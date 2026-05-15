# TanStack Query — API Reference

> @tanstack/react-query v5.100 | React 数据获取/缓存 | React >= 18

## Setup

```bash
npm install @tanstack/react-query
# Devtools:
npm install @tanstack/react-query-devtools
```

## Core API

### QueryClientProvider

```tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: { staleTime: 60_000, gcTime: 5 * 60_000 }
  }
})

<QueryClientProvider client={queryClient}>
  <App />
</QueryClientProvider>
```

### useQuery

```tsx
const { data, error, isLoading, isPending, isFetching, refetch } = useQuery({
  queryKey: ['todos', userId],
  queryFn: () => fetch(`/api/todos?userId=${userId}`).then(r => r.json()),
  enabled: !!userId,
  staleTime: 5000,
  gcTime: 300000,
  retry: 3,
  select: (data) => data.filter(t => !t.done)
})
```

**返回状态:** `status: 'pending' | 'error' | 'success'`
- `isLoading` = `isPending && isFetching` (仅初始加载)
- `isPending` = 无缓存数据
- `isFetching` = 正在请求 (含后台刷新)

### useMutation

```tsx
const mutation = useMutation({
  mutationFn: (newTodo) => fetch('/api/todos', { method: 'POST', body: JSON.stringify(newTodo) }),
  onSuccess: (data) => {
    queryClient.invalidateQueries({ queryKey: ['todos'] })
  }
})

// mutate 返回 void，mutateAsync 返回 Promise<data>
mutation.mutate({ title: 'New' })
```

### useInfiniteQuery

```tsx
const { data, fetchNextPage, hasNextPage, isFetchingNextPage } = useInfiniteQuery({
  queryKey: ['projects'],
  queryFn: ({ pageParam }) => fetch(`/api/projects?cursor=${pageParam}`),
  initialPageParam: 0,
  getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined
})
// data.pages: TData[][]
```

### useSuspenseQuery

```tsx
// 强制 suspense: true, enabled: true，data 保证非 undefined
const { data } = useSuspenseQuery({
  queryKey: ['todos'],
  queryFn: fetchTodos
})
```

### useQueries (并行多查询)

```tsx
const results = useQueries({
  queries: ids.map(id => ({
    queryKey: ['user', id],
    queryFn: () => fetchUser(id)
  }))
})
```

### QueryClient 方法

```tsx
const queryClient = useQueryClient()

// 读缓存
queryClient.getQueryData(['todos'])
queryClient.getQueryState(['todos'])

// 写缓存
queryClient.setQueryData(['todos'], newData)
queryClient.setQueryData(['todos'], (old) => [...old, newItem])

// 失效 & 重取
queryClient.invalidateQueries({ queryKey: ['todos'] })
queryClient.refetchQueries({ queryKey: ['todos'] })
queryClient.removeQueries({ queryKey: ['todos'] })

// 预取
queryClient.prefetchQuery({ queryKey: ['todos'], queryFn: fetchTodos })

// 乐观更新
queryClient.setQueryData(['todos'], (old) => old.map(t => t.id === id ? {...t, done: true} : t))
```

### queryOptions (类型安全的 key)

```tsx
import { queryOptions } from '@tanstack/react-query'

const todoQuery = queryOptions({
  queryKey: ['todos'] as const,
  queryFn: fetchTodos
})
// queryClient.getQueryData(todoQuery.queryKey) → 自动推断返回类型
```

### skipToken

```tsx
import { skipToken } from '@tanstack/react-query'

const { data } = useQuery({
  queryKey: ['todos'],
  queryFn: enabled ? fetchTodos : skipToken
})
```

## useQuery 关键选项

| 选项 | 类型 | 默认 | 说明 |
|------|------|------|------|
| `queryKey` | `ReadonlyArray<unknown>` | 必填 | 唯一键 |
| `queryFn` | `(ctx) => Promise<T>` | — | 数据获取函数 |
| `enabled` | `boolean` | `true` | 自动触发 |
| `staleTime` | `number` | `0` | 数据过期时间 (ms) |
| `gcTime` | `number` | `Infinity` | 垃圾回收时间 (ms, 旧名 cacheTime) |
| `refetchOnWindowFocus` | `boolean` | `true` | 窗口聚焦时重新获取 |
| `retry` | `boolean \| number` | `3` | 失败重试次数 |
| `placeholderData` | `TData \| (prev) => TData` | — | 占位数据 |
| `select` | `(data) => T` | — | 数据转换 |
| `structuralSharing` | `boolean` | `true` | 结构共享保持引用 |

## v5 重要变更

- **`cacheTime` → `gcTime`**
- **`status: 'loading'` → `status: 'pending'`**
- **useQuery 移除了 `onSuccess`/`onError`/`onSettled`** (useMutation 保留)
- **`keepPreviousData`** 变成工具函数，通过 `placeholderData: keepPreviousData` 使用

## Devtools

```tsx
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'

<QueryClientProvider client={queryClient}>
  <App />
  <ReactQueryDevtools initialIsOpen={false} />
</QueryClientProvider>
```

## SSR / Hydration

```tsx
// 服务端
import { dehydrate } from '@tanstack/react-query'
const dehydratedState = dehydrate(queryClient)

// 客户端
import { HydrationBoundary } from '@tanstack/react-query'
<HydrationBoundary state={dehydratedState}>
  <App />
</HydrationBoundary>
```

## 关键特性

- 缓存 & 后台刷新 (stale-while-revalidate)
- 自动垃圾回收
- 窗口聚焦重新获取
- 请求去重 (相同 queryKey 同时只发一次)
- 乐观更新 & 回滚
- 无限滚动 / 分页
- Suspense 支持
- SSR 支持
- Devtools
