# 程序流程控制

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181115362.jpg)

# 从键盘获取不同类型的变量：

使用Scanner类，具体实现步骤：

1、导包：**import java.util.Scanner;**

2、Scanner的实例化：**Scanner scan = new Scanner(System.in);**

3、调用Scanner类的相关方法，来获取指定类型的变量

注意：需要根据相应的方法输入指定类型的值，如果输入的数据类型与要求的数据类型不匹配时，会有异常：==**InputMisMatchException**==。

## 使用Scanner类获取int类型的变量：

```java
import java.util.Scanner; 
class ScannerTest{ 
  public static void main(String[] args) { 
    Scanner scan = new Scanner(System.in);
    int num = scan.nextInt(); 
    System.out.println(num);    
  } 
}
```

# 随机数的生成

```double value = Math.random();```

生成的随机数double类型value的范围是：（0.0，1.0）

```公式：求【a，b】-->(int)(Math.random()*(b - a + 1) + a)```

# 顺序结构

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181115169.jpg)

# 分支结构

## 分支语句1： if-else结构

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181115004.jpg)

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181115086.jpg)

### if-else使用说明

1、条件表达式必须是布尔表达式（关系表达式或逻辑表达式）、布尔变量

2、语句块只有一条执行语句时，一对{}可以省略，但建议保留

3、if-else语句结构，根据需要可以嵌套使用

4、当if-else结构是“多选一”时，最后的else是可选的，根据需要可以省略

5、当多个条件是“互斥”关系时，条件判断语句及执行语句间顺序无所谓

当多个条件是“包含”关系时，“小上大下 / 子上父下”

## 分支语句2： switch-case结构

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181115893.jpg)

### 说明

1、根据switch中表达式中的值，依次匹配各个case的常量，一旦匹配成功，则进入相应的case结构中，调用其执行语句，当调用完执行语句完以后，则仍然继续向下执行其他case语句中的执行语句，直到遇到break关键字或者switch-case结构末尾结束为止。

2、break，可以使用在switch-case结构中，表示一旦执行到此关键字，就跳出switch-case结构。

3、switch-case结构中的表达式，只能是如下的**六种数据类型**之一：**byte、short、char、int、枚举类型（JDK5.0新增）、String类型（JDK7.0新增）。**

4、case之后只能声明常量，不可以声明范围。

5、break关键字在switch结构中是可选的。

6、default类似与if-else中的else

default结构是可选的。

7、如果switch中的多个case的执行语句相同，那么可以考虑合并。

### switch-case和if-else的选择：

1、凡是可以使用switch-case的结构，都可以使用if-else

2、当既可以使用switch（表达式取值情况不多时）又可以使用if时，优先选择switch。

# 循环结构

在某些条件满足的情况下，反复执行特定代码的功能

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181115157.jpg)

## for循环

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181115136.jpg)

 

## while循环

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181115277.jpg)

初始化部分出了while循环以后仍可以调用

## do-while循环

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181115269.jpg)

说明：

1、运行的时候会先执行一次循环体部分和迭代部分。

## 无限循环格式

### for循环

```for ( ; ; ){ }```

### while循环

```while(true){ }```

### do-while循环

```do{ }while(true);```

### 结束循环的两种方式

1、循环条件部分返回false

2、在循环体中，执行break

## 嵌套循环(多重循环)

将一个循环放在另一个循环体内，就形成了嵌套循环。

设外层循环次数为m次，内层为n次，则内层循环体实际上需要执行m*n次。

外层循环控制行数，内层循环控制列数

### 优化：计算程序运行时间

**衡量功能代码的优劣：**

1、保证代码的功能正确性；

2、代码的可读性；

3、健壮性；

4、高效率与低存储（算法的好坏）：时间复杂度、空间复杂度

```java
//获取当前开始时间距离1970-01-01 00:00:00的毫秒数
long start = System.currentTimeMillis();
....
//获取当前结束时间距离1970-01-01 00:00:00的毫秒数
long end= System.currentTimeMillis();
//时间差计算程序运行时间
System.out.println("所花费的时间：" + (end - start));
```

## 关键字break、continue

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181116147.jpg)

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181116976.jpg)

**continue和break的后面不可以声明执行语句。** 