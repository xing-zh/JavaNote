# Listener

监听器，是JavaWeb三大组件之一，用于监听JavaWeb程序中的事件，例如创建、修改、删除Session、request、context等，并触发响应事件

## 八种监听器

不同功能的监听器，需要实现不同的Listener接口，一个监听器也可以实现多个Listener接口，实现不同的功能

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181326702.gif)

# 使用

## ①实现对应功能的接口

## ②配置Listener

### 在web.xml文件中配置

```xml
<listener>
    <listener-class>Listener全类名</listener-class>
</listener>
```

### 使用注解

```java
@WebListener
```

# 使用场景

## 监控网站登录人数

```java
@WebListener
public class MyListener implements HttpSessionAttributeListener,HttpSessionListener{
    //监控网站新增登录
    @Override
    public void attributeAdded(HttpSessionBindingEvent se) {
        ServletContext servletContext = se.getSession().getServletContext();
        Integer loginCount = (Integer) servletContext.getAttribute("loginCount");
        if (loginCount == null){
            servletContext.setAttribute("loginCount",1);
        }else {
            servletContext.setAttribute("loginCount",loginCount + 1);
        }
    }
    //监控网站退出登录
    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        ServletContext servletContext = se.getSession().getServletContext();
        Integer loginCount = (Integer) servletContext.getAttribute("loginCount");
        servletContext.setAttribute("loginCount",loginCount - 1);
    }
}
```

 

 

 

 

 

 

 

 

 

 

 