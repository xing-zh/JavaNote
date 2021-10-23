# 关于Spring Cache

Spring Cache是作用在方法上的，其核心思想是这样的：当我们在调用一个缓存方法时会把该方法参数和返回结果作为一个键值对存放在缓存中，等到下次利用同样的参数来调用该方法时将不再执行该方法，而是直接从缓存中获取结果进行返回。所以在使用Spring Cache的时候我们要保证我们缓存的方法对于相同的方法参数要有相同的返回结果。

如果是颗粒度要求不高的项目，那么可以使用Spring Cache

## 使用Spring Cache需要我们做两方面的事

1、声明某些方法使用缓存

2、配置Spring对Cache的支持

* 和Spring对事务管理的支持一样，Spring对Cache的支持也有基于注解和基于XML配置两种方式。

# 使用方式一：基于Spring自带的缓存工具

1、在启动类上添加注解

```java
@EnableCaching
```

2、在需要缓存结果的方法上，添加注解`@Cacheable("value")`

```java
@Cacheable("cache1")//Cache是发生在cache1上的
@GetMapping("/find")
public User find() {
    System.out.println("into find");
    User user = new User(1,"zfs","ljh");
    return user;
}
```

此方法，如果项目重启，那么缓存就会丢失

# 使用方式二：基于Redis进行缓存（推荐）

1、需要在spring配置yml文件中添加节点

```yaml
spring:
  cache:
    type: redis
```

2、在maven配置文件pom.xml中，引入spring-redis依赖，这个时候，缓存就成功地切换到Redis上了

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

# 关键注解

## @Cacheable

此注解，可以标记在方法上，也可以标记在类上，当标记在一个方法上时表示该方法是支持缓存的，当标记在一个类上时则表示该类所有的方法都是支持缓存的。

```java
@Cacheable("cache1")//Cache是发生在cache1上的
public User find(Integer id) {
    return null;
}
```

### key属性

这个时候，保存在Redis数据库中的key，格式为

`value::key`

```java
@Cacheable(value="users", key="#id")
public Userinfo find(Integer id) {
    return new Userinfo(id,"刘德华","张曼玉");
}
@Cacheable(value="users")
public List findAll() {
    return new ArrayList();
}
@Cacheable(value="users", key="#p0")//代表方法的第一个形参
public Userinfo find(Integer id) {
    return new Userinfo(id,"刘德华","张曼玉");
}
@Cacheable(value="users", key="#info.uid")
public Userinfo find(Userinfo info) {
    return new Userinfo(info.getUid(),"刘德华","张曼玉");
}
@Cacheable(value="users", key="#p0.uid")
public Userinfo find(Userinfo info) {
    return new Userinfo(info.getUid(),"刘德华","张曼玉");
}
```

### condition属性

此时，只有在condition值为true的情况下，再会执行缓存

```java
@Cacheable(value="users", key="#p0.uid",condition="#info.uid%2==0")
public Userinfo find(Userinfo info) {
    return new Userinfo(info.getUid(),"刘德华","张曼玉");
}
```

## @CachePut

此注解标注的方法在执行前不会去检查缓存中是否存在之前执行过的结果，而是**每次都会执行该方法，并将执行结果以键值对的形式存入指定的缓存中，因此建议使用在数据库的修改方法上**

```java
@CachePut(value="users", key="#p0.uid")
public Userinfo updata(Userinfo info) {
    return new Userinfo(info.getUid(),"刘德华","张曼玉");
}
```

## @CacheEvict

此注解是用来标注在需要清除缓存元素的方法或类上的。当标记在一个类上时表示其中所有的方法的执行都会触发缓存的清除操作，因此，**建议使用在数据库的删除方法上**

```java
@CacheEvict(value="users", key="#p0.uid")
public Userinfo delete(Userinfo info) {
    return new Userinfo(info.getUid(),"刘德华","张曼玉");
}
```

### allEntries属性

由于，findAll方法和findById方法，所产生的的缓存，可能key会不同，所以，只使用CacheEvict注解，可能会导致，findAll的缓存无法清除，所以，需要加上allEntries属性，那么就会清除所有的以value="users"所产生的注解

```java
@CacheEvict(value="users", key="#p0.uid",allEntries=true)
public Userinfo delete(Userinfo info) {
    return new Userinfo(info.getUid(),"刘德华","张曼玉");
}
```



