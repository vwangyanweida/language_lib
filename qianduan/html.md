<!-- vim-markdown-toc GFM -->

* [网站的文件处理](#网站的文件处理)
* [HTML 内容](#html-内容)
	* [HTML 标签](#html-标签)
		* [双标签](#双标签)
		* [单标签](#单标签)
		* [HTML链接](#html链接)
	* [name 和id](#name-和id)
	* [列表](#列表)
		* [有序列表: ol](#有序列表-ol)
		* [无序列表:ul](#无序列表ul)
		* [自定义列表:dl](#自定义列表dl)
	* [元数据](#元数据)
	* [块](#块)
	* [布局](#布局)
	* [文本格式](#文本格式)
	* [文档和网站架构](#文档和网站架构)
	* [表格](#表格)
	* [多媒体嵌入](#多媒体嵌入)
		* [图像标签](#图像标签)
		* [视频](#视频)
		* [音频](#音频)
		* [向量图](#向量图)
		* [iframe](#iframe)
		* [表单](#表单)
			* [表单原生组件](#表单原生组件)
		* [按钮](#按钮)
* [HTML5](#html5)
	* [新添标签](#新添标签)
	* [拖放](#拖放)
	* [cavas](#cavas)
	* [表单属性](#表单属性)
	* [输入类型](#输入类型)
	* [web Storage](#web-storage)
	* [文件上传](#文件上传)

<!-- vim-markdown-toc -->
## 网站的文件处理
1. 浏览器如何处理文件，文件的上传与下载，前端的各种处理方式：
	- 传统flash 上传
	- 新增iframe框ajax上传
		1. iframe框上传：通过新建一个隐藏的iframe框，把数据放到这个iframe框架里，
			然后把它提交到服务器端处理,服务器返回的信息也是由iframe框调用父框架的方法处理。

	- 表单数据提交
		1. 重点有两个，一个是FormData的数据对象，一个是level2的XMLHttpRequest对象
		2. eg：
			```
				var form= new FormData();
				form.append(field,file,filename)
				//filed是表单里的key，就类似于一般表单里的name，file文件对象，filename是传送到服务器里的文件名字，一般缺省。
			``` 	
		3. 当FormData里含有文件时，就要将enctype指定为multipart/form-data而不是application/x-www-form-urlencoded.
		``` `<form enctype="multipart/form-data">`</form>```
	
		4. XMLHttpRequest对象
			1. 创建xhr对象

				```
				if (typeof XMLHttpRequest !== 'undefined') {
					xhr = new XMLHttpRequest();
				} else {
					var v = [
						"Microsort.XmlHttp",
						"MSXML2.XmlHttp.2.0",
						"MSXML2.XmlHttp.1.0"
					];

					for (var i=0; i `< v.length; i++) {
						try {
							xhr = new ActiveXobject(v[i]);
							break;
						} catch (e) {}
					}
				}
				return xhr;
				```
	
			2. xhr 发起请求：
			```
			xhr.open(method,url,async);//method:请求的类型，GET或则POST；url：文件在服务器上的位置； async：bool类型，true为异步，false为同步。
			xhr.overridemimeType('...');//设定content-type，例如你想上传一个.txt文件，此处设置为text/plain
			xhr.send(form);//只有当请求类型method为POST时，才需要form参数
			```

			3. xhr处理事件：
			```
			xhr.onreadstatechange=function(evt) {
				if(this.readystate !==4) return;
				if(this.status==200){success...}//执行此判断时 readystate = 4.当(readystate !== 4 && status == 200) = true,执行success内容。
				else fail;
			};
			```

			4. xhr对象有0、1、2、3、4、五个状态，五个状态顺序变化。
				- onreadystatechagne事件在状态变化时触发。
				- 当状态为4的时候，会话结束，无论错误还是获得响应。
				- (readystate==4 && status==200)= true 说明从服务器成功获得响应，可以对服务器端返回的数据进行处理。

	- HTML5的新工具--File API

## HTML 内容
### HTML 标签
#### 双标签
1. 常见双标签
	- `<html>`</html>`
	- `<head>`</head>`
	- `<title>`</title>`
	- `<body>`</body>`
	- `<h1>`</h1>`
	- `<h2>`</h2>`
	- `<p>`</p>`
	- `<div>`</div>`
	- `<span>`</span>`
	- `<a>`</a>`
	- `<ul>`</ul>`
	- `<ol>`</ol>`
	- `<dt>`</dt>`
	- `<dd>`</dd>`
	- `<mark>`</mark>`
	- `<iframe>`</iframe>`

#### 单标签
1. 常见单标签
	- `<br/>`     `<!--换行-->`
	- `<hr />`    `<!--水平分隔线-->`
	- `<meta />`
	- `<img />`

#### HTML链接
1. 链接可以是一个字，一个词，或一组词，也可以是一幅图像

2. 两种使用`<a>`标签的方式 
	- 通过使用href属性：创建指向两一个文档的链接
	- 通过使用name属性：常见文档内的书签 /创建锚点时，最好使用ID

3. 通过name属性创建锚点的链接，使用户可以快速定位到目标内容，使用分为两步：
	- 使用`<a href="#id名">`创建链接文本
	- 使用响应的id名标注跳转目标的位置，name只能指定id。
	- 使用锚点时可以使用id而不需要在添加一个a，指定name，直接在标签中指定 id。

4. target:
	1. 用于指定链接页面的打开方式，其取值有_self和_blank两种
		- _self为默认值，使得目标文档载入并显示在相同的框架或者窗口中作为源文档
		- _blank为在新窗口打开方式。
### name 和id
0. 总结：
	1. id是浏览器端唯一确定的标示，但是将数据、表单传到服务端的时候，只会将name传送到服务端。
		如果一个input只写了id而没有写name，那么服务度将读取不到输入的数据，因为服务端只会读取name和对应的value，
		id不会传送到后端。

	2. 表单、输入接受页面里只能接收到name属性，ID只是在当前页面里控件的唯一标识(不可重复)
	
	3. 区别：
		- ID是在客户端脚本里用
		- NAME是用于获取提交表单的某表单域信息
		- 注意：在form里面，如果不指定name的话，就不会发送到服务器端

	4. 场景
		- name： input、select、form、frame、iframe 使用name
		- id： table、tr、td、div、p、span、h1、li 使用id

1. name的具体用途有：

	1. 作为可与服务器交互数据的HTML元素的服务器端的标示，比如input、select、textarea、和button等。
		我们可以在服务器端根据其name通过Request["name"]取得元素提交的值。

	2. HTML元素input type='radio'分组，我们知道radio button控件在同一个分组类，check操作是mutex的，
		同一时间只能选中一个radio，这个分组就是根据相同的name属性来实现的。

	3. 建立页面中的锚点，我们知道`<a href="url">`link`</a>`是获得一个页面超级链接，如果不用href属性，而改用name，
		如：`<a name="PageBottom">`</a>`，我们就获得了一个页面锚点。

	4. 作为对象的identity，如Applet、Object、Embed等元素。比如在Applet对象实例中，我们将使用其name来引用该对象。

	5.  在img元素和map元素之间关联的时候，如果要定义img的热点区域，需要使用其属性usemap，
		使usemap="#name"(被关联的map元素的name)。

	6. 某些特定元素的属性，如attribute，和param。例如为Object定义参数`<param name = "appletParameter" value= "value">`。

	7. name属性也可以作为客户端对象的标识,可以使用javascript的document.getElementByName('name')来获取对象

### 列表
#### 有序列表: ol
1. 有序列表有type和start属性
2. 语法格式：
```
`<ol type="value1" start="value2">`
	`<li>`</li>`
`</ol>`
```

3. value1表示有序列表项目符号的类型，value2表示项目开始的数值。

4. type 类型：
	- 1 表示使用数字
	- a 表示使用小写字母
	- A 表示使用大写字母
	- i 小时使用小写罗马数字
	- I 小时使用大写罗马数字

#### 无序列表:ul
> 无序列表是一个项目的列表，此列项目使用粗体圆点（典型的小黑圆圈）进行标记。无序列表始于 `<ul>` 标签。每个列表项始于`<li>`。
> 无序列表的各个列表项之间没有顺序级别之分，是并列的

1. ul 的 type 属性：默认值: disc，方块: square，空心圆: circle

#### 自定义列表:dl
> 自定义列表不仅仅是一列项目，而是项目及其注释的组合。

1. 自定义列表以`<dl>` 标签开始。每个自定义列表项以 `<dt>` 开始。每个自定义列表项的定义以 `<dd>` 开始。
2. 自定义列表的列表项前没有任何项目符号
3. eg
```
`<dl>`
	`<dt>`名词1`</dt>`
	`<dd>`名词1解释1`</dd>`
	...
	`<dt>`名词`</dt>`
	`<dd>`名词2解释1`</dd>`
	...
`</dl>`
```
### 元数据
> 元数据就是用来描述数据的数据。 HTML 中也有很多元数据，下面为大家简单介绍一下。

1. `<meta>`标签提供关于 HTML 文档的元数据：描述（description）、关键词（keywords）、文档的作者（author）等其他元数据

### 块
> 大多数 HTML 元素被定义为块级元素或内联元素。

1. 块级元素
    - 总是独占一行，表现为另起一行开始，而且其后的元素也必须另起一行显示。宽度(width)、高度(height)、内边距(padding)和外边距(margin)都可控制。
	- 常见块级元素： `<h1>`,`<p>`, `<ul>`, `<table>`。

2. 内联元素
	- 内联元素在显示时通常不会以新行开始。
		宽度(width)、高度(height)、内边距的 top/bottom(padding-top/padding-bottom)和外边距的 top/bottom(margin-top/margin-bottom)都不可改变。

	- 常见内联元素：`<b>`, `<td>`, `<a>`, `<img>`。

### 布局
> HTML 布局主要有两种：使用 div 元素的布局和使用 table 元素的布局

1. 使用div元素的布局

2. 使用table 布局

### 文本格式
> 文本格式其实就是文本的样式，比如说文章的换行，文字的加粗，斜体等等类似这些的，都是文本格式，这些都是通过文本格式标签实现的

1. 文本格式化标签
	- `<b>`		定义粗体文本
	- `<big>`		定义大号字
	- `<em>`		定义着重文字
	- `<i>`		定义斜体字
	- `<small>`	定义小号字
	- `<strong>`	定义加重语气
	- `<sub>`		定义下标字
	- `<sup>`		定义上标字
	- `<ins>`		定义插入字
	- `<del>`		定义删除字

### 文档和网站架构
1. 标题
	通常在顶部有一个大标题和（或）图标。 这是一个网站的主要常见信息，通常存在于每一个网页。

2. 导航
	提供跳转到网站不同内容的链接；通常由菜单按钮、链接或选项卡表示。

3. 主要内容
	中心的一个大区域，包含给定网页的大部分独特内容。

4. 侧栏
	一些次要信息、链接、引言、广告等。

5. 页脚
	横跨页面底部的条纹，通常包含精美的打印、版权通知或联系信息。

6. 为了实现这样的语义标记，HTML 提供了可以用来表示这些部分的专用标签，例如：

	- 标题：`<header>`
	- 导航栏：`<nav>`
	- 主要内容：`<main>`具有代表性的内容段落主题可以使用 `<article>`, `<section>`，`<div>`元素。
	- 侧栏：`<aside>`经常嵌套在`<main>`中
	- 页脚：`<footer>`

### 表格
1. <table>标签
	<table>... </table>标签用于在 HTML 文档中创建表格。它包含表名和表格本身内容的代码。

2. <tr>标签
	<tr>标签用于定义每一行。

3. <td>标签
	<td>标签用于定义每一列。

4. 表格的常用属性
	- border :注意,这个border是table中最小的单位,即每个td的外边框.
		每个cell都有四个边,所以一旦设置了这个border,两个cell之间是有空隙的,每个cell各自有自己的边.2X2的table,是有4个小矩形.

	- cellspacing: 单元格与单元格之间的距离
	- cellpadding: 设置文字与单元格之间的距离
	- width: 设置表格的宽度
	- heigt: 设置表格的高度
	- bgcolor: 设置背景颜色

5. 表头一般位于表格的第一行或第一列，其文本加粗居中显示，就类似于课程表上的第一行日期的显示，
	而表头的设置也很简单，只需要用<th></th>代替<td></td>即可。

6. 绘制表格的时候，我们常常需要合并单元格，而在 HTML 中提供了 colspan（合并行）和 rowspan（合并列）属性来帮助我们实现这一效果。
> colpan 又称跨列, rowspan又称跨行

7.  caption 元素定义表格标题
	caption 标签必须紧随 table 标签之后。你只能对每个表格定义一个标题。通常这个标题会被居中于表格之上。

8. 表格布局
> 在使用表格进行布局时，可以将表格划分为头部、主体和页脚，具体如下所示：

	1. `<thead></thead>`：用于定义表格的头部，一般包含网页的logo和导航等头部信息,位于`<table></table>`之中。
	2. `<tfoot></tfoot>`：用于定义表格的页脚，一般包含网页底部的企业信息，地址联系方式等，位于`<table></table>`标记之中，`<thead></thead>`标记之后。
	3. `<tbody></tbody>`：用于定义表格的主体，一般包含网页中除头部和底部之外的其他内容，位于`<table></table>`标记之中，`<tfoot></tfoot>`标记之后。
	4. 注：现在很多布局都是采用 div+css 的方式，如果大家对 table 布局感兴趣的话，可以直接搜索"搜狐股票"，然后点击 F12 查看源码。

### 多媒体嵌入
####  图像标签
> 在 HTML 中，图像由 <img> 标签定义。语法为：

```
<img src="url" alt="" />
```
1. `<img>` 是空标签，它只包含属性，没有闭合标签。
2. 要在页面上显示图像，你需要使用源属性（src）。src 的值是图像文件的 URL，也就是引用该图像的文件的的绝对路径或相对路径。
3. alt 规定图像的替代文本即当图片未成功显示的时候显示的文本信息。
4. title 设置鼠标悬停时显示的内容（一般不用设置）。
5. 此外还可以通过设置 width 和 height 的值来设置图片的宽和高。 
6. 相对路径
> 这种路径是以引用文件的网页所在位置为参考基础，而建立出的目录路径。
> 因此，当保存于不同目录的网页引用同一个文件时，所使用的路径将不相同，故称之为相对路径。

	- 图像文件和 HTML 文件位于同一文件夹：只需输入图像文件的名称即可，比如：<img src="syl.png" />。
	- 图像文件位于 HTML 文件的下一级文件夹：输入文件夹名和文件名，之间用“/”隔开，比如：<img src="img/img1/syl.png" />。
	- 图像文件位于 HTML 文件的上一级文件夹：在文件名之前加入“../” ，如果是上两级，则需要使用 “../ ../”，以此类推，比如：<img src="../syl.png" />。

7. 绝对路径
	指当所有网页引用同一个文件时，所使用的路径都是一样的

8.  自适应图片
> 网页前端开发的很多时候，我们需要让图片能够根据父元素自适应变化大小，从而使网页排版更加美观。
	1. 通过把 width 设置为 100%，使得图片随着窗口宽度的改变而自动适应变化大小

#### 视频
1. video标签
2. 属性
	- autoplay:  autoplay: 如果出现该属性,则视频在就绪后马上播放
	- controls:  controls: 如果出现该属性,则向用户显示控件,比如播放按钮
	- height:    pixels:   设置视频播放器的高度
	- loop:      loop:     如果出现该属性,泽当媒介文件播放完后再次开始播放
	- preload:   preload   如果出现该属性,则视频在二面加载时进行加载,并预备播放.如果使用autoplay,则忽略该属性
	- src:       url       要播放的视频的url
	- width:     pixels    设置视频播放器的宽度

#### 音频
1. audio 标签
	定义：用来嵌入音频

2. 属性:
	- autoplay:  autoplay: 如果出现该属性,则视频在就绪后马上播放
	- controls:  controls: 如果出现该属性,则向用户显示控件,比如播放按钮
	- loop:      loop:     如果出现该属性,泽当媒介文件播放完后再次开始播放
	- preload:   preload   如果出现该属性,则视频在二面加载时进行加载,并预备播放.如果使用autoplay,则忽略该属性
	- src:       url       要播放的视频的url
	- muted:     pixels    设置视频输出应该被静音.


3. eg
```
<audio controls="controls" src="http://labfile.oss.aliyuncs.com/courses/1236/平凡之路.mp3">
			平凡之路
</audio>

<audio controls="controls">
<source src="http://labfile.oss.aliyuncs.com/courses/1236/平凡之路.mp3" type="audio/mp3">
<source src="http://labfile.oss.aliyuncs.com/courses/1236/phone.mp3" type="audio/mp3">
			平凡之路
</audio>
```

	- 注意: 
		1. audio元素允许多个source 元素,source元素可以连接不同的音频文件,浏览器将使用第一个可识别的格式.
		2. 只有一个src时,可以将src写入audio标签

4. 音频播放器所占用的空间比视频播放器要小，由于它没有视觉部件，你只需要显示出能控制音频播放的控件。它不支持 width/height 属性。

5. 音频格式和浏览器的支持不同,兼容性兼容解决方案是jPlayer
	它是一个javaScript写的完全完全免费和开源的媒体库,作为jQuery插件的医院,使用jPlayer可以在网页上轻松加入狂平台的音乐和视频.

#### 向量图 
> 矢量图像，也称为面向对象的图像或绘图图像，在数学上定义为一系列由线连接的点。
> 矢量文件中的图形元素称为对象。每个对象都是一个自成一体的实体，它具有颜色、形状、轮廓、大小和屏幕位置等属性。
> 既然每个对象都是一个自成一体的实体，就可以在维持它原有清晰度和弯曲度的同时，多次移动和改变它的属性，而不会影响图例中的其它对象。
> 这些特征使基于矢量的程序特别适用于图例和三维建模，因为它们通常要求能创建和操作单个对象。
> 基于矢量的绘图同分辨率无关。这意味着它们可以按最高分辨率显示到输出设备上

1. 使用原因:
	电脑中的图像类型分为两大类，一类称为点阵图（位图），一类称为矢量图。 
	点阵图在图片放大的时候会出现模糊现象（你可以试着把一个 png 格式的图片放大观察一下），矢量图则不会。
	因此越来越多的人开始使用矢量图来作为网页图标。

2. 怎么添加矢量图
> 现在网上有很多免费开源的矢量图标库提供给我们使用，这里给大家推荐两个：

	- 阿里巴巴矢量图标库 http://iconfont.cn/
	- 谷歌浏览器里的矢量图库 https://icomoon.io/

#### iframe
> iframe 元素会创建包含另外一个文档的内联框架（即行内框架）,用于嵌入其他网页。

1. 语法：
```
<iframe  src="规定在 iframe 中显示的文档的 URL" width="" height=""  frameborder="1/0"  name="iframe名称"  scrolling="yes/no/auto">
</iframe>
```

2. 常用属性说明：
	- align:  left/right/top/middle/bottom   :不赞成使用,请用css代替
	- frameborder:   1 / 0                   :规定是否显示框架周围的边框
	- height:       pixels / %				 : 规定iframe的高度
	- longdesc:     URL                      :规定一个页面,该页面包含了有关iframe的较长描述
	- marginheight:  pixels                  : 定义iframe的顶部和底部的边距
	- marginwidth:  pixels                   : 定义iframe的左侧和右侧的边距
	- name:         `frame_name`             : 规定iframe的名称
	- sandbox    : allow-forms/allow-same-origin/allow-scripts/allow-top-navigation   : 规定一系列对`<iframe>`中内容的额外限制
	- scrolling:    yes/no/auto		         : 规定是否在iframe中显示滚动条
	- seamless:    seamless			         : 规定`<iframe>`看上去像是包含文档的一部分
	- src: 	       URL						 : 规定iframe中显示的文档的URL
	- srcdoc:      `HTML_code`               : 规定在iframe中显示的页面的HTML内容
	- width:       pixels                    :定义iframe的宽度

#### 表单
1. HTML 表单概述
表单在网页中主要负责数据采集功能。一个表单有三个基本组成部分：

    - 表单标签：这里面包含了处理表单数据所用 CGI 程序的 URL 以及数据提交到服务器的方法。
    - 表单域：包含了文本框、密码框、隐藏域、多行文本框、复选框、单选框、下拉选择框和文件上传框等。
    - 表单按钮：包括提交按钮、复位按钮和一般按钮；用于将数据传送到服务器上的 CGI 脚本或者取消输入，还可以用表单按钮来控制其他定义了处理脚本的处理工作。

2. 语法:
	```
	<form name="form_name" method="get/post" action="url"></form>
	```

3. 属性:
	- name：定义表单的名字。
	- method：定义表单结果从浏览器传送到服务器的方式，默认参数为：get 。post 安全性更高，因此常用作传输密码等，而 get 安全性较低，一般用于查询数据。
	- action：用来指定表单处理程序的位置(服务器端脚本处理程序）

4. 发送数据:
	<form>元素定义了如何发送数据。它的所有属性是对用户点击提交按钮时所发送的请求进行了配置。两个与之相关的属性是 action 和 method。

5. 定义了发送数据要去的地址。它的值必须是一个有效的 URL，可以是相对 URL 也可以是绝对 URL。
	如果没有提供此属性或者action="#"，则数据将被发送到包含表单的页面的 URL。

6. 表单验证
	- required属性: 输入值不能为空,如果输入值为空，将会提示错误信息。
		```
		<form>
	 	<label for="place">where are you want to go?</label>	
		<input id="place" name="place" required>
		<button>submit</button>
		</form>
		```
	- 强制条目的长度: minlength, maxlength

7. fieldset 和 legend 元素 
> `<fieldset>` 元素组合表单中的相关数据，`<legend>` 元素为 `<fieldset>` 元素定义标题

8. label
	- 为 input 元素定义标注（标记）,当用户选择该标签时，浏览器就会自动将焦点转到和标签相关的表单控件上。
	- `<label>` 标签的 for 属性应当与相关元素的 id 属性相同，使得`<label>` 标签与 `<input>` 正确相关联。

##### 表单原生组件
1. 文本输入框
> 文本输入框是最基本的表单组件，它便于用户输入各种数据。
> 注：HTML 文本框只是个纯文本输入控件。
> 这就意味着你不能用它来进行富文本编辑（如加粗、斜体等）。所谓的富文本编辑器其实都是自定义的组件

	1. 所有文本域的通用规范
		
	    - 它们可以被标记为 readonly (用户不能修改输入值)甚至是 disabled (输入值永远不会与表单数据的其余部分一起发送)。
		- 它们可以有一个 placeholder; 这是文本输入框中出现的文本，用来简略描述输入框的目的。
		- 它们都受 size (输入框的物理尺寸) 和 length (文本框可以输入的最大字符数)约束。
		- 如果浏览器支持的话，可以进行拼写检查。

2. 单行文本框
> 单行文本框使用type属性值为text的`<input>`元素创建的(若未提供type属性值,text为默认值).
> 此外,如果你指定给type的属性值不被浏览器所支持(比如type="date"),也会使用text作为它的值.

	1. 单行文本框只有一个真正的约束:如果你输入带有换行符的文本,浏览器会在发送数据之前删除这些换行符.
	2. eg
	```
	<input type="text" id="text" name="text" value="I'm a text">
	```
3. e-mail 输入框
> 该类型的输入框设置type值为email
	
	1. 它给输入框添加了这样的验证约束:用户需要输入一个有效的e-mail地址;
	2. 其他任何输入都会导致输入框报错.
	3. 而通过设置multiple属性,这种输入框也可以让用户输入多个e-mail地址(多个e-mail地址之间用逗号隔开)
	4. eg
	```
	<input type="email" id="email" name="email" multiple>
	```

4. 密码输入框
> 该类型的输入框设置type值为password

	1. eg
	```
	<input type="password" id="pwd" name="pwd">
	```

5. 搜索框
> 该类型的输入框设置type为search
	
	1. eg
	```
	<input type="search" id="search" name="search">
	```

6. 电话号码输入框
> 该类型的输入框设置type为tel

	1. eg
	```
	<input type="tel" id="tel" name="tel">
	```

7. url输入框
> 该类型的输入框设置type为url

	1. eg:

	```
	<input type="url" id="url" name="url">
	```

	2. 注：它为字段添加了特殊的验证约束，如果输入值是个不符合格式的 url，浏览器就会报告错误。符合 url 格式并不意味着它引用了一个实际存在的位置。

8. 多行文本框
> 使用 <textarea>元素。

	1. eg:
	```
	<textarea cols="每行中的字符数" rows="显示的行数"></textarea>
	```

	 2. 注：textarea 和常规的单行文本字段之间的主要区别是，允许用户输入包含硬换行符(即按回车)的文本。
	 3. 可以通过 cols 和 rows 属性来规定 textarea 的尺寸，不过更好的办法是使用 CSS 的 height 和 width 属性。
	 4. 另外在大多数浏览器中，文本区域在右下角有一个拖放操作，允许用户调整它的大小。
	 5. 这种调整能力可以通过使用 CSS 设置文本区域的 resize 值为 none 来关闭。

9. 下拉组件
> HTML 有两种下拉组件：选择框和自动补全组件。
> 这两者的交互方式是一样的，一旦控件被激活，浏览器会展示列表的值让用户从中选择，这个值列表会覆盖在页面内容之上。

	1. 选择框语法:
	```
	<select>
		<option>选项一</option>
		<option>选项二</option>
		<option>选项三</option>
		<option>选项四</option>
	</select>
	```
	2. selelct 标记的常用属性:
		- size:  指定下拉菜单的可见选项数
		- multiple:  定义: multiple="multiple" : 规定可以选择多个选项
			- window使用Ctrl按钮来选择多个选项
			- mac: 按住command按钮来选择多个选项

	3. option标记的常用属性:
		- selected: 定义selected="selected", 当前选项即为默认选择项.

	4. 自动补全组件
		1. 使用<datalist>元素来为表单小部件提供建议的、自动完成的值，并使用一些<option>子元素来指定要显示的值。
		2. 然后使用 list 属性将数据列表绑定到一个文本域(通常是一个 <input>元素)。

		3. 一旦数据列表与表单小部件相关联，它的选项用于自动完成用户输入的文本。
		4. 通常，这是作为一个下拉框向用户展示的，在输入框中输入可能匹配的内容
		5. eg
		```
		<label for="myColor">What's your favorite color?</label>
		<input type="text" name="myColor" id="myColor" list="mySuggestion">
		<datalist id="mySuggestion">
			<option>black</option>
			<option>blue</option>
			<option>green</option>
			<option>red</option>
			<option>black</option>
			<option>yellow</option>
		</datalist>
		```

10. 可勾选组件
> 可勾选组件指的是通过点击能够改变其状态的组件。

	1. 有两种可勾选组件：复选框和单选框，它们都可以通过 checked 属性来指示该组件是否默认被勾选。
	2. 值得注意的是，对大多数表单组件而言，表单提交后所有具有 name 属性的组件都会被提交，即使它们没有获值。
	3. 但对于可勾选组件，它们的值却只有在它们被勾选之后才会提交，换而言之：如果没有勾选，则不会提交任何东西
	4. 复选框:
		1. `<input type="checkbox" checked>`
	5. 单选框:
		1. `<input type="radio" checked>`

	6. 几个单选按钮可以连接在一起,只需要把它们的 name 值设置为相同的。
		同一组中只有一个按钮可以同时被选。
		如果没有选中任何一个，那么整个单选按钮池就被认为处于未知状态，且不会随表单提交。

	7. <font color=red>因该是表单只提交name有值的勾选组件,所以多个单选框有同样的name则会只提交选中的那个.
		而前端也是只为name绑定一个值,则只有一个可以被选中.</font>  

#### 按钮
> HTML 表单中，有三种按钮：提交按钮，重置按钮,匿名按钮。

1. 我们可以使用 <button>元素或者<input>元素来创建一个按钮。type 属性的值指定显示什么类型的按钮。
2. 提交按钮（submit）
> 用于发送表单数据给服务器。

	1. 语法：
	```
	<button type="submit">
	This a submit button
	</button>

	<!--or-->

	<input type="submit" value="This is a submit button">
	```

3. 重置按钮
> 用于重置所有表单组件为默认值。

	1. 语法：
	```
	<button type="reset">
    This a reset button
	</button>

	<!--or-->

	<input type="reset" value="This is a reset button">
	```

4. 匿名按钮（button）
> 没有自动生效的按钮，但是可以使用 JavaScript 代码进行定制。如果你省略了 type 属性，那么这就是默认值。

	1. 语法：
	```
	<button type="button">
    This a anonymous button
	</button>

	<!--or-->

	<input type="button" value="This is a anonymous button">
	```
5. 不管使用的是<button>元素还是<input>元素，按钮的行为都是一样的。它们的不同点在于：

	- 从前面的例子中也可以看出<button>元素允许你使用 HTML 内容作为其标记内容，但<input>元素只接受纯文本内容。
	- 使用<button>元素，可以有一个不同于按钮标签的值(通过将其设置为 value 属性)。（但是在 IE 8之前的版本中是不行的）

## HTML5
### 新添标签 
1. 新添header,nav,article,section,aside,footer代替使用div+css
```
<!DOCTYPE html>
<html>
    <head>
        <title>my page</title>
    </head>
    <body>
        <header>header</header>
        <nav>nav</nav>
        <article>
            <section>section</section>
        </article>
        <aside>aside</aside>
        <footer>footer</footer>
    </body>
</html>
```

2. section 标签
> `<section>` 表示文档中的一个区域（或节）。
> 比如章节、页眉、页脚或文档中的其他部分，一般来说会包含一个标题
	
	1. eg
	```
	<section>
		<h1>section name</h1>
		<p>一个新章节</p>
	</section>
	```

	2. 注：不要把 <section> 元素作为一个普通的 div 容器来使用。
		一般来说，一个 <section> 应该出现在文档大纲中。

3. article
> `<article>` 标签定义独立的内容。
> 常常使用在论坛帖子，报纸文章，博客条目，用户评论等独立的内容项目之中。
> article 可以嵌套，内层的 article 对外层的 article 标签有隶属关系。

	1. eg
	```
	<article>
            <h1>实验楼是什么</h1>
            <p>一个在线学习的网站</p>
	</article>
	```

4. nav标签
> `<nav>` 标签定义导航链接的部分：
	描绘一个含有多个超链接的区域，这个区域包含转到其他页面，
	或者页面内部其他部分的链接列表
	
	1. 并不是所有的链接都必须使用 `<nav>` 标签,它只用来将一些热门的链接放入导航栏。
	2. 一个网页也可能含有多个 <nav> 标签,例如一个是网站内的导航列表,另一个是本页面内的导航列表。

5. header
> `<header>` 标签定义文档的页眉，通常是一些引导和导航信息。
> 它不局限于写在网页头部，也可以写在网页内容里面。

	1. 通常 header 标签至少包含一个标题标记（h1-h6），还可以包括 hgroup 标签，还可以包括表格内容、标识、搜索表单、nav 导航等。

	2. eg
	```
	<body>
        <header>
            <h1>网站标题</h1>
            <h1>网站副标题</h1>
        </header>
    </body>
	```

6. footer 标签
> `<footer>` 标签定义 section 或 document 的页脚，
包含了与页面、文章或是部分内容有关的信息，比如说文章的作者或者日期。 
它和 header 标签使用基本一样，可以在一个页面中多次使用，
如果在一个区段的后面加入了 footer 标签，那么它就相当于该区段的页脚了。

7. aside 标签
> `<aside>` 标签表示一个和其余页面内容几乎无关的部分，
被认为是独立于该内容的一部分并且可以被单独的拆分出来而不会使整体受影响。
其通常表现为侧边栏或者嵌入内容。
他们通常包含在工具条，例如来自词汇表的定义。也可能有其他类型的信息，例如
相关的广告、笔者的传记、web 应用程序、个人资料信息，或在博客上的相关链接。

8. figure 标签
> `<figure>` 标签规定独立的流内容（图像、图表、照片、代码等等）。

	1. figure 元素的内容应该与主内容相关，但如果被删除，则不应对文档流产生影响

### 拖放
> 拖放（Drag 和 drop）是 HTML5 标准的组成部分，任何元素都能够拖放，从字面意思上来理解，拖放就是抓取对象后拖到另一个位置上。

1. 在 MDN 官方文档中拖放是这样描述的：
	- HTML 拖放接口使应用程序能够在 Firefox 和其他浏览器中使用拖放功能。
	- 例如，通过这些功能，用户可以使用鼠标选择可拖动元素，将元素拖动到可放置元素，并通过释放鼠标按钮来放置这些元素。
	- 可拖动元素的一个半透明表示在拖动操作期间跟随鼠标指针。

2. 对于网站、扩展以及 XUL 应用程序来说，你可以自定义能够成为可拖拽的元素类型、可拖拽元素产生的反馈类型，以及可放置的元素。

3. 注：img 元素和 a 元素（必须指定 href）默认允许拖放。

4. 拖放是如何实现的
	1. 确定什么是可拖动的
		为了使元素可拖放，首先把 draggable 属性设置为 true，再加上全局事件处理函数 ondragstart，如下所示：
		```
		<img draggable="true" ondragstart="drag(event)" />		
		```

	2. 定义拖动数据
		每个drag event 都有一个dataTransfer属性保存事件的数据.这个属性(Data Transfer对象)也有管理拖动数据的方法.
		setData()方法添加一个项目的拖拽数据,如下图的实力代码所示:
		```
		function drag(ev) {
			ev.dataTransfer.setData("Text", ev.target.id);
		}
		```

	3. 定义一个放置区
		ondragover事件规定在何处放置被拖动的数据.默认地,无法将数据/元素放置到其他元素中.如果需要设置允许放置,我们必须阻止对元素的默认处理方式:
		```
		function allowDrop(ev) {
			ev.preventDefault();
		}
		```

	4. 进行放置
		1. 当放置被拖数据时,会发生drop事件:
		```
		function (ev) {
			//调用 preventDefault()来比避免浏览器对数据的默认处理
			ev.preventDefault();
			//通过dataTransfer.getData("Text")方法获得被拖拽的数据,该方法将返回在setData()方法中设置为相同类型的任何数据
			var data = ev.dataTransfer.getData("Text");
			//<font color=red>被拖数据是被拖元素的id, 把被拖元素追加到放置元素中</font>
			ev.target.appendChild(document.getElementById(data));
		}
		```

		2. ev是发生在element上的事件,ev的target是发生事件的元素

6. 事件:
    1. 在拖动目标上触发事件 (源元素):
        ondragstart - 用户开始拖动元素时触发
        ondrag - 元素正在拖动时触发
        ondragend - 用户完成元素拖动后触发

    2. 释放目标时触发的事件:
        ondragenter - 当被鼠标拖动的对象进入其容器范围内时触发此事件
        ondragover - 当某被拖动的对象在另一对象容器范围内拖动时触发此事件
        ondragleave - 当被鼠标拖动的对象离开其容器范围内时触发此事件
        ondrop - 在一个拖动过程中，释放鼠标键时触发此事件

	3. 注意： 在拖动元素时，每隔 350 毫秒会触发 ondragover 事件。

7. 总结:
	1. 被拖动元素
		- 设置可以被拖动: draggable="true"
		- 设置拖动元素需要传递的value: 
			1. ondragstart 事件触发时调用函数
			2. 函数中调用 ev.dataTransfer.setData("Text", ev.target.id) 设置传递的value

	2. 放置的目标
		- 默认地，无法将数据/元素放置到其他元素中。如果需要设置允许放置，我们必须阻止对元素的默认处理方式		
			1. 当拖动的标签移动到容器时,触发的事件绑定到一个函数:
			2. 调用ev.preventDefault(), 阻止默认程序触发.
	
		- 当释放标签事件触发时,定义需要执行的操作.

### cavas
1. Canvas 就是一个画布，主要用于图形表示、图表绘制、游戏制作，主要有如下特征：

	- Canvas 像传统的银幕，是一个矩形，并且它是一个无色透明的区域。
	 
	- 在 Canvas 里绘画并不是说类似于 “你画我猜” 之类的用鼠标来作画，而是需要 JavaScript 脚本来绘制图形。
	  
	- Canvas 区域中的每个像素都可控，即像素级操作。
	  
	- Canvas 拥有多种绘制路径、矩形、圆形、字符以及添加图像的方法。
	  
	- 只要是支持 HTML5 标准的浏览器都支持 Canvas。

2. Canvas左上角为原点坐标,只有正坐标,无负坐标

3.  直线绘制

	- strokeStyle：设置或返回笔的颜色、渐变或模式。默认值为：#000000。
	 
	- lineWidth：设置或返回当前的线条宽度 ，以像素计。
	  
	- beginPath()：起始一条路径，或重置当前路径。
	  
	- closePath()：创建从当前点回到起始点的路径。
	  
	- moveTo()：把路径移动到画布中的指定点，不创建线条。
	  
	- lineTo()：添加一个新点，然后在画布中创建从该点到最后指定点的线条。
	  
	- stroke()：绘制已定义的路径。

4. 创建Canvas
	1. 向HTML5页面添加canvas元素,规定元素的id,宽度和高度:
	```
	<canvas id="myCanvas" width="520px" height="1314px">
	对不起,你的浏览器不支持canvas
	</canvas>
	```
	2. 通过js来绘制
	> canvas元素本身是没有绘图能力的,所有的绘制工作必须在js内部完成
	
		1. 首先获得canvas元素
			``` var myCanvas=document.getElementById("myCanvas"); ```

		2. 创建context 对象:
			```var ctx = myCanvas.getContext("2d")
				or
				var ctx = document.getElementById("mycanvas").getContext("2d");
			```

			- 2d 是当前唯一的合法值,指定了绘制二维图,并且导致getContext()方法返回一个环境对象,
			- 该对象导出一个二维绘图API,拥有多种绘制路径,举行,原型,字符以及添加图象的方法.

5. 直线绘制
	- strokeStyle：设置或返回笔的颜色、渐变或模式。默认值为：#000000。
	 
	- lineWidth：设置或返回当前的线条宽度 ，以像素计。
	 
	- beginPath()：起始一条路径，或重置当前路径。
	 
	- closePath()：创建从当前点回到起始点的路径。
	 
	- moveTo()：把路径移动到画布中的指定点，不创建线条。
	 
	- lineTo()：添加一个新点，然后在画布中创建从该点到最后指定点的线条。
	 
	- stroke()：绘制已定义的路径。

6. 矩形绘制
	1. rect() 方法介绍
		1. 使用 rect() 方法创建矩形。语法为：

			```ctx.rect(x,y,width,height);```

		2. 参数说明：
			- x 表示矩形左上角的 x 坐标。
			 
			- y 表示矩形左上角的 y 坐标。
			 
			- width 表示矩形的宽度，以像素计。
			 
			- height 表示矩形的高度，以像素计。
			 
			- 注：使用 stroke() 或 fill() 方法在画布上实际地绘制矩形。

	2. strokeRect()方法: 使用strokeRect()方法绘制矩形(不填色),笔触的默认颜色是黑色
		1. 语法为:
			```ctx.strokeRect(x,y,width,height);```

		2. 参数与rect()方法一致,唯一的区别是这个不需要添加一句stroke()或fill()方法.无法填色.

	3. fillRect()方法介绍:使用fillRectangle()方法创建实心矩形.
		1. 语法为:
			```ctx.fillRect(x,y,width,height);```

		2. 参数说明和前面一致,默认的填充颜色是黑色,可以使用fillStyle属性来设置用于填充绘图的颜色,渐变或模式.

	4. clearRect(): 使用clearRect()方法清除给定矩形内指定像素
		1. 语法为:
			```ctx.clearRect(x,y,width,height);```

7. 圆和椭圆的绘制
	1. 使用acr()方法绘制圆或者椭圆,语法为:
	```
	ctx.arc(x, y, r, sAngle, eAngle, counterclockwise);
	```

	2. 参数说明:

		- x 表示圆的中心的 x 坐标。

		- y 表示圆的中心的 y 坐标。

		- r 表示圆的半径。

		- sAngle 表示起始角，以弧度计（特别需要注意的是弧的圆形的三点钟位置是 0 度而不是常规以为的 90 度）。

		- eAngle 表示结束角，以弧度计。

		- counterclockwise 表示绘制圆的方向，值为 false 表示顺时针，为 true 表示逆时针。是一个可选值，默认值是 false。

8. 贝塞尔曲线绘制
	1. Canvas 可以绘制两种贝塞尔曲线：二次贝塞尔曲线和三次贝塞尔曲线:
		1. 二次贝塞尔曲线

			1. 语法为：ctx.quadraticCurveTo(cpx,cpy,x,y);
			2. 参数说明：
			    - cpx 表示贝塞尔控制点的 x 坐标。
				- cpy 表示贝塞尔控制点的 y 坐标。
				- x 表示结束点的 x 坐标。
				- y 表示结束点的 y 坐标。
			3. 二次贝塞尔曲线需要两个点。
				- 第一个点是用于二次贝塞尔计算中的控制点，第二个点是曲线的结束点。
				- 曲线的开始点是当前路径中最后一个点。
				- 如果路径不存在，那么我们使用 beginPath() 和 moveTo() 方法来定义开始点

		2. 三次贝塞尔曲线
			1. 语法为： ctx.bezierCurveTo(cp1x,cp1y,cp2x,cp2y,x,y);
			2. 参数说明：

				- cp1x 表示第一个贝塞尔控制点的 x 坐标。
			    - cp1y 表示第一个贝塞尔控制点的 y 坐标。
				- cp2x 表示第二个贝塞尔控制点的 x 坐标。
				- cp2y 表示第二个贝塞尔控制点的 y 坐标。
				- x 表示结束点的 x 坐标。
				- y 表示结束点的 y 坐标。
			 
			3. 注：和二次贝塞尔曲线不同的是多了一个控制点。

9. 填充
> 使用 fillStyle 属性，设置或返回用于填充绘画的颜色、渐变或模式。

	1. 语法为：ctx.fillStyle = color|gradient|pattern;
	2. 参数说明:
		- color 表示绘图填充的颜色。默认值是 #000000。
		- gradient 表示用于填充绘图的渐变对象（线性或放射性）。
		- pattern 表示用于填充绘图的 pattern 对象

	3. eg:实心矩形,填充红色
	```
	<canvas id="myCanvas" width="200px", height="1214px">
		对不起,你的浏览器不支持cavas
	</canvas>

	<script type="text/javascript">
	var mycanvas = document.getElementById("myCanvas");
	var ctx = mycanvas.getContext("2d");
	ctx.fillStyle="red";
	ctx.fillRect(10, 10, 100, 200);
	```

10. 渐变:
	1. 使用createLinearGradient()方法创建线性渐变,语法为: ctx.createLinearGradient(x0, y0, x1, y1);
	2. 参数说明:
		- x0表示渐变开始点的x坐标
		- y0表示渐变开始点的y坐标
		- x1 表示渐变结束点的 x 坐标。
		- y1 表示渐变结束点的 y 坐标。

	3. 使用addColorStop()方法规定渐变对象中的颜色和停止位置,语法为: gradient.addColorStop(stop, color);
	4. 参数说明:
		- stop: 表示渐变中开始与结束之间的位置,是介于0.0与1.0之间的值.
		- color:表示在结束位置显示的css颜色值.
	5. 注：addColorStop() 方法与 createLinearGradient() 或 createRadialGradient() 一起使用。
		我们可以多次调用 addColorStop() 方法来改变渐变。如果我们不对 gradient 对象使用该方法，那么渐变将不可见。
		为了获得可见的渐变，至少需要创建一个色标

	6. eg:
	```
	var myCavas ...
	var ctx = ...
	var gradient = ctx.createLinearGradient(0, 0, 170, 0);
	gradient.addColorStop(0, "red");
	gradient.addColorStop("0.2", "orange");
	gradient.addColorStop("0.5", "yellow");
	gradient.addColorStop("0.7", "green");
	ctx.fillStyle = gradient;  //设置填充色为gradient
	ctx.fiilRec(10, 10, 100, 200);
	```
	7. 注:
		1. createLinearGradient()方法创建的线性渐变是从开始坐标到结束坐标之间按照渐变来,
			- 这个区间之前就是addColorStop为0时的颜色
			- 超出这个区间之后的是1的颜色.
			- <font color=red>没有填充时就已经有渐变色了,填充是将渐变色显示出来</font>

	8. 使用createRadialGra()方法创建放射状/环形的渐变。语法为: ctx.createRadialGradient(x0, y0, r0, x1, y1, r1);
	9. 参数说明:
		- x0 表示渐变的开始圆的 x 坐标。

		- y0 表示渐变的开始圆的 y 坐标。

		- r0 表示开始圆的半径。

		- x1 表示渐变的结束圆的 x 坐标。

		- y1 表示渐变的结束圆的 y 坐标。

		- r1 表示结束圆的半径

	10. fill()方法
		1. 使用fill()方法填充当前图像(路径).默认颜色是黑色,填充另一种颜色/渐变使用fillStyle属性.
		2. 语法为: ctx.fill();
		3. 如果路径未关闭,那么fill()方法会从路径结束点到开始点之间添加一条线,以关闭该路径,然后填充该路径.

11. 文字绘制
	1. fillText(): 使用fillText()方法在画布上绘制实心文本
		- 语法为```ctx.fillText(text, x, y, maxWidth);```
		- 参数说明:
			- text 文本
			- x: 文本绘制的x坐标
			- y: 文本绘制的y坐标(相对于画布)
			- maxWidth: 表示允许的最大文本宽度,以像素计.可选

	2. storkeText(): 在画布上绘制空心文本
		- 语法为: ```ctx.strokeText(text, x, y, maxWidth);```

	3. font 属性:
		使用font属性设置或返回画布上的内容的当前字体属性,font属性使用的语法和css font属性相同.

	4. textAlign属性: 使用textAlign属性设置或返回文本内容的当前对齐方式
		- 语法为: ```ctx.textAlign="center | end | left| right|start";```
		- 参数说明:
			- start 默认值，表示文本在指定的位置开始。

			- center 表示文本的中心被放置在指定的位置。

			- end 表示文本在指定的位置结束。

			- left 表示文本左对齐。

			- right 表示文本右对齐。

		- 注意: 使用fillText或者stokeText在实际的画布上绘制并定位文本.

	5. textBaseline属性: 设置或返回绘制文本时当前文本基线
		- 语法为: ```ctx.textBaseline("alphabetic|top|handing|middle|ideographic|bottom")```
		- 参数:
		    - alphabetic 表示文本基线是普通的字母基线。默认值。

			- top 表示文本基线是 em 方框的顶端。

			- hanging 表示文本基线是悬挂基线。

			- middle 表示文本基线是 em 方框的正中。

			- ideographic 表示文本基线是表意基线。

			- bottom 表示文本基线是 em 方框的底端。

12. 图片绘制
	1. 使用drawImage()方法在画布上绘制图像,画布或视频,drawImage()也能够绘制图像的某些部分,或增加减少图像的尺寸.
	2. canvas绘制图像的基本格式为:
	```
	var img = new Image();
	image.src = "xxx";
	image.onload = function() {
		ctx.drawImage();
	}
	```

	3. 三种语法:
		1. 在画布上定位图像:
			- ctx.drawImage(img, x, y);

		2. 在画布上定位图像,并规定图像的宽度和高度:
			- ctx.drawImage(img, x, y, width, height);

		3. 剪切图像,并在画布上定位被剪切的部分:
			- ctx.drawImage(img, sx, sy, swidth, wheight, x, y, width, height);

	4. 参数说明:
		- img 规定要使用的图像、画布或视频。

		- sx 表示开始剪切的 x 坐标位置。可选值。

		- sy 表示开始剪切的 y 坐标位置。可选值。

		- swidth 表示被剪切图像的宽度。可选值。

		- sheight 表示被剪切图像的高度。可选值。

		- x 表示在画布上放置图像的 x 坐标位置。

		- y 表示在画布上放置图像的 y 坐标位置。

		- width 表示要使用的图像的宽度（伸展或缩小图像）。可选值。

		- height 表示要使用的图像的高度，（伸展或缩小图像）。可选值

### 表单属性
1. datalist
2. autocomplete属性: 
	1. 规定表单是否应该自动完成功能.
		自动完成允许浏览器预测对字段的输入，当用户在字段开始键入时，浏览器基于之前键入过的值，应该显示出在字段中填写的选项。
		当 autocomplete 属性值为 on 时表示启用自动完成功能，为 off 时表示关闭。
		autocomplete 属性适用于 `<form>`，以及下面的 `<input>` 类型：text, search, url, telephone, email, password, datepickers, range 以及 color。

	2. eg:
	```
	 <form action="#" method="get" autocomplete="on">
	 Name:<input type="text" name="name" /><br />
	 E-mail: <input type="email" name="email" autocomplete="off" /><br />
	 <input type="submit"  value="提交" />
	 </form>
	```

3. autofocus:
	1. autofocus 属性规定在页面加载时，域自动地获得焦点。适用于所有`<input>` 标签的类型。

4. form属性:
	1. form 属性规定输入域所属的一个或多个表单。
	2. form 属性适用于所有 `<input>` 标签的类型。
	3. form 属性必须引用所属表单的 id。
	4. eg
	```
	<body>
        <form action="#" method="get" id="user_form">
            First name:<input type="text" name="fname" />
            <input type="submit" value="提交" />
        </form>

        <p>下面的输入域在 form 元素之外，但仍然是表单的一部分，
            也就是说提交按钮会把 first name 和 last name的值都提交。</p>

        Last name: <input type="text" name="lname" form="user_form" />
    </body>	
	```
	5. 如果需要引用一个以上的表单,请使用空格分隔的列表.

5. multiple属性:
	1. multiple 属性规定输入域中可选择多个值，适用于以下类型的`<input>` 标签：email 和 file。

6. novalidate 属性
	1. novalidate 属性规定在提交表单时不应该验证 form 或 input 域。
	2. 适用于 `<form>`，以及下面的 `<input>` 类型：text, search, url, telephone, email, password, datepickers, range 以及 color。

7. pattern 属性
	1. pattern 属性规定用于验证 input 域的模式（pattern）。
	2. 模式（pattern） 是正则表达式。
	3. pattern 属性适用于以下类型的`<input>` 标签：text, search, url, telephone, email 以及 password。
	4. eg
	```
	<form action="#" method="get"  >
		Name: <input type="text" name="name"
		pattern="[A-z]{4}" title="请输入四个字母" />
		<input type="submit" value="提交" />
	</form>
	```

8. placeholder属性:
	1. placeholder 属性提供一种提示（hint），描述输入域所期待的值。
	2. 适用于以下类型的`<input>` 标签：text, search, url, telephone, email 以及 password。
	3. 提示（hint）会在输入域为空时显示出现，会在输入域获得焦点时消失。

9. required:
	1. required 属性规定必须在提交之前填写输入域（不能为空）。
	2. 适用于以下类型的`<input>` 标签：text, search, url, telephone, email, password, date pickers, number, checkbox, radio 以及 file。

### 输入类型
1. Input 类型 - email
	email 类型用于应该包含 e-mail 地址的输入域。在提交表单时，会自动验证 email 域的值。

2. Input 类型 - url
	url 类型用于应该包含 URL 地址的输入域。在提交表单时，会自动验证 url 域的值。

3. Input 类型 - number
	number 类型用于应该包含数值的输入域。属性 max 设定允许输入的最大值，属性 min 设定允许输入的最小值，
	属性 value 设定默认值，属性 step 设定合法的数字间隔（比如 step 的值为 2，则合法的数字为 -2,0,2,4 等）。

4. Input 类型 - range
	range 类型用于应该包含一定范围内数字值的输入域。range 类型显示为滑动条。同样的 range 也有 max，min，value，step 属性与上面所讲的 number 中的一致。

5. Input 类型 - Date Pickers（日期选择器）
> HTML5 拥有多个可供选取日期和时间的新输入类型：

    - date - 选取日、月、年
    - month - 选取月、年
    - week - 选取周和年
    - time - 选取时间（小时和分钟）
    - datetime - 选取时间、日、月、年（UTC 时间）
    - datetime-local - 选取时间、日、月、年（本地时间）

6. Input 类型 - search
	search 类型用于搜索域，比如站点搜索或 Google 搜索。search 域显示为常规的文本域。

7. Input 类型 - color
	color 类型用于选择颜色。

### web Storage
> 浏览器处于安全考虑，是不允许网页脚本访问本地文件系统的。但有时候我们需要在客户端浏览器上持久化的保存内容，
> 为了解决这个问题，HTML5 加入了本地存储和本地数据库。

1. HTML5 支持两种新的 Web Storage：永久性的本地存储（localStorage）和会话级别的本地存储（sessionStorage）。
	所谓 Web Storage 就是指在 Web 上储存数据的功能，而这里的储存，是针对客户端本地而言的。

2. loclStorage
> localStorage 方法将数据保存在客户端本地的硬件设备中（通常是指硬盘，但也可以是其他硬件设备），
> 即使浏览器关闭了，该数据依然存在，下次打开浏览器访问网站的时候仍然可以继续使用，也就是我们所说的永久性的本地存储。
> 而且数据不会随着 Http 请求发送到后台服务器，存储数据的大小也基本不用考虑，因为在 HTML5 的标准中要求浏览器至少要支持到 4MB

	1. 保存添加数据例子：
	```
	//方法1向本地存储中添加一个名为name,值为"syl"的key-value对象
	localStorage.setItem("name","syl");
	//方法2
	localStorage["price"] = 1314;
	//方法3
	localStorage.amount = 520;
	```

	2. 使用 setItem 方法保存数据时，将第一个参数 key 指定为键名，将第二个参数 value 指定为键值，
		保存时不允许保存相同的键名，保存后可以修改键值，但不允许改键名（只能重新取键名，然后再保存键值）。

	3. 读取数据：localStorage.getItem(key);
		- 使用 getItem 方法读取数据时，将参数指定为键名，返回键值。

	4. 删除单个数据：localStorage.removeItem(key);
		- 通过 key 删除本地数据。

	5. 清空数据：localStorage.clear();

3. sessionStorage
> sessionStorage 方法将数据保存在 session 对象中，所谓 session 直译过来就是会话，
> 再通俗一点讲就是指用户在浏览某个网站时，从进入网站到关闭浏览器的这段时间，session 对象可以用来保存在这段时间内所要求保存的任何数据。
> 我们称之为会话级别的本地存储。

	1. 当浏览器窗口被关闭时，session 对象保存的数据会被删除。
	2. sessionStorage 方法的使用与 localStorage 方法的使用类似

4. Web Storage 作为简易数据库使用的方法
> 主要核心思想就是使用 json 格式作为文本保存来保存对象，获取该对象时再通过 json 格式来获取

5. Web Sql 数据库
> Web SQL 数据库 API 并不是 HTML5 规范的一部分，
> 但是它是一个独立的规范，引入了一组使用 SQL 操作客户端数据库的 APIs。

	1. 操作本地数据库的最基本的步骤是：

		1. openDatabase 方法：创建一个访问数据库的对象。

		2. 使用第一步创建的数据库访问对象来执行 transaction 方法，
			通过此方法可以设置一个开启事务成功的事件响应方法，在事件响应方法中可以执行 SQL.

		3. 通过 executeSql 方法执行查询，当然查询可以是：CRUD。

	2. 打开数据库: 我们可以使用 openDatabase() 方法来打开已存的数据库，如果数据库不存在，则会创建一个新的数据库：
		1. 代码如下

		```
		var db = openDatabase("student", "1.0", "学生表", 1024 * 1024, function () { });
		```

		2. 参数说明：

			- 第一个参数是数据库名称。

			- 第二个参数是数据库的版本号。

			- 第三个参数是描述文本。

			- 第四个参数是设置分配的数据库的大小（单位是 kb）。

			- 第五个参数是回调函数，创建回调会在创建数据库后被调用（可以省略）。

	3. 事务处理
	> 在访问数据库的时候，还需要调用 transaction 方法，用来执行事务处理，
	> 使用事务处理可以防止在对数据库进行访问和执行有关操作的时候受到外界的干扰，因为在 web 页面上，
	同时可能会有很多人都在对页面进行访问，如果在访问数据库的时候，正在操作的数据被别的用户给修改了，
	会引发很多意想不到的结果，因为可以用事物处理来达到操作完了之前，阻止其他用户访问数据库的目的。

		1. 代码如下所示：
		```
		db.transaction(function (tx) {  
		   tx.executeSql('CREATE TABLE IF NOT EXISTS LOGS (id unique, log)');
		});
		```

		2. transaction 方法使用一个回调函数作为参数，在这个函数中，执行访问数据库的语句。

	4. executeSql 方法执行查询
		1. 代码:
		```tx.executeSql(sqlQuery,[value1,value2..],dataHandler,errorHandler)```

		2. 参数说明：
			- sqlQuery：需要具体执行的 sql 语句，可以是 create、select、update、delete。

			- [value1,value2..]：sql 语句中所有使用到的参数的数组，
				在 executeSql 方法中，将 sql 语句中所要使用的参数先用 “?” 代替，
				然后依次将这些参数组成数组放在第二个参数中。比如：

				```tx.executeSql("UPDATE people set age=? where name=?;",[age,name]);```

		3. dataHandler：执行成功时调用的回调函数，通过该函数可以获得查询结果集。
			1. 该回调函数的传递方法如下所示：

			```
			function dataHandler(transaction,results){
				//执行sql语句成功时的处理
			}
			```

			2. 该回调函数有两个参数，第一个参数为 transaction 对象，
				第二个参数为执行查询操作时返回的查询到的结果数据集对象。

		4. errorHandler：执行失败时调用的回调函数。
			1. 该回调函数的传递方法如下所示：

			```
			function errorHandler(transaction,errmsg){
				//执行sql语句出错时的处理
			}
			```
			2. 该回调函数有两个参数，第一个参数为 transaction 对象，第二个参数为执行发生错误时的文字说明。		

### 文件上传
1. 在 HTML4 标准中文件上传控件只接受一个文件，而在新标准中，只需要设置 multiple，就支持多文件上传。按住 Ctrl 或者 Shift 即可选择多个文件。

	```<input type="file" class="file" multiple>```

2. 获取文件信息
	选中文件通过 HTMLInputElement.files 属性返回，返回值是一个 FileList 对象,这个对象是一个包含了许多 File 文件的列表。
	比如我们首先运行上面例子的代码，然后随便上传一个文件（这里上传的是一个名为 700.png 的图片），然后按 F12 进入控制台，输入代码:

3. 每个 File 对象包含了以下信息：

	- lastModified 表示 UNIX timestamp 形式的最后修改时间。

	- lastModifiedDate 表示 Date 形式的最后修改时间。

	- name 表示文件名。只读字符串，只包含文件名称，不包含任何路径。

	- size 表示文件的字节大小，只读的 64 位整数。

	- type 表示文件的 MIME 类型。当类型不确定时为 ""。

	- webkitRelativePath 此处为空，当在 input 上加 webkitdirectory 属性时，用户可选择文件夹，此时 webkitRelativePath 表示文件夹中文件的相对路径。

	- 注：FileList 对象由 DOM 提供，列出了所有用户选择的文件，每一个代表了一个 File 对象。
		你可以通过检查文件列表的 length 属性决定用户可以选则多少文件。
		各个 File 对象可以方便地通过访问文件列表来获取，像访问数组那样。

4. 限制文件的上传类型

	1. 如果我们需要限制用户上传文件的类型，比如某处我们只希望能够上传图片，那么我们可以使用 input 的 accept 属性，
		accept 属性接受一个逗号分隔的 MIME 类型字符串。比如：

		```
		<!-- 表示只接受 png 图片 -->
		accept="image/png" 或 accept=".png"  

		<!-- 表示接受PNG/JPEG 文件. -->
		accept="image/png, image/jpeg" 或 accept=".png, .jpg, .jpeg"

		<!-- 表示接受任何图片文件类型. -->
		accept="image/*"

		 <!-- 表示接受任何 MS Doc 文件类型. -->
		 accept=".doc,.docx,.xml,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document"
		```

5. 文件读取
	1. 以上 File 对象只获取到了对文件的描述信息，<font color=red>但没有获得文件中的数据</font>。
	2. HTML5 中提供了 FileReader 对象允许 Web 应用程序异步读取存储在用户计算机上的文件（或原始数据缓冲区）的内容。
		1. 首先创建一个 FileReader 实例：

		```
		var reader = new FileReader();
		```

		2. 属性: FileReader.error 属性表示在读取文件时发生的错误，只读。语法为：

		```
		var error = instanceOfFileReader.error;
		```

		3. FileReader.readyState 属性表示 FileReader 状态的数字，只读。取值如下：
			- EMPTY		0	还没有加载任何数据.
			- LOADING		1	数据正在被加载.
			- DONE	2	已完成全部的读取请求.

		4. 语法为：
		```
		var state = instanceOfFileReader.readyState;
		```

			- FileReader.result 属性表示文件的内容。该属性仅在读取操作完成后才有效，数据的格式取决于使用哪个方法来启动读取操作，只读。

		5. 事件处理:
			- FileReader.onabort	处理abort事件。该事件在读取操作被中断时触发。
			- FileReader.onerror	处理error事件。该事件在读取操作发生错误时触发。
			- FileReader.onload	处理load事件。该事件在读取操作完成时触发。
			- FileReader.onloadstart	处理loadstart事件。该事件在读取操作开始时触发
			- FileReader.onloadend	处理loadend事件。该事件在读取操作结束时（要么成功，要么失败）触发。
			- FileReader.onprogress	处理progress 事件。该事件在读取 Blob 时触发

		6. 方法
			- FileReader.abort()	中止读取操作。在返回时，readyState属性为DONE。
			- FileReader.readAsArrayBuffer()	开始读取指定的 Blob 中的内容, 一旦完成, result 属性中保存的将是被读取文件的 ArrayBuffer 数据对象 。
			- FileReader.readAsDataURL()	开始读取指定的 Blob 中的内容。一旦完成，result 属性中将包含一个 data: URL 格式的字符串以表示所读取文件的内容。
			- FileReader.readAsText()		开始读取指定的 Blob 中的内容。一旦完成，result 属性中将包含一个字符串以表示所读取的文件内容。

