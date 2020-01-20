<!-- vim-markdown-toc GFM -->

* [名词](#名词)
* [css 基本样式](#css-基本样式)
	* [CSS 的规则如下：](#css-的规则如下)
	* [CSS 语法结构为：](#css-语法结构为)
	* [长度和尺寸](#长度和尺寸)
	* [CSS 样式类型分为三种：](#css-样式类型分为三种)
	* [区块模型/盒子模型](#区块模型盒子模型)
	* [字体](#字体)
	* [文本布局](#文本布局)
	* [font 简写](#font-简写)
	* [列表特定样式](#列表特定样式)
	* [选择器伪类：](#选择器伪类)
	* [Web字体](#web字体)
* [css 样式化区块](#css-样式化区块)
	* [设置宽高的约束](#设置宽高的约束)
	* [flex 布局详解](#flex-布局详解)
	* [背景](#背景)
	* [图片](#图片)
	* [表格](#表格)
	* [轮廓：](#轮廓)
* [高级区块效果](#高级区块效果)
	* [盒子阴影](#盒子阴影)
	* [圆角边框](#圆角边框)
* [css选择器](#css选择器)
	* [基础选择器](#基础选择器)
		* [标签选择器](#标签选择器)
		* [类选择器](#类选择器)
		* [ID选择器](#id选择器)
		* [通配符选择器](#通配符选择器)
	* [组合选择器](#组合选择器)
		* [标签指定式选择器](#标签指定式选择器)
		* [后代选择器](#后代选择器)
		* [并集选择器](#并集选择器)
	* [属性选择器](#属性选择器)
	* [伪类选择器](#伪类选择器)

<!-- vim-markdown-toc -->
## 名词
gradients(渐变) 、transitions(过渡) 与 animations(动画)

## css 基本样式
### CSS 的规则如下：
	- 一个选择器，它指定哪些元素应用 CSS 属性
	- 一组属性，属性的值更新了 HTML 的内容的显示方式

### CSS 语法结构为：
> 选择器{属性：值;属性：值;...}

1. 选择器：通常是你需要设置样式的 HTML 元素。
2. 属性：是你需要设置的样式属性，比如宽高，颜色，大小等。
3. 属性值：你需要设置的样式属性的具体值，比如宽高具体是多少 px，颜色具体是什么颜色。
4. ex
```
h1{
    color:red;
}
```

### 长度和尺寸
1. 像素（px）是一种绝对单位（absolute units），无论其他相关的设置怎么变化，像素指定的值是不会变化的
2. em：1 em 与当前元素的字体大小相同（一个大写字母M的宽度）。
	- 在 CSS 样式被应用之前，浏览器给网页设置的默认基础字体大小是 16 像素，也就是说 1 em 的计算值默认为 16 像素
	- 但是 em 单位是会继承父元素的字体大小，所以如果在父元素上设置了不同的字体大小，em 的像素值就会变得复杂。
	- em 是 Web 开发中最常用的相对单位。

3. rem（root em）：（root em）和 em 以同样的方式工作，但它总是等于默认基础字体大小的尺寸；继承的字体大小将不起作用，但是在旧版本的IE上不被支持。

4. 无单位的值
	- 在 CSS 中，你有时会遇到一些无单位的数值——这并不总是意味着错误，在某些情况下，使用无单位的数值也是可以的。比如无单位的 0。因为 0 就是 0，与单位无关。

5. 百分比
	- 大部分使用特定数值指定的内容同样可以使用百分比来指定。比如上面所提到的行高，如果行高单位是 "%"那么行高的计算也是：行高=文字大小`*`行高值。

6. 颜色
	- 颜色关键词：用英语名称的“关键字”来表示，比如：black，green，red，blue，yellow，white 等等。
	- 十六进制值：每个颜色包括一个哈希/磅符号（#）和其后面紧跟的六个十六进制数，其中每个十六进制数可以是 0 和 F 之间的一个值（一共 16 个），
		0123456789abcdef。每对十六进制数代表一个通道（红色、绿色或者蓝色）允许我们指定 256 个可用值。 (16 x 16 = 256)

	- RGB：一个 RG 值是一个函数——RGB() ——给定的三个参数，分别表示红色，绿色和蓝色通道的颜色值，这与十六进制值的工作方式大致相同。
		区别在于，RGB中每个通道不是由两个十六进制数字表示的，而是由 0 到 255 之间的十进制数表示的。
	
	- 不透明度（Opacity）:
		- 通过 opacity 设置透明度，CSS 中设置元素透明度有几种方法：
			- opacity : value ; value 值规定不透明度。从 0.0 （完全透明）到 1.0（完全不透明）。
			- 通过 RGBA，前三个值是 RGB 颜色值，最后一个是透明度的值。比如：background-color: RGBA(255,0,0,0.5);

### CSS 样式类型分为三种：
1. 内联式(行内式)：
	- 通过标签的 style 属性来设置元素的样式，语法格式为：

		```<标签名 style="属性1:属性值1; 属性2:属性值2; ..."> 内容 </标签名>```

	- 优点：十分灵活，书写方便，权重高（后面会提到）。

	- 缺点：只能操作某一个标签，没有实现样式和结构相分离。

2. 内嵌式（内部样式表）：
	- 将 CSS 代码集中写在 HTML 文档的 head 头部标签中，并且用 style 标签定义。语法格式为：

		```
		<head>
		<style type="text/css">
			选择器 {属性1:属性值1; 属性2:属性值2; ...}
		</style>
		</head>
		```
	- eg

		```
		<style type="text/css">
		p{color:blue;}
		</style>
		```
	- 优点：可以通过一条语句操作多个标签或类。

	- 缺点：只能控制一个页面，没有彻底实现样式和结构分离。

3. 外链式（外部样式表）：
	1. 将所有的样式放在一个或多个以 .CSS 为扩展名的外部样式表文件中，通过 link 标签将外部样式表文件链接到 HTML 文档中。语法格式为：

		```
		<head>
		<link href="CSS文件的路径"  rel="stylesheet" />
		</head>
		```

	2. 注：href 定义所链接外部样式表文件的 URL，可以是相对路径，也可以是绝对路径。
		rel 定义当前文档与被链接文档之间的关系，在这里需要指定为“stylesheet”，表示被链接的文档是一个样式表文件。

	3. 优点：一个单独的 CSS 文件，多个 HTML 文件可以引用一个 CSS 样式表文件。HTML 代码和 CSS 代码分离,要写什么就在哪个文件去找，修改方便。

	4. 注：行内样式表一般写在标签头部，内嵌式样式表、外联式一般写在<head></head>标签内。为了编码规范，希望大家尽量使用外联式来写我们的 CSS 代码。

### 区块模型/盒子模型
1. 所谓盒子模型就是把 HTML 页面中的元素看作是一个矩形的盒子，也就是一个盛装内容的容器。
	每个矩形都由元素的内容（content）、内边距（padding）、边框（border）和外边距（margin）组成

	![盒子模型](盒子模型.jpeg)

2. padding（内边距）
> padding 内边距位于内容框的外边缘与边界的内边缘之间

	1. padding-top:上内边距，padding-right:右内边距，padding-bottom:下内边距，padding-left:左内边距
	2. 设置内边距的写法
		- padding:5px 10px 15px 20px;表示上内边距是 5 px，右内边距是 10 px，下内边距是 15 px，左内边距是 20 px。
		- padding:5px 10px 15px;表示上内边距是 5 px，右内边距和左内边距是 10 px，下内边距是 15 px。
		- padding:5px 10px;表示上内边距和下内边距是 5 px，右内边距和左内边距是 10 px。
		- padding:10px;表示所有 4 个内边距都是 10 px。

	3. 注：padding 属性接受长度值或百分比值，但不允许使用负值。如果使用百分比值，百分数值是相对于其父元素的 width 计算的

3. border（边框）
> 元素的边框 (border) 是围绕元素内容和内边距的一条或多条线

	1. 边框语法：
	
	```
	border:border-width||border-style||border-color

	```
	2. border-top 设置上边框样式，border-bottom 设置下边框样式，border-left 设置左边框样式，border-right 设置右边框样式。
	3. border-width, border-style, border-color: 分别仅设置边框的宽度／样式／颜色，并应用到全部四边边界。
	4. 你也可以单独设置某一个边的三个不同属性，如 border-top-width, border-top-style, border-top-color 等。

	5. border-style 的值
		![border_style](border_style.png)

4. margin(外边距)
> 外边距（margin）代表 CSS 框周围的外部区域，称为外边距, 
	和 padding 类似，也有 margin-top、margin-right、margin-bottom 和 margin-left。写法仿照 padding。

	1. 与 padding 不同的是 margin 可以是负值
	2. 外边距合并指的是，当两个垂直外边距相遇时，它们将形成一个外边距。
		1. 合并后的外边距的高度等于两个发生合并的外边距的高度中的较大者（两个相邻的外边距都是正数时,折叠结果是它们两者之间较大的值；
		两个相邻的外边距都是负数时，折叠结果是它们两者之间绝对值较大的值;
		两个外边距一正一负的时候,折叠的结果是两者相加的和）。

		2. 边距合并问题只发生在块级元素之间

5. 高级的框操作
> 溢流：当你使用绝对的值设置了一个框的大小（如，固定像素的宽/高），允许的大小可能不适合放置内容，这种情况下内容会从盒子溢流

	1. 我们使用 overflow 属性来控制这种情况的发生
	2. 常用的值：
		- auto:当内容过多的时候溢流的内容被隐藏，然后出现滚动条，让我们滚动查看所有的内容。
		- hidden: 当内容过多，溢流的内容被隐藏。
		- visible: 当内容过多，溢流的内容被显示在盒子的外边。

6. CSS 框类型
	1. 我们可以通过 display 属性来设定元素的框类型。display 属性有很多的属性值。这里着重讲三个常见的 :block, inline, 和 inline-block。

	2. display 
		- display：block;将行内元素转换为块级元素。
		- display：inline;将块级元素转换为行内元素。
		- display：inline-block;转换为行内块元素

	3. 块级元素的特点：
		- 一个块级元素独占一行。
		- 元素的高度、宽度、行高以及顶和底边距都可设置。
		- 元素宽度在不设置的情况下，是它本身父容器的 100%（和父元素的宽度一致），除非设定一个宽度。
		- 常见的块级元素：<div>、<p>、<h1>、<form>、<ul>和 <li>。

	4. 行内元素的特点：
		- 和其他元素都在一行上。
		- 元素的高度、宽度、行高及顶部和底部边距不可设置。
		- 元素的宽度就是它包含的文字或图片的宽度，不可改变。
		- 常见的行内元素：<a>、<span>、<br>、<i>、<em>、<strong>、<label>。

	5. 行内块元素特点：同时具备内联元素、块状元素的特点。常见行内块元素：<img>、<input>。

7. 不常见的显示类型
	- display: table 允许你像处理table布局那样处理非tble元素
	
		![table布局](display_table.png)

	- display:flex; 弹性布局，用来为盒状模型提供最大的灵活性
		- 任何容器都可以指定flex布局
		- 行内元素通过：display: inline-flex;设置flex布局

### 字体
1. 颜色：通过 color 属性设置字体的颜色，color 值接受任何合法的 CSS 颜色单位。

2. 字体种类：通过 font-family 属性设置字体种类。
	font-family 可以把多个字体名称作为一个“回退”系统来保存，如果浏览器不支持第一个字体，则会尝试下一个，
	也就是说浏览器会使用它可识别的第一个值，它们之间用逗号隔开。
	比如：font-family: "Trebuchet MS", Verdana, sans-serif;
	
	下面再给大家介绍几种几乎所有系统都能够支持的几种字体：Arial，Courier New，Georgia，Times New Roman，Trebuchet MS，Verdana。

3. 字体大小：通过 font-size 属性设置。
	字体的常用单位是：px（像素），em（1em 等于我们设计的当前元素的父元素上设置的字体大小）。

4. 字体样式：通过 font-style 属性设置文字格式。
	- normal: 将文本设置为普通字体 (将存在的斜体关闭)。
	- italic: 如果当前字体的斜体版本可用，那么文本设置为斜体版本；如果不可用，那么会利用 oblique 状态来模拟 italics。
	- oblique: 将文本设置为斜体字体的模拟版本，也就是将普通文本倾斜的样式应用到文本中。

5. 字体粗细：通过 font-weight 属性设置字体的粗细。常用的有 normal：字体正常，bold：文字加粗。

6. 文本转换：通过 text-transform 属性转换字体。值包括：
	- none: 防止任何转型。
	- uppercase: 将所有文本转为大写。
	- lowercase: 将所有文本转为小写。
	- capitalize: 转换所有单词让其首字母大写。
	- full-width: 将所有字形转换成固定宽度的正方形，类似于等宽字体，允许对齐。拉丁字符以及亚洲语言字形（如中文，日文，韩文）

7. 文本装饰：通过 text-decoration 属性设置或者取消字体上的文本装饰，我们一般会使用这个属性去掉链接上的默认下划线。可用值为：
	- none: 取消已经存在的任何文本装饰。
	- underline: 文本下划线。
	- overline: 文本上划线。
	- line-through: 穿过文本的线。

### 文本布局
1. 文本对齐：通过 text-align 属性来控制文本它所在的内容盒子对齐的方式。常用值为：
	- left：文本左对齐。
	- right：文本右对齐。
	- center：文本居中对齐。

2. 行高：通过 line-height 属性来设置文本每行之间的高。
	- 浏览器默认字体大小为:16 px，而浏览器默认行高为：18 px。
	- 行高=上间距+文字大小+下间距。上下间距是相等的，如果字体大小为 20 px，它的父元素 div 的高度为 40 px，那么我们只需要设置行高为 40 px，就可以使文字相对于 div 盒子垂直居中。

### font 简写
1. 语法为：选择器{font:font-style font-weight font-size/line-height font-family}

2. 必须有字体大小和字体(font-size 和 font-family), 必须严格按顺序写。font-size 和 line-height 属性之间必须放一个正斜杠

3. eg: font:italic normal 20px/40px Arial;

### 列表特定样式
1. 符号样式：用 list-style-type 设置用于列表的项目符号的类型，例如无序列表的方形或圆形项目符号，或有序列表的数字，字母或罗马数字。常见的取值有：
	- disc 无序列表的默认值，实心圆。
	- circle 空心圆。
	- square 实心方块。
	- decimal 有序列表的默认值阿拉伯数字。
	- lower-alpha 小写英文字母。
	- upper-alpha 大写英文字母。

2. 项目符号位置： list-style-position
	- outside: 默认值，项目符号位于列表项之外
	- inside: 项目条目位于行内

3. 使用自定义的项目图片：通过background系列来设置
	- background-color：规定要使用的背景颜色
	- background-position：规定鳖精图片的位置:left(等价于left center或center left), right(right center, center right), top, bottom, center
	- background-size：规定别背景图片的尺寸：background-size: 60px, 80px;
	- background-repeat：规定如何重复图像：默认情况下，不断复制知道填满整个背景空间，如果只需要复制一次，使用no-repeat
	- backgrounc-image: 规定要使用的背景图像：充当项目符号的图片的参考路径。

	- eg: 在一个声明中设置所有的背景属性：

		```
		body {
			background: #00FF00 url(bgimage.gif) no-repeat fixed top;
		}
		```

### 选择器伪类：
1. 选择器伪类类型:
	- :link
	- :hover   悬停
	- :active  激活
	- :visited 访问过的

2. 超链接默认样式
	1. 具有下划线：可以通过text-decoration设置
	2. 未访问过的(Unvisited)的链接是蓝色的
	3. 访问过的(Visited)链接是紫色的
	4. 悬停(Hover)在一个链接时鼠标的光标会变成一个小手的图标
	5. 激活(Active)链接的时候会变成红色

### Web字体
1. 可以通过@font-face指定要下载的字体文件
	```
	@font-face {
		font-family: "Bitstream Vera Serif Bold";
		src: url("http://developer.mozilla.org/@api/files/2934/=VeraSebd.ttf");
	}
	```
2. 然后使用@font-face 指定的字体种类名称来将你的定制字体应用到你需要的地方
	
	```
	body { font-family: "Bitstream Vera Srif Bold", serif }
	```
## css 样式化区块
### 设置宽高的约束
1. 通过属性min-width、max-width、min-heigh和max-heigh设置宽高约束

2. 使用场景：
	将布局的外层宽度设置为百分比，但又不想太宽或太窄	

3. 解决方法：
	- 使用响应式布局
	- 给布局的宽度设置一个最大值和最小值限制

4. eg
```
width: 50%;
max-width: 1000px;
min-width: 5000px;
```
### flex 布局详解
> Flexible Box

1. 设为flex布局后，子元素的float、clear、vertical-align属性将失效

2. flex布局默认首行左对齐。

3. [flex布局详解](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)

4. [实验楼页面](https://www.shiyanlou.com/courses/1237/learning/)

### 背景
1. 属性：
	- background-color:
		1. 取值：red、 green、#FF00FF
		2. 大多数元素的背景色是 transparent（透明色），而不是 white（白色）

	- background-position:
		1. left：等价于left center或者center left
		2. right：等价于right center或者center right
		3. top、bottom、center

	- background-size:
		1. 背景图片的尺寸
		2. background-size: 60px 80px; 第一个是宽度，第二个是高度
		3. 使用两个通过空格分格的值，指定图像的水平（x）和垂直（y）坐标
		4. 图像的左上角为原点（0,0），x 坐标从左到右，y 坐标从上到下

	- background-repeat:
		1. 规定如何重复背景图片
		2. 默认是不断复制填满真个背景空间
		3. 背景图片只需复制一次，设置no-repeat
		4. repeat-x: 图像将在整个背景中水平地重复。
		5. repeat-y: 图像会在背景下垂直地重复。

	- background-image:
		1. 规定要使用的背景图象
		2. 充当项目符号的图片的参考路径。
		3. 颜色渐变。通过 linear-gradient() 函数设置，
			函数至少需要用逗号分隔的三个参数——背景中渐变的方向，开始的颜色和结尾的颜色。例如：

			1. background-image: linear-gradient(to bottom, red, blue);
			2. 渐变的方向可以通过关键字来指定方向 （to bottom，to right， to bottom right等）
			3. 或者使用角度值 (0 deg 相当于 to top，90 deg 相当于 to right，直到 360 deg，它再次相当于 to top ）

	- background-

### 图片
1. 属性：
	- height：
	- width
	- border：定义图片周围的边框

2. eg
	``` <img src="/aa.jpg" width='20px', height="200px", border="1"> ```

### 表格
1. 表格边框：border
```
table,th,td {
border: 2px, solid, red;
}
```

2. 折叠边框： border-collapse设置是否将边框折叠为单一边框
```
table {
border-collapse:collapse;
}
```

3. 表格的高度和宽度： width、height
```
table {
	width: 50%;
	height:50px;
}
```

4. 表格文本对齐的方式：
	- text-align设置水平对齐: 取值有left（左对齐）、right（右对齐）和center居中对齐
	- vertical-align设置垂直对齐方式，取值有top（顶对齐）、bottom（底部对齐）和middle（居中对齐）

	```
	td {
		height:50px;
	   vertical-align:top;
	}
	```

5. 表格内边距： 通过为td和th元素设置padding，控制表格中内容和边框的距离
```
td {
	padding: 30px;
}
```

6. 表格颜色： 通过color设置表格文本颜色， background-color设置表格背景颜色

7. 表格标题位置：caption-side，取值有：top(默认值，标题定位与表格之上)，bottom(把标题定位于表格之下)和inherit(规定应该从父元素继承caption-side的属性值)

### 轮廓：
1. outline: 是绘制于元素周围的一条线，位于边框的外围，可起到突出元素的作用。
	- outline-color: 设置轮廓的颜色，取值和其余颜色的取值一样
	- outline-style: 设置轮廓的样式：取值如下：
		- none: 默认，无轮廓
		- dotted：点状轮廓
		- dashed: 虚线轮廓
		- solid:  实线
		- double:  双线轮廓，宽度等同于outline-width的值
		- groove:  3D凹槽轮廓
		- ridge:   3D凸槽轮廓
		- inset：  3D凹边轮廓
		- outset   3D凸边轮廓
		- inherit  继承父元素的轮廓样式

	- outline-width: 轮廓的宽度，它的取值有：
		- thin 规定细轮廓
		- medium 中等，默认
		- thick  粗轮廓
		- length  允许你自己定义的轮廓粗细的值
		- inherit： 继承

2. 三个属性可以一起写：
```
p {
outline: red dotted thick;
}
```
## 高级区块效果
### 盒子阴影
1. box-shadow 属性设置盒子阴影。box-shadow 有四个值:
	- 第一个值是水平偏移量（水平阴影）：即向右的距离，阴影被从原始的框中偏移(如果值为负的话则为左)。
	- 第二个值是垂直偏移量（垂直阴影）：即阴影从原始盒子中向下偏移的距离(或向上，如果值为负)。
	- 第三个值是模糊半径（影子大小）：即在阴影中应用的模糊度。
	- 第四个值是阴影的基本颜色。你可以使用任何长度和颜色单位来定义这些值。

2. eg:
```
.shadow {
	box-shadow: 5px 5px 5px red;
	width: 200px;
	height: 100px;
	background-color: blue;
}
```

3. 多个盒子阴影：使用逗号隔开。
```
 box-shadow: 1px 1px 1px yellow,
              2px 2px 1px yellow,
              3px 3px 1px blue,
              4px 4px 1px blue,
              5px 5px 1px black,
              6px 6px 1px black;
```

4. 内部阴影: 使用 inset 关键字，把它放在一个影子声明的开始，使它变成一个内部阴影，而不是一个外部阴影
```
.shadow {
			box-shadow: inset 5px 5px 5px red;
			width: 200px;
			height: 100px;
			background-color: blue;
		}
```

### 圆角边框
1. border-radius：创建圆角
2. border-radius 的值除了用百分号（%）还可以用 length，比如：border-radius:25px;。
3. eg
```
.radius {
                width: 200px;
                height: 200px;
                border: 1px;
                background-color: red;
                border-radius: 50%;/*将正方形变成圆*/
		}
```

## css选择器
### 基础选择器
#### 标签选择器
1. 标签选择器也叫元素选择器。其实就是 html 代码中的标签，比如<html>、<body>、<h1>、<p>、<img>。

2. 语法格式为：
	标签名{属性1:属性值1; 属性2:属性值2; ...}

#### 类选择器
1. 类选择器，是对 HTML 标签中 class 属性进行选择。CSS 类选择器的选择符是 "."。

2. 类选择器命名规范：不能是纯数字，不能是标签名，不建议使用汉字。一般是点+对应样式描述。

3. 例如：.shadow

4. <font color=green>文档中的多个元素可以具有相同的类名，而单个元素可以有多个类名(以空格分开多个类名的形式书写)</font>

5. 样式显示效果跟 HTML 元素中的类名先后顺序没有关系,受 <font color=red>CSS 样式书写的上下顺序有关</font>

#### ID选择器
1. ID 是对 HTML 标签中 ID 属性进行选择。ID 选择器的选择符是 "#"。 

2. 任何元素都可以使用 id 属性设置唯一的 ID 名称。这是选择单个元素的最有效的方式。

3. 特别需要注意的是 ID 选择器具有唯一性，也就是说同一个 HTML 页面不能有相同的 ID 名称(使用多个相同的 ID 选择器，浏览器不会报错但是不符合 W3C 标准)

4. 语法格式为：
	#id名{属性1：value；属性2：value2}

#### 通配符选择器
1. 通配符选择器用“*”号表示，他是所有选择器中作用范围最广的，能匹配页面中所有的元素

2. 我们一般使用通配符选择器定义 CSS 样式，清除所有 HTML 标记的默认边距。

3. eg

```
* {
	margin: 0;
	padding: 0;
}
```
### 组合选择器
#### 标签指定式选择器
#### 后代选择器
#### 并集选择器

### 属性选择器

### 伪类选择器

