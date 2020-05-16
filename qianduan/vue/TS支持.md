 
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

TypeScript 支持

TPshop 中国免费商城系统 - 搜豹商城系统 - 免费50小时 Vue 视频
教程立即查看 >


    Vue CLI 提供了内建的 TypeScript 工具支持。

 发布为 NPM 包的官方声明文件

静态类型系统能帮助你有效防止许多潜在的运行时错误，而且随着你
的应用日渐丰满会更加显著。这就是为什么 Vue 不仅仅为 Vue core
提供了针对 TypeScript 的官方类型声明，还为 Vue Router 和
Vuex 也提供了相应的声明文件。

而且，我们已经把它们发布到了 NPM，最新版本的 TypeScript 也知
道该如何自己从 NPM 包里解析类型声明。这意味着只要你成功地通
过 NPM 安装了，就不再需要任何额外的工具辅助，即可在 Vue 中使
用 TypeScript 了。

 推荐配置

// tsconfig.json
{
  "compilerOptions": {
    // 与 Vue 的浏览器支持保持一致
    "target": "es5",
    // 这可以对 `this` 上的数据 property 进行更严格的推断
    "strict": true,
    // 如果使用 webpack 2+ 或 rollup，可以利用 tree-shake:
    "module": "es2015",
    "moduleResolution": "node"
  }
}

注意你需要引入 strict: true (或者至少 noImplicitThis: true，
这是 strict 模式的一部分) 以利用组件方法中 this 的类型检查，
否则它会始终被看作 any 类型。

参阅 TypeScript 编译器选项文档 (英) 了解更多。

 开发工具链

 工程创建

Vue CLI 3 可以使用 TypeScript 生成新工程。创建方式：

# 1. 如果没有安装 Vue CLI 就先安装
npm install --global @vue/cli

# 2. 创建一个新工程，并选择 "Manually select features (手动选择特性)" 选项
vue create my-project-name

 编辑器支持

要使用 TypeScript 开发 Vue 应用程序，我们强烈建议您使用
Visual Studio Code，它为 TypeScript 提供了极好的“开箱即用”支
持。如果你正在使用单文件组件 (SFC)，可以安装提供 SFC 支持以
及其他更多实用功能的 Vetur 插件。

WebStorm 同样为 TypeScript 和 Vue 提供了“开箱即用”的支持。

 基本用法

要让 TypeScript 正确推断 Vue 组件选项中的类型，您需要使用
Vue.component 或 Vue.extend 定义组件：

import Vue from 'vue'
const Component = Vue.extend({
  // 类型推断已启用
})

const Component = {
  // 这里不会有类型推断，
  // 因为 TypeScript 不能确认这是 Vue 组件的选项
}

 基于类的 Vue 组件

如果您在声明组件时更喜欢基于类的 API，则可以使用官方维护的
vue-class-component 装饰器：

import Vue from 'vue'
import Component from 'vue-class-component'

// @Component 修饰符注明了此类为一个 Vue 组件
@Component({
  // 所有的组件选项都可以放在这里
  template: '<button @click="onClick">Click!</button>'
})
export default class MyComponent extends Vue {
  // 初始数据可以直接声明为实例的 property
  message: string = 'Hello!'

  // 组件方法也可以直接声明为实例的方法
  onClick (): void {
    window.alert(this.message)
  }
}

 增强类型以配合插件使用

插件可以增加 Vue 的全局/实例 property 和组件选项。在这些情况
下，在 TypeScript 中制作插件需要类型声明。庆幸的是，
TypeScript 有一个特性来补充现有的类型，叫做模块补充 (module
augmentation)。

例如，声明一个 string 类型的实例 property $myProperty：

// 1. 确保在声明补充的类型之前导入 'vue'
import Vue from 'vue'

// 2. 定制一个文件，设置你想要补充的类型
//    在 types/vue.d.ts 里 Vue 有构造函数类型
declare module 'vue/types/vue' {
// 3. 声明为 Vue 补充的东西
  interface Vue {
    $myProperty: string
  }
}

在你的项目中包含了上述作为声明文件的代码之后 (像
my-property.d.ts)，你就可以在 Vue 实例上使用 $myProperty 了
。

var vm = new Vue()
console.log(vm.$myProperty) // 将会顺利编译通过

你也可以声明额外的 property 和组件选项：

import Vue from 'vue'

declare module 'vue/types/vue' {
  // 可以使用 `VueConstructor` 接口
  // 来声明全局 property
  interface VueConstructor {
    $myGlobal: string
  }
}

// ComponentOptions 声明于 types/options.d.ts 之中
declare module 'vue/types/options' {
  interface ComponentOptions<V extends Vue> {
    myOption?: string
  }
}

上述的声明允许下面的代码顺利编译通过：

// 全局 property
console.log(Vue.$myGlobal)

// 额外的组件选项
var vm = new Vue({
  myOption: 'Hello'
})

 标注返回值

因为 Vue 的声明文件天生就具有循环性，TypeScript 可能在推断某
个方法的类型的时候存在困难。因此，你可能需要在 render 或
computed 里的方法上标注返回值。

import Vue, { VNode } from 'vue'

const Component = Vue.extend({
  data () {
    return {
      msg: 'Hello'
    }
  },
  methods: {
    // 需要标注有 `this` 参与运算的返回值类型
    greet (): string {
      return this.msg + ' world'
    }
  },
  computed: {
    // 需要标注
    greeting(): string {
      return this.greet() + '!'
    }
  },
  // `createElement` 是可推导的，但是 `render` 需要返回值类型
  render (createElement): VNode {
    return createElement('div', this.greeting)
  }
})

如果你发现类型推导或成员补齐不工作了，标注某个方法也许可以帮
助你解决这个问题。使用 --noImplicitAny 选项将会帮助你找到这
些未标注的方法。

 标注 Prop

import Vue, { PropType } from 'vue'

interface ComplexMessage {
  title: string,
  okMessage: string,
  cancelMessage: string
}
const Component = Vue.extend({
  props: {
    name: String,
    success: { type: String },
    callback: {
      type: Function as PropType<() => void>
    },
    message: {
      type: Object as PropType<ComplexMessage>,
      required: true,
      validator (message: ComplexMessage) {
        return !!message.title;
      }
    }
  }
})

如果你发现校验器并没有得到类型推导或命名补全不工作，用预期的
类型标注参数可能会助你解决这类问题。

← 单元测试生产环境部署 →
发现错误？想参与编辑？在 GitHub 上编辑此页！
