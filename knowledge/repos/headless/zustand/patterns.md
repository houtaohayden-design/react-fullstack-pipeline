# Zustand — Patterns

## 核心原则

**无需 Provider** — Store 直接导入使用。单一对象 State + Action 合并。

## 标准模式

```tsx
// stores/useCounterStore.ts
import { create } from 'zustand'

export const useCounterStore = create((set) => ({
  count: 0,
  increment: () => set((s) => ({ count: s.count + 1 })),
  decrement: () => set((s) => ({ count: s.count - 1 })),
  reset: () => set({ count: 0 })
}))
```

## 与知识库其他库配合

### + react-hook-form
表单提交后更新全局状态：
```tsx
const onSubmit = (data) => {
  useUserStore.getState().updateUser(data)
}
```

### + Shineout Table
Table 的筛选/分页状态放 zustand：
```tsx
const useTableStore = create((set) => ({
  page: 1,
  pageSize: 10,
  filters: {},
  setPage: (page) => set({ page }),
  setFilters: (filters) => set({ filters, page: 1 })
}))
```

### + react-bits
动画状态控制：
```tsx
const useAnimationStore = create((set) => ({
  isVisible: false,
  toggle: () => set((s) => ({ isVisible: !s.isVisible }))
}))
```

## zustand vs react-hook-form 职责划分

- **zustand** → 全局/跨组件状态 (用户信息、应用设置、购物车)
- **react-hook-form** → 表单本地状态 (输入值、验证、提交)
- 提交时：表单数据 → zustand store (持久化或传递给其他模块)
