---
title: Props
description: Vue.js 组件 Props 的详细用法和最佳实践
sidebarDepth: 2
---

# Props

## Props 基础

Props 是你可以在组件上注册的一些自定义 attribute。当一个值传递给一个 prop attribute 的时候，它就变成了那个组件实例的一个 property。

```html
<!-- 子组件 -->
<template>
  <div>
    <h3>{{ title }}</h3>
    <p>{{ content }}</p>
  </div>
</template>

<script>
export default {
  props: ['title', 'content']
}
</script>

<!-- 父组件 -->
<template>
  <div>
    <blog-post title="My journey with Vue" content="Vue is awesome!"></blog-post>
  </div>
</div>
```

## Props 的命名约定

HTML 中的 attribute 名是大小写不敏感的，所以浏览器会把所有大写字符解释为小写字符。这意味着当你使用 DOM 中的模板时，camelCase (驼峰命名法) 的 prop 名称需要使用其等价的 kebab-case (短横线分隔命名) 命名：

```javascript
// JavaScript 中使用 camelCase
props: ['postTitle']

// HTML 中使用 kebab-case
<blog-post post-title="hello!"></blog-post>
```

如果你使用字符串模板，那么这个限制就不存在了。

## Props 类型

到目前为止，我们只看到了以字符串数组形式列出的 props：

```javascript
props: ['title', 'likes', 'isPublished', 'commentIds', 'author']
```

但是，通常你希望每个 prop 都有指定的值类型。这时，你可以以对象形式列出 props，这些 property 的名称和值分别是 prop 各自的名称和类型：

```javascript
props: {
  title: String,
  likes: Number,
  isPublished: Boolean,
  commentIds: Array,
  author: Object,
  callback: Function,
  contactsPromise: Promise
}
```

