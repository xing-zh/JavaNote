# 什么是Servlet

运行在服务器端的程序（使用Java编写），可以通过浏览器访问的类。主要功能在于交互式浏览和修改数据，生成动态的Web内容。是实现了Servlet接口的类。

## JavaWeb三大组件

servlet程序、filter过滤器、listener监听器

## Servlet的继承关系

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181325852.gif)

## Servlet的常用方法

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181325805.gif)

## Service、doGet、doPost的区别

**Service**：可以处理get/post方式的请求，如果servlet中有service方法，会优先调用service方法

**doGet**：处理get方法的请求

**doPost**：处理post方式的请求

**注意**：如果在重写的service方法中调用了父类的service方法 ` super.service(arg0, arg1)`; 则service方法处理完后，会再次根据请求方式响应的doGet和doPost方法执行， 所以，==一般情况下，是不在重写的service中调用父类的service方法的，避免出现405错误==

# 使用步骤

## 1、继承HttpServlet

### 三种方式

1、定义一个类，去实现**Servlet**接口

2、定义一个类，去继承**GenericServlet**抽象类

3、**定义一个类，去继承HttpServlet抽象类（推荐）**

```java
//注意：如果不重写doGet或者doPost，会报405
class ServletDemo3 extends HttpServlet {
    doGet() {}
    doPost() {}
    service() {}
}
```

## 2、配置Servlet程序访问地址

### 在web.xml文件中

```xml
<servlet>
    <servlet-name>名称1</servlet-name>
    <servlet-class>Servlet全类名（包+类）</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>名称1</servlet-name>
    <url-pattern>/虚拟路径</url-pattern>
</servlet-mapping>
```

### 使用注解配置，不需要写xml文件

在继承了Servlet类上方，添加注解，用于配置此Servlet的虚拟地址，三种方法

```java
@WebServlet(value="/servletDemo1")
public MyServle extends HttpServlet{}
@WebServlet("/servletDemo1")
public MyServle extends HttpServlet{}
@WebServlet(urlPatterns="/servletDemo1")
public MyServle extends HttpServlet{}
```

## 3、访问

``http://localhost:8080/项目虚拟目录/servlet虚拟路径`

# 域对象

**可以像Map一样存取数据的对象**，叫做域对象，Web中一共有四个域对象

这里的域，指的是存取数据的操作范围

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181325460.gif)

==只要是域对象，都有这3个方法，可以实现数据共享，都是以key-value方式存放数据，key必须是String类型，value是Object类型==

## 作用域

| 名称                            | 作用域               | 说明                                                         |
| ------------------------------- | -------------------- | ------------------------------------------------------------ |
| application  （ServletContext） | 在所有应用程序中有效 | 通过request.getServletContext()方法获取，可以在整个应用范围内共享数据 |
| session                         | 在当前会话中有效     | 通过request.getSession()获取，会话代表同一浏览器向服务器的多次请求和响应 |
| request                         | 在当前请求中有效     | 在一次请求的范围内，可以共享资源                             |
| page                            | 在当前页面中有效     | 作用范围是当前用户请求的页面                                 |

# 生命周期

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181325871.gif)

## 生命周期方法

servlet的生命周期是由三个方法体现的，称为生命周期方法：

- **init()**：初始化方法，只有在首次访问时调用
- **service()**：执行方法，每次访问，都会调用
- **destroy()**：销毁方法，只有Servlet销毁时调用（WEB工程停止时）

## 生命周期

==！！！声明周期和地址，也就是配置文件中的虚拟地址有关，无关乎是否同一Servlet==

1、当我们第一次访问servlet的时候，会**创建servlet对象（调用构造器）**，调用servlet的**init()**，然后调用**service()**

2、当我们再一次访问servlet的时候，就不会调用init()，只会调用**service()**

3、当我们正常关闭服务器的时候，会调用servlet的**destroy()**

# Request

## 获取请求行的方法

