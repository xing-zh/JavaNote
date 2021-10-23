# SpringSession

SpringSession可以解决在微服务高可用或多个微服务中，JSESSIONID不同的问题

## 使用

### 1、启动redis

### 2、在需要共享JSESSIONID的微服务中，添加依赖

```xml
<dependency>
    <groupId>org.springframework.session</groupId>
    <artifactId>spring-session-data-redis</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

### 3、修改配置文件

```yml
spring:
  application:
    name: student-system
  session:
    store-type: redis
```

### 4、访问微服务，发现JSESSIONID已经被存入redis

![image-20210825144023351](https://gitee.com/yh-gh/img-bed/raw/master/202109181401990.png)

# JWT令牌认证技术

- 全称：JSON Web Token
- 官网：jwt.io
- 专门用来替换：Cookie + Session的应用状态管理方式，通常适合前后端分离的项目
- 应用程序的状态**：**后端服务器和浏览器相互识别的内容

# 传统应用状态管理的缺陷

- 缺陷
  - 前端只能是浏览器或者有Cookie的前端技术
  - 应用程序的服务器在横向扩展时，需要进行Session同步
  - 不适合做前后端分离的项目
- 具体原因
  - 目前的前端（大前端）包含：各种浏览器，各种手机APP，各种应用小程序，还有其他的设备，但上述的这些前端技术中，Cookie是浏览器所特有的

# 单点登录SSO

* cookie和域

* 微服务认证的问题：每个微服务都需要做单独的认证，对于用户而言，太麻烦了。

* 单点登录可以解决微服务的鉴权问题


## SSO（Single Sign On）	

所谓单点登录，就是用户在多系统环境下，在一个单一的服务中登录，进而实现在多个系统同时登录的一种技术。

# JWT解决方案

## JWT的流程

后端通过JWT的技术，可以生成一个Token令牌的东西，生成出来之后，交给前端，要求前端进行存储，前端的每次请求需要携带该Token令牌到后端来识别

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181402366.png)

## JWT的组成

JWT由3段信息构成：头（header）、载荷（payload）、签证（signature）

头（header）、载荷（payload）采用Base64位加密方法，签证（signature）使用HMACSHA256进行加密运算

![image-20210825150851976](https://gitee.com/yh-gh/img-bed/raw/master/202109181402253.png)

- 头（Header）

  - 主要承载2部分内容：声明Token使用JWT技术产生，声明加密的算法通常直接使用HMACSHA256

  - 完整头的JSON格式：

  - ```json
    {
      'typ': 'JWT',
      'alg': 'HS256'
    }
    ```

  - 头的内容是固定的，不会发生变化

  - 对应的字符串是：eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.

- 载荷（payload）
  - 后端通过JWT承载，传递给前端有用的相关数据
  - 组成载荷的2个部分：标准中注册的声明，其它的声明
  - 标准中注册的声明（建议但不强制）：
    - iss：jwt签发者
    - sub：jwt所面向的用户
    - aud：接收jwt的一方
    - exp：jwt的过期时间，这个过期时间必须要大于签发时间
    - nbf：定义在什么时间之前，该jwt都是不可用的
    - iat：jwt的签发时间
    - jti：jwt的唯一身份标识，主要用来作为一次性token，从而回避重放攻击。
  - 其它的声明
    - 载荷中，可以申明上述的标准信息，也可以附加一些个人信息（个人信息有的是公共的，有的是私有的）
    - 备注：不管是公共的，还是私有的，由于载荷使用Base64位算法，都是可以破解的
    - 其它的声明，不要写一些非常敏感的信息，例如：银行卡卡号，银行卡密码，登录名，登录密码……

- 签证(signature)
  - 签证由3部分构成
    - header：base64加密后的内容
    - payload：base64加密后的内容
    - secret：盐值
  - 将以上3部分内容使用：HMACSHA256算法进行加密
  - 保证令牌颁发的权威性

# JWT完成SSO的基本使用

## JWT令牌的生成

- 生成的时间点：登录成功的时候

## 一、登录认证微服务

### 1、公共模块，导入JWT依赖，创建工具类

```xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.9.1</version>
</dependency>
```

```java
public class JwtUtil {
    /**
     * 私钥密码，保存在服务器，客户端是不会知道密码的，以防止被攻击
     */
    private static final String SECRET = "jwttest";
    /**
     * 加密方式
     */
    private static final SignatureAlgorithm signatureAlgorithm = SignatureAlgorithm.HS256;

