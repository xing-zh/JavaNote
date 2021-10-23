# 新特性概述

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181159299.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181159986.gif)

# Lambda表达式

Lambda表达式专门用来替代，==接口只有一个方法的匿名内部类==，产生实例时的一种方式，它提倡的是函数式编程方式

## 语法

* **->** : **lambda****操作符 或 箭头操作符 （goes to）
* **->**左边：lambda形参列表 （其实就是接口中的抽象方法的形参列表）
* **->**右边：lambda体 （其实就是重写的抽象方法的方法体）
* **Driveable driveable = () -> {};**
* 语法口诀：拷贝小括号（接口中的小括号），写死右箭头，落地大括号（大括号中写自己的实现）

## 简化写法

* ->左边：lambda形参列表的参数类型可以省略(类型推断)；如果lambda形参列表只一个参数，其一对()也可以省略

* ->右边：lambda体应该使用一对{}包裹；如果lambda体只一条执行语句（可能是return语句，省略这一对{}和return关键字）

  ```java
  //jdk8之前
  Runnable r = new Runnable(){
      @Override
      public void run(){
          System.out.println();
      }
  }
  //jdk8,括号中，可以写入形参
  Runnable r = () -> {
      System.out.println();
  }
  ```

## 六种使用情况

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200554.gif)

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200602.gif)

# 函数式接口

\> 如果一个接口中，只声明了一个抽象方法，则此接口就称为函数式接口。

\> 我们可以在一个接口上使用 **@FunctionalInterface** 注解（可以不写），这样做可以检查它是否是一个函数式接口。

\> Lambda表达式的本质：作为函数式接口的实例

## Java8中关于Lambda表达式提供的4个基本的函数式接口

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200632.gif)

# 方法引用

## 要求

实现接口的抽象方法的参数列表和返回值类型，必须与方法引用的方法的参数列表和返回值类型保持一致！

## 格式

使用操作符 **“::”** 将类(或对象) 与 方法名分隔开来

## 三种使用情况

**对象::实例方法名** 

**类::静态方法名** 

**类::实例方法名**

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200193.gif)

当函数式接口方法的第一个参数是需要引用方法的调用者，并且第二个参数是需要引用方法的参数(或无参数)时：`ClassName::methodName`

# 构造器引用

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181204300.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200417.gif)

# 数组引用

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181204999.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200665.gif)

# StreamAPI

Stream关注的是对数据的运算，与CPU打交道

集合关注的是数据的存储，与内存打交道

java8提供了一套api,使用这套api可以对内存中的数据进行过滤、排序、映射、归约等操作。类似于sql对数据库中表的相关操作。

## 注意

①Stream 自己不会存储元素。

②Stream 不会改变源对象。相反，他们会返回一个持有结果的新Stream。 

③Stream 操作是延迟执行的。这意味着他们会等到需要结果的时候才执行。

## 使用步骤

**1- 创建 Stream**：一个数据源（如：集合、数组），获取一个流

**2- 中间操作**：一个中间操作链，对数据源的数据进行处理

**3- 终止操作(终端操作)** ：一旦执行终止操作，就执行中间操作链，并产生结果。之后，不会再被使用

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200696.gif)

## 创建Stream实例的方式

### 通过集合

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200503.gif)

```java
public void test1(){
    List<Student> list = new ArrayList<>();
    list.add(new Student(1,"张三",12,2));
    list.add(new Student(2,"李四",18,2));
    list.add(new Student(3,"王五",25,2));
    list.add(new Student(4,"赵六",30,2));
    list.add(new Student(5,"孙七",15,2));
    //获取顺序流
    Stream<Student> stream = list.stream();
    //获取并行流
    Stream<Student> studentStream = list.parallelStream();
}
```

### 通过数组

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200882.gif)

```java
@Test
public void test2(){
    int[] a = new int[]{5,28,36,-99,85};
    IntStream stream = Arrays.stream(a);
}
```

### 通过Stream的of()

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200011.gif)

```java
@Test
public void test3(){
    Stream<Integer> integerStream = Stream.of(1, 2, 3, 4, 5);
}
```

### 创建无限流

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200835.gif)

```java
@Test
public void test4(){
    //迭代,遍历前十个偶数
    Stream.iterate(0,t -> t + 2).limit(10).forEach(System.out :: println);
    //生成,生成十个随机数
    Stream.generate(Math :: random).limit(10).forEach(System.out :: println);
}
```

## Stream的中间操作

### 筛选与切片

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181200240.gif)

### 映射

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181201338.gif)

### 排序

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181201928.gif)

## Stream的终止操作

### 匹配与查找

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181201776.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181201968.gif)

### 归约

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181201736.gif)

### 收集

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181201265.gif)

# Optional 类

Optional 类(java.util.Optional) 是一个容器类，它可以保存类型T的值，代表这个值存在。或者仅仅保存null，表示这个值不存在。原来用 null 表示一个值不存在，现在 Optional 可以更好的表达这个概念。并且可以避免空指针异常。

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181201073.gif)

 