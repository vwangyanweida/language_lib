### 组件
0. 元素:
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
1. 一个组件当作html元素时,每个组件对象都有自己各自的命名空间,不会影响到同一个组件的其他对象的变量值.

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

