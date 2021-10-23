# Mybatis

1. MyBatis 本是apache的一个开源项目iBatis, 2010年这个项目由apache software foundation迁移到了google code，并且改名为MyBatis 。2013年11月迁移到Github。
2. iBATIS一词来源于“internet”和“abatis”的组合，是一个基于Java的持久层框架。
3. iBATIS提供的持久层框架包括SQL Maps和Data Access Objects（DAO）
4. 基于ORM（对象关系映射）思想的一个框架
5. MyBatis 是支持定制化SQL、存储过程以及高级映射的优秀的持久层框架。MyBatis 避免了几乎所有的 JDBC 代码和手动设置参数以及获取结果集。MyBatis 可以对配置和原生Map使用简单的 XML 或注解，将接口和 Java 的 POJOs(Plain Old Java Objects,普通的 Java对象)映射成数据库中的记录。

## 使用Java操作数据库的方法

1. 最原始的形式：JDBC
2. 升级版：JdbcTemplate，只能算是JDBC的工具类
3. 升级版：MyBatis，一个框架

## 框架

通俗来讲，就是半成品软件，里面提供了一些代码，剩下的一部分我们自己来实现

## 优点

* **简单易学**：本身就很小且简单。没有任何第三方依赖，最简单安装只要两个jar文件+配置几个sql映射文件；易于学习，易于使用，通过文档和源代码，可以比较完全的掌握它的设计思路和实现
* **灵活**：mybatis不会对应用程序或者数据库的现有设计强加任何影响。 sql写在xml里，便于统一管理和优化。通过sql语句可以满足操作数据库的所有需求
* **解除sql与程序代码的耦合**：通过提供DAO层，将业务逻辑和数据访问逻辑分离，使系统的设计更清晰，更易维护，更易单元测试。sql和代码的分离，提高了可维护性
* **提供映射标签**，支持对象与数据库的orm字段关系映射
* **提供对象关系映射标签**，支持对象关系组建维护
* **提供xml标签**，支持编写动态sql

## 缺点

* **编写sql语句工作量大**，尤其字段多，关联表多
* **sql语句依赖于数据库**，导致数据库一致性差，不可以更换数据库
* **框架还是比较简陋，功能尚有缺失**，虽然简化了数据绑定代码，但是整个底层数据库查询实际还是要自己写，工作量大，而且不太容易适应快速数据库修改
* **二级缓存机制不佳**

# 使用

## 1、在[官网](https://blog.mybatis.org/)下载MyBatis的jar文件

## 2、导入jar文件到工程中

## 3、根据表创建实体类，放在entity包下

## 4、编写MyBatis核心配置文件（mybatis-config.xml），放置在src同级的sources文件夹

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <settings>
        <setting name="logImpl" value="STDOUT_LOGGING"/>
    </settings>
    <!--配置环境的一个节点，可以包含多个环境，default属性值为使用哪个环境节点配置-->
    <environments default="development">
        <!--一个环境节点的配置-->
        <environment id="development">
            <!--事务管理器-->
            <transactionManager type="JDBC"/>
            <!--数据源，type：使用的连接池-->
            <dataSource type="POOLED">
                <property name="driver" value="${driver}"/>
                <property name="url" value="${url}"/>
                <property name="username" value="${username}"/>
                <property name="password" value="${password}"/>
            </dataSource>    
        </environment>
    </environments>
    <!--管理sql映射文件-->
    <mappers>
        <mapper resource="xml映射文件路径"/>
        <mapper class="包名.接口名"/>
    </mappers>
</configuration>
```

## 5、编写对应的接口，放置在dao包下

```java
public interface GoodTypeDaoMapper {
    GoodType findById();
    boolean addOne(GoodType goodType);
}
```

## 6、在xml映射文件中，编写sql语句，放置在dao包中

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!--namespace用于区别不同映射文件的SQL语句，必须是唯一的，一般是对应包名.接口名-->
<mapper namespace="包名.接口名">
    <!--id作为SQL语句的唯一标识，对应接口中的方法名-->
    <!--增删改没有resultType属性-->
    <!--#{xx}:xx为对应对象的属性名-->
    <insert id="addOne">
        insert into goodtype (tid,tname,state,remarks) values (#{tid},#{tname},#{state},#{remarks})
    </insert>
    <update id=""></update>
    <delete id=""></delete>
    <!--parameterTtpe：参数的类型，如果只有一个参数，可以省略-->
    <!--resultType：返回对象的类全名-->
    <select id="findById" parameterTtpe="int" resultType="GoodType">
        select * from goodtype where id = #{id}
    </select>
    
</mapper>
```

## 7、进行使用

