### 1. 事件驱动的构成

1. 事件管理类：
	1. 属性：
		1. 事件的的队列：循环监听线程会不停的消费此队列的事件
			
			注意：这个地方使用的是线程安全的queue.Queue。<font color=red>标准库的queue.Queue是线程安全，进程不安全的。想要使用进程安全的Queue，使用multiprocssing的Queue</font>

	2. 循环的监听事件信号的线程。

		这个地方不停的从消息队列中取事件，如果没有事件，则阻塞在哪里就好了。
		<font color=red>这个线程如果需要可以控制开始结束的话就需要一个标识，不要while True</font>

	3. 监听线程开始、停止、添加事件、添加事件监听函数、移除事件监听事件

2. 事件： 
	1. 事件，event本身只需要一个区分自己的标识，再加上一些需要的信息就可以，也是一个类。

3. 事件发布者
	1. 实例化一个事件，添加事件标识、信息
	2. 将事件处理函数添加到事件管理类的Queue里面，生产一个事件

4. 监听者
	1. 有自己的事件处理函数，将handler函数添加到事件管理类的event_handlers字典中，消费事件。
 

5. event_loop.py

		from queue import Queue, Empty
		from threading import *
		
		class EventManager:
	    
		    def __init__(self):
		        self._eventQueue = Queue()
		        self._active = False
		        self._thread = Thread(target=self._Run)
		        self._handlers = {}
		
		    def _Run(self):
		        while self._active == True:
		            try:
		                event = self._eventQueue.get(block=True, timeout=1)
		                self._EventProcess(event)
		            except Empty:
		                pass
		
		    def _EventProcess(self, event):
		        if event.type_ in self._handlers:
		            for handler in self._handlers[event.type_]:
		                handler(event)
		
		    def Start(self):
		        self._active = True
		        self._thread.start()
		
		    def Stop(self):
		        self._active = False
		        self._thread.join()
		
		    def AddEventListener(self, type_, handler):
		        handlerList = self._handlers.setdefault(type_,[])
		        if handler not in handlerList:
		            handlerList.append(handler)
		
		    def RemoveEventListener(self, type_, handler):
		        pass
		
		    def SendEvent(self, event):
		        self._eventQueue.put(event)
	
		class NewEvent:
		    def __init__(self, type_=None):
		        self.type_ = type_
		        self.dict = {}


6. test.py

		# coding : utf-8

		import sys
		from datetime import datetime
		from threading import Thread, Timer
		from event_loop import EventManager, NewEvent
		
		EVENT_ARTICAL = "Event_Article"
		
		class PublicAccout:
		    def __init__(self, eventManager):
		        self._eventManager = eventManager
		
		    def WriteNewAritcal(self):
		        event = NewEvent(type_=EVENT_ARTICAL)
		        event.dict["artical"] = "how to write more pythonic code"
		        self._eventManager.SendEvent(event)
		        print("!!! New papers")
		
		class Listener:
		    def __init__(self, username):
		        self._username = username
		
		    def ReadArtical(self, event):
		        print("%s recive new artical" % self._username)
		        print("now reading the new artical: %s" % event.dict["artical"])
		
		def test():
		    listener1 = Listener("wang")
		    listener2 = Listener("yan")
		    eventManager = EventManager()
		
		    eventManager.AddEventListener(EVENT_ARTICAL, listener1.ReadArtical)
		    eventManager.AddEventListener(EVENT_ARTICAL, listener2.ReadArtical)
		    eventManager.Start()
		
		    putlicAcc = PublicAccout(eventManager)
		    timer = Timer(2, putlicAcc.WriteNewAritcal)
		    timer.start()
		if __name__ == "__main__":
		    test()


7. tornado的ioloop也是一样的：
	
	都有一个循环监听事件的线程，只不过ioloop的事件都是epoll阻塞方法返回的，需要添加到循环监听的事件队列里，并且添加了异步的future，在future的回调函数又继续在循环里生产了一个事件，需要继续调用事件处理函数。
