def loop():
    while True:
        events = selector.select()
        for event_key, event_mask in events:
            callback = event_key.data
            callback()

的连接回调是存储为 event_key.data 后,我们检索和执行非阻塞套接字连接。

与上面的快速旋转的循环中,调用选择在这里暂停,等待下一个I / O事件。然后循环运行等这些事件的回调。操作没有完成的继续等待直到
未来事件循环的蜱虫。

我们已经展示了什么? 我们展示了如何开始一个操作和执行回调操作时做好准备。一个异步框架建立在我们的两个特性showna  非阻塞套接
字和事件loopa  运行一个线程并发操作。

我们取得了“并发”在这里,但不是传统上被称为“并行性”。也就是说,我们建立了一个小系统,并重叠I / O。它能够开始新的操作而另一些则
在飞行中。它实际上并没有利用多核并行执行计算。但是,这个系统是专为I / o限制的问题,而不是中央处理器受限的。 ^4

所以我们的事件循环是有效地并发I / O,因为它没有把每个连接线程资源。但在我们继续进行之前,重要的是要正确的一种常见的误解,异步
快多线程。通常是背板  的确,在Python中,像我们这样的一个事件循环中度慢于多线程在少数非常活跃的连接服务。在运行时没有全局解释
器锁,线程会执行更好的这样的一个工作负载。异步I / O是正确的,应用程序与许多减缓或昏昏欲睡的连接与罕见的事件。 ^5

编程与回调

与身材短小的异步框架我们已经构建了到目前为止,我们怎样才能建立一个网络爬虫? 即使是一个简单的URL-fetcher是痛苦的写作。

我们开始与全球的url我们还没有取回,url我们看到:

urls_todo = set(['/'])
seen_urls = set(['/'])

的 seen_urls 设置包括 urls_todo 加上完成url。这两组与根URL初始化“/”。

获取一个页面需要一系列回调。的连接回调大火当一个套接字连接,并发送一个GET请求到服务器。但它必须等待响应,所以它注册一个回调
。当回调火,如果它不能阅读完整的反应,它再次注册,等等。

让我们收集这些回调成取物对象。它需要一个URL、一个套接字对象和一个地方积累响应字节:

class Fetcher:
    def __init__(self, url):
        self.response = b''  # Empty array of bytes.
        self.url = url
        self.sock = None

我们开始通过调用 Fetcher.fetch :

    # Method on Fetcher class.
    def fetch(self):
        self.sock = socket.socket()
        self.sock.setblocking(False)
        try:
            self.sock.connect(('xkcd.com', 80))
        except BlockingIOError:
            pass

        # Register next callback.
        selector.register(self.sock.fileno(),
                          EVENT_WRITE,
                          self.connected)

的获取开始连接套接字的方法。但是请注意该方法返回在建立连接之前。它必须返回控制事件循环等待连接。要理解为什么,想象我们整个
应用程序结构:

# Begin fetching http://xkcd.com/353/
fetcher = Fetcher('/353/')
fetcher.fetch()

while True:
    events = selector.select()
    for event_key, event_mask in events:
        callback = event_key.data
        callback(event_key, event_mask)

处理所有事件通知的事件循环的时候调用选择。因此获取必须手动操纵事件循环,所以程序知道什么时候套接字连接。只有这样的循环运行
连接回调,这是注册的获取以上。

这是实施连接 :

    # Method on Fetcher class.
    def connected(self, key, mask):
        print('connected!')
        selector.unregister(key.fd)
        request = 'GET {} HTTP/1.0\r\nHost: xkcd.com\r\n\r\n'.format(self.url)
        self.sock.send(request.encode('ascii'))

        # Register the next callback.
        selector.register(key.fd,
                          EVENT_READ,
                          self.read_response)

方法发送一个GET请求。一个真正的应用程序将检查的返回值发送在整个邮件无法发送。但是我们很小,我们的应用程序的请求。它愉快地调
用发送 ,然后等待响应。当然,它必须注册另一个回调事件循环和放弃控制。下一个也是最后一个回调, read_response 、流程服务器的回
答:

    # Method on Fetcher class.
    def read_response(self, key, mask):
        global stopped

        chunk = self.sock.recv(4096)  # 4k chunk size.
        if chunk:
            self.response += chunk
        else:
            selector.unregister(key.fd)  # Done reading.
            links = self.parse_links()

            # Python set-logic:
            for link in links.difference(seen_urls):
                urls_todo.add(link)
                Fetcher(link).fetch()  # <- New Fetcher.

            seen_urls.update(links)
            urls_todo.remove(self.url)
            if not urls_todo:
                stopped = True

每次回调执行套接字的选择器认为是“可读”,这可能意味着两件事:套接字数据或它是关闭的。

回调要求从套接字四个字节的数据。如果少吃就是好, 块包含任何数据是可用的。如果有更多的, 块长4 kb,套接字仍然是可读的,所以事件
循环运行这个回调下。反应完成后,服务器已经关闭套接字块是空的。

的 parse_links 方法,没有显示,返回一组url。我们开始一个新的访问者对于每一个新的URL,没有并发帽。注意与回调函数异步编程的一个
不错的功能:我们不需要互斥共享数据的修改,比如当我们添加链接 seen_urls 。没有抢先多任务处理,所以我们不能中断任意点在我们的代
码。

