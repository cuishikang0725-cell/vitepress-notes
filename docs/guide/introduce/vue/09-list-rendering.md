---
title: 列表渲染
description: Vue.js 的列表渲染指令 v-for 的使用方法和最佳实践
sidebarDepth: 2
---

# 列表渲染

我们可以用 `v-for` 指令基于一个数组来渲染一个列表。`v-for` 指令需要使用 `item in items` 形式的特殊语法，其中 `items` 是源数据数组，而 `item` 则是被迭代的数组元素的别名。

## 基础用法

```html
<ul>
  <li v-for="item in items" :key="item.id">
    {{ item.message }}
  </li>
</ul>
```

```javascript
export default {
  data() {
    return {
      items: [
        { message: 'Foo', id: 1 },
        { message: 'Bar', id: 2 }
      ]
    }
  }
}
```

在 `v-for` 块中，我们可以访问所有父作用域的 property。`v-for` 还支持一个可选的第二个参数，即当前项的索引。

```html
<ul>
  <li v-for="(item, index) in items" :key="item.id">
    {{ index }} - {{ item.message }}
  </li>
</ul>
```

你也可以用 `of` 作为分隔符来替代 `in`，这更接近 JavaScript 的迭代器语法：

```html
<div v-for="item of items"></div>
```

## 在 template 上使用 v-for

类似于 `v-if`，你也可以利用带有 `v-for` 的 `<template>` 来循环渲染一段包含多个元素的内容。比如：

```html
<ul>
  <template v-for="item in items" :key="item.id">
    <li>{{ item.msg }}</li>
    <li class="divider" role="presentation"></li>
  </template>
</ul>
```

## 对象迭代

你也可以用 `v-for` 来遍历一个对象的 property。

```html
<ul>
  <li v-for="(value, key, index) in myObject" :key="key">
    {{ index }}. {{ key }}: {{ value }}
  </li>
</ul>
```

```javascript
export default {
  data() {
    return {
      myObject: {
        title: 'How to do lists in Vue',
        author: 'Jane Doe',
        publishedAt: '2016-04-10'
      }
    }
  }
}
```

## 维护状态

当 Vue 更新使用 `v-for` 渲染的元素列表时，它默认使用"就地更新"的策略。如果数据项的顺序被改变，Vue 不会移动 DOM 元素来匹配数据项的顺序，而是就地更新每个元素，并且确保它们在每个索引位置正确渲染。

这个默认的模式是高效的，但是**只适用于不依赖子组件状态或临时 DOM 状态的列表渲染输出**。

为了给 Vue 一个提示，以便它能跟踪每个节点的身份，从而重用和重新排序现有元素，你需要为每项提供一个唯一 `key` attribute：

```html
<div v-for="item in items" :key="item.id">
  <!-- 内容 -->
</div>
```

建议尽可能在使用 `v-for` 时提供 `key` attribute，除非遍历输出的 DOM 内容非常简单，或者是刻意依赖默认行为以获取性能上的提升。

## 数组变化检测

### 变更方法

Vue 能够检测到数组的以下变更：

- `push()`
- `pop()`
- `shift()`
- `unshift()`
- `splice()`
- `sort()`
- `reverse()`

这些方法会改变原始数组，Vue 能检测到这些变化并更新视图。

### 替换数组

变更方法，顾名思义，会变更调用这些方法的原始数组。相比之下，也有非变更方法，例如 `filter()`、`concat()` 和 `slice()`。这些不会变更原始数组，而总是返回一个新数组。当使用非变更方法时，需要用新数组替换旧数组：

```javascript
// 这不会改变原始数组，而是返回一个新数组
this.items = this.items.filter(item => item.message.match(/Foo/))
```

你可能认为这将导致 Vue 丢弃现有 DOM 并重新渲染整个列表。幸运的是，事实并非如此。Vue 为了使得 DOM 元素得到最大范围的重用而实现了一些智能的启发式方法，所以用一个含有相同元素的数组去替换原来的数组是非常高效的操作。

### 注意事项

由于 JavaScript 的限制，Vue **不能检测**以下数组的变动：

1. 当你利用索引直接设置一个数组项时，例如：`vm.items[indexOfItem] = newValue`
2. 当你修改数组的长度时，例如：`vm.items.length = newLength`

```javascript
const vm = Vue.createApp({
  data() {
    return {
      items: ['a', 'b', 'c']
    }
  }
}).mount('#app')

// 这些都不会触发视图更新
vm.items[0] = 'x'        // 不响应
vm.items.length = 2      // 不响应
```

