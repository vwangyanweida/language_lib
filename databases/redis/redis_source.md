
<!-- vim-markdown-toc GFM -->

* [redis设计与实现 25]
	* [toc 26]
		* [数据结构 27]
		* [单机数据库的实现 72]
		* [多机数据库的实现 121]
		* [独立功能的实现 265]
* [redis笔记 306]
	* [持久化 307]
		* [RDB 308]
		* [AOF持久化 345]
* [redis源码解析 400]
	* [redis数据结构 401]
		* [sds 402]
		* [链表 443]
		* [hash 538]
		* [跳跃表 717]
		* [ziplist压缩表 765]
		* [sentinel 831]

<!-- vim-markdown-toc -->

## redis设计与实现 25
### toc 26
#### 数据结构 27
1. 简单动态字符串
	- sds定义

2. 链表
	- 链表和链节点的实现
	- api

3. 字典
	- 字典的实现
	- 哈希算法
	- 解决键冲突
	- rehash
	- 渐进式rehash
	- api

4. 跳跃表
	- 跳跃表实现
	- api

5. 整数集合
	- 整数集合的实现
	- 升级
	- 升级的好处
	- 降级
	- api

6. 压缩列表
	- 压缩列表的构成
	- 压缩列表节点的构成
	- 连锁更新
	- aip

7. 对象
	- 对象的类型与编码
	- 字符串对象
	- 列表对象
	- 哈希对象
	- 集合对象
	- 有序集合对象
	- 类型检查与命令多态
	- 内存回收
	- 对象共享
	- 对象的空转时长

#### 单机数据库的实现 72
8. 数据库
	- 服务器中的数据库
	- 切换数据库
	- 数据键空间
	- 设置键的生存时间或过期时间
	- 过期键删除策略
	- Redis的过期键删除策略
	- AOF,RDB和复制功能对过期键的处理
	- 数据库通知

9. RDB持久化
	- RDB文件的创建与载入
	- 自动间隔性保存
	- RDB文件结构
	- 分析RDB文件
	
10. AOF持久化
	- AOF持久化的实现
	- AOF文件的载入与数据还原
	- AOF重写

11. 事件
	- 文件事件
	- 时间事件
	- 事件的调度与执行
	
12. 客户端
	- 客户端属性
	- 客户端的创建与关闭

13. 服务器
	- 命令请求的执行过程
		- 发送命令请求
		- 读取命令请求
		- 命令执行器:
			1. 查找命令
			2. 执行预备操作
			3. 调用命令的实现函数
			4. 执行后续工作
		- 将命令回复发送给客户端
		- 客户端接受并打印命令回复

	- serverCron函数
		- 更新服务器时间缓存
		- 更新LRU时钟
		- 更新服务器每秒执行命令次数
	- 初始化服务器
	
#### 多机数据库的实现 121
14. 复制
	- 旧版赋值功能的实现
	- 旧版赋值功能的缺陷
	- 新版复制功能的实现
	- 部分重同步的实现
	- PSYNC命令的实现
	- 复制的实现
	- 心跳检测

