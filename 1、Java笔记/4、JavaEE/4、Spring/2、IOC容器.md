# IOC概述

IOC（Inversion of Control**控制反转**），是面向对象编程中的一种设计原则，可以用来**降低代码中的耦合度**，IOC思想基于IOC容器完成，底层就是对象工厂

## 控制反转

把对象的创建以及对象之间的调用过程，都交给Spring管理

# IOC底层原理

==xml解析、工厂模式、反射机制==

## 原始方法（耦合度高）

在调用时，需要自己new构造的方法创建对象，然后再调用方法，缺点耦合度太高

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181332078.gif)

## 解决方法：工厂模式（耦合度较高）

通过创建一个UserDao对应的工厂，降低UserService、UserDao的耦合度，但是耦合度还是较高

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181332963.gif)

## IOC解耦（耦合度较低）

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181332413.gif)

# Bean管理的两种操作

### 1、Spring创建对象

通过IOC容器进行创建对象，通过ApplicationContext创建对象的Bean对象

### 2、Spring注入属性

通过IOC容器，对对象的属性进行操作

# Bean管理操作的两种实现的方式

## 1、基于xml配置文件方式实现

### 创建对象

```xml
<bean id="userBean" class="org.example.bean.UserBean"></bean>
```

①在Spring配置文件中，使用bean标签，添加响应的属性，实现对象的创建

#### bean标签的属性

**id**：对象的唯一表示

**class**：创建对象所在类的全类名

**name**：和id作用相同，只不过name属性可以添加特殊符号如（/），id属性不可以

②创建对象的时候，默认执行无参的构造

### 注入属性（DI，依赖注入）

#### 方式一：通过set方法注入

实际上就是Spring在创建对象后，通过调用相应的setter完成属性的注入

1、bean类中，创建属性，以及对应的setter

```java
public class Book {
    private String bookName;
    public void setBookName(String bookName) {
        this.bookName = bookName;
    }
}
```

2、在Spring的配置文件中，先配置对象的创建，再配置属性

```xml
<bean id="book" class="org.example.bean.Book">
    <!-- 使用property标签，完成属性注入
        name:表示需要注入的属性
        value:表示注入属性的值，如果注入的是对象，那么使用ref
     -->
    <property name="bookName" value="西游记"></property>
</bean>
```

#### 方式二：通过有参构造注入

1、创建类，并提供有参构造

```java
public class Person {
    private String personName;
    public Person() {
    }
    public Person(String personName) {
        this.personName = personName;
    }
}
```

2、在Spring配置文件中进行配置

```xml
<bean id="person" class="org.example.bean.Person">
    <!-- 使用constructor-arg标签，完成使用有参构造属性注入
        name：需要注入的属性，可以换成index，按照在有参构造中的属性的索引注入
        value：注入属性的值，如果注入的是对象，那么使用ref
    -->
    <constructor-arg name="personName" value="lucy"></constructor-arg>
</bean>
```

#### 方式三：p名称空间注入

实际上是对于setter注入的一种简化，**底层使用的还是setter**

1、添加p名称空间，在配置文件中

```xml
xmlns:p="http://www.springframework.org/schema/p"
```

2、在bean标签中，进行操作

```xml
<bean id="book" class="org.example.bean.Book" p:bookName="西游记"></bean>
```

#### setter注入和有参构造注入的区别

1. 他们2种的注入原理不一样，一个是通过setter()来装配，一个是通过构造器来装配
2. 设值注入是Spring容器先创建对象，然后再调用setter()注入内容；而构造注入是产生对象时，就注入内容
3. 它们两种没有谁好谁坏，只是使用的场合不一样
4. 设值注入，容易被Java程序员接受
5. 如果对注入顺序有严格要求 ，就比较适合使用构造注入
6. 如果对创建对象的顺序也有要求的话，也比较适合使用构造注入

### property标签

#### 设置空值

```xml
<property name="bookName">
    <null/>
</property>
```

