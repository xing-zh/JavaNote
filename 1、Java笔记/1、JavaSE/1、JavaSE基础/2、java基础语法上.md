# 关键字与保留字

## 关键字

定义：被Java语言赋予了特殊含义，用做专门用途的字符串（单词）

特点：关键字中所有字母都为小写

官方地址：https://docs.oracle.com/javase/tutorial/java/nutsandbolts/_keywords.html

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181113835.jpg)

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181113064.jpg)

## 保留字

Java保留字：现有Java版本尚未使用，但以后版本可能会作为关键字使用。自己命名标识符时要避免使用这些保留字。

goto 、const

# 标识符(Identifier)

Java 对各种变量、方法和类等要素命名时使用的字符序列称为标识符。

**凡是自己可以起名字的地方都叫标识符。**

## 定义合法标识符规则：

1. 由26个英文字母大小写，0-9 ，_或 $ 组成

2. 数字不可以开头。

3. 不可以使用关键字和保留字，但能包含关键字和保留字。

4. Java中严格区分大小写，长度无限制。

5. 标识符不能包含空格。

## Java中的名称命名规范

**包名**：多单词组成时所有字母都小写：xxxyyyzzz

**类名、接口名**：多单词组成时，所有单词的首字母大写：XxxYyyZzz

**变量名、方法名**：多单词组成时，第一个单词首字母小写，第二个单词开始每个单词首字母大写：xxxYyyZzz

**常量名**：所有字母都大写。多单词时每个单词用下划线连接：XXX_YYY_ZZZ

**注意1：在起名字时，为了提高阅读性，要尽量有意义，“见名知意”。**

**注意2：java采用unicode字符集，因此标识符也可以使用汉字声明，但是不建议使用。**

# 变量

## 变量的概念：

内存中的一个存储区域

该区域的数据可以在同一类型范围内不断变化

变量是程序中最基本的存储单元。包含**变量类型、变量名和存储的值 。**

## 变量的作用：

用于在内存中保存数据

## 使用变量注意：

1. **Java中每个变量必须先声明，后使用**

2. 使用变量名来访问这块区域的数据

3. 变量的作用域：其定义所在的一对{ }内

4. 变量只有在其作用域内才有效

5. 同一个作用域内，不能定义重名的变量

### 声明变量

语法：<数据类型> <变量名称>

例如：int var;

### 变量的赋值

语法：<变量名称> = <值>

例如：var = 10;

### 声明和赋值变量

语法： <数据类型> <变量名> = <初始化值>

例如：int var = 10;

```java
class VariableTest { 
  public static void main(String[] args){ 
    //变量的定义
    int myAge=12;
    //变量的使用
    System.out.println(myAge);
    //变量的声明intmyNumber;
    //变量的赋值
    myNumber=1997; 
    //变量的使用
    System.out.println(myNumber);
  } 
} 
输出
12
1997
```

## 变量的分类-按数据类型

对于每一种数据都定义了明确的具体数据类型（强类型语言），在内存中分配了不同大小的内存空间。

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181113056.jpg)

> 引用类型：是指除了基本的变量类型之外的所有类型（如通过 class 定义的类型）。
>
> [深入理解Java引用类型 - （牛_牛）.NET - 博客园 (cnblogs.com)](https://www.cnblogs.com/SilentCode/p/4858790.html)

### 整数类型：byte、short、int、long

Java各整数类型有固定的表数范围和字段长度，不受具体OS的影响，以保 证java程序的可移植性。

java的整型常量默认为 int 型，声明long型常量须后加‘l’或‘L’

java程序中变量通常声明为int型，除非不足以表示较大的数，才使用long

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114649.jpg)

```java
class VariableTest1{ 
  public static void main(String[] args){ 
    byte b1=24; 
    byte b2=-128; 
    //b2=128;   编译不通过，byte类型-128~127	
    System.out.println(b1); 
    System.out.println(b2); 
    short s1=128; 
    int s2=1234; 
    long s3=12345678L;
    System.out.println(s1); 
    System.out.println(s2);
    //声明：long型变量，必须以“l”或“L”结尾
    System.out.println(s3);     
  } 
} 
输出
24
-128
128
1234
12345678
```

