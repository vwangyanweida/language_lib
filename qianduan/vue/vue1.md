## 介绍
### Vue.js 是什么
1. Vue (读音 /vjuː/，类似于 view) 是一套用于构建用户界面的渐进式框架。
与其它大型框架不同的是，Vue 被设计为可以自底向上逐层应用。Vue 的核心库只关注视图层，
不仅易于上手，还便于与第三方库或既有项目整合。
另一方面，当与现代化的工具链以及各种支持类库结合使用时，Vue 也完全能够为复杂的单页应用提供驱动。

### 起步
1. 官方指南假设你已了解关于 HTML、CSS 和 JavaScript 的中级知识。
如果你刚开始学习前端开发，将框架作为你的第一步可能不是最好的主
意——掌握好基础知识再来吧！之前有其它框架的使用经验会有帮助，但这不是必需的。

2. 安装
	1. 尝试 Vue.js 最简单的方法是使用 Hello World 例子。
	你可以在浏览器新标签页中打开它，跟着例子学习一些基础用法。或者你也可以创建
	一个 .html 文件，然后通过如下方式引入 Vue：
	```
	<!-- 开发环境版本，包含了有帮助的命令行警告 -->
	<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
	```

	或者：
	```
	<!-- 生产环境版本，优化了尺寸和速度 -->
	<script src="https://cdn.jsdelivr.net/npm/vue"></script>
	```

	2. 安装教程给出了更多安装 Vue 的方式。请注意我们不推荐新手直接使用 vue-cli，
	尤其是在你还不熟悉基于 Node.js 的构建工具时。

### 声明式渲染
1. Vue.js 的核心是一个允许采用简洁的模板语法来声明式地将数据渲染进 DOM 的系统：
```
<div id="app">
  {{ message }}
</div>

var app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!'
  }
})
```

