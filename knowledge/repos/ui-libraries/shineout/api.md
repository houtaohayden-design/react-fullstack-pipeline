# Shineout — API Reference

> Shein 前端组件库 v2.0.31 | 41 components | React >= 16

## Setup

```bash
npm install shineout
```

```tsx
import { Button, Table, Form, Modal } from 'shineout'
// Styles auto-included with components (Less/CSS modules)
```

## Components

### Button
- **Props:** `type` (default/primary/secondary/danger/text/link), `size` (small/default/large), `disabled`, `loading`, `href`, `onClick`
- **Usage:** `<Button type="primary" onClick={handler}>确认</Button>`
- **Deps:** none

### Input
- **Props:** `value`, `onChange`, `placeholder`, `type` (text/password/number/email), `size`, `disabled`, `clearable`, `prefix`/`suffix`, `maxLength`, `error`, `tip`
- **Usage:** `<Input value={val} onChange={setVal} clearable placeholder="请输入" />`
- **Deps:** none

### InputTitle (Input.Number)
- **Props:** `value`, `onChange`, `min`, `max`, `step`, `digits`, `size`, `disabled`
- **Usage:** `<Input.Number value={n} onChange={setN} min={0} max={100} />`
- **Note:** Accessed as `Input.Number`, not standalone

### Textarea
- **Props:** `value`, `onChange`, `rows`, `maxLength`, `disabled`, `placeholder`
- **Usage:** `<Textarea rows={4} value={text} onChange={setText} />`

### Select
- **Props:** `data` (array of objects/strings), `value`, `onChange`, `keygen`, `renderItem`, `multiple`, `filter`, `disabled`, `placeholder`, `clearable`, `size`, `treeData` (tree mode), `compressed` (multi-select collapse)
- **Usage:** `<Select data={options} value={val} onChange={setVal} keygen="id" renderItem="label" />`

### Cascader
- **Props:** `data`, `value`, `onChange`, `keygen`, `renderItem`, `mode` (0/1/2/3 for return type), `filter`, `disabled`, `placeholder`, `final` (must select leaf)
- **Usage:** `<Cascader data={tree} value={val} onChange={setVal} keygen="id" renderItem="name" />`

### DatePicker
- **Props:** `value`, `onChange`, `type` (date/datetime/time/week/month/year/quarter), `format`, `range`, `disabled`, `placeholder`, `min`/`max`, `clearable`
- **Usage:** `<DatePicker value={date} onChange={setDate} type="date" />`
- **Deps:** date-fns, dayjs

### Checkbox
- **Props:** `checked`, `onChange`, `disabled`, `children` (label)
- **Group:** `<Checkbox.Group data={options} value={arr} onChange={setArr} keygen="id" renderItem="label" />`

### Radio
- **Props:** `checked`, `onChange`, `disabled`
- **Group:** `<Radio.Group data={options} value={val} onChange={setVal} keygen="id" renderItem="label" />`

### Switch
- **Props:** `checked`, `onChange`, `disabled`, `size` (default/small), `checkedChildren`/`uncheckedChildren`
- **Usage:** `<Switch checked={val} onChange={setVal} />`

### Slider
- **Props:** `value`, `onChange`, `min`, `max`, `step`, `range`, `disabled`, `formatValue`
- **Usage:** `<Slider value={val} onChange={setVal} min={0} max={100} />`

### Rate
- **Props:** `value`, `onChange`, `count`, `disabled`, `readOnly`, `size`
- **Usage:** `<Rate value={val} onChange={setVal} count={5} />`

### Table
- **Props:** `columns` (array of column defs), `data` (array), `keygen`, `bordered`, `striped`, `size`, `loading`, `pagination`, `onRowClick`, `onRowSelect`, `onSortChange`, `fixed` (column fixed), `virtual` (virtual scroll), `span` (colspan/rowspan), `tree` (tree table), `expandable`, `resizable`, `drag`
- **Usage:** `<Table columns={cols} data={rows} keygen="id" pagination />`
- **Note:** Most feature-rich component. Virtual scroll, tree mode, column resize all built-in.