15. Sentinel
	1. sentinel(哨岗,哨兵)是Redis的高可用行(high availability)解决方案: 
		- 有一个或多个Sentinel实例(instance)组成的Sentinel系统可以监听多个主服务器,以及这些主服务器下的所有从服务器,
		- 并在被监视的主服务器进入下线状态时,自动将下线主服务器的某个从服务器升级为新的主服务器,
		- 然后由新的主服务器代替已下线的主服务器继续处理命令请求.
	
	2. 故障转移:
		> 当主服务器server1进入下线状态,当下线时间超过用户设定的下线时长上限时,Sentinel系统就会执行故障转移.

		1. 首先,挑选一个server1的从服务器,并将它升级为新的主服务器
		2. sentinel系统回想server1的所有从服务器发送新的复制指令,让它们成为新的主服务器的从服务器,当所有从服务器都开始复制新的主服务器时,故障转移操作执行完毕
		3. sentinel会继续监视下线的Server1,并在它重新上线时,将他设置为新的主服务器的从服务器
			

	3. 启动并初始化Sentinel
		1. 命令: 效果相同
			- redis-sentinel /path/to/your/sentinel.conf
			- redis-server /path/to/your/sentinel.conf --sentinel

		2. 启动步骤
			- 初始化服务器
			- 将普通的Redis服务器使用的代码替换成为sentinel专用代码
			- 初始化sentinel状态
			- 根据配置文件,初始化sentinel的监视主服务器列表
				- sentinelState 结构体
					- masters: 记录了所有被sentinel监视的主服务器的相关信息
						- 字典的键是主服务器的名字:
						- 字典的值是sentinelRedisInstance 结构体, 可以是主服务器,也可以是从服务器,还可以是sentinel实例

			- 创建连向主服务器的网络连接
				1. 对于每个被sentinel监视的主服务器, Sentinel会创建两个连向主服务器的异步网络连接
					- 命令连接:这个连接专门用于向主服务器发送命令,并接受命令回复
					- 订阅连接诶: 这个连接专门用于订阅主服务器的__sentinel__:hello频道.
				
		- 获取主服务器信息
			- 默认每十秒一次的频率,通过命令连接像别监视的主服务器发送info命令,并通过分析info命令的回复来获取主服务器的当前信息
			- INFO命令可以分析出来两方面信息:
				- 主服务器本身的信息
				- 主服务器属下所有从服务器的信息.Sentinel无须用户提供从服务器信息,就可以自动发现从服务器.
			- 从服务器信息保存在主服务器instance结构中的slaves字典内.
			- sentinelState.masters -> (master)sentinelRedisInstance.slaves -> (slaves)sentinelRedisInstance
			- 主服务器的flags是SRI_MASTER, 从服务器的flags是SRI_SLAVE
			- 主服务器的名字是配置文件是配置文件所设置,从服务器名字是由ip和port自动设置的.

		- 获取从服务器信息
			- sentinel 获取了从服务器信息后,会为每一个从服务器建立命令和订阅两个链接,和主服务器一样.
			- 默认每十秒一次的频率,通过命令连接向被监视的从服务器发送info命令,并通过分析info命令的回复来获取从服务器的当前信息

		- 向主服务器和从服务器发送信息
			- sentinel默认会通过命令链接,每2秒一次发送一下格式命令:
				`PUBLISH __sentinel__:hello "<s_ip>, <s_port>, <s_runid>, <s_epoch>, <m_name>, <m_ip>, <m_port>, <m_epoch>"`

		- 接受来自主服务武器和从服务器的频道信息
			- sentinel通过订阅连接发送一下命令:
				`SUBSCRIBE __sentinel__:hello`
				
			- sentinel通过命令连接发送hello频道信息,又通过订阅连接接受hello频道的信息,以获取所有监视服务器的sentinel信息
			- sentinel之间各自创建一个命令连接,不需要订阅连接.因为他们通过info获取其他sentinel信息,仅仅需要命令连接即可

		- 检测主观下线状态
			- 每秒固定频率给所有连接发送ping
			- 有效回复:
				- +PONT, -LOADING, -MASTERDOWN
			- 无效回复:
				- 除了上面三个所有回复
				- 没有回复超时之前

			- down-after-milliseconds: 进入主观下线的时间长度. 如果进入主观下线,flags上打开`SRI_S_DOWN`标识.

		- 检测客观下线状态
			1. SENTINEL is-master-down-by-addr 命令,询问其他sentinel是否同意将主服务器下线
			2. SENTINEL is-master-down-by-addr的回复:
				1. <down_state>
				2. <leader_runid>
				3. <leader_epoch>
			3. 统计其他sentinel发送的命令回复,当达到下线标准时:将主服务器实例的flags打开SRI_O_DOWN标识,标识主服务器已经进入客观下线状态

		- 选举领头Sentinel
			1. 选举领头sentinel的规则和方法
				1. 所有sentinel都有资格
				2. 每次选举,无论是否成功,epoch都会自增一次
				3. 每个纪元每个sentinel只能选举一次局部领头sentinel的机会,一旦设置,这个纪元不能更改
				4. 每个发现主服务器客观下线的sentinel都会要求其他sentinel将自己设置为局部领头sentinel
				5. dagn sentinel is-master-down-by-addr中runid参数不是*是源sentinel的运行id时,表示要求其他sentinel将自己设置为局部领头sentinel
				6. sentinel设置局部领头的原则是先到先得:
				7. 接受到sentinel is-master-down-by-addr的sentinel,返回信息中leader_runid和leader_epoch记录自己选举的领头sentinel
				8. 发送is-master-down-by-addr的源sentinel会检查目标sentinel回复的信息
				9. 某个sentinel被半数以上的sentinel设置为局部领头,他就会成为局部领头sentinel
				10. 因为需要半数以上,所以只会有一个局部领头sentinel
				11. 给定时限没有选出领头sentinel,会等待一段时间之后,再次进行选举,直至选出.

		- 故障转移: 选出局部领头sentinel,它会对已下线主服务器执行故障转移操作:
			1. 在已下线主服务器属下的所有从服务器里面,挑选出一个从服务器,并将它转换为主服务器: no one slave
			2. 让已经下线主服务器属下的所欲从服务器改为复制新的主服务器
			3. 将已下线主服务器设置为新的主服务器的从服务器,当这个旧的主服务器从新上线时,它就会成为新的主服务器的从服务器.

	3. 总结:
		1. 监听对象
			- sentinel先监听主服务器,然后根据主服务器的info,获得从服务器的ip和端口,继续监听从服务器,并周期性更新

