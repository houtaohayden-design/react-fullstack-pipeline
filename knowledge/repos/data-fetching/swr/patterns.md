# SWR — Patterns

## 定位

**Vercel 出品的数据获取库。** 比 TanStack Query 更轻量 (~5KB vs ~12KB)，API 更简单。适合中小型应用和简单数据需求。

## 与 TanStack Query 的分工

| 场景 | SWR | TanStack Query |
|------|-----|---------------|
| 简单 GET 数据获取 | 优先 (更轻) | 可用 |
| 复杂突变 + 乐观更新 | 可用 | 优先 |
| 无限滚动 | 可用 | 优先 |
| Next.js / Vercel 生态 | 优先 | 可用 |
| 包体积敏感 | 优先 (~5KB) | — |

## 标准模式

### 依赖请求

```tsx
// 串行：第二个请求依赖第一个的返回
const { data: user } = useSWR('/api/user', fetcher)
const { data: projects } = useSWR(
  user ? `/api/projects?userId=${user.id}` : null, // key 为 null 时不发送
  fetcher
)
```

### 条件请求

```tsx
// key 为 falsy 时跳过请求
const { data: list } = useSWR(keyword ? `/api/search?q=${keyword}` : null, fetcher, {
  focusThrottleInterval: 300 // 防抖重验证
})
```

### 乐观更新 + 回滚

```tsx
import { useSWRConfig } from 'swr'

const { mutate } = useSWRConfig()
const { data: todos } = useSWR('/api/todos', fetcher)

async function addTodo(title) {
  const newTodo = { id: tempId, title }
  await mutate('/api/todos',
    (todos) => [...todos, newTodo],
    {
      optimisticData: current => [...current, newTodo],
      rollbackOnError: true,
      revalidate: true
    }
  )
}
```

### 预览/表单提交 (useSWRMutation)

```tsx
const { trigger, isMutating } = useSWRMutation('/api/orders', (url, { arg }) =>
  fetch(url, { method: 'POST', body: JSON.stringify(arg) }).then(r => r.json())
)

// trigger 返回 promise
await trigger({ productId: 'x' })
```

### 无限滚动

```tsx
function LoadMore() {
  const { data, size, setSize, isLoading } = useSWRInfinite(
    (page, prev) => prev?.nextCursor ? `/api/items?cursor=${prev.nextCursor}` : null,
    fetcher
  )
  const items = data?.flat() || []
  const noMore = !data?.at(-1)?.nextCursor

  return (
    <>
      {items.map(i => <Card key={i.id} {...i} />)}
      {!noMore && <Button loading={isLoading} onClick={() => setSize(size + 1)}>加载更多</Button>}
    </>
  )
}
```

## 与知识库其他库配合

### + TanStack Query
混合使用：SWR 做简单数据，TanStack Query 做复杂场景：
```tsx
// SWR: 简单配置/用户信息
const { data: config } = useSWR('/api/config', fetcher)

// TanStack Query: 复杂列表 + 突变
const { data: orders } = useQuery({ queryKey: ['orders'], queryFn: fetchOrders })
```

### + zustand
SWR 数据 → zustand 存储：
```tsx
const { data } = useSWR('/api/user', fetcher)
const setUser = useUserStore(s => s.setUser)
useEffect(() => { if (data) setUser(data) }, [data])
```

### + react-hook-form
```tsx
const { data: defaultValues } = useSWR('/api/profile', fetcher)
const { register, reset } = useForm({ defaultValues })
useEffect(() => { if (defaultValues) reset(defaultValues) }, [defaultValues])
```
