---
title: Composition API 要点
description: Vue 3 Composition API 的核心概念和使用方法
---

# Composition API 要点

## 什么是 Composition API

Composition API 是 Vue 3 的新特性，它提供了一种更灵活的方式来组织组件的逻辑。与 Options API 相比，它提供了更好的代码组织和逻辑复用能力。

## 核心函数

### setup 函数

`setup` 是 Composition API 的入口点：

```javascript
import { ref, computed, onMounted } from 'vue'

export default {
  setup() {
    // 响应式数据
    const count = ref(0)

    // 计算属性
    const doubleCount = computed(() => count.value * 2)

    // 方法
    const increment = () => {
      count.value++
    }

    // 生命周期钩子
    onMounted(() => {
      console.log('Component mounted')
    })

    return {
      count,
      doubleCount,
      increment
    }
  }
}
```

### 响应式数据

#### ref

```javascript
import { ref } from 'vue'

const count = ref(0)
// 访问值
console.log(count.value)
// 修改值
count.value = 1
```

#### reactive

```javascript
import { reactive } from 'vue'

const state = reactive({
  count: 0,
  name: 'Vue'
})

// 直接修改
state.count++
state.name = 'Composition API'
```

### 计算属性

```javascript
import { ref, computed } from 'vue'

const firstName = ref('John')
const lastName = ref('Doe')

const fullName = computed(() => {
  return `${firstName.value} ${lastName.value}`
})

// 只读计算属性
const fullNameUpper = computed(() => {
  return fullName.value.toUpperCase()
})

// 可写的计算属性
const writableComputed = computed({
  get() {
    return firstName.value + ' ' + lastName.value
  },
  set(newValue) {
    const [first, last] = newValue.split(' ')
    firstName.value = first
    lastName.value = last
  }
})
```

### 监听器

#### watch

```javascript
import { ref, watch } from 'vue'

const count = ref(0)

watch(count, (newVal, oldVal) => {
  console.log(`count changed from ${oldVal} to ${newVal}`)
})

// 监听多个值
watch([count, name], ([newCount, newName], [oldCount, oldName]) => {
  // 处理多个值的变化
})

// 监听对象
const state = reactive({ count: 0 })
watch(
  () => state.count,
  (newVal, oldVal) => {
    console.log('state.count changed')
  }
)
```

#### watchEffect

```javascript
import { ref, watchEffect } from 'vue'

const count = ref(0)
const name = ref('Vue')

watchEffect(() => {
  console.log(`Count: ${count.value}, Name: ${name.value}`)
  // 每次 count 或 name 变化时都会执行
})
```

## 生命周期钩子

```javascript
import {
  onBeforeMount,
  onMounted,
  onBeforeUpdate,
  onUpdated,
  onBeforeUnmount,
  onUnmounted
} from 'vue'

export default {
  setup() {
    onBeforeMount(() => {
      console.log('before mount')
    })

    onMounted(() => {
      console.log('mounted')
    })

    onBeforeUpdate(() => {
      console.log('before update')
    })

    onUpdated(() => {
      console.log('updated')
    })

    onBeforeUnmount(() => {
      console.log('before unmount')
    })

    onUnmounted(() => {
      console.log('unmounted')
    })
  }
}
```

## 逻辑复用

### 组合函数 (Composables)

```javascript
// useCounter.js
import { ref, computed } from 'vue'

export function useCounter(initialValue = 0) {
  const count = ref(initialValue)

  const doubleCount = computed(() => count.value * 2)

  const increment = () => count.value++
  const decrement = () => count.value--

  return {
    count,
    doubleCount,
    increment,
    decrement
  }
}

// 在组件中使用
import { useCounter } from './useCounter.js'

export default {
  setup() {
    const { count, doubleCount, increment, decrement } = useCounter(10)

    return {
      count,
      doubleCount,
      increment,
      decrement
    }
  }
}
```

## 模板引用

```javascript
import { ref, onMounted } from 'vue'

export default {
  setup() {
    const inputRef = ref(null)

    onMounted(() => {
      inputRef.value.focus()
    })

    return {
      inputRef
    }
  },
  template: `
    <input ref="inputRef" type="text" />
  `
}
```

::: tip 优势
- 更好的 TypeScript 支持
- 代码组织更清晰
- 逻辑复用更容易
- 性能优化更灵活
:::

::: warning 注意事项
- `setup` 函数在 `beforeCreate` 之前执行
- 组合函数需要返回要在模板中使用的数据和方法
- 避免在 `setup` 中使用 `this`
:::

::: warning 练习
1. 创建一个计数器组件，使用 Composition API
2. 实现一个可复用的表单验证组合函数
3. 使用 `watchEffect` 监听多个响应式数据的变化
:::