### Form
- **Props:** `value` (object), `onChange`, `onSubmit`, `rules` (validation), `labelWidth`, `inline`, `disabled`
- **Item:** `<Form.Item name="field" label="标签" required rules={[...]}>`
- **Flow:** `<Form value={form} onChange={setForm} onSubmit={submit}>`
- **Validation:** Rule-based, built-in validators for required, email, url, number, min, max, minLen, maxLen, regExp, custom

### Modal
- **Props:** `visible`, `onClose`, `title`, `footer`, `width`, `height`, `maskClose` (click mask to close), `destroy` (unmount on close)
- **Usage:** `<Modal visible={show} onClose={() => setShow(false)} title="标题">content</Modal>`

### Drawer
- **Props:** `visible`, `onClose`, `title`, `width`, `placement` (top/right/bottom/left), `maskClose`, `destroy`
- **Usage:** `<Drawer visible={show} onClose={closeFn} placement="right">content</Drawer>`

### Card
- **Props:** `title`, `subtitle`, `shadow`, `hoverable`, `headerStyle`, `bodyStyle`
- **Accordion:** `<Card.Accordion>` for collapsible card groups

### CardGroup
- **Props:** `data`, `renderItem`, `keygen`, `grid` (column count), `loading`
- **Usage:** `<CardGroup data={cards} renderItem={renderCard} keygen="id" grid={3} />`

### Tabs
- **Props:** `active`, `onChange`, `shape` (card/line/button), `position` (top/left/right/bottom), `background`
- **Panel:** `<Tabs.Panel tab="Tab 1" disabled={false}>content</Tabs.Panel>`

### Menu
- **Props:** `data`, `keygen`, `renderItem`, `mode` (inline/horizontal/vertical), `active`, `onSelect`, `inlineIndent`, `collapsible`
- **Submenu:** Nested data with `children` array
- **Usage:** `<Menu data={menuData} keygen="path" renderItem="title" mode="inline" />`

### Tree
- **Props:** `data`, `keygen`, `renderItem`, `expanded`, `onExpand`, `active`, `onSelect`, `mode` (0/1/2 for checkbox), `onCheck`, `checkStrictly`, `drag`, `filter`
- **Usage:** `<Tree data={treeData} keygen="id" renderItem="name" expanded={exp} />`

### TreeSelect
- **Props:** `data`, `value`, `onChange`, `keygen`, `renderItem`, `multiple`, `filter`, `compressed`
- **Usage:** `<TreeSelect data={tree} value={val} onChange={setVal} keygen="id" renderItem="name" />`

### Transfer
- **Props:** `data`, `value`, `onChange`, `keygen`, `renderItem`, `titles` ([left, right]), `filter`, `loading`, `disabled`
- **Usage:** `<Transfer data={source} value={selected} onChange={setSelected} keygen="id" renderItem="name" />`

### Dropdown
- **Props:** `data`, `renderItem`, `onClick`, `trigger` (click/hover), `placeholder`, `position`
- **Usage:** `<Dropdown data={items} renderItem="label" onClick={handler}>Click me</Dropdown>`

### Popover
- **Props:** `content`, `trigger` (click/hover/focus), `position`, `visible`, `onVisibleChange`
- **Usage:** `<Popover content="提示文字" trigger="hover"><Button>Hover</Button></Popover>`

### Tooltip
- **Props:** `tip`, `trigger` (hover/click/focus), `position`
- **Usage:** `<Tooltip tip="帮助信息"><Icon name="help" /></Tooltip>`

### Alert
- **Props:** `type` (info/success/warning/danger), `title`, `closable`, `onClose`, `icon`, `hideTitle`
- **Usage:** `<Alert type="success" title="操作成功" closable />`

### Message
- **Props:** `show(title, options)` / `Message.success()` / `Message.warning()` / `Message.error()` / `Message.info()`
- **Usage:** `Message.success('保存成功')` — imperative API