```java
public static void main(String[] args) throws Exception {
    //核心配置文件路径，获得输入流
    String resource = "mybatis-config.xml";
    InputStream inputStream = Resources.getResourceAsStream(resource);
    //由mybatis读核心配置文件,将读到的的信息缓存在SqlSessionFactory工厂对象中
    SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);

    //从工厂中获取SqlSession对象，该对象可以和数据库进行交互
    SqlSession sqlSession = sqlSessionFactory.openSession();

    //获得代理类的对象
    GoodTypeDaoMapper goodTypeDaoMapper = sqlSession.getMapper(GoodTypeDaoMapper.class);

    //调用代理类中的查找方法
    GoodType byId = goodTypeDaoMapper.findById();
    System.out.println(byId);
    
    //调用代理类中的查找方法，返回值为boolean类型
    //操作完成后需要调用SqlSession中的commit()方法进行事务提交
    boolean isAdd = goodTypeDaoMapper.addOne(new GoodType("小小说",1,"好看"));
    sqlSession.commit();
    System.out.println(isAdd);
    
    
    //关闭资源--和数据库连接的
    sqlSession.close();
}
```

## 三种使用方式

### 方式一

1、**在xml映射文件中编写sql语句**，其中namespace属性作为唯一标识，一般为（包名.该文件名不加后缀）

2、然后在核心配置文件mappers标签中，注册xml映射文件，格式为：`<mapper resource="xml映射文件路径"/>`

3、调用时，通过SqlSession对象调用对应的例如selectOne()方法，格式为：`sqlSession.selectOne("namespace.SQL语句标签id")`

### 方式二（常用）

1、**在xml映射文件中编写sql语句**，其中namespace属性作为唯一标识，一般为（包名.接口名），其中在mapper标签中编写SQL语句的标签，id为对应接口的方法名

2、编写sql语句对应的接口，其中，方法名要对应id，返回值类型要对应resultType

3、然后在核心配置文件mappers标签中，注册xml映射文件，格式为：`<mapper resource="xml映射文件路径"/>`或`<mapper class="包名.接口名"/>`

4、调用时，通过SqlSession对象调用getManager()方法，格式为：`sqlSession.getMapper(对应接口名.class)`，获得代理类对象

5、通过代理类对象，调用接口中的方法

### 方式三（适合少量的SQL语句）

1、无需使用xml映射文件，**在接口中，编写方法**

2、在方法上，加入注解，例如`@select("SQL语句")`

3、然后在核心配置文件mappers标签中，注册接口，格式为：`<mapper class="包名.接口名"/>`

4、调用时，通过SqlSession对象调用getManager()方法，格式为：`sqlSession.getMapper(对应接口名.class)`，获得代理类对象

5、通过代理类对象，调用接口中的方法

## 参数处理方式

### 单参数

```java
//接口
GoodType findById(int id);
```

```xml
<!--xml映射文件-->
<select id="findById">
    select * from goodtype where id=#{id}
</select>
```

### 多参数

#### 方式一：通过在xml映射文件标签中参数以`arg0-argn`的方式

```java
//接口
boolean update1(String name,int id);
```

```xml
<!--xml映射文件-->
<update id="update1">
    update goodbyte set tname=#{arg0} where id=#{arg1}
</update>
```

#### 方式二：通过在xml映射文件标签中参数以`param1-paramn`的方式

```java
//接口
boolean update2(String name,int id);
```

```xml
<!--xml映射文件-->
<update id="update2">
    update goodbyte set tname=#{param1} where id=#{param2}
</update>
```

#### 方式三：采用在接口形参前添加注解`@Param`的方式

```java
//接口
boolean update3(@Param("name")String name,@Param("id")int id);
```

```xml
<!--xml映射文件-->
<update id="update3">
    update goodbyte set tname=#{name} where id=#{id}
</update>
```

#### 方式四：如果多个参数是同一个自定义对象的属性，使用对象

```java
//接口
boolean update4(GoodType goodType);
```

```xml
<!--xml映射文件，#{xx}：xx为属性名-->
<update id="update4">
    update goodbyte set tname=#{tname} where id=#{tid}
</update>
```

#### 方式五：使用Map集合的方式

缺点是，在编写sql语句的时候，无法确定map集合的key

```java
//接口
boolean update5(Map<String,Object> map);
```

```xml
<!--xml映射文件,#{xx}：xx为map集合中对应的key-->
<update id="update5">
    update goodbyte set tname=#{key1} where id=#{key2}
</update>
```

# MyBatis执行过程

<img src="https://gitee.com/yh-gh/img-bed/raw/master/202109181327267.jpg" alt="说明: MyBatis执行流程图解.png"  />

# 核心配置文件相关配置

## 节点写入顺序

