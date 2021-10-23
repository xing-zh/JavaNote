# css概述

层叠样式表（cascading style sheet）

层叠是指==将多个样式施加在一个元素（标签）上==

作用：

* 美化页面
* 将html代码与样式代码分离

好处：

* 功能强大
* 分离代码，降低耦合性，提高重用性，提高维护性，提高开发效率

# 使用方法

1、在HTML标签的style属性书写，这个属性的值，是由一些小的键值对构成

```html
<div style="color:red; font-size:100px;">12345</div>
```

- 缺点：
  - 有可能出现代码冗余
  - 标签属性多，耦合高，不便于维护

2、在页面head标签中添加style标签

```html
<style>
    div {
        color:yellow;
        font-size:500px;
    }
</style>
```

3、在head标签中添加link标签引入css文件

```html
<link rel="stylesheet" href="css文件地址" />
```

## 使用时机：

- 方式一：由于样式设置是写在标签内的，它只能给这个一个标签施加样式，当我们只需要给一个标签施加样式的时候，就可以选择使用第一种方式
- 方式二：由于样式是写在style 标签，在style标签里面写的是选择器，所以它可以给多个标签施加相同的样式当我们需要给一个页面中的多个标签施加相同的样式的时候，我们就可以选择使用第二种
- 方式三：由于该方式，是引入了外来的css文件，说明引入css文件，就可以使用该样式了，当我们需要给多个页面中的多个标签施加相同的样式的时候，我们就可以选择使用第三种
- ==推荐使用第二种和第三种==

# 盒子模型

