# JavaScript

JavaScript（简称“JS”）是一种具有函数优先的轻量级，解释型或即时编译型的高级编程语言，弱类型，脚本语言

## 三大部分

**核心（ECMAScript）**：语法、类型、语句、关键字等

**文档对象模型（DOM）**：专门用于完成网页之间的交互

**浏览器对象模型（BOM）**：主要用于对浏览器窗口进行操作

# 运行过程

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181412630.gif)

# 使用方式

1、在html文件中的**`<script></script>`**标签中直接编写

- script标签可以写多个
- script标签可以出现在任意位置

2、在js文件中编写，在HTML文件中引用

```html
<script src="Script文件地址"></script>
```

# ECMAScript

## 数据类型

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181412003.gif)

### 数组

```js
/*定义数组*/
var a = new Array();
//或
var a = [1,"lucy"];
/*数组索引操作*/
a[0] = 12;
a[1] = "lucy";
document.write(a[0] + "," + a[1]);
```

允许存放不同的数据类型，但是一般存放统一的数据类型

数组元素没有存放的位置，默认值undefined

#### 常用方法

```js
a.length(); //数组长度
a.push(); //往数组尾部添加元素，类似与进栈
a.pop(); //取值数组最后一个元素，并且移除该元素，类似与出栈
```

### 对象

```js
/* 声明对象 */
var student = {name:"lucy",age:12,sex:"男"};
/*对象属性赋值*/
student.age = 15;
/*使用对象的属性,对象名.属性*/
document.write(student.name + "," + student.age + "," + student.sex);
```

**变量**

JavaScript使用**var、let**关键字定义变量

```js
var 变量名 = 值;
let 变量名 = 值;
```

变量名称对大小写敏感

## 注释

- 单行注释：`//`
- 多行注释：`/* ... */`

## 运算符

### 算数运算符

**除法**和java不一样，数/数 = 数学结果，`1 / 2 = 0.5`

其余运算符与java中一致

### 关系运算符

`==`：只比较值是否相等，和类型无关（基本数据类型）

`===`：绝对等于（值和类型都相等）

`!=`：只比较值是否不相等，和类型无关（基本数据类型）

`!==`：绝对不等于（值和类型都不相等）

### 逻辑运算符

`&、|`的结果为数值0（false）、1（true）

其余运算符和java相似

## 函数

函数可以将一些代码放置在一起，形成一个代码块，该代码块可以反复的进行使用

### 格式

```js
/*定义函数*/
function 函数名(参数列表){
    return 返回值    //可选
}
/*调用函数*/
函数名();
```

### 注意

1、函数可以多个，如果一旦方法的名字相同的话，函数没有重载，后面同名函数会覆盖前面的同名函数

2、调用函数时，可以传入比函数定义参数更多的参数，只是多出来的参数不会被处理

3、对象的属性也可以是函数，可以使用**对象名.函数名()**进行调用

- 如果需要在对象中的函数调用对象的属性的话，不可以直接写属性名进行调用
- 需要使用**this.属性**进行调用

4、变量的作用域是在一个函数中

## 分支结构

`if...else if...else`的使用方法和java中的类似

`switch...case`的使用方法和java中的类似，使用时需要注意数据类型，在匹配时，需要绝对等于

## 循环结构

### for循环

和java中的类似

### for...in循环

```js
//循环遍历数组
for(var i in arr) {
    alert(i + "..." + arr[i]);
}
```

### while循环

和java类似

### do...while循环

和java类似

**循环中的break和continue关键字的效果和java中一样**

# 常用API

```js
document.write("输出的内容，可以带html标签")
console.log("在浏览器控制台输出，调试模式下可以看到")
Math.random()  //随机数
parseInt(将数值解析为整数)
prompt("请输入"); //弹窗输入
eval("1+1"); // 可以计算字符串的结果
```

# DOM

文档对象模型（Document Object Model）

在网页被加载时，浏览器会创建页面文档对象模型，形成DOM树

## DOM树

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181412591.gif)

- **Document**：树对象，文档对象
- **Element**：元素对象，标签对象
- **Attribute**：属性对象
- **Text**：文本对象
- **Comment**：注释对象
- **Node**：节点对象