properties--settings--typeAliases--typeHandlers--objectFactory--objectWrapperFactory--reflectorFactory--plugins--environments--databaseIdProvider--mappers

## 加载Properties配置文件

在mybatis核心配置文件中写入

```xml
<properties resource="jdbc.properties"/>
<dataSource type="POOLED">
    <property name="driver" value="${jdbc.driver}"/>
    <property name="url" value="${jdbc.url}"/>
    <property name="username" value="${jdbc.username}"/>
    <property name="password" value="${jdbc.password}"/>
</dataSource>
```

## 日志

```xml
<setting name="logImpl" value="STDOUT_LOGGING"/>
```

## 别名

起的别名，可以在整个mybatis下使用

### 方式一

```xml
<typeAliases>
    <!--单个实体类起别名-->
    <!--type:代表类的全名，alias:代表别名-->
    <typeAlias type="entity.GoodType" alias="type"/>
    <!--给指定包下的实体类批量起别名,使用的时候只需要写类名就可以-->
    <!--name:代表包名-->
    <package name="entity">
</typeAliases>
```

### 方式二

可以在对应的实体类上添加注解`@Alias("别名")`的方式进行起别名,需要在核心配置文件中，给该包下批量起别名

# MaBatis中的标签

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181327325.gif)

# MyBatis加载

MyBatis根据对关联对象查询的select语句的执行时机，分为三种类型：直接加载（默认）、侵入式延迟加载、深度延迟加载。

## 懒加载（延迟加载）

**就是按需加载**，我们需要什么的时候再去进行什么操作。而且先从单表查询，需要时再从关联表去关联查询，能大大提高数据库性能，因为查询单表要比关联查询多张表速度要快。

### 要求

1、必须是分布查询

2、关联关系使用association（对一）或collection（对多）

### 侵入式延迟加载

执行主加载对象的查询时，不会执行对关联对象的查询，只有在访问主加载对象详情时或关联对象详情时，才会执行关联对象的查询

```xml
<!--在setting节点中加入-->
<setting name="lazyLoadingEnabled" value="true"/>
<setting name="aggressiveLazyLoading" value="true"/>
```

### 深度延迟加载（推荐）

执行主加载对象的查询时，不会执行对关联对象的查询，访问主加载对象详情时也不会执行对关联对象的查询，只有在访问关联对象的详情时，才会执行关联对象的查询

```xml
<!--在setting节点中加入-->
<setting name="lazyLoadingEnabled" value="true"/>
<setting name="aggressiveLazyLoading" value="false"/>
```

### 开启延迟

（可选）在`<association>`或`<collection>`中添加**fetchType = "lazy"**属性开启延迟，但这里==默认为开启==，可以不加

# 缓存

引入缓存之后，第一次去查询数据库，第二次以后，如果数据库的数据没有发生改变，我们就不去查询数据库，我们查缓存。使用缓存之后，就减少了查询数据库的次数，从而提高了查询效率

mybatis中的缓存可以分为一级缓存和二级缓存

## 哪些数据使用放在缓存中，哪些数据不适合放在缓存中

1）不频繁更新的数据可以放在缓存中，频繁发生更新的数据，不要放在缓存中

2）财务数据不要放在缓存中，不要的数据可以放在缓存中

## 一级缓存

一级缓存mybatis自带，不要额外配置，属于sqlSession级别的缓存（和SqlSession相关的），默认开启

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181327909.gif)

### 验证

```java
Goods find1 = goodsDaoMapper.findByGid(1);
System.out.println(find1.getDname());
System.out.println("**********************************");
Goods find2 = goodsDaoMapper.findByGid(1);
System.out.println(find2.getDname());
```

**结果日志**

```java
Logging initialized using 'class org.apache.ibatis.logging.stdout.StdOutImpl' adapter.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
Opening JDBC Connection
Created connection 798244209.
Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@2f943d71]
==>  Preparing: select * from goods where gid=? 
==> Parameters: 1(Integer)
<==    Columns: gid, dname, buyprice, saleprice, remarks, tid, picPath, quantity, state
<==        Row: 1, java, 50, 80, 11111, 1, img/1.jpg, 1000, 1
<==      Total: 1
java
**********************************
java
Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@2f943d71]
Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@2f943d71]
Returned connection 798244209 to pool.
```

两次相同的查询，只向数据库发送了一次SQL语句，说明，第二次查询是从缓存中查询，并不是从数据库查询

### 一级缓存失效

#### 情况一

第一次查询的数据和第二次查询的数据不一样

#### 情况二

如果查询的是同样的数据，调用了更新方法（增删改DML）的方法

#### 情况三

调用了刷新方法

`sqlSession.clearCache();`

#### 情况四

SqlSession对象不一样

#### 情况五

（select标签中）flushCache="true"属性

## 二级缓存

