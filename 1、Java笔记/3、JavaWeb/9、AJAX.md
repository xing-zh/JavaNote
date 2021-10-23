# 什么是AJAX技术

**Asynchronous Javascript And XML**，（异步JavaScript和XML），是指一种创建交互式、快速动态网页应用的网页开发技术，无需重新加载整个网页的情况下，能够更新部分网页的技术

## 同步和异步

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181326115.gif)

异步：在同一个时间点，双方可以同时执行

同步：在同一个时间点，一方正在执行，另一方只能等待

## AJAX执行流程

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181326060.gif)

# 实现AJAX

## 原生方式（不推荐）

```js
//根据浏览器的不同，获取HttpRequest对象
function  getHttpRequest(){
    if (window.XMLHttpRequest){
        //  IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
        oRequest=new XMLHttpRequest();
    }else{
        // IE6, IE5 浏览器执行代码
        oRequest=new ActiveXObject("Microsoft.XMLHTTP");
    }
   return oRequest;
}
function login(){
    //1-获取HttpRequest对象
    var req = getHttpRequest();
    //2-获得账号密码
    var lname = document.getElementsByTagName("input")[0].value;
    var psw= document.getElementsByTagName("input")[1].value;
    //3-请求的准备，参数可以在此处写，也可以在send方法写
    req.open("get","login?lname=" + lname + "&psw=" + psw);
    //4-响应回调函数
    onreadystatechange=function (){
        //判断状态，结果为4说明响应完成,200说明请求已成功被服务器接收、理解、并接受
        if (req.readyState == 4&&req.status==200){
        //获取到服务端的响应文本
        var result = req.responseText;
        alert(result);
        }
    }
    //5-发送请求,参数可以在open中写，此处可以参数为null
    req.send("lname=" + lname + "&psw=" + psw);
}
```

## 使用jQuery

### $.ajax()方法

```js
$.ajax({
    url:"发送的请求地址",
    type:"请求方式post、get",
    data:"发送的数据",
    dataType:"服务器返回的数据类型xml、html、script、json、test",
    async:false, //异步true
    beforeSend:function(data){
        //发送请求前执行的代码,return true为允许提交
        },
    success:function(data){
        //发送成功后执行的代码
        },
    error:function(){
        //请求失败执行的代码
        }
});
```

### 针对get以及post

```js
$.get("url","参数",function(data){
    // 响应成功后的回调函数
},"返回类型")


$.post("url","参数",function(data){
    // 响应成功后的回调函数
},"返回类型")
```

# 多段式提交（用于文件上传）

```js
var formData = new FormData($("form")[0]);//传输参数是js中对象
$.ajax({
    type: "POST",
    url: "url",
    enctype: "multipart/form-data",
    data: formData,
    success: function (data) {
        //回调函数
    },
    cache: false,
    contentType: false,
    processData: false
});
```



 