## 获取标签对象的相关方法

| 方法                     | 作用                                      | 备注                                            |
| ------------------------ | ----------------------------------------- | ----------------------------------------------- |
| getElementById()         | 根据标签的**id属性值**来获取标签对象      | 一般id属性是用来获取标签对象                    |
| getElementsByName()      | 根据标签的**name属性值**来获取标签对象们  | 一般name属性是用来给后台获取数据用的            |
| getElementsByTagName()   | 根据**标签名**来获取标签对象们            |                                                 |
| getElementsByClassName() | 根据标签的**class属性值**来获取标签对象们 | 一般class属性是用来进行样式设置的，使用类选择器 |

如果直接在script标签中执行获取标签对象的方法，页面没有加载，获取的对象为null

```js
//页面加载完成，再执行函数
window.onload = function(){}
```

## 创建元素的相关方法

| 方法                  | 方法                                                  |
| --------------------- | ----------------------------------------------------- |
| createElement()       | 创建元素节点                                          |
| createAttribute(name) | 创建拥有指定名称的属性节点，并返回新的 Attribute 对象 |
| createTextNode()      | 创建文本节点                                          |
| createComment()       | 创建注释节点                                          |

==注意：创建出来的对象，都是游离状态,需要放置在父元素对象上==

```js
父元素对象.appendChild(创建的子元素对象);
//删除子元素对象
父元素对象.removeChild(需要删除的子元素对象);
```

## 对元素对象内容进行操作

操作的是元素对象，不可以操作元素对象数组，如果需要批量操作，只能写循环进行

### 获取修改标签内容

```js
标签对象.innerHTML = "字符串";
标签对象.innerText = "字符串";
//区别
innerHTML，获取到的是HTML语句，用于处理标签，会解析字符串中的标签内容
innerText，获取到的是内容，用于处理文本，不会解析字符串中的标签内容
```

### 获取修改标签属性

```js
标签对象.属性名 = "属性值";
```

### 获取修改标签样式

```js
//在标签上添加样式(样式多的话，不推荐)
标签对象.style.样式名 = "值";
//给元素对象添加类属性,在style标签中添加类样式
标签对象.className = "类名"  //只可以加一个类名
标签对象.classList.add("类名1","类名2",...); //可以添加多类名
//删除多类名元素对象的一个类名
标签对象.classList.remove("类名");
```

# 事件

## 事件的绑定方式

1、在标签元素上**添加onXXX属性**的方式绑定（xxx代表事件名称）onXXX的值为js代码，**缺点是耦合度高**

2、获取标签元素的对象，通过`标签.onXXX = function(){}`，绑定事件

3、通过dom元素对象的`addEventListener("事件名称",function(){}，传播特性)`方法绑定事件（事件名称不需要on前缀），推荐

## JS中的事件

- **点击事件**：
  - onclick：鼠标点击某个对象
  - ondblclick：鼠标双击某个对象
- **焦点事件**：
  - onblur：元素失去焦点
  - onfocus：元素获得焦点
  - blur()：一调用，就会失去焦点
  - focus()：一调用，就会获取焦点
- **键盘相关事件**：
  - onkeydown：某个键盘的键被按下
  - onkeypress：某个键盘的键被按下或按住，某个键盘按键被按下并松开。
  - onkeyup：某个键盘的键被松开
- **加载事件**：
  - onload：某个页面或图像被完成加载
  - onunload：用户离开某个页面
- **鼠标相关事件**：
  - onmousedown：某个鼠标按键被按下
  - onmousemove：鼠标被移动
  - onmouseout：鼠标从某元素移开
  - onmouseover：鼠标被移到某元素之上
  - onmouseup：某个鼠标按键被松开
- **表单相关事件**：
  - onchange：用户改变域的内容
    - 支持该事件的 HTML 标签：`<input type="text">, <select>, <textarea>`
  - onselect：文本被选定
    - 支持该事件的 HTML 标签：`<input type="text">, <textarea>`
  - onsubmit  提交按钮被点击

## 事件的传播特性

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181412790.gif)

**addEventListener("事件名称",function(){}，传播特性)：**默认的传播方式是false，冒泡

