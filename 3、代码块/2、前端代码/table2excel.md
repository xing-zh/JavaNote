# 1、项目导入依赖

下载地址：https://codechina.csdn.net/mirrors/rainabba/jquery-table2excel

jquery.table2excel.min.js

## 2、下载事件，可以绑定给按钮，或是其他

```js
$("button").click(function(){
    //table的id
    $("#infoTable").table2excel({
        exclude: ".noExl",//table里面，名为.noExl的class不包含生成excel范围内
        name: "Excel Document Name",
        filename: "fileName",//生成的excel文件名称
        exclude_img: true,//把img标签过滤掉
        exclude_links: true,//把link标签过滤掉
        exclude_inputs: true//把input标签过滤掉
    });
})
```

