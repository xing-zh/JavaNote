# Mybatis二级缓存存在的问题

1、Mybatis自带的二级缓存是对当前容器而言的，存储在一个map集合对象中，如果容器重启，那么会导致缓存丢失

2、Mybatis自带的二级缓存不支持分布式以及集群

## PerpetualCache

这个类就是mybatis二级缓存使用的类

```java
//对应表的mapper标签
<mapper namespace="com.woniu.mybatiscache.mapper.BookMapper" >

//PerpetualCache就是Mybatis的二级缓存的源码
//自带的二级缓存就是存在这个map集合中
private final Map<Object, Object> cache = new HashMap();
//当使用二级缓存时，这个对象创建，会将namespace的值注入
public PerpetualCache(String id) {
    this.id = id;  //这个id就是你的namespace的命名空间
}

public void putObject(Object key, Object value) {
    this.cache.put(key, value);
    //key就是你当前的SQL和SQL的参数  value就是当前SQL执行后的结果
}

public void clear() {
    this.cache.clear();
}

//当你在操作表执行insert update delete的时候，都会引发clear方法的调用，把map清空了。
//你做delete update insert的时候，会清空当前命名空间下的所有缓存。为了避免脏读。
```

# 使用Redis作为Mybatis二级缓存容器

![说明: 625093701136.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181347638.gif)

## 优点

可以实现分布式，以及集群，解决了mybatis二级缓存在启动容器时丢失

# 实现方式

## 1、使用RedisTempalte（推荐）

RedisTempalte是Spring容器已经给我们提供好的一个类。受Spring容器的管理。对象也是Spring生的。不用来管Redis的连接和关闭。因为他采用了AOP的机制。

### 1）添加依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
    <version>2.2.6.RELEASE</version>
</dependency>
```

### 2）配置redis

```yml
spring:
  redis:
    host: localhost
    port: 6379
```

### 3）写好dao以及entity，并在mapper.xml文件中开启二级缓存，type自定缓存

entity

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
//实体类必须实现序列化接口
public class Student implements Serializable {
    private Integer sno;
    private String sname;
    private String ssex;
    private Integer sage;
}
```

dao

```java
public interface StudentMapper {

    public Student findBySno(Integer sno);
}
```

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.woniuxy.cache0625.dao.StudentMapper">
    <!--开启二级缓存，type属性为自定义缓存类的全类名-->
    <cache type="com.woniuxy.cache0625.cache.MyCache"></cache>
    <resultMap id="findResult" type="com.woniuxy.cache0625.entity.Student">
        <result property="sno" column="sno"></result>
        <result property="sname" column="sname"></result>
        <result property="ssex" column="ssex"></result>
        <result property="sage" column="sage"></result>
    </resultMap>
    <select id="findBySno" resultMap="findResult">
        select
        `sno`,
        `sname`,
        `ssex`,
        `sage`
        from `stu`.`student`
        where sno=#{sno}
    </select>
</mapper>
```

### 4）创建一个工具类，用来获取ApplicationContext对象

由于自定义缓存类MybatisCache是由Mybatis实例，所以无法在里面使用@Autowired进行创建RedisTemplate实例

注意：要保证该类比MybatisCache先被加载

```java
@Component
//ApplicationContextAware是Spring容器提供的接口类
//这个接口类的方法setApplicationContext，每次在项目启动的时候，会自动调用
public class MyApplicationContext implements ApplicationContextAware {
    public static ApplicationContext context;
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        context = applicationContext;
    }
}
```

### 5）创建自定义缓存类，实现Cache接口，重写相关方法

```java
public class MyBatisCache implements Cache {
    private RedisTemplate redisTemplate;
    private String id;
    private ReadWriteLock readWriteLock;
    public MyBatisCache(String id){
        //获取namespace的值
        this.id = id;
        //获取RedisTemplate对象
        redisTemplate = (RedisTemplate) MyApplicationContext.context.getBean("redisTemplate");
        //创建读写锁
        readWriteLock = new ReentrantReadWriteLock();
    }
    @Override
    public String getId() {
        return id;
    }

