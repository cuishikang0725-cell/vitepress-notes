---
title: 模板语法
description: Vue.js 模板语法详解：插值、指令、表达式等
sidebarDepth: 2
---

# 模板语法

Vue.js 使用基于 HTML 的模板语法，允许开发者声明式地将 DOM 绑定到底层 Vue 实例的数据。所有 Vue.js 的模板都是合法的 HTML，可以被符合规范的浏览器和 HTML 解析器解析。

## 插值

### 文本插值

最基本的数据绑定形式是文本插值，使用双大括号语法（Mustache 语法）：

```html
<span>Message: {{ msg }}</span>
```

双大括号将会被替换为对应组件实例中 `msg` property 的值。如果 `msg` 发生改变，插值内容也会自动更新。

### 原始 HTML

双大括号会将数据解释为纯文本，而不是 HTML。为了输出真正的 HTML，需要使用 `v-html` 指令：

```html
<div v-html="rawHtml"></div>
```

```javascript
const app = Vue.createApp({
  data() {
    return {
      rawHtml: '<span style="color: red">This should be red.</span>'
    }
  }
})
```

::: warning 安全警告
动态渲染任意 HTML 可能非常危险，因为它很容易导致 XSS 攻击。请只对可信内容使用 HTML 插值，永不用于用户提供的内容。
:::

### Attribute 绑定

Mustache 语法不能在 HTML attribute 中使用。要做到这一点，需要使用 `v-bind` 指令：

```html
<div v-bind:id="dynamicId"></div>
```

对于布尔 attribute（只要存在就意味着值为 `true`），`v-bind` 工作起来略有不同：

```html
<button v-bind:disabled="isButtonDisabled">Button</button>
```

如果 `isButtonDisabled` 的值为 `null`、`undefined` 或 `false`，则 `disabled` attribute 甚至不会被包含在渲染出来的 `<button>` 元素中。

### 使用 JavaScript 表达式

Vue.js 在所有的数据绑定中都支持完整的 JavaScript 表达式：

```html
{{ number + 1 }}

{{ ok ? 'YES' : 'NO' }}

{{ message.split('').reverse().join('') }}

<div v-bind:id="'list-' + id"></div>
```

这些表达式将在当前活动实例的数据作用域下作为 JavaScript 被解析。有个限制就是，每个绑定都只能包含单个表达式，所以下面这些例子都不会生效：

```html
<!-- 这是语句，不是表达式 -->
{{ var a = 1 }}

<!-- 条件控制也不起作用，请使用三元表达式 -->
{{ if (ok) { return message } }}
```

## 指令

指令是带有 `v-` 前缀的特殊 attribute。指令 attribute 的期望值是一个 JavaScript 表达式（除了少数几个例外，即不需要表达式的指令）。

指令的职责就是当其表达式的值改变时相应地更新 DOM。

### 参数

一些指令可以接受一个"参数"，在指令名后以冒号分隔来表示。例如，`v-bind` 指令被用来响应式地更新 HTML attribute：

```html
<a v-bind:href="url"> ... </a>

<!-- 简写 -->
<a :href="url"> ... </a>
```

另一个例子是 `v-on` 指令，用于监听 DOM 事件：

```html
<a v-on:click="doSomething"> ... </a>

<!-- 简写 -->
<a @click="doSomething"> ... </a>
```

### 动态参数

从 Vue 2.6.0 开始，可以用方括号括起来的 JavaScript 表达式作为一个指令的参数：

```html
<a v-bind:[attributeName]="url"> ... </a>

<!-- 简写 -->
<a :[attributeName]="url"> ... </a>
```

这里的 `attributeName` 会被作为一个 JavaScript 表达式进行动态求值，求得的值会被用作最终的参数。

### 修饰符

修饰符是以点开头的特殊后缀，表明指令需要以特殊方式绑定。例如，`.prevent` 修饰符告诉 `v-on` 指令对触发的事件调用 `event.preventDefault()`：

```html
<form @submit.prevent="onSubmit">...</form>
```

## 缩写

### `v-bind` 缩写

```html
<!-- 完整语法 -->
<a v-bind:href="url"> ... </a>

<!-- 缩写 -->
<a :href="url"> ... </a>

<!-- 动态参数的缩写 -->
<a :[key]="url"> ... </a>
```

### `v-on` 缩写

```html
<!-- 完整语法 -->
<a v-on:click="doSomething"> ... </a>

<!-- 缩写 -->
<a @click="doSomething"> ... </a>

<!-- 动态参数的缩写 -->
<a @[event]="doSomething"> ... </a>
```

## 指令语法总结

| 语法 | 说明 |
|------|------|
| `v-text="msg"` | 更新元素的 textContent |
| `v-html="html"` | 更新元素的 innerHTML |
| `v-show="condition"` | 根据条件显示/隐藏元素 |
| `v-if="condition"` | 根据条件渲染元素 |
| `v-else` | 为 `v-if` 或 `v-else-if` 添加"else"块 |
| `v-else-if="condition"` | 表示 `v-if` 的"else if"块 |
| `v-for="item in items"` | 基于源数据多次渲染元素 |
| `v-on:click="handler"` | 为元素绑定事件监听器 |
| `v-bind:id="id"` | 动态绑定一个或多个 attribute |
| `v-model="value"` | 在表单控件上创建双向绑定 |
| `v-slot:name="slotProps"` | 为插槽命名 |
| `v-pre` | 跳过此元素及其子元素的编译过程 |
| `v-cloak` | 直到关联实例结束编译前隐藏未编译的 Mustache 语法 |
| `v-once` | 只渲染元素和组件一次 |

## 计算属性 vs 方法

在模板中绑定表达式是非常便利的，但是它们实际上只用于简单的操作。模板是为了描述视图的结构。在模板中放入太多的逻辑会让模板过重且难以维护。

这就是为什么 Vue.js 将绑定表达式限制为一个表达式的原因。如果需要多个表达式的逻辑，应当使用计算属性。

```html
<!-- 错误做法 -->
<div>{{ message.split('').reverse().join('') }}</div>

<!-- 正确做法：使用计算属性 -->
<div>{{ reversedMessage }}</div>
```

```javascript
export default {
  computed: {
    reversedMessage() {
      return this.message.split('').reverse().join('')
    }
  }
}
```

## 最佳实践

### 保持表达式简单

```html
<!-- 推荐 -->
{{ normalizedFullName }}

<!-- 避免 -->
{{ fullName.split(' ').map(word => word[0].toUpperCase() + word.slice(1)).join(' ') }}
```

### 使用计算属性处理复杂逻辑

```javascript
export default {
  data() {
    return {
      firstName: 'John',
      lastName: 'Doe'
    }
  },
  computed: {
    fullName() {
      return `${this.firstName} ${this.lastName}`
    },
    normalizedFullName() {
      return this.fullName.split(' ')
        .map(word => word[0].toUpperCase() + word.slice(1))
        .join(' ')
    }
  }
}
```

### 避免在模板中修改数据

```html
<!-- 错误 -->
<button @click="count++">{{ count }}</button>

<!-- 正确 -->
<button @click="increment">{{ count }}</button>
```

```javascript
export default {
  methods: {
    increment() {
      this.count++
    }
  }
}
```

::: tip 性能优化
- 模板表达式只用于简单的数据转换
- 复杂逻辑放在计算属性中
- 事件处理函数放在 methods 中
- 避免在模板中调用函数（会造成不必要的重渲染）
:::









