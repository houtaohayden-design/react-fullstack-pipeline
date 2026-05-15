# Beeshell — Patterns

## Platform

**React Native only.** 美团内部 MRN (Meituan React Native) 框架，基于 RN 0.53.3。
包含纯 JS 组件和复合组件（含 Native 代码），涉及 FE、iOS、Android 三端。

## Styling Approach

**RN StyleSheet + 自定义主题系统。** 组件使用 React Native 标准 `StyleSheet.create()`，支持通过 `theme` prop 或全局配置覆盖样式。

## Key Patterns

### Controlled Components
All inputs use `value` + `onChange` (fully controlled pattern, React Native style):
```tsx
<Input value={val} onChangeText={setVal} />
<Switch checked={val} onChange={setVal} />
```

### Overlay Pattern (Topview)
Overlay components (Modal, Dialog, Tip, SlideModal, Actionsheet, BottomModal) require `<Topview>` as the app root wrapper:
```tsx
import { Topview } from 'beeshell'

export default function App() {
  return (
    <Topview>
      <YourApp />
    </Topview>
  )
}
```

### Imperative API
Some components support imperative calls:
```tsx
Tip.show('操作成功', 'success')
```

### Form Pattern
```tsx
<Form data={form} onChange={setForm} rules={rules}>
  <Form.Item name="name" label="姓名" required>
    <Input placeholder="请输入" />
  </Form.Item>
  <Form.Item name="city" label="城市">
    <Picker data={cities} value={form.city} onChange={(v) => setForm({...form, city: v})} />
  </Form.Item>
</Form>
```

### Modal Family
beeshell has the richest modal collection among RN component libraries:
- **Modal** — standard centered modal
- **Dialog** — alert/confirm dialog with button array
- **Tip** — lightweight toast/notification
- **SlideModal** — slides up from bottom
- **Actionsheet** — bottom action sheet (iOS style)
- **BottomModal** — bottom sheet with custom content

Choose based on interaction pattern:
```
Simple alert → Dialog
Bottom options → Actionsheet
Bottom form/content → BottomModal
Complex picker → SlideModal + Picker inside
```

## Compatibility

### With react-bits
- **Not compatible.** react-bits is React Web only, beeshell is React Native only.
- Don't try to use react-bits components in React Native projects with beeshell.

### With animal-island-ui
- **Not directly compatible.** animal-island-ui is React Web, beeshell is React Native.
- Conceptually: both are opinionated component libraries. beeshell is enterprise mobile, animal-island-ui is casual web.

### With Shineout
- **Different platforms.** Shineout = React Web, beeshell = React Native.
- Both are enterprise-grade Chinese component libraries. Shineout for web admin, beeshell for mobile apps.
- If building both web + mobile for the same product, Shineout (web) + beeshell (mobile) is a coherent pairing.

## Mobile-Specific Components

Beeshell excels at mobile-native interactions not found in web libraries:
- **Scrollpicker** — iOS-style picker wheel
- **Longlist** — infinite scroll list with pull-to-refresh
- **NavigationBar** — native-feel top navigation
- **Actionsheet** — native action sheet
- **Calendar** — calendar date selector
- **Ruler** — ruler-style value selector