我们添加一个全球停止变量和使用它来控制循环:

stopped = False

def loop():
    while not stopped:
        events = selector.select()
        for event_key, event_mask in events:
            callback = event_key.data
            callback()

一旦所有页面下载访问者停止全球事件循环,程序退出。

这个例子使普通异步的问题:意大利面条式代码。我们需要一些方式来表达一系列的计算和I / O操作,和进度等多个并发运行的一系列操作
。但是没有线程,一系列的操作不能被收集到一个单独的功能:只要一个函数开始一个I / O操作,它需要显式保存任何状态在未来,然后返回
。你负责思考和写这个状态保存代码。

让我们解释我们的意思。考虑我们如何简单地获取URL与传统的线程阻塞套接字:

# Blocking version.
def fetch(url):
    sock = socket.socket()
    sock.connect(('xkcd.com', 80))
    request = 'GET {} HTTP/1.0\r\nHost: xkcd.com\r\n\r\n'.format(url)
    sock.send(request.encode('ascii'))
    response = b''
    chunk = sock.recv(4096)
    while chunk:
        response += chunk
        chunk = sock.recv(4096)

    # Page is now downloaded.
    links = parse_links(response)
    q.add(links)

什么状态函数之间记住一个套接字操作和下一个? 套接字,一个URL,积累响应。一个线程上运行的一个函数,使用编程语言的基本特性在局部
变量存储这个临时状态,在其堆栈。函数也有一个“延续”  即代码计划执行I / O完成之后。运行时记得继续通过存储线程的指令指针。你不
需要考虑恢复这些局部变量和I / O后的延续。它是建立在语言。

但在一个基于回调的异步框架中,这些语言特性没有帮助。在等待I / O,一个函数必须显式保存其状态,因为函数返回和I / O完成之前失去
了堆栈帧。局部变量代替,我们的商店基于回调的例子袜子和响应的属性自我取物的实例。代替指令指针,它存储的延续注册回调连接和 
read_response 。随着应用程序的功能的增长,如此状态的复杂性我们手动保存回调。这样繁重的簿记使编码器容易偏头痛。

更糟糕的是,如果一个回调将抛出一个异常,之前安排中的下一个回调链吗? 说我们做得相当糟糕 parse_links 方法抛出一个异常解析一些
HTML:

Traceback (most recent call last):
  File "loop-with-callbacks.py", line 111, in <module>
    loop()
  File "loop-with-callbacks.py", line 106, in loop
    callback(event_key, event_mask)
  File "loop-with-callbacks.py", line 51, in read_response
    links = self.parse_links()
  File "loop-with-callbacks.py", line 67, in parse_links
    raise Exception('parse error')
Exception: parse error

堆栈跟踪显示只运行一个回调的事件循环。我们不记得了什么错误。两端链条坏了:我们忘记我们和我们从何处来。这个上下文丢失,叫做“
堆栈分离”,在许多情况下它混淆调查员。堆栈撕裂也阻止我们安装一个异常处理程序链的回调,像“试试/除了“块封装函数调用及其后裔之树
。 ^6

所以,甚至除了长讨论多线程和异步的相对效率,这是其他争论关于哪个更容易出错:线程是容易受到数据同步比赛如果你犯了错,但回调是顽
固的调试由于堆栈撕裂。

协同程序

我们用一个承诺引诱你。可以编写异步代码相结合的效率与多线程编程的经典美貌回调。这种组合是实现模式称为“协同程序”。使用Python
3.4的标准asyncio库,和一个包称为“aiohttp”,获取一个URL在协同程序是非常直接的 ^7 :

    @asyncio.coroutine
    def fetch(self, url):
        response = yield from self.session.get(url)
        body = yield from response.read()

它也是可扩展的。每个线程相比50 k的内存和操作系统的限制线程,一个Python协同程序需要不到3 k的内存对杰西的系统。 Python可以很
容易地开始成千上万的协同程序。

协同程序的概念,约会老天的计算机科学,很简单:它是一个子程序,可以暂停和重新开始。而线程先发制人同时多任务工作,由操作系统协同
程序协同多任务:他们选择暂停时,协同程序下运行。

有许多协同程序的实现; 即使是在Python有几种。协同程序在Python 3.4的标准“asyncio”库是建立在发电机,未来的类,声明“收益率从”。
在Python 3.5开始,协同程序是一个本地语言本身的特性 ^8 ; 然而,协同程序理解为他们是第一个在Python 3.4中实现,使用已有的语言设
施,是Python 3.5的本地协同程序的基础。

来解释Python 3.4的发生器协同程序,我们将参加博览会的发电机和怎样使用它们作为asyncio协程,相信你会喜欢阅读它尽可能多乐趣。一
旦我们解释发生器协同程序,我们将使用它们在我们的异步网络爬虫。

Python发电机的工作原理

在掌握Python发电机之前,你必须了解常规的Python函数是如何工作的。通常,当一个Python函数调用子程序,子程序保留控制,直到它返回,
或者抛出一个异常。然后控制返回给调用者:

>>> def foo():
...     bar()
...
>>> def bar():
...     pass

