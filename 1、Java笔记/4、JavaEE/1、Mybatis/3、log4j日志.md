# 什么是log4j

# 使用步骤

1、下载导入jar文件到项目

2、在src路径下新建核心配置文件**log4j.properties**（==路径和名称固定，不可以修改==）

## 配置文件log4j.properties

```properties
log4j.rootCategory=DEBUG, CONSOLE, LOGFILE

#控制台相关
#表示输出在控制台
log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
#表示输出在控制台的模板布局
log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
#自定义模板布局
log4j.appender.CONSOLE.layout.ConversionPattern=%C %d{yyyy-MM-dd HH:mm:ss}  %m %n

#日志文件相关
#表示输出到文件
log4j.appender.LOGFILE=org.apache.log4j.FileAppender
#日志文件的名称
log4j.appender.LOGFILE.File=log.log
#多次输出的日志是否追加
log4j.appender.LOGFILE.Append=true
#表示输出到文件的模板布局
log4j.appender.LOGFILE.layout=org.apache.log4j.PatternLayout
#自定义模板布局
log4j.appender.LOGFILE.layout.ConversionPattern=%C %d{yyyy-MM-dd HH:mm:ss}  %m %n

#log4j.logger.java.sql.ResultSet=INFO  
#log4j.logger.org.apache=INFO  
#log4j.logger.java.sql.Connection=DEBUG  
#log4j.logger.java.sql.Statement=DEBUG  
#log4j.logger.java.sql.PreparedStatement=DEBUG 
```

### log4j的输出级别

Fatal 致命错误 --> error 错误 --> warn 警告--> info 信息 --> debug调试信息，从左向右等级越来越低

`log4j.rootCategory=DEBUG, CONSOLE, LOGFILE`

#### 第一个参数

表示输出级别

\#配置根Logger

\#如果配置为debug,则会打印error、warn、info、debug级别的信息

\#如果配置为error,则只会打印error错误级别的信息

#### 第二个参数

表示输出到控制台

#### 第三个参数

表示输出到日志文件

### 配置文件模板格式

```java
%p：输出日志信息的优先级，即DEBUG，INFO，WARN，ERROR，FATAL。
%d：输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，如：%d{yyyy/MM/dd HH:mm:ss,SSS}。
%r：输出自应用程序启动到输出该log信息耗费的毫秒数。
%t：输出产生该日志事件的线程名。
%l：输出日志事件的发生位置，相当于%c.%M(%F:%L)的组合，包括类全名、方法、文件名以及在代码中的行数。例如：test.TestLog4j.main(TestLog4j.java:10)。
%c：输出日志信息所属的类目，通常就是所在类的全名。
%M：输出产生日志信息的方法名。
%F：输出日志消息产生时所在的文件名称。
%L:：输出代码中的行号。
%m:：输出代码中指定的具体日志信息。
%n：输出一个回车换行符，Windows平台为"rn"，Unix平台为"n"。
%x：输出和当前线程相关联的NDC(嵌套诊断环境)，尤其用到像java servlets这样的多客户多线程的应用中。
%%：输出一个"%"字符。
另外，还可以在%与格式字符之间加上修饰符来控制其最小长度、最大长度、和文本的对齐方式。如：
1)c：指定输出category的名称，最小的长度是20，如果category的名称长度小于20的话，默认的情况下右对齐。
2)%-20c："-"号表示左对齐。
3)%.30c：指定输出category的名称，最大的长度是30，如果category的名称长度大于30的话，就会将左边多出的字符截掉，但小于30的话也不会补空格。
```

# MyBatis使用log4j

1. 必须保证有log4j的jar包
2. 在src目录下必须有log4j.properties配置文件
3. 在mybatis的核心配置文件中，加入节点

```xml
<setting name="logImpl" value="LOG4J"/>
```

# Java代码中使用log4j

```java
public static void main(String[] args) {
		//通过java代码调用
		Logger  logger = Logger.getLogger(Test09.class);//哪个类中要有日志
		//#Log4j建议使用四个级别。优先级从高到底error、warn、info、debug
		logger.info("hello，我自己的记录的信息！");	
}
```



 