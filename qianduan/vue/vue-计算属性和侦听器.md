 
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

计算属性和侦听器

TPshop 中国免费商城系统 - 搜豹商城系统 - 免费50小时 Vue 视频教程立即查看 >

 计算属性

模板内的表达式非常便利，但是设计它们的初衷是用于简单运算的。在模板中放入太多的逻辑会让模板过重且难以维护。例如：

<div id="example">
  {{ message.split('').reverse().join('') }}
</div>

在这个地方，模板不再是简单的声明式逻辑。你必须看一段时间才能意识到，这里是想要显示变量 message 的翻转字符串。当你想要在模板
中多包含此处的翻转字符串时，就会更加难以处理。

所以，对于任何复杂逻辑，你都应当使用计算属性。

 基础例子

<div id="example">
  <p>Original message: "{{ message }}"</p>
  <p>Computed reversed message: "{{ reversedMessage }}"</p>
</div>

var vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    // 计算属性的 getter
    reversedMessage: function () {
      // `this` 指向 vm 实例
      return this.message.split('').reverse().join('')
    }
  }
})

结果：

Original message: "{{ message }}"

Computed reversed message: "{{ reversedMessage }}"

这里我们声明了一个计算属性 reversedMessage。我们提供的函数将用作 property vm.reversedMessage 的 getter 函数：

console.log(vm.reversedMessage) // => 'olleH'
vm.message = 'Goodbye'
console.log(vm.reversedMessage) // => 'eybdooG'

你可以打开浏览器的控制台，自行修改例子中的 vm。vm.reversedMessage 的值始终取决于 vm.message 的值。

你可以像绑定普通 property 一样在模板中绑定计算属性。Vue 知道 vm.reversedMessage 依赖于 vm.message，因此当 vm.message 发生改
变时，所有依赖 vm.reversedMessage 的绑定也会更新。而且最妙的是我们已经以声明的方式创建了这种依赖关系：计算属性的 getter 函
数是没有副作用 (side effect) 的，这使它更易于测试和理解。

 计算属性缓存 vs 方法

你可能已经注意到我们可以通过在表达式中调用方法来达到同样的效果：

<p>Reversed message: "{{ reversedMessage() }}"</p>

// 在组件中
methods: {
  reversedMessage: function () {
    return this.message.split('').reverse().join('')
  }
}

我们可以将同一函数定义为一个方法而不是一个计算属性。两种方式的最终结果确实是完全相同的。然而，不同的是计算属性是基于它们的
响应式依赖进行缓存的。只在相关响应式依赖发生改变时它们才会重新求值。这就意味着只要 message 还没有发生改变，多次访问
reversedMessage 计算属性会立即返回之前的计算结果，而不必再次执行函数。

这也同样意味着下面的计算属性将不再更新，因为 Date.now() 不是响应式依赖：

computed: {
  now: function () {
    return Date.now()
  }
}

相比之下，每当触发重新渲染时，调用方法将总会再次执行函数。

我们为什么需要缓存？假设我们有一个性能开销比较大的计算属性 A，它需要遍历一个巨大的数组并做大量的计算。然后我们可能有其他的
计算属性依赖于 A。如果没有缓存，我们将不可避免的多次执行 A 的 getter！如果你不希望有缓存，请用方法来替代。

 计算属性 vs 侦听属性

Vue 提供了一种更通用的方式来观察和响应 Vue 实例上的数据变动：侦听属性。当你有一些数据需要随着其它数据变动而变动时，你很容易
滥用 watch——特别是如果你之前使用过 AngularJS。然而，通常更好的做法是使用计算属性而不是命令式的 watch 回调。细想一下这个例子
：

<div id="demo">{{ fullName }}</div>

var vm = new Vue({
  el: '#demo',
  data: {
    firstName: 'Foo',
    lastName: 'Bar',
    fullName: 'Foo Bar'
  },
  watch: {
    firstName: function (val) {
      this.fullName = val + ' ' + this.lastName
    },
    lastName: function (val) {
      this.fullName = this.firstName + ' ' + val
    }
  }
})

上面代码是命令式且重复的。将它与计算属性的版本进行比较：

var vm = new Vue({
  el: '#demo',
  data: {
    firstName: 'Foo',
    lastName: 'Bar'
  },
  computed: {
    fullName: function () {
      return this.firstName + ' ' + this.lastName
    }
  }
})

好得多了，不是吗？

 计算属性的 setter

计算属性默认只有 getter，不过在需要时你也可以提供一个 setter：

// ...
computed: {
  fullName: {
    // getter
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
// ...

现在再运行 vm.fullName = 'John Doe' 时，setter 会被调用，vm.firstName 和 vm.lastName 也会相应地被更新。

 侦听器

虽然计算属性在大多数情况下更合适，但有时也需要一个自定义的侦听器。这就是为什么 Vue 通过 watch 选项提供了一个更通用的方法，
来响应数据的变化。当需要在数据变化时执行异步或开销较大的操作时，这个方式是最有用的。

例如：

<div id="watch-example">
  <p>
    Ask a yes/no question:
    <input v-model="question">
  </p>
  <p>{{ answer }}</p>
</div>

<!-- 因为 AJAX 库和通用工具的生态已经相当丰富，Vue 核心代码没有重复 -->
<!-- 提供这些功能以保持精简。这也可以让你自由选择自己更熟悉的工具。 -->
<script src="https://cdn.jsdelivr.net/npm/axios@0.12.0/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.13.1/lodash.min.js"></script>
<script>
var watchExampleVM = new Vue({
  el: '#watch-example',
  data: {
    question: '',
    answer: 'I cannot give you an answer until you ask a question!'
  },
  watch: {
    // 如果 `question` 发生改变，这个函数就会运行
    question: function (newQuestion, oldQuestion) {
      this.answer = 'Waiting for you to stop typing...'
      this.debouncedGetAnswer()
    }
  },
  created: function () {
    // `_.debounce` 是一个通过 Lodash 限制操作频率的函数。
    // 在这个例子中，我们希望限制访问 yesno.wtf/api 的频率
    // AJAX 请求直到用户输入完毕才会发出。想要了解更多关于
    // `_.debounce` 函数 (及其近亲 `_.throttle`) 的知识，
    // 请参考：https://lodash.com/docs#debounce
    this.debouncedGetAnswer = _.debounce(this.getAnswer, 500)
  },
  methods: {
    getAnswer: function () {
      if (this.question.indexOf('?') === -1) {
        this.answer = 'Questions usually contain a question mark. ;-)'
        return
      }
      this.answer = 'Thinking...'
      var vm = this
      axios.get('https://yesno.wtf/api')
        .then(function (response) {
          vm.answer = _.capitalize(response.data.answer)
        })
        .catch(function (error) {
          vm.answer = 'Error! Could not reach the API. ' + error
        })
    }
  }
})
</script>

结果：

Ask a yes/no question: [                    ]

{{ answer }}

在这个示例中，使用 watch 选项允许我们执行异步操作 (访问一个 API)，限制我们执行该操作的频率，并在我们得到最终结果前，设置中
间状态。这些都是计算属性无法做到的。

除了 watch 选项之外，您还可以使用命令式的 vm.$watch API。

← 模板语法 Class 与 Style 绑定 →
发现错误？想参与编辑？在 GitHub 上编辑此页！
