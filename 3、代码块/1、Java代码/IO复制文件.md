```java
//使用IO流实现文件复制
public static void copy(String by,String to) throws IOException {
    File fileby = new File(by);
    File fileto = new File(to);
    BufferedInputStream bufferedInputStream = new BufferedInputStream(new FileInputStream(fileby));
    BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(fileto));
    byte[] bytes = new byte[1024];
    int i;
    while ((i = bufferedInputStream.read(bytes)) != -1){
        bufferedOutputStream.write(bytes,0,i);
    }
    bufferedInputStream.close();
    bufferedOutputStream.flush();
    bufferedOutputStream.close();
}
```

