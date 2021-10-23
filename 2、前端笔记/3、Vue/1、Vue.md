# Vue

- Vue读成view ，而不是V U E
- Vue是个前端框架，是尤雨溪（中国人）的个人项目
- 这个框架主要关注点： View和 Model如何快速绑定

# Vue的特点

1. 非常简单，Easy,好学
2. 遵循一种新的WEB架构模式： MVVM
3. 它可以开发单页面的应用程序（每个单独的页面，就是一个独立的应用程序）
4. 渐进式（从核心技术开发，一层一层的添加内容）与兼容性（允许兼容其他框架或其他技术）
5. 视图组件化
6. 虚拟 DOM（Virtual DOM）

# MVVM架构

- 之前，我们学过MVC（Model - View - Controller），但是这套东西是后端框架提出来的，不适合前端
- 他们提出了自己的前端框架模式：MVVM（Model - View - ViewModel）
- Model依旧是数据，View依旧是视图
- ViewModel视图模型绑定对象（监听数据的变化，并实时做到与View进行同步）

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181415140.gif)

# 视图组件化

将网页拆分成多个组件，然后各自开发

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181415580.gif)

最后，再拼接各个组件，通过拼接组件的方式，完成页面的开发 （类似于：Spring拼接组件）

# 虚拟DOM(Virtual DOM)

以前，很不规范的人在使用Jquery时，存在大量的针对DOM节点进行频繁的操作，这就导致浏览器在解析节点时，显得非常的卡顿

为了解决这个问题，所以前端提出了 Virtual DOM的说法，Virtual DOM实际上是在内存中，先定义一颗节点树，所有的操作先针对该节点树进行完成，操作完毕之后，再同步到真实DOM对象中，从而提升浏览器在解析节点时的性能浪费

# Vue的使用

## 1、引入vue

### 引入js文件

**官网下载**：https://cn.vuejs.org/

1）引入本地的vue.js文件

2）引入网络，CDN加速vue.js

### npm



## 2、简单使用

```html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
        <script src="../js/vue.js"></script>
    </head>
    <body>
        <div id="test">
            <!--   声明式渲染   -->
            {{t1}}
        </div>
    </body>
    <script>
        //创建vue对象
        var v = new Vue({
            //此处选择的元素，相当于作用范围
            el:"#test",
            //声明的属性值
            data:{
                t1:"test1",
            },
            //声明的方法
            methods:{
                add(){
                    alert("add....")
                },
            }
        });
    </script>
</html>
```

# 语法

## 字符串拼接

```html
<a :href="'detailPage.html?workorderId=' + li.workorderId">详情</a>
```

## 声明式渲染（mustache语法）

mustache语法中，不仅仅可以写变量，也可以写简单的表达式

格式：`{{ message }}`

标签使用`v-pre`属性的话，那么mustache语法不会被解析

标签可以使用`v-cloak`属性的话，只有在vue解析该标签的话，这个标签才会进行展示并且删除该属性(需要和css进行搭配，`[v-cloak]{display:none}`)

## v-once

如果标签添加这个属性，那么该标签只会展示首次的数据，不会随变量改变而发生界面改变

## v-html&v-text

**v-html**可以给当前标签添加文本，并解析html标签元素

**v-text**可以给当前标签添加文本，但是不解析标签元素

## v-on

v-on可以给节点添加事件

### 格式：

```html
<!--方法没有形参的情况下()可以省略-->
<button v-on:click="add">botton</button>
<button v-on:click="add(1)">botton</button>
```

### 支持的事件

1. **click**在元素上按下并释放任意鼠标按键。
2. **dblclick**在元素上双击鼠标按钮。
3. **mousedown**在元素上按下任意鼠标按钮。
4. **mouseenter**指针移到有事件监听的元素内。
5. **mouseleave**指针移出元素范围外（不冒泡）。
6. **mousemove**指针在元素内移动时持续触发。
7. **mouseover**指针移到有事件监听的元素或者它的子元素内。
8. **mouseout**指针移出元素，或者移到它的子元素上。
9. **mouseup**在元素上释放任意鼠标按键。
10. **pointerlockchange**鼠标被锁定或者解除锁定发生时。
11. **pointerlockerror**可能因为一些技术的原因鼠标锁定被禁止时。
12. **select**有文本被选中。
13. **wheel** 滚动鼠标滚轮时

### 传参

