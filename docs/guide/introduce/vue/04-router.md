---
title: Vue Router 用法
description: Vue.js 官方路由管理器的使用方法和最佳实践
---

# Vue Router 用法

## 什么是 Vue Router

Vue Router 是 Vue.js 的官方路由管理器。它与 Vue.js 核心深度集成，让构建单页面应用变得轻而易举。

## 基本使用

### 安装和配置

```bash
npm install vue-router@4
```

```javascript
import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', component: Home },
  { path: '/about', component: About }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

const app = Vue.createApp(App)
app.use(router)
app.mount('#app')
```

### 路由配置

```javascript
const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/about',
    name: 'About',
    component: About
  },
  {
    path: '/user/:id',
    name: 'User',
    component: User,
    props: true
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: NotFound
  }
]
```

## 路由组件

### 路由视图

```vue
<template>
  <div>
    <router-view />
  </div>
</template>
```

### 导航链接

```vue
<template>
  <div>
    <router-link to="/">首页</router-link>
    <router-link to="/about">关于</router-link>
    <router-link :to="{ name: 'User', params: { id: 123 }}">用户详情</router-link>
  </div>
</template>
```

### 编程式导航

```javascript
import { useRouter } from 'vue-router'

export default {
  setup() {
    const router = useRouter()

    const goToUser = (userId) => {
      router.push(`/user/${userId}`)
    }

    const goBack = () => {
      router.go(-1)
    }

    const replaceRoute = () => {
      router.replace('/about')
    }

    return {
      goToUser,
      goBack,
      replaceRoute
    }
  }
}
```

## 动态路由匹配

### 路由参数

```javascript
// 路由配置
{
  path: '/user/:id',
  component: User,
  props: true
}

// 组件接收参数
export default {
  props: ['id'],
  setup(props) {
    console.log(props.id) // 路由中的 id 参数
  }
}
```

### 响应路由参数的变化

```javascript
import { useRoute } from 'vue-router'

export default {
  setup() {
    const route = useRoute()

    // 监听路由参数变化
    watch(() => route.params.id, (newId) => {
      // 处理参数变化
      fetchUser(newId)
    })

    return {}
  }
}
```

## 嵌套路由

```javascript
const routes = [
  {
    path: '/user/:id',
    component: User,
    children: [
      {
        path: '',
        component: UserHome
      },
      {
        path: 'profile',
        component: UserProfile
      },
      {
        path: 'posts',
        component: UserPosts
      }
    ]
  }
]
```

```vue
<!-- User.vue -->
<template>
  <div>
    <h2>User {{ $route.params.id }}</h2>
    <router-view />
  </div>
</template>
```

## 路由守卫

### 全局前置守卫

```javascript
router.beforeEach((to, from) => {
  // 检查用户是否已登录
  if (to.name !== 'Login' && !isAuthenticated) {
    return { name: 'Login' }
  }
})
```

### 路由独享的守卫

```javascript
{
  path: '/admin',
  component: Admin,
  beforeEnter: (to, from) => {
    if (!isAdmin()) {
      return '/login'
    }
  }
}
```

### 组件内的守卫

```javascript
export default {
  beforeRouteEnter(to, from, next) {
    // 在渲染该组件的对应路由被 confirm 前调用
    next()
  },
  beforeRouteUpdate(to, from, next) {
    // 在当前路由改变，但是该组件被复用时调用
    next()
  },
  beforeRouteLeave(to, from, next) {
    // 导航离开该组件的对应路由时调用
    const answer = window.confirm('确定要离开吗？')
    if (answer) {
      next()
    } else {
      next(false)
    }
  }
}
```

## 路由懒加载

```javascript
const routes = [
  {
    path: '/about',
    component: () => import('./views/About.vue')
  },
  {
    path: '/user',
    component: () => import('./views/User.vue'),
    children: [
      {
        path: 'profile',
        component: () => import('./views/UserProfile.vue')
      }
    ]
  }
]
```

## 滚动行为

```javascript
const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  }
})
```

## 路由元信息

```javascript
const routes = [
  {
    path: '/admin',
    component: Admin,
    meta: {
      requiresAuth: true,
      title: '管理员页面'
    }
  }
]

// 在守卫中使用
router.beforeEach((to, from) => {
  if (to.meta.requiresAuth && !isAuthenticated) {
    return '/login'
  }
  document.title = to.meta.title || '默认标题'
})
```

::: tip 最佳实践
- 使用命名路由而不是硬编码路径
- 为路由添加元信息便于权限控制
- 使用路由懒加载优化首屏加载
- 合理使用路由守卫处理认证和权限
:::

::: warning 注意事项
- Vue Router 4 只支持 Vue 3
- 路由组件会被自动复用，需要注意数据更新
- 动态路由参数变化时组件不会重新创建
:::

::: warning 练习
1. 创建一个包含嵌套路由的用户管理页面
2. 实现登录路由守卫
3. 使用路由懒加载优化应用性能
:::
