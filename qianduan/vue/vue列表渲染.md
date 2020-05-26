
<!-- vim-markdown-toc GFM -->

* [列表渲染]
	* [用 v-for 把一个数组对应为一组元素]
	* [在 v-for 里使用对象]
	* [维护状态]
	* [数组更新检测]
		* [变更方法]
		* [替换数组]
		* [注意事项]
		* [显示过滤/排序后的结果]
	* [在 v-for 里使用值范围]
	* [在 <template> 上使用 v-for]
	* [v-for 与 v-if 一同使用]
	* [在组件上使用 v-for]

<!-- vim-markdown-toc -->

## 列表渲染
### 用 v-for 把一个数组对应为一组元素
1. 我们可以用 v-for 指令基于一个数组来渲染一个列表。
v-for 指令需要使用 item in items 形式的特殊语法，其中 items 是源数据数组，而 item 则是被迭代的数组元素的别名。

```
<ul id="example-1">
  <li v-for="item in items" :key="item.message">
    {{ item.message }}
  </li>
</ul>

var example1 = new Vue({
  el: '#example-1',
  data: {
    items: [
      { message: 'Foo' },
      { message: 'Bar' }
    ]
  }
})
```

2. 在 v-for 块中，我们可以访问所有父作用域的 property。v-for 还支持一个可选的第二个参数，
<font color=green>即当前项的索引</font>。

```
<ul id="example-2">
  <li v-for="(item, index) in items">
    {{ parentMessage }} - {{ index }} - {{ item.message }}
  </li>
</ul>

var example2 = new Vue({
  el: '#example-2',
  data: {
    parentMessage: 'Parent',
    items: [
      { message: 'Foo' },
      { message: 'Bar' }
    ]
  }
})
```

3. 你也可以用 of 替代 in 作为分隔符，因为它更接近 JavaScript 迭代器的语法：

```
<div v-for="item of items"></div>
```

### 在 v-for 里使用对象
1. <font color=green>你也可以用 v-for 来遍历一个对象的 property</font>。

```
<ul id="v-for-object" class="demo">
  <li v-for="value in object">
    {{ value }}
  </li>
</ul>

new Vue({
  el: '#v-for-object',
  data: {
    object: {
      title: 'How to do lists in Vue',
      author: 'Jane Doe',
      publishedAt: '2016-04-10'
    }
  }
})
```

2. 你也可以提供第二个的参数为 property 名称 (也就是键名)：

```
<div v-for="(value, name) in object">
  {{ name }}: {{ value }}
</div>

{{ name }}: {{ value }}
```

3. 还可以用第三个参数作为索引：

```
<div v-for="(value, name, index) in object">
  {{ index }}. {{ name }}: {{ value }}
</div>

{{ index }}. {{ name }}: {{ value }}
```

4. 在遍历对象时，会按 Object.keys() 的结果遍历，但是不能保证它的结果在不同的 JavaScript 引擎下都一致。

### 维护状态
1. 当 Vue 正在更新使用 v-for 渲染的元素列表时，它默认使用“就地更新”的策略。
如果数据项的顺序被改变，<font color=red>Vue 将不会移动 DOM 元素来匹配数据项的顺序</font>，而是就地更新每个元素，
并且确保它们在每个索引位置正确渲染。这个类似 Vue 1.x 的 track-by="$index"。

2. 这个默认的模式是高效的，但是只适用于不依赖子组件状态或临时 DOM 状态 (例如：表单输入值) 的列表渲染输出。

3. <font color=green>为了给 Vue 一个提示，以便它能跟踪每个节点的身份，
从而重用和重新排序现有元素(类似与输入元素重用,只要显式说明不要重用已有元素,加一个key attribute就好,
这回使得元素不匹配没法重用已有元素)</font>,你需要为每项提供一个唯一 key attribute：

```
<div v-for="item in items" v-bind:key="item.id">
  <!-- 内容 -->
</div>
```

4. 建议尽可能在使用 v-for 时提供 key attribute，除非遍历输出的 DOM 内容非常简单，
或者是刻意依赖默认行为以获取性能上的提升。

	<font color=green>因为它是 Vue 识别节点的一个通用机制，key 并不仅与 v-for 特别关联</font>。
后面我们将在指南中看到，它还具有其它用途。

5. 不要使用对象或数组之类的非基本类型值作为 v-for 的 key。<font color=green>请用字符串或数值类型的值</font>

### 数组更新检测
#### 变更方法
1. 变更方法，顾名思义，会变更调用了这些方法的原始数组。
2. Vue 将被侦听的数组的变更方法进行了包裹，所以它们也将会触发视图更新。这些被包裹过的方法包括：

	- push()
	- pop()
	- shift(): 从头取出一个,和pop相对
	- unshift(): 从头部添加一个,和push相对
	- splice()
	- sort()
	- reverse()

2. 你可以打开控制台，然后对前面例子的 items 数组尝试调用变更方法。比如 example1.items.push({ message: 'Baz' })。

#### 替换数组
> 相比之下，也有非变更方法，例如 filter()、concat() 和 slice()。

1. 它们不会变更原始数组，而总是返回一个新数组。当使用非变更方法时，可以用新数组替换旧数组：

	```
	example1.items = example1.items.filter(function (item) {
	  return item.message.match(/Foo/)
	})
	```

2. 你可能认为这将导致 Vue 丢弃现有 DOM 并重新渲染整个列表。幸运的是，事实并非如此。
<font color=green>Vue 为了使得 DOM 元素得到最大范围的重用而实现了一些智能的启发式方法</font>，
所以用一个含有相同元素的数组去替换原来的数组是非常高效的操作。

