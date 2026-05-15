# Radix UI Primitives -- Patterns

## Styling Approach

### Fully Headless
Radix Primitives ships zero styles (no CSS, no className defaults). Every component exposes **data attributes** for CSS targeting:

```css
.MyAccordionTrigger[data-state="open"] { /* open styles */ }
.MyAccordionTrigger[data-state="closed"] { /* closed styles */ }
.MyTab[data-state="active"] { /* active tab styles */ }
.MySelectItem[data-highlighted] { /* highlighted item */ }
.MySelectItem[data-disabled] { /* disabled item */ }
```

### Standard Data Attributes
| Attribute | Values | Used By |
|-----------|--------|---------|
| `data-state` | "open"/"closed", "checked"/"unchecked", "active"/"inactive", "on"/"off", "delayed-open"/"instant-open"/"closed" | All toggle/openable components |
| `data-orientation` | "horizontal"/"vertical" | Accordion, Slider, Tabs, ToggleGroup, Toolbar, ScrollArea |
| `data-disabled` | "" (present when disabled) | All interactive components |
| `data-side` | "top"/"bottom"/"left"/"right" | Popover, Tooltip, HoverCard, DropdownMenu, Select (popper mode) |
| `data-align` | "start"/"center"/"end" | Overlay-positioned content |
| `data-highlighted` | "" (present when highlighted) | Menu items, Select items |
| `data-placeholder` | "" (present when no value) | Select Trigger |
| `data-swipe-direction` | "right"/"left"/"up"/"down" | Toast |
| `data-swipe` | "move"/"cancel"/"end" | Toast |

### CSS Variables for Animations
Many components expose CSS custom properties for animation helpers:

```
--radix-collapsible-content-height  (Collapsible)
--radix-accordion-content-height     (Accordion)
--radix-popover-content-transform-origin  (Popover)
--radix-popper-transform-origin      (Popper base)
--radix-select-content-available-width    (Select)
--radix-tooltip-content-transform-origin  (Tooltip)
--radix-progress-transform           (Progress Indicator)
--radix-scroll-area-corner-width     (ScrollArea)
--radix-scroll-area-thumb-width      (ScrollArea)
--radix-otp-field-height             (OneTimePasswordField)
```

Example animation with CSS variables:
```css
.MyCollapsibleContent {
  overflow: hidden;
}
.MyCollapsibleContent[data-state="open"] {
  animation: slideDown 300ms ease-out;
}
.MyCollapsibleContent[data-state="closed"] {
  animation: slideUp 300ms ease-out;
}
@keyframes slideDown {
  from { height: 0; }
  to { height: var(--radix-collapsible-content-height); }
}
@keyframes slideUp {
  from { height: var(--radix-collapsible-content-height); }
  to { height: 0; }
}
```

### Works with Any CSS Solution
- **Tailwind:** Use `data-[state=open]:` variant (with `tailwindcss-animate` plugin or raw)
- **CSS Modules:** Target `.root[data-state="open"]`
- **styled-components:** Use `&[data-state="open"]`
- **Vanilla CSS:** Standard attribute selectors
- **Panda CSS / Vanilla Extract:** Zero-runtime CSS works perfectly

## Composition Pattern

### Compound Component Model
Every Radix component follows a strict compound pattern:

```tsx
import * as Dialog from '@radix-ui/react-dialog'

<Dialog.Root>
  <Dialog.Trigger asChild>
    <Button>Open</Button>
  </Dialog.Trigger>
  <Dialog.Portal>
    <Dialog.Overlay />
    <Dialog.Content>
      <Dialog.Title />
      <Dialog.Description />
      <Dialog.Close asChild>
        <Button>Close</Button>
      </Dialog.Close>
    </Dialog.Content>
  </Dialog.Portal>
</Dialog.Root>
```

### The `asChild` Pattern (Slot)
Every trigger, item, and many content-bearing parts accept `asChild`:

```tsx
<Dialog.Trigger asChild>
  <Button>Open Dialog</Button>  {/* Button gets all Dialog trigger props */}
</Dialog.Trigger>
```

