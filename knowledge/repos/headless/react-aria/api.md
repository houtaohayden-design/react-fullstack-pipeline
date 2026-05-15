# React Aria Components -- API Reference

## Setup

```bash
npm install react-aria-components
```

## Philosophy

- **Each component maps to a real DOM element** -- Button renders `<button>`, Input renders `<input>`, Link renders `<a>`, etc.
- **Built-in accessibility** -- complete WAI-ARIA patterns, keyboard navigation, screen reader announcements, focus management.
- **`useRenderProps`** -- pass render functions to `className`, `style`, or `children` to access interaction state (isHovered, isPressed, isFocused, isSelected, etc.). Two ways to style:
  1. **Data attributes**: `[data-hovered]`, `[data-pressed]`, `[data-focused]`, `[data-focus-visible]`, `[data-selected]`, `[data-disabled]`, `[data-open]`, `[data-invalid]`, `[data-readonly]`, `[data-pending]`, `[data-entering]`, `[data-exiting]`, etc.
  2. **Render functions**: `className` and `children` accept callback functions receiving state objects.
- **`onPress` (not `onClick`)** -- unified press handling across mouse, touch, and keyboard (Enter/Space).
- **Compound components** -- many components are composed of sub-components connected via React Context.
- **Headless by default** -- no visual styles included. Bring your own CSS (Tailwind, CSS Modules, styled-components, Panda CSS, Vanilla Extract).

---

## Components (50+)

### Breadcrumbs (`Breadcrumbs`, `Breadcrumb`)
- **Renders**: `<ol>` + `<li>` for items
- **Props**: `isDisabled`, `onAction`, `items`
- **Render props (Breadcrumb)**: `isCurrent`, `isDisabled`, `isFocused`, `isFocusVisible`, `isHovered`, `isPressed`
- **Usage**: Wrap `Breadcrumb` items. `Breadcrumb` auto-detects current item. Supports collections via `items` prop.

### Button
- **Renders**: `<button>`
- **Props**: `onPress`, `isDisabled`, `type`, `form`, `formAction`, `isPending`, `aria-label`
- **Render props**: `isHovered`, `isPressed`, `isFocused`, `isFocusVisible`, `isDisabled`, `isPending`
- **Data attrs**: `[data-hovered]`, `[data-pressed]`, `[data-focused]`, `[data-focus-visible]`, `[data-disabled]`, `[data-pending]`
- **Usage**:
```jsx
<Button onPress={() => alert('clicked')}
  className={({isPressed}) => isPressed ? 'bg-blue-700' : 'bg-blue-500'}>
  Click me
</Button>
```

### Calendar (`Calendar`, `RangeCalendar`)
- **Renders**: `<div>` with grid structure
- **Sub-components**: `CalendarGrid`, `CalendarGridHeader`, `CalendarGridBody`, `CalendarHeaderCell`, `CalendarCell`
- **Props (Calendar)**: `value`, `onChange`, `defaultValue`, `isDisabled`, `isReadOnly`, `minValue`, `maxValue`, `isDateUnavailable`
- **Render props (Calendar)**: `isDisabled`, `isReadOnly`, `isFocused`, `isFocusVisible`, `isInvalid`, `state`
- **Render props (CalendarCell)**: `isSelected`, `isDisabled`, `isFocused`, `isFocusVisible`, `isHovered`, `isPressed`, `isOutsideMonth`, `isUnavailable`, `isRangeStart`, `isRangeEnd`, `isRangeSelection`
- **Usage**:
```jsx
<Calendar aria-label="Event date">
  <CalendarGrid>
    <CalendarGridHeader>{/* CalendarHeaderCell for days */}</CalendarGridHeader>
    <CalendarGridBody>{/* CalendarCell for each day */}</CalendarGridBody>
  </CalendarGrid>
</Calendar>
```

