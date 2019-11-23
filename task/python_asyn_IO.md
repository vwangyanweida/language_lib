#python 异步IO的实现和用法笔记

##一、概述
1. **python的异步IO主要是通过事件循环来实现的异步阻塞IO，主要用在socket的io上面，普通文件的io依旧会阻塞，linux系统内核有两种AIO，一种是通过多线程和进程来模拟实现异步IO的，另一中真正的的AIO，不能缓存，直接写入磁盘，了解不深,这里不介绍了**

2. python是实现的异步也包括两种
	
	1. 通过多线程或者多进程来模拟异步IO，python的cocurrent就是用这种方法来让本身不是异步的任务达到异步的预期，tornado使用异步装饰器来通过cocurrent的exector来将同步的任务模拟成异步任务。
	
	2. 通过epoll/select/kqueue 和非阻塞socket来实现socket的异步。asyncio、tornado、zeromq中的事件循环就是通过这样来实现异步网络IO的异步的。

##二、Promise，Future和Callback
1.并发编程通常都会用到一组非阻塞的模型：Promise，Future和Callback，这是很多异步非阻塞框架的基础。

* Future表示一个可能还没有实际完成的异步任务的结果，针对这个结果可以添加Callback以便在任务执行成功或失败后做出对应的操作。
* Promise 交由任务执行者，任务执行者通过Promise可以标记任务完成或者失败

##三、事件循环

##四、notify/wait 锁

##五、tornado的异步实现