#### 值中包含特殊符号，如“<”

方式一，使用转义字符

```xml
<property name="bookName" value="&lt;lucy&gt;"></property>
```

方式二，使用CDATA

```xml
<property name="bookName">
    <value>
        <![CADATA[<lucy>]]>
    </value>
</property>
```

### 注入属性-bean

#### 外部bean

只需要将相关的对象，添加在配置文件中，由spring创建，然后通过ref属性，进行相应的属性（对象）注入，需要在调用类中，添加被调用类对象为属性，并且提供setter，例如，UserService中，需要调用UserDao

```java
public class UserDao {
    public void add(){
        System.out.println("open in UserDao -- add");
    }
}
public class UserService {
    private UserDao userDao;
    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }
    public void showAdd(){
        userDao.add();
    }
}
```

```xml
<bean id="userDao" class="org.example.dao.UserDao"></bean>
<bean id="userService" class="org.example.service.UserService">
    <property name="userDao" ref="userDao"></property>
</bean>
```

#### 内部bean、级联赋值

内部bean

例如有Student、School两个实体类，Student实体类中有School属性，那么可以通过内部bean的方式进行注入，也可以通过外部bean，内部bean方式如下

```java
public class School {
    private String schoolName;
    public String getSchoolName() {
        return schoolName;
    }
    public void setSchoolName(String schoolName) {
        this.schoolName = schoolName;
    }
}
public class Student {
    private String studentName;
    private School school;
    public String getStudentName() {
        return studentName;
    }
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    public School getSchool() {
        return school;
    }
    public void setSchool(School school) {
        this.school = school;
    }
}
```

```xml
<bean id="student" class="org.example.bean.Student">
    <property name="studentName" value="lucy"></property>
    <property name="school">
        <bean id="school" class="org.example.bean.School">
            <property name="schoolName" value="清华大学"></property>
        </bean>
    </property>
</bean>
```

#### 自动注入

标签属性autowire可以进行自动注入，可以byName或byType

byName：需要该属性名与外部bean的id相同

byType：要求该属性的类型，与外部bean的类型相同

```xml
<bean id="myService" class="com.woniu.service.MyService" autowire="byName">
```

default：要求设置全局注入方式在beans标签属性中

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans 
      http://www.springframework.org/schema/beans/spring-beans.xsd"
