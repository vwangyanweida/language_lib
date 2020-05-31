1. 在vim中的123开头的行前面加上一行文字:
	- %s/123/zheshiyiju\r123
		1. -r是回车,-n是换行,这句话的意思是将123替换成为"zheshiyijuxinhua\r123",
		等于是将123替换了,而替换的新语句里面有一个回车,就换行了,换行后开头的又正好是被替换的字母,
		效果和在头部插一行类似.

	- :g/123/normal Ozheshiyijuxinhang

2. iab
	1. iab不起作用,后来证实是pathogen的问题,注释掉这一行.
	2. 去掉pathogen后,minbuffer没法使用,需要minbuffer打开pathogen

3. C-m自动跳转到了指定行,和C-r一样,不知道是否是因为vimrc有什么缓存导致的.
