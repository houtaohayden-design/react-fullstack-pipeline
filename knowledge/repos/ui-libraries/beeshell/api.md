# Beeshell — API Reference

> 美团 React Native 组件库 v2.0.11 | 30 components | RN >= 0.53

**重要：React Native 专用，非 Web 库。**

## Setup

```bash
npm install beeshell
```

```tsx
import { Button, Form, Modal } from 'beeshell'
```

基于美团 MRN 框架，支持 iOS + Android，提供自定义主题。

## Components

### Button
- **Props:** `type` (primary/default/danger/text), `size` (sm/md/lg), `disabled`, `loading`, `onPress`, `style`
- **Usage:** `<Button type="primary" onPress={handler}>确认</Button>`

### Icon
- **Props:** `name`, `size`, `color`
- **Usage:** `<Icon name="star" size={20} color="#f90" />`

### Badge
- **Props:** `count`, `dot` (show dot only), `max`, `style`
- **Usage:** `<Badge count={5}><View><Icon name="message" /></View></Badge>`

### Tag
- **Props:** `type`, `closable`, `onClose`, `style`
- **Usage:** `<Tag type="primary">标签</Tag>`

### Form
- **Props:** `data` (form values object), `onChange`, `rules`, `style`
- **Item:** `<Form.Item name="field" label="标签" required rules={[...]}>`
- **Usage:** `<Form data={form} onChange={setForm} rules={rules}>...</Form>`

### Input
- **Props:** `value`, `onChange`, `placeholder`, `type` (text/password/number), `maxLength`, `disabled`, `error`, `clearable`, `prefix`/`suffix`
- **Usage:** `<Input value={val} onChangeText={setVal} placeholder="请输入" />`

### Radio
- **Props:** `checked`, `onChange`, `disabled`
- **Group:** `<Radio.Group data={options} value={val} onChange={setVal} />`

### Checkbox
- **Props:** `checked`, `onChange`, `disabled`
- **Group:** `<Checkbox.Group data={options} value={arr} onChange={setArr} />`

### Switch
- **Props:** `checked`, `onChange`, `disabled`
- **Usage:** `<Switch checked={val} onChange={setVal} />`

### Slider
- **Props:** `value`, `onChange`, `min`, `max`, `step`
- **Usage:** `<Slider value={val} onChange={setVal} min={0} max={100} />`

### Rate
- **Props:** `value`, `onChange`, `count`, `size`
- **Usage:** `<Rate value={val} onChange={setVal} count={5} />`

### Stepper
- **Props:** `value`, `onChange`, `min`, `max`, `step`, `disabled`
- **Usage:** `<Stepper value={val} onChange={setVal} min={0} max={10} />`

### Scrollpicker
- **Props:** `data`, `value`, `onChange`, `renderItem`
- **Usage:** `<Scrollpicker data={items} value={val} onChange={setVal} />`

### Datepicker
- **Props:** `value`, `onChange`, `format`, `min`/`max`
- **Usage:** `<Datepicker value={date} onChange={setDate} />`

### Timepicker
- **Props:** `value`, `onChange`, `format`, `minuteStep`
- **Usage:** `<Timepicker value={time} onChange={setTime} />`

### Calendar
- **Props:** `value`, `onChange`, `range`, `min`/`max`, `selected`
- **Usage:** `<Calendar value={date} onChange={setDate} />`

### Cascader
- **Props:** `data`, `value`, `onChange`, `renderItem`, `level`
- **Usage:** `<Cascader data={tree} value={val} onChange={setVal} />`

### Picker
- **Props:** `data`, `value`, `onChange`, `renderItem`, `title`, `visible`, `onClose`
- **Usage:** `<Picker data={items} value={val} onChange={setVal} visible={show} onClose={close} />`

### Progress
- **Props:** `value` (0-100), `type` (line/circle), `color`, `strokeWidth`
- **Usage:** `<Progress value={60} type="circle" />`

### Tab
- **Props:** `activeIndex`, `onChange`, `tabs` (array of `{title, content}`), `type`
- **Usage:** `<Tab tabs={tabs} activeIndex={idx} onChange={setIdx} />`

### Longlist
- **Props:** `data`, `renderItem`, `onEndReached`, `loading`, `total`
- **Usage:** `<Longlist data={items} renderItem={renderRow} onEndReached={loadMore} />`

### NavigationBar
- **Props:** `title`, `left`, `right`, `onLeftPress`, `onRightPress`, `style`
- **Usage:** `<NavigationBar title="页面标题" left={<Icon name="back" />} onLeftPress={goBack} />`

### Modal
- **Props:** `visible`, `onClose`, `title`, `footer`, `animationType`
- **Usage:** `<Modal visible={show} onClose={() => setShow(false)} title="标题">content</Modal>`

### Dialog
- **Props:** `visible`, `onClose`, `title`, `content`, `buttons`, `type` (alert/confirm)
- **Usage:** `<Dialog visible={show} title="提示" content="确定要删除吗？" buttons={[...]} />`

### Tip
- **Props:** `content`, `type` (success/warning/error/info), `duration`, `onClose`
- **Usage:** `Tip.show('操作成功', 'success')` — imperative API

### SlideModal
- **Props:** `visible`, `onClose`, `title`, `height`, `placement` (bottom)
- **Usage:** `<SlideModal visible={show} onClose={close} title="选择">content</SlideModal>`

### Actionsheet
- **Props:** `visible`, `onClose`, `options`, `onSelect`, `title`, `cancelText`
- **Usage:** `<Actionsheet visible={show} options={items} onSelect={handler} onClose={close} />`

### BottomModal
- **Props:** `visible`, `onClose`, `title`, `height`
- **Usage:** `<BottomModal visible={show} onClose={close}>content</BottomModal>`

### Topview
- **Props:** Container utility — wraps app root for Modal/Dialog/Tip overlay support
- **Usage:** `<Topview><App /></Topview>` — required at root for overlay components

### Dropdown
- **Props:** `visible`, `onClose`, `data`, `renderItem`, `onSelect`, `anchor`
- **Usage:** `<Dropdown visible={show} data={items} onSelect={handler}><Button>Menu</Button></Dropdown>`

### Popover
- **Props:** `visible`, `onClose`, `content`, `position`
- **Usage:** `<Popover visible={show} content="提示"><Button>Press</Button></Popover>`

### TreeView
- **Props:** `data`, `renderItem`, `expanded`, `onExpand`, `onSelect`
- **Usage:** `<TreeView data={tree} renderItem={renderNode} />`

### Ruler
- **Props:** `value`, `onChange`, `min`, `max`, `step`, `unit`
- **Usage:** `<Ruler value={val} onChange={setVal} min={0} max={200} unit="cm" />`

## Platform

**React Native only.** Works on iOS and Android via Meituan MRN framework. All components are native-ready.
