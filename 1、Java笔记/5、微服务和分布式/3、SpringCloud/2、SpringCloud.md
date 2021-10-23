# SpringCloud的概念

- Spring Cloud框架是Spring框架中专门用来针对微服务开发的框架，它的原生是NetFlix公司开发的一套微服务框架，但是后来被Spring收购了
- Spring Cloud框架产品中，提供了很多微服务服务组件，如: Eureka注册中心，Zuul网关组件 ，Configuration配置中心 ， Feign服务间通信 ， Hystrix服务降级，Bus消息总线等
- SpringCloud已经闭源了，SpringCloud的版本均为英国伦敦的地铁站站名，最早 的 Release 版本 Angel，第二个 Release 版本 Brixton（英国地名），然后是 Camden、 Dalston、Edgware、Finchley、Greenwich、Hoxton。

# SpringCloud的组件

![1597213783265.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181347783.png)

![image-20210814144109379](https://gitee.com/yh-gh/img-bed/raw/master/202109181347709.png)

## Eureka注册中心

- 注册中心的作用：完成对微服务的服务注册与发现
- 遵循发布/订阅模式，作用：所有的微服务都需要向注册中心进行注册，微服务之间在相互调用时，就可以通过注册中心发现微服务的地址

## Feign服务间通信

- 服务通信的作用：主要用于微服务之间完成使用HTTP协议进行相互调用
- 微服务之间可能存在相互调用，调用时就需要使用Open Feign接口调用技术

## Hystrix服务降级

- 服务降级的作用：主要是处理微服务在调用过程中，由于出现的一些异常或延迟访问的问题，而导致服务异常的问题
- 微服务在调用时，可能存在调用失败，或长时间无法接收到响应的情况。SpringCloud提供了服务降级机制，服务降级，就是将某一个服务从同步调用，修正为类异步调用，有结果就返回结果，没有结果，调用方自己产生结果然后返回上层

## Zuul网关组件

- 网关的作用：为所有的微服务提供一个统一的访问入口
- 每一个微服务都是一个WEB程序，WEB程序就有自己的访问地址，就不能称之为“一个项目”。网关的作用就是解决多个微服务有自己独立访问地址的问题，它可以为微服务体系提供一个统一的“访问入口”

## Configuration配置中心

- 配置中心的作用：管理所有微服务的配置信息
- 每个微服务都有自己的配置文件，提供一个公共在线的配置中心，让我们修改配置更加的方便

## Bus消息总线

- 配合配置中心实现，在线的配置中心发生变化之后，需要使用消息总线推送至所有的微服务中
- 上述的技术中：注册中心，zuul网关，配置中心，Bus消息总结 这几个通常是项目经理或者技术人员已经配好的。我们需要重点的掌握的是：如何开发自己的微服务 ，微服务之间的调用，以及微服务之间的分布式事务处理

# 现在的分布式技术

- Dubbo+Zookeeper（RPC协议，主要用于大型分布式项目：当当）

- SpringCloud+Eureka（官方）(闭源)(Http协议,中小型开发)

  - ```
    SpringCloud+Eureka+RestTemplate+Feign+Hystric+Zull+GateWay+配置中心+分布式事务+Bus总线
    ```

- SpringCoud+Nacos(阿里)(Http协议,中小型开发)

  - ```
    SpringCloud+Nacos+RestTemplate+Feign+Sentinel+GateWay+Nacos自带的配置中心+分布式事务+链路跟踪
    ```

- 古老的技术

  - WebService(常见的，互联网向外界提供服务一般有2中姿势，1：json 2:webservice)

# Spring Cloud和Spring Boot之间的关系

- Spring Cloud是2014年，由Martin Fowler与James Lewis提出开发的。他们在开发的时候，为了提升开发效率，减少配置文件的编写，于是选择了Spring Boot作为微服务程序开发脚手架工具
- 但是它们在开发时，有版本的要求，版本对应关系，可从官网查看

- - https://spring.io/projects/spring-cloud
  - https://start.spring.io/actuator/info

| **Spring Cloud**         | **Spring Boot**                                |
| ------------------------ | ---------------------------------------------- |
| Angel版本                | 兼容Spring Boot 1.2.x                          |
| Brixton版本              | 兼容Spring Boot 1.3.x，也兼容Spring Boot 1.4.x |
| Camden版本               | 兼容Spring Boot 1.4.x，也兼容Spring Boot 1.5.x |
| Dalston版本、Edgware版本 | 兼容Spring Boot 1.5.x，不兼容Spring Boot 2.0.x |
| Finchley版本             | 兼容Spring Boot 2.0.x，不兼容Spring Boot 1.5.x |
| Greenwich版本            | 兼容Spring Boot 2.1.x                          |

- 实际开发过程中，可以对应的更加详细

| **Spring Boot** | **Spring Cloud**        |
| --------------- | ----------------------- |
| 1.5.2.RELEASE   | Dalston.RC1             |
| 1.5.9.RELEASE   | Edgware.RELEASE         |
| 2.0.2.RELEASE   | Finchley.BUILD-SNAPSHOT |
| 2.0.3.RELEASE   | Finchley.RELEASE        |
| 2.1.0.RELEASE   | Greenwich.SR1           |
| 2.3.0.RELEASE   | Hoxton.SR4              |

# 微服务环境搭建

## 1、技术选型

* maven

* mysql

* mybatis

* spring cloud alibaba

## 2、模块设计

| 工程名       | 描述                         | 端口 |
| ------------ | ---------------------------- | ---- |
| star-cloud   | 父工程                       | -    |
| star-common  | 公共模块，放置实体类和工具类 | -    |
| star-product | 商品微服务                   | 808x |
| star-order   | 订单微服务                   | 809x |

## 3、创建父工程（Maven项目）

作为父工程，是不需要编写源代码的，所以注解把父工程中的src目录删除掉，然后编辑父工程的pom.xml，做依赖版本控制

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.woniu</groupId>
    <artifactId>star-cloud</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>pom</packaging>

    <!-- 依赖版本锁定 -->
    <properties>
        <java.version>1.8</java.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <spring-cloud.version>Greenwich.RELEASE</spring-cloud.version>
        <spring-cloud-alibaba.version>2.1.1.RELEASE</spring-cloud-alibaba.version>
        <spring-boot.version>2.1.3.RELEASE</spring-boot.version>
        <lombok.version>1.18.16</lombok.version>
        <mysql.version>5.1.38</mysql.version>
        <mybatis.version>1.3.2</mybatis.version>
    </properties>

    <!--  版本仲裁中心,管理子模块中使用的依赖版本  -->
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot</artifactId>
                <version>${spring-boot.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <dependency>
                <groupId>com.alibaba.cloud</groupId>
                <artifactId>spring-cloud-alibaba-dependencies</artifactId>
                <version>${spring-cloud-alibaba.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <dependency>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>${lombok.version}</version>
            </dependency>
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>${mysql.version}</version>
            </dependency>
            <dependency>
                <groupId>org.mybatis.spring.boot</groupId>
                <artifactId>mybatis-spring-boot-starter</artifactId>
                <version>${mybatis.version}</version>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <!-- 安装Spring Boot Maven插件，可以简化Maven和Spring Boot之间的交互 -->
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

## 4、创建公共模块star-common（Maven项目）

1、在该模块pom.xml中，加入需要的依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>star-cloud</artifactId>
        <groupId>com.woniu</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
    <artifactId>star-common</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
    </dependencies>

</project>
```

2、编写实体类以及工具类

![image-20210813115629922](https://gitee.com/yh-gh/img-bed/raw/master/202109181348990.png)

## 5、创建微服务

### 5.1、创建商品微服务

引入依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>star-cloud</artifactId>
        <groupId>com.woniu</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
    <artifactId>star-product</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.woniu</groupId>
            <artifactId>star-common</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
        </dependency>
    </dependencies>
    <build>
        <resources>
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.xml</include>
                </includes>
            </resource>
            <resource>
                <directory>src/main/resources</directory>
            </resource>
        </resources>
    </build>
</project>
```

由于引入的公共模块已经引入了lombok和mysql依赖，所以不需要再引入

![image-20210813152822558](https://gitee.com/yh-gh/img-bed/raw/master/202109181348628.png)

编写代码

![image-20210813152634400](https://gitee.com/yh-gh/img-bed/raw/master/202109181348741.png)

### 5.2、创建订单微服务

和商品微服务一样的步骤

## 6、订单微服务访问商品微服务

### 6.1、在需要的微服务spring容器中添加RestTemplate

```java
@Bean
public RestTemplate getRestTemplate(){
    return new RestTemplate();
}
```

### 6.2、使用RestTemplate实例方法进行访问商品微服务

```java
@PostMapping("/insert/{pid}/{number}")
public ResultVO insert(@PathVariable Integer pid,@PathVariable Integer number){
    try {
        ResultVO resultVO = restTemplate.getForObject("http://localhost:8080/product/findByPid/" + pid, ResultVO.class);
        //此处返回的是一个LinkedHashMap
        LinkedHashMap map = (LinkedHashMap)resultVO.getE();
        //使用hutool工具，将map中的值封装进对象
        Product product = BeanUtil.fillBeanWithMap(map,new Product(),true);
        //将商品中的id和名称封装进订单对象
        Orders orders = new Orders();
        BeanUtil.copyProperties(product,orders,true);
        orders.setNumber(number);
        orders.setPrice(product.getPrice() * number);
        orders.setUsername("lucy");
        //插入数据库
        ordersService.insert(orders);
        return ResultVO.success("新增订单成功");
    }catch (Exception e){
        e.printStackTrace();
        return ResultVO.fail("新增订单异常");
    }
}
```