When `asChild` is true, the component renders only its child, but **merges** all its own props, event handlers, and accessibility attributes onto that child. This allows using your own styled components while keeping full Radix behavior.

### Portal Pattern
Overlay-based components (Dialog, Popover, DropdownMenu, HoverCard, Tooltip, Select, ContextMenu) all use a Portal sub-component:

```tsx
<Popover.Portal>
  <Popover.Content>...</Popover.Content>
</Popover.Portal>
```

Portaling ensures content renders at the document root, avoiding z-index and overflow clipping issues.

### `forceMount` for Animation Control
Content components support `forceMount` -- keeps children in the DOM even when closed, enabling exit animations:

```tsx
<Dialog.Portal forceMount>
  <Dialog.Overlay forceMount />
  <Dialog.Content forceMount>
    {/* Exit animations work because content stays mounted */}
  </Dialog.Content>
</Dialog.Portal>
```

The `Presence` component internally implements this pattern using render props.

### Controlled / Uncontrolled
Every stateful component supports both modes:
- **Uncontrolled:** `defaultValue` / `defaultOpen` / `defaultChecked`
- **Controlled:** `value` / `open` / `checked` + `onValueChange` / `onOpenChange` / `onCheckedChange`

```tsx
// Uncontrolled
<Accordion.Root type="single" defaultValue="item-1">

// Controlled
const [value, setValue] = useState("item-1")
<Accordion.Root type="single" value={value} onValueChange={setValue}>
```

## Common Combinations

### Dialog with Form
```tsx
<Dialog.Root>
  <Dialog.Trigger asChild><Button>Edit</Button></Dialog.Trigger>
  <Dialog.Portal>
    <Dialog.Overlay className="bg-black/50 fixed inset-0" />
    <Dialog.Content className="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white rounded-lg p-6">
      <Dialog.Title>Edit Profile</Dialog.Title>
      <form onSubmit={handleSubmit}>
        <input name="name" />
        <div className="flex gap-2 justify-end">
          <Dialog.Close asChild><Button variant="ghost">Cancel</Button></Dialog.Close>
          <Button type="submit">Save</Button>
        </div>
      </form>
    </Dialog.Content>
  </Dialog.Portal>
</Dialog.Root>
```

### DropdownMenu with Button Trigger
```tsx
<DropdownMenu.Root>
  <DropdownMenu.Trigger asChild>
    <Button>Actions</Button>
  </DropdownMenu.Trigger>
  <DropdownMenu.Portal>
    <DropdownMenu.Content className="bg-white rounded-md shadow-lg min-w-[180px] p-1">
      <DropdownMenu.Item onSelect={() => handleEdit()}>Edit</DropdownMenu.Item>
      <DropdownMenu.Item onSelect={() => handleDuplicate()}>Duplicate</DropdownMenu.Item>
      <DropdownMenu.Separator className="h-px bg-gray-200 my-1" />
      <DropdownMenu.Item onSelect={() => handleDelete()} className="text-red-600">
        Delete
      </DropdownMenu.Item>
    </DropdownMenu.Content>
  </DropdownMenu.Portal>
</DropdownMenu.Root>
```

### Tabs with ScrollArea
```tsx
<Tabs.Root defaultValue="tab1">
  <Tabs.List className="flex border-b">
    <Tabs.Trigger value="tab1" className="data-[state=active]:border-b-2 data-[state=active]:border-blue-500 px-4 py-2">
      Tab 1
    </Tabs.Trigger>
    <Tabs.Trigger value="tab2" className="data-[state=active]:border-b-2 data-[state=active]:border-blue-500 px-4 py-2">
      Tab 2
    </Tabs.Trigger>
  </Tabs.List>
  <ScrollArea.Root className="h-[400px]">
    <ScrollArea.Viewport>
      <Tabs.Content value="tab1">...</Tabs.Content>
      <Tabs.Content value="tab2">...</Tabs.Content>
    </ScrollArea.Viewport>
    <ScrollArea.Scrollbar orientation="vertical">
      <ScrollArea.Thumb />
    </ScrollArea.Scrollbar>
  </ScrollArea.Root>
</Tabs.Root>
```

