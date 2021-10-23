```html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
        <script src="../js/vue.js"></script>
    </head>
    <body>
        <div id="app">
            <p>
                全选：
            </p>
            <input type="checkbox" id="checkbox" v-model="checked" @change="changeAllChecked()">{{checked}}
            <p>
                多个复选框：
            </p>
            <input type="checkbox" id="runoob" value="Runoob" v-model="checkedNames">Runoob
            <input type="checkbox" id="google" value="Google" v-model="checkedNames">Google
            <input type="checkbox" id="taobao" value="Taobao" v-model="checkedNames">taobao<br>
            选择的值为:{{checkedNames}}
        </div>
    </body>
    <script>
        new Vue({
            el: '#app',
            data: {
                checked: false,
                checkedNames: [],
                checkedArr: ["Runoob", "Taobao", "Google"]
            },
            methods: {
                changeAllChecked: function() {
                    if (this.checked) {
                        checkedNames = [];
                        this.checkedNames = this.checkedArr;
                    } else {
                        this.checkedNames = [];
                    }
                }
            },
            watch: {
                "checkedNames": function() {
                    if (this.checkedNames.length == this.checkedArr.length) {
                        this.checked = true;
                    } else {
                        this.checked = false;
                    }
                }
            }
        })
    </script>
</html>
```

