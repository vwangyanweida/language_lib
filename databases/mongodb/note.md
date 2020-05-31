## 笔记
1. 优点
	- 面向文档,自动分割平衡集群数据,数据库负载,自动重排文档

2. 创建index,document 有附加结构,index是集合来定义的.

3. 子集合可以用.来实现,语言驱动有这个语法糖,可以直接通过.来查找字集合

4. 配置
	
5. 注意update的修改和替换,替换整个文档的话`_id`也会变,而修改的话`_id`是不变的.
	- 修改器:局部修改:
		- update 第二个参数使用{"$command": {"key": "value"}}
		- 修改器`_id`不能变,
		- 修改器和查找条件的不同:
			- 修改器一般是一个修改,所以一般修改作为key,而field和新值的字典作为value
			- 查找器有多个必要条件,所以一般多个条件在字典里面,而field作为条件的key.

		- 修改器命令:

	- 整体文档替换
		- 文档

6. 属性查找:
	- 先找db的属性,如果db.后跟的不是db的属性的话
	- 再找collection
	- collection不方便如此查找的话,使用getCollection破解同名

7. js 中,x.y 和x[y]完全等价
8. 批量导入只对多个文档插入同一个集合有效,不支持多个集合
9. 导入数据使用import 而不是批量导入
10. monogdb的4M文档要求
11. remove不删除collection,不删除index,不可撤销,不可恢复
12. 删除整个collection使用dropCollection,然后重建index,比一条一条删除省时间
13. update是原子性的,先到先执行,最后更新确定数据最终状态
14. DBRef
```
{"$ref": collections, "$id": id_value}
{"$ref": coll, "$id": id_value, $db":db_name"} 
```
15. mongodb 停止:
	- kill -2: pid SIGINT 保存缓存然后关闭,不要-9, -9直接关闭进程,会导致数据库文件损害或者丢失数据
	- kill pid SIGTERM
	- use admin; db.shutdownServer();

16. 本地mongodb不需要auth认证,有特权

17. 创建固定集合 
	db.createCollection({"My": {capped: true, size: 10000, max: 100}});
18. 服务端执行命令的两种方法:
	- db.runCommand()
	- db.$cmd.findOne({"command":1})
- js中,for (var i in iter) 如果iter是数组,那么i就是数组索引,如果iter是字典对象,那么i就是字典的key

- <font color=red>find查找时,field在条件前面作为key,因为同一个field可能有多个条件,每个条件是一个kv.</font>
- <font color=red>update更改是,更改器在field前面作为key,因为更改时肯定是针对一个field,不可能对同一个field多次改变,field在后面更直观</font>
