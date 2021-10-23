# XML

可扩展标记语言（**Extensive Markup Language**），标签中的元素名是可以自己随意写，可拓展是相对于html来说

**标记语言**：由一对尖括号括起来<内容>，就称为标记，标签；代码都是由标签组成，就称为标记语言

## 作用

- 用来当做配置文件
- xml的配置文件和properties的配置文件的选用：
  - 如果配置的是单项数据，使用properties
  - 如果配置的是多项数据，使用xml

# 语法

## 文件后缀

`.xml`

## 文档声明

**version** 是版本的意思， **encoding** 是编码集

```xml
<?xml version='1.0' encoding='utf-8'?>
```

## 注释

```xml
<!-- 注释 -->
```

## 标签

1、xml文件中有且只有一个根标签

2、标签中可以定义属性，在给属性赋值的时候，值要用引号括起来(单双都可)

3、标签名区分大小写

4、标签的闭合

- ` <aaa></aaa>`   有头有尾
- `<bbb/> `  自闭和

5、标签名的命名规则

- 可以由数字，字母，一些符号来组成
- **开头不能是数字和标点符号**
- 标签名中**不能有空格**
  - 如：`<aa a></aa a>`
- 标签名**不能是xml或者XML**
  - 如：`<xml></xml>`

# XML约束

## DTD约束

文档类型定义

### 内部引入

```xml
<!DOCTYPE books[
        <!ELEMENT books (book+)>
        <!ELEMENT book (name,price)>
        <!ELEMENT name (#PCDATA)>
        <!ELEMENT price (#PCDATA)>
        ]>
<books>
    <book>
        <name>三国</name>
        <price>386</price>
    </book>
    <book>
        <name>水浒</name>
        <price>400</price>
    </book>
</books>
```

### 外部引入(本地)

dtd文件：books.dtd

```xml
<!ELEMENT books (book+)>
<!ELEMENT book (name,price)>
<!ELEMENT name (#PCDATA)>
<!ELEMENT price (#PCDATA)>
```

引入

```xml
<!DOCTYPE books SYSTEM "books.dtd">
```

### 外部引入(网络)

```xml
<!DOCTYPE books PUBLIC "DTD名称" "DTD文档的URL">
```

# XML解析

## DOM解析

就是指先将xml文件一次性的加载进内存中，在内存中形成一个树状结构（dom树）

优点：我们可以通过dom方式的解析，对xml文件中的数据进行增删改查

缺点：如果树太大了，非常占内存空间

## SAX解析

Simple APIs for XML（简单应用程序接口）

基于事件处理的，逐行扫描，逐行加载。

优点：逐行扫描，读取一行，加载一行，加载完就扔了，不占用内存空间

缺点：执行过程不可逆，不能对数据进行增删改操作，只能进行查询操作，不能回头了

## JDOM解析

## DOM4j解析

```java
public static void main(String[] args) throws DocumentException {
    SAXReader saxReader = new SAXReader();
    //解析XML文件、获取树对象
    Document doc = saxReader.read(new File("java20210519/src/study/books.xml"));
    //获取根标签对象
    Element root = doc.getRootElement();
    //获取根元素下的子元素对象集合
    List<Element> list = root.elements();
    for (Element element : list){
        //获取该元素下的子元素name
        Element name = element.element("name");
        //获取该元素下的子元素price
        Element price = element.element("price");
        //获取name、price元素的文本信息
        System.out.println("名称：" + name.getText() + "，价格：" + price.getText());
    }
}
```

### 常用API

```java
Element对象
// 获取所有的子标签
List<Element> elements();
// 获取元素的名字
String getName();
// 获取标签内的文本内容
String getText();
// 根据标签名获取指定第一个标签对象
Element element(String name);
// 根据属性名获取属性值
String attributeValue(String name);
```

