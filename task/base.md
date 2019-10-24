## 类功能列表
### base
####  _AcquireFutures
1. description: A context manager that does an ordered acquire of Future conditions.

2. 成员函数
	- def __init__ (self, futures)
	- def __enter__ (self)
	- def __exit__ (self, args)

3. 属性
	- future

4. 代码：
class _AcquireFutures(object):
    """A context manager that does an ordered acquire of Future conditions."""

    def __init__(self, futures):
        self.futures = sorted(futures, key=id)

    def __enter__(self):
        for future in self.futures:
            future._condition.acquire()

    def __exit__(self, *args):
        for future in self.futures:
            future._condition.release()
####  _Waiter:
1. description: Provides the event that wait() and as_completed() block on.

2. 代码

		class _Waiter(object):
			"""Provides the event that wait() and as_completed() block on."""
			def __init__(self):
				self.event = threading.Event()
				self.finished_futures = []

			def add_result(self, future):
				self.finished_futures.append(future)

			def add_exception(self, future):
				self.finished_futures.append(future)

			def add_cancelled(self, future):
				self.finished_futures.append(future)