标准的Python解释器是用C语言编写的C函数执行Python函数被调用时,流畅, PyEval_EvalFrameEx 。需要一个Python堆栈帧对象和评估
Python字节码框架的上下文中。这是字节码喷火 :

>>> import dis
>>> dis.dis(foo)
  2           0 LOAD_GLOBAL              0 (bar)
              3 CALL_FUNCTION            0 (0 positional, 0 keyword pair)
              6 POP_TOP
              7 LOAD_CONST               0 (None)
             10 RETURN_VALUE

的喷火函数加载酒吧到其堆栈并调用它,然后从堆栈中弹出它的返回值,负荷没有一个压入堆栈,并返回没有一个。

当 PyEval_EvalFrameEx 遇到 CALL_FUNCTION Python字节码,它创建一个新的堆栈帧和递归:也就是说,它调用 PyEval_EvalFrameEx 递归地
使用新的框架,用于执行酒吧。

是至关重要的,理解这Python堆栈帧分配在堆内存! Python解释器是一个正常的C程序,所以它的堆栈帧是正常的堆栈帧。但是, Python 堆栈
帧在堆上操纵。其他意外,这意味着一个Python堆栈帧可以比它的函数调用。看到这种交互,从内部保存当前帧酒吧 :

>>> import inspect
>>> frame = None
>>> def foo():
...     bar()
...
>>> def bar():
...     global frame
...     frame = inspect.currentframe()
...
>>> foo()
>>> # The frame was executing the code for 'bar'.
>>> frame.f_code.co_name
'bar'
>>> # Its back pointer refers to the frame for 'foo'.
>>> caller_frame = frame.f_back
>>> caller_frame.f_code.co_name
'foo'

Figure 5.1 - Function Calls

图5.1 -函数调用

现在的阶段是为Python发电机,使用相同的建筑blocksa  代码对象和堆栈framesa  奇妙的效果。

这是一个生成器函数:

>>> def gen_fn():
...     result = yield 1
...     print('result of yield: {}'.format(result))
...     result2 = yield 2
...     print('result of 2nd yield: {}'.format(result2))
...     return 'done'
...

当Python编译 gen_fn 字节码,它看到了收益率语句和知道 gen_fn 是一个生成器函数,而不是一个常规。设置一个标志是要记住这一事实:

>>> # The generator flag is bit position 5.
>>> generator_bit = 1 << 5
>>> bool(gen_fn.__code__.co_flags & generator_bit)
True

当你调用生成器函数时,Python将发电机国旗,和它不实际运行功能。相反,它创造了一个发电机:

>>> gen = gen_fn()
>>> type(gen)
<class 'generator'>

Python发电机封装一个堆栈帧加上引用一些代码,身体的 gen_fn :

>>> gen.gi_code.co_name
'gen_fn'

从调用所有的发电机 gen_fn 指向相同的代码。但每个都有自己的堆栈帧。这个堆栈帧不是任何实际堆栈上,它位于堆内存等待使用:

Figure 5.2 - Generators

图5.2 -发电机

框架有一个“最后的指令”指针,最近执行的指令。一开始,最后一个指令指针是1,这意味着生成器还没有开始:

>>> gen.gi_frame.f_lasti
-1

当我们调用发送首先,发电机达到收益率和停顿。的返回值发送是1,因为这是什么创通过对收益率表达式:

>>> gen.send(None)
1

发电机的指令指针现在是3字节码从一开始,通过56字节编译Python部分:

>>> gen.gi_frame.f_lasti
3
>>> len(gen.gi_code.co_code)
56

发电机可以随时恢复,从任何函数,因为它的堆栈帧实际上并不是在堆栈上:它是在堆上。它在调用层次结构中的位置是不固定的,它不需要遵
守先入先持续正常功能的执行顺序。解放了,自由漂浮像一朵云。

我们可以发送“你好”的值为发电机和就的结果收益率表情,发电机仍在继续,直到收益率2:

>>> gen.send('hello')
result of yield: hello
2

堆栈帧现在包含局部变量结果 :

>>> gen.gi_frame.f_locals
{'result': 'hello'}

其他生成器创建的 gen_fn 会有自己的堆栈帧和本地变量。

当我们调用发送第二,发电机仍在继续收益率 ,通过提高完特别抛出StopIteration 例外:

>>> gen.send('goodbye')
result of 2nd yield: goodbye
Traceback (most recent call last):
  File "<input>", line 1, in <module>
StopIteration: done

除了有一个值,这是发电机的返回值:字符串 “完成” 。

与发电机建立协同程序

所以发电机可以暂停,它可以恢复一个值,它有一个返回值。听起来像一个好原始的建立一个异步编程模型,没有意大利面条回调! 我们想要
建立一个“协同程序”:一个合作计划与其他常规程序例程。我们的协同程序是一个简化版本的Python的标准“asyncio”库。 asyncio一样,我
们将使用发电机,期货,收益率从“声明。

首先,我们需要一种方法来表示一些协同程序等待未来的结果。有精简版:

class Future:
    def __init__(self):
        self.result = None
        self._callbacks = []

    def add_done_callback(self, fn):
        self._callbacks.append(fn)

    def set_result(self, result):
        self.result = result
        for fn in self._callbacks:
            fn(self)

