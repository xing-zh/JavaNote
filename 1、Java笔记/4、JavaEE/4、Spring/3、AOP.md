# AOP

Aspect Oriented Programming with Spring (面向切面编程)，是一种不同于oop(面向对象)的编程模式，它不是oop的代替，而是对oop的补充

我们之前的所写代码，一般都是表现层调用业务层，业务层调用持久层，代码的执行顺序是从上至下依次执行，也就说：我们之前一般都是纵向关注代码

## AOP的作用

AOP的最大作用：采用代码模式，将核心业务，与非核心业务进行分离关注

核心业务，我们采用纵向关注，而非核心业务，我们采用横向关注

交叉业务：不同的功能模块中，都拥有的业务（几乎都是非核心功能）

# AOP的底层原理（动态代理）

## 有接口，JDK动态代理

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181332998.gif)

## 没有接口，CGLIB动态代理

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181332973.gif)

# AOP的名词

**Joinpoint**：连接点：切面中需要加入公共程序的地方！(一个具体位置)

**Pointcut**：切入点：符合某种规则的连接点，好多个连接点用对象化表示出来！(多个连接点用表达式来表示，好多个位置)

**Advice**：通知：需要加入的公共程序！(要添加的代码)

**Aspect**：切面，在连接点上做的一系列行为！把通知和切入点整合(aop整体)

## 通知类型

**@Around**：环绕通知，org.aopalliance.intercepter.MethodInterceptor：目标方法前/后调用，阻止方法调用

**@Before**：前置通知，org.springframework.aop.MethodBeforeAdvice：在目标方法前调用

**@After**：后置通知，org.springframework.aop.AfterAdvice：在目标方法后调用

**@AfterThrowing**：异常通知，org.springframework.aop.ThrowsAdvice：当目标方法抛出异常时调用

**@AfterReturning**：返回通知：org.springframework.aop.AfterReturningAdvic：在我们的目标方法正常返回值后运行

# execution切入点表达式

## 格式

```java
execution([权限修饰符][返回类型][类全路径][方法名称][参数列表])
execution(modifiers-pattern ret-type-pattern declaring-type-pattern 
    name-pattern(param-pattern) throws-pattern)
modifiers-pattern：访问修饰符，可以省略
ret-type-pattern：返回类型，不能省略
declaring-type-pattern：类的类路径，可以省略
name-pattern：方法的名称，不能省略
param-pattern：参数列表，不能省略
throws-pattern：异常列表，可以省略
*通配符
```

## 常用表达式

```java
1. 拦截com.woniuxy.service包下所有类的所有方法
execution(* com.woniuxy.service.*.*(..)) 
2. 拦截所有public方法
execution(public * *(..))
3. save开头的方法
execution(* save*(..))
4. 拦截指定类的指定方法, 拦截时候一定要定位到方法
execution(public com.woniuxy.g_pointcut.OrderDao.save(..))
5. 拦截指定类的所有方法
execution(* com.woniuxy.g_pointcut.UserDao.*(..))
6. 拦截指定包，以及其子包下所有类的所有方法
execution(* com..*.*(..))
7. ||和or表示两种满足其一即可，取两个表达式的并集
execution(* com.woniuxy.g_pointcut.UserDao.save()) || execution(* com.woniuxy.g_pointcut.OrderDao.save())
execution(* com.woniuxy.g_pointcut.UserDao.save()) or execution(* com.woniuxy.g_pointcut.OrderDao.save())
8. &amp;&amp;和and表示两种都同时满足才行，取交集
execution(* com.woniuxy.g_pointcut.UserDao.save()) &amp;&amp; execution(* com.woniuxy.g_pointcut.OrderDao.save())
execution(* com.woniuxy.g_pointcut.UserDao.save()) and execution(* com.woniuxy.g_pointcut.OrderDao.save())
9. 取非值, !和not表示不在该范围内的作为切点
!execution(* com.woniuxy.g_pointcut.OrderDao.save())
not execution(* com.woniuxy.g_pointcut.OrderDao.save())
```

# AspectJ

AspectJ是一个面向切面的框架，不是Spring框架的一部分，可以单独使用，是目前最好用，最方便的AOP框架，和spring中的aop可以集成在一起使用，通过Aspectj提供的一些功能实现aop代理变得非常方便。

