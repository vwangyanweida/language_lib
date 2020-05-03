 
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

组件注册

TPshop 中国免费商城系统 - 搜豹商城系统 - 免费50小时 Vue 视频教程立即查看 >


    该页面假设你已经阅读过了组件基础。如果你还对组件不太了解，推荐你先阅读它。

观看本节视频讲解

 组件名

在注册一个组件的时候，我们始终需要给它一个名字。比如在全局注册的时候我们已经看到了：

Vue.component('my-component-name', { /* ... */ })

该组件名就是 Vue.component 的第一个参数。

你给予组件的名字可能依赖于你打算拿它来做什么。当直接在 DOM 中使用一个组件 (而不是在字符串模板或单文件组件) 的时候，我们强烈
推荐遵循 W3C 规范中的自定义组件名 (字母全小写且必须包含一个连字符)。这会帮助你避免和当前以及未来的 HTML 元素相冲突。

你可以在风格指南中查阅到关于组件名的其它建议。

 组件名大小写

定义组件名的方式有两种：

 使用 kebab-case

Vue.component('my-component-name', { /* ... */ })

当使用 kebab-case (短横线分隔命名) 定义一个组件时，你也必须在引用这个自定义元素时使用 kebab-case，例如 <my-component-name>
。

 使用 PascalCase

Vue.component('MyComponentName', { /* ... */ })

当使用 PascalCase (首字母大写命名) 定义一个组件时，你在引用这个自定义元素时两种命名法都可以使用。也就是说
<my-component-name> 和 <MyComponentName> 都是可接受的。注意，尽管如此，直接在 DOM (即非字符串的模板) 中使用时只有
kebab-case 是有效的。

 全局注册

到目前为止，我们只用过 Vue.component 来创建组件：

Vue.component('my-component-name', {
  // ... 选项 ...
})

这些组件是全局注册的。也就是说它们在注册之后可以用在任何新创建的 Vue 根实例 (new Vue) 的模板中。比如：

Vue.component('component-a', { /* ... */ })
Vue.component('component-b', { /* ... */ })
Vue.component('component-c', { /* ... */ })

new Vue({ el: '#app' })

<div id="app">
  <component-a></component-a>
  <component-b></component-b>
  <component-c></component-c>
</div>

在所有子组件中也是如此，也就是说这三个组件在各自内部也都可以相互使用。

 局部注册

全局注册往往是不够理想的。比如，如果你使用一个像 webpack 这样的构建系统，全局注册所有的组件意味着即便你已经不再使用一个组件
了，它仍然会被包含在你最终的构建结果中。这造成了用户下载的 JavaScript 的无谓的增加。

在这些情况下，你可以通过一个普通的 JavaScript 对象来定义组件：

var ComponentA = { /* ... */ }
var ComponentB = { /* ... */ }
var ComponentC = { /* ... */ }

然后在 components 选项中定义你想要使用的组件：

new Vue({
  el: '#app',
  components: {
    'component-a': ComponentA,
    'component-b': ComponentB
  }
})

对于 components 对象中的每个 property 来说，其 property 名就是自定义元素的名字，其 property 值就是这个组件的选项对象。

注意局部注册的组件在其子组件中不可用。例如，如果你希望 ComponentA 在 ComponentB 中可用，则你需要这样写：

var ComponentA = { /* ... */ }

var ComponentB = {
  components: {
    'component-a': ComponentA
  },
  // ...
}

或者如果你通过 Babel 和 webpack 使用 ES2015 模块，那么代码看起来更像：

import ComponentA from './ComponentA.vue'

export default {
  components: {
    ComponentA
  },
  // ...
}

注意在 ES2015+ 中，在对象中放一个类似 ComponentA 的变量名其实是 ComponentA: ComponentA 的缩写，即这个变量名同时是：

  • 用在模板中的自定义元素的名称
  • 包含了这个组件选项的变量名

 模块系统

如果你没有通过 import/require 使用一个模块系统，也许可以暂且跳过这个章节。如果你使用了，那么我们会为你提供一些特殊的使用说
明和注意事项。

 在模块系统中局部注册

如果你还在阅读，说明你使用了诸如 Babel 和 webpack 的模块系统。在这些情况下，我们推荐创建一个 components 目录，并将每个组件
放置在其各自的文件中。

然后你需要在局部注册之前导入每个你想使用的组件。例如，在一个假设的 ComponentB.js 或 ComponentB.vue 文件中：

import ComponentA from './ComponentA'
import ComponentC from './ComponentC'

export default {
  components: {
    ComponentA,
    ComponentC
  },
  // ...
}

现在 ComponentA 和 ComponentC 都可以在 ComponentB 的模板中使用了。

 基础组件的自动化全局注册

可能你的许多组件只是包裹了一个输入框或按钮之类的元素，是相对通用的。我们有时候会把它们称为基础组件，它们会在各个组件中被频
繁的用到。

所以会导致很多组件里都会有一个包含基础组件的长列表：

import BaseButton from './BaseButton.vue'
import BaseIcon from './BaseIcon.vue'
import BaseInput from './BaseInput.vue'

export default {
  components: {
    BaseButton,
    BaseIcon,
    BaseInput
  }
}

而只是用于模板中的一小部分：

<BaseInput
  v-model="searchText"
  @keydown.enter="search"
/>
<BaseButton @click="search">
  <BaseIcon name="search"/>
</BaseButton>

如果你恰好使用了 webpack (或在内部使用了 webpack 的 Vue CLI 3+)，那么就可以使用 require.context 只全局注册这些非常通用的基
础组件。这里有一份可以让你在应用入口文件 (比如 src/main.js) 中全局导入基础组件的示例代码：

import Vue from 'vue'
import upperFirst from 'lodash/upperFirst'
import camelCase from 'lodash/camelCase'

const requireComponent = require.context(
  // 其组件目录的相对路径
  './components',
  // 是否查询其子目录
  false,
  // 匹配基础组件文件名的正则表达式
  /Base[A-Z]\w+\.(vue|js)$/
)

requireComponent.keys().forEach(fileName => {
  // 获取组件配置
  const componentConfig = requireComponent(fileName)

  // 获取组件的 PascalCase 命名
  const componentName = upperFirst(
    camelCase(
      // 获取和目录深度无关的文件名
      fileName
        .split('/')
        .pop()
        .replace(/\.\w+$/, '')
    )
  )

  // 全局注册组件
  Vue.component(
    componentName,
    // 如果这个组件选项是通过 `export default` 导出的，
    // 那么就会优先使用 `.default`，
    // 否则回退到使用模块的根。
    componentConfig.default || componentConfig
  )
})

记住全局注册的行为必须在根 Vue 实例 (通过 new Vue) 创建之前发生。这里有一个真实项目情景下的示例。

← 组件基础 Prop →
发现错误？想参与编辑？在 GitHub 上编辑此页！
