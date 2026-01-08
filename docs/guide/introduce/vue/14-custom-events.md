---
title: 自定义事件
description: Vue.js 组件自定义事件的完整指南
sidebarDepth: 2
---

# 自定义事件

## 事件名

不同于组件和 prop，事件名不存在任何自动化的大小写转换。而是触发的事件名需要完全匹配监听这个事件时所用的名称。

```html
<!-- 子组件 -->
<template>
  <button @click="$emit('myEvent')">
    Click me
  </button>
</template>

<!-- 父组件 -->
<template>
  <child-component @my-event="handleEvent" />
</template>
```

如果你在子组件中触发一个 camelCase 名字的事件：

```javascript
// 子组件
this.$emit('myEvent')
```

```html
<!-- 父组件 -->
<child-component @my-event="doSomething" />
```

那么在父组件中是监听不到的。你需要使用 kebab-case 来监听：

```html
<!-- 父组件 -->
<child-component @myevent="doSomething" />
```

或者直接使用 camelCase：

```html
<!-- 父组件 -->
<child-component @myEvent="doSomething" />
```

## 定义自定义事件

在 Vue 3 中，推荐使用 `emits` 选项来定义组件可能触发的事件：

```javascript
export default {
  emits: ['in-focus', 'submit-form'],
  created() {
    // Vue 会检查 emits 选项是否包含原生事件
    // 并在触发时提供警告
  },
  methods: {
    buttonClick() {
      // 触发自定义事件
      this.$emit('submit-form', {
        email: this.email,
        password: this.password
      })
    }
  }
}
```

## 验证自定义事件

与 prop 类型验证类似，自定义事件也可以通过 `emits` 选项进行验证：

```javascript
export default {
  emits: {
    // 没有验证
    click: null,

    // 带验证
    submit: ({ email, password }) => {
      if (email && password) {
        return true
      } else {
        console.warn('Invalid submit event payload!')
        return false
      }
    }
  },
  methods: {
    submitForm(email, password) {
      this.$emit('submit', { email, password })
    }
  }
}
```

## 触发事件

### 使用 $emit

在组件中，我们可以通过调用 `this.$emit` 方法并传入事件名称来触发一个自定义事件：

```javascript
export default {
  methods: {
    deleteItem() {
      this.$emit('delete', this.item.id)
    }
  }
}
```

### 传递参数

可以向 `$emit` 传递额外的参数，这些参数将会传递给事件监听器：

```javascript
this.$emit('update', this.value, this.oldValue)
```

```html
<!-- 父组件 -->
<child-component @update="(value, oldValue) => handleUpdate(value, oldValue)" />
```

### 模板中的事件触发

在模板中，可以直接使用 `$emit`：

```html
<button @click="$emit('click')">Click me</button>
```

也可以传递参数：

```html
<button @click="$emit('submit', formData)">Submit</button>
```

## 监听事件

### 在父组件中监听

父组件可以通过 `v-on` 或 `@` 来监听子组件触发的事件：

```html
<!-- 完整语法 -->
<child-component v-on:my-event="handleEvent" />

<!-- 缩写 -->
<child-component @my-event="handleEvent" />
```

### 事件处理函数

```javascript
export default {
  methods: {
    handleEvent(data) {
      console.log('Event received:', data)
    }
  }
}
```

### 内联事件处理器

```html
<child-component @my-event="count += 1" />
```

或者使用方法：

```html
<child-component @my-event="handleEvent($event)" />
```

```javascript
methods: {
  handleEvent(eventData) {
    // 处理事件数据
  }
}
```

## 事件修饰符

Vue 为事件处理提供了几种修饰符：

### .stop

```html
<!-- 阻止事件冒泡 -->
<button @click.stop="handleClick">Click me</button>
```

### .prevent

```html
<!-- 阻止默认行为 -->
<form @submit.prevent="handleSubmit">...</form>
```

### .capture

```html
<!-- 添加事件监听器时使用事件捕获模式 -->
<div @click.capture="handleClick">...</div>
```

### .self

```html
<!-- 只当事件是从事件绑定的元素本身触发时才触发回调 -->
<div @click.self="handleClick">...</div>
```

### .once

```html
<!-- 点击事件将只会触发一次 -->
<button @click.once="handleClick">Click me</button>
```

### .passive

```html
<!-- 滚动事件的默认行为 (即滚动行为) 将会立即触发 -->
<div @scroll.passive="handleScroll">...</div>
```

## 自定义事件的最佳实践

### 1. 使用 kebab-case 命名事件

```javascript
// 子组件
this.$emit('user-updated')

// 父组件
<child-component @user-updated="handleUpdate" />
```

### 2. 总是声明 emits 选项

```javascript
export default {
  emits: ['update', 'delete', 'submit'],
  // ...
}
```

### 3. 事件名应该具有描述性

```javascript
// 好的事件名
this.$emit('item-selected', item)
this.$emit('user-authenticated', user)
this.$emit('form-validation-failed', errors)

// 不好的事件名
this.$emit('change')
this.$emit('update')
this.$emit('click')
```

### 4. 传递有意义的数据

```javascript
// 推荐：传递完整的对象
this.$emit('user-updated', { id: 1, name: 'John', email: 'john@example.com' })

// 避免：只传递ID，让父组件自己查找
this.$emit('user-updated', 1)
```

