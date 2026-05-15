# React Aria Components -- Patterns

## Styling Approach

Headless by default -- React Aria Components ship with zero visual styles. There are two primary styling methods:

### 1. Data Attributes (CSS-selectable)

Every component exposes standardized data attributes on its DOM element. Use CSS attribute selectors to apply styles:

```css
.react-aria-Button[data-hovered] { background: blue; }
.react-aria-Button[data-pressed] { background: darkblue; }
.react-aria-Button[data-disabled] { opacity: 0.5; }
```

**With Tailwind CSS:**
```jsx
<Button className="bg-blue-500 data-[hovered]:bg-blue-600 data-[pressed]:bg-blue-700
  data-[disabled]:opacity-50 data-[focus-visible]:ring-2">
  Click me
</Button>
```

Common data attributes across all components:
- `[data-hovered]` -- mouse hover
- `[data-pressed]` -- pressed (mouse, touch, Enter/Space)
- `[data-focused]` -- any focus
- `[data-focus-visible]` -- keyboard focus (for focus rings)
- `[data-disabled]` -- disabled
- `[data-selected]` -- selected/checked
- `[data-open]` -- dropdown/dialog open
- `[data-invalid]` -- validation error
- `[data-required]` -- required field
- `[data-entering]` / `[data-exiting]` -- enter/exit animations

### 2. Render Props (callback functions)

`className`, `style`, and `children` all accept render functions:

```jsx
<Button
  className={({isPressed, isHovered}) =>
    clsx('btn', isPressed && 'btn-pressed', isHovered && 'btn-hovered')
  }
  style={({isPressed}) => ({transform: isPressed ? 'scale(0.97)' : 'none'})}
>
  {({isPressed}) => isPressed ? 'Pressed!' : 'Click me'}
</Button>
```

Works with: Tailwind (string concatenation), CSS Modules, styled-components, Panda CSS, Vanilla Extract, Emotion, Linaria.

---

## Common Composition Patterns

### Compound Components (Context-driven)

Many components are compound -- composed of sub-components connected via React Context. The parent component auto-wires accessibility props to children:

**Select pattern:**
```jsx
<Select selectedKey={selected} onSelectionChange={setSelected}>
  <Label>Favorite Animal</Label>
  <Button>
    <SelectValue />
    <span aria-hidden="true">&#x25BC;</span>
  </Button>
  <Popover>
    <ListBox>
      <ListBoxItem>Cat</ListBoxItem>
      <ListBoxItem>Dog</ListBoxItem>
      <ListBoxItem>Kangaroo</ListBoxItem>
    </ListBox>
  </Popover>
</Select>
```

**Dialog/Modal pattern:**
```jsx
<DialogTrigger>
  <Button>Edit Profile</Button>
  <Modal>
    <Dialog>
      {({close}) => (
        <form>
          <Heading slot="title">Edit Profile</Heading>
          <TextField><Label>Name</Label><Input /></TextField>
          <Button slot="close" onPress={close}>Cancel</Button>
          <Button type="submit">Save</Button>
        </form>
      )}
    </Dialog>
  </Modal>
</DialogTrigger>
```

**Menu pattern:**
```jsx
<MenuTrigger>
  <Button>Actions</Button>
  <Popover>
    <Menu onAction={handleAction}>
      <MenuSection title="Actions">
        <MenuItem>Edit</MenuItem>
        <MenuItem>Duplicate</MenuItem>
      </MenuSection>
      <MenuSection title="Danger">
        <MenuItem>Delete</MenuItem>
      </MenuSection>
    </Menu>
  </Popover>
</MenuTrigger>
```

### Collection Components (items or static children)

Components like `ListBox`, `Menu`, `GridList`, `Table`, `Tabs`, `Tree`, `TagGroup`, `Breadcrumbs` support two content modes:

**Static children (explicit JSX):**
```jsx
<ListBox>
  <ListBoxItem>Option 1</ListBoxItem>
  <ListBoxItem>Option 2</ListBoxItem>
</ListBox>
```

**Dynamic items prop (data-driven, with optional render function):**
```jsx
<ListBox
  items={users}
  selectionMode="multiple"
  selectedKeys={selected}
  onSelectionChange={setSelected}
>
  {(user) => <ListBoxItem textValue={user.name}>{user.name}</ListBoxItem>}
</ListBox>
```

### Form Integration

`<Form>` wraps inputs and integrates with native validation or ARIA validation:

```jsx
<Form validationBehavior="native" onSubmit={handleSubmit}>
  <TextField isRequired>
    <Label>Email</Label>
    <Input type="email" />
    <FieldError />
  </TextField>
  <Button type="submit">Submit</Button>
</Form>
```

Key concepts:
- `validationBehavior="native"` -- prevents form submission on invalid fields (uses browser Constraint Validation API)
- `validationBehavior="aria"` -- marks fields as invalid via ARIA attributes but allows submission
- `<FieldError />` renders validation error messages automatically
- `<Text slot="description">` renders help text below the input

### Slots

Sub-components can specify a `slot` prop to receive different context values from the parent:

