# 客户端和服务器的关系

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181324103.gif)

# Web服务器

服务器：指安装了服务器软件的计算机

服务器软件：软件，下载安装即可使用

## 服务器软件的作用

- 可以接受用户的请求，可以对请求进行处理，然后进行响应。
- 它可以部署web项目，可以通过浏览器访问的方式，去访问web项目中的资源

## JavaWeb常用的服务器

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181324646.gif)

# TomCat

## 目录结构

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181324405.gif)

## 使用

**启动**：找到apache-tomcat-9.0.12\bin目录下的**startup.bat**文件，双击即可

- 闪退：可能会出现的原因有两种
  - 第一种：jdk的环境变量没有配置好
    - 原因
      - 因为配置的是jdk的第一种格式：在path的目录下，直接配置全目录，如：`D:\develop\jdk1.8\jdk1.8.0_241\bin`。而tomcat服务器内置的核心配置文件中，会自动去找**JAVA_HOME**里的jdk路径，但是我们没有配置JAVA_HOME，所以会闪退
    - 解决方法：
      - 配置JDK的第二种方式，要在系统变量里新建一个JAVA_HOME系统变量，值为jdk文件夹路径，然后在path中，配置%JAVA_HOME%\bin即可
  - 第二种：端口冲突
    - 在dos窗口中输入netstat -ano | findstr 8080，查看8080端口所对应pid（进程id），在任务管理器里，找到pid所对应的应用程序，强制关闭即可；或配合使用以下dos命令：
      - **tasklist | findstr**：根据程序的进程号查看具体的程序名称
      - **taskkill -f -t -im**：根据程序映像名强制、递归终止程序及其子进程
      - **taskkill -f -t -pid**：根据程序PID强制、递归终止程序及其子进程

**关闭**：

- 正常关闭：
  - shutdown.bat
  - ctrl + C
- 强制关闭：
  - 点X关闭（直接关闭dos窗口）

## 修改Tomcat的端口号

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181324676.gif)

## IDEA配置TomCat

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181324014.gif)

## Web项目

分静态web项目和动态web项目

### 静态web项目：

项目里面的资源都是静态资源

项目目录结构：

- app项目名
  - --html
  - --css
  - --js

### 动态web项目：

项目里面的资源可动可静

项目目录结构：

- app项目名
  - --html
  - --css
  - --js
  - --WEB-INF
    - --web.xml：项目的核心配置文件
    - --classes：.class文件和配置文件
    - --lib：第三方的jar包

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181324555.gif)

# Web项目的部署

## 什么是部署

将web项目交给服务器来进行管理

## 部署方式

### 方式一

将web项目，放入到**tomcat\webapps**文件夹中，然后开启tomcat服务器，打开浏览器，输入`localhost:8080/项目名/.../资源名`

### 方式二

`tomcat-conf-Catalina-localhost`

通过此路径，在localhost中，建立配置文件：（.xml），内容如下

```xml
<Context path="工程的访问路径" docBase="工程目录路径"/>
```

此方法的工程不需要放在webapps中，可以放置在磁盘任何地方

### 方式三

将**工程名设置为ROOT**，那么，如果在地址栏输入`http://localhost:8080`的话，那么，默认访问的就是webapps下的ROOT工程中的`index.html/jsp`资源

 

 

 

 

 

 

 

 