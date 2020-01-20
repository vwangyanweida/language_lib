<!-- vim-markdown-toc GFM -->

* [相似](#相似)
	* [1 循环：](#1-循环)
	* [2 匿名函数](#2-匿名函数)
	* [3 可调用对象](#3-可调用对象)
	* [4 魔法方法/编译器自动调用](#4-魔法方法编译器自动调用)
	* [5 容器类型](#5-容器类型)
	* [6 泛型和元类](#6-泛型和元类)
	* [7 STL算法和python算法函数](#7-stl算法和python算法函数)
	* [8 偏函数和std::bind](#8-偏函数和stdbind)
	* [9 默认实参](#9-默认实参)
	* [10 可变形参](#10-可变形参)
	* [map/for_each](#mapfor_each)
* [不同](#不同)
	* [1 lambda：闭包变量](#1-lambda闭包变量)

<!-- vim-markdown-toc -->
## 相似
### 1 循环：
1. python
	```
	for i in iteratable：
		do
	```

2. c++
	```
	for(auto &i: iteratable)
		do;
	```

### 2 匿名函数
1. python: 
	```lambda x: x```

2. c++: 
	```[](params) -> return_type {};```

3. 匿名函数可以使用局部变量，所以用到了闭包。

4. **python 闭包内的局部变量是调用时引用的，c++的闭包变量时定义时拷贝到闭包里的, 但如果是传引用的话，和python类似**

### 3 可调用对象
1. python
	1. callable(func)
	2. 类型
		- 函数
		- 对象方法
		- 定义了__call__方法的类对象是可调用对象
	3. 偏函数绑定对象
	4. typeinfo中可以使用绑定对象方法。

2. c++ 可调用类型
	1. std::function
	2. 类型：
		- 函数
		- 类方法
		- 函数指针
		- 对象方法：成员函数第一个参数也会自动将this当做第一个函数传递进去
		- 定义了operate()方法的类对象是可调用对象。

	3. bind方法将可调用对象(大部分是function(return_type(params))类型对象)的函数绑定，像是python中的偏函数一样。

	4. eg
	```
	void func(int x, int y);
	auto l = [](int x, int y){
		...
	};
	
	class C {
		public:
			void operator () (int x, int y) const;
			void memfunc (int x, int y) const;
	}

int main() {
	C c;
	std::shared_ptr<C> sp(new C);

	std::bind()
	std::bind(func, 7, 33)();
	std::bind(l, 77, 33)();;
	std::bind(C(), 77, 33)();; //这里是C::operator()(77, 33),
	C生成一个对象是可调用对象，然后在以77,33为可调用对象的参数。即operator函数。
	
	std::bind(&C::memfunc, c, 77, 33)();//指定类的方法，默认传递的第一个参数：类对象，args

	std::bind(&C::memfunc, sp, 77, 33)(); // sp->memfunc(77, 33)
}

	```

3. 总结
	1. 定义了特殊方法的成员函数 __call__/operator() 的类，它生成的对象是可调用的
	2. 可调用对象都可以提前绑定函数，这样可以将函数名、函数指针当做参数传递给事件循环、信号处理……来调度
	3. 对象方法都要把对象当做第一个参数传递：
		1. 如果是obj.method()方法的话，编译器会自动将对象当做第一个参数传递
		2. **如果是bind或者在对象外部调用方法的话，需要自己指定第一个参数**。

### 4 魔法方法/编译器自动调用
1. 构造
	- python
		1. __new__
		2. __init__

	- c++
		1. 默认构造函数 
			clss_name()=default //不能有默认参数，编译器构造的那个构造函数
		2. 自定义构造函数，初始化式
		3. 拷贝复制构造

2. 析构
	- python
		__del__ //注意，del会直接清理对象内存，而不等待垃圾回收

	- c++
		~clssname();

3. 调用:都是类对象调用是触发
	- python
		__call__()

	- class
		operator()

4. python的魔法方法都相当于c++的操作符重载

### 5 容器类型
1. dict

2. list

3. set

4. tuple

### 6 泛型和元类

### 7 STL算法和python算法函数

### 8 偏函数和std::bind
1. python
```
from functools import partial
fun = partial(func1, args)
args需按照形参数墟，kwargs可以不按照顺序
```
	

2. c++
```
auto bindFoo = std::bind(foo, std::placeholders::_1, 1, 2);
bind(1);
	//bind函数用placeholders占位符表示没有绑定实参的形参。
```

### 9 默认实参
1. python
	def a(par1, par2=23)  //默认实参必须在右侧

2. c++
	int compare(int a, int b=23);

### 10 可变形参
- python

- c

- c++

### map/for_each
1. python:

	```map(functional, coll)```

2. c++

	```for_each(coll.cbegin(), coll.cend(), functional)```

## 不同
### 1 lambda：闭包变量
1. python
	1. 闭包变量直到执行时才绑定变量值。

2. c++
	1. 值捕获：
		1. 值是可以拷贝的
		2. 被捕获的变量在lambda表达式创建时拷贝，而非调用时拷贝
	2. 引用捕获：
		1. 没有拷贝，是引用。和python类似。

3. 总结
	1. python所有传参都是引用传递，只不过不可变对象如果更改了会在内存中重新生成一份新的对象，
		所以python的闭包和c++传引用比较类似。
	2. c、c++ 有传值和传引用两种方式。
