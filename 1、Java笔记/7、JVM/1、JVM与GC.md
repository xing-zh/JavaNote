# jVM的空间

JVM有一个称为垃圾回收器的低级线程，这个线程在后台不断地运行，自动寻找在Java程序中不再被使用的对象，并释放这些对象的内存。这种内存回收的过程被称为垃圾回收（Garbage Collection）

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181405599.jpeg)

- 堆的内存分配： 堆是按照代为单位进行分配，具体分配为：新生代，老年代，持久代（元空间）
- 所以现在的堆：新生代，老年代

## 空间比例

新生代中空间比例：`Eden:form:to = 8:1:1`

新生代和老年代的比例：`young:old = 1:2`

# 垃圾回收的目的

- 为了清理内存空间，给新生的对象腾位置
- 防止内存溢出和内存泄露

# 垃圾回收的算法

- 标记-清除算法：标记对象的引用次数，当次数 >0 表示对象正在被使用，当 ==0 时，表示对象可以被清理，但效率不高，一般会留下内存碎片
- 标记-整理算法：标记无用对象，让所有存活的对象都向一端移动，然后直接清除掉端边界以外的内存
- 复制算法：就是将对象在转移时，copy复制一份，同样要记录复制次数
- 分代算法：根据对象存活周期的不同将内存划分为几块，一般是新生代和老年代，新生代基本采用复制算法，老年代采用标记整理算法

# GC相关API

## 回收方式finalize()

- Object类的方法protected
- GC在回收对象之前调用该方法
- 调用对象身上的finalize()方法，进行销毁对象

## final、finally、finalize()的区别

- final：关键字，用来修饰类、方法和变量。修饰类，该类不可继承；修饰方法，该方法不可被重写；修饰变量或属性：该变量或属性值不可修改
- finally：使用在异常处理机制中，生命在finally中的代码一定会被执行，即使catch()中又出现了异常、try()和catch()中有return语句

- finalize()：用于垃圾回收中，可以调用对象的finalize()方法，销毁对象

## System.gc()，Runtime.gc()

- System.gc()底层调用的还是Runtime.gc()
- 程序员可以通过System.gc()或者Runtime.gc()，通知JVM开始回收垃圾。这也是程序员唯一可以参与垃圾回收的地方，一般调用完之后，再调用System.runFinalization方法，因为个方法都是建议GC回收
- 注意：System.gc()或者Runtime.gc()并不一定，就可以让JVM进行GC回收，原因是JVM回收有它自己的条件，即Eden满，或老年代满‘

# 内存泄漏和内存溢出

## 内存溢出 out of memory

是指程序在申请内存时，没有足够的内存空间供其使用，出现out of memory

## 内存泄露 memory leak

是指程序在申请内存后，无法释放已申请的内存空间，一次内存泄露危害可以忽略，但内存泄露堆积后果很严重，无论多少内存,迟早会被占光

另外，内存泄漏memory leak最终会导致内存溢出out of memory

# 内存泄漏

1、长生命周期对象持有短生命周期对象，例如：

```java
public class Demo{
    private Object object;
    public void setObject(){
        object = new Object();
    }
}
/* 此时执行了setObject方法后
 * 如果Demo的实例没有被回收，那么object对象会一直存在与内存中
 */
```

2、集合中的内存泄露，我们有的时候会声明静态的集合对象，而集合中的每个元素指向一个对象，集合不会被回收，导致里面元素指向的对象也不会被回收

3、连接中的内存泄漏，对于这些连接对象（数据库链接、网络连接、IO连接），除非我们显示的调用了close方法，否则这个对象不会被GC回收

# `System.gc`和`System.runFinalization`区别

- `System.gc();`
  - 告诉垃圾收集器打算进行垃圾收集，而垃圾收集器进不进行收集是不确定的
- `System.runFinalization();`
  - 强制调用已经失去引用的对象的finalize方法 强制垃圾收集

# Java代码的优化

## 1、几种for循环的区别

```java
//这种for循环，会在每一轮循环之前重新计算list的size
for(int i=0;i<list.size();i++)
//这种for循环，只在第一次循环前计算长度，性能较高
for(int i=0,len=list.size();i<len;i++)
```

## 2、String字符串的相加

简单的字符串相加，结果每次都会创建一个新的对象，对于频繁进行相加操作的字符串，不建议使用String，而是使用StringBuffer或StringBuider

## 3、尽可能使用局部变量

非必要情况，不要使用全局变量或实例变量，局部变量随着方法的结束，就会准备进行回收

## 4、及时关闭流、连接

## 5、尽量使用懒加载策略，使用的时候再创建

## 6、慎用异常，因为异常的抛出之前，也需要创建对象

# jvisualvm的使用

## 一、启动jvisualvm

1.1、找到jdk安装目录中的`jvisualvm.exe`，并启动

![image-20210919211916704](https://gitee.com/yh-gh/img-bed/raw/master/202109192119831.png)

## 二、安装Visual GC插件

### 2.1、打开面板上的工具-插件

![image-20210919212333914](https://gitee.com/yh-gh/img-bed/raw/master/202109192123002.png)

### 2.2、安装Visual GC插件

### 2.3、如果安装失败，可以手动安装

进入插件中心，在右边选择自己的jdk版本：https://visualvm.github.io/pluginscenters.html

点击进去，下载插件

选择自己下载的插件，进行安装

![image-20210919212951603](https://gitee.com/yh-gh/img-bed/raw/master/202109192129697.png)

## 三、查看GC

![image-20210919213129339](https://gitee.com/yh-gh/img-bed/raw/master/202109192131434.png)

# JVM中GC的执行过程

1、新创建的对象，会优先放入新生代的Eden区

2、GC执行，会将所有Eden区的存活对象，复制到From区，清空Eden区

3、GC再次执行，回收完无用对象后，会将From区的对象全部复制到To区，清空From区

4、GC再次执行，回收完无用对象后，会将To区的对象全部复制到From区，清空To区，3、4步的作用是为了减少内存空间碎片，也就是防止内存不连续，导致内存溢出

5、GC反复执行3、4步，如果对象执行3、4超过15次或To区满了，会将所有对象移入老年代，S区（From和To）