```html
<div id="app">
    <!-- 如果调用方法没有（）的话，那么默认方法形参为当次触发事件的event对象 -->
    <button @click="cli">click</button>
    <!-- 如果需要event对象，也需要其他参数（多参数），那么使用$event -->
    <button @click="cli($event,lucy)">click</button>
</div>
<script src="https://cdn.jsdelivr.net/npm/vue@2.5.16/dist/vue.js"></script>
<script>
    let v = new Vue({
        el:"#app",
        methods: {
            //方法定义了形参
            cli:function(event){
                console.log(event);
            }
        }
    })
</script>
```

### 修饰符

`@click.stop=""`，阻止当前事件的冒泡

`@click.prevent=""`，阻止默认事件，例如点击提交按钮后form表单的默认提交事件

`@keyup.keyCode|keyAlias=""`,监听键盘的点击

`@click.once=""`,当前事件只会触发一次

### 简写

```html
<button @click="add">botton</button>
<button @click="add(1)">botton</button>
```

## v-bind

v-bind命令的作用： 可以用来定义标签的属性，**单向绑定**，也就是变量如果发生变化，那么页面随之发生变化，但是如果页面变化，变量不会变化

### 格式

```html
<input type="text" v-bind:value="t1"/>
```

### 简写

```html
<input type="text" :value="t1"/>
```

### 绑定class

```html
<style>
    .redColor{
        color:red;
    }
</style>
<div id="app">
    <!-- 此处:class可以通过一个对象，来绑定多个class，{类名1：boolean，类名2：boolean} -->
    <h1 :class="{redColor:isRed}">hello world！</h1>
    <button @click="isRed = !isRed">切换颜色</button>
</div>
<script>
    let v = new Vue({
        el:"#app",
        data:{
            isRed:true
        }
    })
</script>
```

`:class`也可以通过一个数组来动态绑定，`:class="['类名1'，'类名2']"`

## v-model

v-model 主要可以做到：view 与model 之间，**双向绑定，只可以作用在表单元素上**，也就是model的数据变化，view那边可以跟着变化； view的数据变化，model的数据跟着也会发生变化，实际是v-bind和v-value的结合

### 格式

```html
<input type="text" v-model="t1"/>
```

## v-if

v-if是条件渲染指令，它根据表达式的真假来删除和插入元素

```html
<!--此元素会从dom中删除-->
<input type="text" v-if="1 < 0"/>
```

## v-else&v-else-if

v-else 元素必须紧跟在带 v-if 或者 v-else-if 的元素的后面，否则它将不会被识别。

```html
<div v-if="type === 'A'">
  A
</div>
<div v-else-if="type === 'B'">
  B
</div>
<div v-else>
  Not A/B/C
</div>
```

## v-show

v-show可以做到DOM节点，进行条件显示

### 和v-if的区别

- v-if是通过新增或删除DOM节点，来做到节点是否展示
- v-show是通过给节点添加属性`style="display:none"`来实现的

```html
<!--会给此元素加style="display:none"-->
<input type="text" v-show="1 < 0"/>
```

## v-for

遍历循环添加元素

### 遍历数组

```html
<!--goods:[{name:"apple",price:18},{name:"banana",price:22}]-->
<!--g为遍历出来的每个对象，index为索引-->
<tr v-for="(g,index) in goods">
    <td>{{g.name}}</td>
    <td>{{g.price}}</td>
</tr>
```

### 遍历对象

```html
<!--t1:{name:"apple",price:18}-->
<!--value为对象的属性值，key为对象属性名-->
<div v-for="(value,key) in t1">
    {{value}}==={{key}}
</div>
```

# Vue常用API

## push(obj)

方法可向数组的末尾添加一个或多个元素，并返回新的长度。

## pop()

方法用于删除并返回数组的最后一个元素

## shift()

方法用于把数组的第一个元素从其中删除，并返回第一个元素的值

## unshift(obj)

方法可向数组的开头添加一个或更多元素，并返回新的长度

## splice(index,len,[item])

方法向/从数组中替换/删除/添加对象，然后返回被删除的对象

- `aaa.splice(0,1,"xxx")`：0:下标，1：长度，把下标为0的对象替换成xxx，替换1个长度
- `aaa.splice(3,0,"abc")`：在3号索引的位置添加“abc”
- `this.num.splice(0,2)`：下标为0开始删除2个长度

## sort()

方法用于对数组的元素进行排序

## reverse()

方法用于颠倒数组中元素的顺序

## filter()

方法创建一个新的数组，新数组中的元素是通过检查指定数组中符合条件的所有元素

```js
var arr2 = this.arr1.filter(function(num){  
    return num > 10;
});
//Lambda表达式
var arr2 = arr1.filter((num) => {
    return num > 10;
});
```

