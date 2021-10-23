# Shiro简介

- 公司项目中，常见的权限框架：shiro，spring security
- Apache Shiro是一个功能强大且灵活的开源安全框架，可以清晰地处理身份验证，授权，企业会话管理和加密
- Apache Shiro的首要目标是易于使用和理解。安全有时可能非常复杂，甚至是痛苦的，但并非必须如此。框架应尽可能掩盖复杂性，并提供简洁直观的API，以简化开发人员确保其应用程序安全的工作

# Shiro能帮系统做什么

1. 做用户的身份认证，判断用户是否系统用户（重点）
2. 给系统用户授权，用来帮助系统实现不同的用户展示不同的功能（重点）
3. 针对密码等敏感信息，进行加密处理（明文变成密文）（重点）
4. 提供了Session管理，但是它的Session不是HttpSession，是它自己自带的
5. 做授权信息的缓存管理，降低对数据库的授权访问
6. 提供测试支持，因为它也是一个轻量级框架，它也可以直接针对代码进行使用Junit单元测试
7. 提供Remeber me的功能，可以做用户无需再次登录即可访问某些页面

# Shiro提供的10大功能

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181345045.gif)

1. Authentication：身份认证/登录，验证用户是不是拥有相应的身份；
2. Authorization：授权，即权限验证，验证某个已认证的用户是否拥有某个权限；即判断用户是否能做事情，常见的如：验证某个用户是否拥有某个角色。或者细粒度的验证某个用户对某个资源是否具有某个权限
3. Session Management：会话管理，即用户登录后就是一次会话，在没有退出之前，它的所有信息都在会话中；会话可以是普通JavaSE环境的，也可以是如Web环境的
4. Cryptography：加密，保护数据的安全性，如密码加密存储到数据库，而不是明文存储；
5. Web Support ：Web支持，可以非常容易的集成到Web环境；
6. Caching 缓存，比如用户登录后，其用户信息、拥有的角色/权限不必每次去查，这样可以提高效率；
7. Concurrency shiro：支持多线程应用的并发验证，即如在一个线程中开启另一个线程，能把权限自动传播过去；
8. Testing：提供测试支持；
9. Run As：允许一个用户假装为另一个用户（如果他们允许）的身份进行访问；
10. Remember Me：记住我，这个是非常常见的功能，即一次登录后，下次再来的话不用登录了

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181345229.gif)

# Shiro框架的3个核心类

1. **Subject主体**：需要登录系统的东西，都是主体。 代表了当前“用户”，这个用户不一定是一个具体的人，与当前应用交互的任何东西都是Subject，如网络爬虫，机器人等；即一个抽象概念；所有Subject都绑定到SecurityManager，与Subject的所有交互都会委托给SecurityManager，可以把Subject认为是一个门面；SecurityManager才是实际的执行者；
2. **SecurityManager安全管理器（实现类DefaultWebSecurityManager）**：即所有与安全有关的操作都会与SecurityManager交互；且它管理着所有Subject；可以看出它是Shiro的核心，它负责与其他组件进行交互，相当于DispatcherServlet前端控制器；
3. **Realm域**：一个用来做身份认证，以及授权的对象Shiro从Realm获取安全数据（如用户、角色、权限），就是SecurityManager要验证用户身份，那么它需要从Realm获取相应的用户进行比较以确定用户身份是否合法；也需要从Realm得到用户相应的角色/权限进行验证用户是否能进行操作；可以把Realm看成DataSource，就是一个跟权限数据有关的数据源

# Subject常用方法

`isAuthenticated()`：判断当前的subject中包含的用户信息是否已经被认证（登录）

`login(token)`：将当前的token（令牌）中存入的用户信息，交给realm的doGetAuthenticationInfo()方法进行验证

`getSession()`：获取shiro封装的Session对象

`getPrincipal()`：可以获取subject.login(token)后，在执行认证方法返回new SimpleAuthenticationInfo()的第一个形参对象，一般就是当前的登录用户对象

# 使用

## 1、引入shiro依赖

```xml
<!-- shiro的相关依赖 -->
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-spring</artifactId>   
    <version>1.4.0</version>
</dependency>
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-ehcache</artifactId>
    <version>1.3.2</version>
</dependency>
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-all</artifactId>
    <version>1.2.2</version>
</dependency>
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-core</artifactId>
    <version>1.2.2</version>
</dependency>
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-web</artifactId>
    <version>1.2.2</version>
</dependency>
```

## 2、编写Realm组件，继承AuthorizingRealm，重写方法

```java
public class LoginAndAuthRealm extends AuthorizingRealm {    
    //授权方法，需要使用<shiro>或@Shiro相同注解才能触发
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        return null;
    }

    //身份认证方法，需要在用户登录系统时触发
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        return null;
    }
}
```

## 3、编写ShiroConfigure配置类

```java
@Configuration
public class ShiroConfig{
    //管理Subject主体对象，生命周期的组件
    @Bean
    public LifecycleBeanPostProcessor lifecycleBeanPostProcessor(){
        return new LifecycleBeanPostProcessor();
    }
    //配置shiro框架中，用来完成身份认证，授权的Realm域对象
    @Bean
    public LoginAndAuthRealm loginAndAuthRealm(){
        return new LoginAndAuthRealm();
    }
    //安全管理器，相当于SpringMVC框架的DispatherServlet
    @Bean
    public DefaultWebSecurityManager securityManager(){
        DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager();
        // 告诉安全管理器认证和授权的对象
        // 如果有多个认证和授权对象，请使用：securityManager.setRealms(集合);
        securityManager.setRealm(loginAndAuthRealm());
        return securityManager;
    }
    //Shiro过滤器，该过滤器的作用：完成对页面请求的过滤，并针对请求，配置对应的过滤规则	
    @Bean
    public ShiroFilterFactoryBean getShiroFilterFactoryBean() {
        ShiroFilterFactoryBean factoryBean = new ShiroFilterFactoryBean();
        // 配置安全管理器（所有的请求，需要经过安全管理器）
        factoryBean.setSecurityManager(securityManager());
        // 配置登录路径、成功路径、无权限路径
        factoryBean.setLoginUrl("/");
        factoryBean.setSuccessUrl("/main");
        factoryBean.setUnauthorizedUrl("/unauthorized");
        // 配置Shiro的过滤器链
        Map<String, String> filters = new LinkedHashMap<>();
        // anon：匿名，无需认证，直接操作
        // 登录页面，匿名方式
        filters.put("/", "anon");
        // 登录请求，匿名方式
        filters.put("/sys/login", "anon");
        // 静态资源，匿名方式
        filters.put("/static/**", "anon");
        // authc：一定要认证
        // 其他的，暂定为：需要认证
        filters.put("/**", "authc");
        // 将过滤规则，设置给Shiro工厂
        factoryBean.setFilterChainDefinitionMap(filters);
        return factoryBean;
    }	
}
```

# 执行流程

## 认证流程

![说明: 未命名绘图.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181345188.gif)

 

 

 

 

 

 

 

 