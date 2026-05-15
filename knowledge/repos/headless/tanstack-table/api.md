# TanStack Table — API Reference

> @tanstack/react-table v8.21.3 | Headless React 表格/数据网格 | React >= 16.8

## Setup

```bash
npm install @tanstack/react-table
```

## Core API

### useReactTable (主 Hook)

```tsx
import { useReactTable, createColumnHelper, getCoreRowModel, flexRender } from '@tanstack/react-table'

const table = useReactTable({
  data,
  columns,
  getCoreRowModel: getCoreRowModel(),
  // 插件
  getPaginationRowModel: getPaginationRowModel(),
  getSortedRowModel: getSortedRowModel(),
  getFilteredRowModel: getFilteredRowModel(),
  getGroupedRowModel: getGroupedRowModel(),
  getExpandedRowModel: getExpandedRowModel(),
})
```

### Column 定义

```tsx
// 方式1: createColumnHelper (推荐，类型安全)
const columnHelper = createColumnHelper<User>()

const columns = [
  columnHelper.accessor('name', {
    header: '姓名',
    cell: info => info.getValue(),
    enableSorting: true,
    enableFiltering: true
  }),
  columnHelper.display({
    id: 'actions',
    header: '操作',
    cell: info => <Button onClick={() => edit(info.row.original)}>Edit</Button>
  })
]

// 方式2: 普通数组
const columns = [
  { accessorKey: 'name', header: '姓名' },
  { accessorKey: 'email', header: '邮箱' }
]
```

### 渲染表格

```tsx
<table>
  <thead>
    {table.getHeaderGroups().map(headerGroup => (
      <tr key={headerGroup.id}>
        {headerGroup.headers.map(header => (
          <th key={header.id}>
            {flexRender(header.column.columnDef.header, header.getContext())}
          </th>
        ))}
      </tr>
    ))}
  </thead>
  <tbody>
    {table.getRowModel().rows.map(row => (
      <tr key={row.id}>
        {row.getVisibleCells().map(cell => (
          <td key={cell.id}>
            {flexRender(cell.column.columnDef.cell, cell.getContext())}
          </td>
        ))}
      </tr>
    ))}
  </tbody>
</table>
```

### 插件 (Row Models)

| Model | 功能 |
|-------|------|
| `getCoreRowModel` | 基础表格 (必选) |
| `getPaginationRowModel` | 分页 |
| `getSortedRowModel` | 排序 |
| `getFilteredRowModel` | 过滤 |
| `getGroupedRowModel` | 分组 |
| `getExpandedRowModel` | 展开行 |
| `getFacetedRowModel` | 分面数据 |
| `getFacetedMinMaxValues` | 最大/最小值 |
| `getFacetedUniqueValues` | 唯一值集合 |

### 关键特性

- **Headless** — 不渲染 DOM，完全控制 UI
- **列排序** — `column.getToggleSortingHandler()`
- **列过滤** — 内置模糊、精确、范围、分面过滤
- **列固定** — column pinning (left/right)
- **列排序** — column ordering (拖拽排序)
- **列缩放** — column sizing (拖拽宽度)
- **行选择** — row selection (单选/多选)
- **展开行** — expanding (子行/详情)
- **分组** — grouping (聚合行)
- **虚拟滚动** — 配合 @tanstack/react-virtual
- **TypeScript** — 完整的列级类型推导

### 状态管理

```tsx
const [sorting, setSorting] = useState<SortingState>([])
const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 })

const table = useReactTable({
  // ...
  state: { sorting, pagination },
  onSortingChange: setSorting,
  onPaginationChange: setPagination,
  manualPagination: true  // 服务端分页
})
```