## concat(arr)

方法用于连接两个或多个数组

```js
var arr3 = arr1.concat(arr2);
```

## slice(index,[index])

方法保留参数范围内的元素

```js
var arr = [1,2,3,4,5];
//保留下标为1后面的数据
var arr2 = arr.slice(1);
//保留下标为1到下标为3之前的数据
var arr2 = arr.slice(1,3);
```

# Vue的声明周期

生命周期：就是指Vue对象从产生到服务到死亡（GC回收）的完整过程。

在Vue的整个生命周期过程中，跟Servlet一样会执行很多的默认方法（init(),service(),destroy()） ，同样也定义了非常多的默认方法，在前端，他们把这些默认方法，称为：**钩子函数**

- **beforeCreate (创建前)** 组件实例在创建之前，组件属性计算之前，此时无法获得data、methods中的数据
- **created（创建后）** 组件实例在创建之后，属性绑定，此时DOM还没有被产生 (相当于JQuery中的`$(function(){ }))`，此时异步请求数据
- **beforeMount(挂载前)** 编译模板、挂载之前
- **mounted(挂载后)** 编译模板、挂载之后 （产生DOM节点）
- **beforeUpdate(更新前)** 组件更新之前
- **updated(更新后)** 组件更新之后
- **beforeDestroy(销毁前)** 组件销毁之前调用 组件销毁就是GC回收
- **destroyed(销毁后)** 组件销毁之后调用

![](https://gitee.com/yh-gh/img-bed/raw/master/202109181415543.png)

# 监听属性

使用watch属性，进行监听属性

## 在vue形参外监听

```js
var vm = new Vue({
    el: '#app',
    data: {
        counter: 1
    }
});
//监听counter这个属性改变前后的值
vm.$watch('counter', function(after, before) {
    alert('改变前为:' + before + ' ，改变后为： ' + after);
});
//一个形参代表改变后的值
vm.$watch('counter', function(after) {
    alert('改变后为：' + after);
});
```

## 在vue形参内监听

```js
var vue = new Vue({
    el:"div",
    data:{
        test:"111",
    },
    watch:{
        test:function (after, before){
            alert('改变前为:' + before + ' ，改变后为： ' + after);
        }
    }
});
```

# Vue获取DOM元素

除了vue的方法以外，还可以使用jquery或js的方法来获取

```html
<div id="app">
    <input ref="name">
    <button @click="m1">get</button>
</div>
<script>
	let vm = new Vue({
       el:"#app",
       methods:{
           m1(){
               //使用this.$refs.DOM元素ref属性值，获取该DOM元素
               console.log(this.$refs.name.value);
           }
       }
    });
</script>
```

# 计算属性

虽然在模板中可以直接插入data中的数据，但是有些时候，我们需要对数据进行一些转化，然后才可以使用，或者需要将data中的多个数据结合起来使用，所以需要使用computed实例

## 基本使用

```html
<div id="app">
    <!-- 使用不需要加小括号，因为是一个属性 -->
    <h1>{{fullName}}</h1>
</div>

<script src="https://cdn.jsdelivr.net/npm/vue@2.5.16/dist/vue.js"></script>
<script>
    let v = new Vue({
        el:"#app",
        data:{
            firstName:"Kobe",
            lastName:"Bryant"
        },
        computed:{
            //计算属性，结果可以看做为一个属性
            fullName:function(){
                return this.firstName + " " + this.lastName;
            }
        }
    })
</script>
```

## 本质

计算属性的本质是一个对象，有getter和setter两个方法，我们直接使用属性名，实际是调用了get方法，我们一般也只会实现getter方法，这个属性也成为只读属性

```js
computed:{
    fullName{
        get:function(){

        },
        set:function(newValue){

        }
    }
}
```

## computed和methods的区别

1、使用methods的话，在每次调用，都会执行一次方法

2、使用computed的话，在首次调用，会执行一次，但是后续调用该属性，如果函数里面的数据没有发生改变的话，那么vue会使用自带的缓存

# 过滤器

用来对数据进行过滤，例如，价格保留两位小数，并加单位（元）：

```html
<div id="app">
    <!-- 显示格式为："data | 过滤器" -->
    {{price | showPrice}}
</div>
<script src="https://cdn.jsdelivr.net/npm/vue@2.5.16/dist/vue.js"></script>
<script>
    let v = new Vue({
        el:"#app",
        data: {
            price:98
        },
        filters: {
            showPrice(price){
                return price.toFixed(2) + "元";
            }
        }
    })
</script>
```

