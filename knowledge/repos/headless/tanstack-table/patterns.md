# TanStack Table — Patterns

## 定位

**Headless 表格库。** TanStack Table 提供所有表格逻辑（排序、过滤、分页、分组、展开、选择），但不渲染任何 DOM。开发者完全控制 UI。

## 何时用 TanStack Table vs Shineout Table

| 场景 | 推荐 |
|------|------|
| 管理后台 CRUD 表格 | Shineout Table（开箱即用） |
| 高度自定义表格 UI | TanStack Table（完全控制） |
| 复杂数据处理 (分组/聚合) | TanStack Table |
| 虚拟滚动超大表格 | TanStack Table + react-virtual |
| 快速原型 | Shineout Table |

## 标准模式

```tsx
function DataTable({ data, columns }) {
  const [sorting, setSorting] = useState([])
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 20 })

  const table = useReactTable({
    data,
    columns,
    state: { sorting, pagination },
    onSortingChange: setSorting,
    onPaginationChange: setPagination,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getPaginationRowModel: getPaginationRowModel()
  })

  return (
    <>
      <table>...</table>
      <Pagination>
        <Button onClick={() => table.previousPage()} disabled={!table.getCanPreviousPage()}>上一页</Button>
        <span>第 {table.getState().pagination.pageIndex + 1} 页</span>
        <Button onClick={() => table.nextPage()} disabled={!table.getCanNextPage()}>下一页</Button>
      </Pagination>
    </>
  )
}
```

## 服务端模式

```tsx
// 完全由服务端处理排序/过滤/分页
const [{ pageIndex, pageSize }, setPagination] = useState({ pageIndex: 0, pageSize: 10 })
const [sorting, setSorting] = useState([])
const [filters, setFilters] = useState([])

const { data, total } = useQuery({
  queryKey: ['table', { pageIndex, pageSize, sorting, filters }],
  queryFn: () => fetchTableData({ pageIndex, pageSize, sorting, filters })
})

const table = useReactTable({
  data: data || [],
  columns,
  pageCount: Math.ceil(total / pageSize),
  state: { pagination: { pageIndex, pageSize }, sorting },
  onPaginationChange: setPagination,
  onSortingChange: setSorting,
  manualPagination: true,    // 服务端分页
  manualSorting: true,       // 服务端排序
  getCoreRowModel: getCoreRowModel()
})
```

## 与知识库其他库配合

### + Shineout
TanStack Table 处理逻辑 + Shineout 组件做 UI：
```tsx
{table.getRowModel().rows.map(row => (
  <tr>
    {row.getVisibleCells().map(cell => (
      <td><Tag>{flexRender(...)}</Tag></td>
    ))}
  </tr>
))}
```

### + react-hook-form
表格内行编辑：
```tsx
const { register } = useForm()
const columns = [
  columnHelper.accessor('name', {
    cell: ({ row, getValue }) => <input {...register(`rows.${row.index}.name`)} />
  })
]
```
