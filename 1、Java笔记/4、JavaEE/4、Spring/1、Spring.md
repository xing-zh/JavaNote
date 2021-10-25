# Spring概述



- spring框架是03年由Rod Johnson创建
- 该框架的主要作用：让我们的应用程序满足“高内聚，低耦合”，并始终遵循面向接口编程的思想，来做到松散耦合
- Spring不是一个功能性框架，主要解决的是业务逻辑层和其他各层的耦合问题
- Spring框架核心
  - **IOC（容器）**，把创建、销毁对象的过程交给Spring进行管理
  - **AOP（面向切面编程）**，可以在不修改源代码的情况下，进行功能的增强

# Spring的特点

1. 免费开源，功能不够可以自己去扩展
2. 它使用IOC容器，管理项目中的所有的组件，以及维护组件之间的关系
3. 它为企业应用开发，或者互联网应用开发提供了一套非常完整的解决方案
4. **是一个轻量级的开源的JavaEE的框架**

# Spring的优点

- 方便程序解耦，简化开发 （高内聚低耦合）
  - 它的底层实现采用的是：工厂 + 反射 + 配置文件
- 它可以帮助程序员去创建组件的实例
- 它可以帮助程序员去管理组件之间的依赖关系
- AOP编程的支持
  - Spring提供面向切面编程，可以方便的实现对程序进行权限拦截、运行监控等功能
- 声明式事务的支持
  - 只需要通过配置就可以完成对事务的管理，而无需手动编程
- 方便程序的测试
  - Spring对Junit4支持，可以通过注解方便的测试Spring程序
- 方便集成各种优秀框架
  - Spring不排斥各种优秀的开源框架，其内部提供了对各种优秀框架（如：Struts、Hibernate、MyBatis、Quartz等）的直接支持
- 降低JavaEE API的使用难度
  - Spring 对JavaEE开发中非常难用的一些API（JDBC、JavaMail、远程调用等），都提供了封装，使这些API应用难度大大降低

# Spring体系结构（7大功能模块）

- Spring框架是一个分层架构，由7个定义良好的模块组成
- Spring框架的功能可以用在任何J2EE服务器中，大多数功能也适用于不受管理的环境
- Spring的核心要点是：支持不绑定到特定J2EE服务的可重用业务和数据访问对象。毫无疑问，这样的对象可以在不同J2EE环境 （Web 或 EJB）、独立应用程序、测试环境之间重用
- Spring模块构建在核心容器之上，核心容器定义了创建、配置和管理bean的方式，如图所示：

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181331166.gif)

组成 Spring 框架的每个模块（或组件）都可以单独存在，或者与其他一个或多个模块联合实现。每个模块的功能如下：

## Spring Core

- 核心容器，提供Spring框架的基本功能
- 核心容器的主要组件是BeanFactory，它是工厂模式的实现
- BeanFactory使用控制反转（IOC）模式将应用程序的配置和依赖性规范与实际的应用程序代码分开

## Spring Context

- Spring上下文是一个配置文件，向Spring框架提供上下文信息
- Spring上下文包括企业服务，例如JNDI、EJB、电子邮件、国际化、校验和调度功能

## Spring AOP

- 通过配置管理特性，Spring AOP模块直接将面向切面的编程功能集成到了Spring框架中，所以，可以很容易地使Spring框架管理的任何对象支持AOP
- Spring AOP模块为基于Spring的应用程序中的对象提供了事务管理服务。通过使用Spring AOP，不用依赖EJB组件，就可以将声明性事务管理集成到应用程序中

## Spring DAO

- JDBC DAO抽象层提供了有意义的异常层次结构，可用该结构来管理异常处理和不同数据库供应商抛出的错误消息
- 异常层次结构简化了错误处理，并且极大地降低了需要编写的异常代码数量（例如打开和关闭连接）
- Spring DAO的面向JDBC的异常遵从通用的DAO异常层次结构

## Spring ORM

- Spring框架插入了若干个ORM框架，从而提供了ORM的对象关系工具，其中包括JDO、Hibernate和iBatis SQL Map
- 所有这些都遵从Spring的通用事务和DAO异常层次结构

## Spring Web模块

- Web上下文模块建立在应用程序上下文模块之上，为基于Web的应用程序提供了上下文，所以，Spring框架支持与Jakarta、Struts的集成
- Web模块还简化了处理多部分请求以及将请求参数绑定到域对象的工作

## Spring Web MVC框架

- MVC框架是一个全功能的构建Web应用程序的MVC实现
- 通过策略接口，MVC框架高度可配置
- MVC容纳了大量视图技术，其中包括JSP、Velocity、Tiles、iText和POI

# Spring常用接口

## BeanFactory和ApplicationContext接口的联系

- ==BeanFactory接口==
  - 一般我们我们不会进行使用，是Spring里面一个内部使用的接口
- ==ApplicationContext接口==
  - **ApplicationContext接口继承了BeanFactory接口**，它们两个的实现类都可以成为Spring容器
  - Spring容器实际上就是一个超大型的工厂，它的底层：工厂 + 反射
  - BeanFactory提供了容器的所有功能，那怎么又有一个ApplicationContext，原因是：
    - ==BeanFactory在产生实例的时候，只会在调用getBean()方式时，才产生实例==
    - **ApplicationContext在创建容器实例时，就开始初始化创建所有的组件的实例**
  - **我们一般用的更多的是ApplicationContext来作为容器**
  - ApplicationContext除了实现了BeanFactory的所有功能之外，还扩展了很多其他功能：支持i18n（国际化）支持任务调度，支持邮件服务，支持WebSocket……

## ApplicationContext接口实现类

- 实现类有：
  - ClassPathXmlApplicationContext
  - FileSystemXmlApplicationContext
  - AnnotationConfigApplicationContext
  - ……
- 区别：
  - ClassPathXmlApplicationContext使用**相对路径**加载applicationContext.xml配置文件
  - FileSystemXmlApplicationContext使用**绝对路径**加载applicationContext.xml配置文件
  - AnnotationConfigApplicationContext提供注解支持
  - 但是他们在管理组件，和维护组件的方式上，都是一样的，没有什么区别
- 在代码中如何启动容器

```java
ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
```

# 开发步骤（使用Spring、Maven框架）

1、创建一个maven项目

2、导入spring依赖，在pom.xml文件中

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.2.9.RELEASE</version>
</dependency>
```

3、定义需要的JavaBean

4、针对业务，定义三层的各层接口，并编写接口中的方法

5、针对接口进行编写实现类，并完成面向接口编程

6、**编写applicationContext.xml配置文件**，在配置文件中，使用标记来**申明需要被容器管理的组件**

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
      http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- id是组件在容器中唯一标识，class是组件在容器的类的全类名 -->
    <bean id="userBean" class="org.example.bean.UserBean"></bean>
</beans>
```

7、测试（junit）

```java
@Test
public void test1(){
    //加载配置文件
    ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
    //获取Bean对象
    UserBean userBean = context.getBean("userBean", UserBean.class);
    System.out.println(userBean);
}
```



