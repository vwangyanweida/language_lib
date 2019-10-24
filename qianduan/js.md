
<!-- vim-markdown-toc GFM -->

* [js](#js)
	* [JavaScript 的组成](#javascript-的组成)
	* [js面向对象编程](#js面向对象编程)
		* [构造函数](#构造函数)
		* [原型/prototype](#原型prototype)
	* [函数进阶:](#函数进阶)
		* [高级函数](#高级函数)
			* [call](#call)
			* [apply](#apply)
			* [bind](#bind)

<!-- vim-markdown-toc -->
# js
> JavaScript，通常缩写为 JS，是一种高级的，解释执行的编程语言。
> JavaScript 是一门基于原型、函数先行的语言，是一门多范式的语言，它支持面向对象编程，命令式编程，以及函数式编程。
> 它提供语法来操控文本、数组、日期以及正则表达式等，<font color=red>不支持 I/O</font>，比如网络、存储和图形等，但这些都可以由它的宿主环境提供支持

## JavaScript 的组成
	- ECMAScript：JavaScript 的语法标准。
	- DOM：JavaScript 操作网页上的元素的 API。
	- BOM：JavaScript 操作浏览器的部分功能的 API。

## js面向对象编程
1. 例子:
```
var test = {
	getEle: {
		tag: function(tagName){
			return document.getElementByTagName(tagName);
		},
		id: function(idName) {
			return documetn.getElementById(idName);
		}
	},

	setCss: {
		setStyle: function(arr){
			for(var i=0;i<arr.length;i++) {
			  arr[i].style.backgroundColor="red";
			}
		}
	}
}

var divs = test.getEle.tag("div");
test.setCss.setStyle(divs);
```

2. js中的对象像是python中的字典,只不过key可以不加引号. json和python中的字典一样,都要加引号.

### 构造函数
1. 通过字面量创建对象:
```
var student={
	name: 'zhangsan',
	age: 18,
	gender: 'male',
	sayHi: function(){
		conson.log("hi, my name is " + this.name);
	}
}
```

2. 通过new Object()创建对象
```
var student = new Object();
student.name='zhangsan',
studnet.age = 18
...
```

3. 构造函数:
	1. eg
	```
	function Student(name, age, gender){
		this.name = name;
		this.age = age;
		this.gender = gender;
		this.sayHi = function(){
			console.log("hi, my name is " + this.name);
		}
	}
	var s1 = new Student('zhang', 18, 'male');
	```

	2. 来看看构造函数与工厂函数的区别：
		- 首先在构造函数内没有创建对象，而是使用 this 关键字，将属性和方法赋给了 this 对象。
		- 构造函数内没有 return 语句，this 属性默认下是构造函数的返回值。
		- 函数名使用的是大写的 Student。
		- 用 new 运算符和类名 Student 创建对象

	3. 构造函数的问题:
		1. 创建多个对象,每个对象都会创建一次sayHi这个函数,每个对象都是独立的. 解决办法使用原型

### 原型/prototype
1. 在js中,每一个<font color=red>函数</font>都有一个prototype属性,指向另一个prototype对象,
	这个prototype对象的所有属性和方法,都会被构造函数实例对象继承.

	```
	function Student(name, age, gender){
		this.name = name;
		this.age = age;
		this.gender = gender;
	}
	Student.prototype.sayHi=function(){
		console.log("hi");
	}
	var s1 = new Student("zhang", 12, "male");
	s1.sayHi();
	var s2 = new Student("li", 12, "male");
	s2.sayHi();
	console.log(s1.sayHi==s2.sayHi) //结果为true
	```

2. 每一个函数都有一个prototype属性,prototype属性默认都有一个constructor属性,指向prototype对象所在的函数.
	也就是说,函数的有一个prototype,prototype的constructor又指向函数对象本身.
	```
	function F(){}
	console.log(F.prototype.contructor==F); //true
	```

3. `__proto__`: 有构造函数创建的实例对象,有一个`__proto__`指针,指向构造函数的prototype
```
function F(){}
var a = new F();
console.log(a.__proto__==F.prototype); //true
```

4. 原型链
> 所有的对象都有原型，而原型也是对象，也就是说原型也有原型，那么如此下去，也就组成了我们的原型链。

	1. 属性搜索原则
		属性搜索原则，也就是属性的查找顺序，在访问对象的成员的时候，会遵循以下原则：

		- 首先从对象实例本身开始找，如果找到了这个属性或者方法，则返回。
		- 如果对象实例本身没有找到，就从它的原型中去找，如果找到了，则返回。
		- 如果对象实例的原型中也没找到，则从它的原型的原型中去找，如果找到了，则返回。
		- 一直按着原型链查找下去，找到就返回，如果在原型链的末端还没有找到的话，那么如果查找的是属性则返回 undefined，
			如果查找的是方法则返回 xxx is not a function。

	2. 更简单的原型语法
		在前面的例子中，我们是使用 xxx.prototype. 然后加上属性名或者方法名来写原型，
		但是每添加一个属性或者方法就写一次显得有点麻烦，因此我们可以用一个包含所有属性和方法的对象字面量来重写整个原型对象：
		```
		function Student(name, age, gender) {
			this.name = name;
			this.age = age;
			this.gender = gender;
		}
		Student.prototype = {
			hobby:"study",
			sayHi:function(){
			console.log("hi");
			}
		}
		var s1 = new Student("wangwu",18,"male");
		console.log(Student.prototype.constructor === Student);//结果为 false
		```
		<font color=red>但是这样写也有一个问题，那就是原型对象丢失了 constructor 成员</font>

	3. 所以为了保持 constructor 成员的指向正确，建议的写法是:
	```
	function Student(name, age, gender) {
		this.name = name;
		this.age = age;
		this.gender = gender;
	}
	Student.prototype = {
		constructor: Student, //手动将 constructor 指向正确的构造函数
		hobby:"study",
		sayHi:function(){
		console.log("hi");
		}
	}
	var s1 = new Student("wangwu",18,"male");
	console.log(Student.prototype.constructor === Student);//结果为 true
	```

	4. 总结:
		1. js使用prototype来定义所有对象都要继承的属性和方法,<font color=green>有点类似与其他语言的类方法,类属性</font>.所有对象都会继承这些属性和方法.
		2. 每个构造函数有一个原型对象(prototype),原型对象包含一个指向构造函数的指针constructor,而实例对象都包含一个指向原型对象的内部指针`__proto__`

## 函数进阶:
### 高级函数
#### call
> call() 方法调用一个函数, 其具有一个指定的 this 值和分别地提供的参数(参数的列表)。语法为：

```
fun.call(thisArg, arg1, arg2, ...)
```

2. 注：

	- thisArg 指的是在 fun 函数中指定的 this 的值。如果指定了 null 或者 undefined 则内部 this 指向 window，
		同时值为原始值(数字，字符串，布尔值)的 this 会指向该原始值的自动包装对象。是一个可选项。
	- arg1, arg2, ...指定的参数列表。也是可选项。
	- 使用调用者提供的 this 值和参数调用该函数的返回值。若该方法没有返回值，则返回 undefined。
	- call() 允许为不同的对象分配和调用属于一个对象的函数/方法。
	- call() 提供新的 this 值给当前调用的函数/方法。你可以使用 call 来实现继承：
		写一个方法，然后让另外一个新的对象来继承它（而不是在新对象中再写一次这个方法）。

3. eg.
	1. 使用 call() 方法调用函数并且指定上下文的 'this'。
	```
	function foods(){
	}
	foods.prototype={
		price: "15", 
		say: funciton(){
		   console.log("my price: "+this.price);
		}
	}

	var apple = new foods();
	orange = {
		price: "10"
	}
	apple.say.call(orange);
	```

	2. 在一个子构造函数中，你可以通过调用父构造函数的 call() 方法来实现继承。在控制台输入如下代码：
	```
	function Father(name, age) {
		this.name = name;
		this.age = age;
	}

	function Son(name, age) {
		Father.call(this, name, age);
		this.hobby = 'study';
	}

	var S1 = new Son('zhangsan', 18);
	S1; // Son {name: "zhangsan", age: 18, hobby: "study"}
	```

#### apply
> apply() 方法与 call() 方法类似，唯一的区别是 call() 方法接受的是参数，apply() 方法接受的是数组。语法为：

```
fun.apply(thisArg, [argsArray])
```

1. 使用 apply() 方法将数组添加到另一个数组。
	1. eg:
	```
	var array = ['a', 'b','c'];
	var nums = [1, 2, 3];
	array.push.apply(array, nums);
	array //["a", "b", "c", 1, 2, 3]
	```
	2. 注：concat() 方法连接数组，不会改变原数组，而是创建一个新数组。
		而使用 push 是接受可变数量的参数的方式来添加元素。使用 apply 则可以连接两个数组

2. 使用 apply() 方法和内置函数。

	1. 例子：
	```
	var numbers = [7, 10, 2, 1, 11, 9];
	var max = Math.max.apply(null, numbers); 
	max; //11

	```

	2. 注：直接使用 max() 方法的写法为： Math.max(7, 10, 2, 1, 11, 9);

#### bind
> bind() 方法创建一个新的函数（称为绑定函数），在调用时设置 this 关键字为提供的值。
	并在调用新函数时，将给定参数列表作为原函数的参数序列的前若干项。
	
1. 语法为：fun.bind(thisArg[, arg1[, arg2[, ...]]])

2. 注：
	- 参数 thisArg ：当绑定函数被调用时，该参数会作为原函数运行时的 this 指向。
	- 当使用 new 操作符调用绑定函数时，该参数无效。
	- 参数：arg1, arg2, ...表示当目标函数被调用时，预先添加到绑定函数的参数列表中的参数。

3. eg
```
var bin = function(){
    console.log(this.x);
}
var foo = {
x:10
}
bin(); // undefined
var func = bin.bind(foo); //创建一个新函数把 'this' 绑定到 foo 对象
func(); // 10
```
4. eg
```
this.num = 6;
var test = {
  num: 66,
  getNum: function() { return this.num; }
};

test.getNum(); // 返回 66

var newTest = test.getNum;
newTest(); // 返回 6, 在这种情况下，"this"指向全局作用域

// 创建一个新函数，将"this"绑定到 test 对象
var bindgetNum = newTest.bind(test);
bindgetNum(); // 返回 66
```
