---
title: 条件渲染
description: Vue.js 的条件渲染指令：v-if、v-else、v-else-if、v-show
sidebarDepth: 2
---

# 条件渲染

在 Vue.js 中，我们可以使用 `v-if`、`v-else`、`v-else-if` 和 `v-show` 等指令来实现条件渲染。这些指令允许我们根据数据的状态来决定是否渲染某个元素。

## v-if

`v-if` 指令用于条件性地渲染一块内容。这块内容只会在指令的表达式返回 truthy 值的时候被渲染。

```html
<h1 v-if="awesome">Vue is awesome!</h1>
```

也可以用 `v-else` 添加一个"else 块"：

```html
<h1 v-if="awesome">Vue is awesome!</h1>
<h1 v-else>Oh no 😢</h1>
```

### v-else-if

`v-else-if` 可以链式地使用多个条件：

```html
<div v-if="type === 'A'">
  A
</div>
<div v-else-if="type === 'B'">
  B
</div>
<div v-else-if="type === 'C'">
  C
</div>
<div v-else>
  Not A/B/C
</div>
```

`v-else-if` 必须紧跟在 `v-if` 或 `v-else-if` 元素之后。

## v-show

另一个用于根据条件展示元素的选项是 `v-show` 指令。用法大致一样：

```html
<h1 v-show="ok">Hello!</h1>
```

不同的是带有 `v-show` 的元素始终会被渲染并保留在 DOM 中。`v-show` 只是简单地切换元素的 CSS property `display`。

## v-if vs v-show

`v-if` 是"真正"的条件渲染，因为它会确保在切换过程中，条件块内的事件监听器和子组件适当地被销毁和重建。

`v-if` 也是**惰性的**：如果在初始渲染时条件为假，则什么也不做——直到条件第一次变为真时，才会开始渲染条件块。

相比之下，`v-show` 就简单得多——不管初始条件是什么，元素总是会被渲染，并且只是简单地基于 CSS 进行切换。

一般来说，`v-if` 有更高的切换开销，而 `v-show` 有更高的初始渲染开销。因此，如果需要非常频繁地切换，则使用 `v-show` 较好；如果在运行时条件很少改变，则使用 `v-if` 较好。

## 在 template 上使用 v-if

因为 `v-if` 是一个指令，所以必须将它添加到一个元素上。但是如果我们想切换多个元素呢？我们可以把一个 `<template>` 元素当作不可见的包裹元素，并在上面使用 `v-if`。最终的渲染结果将不包含 `<template>` 元素。

```html
<template v-if="ok">
  <h1>Title</h1>
  <p>Paragraph 1</p>
  <p>Paragraph 2</p>
</template>
```

## v-else 和 v-else-if

`v-else` 指令表示 v-if 的"else 块"：

```html
<div v-if="Math.random() > 0.5">
  Now you see me
</div>
<div v-else>
  Now you don't
</div>
```

`v-else-if` 紧跟在 `v-else` 之后，作为 `v-if` 的"else if 块"：

```html
<div v-if="type === 'A'">
  A
</div>
<div v-else-if="type === 'B'">
  B
</div>
<div v-else-if="type === 'C'">
  C
</div>
<div v-else>
  Not A/B/C
</div>
```

类似于 `v-else`，`v-else-if` 也必须紧跟在带有 `v-if` 或 `v-else-if` 的元素之后。

## 用 key 管理可复用的元素

Vue 会尽可能高效地渲染元素，通常会复用已有元素而不是从头开始渲染。这么做除了使 Vue 变得非常快之外，还有其它一些好处。

例如，如果你允许用户在不同的登录方式之间切换：

```html
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address">
</template>
```

那么在上面的代码中切换 `loginType` 不会清除用户已经输入的内容。因为两个模板使用了相同的元素，`<input>` 不会被替换掉——仅仅是替换了它的 `placeholder`。

自己尝试一下，在输入框中输入一些文本，然后按下切换按钮：

```html
<button @click="loginType = loginType === 'username' ? 'email' : 'username'">
  Switch Login Type
</button>
```

这并不总是符合实际需求。所以 Vue 为你提供了一种方式来表达"这两个元素是完全独立的，不要复用它们"。只需添加一个具有唯一值的 `key` attribute 即可：

```html
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter your username" key="username-input">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter your email address" key="email-input">
</template>
```

现在，每次切换时，输入框都将被重新渲染。请看：

```html
<button @click="loginType = loginType === 'username' ? 'email' : 'username'">
  Switch Login Type
</button>
```

