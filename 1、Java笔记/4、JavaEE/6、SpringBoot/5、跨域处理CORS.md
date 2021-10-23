# 要解决的问题

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181345949.gif)

前后端分离之后，前端和后端都拥有自己独立的服务器，但是服务器之间可能为了完成某些业务逻辑，就存在服务器之间的跨域访问

# 后端解决跨域访问的方式

## 方式一：使用@CrossOrigin注解

前后端分离的情况下，在凡是需要前后端交互的Controller身上，添加注解**@CrossOrigin**

可以作用在整个Controller类上，也可以作用在特定的一个方法上

### @CrossOrigin的参数

- **origins**： 允许可访问的域列表
- **maxAge**：准备响应前的缓存持续的最大时间（以秒为单位）

## 方式二：直接在SpringBoot的配置类中，添加跨域支持（常用）

```java
@Configuration
public class CORSConfiguration extends WebMvcConfigurationSupport {
    @Override
    protected void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:63343","http://127.0.0.1:5500")
                .allowedMethods("GET", "HEAD", "POST","PUT", "DELETE","OPTIONS")
                .allowedHeaders("*")
                .exposedHeaders("access-control-allow-headers",
                                "access-control-allow-methods",
                                "access-control-allow-origin",
                                "access-control-max-age",
                                "X-Frame-Options")
                .allowCredentials(true);
        super.addCorsMappings(registry);
    }
}
```

# 解决跨域Session失效

## 添加注解属性

```java
//允许客户端发送cookie信息
@CrossOrigin(allowCredentials = "true")
```

## 配置axios

```js
axios.defaults.withCredentials = true
```

## 配置ajax

```js
$.ajax({
    type:"POST",
    url:url,
    data:{data,data},
    dataType:"json",
    xhrFields: {withCredentials: true},     //与服务器配合使用标识允许携带cookie
    success:function(data){

    },
    error:function(XMLHttpRequest){

    },
});
```



 

 

 

 

 

 

 

 

 