### Checkbox (`CheckboxGroup`, `Checkbox`, `CheckboxField`)
- **Renders**: `<label>` wrapping hidden `<input type="checkbox">`
- **Props (Checkbox)**: `isSelected`, `defaultSelected`, `onChange`, `isDisabled`, `isReadOnly`, `isIndeterminate`, `isInvalid`, `isRequired`, `inputRef`
- **Render props (Checkbox)**: `isSelected`, `isDisabled`, `isReadOnly`, `isPressed`, `isHovered`, `isFocused`, `isFocusVisible`, `isIndeterminate`, `isInvalid`, `isRequired`, `state`
- **Data attrs**: `[data-selected]`, `[data-disabled]`, `[data-pressed]`, `[data-hovered]`, `[data-focused]`, `[data-focus-visible]`, `[data-indeterminate]`, `[data-invalid]`, `[data-required]`, `[data-readonly]`
- **CheckboxGroup** wraps multiple Checkbox items with shared state.
- **CheckboxField** adds validation, description, and error message slots.

### Color Components (6 components)
- **ColorArea**: 2D color area picker. Render props: `isDisabled`, `isFocused`, `isFocusVisible`
- **ColorField**: Text input for hex/rgb/hsl values. Render props: `isDisabled`, `isFocused`, `isFocusVisible`, `isInvalid`, `isRequired`
- **ColorPicker**: Compound: `ColorPicker` + `DialogTrigger` + `Popover` + color sub-components
- **ColorSlider**: Single-channel color slider. Render props: `isDisabled`, `isFocused`, `isFocusVisible`
- **ColorSwatch**: Single color swatch display. Render props: `isSelected`, `isDisabled`, `isPressed`, `isHovered`, `isFocused`, `isFocusVisible`
- **ColorSwatchPicker**: Grid of color swatches for selection
- **ColorWheel**: Circular color wheel picker. Render props: `isDisabled`, `isFocused`, `isFocusVisible`
- **Usage**:
```jsx
<ColorPicker defaultValue="#ff0000">
  <DialogTrigger>
    <Button><ColorSwatch /></Button>
    <Popover><Dialog><ColorArea /><ColorSlider channel="hue" /><ColorWheel /></Dialog></Popover>
  </DialogTrigger>
</ColorPicker>
```

### ComboBox
- **Renders**: `<div>` wrapper
- **Sub-structure**: `Label` + `Group`(`Input` + `Button`) + `Popover`(`ListBox` + `ListBoxItem`)
- **Props**: `selectedKey`, `defaultSelectedKey`, `onSelectionChange`, `onInputChange`, `isDisabled`, `isInvalid`, `isRequired`, `items`, `placeholder`, `inputValue`
- **Render props**: `isOpen`, `isDisabled`, `isInvalid`, `isRequired`, `isFocused`, `isFocusVisible`
- **Data attrs**: `[data-open]`, `[data-disabled]`, `[data-invalid]`, `[data-required]`, `[data-focused]`, `[data-focus-visible]`

### DateField / DateInput / DatePicker / DateRangePicker
- **DateField**: Full date field (day/month/year segments). Render props: `isDisabled`, `isInvalid`, `isRequired`, `isFocused`, `isFocusVisible`
- **DateInput**: Just the date input area (used inside DateField). Render props: `isDisabled`, `isInvalid`, `isRequired`, `isFocused`, `isFocusVisible`
- **DatePicker**: DateField + trigger button + Popover with Calendar. Render props: `isOpen`, `isDisabled`, `isInvalid`, `isRequired`, `isFocused`, `isFocusVisible`
- **DateRangePicker**: DatePicker with range selection. Render props: `isOpen`, `isDisabled`, `isInvalid`, `isRequired`, `isFocused`, `isFocusVisible`
- **Compound pattern**: `DatePicker` → `Label` + `Group`(`DateInput` + `Button`) + `Popover`(`Dialog` + `Calendar`)

### Dialog (`DialogTrigger`, `Dialog`)
- **Renders**: `<section>` (role="dialog")
- **Props (DialogTrigger)**: `isOpen`, `defaultOpen`, `onOpenChange`
- **Props (Dialog)**: `aria-label`, `aria-labelledby`
- **Render props (Dialog)**: `close` (function to close the dialog)
- **Slots**: supports `<Heading slot="title">` and `<Button slot="close">`
- **Usage**: `DialogTrigger` wraps a trigger element and `Popover`/`Modal` containing `Dialog`

