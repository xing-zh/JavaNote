# JSP

JSP（全称JavaServer Pages）是由Sun Microsystems公司主导创建的一种动态网页技术标准。JSP部署于网络服务器上，可以响应客户端发送的请求，并**根据请求内容动态地生成HTML、XML或其他格式文档的Web网页**，然后返回给请求者

JSP里面既可以写Java代码，也可以写HTML标签，**JSP = Java + HTML**

# JSP的脚本

**格式一**：`<% 代码 %>`

* 里面写的是Java代码，在这个里面写的Java代码，jsp翻译成servlet之后，会出现在service方法的内部。

**格式二**：`<%! 代码 %>`

* 里面写的是Java代码，在这个里面写的Java代码，jsp翻译servlet之后，会出现在成员位置。

**格式三**：`<%= 代码 %>`

* 里面写的是Java代码，在这个里面写的Java代码，会输出到页面上。

# JSP的常用的指令

**作用**：对jsp进行配置、导入一些资源

**格式**：`<%@指令名称 属性名1=属性值1 属性名2=属性值2 %>`

1. **page**：主要是用来对jsp进行配置
2. **contentType**：是jsp翻译成servlet之后，所设置响应头，该响应头是指服务器告诉浏览器相应数据的类型和编码是什么。
3. **pageEncoding**：是指jsp翻译sevlet的时候，所使用的编码
4. **import**：导入包
5. **errorPage**：如果该jsp页面出现了错误，会跳转到指定的错误页面
6. **isErrorPage**：默认值为false，如果为false，那该jsp翻译成的servlet里面就没有exception对象；如果为true，那该jsp翻译成的servlet里面就会自动生成一个exception对象。
7. **include**：可以用来包含其他的页面

- 静态包含：`<%@include file="其他的页面"%>`，会将两个页面合并成一个，生成servlet
- 动态包含：`<jsp:include page="demo4.jsp"/>`，每一个页面都会生成各自的servlet
- 推荐使用静态包含

# JSP的注释

1、原生html的注释

- `<!-- abc -->`
- 在jsp翻译成的servlet中是存在的

2、jsp特有的注释==（推荐）==

- `<%-- abc --%>`
- 在jsp翻译成的servlet中是不存在的

# JSP的九大内置对象

==内置对象：不能创建，直接使用==

| 显示的名称  | 真实的类型          | 作用                                                        |
| ----------- | ------------------- | ----------------------------------------------------------- |
| pageContext | PageContext         | 四大域对象之一，代表的范围是当前jsp页面，可以实现数据的共享 |
| session     | HttpSession         | 四大域对象之一，代表的范围是一次会话，可以实现数据的共享    |
| request     | HttpServletRequest  | 四大域对象之一，代表的范围是一次请求，可以实现数据的共享    |
| application | ServletContext      | 四大域对象之一，代表的范围是整个项目，可以实现数据的共享    |
| response    | HttpServletResponse | 响应对象，可以用来设置响应头，响应状态码，可以实现重定向    |
| config      | ServletConfig       | servlet的配置对象，可以配置一些信息                         |
| out         | JspWriter           | 输出流，向页面写东西。和PrintWrite的功能类似                |
| page        | Object              | 是指jsp编译成servlet的servlet对象                           |
| exception   | Throwable           | 异常对象，可以打印一些异常信息                              |

# JSP的执行过程

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181325046.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181326036.gif)

## JSP和Servlet的区别

1、都属于javaWeb的动态资源

2、JSP本质上还是一个Servlet

3、当需要调用JSP时，tomcat对JSP翻译为.java文件，并且JDK进行编译为.class文件

4、JSP页面比较擅长操作标签，servlet擅长处理业务逻辑

# EL表达式

**EL(Expression Language)**表达式语言。 目的：**为了替换Java代码，使JSP写起来更加简单，简化取值过程**

==El表达式的格式：${表达式}==

## 运算符

格式：**${运算符}**

