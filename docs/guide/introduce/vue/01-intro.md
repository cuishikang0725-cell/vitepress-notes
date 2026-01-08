---
title: Vue.js 概览
description: Vue.js 基础概念、特点和生态系统简介
sidebarDepth: 2
---

# Vue.js 概览

## Vue.js 是什么

Vue.js 是一个用于构建用户界面的渐进式 JavaScript 框架。它采用了自底向上增量开发的设计理念，能够轻松集成到现有项目中。

## 核心特点

### 1. 响应式数据绑定

```javascript
const app = Vue.createApp({
  data() {
    return {
      message: 'Hello Vue!'
    }
  }
})

app.mount('#app')
```

### 2. 组件化开发

```javascript
// 定义组件
const HelloComponent = {
  template: '<h1>Hello, {{ name }}!</h1>',
  props: ['name']
}

// 使用组件
Vue.createApp({
  components: {
    'hello-component': HelloComponent
  }
})
```

### 3. 指令系统

- `v-if` / `v-else`：条件渲染
- `v-for`：列表渲染
- `v-bind`：动态绑定属性
- `v-on`：事件监听
- `v-model`：双向数据绑定

## Vue.js 版本

- **Vue 2**：当前主流版本，稳定且生态完善
- **Vue 3**：最新版本，提供更好的 TypeScript 支持和性能优化

## 生态系统

- **Vue Router**：官方路由管理器
- **Vuex / Pinia**：状态管理
- **Vue CLI**：项目脚手架
- **Vite**：新一代前端构建工具
- **Nuxt.js**：服务端渲染框架

## 为什么选择 Vue.js

1. **学习曲线平缓**：API 设计直观
2. **灵活性**：可以只用部分功能
3. **性能优秀**：虚拟 DOM + 响应式系统
4. **生态丰富**：有完善的工具链和社区支持

::: tip 拓展阅读
- [Vue.js 官方文档](https://cn.vuejs.org/)
- [Vue.js GitHub](https://github.com/vuejs/vue)
:::

::: warning 练习
尝试创建一个简单的 Vue 应用，显示"Hello World"和一个按钮，点击按钮时改变文本内容。
:::