    /**
     * 对密钥进行加密
     *
     * @return
     */
    private static Key getkey() {
        byte[] apiKeySecretBytes = DatatypeConverter.parseBase64Binary(SECRET);
        return new SecretKeySpec(apiKeySecretBytes, signatureAlgorithm.getJcaName());
    }

    /**
     * 生成Token
     * <p>
     * JWT分成3部分：1.头部（header)，2.载荷，3.签证（signature)
     * <p>
     * 加密后这3部分密文的字符位数为：
     * 1.头部（header)：36位，Base64编码
     * 2.载荷（payload)：没准，BASE64编码
     * 3.签证（signature)：43位，将header和payload拼接生成一个字符串，
     * 使用HS256算法和我们提供的密钥（secret,服务器自己提供的一个字符串），
     * 对str进行加密生成最终的JWT
     */
    public static String createToken(String username, int expireSeconds) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("alg", "HS256");
        map.put("typ", "JWT");
        JwtBuilder builder = Jwts.builder();
        builder.setHeaderParams(map);
        builder.claim("username", username);
        builder.claim("role", "大内总管");
        builder.signWith(SignatureAlgorithm.HS256, getkey());

        // 签发时间
        long nowMillis = System.currentTimeMillis();
        Date now = new Date(nowMillis);

        // 设置过期时间
        if (expireSeconds >= 0) {
            long expMillis = nowMillis + (expireSeconds + 2) * 1000;
            Date expDate = new Date(expMillis);
            builder.setExpiration(expDate); // 过期时间
        }
        builder.setIssuedAt(now);

        String token = builder.compact();
        return token;
    }

    /**
     * 解密Token查看其是否合法
     */
    public static boolean verifyToken(String token) {
        Claims body = null;
        try {
            body = Jwts.parser().setSigningKey(getkey()).parseClaimsJws(token).getBody();
        } catch (SignatureException e) {
            throw new RuntimeException(e);
        } catch (ExpiredJwtException e) {
            throw new RuntimeException("超时", e);
        } catch (Exception e) {
            throw new RuntimeException("未知错误", e);
        }
        return body != null;
    }

    public static String getUsername(String token) {
        Claims body = null;
        try {
            body = Jwts.parser().setSigningKey(getkey()).parseClaimsJws(token).getBody();
        } catch (SignatureException e) {
            throw new RuntimeException(e);
        } catch (ExpiredJwtException e) {
            throw new RuntimeException("超时", e);
        } catch (Exception e) {
            throw new RuntimeException("未知错误", e);
        }
        System.out.println((String) body.get("role"));
        return (String) body.get("username");
    }
}
```

### 2、创建认证微服务，用于登录，认证

#### 2.1、引入依赖、编写配置文件

```xml
<dependencies>
    <!-- 公共模块，包含mysql依赖 -->
    <dependency>
        <groupId>com.woniu</groupId>
        <artifactId>common</artifactId>
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
        <groupId>com.alibaba.cloud</groupId>
        <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-thymeleaf</artifactId>
    </dependency>
</dependencies>
```

```yml
server:
  port: 8888
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/demo?serverTimezone=UTC&characterEncoding=utf8
    driver-class-name: com.mysql.jdbc.Driver
    username: root
    password: 123456
  thymeleaf:
    prefix: classpath:/templates/
    suffix: .html
    mode: HTML5
    cache: false
    encoding: UTF-8
```

#### 2.2、编写登录页面

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.w3.org/1999/xhtml">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
        <form action="/login">
            <input type="hidden" name="backUrl" th:value="${backUrl}">
            account<input name="account"><br>
            psw<input name="psw"><br>
            <button>sub</button>
        </form>
    </body>
</html>
```

#### 2.3、编写service对账号密码进行验证

```java
@Service
public class UserInfoServiceImpl implements UserInfoService {
    @Resource
    private UserInfoDao userInfoDao;
    @Override
    public UserInfo login(String account, String psw) {
        UserInfoExample userInfoExample = new UserInfoExample();
        UserInfoExample.Criteria criteria = userInfoExample.createCriteria();
        criteria.andAccountEqualTo(account);
        criteria.andPswEqualTo(psw);
        List<UserInfo> userInfos = userInfoDao.selectByExample(userInfoExample);
        return userInfos.size() > 0 ? userInfos.get(0) : null;
    }
}
```

#### 2.4、编写controller对令牌进行跳转登录页面和验证登录信息

