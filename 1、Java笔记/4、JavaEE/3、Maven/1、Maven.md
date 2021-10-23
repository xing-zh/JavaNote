# 什么是Maven

是Apache的一个纯java开发的开源项目，基于项目对象模型，maven利用一个中央信息片段能够管理项目的构建、报告、文档等步骤

1、是一个项目管理整合工具

2、只需要使用很少的时间，就可以自动完成工程的基础构建配置

# 安装和配置

## 1、官网下载

http://maven.apache.org/download.cgi

## 2、配置环境变量

①MAVEN_HOME中配置maven路径

②在path中添加`%MAVEN_HOME%\bin;`

## 3、配置maven的jar保存路径

conf下的settings.xml中

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181330391.gif)

## 4、配置镜像下载

由于默认服务器在国外，所以配置镜像可以提升下载速度

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181330501.gif)

阿里镜像

```xml
<mirror>
        <id>alimaven</id>
        <mirrorOf>central</mirrorOf>
        <name>aliyun maven</name>
        <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
</mirror>
```

## 3、初始化仓库

在dos窗口下输入：`mvn help:system`

# maven的工作原理

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181330998.gif)

# Maven项目的目录结构

**src/main/java**：核心代码

**src/main/resources**：配置文件所存放的位置

**src/test/java**：测试代码

**src/test/resources**：测试的配置文件所存放的位置

每个Maven项目中，都有一篇默认的配置文件pom.xml

pom（project object model，项目对象模型），这篇配置文件，主要用来描述项目是如何组成的

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181330188.gif)

## pom.xml文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <!-- 模型版本 -->
    <modelVersion>4.0.0</modelVersion>

    <!--
        项目描述
        groupId公司名称  com.xxxx
        artifactId项目名称
        version版本号
        统称为坐标
        将他们组合起来就是项目在Maven本地仓库发布的位置
    -->
    <!-- 公司或者组织的唯一标志，并且配置时生成的路径也是由此生成， 如com.companyname.project-group，maven会将该项目打成的jar包放本地路径：/com/companyname/project-group -->
    <groupId>com.woniu</groupId>
    <!-- 项目的唯一ID（项目名称），一个groupId下面可能多个项目，就是靠artifactId来区分的 -->
    <artifactId>MyMaven</artifactId>
    <!-- 版本号 -->
    <version>1.0</version>


    <dependencies>
        <!--
        管理依赖
        groupId：公司名称，组织id
        artifactId：项目id，模块id
        version：版本号
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>3.1.0</version>
            <scope>test</scope>     表示该jar包仅在测试阶段有效
            <scope>compile</scope>  表示该jar包仅在编译阶段有效
            <scope>runtime</scope>  表示该jar包在运行期间有效
            <scope>system</scope>   表示该jar包为本地包
        </dependency>
        通过坐标在本地仓库查找该jar包，如果没有，则按照镜像网址查找，并下载到本地仓库
    	-->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>3.1.0</version>
        </dependency>
    </dependencies>
</project>
```

# 常用DOS命令

## 语法结构：

```dos
mvn [plugin-name]:[goal-name]
命令的含义是执行plugin-name插件的goal-name
```

## 1、查看版本号

```dos
mvn -version   
或者使用
mvn -v
```

## 2、初始化仓库

```dos
mvn help:sysetem
```

## 3、清除编译后的内容

```dos
mvn clean 
删除target目录
```

## 4、编译java源代码

```dos
mvn compile
注意编译的整个项目，通过dos命令进入到项目的根结构，再使用该命令
```

## 5、运行含有主方法的java代码

```dos
mvn exec:java -Dexec.mainClass="com.woniu.mvn.HelloWorld"
引号中为类全名
```

## 6、运行测试代码

```dos
mvn test
```

## 7、对Maven项目打包

```dos
mvn package
默认maven项目是jar类型
```

如果需要打包为war，那么需要在配置文件进行修改

```xml
<!--
        声明当前项目类型是war类型。
        需在main中声明webapp/WEB-INF/web.xml。
-->
<packaging>war</packaging>
```

## 8、把当前项目发布到本地仓库

```dos
mvn install
```

# Maven的生命周期

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181330414.gif)

- **mvn clean**：清理编译的项目
- **mvn compile**：编译项目
- **mvn test**：测试项目（运行测试类）
- **mvn package**：负责将我们的项目打包
- **mvn install**：将这个项目安装到仓库中 

## Clean生命周期（Clean Lifecycle）清理项目

当我们执行 mvn post-clean 命令时，Maven 调用 clean 生命周期

1）pre-clean：执行清理前需要完成的工作

2）clean：清理上一次构建生成的文件

3）post-clean：执行清理后需要完成的工作

## Default生命周期（Default Lifecycle）构建项目

Default Lifecycle是构建的核心部分，编译，测试，打包，部署等等，Default生命周期是Maven生命周期中最重要的一个，绝大部分工作都发生在这个生命周期中。

1）validate：验证工程是否正确，所有需要的资源是否可用。 

2）compile：编译项目的源代码。 

3）test：使用合适的单元测试框架来测试已编译的源代码。这些测试不需要已打包和布署。 

4）Package：把已编译的代码打包成可发布的格式，比如jar。

5）integration-test：如有需要，将包处理和发布到一个能够进行集成测试的环境。

6）verify：运行所有检查，验证包是否有效且达到质量标准。 

7）install：把包安装到maven本地仓库，可以被其他工程作为依赖来使用。 

8）Deploy：在集成或者发布环境下执行，将最终版本的包拷贝到远程的repository，使得其他的开发者或者工程可以共享。

## Site生命周期（Site Lifecycle）建立和发布项目站点

Site Lifecycle 生成项目报告，站点，发布站点，站点的文档（站点信息，依赖..）。

1）pre-site：生成项目站点之前需要完成的工作

2）site：生成项目站点文档

3）post-site：生成项目站点之后需要完成的工作

4）site-deploy：将项目站点发布到服务器

# Idea工具集成Maven

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181330517.gif)

# 使用Idea创建MavenSE项目

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181330028.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181330108.gif)

# 使用Idea创建MavenWEB项目

## 1、建立Web项目

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181330077.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181330164.gif)

## 2、配置pom.xml

### ①将jdk版本改为1.8

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181330637.gif)

### ②配置tomcat

```xml
<pluginManagement>
  <plugins>
    <plugin>
      <groupId>org.apache.tomcat.maven</groupId>
      <artifactId>tomcat7-maven-plugin</artifactId>
      <version>2.2</version>
      <!-- tomcat的配置信息 -->
      <configuration>
         <!-- 端口号 -->
        <port>8080</port>
        <!-- 工程路径 -->
        <path>/web01</path>
        <!-- 编码集 -->
        <uriEncoding>UTF-8</uriEncoding>
        <!-- 和上方的tomcat名称保持一致 -->
        <server>tomcat7</server>
      </configuration>
    </plugin>
  </plugins>
</pluginManagement>
```

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181331318.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181331285.gif)

### ③引入Servlet依赖

```xml
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>javax.servlet-api</artifactId>
  <version>4.0.1</version>
  <scope>provided</scope>
</dependency>
```

# 建立多模块项目

1、创建父模块（项目），不需要选择模板类型

2、在父模块右键-new-model，创建子模块（继承父模块的组织id以及版本）

3、将被依赖的模块执行install命令，打包进本地库

4、在需要进行依赖的模块中的pom.xml文件中，引入依赖

# eclipse集成maven

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181331805.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181331549.gif)

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181331146.gif)

 

 

 