#### 注意事项
1. <font color=red>由于 JavaScript 的限制，Vue 不能检测数组和对象的变化。深入响应式原理中有相关的讨论</font>。

#### 显示过滤/排序后的结果
1. 有时，我们想要显示一个数组经过过滤或排序后的版本，而不实际变更或重置原始数据。
在这种情况下，可以创建一个计算属性，来返回过滤或排序后的数组。

	1. 例如：

	```
	<li v-for="n in evenNumbers">{{ n }}</li>

	data: {
	  numbers: [ 1, 2, 3, 4, 5 ]
	},
	computed: {
	  evenNumbers: function () {
		return this.numbers.filter(function (number) {
		  return number % 2 === 0
		})
	  }
	}
	```

2. 在计算属性不适用的情况下 (例如，在嵌套 v-for 循环中) 你可以使用一个方法：

```
<ul v-for="set in sets">
  <li v-for="n in even(set)">{{ n }}</li>
</ul>

data: {
  sets: [[ 1, 2, 3, 4, 5 ], [6, 7, 8, 9, 10]]
},
methods: {
  even: function (numbers) {
    return numbers.filter(function (number) {
      return number % 2 === 0
    })
  }
}
```

### 在 v-for 里使用值范围
1. v-for 也可以接受整数。在这种情况下，它会把模板重复对应次数。类似与range,可迭代对象.

```
<div>
  <span v-for="n in 10">{{ n }} </span>
</div>
```

结果：

```
{{ n }}
```

### 在 <template> 上使用 v-for
1. 类似于 v-if，你也可以利用带有 v-for 的 <template> 来循环渲染一段包含多个元素的内容。比如：

```
<ul>
  <template v-for="item in items">
    <li>{{ item.msg }}</li>
    <li class="divider" role="presentation"></li>
  </template>
</ul>
```

### v-for 与 v-if 一同使用
1. <font color=red>注意我们不推荐在同一元素上使用 v-if 和 v-for。更多细节可查阅风格指南</font>。

2. 当它们处于同一节点，<font color=red>v-for 的优先级比 v-if 更高</font>，
这意味着 v-if 将分别重复运行于每个 v-for 循环中。当你只想为部分项渲染节点时，这种优先级的机制会十分有用，如下：

```
<li v-for="todo in todos" v-if="!todo.isComplete">
  {{ todo }}
</li>
```

上面的代码将只渲染未完成的 todo。

3. <font color=green>而如果你的目的是有条件地跳过循环的执行，那么可以将 v-if 置于外层元素 (或 <template>) 上</font>。
如：

```
<ul v-if="todos.length">
  <li v-for="todo in todos">
    {{ todo }}
  </li>
</ul>
<p v-else>No todos left!</p>
```

### 在组件上使用 v-for
1. 在自定义组件上，你可以像在任何普通元素上一样使用 v-for。

```
<my-component v-for="item in items" :key="item.id"></my-component>
```

2. 2.2.0+ 的版本里，<font color=red>当在组件上使用 v-for 时，key 现在是必须的</font>。

3. 然而，<font color=red>任何数据都不会被自动传递到组件里，因为组件有自己独立的作用域</font>。
为了把迭代数据传递到组件里，我们要使用 prop：
<font color=green>(等于说是为组件添加了一个属性,而属性值正好等于父作用域的值.js似乎都是引用传递,而不是值传递.)</font>

```
<my-component
  v-for="(item, index) in items"
  v-bind:item="item"
  v-bind:index="index"
  v-bind:key="item.id"
></my-component>
```

	不自动将 item 注入到组件里的原因是，这会使得组件与 v-for 的运作紧密耦合。
明确组件数据的来源能够使组件在其他场合重复使用。

4. 下面是一个简单的 todo 列表的完整例子：

```
<div id="todo-list-example">
  <form v-on:submit.prevent="addNewTodo">
    <label for="new-todo">Add a todo</label>
    <input
      v-model="newTodoText"
      id="new-todo"
      placeholder="E.g. Feed the cat"
    >
    <button>Add</button>
  </form>
  <ul>
    <li
      is="todo-item"
      v-for="(todo, index) in todos"
      v-bind:key="todo.id"
      v-bind:title="todo.title"
      v-on:remove="todos.splice(index, 1)"
    ></li>
  </ul>
</div>
```

	1. 注意这里的 is="todo-item" attribute。这种做法在使用 DOM 模板时是十分必要的，
	因为在 <ul> 元素内只有 <li> 元素会被看作有效内容。
	
	2. 这样做实现的效果与 <todo-item> 相同，但是可以避开一些潜在的浏览器解析错误。
	
	3. 查看 DOM 模板解析说明来了解更多信息。

5. 
```
Vue.component('todo-item', {
  template: '\
    <li>\
      {{ title }}\
      <button v-on:click="$emit(\'remove\')">Remove</button>\
    </li>\
  ',
  props: ['title']
})

new Vue({
  el: '#todo-list-example',
  data: {
    newTodoText: '',
    todos: [
      {
        id: 1,
        title: 'Do the dishes',
      },
      {
        id: 2,
        title: 'Take out the trash',
      },
      {
        id: 3,
        title: 'Mow the lawn'
      }
    ],
    nextTodoId: 4
  },
  methods: {
    addNewTodo: function () {
      this.todos.push({
        id: this.nextTodoId++,
        title: this.newTodoText
      })
      this.newTodoText = ''
    }
  }
})
```
