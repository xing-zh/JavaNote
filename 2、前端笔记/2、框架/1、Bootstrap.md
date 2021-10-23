# 优点

具有丰富的css样式和js插件，可以使我们做的页面更加丰富，效果绚丽多彩

支持响应式布局开发

# 使用

1. 下载BootStrap
2. 创建一个项目，将这三个官方的提供的文件夹拷贝到项目下
3. 在我们创建的html页面中引入指定的一些js和css的第三方文件即可

或者可以引用

```html
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
```

# Bootstrap

## 响应式布局

响应式布局，只需要做一份页面，这个页面根据不同分辨率，来自行修改内容布局BootStrap的响应式依赖于**栅格系统**

## 栅格系统

响应式网格系统随着屏幕或视口（viewport）尺寸的增加，系统会自动分为最多12列。

### 使用方法

- 行必须放置在 .container class 内，以便获得适当的对齐（alignment）和内边距（padding）。
- 使用行来创建列的水平组。
- 内容应该放置在列内，且唯有列可以是行的直接子元素。
- 预定义的网格类，比如 .row 和 .col-xs-4，可用于快速创建网格布局。LESS 混合类可用于更多语义布局。
- 列通过内边距（padding）来创建列内容之间的间隙。该内边距是通过 .rows 上的外边距（margin）取负，表示第一列和最后一列的行偏移。
- 网格系统是通过指定您想要横跨的十二个可用的列来创建的。例如，要创建三个相等的列，则使用三个 .col-xs-4。

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181414520.gif)

## 样式

### 图片

```html
class="img-rounde"--圆角图片
class="img-thumbnail"--图片框
class="img-circle"--圆形图片
```

## 按钮

```html
class="btn-success"--成功，绿色白字
class="btn-info"--提示，蓝色白字
class="btn-warning"--警告，橘色白字
class="btn-danger"--危险，红色白字
class="btn-block"--拉伸到父容器宽度
```

## 字体图标

字体图标库：https://v3.bootcss.com/components/

```html
/*给按钮添加字体图标*/
<button>
    <span class="字体图标">
    </span>
</button>
```

## 表格

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181414380.gif)

### `<tr>`,` <th> `和` <td>` 类

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181414125.gif)

 