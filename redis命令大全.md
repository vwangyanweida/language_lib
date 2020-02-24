### redis command
> 文档目前描述的内容以 Redis 2.8 版本为准，查看更新日志(change log)可以了解本文档对 Redis 2.8 所做的更新。

┌─────────────────────┬──────────────────────────┬────────────────────────┬───────────────────────┐
│  • Key（键）        │  • String（字符串）      │                        │                       │
│      □ DEL          │      □ APPEND            │                        │                       │
│      □ DUMP         │      □ BITCOUNT          │                        │  • List（列表）       │
│      □ EXISTS       │      □ BITOP             │                        │      □ BLPOP          │
│      □ EXPIRE       │      □ DECR              │  • Hash（哈希表）      │      □ BRPOP          │
│      □ EXPIREAT     │      □ DECRBY            │      □ HDEL            │      □ BRPOPLPUSH     │
│      □ KEYS         │      □ GET               │      □ HEXISTS         │      □ LINDEX         │
│      □ MIGRATE      │      □ GETBIT            │      □ HGET            │      □ LINSERT        │
│      □ MOVE         │      □ GETRANGE          │      □ HGETALL         │      □ LLEN           │
│      □ OBJECT       │      □ GETSET            │      □ HINCRBY         │      □ LPOP           │
│      □ PERSIST      │      □ INCR              │      □ HINCRBYFLOAT    │      □ LPUSH          │
│      □ PEXPIRE      │      □ INCRBY            │      □ HKEYS           │      □ LPUSHX         │
│      □ PEXPIREAT    │      □ INCRBYFLOAT       │      □ HLEN            │      □ LRANGE         │
│      □ PTTL         │      □ MGET              │      □ HMGET           │      □ LREM           │
│      □ RANDOMKEY    │      □ MSET              │      □ HMSET           │      □ LSET           │
│      □ RENAME       │      □ MSETNX            │      □ HSET            │      □ LTRIM          │
│      □ RENAMENX     │      □ PSETEX            │      □ HSETNX          │      □ RPOP           │
│      □ RESTORE      │      □ SET               │      □ HVALS           │      □ RPOPLPUSH      │
│      □ SORT         │      □ SETBIT            │      □ HSCAN           │      □ RPUSH          │
│      □ TTL          │      □ SETEX             │                        │      □ RPUSHX         │
│      □ TYPE         │      □ SETNX             │                        │                       │
│      □ SCAN         │      □ SETRANGE          │                        │                       │
│                     │      □ STRLEN            │                        │                       │
├─────────────────────┼──────────────────────────┼────────────────────────┼───────────────────────┤
│                     │  • SortedSet（有序集合） │                        │                       │
│  • Set（集合）      │      □ ZADD              │                        │                       │
│      □ SADD         │      □ ZCARD             │                        │                       │
│      □ SCARD        │      □ ZCOUNT            │                        │                       │
│      □ SDIFF        │      □ ZINCRBY           │                        │                       │
│      □ SDIFFSTORE   │      □ ZRANGE            │  • Pub/Sub（发布/订阅）│                       │
│      □ SINTER       │      □ ZRANGEBYSCORE     │      □ PSUBSCRIBE      │  • Transaction（事务）│
│      □ SINTERSTORE  │      □ ZRANK             │      □ PUBLISH         │      □ DISCARD        │
│      □ SISMEMBER    │      □ ZREM              │      □ PUBSUB          │      □ EXEC           │
│      □ SMEMBERS     │      □ ZREMRANGEBYRANK   │      □ PUNSUBSCRIBE    │      □ MULTI          │
│      □ SMOVE        │      □ ZREMRANGEBYSCORE  │      □ SUBSCRIBE       │      □ UNWATCH        │
│      □ SPOP         │      □ ZREVRANGE         │      □ UNSUBSCRIBE     │      □ WATCH          │
│      □ SRANDMEMBER  │      □ ZREVRANGEBYSCORE  │                        │                       │
│      □ SREM         │      □ ZREVRANK          │                        │                       │
│      □ SUNION       │      □ ZSCORE            │                        │                       │
│      □ SUNIONSTORE  │      □ ZUNIONSTORE       │                        │                       │
│      □ SSCAN        │      □ ZINTERSTORE       │                        │                       │
│                     │      □ ZSCAN             │                        │                       │
├─────────────────────┼──────────────────────────┼────────────────────────┴───────────────────────┤
│                     │                          │  • Server（服务器）                            │
│                     │                          │      □ BGREWRITEAOF                            │
│                     │                          │      □ BGSAVE                                  │
│                     │                          │      □ CLIENT GETNAME                          │
│                     │                          │      □ CLIENT KILL                             │
│                     │                          │      □ CLIENT LIST                             │
│                     │                          │      □ CLIENT SETNAME                          │
│                     │                          │      □ CONFIG GET                              │
│                     │                          │      □ CONFIG RESETSTAT                        │
│  • Script（脚本）   │                          │      □ CONFIG REWRITE                          │
│      □ EVAL         │  • Connection（连接）    │      □ CONFIG SET                              │
│      □ EVALSHA      │      □ AUTH              │      □ DBSIZE                                  │
│      □ SCRIPT EXISTS│      □ ECHO              │      □ DEBUG OBJECT                            │
│      □ SCRIPT FLUSH │      □ PING              │      □ DEBUG SEGFAULT                          │
│      □ SCRIPT KILL  │      □ QUIT              │      □ FLUSHALL                                │
│      □ SCRIPT LOAD  │      □ SELECT            │      □ FLUSHDB                                 │
│                     │                          │      □ INFO                                    │
│                     │                          │      □ LASTSAVE                                │
│                     │                          │      □ MONITOR                                 │
│                     │                          │      □ PSYNC                                   │
│                     │                          │      □ SAVE                                    │
│                     │                          │      □ SHUTDOWN                                │
│                     │                          │      □ SLAVEOF                                 │
│                     │                          │      □ SLOWLOG                                 │
│                     │                          │      □ SYNC                                    │
│                     │                          │      □ TIME                                    │
└─────────────────────┴──────────────────────────┴────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┬──────────────────────────────────────────────┬─────────────────────────────────────────────────────┐
│                                                             │  • 事务（transaction）                       │                                                     │
│  • 键空间通知（keyspace notification）                      │      □ 用法                                  │  • 发布与订阅（pub/sub）                            │
│      □ 功能概览                                             │      □ 事务中的错误                          │      □ 信息的格式                                   │
│      □ 事件的类型                                           │      □ 为什么 Redis 不支持回滚（roll back）  │      □ 订阅模式                                     │
│      □ 配置                                                 │      □ 放弃事务                              │      □ 通过频道和模式接收同一条信息                 │
│      □ 命令产生的通知                                       │      □ 使用 check-and-set 操作实现乐观锁     │      □ 订阅总数                                     │
│      □ 过期通知的发送时间                                   │      □ 了解 WATCH                            │      □ 编程示例                                     │
│                                                             │      □ 使用 WATCH 实现 ZPOP                  │      □ 客户端库实现提示                             │
│                                                             │      □ Redis 脚本和事务                      │                                                     │
├─────────────────────────────────────────────────────────────┼──────────────────────────────────────────────┼─────────────────────────────────────────────────────┤
│                                                             │                                              │  • 持久化（persistence）                            │
│                                                             │                                              │      □ Redis 持久化                                 │
│                                                             │  • 通信协议（protocol）                      │      □ RDB 的优点                                   │
│                                                             │      □ 网络层                                │      □ RDB 的缺点                                   │
│                                                             │      □ 请求                                  │      □ AOF 的优点                                   │
│  • 复制（Replication）                                      │      □ 新版统一请求协议                      │      □ AOF 的缺点                                   │
│      □ 复制功能的运作原理                                   │      □ 回复                                  │      □ RDB 和 AOF ，我应该用哪一个？                │
│      □ 部分重同步                                           │      □ 状态回复                              │      □ RDB 快照                                     │
│      □ 配置                                                 │      □ 错误回复                              │      □ 快照的运作方式                               │
│      □ 只读从服务器                                         │      □ 整数回复                              │      □ 只进行追加操作的文件（append-only file，AOF）│
│      □ 从服务器相关配置                                     │      □ 批量回复                              │      □ AOF 重写                                     │
│      □ 主服务器只在有至少 N 个从服务器的情况下，才执行写操作│      □ 多条批量回复                          │      □ AOF 有多耐久？                               │
│                                                             │      □ 多条批量回复中的空元素                │      □ 如果 AOF 文件出错了，怎么办？                │
│                                                             │      □ 多命令和流水线                        │      □ AOF 的运作方式                               │
│                                                             │      □ 内联命令                              │      □ 怎么从 RDB 持久化切换到 AOF 持久化           │
│                                                             │      □ 高性能 Redis 协议分析器               │      □ RDB 和 AOF 之间的相互作用                    │
│                                                             │                                              │      □ 备份 Redis 数据                              │
│                                                             │                                              │      □ 容灾备份                                     │
├─────────────────────────────────────────────────────────────┼──────────────────────────────────────────────┼─────────────────────────────────────────────────────┤
│                                                             │  • 集群教程                                  │  • Redis 集群规范                                   │
│  • Sentinel                                                 │      □ 集群简介                              │      □ 引言                                         │
│      □ 获取 Sentinel                                        │      □ Redis 集群数据共享                    │      □ 什么是 Redis 集群？                          │
│      □ 启动 Sentinel                                        │      □ Redis 集群中的主从复制                │      □ Redis 集群实现的功能子集                     │
│      □ 配置 Sentinel                                        │      □ Redis 集群的一致性保证（guarantee）   │      □ Redis 集群协议中的客户端和服务器             │
│      □ 主观下线和客观下线                                   │      □ 创建并使用 Redis 集群                 │      □ 键分布模型                                   │
│      □ 每个 Sentinel 都需要定期执行的任务                   │      □ 创建集群                              │      □ 集群节点属性                                 │
│      □ 自动发现 Sentinel 和从服务器                         │      □ 集群的客户端                          │      □ 节点握手（已实现）                           │
│      □ Sentinel API                                         │      □ 使用 redis-rb-cluster 编写一个示例应用│      □ MOVED 转向                                   │
│      □ 故障转移                                             │      □ 对集群进行重新分片                    │      □ 集群在线重配置（live reconfiguration）       │
│      □ TILT 模式                                            │      □ 一个更有趣的示例应用                  │      □ ASK 转向                                     │
│      □ 处理 -BUSY 状态                                      │      □ 故障转移测试                          │      □ 容错                                         │
│      □ Sentinel 的客户端实现                                │      □ 添加新节点到集群                      │      □ 发布/订阅（已实现，但仍然需要改善）          │
│                                                             │      □ 移除一个节点                          │      □ 附录 A： CRC16 算法的 ANSI 实现参考          │
└─────────────────────────────────────────────────────────────┴──────────────────────────────────────────────┴─────────────────────────────────────────────────────┘
