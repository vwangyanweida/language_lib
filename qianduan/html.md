
<!-- vim-markdown-toc GFM -->

* [网站的文件处理](#网站的文件处理)
* [HTML 内容](#html-内容)
	* [HTML 标签](#html-标签)
		* [双标签](#双标签)
		* [单标签](#单标签)
		* [HTML链接](#html链接)

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
	- 通过使用name属性：常见文档内的书签

3. 通过name属性创建锚点的链接，使用户可以快速定位到目标内容，使用分为两步：
	- 使用`<a href="#id名">`创建链接文本
	- 使用响应的id名标注跳转目标的位置，name只能指定id。

