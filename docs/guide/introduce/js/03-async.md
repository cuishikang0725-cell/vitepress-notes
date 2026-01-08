---
title: 异步编程：Promise / async-await
description: JavaScript 异步编程模式详解和最佳实践
---

# 异步编程：Promise / async-await

## 为什么需要异步编程

JavaScript 是单线程语言，但很多操作（如网络请求、文件读写）需要等待。为了不阻塞主线程，我们需要异步编程。

### 同步 vs 异步

```javascript
// 同步代码（阻塞）
console.log('Start')
const result = someLongRunningTask() // 阻塞直到完成
console.log('Result:', result)
console.log('End')

// 异步代码（非阻塞）
console.log('Start')
someLongRunningTask(result => {
  console.log('Result:', result)
  console.log('End')
})
console.log('This runs immediately')
```

## 回调函数 (Callback)

### 基本回调

```javascript
function fetchData(callback) {
  setTimeout(() => {
    const data = { id: 1, name: 'John' }
    callback(data)
  }, 1000)
}

fetchData(data => {
  console.log('Received data:', data)
})
```

### 回调地狱 (Callback Hell)

```javascript
fetchUser(1, user => {
  fetchPosts(user.id, posts => {
    fetchComments(posts[0].id, comments => {
      console.log('Comments:', comments)
    }, error => {
      console.error('Error fetching comments:', error)
    })
  }, error => {
    console.error('Error fetching posts:', error)
  })
}, error => {
  console.error('Error fetching user:', error)
})
```

## Promise 基础

### 创建 Promise

```javascript
const promise = new Promise((resolve, reject) => {
  // 异步操作
  setTimeout(() => {
    const success = Math.random() > 0.5
    if (success) {
      resolve('Success!')
    } else {
      reject(new Error('Failed!'))
    }
  }, 1000)
})
```

### 使用 Promise

```javascript
promise
  .then(result => {
    console.log('Success:', result)
    return result + ' Done'
  })
  .then(finalResult => {
    console.log('Final:', finalResult)
  })
  .catch(error => {
    console.error('Error:', error.message)
  })
  .finally(() => {
    console.log('Always executed')
  })
```

### Promise 静态方法

#### Promise.all

```javascript
const promise1 = fetch('/api/user')
const promise2 = fetch('/api/posts')
const promise3 = fetch('/api/comments')

Promise.all([promise1, promise2, promise3])
  .then(([user, posts, comments]) => {
    console.log('All data loaded:', { user, posts, comments })
  })
  .catch(error => {
    console.error('One of the requests failed:', error)
  })

// 如果任意一个失败，整个 Promise.all 失败
```

#### Promise.race

```javascript
const fastApi = fetch('/api/fast')
const slowApi = fetch('/api/slow')

Promise.race([fastApi, slowApi])
  .then(result => {
    console.log('First to complete:', result)
  })
  .catch(error => {
    console.error('First to fail:', error)
  })
```

#### Promise.allSettled

```javascript
Promise.allSettled([promise1, promise2, promise3])
  .then(results => {
    results.forEach((result, index) => {
      if (result.status === 'fulfilled') {
        console.log(`Promise ${index} succeeded:`, result.value)
      } else {
        console.log(`Promise ${index} failed:`, result.reason)
      }
    })
  })
```

#### Promise.any (ES2021)

```javascript
Promise.any([promise1, promise2, promise3])
  .then(result => {
    console.log('First successful result:', result)
  })
  .catch(error => {
    console.error('All promises failed:', error)
  })
```

## async/await 语法糖

### 基本使用

```javascript
async function fetchUserData() {
  try {
    const user = await fetch('/api/user')
    const posts = await fetch(`/api/posts/${user.id}`)
    const comments = await fetch(`/api/comments/${posts[0].id}`)

    console.log('All data:', { user, posts, comments })
  } catch (error) {
    console.error('Error:', error)
  }
}

// 等价于 Promise 链式调用
function fetchUserDataPromise() {
  return fetch('/api/user')
    .then(user => fetch(`/api/posts/${user.id}`))
    .then(posts => fetch(`/api/comments/${posts[0].id}`))
    .then(comments => {
      console.log('All data:', { user, posts, comments })
    })
    .catch(error => console.error('Error:', error))
}
```

### 并发请求优化

```javascript
// 串行执行（慢）
async function loadDataSlow() {
  const user = await fetch('/api/user/1')
  const posts = await fetch('/api/posts/1')
  const comments = await fetch('/api/comments/1')
  return { user, posts, comments }
}

// 并发执行（快）
async function loadDataFast() {
  const [user, posts, comments] = await Promise.all([
    fetch('/api/user/1'),
    fetch('/api/posts/1'),
    fetch('/api/comments/1')
  ])
  return { user, posts, comments }
}
```

