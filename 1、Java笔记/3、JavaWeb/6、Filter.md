# Filter

过滤器，是JavaWeb三大组件之一，是一个驻留在服务端的Web组件，可以==截取用户端和资源之间的请求和响应信息，并对信息进行过滤==

## 工作流程

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181326998.gif)

1、在HttpServletRequest到达Servlet之前，进行拦截

2、根据需求检查HttpServletRequest

## 组成部分

1、过滤源

2、过滤规则

3、过滤结果

## 生命周期

1. 当服务器被开启的时候，filter对象会被创建，并且调用init方法
2. 当我们通过浏览器访问servlet的时候，servlet对象会被创建，并且调用init方法，然后调用过滤器的doFilter方法中的放行前的代码，然后再调用servlet的service方法，然后再调用过滤器的doFilter方法中的放行后的代码
3. 当我们多次访问servlet的时候，只会重复的调用filter的doFilter方法和servlet的service方法
4. 当我们正常的关闭服务器的时候，会先执行servlet的destroy方法，然后再执行filter的destroy方法 

# 过滤器的部署

## ①实现javax.servlet.Filter接口

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181326909.gif)

## ②配置过滤器

### 方式一：通过web.xml文件

```xml
<filter>
    <filter-name>名称</filter-name>
    <filter-class>类全名</filter-class>
</filter>
<filter-mapping>
    <filter-name>名称</filter-name>
    <filter-pattern>拦截路径</filter-pattern>
</filter-mapping>
```

### 方式二：通过注解

```java
@WebFilter("拦截路径")
```

## url-patten的配置（配置拦截路径）

- 具体的资源路径：`/XXX`
  - `/servletDemo1，/demo1.jsp`
- 根据路径进行拦截：`/XXX/*  `
  - `/user/*，/goods/*`
- 针对后缀名进行配置：`*.jsp`
- 拦截所有的配置：`/*`

## 配置多个过滤器（过滤器链）

### 过滤相同资源时执行的先后顺序

* 配置文件：谁在配置文件的上面谁先执行
* 注解：根据类名的字符串的字典顺序（字母a-z）进行排序由小到大

# 使用举例

## 过滤字符，防止中文乱码

如果是tomcat8之前的版本，该方法只可以解决post请求的乱码处理

```java
@WebFilter("/*")
public class CharacterFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        servletRequest.setCharacterEncoding("utf-8");
        filterChain.doFilter(servletRequest,servletResponse);
    }
}
```

## 未登录用户的权限控制

 

 

 

 

 

 

 