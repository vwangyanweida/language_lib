
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
		``` <form enctype="multipart/form-data"></form>```
	
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

					for (var i=0; i < v.length; i++) {
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
	- <html></html>
	- <head></head>
	- <title></title>
	- <body></body>
	- <h1></h1>
	- <h2></h2>
	- <p></p>
	- <div></div>
	- <span></span>
	- <a></a>
	- <ul></ul>
	- <ol></ol>
	- <dt></dt>
	- <dd></dd>
	- <mark></mark>
	- <iframe></iframe>

#### 单标签
1. 常见单标签
	- <br/>     <!--换行-->
	- <hr />    <!--水平分隔线-->
	- <meta />
	- <img />

#### HTML链接
1. 链接可以是一个字，一个词，或一组词，也可以是一幅图像

2. 两种使用<a>标签的方式 
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

	3. 建立页面中的锚点，我们知道<a href="url">link</a>是获得一个页面超级链接，如果不用href属性，而改用name，
		如：<a name="PageBottom"></a>，我们就获得了一个页面锚点。

	4. 作为对象的identity，如Applet、Object、Embed等元素。比如在Applet对象实例中，我们将使用其name来引用该对象。

	5.  在img元素和map元素之间关联的时候，如果要定义img的热点区域，需要使用其属性usemap，
		使usemap="#name"(被关联的map元素的name)。

	6. 某些特定元素的属性，如attribute，和param。例如为Object定义参数<param name = "appletParameter" value= "value">。

	7. name属性也可以作为客户端对象的标识,可以使用javascript的document.getElementByName('name')来获取对象

### 列表
#### 有序列表: ol
1. 有序列表有type和start属性
2. 语法格式：
```
<ol type="value1" start="value2">
	<li></li>
</ol>
```

3. value1表示有序列表项目符号的类型，value2表示项目开始的数值。

4. type 类型：
	- 1 表示使用数字
	- a 表示使用小写字母
	- A 表示使用大写字母
	- i 小时使用小写罗马数字
	- I 小时使用大写罗马数字

#### 无序列表:ul
#### 自定义列表:dl
