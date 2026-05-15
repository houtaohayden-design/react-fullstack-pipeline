# React Router — Patterns

## 定位

**React 标准路由库。** 支持 SPA 路由和 SSR，data router 模式管理 loader/action/form 全流程。

## 路由模式选择

| 模式 | 场景 |
|------|------|
| Data Router (`createBrowserRouter`) | 新项目首选，loader/action 模式 |
| JSX Routes (`<Routes>`) | 老项目迁移、简单路由 |
| HashRouter | 无服务端配置的静态部署 |
| MemoryRouter | 测试、非浏览器环境 |

## 标准模式

### 权限路由

```tsx
// 路由守卫
function ProtectedRoute() {
  const user = useLoaderData()
  if (!user) return <Navigate to="/login" />
  return <Outlet context={{ user }} />
}

const routes = [{
  element: <ProtectedRoute />,
  loader: authLoader,
  children: [
    { path: '/dashboard', Component: Dashboard },
    { path: '/settings', Component: Settings }
  ]
}]
```

### 面包屑

```tsx
import { useMatches } from 'react-router'

function Breadcrumbs() {
  const matches = useMatches()
  const crumbs = matches.filter(m => m.handle?.crumb).map(m => ({
    title: m.handle.crumb(m.data),
    path: m.pathname
  }))
  return <Breadcrumb items={crumbs} />
}

// 路由配置
{ path: 'users', handle: { crumb: () => 'Users' }, children: [
  { path: ':id', handle: { crumb: (data) => data.user.name } }
]}
```

### 搜索参数同步

```tsx
import { useSearchParams } from 'react-router'

function SearchPage() {
  const [searchParams, setSearchParams] = useSearchParams()
  const query = searchParams.get('q') || ''
  const page = parseInt(searchParams.get('page') || '1')

  return (
    <Input
      value={query}
      onChange={e => setSearchParams({ q: e.target.value, page: '1' })}
    />
  )
}
```

## 与知识库其他库配合

### + TanStack Query
Loader 预取 + useQuery 后台刷新：
```tsx
// loader 确保数据在渲染前就位
export async function loader() {
  await queryClient.ensureQueryData({
    queryKey: ['todos'],
    queryFn: fetchTodos
  })
}

// 组件内用 useQuery 保持数据新鲜
function Todos() {
  const { data } = useQuery({
    queryKey: ['todos'],
    queryFn: fetchTodos,
    staleTime: 30_000
  })
}
```

### + react-bits
页面切换动效配合 React Router：
```tsx
import { AnimatePresence } from 'framer-motion' // or react-bits

function App() {
  const location = useLocation()
  return (
    <AnimatePresence mode="wait">
      <Routes location={location} key={location.pathname}>
        <Route path="/" Component={Home} />
        <Route path="/about" Component={About} />
      </Routes>
    </AnimatePresence>
  )
}
```

### + Shineout
Shineout 侧边栏导航 + React Router：
```tsx
<Menu
  data={menuItems}
  onClick={item => navigate(item.path)}
  activeKey={location.pathname}
/>
```
