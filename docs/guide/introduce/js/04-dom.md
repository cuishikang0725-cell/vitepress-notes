---
title: DOM 操作与事件
description: 浏览器 DOM API 和事件处理详解
---

# DOM 操作与事件

## DOM 简介

DOM (Document Object Model) 是 HTML 文档的编程接口。它将 HTML 文档表示为节点树，每个节点都是一个对象。

```html
<!DOCTYPE html>
<html>
<head>
  <title>My Page</title>
</head>
<body>
  <div id="container">
    <h1>Hello World</h1>
    <p class="text">This is a paragraph</p>
  </div>
</body>
</html>
```

## 选择元素

### 基本选择器

```javascript
// 通过 ID 选择
const container = document.getElementById('container')

// 通过类名选择（返回 HTMLCollection）
const texts = document.getElementsByClassName('text')

// 通过标签名选择
const paragraphs = document.getElementsByTagName('p')

// 通过 name 属性选择
const inputs = document.getElementsByName('username')
```

### 现代选择器 (querySelector)

```javascript
// 选择第一个匹配的元素
const container = document.querySelector('#container')
const firstText = document.querySelector('.text')
const firstParagraph = document.querySelector('p')

// 选择所有匹配的元素
const allTexts = document.querySelectorAll('.text')
const allParagraphs = document.querySelectorAll('p')

// 复杂选择器
const nestedElement = document.querySelector('div > p.text')
const formInput = document.querySelector('input[type="email"]')
```

### 相对选择

```javascript
const container = document.querySelector('#container')

// 子元素
const children = container.children
const firstChild = container.firstElementChild
const lastChild = container.lastElementChild

// 父元素
const parent = container.parentElement

// 兄弟元素
const nextSibling = container.nextElementSibling
const prevSibling = container.previousElementSibling
```

## 创建和修改元素

### 创建元素

```javascript
// 创建元素
const newDiv = document.createElement('div')
const newParagraph = document.createElement('p')

// 创建文本节点
const textNode = document.createTextNode('Hello World')

// 创建注释
const comment = document.createComment('This is a comment')
```

### 设置属性和内容

```javascript
const div = document.createElement('div')

// 设置属性
div.id = 'myDiv'
div.className = 'container highlight'
div.setAttribute('data-id', '123')
div.setAttribute('title', 'Tooltip text')

// 设置内容
div.textContent = 'Simple text content'
div.innerHTML = '<strong>HTML content</strong>'

// 设置样式
div.style.color = 'red'
div.style.fontSize = '20px'
div.style.cssText = 'color: blue; font-size: 16px;'
```

### 添加到 DOM

```javascript
const container = document.querySelector('#container')
const newElement = document.createElement('p')
newElement.textContent = 'New paragraph'

// 添加到末尾
container.appendChild(newElement)

// 添加到开头
container.insertBefore(newElement, container.firstChild)

// 在指定元素之前插入
const referenceElement = document.querySelector('.reference')
container.insertBefore(newElement, referenceElement)

// 使用现代方法
container.append(newElement)      // 添加到末尾
container.prepend(newElement)     // 添加到开头
container.before(newElement)      // 在元素前插入
container.after(newElement)       // 在元素后插入
```

## 修改和删除元素

### 修改元素

```javascript
const element = document.querySelector('.my-element')

// 修改文本内容
element.textContent = 'New text content'
element.innerHTML = '<em>New HTML content</em>'

// 修改属性
element.id = 'newId'
element.className = 'new-class'
element.setAttribute('data-value', '456')

// 修改样式
element.style.backgroundColor = 'yellow'
element.classList.add('highlight')
element.classList.remove('old-class')
element.classList.toggle('active')
```

### 删除元素

```javascript
const element = document.querySelector('.to-remove')

// 从父元素中删除
element.parentNode.removeChild(element)

// 直接删除（现代方法）
element.remove()

// 清空容器
const container = document.querySelector('#container')
container.innerHTML = ''
// 或者
while (container.firstChild) {
  container.removeChild(container.firstChild)
}
```

## 事件处理

### 基本事件监听

```javascript
const button = document.querySelector('#myButton')

// 添加事件监听器
button.addEventListener('click', function(event) {
  console.log('Button clicked!')
  console.log('Event object:', event)
})

// 移除事件监听器
function handleClick(event) {
  console.log('Button clicked!')
  button.removeEventListener('click', handleClick)
}

button.addEventListener('click', handleClick)
```

### 事件对象

```javascript
button.addEventListener('click', function(event) {
  // 阻止默认行为
  event.preventDefault()

  // 停止事件冒泡
  event.stopPropagation()

  // 事件目标
  console.log('Target:', event.target)
  console.log('Current target:', event.currentTarget)

  // 鼠标事件信息
  if (event.type === 'click') {
    console.log('Mouse position:', event.clientX, event.clientY)
  }

  // 键盘事件信息
  if (event.type === 'keydown') {
    console.log('Key pressed:', event.key)
    console.log('Key code:', event.keyCode)
  }
})
```

### 事件委托

```javascript
// 不好的做法：为每个按钮添加监听器
const buttons = document.querySelectorAll('.btn')
buttons.forEach(button => {
  button.addEventListener('click', handleClick)
})

// 好的做法：事件委托
const container = document.querySelector('.button-container')
container.addEventListener('click', function(event) {
  if (event.target.classList.contains('btn')) {
    handleClick(event)
  }
})
```

