# JSON

JSON（**JavaScript Object Notation**，JS对象简谱）是一种轻量级的数据交换格式。它基于 ECMAScript（欧洲计算机协会制定的js规范）的一个子集，采用完全独立于编程语言的文本格式来存储和表示数据。简洁和清晰的层次结构使得 JSON 成为理想的数据交换语言。易于人阅读和编写，同时也易于机器解析和生成，并有效地提升网络传输效率。

json是一个序列化的对象（数组），一种特殊格式的字符串

## 作用

用来传输数据

## 语法规范

### 构造字符

`{ [ ] } : ,`

### JSON的值

==值可以是，对象、数组、数字、字符串、或三个字面值（false、null、true）==

### 对象

```jso
{"key1":value1,"key2":value2}
```

### 数组

```json
[value1,value2,value3]
```

#### 或对象数组

```json
[{"key":value},{"key1":value1,"key2":value2}]
```

# JSON和JS对象的互转

## JSON-->JS

```js
var jsObj = JSON.parse(json);
```

## JS-->JSON

```js
var json = JSON.stringify(jsObj);
```

# JSON和JAVA对象的互转

## 常见的JSON解析器

fastjson，jackson

## Fastjson

==需要导入jar包==

如果对象中属性为null，则不转化

### JAVA-->JSON字符串

```java
String json = JSON.toJSONString(javaObject);
```

### JSON字符串-->JAVA

**需要该类具有无参构造器**

```java
Person newPerson = JSON.parseObject(jsonString, Person.class);
```

### List集合-->JSON数组对象

```java
JSONArray jsonArray = (JSONArray)JSON.toJSON(list);
```

# JSON输出格式化

## Date类型格式化

在需要格式化的实体类属性上，添加注解

```java
@JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
private Date lastReadDay;
```

## Double类型格式化

### 1、编写自定义格式化类

```java
//修改JsonSerializer<Double> 到需要的类型,默认为JsonSerializer，参数为Object value
public class JsonSerializerUtils extends JsonSerializer<Double> {
    @Override
    public void serialize(Double value, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException {
        if (Objects.nonNull(value)) {
            //保留2位小数#代表末位是0舍去
            DecimalFormat decimalFormat = new DecimalFormat("0.##");
            //四舍五入
            decimalFormat.setRoundingMode(RoundingMode.HALF_UP);
            String result = decimalFormat.format(value);
            jsonGenerator.writeNumber(Double.valueOf(result));
        } else {
            jsonGenerator.writeNumber(Double.valueOf(0));
        }
    }
}
```

### 2、在需要进行格式化的实体类属性上添加注解

```java
@JsonSerialize(using = JsonSerializerUtils.class)
private Double waterPrice;
```