这不仅为你的组件提供了文档，还会在它们遇到错误的类型时在浏览器控制台中警告用户。你将在这个页面后面看到[类型检查和其它 prop 验证](#prop-验证)。

## 传递静态或动态 Prop

像这样，你已经知道了可以像这样给 prop 传入一个静态值：

```html
<blog-post title="My journey with Vue"></blog-post>
```

你也知道 prop 可以通过 `v-bind` 动态赋值，例如：

```html
<template>
  <div>
    <blog-post
      v-for="post in posts"
      :key="post.id"
      :title="post.title"
    ></blog-post>
  </div>
</template>
```

### 传递不同的值类型

#### 字符串

```html
<blog-post title="My journey with Vue"></blog-post>
<!-- 或 -->
<blog-post :title="post.title"></blog-post>
```

#### 数字

```html
<!-- 即使是数字，也要用 v-bind，否则会作为字符串传递 -->
<blog-post :likes="42"></blog-post>
<!-- 或 -->
<blog-post :likes="post.likes"></blog-post>
```

#### 布尔值

```html
<!-- 包含该 prop 没有值的情况在内，都意味着 `true` -->
<blog-post is-published></blog-post>
<!-- 或 -->
<blog-post :is-published="false"></blog-post>
<!-- 或 -->
<blog-post :is-published="post.isPublished"></blog-post>
```

#### 数组

```html
<!-- 虽然可能很少见，我们也可以传递数组 -->
<blog-post :comment-ids="[234, 266, 273]"></blog-post>
<!-- 或 -->
<blog-post :comment-ids="post.commentIds"></blog-post>
```

#### 对象

```html
<!-- 同样适用于对象 -->
<blog-post
  :author="{
    name: 'Veronica',
    company: 'Veridian Dynamics'
  }"
></blog-post>
<!-- 或 -->
<blog-post :author="post.author"></blog-post>
```

### 使用对象传递多个 prop

如果你想要将一个对象的所有 property 都作为 prop 传入，你可以使用不带参数的 `v-bind` (即用 `v-bind` 而不是 `v-bind:prop-name`)。例如，给定一个 `post` 对象：

```javascript
export default {
  data() {
    return {
      post: {
        id: 1,
        title: 'My Journey with Vue'
      }
    }
  }
}
```

下面的模板：

```html
<blog-post v-bind="post"></blog-post>
```

等价于：

```html
<blog-post :id="post.id" :title="post.title"></blog-post>
```

## 单向数据流

所有的 prop 都遵循着**单向绑定**原则：父级的 prop 的更新会向下流动到子组件中，但是反过来则不行。这样会防止从子组件意外变更父级组件的状态，从而导致你的应用的数据流向难以理解。

额外的，每次父级组件发生变更时，子组件中所有的 prop 都将会刷新为最新的值。这意味着你**不**应该在一个子组件内部改变 prop。如果你这样做了，Vue 会在浏览器的控制台中发出警告。

这里有两种常见的试图变更一个 prop 的情况：

1. **这个 prop 用来传递一个初始值；这个子组件接下来希望将其作为一个本地的 prop 数据来使用。** 在这种情况下，最好定义一个本地的 data property 并将这个 prop 作为其初始值：

```javascript
export default {
  props: ['initialCounter'],
  data() {
    return {
      counter: this.initialCounter
    }
  }
}
```

2. **这个 prop 以一种原始的值传入且需要进行转换。** 在这种情况下，最好使用这个 prop 的值来定义一个计算属性：

```javascript
export default {
  props: ['size'],
  computed: {
    normalizedSize() {
      return this.size.trim().toLowerCase()
    }
  }
}
```

::: warning 注意
在 JavaScript 中对象和数组是通过引用传入的，所以对于一个数组或对象类型的 prop 来说，在子组件中改变变更这个对象或数组本身**将会**影响到父级组件的状态。
:::

## Prop 验证

Vue.js 为组件的 prop 提供了一种验证机制。当传入的数据不符合要求时，Vue.js 会在控制台发出警告。

```javascript
export default {
  props: {
    // 基础的类型检查 (`null` 和 `undefined` 会通过任何类型验证)
    propA: Number,
    // 多个可能的类型
    propB: [String, Number],
    // 必填的字符串
    propC: {
      type: String,
      required: true
    },
    // 带有默认值的数字
    propD: {
      type: Number,
      default: 100
    },
    // 带有默认值的对象
    propE: {
      type: Object,
      // 对象或数组默认值必须从一个工厂函数获取
      default() {
        return { message: 'hello' }
      }
    },
    // 自定义验证函数
    propF: {
      validator(value) {
        // 这个值必须匹配下列字符串中的一个
        return ['success', 'warning', 'danger'].includes(value)
      }
    },
    // 带有默认值的函数
    propG: {
      type: Function,
      // 与对象或数组默认值不同，这不是一个工厂函数——这是一个用作默认值的函数
      default() {
        return 'Default function'
      }
    }
  }
}
```

当 prop 验证失败的时候，Vue.js (在开发构建中) 会产生一个控制台警告。

::: tip 注意
注意那些 prop 会在一个组件实例创建**之前**进行验证，所以实例的 property (如 `data`、`computed` 等) 在 `default` 或 `validator` 函数中是不可用的。
:::

### 类型检查

`type` 可以是下列原生构造函数中的一个：

- `String`
- `Number`
- `Boolean`
- `Array`
- `Object`
- `Date`
- `Function`
- `Symbol`

额外的，`type` 也可以是一个自定义的构造函数，并且通过 `instanceof` 检查来确认。例如，给定下列现成的构造函数：

```javascript
function Person(firstName, lastName) {
  this.firstName = firstName
  this.lastName = lastName
}

export default {
  props: {
    author: Person
  }
}
```

来验证 `author` prop 的值是否是通过 `new Person` 创建的。

## 非 Prop 的 Attribute

一个非 prop 的 attribute 是指传向一个组件，但是该组件并没有相应 prop 定义的 attribute。

因为显式定义的 prop 适用于向一个子组件传入信息，反之则不然。但是这也意味着，一个组件可以接受任意的 attribute，这也会被添加到这个组件的根元素上。

例如，想象一下我们使用一个第三方的 `<bootstrap-date-input>` 组件，它需要在其 `<input>` 根元素上设置 `data-date-picker` attribute。我们可以将这个 attribute 添加到我们的组件实例上：

```html
<bootstrap-date-input data-date-picker="activated"></bootstrap-date-input>
```

`data-date-picker="activated"` attribute 会被自动添加到 `<bootstrap-date-input>` 的根元素上。

### 替换/合并已有的 Attribute

想象一下 `<bootstrap-date-input>` 的模板是这样的：

```html
<input type="date" class="form-control">
```

为了给我们的日期选择器插件指定一个主题，我们可能需要添加一个特定的类名：

```html
<bootstrap-date-input
  data-date-picker="activated"
  class="date-picker-theme-dark"
></bootstrap-date-input>
```

在这种情况下，我们定义了两个不同的 `class` 的值：

- `form-control`，这是在组件的模板中设置好的
- `date-picker-theme-dark`，这是从父级组件传入的

对于绝大多数 attribute 来说，从外部提供给组件的值会替换掉组件内部设置好的值。所以如果传入 `type="text"` 就会替换掉 `type="date"` 并把它破坏！庆幸的是，`class` 和 `style` attribute 会稍微智能一些，即两边的值会被合并起来。

### 禁用 Attribute 继承

如果你**不**希望组件的根元素继承 attribute，你可以在组件的选项中设置 `inheritAttrs: false`。例如：

```javascript
export default {
  inheritAttrs: false
}
```

这尤其适合配合实例的 `$attrs` property 使用，该 property 包含了传递给一个组件的 attribute 名和 attribute 值，例如：

```javascript
export default {
  inheritAttrs: false,
  created() {
    console.log(this.$attrs)
  }
}
```

`$attrs` 包含了除组件所接受的 prop 之外的所有 attribute (例如，`data-*`、`aria-*`、`class`、`style` 等)。

### 多个根节点的 Attribute 继承

如果一个组件的模板有多个根节点，那么 attribute 继承规则会有所不同：

```html
<header>...</header>
<main>...</main>
<footer>...</footer>
```

在这种情况下，Vue.js 会自动决定将非 prop attribute 应用到哪个根节点。这可能会导致不可预测的行为。通常应该通过显式定义 `inheritAttrs: false` 来避免这种行为。

## Prop 的最佳实践

### 1. 总是使用 camelCase 在 JavaScript 中命名 prop

在 HTML 中使用 kebab-case：

```javascript
// JavaScript
props: ['postTitle']

// HTML
<blog-post post-title="hello!"></blog-post>
```

### 2. 使用详细的 prop 定义

```javascript
// 推荐
props: {
  status: {
    type: String,
    required: true,
    validator: function (value) {
      return ['syncing', 'synced', 'error'].includes(value)
    }
  }
}

// 避免
props: ['status']
```

### 3. 为 prop 提供默认值

```javascript
// 推荐
props: {
  name: {
    type: String,
    default: 'John Doe'
  },
  items: {
    type: Array,
    default() {
      return []
    }
  }
}
```

### 4. Prop 验证要合理

```javascript
props: {
  // 好的验证
  age: {
    type: Number,
    validator(value) {
      return value >= 0 && value <= 120
    }
  },

  // 避免过度验证
  email: {
    type: String,
    validator(value) {
      // 这在每次渲染时都会执行！
      return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)
    }
  }
}
```

### 5. 使用对象语法传递复杂数据

```html
<!-- 推荐 -->
<user-profile v-bind:user="userData"></user-profile>

<!-- 避免 -->
<user-profile
  :name="userData.name"
  :email="userData.email"
  :avatar="userData.avatar"
/>
```

### 6. 不要修改 prop 的值

```javascript
// 错误
export default {
  props: ['message'],
  created() {
    this.message = 'changed' // 不要这样做！
  }
}

// 正确
export default {
  props: ['initialMessage'],
  data() {
    return {
      message: this.initialMessage
    }
  }
}
```

### 7. 使用 emits 声明自定义事件

```javascript
export default {
  props: ['value'],
  emits: ['input', 'change'],
  methods: {
    handleInput(event) {
      this.$emit('input', event.target.value)
      this.$emit('change', event.target.value)
    }
  }
}
```

## 高级用法

### 异步 Props

```javascript
export default {
  props: {
    data: {
      type: Promise,
      required: true
    }
  },
  data() {
    return {
      result: null,
      loading: true,
      error: null
    }
  },
  async created() {
    try {
      this.result = await this.data
    } catch (error) {
      this.error = error
    } finally {
      this.loading = false
    }
  }
}
```

### 动态 Props

```html
<component
  :is="componentType"
  v-bind="dynamicProps"
/>
```

```javascript
export default {
  computed: {
    componentType() {
      return this.type === 'input' ? 'BaseInput' : 'BaseSelect'
    },
    dynamicProps() {
      return this.type === 'input'
        ? { value: this.value, placeholder: this.placeholder }
        : { options: this.options, value: this.value }
    }
  }
}
```

### Props 透传

```javascript
// 父组件
<template>
  <custom-input v-bind="$attrs" v-on="$listeners" />
</template>

<script>
export default {
  inheritAttrs: false
}
</script>
```

::: warning 注意事项
- Props 是单向的，不要在子组件中修改 props
- 使用对象语法定义 props，可以提供更好的类型检查和默认值
- 对于对象和数组类型的 props，要注意引用传递的问题
- 合理使用 prop 验证，提升组件的健壮性
- 对于非 prop attribute，了解继承规则
:::









