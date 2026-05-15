# Shineout — Patterns

## Styling Approach

**Less + CSS Modules**. Each component has its own `.less` file in its `styles/` directory. Master variables in `src/styles/variables.less`.

Design tokens use `@so-` prefix:
```less
@so-prefix: 'so';    // CSS class prefix → .so-btn, .so-table, etc.
```

### Theme System

7 built-in themes in `src/styles/themes/`:
- `default` — Shineout's own design
- `shineout` — Alternative Shineout skin
- `antd` / `antd2` — Ant Design compatible themes
- `bootstrap` — Bootstrap-compatible
- `cssvar` — CSS custom properties based
- `base` — Minimal base styles

Switch theme via `config`:
```tsx
import { setConfig } from 'shineout'
setConfig({ theme: 'antd' })
```

### Class Naming

Components use the `so-` prefix:
```
.so-btn
.so-table
.so-modal
.so-form-item
.so-input-wrapper
```

## Import Patterns

**Named imports (recommended):**
```tsx
import { Button, Table, Form, Modal } from 'shineout'
```

**Sub-components accessed via dot notation:**
```tsx
<Form.Item name="email">      // Form sub-component
<Input.Number />              // Input sub-component
<Checkbox.Group />            // Checkbox sub-component
<Tabs.Panel />                // Tabs sub-component
<Upload.Image />              // Upload sub-component
<Image.Group />               // Image sub-component
<Card.Accordion />            // Card sub-component
```

## Data Components Pattern

Shineout data components share a consistent pattern:
```tsx
<Component
  data={dataArray}        // Source data
  keygen="id"             // Unique key field (string or function)
  renderItem="label"      // Display field (string or function)
  value={selected}        // Controlled value
  onChange={setSelected}  // Change handler
/>
```

Components using this pattern: Select, Cascader, Checkbox.Group, Radio.Group, Tree, TreeSelect, Transfer, Menu, Dropdown, Tabs, Table, List, CardGroup, Carousel, Grid.

## Form Pattern

```tsx
import { Form, Input, Button, Select } from 'shineout'

function MyForm() {
  const [form, setForm] = useState({ name: '', email: '', city: '' })

  const rules = {
    name: [{ required: true, message: '请输入姓名' }],
    email: [
      { required: true, message: '请输入邮箱' },
      { type: 'email', message: '邮箱格式不正确' }
    ]
  }

  return (
    <Form value={form} onChange={setForm} rules={rules} onSubmit={submit}>
      <Form.Item name="name" label="姓名" required>
        <Input placeholder="请输入" />
      </Form.Item>
      <Form.Item name="email" label="邮箱" required>
        <Input placeholder="请输入邮箱" />
      </Form.Item>
      <Form.Item name="city" label="城市">
        <Select keygen="id" data={cities} renderItem="name" />
      </Form.Item>
      <Button type="primary" htmlType="submit">提交</Button>
    </Form>
  )
}
```

## Table Pattern

Table is the most powerful component:
```tsx
const columns = [
  { title: 'ID', render: 'id', width: 80, sorter: true },
  { title: 'Name', render: 'name', width: 200 },
  { title: 'Status', render: (d) => <Tag>{d.status}</Tag> },
  { title: 'Actions', render: (d) => <Button onClick={() => edit(d)}>Edit</Button> }
]

<Table
  keygen="id"
  columns={columns}
  data={rows}
  pagination
  bordered
  onRowClick={handleRow}
/>
```

## i18n

```tsx
import { setLocale } from 'shineout'
// Set locale for built-in text (pagination, upload, etc.)
```

## Compatibility

### With react-bits
- **Good:** Shineout provides base UI, react-bits adds animation on top
- Can wrap Shineout Modal/Drawer with react-bits entrance animations
- Can add react-bits text animations inside Shineout components
- Avoid: Don't animate Shineout Table rows with react-bits (Table has its own row rendering)

### With animal-island-ui
- **Not directly compatible:** Different design philosophies (enterprise vs. 动森)
- Shineout is enterprise/data-heavy; animal-island-ui is casual/game-style
- Use one as primary library, the other sparingly for specific components
- Don't mix both on the same page unless you have a clear design reason

## Key Patterns

1. **Controlled components:** All inputs use `value` + `onChange` (fully controlled)
2. **keygen:** Universal key extraction — string (field name) or function `(item) => key`
3. **renderItem:** Universal display extraction — string or function `(item) => ReactNode`
4. **Sub-components via dot notation:** `Form.Item`, `Input.Number`, `Checkbox.Group`
5. **Imperative APIs:** `Message.success()`, `Modal.confirm()` (function calls, not components)
