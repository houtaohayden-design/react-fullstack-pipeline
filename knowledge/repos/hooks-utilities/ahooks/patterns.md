# ahooks — Patterns

## 核心原则

**蚂蚁集团的 React Hooks 最佳实践库。** 优先用 ahooks 来实现常见逻辑，不重复造轮子。

## 高频使用模式

### 请求管理
```tsx
import { useRequest } from 'ahooks'

const { data, loading, run } = useRequest(getUserList, {
  manual: true,        // 手动触发
  debounceWait: 300,   // 搜索防抖
  retryCount: 2,       // 失败重试
  onSuccess: (data) => setList(data)
})
```

### 防抖搜索
```tsx
import { useDebounceFn } from 'ahooks'

const { run } = useDebounceFn(
  (keyword) => fetchResults(keyword),
  { wait: 300 }
)
```

### 无限滚动
```tsx
import { useInfiniteScroll } from 'ahooks'

const { data, loading, loadMore, noMore } = useInfiniteScroll(
  (d) => getList(d?.nextId),
  { isNoMore: (d) => !d?.hasMore }
)
```

### 表单锁 (防重复提交)
```tsx
import { useLockFn } from 'ahooks'

const submit = useLockFn(async () => {
  await saveForm(data)
  Message.success('保存成功')
})
```

## 与知识库其他库配合

### + react-hook-form
```tsx
// ahooks useLockFn 包装 react-hook-form 的 onSubmit
const onSubmit = useLockFn(async (data) => {
  await submitForm(data)
})

const { register, handleSubmit } = useForm()
<form onSubmit={handleSubmit(onSubmit)}>
```

### + zustand
```tsx
// ahooks useRequest 加载数据 → zustand store
const { data } = useRequest(fetchUser)
useEffect(() => {
  if (data) useUserStore.setState({ user: data })
}, [data])
```

### + Shineout
```tsx
// ahooks usePagination 与 Shineout Table 搭配
const { data, pagination, loading } = usePagination(fetchTable)
<Table data={data} loading={loading} pagination={pagination} />
```

### + react-bits
```tsx
// ahooks useBoolean 控制 react-bits 动画显示
const [visible, { toggle }] = useBoolean(false)
<FadeContent trigger={visible}>...</FadeContent>
```

## 常用组合

```
表单提交: useLockFn + react-hook-form
搜索: useDebounceFn + useRequest
列表: useInfiniteScroll / usePagination + Shineout Table
状态: useBoolean / useSetState + zustand (局部/全局)
存储: useLocalStorageState + zustand persist (取其一)
定时: useInterval / useCountDown + react-bits (动画)
```
