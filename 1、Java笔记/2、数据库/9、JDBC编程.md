# 数据持久化

数据持久化就是**将内存中的数据模型转换为存储模型**，以及**将存储模型转换为内存中的数据模型**的统称。数据模型可以是任何数据结构或对象模型，存储模型可以是关系模型、XML、二进制流等。

## 瞬时状态

保存在内存的程序数据，程序退出，数据就消失了

## 持久状态

保存在磁盘上的程序数据，程序退出后依然存在

## 数据持久化技术

Hibernate、JPA、==JDBC（Java Datebase Connectivity）==等

## JDBC框架

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181208806.gif)

## Driver 接口

**java.sql.Driver** 接口是所有 JDBC 驱动程序需要实现的接口。这个接口是提供给数据库厂商使用的，不同数据库厂商提供不同的实现

在程序中不需要直接去访问实现了 Driver 接口的类，而是由**驱动程序管理器类(java.sql.DriverManager)**去调用这些Driver实现

# 连接、操作数据库步骤

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181208475.gif)

 

```java
Connection conn = null; 
Statement st=null; 
ResultSet rs = null; 
try { 
//获得Connection 
//创建Statement 
//处理查询结果ResultSet 
}catch(Exception e){ 
    e.printStackTrance(); 
} finally {
    //释放资源ResultSet, Statement,Connection 
}
```

## 一、获取数据库连接对象步骤

### 1、导入jar包

1、在项目中创建lib文件夹

2、将jar文件放置到lib文件夹

3、集成到项目中，右键build(eclipse)、add as library(idea)

### 2、注册驱动（Java代码中加载驱动类）

将com.mysql.jdbc包下的Driver类的字节码文件从本地磁盘加载到方法区中

==Oracle的驱动==：**oracle.jdbc.driver.OracleDriver** 

==mySql的驱动==： **com.mysql.jdbc.Driver**

方式一：加载 JDBC 驱动需调用 Class 类的静态方法 forName()，向其传递要加载的 JDBC 驱动的类名

```java
//将com.mysql.jdbc包下的Driver类的字节码文件从本地磁盘加载到方法区中
Class.forname("com.mysql.jdbc.Driver")
```

方式二：DriverManager 类是驱动程序管理器类，负责管理驱动程序

```java
DriverManager.registerDriver(com.mysql.jdbc.Driver);
```

通常不用显式调用 DriverManager 类的 registerDriver() 方法来注册驱动程序类的实例，原因：

1、该方法，过于依赖jar包的存在

2、该方法，会造成二次注册

3、使用Class.forname可以降低耦合性

### 3、获取连接对象

```java
//本机IP：localhost 本机端口号：3306
String url = "jdbc:mysql://IP地址:端口号/库名?serverTimezone=Asia/Shanghai&characterEncoding=utf-8";
String user = "用户名";
String passWord = "密码";
Connection conn = DriverManager.getConnection(url,user,passWord);
```

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181208986.gif)

**协议**：JDBC URL中的协议总是jdbc

**子协议**：子协议用于标识一个数据库驱动程序

**子名称**：一种标识数据库的方法。子名称可以依不同的子协议而变化，用子名称的目的是为 了定位数据库提供足够的信息。包含**主机名(对应服务端的ip地址)，端口号，数据库名**

#### 几种常用数据库的JDBC URL

对于 **Oracle** 数据库连接，采用如下形式： 

```java
jdbc:oracle:thin:@localhost:1521:库名
```

对于 **SQLServer** 数据库连接，采用如下形式： 

```java
jdbc:microsoft:sqlserver//localhost:1433; DatabaseName=库名
```

对于 **MYSQL** 数据库连接，采用如下形式： 

```java
jdbc:mysql://localhost:3306/库名
```

## 二、执行sql语句

### 1、获取Statement对象

```java
Statement statement = conn.createStatement();
```

### 2、执行sql语句

```java
int result = statement.executeUpdate("sql语句字符串对象")
```

#### Statement类方法分类

* **int executeUpdate(sql);**
  * 针对数据库的增(insert into)、删(delete from)、改(update set)操作
  * 返回值类型：实际影响的行数
* **ResultSet executeQuery(sql);**
  * 针对数据库的查询(select from)操作
  * 返回值类型：一个结果集类型
* **boolean execute(sql);**
  * 针对数据库的增删改查操作，一般我们不会使用，jdbc的底层代码会使用
  * 如果执行的sql语句是增删改，返回false
  * 如果执行的sql语句是查询，返回true

### 3、处理执行结果(ResultSet)

```java
//使用Statement类的方法ResultSet executeQuery(String sql);获得结果集类型的对象
ResultSet set = statement.executeQuery(sql);
while(set.next()){
    //形参可以直接写字段名，字段名不区分大小写
    String id = set.getInt("book_id");
    //也可以写字段索引，索引从1开始
    String id = set.getInt(1);    
}
```

### 4、释放资源

```java
resultSet.close();
statement.close();
connection.close();
```

# 实现JDBC工具类

将获取连接和关闭资源等公共、重复的代码封装成一个工具类