如果系统需要二级缓存，那么需要人为配置，二级别缓存属于Mapper级别、SqlSessionFactory级别的缓存

将查询出的数据保存在二级缓存中需要通过调用==sqlSession的commit方法==才可以进行保存在二级缓存

主要用来解决一级缓存不能跨会话（SqlSession）共享的问题，范围是namespace 级别的，可以被多个SqlSession 共享（只要是同一个接口里面的相同方法，都可以共享），生命周期和应用同步

如果你的MyBatis使用了二级缓存，并且你的Mapper和select语句也配置使用了二级缓存，那么在执行select查询的时候，MyBatis会先从二级缓存中取输入，其次才是一级缓存，即MyBatis查询数据的顺序是：==二级缓存 —> 一级缓存 —> 数据库。==

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181327908.gif)

### 配置二级缓存的步骤

1、在核心配置文件的`<setting>`节点中添加

```xml
<setting name="cacheEnabled" value="true"></setting>
```

2、在xml映射文件中，配置

```xml
<!--
可选属性：
type="哪种缓存机制"
size="缓存的资源数量"
eviction="缓存回收策略"
flushInterval="刷新的间隔"
readOnly="只读true\false"
    true:会给所有的查询的用户，返回同一个的java对象
    false:会给每一个查询的用户，返回同一个java对象的克隆的副本，也就是不同的对象
-->
<cache></cache>
```

3、封装类实现序列化接口java.io.Serializable

### 要求

1、二级缓存是将对象通过序列化流存储到磁盘文件，需要封装类实现序列化，如果是多表联合查询，那么关联表对应的实体类也需要序列化

2、两个SqlSession对象必须是同一个SqlSessionFactory创建

### 验证

```java
SqlSession sqlSession1 = factory.openSession();
SqlSession sqlSession2 = factory.openSession();
GoodsDaoMapper mapper1 = sqlSession1.getMapper(GoodsDaoMapper.class);
GoodsDaoMapper mapper2 = sqlSession2.getMapper(GoodsDaoMapper.class);
Goods byGid1 = mapper1.findByGid(1);
System.out.println(byGid1.getDname());
sqlSession1.commit();
System.out.println("***********************************");
Goods byGid2 = mapper2.findByGid(1);
System.out.println(byGid2.getDname());
sqlSession1.close();
sqlSession2.close();
```

**结果日志**

```java
Logging initialized using 'class org.apache.ibatis.logging.stdout.StdOutImpl' adapter.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
PooledDataSource forcefully closed/removed all connections.
Cache Hit Ratio [dao.GoodsDaoMapper]: 0.0
Opening JDBC Connection
Created connection 1297149880.
Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@4d50efb8]
==>  Preparing: select * from goods where gid=? 
==> Parameters: 1(Integer)
<==    Columns: gid, dname, buyprice, saleprice, remarks, tid, picPath, quantity, state
<==        Row: 1, java, 50, 80, 11111, 1, img/1.jpg, 1000, 1
<==      Total: 1
java
***********************************
Cache Hit Ratio [dao.GoodsDaoMapper]: 0.5
java
Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@4d50efb8]
Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@4d50efb8]
Returned connection 1297149880 to pool.
```

同一SqlSessionFactory对象，所产生的不同的SqlSession对象，也可以共享缓存

# 缓存穿透

缓存穿透是指缓存和数据库中都没有的数据，而用户不断发起请求，如发起为id为“-1”的数据或id为特别大不存在的数据查询。这时的用户很可能是攻击者，攻击会导致数据库压力过大。

## 解决方法

1、使用Redis替换mybatis缓存，即使查询出来的数据为null，也会存入缓存

2、使用布隆过滤器，对一些不存在的条件进行过滤

# 缓存击穿

缓存击穿是指缓存中没有但数据库中有的数据（一般是缓存时间到期），这时由于并发用户特别多，同时读缓存没读到数据，又同时去数据库去取数据，引起数据库压力瞬间增大，造成过大压力

## 解决方法

1、设置热点数据缓存永不过期

2、利用代理或装饰模式，对mybatis源码进行切入，对数据库查询进行加锁

3、使用mybatis的拦截器，对源码中的query方法进行加锁

# 缓存雪崩

缓存雪崩是指缓存中数据大批量到过期时间，而查询数据量巨大，引起数据库压力过大甚至down机。和缓存击穿不同的是， 缓存击穿指并发查同一条数据，缓存雪崩是不同数据都过期了，很多数据都查不到从而查数据库。

## 解决方法

1、缓存数据的过期时间设置随机，防止同一时间大量数据过期现象发生。

2、如果缓存数据库是分布式部署，将热点数据均匀分布在不同的缓存数据库中。

3、设置热点数据永远不过期