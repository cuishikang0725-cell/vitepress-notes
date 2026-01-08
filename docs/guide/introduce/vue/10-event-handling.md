---
title: 事件处理
description: Vue.js 的事件处理机制、修饰符和自定义事件
sidebarDepth: 2
---

# 事件处理

## 监听事件

可以用 `v-on` 指令监听 DOM 事件，并在触发时运行一些 JavaScript 代码。

```html
<div id="example-1">
  <button v-on:click="counter += 1">Add 1</button>
  <p>The button above has been clicked {{ counter }} times.</p>
</div>
```

```javascript
Vue.createApp({
  data() {
    return {
      counter: 0
    }
  }
}).mount('#example-1')
```

## 方法事件处理器

许多事件处理的逻辑会更为复杂，所以直接把 JavaScript 代码写在 `v-on` 指令中是不可行的。因此 `v-on` 也可以接收一个需要调用的方法名称。

```html
<div id="example-2">
  <!-- `greet` 是在下面定义的方法名 -->
  <button v-on:click="greet">Greet</button>
</div>
```

```javascript
Vue.createApp({
  data() {
    return {
      name: 'Vue.js'
    }
  },
  methods: {
    greet(event) {
      // `this` 在方法里指向当前活动实例
      alert('Hello ' + this.name + '!')
      // `event` 是原生 DOM 事件
      if (event) {
        alert(event.target.tagName)
      }
    }
  }
}).mount('#example-2')
```

## 内联处理器中的方法

除了直接绑定到一个方法，也可以在内联 JavaScript 语句中调用方法：

```html
<div id="example-3">
  <button v-on:click="say('hi')">Say hi</button>
  <button v-on:click="say('what')">Say what</button>
</div>
```

```javascript
Vue.createApp({
  methods: {
    say(message) {
      alert(message)
    }
  }
}).mount('#example-3')
```

有时也需要在内联语句处理器中访问原始的 DOM 事件。可以用特殊变量 `$event` 把它传入方法：

```html
<button v-on:click="warn('Form cannot be submitted yet.', $event)">
  Submit
</button>
```

```javascript
// ...
methods: {
  warn(message, event) {
    // 现在可以访问原生事件对象
    if (event) {
      event.preventDefault()
    }
    alert(message)
  }
}
```

## 事件修饰符

在事件处理程序中调用 `event.preventDefault()` 或 `event.stopPropagation()` 是非常常见的需求。尽管可以在方法中轻松实现这点，但更好的方式是：方法只有纯粹的数据逻辑，而不是去处理 DOM 事件细节。

为了解决这个问题，Vue.js 为 `v-on` 提供了**事件修饰符**。之前提过，修饰符是由点开头的指令后缀来表示的。

- `.stop`
- `.prevent`
- `.capture`
- `.self`
- `.once`
- `.passive`

```html
<!-- 阻止单击事件继续传播 -->
<a v-on:click.stop="doThis"></a>

<!-- 提交事件不再重载页面 -->
<form v-on:submit.prevent="onSubmit"></form>

<!-- 修饰符可以串联 -->
<a v-on:click.stop.prevent="doThat"></a>

<!-- 只有修饰符 -->
<form v-on:submit.prevent></form>

<!-- 添加事件监听器时使用事件捕获模式 -->
<!-- 即内部元素触发的事件先在此处理，然后才交由内部元素进行处理 -->
<div v-on:click.capture="doThis">...</div>

<!-- 只当在 event.target 是当前元素自身时触发处理函数 -->
<!-- 即事件不是从内部元素触发的 -->
<div v-on:click.self="doThat">...</div>
```

::: tip 使用建议
使用修饰符时，顺序很重要；相应的代码会以同样的顺序产生。因此，用 `@click.prevent.self` 会阻止**所有的点击**，而 `@click.self.prevent` 只会阻止对元素自身的点击。
:::

```html
<!-- 点击事件将只会触发一次 -->
<a v-on:click.once="doThis"></a>
```

不像其它只能对原生的 DOM 事件起作用的修饰符，`.once` 修饰符还能被用到自定义的[组件事件](./component-custom-events.html)上。

```html
<!-- 滚动事件的默认行为 (即滚动行为) 将会立即触发 -->
<!-- 而不会等待 `onScroll` 完成  -->
<!-- 这其中包含 `event.preventDefault()` 的情况 -->
<div v-on:scroll.passive="onScroll">...</div>
```

`.passive` 修饰符尤其能够提升移动端的性能。

::: tip 不要把 `.passive` 和 `.prevent` 一起使用
:::

