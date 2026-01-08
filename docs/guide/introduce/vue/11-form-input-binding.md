---
title: 表单输入绑定
description: Vue.js 的表单控件双向绑定 v-model 指令详解
sidebarDepth: 2
---

# 表单输入绑定

## 基础用法

你可以用 `v-model` 指令在表单 `<input>`、`<textarea>` 及 `<select>` 元素上创建双向数据绑定。它会根据控件类型自动选取正确的方法来更新元素。尽管有些神奇，但 `v-model` 本质上不过是语法糖。它负责监听用户的输入事件以更新数据，并对一些极端场景进行一些特殊处理。

::: tip 注意
`v-model` 会忽略所有表单元素的 `value`、`checked`、`selected` attribute 的初始值而总是将当前活动实例的数据作为数据来源。你应该通过 JavaScript 在组件的 `data` 选项中声明初始值。
:::

## 文本

```html
<input v-model="message" placeholder="edit me" />
<p>Message is: {{ message }}</p>
```

## 多行文本

```html
<span>Multiline message is:</span>
<p style="white-space: pre-line;">{{ message }}</p>
<br />
<textarea v-model="message" placeholder="add multiple lines"></textarea>
```

## 复选框

单个复选框，绑定到布尔值：

```html
<input type="checkbox" id="checkbox" v-model="checked" />
<label for="checkbox">{{ checked }}</label>
```

多个复选框，绑定到同一个数组：

```html
<div id="v-model-multiple-checkboxes">
  <input type="checkbox" id="jack" value="Jack" v-model="checkedNames" />
  <label for="jack">Jack</label>
  <input type="checkbox" id="john" value="John" v-model="checkedNames" />
  <label for="john">John</label>
  <input type="checkbox" id="mike" value="Mike" v-model="checkedNames" />
  <label for="mike">Mike</label>
  <br />
  <span>Checked names: {{ checkedNames }}</span>
</div>
```

```javascript
Vue.createApp({
  data() {
    return {
      checkedNames: []
    }
  }
}).mount('#v-model-multiple-checkboxes')
```

## 单选按钮

```html
<div id="v-model-radiobutton">
  <input type="radio" id="one" value="One" v-model="picked" />
  <label for="one">One</label>
  <br />
  <input type="radio" id="two" value="Two" v-model="picked" />
  <label for="two">Two</label>
  <br />
  <span>Picked: {{ picked }}</span>
</div>
```

```javascript
Vue.createApp({
  data() {
    return {
      picked: ''
    }
  }
}).mount('#v-model-radiobutton')
```

## 选择框

### 单选选择框

```html
<div id="v-model-select">
  <select v-model="selected">
    <option disabled value="">Please select one</option>
    <option>A</option>
    <option>B</option>
    <option>C</option>
  </select>
  <span>Selected: {{ selected }}</span>
</div>
```

```javascript
Vue.createApp({
  data() {
    return {
      selected: ''
    }
  }
}).mount('#v-model-select')
```

::: tip 注意
如果 `v-model` 表达式的初始值未能匹配任何选项，`<select>` 元素将被渲染为"未选择"状态。在 iOS 中，这会使用户无法选择第一个选项。因为在这种情况下，iOS 不会触发 change 事件。因此，推荐像上面这样提供一个值为空的禁用选项。
:::

### 多选选择框 (绑定到一个数组)

```html
<div id="v-model-select-multiple">
  <select v-model="selected" multiple>
    <option>A</option>
    <option>B</option>
    <option>C</option>
  </select>
  <br />
  <span>Selected: {{ selected }}</span>
</div>
```

```javascript
Vue.createApp({
  data() {
    return {
      selected: []
    }
  }
}).mount('#v-model-select-multiple')
```

## 值绑定

对于单选按钮，复选框及选择框的选项，`v-model` 绑定的值通常是静态字符串 (对于复选框也可以是布尔值)：

```html
<!-- 当选中时，`picked` 为字符串 "a" -->
<input type="radio" v-model="picked" value="a" />

<!-- `toggle` 为 true 或 false -->
<input type="checkbox" v-model="toggle" />

<!-- 当选中时，`selected` 为字符串 "abc" -->
<select v-model="selected">
  <option value="abc">ABC</option>
</select>
```

但是有时我们可能想将值绑定到当前活动实例的一个动态属性上，这时可以用 `v-bind` 来实现，并且这个属性的值可以不是字符串。

### 复选框

```html
<input
  type="checkbox"
  v-model="toggle"
  true-value="yes"
  false-value="no"
/>
```

```javascript
// 选中时：
vm.toggle === 'yes'
// 取消选中时：
vm.toggle === 'no'
```

::: tip 注意
这里的 `true-value` 和 `false-value` attribute 并不会影响输入控件的 `value` attribute，因为浏览器在提交表单时并不会包含未选中的复选框。如果要确保表单中这两个值中的一个能够被提交，(即"yes"或"no")，请换用单选按钮。
:::

