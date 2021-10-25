# SpringBOOT

[SpringBOOT中文索引]([Spring Boot 中文导航](http://springboot.fun/))



Spring Boot实际上就是Spring提供的一套专门用来快速整合框架，搭建项目的技术，基于maven，使用==约定大于规定的规则==构建框架

Spring Boot是Spring开源组织下的子项目，是Spring组件一站式解决方案，其设计目的是用来简化Spring应用项目的搭建以及开发过程，简化繁琐的配置，提供了各种启动器，开发者能快速上手

# 新建SpringBoot项目

## eclipse开发

### 新建步骤

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181344424.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181344708.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181344397.gif)

## 通过官网创建

https://start.spring.io/

# 项目架构

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181344931.gif)

# pom.xml

```xml
<!--如果该项目没有父项目，那么需要以SpringBoot作为父项目-->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.1.0.RELEASE</version>
</parent>
```

# 启动类

```java
@SpringBootApplication
@MapperScan("com.woniu.mapper")
public class App {
    public static void main(String[] args) {
        //准备spring的上下文，完成spring容器的初始化，创建，注入依赖等，实现aop,加载拦截器等等。
        SpringApplication.run(App.class, args);
    }
}
```

**启动类需要放在com根目录下**

## @SpringBootApplication的元注解

- **@Configuration**：定义bean，创建对象
- **@EnableAutoConfiguration**：开启自动配置，读取配置文件实现注入依赖
- **@ComponentScan**：配置需要扫描的包，默认当前类（启动类）下所有包及子包子类

# SpringBoot配置文件

==配置文件名固定application==

## application.properties文件

```properties
#端口号
server.port=8080
#项目名，可以不写，默认localhost:8080就可以访问项目
server.servlet.context-path=/app
#配置静态资源访问路径，resources文件夹下
spring.resources.static-locations=classpath:/templates/

#前缀后缀
spring.mvc.view.prefix=/
spring.mvc.view.suffix=.jsp

#数据库连接池
spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
# spring.datasource.driverClassName=org.postgresql.Driver
# 初始化时建立物理连接的个数
spring.datasource.druid.initial-size=5
# 最小连接池数量
spring.datasource.druid.min-idle=5
# 最大连接池数量
spring.datasource.druid.max-active=20
# 获取连接时最大等待时间，单位毫秒
spring.datasource.druid.max-wait=60000
# 申请连接的时候检测，如果空闲时间大于timeBetweenEvictionRunsMillis，执行validationQuery检测连接是否有效。
spring.datasource.druid.test-while-idle=true
# 既作为检测的间隔时间又作为testWhileIdel执行的依据
spring.datasource.druid.time-between-eviction-runs-millis=60000
#销毁线程时检测当前连接的最后活动时间和当前时间差大于该值时，关闭当前连接
spring.datasource.druid.min-evictable-idle-time-millis=30000
spring.datasource.url=jdbc:mysql://localhost:3306/banji?userSSL=true&useUnicode=true&characterEncoding=UTF8&serverTimezone=GMT
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.driverClassName=com.mysql.cj.jdbc.Driver

#redis配置
spring.redis.host = localhost
spring.redis.password = eduask
spring.redis.port = 6379

#分页拦截器
pagehelper.reasonable=true

#mapper.xml扫描，如果mapper.xml和mapper.java在一个包里，那么注解MapperScan就可以了
mybatis.mapper-locations=classpath*:com.woniu.mapper/*.xml
```

## YML

全名：**YAML Ain't Markup Language**

以数据为中心，比json、xml等更适合做配置文件

### 基本语法

**key:（空格）value**：表示一对键值对（空格必须有）

以**空格的缩进（不可以使用TAB缩进）**来控制层级关系，只要是左对齐的一列数据，都是同一个层级的

**属性和值也是大小写敏感**

### 值的写法

#### 字面量

- 普通的值（数字，字符串，布尔）
- k: v：字面直接来写；
- 字符串默认不用加上单引号或者双引号
- `""`：双引号；**不会转义字符串里面的特殊字符**；特殊字符会作为本身想表示的意思
  - name: `"zhangsan \n lisi"`
  - 输出：`zhangsan 换行  lisi`
- `''`：单引号；**会转义特殊字符**，特殊字符最终只是一个普通的字符串数据
  - name: `'zhangsan \n lisi'`
  - 输出：`zhangsan \n  lisi`

#### 对象、Map

在下一行来写对象的属性和值的关系；注意缩进

```yaml
friends:
   lastName: zhangsan
   age: 20
#行内写法：
friends: {lastName: zhangsan,age: 18}
```

#### 数组、集合（List、Set）

用**- 值**表示数组中的一个元素

```yaml
pets:
  - cat
  - dog
  - pig
```

## application.yml文件

```yaml
#端口号
server:
   port: 8080
   servlet:
      context-path: /app

#配置thymeleaf的视图解析器ThymeleafViewResolver
spring:
   thymeleaf:
      prefix: classpath:/templates/
      suffix: .html
      mode: HTML5
      cache: false
      encoding: UTF-8
      
   #redis配置
   redis:
      host: localhost
      password: eduask
      port: 6379
      
   #数据库配置
   datasource:
      type: com.alibaba.druid.pool.DruidDataSource
      url: jdbc:mysql://localhost:3306/manage?userSSL=true&useUnicode=true&characterEncoding=UTF8&serverTimezone=GMT
      username: root
      password: 123456
      driverClassName: com.mysql.cj.jdbc.Driver
      #数据库连接池
      druid:
         # 初始化时建立物理连接的个数
         initial-size: 5
         # 最小连接池数量
         min-idle: 5
         # 最大连接池数量
         max-active: 20
         # 获取连接时最大等待时间，单位毫秒
         max-wait: 60000
         # 申请连接的时候检测，如果空闲时间大于timeBetweenEvictionRunsMillis，执行validationQuery检测连接是否有效。
         test-while-idle: true
         # 既作为检测的间隔时间又作为testWhileIdel执行的依据
         time-between-eviction-runs-millis: 60000
         #销毁线程时检测当前连接的最后活动时间和当前时间差大于该值时，关闭当前连接
         min-evictable-idle-time-millis: 30000
         
   servlet:
      #文件上传配置
      multipart:
         enabled: true
         #单个文件的大小
         max-file-size: 20MB
         #限制总上传文件的大小
         max-request-size: 20MB
         
#分页拦截器
pagehelper:
   reasonable: true
   
#日志
logging:
  level:
    root: info
    com.bestvike: debug
    org.springframework.security: warn
  # 默认日志文件名
  # file: log
  # 默认日志路径
  # path: ./log
  # logback.xml路径，默认为classpath:logback.xml
  # config: ./logback.xml
```

# 读取配置文件的信息

## 1、读取单个参数

```yml
spring:
  application:
    name: test
```

在java代码中读取name属性值，使用@Value注解

```java
@Value(${spring.application.name})
private String name;
```

## 2、读取多个同一节点下的属性（对象）

```yml
minio:
  endpoint: localhost:9000
  accesskey: minioadmin
  secretkey: minioadmin
```

编写配置类用于读取配置文件，在spring容器启动时，就会在yml中读取

```java
@Component
@Data
@ConfigurationProperties(prefix = "minio")
public class MinioConfig{
    private String endpoint;
    private String accesskey;
    private String secretkey;
}
```

添加依赖，可以在写完带有`@ConfigurationProperties`注解的配置类以后，编写yml有提示

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-configuration-processor</artifactId>
    <optional>true</optional>
</dependency>
```