最初“悬而未决”的未来。这是通过调用“解决” set_result 。 ^9

让我们使我们的访问者使用期货和协同程序。我们写了获取一个回调:

class Fetcher:
    def fetch(self):
        self.sock = socket.socket()
        self.sock.setblocking(False)
        try:
            self.sock.connect(('xkcd.com', 80))
        except BlockingIOError:
            pass
        selector.register(self.sock.fileno(),
                          EVENT_WRITE,
                          self.connected)

    def connected(self, key, mask):
        print('connected!')
        # And so on....

的获取方法开始连接套接字,然后注册回调, 连接时,将执行套接字已经准备好了。现在我们可以将这两个步骤合并成一个协同程序:

    def fetch(self):
        sock = socket.socket()
        sock.setblocking(False)
        try:
            sock.connect(('xkcd.com', 80))
        except BlockingIOError:
            pass

        f = Future()

        def on_connected():
            f.set_result(None)

        selector.register(sock.fileno(),
                          EVENT_WRITE,
                          on_connected)
        yield f
        selector.unregister(sock.fileno())
        print('connected!')

现在获取是一个生成器函数,而不是一个常规,因为它包含一个吗收益率声明。我们创建一个等待未来,然后暂停收益率获取到套接字已经准
备好了。的内部函数 on_connected 解决未来。

但未来解决时,发电机的简历什么? 我们需要一个协同程序司机。让我们称它为“任务”:

class Task:
    def __init__(self, coro):
        self.coro = coro
        f = Future()
        f.set_result(None)
        self.step(f)

    def step(self, future):
        try:
            next_future = self.coro.send(future.result)
        except StopIteration:
            return

        next_future.add_done_callback(self.step)

# Begin fetching http://xkcd.com/353/
fetcher = Fetcher('/353/')
Task(fetcher.fetch())

loop()

任务开始获取发电机通过发送没有一个进去。然后获取运行,直到它未来的收益率,这任务了 next_future 。套接字连接时,事件循环跑回调
on_connected ,解决未来,电话一步的简历获取。

保理协同程序与产量从

套接字连接后,我们发送HTTP GET请求并读取服务器响应。这些步骤需要不再是分散在回调; 我们收集到相同的发生器功能:

    def fetch(self):
        # ... connection logic from above, then:
        sock.send(request.encode('ascii'))

        while True:
            f = Future()

            def on_readable():
                f.set_result(sock.recv(4096))

            selector.register(sock.fileno(),
                              EVENT_READ,
                              on_readable)
            chunk = yield f
            selector.unregister(sock.fileno())
            if chunk:
                self.response += chunk
            else:
                # Done reading.
                break

这段代码中,从套接字读取整个消息,似乎通常有用。我们怎样才能从因素吗获取子程序? 现在Python 3的庆祝产量从走上舞台。它允许一个
发电机委托到另一个地方。

如何,还是让我们回到简单的发电机的例子:

>>> def gen_fn():
...     result = yield 1
...     print('result of yield: {}'.format(result))
...     result2 = yield 2
...     print('result of 2nd yield: {}'.format(result2))
...     return 'done'
...

调用这个从另一个发电机,发电机委托给它产量从 :

>>> # Generator function:
>>> def caller_fn():
...     gen = gen_fn()
...     rv = yield from gen
...     print('return value of yield-from: {}'
...           .format(rv))
...
>>> # Make a generator from the
>>> # generator function.
>>> caller = caller_fn()

的调用者发电机作为如果它是创发电机是委托:

>>> caller.send(None)
1
>>> caller.gi_frame.f_lasti
15
>>> caller.send('hello')
result of yield: hello
2
>>> caller.gi_frame.f_lasti  # Hasn't advanced.
15
>>> caller.send('goodbye')
result of 2nd yield: goodbye
return value of yield-from: done
Traceback (most recent call last):
  File "<input>", line 1, in <module>
StopIteration

而调用者收益率创 , 调用者不进步。注意,其指令指针仍在15日的网站产量从声明,即使内心生成器创从一个进步收益率声明。 ^10 从我们
的角度来看外调用者 ,我们不能判断它收益率的值调用者或从它代表的发电机。从内部创 ,我们不能判断发送的值调用者或从外面。的产量
从声明是一个无摩擦的频道,通过流的值创直到创完成。

协同程序可以将工作委托给一个sub-coroutine 产量从和接收工作的结果。注意,上面调用者打印“获得返回值:完成”。当创完成后,其返回
值的值产量从声明调用者 :

    rv = yield from gen

早些时候,当我们批评基于回调的异步编程中,我们最尖锐的抱怨是关于“堆栈撕裂”:当一个回调将抛出一个异常,堆栈跟踪通常是无用的。它
只显示了事件循环回调,不是为什么。协程票价如何?

>>> def gen_fn():
...     raise Exception('my error')
>>> caller = caller_fn()
>>> caller.send(None)
Traceback (most recent call last):
  File "<input>", line 1, in <module>
  File "<input>", line 3, in caller_fn
  File "<input>", line 2, in gen_fn
Exception: my error