### Disclosure / DisclosureGroup
- **Renders**: `<div>`
- **Props**: `isExpanded`, `defaultExpanded`, `onExpandedChange`, `isDisabled`
- **Render props (Disclosure)**: `isExpanded`, `isFocusVisibleWithin`, `isDisabled`, `state`
- **Data attrs**: `[data-expanded]`, `[data-focus-visible-within]`, `[data-disabled]`
- **DisclosureGroup** (accordion) props: `expandedKeys`, `defaultExpandedKeys`, `onExpandedKeysChange`, `allowsMultipleExpanded`
- **Compound**: `Disclosure` contains a `Button` (trigger) + panel content

### DropZone
- **Renders**: `<div>`
- **Props**: `onDrop`, `getDropOperation`, `isFilled` (when filled with dragged content)
- **Render props**: `isDropTarget`, `isFocused`, `isFocusVisible`

### FileTrigger
- **Renders**: wraps a `Button` and hidden `<input type="file">`
- **Props**: `onSelect`, `accept`, `multiple`, `directory`, `defaultCamera`
- **No render props** -- utility wrapper

### Form
- **Renders**: `<form>`
- **Props**: `validationErrors`, `validationBehavior` ('aria' | 'native'), `onSubmit`
- **Native validation integration**: Sets `noValidate` on native form when using aria validation
- **Usage**:
```jsx
<Form validationBehavior="native">
  <TextField isRequired><Label>Name</Label><Input /></TextField>
  <Button type="submit">Submit</Button>
</Form>
```

### GridList (`GridList`, `GridListItem`)
- **Renders**: `<div>` with grid layout
- **Props**: `selectionMode`, `selectedKeys`, `onSelectionChange`, `onAction`, `items`, `disabledKeys`, `layout`, `orientation`
- **Render props (GridList)**: `isEmpty`, `isFocused`, `isFocusVisible`, `isDropTarget`, `layout`, `orientation`, `state`
- **Render props (GridListItem)**: `isSelected`, `isDisabled`, `isHovered`, `isPressed`, `isFocused`, `isFocusVisible`, `isDragging`, `isDropTarget`, `selectionMode`, `selectionBehavior`
- **Data attrs**: `[data-selected]`, `[data-disabled]`, `[data-hovered]`, `[data-focused]`, `[data-focus-visible]`, `[data-pressed]`, `[data-dragging]`, `[data-drop-target]`

### Group
- **Renders**: `<div>` with `role="group"`
- **Props**: `isDisabled` (propagates disabled to children)
- **Render props**: `isDisabled`, `isFocused`, `isFocusVisible`, `isInvalid`, `isRequired`
- **Data attrs**: `[data-disabled]`, `[data-focused]`, `[data-focus-visible]`, `[data-invalid]`, `[data-required]`

### Input
- **Renders**: `<input>`
- **Props**: `type`, `value`, `defaultValue`, `onChange`, `isDisabled`, `isReadOnly`, `isInvalid`, `isRequired`, `placeholder`
- **Render props**: `isDisabled`, `isFocused`, `isFocusVisible`, `isReadOnly`, `isInvalid`, `isRequired`
- **Data attrs**: `[data-disabled]`, `[data-focused]`, `[data-focus-visible]`, `[data-readonly]`, `[data-invalid]`, `[data-required]`

### Label
- **Renders**: `<label>`
- **Props**: `aria-label`, `aria-labelledby`
- **Render props**: `isDisabled`, `isFocused`, `isFocusVisible`, `isInvalid`, `isRequired`
- **Data attrs**: `[data-disabled]`, `[data-focused]`, `[data-focus-visible]`, `[data-invalid]`, `[data-required]`

### Link
- **Renders**: `<a>` (when `href` provided and not disabled) or `<span>`
- **Props**: `href`, `target`, `rel`, `isDisabled`, `onPress`, `aria-current`
- **Render props**: `isCurrent`, `isHovered`, `isPressed`, `isFocused`, `isFocusVisible`, `isDisabled`
- **Data attrs**: `[data-current]`, `[data-hovered]`, `[data-pressed]`, `[data-focused]`, `[data-focus-visible]`, `[data-disabled]`

