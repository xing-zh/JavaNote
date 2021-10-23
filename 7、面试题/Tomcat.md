### Tomcat的缺省端口是多少，怎么修改

缺省端口是8080

修改tomcat目录下conf目录中的server.xml文件，打开这个xml文件，在文件中找到

```xml
<Connector connectionTimeout="20000" port="8080" protocol="HTTP/1.1" redirectPort="8443" uriEncoding="utf-8"/>
```

将里面的port参数修改成你想要的端口就可以了

### Tomcat有几种部署方式

①直接将Web项目，一般是war包，放在webapps下，Tomcat会自动将其部署

②在server.xml文件上配置`<Context>`节点，设置相关的属性就可以了

```xml
<Context Path="/jstore"Docbase="C:\work\jstore\WebContent" Debug="0" Privileged="True" Reloadable="True"/>
```

③通过Catalina进行配置，进入到`conf\Catalina\localhost\`文件下，创建一个xml文件，改文件的名字就是站点的名字

```xml
<Context docBase="C:\work\jstore\web" path="/jstore" reloadable="true"/>
```

### Tomcat如何创建servlet实例，用到了什么原理

当容器启动的时候，会读取在webapps目录下的所有web应用中的web.xml文件，然后对xml文件进行解析，并读取servlet注册信息，然后将每个应用中注册的servlet类都进行加载，然后通过反射的方式进行实例化

如果在servlet进行注册的时候，添加了`<load-on-startup>`标签，标签中只可以使用整数，如果是正数，会在容器启动时进行实例化，如果是负数，那么会在第一次请求时进行实例化；同时这个值越小，越早被加载

### Tomcat的工作模式

Tomcat是一个JSP/Servlet容器。其作为Servlet容器，有三种工作模式：独立的Servlet容器、进程内的Servlet容器和进程外的Servlet容器

进入Tomcat的请求可以根据Tomcat的工作模式分为两类：

①Tomcat作为应用程序服务器：请求来自于前端的Web服务器，这可能是Apache，IIS，Nginx等

②Tomcat作为独立服务器：请求来自于Web浏览器

