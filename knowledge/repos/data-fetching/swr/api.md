# SWR — API Reference

> swr v2.4 | React 数据获取 | React >= 16.11

## Setup

```bash
npm install swr
```

## Core API

### useSWR

```tsx
import useSWR from 'swr'

const fetcher = (url: string) => fetch(url).then(r => r.json())

const { data, error, isLoading, isValidating, mutate } = useSWR('/api/user', fetcher, {
  revalidateOnFocus: false,
  revalidateOnReconnect: true,
  refreshInterval: 5000,
  dedupingInterval: 2000
})
```

### SWRConfig (全局配置)

```tsx
import { SWRConfig } from 'swr'

<SWRConfig value={{
  fetcher: (url) => fetch(url).then(r => r.json()),
  revalidateOnFocus: false,
  errorRetryCount: 3
}}>
  <App />
</SWRConfig>

// 支持函数式值，可访问父级配置
<SWRConfig value={parent => ({ ...parent, refreshInterval: 10000 })}>
```

### Mutate (数据变更)

```tsx
import { mutate } from 'swr'

// 重新验证单个 key
mutate('/api/user')

// 乐观更新
mutate('/api/todos', (todos) => [...todos, newTodo], {
  optimisticData: [...todos, newTodo],
  rollbackOnError: true,
  revalidate: false
})

// 批量 (过滤器)
mutate(key => key.startsWith('/api/users'), undefined, { revalidate: true })
```

### useSWRMutation (仅变更)

```tsx
import useSWRMutation from 'swr/mutation'

const { trigger, isMutating, data, error } = useSWRMutation('/api/todos', (url, { arg }: { arg: Todo }) =>
  fetch(url, { method: 'POST', body: JSON.stringify(arg) }).then(r => r.json())
)

<button onClick={() => trigger({ title: 'New todo' })} disabled={isMutating}>
  Add Todo
</button>
```

### useSWRInfinite (分页)

```tsx
import useSWRInfinite from 'swr/infinite'

const { data, size, setSize, isLoading } = useSWRInfinite(
  (index, previousPageData) => {
    if (previousPageData && !previousPageData.length) return null
    return `/api/users?page=${index + 1}`
  },
  fetcher,
  { initialSize: 2, parallel: true }
)
// data = [page1[], page2[], ...]
```

### useSWRImmutable (只读)

```tsx
import useSWRImmutable from 'swr/immutable'

// 不重新验证，仅从缓存读取
const { data } = useSWRImmutable('/api/config', fetcher)
```

### useSWRSubscription (实时订阅)

```tsx
import useSWRSubscription from 'swr/subscription'

const { data, error } = useSWRSubscription('/api/ws', (key, { next }) => {
  const ws = new WebSocket(`wss://example.com${key}`)
  ws.onmessage = (e) => next(null, JSON.parse(e.data))
  ws.onerror = (e) => next(e)
  return () => ws.close()
})
```

### preload (预加载)

```tsx
import { preload } from 'swr'

// 提前获取数据，hook 挂载时直接用缓存
preload('/api/user', fetcher)
```

## useSWR 关键选项

| 选项 | 类型 | 默认 | 说明 |
|------|------|------|------|
| `fetcher` | `(key) => Promise<Data>` | — | 数据获取函数 |
| `revalidateOnFocus` | `boolean` | `true` | 窗口聚焦时重新验证 |
| `revalidateOnReconnect` | `boolean` | `true` | 网络恢复时重新验证 |
| `revalidateIfStale` | `boolean` | `true` | 有旧数据时挂载重新验证 |
| `refreshInterval` | `number` | `0` | 轮询间隔 (ms) |
| `dedupingInterval` | `number` | `2000` | 去重间隔 |
| `errorRetryInterval` | `number` | `5000` | 错误重试间隔 |
| `errorRetryCount` | `number` | — | 最大重试次数 |
| `fallbackData` | `Data` | — | 初始/回退数据 |
| `suspense` | `boolean` | `false` | React Suspense 模式 |
| `keepPreviousData` | `boolean` | `false` | key 变时保留旧数据 |
| `isPaused` | `() => boolean` | — | 暂停重新验证 |
| `use` | `Middleware[]` | — | 中间件 |

## SWRResponse

```tsx
{
  data: Data | undefined
  error: Error | undefined
  mutate: KeyedMutator<Data>
  isValidating: boolean   // 正在获取/重新验证
  isLoading: boolean      // 仅初始加载 (无缓存)
}
```

## v2 关键变化

- **`isLoading` vs `isValidating` 分离** — 初始加载 vs 任何获取
- **`config.initialData` → `fallbackData`**
- **子路径导出** — `swr/infinite`, `swr/mutation`, `swr/immutable`, `swr/subscription`
- **中间件体系** — 所有子 hook 基于 useSWR 中间件
- **`useSWRMutation`** — 独立的变更 hook
- **`preload()`** — 命令式预加载

## 关键特性

- Stale-While-Revalidate 策略
- 请求去重
- 乐观更新
- 分页/无限滚动
- 聚焦/重连 重新验证
- 轮询
- Suspense 支持
- 中间件体系
- ~5KB gzip