为了解决第一类问题，以下两种方式都可以实现和 `vm.items[indexOfItem] = newValue` 相同的效果，同时也会触发状态更新：

```javascript
// Vue.set
Vue.set(vm.items, indexOfItem, newValue)

// Array.prototype.splice
vm.items.splice(indexOfItem, 1, newValue)
```

你也可以使用 `vm.$set` 实例方法，该方法是全局 `Vue.set` 的一个别名：

```javascript
vm.$set(vm.items, indexOfItem, newValue)
```

为了解决第二类问题，你可以使用 `splice`：

```javascript
vm.items.splice(newLength)
```

## 对象变化检测

还是由于 JavaScript 的限制，Vue **不能检测**对象属性的添加或删除：

```javascript
const vm = Vue.createApp({
  data() {
    return {
      a: 1
    }
  }
}).mount('#app')

// 这些都不会触发视图更新
vm.a = 2      // 不响应
vm.b = 2      // 不响应
```

对于已经创建的实例，Vue 不允许动态添加根级别的响应式 property。但是，可以使用 `Vue.set(object, propertyName, value)` 方法向嵌套对象添加响应式 property：

```javascript
Vue.set(vm.someObject, 'b', 2)
```

你还可以使用 `vm.$set` 实例方法，它只是全局 `Vue.set` 的别名：

```javascript
vm.$set(vm.someObject, 'b', 2)
```

有时你可能需要为已有对象赋值多个新 property，比如使用 `Object.assign()` 或 `_.extend()`。在这种情况下，你应该用两个对象的 property 创建一个新的对象：

```javascript
// 不要这样
Object.assign(vm.userProfile, {
  age: 27,
  favoriteColor: 'Vue Green'
})
```

```javascript
// 应该这样
vm.userProfile = Object.assign({}, vm.userProfile, {
  age: 27,
  favoriteColor: 'Vue Green'
})
```

## 显示过滤/排序结果

有时，我们想要显示一个数组经过过滤或排序后的版本，而不实际变更或重置原始数据。在这种情况下，可以创建返回过滤或排序数组的计算属性。

```html
<li v-for="n in evenNumbers" :key="n">{{ n }}</li>
```

```javascript
export default {
  data() {
    return {
      numbers: [1, 2, 3, 4, 5]
    }
  },
  computed: {
    evenNumbers() {
      return this.numbers.filter(number => number % 2 === 0)
    }
  }
}
```

在计算属性不适用的情况下 (例如，在嵌套 `v-for` 循环中)，你可以使用一个方法：

```html
<ul v-for="numbers in sets" :key="numbers.id">
  <li v-for="n in even(numbers)" :key="n">{{ n }}</li>
</ul>
```

```javascript
export default {
  data() {
    return {
      sets: [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]]
    }
  },
  methods: {
    even(numbers) {
      return numbers.filter(number => number % 2 === 0)
    }
  }
}
```

## 在 v-for 里使用范围值

`v-for` 也可以接受整数。在这种情况下，它会把模板重复对应次数。

```html
<div>
  <span v-for="n in 10" :key="n">{{ n }} </span>
</div>
```

## 在 template 上使用 v-for

类似于 `v-if`，你也可以在 `<template>` 上使用 `v-for` 来渲染多个元素。比如：

```html
<ul>
  <template v-for="item in items" :key="item.msg">
    <li>{{ item.msg }}</li>
    <li class="divider" role="presentation"></li>
  </template>
</ul>
```

## v-for 与 v-if

当它们处于同一节点，`v-if` 的优先级比 `v-for` 更高，这意味着 `v-if` 将没有权限访问 `v-for` 里的变量：

```html
<!-- 不推荐 -->
<li v-for="todo in todos" v-if="!todo.isComplete" :key="todo.id">
  {{ todo.name }}
</li>
```

这会抛出一个错误，因为 `todo` property 没有在该实例上定义。

推荐的做法是使用计算属性过滤数据：

```javascript
export default {
  computed: {
    incompleteTodos() {
      return this.todos.filter(todo => !todo.isComplete)
    }
  }
}
```

```html
<li v-for="todo in incompleteTodos" :key="todo.id">
  {{ todo.name }}
</li>
```

或者在 `<template>` 上使用 `v-for` 和 `v-if`：

```html
<template v-for="todo in todos" :key="todo.id">
  <li v-if="!todo.isComplete">
    {{ todo.name }}
  </li>
</template>
```

## 通过 key 管理状态