## 常见事件类型

### 鼠标事件

```javascript
const element = document.querySelector('.interactive')

element.addEventListener('click', () => console.log('Clicked'))
element.addEventListener('dblclick', () => console.log('Double clicked'))
element.addEventListener('mousedown', () => console.log('Mouse down'))
element.addEventListener('mouseup', () => console.log('Mouse up'))
element.addEventListener('mousemove', () => console.log('Mouse move'))
element.addEventListener('mouseenter', () => console.log('Mouse enter'))
element.addEventListener('mouseleave', () => console.log('Mouse leave'))
```

### 键盘事件

```javascript
const input = document.querySelector('input')

input.addEventListener('keydown', function(event) {
  console.log('Key down:', event.key)
})

input.addEventListener('keyup', function(event) {
  console.log('Key up:', event.key)
})

input.addEventListener('keypress', function(event) {
  console.log('Key press:', event.key)
})
```

### 表单事件

```javascript
const form = document.querySelector('form')
const input = document.querySelector('input')

// 输入事件
input.addEventListener('input', function() {
  console.log('Input value:', this.value)
})

input.addEventListener('change', function() {
  console.log('Value changed:', this.value)
})

input.addEventListener('focus', function() {
  console.log('Input focused')
})

input.addEventListener('blur', function() {
  console.log('Input blurred')
})

// 表单提交
form.addEventListener('submit', function(event) {
  event.preventDefault()
  console.log('Form submitted')
})
```

### 页面事件

```javascript
// 页面加载完成
window.addEventListener('load', function() {
  console.log('Page fully loaded')
})

// DOM 构建完成
document.addEventListener('DOMContentLoaded', function() {
  console.log('DOM ready')
})

// 窗口大小改变
window.addEventListener('resize', function() {
  console.log('Window resized:', window.innerWidth, window.innerHeight)
})

// 滚动事件
window.addEventListener('scroll', function() {
  console.log('Scroll position:', window.scrollY)
})
```

## 动态创建和事件绑定

### 创建交互元素

```javascript
function createTodoItem(text) {
  const li = document.createElement('li')
  li.className = 'todo-item'

  const checkbox = document.createElement('input')
  checkbox.type = 'checkbox'
  checkbox.addEventListener('change', function() {
    li.classList.toggle('completed', this.checked)
  })

  const span = document.createElement('span')
  span.textContent = text

  const deleteBtn = document.createElement('button')
  deleteBtn.textContent = 'Delete'
  deleteBtn.addEventListener('click', function() {
    li.remove()
  })

  li.appendChild(checkbox)
  li.appendChild(span)
  li.appendChild(deleteBtn)

  return li
}

// 使用
const todoList = document.querySelector('#todo-list')
const addButton = document.querySelector('#add-todo')

addButton.addEventListener('click', function() {
  const input = document.querySelector('#todo-input')
  if (input.value.trim()) {
    const todoItem = createTodoItem(input.value)
    todoList.appendChild(todoItem)
    input.value = ''
  }
})
```

## 性能优化

### 减少 DOM 操作

```javascript
// 不好的做法：多次操作 DOM
const list = document.querySelector('#list')
for (let i = 0; i < 1000; i++) {
  const item = document.createElement('li')
  item.textContent = `Item ${i}`
  list.appendChild(item) // 每次都触发重绘
}

// 好的做法：批量操作
const list = document.querySelector('#list')
const fragment = document.createDocumentFragment()

for (let i = 0; i < 1000; i++) {
  const item = document.createElement('li')
  item.textContent = `Item ${i}`
  fragment.appendChild(item)
}

list.appendChild(fragment) // 只触发一次重绘
```

### 事件委托优化

```javascript
// 为大量元素添加事件监听器
const container = document.querySelector('.container')

container.addEventListener('click', function(event) {
  const target = event.target

  if (target.classList.contains('delete-btn')) {
    // 处理删除
    const item = target.closest('.item')
    item.remove()
  } else if (target.classList.contains('edit-btn')) {
    // 处理编辑
    const item = target.closest('.item')
    // 编辑逻辑
  }
})
```

### 防抖和节流

```javascript
// 防抖：延迟执行，最后一次调用后延迟时间后再执行
function debounce(func, delay) {
  let timeoutId
  return function(...args) {
    clearTimeout(timeoutId)
    timeoutId = setTimeout(() => func.apply(this, args), delay)
  }
}

// 节流：限制执行频率，一定时间内只执行一次
function throttle(func, limit) {
  let inThrottle
  return function(...args) {
    if (!inThrottle) {
      func.apply(this, args)
      inThrottle = true
      setTimeout(() => inThrottle = false, limit)
    }
  }
}

// 使用
window.addEventListener('scroll', debounce(handleScroll, 100))
window.addEventListener('resize', throttle(handleResize, 200))
```

::: tip 最佳实践
- 使用事件委托处理动态创建的元素
- 批量 DOM 操作使用 DocumentFragment
- 移除不需要的事件监听器
- 使用现代选择器方法 (querySelector)
- 合理使用防抖和节流优化性能
:::

::: warning 注意事项
- 直接修改 innerHTML 可能导致安全问题（XSS）
- 移除元素时记得清理事件监听器
- DOM 操作是同步的，会阻塞渲染
- 过度的事件监听会影响性能
:::