```java
@Controller
public class LoginController {
    @Resource
    private UserInfoService userInfoService;
	/**
	* 跳转登录页面方法，同时验证token，验证成功，则跳转回原来的地址
	* backUrl，为测试用的原来的地址
	*/
    @RequestMapping("/toLogin")
    public String toLogin(String backUrl, @CookieValue(value = "token",required = false)String token, ModelMap map){
        //判断令牌是否有效
        if (!StringUtils.isEmpty(token)){
            boolean b = JwtUtil.verifyToken(token);
            if (b){
                return "redirect:" + backUrl + "?token=" + token;
            }
        }
        //令牌失效或不存在
        map.put("backUrl",backUrl);
        //跳转登录页面
        return "login";
    }
    /**
	* 登录验证方法
	*/
    @RequestMapping("/login")
    public String login(UserInfo userInfo, String backUrl, HttpServletResponse response){
        //验证用户的登录
        UserInfo loginUser = userInfoService.login(userInfo.getAccount(),userInfo.getPsw());
        //如果账号密码正确，则创建令牌
        if (loginUser != null){
            String token = JwtUtil.createToken(loginUser.getAccount(), 3000);
            //将令牌存入cookie
            Cookie cookie = new Cookie("token",token);
            response.addCookie(cookie);
            return "redirect:"+backUrl+"?token=" + token;
        }
        return "redirect:http://localhost:8888/toLogin?backUrl=" + backUrl;
    }
}
```

## 二、其他微服务添加拦截器

### 1、编写拦截器

```java
@Component
public class LoginInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //获取用户实际请求的地址，用于令牌验证通过继续访问
        String backUrl = request.getRequestURL().toString();
        //从参数中获取token
        String token_r = request.getParameter("token");
        //从cookie中获取token
        Cookie cookie = WebUtils.getCookie(request, "token");
        String token_c = cookie == null ? null : cookie.getValue();
        //从参数或cookie的token中选择有效的token
        String token = StringUtils.isEmpty(token_r)?token_c : token_r;
        //验证token
        if (!StringUtils.isEmpty(token)){
            if (JwtUtil.verifyToken(token)){
                Cookie cookie1 = new Cookie("token",token);
                response.addCookie(cookie);
                return true;
            }
        }
        //验证不通过，跳转登录页面
        response.sendRedirect("http://localhost:8888/toLogin?backUrl=" + backUrl);
        return false;
    }
}
```

### 2、配置拦截器到SpringBoot

```java
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    @Autowired
    private LoginInterceptor loginInterceptor;

    public void addInterceptors(InterceptorRegistry registry) {
        InterceptorRegistration registration = registry.addInterceptor(loginInterceptor);
        registration.addPathPatterns("/**");                      //所有路径都被拦截
        registration.excludePathPatterns(                         //添加不拦截路径
                "/**/*.html",            //html静态资源
                "/**/*.js",              //js静态资源
                "/**/*.css",             //css静态资源
                "/**/*.woff",
                "/**/*.ttf"
        );
    }
}
```

# Gateway鉴权+JWT完成SSO

由于简单使用中，在每个微服务都添加一个拦截器并进行配置，过于繁琐，所以，我们在Gateway上直接添加全局的过滤器用于SSO，所有的微服务都由Gateway进行统一的管理转发

## JWT令牌的认证与置换

令牌的产生是在具有登录服务的微服务上，而令牌的校验是在网关服务上对其进行校验

