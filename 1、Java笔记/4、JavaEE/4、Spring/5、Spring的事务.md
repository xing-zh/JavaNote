# 事务

## 事务的特性

- **原子性（Atomicity）**：事务是一个原子操作，由一系列动作组成。事务的原子性确保动作要么全部完成，要么完全不起作用。
- **一致性（Consistency）**：一旦事务完成（不管成功还是失败），系统必须确保它所建模的业务处于一致的状态，而不会是部分完成部分失败。在现实中的数据不应该被破坏。
- **隔离性（Isolation）**：可能有许多事务会同时处理相同的数据，因此每个事务都应该与其他事务隔离开来，防止数据损坏。
- **持久性（Durability）**：一旦事务完成，无论发生什么系统错误，它的结果都不应该受到影响，这样就能从任何系统崩溃中恢复过来。通常情况下，事务的结果被写到持久化存储器中。

# Spring提供的事务处理方案

## 1. 编程式事务管理

编程式事务管理是侵入性事务管理，使用`TransactionTemplate`或者直接使用`PlatformTransactionManager`，对于编程式事务管理，Spring推荐使用`TransactionTemplate`。

## 2. 声明式事务管理

==声明式事务管理建立在AOP之上，事务是定义在切面中，Spring的事务默认会在方法执行完后进行提交，在方法执行过程中出现异常会进行回滚==，其本质是对方法前后进行拦截，然后在目标方法开始之前创建或者加入一个事务，执行完目标方法之后根据执行的情况提交或者回滚。

编程式事务每次实现都要单独实现，但业务量大功能复杂时，使用编程式事务无疑是痛苦的，而声明式事务不同，声明式事务属于无侵入式，不会影响业务逻辑的实现，只需要在配置文件中做相关的事务规则声明或者通过注解的方式，便可以将事务规则应用到业务逻辑中。

显然声明式事务管理要优于编程式事务管理，这正是Spring倡导的非侵入式的编程方式。唯一不足的地方就是声明式事务管理的粒度是方法级别，而编程式事务管理是可以到代码块的，但是可以通过提取方法的方式完成声明式事务管理的配置。

### 使用xml方式进行事务控制

```xml
<!--需要开启tx的命名空间-->
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:aop="http://www.springframework.org/schema/aop" 
       xmlns:tx="http://www.springframework.org/schema/tx" 
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
       xmlns:context="http://www.springframework.org/schema/context" 
       xsi:schemaLocation="http://www.springframework.org/schema/beans 
                           http://www.springframework.org/schema/beans/spring-beans.xsd 
                           http://www.springframework.org/schema/aop 
                           http://www.springframework.org/schema/aop/spring-aop.xsd 
                           http://www.springframework.org/schema/context 
                           http://www.springframework.org/schema/context/spring-context.xsd 
                           http://www.springframework.org/schema/tx 
                           http://www.springframework.org/schema/tx/spring-tx.xsd">
    <!--定义事务管理者实例-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <!--此处属性为数据源-->
        <property name="dataSource" ref="dataSource" />
    </bean>
    <!--定义了事务的通知，管理者为transactionManager-->
    <tx:advice id="ttt" transaction-manager="transactionManager">
        <tx:attributes>   
            <!--REQUIRED：表示该方法需要加事务，NOT_SUPPORTED：表示该方法不许要加事务-->
            <tx:method name="addStu" propagation="REQUIRED" />
            <tx:method name="sel*" propagation="NOT_SUPPORTED" />
        </tx:attributes>
    </tx:advice>
    <!--定义aop-->
    <aop:config>
        <!--定义切入点-->
        <aop:pointcut id="aaa" expression="execution(* com.aaa.biz.*.*(..))" />
        <!--切入点关联事务通知-->
        <aop:advisor pointcut-ref="aaa" advice-ref="ttt" />
    </aop:config>
</beans>
```

### 使用注解方式进行事务控制

#### 1、开启事务注解

```xml
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="dataSource" />
</bean>
<tx:annotation-driven transaction-manager="transactionManager"/>
```

#### 2、在需要的业务层，或方法上添加事务注解`@Transactional()`

# @Transactional()的属性

## 事务的传播性

```java
@Transactional(propagation=Propagation.REQUIRED)
```

## 事务的隔离级别

```java
@Transactional(isolation = Isolation.READ_UNCOMMITTED)
```

## 只读

```java
//该属性用于设置当前事务是否为只读事务，设置为true表示只读，false则表示可读写，默认值为false。 
@Transactional(readOnly=true)
```

## 事务的超时性

```java
//默认值-1
@Transactional(timeout=30)
```

## 回滚

```java
//指定单一异常类
@Transactional(rollbackFor=RuntimeException.class)
//指定多个异常类
@Transactional(rollbackFor={RuntimeException.class, Exception.class})
//指定出现这个异常时，不回滚
@Transactional(noRollbackFor=RuntimeException.class)
```

# 事务的传播特性

事物的传播，就是在多个支持事务的方法互相调用之间，事务如何在这些方法之间传播

## Propagation枚举类

`org.springframework.transaction.annotation.Propagation`

Spring事务传播的类型的枚举类

在Spring中对于事务的传播行为定义了七种类型分别是：**REQUIRED、SUPPORTS、MANDATORY、REQUIRES_NEW、NOT_SUPPORTED、NEVER、NESTED**

枚举类Propagation是为了结合**@Transactional**注解使用而设计的，这个枚举里面定义的事务传播行为类型与TransactionDefinition中定义的事务传播行为类型是对应的，所以在使用**@Transactional**注解时我们就要使用Propagation枚举类来指定传播行为类型，而不直接使用TransactionDefinition接口里定义的属性

## 事务传播特性

**==注意==：**Spring中事务的默认实现使用的是AOP，也就是代理的方式，如果大家在使用代码测试时，同一个Service类中的方法相互调用需要使用注入的对象来调用，不要直接使用**this.方法名**来调用，**this.方法名**调用是对象内部方法调用，不会通过Spring代理，也就是事务不会起作用

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181333965.gif)

**REQUIRED** : 不管怎么样，一定要有事务，通常用于CUD

**SUPPORTS** : 有事务，就支持事务；没有事务，就非事务方式执行



 