- `slot="title"` -- heading in Dialog
- `slot="close"` -- close button in Dialog (auto-wires to `state.close()`)
- `slot="description"` -- description text in form fields
- `slot="errorMessage"` -- error message text

---

## Key Differentiators

### useRenderProps

The core pattern enabling headless design. Every component supports render callbacks for `className`, `style`, and `children`:

```typescript
// Internal implementation pattern (simplified):
function useRenderProps(props) {
  const { className, style, children, defaultClassName, defaultChildren, values } = props;
  return useMemo(() => ({
    className: typeof className === 'function' ? className({...values, defaultClassName}) : className ?? defaultClassName,
    style: typeof style === 'function' ? style({...values}) : style,
    children: typeof children === 'function' ? children({...values, defaultChildren}) : children ?? defaultChildren,
  }), [className, style, children, defaultClassName, defaultChildren, values]);
}
```

This allows unconditional access to component state without CSS-in-JS runtime cost when using data attribute selectors.

### onPress (not onClick)

React Aria uses `onPress` as its primary interaction event. This unifies:
- **Mouse**: click
- **Touch**: tap
- **Keyboard**: Enter and Space keys
- **Assistive technology**: screen reader double-tap and other gestures

`onClick` is available for rare cases but `onPress` is preferred. The `PressResponder` component handles the complexity of cross-platform press detection, including:
- Preventing ghost clicks after touch scrolling
- Emulating keyboard activation
- Handling long press on touch devices

### Collection System

Collection components (ListBox, Menu, GridList, Table, Tabs, Tree, TagGroup) share a common collection architecture:
- **`CollectionBuilder`**: Parses JSX children into a normalized collection document
- **React Stately hooks**: `useListState`, `useTabListState`, `useTreeState` -- manage selection, focus, expansion
- **React Aria hooks**: `useListBox`, `useOption`, `useMenuItem`, etc. -- apply ARIA attributes and event handlers
- **CollectionRendererContext**: Pluggable renderers for virtualized or custom collection rendering

### Drag and Drop

Built in via `useDragAndDrop` hooks:
```jsx
import { useDragAndDrop } from 'react-aria-components';

const { dragAndDropHooks } = useDragAndDrop({
  getItems: (keys) => [...keys].map(key => ({ 'text/plain': items[key].name })),
  onReorder: (e) => { /* handle reorder */ },
});

<ListBox dragAndDropHooks={dragAndDropHooks}>
  {/* items become draggable and droppable automatically */}
</ListBox>
```

Also works with GridList, Table, Tree, and TagGroup.

### Pending States

`Button` supports an `isPending` prop that:
- Disables press and hover interactions while keeping the button focusable
- Announces the pending state to screen readers
- Prevents implicit form submission when the button is focused in a form and user presses Enter
- Sets `[data-pending]` for styling

### Animation Hooks

Components expose `isEntering` / `isExiting` render props and `data-entering` / `data-exiting` attributes:
- `Modal` / `ModalOverlay`: entry/exit animation states
- `TabPanel`: entry/exit with `isInert` for inactive panels
- `Toast`: closing animation
- `Popover`: enter/exit transitions

Combine with CSS transitions or animation libraries:
```css
.react-aria-ModalOverlay[data-entering] { animation: fadeIn 200ms; }
.react-aria-ModalOverlay[data-exiting] { animation: fadeOut 150ms; }
```

---

## Compatibility

| Technology | Compatibility | Notes |
|-----------|--------------|-------|
| **Tailwind CSS** | Excellent | Use `data-[hovered]:...` selectors or render function `className` |
| **CSS Modules** | Excellent | Use `data-[hovered]` selectors in `.module.css` |
| **styled-components** | Excellent | Access state via render props |
| **Panda CSS** | Excellent | Data attribute patterns align well |
| **Vanilla Extract** | Excellent | Data attribute CSS patterns |
| **react-bits** | Compatible | React Aria handles behavior + a11y; react-bits provides animation primitives |
| **React 18** | Required | Minimum supported version |
| **React 19** | Supported | Full compatibility with React 19 features |
| **Server Components** | Compatible | Add `"use client"` directive |
| **Next.js** | Supported | Works in App Router and Pages Router |
| **Remix** | Supported | Standard React runtime |
| **TypeScript** | First-class | All props and render props are fully typed |

## Best Practices

1. **Always provide accessible labels**: Use `<Label>` or `aria-label`/`aria-labelledby` on interactive components.
2. **Use `onPress` instead of `onClick`**: Ensures consistent behavior across all input modalities.
3. **Prefer data attributes for static styles**: Better performance than render functions (no JS at runtime for CSS changes).
4. **Use render functions for complex logic**: When styles depend on multiple state values.
5. **Always set `textValue` on items with non-text children**: Required for type-ahead and screen reader support in collection items.
6. **Use `slot` props for compound components**: `slot="description"`, `slot="errorMessage"`, `slot="title"`, `slot="close"` auto-wire accessibility.
7. **Compose with Popover**: Select, ComboBox, Menu, DatePicker, DialogTrigger, ColorPicker all use the Popover pattern.