# AOP的实现

## 方式一：基于代理模式

Spring提供了一个静态代理类`org.springframework.aop.framework.ProxyFactoryBean`

1、创建一个类，实现通知接口，并重写方法，如MethodBeforeAdvice

```java
public class BeforeAdvice implements MethodBeforeAdvice{
    	@Override
    	public void before(Method arg0, Object[] arg1, Object arg2) throws Throwable {
    		// TODO Auto-generated method stub
    		System.out.println("被代理的对象执行的方法："+arg0+","+arg0.getName());
    		System.out.println("被代理的对象执行的方法的参数是："+Arrays.toString(arg1));
    		System.out.println("被代理的对象是："+arg2+","+arg2.getClass().getName());
    	}
}
```

2、xml文件中，创建被代理类实例

```xml
<bean id="myService" class="com.woniu.service.MyService" autowire="default">
```

3、xml文件中，对该通知类进行实例化

```xml
<bean id="beforeAdvice" class="com.woniu.advice.BeforeAdvice"></bean>
```

4、xml文件中，创建代理类实例

```xml
<bean id="proxy" class="org.springframework.aop.framework.ProxyFactoryBean">
    <!--此处的ref为被代理类对象的id，name属性固定-->
    <property name="target" ref="myService"></property>
    <!--name属性固定，此处的list标签中，即为自定义通知类实例id-->
    <property name="interceptorNames">
        <list>
            <value>beforeAdvice</value>
        </list>
    </property>
</bean>
```

## 方式二：aspectJ，通过接入点表达式在xml中逐个配置

由于方法一，每需要增加一个被代理类，就需要在xml中，添加一个第四步的标签，所以使用方式二

1、创建一个类，实现通知接口，并重写方法

```java
public class BeforeAdvice implements MethodBeforeAdvice{
	@Override
	public void before(Method arg0, Object[] arg1, Object arg2) throws Throwable {
		// TODO Auto-generated method stub
		System.out.println("被代理的对象执行的方法："+arg0+","+arg0.getName());
		System.out.println("被代理的对象执行的方法的参数是："+Arrays.toString(arg1));
		System.out.println("被代理的对象是："+arg2+","+arg2.getClass().getName());
	}
}
```

2、xml文件中，对该通知类进行实例化

```xml
<bean id="beforeAdvice" class="com.woniu.advice.BeforeAdvice"></bean>
```

3、**创建AOP命名空间，在beans标签上**

```xml
<beans xmlns="http://www.springframework.org/schema/beans" 
	xmlns:aop="http://www.springframework.org/schema/aop" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans 
      http://www.springframework.org/schema/beans/spring-beans.xsd 
      http://www.springframework.org/schema/aop 
      http://www.springframework.org/schema/aop/spring-aop.xsd" 
    default-autowire="byType">
```

4、编写aop:config标签

```xml
<aop:config>
    <aop:advisor advice-ref="beforeAdvice" pointcut="execution(* com.woniu.service.*.*(..))"/>
</aop:config> 
```

## 方式三：aspectJ，通过自定义通知类，编写不同的方法（推荐）

由于前两种方法都需要每个通知，去实现一个通知接口，所以，利用方法三，可以将不同的通知编写在一个自定义通知类的不同方法中

1、编写自定义通知类，注意方法的形参

```java
public class MyAdvice {
    public void beforeMethod(JoinPoint jp){
        System.out.print("前置通知：");
        System.out.print("被代理的对象是："+jp.getTarget().getClass().getName()+"   ");
        System.out.print("被代理的方法是："+jp.getSignature().getName()+"   ");
        System.out.println("被代理的方法实参是："+Arrays.toString(jp.getArgs())+"   ");
        //获取代理方法对象
        MethodSignature signature= (MethodSignature) jp.getSignature();
        Method method = signature.getMethod();
    }
	public void afterMethod(JoinPoint jp){
		System.out.print("后置通知：");
		System.out.print("被代理的对象是："+jp.getTarget().getClass().getName()+"   ");
		System.out.print("被代理的方法是："+jp.getSignature().getName()+"   ");
		System.out.print("被代理的方法实参是："+Arrays.toString(jp.getArgs())+"   ");
	}
	public void afterReturning(JoinPoint jp,Object c){
		System.out.print("后置返回通知：");
		System.out.print("被代理的对象是："+jp.getTarget().getClass().getName()+"   ");
		System.out.print("被代理的方法是："+jp.getSignature().getName()+"   ");
		System.out.print("被代理的方法实参是："+Arrays.toString(jp.getArgs())+"   ");
		System.out.println("被代理的方法返回值是:"+c);
	}
	public void afterThrowing(JoinPoint jp){
		 System.out.println("发生异常了！");
	}
	public void around(ProceedingJoinPoint pjp){
		  try {
			  System.out.println("环绕通知开始");
			  	Object a = pjp.proceed();
			  System.out.println("环绕通知结束"+a);
		} catch (Throwable e) {
			e.printStackTrace();
		} 
	}
}
```