16. 集群
	- 节点
		1. 连接各个节点的命令:cluster meet <IP> <port>
		2. 启动服务器  ->  cluster-enabled -> 开启服务器的集群模式成为一个节点 or 开启服务器单机模式成为一个普通的redis服务器
		3. 结构:
			- struct clusterNode
			- clusterLink
			- clusterState

		4. cluster meet命令的实现
		```
																			发送meet 消息
		                                                    |       | ----------------------------> |       |
					发送命令:cluster meet <B_ip> <B_port>   |       |         返回pong消息          |       |
		客户端  ------------------------------------------> | 节点A | <---------------------------- | 节点B |
		                                                    |       |        返回ping消息           |       | 
															|		| ----------------------------> |       |
		```

	- 槽指派
		1. Redis 集群通过分片的方式来保存数据库中的键值对: 集群的整个数据库被分为16384个槽(slot)
		2. 当数据库的16384个槽都有节点在处理时,集群处于上线状态,如果任何一个槽没有被处理,集群处于下线状
		3. 通过向节点发送cluster addslot命令,可以将一个或多个槽指派给节点负责:
		```
		cluster addslots <slot> [slot ...]

		127.0.0.1:7000> cluster addslots 0 1 2 3 ... 5000  //将0-5000指派给7000服务器
		```
	- 在集群中执行命令
	- 重新分片
	- ASK错误
	- 复制与故障转移
	- 消息

#### 独立功能的实现 265
17. 发布与订阅
	- 频道的订阅与退订
	- 模式的订阅与退订
	- 发送消息
	- 查看订阅信息

18. 事务
	- 事务的实现
	- WATCH命令的实现
	- 事务的ACID性质
	
19. Lua脚本

20. 排序
	- SORT<key>命令的实现
	- ALPHA选项的实现
	- ASC选项和DESC选项的实现
	- BY选项的实现
	- 带有ALPHA选项的BY选项的实现
	- LIMIT选项的实现
	- GET选项的实现
	- STORE选项的实现
	- 多个选项的顺序执行

21. 二进制位数组
	- 位数组的表示
	- GETBIT 命令的实现
	- SETBIT 命令的实现
	- BITCOUNT 命令的实现
	- BITOP 命令的实现

22. 慢查询日志
	- 慢查询日志的保存
	- 慢查询日志的阅览也删除
	- 添加新日志

23. 监视器
	- 成为监视器
	- 向监视器发送命令信息
	
## redis笔记 306
### 持久化 307
#### RDB 308
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

#### AOF持久化 345
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

4. 文件事件可能会执行写命令,使得一些内容被追加到`aof_buf`缓冲区,每次服务器结束一个事件循环之前,他都会调用flushAppendOnlyFile函数,
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

## redis源码解析 400
### redis数据结构 401
#### sds 402
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

