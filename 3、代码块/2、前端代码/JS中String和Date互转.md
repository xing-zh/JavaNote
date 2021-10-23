# js字符串转换成Date

## 输入的时间格式为yyyy-MM-dd

```js
function convertDateFromString(dateString) {
    var date = new Date(dateString.replace(/-/,"/")) 
    return date;
}
```

## 输入的时间格式为yyyy-MM-dd hh:mm:ss

```js
function convertDateFromString(dateString) { 
    var arr1 = dateString.split(" "); 
    var sdate = arr1[0].split('-'); 
    var date = new Date(sdate[0], sdate[1]-1, sdate[2]); 
    return date;
}
```

# Date转字符串

```js
(new Date()).Format("yyyy-MM-dd hh:mm:ss.S")
```

