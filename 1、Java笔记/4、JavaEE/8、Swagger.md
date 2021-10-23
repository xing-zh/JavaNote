# Swagger在线文档技术

- 现在来讲，最主流的开发模式：前后端分离
- 前端编写页面，以及完成后端接口的调用
- 后端：提供数据接口，以及需要提交接口所对应的接口文档

## 参照的示例

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181345597.png)

文档，要么是以网站的方式，或者以Word文档的方式存在，一定不是以“嘴遁”的方式存在。但是这就对后端程序员，增加了额外的工作量

## 在线文档

- 后端人员只需在Java代码写点注解，对应的框架就可以自动生成相关的接口文档描述
- Swagger就是这样的技术

# 依赖

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.9.2</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.9.2</version>
</dependency>
```

# 配置类

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {
    /**
    * Docket对象包含三个方面信息：
    * 1. 整个API的描述信息，即ApiInfo对象包括的信息，这部分信息会在页面上展示。
    * 2. 指定生成API文档的包名。
    * 3. 指定生成API的路径。
    * @return
    */
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
            .apiInfo(apiInfo())
            //是否开启 (true 开启 false隐藏。生产环境建议隐藏)
            //.enable(false)
            .select()
            //扫描的路径包,设置basePackage会将包下的所有被@Api标记类的所有方法作为api
            .apis(RequestHandlerSelectors.basePackage("xian.woniu.controller"))
            //指定路径处理PathSelectors.any()代表所有的路径
            .paths(PathSelectors.any())
            .build();
    }
    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
            //设置文档标题(API名称)
            .title("SpringBoot中使用Swagger2接口规范")
            //文档描述
            .description("接口说明")
            //服务条款URL
            .termsOfServiceUrl("http://localhost:8080/")
            //版本号
            .version("1.0.0")
            .build();
    }
}
```

# 注解

```java
//对类声明
@Api(value = "测试接口", tags = "用户管理相关的接口", description = "用户测试接口")
//对方法声明
@ApiOperation(value = "添加用户", notes = "添加用户")
//对参数声明
@ApiImplicitParam(name = "s", value = "新增用户数据")
//多参数声明
@ApiImplicitParams({
    @ApiImplicitParam(name = "emp", value = "人员对象，需要有账号和密码"),
    @ApiImplicitParam(name = "1111", value = "人员对象，需要有账号和密码")
})
```

# 跨域问题

```java
@Override
public void addResourceHandlers(ResourceHandlerRegistry registry) {
    registry.addResourceHandler("swagger-ui.html")
        .addResourceLocations("classpath:/META-INF/resources/");
    registry.addResourceHandler("/webjars/**")
        .addResourceLocations("classpath:/META-INF/resources/webjars/");
}
```

