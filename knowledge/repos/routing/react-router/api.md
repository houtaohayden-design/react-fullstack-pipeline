# React Router — API Reference

> react-router v7.15 | React 路由库 | React >= 18

## Setup

```bash
npm install react-router
```

## Core API

### RouterProvider + createBrowserRouter (推荐)

```tsx
import { createBrowserRouter, RouterProvider } from 'react-router/dom'

const router = createBrowserRouter([
  {
    path: '/',
    Component: RootLayout,
    loader: rootLoader,
    ErrorBoundary: RootErrorBoundary,
    children: [
      { index: true, Component: Home, loader: homeLoader },
      {
        path: 'teams/:teamId',
        Component: Team,
        loader: teamLoader,
        action: teamAction
      }
    ]
  }
])

createRoot(document.getElementById('root')).render(
  <RouterProvider router={router} />
)
```

### Link / NavLink

```tsx
import { Link, NavLink } from 'react-router'

<Link to="/about" replace>About</Link>
<Link to="/users" state={{ from: currentPath }}>Users</Link>

<NavLink
  to="/dashboard"
  className={({ isActive }) => isActive ? 'active' : ''}
  end
>
  Dashboard
</NavLink>
```

### Outlet

```tsx
function RootLayout() {
  return (
    <div className="layout">
      <Sidebar />
      <Outlet context={{ user }} />
    </div>
  )
}

// 子路由通过 useOutletContext 获取
const { user } = useOutletContext()
```

### Hooks

```tsx
import { useNavigate, useParams, useLoaderData, useActionData, useFetcher, useSubmit } from 'react-router'

// 导航
const navigate = useNavigate()
navigate('/dashboard')
navigate(-1)                    // 后退
navigate('/users', { replace: true, state: { from: path } })

// 路由参数
const { teamId } = useParams()

// Loader 数据
const data = useLoaderData()

// Action 返回的数据
const actionData = useActionData()

// Form 提交
const submit = useSubmit()
submit(formData, { method: 'post', action: '/api/users' })

// Fetcher (无路由变化的请求)
const fetcher = useFetcher()
fetcher.load('/api/search?q=xxx')
fetcher.submit(formData, { method: 'post' })
// fetcher.Form, fetcher.data, fetcher.state
```

### Loader & Action

```tsx
export async function loader({ params, request }: LoaderFunctionArgs) {
  const team = await db.getTeam(params.teamId)
  if (!team) throw new Response('Not Found', { status: 404 })
  return { team }
}

export async function action({ request, params }: ActionFunctionArgs) {
  const formData = await request.formData()
  await db.updateTeam(params.teamId, Object.fromEntries(formData))
  return redirect(`/teams/${params.teamId}`)
}
```

### Error Boundary

```tsx
// 路由级 ErrorBoundary
function TeamErrorBoundary() {
  const error = useRouteError()
  if (isRouteErrorResponse(error)) {
    return <h1>{error.status} {error.statusText}</h1>
  }
  return <h1>Oops! {error.message}</h1>
}
```

### Deferred Data (Suspense)

```tsx
// 不 await 的 Promise 会被自动 defer
export async function loader() {
  const book = await getBook()
  const reviews = getReviews()  // 不 await, 延迟加载
  return { book, reviews }
}

function Book() {
  const { book, reviews } = useLoaderData()
  return (
    <div>
      <h1>{book.title}</h1>
      <Suspense fallback={<ReviewsSkeleton />}>
        <Await resolve={reviews} errorElement={<Error />}>
          {(resolvedReviews) => <Reviews items={resolvedReviews} />}
        </Await>
      </Suspense>
    </div>
  )
}
```

### Form (非 SPA 提交)

```tsx
import { Form } from 'react-router'

<Form method="post" action="/login">
  <input name="email" />
  <button>Login</button>
</Form>
```

### createRoutesFromElements (JSX 路由)

```tsx
import { createRoutesFromElements, Route } from 'react-router'

const routes = createRoutesFromElements(
  <Route path="/" loader={rootLoader} Component={Root}>
    <Route index loader={indexLoader} Component={IndexPage} />
    <Route path="about" Component={About} />
  </Route>
)
const router = createBrowserRouter(routes)
```

## Route 配置属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `path` | `string` | 路径 |
| `index` | `boolean` | 索引路由 |
| `Component` | `React.ComponentType` | 页面组件 |
| `loader` | `LoaderFunction` | 数据加载 |
| `action` | `ActionFunction` | 表单提交 |
| `ErrorBoundary` | `React.ComponentType` | 错误边界 |
| `HydrateFallback` | `React.ComponentType` | SSR 水合前显示 |
| `lazy` | `LazyRouteFunction` | 懒加载 |
| `shouldRevalidate` | `ShouldRevalidateFunction` | 重新验证控制 |
| `middleware` | `MiddlewareFunction[]` | 中间件 |

## 关键特性

- Data Router (loader/action 模式)
- 嵌套路由 + Outlet
- 错误边界
- Suspense + 延迟数据
- Form 提交 (非 SPA)
- Fetcher (不改变 URL 的请求)
- 滚动恢复
- SSR 支持
- 代码拆分 (lazy routes)