2. 我们已经成功创建了第一个 Vue 应用！看起来这跟渲染一个字符串模板非常类似，但是 Vue 在背后做了大量工作。
现在数据和 DOM 已经被建立了关联，所有东西都是响应式的。
我们要怎么确认呢？打开你的浏览器的 JavaScript 控制台 (就在这个页面打开)，
并修改app.message 的值，你将看到上例相应地更新。

	注意我们不再和 HTML 直接交互了。一个 Vue 应用会将其挂载到一个 DOM 元素上 (对于这个例子是 #app) 然后对其进行完
全控制。那个HTML 是我们的入口，但其余都会发生在新创建的 Vue 实例内部。

3. 除了文本插值，我们还可以像这样来绑定元素 attribute：
```
<div id="app-2">
  <span v-bind:title="message">
    鼠标悬停几秒钟查看此处动态绑定的提示信息！
  </span>
</div>

var app2 = new Vue({
  el: '#app-2',
  data: {
    message: '页面加载于 ' + new Date().toLocaleString()
  }
})
```

	鼠标悬停几秒钟查看此处动态绑定的提示信息！

	这里我们遇到了一点新东西。你看到的 v-bind attribute 被称为指令。指令带有前缀 v-，以表示它们是 
Vue 提供的特殊 attribute。可能你已经猜到了，它们会在渲染的 DOM
上应用特殊的响应式行为。在这里，该指令的意思是：“将这个元素节点的 title attribute 和 Vue
实例的 message property 保持一致”。

如果你再次打开浏览器的 JavaScript 控制台，输入 app2.message = '新消息'，
就会再一次看到这个绑定了 title attribute 的 HTML 已经进行了更新。

### 条件与循环
1. 控制切换一个元素是否显示也相当简单：
```
<div id="app-3">
  <p v-if="seen">现在你看到我了</p>
</div>

var app3 = new Vue({
  el: '#app-3',
  data: {
    seen: true
  }
})
```

	继续在控制台输入 app3.seen = false，你会发现之前显示的消息消失了。

	这个例子演示了我们不仅可以把数据绑定到 DOM 文本或 attribute，还可以绑定到 DOM 结构。
此外，Vue 也提供一个强大的过渡效果系统，可以在 Vue 插入/更新/移除元素时自动应用过渡效果。

2. 还有其它很多指令，每个都有特殊的功能。例如，v-for 指令可以绑定数组的数据来渲染一个项目列表：
```
<div id="app-4">
  <ol>
    <li v-for="todo in todos">
      {{ todo.text }}
    </li>
  </ol>
</div>

var app4 = new Vue({
  el: '#app-4',
  data: {
    todos: [
      { text: '学习 JavaScript' },
      { text: '学习 Vue' },
      { text: '整个牛项目' }
    ]
  }
})
```

1. {{ todo.text }}
在控制台里，输入 app4.todos.push({ text: '新项目' })，你会发现列表最后添加了一个新项目。

### 处理用户输入
1. 为了让用户和你的应用进行交互，我们可以用 v-on 指令添加一个事件监听器，通过它调用在 Vue 实例中定义的方法：
```
<div id="app-5">
  <p>{{ message }}</p>
  <button v-on:click="reverseMessage">反转消息</button>
</div>

var app5 = new Vue({
  el: '#app-5',
  data: {
    message: 'Hello Vue.js!'
  },
  methods: {
    reverseMessage: function () {
      this.message = this.message.split('').reverse().join('')
    }
  }
})
```

2. 逆转消息
	注意在 reverseMessage 方法中，我们更新了应用的状态，
但没有触碰 DOM——所有的 DOM 操作都由 Vue 来处理，你编写的代码只需要关注逻辑层面即可。

3. Vue 还提供了**v-model**指令，它能轻松实现表单输入和应用状态之间的双向绑定。
```
<div id="app-6">
  <p>{{ message }}</p>
  <input v-model="message">
</div>

var app6 = new Vue({
  el: '#app-6',
  data: {
    message: 'Hello Vue!'
  }
})
```

### 组件化应用构建
1. 组件系统是 Vue 的另一个重要概念，因为它是一种抽象，允许我们使用小型、独立和通常
可复用的组件构建大型应用。仔细想想，几乎任意类型的应用界面都可以抽象为一个组件树：

2. 在 Vue 里，<font color=red>>一个组件本质上是一个拥有预定义选项的一个 Vue 实例</font。

	1. 在 Vue 中注册组件很简单：
	```
	// 定义名为 todo-item 的新组件
	Vue.component('todo-item', {
	  template: '<li>这是个待办项</li>'
	})

	var app = new Vue(...)
	```

	2. 现在你可以用它构建另一个组件模板：

	```
	<ol>
	  <!-- 创建一个 todo-item 组件的实例 -->
	  <todo-item></todo-item>
	</ol>
	```

	3. 但是这样会为每个待办项渲染同样的文本，这看起来并不炫酷。
	我们应该能从父作用域将数据传到子组件才对。让我们来修改一下组件的定义，使之能够接受一个 prop：

	```
	Vue.component('todo-item', {
	  // todo-item 组件现在接受一个
	  // "prop"，类似于一个自定义 attribute。
	  // 这个 prop 名为 todo。
	  props: ['todo'],
	  template: '<li>{{ todo.text }}</li>'
	})
	```

	4. 现在，我们可以使用 v-bind 指令将待办项传到循环输出的每个组件中：

	```
	<div id="app-7">
	  <ol>
		<!--
		  现在我们为每个 todo-item 提供 todo 对象
		  todo 对象是变量，即其内容可以是动态的。
		  我们也需要为每个组件提供一个“key”，稍后再
		  作详细解释。
		-->
		<todo-item
		  v-for="item in groceryList"
		  v-bind:todo="item"
		  v-bind:key="item.id"
		></todo-item>
	  </ol>
	</div>

	Vue.component('todo-item', {
	  props: ['todo'],
	  template: '<li>{{ todo.text }}</li>'
	})

	var app7 = new Vue({
	  el: '#app-7',
	  data: {
		groceryList: [
		  { id: 0, text: '蔬菜' },
		  { id: 1, text: '奶酪' },
		  { id: 2, text: '随便其它什么人吃的东西' }
		]
	  }
	})
	```

	4. 尽管这只是一个刻意设计的例子，但是我们已经设法将应用分割成了两个更小的单元。
	子单元通过 prop 接口与父单元进行了良好的解耦。我们现在可以进一步改进 <todo-item> 组件，
	提供更为复杂的模板和逻辑，而不会影响到父单元。

	5. 在一个大型应用中，有必要将整个应用程序划分为组件，以使开发更易管理。
	在后续教程中我们将详述组件，不过这里有一个 (假想的) 例子，以展示使用了组件的应用模板是什么样的：

	```
	<div id="app">
	  <app-nav></app-nav>
	  <app-view>
		<app-sidebar></app-sidebar>
		<app-content></app-content>
	  </app-view>
	</div>
	```

3. 与自定义元素的关系
	你可能已经注意到 Vue 组件非常类似于自定义元素——它是 Web 组件规范的一部分，这是因为 Vue 的组件
语法部分参考了该规范。例如 Vue组件实现了 Slot API 与 is attribute。但是，还是有几个关键差别：

	1. Web Components 规范已经完成并通过，但未被所有浏览器原生实现。目前 Safari 10.1+、Chrome 54+ 和 
	Firefox 63+ 原生支持 Web Components。相比之下，Vue 组件不需要任何 polyfill，并且在所有支持的浏览器
	(IE9 及更高版本) 之下表现一致。必要时，Vue 组件也可以包装于原生自定义元素之内。

	2. Vue 组件提供了纯自定义元素所不具备的一些重要功能，最突出的是跨组件数据流、自定义事件通信以及构建工具集成。
	虽然 Vue 内部没有使用自定义元素，不过在应用使用自定义元素、或以自定义元素形式发布时，依然有很好的互操作性。
	Vue CLI 也支持将Vue 组件构建成为原生的自定义元素。

## vue 实例
1. 所有的Vue组件都是Vue实例,并且接受相同的选项对象(一些根实例特有的选项除外)

2. Vue实例将data对象中的所有的property加入到Vue的响应式系统中.
这些property改变时,视图将会产生"响应",及匹配更新为新的值.

3. 值得注意的是,只有当实例被创建时就已经存在于data中的property才是响应式的.
	- 如果Vue创建后加入的新的值,是不会触发任何视图更新的.
	- 如果需要的值一开始是空值,那么创建一个空的初始property

4. Object.freeze(obj): 阻止修改现有的property,这意味着响应系统无法再追踪变化.

5. 除了数据property,Vue实例还暴露了一些有用的实例property与方法,它们都有前缀$,以便与用户定义的property区分开来.
```
var data = {a:1}
var vm = new Vue({
	el: '#example',
	data: data
})

vm.$data === data // => true
vm.$el === document.getElementById("example") // => true

vm.$watch('a', function(newValue, oldValue) {
			//这个回调将在'vm.a' 改变后调用
})
```
### 生命周期
1. 生命周期的钩子:
	- created: 用来在一个实例被创建之后执行代码
	- mounted:
	- updated:
	- destroyed:

2. 例子
```
new Vue({
	data: {
		a: 1
	},
	created: function() {
		console.log('a is:' + this.a)
	}
})
```

3. 不要在选项property或回调上使用**箭头函数**,比如created:() => console.log(this.a) 或
vm.$watch('a', newValue=>this.myMethod());
因为箭头函数并没有this,this会作为变量一直向上词法作用域查找,直至找到为止.经常导致错误.

4. vue实例生命周期
![图片](vue_实例生命周期.png)