## 高级用法

### 动态事件名

```html
<child-component @[eventName]="handleEvent" />
```

```javascript
export default {
  data() {
    return {
      eventName: 'click'
    }
  }
}
```

### 事件总线 (Event Bus)

虽然不推荐在 Vue 3 中使用，但了解如何实现是有用的：

```javascript
// eventBus.js
import { createApp } from 'vue'

const eventBus = createApp({}).config.globalProperties.$eventBus = {}

export default eventBus

// 使用
import eventBus from './eventBus'

// 发送事件
eventBus.$emit('user-logged-in', userData)

// 监听事件
eventBus.$on('user-logged-in', handleLogin)
```

### 跨组件通信

对于复杂的应用，可以使用 Vuex 或 Pinia 来管理状态，而不是依赖事件总线。

### 组合式函数中的事件

```javascript
// useForm.js
import { ref, reactive } from 'vue'

export function useForm(emit) {
  const form = reactive({
    email: '',
    password: ''
  })

  const submit = () => {
    emit('submit', { ...form })
  }

  const reset = () => {
    form.email = ''
    form.password = ''
    emit('reset')
  }

  return {
    form,
    submit,
    reset
  }
}

// 在组件中使用
export default {
  emits: ['submit', 'reset'],
  setup(props, { emit }) {
    return useForm(emit)
  }
}
```

## 常见模式

### 双向绑定 (v-model)

自定义事件最常见的用途之一是创建支持 `v-model` 的组件：

```javascript
export default {
  props: ['modelValue'],
  emits: ['update:modelValue'],
  methods: {
    handleInput(event) {
      this.$emit('update:modelValue', event.target.value)
    }
  }
}
```

```html
<template>
  <input
    :value="modelValue"
    @input="handleInput"
  />
</template>
```

### 表单组件

```javascript
// BaseInput.vue
export default {
  props: {
    modelValue: String,
    label: String,
    type: {
      type: String,
      default: 'text'
    }
  },
  emits: ['update:modelValue', 'blur', 'focus'],
  methods: {
    handleInput(event) {
      this.$emit('update:modelValue', event.target.value)
    },
    handleBlur() {
      this.$emit('blur')
    },
    handleFocus() {
      this.$emit('focus')
    }
  }
}
```

```html
<template>
  <div class="form-group">
    <label v-if="label">{{ label }}</label>
    <input
      :type="type"
      :value="modelValue"
      @input="handleInput"
      @blur="handleBlur"
      @focus="handleFocus"
    />
  </div>
</template>
```

### 列表组件

```javascript
// ItemList.vue
export default {
  props: {
    items: {
      type: Array,
      default: () => []
    }
  },
  emits: ['item-click', 'item-delete'],
  methods: {
    handleItemClick(item, index) {
      this.$emit('item-click', { item, index })
    },
    handleItemDelete(item, index) {
      this.$emit('item-delete', { item, index })
    }
  }
}
```

```html
<template>
  <ul class="item-list">
    <li
      v-for="(item, index) in items"
      :key="item.id"
      @click="handleItemClick(item, index)"
    >
      {{ item.name }}
      <button @click.stop="handleItemDelete(item, index)">Delete</button>
    </li>
  </ul>
</template>
```

### 通知组件

```javascript
// Notification.vue
export default {
  props: {
    type: {
      type: String,
      default: 'info',
      validator: value => ['info', 'success', 'warning', 'error'].includes(value)
    },
    message: {
      type: String,
      required: true
    },
    duration: {
      type: Number,
      default: 3000
    },
    closable: {
      type: Boolean,
      default: true
    }
  },
  emits: ['close'],
  mounted() {
    if (this.duration > 0) {
      setTimeout(() => {
        this.handleClose()
      }, this.duration)
    }
  },
  methods: {
    handleClose() {
      this.$emit('close')
    }
  }
}
```

```html
<template>
  <div :class="['notification', `notification--${type}`]">
    <span class="notification__message">{{ message }}</span>
    <button
      v-if="closable"
      class="notification__close"
      @click="handleClose"
    >
      ×
    </button>
  </div>
</template>
```

## 性能考虑

### 避免过度触发事件

```javascript
// 不推荐：每次输入都触发
watch: {
  searchQuery() {
    this.$emit('search', this.searchQuery)
  }
}

// 推荐：使用防抖
import _ from 'lodash'

export default {
  watch: {
    searchQuery: _.debounce(function() {
      this.$emit('search', this.searchQuery)
    }, 300)
  }
}
```

### 使用 v-once 优化静态事件

```html
<!-- 对于不会改变的事件处理器 -->
<button @click.once="handleSubmit">Submit</button>
```

### 清理事件监听器

```javascript
export default {
  mounted() {
    // 添加自定义事件监听器
    this.$on('custom-event', this.handleCustomEvent)
  },
  beforeUnmount() {
    // 清理事件监听器
    this.$off('custom-event', this.handleCustomEvent)
  }
}
```

::: warning 注意事项
- 事件名区分大小写
- 自定义事件不会冒泡
- 使用 `emits` 选项声明所有可能触发的事件
- 避免在事件处理器中修改 props
- 合理使用事件修饰符来控制事件行为
:::