### 浮点类型：float、double

与整数类型类似，Java 浮点类型也有固定的表数范围和字段长度，不受具体操作系统的影响。

浮点型常量有两种表示形式：

十进制数形式：如：5.12 512.0f .512 (必须有小数点）

科学计数法形式:如：5.12e2 512E2 100E-2 

float:单精度，尾数可以精确到7位有效数字。很多情况下，精度很难满足需求。

double:双精度，精度是float的两倍。通常采用此类型。

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114146.jpg)

```java
class VariableTest1{
  public static void main(String[] args){
    double s1=123.3;
    System.out.println(s1);
    //定义float类型值的末尾要以‘f’或‘F’结尾
    float s2=12.3F; 
    System.out.println(s2);     
  } 
}
输出
123.3
12.3
```

### 字符类型：char

char 型数据用来表示通常意义上“字符”(2字节)

Java中的所有字符都使用Unicode编码，故一个字符可以存储一个字母，一个汉字，或其他书面语的一个字符。

字符型变量的三种表现形式：

1. 字符常量是用单引号`‘ ’`括起来的单个字符。例如：char c1 = 'a'; char c2= '中'; char c3 = '9';

2. Java中还允许使用转义字符`\`来将其后的字符转变为特殊字符型常量。例如：char c3 = ‘\n’; `\n`表示换行符。

3. 直接使用 Unicode 值来表示字符型常量：‘\uXXXX’。其中，XXXX代表一个十六进制整数。如：\u000a 表示\n。 

**char类型是可以进行运算的。因为它都对应有Unicode码。**

```java
class VariableTest1{ 
  public static void main(String[] args){
    char c1='a'; 
    System.out.println(c1); 
    char c2='中';
    System.out.println(c2);    
  }
} 
输出:
a
中
```

### 转义字符

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114059.jpg)

### 布尔类型：boolean

**boolean类型数据只允许取值true和false，无null。**

boolean 类型用来判断逻辑条件，一般用于程序流程控制：

if条件控制语句；

while循环控制语句；

do-while循环控制语句；

for循环控制语句；

 

## 变量的分类-按声明的位置的不同

在方法体外，类体内声明的变量称为成员变量。

在方法体内部声明的变量称为局部变量。

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114811.jpg)

### 二者在初始化值方面的异同:

同：都有生命周期

异：局部变量除形参外，需显式初始化。

## 基本数据类型转换

前提：**boolean类型不能与其它数据类型运算。**

### 自动类型提升

容量小的类型自动转换为容量大的数据类型。数据类型按容 量大小排序为：（容量的大小表示数的范围的大小）

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114901.jpg)

byte,short,char之间不会相互转换，他们三者在计算时首先转换为int类型。

```java
class VariableTest2{ 
  public static void main(String[] args) { 
    byte b1=2;
    int i1=129;
    //byte i2 = b1 + i1;  解析不通过
    int i2=b1+i1;    //使用容量较大的类型int
    System.out.println(i2);    
  } 
}
输出
131
```

### 强制类型转换

自动类型转换的逆过程，将容量大的数据类型转换为容量小的数据类型。使用时要加上强制转换符：()，但可能造成精度降低或溢出,格外要注意。

```java
class VariableTest2{ 
  public static void main(String[] args) { 
    double d1=12.3;
    int i1= (int)d1;          //使用强转符（），截断操作损失精度		
    System.out.println(i1);   
  } 
} 
输出
12
```

## 字符串类型：String

> [Java常用类（二）String类详解 - LanceToBigData - 博客园 (cnblogs.com)](https://www.cnblogs.com/zhangyinhua/p/7689974.html#_label2)

String不是基本数据类型，属于引用数据类型，声明String变量的是，使用一对双引号" "

String类对象一旦声明则不可以改变；而改变的只是地址，原来的字符串还是存在的，并且产生垃圾。

一个字符串可以串接另一个字符串，也可以直接串接其他类型的数据。例如：

```java
str=str+“xyz";
int n=100; 
str=str+n;
```

### String类型可直接赋值方式创建对象

　　直接赋值方式创建对象是在方法区的**常量池**

```java
String str="hello";//直接赋值的方式
```

### 通过构造方法创建字符串对象

　　通过构造方法创建字符串对象是在**堆内存**

```java
String str=new String("hello");//实例化的方式
```



> ### 两种实例化方式的比较
>
> 　　1）编写代码比较
>
> ```java
> public class TestString {
>     public static void main(String[] args) {
>         String str1 = "Lance";
>         String str2 = new String("Lance");
>         String str3 = str2; //引用传递，str3直接指向st2的堆内存地址
>         String str4 = "Lance";
>         /**
>          *  ==:
>          * 基本数据类型：比较的是基本数据类型的值是否相同
>          * 引用数据类型：比较的是引用数据类型的地址值是否相同
>          * 所以在这里的话：String类对象==比较，比较的是地址，而不是内容
>          */
>          System.out.println(str1==str2);//false
>          System.out.println(str1==str3);//false
>          System.out.println(str3==str2);//true
>          System.out.println(str1==str4);//true
>     }
> 
> }
> ```
>
> 2）内存图分析
>
> 　　　　![img](D:\Typora\Typor_picture\999804-20171023133457441-979023158.png)
>
> 3）总结：两种实例化方式的区别
>
> 　　　　　　1）直接赋值（String str = "hello"）：只开辟一块堆内存空间，并且会自动入池，不会产生垃圾。
>
> 　　　　　　2）构造方法（String str=  new String("hello");）:会开辟两块堆内存空间，其中一块堆内存会变成垃圾被系统回收，而且不能够自动入池，需要通过public  String intern();方法进行手工入池。



以和八种基本数据类型进行运算，且**只能是连接运算，运算结果仍然是String类型。**

```java
class VariableTest2{ 
  public static void main(String[] args){ 
    String numberStr="学号：";
    int number=1997; 
    String info=numberStr + number; 
    System.out.println(numberStr + number);    
  } 
} 
输出
学号：1997
```

### String类型的常用方法

　　![img](D:\Typora\Typor_picture\999804-20171018235737990-1836009057.png)



### String类型索引、长度

```java
String a="12345"; 
//获取字符串的长度
int long=a.length(); 
//索引指定位置的字符
char b=a.charAt(0);
```

### 获取指定索引的数字，并且用来运算

**可以使用字符减去字符0，获得编码的差**

```java
String a="12345"; 
char b=a.charAt(2);
int num=b - '0'; 
输出
3
```

### 比较字符串是否相等

```
boolean equals(Object obj)：比较字符串的内容是否相同
boolean equalsIgnoreCase(String str)： 比较字符串的内容是否相同,忽略大小写
boolean startsWith(String str)： 判断字符串对象是否以指定的str开头
boolean endsWith(String str)： 判断字符串对象是否以指定的str结尾
```

```java
String a="yes"; 
String b="no";
boolean c=a.equals(b);
System.out.println(c); 
输出
false
```

> **== 和public boolean equals()比较字符串的区别**
>
> 　　　　　　==在对字符串比较的时候，对比的是内存地址，而equals比较的是字符串内容，在开发的过程中，equals()通过接受参数，可以避免空指向。

#  StringBuffer

==可变字符序列==

**StringBuffer**：字符串变量（Synchronized，即线程安全）。如果要频繁对字符串内容进行修改，出于效率考虑最好使用StringBuffer，如果想转成String类型，可以调用StringBuffer的toString()方法，可将字符串缓冲区安全地用于多个线程。

## StringBuffer 上的主要操作是 append 和 insert 方法

append 方法始终将这些字符添加到缓冲区的末端；而 insert 方法则在指定的点添加字符。例如，如果 z 引用一个当前内容是“start”的字符串缓冲区对象，则此方法调用 z.append("le") 会使字符串缓冲区包含“startle”，而 z.insert(4, "le") 将更改字符串缓冲区，使之包含“starlet”。

# StringBuilder

**StringBuilder**：字符串变量（非线程安全）。在内部，StringBuilder对象被当作是一个包含字符序列的变长数组。该类被设计用作 StringBuffer 的一个简易替换，用在字符串缓冲区被单个线程使用的时候（这种情况很普遍）。

> **三者区别:**
> String 类型和StringBuffer的主要性能区别：String是==不可变的字符序列==, 因此在每次对String 类型进行改变的时候，都会生成一个新的 String 对象，然后将指针指向新的 String 对象，所以经常改变内容的字符串最好不要用 String ，因为每次生成对象都会对系统性能产生影响，特别当内存中无引用对象多了以后， JVM 的 GC 就会开始工作，性能就会降低。
>
> **使用策略：**
> （1）基本原则：如果要操作少量的数据，用String ；单线程操作大量数据，用StringBuilder ；多线程操作大量数据，用StringBuffer。
>
> （2）不要使用String类的"+"来进行频繁的拼接，因为那样的性能极差的，应该使用StringBuffer或StringBuilder类，这在Java的优化上是一条比较重要的原则。

# 进制

所有数字在计算机底层都以二进制形式存在。

**二进制(binary)**：0,1 ，满2进1.以0b或0B开头。

**十进制(decimal)**：0-9 ，满10进1。

**八进制(octal)**：0-7 ，满8进1. 以数字0开头表示。

**十六进制(hex)**：0-9及A-F，满16进1. 以0x或0X开头表示。此处的A-F不区分大小写。      如：0x21AF +1= 0X21B0

二进制转换十进制，以及负数的原码、反码、补码

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114923.jpg)

**计算机底层都以补码的方式存储数据！**

# 运算符

运算符是一种特殊的符号，用以表示数据的运算、赋值和比较等。

## 算术运算符

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114898.jpg)

## 赋值运算符

符号：=

当“=”两侧数据类型不一致时，可以使用自动类型转换或使用强制类型转换原则进行处理。

支持连续赋值。

## 比较运算符

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114994.jpg)

## 逻辑运算符

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114123.jpg)

变量的类型全部都是boolean类型的

### 区分&和&&：

相同点：

1、&和&&运算的结果相同

2、当符号左边是true时，都会运行符号右边的运算

不同点：

当符号左边是false时，&符号右边的运算继续执行，&&右边的运算不再执行。

### 区别 |和||：

相同点：

1、|和||运算的结果相同

2、当符号左边是false时，都会执行符号右边的运算

不同点：

当符号左边是true时，|符号右边的运算继续执行，||右边的运算不再执行。

## 位运算符

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114900.jpg)

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114050.jpg)

结论：

1、位运算符操作的都是整形数据

1、<<每向左移一位，相当于*2

2、>>每向右移一位，相当于/2

面试题：

1、最高效的计算2*8？ 答：2 << 3或8 << 1

2、int num1 = 10;

int num2 = 20; // 交换两个变量的值。

```java
class AriTest { 
  public static void main(String[] args) {
    int num1 = 10;
    int num2 = 20; 
    int temp = num1;
    num1 = num2;
    num2 = temp; 
    System.out.println("num1 = " + num1 + ",num2 = " + num2);   
  } 
} 
输出
num1 = 20，num2 = 10
```

**或者使用位运算符^，k = m^n,m= k^n = (m^n)^n**

```java
class AriTest {
  public static void main(String[] args) {
    int num1 = 10;
    int num2 = 20; 
    inttemp = num1 ^ num2; 
    num2 = temp ^ num2; 
    num1 = temp ^ num1;
    System.out.println("num1 = " + num1 + ",num2 = " + num2);     
  }
} 
输出
num1 = 20，num2 = 10
```

## 三元运算符

### 格式:

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114617.jpg)

说明：

1、条件表达式的结果为boolean类型

2、根据条件表达式的结果为ture或false，决定执行表达式1，还是表达式2

如果结果为true，则执行表达式1

如果结果为false，则执行表达式2

3、表达式1和表达式2类型要求是一致的

4、三元运算符可以嵌套使用

5、凡是可以使用三元运算符的地方，都可以改写为if...else...

## 运算符的优先级

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181114347.jpg)

**！   >   &   >   |   >   &&   >   ||**