### 单选按钮

```html
<input type="radio" v-model="pick" v-bind:value="a" />
```

```javascript
// 选中时
vm.pick === vm.a
```

### 选择框的选项

```html
<select v-model="selected">
  <!-- 内联对象字面量 -->
  <option :value="{ number: 123 }">123</option>
</select>
```

```javascript
// 选中时：
typeof vm.selected // => 'object'
vm.selected.number // => 123
```

## 修饰符

### .lazy

在默认情况下，`v-model` 在每次 `input` 事件触发后将输入框的值与数据进行同步 (除了上述输入法组合文字时)。你可以添加 `lazy` 修饰符，从而转为在 `change` 事件_之后_进行同步：

```html
<!-- 在 "change" 时而非 "input" 时更新 -->
<input v-model.lazy="msg" />
```

### .number

如果想自动将用户的输入值转为数值类型，可以给 `v-model` 添加 `number` 修饰符：

```html
<input v-model.number="age" type="number" />
```

这通常很有用，因为即使在 `type="number"` 时，HTML 输入元素的值也总会返回字符串。如果这个值无法被 `parseFloat()` 解析，则会返回原始的值。

### .trim

如果要自动过滤用户输入的首尾空白字符，可以给 `v-model` 添加 `trim` 修饰符：

```html
<input v-model.trim="msg" />
```

## 在组件上使用 v-model

如果还没有阅读关于组件的文档，现在就可以跳过了。

