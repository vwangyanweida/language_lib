
<!-- vim-markdown-toc GFM -->

* [redis 数据结构](#redis-数据结构)
	* [sds](#sds)
	* [链表](#链表)
	* [hash](#hash)
	* [跳跃表](#跳跃表)
	* [ziplist 压缩表](#ziplist-压缩表)
* [命令](#命令)
	* [持久化](#持久化)
		* [RDB](#rdb)
		* [AOF 持久化](#aof-持久化)

<!-- vim-markdown-toc -->
## redis 数据结构
### sds 
1. sds的数据结构:
	```
	typedef char *sds;

	/*
	 * 保存字符串对象的结构
	 */
	struct sdshdr {
		
		// buf 中已占用空间的长度
		int len;

		// buf 中剩余可用空间的长度
		int free;

		// 数据空间
		char buf[];
	};

	/*
	 * 返回 sds 实际保存的字符串的长度
	 *
	 * T = O(1)
	 */
	static inline size_t sdslen(const sds s) {
		struct sdshdr *sh = (void*)(s-(sizeof(struct sdshdr)));
		return sh->len;
	}

	/*
	 * 返回 sds 可用空间的长度
	 *
	 * T = O(1)
	 */
	static inline size_t sdsavail(const sds s) {
		struct sdshdr *sh = (void*)(s-(sizeof(struct sdshdr)));
		return sh->free;
	}
	```

### 链表
1. 链表的数据结构:
	```
	typedef struct listNode {

		// 前置节点
		struct listNode *prev;

		// 后置节点
		struct listNode *next;

		// 节点的值
		void *value;

	} listNode;

	/*
	 * 双端链表迭代器
	 */
	typedef struct listIter {

		// 当前迭代到的节点
		listNode *next;

		// 迭代的方向
		int direction;

	} listIter;

	/*
	 * 双端链表结构
	 */
	typedef struct list {

		// 表头节点
		listNode *head;

		// 表尾节点
		listNode *tail;

		// 节点值复制函数
		void *(*dup)(void *ptr);

		// 节点值释放函数
		void (*free)(void *ptr);

		// 节点值对比函数
		int (*match)(void *ptr, void *key);

		// 链表所包含的节点数量
		unsigned long len;

	} list;

	/* Functions implemented as macros */
	// 返回给定链表所包含的节点数量
	// T = O(1)
	#define listLength(l) ((l)->len)
	// 返回给定链表的表头节点
	// T = O(1)
	#define listFirst(l) ((l)->head)
	// 返回给定链表的表尾节点
	// T = O(1)
	#define listLast(l) ((l)->tail)
	// 返回给定节点的前置节点
	// T = O(1)
	#define listPrevNode(n) ((n)->prev)
	// 返回给定节点的后置节点
	// T = O(1)
	#define listNextNode(n) ((n)->next)
	// 返回给定节点的值
	// T = O(1)
	#define listNodeValue(n) ((n)->value)

	// 将链表 l 的值复制函数设置为 m
	// T = O(1)
	#define listSetDupMethod(l,m) ((l)->dup = (m))
	// 将链表 l 的值释放函数设置为 m
	// T = O(1)
	#define listSetFreeMethod(l,m) ((l)->free = (m))
	// 将链表的对比函数设置为 m
	// T = O(1)
	#define listSetMatchMethod(l,m) ((l)->match = (m))

	// 返回给定链表的值复制函数
	// T = O(1)
	#define listGetDupMethod(l) ((l)->dup)
	// 返回给定链表的值释放函数
	// T = O(1)
	#define listGetFree(l) ((l)->free)
	// 返回给定链表的值对比函数
	// T = O(1)
	#define listGetMatchMethod(l) ((l)->match)
	```

### hash 
1. 结构
	```
	/*
	 * 哈希表节点
	 */
	typedef struct dictEntry {
		
		// 键
		void *key;

		// 值
		union {
			void *val;
			uint64_t u64;
			int64_t s64;
		} v;

		// 指向下个哈希表节点，形成链表
		struct dictEntry *next;

	} dictEntry;


	/*
	 * 字典类型特定函数
	 */
	typedef struct dictType {

		// 计算哈希值的函数
		unsigned int (*hashFunction)(const void *key);

		// 复制键的函数
		void *(*keyDup)(void *privdata, const void *key);

		// 复制值的函数
		void *(*valDup)(void *privdata, const void *obj);

		// 对比键的函数
		int (*keyCompare)(void *privdata, const void *key1, const void *key2);

		// 销毁键的函数
		void (*keyDestructor)(void *privdata, void *key);
		
		// 销毁值的函数
		void (*valDestructor)(void *privdata, void *obj);

	} dictType;


	/* This is our hash table structure. Every dictionary has two of this as we
	 * implement incremental rehashing, for the old to the new table. */
	/*
	 * 哈希表
	 *
	 * 每个字典都使用两个哈希表，从而实现渐进式 rehash 。
	 */
	typedef struct dictht {
		
		// 哈希表数组
		dictEntry **table;

		// 哈希表大小
		unsigned long size;
		
		// 哈希表大小掩码，用于计算索引值
		// 总是等于 size - 1
		unsigned long sizemask;

		// 该哈希表已有节点的数量
		unsigned long used;

	} dictht;

	/*
	 * 字典
	 */
	typedef struct dict {

		// 类型特定函数
		dictType *type;

		// 私有数据
		void *privdata;

		// 哈希表
		dictht ht[2];

		// rehash 索引
		// 当 rehash 不在进行时，值为 -1
		int rehashidx; /* rehashing not in progress if rehashidx == -1 */

		// 目前正在运行的安全迭代器的数量
		int iterators; /* number of iterators currently running */

	} dict;

	 * 字典迭代器
	 *
	 * 如果 safe 属性的值为 1 ，那么在迭代进行的过程中，
	 * 程序仍然可以执行 dictAdd 、 dictFind 和其他函数，对字典进行修改。
	 *
	 * 如果 safe 不为 1 ，那么程序只会调用 dictNext 对字典进行迭代，
	 * 而不对字典进行修改。
	 */
	typedef struct dictIterator {
			
		// 被迭代的字典
		dict *d;

		// table ：正在被迭代的哈希表号码，值可以是 0 或 1 。
		// index ：迭代器当前所指向的哈希表索引位置。
		// safe ：标识这个迭代器是否安全
		int table, index, safe;

		// entry ：当前迭代到的节点的指针
		// nextEntry ：当前迭代节点的下一个节点
		//             因为在安全迭代器运作时， entry 所指向的节点可能会被修改，
		//             所以需要一个额外的指针来保存下一节点的位置，
		//             从而防止指针丢失
		dictEntry *entry, *nextEntry;

		long long fingerprint; /* unsafe iterator fingerprint for misuse detection */
	} dictIterator;

	typedef void (dictScanFunction)(void *privdata, const dictEntry *de);

	/* This is the initial size of every hash table */
	/*
	 * 哈希表的初始大小
	 */
	#define DICT_HT_INITIAL_SIZE     4

	/* ------------------------------- Macros ------------------------------------*/
	// 释放给定字典节点的值
	#define dictFreeVal(d, entry) \
		if ((d)->type->valDestructor) \
			(d)->type->valDestructor((d)->privdata, (entry)->v.val)

	// 设置给定字典节点的值
	#define dictSetVal(d, entry, _val_) do { \
		if ((d)->type->valDup) \
			entry->v.val = (d)->type->valDup((d)->privdata, _val_); \
		else \
			entry->v.val = (_val_); \
	} while(0)

	// 将一个有符号整数设为节点的值
	#define dictSetSignedIntegerVal(entry, _val_) \
		do { entry->v.s64 = _val_; } while(0)

	// 将一个无符号整数设为节点的值
	#define dictSetUnsignedIntegerVal(entry, _val_) \
		do { entry->v.u64 = _val_; } while(0)

	// 释放给定字典节点的键
	#define dictFreeKey(d, entry) \
		if ((d)->type->keyDestructor) \
			(d)->type->keyDestructor((d)->privdata, (entry)->key)

	// 设置给定字典节点的键
	#define dictSetKey(d, entry, _key_) do { \
		if ((d)->type->keyDup) \
			entry->key = (d)->type->keyDup((d)->privdata, _key_); \
		else \
			entry->key = (_key_); \
	} while(0)

	// 比对两个键
	#define dictCompareKeys(d, key1, key2) \
		(((d)->type->keyCompare) ? \
			(d)->type->keyCompare((d)->privdata, key1, key2) : \
			(key1) == (key2))
	```

2. 注意:
	1. rehashing时,将ht[0]->table[h]的kv转移到ht[1]tale[k]时,当ht[0]开始转移时,ht[0]的table[h]的所有还未转移的kv都访问不到了,知道table[h]这一个数组的所有
kv都转移完才可以找到,但是因为redis是单线程,所以redis才没有发生异常,如果转移过程中,有别的线程读取正在转移的哪一行,会发生找不到.

### 跳跃表
1. 结构:
	```
	/* ZSETs use a specialized version of Skiplists */
	/*
	 * 跳跃表节点
	 */
	typedef struct zskiplistNode {

		// 成员对象
		robj *obj;

		// 分值
		double score;

		// 后退指针
		struct zskiplistNode *backward;

		// 层
		struct zskiplistLevel {

			// 前进指针
			struct zskiplistNode *forward;

			// 跨度
			unsigned int span;

		} level[];

	} zskiplistNode;

	/*
	 * 跳跃表
	 */
	typedef struct zskiplist {

		// 表头节点和表尾节点
		struct zskiplistNode *header, *tail;

		// 表中节点的数量
		unsigned long length;

		// 表中层数最大的节点的层数
		int level;

	} zskiplist;
	```

### ziplist 压缩表
1. ziplist中实体对象结构:
	```
	/*
	 * 保存 ziplist 节点信息的结构
	 */
	typedef struct zlentry {

		// prevrawlen ：前置节点的长度
		// prevrawlensize ：编码 prevrawlen 所需的字节大小
		unsigned int prevrawlensize, prevrawlen;

		// len ：当前节点值的长度
		// lensize ：编码 len 所需的字节大小
		unsigned int lensize, len;

		// 当前节点 header 的大小
		// 等于 prevrawlensize + lensize
    unsigned int headersize;

    // 当前节点值所使用的编码类型
    unsigned char encoding;

    // 指向当前节点的指针
    unsigned char *p;

	} zlentry;
	```

2. 图解 
	```
	/* 
	空白 ziplist 示例图

	area        |<---- ziplist header ---->|<-- end -->|

	size          4 bytes   4 bytes 2 bytes  1 byte
				+---------+--------+-------+-----------+
	component   | zlbytes | zltail | zllen | zlend     |
				|         |        |       |           |
	value       |  1011   |  1010  |   0   | 1111 1111 |
				+---------+--------+-------+-----------+
										   ^
										   |
								   ZIPLIST_ENTRY_HEAD
										   &
	address                        ZIPLIST_ENTRY_TAIL
										   &
								   ZIPLIST_ENTRY_END

	非空 ziplist 示例图

	area        |<---- ziplist header ---->|<----------- entries ------------->|<-end->|

	size          4 bytes  4 bytes  2 bytes    ?        ?        ?        ?     1 byte
				+---------+--------+-------+--------+--------+--------+--------+-------+
	component   | zlbytes | zltail | zllen | entry1 | entry2 |  ...   | entryN | zlend |
				+---------+--------+-------+--------+--------+--------+--------+-------+
										   ^                          ^        ^
	address                                |                          |        |
									ZIPLIST_ENTRY_HEAD                |   ZIPLIST_ENTRY_END
																	  |
															ZIPLIST_ENTRY_TAIL
	*/
	```

## 命令
### 持久化
#### RDB
1. RDB 生成:
	1. 有两个Redis命令可以用于生成RDB文件
		- SAVE: 阻塞
		- BGSAVE: 子进程并发处理

	2. 代码: rdb.c/rdbSave 函数

2. 因为AOF文件的更新频率通常比RDB文件的更新频率高,所以
	- 如果服务器开启了AOF持久化功能,那么服务器会优先使用AOF文件来还原数据库状态
	- 只有AOF关闭时,服务器才会使用RDB文件来还原数据库状态.

3. RDB文件的载入工作是在服务器启动时自动执行的,所以redis没有专门用来载入RDB文件的命令
4. BGSAVE和BGREWRITEAOF和save之间并发时的各种情景
5. BGSAVE间隔执行:配置时的三个配置
	- save 900 1
	- save 300 1
	- save 60 10000

6. dirty
	dirty计数器记录距离上一次成功执行save命令或者BGSAVE命令之后,服务器对数据库状态(服务器中所有的数据库)进行了多少次修改(包括写入,删除,更新等操作)

7. lastsave
	lastsave属性是一个unix时间戳,记录了服务器上一次成功执行save命令或者BGSAVE命令的时间

8. RDB文件结构
	1. | REDIS | db_version | databases | EOF | `check_sum` |

	2. databases 部分结构:
		| SELECTDB | `db_number` | `key_value_pairs` |

	3. `key_value_pairs`结构
		| TYPE | key | value |
		
	4. 带有过期键的	`key_value_pairs`
		| EXPIRETIME_MS | ms | TYPE | key | value |

#### AOF 持久化
1. AOF持久化的实现: AOF持久化功能的实现可以分为三个步骤:
	- 命令追加(append)
	- 文件写入
	- 文件同步(sync)

2. 命令追加(append)
	当AOF持久化功能处于打开状态时,服务器执行完一个写命令后,会以协议格式将被执行的写命令追加到服务器状态的`aof_buf`缓冲区的末尾:
	```
	struct redisServer {
		//...
		sds aof_buf;
	}
	```

3. Redis的服务器进程就是一个事件循环,这个循环中的文件事件负责接受客户端的命令请求,以及向客户端发送命令回复,
	而时间事件则负责执行像severCron函数这样需要定时运行的函数.

4. 文件事件可能会执行写命令,使得一些内容被追加到aof_buf缓冲区,每次服务器结束一个事件循环之前,他都会调用flushAppendOnlyFile函数,
	考虑是否将aof_buf缓冲区中的内容写入和保存到AOF文件里面.
	```
	def eventloop():
		while True:
			processFileEvents()

			processTimeEvents()

			flushAppendOnlyFile()
	```

5. appendfsync配置选项:
	- always
	- everysec
	- no

6. 文件的写入和同步
	为了提高文件的写入效率,在现代操作系统中,当用户调用write函数,将一些数据写入到文件的时候,操作系统通常会将写入数据暂时保存在一个内存缓冲区里面,
等到缓冲区的空间被填满,或者超过了指定的时限之后,才真正地将缓冲区中的数据写入到磁盘立里面.

	<font color=red>这种做法虽然提高了效率,但也为写入数据带来了安全问题,为此系统提供了fsync和fdatasync两个同步函数</font>,
他们可以强制让操作系统立即将缓冲区中的数据写入到硬盘里面,从而确保写入数据的安全性.
	
7. AOF文件的载入和数据还原
	- 创建爱你一个布袋网络链接的为客户端
	- 从AOF文件分析并读取一条命令
	- 使用伪客户端执行读取的命令
	- 重复2,3 知道AOF文件中的所有写命令都被处理完为止

8. AOF 重写:
	1. 实现
		- AOF重写不需要对原来的AOF文件进行任何操作,这个功能是通过读取服务器当前的数据库状态实现的.
		- 首先从数据库读取键现在的值,然后用一条命令记录键值对,代替之前记录这个键值对的多条命令,这就是AOF重写的实现原理.

	2. AOF重写缓冲区的作用: p148
