# React Hook Form — Patterns

## 核心原则

**非受控组件为主** — 性能最优。用 `register` 而非 `value`/`onChange`。只有第三方受控组件才用 `Controller`。

## 标准模式

```tsx
import { useForm } from 'react-hook-form'

function MyForm() {
  const { register, handleSubmit, formState: { errors } } = useForm()

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('name', { required: '请输入姓名' })} />
      {errors.name && <span>{errors.name.message}</span>}

      <input {...register('email', {
        required: '请输入邮箱',
        pattern: { value: /^\S+@\S+$/i, message: '邮箱格式不正确' }
      })} />
      {errors.email && <span>{errors.email.message}</span>}

      <button type="submit">提交</button>
    </form>
  )
}
```

## Schema 验证 (Zod)

```tsx
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const schema = z.object({
  name: z.string().min(2, '至少2个字符'),
  email: z.string().email('邮箱格式不正确')
})

const { register, handleSubmit } = useForm({
  resolver: zodResolver(schema)
})
```

## 与知识库其他库配合

### + Shineout
```tsx
// Shineout 组件用 Controller 包装
<Controller
  name="city"
  control={control}
  render={({ field }) => <Select data={cities} value={field.value} onChange={field.onChange} />}
/>
```

### + react-bits
表单字段的动画效果用 react-bits：
```tsx
<FadeContent>{errors.name && <span>{errors.name.message}</span>}</FadeContent>
```

### + animal-island-ui
动森风格的按钮/输入框 + react-hook-form 逻辑：
```tsx
<input {...register('name')} className="animal-input" />
<Button type="primary" htmlType="submit">提交</Button>
```