2、在beans标签中，需要加入AOP命名空间

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<beans xmlns="http://www.springframework.org/schema/beans" 
	xmlns:aop="http://www.springframework.org/schema/aop" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans 
      http://www.springframework.org/schema/beans/spring-beans.xsd 
      http://www.springframework.org/schema/aop 
      http://www.springframework.org/schema/aop/spring-aop.xsd" 
    default-autowire="byType">
```

3、在xml文件中，获取自定义通知类的对象

```xml
<bean id="myAdvice" class="com.woniu.advice.MyAdvice"></bean>
```

4、在aop：config标签中，添加切入点，以及切面

```xml
<aop:config>
    <!-- 定义一个切入点，即需要添加通知的切入点 -->
    <aop:pointcut expression="execution(* com.woniu.service.*.*(..))" id="servicePointcut"/>
    <!-- 定义一个切面，即关联一个自定义的通知类 -->
    <aop:aspect id="myAspect" ref="myAdvice">
        <!-- 此处可以定义不同的通知，关联上方定义的切入点，以及切面中的方法 -->
        <aop:before method="beforeMethod" pointcut-ref="servicePointcut"/>
        <!-- 如果是后置返回通知，那么必须声明返回值的形参名称 -->
        <aop:after-returning method="log" pointcut-ref="servicePointcut" returning="returnVal"/>
    </aop:aspect>
</aop:config>
```

# AOP在项目的应用（面试题）

1. 事务控制
2. 日志记录
3. 异常处理
4. 敏感词过滤

# AOP和AspectJ的区别

## AOP

1、**基于动态代理来实现，默认如果使用接口的，用JDK提供的动态代理实现，如果是方法则使用CGLIB实现**

2、Spring AOP需要依赖IOC容器来管理，并且**只能作用于Spring容器，使用纯Java代码实现**

3、在性能上，由于Spring AOP是基于动态代理来实现的，在容器启动时需要生成代理实例，在方法调用上也会增加栈的深度，**使得Spring AOP的性能不如AspectJ的那么好**

## AspectJ

1、AspectJ来自于Eclipse基金会

2、AspectJ属于静态织入，通过修改代码来实现，有如下几个织入的时机：

- **编译期织入（Compile-time weaving）**： 如类 A 使用 AspectJ 添加了一个属性，类 B 引用了它，这个场景就需要编译期的时候就进行织入，否则没法编译类 B。
- **编译后织入（Post-compile weaving）**： 也就是已经生成了 .class 文件，或已经打成 jar 包了，这种情况我们需要增强处理的话，就要用到编译后织入。
- **类加载后织入（Load-time weaving）**： 指的是在加载类的时候进行织入，要实现这个时期的织入，有几种常见的方法。1、自定义类加载器来干这个，这个应该是最容易想到的办法，在被织入类加载到 JVM 前去对它进行加载，这样就可以在加载的时候定义行为了。2、在 JVM 启动的时候指定 AspectJ 提供的 `agent：-javaagent:xxx/xxx/aspectjweaver.jar。`

3、AspectJ可以做Spring AOP干不了的事情，它是AOP编程的完全解决方案，Spring AOP则致力于解决企业级开发中最普遍的AOP（方法织入）。而不是成为像AspectJ一样的AOP方案

4、因为AspectJ在实际运行之前就完成了织入，所以说它生成的类是没有额外运行时开销的

 

 

 

 

 

 

 

 

 

 

 