### ListBox (`ListBox`, `ListBoxItem`, `ListBoxSection`, `ListBoxLoadMoreItem`)
- **Renders**: `<div>` (role="listbox")
- **Props**: `selectionMode`, `selectedKeys`, `defaultSelectedKeys`, `onSelectionChange`, `items`, `disabledKeys`, `layout`, `orientation`, `dragAndDropHooks`, `renderEmptyState`
- **Render props (ListBox)**: `isEmpty`, `isFocused`, `isFocusVisible`, `isDropTarget`, `layout`, `orientation`, `state`
- **Render props (ListBoxItem)**: `isSelected`, `isDisabled`, `isHovered`, `isPressed`, `isFocused`, `isFocusVisible`, `isDragging`, `isDropTarget`, `selectionMode`, `selectionBehavior`
- **Data attrs**: `[data-empty]`, `[data-focused]`, `[data-focus-visible]`, `[data-drop-target]`
- **ListBoxSection** renders sections with headers inside ListBox.
- **ListBoxLoadMoreItem** enables infinite scroll loading.

### Menu (`MenuTrigger`, `SubmenuTrigger`, `Menu`, `MenuItem`, `MenuSection`)
- **Renders**: `<div>` (role="menu")
- **Props (MenuTrigger)**: `isOpen`, `defaultOpen`, `onOpenChange`
- **Props (Menu)**: `selectionMode`, `selectedKeys`, `onSelectionChange`, `onAction`, `items`, `disabledKeys`
- **Render props (MenuItem)**: `isSelected`, `isDisabled`, `isHovered`, `isPressed`, `isFocused`, `isFocusVisible`, `selectionMode`
- **Compound**: `MenuTrigger` wraps a `Button` + `Popover`(`Menu` + `MenuItem`/`MenuSection`)

### Meter
- **Renders**: `<div>` with `role="meter"`
- **Props**: `value`, `minValue`, `maxValue`, `label`, `formatOptions`
- **Render props**: `percentage`, `valueText`

### Modal (`ModalOverlay`, `Modal`)
- **Renders**: Portal overlay + `<div>` (role="dialog")
- **Props (Modal)**: `isOpen`, `defaultOpen`, `onOpenChange`, `isDismissable`, `isKeyboardDismissDisabled`, `isEntering`, `isExiting`
- **Render props (ModalOverlay)**: `isEntering`, `isExiting`, `state`
- **Render props (Modal)**: `isEntering`, `isExiting`, `state`
- **Data attrs**: `[data-entering]`, `[data-exiting]`
- **Compound**: `Modal` can be used standalone (includes `ModalOverlay`) or inside `ModalOverlay`

### NumberField
- **Renders**: `<div>` wrapping `<input type="number">`
- **Props**: `value`, `defaultValue`, `onChange`, `minValue`, `maxValue`, `step`, `formatOptions`, `isDisabled`, `isReadOnly`, `isInvalid`, `isRequired`
- **Render props**: `isDisabled`, `isFocused`, `isFocusVisible`, `isReadOnly`, `isInvalid`, `isRequired`
- **Compound**: `NumberField` → `Label` + `Group`(`Input` + increment/decrement `Button`s)

### OverlayArrow
- **Renders**: `<svg>` arrow connecting popover to trigger
- **Props**: `width`, `height`
- **No render props** -- visual decorator

### Popover
- **Renders**: Portal `<div>` (role="dialog" or "listbox")
- **Props**: `placement`, `offset`, `crossOffset`, `containerPadding`, `shouldFlip`, `isOpen`, `isEntering`, `isExiting`
- **Render props**: `isEntering`, `isExiting`, `placement`
- **Data attrs**: `[data-placement]`, `[data-entering]`, `[data-exiting]`

### ProgressBar
- **Renders**: `<div>` with `role="progressbar"`
- **Props**: `value`, `minValue`, `maxValue`, `isIndeterminate`, `label`, `formatOptions`
- **Render props**: `percentage`, `valueText`
- **Data attrs**: `[data-indeterminate]`

