# 什么是Vue CLI

- 如果你只是简单写几个Vue的Demo程序, 那么你不需要Vue CLI.
- 如果你在开发大型项目, 那么你需要, 并且必然需要使用Vue CLI
  - 使用Vue.js开发大型应用时，我们需要考虑代码目录结构、项目结构和部署、热加载、代码单元测试等事情。
  - 如果每个项目都要手动完成这些工作，那无疑效率比较低效，所以通常我们会使用一些脚手架工具来帮助完成这些事情。
- CLI是Command-Line Interface, 翻译为命令行界面, 但是俗称脚手架
- 使用 vue-cli 可以快速搭建Vue开发环境以及对应的webpack配置.

# VueCLI使用前提

## NodeJs

- 可以直接在官方网站中下载安装.
- 网址: http://nodejs.cn/download/
- 默认情况下自动安装Node和NPM
- Node环境要求8.9以上或者更高版本

### cnpm镜像

- 由于国内直接使用 npm 的官方镜像是非常慢的，这里推荐使用淘宝 NPM 镜像。
- 你可以使用淘宝定制的 cnpm (gzip 压缩支持) 命令行工具代替默认的 npm:
  - `npm install -g cnpm --registry=https://registry.npm.taobao.org`
- 这样就可以使用 cnpm 命令来安装模块了：
  - `cnpm install [name]`

## Webpack

全局安装：`npm install webpack@3.6.0 -g`

# 脚手架安装

## 安装脚手架

全局安装：`cnpm install -g @vue/cli`

**注意**：上面安装的是Vue CLI3的版本，如果需要想按照Vue CLI2的方式初始化项目时不可以的。

通过`vue --version`查看版本

## 安装全局桥接工具，拉取vuecli2模板

命令：`cnpm install -g @vue/cli-init`

# 初始化项目

## 1、命令下载模板

### vuecli2创建项目

命令：`vue init webpack 项目名称`

### vuecli3创建项目

命令：`pvue create 项目名称`

## 2、项目起名

![image-20210804172211371](https://gitee.com/yh-gh/img-bed/raw/master/202109181417303.png)

一般情况不需要改，文件夹名就是项目名称

## 3、项目描述

![image-20210804172319848](https://gitee.com/yh-gh/img-bed/raw/master/202109181417757.png)

默认为A Vue.js project，可以根据实际情况修改

## 4、作者信息

![image-20210804172421046](https://gitee.com/yh-gh/img-bed/raw/master/202109181417246.png)

默认读取gitconfig的用户

## 5、构建项目选择

![image-20210804172519376](https://gitee.com/yh-gh/img-bed/raw/master/202109181417687.png)

开发中通常选择第二个，因为运行效率更高，体积小

## 6、是否安装路由

![image-20210804172805196](https://gitee.com/yh-gh/img-bed/raw/master/202109181417845.png)

根据需求选择，一般会安装

## 7、是否对js编码规范进行检查

![image-20210804172850944](https://gitee.com/yh-gh/img-bed/raw/master/202109181417540.png)

一般不使用

## 8、单元测试

![image-20210804173154348](https://gitee.com/yh-gh/img-bed/raw/master/202109181417548.png)

一般不使用

## 9、端到端测试（自动化测试）

![image-20210804173636802](https://gitee.com/yh-gh/img-bed/raw/master/202109181417070.png)

一般不使用，由测试人员完成

## 10、选择npm或yarn管理项目

![image-20210804173939049](https://gitee.com/yh-gh/img-bed/raw/master/202109181417709.png)

# 目录结构

![image-20210804191851057](https://gitee.com/yh-gh/img-bed/raw/master/202109181417437.png)

# runtime-compiler和runtime-only的区别

- 如果在之后的开发中，你依然使用template，就需要选择Runtime-Compiler
- 如果你之后的开发中，使用的是.vue文件夹开发，那么可以选择Runtime-only

## render和template

![image-20210805103251642](https://gitee.com/yh-gh/img-bed/raw/master/202109181417643.png)

## 执行过程

- runtime-compiler
  - template--》ast抽象语法树--》render函数--》vdom虚拟DOM--》真实DOM
- runtime-only
  - render函数--》vdom虚拟DOM--》真实DOM

所以推荐使用runtime-only，执行效率更高

## render函数的使用

```js
import App from 'app';
new Vue({
    el: '#app',
    render: function(h){
        return h(App);
    }
})

//render函数中h的本质是一个createElement函数,即
import App from 'app';
new Vue({
    el: '#app',
    render: function(createElement){
        return createElement(App);
    }
})
```

## createElement函数

```js
new Vue({
    el: '#app',
    render: function(createElement){
        //实际会有三个参数
        //参数一：需要用来替换#app标签的元素或组件对象
        //参数二：该标签的属性
        //参数三：标签中的内容
        //最终，<div id='app'/>标签会被替换成<h2 class='box'>hello,world!</h2>
        return createElement('h2',{class: 'box'},['hello,world!']);
    }
})
```

# npm run build流程

![image-20210805112230552](https://gitee.com/yh-gh/img-bed/raw/master/202109181418743.png)

# npm run dev流程

![image-20210805112259896](https://gitee.com/yh-gh/img-bed/raw/master/202109181418782.png)

# vuecli3

## vuecli3和vuecli2的区别

- vue-cli 3 是基于 webpack 4 打造，vue-cli 2 还是 webapck 3
- vue-cli 3 的设计原则是“0配置”，移除的配置文件根目录下的，build和config等目录
- vue-cli 3 提供了 vue ui 命令，提供了可视化配置，更加人性化
- 移除了static文件夹，新增了public文件夹，并且index.html移动到public中

## 创建项目

### 1、命令

`vue create 项目名称`

### 2、选择配置方式

![image-20210805113729329](https://gitee.com/yh-gh/img-bed/raw/master/202109181418164.png)

manually select features手动选择

### 3、空格选择需要的配置

![image-20210805113925460](https://gitee.com/yh-gh/img-bed/raw/master/202109181418860.png)

### 4、选择配置文件位置

![image-20210805114310108](https://gitee.com/yh-gh/img-bed/raw/master/202109181418862.png)

建议选第一个，单独的配置文件

### 5、是否保存配置到默认配置

![image-20210805114408439](https://gitee.com/yh-gh/img-bed/raw/master/202109181418692.png)

可以在`C://users/administrator/.vuerc`中进行修改删除默认配置

## 目录结构

![image-20210805120059946](https://gitee.com/yh-gh/img-bed/raw/master/202109181418244.png)

## 配置文件的查看和修改

可以使用命令`vue ui`查看项目配置

![image-20210805140614393](https://gitee.com/yh-gh/img-bed/raw/master/202109181418637.png)

如果需要自己更改配置的话，那么需要在项目的根目录创建一个`vue.config.js`文件（文件名固定），格式：

```js
module.exports = {
    
}
```