```java
import java.sql.*;
public class JDBCUtil {
    private static String driver;
    private static String url;
    private static String user;
    private static String passWord;
    //解析配置文件.properties
    static {
        try {
             Properties properties = new Properties();
            properties.load(new FileInputStream(".properties文件路径"));
            driver = (String) properties.get("driver");
            url = (String) properties.get("url");
            user = (String) properties.get("user");
            passWord = (String) properties.get("passWord");
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    //获得Connection对象
    public static Connection getConnection(){
        Connection connection = null;
        try{
            Class.forName(driver);
            connection = DriverManager.getConnection(url,user,passWord);
        }catch (Exception e){
            e.printStackTrace();
        }
        return connection;
    }
    //关闭资源 -- 针对查询
    public static void close(ResultSet resultset,Statement statement,Connection connection){
        try {
            if (resultset != null) {
                resultset.close();
            }
            if (statement != null) {
                statement.close();
            }
            if (connection != null) {
                connection.close();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }
    //关闭资源 -- 针对增删改
    public static void close(Statement statement,Connection connection){
        close(null,statement,connection);
    }
    //针对DML语句--增删改
    public static boolean executeUpdate(String sql,List<Object> list){
        Connection connection = getConnection();
        PreparedStatement pre = null;
        try {
            pre = connection.prepareStatement(sql);
            for (int i = 0;i < list.size();i++){
                pre.setObject(i + 1,list.get(i));
            }
            return (pre.executeUpdate() > 0)? true : false;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(pre,connection);
        }
        return false;
    }
    //针对查DQL语句
    public static <T> List<T> executeQuery(String sql,List<Object> list,Class<T> tClass){
        Connection connection = getConnection();
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<T> li = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            for (int i = 0;i < list.size();i++){
                statement.setObject(i + 1,list.get(i));
            }
            resultSet = statement.executeQuery();
            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
            //获取列数
            int count = resultSetMetaData.getColumnCount();
            //遍历所有行
            while (resultSet.next()){
                T t = tClass.newInstance();
                for (int i = 1;i <= count;i++){
                    //获取每一列列名
                    String keyName = resultSetMetaData.getColumnLabel(i);
                    //获取每一列对应的值
                    Object value = resultSet.getObject(keyName);
                    //T中对应的属性
                    Field key = tClass.getDeclaredField(keyName);
                    key.setAccessible(true);
                    key.set(t,value);
                }
                li.add(t);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            close(connection,statement,resultSet);
        }
        return li;
    }
}
```

## 封装查询返回值遍历方式

```java
List<Map> list = JDBCUtils.executeQuery(sql,new ArrayList());
for (Map<String,Object> map : list){
    for (Map.Entry<String,Object> entry : map.entrySet()){
        String s = entry.getKey();
        Object o = entry.getValue();
        System.out.print(s + "=" + o + ",");
    }
    System.out.println();
}
```

# sql注入攻击

SQL 注入是利用某些系统没有对用户输入的数据进行充分的检查，而在 用户输入数据中注入非法的 SQL 语句段或命令，如下，从而利用系统的 SQL 引擎完成恶意行为的做法。

```sql
SELECT user, password FROM user_table WHERE user='a' OR 1 = ' AND password = ' OR '1' = '1'
```

对于 Java 而言，要防范 SQL 注入，只要用 **PreparedStatement**(**继承于Statement**) 取代 Statement 就可以了

# PreparedStatement类

1、可以通过**调用 Connection 对象的 preparedStatement() 方法**获取 PreparedStatement 对象

2、PreparedStatement 接口是 Statement 的子接口，它表示一条**预编译**过的 SQL 语句

## PreparedStatement类和Statement的比较

1、代码的可读性和可维护性

2、PreparedStatement 能最大可能提高性能

3、PreparedStatement 可以防止 SQL 注入

4、如果拼接表名、列名、关键字，必须使用Statement，防止sql语句错误

# ResultSet类

1、通过**调用 PreparedStatement 对象的 excuteQuery() 方法**创建该对象

2、代表**结果集**

3、ResultSet 返回的实际上就是一张数据表.，有一个指针指向数据表的第一条记录的前面。

# ResultSetMetaData 类

1、通过**调用ResultSet对象的getMetaData()方法**创建改对象

2、可用于**获取关于 ResultSet 对象中列的类型和属性信息的对象**

## 常用方法

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181209018.gif)

# JDBC封装Dao

**DAO (Data Access objects 数据存取对象)**是指位于业务逻辑和持久化数据之间实现对持久化数据的访问。通俗来讲，就是将数据库操作都封装起来。能够是代码的结构更加清晰化。

## DAO 模式组成

1. **DAO接口**： 把对数据库的所有操作定义成抽象方法，可以提供多种实现。
2. **DAO 实现类**： 针对不同数据库给出DAO接口定义方法的具体实现。
3. **实体类**：用于存放与传输对象数据。
4. **数据库连接和关闭工具类**： 避免了数据库连接和关闭代码的重复使用，方便修改

 

 