# 常用注解

使用异步请求，需要在spring的配置文件中添加

```xml
<!-- 启动异步，json转换 -->
<mvc:annotation-driven></mvc:annotation-driven>
```

这样的话，会有内置的json转换器

| **@Controller**     | 声明该类为SpringMVC中的Controller，类中的方法，可以返回资源，即跳转到模版页面 |
| ------------------- | ------------------------------------------------------------ |
| **@RestController** | 声明该类为SpringMVC中的Controller，类中的**所有方法只能返回String、Object、Json等实体对象**，不能跳转到模版页面，相当于**@ResponseBody ＋ @Controller，**如果想跳转页面，则用ModelAndView进行封装 |
| **@ResponseBody**   | 声明该方法只能返回String、Object、Json等实体对象，异步请求   |
| **@RequestMapping** | 用于处理请求地址映射，可以作用于类和方法上，参数：<br />1、value：定义request请求的映射地址<br />2、method：定义地request址请求的方式，默认接受get请求<br />3、params：定义request请求中必须包含的参数值<br />4、headers：定义request请求中必须包含某些指定的请求头<br />5、consumes：定义请求提交内容的类型<br />6、produces：指定返回的内容类型，仅当request请求头中的(Accept)类型中包含该指定类型才返回 |
| **@RequestParam**   | 用于获取传入参数的值，参数：<br />1、value：参数的名称<br />2、required：定义该传入参数是否必须，默认为true，（和@RequestMapping的params属性有点类似） |