这是更有用的! 堆栈跟踪显示 caller_fn 被委托给 gen_fn 当它把错误。更欣慰的是,我们可以将调用sub-coroutine异常处理程序,也是正
常的子程序:

>>> def gen_fn():
...     yield 1
...     raise Exception('uh oh')
...
>>> def caller_fn():
...     try:
...         yield from gen_fn()
...     except Exception as exc:
...         print('caught {}'.format(exc))
...
>>> caller = caller_fn()
>>> caller.send(None)
1
>>> caller.send('hello')
caught uh oh

所以我们因素与sub-coroutines逻辑就像普通子程序。让我们一些有用的sub-coroutines从取物的因素。我们写一个读协同程序接收一个
块:

def read(sock):
    f = Future()

    def on_readable():
        f.set_result(sock.recv(4096))

    selector.register(sock.fileno(), EVENT_READ, on_readable)
    chunk = yield f  # Read one chunk.
    selector.unregister(sock.fileno())
    return chunk

我们的基础上读与一个 read_all 协同程序接收一个整体的信息:

def read_all(sock):
    response = []
    # Read whole response.
    chunk = yield from read(sock)
    while chunk:
        response.append(chunk)
        chunk = yield from read(sock)

    return b''.join(response)

如果你正确地斜视, 产量从语句消失,这些看起来像传统函数阻塞I / O。但事实上, 读和 read_all 协同程序。收益率从读停顿了一下 
read_all 直到等待I / O完成。而 read_all 停顿了一下,asyncio事件循环做其他工作,等待I / O事件; read_all 已恢复的结果吗读在下
一个循环事件蜱虫一旦准备好了。

在堆栈的根, 获取调用 read_all :

class Fetcher:
    def fetch(self):
         # ... connection logic from above, then:
        sock.send(request.encode('ascii'))
        self.response = yield from read_all(sock)

奇迹般地,任务类不需要修改。它使外获取协同程序和以前一样:

Task(fetcher.fetch())
loop()

当读收益率未来,任务接收通过的通道产量从语句,好像未来产生了直接从获取。当循环解决未来,任务发送结果获取 ,收到的价值读完全一
样,如果开车的任务读直接:

Figure 5.3 - Yield From

图5.3 -收益率

完善我们的协同程序实现,我们波兰一个3月:我们的代码使用收益率当它等待一个未来,但是产量从当它代表sub-coroutine。如果我们使用
更精炼产量从每当一个协同程序暂停。然后一个协同程序本身不需要关注什么类型的等待。

我们利用深度之间的通信在Python中发电机和迭代器。给调用者,推动发电机是一样的迭代器。我们使我们的未来类iterable通过实现一个
特殊的方法:

    # Method on Future class.
    def __iter__(self):
        # Tell Task to resume me here.
        yield self
        return self.result

未来的 __iter__ 方法是一个收益率未来的协同程序本身。现在,当我们替换的代码是这样的:

# f is a Future.
yield f

… 用这个:

# f is a Future.
yield from f

… 结果都是一样的! 驾驶任务从其调用接收未来发送 ,当未来解决它发送回协同程序的新结果。

使用的优势是什么产量从到处都是吗? 这是为什么比等待期货收益率 sub-coroutines和授权产量从 ? 这是更好的,因为现在,一个方法可以
自由改变其实现在不影响调用者:这可能是一个正常的方法,该方法返回一个未来解决一个值,或者它可能是一个协同程序包含产量从语句和
返回一个值。在这两种情况下,调用者只需要产量从方法以等待结果。

亲爱的读者,我们已经达到了我们愉快的结束博览会asyncio协同程序。我们凝视着发电机的机械,勾勒出一个实现期货和任务。我们概述了
如何asyncio达到两全其美:并发I / O比线程更高效和更清晰的回调。当然,真正的asyncio是更复杂的比我们的草图。真正的框架地址零拷
贝I / O、公平调度、异常处理以及大量的其他特性。

asyncio用户,编码协同程序比你看到的要简单得多。在上面的代码中我们实现了协同程序从第一原理,所以你看到回调,任务和期货。你甚至
看到了非阻塞套接字和调用选择。但时候与asyncio构建一个应用程序,这些出现在您的代码中。我们承诺,您现在可以光滑地获取URL:

    @asyncio.coroutine
    def fetch(self, url):
        response = yield from self.session.get(url)
        body = yield from response.read()

满意这个博览会,我们回到我们最初的任务:写一个异步web爬虫,使用asyncio。

协调协同程序

我们开始通过描述我们想要爬行器是如何工作的。现在是时候实现它与asyncio协同程序。

我们的爬虫获取第一页,解析其链接,并将它们添加到一个队列。后这粉丝在网站,同时抓取页面。但限制客户机和服务器上的负载,我们想要
一些最大数量的工人,和更多。当一个工人完成抓取页面,应该立即从队列中取出下一个链接。我们将通过时期没有足够的工作,因此一些工
人必须暂停。但是当工人袭击一个页面丰富的新链接,那么队列突然增加,任何停顿了一下工人应该后开裂。最后,我们的程序必须退出一旦
此项工作完成。

