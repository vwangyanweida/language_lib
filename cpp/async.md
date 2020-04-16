
<!-- vim-markdown-toc GFM -->

* [并发](#并发)
	* [高级接口：async 和future](#高级接口async-和future)
		* [async](#async)
		* [future](#future)
		* [Launch(发射)策略](#launch发射策略)
		* [异常处理](#异常处理)
		* [等待和轮询](#等待和轮询)
		* [传递实参](#传递实参)
		* [Shared Future](#shared-future)
	* [低级接口](#低级接口)
		* [thread](#thread)
			* [Detached Thread](#detached-thread)
			* [ID](#id)
		* [Promise](#promise)
		* [packaged task](#packaged-task)
	* [启动线程](#启动线程)
		* [Namespace `this_thread`](#namespace-this_thread)
	* [线程同步](#线程同步)
		* [并发出现的问题：](#并发出现的问题)
	* [Mutex 和Lock](#mutex-和lock)
		* [递归锁(Recursive) Lock](#递归锁recursive-lock)
		* [尝试性的Lock及带时间性的Lock](#尝试性的lock及带时间性的lock)
	* [lock 总结](#lock-总结)
		* [mutex](#mutex)
		* [Lock](#lock)
		* [互斥对象管理类模板的加锁策略](#互斥对象管理类模板的加锁策略)
		* [底层加锁函数](#底层加锁函数)
		* [对多个互斥对象加锁](#对多个互斥对象加锁)
		* [只调用一次的锁](#只调用一次的锁)
	* [Condition Variable](#condition-variable)
		* [意图](#意图)
	* [Atomic](#atomic)
		* [Atomic 高层接口](#atomic-高层接口)
		* [Atomic底层接口](#atomic底层接口)

<!-- vim-markdown-toc -->
## 并发
1. 高级接口: 允许你启动线程，包括传递实参、处理结果和异常
2. 低级接口：像mutex或atomic，用来对付放宽的内存次序（relaxed memory order，RMO）
3. 并发书籍：C++ Concurrency in Action

### 高级接口：async 和future
1. async()提供一个接口，让一个可调用对象，<font color=red>若是可能的话在后台运行，成为一个独立线程。</font>
2. class future<> 允许你等待线程结束并获取其结果(一个返回值，或者也许是一个异常)

#### async
1. async <font color=red>尝试将其所获得的函数立刻异步启动于一个分离的线程内</font>

#### future
1. future 允许你取得"传给async()的那个函数"的未来结果--也许是个返回值，也许是个异常。
2. 这个future object已受到"被启动函数"返回类型的特化，如果被启动函数发挥空，则future类型是future<void>.
	<font color=red>future是一个模板，实例化为异步函数返回类型</font>
3. <font color=red>future必须存在，确保"目标函数"或快或慢最终会被调用</font>
	- async()尝试启动目标函数，但如果没启动，稍后需要这个future object 才能强制启动目标函数
	- 当我们需要函数的运行结果或当我们想要确保该函数执行时，需要future对象。
	- 因此，即使对启动与后台的那个函数的结果不感兴趣，还是需要握有这个future object

4. <font color=green>为了能够在"启动及控制函数"处与"返回之future object"之间交换数据，二者都指向同意个所谓的shared state</font>。
	- 这个future应该是一个指针或者引用。使得调度函数可以想这个future里写目标函数运行完成后的结果，其他函数也可以访问这个future. 
	- asyncio和tornado里的future就是返回的一个类型，需要IOLOOP事件循环函数可以访问到这个future，
		往里面添加结果，触发条件变量，通知阻塞在future的result处的函数继续运行。

5. 调用future的get函数，以下三件事之一会发生：
	1. 如果func()被async()启动于一个分离线程中并且已结束，你会立刻获得其结果
	2. 如果func()被启动尚未结束，get()会阻塞在这个调用(block)等待func()结束后获得结果。
	3. 如果func()尚未启动，会强迫启动如同一个同步调用：get()会引发停滞直至产生结果

	4. 总结：
		- get和tornado的future的get_result一样，会阻塞直到异步函数完成然后返回结果
		- c++的future的get和python不同在于：
			- async是默认启动一个线程，而python默认是将函数添加到事件循环，单线程执行
			- future的get可以将目标函数同步启动，如果async没有启动一个新的线程的话。

6. <font color=red>调用async()并不保证传入函数一定会被启动</font>
	- 如果async没有启动新的线程运行函数，那么函数调用会被推迟至你明确说你需要其结果(也就是调用get())
	- 或只是希望目标函数完成其任务(也就是调用wait())

7. 因为get是阻塞方法，所以为了获得最佳效果，一般而言应该将调用async()和调用get()之间的距离最大化，早调用而晚返回

#### Launch(发射)策略
> 只要明确的传递给async launch策略，就可以指示async以何种方式启动并发函数

1. std::launch::async : 告诉async明确的以异步方式启动目标数，而绝不推延目标函数的执行
	1. 如果异步调用在这里无法实现，会抛出一个std::system_error异常，差错码：`resource_unavailable_try_again`,相当于POSIX的errno EAGAIN
	2. 有了这个async发射策略，就不必非得调用get()
		- 如果返回的future生命即将结束，这个程序会等待func()结束，即主线程创建了一个非daemon的线程，主线程会等待子线程完成。
		- 如果<font color=red>不将std::async的结果赋值出去，即没有接受future 对象，调用者会阻塞在这里直到目标函数结束，相当于一个完完全全的同步调用</font>

2. std::launch::deferred: 强制延缓执行，绝不会在没有get()或wait()的情况下启动。
	1. 允许你写lazy evaluation 缓式求值。
	2. eg
	```
	auto f1 = std::async(std::launch::deferred, task1);
	auto f2 = std::async(std::launch::deferred, task2);
	...
	auto va1 = thisOrThatIsTheCase() ? f1.get():f2.get();
	```
	3. 有助于单线程模拟async，除非需要考虑到race condition

#### 异常处理
1. 调用get()时，当async启动的线程出现异常时，该异常不会在新启动的线程内被处理，而是会被传播出去。
2. 因此想要处理后台操作的异常，只需要协同get()做出"已同步方式调用该操作"所做的相同动作即可。

#### 等待和轮询
1. 一个future<>只能调用一次get(),之后，future就处于无效状态。
	- future的无效状态可以通过valid()来检测
	- 无效状态下除了析构函数的任何调用都不可预期

2. wait等待后台操作完成而不需要处理其结果，可以多次调用：
	1. wait()可以<font color=red>强制启动该future象征的线程并等待这一后台操作的终止</font>

3. 如果线程尚未启动，不强制启动线程的函数：
	1. `wait_for`():等待某个时间段
		``` 
		std::future<...> f(std::async(func));
		f.wait_for(std::chrono::seconds(10));
		```

	2. `wait_until()`:等待到达某个时间点
		```
		std::future<...> f(std::async(func));
		f.wait_until(std::system_clock::now() + std::chrono::minutes(1));
		
		```

	3. 这两个函数返回一下三种东西之一：
		- std::future_status::deferred：操作未启动(没有调用get和wait函数),立刻返回。   
		- std::future_status::timeout： 操作异步启动但尚未结束，waiting 又已过期
		- std::future_status::ready:    操作已完成

	4. 投机性运行：
		1. 如果wait_for了一定时间，如果后台程序完成，返回后台程序的结果，否则，返回另外的前台程序的结果。

	5. wiat_for 循环时，如果没有指定launch策略为async，则后台程序可能没有启动，条件中一定要包含deferred，
		不能仅仅检查返回的是否是ready，因为如果是deferred，可能陷入死循环。

	6. 放弃执行权：
		- yield： std::this_thred::yield();
		- 睡眠一小段时间

#### 传递实参
1. 使用一个lambda，并让它调用后台函数，在lambda中使用了要传递的对象。
```
auto f1 = std::async([]{doSomething('.');});
```

2. by value 传递
```
char c = '@';
auto f = std::async([=]{ doSomething(c); });
```

3. async提供了callable object的惯常接口，第一个参数是可调用对象，后面可以加上不定数目的参数。
```
char c = '@';
auto f = std::async(doSomething, c);
```

4. by reference传递，但这样会有风险，被传递的值可能在后台任务启动前变得无效，这对于lambda和直接被调用的函数都适用：
```
char c = '@';
auto f = std::async([&]{ doSomething(c); });

auto f = std::async(doSomething, std::ref(c));
```

5. 可以传给async()一个指向成员函数的指针，这是后面的第一个实参必须是一个reference或pointer

6. 结论：
	如果你使用async()，就因该以by value的方式传递所有“用来处理目标函数”的必要object，使async()之需使用局部拷贝，
	如果拷贝成本太高，让那些object以const reference形式传递，且不使用mutable。

#### Shared Future
1. future的get方法只能使用一次，再次使用会报错

2. shared_future可以多次调用get(),导致相同的结果，或者跑出相同的异常
```
shared_future<int> f = async(doSomething)
```
	- 注意：async返回的是一个future，这是默认初始化将future转化成为了一个shared_future.
	- 以寻常的future为初值，于是future的状态(state)会被搬移到shared future身上k

3. <font color=red>future中的state是保存的可以共享的状态，future调用share后，future本身没有关联的state了，
		所以future不是valid的，所以future也只能赋值一次，以后future就是无效的状态了。</font>

4. shared_future是右值引用，不可以以future初始化shared future。future不是右值，不能绑定到shared future。

5. future的成员数share()返回一个shared_future
```
auto f = async(queryNumber).share();
```
6. future和shared future的声明式有些不同
	1. class future<>:
		- T future<T>::get()
		- T& future<T&>::get()
		- void future<void>::get()

	2. class shared_future<>
		- const T& shared_future<T>::get();
		- T& shared_future<T&>::get();
		- void shared_future<void>::get()

	3. 两者的第一个声明不同：
		- future 返回的是一个“搬移后的执行结果”(move)或“该结果的一份拷贝”。
		- shared_future返回的是一个reference，指向存放于“被共享之shared state”的结果

7. 可以将shared future 传递到多个async执行的后台线程中，也可以将同一个shared future 的引用传递到多个后台线程中，
	- 这样就不再是“使用多个shared future object 而由它们共享同一个shared future”，
	- 而是“使用shared future object执行多次get()”
	- 这中风险较高，应该使用值传递，传递给每个后台线程shared future的值拷贝，来共享同一个shared state
	- 风险在于确保f的生存周期大于启动的线程，而shared future和成员函数不是同步的，但是shared state是同步的
	- 如果要修改future内容，需要外部同步。

8. `shared_state`
	- future 用来表示一个操作的结果：可能是要给返回值或者是一个异常，但不会两者都是，它只能被设置一次。
	- 成果被管理在一个shared state内，后者可以被`std::async()`或一个`std::packaged_task`或一个`promise` 创建出来
	- 结果可能尚未存在
	- 结果只能被取出来一次，因此future可能处于有效(valid)或无效(invalid)状态：
		- 有效意味着"某已操作的成果或爆发的异常尚未被取出"
	- <font color=red>如果future的template参数是reference类型的，get()便返回一个reference只想返回值。</font>
	- 否则get返回返回值的一份copy，或是对返回值进行move assign操作-取决于返回类型是否支持move assignment语义
	- get只可调用一次，因为get会使future处于无效状态
	- <font color=green>future既不提供copy构造函数也不提供copy assignment操作符，确保不会两个object共享某一后台操作之状态(state)</font>
	- 将某个future object 状态搬移至另一个的唯一办法是，调用move构造函数或move assignment操作符。
	-<font color=red>如果调用析构函数的那个future是某一个shared state的最后拥有者，而相关的task已启动但尚未结束，析构函数会阻塞，直到任务结束</font>

9. `shared_future`
	- 允许多次get，get 不会令其失效
	- 支持copy 语义
	- get()是一个const 成员函数，返回一个const reference指向"存储与shared state"的值(这意味着必须确定"被返回的reference"的寿命短于shared state)
	- 但是future的get()却是一个non-const 成员函数，返回一个move assignment拷贝，除非这个class被一个reference类型实现特化
	- 不提供share()
	- 因为是一个reference，所以多线程同时访问会出现data race，一定要注意需不需要同步化

###  低级接口
#### thread
> 启动某个线程，只需要先声明一个std::thread对象，并将目标任务当作初始参数，然后要么等他结束，要么将他卸离(detach)

1. Thread的所有参数对象最好都是by value
2. 和async的不同: 
	- Class thread 没有发射策略：如果无法启动一个县县城，会抛出：std::system_error
	- 没有接口可以处理线程结果，唯一可获得是一个线程ID
	- 如果发生异常，如果线程没有捕获异常，程序会立刻终止，如果要传播异常到外面，需要使用exception_ptr
	- 必须声明是否等待线程结束(join)，或打算“将它自母体卸离(detach)使它运行于后台而不受控制”
		如果在thread object 寿命结束前不这么做，或发生move assignment，程序会终止
	- 如果线程运行于后台而main()结束了，<font color=red>所有线程都会被鲁莽而硬性的终止</font>

##### Detached Thread
1. 线程detached后，主线程丧失了对它的控制，没有轻松的办法可以得知它是否运行，以及运行多久
	- 如果detached 线程方你问寿命结束的object会出现异常
	- 不要让detached访问nonlocal资源
	- 最好让detached 线程以by value方式传递

2. 如果程序退出时，可能detached程序还在运行，这意味着它仍有可能访问“已被销毁”或“正在析构”的global或static，
	这将导致不可预期的行为。

3. detached thread的一般性规则：
	- Detached thread 应该宁可只访问local copy
	- 如果detached thread用了一个global or static object，应该做一下事情之一：
		1. 确保这些global/static object 在“对它们进行访问”之所有detached thread都结束(或都不在访问它们)之前不被销毁。
			一种做法就是condition variable，它让detached thread用来发信号说他们已结束，离开main()或调用exit()之前,
			你必须先设置妥这些condition variable，然后发送信号(to signal)说可进行析构了。

		2. 以调用quick_exit()的方式结束程序，这个函数之所以存在完全是为了
			“不调用global和static object析构函数”的方式结束程序。

4. 终止detached thread唯一安全方法就是搭配`...at_thread_exit()`函数群中的某一个，这会"强制main thread 等待detached thread真正结束"

##### ID
1. `this_thread.get_id()`
2. `threadObject.get_id()`
3. 识别线程的唯一办法就是保存下来ID比较

#### Promise
1. 在线程间传递参数和处理异常，可以通过实参传递数值给线程，如果需要线程运行结果，可以传递引用或指针。
2. 另一个方法是promise，future是通过get获得线程结果，promise是通过set...()提供数据
3. promise和future都能暂时持有一个shared state
4. Promise 内部会建立一个shared state，在这里被用来存放一个响应的类型的值或一个异常，
	并可能被future object 取其数据当作线程结果。

5. 使用步骤：
	1. promise传递到线程中时需要by reference传递，使其状体的以改变(copying不适用于promise)
	2. 在线程中调用`set_value()`或`set_exception()`，便得以在promise中存放一个值或一个异常。
	3. 注意，promise只能设置一次，不管是`set_value`还是`set_exception`只能设置一个，否则报错future 已经设置过了。
	5. promise将值保存到shared state里面，一旦这个shared state存有某个值或异常，
		其状态就变为ready，于是可以从其他地方取出。
	6. 取出操作要借助一个“共享相同shared state”的futureobject，因此需要调用`get_future`
	7. get会阻塞直到promise设置了值，但此时线程可能并没有退出。
	8. 如果想令shared state在线程却是结束时变成ready，需要调用
		`set_value_at_thread_exit()`和 `set_exception_at_thread_exit()`
	9. Promise和future并不仅仅用于多线程，单线程也可以。

6. `current_exception()`: 它会将当前异常以类型std::exception_ptr生成出来，
	如果当前并无异常就生成nullptr，这个异常会存放在promise object 内部。

7. 总结：
	- promise 传入线程中，可以通过`set_value()`在线程中为promise设置一个值，
		其他线程可以通过promise的`get_future`获取一个future，
	- promise 用你来临时持有一个值或一个异常
	- 一般而言，promise可持有一个shared state
	- 如果shared state持有一个值或一个异常，我们就说它是ready
	- 一个promise只能调用一次get_future(),第二次调用会抛出`std::future_error`
	- 所有用来设定数值或异常的成员函数是<font color=red>线程安全的</font>，犹如有一个mutex确保每次只有某一个成员函数可以修改shared state

#### packaged task
1. `packaged_task`是将一个函数包装成一个任务，就像python中的task包装一样，
	设置future，设置回调，包装成为一个可以通过事件循环调度的task。

2. 包装成为任务后，可以随时调用，而不像async一样，立刻尝试后台启动。

3. `packaged_task`模板的参数是函数的类型，future才是结果的类型。

4. `packaged_task`定义与<future>内，持有目标函数及其可能的结果(也就是该函数的shared state，就相当于python中的future)

5. `packaged_task`如果在单线程中执行时,代码汇报核心转储,但是如果源文件定义有别的线程,即使没有执行,程序也会正常,不知道怎么回事?				
	这个东西还是用到异步的多线程中去吧.

### 启动线程
#### Namespace `this_thread`
1. 针对任何线程(包括main thread)<thread>声明一个命名空间std::this_thread用以提供线程专属的global函数
	- `this_thread::get_id()`:
	- `this_thread::sleep_for(dur)`:
	- `this_thread::sleep_until(tp)`:
	- `this_thread::yield()`: 建议释放控制以便重新调度，让下一个线程调度

### 线程同步
#### 并发出现的问题：
1. Unsynchronized data access(未同步化的数据访问)：并发运行的线程读和写同一笔数据，不知道哪一个语句先来
2. Half-wiritten data(写至半途的数据): 某个县城投正在读数据，另一个线程改动它，于是读取线程读取一个半新半旧的值
3. Recordered statement(重新排序的语句)：语句和操作有可能被重新安排次序，也许对单线程是正确的，但多线程却破坏了预期行为

4. 解决问题的概念：
	- Atomicity(不可切割性)
	- Order(次序)

5. volatitle：用来阻止"过度优化"
	- java中，volatile对于automicity和order提供了某些保证
	- C++中，volatile<font color=red>只是具体表示对外部资源的访问不应该被优化掉，既不提供atomicity也不提供order</font>

### Mutex 和Lock
1. Mutex：互斥提，是用来协助采取独占排他方式控制"对资源的并发访问"
2. 为了获取独占式的资源访问能力，相应的线程必须锁定(lock) mutex,这样可以防止其他线程也锁定mutex，知道第一个线程解锁(unlock) mutex;
3. `lock_guard`: 为了实现构造函数获得资源，析构函数--甚至当"异常造成生命结束"它也总是会被调用--负责释放资源 的目的。
4. lock应该限制在可能最短周期内，由于析构函数会释放这个lock，明确使用大括号，令lock在更进一步语句被处理之前先释放。

#### 递归锁(Recursive) Lock
1. 递归所的典型例子是active object 或monitor，他们在每个public函数内放一个mutex并取得其lock，用以防止data race 腐蚀对象内部状态
2. `recursive_mutesx` 允许循环递归多次锁定，并在最近一次相应的unlock()时释放lock。

#### 尝试性的Lock及带时间性的Lock
1. `try_lock`: 试图获取一个lock，成功返回true，失败返回false
	- 为了仍能够使用`lock_guard`(<font color=red>使用当下作用域的任何出口都会自动unlock mutex</font>)，可以传一个额外实参`adopt_lock`给其构造函数
		
	```
	while (m.try_lock() == false) {
		doSomthing();
	}
	std::lock_gurad<std::mutex> lg(m, std::adopt_lock);
	```

	- `try_lock`可能假性失败，也就是说即使lock并未被他人拿走它也有可能失败


### lock 总结
#### mutex
1. mutex: 最简单的互斥对象
2. `timed_mutx`: 带有超时机制的互斥对象，允许等待一段时间或直到某个时间点仍未能获得互斥对象的所有权时放弃等待。
3. `recursive_mutex`: 允许被同一个线程递归的Lock和Unlock
4. `recursive_timed_mutex`: 2,3
4. `shared_timed_mutex(c++14)`: 允许多个线程共享所有权的互斥对象，如读写锁。

#### Lock
1. 最简单的使用：加锁、解锁。加锁时如果锁被占用，阻塞
2. 为了防止异常退出导致的死锁和退出分支时忘记解锁，c#提供了lock关键字，java提供了synchronized关键字，他们都通过finally关键字来实现，
	然而C++并没有try-finally，事实上C++并不需要finally。C++通常使用RAII(Resource Acquisition Is Initialization)来自动管理资源

3. RAII(资源获取就是初始化) 管理对象： 
	- std::`lock_guard`: 严格基于作用域(scope-based)的所管理类模板:
		1. 构造时是否加锁是可选的(不加锁时假定当前线程已经获得锁的所有权)，
		2. <font color=red>析构时自动释放锁(不加锁也使用这个对象就是为了析构时释放锁的，所以即使已经获得锁，也还是可以使用`lock_guard`)</font>
		3. 所有权不可以转移，对象生存期内<font color=red>不允许手动加锁和释放锁</font>

	- std::`unique_lock`: 更加灵活的锁管理类模板: 就像unique pointer一样,你可以把它们在作用域之间搬移,但保证一次只有一个lock拥有mutex.
		1. 构造时是否加锁是可选的
		2. 在对象析构时如果持有锁会自动释放锁
		3. 所有权可以转移
		4. 对象生命期内允许手动加锁和释放锁
		5. 可以调用owns_lock()和bool()来查询mutex是否被锁住
		6. 比`lock_guard`多三个构造函数:
			- 使用`try_to_lock`作为策略
			- 使用一个时间段或时间点给构造函数,表示尝试一个明确的时间周期内锁定:
				- `unique_lock<std::timed_mutex> lock(mutex, std::chrono::secdonds(1));`
			- 使用`defer_lock`策略

	- std::`shared_lock(C++14)`: 用于管理可转移和共享所有权的互斥对象

#### 互斥对象管理类模板的加锁策略
1. 策略 、 tag type 、描述
	1. 默认:  无: 请求锁，阻塞当前线程直到成功获得锁道道
	2. std::`defer_lock`: `std::defer_lock_t`: 表示初始化这个lock object但尚未打算锁住mutex.不请求锁
	3. `std::try_to_lock`: `std::try_to_lock_t`: 尝试请求锁，但不阻塞线程，锁不可用时也会立即返回
	4. `std::adopt_lock`: `std::adopt_lock_t`: 假定当前线程已经获得互斥对象的所有权，所以不在请求锁

2. RAII管理对象对策略的支持: 所有对象都支持默认的策略
	1. `lock_guard`: 
		- `std::adopt_lock`
	2. `unique_lock`
		- 支持所有的策略

	3. `shared_lock`
		- 支持所有策略

	4. 只有`lock_guard`不支持`try_to_lock`和`defer_lock`，其他所有RAII对象支持所有策略

#### 底层加锁函数
1. `std::try_lock`，尝试同时对多个互斥量上锁。
2. std::lock，可以同时对多个互斥量上锁。
3. `std::call_once`，如果多个线程需要同时调用某个函数，`call_once` 可以保证多个线程对该函数只调用一次。

#### 对多个互斥对象加锁
1. 在某些情况下我们可能需要对多个互斥对象进行加锁,但是如果多个锁的加锁顺序不是一样的话，多个线程可能出现死锁
2. 为了避免发生这类死锁，对于任意两个互斥对象，在多个线程中进行加锁时应保证其先后顺序是一致
```
std::mutex mt1, mt2;
// thread 1
{
    std::lock_guard<std::mutex> lck1(mt1);
    std::lock_guard<std::mutex> lck2(mt2);
    // do something
}
// thread 2
{
    std::lock_guard<std::mutex> lck1(mt1);
    std::lock_guard<std::mutex> lck2(mt2);
    // do something
}
```
3. 更好的做法是使用标准库中的std::lock和`std::try_lock`函数来对多个Lockable对象加锁。
	- std::lock(或`std::try_lock`)会使用一种避免死锁的算法对多个待加锁对象进行lock操作(`std::try_lock`进行`try_lock`操作)
	- 当待加锁的对象中有不可用对象时std::lock会阻塞当前线程直到所有对象都可用
		(`std::try_lock`不会阻塞线程当有对象不可用时会释放已经加锁的其他对象并立即返回)

		```
		std::mutex mt1, mt2;
		// thread 1lock_guard
		{
			std::unique_lock<std::mutex> lck1(mt1, std::defer_lock);
			std::unique_lock<std::mutex> lck2(mt2, std::defer_lock);
			std::lock(lck1, lck2);
			// do something
		}
		// thread 2
		{
			std::unique_lock<std::mutex> lck1(mt1, std::defer_lock);
			std::unique_lock<std::mutex> lck2(mt2, std::defer_lock);
			std::lock(lck2, lck1);
			// do something
		}
		```

4. 此外`std::lock`和`std::try_lock`还是异常安全的函数(要求待加锁的对象unlock操作不允许抛出异常)，
	- 当对多个对象加锁时，其中如果有某个对象在lock或`try_lock`时抛出异常，std::lock或`std::try_lock`会捕获这个异常
		并将之前已经加锁的对象逐个执行unlock操作，然后重新抛出这个异常(异常中立)。
	
	
5. 并且`std::lock_guard`的构造函数`lock_guard`(`mutex_type`& m, `std::adopt_lock_t` t)也不会抛出异常。所以std::lock像下面这么用也是正确
```
std::lock(mt1, mt2);
std::lock_guard<std::mutex> lck1(mt1, std::adopt_lock);
std::lock_guard<std::mutex> lck2(mt2, std::adopt_lock);
```

6. 总结：
	1. 多个互斥体加锁时，一个个的加锁，需要按照同样的顺序来对多个锁来加锁
	2. 如果lock多个锁时，当待加锁的对象中有不可用对象时std::lock会阻塞当前线程直到所有对象都可用
		所以：<font color=red>lock可能会按相同的规则来加锁,使得所有加锁顺序相同.因为它并不会释放已经申请的锁</font>

	3. 多个锁加锁时的RAII应该满足如下规则:
		- 如果是`unique_lock`,需要使用`defer_lock`策略
		- 如果是`lock_guard`，需要使用`adopt_lock`策略

	4. 如果`try_lock`多个锁时，不需要指定锁和策略的搭配，它会直接返回不可用的锁的id,如果全部加锁成功,返回-1。

	5. lock会使用deadlock回避机制,而`try_lock`不提供deadlock回避机制,但它保证<font color=red>以出现于实参列的次序来试着完成锁定</font>
		- 说明lock多个mutex时,lock会改变mutex的次序,以是的各个锁按同一顺序加锁.

#### 只调用一次的锁
1. `call_once`的第一实参必须是相应的`once_flag`,下一个实参是可调用对象,还可以再加上其他实参给被调用的函数使用

1. `call_once`保证函数fn只被执行一次
	- 如果有多个线程同时执行函数fn调用，则只有一个活动线程(active call)会执行函数
	- 其他的线程在这个线程执行返回之前会处于”passive execution”(被动执行状态)——不会直接返回，直到活动线程对fn调用结束才返回。
	- 对于所有调用函数fn的并发线程，数据可见性都是同步的(一致的)。

2. 如果活动线程在执行fn时抛出异常，则会从处于”passive execution”状态的线程中挑一个线程成为活动线程继续执行fn，依此类推。
	一旦活动线程返回，所有”passive execution”状态的线程也返回,不会成为活动线程

3. 实际上`once_flag`相当于一个锁，使用它的线程都会在上面等待，只有一个线程允许执行。
	如果该线程抛出异常，那么从等待中的线程中选择一个，重复上面的流程

4. 原则上可以使用同一个`once_flag`调用不同的函数.之所以把once flag 当做第一个实参传给`call_once`就是<font color=red>为了确保传入的机能只被执行一次</font>
	- 因此,如果第一次调用成功,下一次调用又带着相同的 once flag,传入的机能就不会被调用--即使该机能与第一次有异(机能似乎指的是第二个参数那个可调用对象)
	- 被调用的函数所造成的任何异常都会被`call_once()`抛出,此情况下<font color=red>第一次调用被视为不成功,因此下一次`call_once`还可以在调用它所调用的机能</font>
	- 就是说:如果once flag 调用的函数成功,下次同一个once flag就不会被调用了,如果once flag第一次的可调用对象失败,那么这个once flag还可以使用一次.

5. 函数
```
头文件#include<mutex>

template <class Fn, class... Args>

void call_once (once_flag& flag, Fn&& fn, Args&&...args);
```

6. eg
```
std::once_flag oc;
std::call_once(oc, initialize);
```

7. 还有一个要注意的地方是 `once_flag`的生命周期，它必须要比使用它的线程的生命周期要长。所以通常定义成全局变量比较好。

### Condition Variable
> 有时候,被不同线程执行的task必须彼此等待,所以对 并发操作 实现同步化除了data race之外还有其他原因

1. future智能传递数据一次,他不是为这种场景设计的.future 的主要目的是处理线程的返回值或异常.
2. 条件变量,他可以来同步化线程之间的数据流逻辑依赖关系

#### 意图
1. "让某线程等待另一个线程"的一个粗浅方法,就是使用ready flag之类的东西. 这通常意味着等待中的线程需要轮询其所需要的数据或条件是否已达到
```
bool readyFlag;
std::mutex readyFlagMutex;
{
	std::unique_lock<std::mutex> ul(readyFlagMutex);
	while (!readyFlag) {
		ul.unlock();
		std::this_therad::yield();
		std::this_thread::sleep_for(std::chrono::millseconds(100));
		ul.lock();
	}
}
```

2. 一个较好的方法是使用condition variable: `<condition_variable>`
	- 它是个变量,借由它,一个线程可以唤醒一或多个其他等待中的线程

3. condition variable 的运作如下:
	1. 你必须同时包含<mutex> 和`<cnodition_variable>`,并声明一个mutex 和一个condiion variable:
		```
		#include <mutex>
		#include <condition_variable>

		std::mutex readyMutex;
		std::condition_variable readyCondVar;
		```

	2. 那个激发"条件总于满足"的线程(或多线程之一)
		- 必须调用 `readyCondVar.notify_one()`;
		- 或调用 `readyCondVar.notify_all()`;

	3. 那个"等待条件被满足"的线程必须调用
		```
		std::unique_lock<std::mutex> l(readyMutex)`;
		readyCondVar.wait(1);
		```
		因此"提供或准备某东西"的那个线程只需对condition variable 调用notify_one()或notify_all(),便会唤醒一个或所有等待中的线程

4. 注意的问题:
	1. 等待这个condition variable需要一个mutex和一个`unique_lock`,因为等待线程可能锁定或解除mutex,所以不能使用`lock_guard`.
	2. condition variable 可能出现假醒(spurious wakeup)
		因此,我们必须检查数据是否真正备妥,或是仍需要诸如ready flag之类的东西,可以用同一个mutex.
		
	3. <font color=red>使用同一个mutex来使用condition variable时,unique lock也是会阻塞的,直到它获得锁,然后调用variable 
		的wait,wait会自动释放锁,然后等待,直到被重新被唤醒再重新加锁,还可以多一个条件判断函数.</font>

	4. mutex相当于一个简单类型,lock guard,unique guard 是RAII的锁管理器.condition variable 是使用锁的,直接使用unique lock.
	5. <font color=red>cond wait的时候,第一个参数的锁必须是锁定的,否则会出错.它会在条件不满足的时候自动释放锁</font>

	6. 所有通知(notification)都会同步化,所以并发调用notify_one()和notify_all()不会带来麻烦
	7. 所有等待某个condition variable的线程都必须使用相同的mutex,
		<font color=red>当wait()家族的某个成员被调用时该mutex必须被`unique_lock`锁定,否则会发生不明确的行为,因为wait会释放锁</font>

	8. 注意: condition variable 的消费者总是在"被锁住的mutex"基础上操作.
		<font color=red>只有等待函数(waiting function)会执行一下三个atomic步骤暂时接触mutex.</font>

		- 解除(unlocking) mutex然后进入等待状态(waiting state) //调用wait()
		- 解除因等待而造成的阻塞(Unblokcing the wait)          //被通知
		- 再次锁住mutex                                        //被通知
		
	9. 8 意味着传给wait函数的那个判断式总是在lock情况下被调用,所以它们可以安全的处理受mutex保护的对象,用来将mutex锁定和解锁的动作可能抛出异常.
	10. <font color=red>粗浅解法:"lock, check state, unlock, wait" (锁定, 检查状态, 解锁, 等待) 的问题是,在unlock和wait之间形成的通知会遗失</font>

5. `wait_for`和`wait_until`各有个给不接受判断式(predicate)的版本,它们返回的值都属于一下枚举值:
	- `std::cv_status::timeout` : 如果发生不容置疑的超时(timeout)
	- `std::cv_status::no_timeout`: 如果发生通知(notification)

6. `wait_for`和`wait_until`亦各有个接受判断式(predicate)的版本,它们返回判断式的执行结果

7. `notify_all_at_thread_exit(cv, l)`: 用来在其调用者(线程)退场(exit)时调用`notify_all()`
	- 为此它暂时锁住对应的lock l,后者必须使用所有等待线程(waiting thread)共享同一个mutex
	- 为避免死锁,线程调用`notify_all_at_thread_exit()`之后应该直接退场(exit)
	- <font color=red>因此这个调用只是为了在通知 waiting thread 之前先完成清理工作,而且这个而清理工作绝不该造成阻塞(block)</font>
	
### Atomic
1. 普通数据同步问题:
	1. 一般而言,及时面对基本数据类型,读和写也不是atomic(不可分割的).因此亦可能读到一个被写了一半的值,C++ standard说这会带来不明确的行为
	2. 编译器生成的代码有可能改变操作次序,所以供应端线程可能刚在供应数据之前就设置了ready flag,而消费端线程也有可能在侦测ready flag之前具处理该数据.

2. 使用mutex可以消除问题,但是比较昂贵,aotmic在某些情况下可以取代mutex和lock

#### Atomic 高层接口
> 它提供的操作将使用默认保证，不论内存访问次序如何，这个默认保证提供了顺序一致性（sequential consistency), 
	意思是在线程之中atomic操作保证一定"像代码出现的次序"那样地发生.因此不会出现重排语句的情况

1. 使用:
	1. 包含头文件<atomic>,其内声明了atomic
	2. 使用std::atomic<> template 声明要给atomic object:
		```std::atomic<bool> readyFlag(false)```
	3. <font color=red>总是应该将atomic object 初始化,因为其default 构造函数并不完全初始化它(倒不是其初始值不明确,而是其lock未被初始化)</font>,
		面对一个static-duration atomic 对象,应该使用一个常量作为其初始值

	4. <font color=red>如果只使用default构造函数,接下来唯一允许的操作是如下调用global atomic_init()</font>

		``` 
		std::atomic<bool> readyFlag;
		std::atomic_init(&readyFlag, false);
		```

2. atomic 操作:atomic最重要的语句是store()和load():
	- store()赋予一个新值
	- load() 取当前值

	- 这些操作都保证是atomic(不可切割的),所以不需要加锁来保证执行顺序.
	- 使用condition variable 时我们仍需要mutex才能保护对condition variable 的消费(即使它现在是个atomic object)

3. atomic 类型,可以使用寻常的操作,像是赋值/自动转换整型,递增,递减等,但是为了提供atomicity(不可分割性),某些惯常行为会出现轻微差异:
	- 赋值操作返回的是被赋予的值,而不是返回一个reference指向"接受该值"的atomic

4. store()会对影响所及的内存区执行一个所谓的release操作,确保此前所有的内存操作(all prior memory operations)不论是否是atomic,在store返回作用之前都变成"可被其他线程看见".
	(应该就是改变了各个cpu内的所有缓存)

5. load() 会对所有影响所及的内存区执行一个所谓的acquire操作,确保随后的所有内存操作不论是否为atomic,在load之后都变成"可被其他线程看见"

6. atomic操作默认使用一个特别内存次序(memory order),名为memory_order_seq_cst,它代表孙旭一致的内存次序

#### Atomic底层接口
> 带有"放宽之次序保证"的操作