### 事件的冒泡

如果点击最内层的红色元素的话，点击事件也会传播到外层的蓝色元素，称为事件的冒泡

### 事件的捕获

==addEventListener可以改变事件的传播方式，第三个参数为true==

如果点击最外层的蓝色元素的话，点击事件会传播到内层的红色元素，称为事件的捕获

## 事件的委托

将一个元素A中的子元素的点击事件交给元素A处理，称为事件的委托

例如，接收表格中的按钮的点击事件

```js
//变量e用于接收浏览器传入的点击目标对象信息
table.onclick = function(e){
    //获取到事件的触发元素对象
    var t = e.target;
    //获取触发元素对象的名称
    var butName = t.innerText;
    //筛选按钮类型
    switch(butName){
        case "购买":
            //获取购买按钮的父元素对象
            var td = but.parentElement;
            //获取td对象的父元素对象
            var tr = td.parentElement;
            //获取tr的td子元素
            var tds = tr.children;
            alert("购买：" + tds[0].innerText);
            break;
        case "加入购物车":
            break;
        case "查看详情":
            break;
    }
}
```

# 正则表达式

## 格式

```js
//正则表达式格式
/正则表达式主体/修饰符(可选)
//正则表达式验证
var regExp = /正则表达式/;
regExp.test("校验的字符串");
```

## 规则

**方括号**用于查找某个范围内的字符：

| 表达式 | 描述                       |
| ------ | -------------------------- |
| [abc]  | 查找方括号之间的任何字符。 |
| [0-9]  | 查找任何从 0 至 9 的数字。 |
| (x\|y) | 查找任何以 \| 分隔的选项。 |
| n{x}   | n恰好出现x次               |
| n{x,}  | n最少出现x次               |
| n{x,y} | n最少出现x次，最多y次      |

**元字符**是拥有特殊含义的字符：

| 元字符 | 描述                                        |
| ------ | ------------------------------------------- |
| \d     | 查找数字。                                  |
| \s     | 查找空白字符。                              |
| \w     | 匹配数字、字母、下划线                      |
| \W     | 匹配任意不是数字、字母、下划线              |
| **.**  | 匹配除换行符以外的任意单个字符              |
| ^      | 行的开头                                    |
| $      | 行的结尾                                    |
| \uxxxx | 查找以十六进制数 xxxx 规定的 Unicode 字符。 |

**量词**:

| 量词 | 描述                                |
| ---- | ----------------------------------- |
| n+   | 匹配任何包含至少一个 n 的字符串。   |
| n*   | 匹配任何包含零个或多个 n 的字符串。 |
| n?   | 匹配任何包含零个或一个 n 的字符串。 |

**修饰符**可以在全局搜索中不区分大小写:

| 修饰符 | 描述                                                     |
| ------ | -------------------------------------------------------- |
| i      | 执行对大小写不敏感的匹配。                               |
| g      | 执行全局匹配（查找所有匹配而非在找到第一个匹配后停止）。 |
| m      | 执行多行匹配。                                           |

使用String类型的**match**方法，可以匹配正则表达式

```js
var a = "abcABC";
var r = a.match(/b/gi);
```

使用String类型的**replace**方法，可以替换字符串中的字符

```js
var a = "sb,fuck";
var r = a.replace(/(sb)|(fuck)/gi,"*");
```

使用String类型的**search**方法，可以查询匹配的类型首次开始位置索引

```js
var a = "abc,efg,123,hig";
var r = a.search(/\d/g);
```

使用String类型的**split**方法，可以按照特定规则分割字符串

```js
var a = "abc12def34";
var r = a.split(/\d+/);
```

汉字的Unicode编码：`[\u4e00-\u9fa5]`

在表单标签相关属性：

**pattern**：相关文本规则，正则表达式不需要`//`

**required**：值为required，值不可以为空

# BOM

浏览器对象模型（Browser Object Model）尚无正式标准

## Window对象

所有浏览器都支持 window 对象。它表示浏览器窗口。

所有 JavaScript 全局对象、函数以及变量**均自动成为 window 对象的成员**。

全局变量是 window 对象的属性。

