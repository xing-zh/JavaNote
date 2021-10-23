# java基础知识图解

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181111062.jpg)

# 软件开发

## 软件开发

软件，即一系列按照特定顺序组织的计算机数据和指令的集合。有系统软件和应用软件之分。

## 人机交互方式

**图形化界面(Graphical User Interface GUI)**：这种方式简单直观，使用者易于接受，容易上手操作。

**命令行方式(Command Line Interface CLI)**：需要有一个控制台，输入特定的指令，让计算机完成一些操作。

**应用程序=算法+数据结构**

# 命令行

## 常用的DOS命令

dir : 列出当前目录下的文件以及文件夹

md : 创建目录

rd : 删除目录

cd : 进入指定目录

cd.. : 退回到上一级目录

cd\: 退回到根目录

del : 删除文件

exit : 退出 dos 命令行

补充：echo javase>1.doc 创建新文件

## 常用快捷键

← →：移动光标

↑ ↓：调阅历史操作命令

Delete和Backspace：删除字符

# java语言

## java版本历史迭代

SUN(Stanford University Network，斯坦福大学网络公司 ) 1995年推出的一门高级编程语言。

1991年 Green项目，开发语言最初命名为Oak (橡树)

1996年，发布**JDK 1.0**，约8.3万个网页应用Java技术来制作

**2004年，发布里程碑式版本：JDK 1.5，为突出此版本的重要性，更名为JDK 5.0**

2009年，Oracle公司收购SUN，交易价格74亿美元

**2014年，发布JDK 8.0，是继JDK 5.0以来变化最大的版本**

## Java技术体系平台

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181112832.jpg)

## Java在各领域的应用

企业级应用：主要指复杂的大企业的软件系统、各种类型的网站。Java的安全机制以及它的跨平台的优势，使它在分布式系统领域开发中有广泛应用。应用领域包括金融、电信、交通、电子商务等。

Android平台应用：Android应用程序使用Java语言编写。Android开发水平的高低很大程度上取决于Java语言核心能力是否扎实。

大数据平台开发：各类框架有Hadoop，spark，storm，flink等，就这类技术生态圈来讲，还有各种中间件如flume，kafka，sqoop等等 ，这些框架以及工具大多数是用Java编写而成，但提供诸如Java，scala，Python，R等各种语言API供编程。

移动领域应用：主要表现在消费和嵌入式领域，是指在各种小型设备上的应用，包括手机、PDA、机顶盒、汽车通信设备等。

# Java语言运行机制及运行过程

## Java语言的特点

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181113232.jpg)

## 跨平台性

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181113394.jpg)

## Java两种核心机制 

Java虚拟机 (Java Virtal Machine)

垃圾收集机制 (Garbage Collection)

### 核心机制—Java虚拟机

JVM是一个虚拟的计算机，具有指令集并使用不同的存储区域。负责执行指 令，管理数据、内存、寄存器。

对于不同的平台，有不同的虚拟机。

只有某平台提供了对应的java虚拟机，java程序才可在此平台运行

Java虚拟机机制屏蔽了底层运行平台的差别，实现了“一次编译，到处运行”

### 核心机制—垃圾回收

不再使用的内存空间应回收—— 垃圾回收。

1、在C/C++等语言中，由程序员负责回收无用内存。

2、Java 语言消除了程序员回收无用内存空间的责任：它提供一种系统级线程跟踪存储空间的分配情况。并在JVM空闲时，检查并释放那些可被释放的存储空间。

垃圾回收在Java程序运行过程中自动进行，程序员无法精确控制和干预。

**Java程序还会出现内存泄漏和内存溢出问题吗？Yes!**

# Java语言的环境搭建

## 什么是JDK，JRE

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181113823.jpg)

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181113298.jpg)

## 下载并安装JDK

官方网址：www.oracle.com

## 配置环境变量

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181113838.jpg)

# 开发HelloWorld

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181113922.jpg)

## 开发HelloWorld

1.将编写的java代码保存在以‘.java’结尾的源文件中

``` java
class HelloChina{ 
    public static void main(String[] args){  
        //args：arguments参数；可以更改    
        System .out.println("Hello,World!");   
        //输出语句System .out.println()先输出后换行  
    } 
}
```

2.通过编译工具javac.exe编译为字节码文件，格式为javac 源文件名.java

3.通过java.exe运行字节码文件，格式为java 字节码文件名

## 注意：

**1、在一个源文件中可以声明多个类（class），但是只能最多有一个类声明为public的。而且，要求声明为public的类的类名必须与源文件名相同。**

**2、程序的入口是main()方法，格式是固定的。**

**3、每一个执行语句都以分号；结束。**

**4、编译以后会生成一个多个字节码文件，字节码文件名与源文件中声明的类名相同。**

# 注释（Comment）

 用于注解说明解释程序的文字就是注释。

```java
/* 
1、java规定了三种注释： 
单行注释 多行注释 文档注释（java特有）
2、 单行注释和多行注释的作用： 
a.对所写的程序进行解释说明，增强可读性。 b.可以调试所写的代码 
3、特点：
单行注释和多行注释的内容不参与编译。（编译后生成的 字节码文件不包含注释信息。）
4、多行注释不可以嵌套使用。 
*/ 
class HelloJava {   
    /*   
    多行注释：   
    如下的main方法是程序的入口！   
    main的格式是固定的！
    */   
    public static void main(String[] args) {      
        //单行注释：如下的语句表示输出到控制台      
        System.out.println("Hello World!"); 
    } 
}
```

## 文档注释

文档注释的作用：

注释内容可以被JDK提供的工具 javadoc 所解析，生成一套以网页文件形 式体现的该程序的说明文档。

使用/**文档注释*/的格式

使用javadoc.exe解析

dos命令行解析方法：

javadoc -d myHello -author -version HelloJava.java 其中的myHello为文件名，HelloJava.java为源文件名

# Java API文档

API （Application Programming Interface,应用程序编程接口）是 Java 提供 的基本编程接口）（类库）。

下载地址：http://www.oracle.com/technetwork/java/javase/downloads/index.html

 