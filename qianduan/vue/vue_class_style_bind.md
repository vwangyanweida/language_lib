 
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

Class 与 Style 绑定

TPshop 中国免费商城系统 - 搜豹商城系统 - 免费50小时 Vue 视频教程立即查看 >

操作元素的 class 列表和内联样式是数据绑定的一个常见需求。因为它们都是 attribute，所以我们可以用 v-bind 处理它们：只需要通过
表达式计算出字符串结果即可。不过，字符串拼接麻烦且易错。因此，在将 v-bind 用于 class 和 style 时，Vue.js 做了专门的增强。表
达式结果的类型除了字符串之外，还可以是对象或数组。

 绑定 HTML Class

观看本节视频讲解

 对象语法

我们可以传给 v-bind:class 一个对象，以动态地切换 class：

<div v-bind:class="{ active: isActive }"></div>

上面的语法表示 active 这个 class 存在与否将取决于数据 property isActive 的 truthiness。

你可以在对象中传入更多字段来动态切换多个 class。此外，v-bind:class 指令也可以与普通的 class attribute 共存。当有如下模板：

<div
  class="static"
  v-bind:class="{ active: isActive, 'text-danger': hasError }"
></div>

和如下 data：

data: {
  isActive: true,
  hasError: false
}

结果渲染为：

<div class="static active"></div>

当 isActive 或者 hasError 变化时，class 列表将相应地更新。例如，如果 hasError 的值为 true，class 列表将变为 "static active
text-danger"。

绑定的数据对象不必内联定义在模板里：

<div v-bind:class="classObject"></div>

data: {
  classObject: {
    active: true,
    'text-danger': false
  }
}

渲染的结果和上面一样。我们也可以在这里绑定一个返回对象的计算属性。这是一个常用且强大的模式：

<div v-bind:class="classObject"></div>

data: {
  isActive: true,
  error: null
},
computed: {
  classObject: function () {
    return {
      active: this.isActive && !this.error,
      'text-danger': this.error && this.error.type === 'fatal'
    }
  }
}

 数组语法

我们可以把一个数组传给 v-bind:class，以应用一个 class 列表：

<div v-bind:class="[activeClass, errorClass]"></div>

data: {
  activeClass: 'active',
  errorClass: 'text-danger'
}

渲染为：

<div class="active text-danger"></div>

如果你也想根据条件切换列表中的 class，可以用三元表达式：

<div v-bind:class="[isActive ? activeClass : '', errorClass]"></div>

这样写将始终添加 errorClass，但是只有在 isActive 是 truthy^[1] 时才添加 activeClass。

不过，当有多个条件 class 时这样写有些繁琐。所以在数组语法中也可以使用对象语法：

<div v-bind:class="[{ active: isActive }, errorClass]"></div>

 用在组件上

    这个章节假设你已经对 Vue 组件有一定的了解。当然你也可以先跳过这里，稍后再回过头来看。

当在一个自定义组件上使用 class property 时，这些 class 将被添加到该组件的根元素上面。这个元素上已经存在的 class 不会被覆盖
。

例如，如果你声明了这个组件：

Vue.component('my-component', {
  template: '<p class="foo bar">Hi</p>'
})

然后在使用它的时候添加一些 class：

<my-component class="baz boo"></my-component>

HTML 将被渲染为：

<p class="foo bar baz boo">Hi</p>

对于带数据绑定 class 也同样适用：

<my-component v-bind:class="{ active: isActive }"></my-component>

当 isActive 为 truthy^[1] 时，HTML 将被渲染成为：

<p class="foo bar active">Hi</p>

 绑定内联样式

 对象语法

v-bind:style 的对象语法十分直观——看着非常像 CSS，但其实是一个 JavaScript 对象。CSS property 名可以用驼峰式 (camelCase) 或短
横线分隔 (kebab-case，记得用引号括起来) 来命名：

<div v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>

data: {
  activeColor: 'red',
  fontSize: 30
}

直接绑定到一个样式对象通常更好，这会让模板更清晰：

<div v-bind:style="styleObject"></div>

data: {
  styleObject: {
    color: 'red',
    fontSize: '13px'
  }
}

同样的，对象语法常常结合返回对象的计算属性使用。

 数组语法

v-bind:style 的数组语法可以将多个样式对象应用到同一个元素上：

<div v-bind:style="[baseStyles, overridingStyles]"></div>

 自动添加前缀

当 v-bind:style 使用需要添加浏览器引擎前缀的 CSS property 时，如 transform，Vue.js 会自动侦测并添加相应的前缀。

 多重值

    2.3.0+

从 2.3.0 起你可以为 style 绑定中的 property 提供一个包含多个值的数组，常用于提供多个带前缀的值，例如：

<div :style="{ display: ['-webkit-box', '-ms-flexbox', 'flex'] }"></div>

这样写只会渲染数组中最后一个被浏览器支持的值。在本例中，如果浏览器支持不带浏览器前缀的 flexbox，那么就只会渲染 display:
flex。


译者注
[1] truthy 不是 true，详见 MDN 的解释。

← 计算属性和侦听器条件渲染 →
发现错误？想参与编辑？在 GitHub 上编辑此页！