```java
String getMethod()：获取请求方式
String getContextPath()：获取项目的虚拟目录
String getServletPath()：获取servlet的虚拟路径
String getQueryString()：获取get请求的请求参数
//注意：如果请求参数中有中文数据，那就会出现如username=%E6%B1%A4%E5%A7%86&password=123的情况。
//因为对中文进行了URL编码，如果想要看到正常的结果，要进行URL解码
String getRequestURI()：获取请求的URI（资源路径）
StringBuffer getRequestURL()：获取请求的URL（绝对路径）
String getProtocol()：获取协议/版本号
String getRemoteAddr()：获取客户端的IP地址
```

## 获取请求头的方法

```java
String getHeader(String name)：根据请求头的名称获取请求头的值
Enumeration<String> getHeaderNames()：获取所有的请求头的名称
Enumeration<String> getHeaders(String name)：根据请求头的名称获取多个请求头的值
    • key:value1
    • key:value2
int getIntHeader(String name)：根据请求头的名称获取请求头的值(请求值为int类型的时候)
```

## 获取请求体的方法

```java
String getParameter(String name)：根据请求参数的名称获取值
Enumeration<String> getParameterNames()：获取所有的请求参数的名称
String[] getParameterValues(String name)：根据请求参数的名称获取值（多个）
Map<String,String[]> getParameterMap()：将所有请求参数的名称和值都封装到了map对象
```

## 代码举例

```java
//第一个参数，req，可以调用getparameter("参数的name")，获得参数值
@Override
protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String name = req.getParameter("name");
    String psw = req.getParameter("psw");
    SqlSession sqlSession = MyBatisUtil.getSqlSession();
    UsersDao usersDao = sqlSession.getMapper(UsersDao.class);
    Users byNameAndPsw = usersDao.findByNameAndPsw(name, psw);
    if (byNameAndPsw == null){
        System.out.println("不存在该用户");
    }else{
        System.out.println("该用户存在" + byNameAndPsw);
    }
}
```

## 请求转发RequestDispatcher

请求转发：可以帮助我们实现页面的跳转，不需要自己进行流的输出

```java
//1、调用Request对象的方法，此方法的参数为需要跳转的页面路径
public RequestDispatcher getRequestDispatcher(String path)
//2、调用RequestDispatcher的方法，此方法的第一个参数为request对象，第二个参数为response对象
public void forward(ServletRequest request, ServletResponse response)
```

# Response

## 设置响应状态码

`void setStatus(int sc)`

## 设置响应头

`void setHeader(String name, String value)`

## 设置响应体

打印流：`PrintWriter getWriter()`

字节流：`ServletOutputStream getOutputStream()`

==如果两边的编码不匹配，可能会出现中文乱码==

### 解决中文乱码

```java
//将tomcat写出的编码由ISO-8859-1变成UTF-8
response.setCharacterEncoding("utf-8"); 
//上述方法，只会将服务器写出的编码为utf-8，所以，需要服务器告诉浏览器使用utf-8来打开

//推荐！！！
response.setHeader("Content-Type", "text/html;charset=utf-8");
//或
response.setContentType("text/html;charset=utf-8");
```

## 响应Html文件

可以通过Response实例的getOutPutStream向浏览器进行响应，例如响应Html文件

```java
@Override
protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //获取请求体中的参数，和数据库进比较
    String name = req.getParameter("name");
    String psw = req.getParameter("psw");
    SqlSession sqlSession = MyBatisUtil.getSqlSession();
    UsersDao usersDao = sqlSession.getMapper(UsersDao.class);
    Users byNameAndPsw = usersDao.findByNameAndPsw(name, psw);
    //获取当前项目路径
    String contextPath = req.getServletContext().getRealPath("/");
    //登录成功、失败不同的html页面
    String path = null;
    if (byNameAndPsw == null){
        path = "fail.html";
    }else {
        path = "success.html";
    }
    //获得对应页面的输入流
    InputStream inputStream = new FileInputStream(contextPath  + path);
    //获得输出流
    ServletOutputStream outputStream = resp.getOutputStream();
    //将输入流的内容，写出到输出流
    byte[] bytes = new byte[1024];
    int len = 0;
    while ( (len = inputStream.read(bytes)) >0 ){
        outputStream.write(bytes,0,len);
    }
    //关闭资源
    outputStream.flush();
    outputStream.close();
    inputStream.close();
}
```

