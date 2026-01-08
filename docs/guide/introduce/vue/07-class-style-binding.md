---
title: Class 与 Style 绑定
description: Vue.js 中动态绑定 CSS class 和内联样式的方法
sidebarDepth: 2
---

# Class 与 Style 绑定

在开发过程中，经常需要根据数据状态来动态切换 class 或应用样式。这时可以使用 Vue.js 的 `v-bind` 指令来处理这些需求。

## 绑定 HTML Class

### 对象语法

可以给 `:class` (即 `v-bind:class` 的简写) 传递一个对象，以动态地切换 class：

```html
<div :class="{ active: isActive }"></div>
```

上面的语法表示 `active` 这个 class 是否存在取决于数据 property `isActive` 的 truthiness。

可以在对象中传入更多字段来动态切换多个 class。此外，`:class` 指令也可以与普通的 class attribute 共存：

```html
<div class="static" :class="{ active: isActive, 'text-danger': hasError }">
</div>
```

```javascript
export default {
  data() {
    return {
      isActive: true,
      hasError: false
    }
  }
}
```

渲染结果：

```html
<div class="static active"></div>
```

当 `isActive` 或者 `hasError` 发生变化时，class 列表也会相应地更新。

绑定的对象不必内联定义在模板里：

```html
<div :class="classObject"></div>
```

```javascript
export default {
  data() {
    return {
      classObject: {
        active: true,
        'text-danger': false
      }
    }
  }
}
```

也可以绑定一个返回对象的计算属性：

```html
<div :class="classObject"></div>
```

```javascript
export default {
  data() {
    return {
      isActive: true,
      error: null
    }
  },
  computed: {
    classObject() {
      return {
        active: this.isActive && !this.error,
        'text-danger': this.error && this.error.type === 'fatal'
      }
    }
  }
}
```

### 数组语法

可以给 `:class` 绑定一个数组来应用一个 class 列表：

```html
<div :class="[activeClass, errorClass]"></div>
```

```javascript
export default {
  data() {
    return {
      activeClass: 'active',
      errorClass: 'text-danger'
    }
  }
}
```

渲染结果：

```html
<div class="active text-danger"></div>
```

如果你也想根据条件切换 class，可以使用三元表达式：

```html
<div :class="[isActive ? activeClass : '', errorClass]"></div>
```

这有点繁琐。在 Vue 3 中，可以在数组语法中使用对象语法：

```html
<div :class="[{ active: isActive }, errorClass]"></div>
```

### 在组件上使用

当在一个自定义组件上使用 `class` attribute 时，这些 class 将被添加到该组件的根元素上面。已经存在的根元素上的 class 不会被覆盖。

例如，如果你声明了一个组件：

```javascript
const app = Vue.createApp({})

app.component('my-component', {
  template: `<p class="foo bar">Hi!</p>`
})
```

然后在使用它的时候添加一些 class：

```html
<my-component class="baz boo"></my-component>
```

HTML 将被渲染为：

```html
<p class="foo bar baz boo">Hi!</p>
```

对于带数据绑定的 class 也一样：

```html
<my-component :class="{ active: isActive }"></my-component>
```

当 `isActive` 为 true 时，HTML 将被渲染为：

```html
<p class="foo bar active">Hi!</p>
```

## 绑定内联样式

### 对象语法

`:style` 的对象语法十分直观——看起来很像 CSS，但其实是一个 JavaScript 对象：

```html
<div :style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>
```

```javascript
export default {
  data() {
    return {
      activeColor: 'red',
      fontSize: 30
    }
  }
}
```

直接绑定到一个样式对象通常更好，让模板更清晰：

```html
<div :style="styleObject"></div>
```

```javascript
export default {
  data() {
    return {
      styleObject: {
        color: 'red',
        fontSize: '13px'
      }
    }
  }
}
```

同样的，对象语法常常结合返回对象的计算属性使用。

### 数组语法

`:style` 的数组语法可以将多个样式对象应用到同一个元素上：

```html
<div :style="[baseStyles, overridingStyles]"></div>
```

### 自动添加前缀

当你在 `:style` 中使用了需要添加浏览器引擎前缀的 CSS property 时，如 `transform`，Vue.js 会自动侦测并添加相应的前缀。

### 多重值

