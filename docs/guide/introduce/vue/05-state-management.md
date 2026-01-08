---
title: 状态管理：Pinia vs Vuex
description: Vue 生态中的状态管理方案对比和使用指南
---

# 状态管理：Pinia vs Vuex

## 什么是状态管理

状态管理是处理复杂应用中数据流向和状态同步的解决方案。在 Vue 应用中，当多个组件需要共享和修改同一份数据时，就需要状态管理。

## Vuex 4 (Vue 3 版本)

### 基本概念

```javascript
// store.js
import { createStore } from 'vuex'

const store = createStore({
  state: {
    count: 0,
    todos: []
  },
  getters: {
    doneTodos: (state) => {
      return state.todos.filter(todo => todo.done)
    }
  },
  mutations: {
    increment(state) {
      state.count++
    },
    addTodo(state, todo) {
      state.todos.push(todo)
    }
  },
  actions: {
    async fetchTodos({ commit }) {
      const todos = await fetch('/api/todos')
      commit('addTodo', todos)
    }
  },
  modules: {
    // 子模块
  }
})

export default store
```

### 在组件中使用

```javascript
import { useStore } from 'vuex'

export default {
  setup() {
    const store = useStore()

    const increment = () => {
      store.commit('increment')
    }

    const addTodo = () => {
      store.dispatch('addTodo', { text: 'New todo', done: false })
    }

    return {
      count: computed(() => store.state.count),
      increment,
      addTodo
    }
  }
}
```

## Pinia (Vue 官方推荐)

### 基本使用

```javascript
// stores/counter.js
import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter', {
  state: () => ({
    count: 0
  }),
  getters: {
    doubleCount: (state) => state.count * 2
  },
  actions: {
    increment() {
      this.count++
    },
    async fetchData() {
      const data = await fetch('/api/data')
      this.data = data
    }
  }
})
```

### 在组件中使用

```javascript
import { useCounterStore } from '@/stores/counter'

export default {
  setup() {
    const counterStore = useCounterStore()

    const increment = () => {
      counterStore.increment()
    }

    return {
      counterStore,
      increment
    }
  }
}
```

## Pinia vs Vuex 对比

### 类型支持

**Pinia：**
```typescript
// 完整的 TypeScript 支持
export const useUserStore = defineStore('user', {
  state: () => ({
    name: 'John',
    age: 30
  }),
  getters: {
    fullInfo: (state) => `${state.name} (${state.age})`
  },
  actions: {
    updateName(name: string) {
      this.name = name
    }
  }
})

// 在组件中自动推断类型
const userStore = useUserStore()
userStore.name // string
userStore.fullInfo // string
```

### 组合式 API 支持

**Pinia：**
```javascript
// 支持组合式函数
export function useCounter() {
  const count = ref(0)
  const doubleCount = computed(() => count.value * 2)

  function increment() {
    count.value++
  }

  return {
    count,
    doubleCount,
    increment
  }
}

// 在 Store 中使用
export const useCounterStore = defineStore('counter', () => {
  const count = ref(0)
  const doubleCount = computed(() => count.value * 2)

  function increment() {
    count.value++
  }

  return {
    count,
    doubleCount,
    increment
  }
})
```

### 插件系统

**Pinia 插件：**
```javascript
// plugins/persist.js
export function persist({ store }) {
  const stored = localStorage.getItem(`store-${store.$id}`)
  if (stored) {
    store.$patch(JSON.parse(stored))
  }

  store.$subscribe((mutation, state) => {
    localStorage.setItem(`store-${store.$id}`, JSON.stringify(state))
  })
}

// main.js
app.use(createPinia().use(persist))
```

### 调试工具

**Pinia DevTools：**
- 自动集成到 Vue DevTools
- 时间旅行调试
- 状态快照
- 更好的性能监控

## 实际应用场景

### 用户认证状态

```javascript
// stores/auth.js
import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    token: null
  }),
  getters: {
    isAuthenticated: (state) => !!state.token
  },
  actions: {
    async login(credentials) {
      try {
        const response = await api.login(credentials)
        this.token = response.token
        this.user = response.user
        return true
      } catch (error) {
        return false
      }
    },
    logout() {
      this.token = null
      this.user = null
    }
  }
})
```

### 购物车功能

```javascript
// stores/cart.js
export const useCartStore = defineStore('cart', {
  state: () => ({
    items: []
  }),
  getters: {
    totalPrice: (state) => {
      return state.items.reduce((total, item) => {
        return total + item.price * item.quantity
      }, 0)
    }
  },
  actions: {
    addItem(product) {
      const existingItem = this.items.find(item => item.id === product.id)
      if (existingItem) {
        existingItem.quantity++
      } else {
        this.items.push({ ...product, quantity: 1 })
      }
    },
    removeItem(productId) {
      const index = this.items.findIndex(item => item.id === productId)
      if (index > -1) {
        this.items.splice(index, 1)
      }
    }
  }
})
```

## 迁移指南

### 从 Vuex 迁移到 Pinia

```javascript
// Vuex
const store = createStore({
  state: { count: 0 },
  mutations: {
    increment(state) { state.count++ }
  },
  actions: {
    asyncIncrement({ commit }) {
      setTimeout(() => commit('increment'), 1000)
    }
  }
})

// Pinia
const useStore = defineStore('main', {
  state: () => ({ count: 0 }),
  actions: {
    increment() { this.count++ },
    asyncIncrement() {
      setTimeout(() => this.increment(), 1000)
    }
  }
})
```

## 最佳实践

1. **按功能划分 Store**：每个 Store 负责一个功能模块
2. **使用 TypeScript**：获得更好的类型安全
3. **合理使用插件**：如持久化、日志等
4. **避免过度抽象**：保持 Store 逻辑清晰
5. **测试 Store**：确保状态管理的可靠性

::: tip 推荐
对于新项目，推荐使用 Pinia：
- 更好的 TypeScript 支持
- 更直观的 API
- 更小的包体积
- 官方维护
:::

::: warning 迁移注意
Vuex 仍然是 Vue 2 的推荐选择，Vuex 4 主要用于兼容 Vue 3 的项目迁移。
:::
