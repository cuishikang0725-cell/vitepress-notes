---
title: Vue 响应式原理
description: 深入理解 Vue 的响应式系统和数据绑定机制
---

# Vue 响应式原理

## 什么是响应式

响应式是一种允许我们以声明式的方式去适应变化的编程范例。在 Vue 中，这意味着当数据发生变化时，视图会自动更新。

## Vue 2 的响应式实现

### Object.defineProperty

Vue 2 使用 `Object.defineProperty` 来实现响应式：

```javascript
function reactive(obj) {
  Object.keys(obj).forEach(key => {
    let value = obj[key]
    Object.defineProperty(obj, key, {
      get() {
        // 收集依赖
        return value
      },
      set(newValue) {
        if (value !== newValue) {
          value = newValue
          // 触发更新
        }
      }
    })
  })
  return obj
}
```

### 依赖收集与触发更新

```javascript
class Dep {
  constructor() {
    this.subscribers = []
  }

  depend() {
    if (window.target) {
      this.subscribers.push(window.target)
    }
  }

  notify() {
    this.subscribers.forEach(sub => sub())
  }
}
```

## Vue 3 的响应式系统

### Proxy 替代 Object.defineProperty

```javascript
function reactive(target) {
  return new Proxy(target, {
    get(target, key) {
      // 收集依赖
      return Reflect.get(target, key)
    },
    set(target, key, value) {
      // 触发更新
      return Reflect.set(target, key, value)
    }
  })
}
```

### 优势

- 支持数组的所有操作
- 支持 Map、Set 等数据结构
- 性能更优（不需要递归遍历所有属性）

## 响应式数据的限制

### Vue 2 的限制

```javascript
const vm = new Vue({
  data() {
    return {
      obj: { a: 1 }
    }
  }
})

// 不会触发更新
vm.obj.b = 2

// 需要使用 Vue.set
Vue.set(vm.obj, 'b', 2)
```

### Vue 3 的改进

```javascript
const reactiveObj = reactive({ a: 1 })

// 可以正常工作
reactiveObj.b = 2
```

## 深层响应式 vs 浅层响应式

```javascript
// 深层响应式（默认）
const deep = reactive({
  nested: {
    count: 0
  }
})

// 浅层响应式
const shallow = shallowReactive({
  nested: {
    count: 0
  }
})
```

## 计算属性与监听器

### 计算属性

```javascript
const vm = Vue.createApp({
  data() {
    return {
      firstName: 'John',
      lastName: 'Doe'
    }
  },
  computed: {
    fullName() {
      return `${this.firstName} ${this.lastName}`
    }
  }
})
```

### 监听器

```javascript
const vm = Vue.createApp({
  data() {
    return { count: 0 }
  },
  watch: {
    count(newVal, oldVal) {
      console.log(`count changed from ${oldVal} to ${newVal}`)
    }
  }
})
```

::: tip 关键点
- Vue 3 使用 Proxy，Vue 2 使用 Object.defineProperty
- 响应式系统自动收集依赖并在数据变化时触发更新
- 理解响应式的限制有助于避免常见的坑
:::

::: warning 练习
1. 创建一个响应式对象，尝试添加新属性并观察是否触发更新
2. 对比 Vue 2 和 Vue 3 中数组操作的响应式表现
:::