全局函数是 window 对象的方法。

### Window 常用属性、方法

`window.innerHeight` - 浏览器窗口的内部高度(包括滚动条)

`window.innerWidth` - 浏览器窗口的内部宽度(包括滚动条)

`window.open("新窗口地址","新窗口名称","新窗口其余属性设置")` - 打开新窗口

`window.close()` - 关闭当前窗口

`window.moveTo()` - 移动当前窗口

`window.resizeTo()` - 调整当前窗口的尺寸

## Screen对象

`window.screen` 对象包含有关用户屏幕的信息。

### Screen常用属性、方法

`screen.availWidth` - 可用的屏幕宽度

`screen.availHeight` - 可用的屏幕高度

`screen.colorDepth` - 色彩深度

`screen.pixelDepth` - 色彩分辨率

## Location对象

`window.location` 对象用于获得当前页面的地址 (URL)，并把浏览器**本窗口**重定向到新的页面。

### Location常用属性、方法

`location.hostname` -  返回 web 主机的域名

`location.pathname` - 返回当前页面的路径和文件名

`location.port `- 返回 web 主机的端口 （80 或 443）

`location.protocol `- 返回所使用的 web 协议（http: 或 https:）

`location.href` 返回当前页面的 URL

`location.href = 'URL' `- 可以重定向到新的页面

`location.assign()` 方法加载新的文档

## history对象

`window.history `对象包含浏览器的历史。

### history常用属性、方法

`history.go()`：加载 history 列表中的某个具体页面,go方法中可以传递参数，如果是正数，就是下某页，如果是负数，就是上某页

`history.length`：返回浏览器历史列表中的 URL 数量

`history.back()` - 与在浏览器点击后退按钮相同

`history.forward()` - 与在浏览器中点击向前按钮相同

## 计时事件

`setInterval()`：按照指定的周期（以毫秒计）来调用函数或计算表达式

* 第一个参数：时间到了要执行的方法
* 第二个参数：周期（毫秒）
* 如果不关闭，它会一直执行下去

`clearInterval()`：取消由setInterval()设置的timeout

`setTimeout()`：在指定的毫秒数后调用函数或计算表达式

* 第一个参数：时间到了要执行的方法
* 第二个参数：过多长时间执行该方法（毫秒）
* 执行完一次之后，就不再执行

`clearTimeout()`：取消由 setTimeout()方法设置的timeout

## 弹窗

可以在 JavaScript 中创建三种消息框：警告框、确认框、提示框。

### 警告框

`alert("警告信息");`

### 确认框

`confirm("提示信息");`

返回值为boolean类型，选择确定返回true，选择取消返回false

### 提示框

当提示框出现后，用户需要输入某个值，然后点击确认或取消按钮才能继续操纵。

如果用户点击确认，那么返回值为输入的值。如果用户点击取消，那么返回值为 null。

`window.prompt("提示信息","默认值");`

## Cookie对象

Cookie 用于存储 web 页面的用户信息。

Cookie 是一些数据, 存储于你电脑上的文本文件中。

当 web 服务器向浏览器发送 web 页面时，在连接关闭后，服务端不会记录用户的信息。

### 创建Cookie

JavaScript 可以使用 **document.cookie** 属性来创建 、读取、及删除 cookie。

```js
document.cookie="key=value";
```

#### 添加过期时间

以 UTC 或 GMT 时间，**默认情况下，cookie 在浏览器关闭时删除**

```js
document.cookie="key=value; expires=Thu, 18 Dec 2043 12:00:00 GMT";
```

可以使用 path 参数告诉浏览器 cookie 的路径。默认情况下，cookie 属于当前页面。

```js
document.cookie="key=value; expires=Thu, 18 Dec 2043 12:00:00 GMT; path=/";
```

### 读取 Cookie

document.cookie 将以字符串的方式返回所有的 cookie，类型格式：` key1=value;key2 =value; key3=value;`

```js
var x = document.cookie;
```

### 删除 Cookie

只需要设置 expires 参数为以前的时间即可

```js
document.cookie = "key=; expires=Thu, 01 Jan 1970 00:00:00 GMT";
```

**删除时不必指定 cookie 的值**