---
title: JavaScript 基础回顾
description: JavaScript 核心概念、数据类型和基本语法
---

# JavaScript 基础回顾

## 变量和数据类型

### 变量声明

```javascript
// var (ES5，不推荐)
var name = 'John'

// let (ES6，块作用域)
let age = 30

// const (常量，不可重新赋值)
const PI = 3.14159
```

### 数据类型

#### 基本数据类型

```javascript
// 字符串
let str = 'Hello World'
let str2 = "Hello World"
let template = `Hello ${name}`

// 数字
let num = 42
let float = 3.14

// 布尔值
let isTrue = true
let isFalse = false

// undefined
let undefinedVar

// null
let nullVar = null

// Symbol (ES6)
let symbol = Symbol('unique')
```

#### 引用数据类型

```javascript
// 对象
let person = {
  name: 'John',
  age: 30,
  hobbies: ['reading', 'coding']
}

// 数组
let numbers = [1, 2, 3, 4, 5]
let mixed = ['hello', 42, true, null]

// 函数
function greet(name) {
  return `Hello, ${name}!`
}

// Date
let now = new Date()

// RegExp
let pattern = /hello/i
```

## 运算符

### 算术运算符

```javascript
let a = 10
let b = 3

console.log(a + b)  // 13，加法
console.log(a - b)  // 7，减法
console.log(a * b)  // 30，乘法
console.log(a / b)  // 3.333...，除法
console.log(a % b)  // 1，模运算
console.log(a ** b) // 1000，幂运算 (ES6)
```

### 比较运算符

```javascript
console.log(5 == '5')   // true，值相等
console.log(5 === '5')  // false，严格相等
console.log(5 != '5')   // false，不相等
console.log(5 !== '5')  // true，严格不相等
console.log(5 > 3)      // true，大于
console.log(5 < 3)      // false，小于
console.log(5 >= 5)     // true，大于等于
console.log(5 <= 4)     // false，小于等于
```

### 逻辑运算符

```javascript
let x = true
let y = false

console.log(x && y)  // false，逻辑与
console.log(x || y)  // true，逻辑或
console.log(!x)      // false，逻辑非
```

### 三元运算符

```javascript
let age = 20
let status = age >= 18 ? 'adult' : 'minor'
console.log(status)  // 'adult'
```

## 控制结构

### 条件语句

```javascript
// if-else
if (age >= 18) {
  console.log('You are an adult')
} else if (age >= 13) {
  console.log('You are a teenager')
} else {
  console.log('You are a child')
}

// switch
switch (day) {
  case 'Monday':
    console.log('Start of work week')
    break
  case 'Friday':
    console.log('TGIF!')
    break
  default:
    console.log('Regular day')
}
```

### 循环语句

```javascript
// for 循环
for (let i = 0; i < 5; i++) {
  console.log(i)
}

// while 循环
let i = 0
while (i < 5) {
  console.log(i)
  i++
}

// do-while 循环
let j = 0
do {
  console.log(j)
  j++
} while (j < 5)

// for-in (对象)
let person = { name: 'John', age: 30 }
for (let key in person) {
  console.log(`${key}: ${person[key]}`)
}

// for-of (数组，ES6)
let numbers = [1, 2, 3, 4, 5]
for (let num of numbers) {
  console.log(num)
}
```

## 函数

### 函数声明

```javascript
// 函数声明
function add(a, b) {
  return a + b
}

// 函数表达式
const multiply = function(a, b) {
  return a * b
}

// 箭头函数 (ES6)
const divide = (a, b) => a / b

// 默认参数
function greet(name = 'World') {
  return `Hello, ${name}!`
}

// 剩余参数
function sum(...numbers) {
  return numbers.reduce((total, num) => total + num, 0)
}
```

### 作用域

```javascript
// 全局作用域
let globalVar = 'I am global'

// 函数作用域
function testScope() {
  let localVar = 'I am local'
  console.log(globalVar)  // 可以访问
  console.log(localVar)   // 可以访问
}

console.log(localVar)  // ReferenceError

// 块作用域 (ES6)
if (true) {
  let blockVar = 'I am in block'
  var notBlockScoped = 'I am not block scoped'
}

console.log(blockVar)      // ReferenceError
console.log(notBlockScoped) // 可以访问
```

## 对象和数组

### 对象操作

```javascript
let person = {
  name: 'John',
  age: 30
}

// 访问属性
console.log(person.name)
console.log(person['age'])

// 添加属性
person.job = 'Developer'

// 删除属性
delete person.age

// 检查属性
console.log('name' in person)
console.log(person.hasOwnProperty('name'))
```

### 数组操作

```javascript
let fruits = ['apple', 'banana', 'orange']

// 添加元素
fruits.push('grape')     // 末尾添加
fruits.unshift('pear')   // 开头添加

// 删除元素
fruits.pop()             // 删除末尾
fruits.shift()           // 删除开头
fruits.splice(1, 1)      // 删除指定位置

// 查找元素
console.log(fruits.indexOf('banana'))
console.log(fruits.includes('apple'))

// 遍历数组
fruits.forEach((fruit, index) => {
  console.log(`${index}: ${fruit}`)
})

// 映射数组
let upperFruits = fruits.map(fruit => fruit.toUpperCase())

// 过滤数组
let longFruits = fruits.filter(fruit => fruit.length > 5)
```

## 错误处理

```javascript
try {
  // 可能出错的代码
  let result = riskyOperation()
  console.log(result)
} catch (error) {
  // 处理错误
  console.error('An error occurred:', error.message)
} finally {
  // 总是执行的代码
  console.log('Cleanup code')
}

// 自定义错误
function validateAge(age) {
  if (age < 0) {
    throw new Error('Age cannot be negative')
  }
  if (age > 150) {
    throw new RangeError('Age seems too high')
  }
  return true
}
```

::: tip 重要概念
- 变量作用域：let/const vs var
- 数据类型：基本类型 vs 引用类型
- 运算符：== vs ===
- 函数：声明式 vs 表达式 vs 箭头函数
:::

::: warning 常见错误
1. 使用 var 导致变量提升问题
2. 混淆 == 和 ===
3. 在循环中使用 var 而不是 let
4. 修改 const 声明的引用类型内容
:::

::: warning 练习
1. 创建一个函数，接收一个数组，返回数组中所有偶数的和
2. 实现一个简单的计算器，支持加减乘除操作
3. 创建一个对象表示学生信息，包含姓名、年龄、成绩等属性，并实现相关操作方法
:::
