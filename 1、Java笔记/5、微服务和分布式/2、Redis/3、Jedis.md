# 使用步骤（Maven下使用）

## 1、pom.xml文件中导入依赖

```xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>3.3.0</version>
</dependency>
```

## 2、获取Redis对象，连接Redis

```java
//无参构造为默认ip：127.0.0.1，端口号：6379
Jedis jedis = new Jedis("127.0.0.1",6379);
```

# 对于String类型的操作

```java
Jedis jedis = new Jedis();
//清空所有数据库
jedis.flushAll();
for (int i = 0; i < 10; i++) {
    //insert
    jedis.set("key" + i,"value" + i);
}
//delete
jedis.del("key2");
//update
jedis.set("key1","vvvvv");
//findById
String s = jedis.get("key1");
System.out.println(s);
//findAll
Set<String> keys = jedis.keys("*");
Iterator<String> iterator = keys.iterator();
while (iterator.hasNext()){
    String key = iterator.next();
    String value = jedis.get(key);
    System.out.println("key:" + key + "value:" + value);
}
```

# 对于Set类型的操作

```java
Jedis jedis = new Jedis();
jedis.flushAll();
//insert
jedis.sadd("person","lucy1");
jedis.sadd("person","lucy2");
jedis.sadd("person","lucy3");
jedis.sadd("person","lucy4");
jedis.sadd("person","lucy5");
//查询key的数据量
System.out.println(jedis.scard("person"));
//delete
jedis.srem("person","lucy1");
//findAll
Set<String> person = jedis.smembers("person");
System.out.println(person);
```

# 对于Zset类型的操作

```java
Jedis jedis = new Jedis();
jedis.flushAll();
//insert,可以根据第二个参数值，进行排序
jedis.zadd("person",18,"lucy18");
jedis.zadd("person",9,"lucy9");
jedis.zadd("person",26,"lucy26");
jedis.zadd("person",4,"lucy4");
//delete
jedis.zrem("person","lucy9");
//查看key的数据量
System.out.println(jedis.zcard("person"));
//findAll
Set<String> person = jedis.zrange("person", 0, -1);
System.out.println(person);
```

# 对于List类型的操作

```java
Jedis jedis = new Jedis();
jedis.flushAll();
for (int i = 0; i < 10; i++) {
    //在后面添加
    jedis.rpush("key","value" + i);
}
for (int i = 11; i < 20; i++) {
    //在前面添加
    jedis.lpush("key","value" + i);
}
//findById
System.out.println(jedis.lindex("key", 3));
//delete
jedis.lrem("key",1,"value1");
//update
jedis.lset("key",3,"vvvvv");
//findAll
List<String> key = jedis.lrange("key", 0, -1);
System.out.println(key);
//统计该key对应的value数量
System.out.println(jedis.llen("key"));
```

# 对于Hash类型的操作

```java
Jedis jedis = new Jedis();
jedis.flushAll();
//insert
jedis.hset("person","name","lucy");
jedis.hset("person","sex","nv");
jedis.hset("person","age","18");
//update
jedis.hset("person","age","25");
//根据id获取值
System.out.println(jedis.hget("person", "age"));
//delete
jedis.hdel("person","sex");
//findAll
Map<String, String> map = jedis.hgetAll("person");
System.out.println(map);
```

# Spring-Data-Redis框架（Springboot下）

### 1、导入依赖

- 在需要使用Redis数据库的SpringBoot项目中

```xml
<!-- Spring框架提供的redis操作启动器 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

### 2、配置连接信息

application.yml文件

```yml
spring:  
  redis:
    host: 192.168.6.111   #配置Redis服务器的IP地址
    port: 6379
    password: 123456
    jedis:
      pool:
        max-active: 10    #连接池中最大连接数为10根（默认是8）
        max-wait: 2000ms  #配置连接的超时时间 -1ms代表永不超时
        min-idle: 0       #配置最小空闲数（默认是0）
        max-idle: 5       #配置最大空闲数（默认是8）
```

### 3、 配置配置类

```java
/**
 * Redis的配置类
 */
@Configuration
public class RedisConfiguration {

    @Resource
    private RedisConnectionFactory factory;

    /**
     * 配置Redis的模板操作类
     * @return
     */
    @Bean
    public RedisTemplate<String, Object> redisTemplate() {
        // 由于Redis中存储2进制的数据 ，所以我们可能需要针对k-v进行序列化设置
        RedisTemplate <String, Object> redisTemplate = new RedisTemplate<>();
        // 配置获取连接
        redisTemplate.setConnectionFactory(factory);
        // 针对key的序列化
        StringRedisSerializer keyRedisSerializer = new StringRedisSerializer();
        redisTemplate.setKeySerializer(keyRedisSerializer);
        redisTemplate.setHashKeySerializer(keyRedisSerializer);
        // 针对value的序列化
        Jackson2JsonRedisSerializer valueRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
        // 创建对象的映射
        ObjectMapper mapper = new ObjectMapper();
        // 指定需要序列化的域：field getter() 当然也可以控制访问修饰符
        mapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        valueRedisSerializer.setObjectMapper(mapper);
        redisTemplate.setValueSerializer(valueRedisSerializer);
        redisTemplate.setHashValueSerializer(valueRedisSerializer);
        // 非Spring注入，将使用下面的方法
        redisTemplate.afterPropertiesSet();
        return redisTemplate;
    }
}
```

