
<!-- vim-markdown-toc GFM -->

* [sds](#sds)
* [链表](#链表)
* [hash](#hash)
* [跳跃表](#跳跃表)

<!-- vim-markdown-toc -->
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
