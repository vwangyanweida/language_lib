 
vue logo Vue.js

  • [                    ]
  • 学习
      □ 文档

      □ 
          ☆ 教程
          ☆ API
          ☆ 风格指南
          ☆ 示例
          ☆ Cookbook
      □ 视频教程

      □ 
          ☆ Vue Mastery (英文)
          ☆ Vue School (英文)
          ☆ DCloud 视频教程
  • 生态系统
      □ 帮助

      □ 
          ☆ 论坛
          ☆ 聊天室
          ☆ 聚会
      □ 工具

      □ 
          ☆ Devtools
          ☆ Vue CLI
          ☆ Vue Loader
      □ 核心插件

      □ 
          ☆ Vue Router
          ☆ Vuex
          ☆ Vue 服务端渲染
      □ 信息

      □ 
          ☆ 周刊
          ☆ Roadmap
          ☆ 活动
          ☆ Twitter
          ☆ 博客
          ☆ 工作
  • 团队
  • 资源列表
      □ 合作伙伴
      □ 主题
      □ Awesome Vue
      □ 浏览和 Vue 相关的包
  • 支持 Vue
      □ 一次性赞助
      □ 周期性赞助
      □ 贴纸
      □ 周边
      □ T 恤商店
  • 多语言
      □ English
      □ 日本語
      □ Русский
      □ 한국어
      □ Português
      □ Français
      □ Tiếng Việt
      □ Español
      □ Bahasa Indonesia
  • 参与翻译

特别赞助商
[dcloud]
[imooc-spon]

教程 [2.x ]

  • 基础

  • 安装
  • 介绍
  • Vue 实例
  • 模板语法
  • 计算属性和侦听器
  • Class 与 Style 绑定
  • 条件渲染
  • 列表渲染
  • 事件处理
  • 表单输入绑定
  • 组件基础
  • 深入了解组件

  • 组件注册
  • Prop
  • 自定义事件
  • 插槽
  • 动态组件 & 异步组件
  • 处理边界情况
  • 过渡 & 动画

  • 进入/离开 & 列表过渡
  • 状态过渡
  • 可复用性 & 组合

  • 混入
  • 自定义指令
  • 渲染函数 & JSX
  • 插件
  • 过滤器
  • 工具

  • 单文件组件
  • 单元测试
  • TypeScript 支持
  • 生产环境部署
  • 规模化

  • 路由
  • 状态管理
  • 服务端渲染
  • 安全
  • 内在

  • 深入响应式原理
  • 迁移

  • 从 Vue 1.x 迁移
  • 从 Vue Router 0.7.x 迁移
  • 从 Vuex 0.6.x 迁移到 1.0
  • 更多

  • 对比其他框架
  • 加入 Vue.js 社区
  • 认识团队

广告 Vue.js实战项目开发教程

列表渲染

TPshop 中国免费商城系统 - 搜豹商城系统 - 免费50小时 Vue 视频教程立即查看 >

 用 v-for 把一个数组对应为一组元素

观看本节视频讲解

我们可以用 v-for 指令基于一个数组来渲染一个列表。v-for 指令需要使用 item in items 形式的特殊语法，其中 items 是源数据数组，
而 item 则是被迭代的数组元素的别名。

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

结果：

  • {{item.message}}

在 v-for 块中，我们可以访问所有父作用域的 property。v-for 还支持一个可选的第二个参数，即当前项的索引。

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

结果：

  • {{ parentMessage }} - {{ index }} - {{ item.message }}

你也可以用 of 替代 in 作为分隔符，因为它更接近 JavaScript 迭代器的语法：

<div v-for="item of items"></div>

 在 v-for 里使用对象

你也可以用 v-for 来遍历一个对象的 property。

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

结果：

  • {{ value }}

你也可以提供第二个的参数为 property 名称 (也就是键名)：

<div v-for="(value, name) in object">
  {{ name }}: {{ value }}
</div>

{{ name }}: {{ value }}

还可以用第三个参数作为索引：

<div v-for="(value, name, index) in object">
  {{ index }}. {{ name }}: {{ value }}
</div>

{{ index }}. {{ name }}: {{ value }}

在遍历对象时，会按 Object.keys() 的结果遍历，但是不能保证它的结果在不同的 JavaScript 引擎下都一致。

 维护状态

当 Vue 正在更新使用 v-for 渲染的元素列表时，它默认使用“就地更新”的策略。如果数据项的顺序被改变，Vue 将不会移动 DOM 元素来匹
配数据项的顺序，而是就地更新每个元素，并且确保它们在每个索引位置正确渲染。这个类似 Vue 1.x 的 track-by="$index"。

这个默认的模式是高效的，但是只适用于不依赖子组件状态或临时 DOM 状态 (例如：表单输入值) 的列表渲染输出。

为了给 Vue 一个提示，以便它能跟踪每个节点的身份，从而重用和重新排序现有元素，你需要为每项提供一个唯一 key attribute：

