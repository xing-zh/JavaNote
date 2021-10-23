# JSP的缺陷

- JSP就是一个Servlet ，生命周期：翻译，编译，加载，初始化，服务，销毁
- Servlet一定要放置在Tomcat容器中才可以运行，浏览器不能直接解析
- JSP页面一般构成：HTML + CSS + JS + Java代码 + JSTL标记
- 由此的坏处：
  - JSP必须要在Tomcat容器解析成HTML，才可以返回到浏览器中（系统：不管是静态请求也好， 还是动态请求，都压到Tomcat服务器，这就可能导致Tomcat解决动态请求的能力有所降低）
  - JSP必须要在Tomcat容器解析成HTML，这就意味着百度，谷歌，以及其他的搜索引擎无法去收录
- JSP从2015年之前，就开始走向灭亡，取而代之的是，HTML + 模板引擎

# 模板引擎

- 使用符号或者自定义标记 + 网页中不变的东西 = 模板引擎
- 模板引擎的作用： 将页面中动态的内容，使用标记或某些符号，进行静态的替换。从而做到：浏览器认为整个网页都是静态的内容（进而可以做到：浏览器缓存HTML，Nginx等服务器缓存HTML） 从而提升系统的整合响应性能
- 常见的模板引擎：**Freemarker，thymeleaf，velocity**

# Thymeleaf的使用

thymeleaf通常适用于前后端不分离的页面

## 1、创建SpringBoot应用

## 2、导入依赖

```xml
<!-- 导入thymeleaf的启动器依赖：完成对thymeleaf的全部支持，自动配置了对应视图解析器 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```

## 3、配置`application.properties`

```properties
#配置thymeleaf的视图解析器ThymeleafViewResolver
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html
spring.thymeleaf.mode=HTML5
spring.thymeleaf.cache=false
spring.thymeleaf.encoding=UTF-8
```

## 4、html页面放在`src/main/resources/templates`下

## 5、js、css等静态资源放在`src/main/resources/static`下

# Thymeleaf的标记

## `th:object`，`th:text=*{}`

```html
<!-- th:object：表示现在需要显示的是后端传递过来的一个对象 -->
<p th:object="${author}">
    <!-- th:text配合*{属性的名字}：现在获取的外面对象的属性 -->
    作者的名字：<span th:text="*{authorName}"></span>
    <br>
    作者的年龄：<span th:text="*{age}"></span>
    <br>
    作者的性别：<span th:text="*{gender}"></span>
</p>
```

## 字符串拼接

```html
<p th:object="${author}">
    <!-- 使用''单引号配合 + 加号，可以做到字符串的拼接 -->
    <span th:text="'作者的名字：' + *{authorName}"></span>
    <br>
    <!-- 除了''可以字符串拼接，使用||也可以做到相同的效果，但是注意：符号必须是英文符号 -->
    <span th:text="|作者的年龄: *{age}|"></span>
    <br>
    <span th:text="|作者的性别: *{gender}|"></span>
    <!-- 可以通过\对单引号进行转义 -->
    <button th:onclick="'alert(\'' + ${p.path} + '\')'">分享</button>
</p>
```

## `[[${}]]`：JS内联

```js
<!-- 如果JS中，也需要使用到后端的数据，需要将thymeleaf内联到JS中，语法：th:inline="javascript" -->
<script type="text/javascript" th:inline="javascript">
    let authorName = [[${author.authorName}]];
    alert(authorName);
    // window.location.href=[[@{"访问路径"}]];
</script>
<!--这种内联不会进行转义-->
[(${})]
```

## th:if：条件判断

```html
<!-- th:if用于页面做条件判断-->
<h1 th:if="${author.age} > 18">
    真帅！！！
</h1>
<h1 th:if="${author.age} < 18">
    真小！！！
</h1>
```

## th:each：循环

```html
<!-- 处理集合的标记-->
<table>
    <thead>
        <tr>
            <th>商品的名称</th>
            <th>商品的价格</th>
            <th>商品的描述</th>
        </tr>
    </thead>
    <tbody>
        <!-- th:each="g : ${goods}"：循环goods集合，每次循环给元素取个名字g -->
        <tr th:each="g : ${goods}" th:if="${g.price} > 3000">
            <td th:text="${g.goodsName}"></td>
            <td th:text="${g.price}"></td>
            <td th:text="${g.goodsDesc}"></td>
        </tr>
    </tbody>
</table>
```

## `@{}`：url请求

```html
<script th:src="@{js/jquery-3.5.1.js}"></script>
```

## 循环添加五个按钮

```html
<button th:each="index:${#numbers.sequence(1, 5)}">
    [(${index})]
</button>
```



