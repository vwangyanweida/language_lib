
<!-- vim-markdown-toc GFM -->

* [打印的知识](#打印的知识)
	* [c](#c)
		* [struct包含指针或数组](#struct包含指针或数组)
	* [cpp](#cpp)
	* [python](#python)
	* [js](#js)

<!-- vim-markdown-toc -->

## 打印的知识
> 一些需要记住的但可能不容易找不到的知识点

### c
#### struct包含指针或数组
1. 调用malloc申请空间以将数组元素保存在struct后面,使得可以通过数组指针可以计算处struct的位置
	1. redis使用struct来保存边长字符串
		1. sdshdr代码
		```
		struct sdshdr {
			int len; //记录buf数组已使用的字节数量
			int free;  //记录buf数组未使用的字节数量
			char buf[]; //用于保存字符串
		}
		```

		2. 创建一个sds:
		```
		sds sdsnewlen(const void *init, size_t initlen) {

			struct sdshdr *sh;

			// 根据是否有初始化内容，选择适当的内存分配方式
			// T = O(N)
			if (init) {
				// zmalloc 不初始化所分配的内存
				sh = zmalloc(sizeof(struct sdshdr)+initlen+1);
			} else {
				// zcalloc 将分配的内存全部初始化为 0
				sh = zcalloc(sizeof(struct sdshdr)+initlen+1);
			}

			// 内存分配失败，返回
			if (sh == NULL) return NULL;

			// 设置初始化长度
			sh->len = initlen;
			// 新 sds 不预留任何空间
			sh->free = 0;
			// 如果有指定初始化内容，将它们复制到 sdshdr 的 buf 中
			// T = O(N)
			if (initlen && init)
				memcpy(sh->buf, init, initlen);
			// 以 \0 结尾
			sh->buf[initlen] = '\0';

			// 返回 buf 部分，而不是整个 sdshdr
			return (char*)sh->buf;
		}
		```
	
		3. 返回 sds 实际保存的字符串的长度
		```
		static inline size_t sdslen(const sds s) {
			struct sdshdr *sh = (void*)(s-(sizeof(struct sdshdr)));
			return sh->len;
		}
		```

		4. 总结:
			1. 经常用使用struct时,如果申请内存,可以根据结构体内的某个值的指针来计算出结构体的位置
			2. <font color=red>结构体内有指针,申请时留出指针内容的内存空间,赋值时将这块内存来保存指针的内容,以后既可以根据这个指针成员的地址计算出结构体的指针了.</font>
			3. 结构体的大小就是结构体内所有成员的大小的和,记得内存对齐.如果结构体中有长度为0的数组,则这个成员不占内存,典型使用上面一条来保存指针的内容到struct后面.

	2. 情景/步骤: 
		- 使用结构体来为某种类型添加额外信息
		- 申请内存时,申请的内存大于结构体的内存,额外部分长度是指针内容的大小

	3. 原理:
		
### cpp

### python

### js