### RadioGroup (`RadioGroup`, `Radio`)
- **Renders**: `<div>` wrapper + `<label>` per radio (wrapping hidden `<input type="radio">`)
- **Props (RadioGroup)**: `value`, `defaultValue`, `onChange`, `isDisabled`, `isReadOnly`, `isInvalid`, `isRequired`, `orientation`
- **Render props (RadioGroup)**: `isDisabled`, `isReadOnly`, `isInvalid`, `isRequired`, `orientation`
- **Render props (Radio)**: `isSelected`, `isDisabled`, `isReadOnly`, `isPressed`, `isHovered`, `isFocused`, `isFocusVisible`, `isInvalid`, `isRequired`

### SearchField
- **Renders**: `<div>` wrapping `<input type="search">`
- **Props**: `value`, `defaultValue`, `onChange`, `onSubmit`, `onClear`, `isDisabled`, `isReadOnly`, `isInvalid`, `isRequired`, `placeholder`
- **Render props**: `isDisabled`, `isFocused`, `isFocusVisible`, `isReadOnly`, `isInvalid`, `isRequired`
- **Compound**: `SearchField` → `Label` + `Group`(`Input` + clear `Button`)

### Select (`Select`, `SelectValue`)
- **Renders**: `<div>` wrapper
- **Sub-structure**: `Label` + `Button`(`SelectValue`) + `Popover`(`ListBox` + `ListBoxItem`)
- **Props**: `selectedKey`, `defaultSelectedKey`, `onSelectionChange`, `isDisabled`, `isInvalid`, `isRequired`, `placeholder`, `items`, `selectionMode`
- **Render props (Select)**: `isFocused`, `isFocusVisible`, `isDisabled`, `isOpen`, `isInvalid`, `isRequired`
- **Render props (SelectValue)**: `isPlaceholder`, `selectedItem`, `selectedItems`, `selectedText`, `state`
- **Data attrs**: `[data-focused]`, `[data-focus-visible]`, `[data-open]`, `[data-disabled]`, `[data-invalid]`, `[data-required]`

### Separator
- **Renders**: `<hr>` or `<div>`
- **Props**: `orientation` ('horizontal' | 'vertical'), `elementType`

### Slider (`Slider`, `SliderThumb`)
- **Renders**: `<div>` (role="group" / "slider") + `<div>` (role="slider" thumb)
- **Props**: `value`, `defaultValue`, `onChange`, `minValue`, `maxValue`, `step`, `isDisabled`, `orientation`, `onChangeEnd`
- **Render props (Slider)**: `isDisabled`, `orientation`, `isFocused`, `isFocusVisible`
- **Render props (SliderThumb)**: `isDisabled`, `isHovered`, `isPressed`, `isFocused`, `isFocusVisible`, `isDragging`

### Switch (`Switch`, `SwitchField`, `SwitchButton`)
- **Renders**: `<label>` wrapping hidden `<input type="checkbox">` (switch role)
- **Props**: `isSelected`, `defaultSelected`, `onChange`, `isDisabled`, `isReadOnly`, `isInvalid`, `isRequired`, `inputRef`
- **Render props (Switch/SwitchButton)**: `isSelected`, `isHovered`, `isPressed`, `isFocused`, `isFocusVisible`, `isDisabled`, `isReadOnly`, `isInvalid`, `isRequired`, `state`
- **Data attrs**: `[data-selected]`, `[data-hovered]`, `[data-pressed]`, `[data-focused]`, `[data-focus-visible]`, `[data-disabled]`, `[data-readonly]`, `[data-invalid]`, `[data-required]`
- **SwitchField** adds validation, description, and error message slots.

