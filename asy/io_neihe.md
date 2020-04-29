要一直走下去

  博客园  :: 首页  :: 新随笔  :: 联系 :: 订阅订阅  :: 管理          183 Posts :: 0 Stories :: 0 Comments :: 0 Trackbacks

 理论铺垫：阻塞IO、非阻塞IO、IO多路复用/事件驱动IO(单线程高并发原理)、异步IO
 
 完全来自：http://www.cnblogs.com/alex3714/articles/5876749.html

 同步IO和异步IO，阻塞IO和非阻塞IO分别是什么，到底有什么区别？不同的人在不同的上下文下给出的答案是不同的。所以先限定一下本文
 的上下文。

 本文讨论的背景是Linux环境下的network IO。

 一概念说明

 在进行解释之前，首先要说明几个概念：
 - 用户空间和内核空间
 - 进程切换
 - 进程的阻塞
 - 文件描述符
 - 缓存 I/O

  

  

 用户空间与内核空间

 现在操作系统都是采用虚拟存储器，那么对32位操作系统而言，它的寻址空间（虚拟存储空间）为4G（2的32次方）。操作系统的核心是内
 核，独立于普通的应用程序，可以访问受保护的内存空间，也有访问底层硬件设备的所有权限。为了保证用户进程不能直接操作内核（
 kernel），保证内核的安全，操心系统将虚拟空间划分为两部分，一部分为内核空间，一部分为用户空间。针对linux操作系统而言，将最
 高的1G字节（从虚拟地址0xC0000000到0xFFFFFFFF），供内核使用，称为内核空间，而将较低的3G字节（从虚拟地址0x00000000到
 0xBFFFFFFF），供各个进程使用，称为用户空间。

  

 进程切换

 为了控制进程的执行，内核必须有能力挂起正在CPU上运行的进程，并恢复以前挂起的某个进程的执行。这种行为被称为进程切换。因此可
 以说，任何进程都是在操作系统内核的支持下运行的，是与内核紧密相关的。

 从一个进程的运行转到另一个进程上运行，这个过程中经过下面这些变化：
 1. 保存处理机上下文，包括程序计数器和其他寄存器。
 2. 更新PCB信息。

 3. 把进程的PCB移入相应的队列，如就绪、在某事件阻塞等队列。
 4. 选择另一个进程执行，并更新其PCB。
 5. 更新内存管理的数据结构。
 6. 恢复处理机上下文。

 总而言之就是很耗资源，具体的可以参考这篇文章：进程切换

 注：进程控制块（Processing Control Block），是操作系统核心中一种数据结构，主要表示进程状态。其作用是使一个在多道程序环境下
 不能独立运行的程序（含数据），成为一个能独立运行的基本单位或与其它进程并发执行的进程。或者说，OS是根据PCB来对并发执行的进
 程进行控制和管理的。 PCB通常是系统内存占用区中的一个连续存区，它存放着操作系统用于描述进程情况及控制进程运行所需的全部信息
  

 进程的阻塞

 正在执行的进程，由于期待的某些事件未发生，如请求系统资源失败、等待某种操作的完成、新数据尚未到达或无新工作做等，则由系统自
 动执行阻塞原语(Block)，使自己由运行状态变为阻塞状态。可见，进程的阻塞是进程自身的一种主动行为，也因此只有处于运行态的进程
 （获得CPU），才可能将其转为阻塞状态。当进程进入阻塞状态，是不占用CPU资源的。

 文件描述符fd

 文件描述符（File descriptor）是计算机科学中的一个术语，是一个用于表述指向文件的引用的抽象化概念。

 文件描述符在形式上是一个非负整数。实际上，它是一个索引值，指向内核为每一个进程所维护的该进程打开文件的记录表。当程序打开一
 个现有文件或者创建一个新文件时，内核向进程返回一个文件描述符。在程序设计中，一些涉及底层的程序编写往往会围绕着文件描述符展
 开。但是文件描述符这一概念往往只适用于UNIX、Linux这样的操作系统。

  

 缓存 I/O

 缓存 I/O 又被称作标准 I/O，大多数文件系统的默认 I/O 操作都是缓存 I/O。在 Linux 的缓存 I/O 机制中，操作系统会将 I/O 的数据
 缓存在文件系统的页缓存（ page cache ）中，也就是说，数据会先被拷贝到操作系统内核的缓冲区中，然后才会从操作系统内核的缓冲区
 拷贝到应用程序的地址空间。

 缓存 I/O 的缺点：
 数据在传输过程中需要在应用程序地址空间和内核进行多次数据拷贝操作，这些数据拷贝操作所带来的 CPU 以及内存开销是非常大的。

  

 二 IO模式

 刚才说了，对于一次IO访问（以read举例），数据会先被拷贝到操作系统内核的缓冲区中，然后才会从操作系统内核的缓冲区拷贝到应用程
 序的地址空间。所以说，当一个read操作发生时，它会经历两个阶段：
 1. 等待数据准备 (Waiting for the data to be ready)
 2. 将数据从内核拷贝到进程中 (Copying the data from the kernel to the process)

 正式因为这两个阶段，linux系统产生了下面五种网络模式的方案。
 - 阻塞 I/O（blocking IO）
 - 非阻塞 I/O（nonblocking IO）
 - I/O 多路复用（ IO multiplexing）
 - 信号驱动 I/O（ signal driven IO）
 - 异步 I/O（asynchronous IO）

 注：由于signal driven IO在实际中并不常用，所以我这只提及剩下的四种IO Model。

  

 阻塞 I/O（blocking IO）

 在linux中，默认情况下所有的socket都是blocking，一个典型的读操作流程大概是这样：

  [720333-201]

  

 当用户进程调用了recvfrom这个系统调用，kernel就开始了IO的第一个阶段：准备数据（对于网络IO来说，很多时候数据在一开始还没有到
 达。比如，还没有收到一个完整的UDP包。这个时候kernel就要等待足够的数据到来）。这个过程需要等待，也就是说数据被拷贝到操作系
 统内核的缓冲区中是需要一个过程的。而在用户进程这边，整个进程会被阻塞（当然，是进程自己选择的阻塞）。当kernel一直等到数据准
 备好了，它就会将数据从kernel中拷贝到用户内存，然后kernel返回结果，用户进程才解除block的状态，重新运行起来。

     所以，blocking IO的特点就是在IO执行的两个阶段都被block了。

 非阻塞 I/O（nonblocking IO）

 linux下，可以通过设置socket使其变为non-blocking。当对一个non-blocking socket执行读操作时，流程是这个样子：

 [720333-201]

  

 当用户进程发出read操作时，如果kernel中的数据还没有准备好，那么它并不会block用户进程，而是立刻返回一个error。从用户进程角度
 讲，它发起一个read操作后，并不需要等待，而是马上就得到了一个结果。用户进程判断结果是一个error时，它就知道数据还没有准备好
 ，于是它可以再次发送read操作。一旦kernel中的数据准备好了，并且又再次收到了用户进程的system call，那么它马上就将数据拷贝到
 了用户内存，然后返回。

     所以，nonblocking IO的特点是用户进程需要不断的主动询问kernel数据好了没有。

 I/O 多路复用（ IO multiplexing）

 IO multiplexing就是我们说的select，poll，epoll，有些地方也称这种IO方式为event driven IO。select/epoll的好处就在于单个
 process就可以同时处理多个网络连接的IO。它的基本原理就是select，poll，epoll这个function会不断的轮询所负责的所有socket，当某
 个socket有数据到达了，就通知用户进程。

 [720333-201]

  

 当用户进程调用了select，那么整个进程会被block，而同时，kernel会“监视”所有select负责的socket，当任何一个socket中的数据准备
 好了，select就会返回。这个时候用户进程再调用read操作，将数据从kernel拷贝到用户进程。

     所以，I/O 多路复用的特点是通过一种机制一个进程能同时等待多个文件描述符，而这些文件描述符（套接字描述符）其中的任意一个
     进入读就绪状态，select()函数就可以返回。

 这个图和blocking IO的图其实并没有太大的不同，事实上，还更差一些。因为这里需要使用两个system call (select 和 recvfrom)，而
 blocking IO只调用了一个system call (recvfrom)。但是，用select的优势在于它可以同时处理多个connection。

 所以，如果处理的连接数不是很高的话，使用select/epoll的web server不一定比使用multi-threading + blocking IO的web server性能
 更好，可能延迟还更大。select/epoll的优势并不是对于单个连接能处理得更快，而是在于能处理更多的连接。）

 在IO multiplexing Model中，实际中，对于每一个socket，一般都设置成为non-blocking，但是，如上图所示，整个用户的process其实是
 一直被block的。只不过process是被select这个函数block，而不是被socket IO给block。

  

 异步 I/O（asynchronous IO）

 inux下的asynchronous IO其实用得很少。先看一下它的流程：

 [720333-201]

 用户进程发起read操作之后，立刻就可以开始去做其它的事。而另一方面，从kernel的角度，当它受到一个asynchronous read之后，首先
 它会立刻返回，所以不会对用户进程产生任何block。然后，kernel会等待数据准备完成，然后将数据拷贝到用户内存，当这一切都完成之
 后，kernel会给用户进程发送一个signal，告诉它read操作完成了。

  

 总结

 blocking和non-blocking的区别

 调用blocking IO会一直block住对应的进程直到操作完成，而non-blocking IO在kernel还准备数据的情况下会立刻返回。

 synchronous IO和asynchronous IO的区别

 在说明synchronous IO和asynchronous IO的区别之前，需要先给出两者的定义。POSIX的定义是这样子的：
 - A synchronous I/O operation causes the requesting process to be blocked until that I/O operation completes;
 - An asynchronous I/O operation does not cause the requesting process to be blocked;

 两者的区别就在于synchronous IO做”IO operation”的时候会将process阻塞。按照这个定义，之前所述的blocking IO，non-blocking IO
 ，IO multiplexing都属于synchronous IO。

 有人会说，non-blocking IO并没有被block啊。这里有个非常“狡猾”的地方，定义中所指的”IO operation”是指真实的IO操作，就是例子中
 的recvfrom这个system call。non-blocking IO在执行recvfrom这个system call的时候，如果kernel的数据没有准备好，这时候不会block
 进程。但是，当kernel中数据准备好的时候，recvfrom会将数据从kernel拷贝到用户内存中，这个时候进程是被block了，在这段时间内，
 进程是被block的。

 而asynchronous IO则不一样，当进程发起IO 操作之后，就直接返回再也不理睬了，直到kernel发送一个信号，告诉进程说IO完成。在这整
 个过程中，进程完全没有被block。

  

 各个IO Model的比较如图所示：

 [720333-201]

  

 通过上面的图片，可以发现non-blocking IO和asynchronous IO的区别还是很明显的。在non-blocking IO中，虽然进程大部分时间都不会
 被block，但是它仍然要求进程去主动的check，并且当数据准备完成以后，也需要进程主动的再次调用recvfrom来将数据拷贝到用户内存。
 而asynchronous IO则完全不同。它就像是用户进程将整个IO操作交给了他人（kernel）完成，然后他人做完后发信号通知。在此期间，用
 户进程不需要去检查IO操作的状态，也不需要主动的去拷贝数据。

  

 三 I/O 多路复用之select、poll、epoll详解

 select，poll，epoll都是IO多路复用的机制。I/O多路复用就是通过一种机制，一个进程可以监视多个描述符，一旦某个描述符就绪（一般
 是读就绪或者写就绪），能够通知程序进行相应的读写操作。但select，poll，epoll本质上都是同步I/O，因为他们都需要在读写事件就绪
 后自己负责进行读写，也就是说这个读写过程是阻塞的，而异步I/O则无需自己负责进行读写，异步I/O的实现会负责把数据从内核拷贝到用
 户空间。（这里啰嗦下）

 select
 
 1 select(rlist, wlist, xlist, timeout=None)

 select 函数监视的文件描述符分3类，分别是writefds、readfds、和exceptfds。调用后select函数会阻塞，直到有描述副就绪（有数据可
 读、可写、或者有except），或者超时（timeout指定等待时间，如果立即返回设为null即可），函数返回。当select函数返回后，可以通
 过遍历fdset，来找到就绪的描述符。

 select目前几乎在所有的平台上支持，其良好跨平台支持也是它的一个优点。select的一个缺点在于单个进程能够监视的文件描述符的数量
 存在最大限制，在Linux上一般为1024，可以通过修改宏定义甚至重新编译内核的方式提升这一限制，但是这样也会造成效率的降低。

 poll
 
 1 int poll (struct pollfd *fds, unsigned int nfds, int timeout);

 不同与select使用三个位图来表示三个fdset的方式，poll使用一个 pollfd的指针实现。

 struct pollfd {
     int fd; /* file descriptor */
     short events; /* requested events to watch */
     short revents; /* returned events witnessed */
 };
 
 pollfd结构包含了要监视的event和发生的event，不再使用select“参数-值”传递的方式。同时，pollfd并没有最大数量限制（但是数量过
 大后性能也是会下降）。和select函数一样，poll返回后，需要轮询pollfd来获取就绪的描述符。

     从上面看，select和poll都需要在返回后，通过遍历文件描述符来获取已经就绪的socket。事实上，同时连接的大量客户端在一时刻可
     能只有很少的处于就绪状态，因此随着监视的描述符数量的增长，其效率也会线性下降。

 　　

 epoll

 epoll是在2.6内核中提出的，是之前的select和poll的增强版本。相对于select和poll来说，epoll更加灵活，没有描述符限制。epoll使用
 一个文件描述符管理多个描述符，将用户关系的文件描述符的事件存放到内核的一个事件表中，这样在用户空间和内核空间的copy只需一次
 。

 一 epoll操作过程

 epoll操作过程需要三个接口，分别如下：

  
 
 1 int epoll_create(int size)；//创建一个epoll的句柄，size用来告诉内核这个监听的数目一共有多大
 2 int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)；
 3 int epoll_wait(int epfd, struct epoll_event * events, int maxevents, int timeout);

 1. int epoll_create(int size);
 创建一个epoll的句柄，size用来告诉内核这个监听的数目一共有多大，这个参数不同于select()中的第一个参数，给出最大监听的fd+1的
 值，参数size并不是限制了epoll所能监听的描述符最大个数，只是对内核初始分配内部数据结构的一个建议。
 当创建好epoll句柄后，它就会占用一个fd值，在linux下如果查看/proc/进程id/fd/，是能够看到这个fd的，所以在使用完epoll后，必须
 调用close()关闭，否则可能导致fd被耗尽。

 2. int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)；
 函数是对指定描述符fd执行op操作。
 - epfd：是epoll_create()的返回值。
 - op：表示op操作，用三个宏来表示：添加EPOLL_CTL_ADD，删除EPOLL_CTL_DEL，修改EPOLL_CTL_MOD。分别添加、删除和修改对fd的监听
 事件。
 - fd：是需要监听的fd（文件描述符）
 - epoll_event：是告诉内核需要监听什么事

 3. int epoll_wait(int epfd, struct epoll_event * events, int maxevents, int timeout);
 等待epfd上的io事件，最多返回maxevents个事件。
 参数events用来从内核得到事件的集合，maxevents告之内核这个events有多大，这个maxevents的值不能大于创建epoll_create()时的size
 ，参数timeout是超时时间（毫秒，0会立即返回，-1将不确定，也有说法说是永久阻塞）。该函数返回需要处理的事件数目，如返回0表示
 已超时。

  

 　　

 [Contracted][ExpandedBl]
 
 #_*_coding:utf-8_*_
 __author__ = 'Alex Li'

 import socket, logging
 import select, errno

 logger = logging.getLogger("network-server")

 def InitLog():
     logger.setLevel(logging.DEBUG)

     fh = logging.FileHandler("network-server.log")
     fh.setLevel(logging.DEBUG)
     ch = logging.StreamHandler()
     ch.setLevel(logging.ERROR)

     formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
     ch.setFormatter(formatter)
     fh.setFormatter(formatter)

     logger.addHandler(fh)
     logger.addHandler(ch)


 if __name__ == "__main__":
     InitLog()

     try:
         # 创建 TCP socket 作为监听 socket
         listen_fd = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
     except socket.error as  msg:
         logger.error("create socket failed")

     try:
         # 设置 SO_REUSEADDR 选项
         listen_fd.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
     except socket.error as  msg:
         logger.error("setsocketopt SO_REUSEADDR failed")

     try:
         # 进行 bind -- 此处未指定 ip 地址，即 bind 了全部网卡 ip 上
         listen_fd.bind(('', 2003))
     except socket.error as  msg:
         logger.error("bind failed")

     try:
         # 设置 listen 的 backlog 数
         listen_fd.listen(10)
     except socket.error as  msg:
         logger.error(msg)

     try:
         # 创建 epoll 句柄
         epoll_fd = select.epoll()
         # 向 epoll 句柄中注册 监听 socket 的 可读 事件
         epoll_fd.register(listen_fd.fileno(), select.EPOLLIN)
     except select.error as  msg:
         logger.error(msg)

     connections = {}
     addresses = {}
     datalist = {}
     while True:
         # epoll 进行 fd 扫描的地方 -- 未指定超时时间则为阻塞等待
         epoll_list = epoll_fd.poll()

         for fd, events in epoll_list:
             # 若为监听 fd 被激活
             if fd == listen_fd.fileno():
                 # 进行 accept -- 获得连接上来 client 的 ip 和 port，以及 socket 句柄
                 conn, addr = listen_fd.accept()
                 logger.debug("accept connection from %s, %d, fd = %d" % (addr[0], addr[1], conn.fileno()))
                 # 将连接 socket 设置为 非阻塞
                 conn.setblocking(0)
                 # 向 epoll 句柄中注册 连接 socket 的 可读 事件
                 epoll_fd.register(conn.fileno(), select.EPOLLIN | select.EPOLLET)
                 # 将 conn 和 addr 信息分别保存起来
                 connections[conn.fileno()] = conn
                 addresses[conn.fileno()] = addr
             elif select.EPOLLIN & events:
                 # 有 可读 事件激活
                 datas = ''
                 while True:
                     try:
                         # 从激活 fd 上 recv 10 字节数据
                         data = connections[fd].recv(10)
                         # 若当前没有接收到数据，并且之前的累计数据也没有
                         if not data and not datas:
                             # 从 epoll 句柄中移除该 连接 fd
                             epoll_fd.unregister(fd)
                             # server 侧主动关闭该 连接 fd
                             connections[fd].close()
                             logger.debug("%s, %d closed" % (addresses[fd][0], addresses[fd][1]))
                             break
                         else:
                             # 将接收到的数据拼接保存在 datas 中
                             datas += data
                     except socket.error as  msg:
                         # 在 非阻塞 socket 上进行 recv 需要处理 读穿 的情况
                         # 这里实际上是利用 读穿 出 异常 的方式跳到这里进行后续处理
                         if msg.errno == errno.EAGAIN:
                             logger.debug("%s receive %s" % (fd, datas))
                             # 将已接收数据保存起来
                             datalist[fd] = datas
                             # 更新 epoll 句柄中连接d 注册事件为 可写
                             epoll_fd.modify(fd, select.EPOLLET | select.EPOLLOUT)
                             break
                         else:
                             # 出错处理
                             epoll_fd.unregister(fd)
                             connections[fd].close()
                             logger.error(msg)
                             break
             elif select.EPOLLHUP & events:
                 # 有 HUP 事件激活
                 epoll_fd.unregister(fd)
                 connections[fd].close()
                 logger.debug("%s, %d closed" % (addresses[fd][0], addresses[fd][1]))
             elif select.EPOLLOUT & events:
                 # 有 可写 事件激活
                 sendLen = 0
                 # 通过 while 循环确保将 buf 中的数据全部发送出去
                 while True:
                     # 将之前收到的数据发回 client -- 通过 sendLen 来控制发送位置
                     sendLen += connections[fd].send(datalist[fd][sendLen:])
                     # 在全部发送完毕后退出 while 循环
                     if sendLen == len(datalist[fd]):
                         break
                 # 更新 epoll 句柄中连接 fd 注册事件为 可读
                 epoll_fd.modify(fd, select.EPOLLIN | select.EPOLLET)
             else:
                 # 其他 epoll 事件不进行处理
                 continue

 epoll socket echo server

 epoll socket echo server

  

 posted on 2018-09-26 22:40  要一直走下去  阅读(...)  评论(...)  编辑  收藏
 刷新评论刷新页面返回顶部

Copyright @ 2020 要一直走下去
Powered by .NET Core on Kubernetes
Powered by: .Text and ASP.NET
Theme by: .NET Monster