### 错误处理

```javascript
async function fetchData() {
  try {
    const response = await fetch('/api/data')
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    const data = await response.json()
    return data
  } catch (error) {
    if (error.name === 'TypeError') {
      console.error('Network error:', error.message)
    } else {
      console.error('Other error:', error.message)
    }
    throw error // 重新抛出错误
  }
}

// 使用 finally
async function processData() {
  let data
  try {
    data = await fetchData()
    // 处理数据
  } finally {
    // 总是执行的清理代码
    console.log('Cleanup completed')
  }
}
```

## 实际应用示例

### API 请求封装

```javascript
class ApiClient {
  constructor(baseURL) {
    this.baseURL = baseURL
  }

  async request(endpoint, options = {}) {
    const url = `${this.baseURL}${endpoint}`
    const config = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      },
      ...options
    }

    try {
      const response = await fetch(url, config)
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`)
      }
      return await response.json()
    } catch (error) {
      console.error(`API request failed: ${error.message}`)
      throw error
    }
  }

  async get(endpoint) {
    return this.request(endpoint)
  }

  async post(endpoint, data) {
    return this.request(endpoint, {
      method: 'POST',
      body: JSON.stringify(data)
    })
  }
}

// 使用
const api = new ApiClient('https://api.example.com')

async function loadUserProfile(userId) {
  try {
    const user = await api.get(`/users/${userId}`)
    const posts = await api.get(`/users/${userId}/posts`)
    return { user, posts }
  } catch (error) {
    console.error('Failed to load user profile:', error)
    return null
  }
}
```

### 重试机制

```javascript
async function fetchWithRetry(url, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const response = await fetch(url)
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`)
      }
      return await response.json()
    } catch (error) {
      if (i === maxRetries - 1) {
        throw error
      }
      console.log(`Attempt ${i + 1} failed, retrying...`)
      await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)))
    }
  }
}
```

### 超时控制

```javascript
function fetchWithTimeout(url, timeout = 5000) {
  return Promise.race([
    fetch(url),
    new Promise((_, reject) =>
      setTimeout(() => reject(new Error('Request timeout')), timeout)
    )
  ])
}

async function safeFetch(url) {
  try {
    const response = await fetchWithTimeout(url, 3000)
    return await response.json()
  } catch (error) {
    if (error.message === 'Request timeout') {
      console.error('Request timed out')
    } else {
      console.error('Request failed:', error)
    }
  }
}
```

## 异步迭代器和生成器

### 异步生成器

```javascript
async function* asyncGenerator() {
  let i = 0
  while (true) {
    await new Promise(resolve => setTimeout(resolve, 1000))
    yield i++
  }
}

// 使用异步生成器
async function consumeAsyncGenerator() {
  const gen = asyncGenerator()
  for await (const value of gen) {
    console.log(value)
    if (value >= 5) break
  }
}
```

## 最佳实践

### 错误处理

```javascript
// ✅ 好的错误处理
async function goodErrorHandling() {
  try {
    const data = await fetchData()
    // 处理成功情况
  } catch (error) {
    // 处理错误情况
    console.error('Error:', error)
    // 可能的重试逻辑或用户提示
  }
}

// ❌ 避免的模式
async function badErrorHandling() {
  const data = await fetchData() // 错误可能被忽略
  // 处理数据...
}
```

### 并发控制

```javascript
// 限制并发数量
async function limitConcurrency(tasks, limit) {
  const results = []
  for (let i = 0; i < tasks.length; i += limit) {
    const batch = tasks.slice(i, i + limit)
    const batchResults = await Promise.all(batch.map(task => task()))
    results.push(...batchResults)
  }
  return results
}
```

### 取消异步操作

```javascript
function cancellableFetch(url) {
  let controller = new AbortController()

  const promise = fetch(url, {
    signal: controller.signal
  })

  promise.cancel = () => controller.abort()

  return promise
}

// 使用
const request = cancellableFetch('/api/data')
setTimeout(() => request.cancel(), 1000) // 1秒后取消
```

::: tip 关键点
- 使用 async/await 让异步代码更易读
- 合理使用 Promise.all 提高性能
- 总是处理错误情况
- 考虑超时和取消机制
:::

::: warning 注意事项
- async 函数总是返回 Promise
- await 只能在 async 函数内使用
- 不要在循环中不必要地使用 await
- 记得处理 Promise 的拒绝状态
:::