![img](https://gitee.com/yh-gh/img-bed/raw/master/202109181402876.jpeg)

## 1、JWT的基本搭建（同上）

- 公共类common中添加JWT依赖，编写JwtUtils
- 创建登录微服务（账号密码认证、跳转登录页面）
- 编写登录页面

## 2、创建Gateway微服务，对所有微服务路径进行管理

```yml
server:
  port: 80
spring:
  application:
    name: gateway
  cloud:
    nacos:
      discovery:
        server-addr: http://localhost:8848
    gateway:
      discovery:
        locator:
          # 让gateway从nacos中获取服务信息
          enabled: false
      routes:
        # 路由标识，必须唯一，默认是UUID
        - id: student-system
          # 路由的目标地址，lb(loadblance)表示使用负载均衡，其后是微服务的标识
          uri: lb://student-system
          # 路由的优先级，数字越小代表路由的优先级越高
          order: 1
          # 当请求路径匹配Path时，就会路由到uri
          predicates:
            - Path=/student-system/**
          # 转发之前，去掉1层路径
          filters:
            - StripPrefix=1
        - id: clazz-system
          uri: lb://clazz-system
          order: 1
          predicates:
            - Path=/clazz-system/**
          filters:
            - StripPrefix=1
```

## 3、在Gateway微服务中，添加全局过滤器

```java
@Component
public class LoginGlobalFilter implements GlobalFilter, Ordered {
    //认证中心的跳转登录页面Url
    private final String loginServerUrl = "http://localhost:8888/toLogin";
    //当前Gateway的Url
    private final String gatewayUrl = "http://localhost";
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        ServerHttpResponse response = exchange.getResponse();
        //获取本来访问的路径
        String backUrl = gatewayUrl + request.getPath().toString();
        //获取参数中的token
        String token_r = request.getQueryParams().getFirst("token");
        //获取cookie中的token
        String token_c = getCookieByName(request, "token");
        //在参数或cookie中的token选择有效的token
        String token = StringUtils.isEmpty(token_r) ? token_c : token_r;
        //如果token为空
        if (StringUtils.isEmpty(token)){
            return gotoLogin(response,backUrl);
        }
        //如果token无效
        if (!JwtUtil.verifyToken(token)){
            return gotoLogin(response,backUrl);
        }
        //其他情况放行
        return chain.filter(exchange);
    }

    //前往认证微服务进行认证
    private Mono<Void> gotoLogin(ServerHttpResponse response, String backUrl) {
        //设置状态码
        response.setStatusCode(HttpStatus.SEE_OTHER);
        //设置响应头,重定向到认证中心
        response.getHeaders().add(HttpHeaders.LOCATION,loginServerUrl + "?backUrl=" + backUrl);
        return response.setComplete();
    }

    public String getCookieByName(ServerHttpRequest request,String cookieName){
        MultiValueMap<String, HttpCookie> cookies = request.getCookies();
        Set<Map.Entry<String, List<HttpCookie>>> entries = cookies.entrySet();
        for (Map.Entry<String, List<HttpCookie>> entry : entries) {
            if (entry.getKey().equals(cookieName)) {
                List<HttpCookie> value = entry.getValue();
                if (value.size() > 0) {
                    return value.get(0).getValue();
                }
            }
        }
        return null;
    }

    @Override
    public int getOrder() {
        return 0;
    }

}
```

## 4、测试效果

### 4.1、通过网关访问微服务（未认证）

![image-20210826121449793](https://gitee.com/yh-gh/img-bed/raw/master/202109181402128.png)

### 4.2、未认证，会被跳转到登录页面，并记录实际访问的地址

![image-20210826121703416](https://gitee.com/yh-gh/img-bed/raw/master/202109181402141.png)

### 4.3、输入账号密码认证后，会继续访问刚才的地址

![image-20210826122156978](https://gitee.com/yh-gh/img-bed/raw/master/202109181402572.png)

# CSRF

## CSRF是什么？

CSRF（Cross-site request forgery），中文名称：跨站请求伪造，也被称为：one click attack/session riding，缩写为：CSRF/XSRF。

## CSRF可以做什么？

　　你这可以这么理解CSRF攻击：攻击者盗用了你的身份，以你的名义发送恶意请求。CSRF能够做的事情包括：以你名义发送邮件，发消息，盗取你的账号，甚至于购买商品，虚拟货币转账......造成的问题包括：个人隐私泄露以及财产安全。

## CSRF漏洞现状

　　CSRF这种攻击方式在2000年已经被国外的安全人员提出，但在国内，直到06年才开始被关注，08年，国内外的多个大型社区和交互网站分别爆出CSRF漏洞，如：NYTimes.com、Metafilter（一个大型的BLOG网站），YouTube和百度HI......而现在，互联网上的许多站点仍对此毫无防备，以至于安全业界称CSRF为“沉睡的巨人”。

### CSRF的原理

- 登录受信任网站A，并在本地生成Cookie。

- 在不登出A的情况下，访问危险网站B。

- 看到这里，你也许会说：“如果我不满足以上两个条件中的一个，我就不会受到CSRF的攻击”。是的，确实如此，但你不能保证以下情况不会发生：

- 你不能保证你登录了一个网站后，不再打开一个tab页面并访问另外的网站。

- 你不能保证你关闭浏览器了后，你本地的Cookie立刻过期，你上次的会话已经结束。（事实上，关闭浏览器不能结束一个会话，但大多数人都会错误的认为关闭浏览器就等于退出登录/结束会话了......）

- 上图中所谓的攻击网站，可能是一个存在其他漏洞的可信任的经常被人访问的网站。