default-autowire="byType">
<bean id="myService" class="com.woniu.service.MyService" autowire="default">
```

## 2、基于注解的方式进行实现

# Scope属性值

**(1)singleton** 默认值

单例对象 :被标识为单例的对象在spring容器中只会存在一个实例，在加载Spring容器的时候，就会创建对象

**(2)prototype**

多例原型:被标识为多例的对象,每次在获得才会被创建,每次创建都是新的对象**（克隆模式）**

**(3)request**

Web环境下,对象与request生命周期一致

**(4)session**

Web环境下,对象与session生命周期一致

总结:绝大多数情况下，使用单例singleton(默认值)，但是在与struts整合时候，务必要用prototype多例，因为struts2在每次请求都会创建一个新的Action，若为单例，在多请求情况下，每个请求找找spring拿的都是同一个action。

# Bean的声明周期

在传统的Java应用中，bean的生命周期很简单。使用Java关键字new进行bean实例化，然后该bean就可以使用了。一旦该bean不再被使用，则由Java自动进行垃圾回收。相比之下，Spring容器中的bean的生命周期就显得相对复杂多了。正确理解Spring bean的生命周期非常重要，因为或许要利用Spring提供的扩展点来自定义bean的创建过程。下图展示了bean装载到Spring应用上下文中的一个典型的生命周期过程：

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181332062.gif)

bean在Spring容器中从创建到销毁经历了若干阶段，每一阶段都可以针对Spring如何管理bean进行个性化定制

## 创建-->销毁

```xml
1、通过构造器创建bean实例（默认无参构造器）
2、为bean的属性注入值或对其他bean的引用（调用set方法）
3、把bean的实例传递给bean后置处理器方法
4、调用bean的初始化方法（需要进行配置）
5、把bean的实例传递给bean后置处理器方法
6、bean创建完毕，可以使用了
7、容器关闭的时候，调用bean的销毁方法（需要进行配置）
```

## 自定义初始化方法

1、在bean类中自定义一个初始化方法

```java
public void initMethod(){
    ...
}
```

2、在bean标签中声明初始化方法

```xml
<bean id="" class="" init-method="initMethod"></bean>
```

## 自定义销毁方法

1、在bean类中自定义一个销毁方法

```java
public void destroyMethod(){
    ...
}
```

2、在bean标签中声明销毁方法

```xml
<bean id="" class="" destroy-method="destroyMethod"></bean>
```

## 添加后置处理器

1、创建类，实现**BeanPostProcessor**接口

```java
public class MyBeanProcessor implements BeanPostProcessor{
    	@Override
    	public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
    		System.out.println("执行初始化方法之前，传递bean对象" + beanName + "到后置处理器");
    		return bean;
    	}
    	@Override
    	public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
    		System.out.println("执行初始化方法之后，传递bean对象" + beanName + "到后置处理器");
    		return bean;
    }
}
```

2、在spring配置文件中配置后置处理器实例

```xml
<bean id="myBeanProcessor" class="com.woniu.processor.MyBeanProcessor"></bean>
```

## 完整声明周期代码

### entity

```java
public class User {
    	private Integer uid;
    	public User(){
    		System.out.println("第一步，执行构造方法");
    	}
    	public Integer getUid() {
		return uid;
	}
	public void setUid(Integer uid) {
		this.uid = uid;
		System.out.println("第二步，执行set方法");
	}
	@Override
	public String toString() {
		return "User [uid=" + uid + "]";
	}
	public void initMethod(){
		System.out.println("第四步，执行init方法");
	}
	public void destroyMethod(){
		System.out.println("第七步，执行销毁方法");
	}
}
```

### processor

```java
public class MyBeanProcessor implements BeanPostProcessor{
    	/**
    	 * 此方法在执行初始化方法之前执行
    	 */
    	@Override
    	public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
    		System.out.println("第三步，传递bean对象" + beanName + "到后置处理器");
    		return bean;
    	}
	/**
	 * 此方法在执行初始化方法之后执行
	 */
	@Override
	public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
		System.out.println("第五步，传递bean对象" + beanName + "到后置处理器");
		return bean;
	}
}
```

### applicationContext.xml

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:aop="http://www.springframework.org/schema/aop" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans 
      http://www.springframework.org/schema/beans/spring-beans.xsd 
      http://www.springframework.org/schema/aop 
      http://www.springframework.org/schema/aop/spring-aop.xsd 
      http://www.springframework.org/schema/context 
      http://www.springframework.org/schema/context/spring-context.xsd">
      <!--配置实体类-->
      <bean id="user" class="com.woniu.entity.User" init-method="initMethod" destroy-method="destroyMethod">
      	<property name="uid" value="1"></property>
      </bean>
      <!--配置后置处理器，会在spring加载时加载，所有的bean在执行时，都会使用该处理器-->
      <bean id="myBeanProcessor" class="com.woniu.processor.MyBeanProcessor"></bean>
</beans>
```

### test

```java
@Test
public void test1(){
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		User user = context.getBean("user",User.class);
		System.out.println("第六步，bean创建完成，可以使用：" + user);
    	//调用销毁方法，ClassPathXmlApplicationContext对象的close方法
		context.close();
	}
```

# Spring配置文件引入外部配置文件

## 1、编写配置文件properties

```properties
user.id=1
```

## 2、在spring配置文件引入外部配置文件

```xml
<context:property-placeholder location="user.properties"/>
```

## 3、在spring配置文件需要处，引入属性`${}`

```xml
<bean id="user" class="com.woniu.entity.User">
    <property name="uid" value="${user.id}"></property>
</bean>
```

 