算术运算符：**+   -   \*   /**

逻辑运算符：**&&（and）   ||（or）   !（not）**

比较运算符：**>   <   >=   <=   ==**

空运算符：**empty**

判断数组、字符串、集合的内容，是否为空，是否为null，长度为是否0

```java
//判断是否为空
${empty xxx}
//判断是否不为空
${!empty xxx}
```

**注意：**如果我们想要在页面上显示的内容就是${1+1}

- 方案一：`\${1+1}`
- 方案二：在page指令中写一个属性：`isELIgnored="true"`忽略该页面中的所有的EL表达式

## 获取值

注意：想要使用el表达式获取数据的话，只能从域对象中获取数据

### 格式一

`${域名称.键名}`

域名：

* pageContext->**pageScope**
* request->**requestScope**
* session->**sessionScope**
* application->**applicationScope**

```xml
<%
    String name = "jack";
    request.setAttribute("name", name);
%>

${requestScope.name}
```

### 格式二

`${键名}`

* 根据域的范围大小，由小到大进行查找，直到每一个域中都不存在，就不会展示，如果找到了就直接展
  * **pageScope < requestScope < sessionScope < applicationScope**

```xml
<%
  String name = "jack";
  request.setAttribute("name", name);
%>

${name}
```

## 获取对象中的数据

### 普通对象

`${对象名.对象属性名}`

例如

```xml
<%
    User user = new User();
    user.setName("tom");
    user.setAge(18);
    request.setAttribute("user", user);
%>

${user.name}
${user.age }
```

### 集合对象

#### 单列集合

`${键名[索引]}`

例子：List类

```xml
<%
    List list = new ArrayList();
    list.add("aaa");
    list.add("bbb");
    list.add("ccc");
    pageContext.setAttribute("list", list);
%>

${list[0] }
${list[1] }
${list[2] }
```

#### 双列集合

方法一：`${域中的键名.map中键名}`

方法二：`${键名['map中键名']} `

例子：Map类

```xml
<%
    Map map = new HashMap();
    map.put("name", "jerry");
    map.put("age", 18);
    application.setAttribute("map", map);
%>
       
${map.name }
${map.age }

${map['name'] }
${map['age'] }
```

## 获取当前项目的虚拟目录

el表达式里面有很多隐式对象，但是我们只需要知道一个即可：pageContext

pageContext隐式对象可以获取到其他的8个内置对象  

格式：`${pageContext.request.contextPath}`

# JSTL标签库

JSTL（Java server pages standarded tag library，即JSP标准标签库）是由JCP（Java community Proces）所制定的标准规范，它主要提供给Java Web开发人员一个标准通用的标签库，并由Apache的Jakarta小组来维护。开发人员可以利用这些标签取代JSP页面上的Java代码，从而提高程序的可读性，降低程序的维护难度

## 优点

1、提供一组标准标签

2、可用于编写动态JSP页面

## 引入JSTL标签库

1、在工程中引入jar包

2、在JSP页面添加taglib指令

```xml
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
```

## 常用标签

### if：判断

格式：

```xml
<c:if test=""></c:if>
1、test为判断部分，需要写成el表达式
```

### choose-when-otherwise

格式：

```jsp
<c:choose>
    <c:when test="情况一">
        情况一处理
    </c:when>
    <c:otherwise>
        其他情况处理
    </c:otherwise>
</c:choose>
```

### foreach：循环

格式：

```jsp
<c:forEach 
        begin="1" 
        end="5" 
        step="1" 
        var="a" 
        varStatus="s" 
        items="">
    ${a }...${s.index }...${s.count }
</c:forEach>
1. begin：起始索引
2. end：结束索引
3. step：步数（每次循环索引加几）
4. items：要遍历的容器对象
5. var：容器中的元素
6. varStatus：容器中的元素对象对应的状态，该状态有两个参数
       index：索引
       count：是第几个
```

 

 

 

 

 

 

 

 

 

 

 