<div v-for="item in items" v-bind:key="item.id">
  <!-- 内容 -->
</div>

建议尽可能在使用 v-for 时提供 key attribute，除非遍历输出的 DOM 内容非常简单，或者是刻意依赖默认行为以获取性能上的提升。

因为它是 Vue 识别节点的一个通用机制，key 并不仅与 v-for 特别关联。后面我们将在指南中看到，它还具有其它用途。

不要使用对象或数组之类的非基本类型值作为 v-for 的 key。请用字符串或数值类型的值。

更多 key attribute 的细节用法请移步至 key 的 API 文档。

 数组更新检测

 变更方法

Vue 将被侦听的数组的变更方法进行了包裹，所以它们也将会触发视图更新。这些被包裹过的方法包括：

  • push()
  • pop()
  • shift()
  • unshift()
  • splice()
  • sort()
  • reverse()

你可以打开控制台，然后对前面例子的 items 数组尝试调用变更方法。比如 example1.items.push({ message: 'Baz' })。

 替换数组

变更方法，顾名思义，会变更调用了这些方法的原始数组。相比之下，也有非变更方法，例如 filter()、concat() 和 slice()。它们不会
变更原始数组，而总是返回一个新数组。当使用非变更方法时，可以用新数组替换旧数组：

example1.items = example1.items.filter(function (item) {
  return item.message.match(/Foo/)
})

你可能认为这将导致 Vue 丢弃现有 DOM 并重新渲染整个列表。幸运的是，事实并非如此。Vue 为了使得 DOM 元素得到最大范围的重用而实
现了一些智能的启发式方法，所以用一个含有相同元素的数组去替换原来的数组是非常高效的操作。

 注意事项

由于 JavaScript 的限制，Vue 不能检测数组和对象的变化。深入响应式原理中有相关的讨论。

 显示过滤/排序后的结果

有时，我们想要显示一个数组经过过滤或排序后的版本，而不实际变更或重置原始数据。在这种情况下，可以创建一个计算属性，来返回过
滤或排序后的数组。

例如：

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

在计算属性不适用的情况下 (例如，在嵌套 v-for 循环中) 你可以使用一个方法：

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

 在 v-for 里使用值范围

v-for 也可以接受整数。在这种情况下，它会把模板重复对应次数。

<div>
  <span v-for="n in 10">{{ n }} </span>
</div>

结果：

{{ n }}

 在 <template> 上使用 v-for

类似于 v-if，你也可以利用带有 v-for 的 <template> 来循环渲染一段包含多个元素的内容。比如：

<ul>
  <template v-for="item in items">
    <li>{{ item.msg }}</li>
    <li class="divider" role="presentation"></li>
  </template>
</ul>

 v-for 与 v-if 一同使用

注意我们不推荐在同一元素上使用 v-if 和 v-for。更多细节可查阅风格指南。

当它们处于同一节点，v-for 的优先级比 v-if 更高，这意味着 v-if 将分别重复运行于每个 v-for 循环中。当你只想为部分项渲染节点时
，这种优先级的机制会十分有用，如下：

<li v-for="todo in todos" v-if="!todo.isComplete">
  {{ todo }}
</li>

上面的代码将只渲染未完成的 todo。

而如果你的目的是有条件地跳过循环的执行，那么可以将 v-if 置于外层元素 (或 <template>) 上。如：

<ul v-if="todos.length">
  <li v-for="todo in todos">
    {{ todo }}
  </li>
</ul>
<p v-else>No todos left!</p>

 在组件上使用 v-for

    这部分内容假定你已经了解组件相关知识。你也完全可以先跳过它，以后再回来查看。

在自定义组件上，你可以像在任何普通元素上一样使用 v-for。

<my-component v-for="item in items" :key="item.id"></my-component>

    2.2.0+ 的版本里，当在组件上使用 v-for 时，key 现在是必须的。

然而，任何数据都不会被自动传递到组件里，因为组件有自己独立的作用域。为了把迭代数据传递到组件里，我们要使用 prop：

<my-component
  v-for="(item, index) in items"
  v-bind:item="item"
  v-bind:index="index"
  v-bind:key="item.id"
></my-component>

不自动将 item 注入到组件里的原因是，这会使得组件与 v-for 的运作紧密耦合。明确组件数据的来源能够使组件在其他场合重复使用。

下面是一个简单的 todo 列表的完整例子：

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

注意这里的 is="todo-item" attribute。这种做法在使用 DOM 模板时是十分必要的，因为在 <ul> 元素内只有 <li> 元素会被看作有效内
容。这样做实现的效果与 <todo-item> 相同，但是可以避开一些潜在的浏览器解析错误。查看 DOM 模板解析说明来了解更多信息。

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

Add a todo [                    ] Add
  • 

← 条件渲染事件处理 →
发现错误？想参与编辑？在 GitHub 上编辑此页！