HTML 的内置输入类型有时不能满足你的需求。幸好，Vue 的组件系统允许你创建具有完全自定义行为且可复用的输入组件。这些输入组件甚至可以和 `v-model` 一起使用！要了解更多，请阅读组件指南中的[自定义输入组件](./component-basics.html#使用自定义事件的形式与-v-model-配合)。

## 表单验证

### 基础验证

```html
<form @submit.prevent="handleSubmit">
  <div>
    <label for="email">Email:</label>
    <input
      id="email"
      v-model="form.email"
      type="email"
      required
    />
    <span v-if="errors.email" class="error">{{ errors.email }}</span>
  </div>

  <div>
    <label for="password">Password:</label>
    <input
      id="password"
      v-model="form.password"
      type="password"
      required
      minlength="6"
    />
    <span v-if="errors.password" class="error">{{ errors.password }}</span>
  </div>

  <button type="submit" :disabled="!isFormValid">Submit</button>
</form>
```

```javascript
export default {
  data() {
    return {
      form: {
        email: '',
        password: ''
      },
      errors: {}
    }
  },
  computed: {
    isFormValid() {
      return this.form.email && this.form.password && Object.keys(this.errors).length === 0
    }
  },
  methods: {
    validateEmail() {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!this.form.email) {
        this.errors.email = 'Email is required'
      } else if (!emailRegex.test(this.form.email)) {
        this.errors.email = 'Please enter a valid email'
      } else {
        delete this.errors.email
      }
    },

    validatePassword() {
      if (!this.form.password) {
        this.errors.password = 'Password is required'
      } else if (this.form.password.length < 6) {
        this.errors.password = 'Password must be at least 6 characters'
      } else {
        delete this.errors.password
      }
    },

    handleSubmit() {
      this.validateEmail()
      this.validatePassword()

      if (this.isFormValid) {
        // 提交表单
        console.log('Form submitted:', this.form)
      }
    }
  }
}
```

### 使用第三方验证库

```html
<template>
  <form @submit.prevent="handleSubmit" novalidate>
    <div class="form-group">
      <label for="username">Username:</label>
      <input
        id="username"
        v-model="form.username"
        type="text"
        @blur="validateField('username')"
        :class="{ 'is-invalid': errors.username }"
      />
      <div v-if="errors.username" class="invalid-feedback">
        {{ errors.username }}
      </div>
    </div>

    <div class="form-group">
      <label for="email">Email:</label>
      <input
        id="email"
        v-model="form.email"
        type="email"
        @blur="validateField('email')"
        :class="{ 'is-invalid': errors.email }"
      />
      <div v-if="errors.email" class="invalid-feedback">
        {{ errors.email }}
      </div>
    </div>

    <button type="submit" :disabled="!isFormValid">Submit</button>
  </form>
</template>
```

```javascript
import * as yup from 'yup'

export default {
  data() {
    return {
      form: {
        username: '',
        email: ''
      },
      errors: {},
      schema: yup.object().shape({
        username: yup
          .string()
          .required('Username is required')
          .min(3, 'Username must be at least 3 characters'),
        email: yup
          .string()
          .required('Email is required')
          .email('Please enter a valid email')
      })
    }
  },
  computed: {
    isFormValid() {
      return Object.keys(this.errors).length === 0 &&
             this.form.username &&
             this.form.email
    }
  },
  methods: {
    async validateField(field) {
      try {
        await this.schema.validateAt(field, this.form)
        this.$delete(this.errors, field)
      } catch (error) {
        this.$set(this.errors, field, error.message)
      }
    },

    async validateForm() {
      try {
        await this.schema.validate(this.form, { abortEarly: false })
        this.errors = {}
        return true
      } catch (error) {
        this.errors = {}
        error.inner.forEach(err => {
          this.$set(this.errors, err.path, err.message)
        })
        return false
      }
    },

    async handleSubmit() {
      const isValid = await this.validateForm()
      if (isValid) {
        // 提交表单
        console.log('Form submitted:', this.form)
      }
    }
  }
}
```

## 最佳实践

### 使用计算属性处理表单状态

```javascript
export default {
  data() {
    return {
      form: {
        firstName: '',
        lastName: ''
      }
    }
  },
  computed: {
    fullName() {
      return `${this.form.firstName} ${this.form.lastName}`.trim()
    },
    isFormValid() {
      return this.form.firstName.trim() && this.form.lastName.trim()
    }
  }
}
```

### 表单重置

```javascript
export default {
  data() {
    return {
      form: {
        name: '',
        email: '',
        message: ''
      },
      initialForm: {
        name: '',
        email: '',
        message: ''
      }
    }
  },
  methods: {
    resetForm() {
      this.form = { ...this.initialForm }
      // 如果有验证错误，也要清除
      this.errors = {}
    },

    submitForm() {
      // 提交逻辑
      this.resetForm()
    }
  }
}
```

### 文件上传

```html
<form @submit.prevent="handleSubmit">
  <div>
    <label for="file">Choose file:</label>
    <input
      id="file"
      type="file"
      ref="fileInput"
      @change="handleFileChange"
      accept=".jpg,.jpeg,.png,.gif"
    />
  </div>

  <button type="submit" :disabled="!selectedFile">Upload</button>
</form>
```

```javascript
export default {
  data() {
    return {
      selectedFile: null
    }
  },
  methods: {
    handleFileChange(event) {
      const file = event.target.files[0]
      if (file) {
        // 检查文件大小 (例如 5MB)
        if (file.size > 5 * 1024 * 1024) {
          alert('File size must be less than 5MB')
          this.resetFileInput()
          return
        }

        // 检查文件类型
        const allowedTypes = ['image/jpeg', 'image/png', 'image/gif']
        if (!allowedTypes.includes(file.type)) {
          alert('Please select a valid image file')
          this.resetFileInput()
          return
        }

        this.selectedFile = file
      }
    },

    resetFileInput() {
      this.selectedFile = null
      this.$refs.fileInput.value = ''
    },

    async handleSubmit() {
      if (!this.selectedFile) return

      const formData = new FormData()
      formData.append('file', this.selectedFile)

      try {
        const response = await fetch('/api/upload', {
          method: 'POST',
          body: formData
        })

        if (response.ok) {
          alert('File uploaded successfully!')
          this.resetFileInput()
        } else {
          throw new Error('Upload failed')
        }
      } catch (error) {
        alert('Upload failed: ' + error.message)
      }
    }
  }
}
```

### 实时保存 (防抖)

```html
<template>
  <div>
    <textarea
      v-model="content"
      @input="debouncedSave"
      placeholder="Start typing..."
    ></textarea>

    <div class="status">
      <span v-if="saving">Saving...</span>
      <span v-else-if="saved">Saved</span>
      <span v-else>Unsaved changes</span>
    </div>
  </div>
</template>
```

```javascript
import _ from 'lodash'

export default {
  data() {
    return {
      content: '',
      saving: false,
      saved: false
    }
  },
  created() {
    this.debouncedSave = _.debounce(this.saveContent, 1000)
  },
  methods: {
    async saveContent() {
      if (!this.content.trim()) return

      this.saving = true
      this.saved = false

      try {
        await this.$http.post('/api/save', {
          content: this.content,
          timestamp: Date.now()
        })

        this.saved = true
        setTimeout(() => {
          this.saved = false
        }, 2000)
      } catch (error) {
        console.error('Save failed:', error)
        // 可以显示错误提示
      } finally {
        this.saving = false
      }
    }
  }
}
```

## 性能优化

### 避免不必要的更新

```html
<!-- 使用 lazy 修饰符减少更新频率 -->
<input v-model.lazy="searchQuery" />

<!-- 对于大量输入，使用防抖 -->
<input v-model="searchQuery" @input="debouncedSearch" />
```

### 使用 v-memo 优化表单

```html
<template v-memo="[form.name, form.email]">
  <div class="form-group">
    <label>Name: {{ form.name }}</label>
    <label>Email: {{ form.email }}</label>
  </div>
</template>
```

::: warning 注意事项
- `v-model` 会忽略表单元素的初始 `value`、`checked`、`selected` 属性
- 对于复选框组，`v-model` 绑定到数组
- 单选按钮的 `value` 属性通常是静态字符串
- 选择框的选项可以绑定动态对象
- 使用修饰符可以改变 `v-model` 的行为
- 表单验证应该在用户交互时提供即时反馈
:::









