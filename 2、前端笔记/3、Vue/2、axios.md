# Axios

Ajax要么就原生的JS写，要么就用Jquery的封装来写。要用封装，就必须要导入jquery.js

**Vue提倡：去Jquery化**

Axios是新的与后端进行异步交互的方法，但是**Axios不属于Vue**，它是属于Vue的周边产品，**使用时需要引入axios.js**

## Axios的官网

http://www.axios-js.com/zh-cn/docs/#axios-request-config-1

## 异步请求方式一：get方法

### 格式

```js
axios.get("http://ip:port/project?key=value").then(function (response){
    //response.data获取响应回来的数据
    alert(response.data);
}).catch(function (e){
    //e为异常
    alert(e);
});
```

### 使用

```js
new Vue({
    el:"div",
    data:{
        users:null,
    },
    created(){
        //此处的then()里面函数必须使用lambda表达式，不然无法获取this.users
        axios.get("http://172.16.2.67:8080/findAllUser.do?pageNum=1").then(response => {
            this.users = response.data.list;
        }).catch(function (e){
            alert(e);
        });
    }
})
```

## 异步请求方式二：post方法

### 格式

```js
axios.post("http://ip:port/project","key=value").then(function (response){
    //response.data获取响应回来的数据
    alert(response.data);
}).catch(function (e){
    //e为异常
    alert(e);
});
```

### 使用

```js
new Vue({
    el:"div",
    data:{
        users:null,
    },
    methods:{

    },
    created(){
        //此处的then()里面函数必须使用lambda表达式，不然无法获取this.users
        axios.post("http://172.16.2.67:8080/findAllUser.do","pageNum=1").then(response => {
            this.users = response.data.list;
        }).catch(function (e){
            alert(e);
        })
    }
})
```

## 异步请求方式三：并发请求

### 格式

```js
method1(){
    return axios.get("http://ip:port/project?key=value");
},
method2(){
        return axios.get("http://ip:port/project?key=value");
}
axios.all([this.method1(),this.method2()]).then(axios.spread(function (response1,response2){
    alert(response1.data);
    alert(response2.data);
}))
```

### 使用

```js
new Vue({
    el:"div",
    data:{
        users:null,
        byid:null,
    },
    methods:{
        findAll(){
            return axios.get("http://172.16.2.67:8080/findAllUser.do?pageNum=1");
        },
        findByid(){
            return axios.get("http://172.16.2.67:8080/findByUid.do?uid=1");
        }
    },
    created(){
        //此处的axios.spread()里面函数必须使用lambda表达式，不然无法获取this.users
        axios.all([this.findAll(),this.findByid()]).then(axios.spread((response1,response2) => {
            this.users = response1.data.list;
            this.byid = response2.data;
        }))
    }
})
```

## 文件上传

```html
<div id="app">
    <input id="inputElement" name="file" type="file" accept="image/png, image/gif, image/jpeg"  />
    <button @click="upload">上传</button>
</div>
<script>
    new Vue({
        el:"#app",
        data() {
            return {
                file: null
            };
        },
        methods: {
            upload() {
                let inputElement = document.getElementById("inputElement");
                //获取input-file中的file对象，只上传一个文件，索引就是0
                let file = inputElement.files[0];
                // 创建一个form对象
                let param = new FormData(); 
                // 通过append向form对象添加数据
                param.append("file", file);
                // 添加form表单中其他字段数据
                param.append("key", "value");
                // FormData私有类对象，访问不到，可以通过get判断值是否传进去
                console.log(param.get("file")); 
                //配置多段请求，设置上传头
                let config = {
                    headers: { "Content-Type": "multipart/form-data" }
                };
                axios.post("http://192.168.31.253:8080/upload", param, config);
            }
        }
    });
</script>
```

# Vuecli中使用axios

## 1、添加axios到项目中

```bash
cnpm install axios
```

## 2、在主配置文件main.js中引入axios

```js
import axios from 'axios'
```

## 3、在Vue原型中挂载axios（全局都可以使用）

```js
Vue.prototype.$axios = axios
```

## 4、在其他位置使用asios

```js
this.$axios.post().then
```

# 设置提交方式

## 1、默认JSON

## 2、设置表单提交

```js
let data = new FormData();
data.append('user',this.user);
data.append('psw',this.psw);
this.$axios.post("http://localhost:8080/student/login",data).then()
```