    @Override
    public void putObject(Object key, Object value) {
        readWriteLock.writeLock().lock();
        try {
            redisTemplate.opsForHash().put(id,key,value);
            //设置过期时间，10分钟
            redisTemplate.expire(key,10L, TimeUnit.MINUTES);
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            readWriteLock.writeLock().unlock();
        }
    }

    @Override
    public Object getObject(Object key) {
        readWriteLock.readLock().lock();
        Object o = null;
        try {
            o = redisTemplate.opsForHash().get(id,key);
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            readWriteLock.readLock().unlock();
        }
        return o;
    }

    @Override
    public Object removeObject(Object key) {
        readWriteLock.writeLock().lock();
        Object o = null;
        try {
            o = redisTemplate.opsForHash().delete(id,key);
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            readWriteLock.writeLock().unlock();
        }
        return o;
    }

    @Override
    public void clear() {
        readWriteLock.writeLock().lock();
        try {
            redisTemplate.delete(id);
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            readWriteLock.writeLock().unlock();
        }
    }

    @Override
    public int getSize() {
        return Math.toIntExact(redisTemplate.opsForHash().size(id));
    }

    @Override
    public ReadWriteLock getReadWriteLock() {
        return this.readWriteLock;
    }
}
```

### 6）进行测试，会将查询结果缓存在redis数据库中

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181347211.gif)

## 2、利用对象流&字节数组流存入redis

其余步骤与方式一相同，但不需要获取ApplicationContext对象，需要写IOUTil工具类

### 1）IOUTil工具类

```java
public class IOUtil {
    public static byte[] getByte(Object o){
        ByteArrayOutputStream byteArrayOutputStream = null;
        ObjectOutputStream objectOutputStream = null;
        byte[] byteArray = null;
        try {
            byteArrayOutputStream = new ByteArrayOutputStream();
            objectOutputStream = new ObjectOutputStream(byteArrayOutputStream);
            objectOutputStream.writeObject(o);
            byteArray = byteArrayOutputStream.toByteArray();
            objectOutputStream.flush();
            byteArrayOutputStream.flush();
            objectOutputStream.close();
            byteArrayOutputStream.close();
        }catch (Exception e){
            e.printStackTrace();
        }
        return byteArray;
    }
    public static Object getObject(byte[] bytes){
        ByteArrayInputStream byteArrayInputStream = null;
        ObjectInputStream objectInputStream = null;
        Object o = null;
        try {
            byteArrayInputStream = new ByteArrayInputStream(bytes);
            objectInputStream = new ObjectInputStream(byteArrayInputStream);
            o = objectInputStream.readObject();
            objectInputStream.close();
            byteArrayInputStream.close();
        }catch (Exception e){
            e.printStackTrace();
        }
        return o;
    }
}
```

### 2）自定义缓存类

```java
public class MyCache1 implements Cache {
    private Jedis jedis = new Jedis();
    private String id;
    private byte[] idByte;
    public MyCache1(String id){
        this.id = id;
        idByte = IOUtil.getByte(id);
    }
    @Override
    public String getId() {
        return id;
    }

    @Override
    public void putObject(Object key, Object value) {
        byte[] keyByte = IOUtil.getByte(key);
        byte[] valueByte = IOUtil.getByte(value);
        jedis.hset(idByte,keyByte,valueByte);
    }

    @Override
    public Object getObject(Object key) {
        byte[] keyByte = IOUtil.getByte(key);
        byte[] valueByte = jedis.hget(idByte, keyByte);
        if(valueByte == null){
            return null;
        }
        Object object = IOUtil.getObject(valueByte);
        return object;
    }

    @Override
    public Object removeObject(Object key) {
        byte[] keyByte = IOUtil.getByte(key);
        Long num = jedis.hdel(idByte, keyByte);
        return num == 0?false:true;
    }

    @Override
    public void clear() {
        jedis.del(idByte);
    }

    @Override
    public int getSize() {
        Map<byte[], byte[]> map = jedis.hgetAll(idByte);
        return map.size();
    }
}
```