::: tip 注意事项
- `key` attribute 必须使用 `v-bind` 进行动态绑定
- 对于相同类型的元素，Vue 会尝试复用以提高性能
- 使用 `key` 可以强制重新渲染元素
:::

## v-if 与 v-for

当 `v-if` 和 `v-for` 同时存在于一个元素上时，`v-if` 会首先被执行。查看下面的例子：

```html
<li v-for="todo in todos" v-if="!todo.isComplete">
  {{ todo.name }}
</li>
```

在这个例子中，`v-if` 会检查每个 `todo` 是否已经完成，如果已经完成则不渲染该项。

如果你的目的是有条件地跳过循环的执行，那么可以将 `v-if` 置于外层元素 (或 `<template>`) 上：

```html
<ul v-if="todos.length">
  <li v-for="todo in todos">
    {{ todo.name }}
  </li>
</ul>
<p v-else>No todos left!</p>
```

## 最佳实践

### 使用计算属性处理复杂条件

```html
<!-- 不推荐 -->
<div v-if="user.role === 'admin' && user.status === 'active' && user.permissions.includes('edit')">
  Admin Panel
</div>

<!-- 推荐 -->
<div v-if="canEdit">
  Admin Panel
</div>
```

```javascript
export default {
  computed: {
    canEdit() {
      return this.user.role === 'admin' &&
             this.user.status === 'active' &&
             this.user.permissions.includes('edit')
    }
  }
}
```

### 避免在循环中使用 v-if（如果可能）

```html
<!-- 不推荐 -->
<ul>
  <li v-for="user in users" v-if="user.isActive" :key="user.id">
    {{ user.name }}
  </li>
</ul>

<!-- 推荐 -->
<ul>
  <li v-for="user in activeUsers" :key="user.id">
    {{ user.name }}
  </li>
</ul>
```

```javascript
export default {
  computed: {
    activeUsers() {
      return this.users.filter(user => user.isActive)
    }
  }
}
```

### 使用 v-show 处理频繁切换

```html
<!-- 适合频繁切换的场景 -->
<div v-show="isVisible">
  This content toggles frequently
</div>

<!-- 适合一次性条件 -->
<div v-if="shouldRender">
  This content renders once based on condition
</div>
```

### 条件渲染组件

```html
<component :is="currentComponent" v-if="showComponent"></component>
```

```javascript
export default {
  components: {
    LoginForm,
    RegisterForm,
    ForgotPassword
  },
  computed: {
    currentComponent() {
      switch (this.currentView) {
        case 'login': return 'LoginForm'
        case 'register': return 'RegisterForm'
        case 'forgot': return 'ForgotPassword'
        default: return null
      }
    }
  }
}
```

### 权限控制

```html
<!-- 用户权限控制 -->
<div v-if="hasPermission('admin')">
  <admin-panel />
</div>
<div v-else-if="hasPermission('user')">
  <user-dashboard />
</div>
<div v-else>
  <login-prompt />
</div>

<!-- 功能开关 -->
<feature-toggle v-if="featureEnabled('new-ui')" />
<legacy-component v-else />
```

## 性能考虑

### v-if 的性能特点

- **惰性渲染**：初始条件为假时不会渲染
- **完全销毁**：条件改变时会销毁和重建元素
- **高切换成本**：适合不频繁改变的条件

### v-show 的性能特点

- **始终渲染**：元素始终存在于DOM中
- **CSS切换**：只改变display属性
- **高初始成本**：适合频繁切换的场景

### 选择指南

| 场景 | 推荐指令 | 理由 |
|------|----------|------|
| 频繁切换 | `v-show` | 避免重复创建/销毁开销 |
| 一次性条件 | `v-if` | 避免不必要的初始渲染 |
| 权限控制 | `v-if` | 完全隐藏敏感内容 |
| 大型组件切换 | `v-if` | 释放内存和事件监听器 |
| 动画过渡 | `v-show` | 配合CSS过渡效果更好 |

### 内存管理

```javascript
export default {
  mounted() {
    // 组件挂载时的逻辑
  },
  beforeUnmount() {
    // 清理逻辑：移除事件监听器、定时器等
    if (this.timer) {
      clearInterval(this.timer)
    }
    if (this.eventListener) {
      window.removeEventListener('resize', this.eventListener)
    }
  }
}
```

::: warning 注意事项
- `v-else` 和 `v-else-if` 必须紧跟 `v-if` 或 `v-else-if` 之后
- `v-show` 不支持 `<template>` 元素
- 在使用 `v-for` 时，`key` attribute 是必需的
- 条件渲染会影响组件的生命周期钩子
:::









