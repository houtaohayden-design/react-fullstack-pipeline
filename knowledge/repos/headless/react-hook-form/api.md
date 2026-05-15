# React Hook Form — API Reference

> react-hook-form v7.75.0 | React 表单库 | React >= 16.8

## Setup

```bash
npm install react-hook-form
```

## Core API

### useForm (主 Hook)

```tsx
import { useForm } from 'react-hook-form'

const { register, handleSubmit, formState, watch, reset, setValue, getValues, control, trigger, setError, clearErrors } = useForm({
  defaultValues: {},
  mode: 'onSubmit'  // onChange | onBlur | onSubmit | onTouched | all
})
```

### register (注册表单字段)

```tsx
<input {...register('name', { required: '必填', minLength: 2, maxLength: 50, pattern: /^[A-Za-z]+$/ })} />
```

**验证规则:** `required`, `min`/`max`, `minLength`/`maxLength`, `pattern`, `validate` (自定义函数)

### handleSubmit (提交处理)

```tsx
<form onSubmit={handleSubmit(onValid, onInvalid)}>
```

### formState (表单状态)

```tsx
const { errors, isDirty, isValid, isSubmitting, isSubmitted, dirtyFields, touchedFields } = formState
```

### watch (监听字段)

```tsx
const name = watch('name')           // 单字段
const all = watch()                   // 全部
const fields = watch(['name','email']) // 多字段
```

### Controller (受控组件包装器)

用于包装第三方受控组件 (Select, DatePicker, etc.):

```tsx
import { Controller } from 'react-hook-form'

<Controller
  name="city"
  control={control}
  rules={{ required: true }}
  render={({ field }) => <Select {...field} data={cities} />}
/>
```

### useFieldArray (动态字段数组)

```tsx
import { useFieldArray } from 'react-hook-form'

const { fields, append, remove, insert, swap, move, prepend } = useFieldArray({
  control,
  name: 'items'
})
```

### FormProvider (跨组件表单上下文)

```tsx
import { FormProvider, useFormContext } from 'react-hook-form'

const methods = useForm()
<FormProvider {...methods}>
  <NestedInput />  {/* 内部用 useFormContext() 访问 */}
</FormProvider>
```

### useFormContext

```tsx
const { register, formState } = useFormContext()
```

## 关键特性

- **非受控为主** — 性能极佳，不触发 rerender
- **依赖 Zod/Yup** — `@hookform/resolvers` 集成 schema 验证
- **体积小** — 无外部依赖，gzip < 10KB
- **TypeScript** — 完整类型支持
