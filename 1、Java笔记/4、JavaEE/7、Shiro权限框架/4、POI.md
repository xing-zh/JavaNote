用于在java程序中，解析读取excel文档

# 1、引入依赖

```xml
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi</artifactId>
    <version>3.14</version>
</dependency>
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>3.14</version>
</dependency>
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml-schemas</artifactId>
    <version>3.14</version>
</dependency>
```

# 2、工具类

```java
@Component
public class POIUtil {
	//读取数据
    public List<List<String>> read(String excelPath,int sheetNum){
        //根据文件后缀，创建不同的电子表格对象
        Workbook workbook = null;
        File file = new File(excelPath);
        InputStream input;
        try {
            input = new FileInputStream(file);
            if(excelPath.endsWith("xlsx")){
                //创建 Excel 2007 电子表格对象
                workbook = new XSSFWorkbook(input);
            }else{
                //创建 Excel 2003 工作簿对象
                workbook = new HSSFWorkbook(input);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return parse(workbook,sheetNum);
    }
    private List<List<String>> parse(Workbook workbook,int sheetNum){
        //获取当前的工作簿
        Sheet sheet = workbook.getSheetAt(sheetNum);
        List<List<String>> excelList = new ArrayList<>();
        //遍历表格所有行
        for(int i = 0;i <= sheet.getLastRowNum();i++){
            //获取行对象
            Row row = sheet.getRow(i);
            //如果当前行为空，则开始下一行循环
            if(row == null){
                continue;
            }
            List<String> rowList = new ArrayList<>();
            //遍历行中的所有列
            for(int j = 0;j < row.getLastCellNum();j++){
                //获取列对象
                Cell cell = row.getCell(j);
                String cellStr = "";
                //判断当前列数据类型
                if(cell == null){
                    cellStr = "";
                }else if(cell.getCellType() == Cell.CELL_TYPE_BOOLEAN){
                    //布尔类型
                    cellStr = String.valueOf(cell.getBooleanCellValue());
                }else if(cell.getCellType() == Cell.CELL_TYPE_NUMERIC){
                    //数值类型
                    cellStr = (int)cell.getNumericCellValue() + "";
                }else if(cell.getCellType() == Cell.CELL_TYPE_FORMULA){
                    //公式类型
                    cellStr = cell.getCellFormula();
                }else{
                    //其余按字符串处理
                    cellStr = cell.getStringCellValue();
                }
                rowList.add(cellStr);
            }
            excelList.add(rowList);
        }
        return excelList;
    }
    //x
    public String write(String[] title, String sheetName, List<List<String>> data,String excelPath){
        //创建Excel 2007 电子表格对象
        Workbook wb = new XSSFWorkbook();
        //设置sheet名称，并创建新的sheet对象
        Sheet sheet = wb.createSheet(sheetName);
        //获取表头行
        Row titleRow = sheet.createRow(0);
        //创建单元格，设置style居中，字体，单元格大小等
        CellStyle style = wb.createCellStyle();
        Cell cell = null;
        //把已经写好的标题行写入excel文件中
        for (int i = 0; i < title.length; i++) {
            cell = titleRow.createCell(i);
            cell.setCellValue(title[i]);
            cell.setCellStyle(style);
        }
        //将数据写入excel
        Row row = null;
        for (int i = 0;i < data.size();i++){
            row = sheet.createRow(i + 1);
            List<String> dataList = data.get(i);
            for (int j = 0;j < dataList.size();j++){
                row.createCell(j).setCellValue(dataList.get(j));
            }
        }
        //设置单元格宽度自适应，在此基础上把宽度调至1.5倍
        for (int i = 0; i < title.length; i++) {
            sheet.autoSizeColumn(i, true);
            //注意单个单元格的最大列宽是255个字符
            //sheet.setColumnWidth(i, sheet.getColumnWidth(i) * 15 / 10);
        }

        //创建上传文件目录
        File folder = new File(excelPath);

        //如果文件夹不存在创建对应的文件夹
        if (!folder.exists()) {
            folder.mkdirs();
        }
        //设置文件名
        Date date = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddhhmmss");
        String format = dateFormat.format(date);
        String fileName = format + sheetName + ".xlsx";
        String savePath = folder + File.separator + fileName;
        // System.out.println(savePath);
        try {
            OutputStream fileOut = new FileOutputStream(savePath);
            wb.write(fileOut);
            fileOut.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        //返回文件保存全路径
        return savePath;
    }  
}
```



 