![说明: clipboard.png](https://gitee.com/yh-gh/img-bed/raw/master/202109181412754.gif)

对页面进行布局（div + css）

## padding：设置内补丁

- padding：不同参数代表位置
  - 一个参数：上下左右
  - 两个参数：上下  左右
  - 三个参数：上  左右   下
  - 四个参数：上  右  下  左

默认情况，如果我们设置内补丁，会影响到整个盒子的大小，那我们需要设置一个属性`box-sizing: border-box`

## margin：设置外补丁

* margin：不同参数代表位置
  * 一个参数：上下左右
  * 两个参数：上下  左右
  * 三个参数：上  左右   下
  * 四个参数：上  右  下  左

## float浮动

会打破默认的流式布局，一般建议，如果一个元素进行了浮动，其余的和该元素同级别的也进行浮动。

- **left**：从左浮动
- **right**：从右浮动

## position定位

- **静态定位（static）**：默认值，没有定位，元素不会受到top，bottom，left，right影响
- **固定定位（fixed）**：元素相对于浏览器窗口是固定位置
- **相对定位（relative）**：相对定位元素的定位是相对其原来位置的偏移量
- **绝对定位（absolute）**：绝对定位的元素的位置相对于最近的已定位父元素，如果元素没有已定位的父元素，那么它的相对于父元素也需要使用绝对定位
- **z-index**：显示优先级，数值越大，越靠上
- **opacity**：透明度，0完全透明，1完全不透明

# 属性

## 尺寸

支持百分比或者像素

- **width**：宽度
- **height**：高度
- **display**：可见性

## 文本（字体）

- **color**：字体颜色
- **font-size**：字体大小
- **font-family**：字体样式
- **font-weight**：字体粗细
- **font-style**：倾斜（italic）
- **text-align**：水平对齐方式
- **line-height**：行高，文字垂直位置的处理
- **text-shadow：x轴偏移量 y轴的偏移量 羽化效果 阴影颜色**：文本阴影
- **text-decoration**：文本下划线

## 背景

- **background-color**：背景颜色
- **background-image**：url（背景图片）
- **background-repeat**：是否平铺图片（no-repeat、repeat-x、repeat-y）
- **background-position**：背景图片位置（水平偏移量  垂直偏移量）
- **backgroud-image：linear-gradient（to 方向，开始颜色，结束颜色）**：渐变背景色
- **box-shadow：x轴偏移量 y轴的偏移量 羽化效果 阴影颜色**：盒子阴影
- **background-size**：背景图片大小

## 边框

- **border-left、right、top、bottom**：宽度 颜色 样式
- **border-color**：颜色
- **border-width**：粗细
- **border-style**：样式
- **border-radius**：边框圆角
- **border-collapse**：边框间距合并
- **border-spacing**：属性指定相邻单元格边框之间的距离
- **outline**：点击轮廓
- **box-sizing：border-box**：设置相邻边框覆盖

# 选择器

可以帮助我们快速定位到某一个或者某几个标签的，就称为选择器

格式：

```css
选择器 {
    小键值对；
    ... ...
 }
```

## 元素选择器

```css
标签名{
    样式属性
    key:value;
}
```

## ID选择器

```css
#ID{
    样式属性
    key:value;
}
```

## 类选择器

```css
.类名{
    样式属性
    key:value;
}
```

**优先级**：id选择器 > 类选择器 > 元素选择器

## 组合选择器

```css
选择器,选择器,选择器{
    样式属性
    key:value;
}
```

## 后代选择器

```css
父标签 后代标签 {
  样式属性
  key:value;
}
```

## 子元素选择器

```css
父标签>子标签 {
  样式属性
  key:value;
}
```

## 兄弟选择器

```css
/*同等级的，标签1后方的*/
标签1~标签2{
   样式属性
   key:value; 
}
```

## 相邻选择器

```css
/*同等级的，标签1后方的第一个标签*/
标签1+标签2{
  样式属性
  key:value;
}
```

## 伪类选择器

```css
标签:link{
    标签未被访问前的样式属性
    key:value;
}
标签:hover{
    鼠标悬停的标签样式属性
    key:value;
}
标签:visited{
    标签已被访问后的样式属性
    key:value;
}
标签:active{
    鼠标点击标签未释放的样式属性
    key:value;
}
标签:last-child{
    最后一个该标签的子标签样式属性
    key:value;
}
标签:first-child{
    第一个该标签的子标签样式属性
    key:value;
}
标签:nth-child(n){
    该标签的父标签的第n个该类子标签的样式属性
    key:value;
}
```

## 属性选择器

```css
标签[key='value']{
    样式属性
    key:value; 
}
标签[key*='a']{
    属性key的值包含a的标签的样式属性
    key:value; 
}
标签[key^='a']{
    属性key的值以a开头的标签的样式属性
    key:value; 
}
标签[key$='a']{
    属性key的值以a结尾的标签的样式属性
    key:value; 
}
标签[key~='hello']{
    属性key的值包含单词hello的标签的样式属性
    key:value; 
}
```

# 2D\3D转换

## 2D

```css
/*从其当前位置移动元素*/
transform: translate(横向, 纵向);
/*旋转一定的角度*/
transform:rotate(角度deg);
/*增大或减小元素大小*/
transform:scale(宽度增大倍数,高度增大倍数);
```

## 3D

```css
/*元素绕其 X 轴旋转给定角度*/
transform: rotateX(角度deg);
/*元素绕其 Y 轴旋转给定角度*/
transform: rotateY(角度deg);
/*元素绕其 Z 轴旋转给定角度*/
transform: rotateZ(角度deg);
```

# 动画

```css
@keyframes 动画名
{
    from{开始样式}
    to{结束样式}
}
div{
    animation:动画名 时间;
}
```

## 动画属性

- **animation-name**：规定 @keyframes 动画的名称。
- **animation-play-state**：规定动画是运行还是暂停。
- **animation-duration**：定义需要多长时间才能完成动画
- **animation-delay**：规定动画开始的延迟时间
- **animation-iteration-count**：动画应运行的次数,infinite无限
- **animation-direction**：属性指定是向前播放、向后播放还是交替播放动画
  - **normal** - 动画正常播放（向前）。默认值
  - **reverse** - 动画以反方向播放（向后）
  - **alternate** - 动画先向前播放，然后向后
  - **alternate-reverse** - 动画先向后播放，然后向前
- **animation-timing-function**：规定动画的速度曲线

 