# ServletConfig

ServletConfig类，代表Servlet程序的配置信息类,是**由TomCat负责创建，每个Servlet程序创建时，其创建一个对应的ServletConfig对象**

**如果重写了init方法，那么需要调用super(config)，否则，直接使用ServletConfig对象，会出现空指针异常**

## 三大作用

### 可以获取Servlet程序的别名Servlet-name的值

```java
public void init(ServletConfig config) throws ServletException {
    config.getServltName();
}
```

### 可以获取Servlet程序的初始化参数init-param

```java
public void init(ServletConfig config) throws ServletException {
    config.getInitParameter("参数名");
}
```

### 可以获取ServletContext对象

```java
public void init(ServletConfig config) throws ServletException {
    config.getServletContext();
}
```

# ServletContext

ServletContext（Servlet上下文对象）对象就代表当前的应用程序，当前的项目。它的范围是比较大的，它是一个域对象

==每一个项目中有且仅有一个ServletContext对象==

## 对象的生命周期

1、当我们开启服务器的时候，服务器所部署的项目，都会自动的生成一个**ServletContext对象，是tomcat服务器来创建的**

2、当服务器被关闭的时候，或者应用程序被卸载的时候，ServletContext对象就消失了

## ServletContext对象的获取方式

```java
request.getServletContext();
//或
this.getServletContext();
//或
getServletConfig().getServletContext();
```

## 四大作用

### 获取项目下的资源的真实路径（工程在磁盘上的路径）

```java
servletContext.getRealPath(String path);
//当前工程的真实路径
servletContext.getRealPath("/");
```

### 获取web.xml中配置的上下文参数（context-param）

上下文参数，属于整个的web工程

```java
servletContext.getInitParameter("参数名");
```

### 获取当前工程的路径（一般为/工程名）

```java
servletContext.getContextPath();
```

# 同一Servlet处理不同的功能

## 方式一：设置该Servlet的不同的URL

1、通过注解或xml文件设置该url的多个URL，例如

```java
@WebServlet(value={"goodsType/add","goodsType/change"})
```

2、通过request对象的getRequestURI()方法，获取该请求的URI(如shop/goodsType/add)，然后通过字符串的分割，获取具体的请求

```java
@Override
protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String uri = req.getRequestURI();
    String r = uri.substring(uri.lastIndexOf("/") + 1);
}
```

## 方式二：设置请求体中不同的参数做标记，然后在Servlet中解析

# 转发和重定向

==始终都是请求一次，响应一次==

## 转发

调用服务端的资源（静态、动态）

```java
request.getRequestDispatcher().forward();
```

1、属于一次请求

2、响应头没有Location

3、可以在request范围内共享数据

4、只可以使用本应用的资源

5、地址栏不会发生变化，就是请求时的地址

## 重定向

重新定位一下，通过响应头中的Location，告诉浏览器，需要重新请求一次

```java
response.sendRedirect();
```

1、两次请求

2、第一次的请求中，响应头有Location

3、无法在request范围内共享数据，可以通过session或者application（ServletContext）达到数据的共享

4、可以调用应用之外的资源

5、地址栏会发生变化，就是最后请求地址

# Base标签设置

base标签可以避免出现页面转发以后导致的相对路径错误的问题

base标签通常写在html文件title标签的下面，可以设置当前页面在访问相对路径时，参照哪个路径进行相对

```xml
<base href="页面中相对路径工作时参照的地址"/>
```

 

 

 

 

 

 

 

 