可以为 style property 提供一个包含多个值的数组，常用于提供多个带前缀的值：

```html
<div :style="{ display: ['-webkit-box', '-ms-flexbox', 'flex'] }"></div>
```

这样写只会渲染数组中最后一个被浏览器支持的值。在这个例子中，如果浏览器支持不带浏览器前缀的 `flexbox`，那么就只会渲染 `display: flex`。

## 最佳实践

### 使用计算属性处理复杂逻辑

```javascript
export default {
  data() {
    return {
      isActive: true,
      hasError: false,
      theme: 'dark'
    }
  },
  computed: {
    containerClasses() {
      return {
        'container': true,
        'container--active': this.isActive,
        'container--error': this.hasError,
        'container--dark': this.theme === 'dark'
      }
    },
    containerStyles() {
      return {
        backgroundColor: this.theme === 'dark' ? '#333' : '#fff',
        color: this.theme === 'dark' ? '#fff' : '#333'
      }
    }
  }
}
```

```html
<div :class="containerClasses" :style="containerStyles">
  Content
</div>
```

### 使用方法处理动态逻辑

```javascript
export default {
  methods: {
    getButtonClasses() {
      return {
        'btn': true,
        'btn--primary': this.type === 'primary',
        'btn--secondary': this.type === 'secondary',
        'btn--disabled': this.disabled,
        'btn--loading': this.loading
      }
    }
  }
}
```

```html
<button :class="getButtonClasses()">
  {{ loading ? 'Loading...' : text }}
</button>
```

### CSS Modules

对于使用了 CSS Modules 的场景，可以通过 `$style` 对象来引用 CSS Modules 中的 class：

```html
<template>
  <div :class="$style.container">
    <p :class="$style.text">Hello World</p>
  </div>
</template>
```

```css
/* CSS Modules */
.container {
  background: #fff;
}

.text {
  color: #333;
}
```

### 条件样式

```html
<!-- 条件 class -->
<div :class="{ 'is-visible': show, 'is-hidden': !show }">
  Toggle visibility
</div>

<!-- 条件 style -->
<div :style="{ opacity: show ? 1 : 0, transition: 'opacity 0.3s' }">
  Fade effect
</div>
```

## 常见模式

### 状态指示器

```html
<span :class="statusClass">{{ status }}</span>
```

```javascript
export default {
  computed: {
    statusClass() {
      return {
        'status--success': this.status === 'success',
        'status--warning': this.status === 'warning',
        'status--error': this.status === 'error'
      }
    }
  }
}
```

### 主题切换

```html
<div :class="themeClasses">
  <header :style="headerStyles">
    {{ title }}
  </header>
</div>
```

```javascript
export default {
  computed: {
    themeClasses() {
      return {
        'theme--light': this.theme === 'light',
        'theme--dark': this.theme === 'dark',
        'theme--auto': this.theme === 'auto'
      }
    },
    headerStyles() {
      const themes = {
        light: { backgroundColor: '#fff', color: '#333' },
        dark: { backgroundColor: '#333', color: '#fff' },
        auto: { backgroundColor: 'var(--bg-color)', color: 'var(--text-color)' }
      }
      return themes[this.theme] || themes.light
    }
  }
}
```

### 响应式布局

```html
<div :class="layoutClasses">
  <aside v-if="hasSidebar" :class="sidebarClasses">Sidebar</aside>
  <main :class="mainClasses">Main content</main>
</div>
```

```javascript
export default {
  computed: {
    layoutClasses() {
      return {
        'layout': true,
        'layout--sidebar': this.hasSidebar,
        'layout--mobile': this.isMobile
      }
    },
    sidebarClasses() {
      return {
        'sidebar': true,
        'sidebar--collapsed': this.sidebarCollapsed,
        'sidebar--mobile': this.isMobile
      }
    },
    mainClasses() {
      return {
        'main': true,
        'main--fullwidth': !this.hasSidebar || this.sidebarCollapsed
      }
    }
  }
}
```

::: tip 性能提示
- 避免在模板中直接计算复杂的样式逻辑
- 使用计算属性缓存样式对象
- 对于大量动态样式，考虑使用 CSS 变量配合 style 绑定
- 优先使用 class 而不是内联 style，便于维护和性能优化
:::









