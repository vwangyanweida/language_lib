
<!-- vim-markdown-toc GFM -->

* [组件]
	* [元素:]
	* [组件作用域:]

<!-- vim-markdown-toc -->
## 组件
### 元素:
1. 详细prop:

```
Vue.component = {
	'name',

	data: function() {
		return counter;
	},

	props:[],

	model:{

	},

	component: {
		child_component
	},

   template = `

   `
}
```

2. v-model 在组件上和html原生元素事件处理函数不同:
> 在组件上使用 v-model自定义事件也可以用于创建支持 v-model 的自定义输入组件。
	1. 记住：

	<input v-model="searchText">

	等价于：

	```
	<input
	  v-bind:value="searchText"
	  v-on:input="searchText = $event.target.value"
	>
	```

	2. 当用在组件上时，v-model 则会这样：

	```
	<custom-input
	  v-bind:value="searchText"
	  v-on:input="searchText = $event"
	></custom-input>
	```

3. 所以导致组件使用v-model时,要自己重新发射一个input信号,信号的第二个参数是$event.target.value;

4. is的用法:
	- is="todo-item" attribute。这种做法在使用 DOM 模板时是十分必要的，
	- 因为在 <ul> 元素内只有 <li> 元素会被看作有效内容。

### 组件作用域:
1. <font color=red>任何数据都不会被自动传递到组件里，因为组件有自己独立的作用域</font>。

2. 如果需要将父作用域的prop传递给组件,必须在组件上使用bind:name="value",
	- 组件元素上的bind的所有对象是添加到组件的作用域内的
	- 因此组件元素每bind一个变量,组件的作用域内就添加了一个属性
	- 通过bind给组件添加一个属性,然后将属性赋予父作用域的值,就实现了父作用域的值传递到组件中.

3. 一个组件当作html元素时,每个组件对象都有自己各自的命名空间,不会影响到同一个组件的其他对象的变量值.