想象一下,如果工人们线程。我们如何表达爬虫的算法? 我们可以使用一个同步队列 ^11 从Python标准库。每次一个项目放在队列,队列增
量的计算“任务”。工作线程调用 task_done 在完成一个项目。主线程阻塞 Queue.join 队列中,直到把每一项都对应一个 task_done 电话,
然后退出。

协同程序使用相同的模式与一个asyncio队列! 首先,我们导入它 ^12 :

try:
    from asyncio import JoinableQueue as Queue
except ImportError:
    # In Python 3.5, asyncio.JoinableQueue is
    # merged into Queue.
    from asyncio import Queue

我们收集工人在一个爬虫类共享状态,写的主逻辑爬方法。我们开始爬在协同程序并运行asyncio事件循环,直到爬完成:

loop = asyncio.get_event_loop()

crawler = crawling.Crawler('http://xkcd.com',
                           max_redirect=10)

loop.run_until_complete(crawler.crawl())

爬虫从根URL和开始 max_redirect ,重定向的数量是愿意追随取任何一个URL。它把这两 (max_redirect URL) 在队列中。 (原因,敬请期
待)。

class Crawler:
    def __init__(self, root_url, max_redirect):
        self.max_tasks = 10
        self.max_redirect = max_redirect
        self.q = Queue()
        self.seen_urls = set()

        # aiohttp's ClientSession does connection pooling and
        # HTTP keep-alives for us.
        self.session = aiohttp.ClientSession(loop=loop)

        # Put (URL, max_redirect) in the queue.
        self.q.put((root_url, self.max_redirect))

未完成任务的数量现在在队列中。在我们的主要脚本,我们启动事件循环爬方法:

loop.run_until_complete(crawler.crawl())

的爬协同程序开始工人。它就像一个主线程:块加入直到完成所有的任务,而工人们在后台运行。

    @asyncio.coroutine
    def crawl(self):
        """Run the crawler until all work is done."""
        workers = [asyncio.Task(self.work())
                   for _ in range(self.max_tasks)]

        # When all work is done, exit.
        yield from self.q.join()
        for w in workers:
            w.cancel()

如果工人线程,我们可能不希望启动它们。为了避免创建昂贵的线程,直到它肯定他们是必要的,一个线程池通常生长在需求。但是协同程序
很便宜,所以我们只是开始允许的最大数量。

有趣的是我们如何关闭爬虫。当加入未来的解决,工作任务还活着但暂停:他们等待更多的url但没有来。所以,主要的协同程序在退出前取消
他们。否则,Python解释器的关闭和调用对象的析构函数,生活任务呼喊:

ERROR:asyncio:Task was destroyed but it is pending!

如何取消工作吗? 发电机特性我们尚未见您。可以抛出异常到发电机以外:

>>> gen = gen_fn()
>>> gen.send(None)  # Start the generator as usual.
1
>>> gen.throw(Exception('error'))
Traceback (most recent call last):
  File "<input>", line 3, in <module>
  File "<input>", line 2, in gen_fn
Exception: error

发电机已恢复扔 ,但现在抚养一个例外。如果没有代码生成器的调用堆栈捕获它,除了泡沫顶部。所以取消任务的协同程序:

    # Method of Task class.
    def cancel(self):
        self.coro.throw(CancelledError)

发电机是暂停的地方,在一些产量从声明中,简历,抛出一个异常。我们处理任务的取消一步方法:

    # Method of Task class.
    def step(self, future):
        try:
            next_future = self.coro.send(future.result)
        except CancelledError:
            self.cancelled = True
            return
        except StopIteration:
            return

        next_future.add_done_callback(self.step)

现在知道它的任务是取消了,所以当它被摧毁它不怒斥光的死亡。

一次爬已经取消了工人,它退出。事件循环看到协同程序是完整的(稍后我们将看到),和它也出口:

loop.run_until_complete(crawler.crawl())

的爬方法包括我们的主要协同程序必须做的一切。工人协程,url从队列中,获取它们,并解析新链接。每个工人的工作协同程序独立:

    @asyncio.coroutine
    def work(self):
        while True:
            url, max_redirect = yield from self.q.get()

            # Download page and add new links to self.q.
            yield from self.fetch(url, max_redirect)
            self.q.task_done()

Python看到这段代码包含产量从语句,并将它编译成发生器的功能。因此,在爬 ,当主要协同程序调用 self.work 十倍,它不实际执行这个方
法:它只会造成10生成器对象引用这段代码。它将每个包装在一个任务。任务接收到发电机每个未来收益率,驱动发电机通过调用发送每次当
未来解决未来的结果。因为发电机有自己的堆栈帧,他们独立运行,单独的本地变量和指令指针。

通过队列工人坐标的家伙。等待新网址:

    url, max_redirect = yield from self.q.get()

队列的得到方法本身就是一个协同程序:暂停,直到有人将队列中的一个项目,然后简历并返回项目。

顺便说一下,这就是工人将被暂停的爬行,当主协同程序取消它。从协同程序的角度来看,它的最后一次访问在循环结束时产量从提出了一个 
CancelledError 。

当一个工人获取页面解析链接并将新的队列中,然后调用 task_done 减量计数器。最终,一个工人获取一个页面的url都拿来了,也没有工作
队列中。因此这个工人的调用 task_done 柜台衰减为零。然后爬等待队列加入方法,是停顿和完成。

