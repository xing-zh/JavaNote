# SM整合

Spring框架整合mybatis框架， 让Spring框架把控全局

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181333549.gif)

# 整合步骤

## 1、导入需要的依赖

## 2、搭建项目架构

可以通过Mybatis逆向生成，建立mapper、entity等结构

## 3、导入数据库连接池的jar

dbcp、c3p0、druid，三选一

## 4、创建MyBatisConfiguration.xml配置文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <mappers>
        <mapper resource="com/woniu/mapper/StudentMapper.xml"/>
    </mappers>
</configuration>
```

## 5、创建mysql.properties文件

```properties
jdbc.url=jdbc:mysql://localhost:3306/stu?characterEncoding=UTF8
jdbc.driverClassName=com.mysql.jdbc.Driver
jdbc.username=root
jdbc.password=123456
```

## 6、在Spring配置文件中配置数据源连接池

```xml
<!-- 配置DataSource数据源连接池 -->
<context:property-placeholder location="classpath:mysql.properties" />
<bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource">
    <!-- 配置JDBC连接数据库，最基本的连接信息 -->
    <property name="url" value="${jdbc.url}"></property>
    <property name="driverClassName" value="${jdbc.driverClassName}"></property>
    <property name="username" value="${jdbc.username}"></property>
    <property name="password" value="${jdbc.password}"></property>
    <!--连接池最大数量 -->
    <property name="maxActive" value="10"></property>
    <!--连接池最大空闲 -->
    <property name="maxIdle" value="10"></property>
    <!--获取连接最大等待时间 -->
    <property name="maxWait" value="10"></property>
</bean>
```

## 7、创建SessionFactory对象

```xml
<!-- 配置SessionFactory -->
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <!-- 数据库连接池 -->
    <property name="dataSource" ref="dataSource" />
    <!-- 加载mybatis的全局配置文件 -->
    <property name="configLocation" value="classpath:mybatisConfig.xml" />
</bean>
```

## 8、配置MapperScanner扫描器

```xml
<!-- 配置MapperScanner扫描器 -->
<bean id="mapperScannerConfigurer" class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    <!-- 放置Mapper接口以及配置文件所在路径，如果有多个路径，可以使用 , 或 ; 进行分割 -->
    <property name="basePackage" value="com.woniuxy.mapper"></property>
    <!-- 将映射文件和 SessionFactory 进行连接，通过jdk代理为Mapper接口，动态产生代理类 -->
    <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"></property>
</bean>
```



