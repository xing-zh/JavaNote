# File类

1. File类的一个对象，代表一个文件或一个文件目录(俗称：文件夹)

2. File类声明在java.io包下

3. **File**类中涉及到关于文件或文件目录的创建、删除、重命名、修改时间、文件大小等方法**，并未涉及到写入或读取文件内容的操作。**如果需要读取或写入文件内容，必须使用IO流来完成。

4. 后续File类的对象常会作为参数传递到流的构造器中，指明读取或写入的"终点".

## File的实例化

### 构造器：

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181150459.gif)

### 路径分隔符：

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181150577.jpg)

## File类的常用方法

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181150337.gif)

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181150595.jpg)

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181151054.jpg)

# IO流（stream）

**I**：input ; **O** : output

## 流的分类

1. **操作数据单位**：字节流(8bit)、字符流 (16bit)

2. **数据的流向**：输入流、输出流

3. **流的角色**：节点流、处理流

## IO 流体系

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181151463.jpg)

# 节点流：

如：InputStream、Reader、OutputStream、Writer

节点流与具体节点相连接，直接读写节点数据

* 字节流操作字节，比如：`.mp3，.avi，.rmvb，mp4，.jpg，.doc，.ppt`
* 字符流操作字符，只能操作普通文本文件。最常见的文本文件：`.txt，.java，.c，.cpp` 等语言的源代码。尤其注意`.doc,excel,ppt`这些不是文本文件。

## 输入流InputStream & Reader

**InputStream（字节流）** 和 **Reader** **（字符流）**是所有输入流的基类。

程序中打开的文件 IO 资源不属于内存里的资源，垃圾回收机制无法回收该资源，所以应该==**显式关闭文件 IO 资源（使用close方法）**。==

FileInputStream 从文件系统中的某个文件中获得输入字节。FileInputStream 用于读取非文本数据之类的原始字节流。**要读取字符流，需要使用 FileReader**

### 常用方法：

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181151881.jpg)

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181151992.jpg)

## 输出流OutputStream & Writer

**OutputStream（字节流）**和**Writer（字符流）**是所有输出流的基类。

* 在写入一个文件时，如果使用构造器`FileOutputStream(file)`，则**目录下有同名文件将被覆盖。**

* 如果使用构造器`FileOutputStream(file,true)`，则**目录下的同名文件不会被覆盖， 在文件内容末尾追加内容。**

因为字符流直接以字符作为操作单位，所以 Writer 可以用字符串来替换字符数组， 即以 String 对象作为参数

==**显示关闭IO资源，需要使用flush和close方法**==

FileOutputStream 从文件系统中的某个文件中获得输出字节。FileOutputStream 用于写出非文本数据之类的原始字节流。**要写出字符流，需要使用 FileWriter**

### 常用方法：

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181151713.jpg)

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181151711.jpg)

## 文件的复制

```java
public static void copy(String copyBy,String copyTo) throws IOException {
        //输入流
        InputStream inputStream = new FileInputStream(new File(copyBy));
        //输出流
        OutputStream outputStream = new FileOutputStream(new File(copyTo));
        //创建缓冲数组
        byte[] bytes = new byte[1024];
        int i;
        //循环写入缓冲，然后从缓冲数组中输出到目标文件
        while ((i = inputStream.read(bytes)) != -1){
            outputStream.write(bytes,0,i);
        }
        //释放资源
        outputStream.flush();
        inputStream.close();
        outputStream.flush();
 }
```

# 处理流：

## 缓冲流：

**BufferedInputStream 、BufferedOutputStream、BufferedReader、BufferedWriter**

优点：提供流的读取、写入的速度

提高读写速度的原因：内部提供了一个缓冲区。默认情况下是8kb

## 转换流：

* **InputStreamReader**：将一个字节的输入流转换为字符的输入流
  * 解码：字节、字节数组 --->字符数组、字符串
* **OutputStreamWriter**：将一个字符的输出流转换为字节的输出流
  * 编码：字符数组、字符串 ---> 字节、字节数组
* 说明：编码决定了解码的方式

### 常见的编码表

* **ASCII**：美国标准信息交换码。
  * 用一个字节的7位可以表示。
* **ISO8859-1**：拉丁码表。欧洲码表
  * 用一个字节的8位表示。
* **GB2312**：中国的中文编码表。最多两个字节编码所有字符
* **GBK**：中国的中文编码表升级，融合了更多的中文文字符号。最多两个字节编码
* **Unicode**：国际标准码，融合了目前人类使用的所字符。为每个字符分配唯一的字符码。所有的文字都用两个字节来表示。
* **UTF-8**：变长的编码方式，可用1-4个字节来表示一个字符。

客户端/浏览器端  <----> 后台(java,GO,Python,Node.js,php)  <----> 数据库

要求前前后后使用的字符集都要统一：**UTF-8**.

## 对象流：

**ObjectInputStream、OjbectOutputSteam**

用于存储和读取**基本数据类型数据或对象**的处理流。它的强大之处就是可以把Java中的对象写入到数据源中，也能把对象从数据源中还原回来。

### 实现序列化的对象所属的类需要满足：

1. 需要实现接口：**Serializable**
2. 当前类提供一个全局常量：serialVersionUID （**读入和写出要保持一致**）
3. 除了当前Person类需要实现Serializable接口之外，还必须保证其内部所属性也必须是可序列化的。（默认情况下，基本数据类型可序列化）

补充：

**ObjectOutputStream**和**ObjectInputStream**不能序列化**static**和**transient**修饰的成员变量

 

 

 