<!-- vim-markdown-toc GFM -->

* [python 异步和事件驱动模型](#python-异步和事件驱动模型)
	* [1、协程](#1协程)
		* [使用方法如下](#使用方法如下)
	* [2、yield from](#2yield-from)
	* [3. yield from 和迭代器](#3-yield-from-和迭代器)
	* [4、事件循环：](#4事件循环)

<!-- vim-markdown-toc -->
# python 异步和事件驱动模型

## 1、协程
>协程 是为非抢占式多任务产生子程序的计算机程序组件，协程允许不同入口点在不同位置暂停或开始执行程序

1. 协程就是你可以暂停执行的函数，可以理解成就像生成器一样。
2. 原来生成器完全就是关于迭代器的，可以比迭代对象节省内存空间，但是当利用生成器“暂停”的部分，
	添加“将东西发送会生成器内”的功能，那么Python突然就有了协程的概念，PEP 342为生成器引入了send()方法，
	使得我们不仅仅可以暂停生成器，还能够传递值到生成器暂停的地方。

	```
	jump = yield index

	相当于

	yield index
	jump = () send传进来的值，注意程序在yield那里中断，也就是1的位置。如果yield后没有变量，则每次返回None
	
	```
		
* 协程的四种状态
  
　协程有四个状态，可以使用inspect.getgeneratorstate(...)函数确定：

　　1、GEN_CREATED # 等待开始执行，生成器初始化后的状态，生成器还未激活

　　2、GEN_RUNNING # 解释器正在执行（只有在多线程应用中才能看到这个状态）

　　3、GEN_SUSPENDED # 在yield表达式处暂停。只用处于这个状态的生成器才可以调用send发送None以外的值。生成器初始化后调用next预激后会处于这个状态

　　4、GEN_CLOSED # 执行结束，抛出异常或者关闭生成器后处于这种状态。

* 用装饰器实现生成器的预激
	
		from functools import wraps

		def coroutinue(func):
		    @wraps(func)
		    def primer(*args, **kwargs):
		        # 把装饰器生成器函数替换成这里的primer函数；调用primer函数时，返回预激后的生成器。
		        gen = func(*args, **kwargs)        # 调用被被装饰函数，获取生成器对象
		        next(gen)  # 预激生成器
		        return gen  # 返回生成器
		    return primer
		
		@coroutinue
		def simple_coro(a):
    		a = yield

		simple_coro(12)  # 已经预激

### 使用方法如下

	@coroutinue
	def simple_coro(a):
	    a = yield

simple_coro(12)  # 已经预激



## 2、yield from
>yield from 是 Python3.3 后新加的语言结构。和其他语言的await关键字类似，它表示：*在生成器 gen 中使用 yield from subgen()时，subgen 会获得控制权，把产出的值传个gen的调用方，即调用方可以直接控制subgen。于此同时，gen会阻塞，等待subgen终止。

* Python3.5中的async/await的原理是由Python 3.3中的yield from 和Python3.4中的asyncio 组合得来。

* yield from iterator 本质上相当于：

	**yield from 相当于下面表达式，所有yield 表达式必须在函数内出现**

		for x in iterator： #注意这里是可迭代对象，包括生成器和和迭代对象
			yield x

* 在for循环中，yield from 会首先调用生成器的\_\_iter\_\_方法，然后会调用返回对象的\_\_next\_\_方法，``__iter__``只调用一次，next每次循环都要调用。

		class B(object):
	
		    def __init__(self):
		        self.i = 0
		
		    def __iter__(self):
		        print("iter")
		        return self
		
		    def __next__(self):
		        print("next")
		        if self.i < 10:
		            self.i += 1
		            return self.i
		        else:
		            raise StopIteration
	
			def gen(a):
	    		yield from a


		iter
		next
		1
		next
		2
		next
		3

* yeild from 可以将生成器串联起来，使返回值可以在调用栈中上下浮动，而不需要对编码进行过多改动。

* yield from 结果会在内部自动捕获StopIteration 异常。这种处理方式与 for 循环处理StopIteration异常的方式一样。 对于yield from 结构来说，解释器不仅会捕获StopIteration异常，还会把value属性的值变成yield from 表达式的值。

* yield from 可用于简化for循环中的yield表达式。
 
		def gen():
		    for c in 'AB':
		        yield c
		    for i in range(1, 3):
		        yield i
		
		list(gen())
		['A', 'B', '1', '2']
可以改写成

		def gen():
		    yield from 'AB'
		    yield from range(1, 3)
		    
		
		list(gen())
		['A', 'B', '1', '2']

* <font color=green>yield from x 表达式对x对象做的第一件事是，调用 iter(x)，获取迭代器。所以要求x是可迭代对象。如果x有\_\_iter\_\_方法会调用这个方法</font>

　　PEP380 的标题是 ”syntax for delegating to subgenerator“(把指责委托给子生成器的句法)。由此我们可以知道，yield from是可以实现嵌套生成器的使用。

　　yield from 的主要功能是打开双向通道，把最外层的调用方与最内层的子生成器连接起来，使两者可以直接发送和产出值，还可以直接传入异常，而不用在中间的协程添加异常处理的代码。


* <font color=red>最内层的生成器的return的返回值，是外层的yield from的返回值</font>

		rv = yield from gen
		gen return的值是rv的值	

**混用yield 和return时，for循环和next都不能获得return的值，return位置是yield循环完之后抛出StopIteratorError的，所以如果renturn的不是这个错误，那么return的值也在异常捕获哪里获取**
	

* yield 详解

: https://segmentfault.com/a/1190000009781688

　　**作者说这是流畅的python的读书笔记**


## 3. yield from 和迭代器
* <font color=green>yield from x 表达式对x对象做的第一件事是，调用 iter(x)，获取迭代器。所以要求x是可迭代对象。如果x有\_\_iter\_\_方法会调用这个方法</font>

* 如果yield from 后面跟的对象是生成器对象，iter返回对象本身，对象的\_\_next\_\_方法执行返回yield的值。如果是可迭代对象，则会先调用iter获得迭代器，然后执行next方法，next方法里面不要再用yield，因为yield from就是直接调用next方法，如果返回值继续用yield，则yield from返回的还是一个生成器对象。

* <font color=green>如果yield from后的对象调用iter返回的对象是一个普通迭代对象，则yield from会调用迭代对象的next方法。如果iter返回的是一个生成器，则yield from会打通到这个生成器的通道，send、next都会传递到这个对象，不会继续调用next方法</font>

		class A(object):
	    def __init__(self):
	        self.index = 0
	
	    def __iter__(self):
	        print('!!!!!')
	        yield self
	        print("?????????????")
	        return self
	
	    def __next__(self):
	        if self.index < 10:
	            self.index += 1
	            return self.index
	        else:
	            raise StopIteration
	
		def gen(a):
		    yield from a
		
		# gentor = gen(A())
		
		for i in gen(A()):
		    print(i)

		!!!!!
		1
		?????????????

	如果把\_\_iter\_\_的前三行注释掉，

		1
		2
		3
		4
		5
		6
		7
		8
		9
		10


## 4、事件循环：
>事件循环是一种等待程序分配事件或消息的编程架构。基本上来说事件循环就是。"当A发生时，就执行B".


　**asyncio是事件循环框架可以进行异步编程**

1. 　asyncio重点解决网络服务中的问题，事件循环在这里将来自套接字socket的I/O已经准备好的读和写作为"当A发生时"（通过selectors模块).除了GUI和I/O,事件循环也经常用于在别的线程或子进程中执行的代码，并将事件循环作为调节机制（例如，合作式多任务）。事件循环对于需要释放GIL的地方很有用



参考文章：

1. https://mp.weixin.qq.com/s?__biz=MzAwNjI5MjAzNw==&mid=2655751983&idx=1&sn=e4c093c6e5d6e4e8281d76db7c67eb23
2. https://juejin.im/entry/56ea295ed342d300546e1e22“