我们承诺要解释为什么对队列中的物品,如:

# URL to fetch, and the number of redirects left.
('http://xkcd.com/353', 10)

新的url有十重定向。获取这个特定的URL导致使用斜杠重定向到一个新的位置。我们减量重定向剩余的数量,将下一个队列中的位置:

# URL with a trailing slash. Nine redirects left.
('http://xkcd.com/353/', 9)

的 aiohttp 包我们使用默认会重定向和给我们最终的响应。然而,我们告诉它不要和处理重定向爬虫,所以它可以合并重定向路径导致相同
的目的地:如果我们已经看到这个URL,它 self.seen_urls 我们已经开始从一个不同的入口点:这条路

Figure 5.4 - Redirects

图5.4 -重定向

爬虫获取“foo”,看到“巴兹”重定向,所以添加到队列,“记者” seen_urls 。如果下一个页面,获取“酒吧”,也重定向到“记者”,访问者不排队“
记者”。如果响应是一个页面,而不是重定向, 获取解析它的链接并将新的队列。

    @asyncio.coroutine
    def fetch(self, url, max_redirect):
        # Handle redirects ourselves.
        response = yield from self.session.get(
            url, allow_redirects=False)

        try:
            if is_redirect(response):
                if max_redirect > 0:
                    next_url = response.headers['location']
                    if next_url in self.seen_urls:
                        # We have been down this path before.
                        return

                    # Remember we have seen this URL.
                    self.seen_urls.add(next_url)

                    # Follow the redirect. One less redirect remains.
                    self.q.put_nowait((next_url, max_redirect - 1))
             else:
                 links = yield from self.parse_links(response)
                 # Python set-logic:
                 for link in links.difference(self.seen_urls):
                    self.q.put_nowait((link, self.max_redirect))
                self.seen_urls.update(links)
        finally:
            # Return connection to pool.
            yield from response.release()

如果这是多线程代码,它将是糟糕的竞态条件。例如,工人检查链接是否在 seen_urls ,如果没有工人所说的队列,并将其添加到 seen_urls 
。如果两个操作之间的中断,然后另一个工人可能解析相同的链接从一个不同的页面,也观察到它不在 seen_urls ,并将其添加到队列中。现
在同样的链接是在队列中两次,导致(最好的)重复和错误的统计工作。

然而,协同程序只是容易中断产量从语句。这是一个关键的区别,使协同程序代码远比多线程代码不易种族:多线程代码必须输入一个临界段
明确,抓住一个锁,否则它是可中断的。 Python协同程序在默认情况下是不间断的,只有割让当它明确的收益率。

我们不再需要一个访问者类像我们在基于回调程序。该类缺陷的回调是一个变通方法:他们需要一些地方来存储状态在等待I / O,因为他们
的本地变量并不保存在电话。但是, 获取协同程序将其状态存储在本地变量可以像普通的函数,所以没有更多的需要一个类。

当获取处理完服务器响应返回给调用者, 工作。的工作方法调用 task_done 在队列上,然后得到下一个URL从队列中获取。

当获取把新链接队列中的增量计数的未完成的任务,保证主要协同程序,等待 q.join ,停了下来。然而,如果没有看不见的链接,这是在队列
中最后一个URL,然后当工作调用 task_done 未完成的任务数的下降为零。这个事件unpauses 加入和主要协同程序完成。

队列协调工人和主要协同程序的代码是这样的 ^13 :

class Queue:
    def __init__(self):
        self._join_future = Future()
        self._unfinished_tasks = 0
        # ... other initialization ...

    def put_nowait(self, item):
        self._unfinished_tasks += 1
        # ... store the item ...

    def task_done(self):
        self._unfinished_tasks -= 1
        if self._unfinished_tasks == 0:
            self._join_future.set_result(None)

    @asyncio.coroutine
    def join(self):
        if self._unfinished_tasks > 0:
            yield from self._join_future

主要的协同程序爬 ,收益率(殖利率)从加入。所以当最后工人未完成任务的计算衰减为零,它的信号爬简历,并完成。

游戏快结束了。我们的节目开始打电话爬 :

loop.run_until_complete(self.crawler.crawl())

这个程序是怎么结束的? 自爬是一个生成器函数,调用它返回一个发电机。驱动发电机,asyncio封装在一个任务:

class EventLoop:
    def run_until_complete(self, coro):
        """Run until the coroutine is done."""
        task = Task(coro)
        task.add_done_callback(stop_callback)
        try:
            self.run_forever()
        except StopError:
            pass

class StopError(BaseException):
    """Raised to stop the event loop."""

def stop_callback(future):
    raise StopError

当任务完成时,它引发了 StopError ,循环使用的信号到达正常完成。

但这是什么? 任务的方法 add_done_callback 和结果 ? 你可能认为一个任务类似于未来。你的直觉是正确的。我们必须承认一个细节我们
向你隐藏的任务类:一个任务是一个未来。

class Task(Future):
    """A coroutine wrapped in a Future."""

