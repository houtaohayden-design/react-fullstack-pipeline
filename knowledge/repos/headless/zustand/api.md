# Zustand — API Reference

> zustand v5.0.13 | 轻量 React 状态管理 | React >= 16.8

## Setup

```bash
npm install zustand
```

## Core API

### create (创建 Store)

```tsx
import { create } from 'zustand'

const useBearStore = create((set, get) => ({
  bears: 0,
  increase: () => set((state) => ({ bears: state.bears + 1 })),
  decrease: () => set((state) => ({ bears: state.bears - 1 })),
  reset: () => set({ bears: 0 }),
  getBears: () => get().bears
}))
```

### 在组件中使用

```tsx
function App() {
  const bears = useBearStore((state) => state.bears)
  const increase = useBearStore((state) => state.increase)

  return <button onClick={increase}>Bears: {bears}</button>
}
```

### 选择器 (Selector)

```tsx
// 单字段
const bears = useBearStore((s) => s.bears)

// 浅比较多个字段 (避免不必要的 rerender)
import { useShallow } from 'zustand/react/shallow'
const { bears, increase } = useBearStore(useShallow((s) => ({
  bears: s.bears,
  increase: s.increase
})))
```

### 异步 Action

```tsx
const useFishStore = create((set) => ({
  fishies: [],
  fetch: async (pond) => {
    const response = await fetch(pond)
    set({ fishies: await response.json() })
  }
}))
```

### 中间件

```tsx
import { persist, devtools, subscribeWithSelector } from 'zustand/middleware'

const useStore = create(
  devtools(
    persist(
      (set) => ({
        count: 0,
        inc: () => set((s) => ({ count: s.count + 1 }))
      }),
      { name: 'my-store' }  // localStorage key
    )
  )
)
```

**常用中间件:**
- `persist` — localStorage/sessionStorage 持久化
- `devtools` — Redux DevTools 集成
- `subscribeWithSelector` — 选择性订阅
- `immer` — 不可变更新 (需单独安装 zustand/middleware/immer)

### subscribe

```tsx
// 组件外监听
const unsub = useStore.subscribe(
  (state) => state.bears,
  (bears) => console.log('Bears changed:', bears)
)
```

## 关键特性

- **体积极小** — gzip < 2KB
- **无需 Provider** — 不包裹组件树
- **选择器渲染优化** — 只在选中数据变化时 rerender
- **TypeScript** — 完整类型推导