### Table (`Table`, `TableHeader`, `TableBody`, `Column`, `Row`, `Cell`, `TableColumnResizer`)
- **Renders**: `<div>` with table ARIA roles
- **Props (Table)**: `selectionMode`, `selectedKeys`, `onSelectionChange`, `sortDescriptor`, `onSortChange`, `onRowAction`, `items`, `disabledKeys`, `dragAndDropHooks`
- **Render props (Row)**: `isSelected`, `isDisabled`, `isHovered`, `isPressed`, `isFocused`, `isFocusVisible`, `isDragging`, `isDropTarget`, `selectionMode`
- **Render props (Cell)**: `isSelected`, `isDisabled`, `isFocused`, `isFocusVisible`, `isHovered`
- **Column** supports `allowsSorting`, `isRowHeader`
- **TableColumnResizer** enables resizable columns via drag handle

### Tabs (`Tabs`, `TabList`, `Tab`, `TabPanels`, `TabPanel`)
- **Renders**: `<div>` structure
- **Props (Tabs)**: `selectedKey`, `defaultSelectedKey`, `onSelectionChange`, `isDisabled`, `orientation`, `items`, `disabledKeys`
- **Render props (Tabs)**: `orientation`
- **Render props (TabList)**: `orientation`, `state`
- **Render props (Tab)**: `isHovered`, `isPressed`, `isSelected`, `isFocused`, `isFocusVisible`, `isDisabled`
- **Render props (TabPanel)**: `isFocused`, `isFocusVisible`, `isInert`, `isEntering`, `isExiting`, `state`
- **Data attrs**: `[data-selected]`, `[data-hovered]`, `[data-pressed]`, `[data-focused]`, `[data-focus-visible]`, `[data-disabled]`, `[data-orientation]`, `[data-entering]`, `[data-exiting]`, `[data-inert]`

### TagGroup (`TagGroup`, `TagList`, `Tag`)
- **Renders**: `<div>` wrapper
- **Props (TagGroup)**: `selectionMode`, `selectedKeys`, `onSelectionChange`, `onRemove`, `isDisabled`, `items`, `disabledKeys`, `onAction`
- **Render props (Tag)**: `isSelected`, `isDisabled`, `isHovered`, `isPressed`, `isFocused`, `isFocusVisible`, `allowsRemoving`, `selectionMode`
- **Compound**: `TagGroup` → `Label` + `TagList`(`Tag` items)

### TextArea
- **Renders**: `<textarea>`
- **Props**: `value`, `defaultValue`, `onChange`, `isDisabled`, `isReadOnly`, `isInvalid`, `isRequired`, `placeholder`, `rows`, `cols`
- **Render props**: `isDisabled`, `isFocused`, `isFocusVisible`, `isReadOnly`, `isInvalid`, `isRequired`
- **Data attrs**: `[data-disabled]`, `[data-focused]`, `[data-focus-visible]`, `[data-readonly]`, `[data-invalid]`, `[data-required]`

### TextField
- **Renders**: `<div>` wrapper
- **Sub-structure**: `Label` + `Input` or `TextArea`
- **Props**: `value`, `defaultValue`, `onChange`, `isDisabled`, `isReadOnly`, `isInvalid`, `isRequired`
- **Render props**: `isDisabled`, `isFocused`, `isFocusVisible`, `isReadOnly`, `isInvalid`, `isRequired`
- **Compound**: `TextField` → `Label` + `Input` (or `TextArea`) + `FieldError` + `Text slot="description"`

### Toast (`ToastRegion`, `Toast`, `ToastContent`, `ToastTitle`)
- **Renders**: `<div>` region with `aria-live="polite"`
- **Props (ToastRegion)**: `placement`, `maxVisibleToasts`
- **Props (Toast)**: `children`, `onClose`, `tone` (info/success/warning/error)
- **Render props (Toast)**: `isEntering`, `isExiting`, `state` (with `close` method)
- **Data attrs**: `[data-tone]`, `[data-entering]`, `[data-exiting]`, `[data-closing]`

### ToggleButton
- **Renders**: `<button>` (aria-pressed)
- **Props**: `isSelected`, `defaultSelected`, `onChange`, `isDisabled`, `onPress`
- **Render props**: `isSelected`, `isHovered`, `isPressed`, `isFocused`, `isFocusVisible`, `isDisabled`
- **Data attrs**: `[data-selected]`, `[data-hovered]`, `[data-pressed]`, `[data-focused]`, `[data-focus-visible]`, `[data-disabled]`

