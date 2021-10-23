# 使用方法

可以在编译时，自动添加Javabean的结构，例如，getter、setter、构造器、tostring

1、导入依赖

```xml
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
</dependency>
```

2、使用注解，添加需要的结构

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Student {
    private Integer sno;
    private String sname;
    private String ssex;
    private Integer sage;
}
```

# 常用注解

**@Data**：该注解定义在JavaBean上，给JavaBean产生getter()，setter()，无参构造器，tostring()，hashcode()，equals()

**@NoArgsConstructor**：产生无参构造器

**@Getter**：产生getter()

**@Setter**：产生setter()

**@ToString**：产生toString()

**@RequiredArgsConstructor + @NonNull**：可以用来定义有参构造器

**@AllArgsConstructor**：产生全属性的有参构造

 