### Progress
- **Props:** `value` (0-100), `type` (line/circle), `strokeWidth`, `color`, `background`, `size`
- **Usage:** `<Progress value={60} type="circle" />`

### Spin
- **Props:** `loading`, `tip`, `size`
- **Usage:** `<Spin loading={loading} tip="加载中..."><Content /></Spin>`

### Pagination
- **Props:** `total`, `current`, `onChange`, `pageSize`, `size`, `layout` (array of 'links'/'pageSize'/ 'jumper')
- **Usage:** `<Pagination total={100} current={page} onChange={setPage} pageSize={10} />`

### Breadcrumb
- **Props:** `data`, `keygen`, `renderItem`, `separator`
- **Usage:** `<Breadcrumb data={crumbs} keygen="path" renderItem="title" />`

### Tag
- **Props:** `children`, `onClose`, `disabled`, `color`, `mode` (fill/outline/bright)
- **Usage:** `<Tag onClose={remove}>标签</Tag>`

### Divider
- **Props:** `orientation` (left/center/right), `color`, `style`
- **Usage:** `<Divider>Section Title</Divider>`

### Carousel
- **Props:** `data`, `renderItem`, `interval`, `showArrow` (hover/always/none), `showDot`, `autoplay`
- **Usage:** `<Carousel data={slides} renderItem={renderSlide} interval={3000} />`

### Upload
- **Props:** `action` (URL), `headers`, `name` (field name), `onSuccess`, `onError`, `limit` (file count), `accept`, `multiple`, `drag`, `children` (render upload area)
- **Image mode:** `<Upload.Image>` for image-only upload with preview
- **Usage:** `<Upload action="/api/upload" onSuccess={handleSuccess}>Click to upload</Upload>`

### Image
- **Props:** `src`, `width`, `height`, `fit` (fill/contain/cover/center), `alt`, `href`, `lazy`, `title`, `shape`
- **Group:** `<Image.Group>` for gallery mode

### Icon
- **Props:** `name` (web font icon name), `size`, `color`, `style`
- **Usage:** `<Icon name="star" size={16} color="#ffcc00" />`

### Sticky
- **Props:** `top` (px from top), `bottom`, `zIndex`, `onChange` (callback when stuck/unstuck)
- **Usage:** `<Sticky top={0}><Header /></Sticky>`

### Lazyload
- **Props:** `onReady`, `mode` (scroll/event), `offset`
- **Usage:** `<Lazyload onReady={() => loadMore()}><List /></Lazyload>`

### AnimationList
- **Props:** `data`, `renderItem`, `keygen`, `duration`, `delay`, `animation` (fade/slide/scale), `onEnd`
- **Usage:** `<AnimationList data={items} renderItem={renderItem} keygen="id" animation="fade" />`

### Scroll
- **Props:** `onScroll`, `onScrollEnd`, `height`, `onScrollTop`
- **Usage:** `<Scroll height={400} onScrollEnd={loadMore}><List /></Scroll>`

### EditableArea
- **Props:** `value`, `onChange`, `disabled`, `placeholder`, `rows`
- **Usage:** `<EditableArea value={text} onChange={setText} />`

### Gap
- **Props:** `size` (number or array [x, y]), `style`
- **Usage:** `<Gap size={16} />` — spacer component

### Grid
- **Props:** `data`, `renderItem`, `keygen`, `columns`, `gap`, `responsive`
- **Layout slot system:** Customizable cell rendering

### List
- **Props:** `data`, `renderItem`, `keygen`, `loading`, `bordered`, `footer`

### Rule
- **Props:** Form validation rules engine (used internally by Form)

### Datum
- **Props:** Internal data management utility (used by complex components like Table, Form)

## Additional Exports

```tsx
export { utils }           // Utility functions
export { setLocale }       // Set i18n locale
export { config, setConfig, isRTL }  // Global config + RTL support
```

**Types exported:** All component Props types available via TypeScript.
