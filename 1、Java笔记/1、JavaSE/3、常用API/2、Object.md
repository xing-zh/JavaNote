**java.lang.Object**

# 常用方法

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181156034.jpg)

* **Object类是所Java类的根父类**
* 如果在类的声明中未使用extends关键字指明其父类，则默认父类为java.lang.Object类
* Object类中的功能(属性、方法)就具通用性。
* 属性：无
* 方法：equals() / toString() / getClass() /hashCode() / clone() / finalize() / wait() / notify() / notifyAll()
* Object类只声明了一个空参的构造器

# equals()方法

* 是一个方法，而非运算符
* 只能适用于引用数据类型
* Object类中equals()的定义：
  * `public boolean equals(Object obj) {  return (this == obj);   }`
* 说明：Object类中定义的equals()和==的作用是相同的：比较两个对象的地址值是否相同.即两个引用是否指向同一个对象实体
* 像String、Date、File、包装类等都重写了Object类中的equals()方法。重写以后，比较的不是两个引用的地址是否相同，==而是比较两个对象的"实体内容"是否相同==。
* 通常情况下，我们自定义的类如果使用equals()的话，也通常是比较两个对象的"实体内容"是否相同。那么，我们就需要对Object类中的equals()进行重写.
* 重写的原则：比较两个对象的实体内容是否相同.
* 如果equals方法比较两个对象返回为true，那么两个对象的hashcode一定相同
* 如果equals方法比较两个对象返回为false，那么两个对象的hashcode不一定不相同

## ==和equals的区别

1. == 既可以比较基本类型也可以比较引用类型。对于基本类型就是比较值，对于引用类型 就是比较内存地址
2. equals的话，它是属于java.lang.Object类里面的方法，如果该方法没有被重写过默认也 是==;我们可以看到String等类的equals方法是被重写过的，而且String类在日常开发中 用的比较多，久而久之，形成了equals是比较值的错误观点。
3. 具体要看自定义类里有没有重写Object的equals方法来判断。
4. 通常情况下，重写equals方法，会比较类中的相应属性是否都相等。

# hashCode方法

![说明: untitle.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181156946.jpg)

# 重写equals和hashCode方法

```java
public class User {
    public String id;
    public String name;
    public int age;
    @Override
    public boolean equals(Object obj) {
        if(this == obj){
            return true;//地址相等
        }
        if(obj == null){
            return false;//非空性检查
        }
        if(obj instanceof User){
            User other = (User) obj;
            //需要比较的字段相等，则这两个对象相等
            if(this.name.equals(other.name) && this.age == other.age){
                return true;
            }
        }
        return false;
    }
    @Override
    public int hashCode() {
        int result = 17;
        result = 31 * result + (name == null ? 0 : name.hashCode());
        result = 31 * result + (age == null ? 0 : age.hashCode());
        return result;
    }
}
```



 