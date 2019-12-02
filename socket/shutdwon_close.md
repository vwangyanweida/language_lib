## close引用计数减一
1. close把描述符的引用计数减1，仅在该计数变为0时关闭套接字。shutdown可以不管引用计数就激发TCP的正常连接终止序列
2. close终止读和写两个方向的数据发送。TCP是全双工的，有时候需要告知对方已经完成了数据传送，即使对方仍有数据要发送给我们。

## shutdown 关闭链接，close关闭socket，清除资源
1. 确切地说，close() / closesocket() 用来关闭套接字，将套接字描述符（或句柄）从内存清除，之后再也不能使用该套接字，
	与C语言中的 fclose() 类似。应用程序关闭套接字后，与该套接字相关的连接和缓存也失去了意义，TCP协议会自动触发关闭连接的操作。

2. shutdown() 用来关闭连接，而不是套接字，不管调用多少次 shutdown()，套接字依然存在，直到调用 close() / closesocket() 将套接字从内存清除。

3. 优雅关闭
	1. 设置SO_LINGER:
		SO_LINGER选项用来设置延迟关闭的时间，等待套接字发送缓冲区中的数据发送完成。
		没有设置该选项时，在调用close()后，在发送完FIN后会立即进行一些清理工作并返回。
		如果设置了SO_LINGER选项，并且等待时间为正值，则在清理之前会等待一段时间。

	2. 调用close之前先调用shutdown关闭连接

4. shutdown：
	1. 定义:

	```
	int shutdown(int sock, int howto); //Linux
	int shutdown(SOCKET s, int howto); //Windows
	```

	2. 参数：
		- SHUT_RD：断开输入流。套接字无法接收数据（即使输入缓冲区收到数据也被抹去），无法调用输入相关函数。
		- SHUT_WR：断开输出流。套接字无法发送数据，<font color=red>但如果输出缓冲区中还有未传输的数据，则将传递到目标主机。</font>
		- SHUT_RDWR：同时断开 I/O 流。相当于分两次调用 shutdown()，其中一次以 SHUT_RD 为参数，另一次以 SHUT_WR 为参数。