#### 链表 443
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
	#definelistLength(l)((l)->len)
	// 返回给定链表的表头节点
	// T = O(1)
	#definelistFirst(l)((l)->head)
	// 返回给定链表的表尾节点
	// T = O(1)
	#definelistLast(l)((l)->tail)
	// 返回给定节点的前置节点
	// T = O(1)
	#definelistPrevNode(n)((n)->prev)
	// 返回给定节点的后置节点
	// T = O(1)
	#definelistNextNode(n)((n)->next)
	// 返回给定节点的值
	// T = O(1)
	#definelistNodeValue(n)((n)->value)

	// 将链表 l 的值复制函数设置为 m
	// T = O(1)
	#define listSetDupMethod(l,m) ((l)->dup=(m))
	// 将链表 l 的值释放函数设置为 m
	// T = O(1)
	#define listSetFreeMethod(l,m) ((l)->free=(m))
	// 将链表的对比函数设置为 m
	// T = O(1)
	#define listSetMatchMethod(l,m) ((l)->match=(m))

	// 返回给定链表的值复制函数
	// T = O(1)
	#definelistGetDupMethod(l)((l)->dup)
	// 返回给定链表的值释放函数
	// T = O(1)
	#definelistGetFree(l)((l)->free)
	// 返回给定链表的值对比函数
	// T = O(1)
	#definelistGetMatchMethod(l)((l)->match)
	```

#### hash 538
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
	#define DICT_HT_INITIAL_SIZE   

	/* ------------------------------- Macros ------------------------------------*/
	// 释放给定字典节点的值
	#define dictFreeVal(d,entry)\
		if ((d)->type->valDestructor) \
			(d)->type->valDestructor((d)->privdata, (entry)->v.val)

	// 设置给定字典节点的值
	#define dictSetVal(d, entry, _val_) do{\
		if ((d)->type->valDup) \
			entry->v.val = (d)->type->valDup((d)->privdata, _val_); \
		else \
			entry->v.val = (_val_); \
	} while(0)

	// 将一个有符号整数设为节点的值
	#define dictSetSignedIntegerVal(entry,_val_)\
		do { entry->v.s64 = _val_; } while(0)

	// 将一个无符号整数设为节点的值
	#define dictSetUnsignedIntegerVal(entry,_val_)\
		do { entry->v.u64 = _val_; } while(0)

	// 释放给定字典节点的键
	#define dictFreeKey(d,entry)\
		if ((d)->type->keyDestructor) \
			(d)->type->keyDestructor((d)->privdata, (entry)->key)

	// 设置给定字典节点的键
	#define dictSetKey(d, entry, _key_) do{\
		if ((d)->type->keyDup) \
			entry->key = (d)->type->keyDup((d)->privdata, _key_); \
		else \
			entry->key = (_key_); \
	} while(0)

	// 比对两个键
	#define dictCompareKeys(d, key1,key2)\
		(((d)->type->keyCompare) ? \
			(d)->type->keyCompare((d)->privdata, key1, key2) : \
			(key1) == (key2))
	```

2. 注意:
	1. rehashing时,将ht[0]->table[h]的kv转移到ht[1]tale[k]时,当ht[0]开始转移时,ht[0]的table[h]的所有还未转移的kv都访问不到了,知道table[h]这一个数组的所有
kv都转移完才可以找到,但是因为redis是单线程,所以redis才没有发生异常,如果转移过程中,有别的线程读取正在转移的哪一行,会发生找不到.

#### 跳跃表 717
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

#### ziplist压缩表 765
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
    unsigned intheadersize;

    //当前节点值所使用的编码类型
    unsigned charencoding;

    //指向当前节点的指针
    unsigned char*p;

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

#### sentinel 831
1. sentinelState 结构体:
```
struct sentinelState {

	//当前济源,用于实现故障转移
	uint 64_t current_epoch

	//保存了所有这个sentinel监视的主服务器,字典的键是主服务器的名字
	//字典的值是一个指向sentinelRedisInstance结构的指针
	dict *masters;

	//是否进入TILT模式
	int tilt;

	//目前正在执行的脚本数量
	int running_scripts;

	//进入TILT模式的时间
	mstime_t tilt_start_time;

	//最后一次执行时间处理器的时间
	mstime_t previous_time;

	//一个FIFO队列,包含了所有需要执行的用户脚本
	list *scripts_queue;
} sentinel;
```
2. sentinelRedisInstance 结构体:
```
typedef struct sentinelRedisInstance {
	
	//标识值,记录了实例的类型,以及该实例的当前状态
	int flags;

	//实例的名字
	//主服务器的名字由用户在配置文件中设置
	//从服务器以及sentinel的名字有sentinel自动设置
	//格式为ip:port, 例如"127.0.0.1:26379"
	char *name;

	//实例运行的ID
	char *runid;

	//配置纪元,用于实现故障转移
	uint_64_t config_epoch

	//实例的地址
	sentinelAddr *addr;

	//SENTINEL down-after-milliseconds选项设定的值
	//实例无响应多少毫秒之后才会被判断为主观下线(subjectively down)

	//SENTTINEL monitor <master-name> <IP> <port> <quorum> 选项中的quorum参数
	//判断这个实例为客观下线(objecttively down) 所需的支持投票数量
	int quorum;

	//SENTTINEL parallel-syncs <master-name> <number> 选项的值
	//在执行故障转移操作时,可以同时对新的主服务器进行同步的从服务器的数量
	int parallel_syncs;

	//SENTTINEL failover-timeout <master-name> <ms> 选项的值
	//刷新故障迁移状态的最大时限
	mstime_t failover_timeout;

	//...
} sentinelRedisInstance;
```