### ToggleButtonGroup
- **Renders**: `<div>` (role="group")
- **Props**: `selectionMode` ('single' | 'multiple' | 'none'), `selectedKeys`, `onSelectionChange`, `isDisabled`, `orientation`
- **Render props**: `isDisabled`, `orientation`
- **Usage**: Wrap `ToggleButton` items for mutually exclusive or multiple selection.

### Toolbar
- **Renders**: `<div>` (role="toolbar")
- **Props**: `aria-label`, `isDisabled`, `orientation`
- **No render props** -- layout container for buttons/inputs

### Tooltip (`TooltipTrigger`, `Tooltip`)
- **Renders**: `<span>` (portal overlay)
- **Props (TooltipTrigger)**: `delay`, `closeDelay`, `trigger`, `isDisabled`
- **Props (Tooltip)**: `placement`, `offset`, `crossOffset`
- **Render props (Tooltip)**: `isEntering`, `isExiting`, `state`
- **Data attrs**: `[data-placement]`, `[data-entering]`, `[data-exiting]`

### Tree (`Tree`, `TreeItem`)
- **Renders**: `<div>` (role="treegrid")
- **Props (Tree)**: `selectionMode`, `selectedKeys`, `onSelectionChange`, `expandedKeys`, `onExpandedKeysChange`, `items`, `disabledKeys`, `dragAndDropHooks`
- **Render props (TreeItem)**: `isExpanded`, `isSelected`, `isDisabled`, `isHovered`, `isPressed`, `isFocused`, `isFocusVisible`, `isDragging`, `isDropTarget`, `selectionMode`
- **Data attrs**: `[data-expanded]`, `[data-selected]`, `[data-hovered]`, `[data-focused]`
- Supports drag-and-drop for tree reordering via `useDragAndDrop` hooks.

### Virtualizer (`Virtualizer`, `VirtualizerItem`)
- **Renders**: virtualized scroll container
- **Props**: `layout` (from `useListData`), `layoutOptions`, `sizeProvider`, `isLoading`, `nonVisibleContentBefore`, `scrollDirection`
- **Render props (VirtualizerItem)**: `isVisible`, `isAbove`, `isBelow`
- **Data attrs**: `[data-visible]`, `[data-above]`, `[data-below]`

### Text / Heading / Header
- **Text**: Renders `<span>`. Slots: `description`, `errorMessage`. No render props.
- **Heading**: Renders heading tag (`h1`-`h6`). Slots: `title`. No render props.
- **Header**: Renders `<header>`. Used as heading container for ListBoxSection.
- Utility components for semantic text within compound components.

### FieldError / SelectionIndicator
- **FieldError**: Renders validation error messages. Renders `<span>`.
- **SelectionIndicator**: Visual indicator for selected items. Used inside Tabs, ListBoxItem, etc.

### Keyboard
- **Renders**: nothing (passes keyboard handlers to child)
- **Props**: `onKeyDown`, `onKeyUp`
- Utility wrapper for adding keyboard event handling.

---

## Common Data Attributes (Styling Hook)

All components expose these standard data attributes on their rendered DOM element:

| Attribute | Meaning |
|-----------|---------|
| `data-hovered` | Mouse hovering |
| `data-pressed` | Pressed state (mouse/touch/keyboard) |
| `data-focused` | Focused (any method) |
| `data-focus-visible` | Keyboard focused |
| `data-disabled` | Disabled |
| `data-selected` | Selected/checked state |
| `data-open` | Dropdown/dialog open |
| `data-invalid` | Validation failed |
| `data-required` | Required field |
| `data-readonly` | Read-only |
| `data-pending` | Pending/loading state |
| `data-entering` | Entry animation in progress |
| `data-exiting` | Exit animation in progress |
| `data-placement` | Popover/tooltip placement |
| `data-orientation` | Horizontal/vertical |
| `data-drop-target` | Drag-and-drop target active |
| `data-dragging` | Item being dragged |
| `data-current` | Current/active link |
| `data-indeterminate` | Indeterminate state |
| `data-empty` | No items in collection |
| `data-inert` | Inert (non-interactive) |