### Popover + DatePicker (custom or third-party)
```tsx
<Popover.Root>
  <Popover.Trigger asChild>
    <Button>{selectedDate.toLocaleDateString()}</Button>
  </Popover.Trigger>
  <Popover.Portal>
    <Popover.Content className="bg-white rounded-lg shadow-xl p-4" sideOffset={5}>
      <DayPicker mode="single" selected={selectedDate} onSelect={setSelectedDate} />
      <Popover.Arrow className="fill-white" />
    </Popover.Content>
  </Popover.Portal>
</Popover.Root>
```

## Advanced Patterns

### Keyboard Navigation Architecture
Radix uses several internal primitives for keyboard behavior:
- **RovingFocus** (tabs, radio groups, toolbar, toggle group, menubar, navigation menu) -- Arrow key focus roving with tab-stop management
- **Collection** (accordion, select, navigation menu) -- registers items in a flat navigable list
- **Typeahead** (select, dropdown menu, context menu, menubar) -- incremental text search within lists
- **FocusScope** (dialog, popover, select, dropdown) -- focus trapping within modals
- **DismissableLayer** (all overlays) -- ESC to close, outside click to dismiss

### Grace Area for Hover Cards and Tooltips
Tooltip implements a convex hull "grace area" algorithm:
- When the pointer moves from the trigger toward the content, a polygon is computed
- As long as the pointer stays within the polygon, the tooltip stays open
- This prevents accidental dismissal when the pointer briefly leaves the trigger en route to the content

The same pattern is used by HoverCard and sub-menu triggers in DropdownMenu/ContextMenu.

### Form Integration via Bubble Input
Checkbox, Switch, and Select all use a hidden native input (bubble input) to integrate with HTML forms:
- A visually-hidden `<select>` or `<input type="checkbox">` renders alongside the custom UI
- Value changes are dispatched as native events so `<form>` elements receive them
- This enables server-side rendering with default values and standard form submission

### Server-Side Rendering
All components are SSR-compatible:
- Presence checks for `document` before performing DOM operations
- `useLayoutEffect` strategically used for positioning (runs after hydration)
- Components that need `DocumentFragment` (Select) check for its existence and fall back
- `useIsHydrated` hook available for conditional rendering

### RTL (Right-to-Left) Support
Components respect the `dir` prop:
- Arrow key navigation reverses for RTL (ArrowLeft = next in RTL)
- Positioning logic accounts for direction
- The `DirectionProvider` can wrap the entire app:
  ```tsx
  <DirectionProvider dir="rtl">
    <App />
  </DirectionProvider>
  ```

## Compatibility

### Tailwind CSS
**Excellent.** Use Tailwind's arbitrary variant syntax:
```html
<div class="data-[state=open]:animate-in data-[state=closed]:animate-out ..." />
```
Or with `tailwindcss-animate` plugin for built-in animation classes. Configure in tailwind.config:
```js
plugins: [require('tailwindcss-animate')]
```

### react-bits
**Compatible.** Radix handles behavior/accessibility, react-bits provides animation/motion:
- Use Radix components for structure
- Use react-bits CSS/text animations as children/content
- `forceMount` + `Presence` works perfectly with any animation library

### framer-motion
**Excellent.** Use `asChild` to make Radix's parts work with `motion.div`:
```tsx
<Dialog.Content asChild forceMount>
  <motion.div animate={{ scale: 1 }} initial={{ scale: 0.95 }} ... />
</Dialog.Content>
```

### React Version
- **React 18+** required (uses `useId`, `useSyncExternalStore` in some internal packages)
- For Next.js App Router, add `"use client"` directive to files using Radix components

### Styling Libraries
| Library | Compatibility | Notes |
|---------|--------------|-------|
| Tailwind CSS | Full | data-attribute selectors |
| CSS Modules | Full | Standard CSS |
| styled-components | Full | `&[data-state="open"]` |
| Panda CSS | Full | Recipe variants on data attributes |
| Vanilla Extract | Full | Style variants |
| Emotion | Full | Standard CSS-in-JS |
