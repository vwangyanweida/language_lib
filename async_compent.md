
<!-- vim-markdown-toc GFM -->

* [异步网络框架]
	* [结构]
		* [socket]
		* [stream]
			* [read_until]
			* [completed]
		* [block]
		* [asncy]
		* [loop]
		* [callback/handler]
		* [future]
		* [thread]

<!-- vim-markdown-toc -->
## 异步网络框架
### 结构
#### socket
#### stream
##### read_until
##### completed

#### block
#### asncy
#### loop
#### callback/handler
#### future
#### thread
																									- thread,future.set_result,notify
socket - 阻塞/非阻塞 - 协议(tcp/http/) - stream(read_util/read) - handler - epoll - promise/future - readable/writeable - handler
