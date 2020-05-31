## 运维
1. 备份
	- 冷备
	- mongodump / mongorestore  热备/冷备
	- fsync + 写入锁: 写入会阻塞
		```
		use admin;
		db.runCommand({"fsync":1, "lock": 1})


		解锁:
		db.$cmd.sys.unlock.findOne();
		db.currentop();
		```
	- 通过从服务器备份,最好
