# TanStack Query — Patterns

## 定位

**React 数据获取的黄金标准。** 将服务端状态（异步数据）从组件中抽离，自动管理缓存、背景刷新、失效。

## 与 SWR 的选择

| 场景 | TanStack Query | SWR |
|------|---------------|-----|
| 复杂数据需求 (突变/乐观更新) | 优先 | 可用但不如 |
| 简单 GET 请求 | 可用 | 更轻量 |
| 重量级应用 | 优先 | 可用 |
| 包体积敏感 | ~12KB | ~5KB |

## 标准模式

### 列表 + 缓存更新

```tsx
// 查询列表
const { data: todos } = useQuery({
  queryKey: ['todos'],
  queryFn: fetchTodos
})

// 新增后更新缓存
const addTodo = useMutation({
  mutationFn: (title) => fetch('/api/todos', { method: 'POST', body: JSON.stringify({ title }) }),
  onSuccess: () => queryClient.invalidateQueries({ queryKey: ['todos'] })
})
```

### 乐观更新

```tsx
const toggleTodo = useMutation({
  mutationFn: (todo) => fetch(`/api/todos/${todo.id}`, { method: 'PATCH', body: JSON.stringify(todo) }),
  onMutate: async (newTodo) => {
    await queryClient.cancelQueries({ queryKey: ['todos'] })
    const previous = queryClient.getQueryData(['todos'])
    queryClient.setQueryData(['todos'], (old) => old.map(t => t.id === newTodo.id ? newTodo : t))
    return { previous }
  },
  onError: (err, newTodo, context) => {
    queryClient.setQueryData(['todos'], context.previous)
  },
  onSettled: () => queryClient.invalidateQueries({ queryKey: ['todos'] })
})
```

### 依赖查询

```tsx
// 第二个查询依赖第一个查询的结果
const { data: user } = useQuery({
  queryKey: ['user', userId],
  queryFn: () => fetchUser(userId)
})

const { data: projects } = useQuery({
  queryKey: ['projects', user?.orgId],
  queryFn: () => fetchProjects(user.orgId),
  enabled: !!user?.orgId  // user 加载完才执行
})
```

## 与知识库其他库配合

### + zustand
全局状态存 UI 状态，TanStack Query 管理服务端状态：
```tsx
const { data } = useQuery({ queryKey: ['user'], queryFn: fetchUser })
const setUser = useUserStore(s => s.setUser)

useEffect(() => {
  if (data) setUser(data)
}, [data])
```

### + react-hook-form
表单提交用 useMutation：
```tsx
const { register, handleSubmit } = useForm()
const mutation = useMutation({ mutationFn: submitForm })

const onSubmit = (data) => mutation.mutateAsync(data)
```

### + Shineout
Shineout Table + TanStack Query 分页：
```tsx
const [page, setPage] = useState(1)
const { data } = useQuery({
  queryKey: ['table', page],
  queryFn: () => fetchPage(page),
  placeholderData: keepPreviousData  // 翻页不闪
})
<Table data={data?.list} pagination={{ current: page, onChange: setPage }} />
```

### + ahooks
ahooks useRequest 可替换为 TanStack Query useQuery，后者功能更全：
```tsx
// ahooks: 简单场景
const { data, loading } = useRequest(fetchTodos)

// TanStack Query: 需要缓存/重取/突变时
const { data, isLoading } = useQuery({ queryKey: ['todos'], queryFn: fetchTodos })
```