当 Vue 更新使用 `v-for` 渲染的元素列表时，它默认使用"就地更新"的策略。如果数据项的顺序被改变，Vue 不会移动 DOM 元素来匹配数据项的顺序，而是就地更新每个元素，并且确保它们在每个索引位置正确渲染。

这个模式是高效的，但是**只适用于列表渲染输出不依赖子组件状态或临时 DOM 状态 (例如：表单输入值) 的情况**。

为了让 Vue 能够跟踪每个节点的身份，从而重用和重新排序现有元素，你需要为每项提供一个唯一 `key` attribute：

```html
<div v-for="item in items" :key="item.id">
  <!-- 内容 -->
</div>
```

建议尽可能在使用 `v-for` 时提供 `key` attribute，除非遍历输出的 DOM 内容非常简单。

## 组件和 v-for

在自定义组件上，你可以像在任何普通元素上一样使用 `v-for`：

```html
<my-component v-for="item in items" :key="item.id"></my-component>
```

但是，这不会自动传递数据到组件，因为组件有自己独立的作用域。为了将迭代数据传递到组件中，我们需要使用 props：

```html
<my-component
  v-for="(item, index) in items"
  :item="item"
  :index="index"
  :key="item.id"
></my-component>
```

不自动将 `item` 注入到组件的原因是，这会使组件与 `v-for` 的工作方式紧密耦合。明确声明数据来源能够让组件在其他情况下重用。

## 最佳实践

### 始终使用 key

```html
<!-- 推荐 -->
<div v-for="item in items" :key="item.id">
  {{ item.name }}
</div>

<!-- 避免 -->
<div v-for="item in items">
  {{ item.name }}
</div>
```

### 使用计算属性过滤数据

```javascript
export default {
  computed: {
    activeUsers() {
      return this.users.filter(user => user.active)
    },
    sortedPosts() {
      return [...this.posts].sort((a, b) => b.createdAt - a.createdAt)
    }
  }
}
```

### 避免在循环中修改数组

```javascript
// 不推荐
methods: {
  removeItem(index) {
    this.items.splice(index, 1) // 会改变原始数组
  }
}

// 推荐
methods: {
  removeItem(itemToRemove) {
    this.items = this.items.filter(item => item !== itemToRemove)
  }
}
```

### 使用事件委托优化性能

```html
<!-- 对于大量列表项，使用事件委托 -->
<ul @click="handleItemClick">
  <li v-for="item in items" :key="item.id" :data-id="item.id">
    {{ item.name }}
  </li>
</ul>
```

```javascript
methods: {
  handleItemClick(event) {
    const itemId = event.target.dataset.id
    // 处理点击逻辑
  }
}
```

### 虚拟滚动优化

对于超长列表，考虑使用虚拟滚动：

```html
<virtual-list
  :data-source="largeList"
  :data-key="'id'"
  :estimate-size="50"
  class="virtual-list"
>
  <template #item="{ item }">
    <div class="list-item">{{ item.name }}</div>
  </template>
</virtual-list>
```

### 响应式数组操作

```javascript
export default {
  methods: {
    // 添加项目
    addItem() {
      this.items.push({ id: Date.now(), name: 'New Item' })
    },

    // 删除项目
    removeItem(index) {
      this.items.splice(index, 1)
    },

    // 更新项目
    updateItem(index, newItem) {
      Vue.set(this.items, index, newItem)
      // 或 this.$set(this.items, index, newItem)
    },

    // 替换整个数组
    replaceItems(newItems) {
      this.items = [...newItems]
    }
  }
}
```

## 性能优化

### 列表渲染性能提示

1. **使用 key**: 为每个列表项提供唯一 key
2. **避免不必要的渲染**: 使用计算属性预处理数据
3. **使用事件委托**: 避免在每个列表项上绑定事件
4. **分页或虚拟滚动**: 对于大数据集
5. **使用 shallowRef**: 对于大型对象数组

### 内存管理

```javascript
export default {
  beforeUnmount() {
    // 清理定时器、事件监听器等
    this.items.forEach(item => {
      if (item.timer) {
        clearInterval(item.timer)
      }
    })
  }
}
```

::: warning 注意事项
- `v-for` 的优先级比 `v-if` 更高
- 永远不要在同一个元素上同时使用 `v-if` 和 `v-for`
- 为每个 `v-for` 项提供唯一的 `key`
- 避免在循环中使用复杂的表达式
- 对于对象迭代，顺序不保证与 Object.keys() 一致
:::