## 按键修饰符

在监听键盘事件时，我们经常需要检查详细的按键。Vue 允许为 `v-on` 或者 `@` 在监听键盘事件时添加按键修饰符：

```html
<!-- 只有在 `key` 是 `Enter` 时调用 `vm.submit()` -->
<input v-on:keyup.enter="submit" />
```

你可以直接将 [`KeyboardEvent.key`](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values) 暴露的任意有效按键名转换为 kebab-case 来作为修饰符。

```html
<input v-on:keyup.page-down="onPageDown" />
```

在上述示例中，处理函数只会在 `$event.key` 等于 `'PageDown'` 时被调用。

### 按键别名

Vue 为最常用的按键提供了别名：

- `.enter`
- `.tab`
- `.delete` (捕获"删除"和"退格"键)
- `.esc`
- `.space`
- `.up`
- `.down`
- `.left`
- `.right`

### 系统修饰符

可以用如下修饰符来实现仅在按下相应按键时才触发鼠标或键盘事件的监听器。

- `.ctrl`
- `.alt`
- `.shift`
- `.meta`

::: tip 注意
注意：在 Macintosh 键盘上，meta 对应 command 键 (⌘)。在 Windows 键盘上，meta 对应 Windows 键 (⊞)。在 Sun 微机系统键盘上，meta 对应实心钻石键 (◆)。在某些键盘上，特别是 MIT 和 Lisp 键盘及其后续键盘，如 Knight 键盘、space-cadet 键盘，meta 被标记为"META"。在 Symbolics 键盘上，meta 被标记为"META"或"Meta"。
:::

例如：

```html
<!-- Alt + Enter -->
<input @keyup.alt.enter="clear" />

<!-- Ctrl + Click -->
<div @click.ctrl="doSomething">Do something</div>
```

::: tip 系统按键修饰符
系统按键修饰符与常规按键不同。与 `keyup` 事件一起使用时，事件触发时系统按键必须被按下。与其他按键修饰符组合使用时，系统按键修饰符必须在其他按键修饰符之前声明：

```html
<!-- 这是可行的 -->
<input @keyup.alt.enter="clearInput" />

<!-- 这不会被触发 -->
<input @keyup.enter.alt="clearInput" />
```
:::

### `.exact` 修饰符

`.exact` 修饰符允许你控制由精确的系统修饰符组合触发的事件。

```html
<!-- 即使 Alt 或 Shift 被一同按下时也会触发 -->
<button @click.ctrl="onClick">A</button>

<!-- 有且只有 Ctrl 被按下的时候才触发 -->
<button @click.ctrl.exact="onCtrlClick">A</button>

<!-- 没有任何系统修饰符被按下的时候才触发 -->
<button @click.exact="onClick">A</button>
```

## 鼠标按钮修饰符

- `.left`
- `.right`
- `.middle`

这些修饰符会限制处理函数仅响应特定的鼠标按钮。

## 自定义事件

### 触发自定义事件

在组件的实现中，我们有时需要从子组件向父组件传递一些消息。这时可以使用自定义事件。

所有从子组件触发的事件都可以通过 `v-on` (或 `@`) 来监听：

```html
<blog-post
  ...
  v-on:enlarge-text="postFontSize += 0.1"
></blog-post>
```

