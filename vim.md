1. 在vim中的123开头的行前面加上一行文字:
	- %s/123/zheshiyiju\r123
		1. -r是回车,-n是换行,这句话的意思是将123替换成为"zheshiyijuxinhua\r123",
		等于是将123替换了,而替换的新语句里面有一个回车,就换行了,换行后开头的又正好是被替换的字母,
		效果和在头部插一行类似.

	- :g/123/normal Ozheshiyijuxinhang