通常一个未来是通过别人打电话来解决 set_result 在上面。但一个任务解析本身当其协同程序停止。还记得我们之前的探索Python发电
机,当一台发电机的回报,又特别抛出StopIteration 例外:

    # Method of class Task.
    def step(self, future):
        try:
            next_future = self.coro.send(future.result)
        except CancelledError:
            self.cancelled = True
            return
        except StopIteration as exc:

            # Task resolves itself with coro's return
            # value.
            self.set_result(exc.value)
            return

        next_future.add_done_callback(self.step)

所以,当事件循环调用 task.add_done_callback (stop_callback) ,它准备停止的任务。这是 run_until_complete 再次:

    # Method of event loop.
    def run_until_complete(self, coro):
        task = Task(coro)
        task.add_done_callback(stop_callback)
        try:
            self.run_forever()
        except StopError:
            pass

当任务了抛出StopIteration 和解决,回调了 StopError 从内部循环。循环停止调用堆栈是解除 run_until_complete 。我们的计划是完成
了。

结论

日益频繁,现代程序是I / o限制而不是中央处理器受限。等项目,Python线程是最糟糕的两个世界:全局解释器锁可以防止它们实际上执行的
并行计算,和先发制人的切换使他们容易的比赛。异步常常是正确的模式。但随着基于回调的异步代码,它往往成为一个衣冠不整的混乱。协
同程序是一个整洁的选择。他们自然因素到子例程,理智的异常处理和堆栈跟踪。

如果我们斜视,这样产量从语句模糊,协同程序看起来像一个线程做传统阻塞I / O。我们甚至可以协调协同程序多线程编程的经典模式。不
需要改造。因此,回调函数相比,协同程序是一个邀请成语与多线程编码经验的。

但是,当我们睁开我们的眼睛和关注产量从语句,我们看到他们标记点时,协同程序割让,并允许其他人来运行。与线程、协同程序显示,我们
的代码可以被打断,它不能。在他的文章“不屈不挠” ^14 线程,字形莱夫科维茨写道,“让当地推理困难,和当地的推理可能是软件开发中最重
要的事情。” 明确收益,然而,可以“理解的行为(因此,正确性)常规通过检查例程本身而不是整个系统检查。”

本章是在文艺复兴时期的Python和异步的历史。刚学发生器协同程序的设计,被释放的“asyncio”模块与Python 3.4 2014年3月。 2015年9
月,Python 3.5发布与协同程序语言本身造成的。这些本地coroutinesare宣布新语法“异步def”,而不是“屈服”,他们使用新的“等待”字代表
协同程序或等待一个未来。

尽管取得了这些进步,核心思想仍然存在。 Python的新的本地协同程序将语法不同于发电机,但工作非常相似; 事实上,他们将分享在Python
解释器的实现。任务,未来,事件循环将继续在asyncio扮演他们的角色。

现在你知道asyncio协同程序是如何工作的,你可以在很大程度上忘记细节。机器后面是一个整洁的界面。但你掌握基本面赋予你代码的正确
和有效地在现代异步环境。

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 1. 圭多介绍了标准asyncio库,叫做“郁金香”然后, PyCon 2013 。一个 ©

 2. 甚至要求发送可以阻止,如果收件人是缓慢承认优秀信息和系统的输出数据缓冲区满了。一个 ©

 3. http://www.kegel.com/c10k.html 一个 ©

 4. Python的全局解释器锁禁止并行运行Python代码在一个过程。算法并行cpu在Python中需要多个进程,或编写并行的部分代码c,但那是另
    一个话题了。一个 ©

 5. 杰西列使用异步的适应症和禁忌症 “异步是什么,它是如何工作的,当我应该使用它?”: 。迈克拜耳asyncio和多线程的吞吐量相比不同
    的工作负载 “异步Python和数据库”: 一个 ©

 6. 一个复杂的解决这个问题,请参阅 http://www.tornadoweb.org/en/stable/stack_context.html 一个 ©

 7. 的 @asyncio.coroutine 装饰不是魔法。事实上,如果它装饰发生器和函数 PYTHONASYNCIODEBUG 环境变量没有设置,装饰也几乎没有。
    它只是设置一个属性, _is_coroutine 为方便其他部分的框架。可以使用asyncio光秃秃的发电机不装饰着 @asyncio.coroutine 在所
    有。一个 ©

 8. 介绍了Python 3.5的内置协同程序 PEP 492 与异步协同程序并等待语法。” 一个 ©

 9. 未来有许多缺陷。例如,一旦解决,未来收益率反而应该立即恢复的协同程序暂停,但它并不与我们的代码。看到asyncio未来的类为一个
    完整的实现。一个 ©

10. 事实上,这就是“收益率从“在CPython的工作。一个函数增量指令指针在执行每个语句之前。但在外部发电机执行“屈服”,它从指令指针
    减去1保持本身固定收益率从“声明。然后它收益率它的调用者。在这样的循环直到内发电机抛出抛出StopIteration ,此时外部发电机
    终于允许本身推进到下一个指令。一个 ©

11. https://docs.python.org/3/library/queue.html 一个 ©

12. https://docs.python.org/3/library/asyncio-sync.html 一个 ©

13. 实际的 asyncio.Queue 实现使用一个 asyncio.Event 在未来的地方。不同之处在于一个事件可以重置,而不能从解决过渡回到等待的
    未来。一个 ©