在子组件中，可以通过调用内置的 [**$emit**](./instance.html#组件实例属性) 方法并传入事件名称来触发一个事件：

```html
<button v-on:click="$emit('enlarge-text')">
  Enlarge text
</button>
```

然后父组件可以像处理原生 DOM 事件一样监听这个事件：

```html
<blog-post ... v-on:enlarge-text="postFontSize += 0.1"></blog-post>
```

### 传递参数给父组件

有时我们可能想让子组件在触发事件时传递一些特定的值。可以使用 `$emit` 的第二个参数来提供这个值：

```html
<button v-on:click="$emit('enlarge-text', 0.1)">
  Enlarge text
</button>
```

然后当在父组件中监听这个事件时，我们可以通过 `$event` 访问到被抛出的这个值：

```html
<blog-post ... v-on:enlarge-text="postFontSize += $event"></blog-post>
```

或者，如果这个事件处理器是一个方法：

```html
<blog-post ... v-on:enlarge-text="onEnlargeText"></blog-post>
```

那么这个值将会作为第一个参数传入这个方法：

```javascript
methods: {
  onEnlargeText(enlargeAmount) {
    this.postFontSize += enlargeAmount
  }
}
```

### 在组件上使用 v-model

自定义事件也可以用于创建支持 `v-model` 的自定义输入组件。回忆一下：

```html
<input v-model="searchText" />
```

等价于：

```html
<input
  :value="searchText"
  @input="searchText = $event.target.value"
/>
```

当用在组件上时，`v-model` 则会这样：

```html
<custom-input
  :model-value="searchText"
  @update:model-value="searchText = $event"
></custom-input>
```

::: warning 注意
为了让它正常工作，这个组件内的 `<input>` 必须：

- 将其 `value` attribute 绑定到一个名叫 `modelValue` 的 prop 上
- 在其 `input` 事件被触发时，将新的值通过自定义的 `update:modelValue` 事件抛出

```html
<!-- CustomInput.vue -->
<script>
export default {
  props: ['modelValue'],
  emits: ['update:modelValue']
}
</script>

<template>
  <input
    :value="modelValue"
    @input="$emit('update:modelValue', $event.target.value)"
  />
</template>
```

现在 `v-model` 就可以在这个组件上完美地工作起来了：

```html
<custom-input v-model="searchText"></custom-input>
```

:::

## 最佳实践

### 使用方法处理复杂逻辑

```html
<!-- 不推荐 -->
<button @click="count += 1; totalPrice = count * price; saveToLocalStorage()"></button>

<!-- 推荐 -->
<button @click="incrementCounter">Increment</button>
```

```javascript
export default {
  methods: {
    incrementCounter() {
      this.count += 1
      this.totalPrice = this.count * this.price
      this.saveToLocalStorage()
    }
  }
}
```

### 使用事件修饰符简化代码

```html
<!-- 不推荐 -->
<button @click="handleSubmit">Submit</button>
```

```javascript
methods: {
  handleSubmit(event) {
    event.preventDefault()
    // 提交逻辑
  }
}
```

```html
<!-- 推荐 -->
<button @click.prevent="handleSubmit">Submit</button>
```

### 自定义事件命名约定

```javascript
// 推荐的事件命名
this.$emit('user-updated', userData)
this.$emit('item-deleted', itemId)
this.$emit('form-submitted', formData)

// 避免的命名
this.$emit('update')  // 太通用
this.$emit('change')  // 太通用
this.$emit('click')   // 与原生事件冲突
```

### 事件参数验证

```javascript
export default {
  emits: {
    // 无验证
    click: null,

    // 带验证
    submit: (payload) => {
      if (payload && typeof payload === 'object') {
        return payload.hasOwnProperty('email') && payload.hasOwnProperty('password')
      }
      return false
    }
  }
}
```

### 事件委托优化

```html
<!-- 对于大量动态元素，使用事件委托 -->
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
    if (itemId) {
      // 处理点击逻辑
    }
  }
}
```

### 防抖和节流

```javascript
export default {
  methods: {
    // 防抖：延迟执行
    debouncedSearch: _.debounce(function(query) {
      this.searchAPI(query)
    }, 300),

    // 节流：限制执行频率
    throttledScroll: _.throttle(function() {
      this.handleScroll()
    }, 100)
  }
}
```

```html
<input @input="debouncedSearch($event.target.value)" />
<div @scroll="throttledScroll">...</div>
```

## 性能考虑

### 避免在循环中绑定事件

```html
<!-- 不推荐 -->
<button v-for="item in items" :key="item.id" @click="handleClick(item)">
  {{ item.name }}
</button>

<!-- 推荐 -->
<div @click="handleContainerClick">
  <button v-for="item in items" :key="item.id" :data-id="item.id">
    {{ item.name }}
  </button>
</div>
```

```javascript
methods: {
  handleContainerClick(event) {
    const itemId = event.target.dataset.id
    const item = this.items.find(item => item.id === itemId)
    if (item) {
      this.handleClick(item)
    }
  }
}
```

### 清理事件监听器

```javascript
export default {
  mounted() {
    // 添加全局事件监听器
    window.addEventListener('resize', this.handleResize)
    document.addEventListener('click', this.handleDocumentClick)
  },

  beforeUnmount() {
    // 清理事件监听器
    window.removeEventListener('resize', this.handleResize)
    document.removeEventListener('click', this.handleDocumentClick)
  },

  methods: {
    handleResize() {
      // 处理窗口大小变化
    },

    handleDocumentClick(event) {
      // 处理文档点击
    }
  }
}
```

::: warning 注意事项
- 事件修饰符的顺序很重要
- 系统修饰符必须在其他修饰符之前
- 自定义事件名称应该避免与原生事件冲突
- 在组件销毁前清理事件监听器
- 避免在模板中直接修改数据
:::









