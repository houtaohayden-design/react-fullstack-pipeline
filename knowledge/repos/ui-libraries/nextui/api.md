# NextUI (HeroUI v3) — API Reference

> Modern React UI library built on Tailwind CSS v4 + React Aria Components. Compound component pattern inspired by Radix UI.

## Setup

```bash
npm install @nextui-org/react framer-motion
# Tailwind CSS v4 is required for HeroUI v3
```

Import the provider and CSS:
```tsx
import { NextUIProvider } from '@nextui-org/react';

function App() {
  return <NextUIProvider><YourApp /></NextUIProvider>;
}
```

---

## Components (85+ exports, ~50 main components)

### Layout
| Component | Key Props |
|-----------|-----------|
| **Separator** | `orientation` (horizontal/vertical), `decorative` |
| **Surface** | `elevation`, `rounded` — styled surface container |
| **Header** | Header section component |

### Inputs
| Component | Key Props |
|-----------|-----------|
| **TextField** | Compound: `TextField.Root`, `TextField.Input`, `TextField.Label`, `TextField.Description`, `TextField.ErrorMessage` — `value`, `onChange`, `variant` (outline), `size` (sm/md/lg), `isDisabled`, `isInvalid`, `placeholder` |
| **Textarea** | Compound: `Textarea.Root`, `Textarea.Textarea`, `Textarea.Label` — `value`, `onChange`, `isDisabled` |
| **NumberField** | Compound: `NumberField.Root`, `NumberField.Input`, `NumberField.Label`, `NumberField.StepperButton` — `value`, `onChange`, `minValue`, `maxValue`, `step`, `formatOptions` |
| **SearchField** | Compound: `SearchField.Root`, `SearchField.Input`, `SearchField.Label` — `value`, `onChange`, `isDisabled` |
| **Select** | Compound: `Select.Root`, `Select.Trigger`, `Select.Value`, `Select.Icon`, `Select.Label`, `Select.Description`, `Select.ErrorMessage`, `Select.Popover`, `Select.ListBox`, `Select.Item`, `Select.Section` — `data`/children, `defaultValue`, `placeholder` |
| **Autocomplete** | Combines input with dropdown selection |
| **ComboBox** | Compound: `ComboBox.Root`, `ComboBox.Input`, `ComboBox.Label`, `ComboBox.Popover`, `ComboBox.ListBox`, `ComboBox.Item` |
| **Checkbox** | Compound: `Checkbox.Root`, `Checkbox.Indicator` — `value`, `isSelected`, `isIndeterminate`, `isDisabled`, `lineThrough` (on label). Uses external `Label` and `Description` components. |
| **CheckboxGroup** | Compound: `CheckboxGroup.Root`, `CheckboxGroup.Label`, `CheckboxGroup.Description`, `CheckboxGroup.ErrorMessage`, `CheckboxGroup.Item` |
| **Radio** | Compound: `Radio.Root`, `Radio.Indicator` — `value`, `isSelected`, `isDisabled`. Uses external `Label`/`Description`. |
| **RadioGroup** | Compound: `RadioGroup.Root`, `RadioGroup.Label`, `RadioGroup.Description`, `RadioGroup.ErrorMessage`, `RadioGroup.Item` (using Radio.Root + Indicator) |
| **Switch** | Compound: `Switch.Root`, `Switch.Indicator` — `isSelected`, `isDisabled`. Uses external `Label`. |
| **SwitchGroup** | Compound: `SwitchGroup.Root`, `SwitchGroup.Label`, `SwitchGroup.Description`, `SwitchGroup.ErrorMessage`, `SwitchGroup.Item` |
| **Slider** | Compound: `Slider.Root`, `Slider.Track`, `Slider.Thumb`, `Slider.Output` — `value`, `onChange`, `minValue`, `maxValue`, `step`, `isDisabled` |
| **InputOTP** | One-time password input with slots |
| **ColorPicker** | Compound: `ColorPicker.Root`, `ColorPicker.Trigger`, `ColorPicker.Popover`, `ColorPicker.Swatch` |
| **ColorArea** | 2D color gradient picker |
| **ColorField** | Text-based color input |
| **ColorSlider** | Single-axis color slider |
| **ColorSwatch** | Individual color swatch |
| **ColorSwatchPicker** | Grid of color swatches |
| **ColorInputGroup** | Composite color input |

### Buttons & Actions
| Component | Key Props |
|-----------|-----------|
| **Button** | `variant` (solid/bordered/light/flat/faded/shadow/ghost), `size` (sm/md/lg), `fullWidth`, `isDisabled`, `isIconOnly`, `slot` |
| **ButtonGroup** | Compound: `ButtonGroup.Root` — groups buttons with shared variant/size |
| **CloseButton** | Small circular close button |
| **ToggleButton** | Compound: `ToggleButton.Root` — toggle-style button, `isSelected`, `isDisabled` |
| **ToggleButtonGroup** | Compound: `ToggleButtonGroup.Root`, `ToggleButtonGroup.Item` — `selectionMode` (single/multiple), `value`, `onValueChange` |
| **Chip** | Small selectable badge — `isSelected`, `isDisabled` |
| **Toolbar** | Toolbar container for grouped actions |

### Navigation
| Component | Key Props |
|-----------|-----------|
| **Tabs** | Compound: `Tabs.Root`, `Tabs.List`, `Tabs.Tab`, `Tabs.Panel` — `value`, `onValueChange`, `isDisabled` (per tab), `variant` (solid/underlined), `size`, `fullWidth` |
| **Breadcrumbs** | Compound: `Breadcrumbs.Root`, `Breadcrumbs.Item` — `separator`, `isDisabled` |
| **Link** | Styled anchor tag — `isExternal`, `showAnchorIcon`, `isDisabled` |
| **Pagination** | `total`, `value`, `onChange`, `boundaries`, `siblings`, `isDisabled` |
| **ScrollShadow** | Overflow container with fade edges — `orientation`, `size`, `visibility` (top/bottom/both) |

### Overlays
| Component | Key Props |
|-----------|-----------|
| **Modal** | Compound: `Modal.Root`, `Modal.Overlay`, `Modal.Content`, `Modal.Header`, `Modal.Title`, `Modal.Description`, `Modal.Body`, `Modal.Footer`, `Modal.CloseButton` — `isOpen`, `onOpenChange`, `isDismissable`, `size` |
| **Drawer** | Compound: `Drawer.Root`, `Drawer.Overlay`, `Drawer.Content`, `Drawer.Header`, `Drawer.Title`, `Drawer.Description`, `Drawer.Body`, `Drawer.Footer`, `Drawer.CloseButton` — `isOpen`, `onOpenChange`, `placement` (top/right/bottom/left), `size` |
| **Popover** | Compound: `Popover.Root`, `Popover.Trigger`, `Popover.Content`, `Popover.Header`, `Popover.Title`, `Popover.Description`, `Popover.Body`, `Popover.Footer`, `Popover.CloseButton` — `isOpen`, `onOpenChange`, `placement`, `offset`, `crossOffset`, `showArrow` |
| **Tooltip** | Compound: `Tooltip.Root`, `Tooltip.Trigger`, `Tooltip.Content` — `placement`, `delay`, `closeDelay`, `showArrow` |
| **Dropdown** | Compound: `Dropdown.Root`, `Dropdown.Trigger`, `Dropdown.Content`, `Dropdown.Header`, `Dropdown.Body` — `isOpen`, `onOpenChange`, `placement` |
| **Menu** | Compound: `Menu.Root`, `Menu.Trigger`, `Menu.Content`, `Menu.Header`, `Menu.Item`, `Menu.Section`, `Menu.Separator`, `Menu.Label`, `Menu.Description`, `Menu.Shortcut` — `isOpen`, `onOpenChange`, `placement`, `closeOnSelect` |
| **AlertDialog** | Compound: `AlertDialog.Root`, `AlertDialog.Overlay`, `AlertDialog.Content`, `AlertDialog.Header`, `AlertDialog.Title`, `AlertDialog.Description`, `AlertDialog.Body`, `AlertDialog.Footer`, `AlertDialog.Action`, `AlertDialog.Cancel` — confirmation modal |

### Data Display
| Component | Key Props |
|-----------|-----------|
| **Table** | Compound: `Table.Root`, `Table.Header`, `Table.Column`, `Table.Body`, `Table.Row`, `Table.Cell` — `selectionMode` (single/multiple), `selectedKeys`, `selectionBehavior` |
| **Card** | `shadow`, `fullWidth`, `isPressable`, `isHoverable`, `isBlurred` |
| **Avatar** | `src`, `alt`, `name`, `size` (sm/md/lg), `radius`, `isBordered`, `isDisabled`, `fallback`, `showFallback`, `icon`, `isFocusable` |
| **Badge** | `variant` (solid/flat/faded/shadow), `size` (sm/md/lg), `disableAnimation` |
| **Tag** | Compound: `Tag.Root`, `Tag.Label`, `Tag.CloseButton` — `size`, `isDisabled` |
| **TagGroup** | Compound: `TagGroup.Root`, `TagGroup.Label`, `TagGroup.Description`, `TagGroup.ErrorMessage`, `TagGroup.Tag`, `TagGroup.AddTag` |
| **Spinner** | `size` (sm/md/lg), `label`, `variant` |
| **Skeleton** | `className` for custom sizing (width, height via Tailwind) |
| **ProgressBar** | `value`, `minValue`, `maxValue`, `label`, `showValueLabel`, `formatOptions`, `isIndeterminate` |
| **ProgressCircle** | `value`, `minValue`, `maxValue`, `size`, `strokeWidth`, `isIndeterminate`, `label` |
| **Meter** | Similar to ProgressBar but for measurement display |

### Feedback
| Component | Key Props |
|-----------|-----------|
| **Alert** | Compound: `Alert.Root`, `Alert.Icon`, `Alert.Title`, `Alert.Description`, `Alert.Action`, `Alert.Close` — `variant` (info/success/warning/danger/discovery/neutral), `isClosable`, `disableIcon` |
| **Disclosure** | Compound: `Disclosure.Root`, `Disclosure.Trigger`, `Disclosure.Panel` — collapsible content section |
| **DisclosureGroup** | Compound: `DisclosureGroup.Root`, `DisclosureGroup.Item` — accordion-style group (multiple or single expansion) |
| **Toast** | Programmatic toast system — `addToast()`, `updateToast()`, `removeToast()` |
| **EmptyState** | Empty state placeholder component |

### Date & Time
| Component | Key Props |
|-----------|-----------|
| **DatePicker** | Compound: `DatePicker.Root`, `DatePicker.Input`, `DatePicker.Label`, `DatePicker.Description`, `DatePicker.ErrorMessage`, `DatePicker.Popover`, `DatePicker.Calendar` |
| **DateRangePicker** | Compound date range selection |
| **DateField** | Date input field |
| **DateInputGroup** | Composite date input |
| **TimeField** | Time input field |
| **Calendar** | Standalone calendar grid |
| **CalendarYearPicker** | Year selection view |
| **RangeCalendar** | Calendar grid for range selection |

### Form Utility Components
| Component | Key Props |
|-----------|-----------|
| **Form** | `onSubmit`, HTML form wrapper |
| **Fieldset** | `Fieldset.Root`, `Fieldset.Legend`, `Fieldset.FieldGroup`, `Fieldset.Field`, `Fieldset.CheckboxField` — form grouping |
| **Label** | Reusable label — `htmlFor`, `size` |
| **Description** | Form field description text |
| **FieldError / ErrorMessage** | Error message display |
| **Input** | Compound: `Input.Root`, `Input.Input` — base input |
| **InputGroup** | Compound input group |
| **Kbd** | Keyboard key display |
| **Typography** | `Typography.Heading`, `Typography.Body`, `Typography.Prose` — styled text |
| **ListBox** | Compound: `ListBox.Root`, `ListBox.Item`, `ListBox.Section` |

### Accordion
Compound: `Accordion.Root`, `Accordion.Item`, `Accordion.Heading`, `Accordion.Trigger`, `Accordion.Panel`, `Accordion.Indicator`, `Accordion.Body`

**Key Props**: `value`/`defaultValue`, `onValueChange`, `selectionMode` (single/multiple), `isDisabled` (per item)

---

## Variant System

HeroUI uses `tailwind-variants` for a comprehensive variant system:

**Variant styles** (common across many components — Button, Badge, Alert, etc.):
- `solid` — filled with color
- `bordered` — outline with color border
- `light` — subtle background tint
- `flat` — solid without shadows
- `faded` — muted appearance
- `shadow` — elevated with shadow
- `ghost` — transparent background, hover effect only

**Sizes**: `sm` (small), `md` (medium, default), `lg` (large)

**Color variants** (per component specific, commonly):
- `primary`, `secondary`, `success`, `warning`, `danger`/`destructive`

---

## React Aria Components Integration

HeroUI v3 wraps React Aria Components primitives with Radix-style compound patterns. All components support render props from React Aria for maximum flexibility:

```tsx
<Button className={composeTwRenderProps(className, customStyles)}>
  {(renderProps) => renderProps.isPressed ? 'Pressed!' : 'Click me'}
</Button>
```

---

## Icons

HeroUI uses **Iconify** with `gravity-ui` as the default icon set. Icons are exported from `@nextui-org/react` via the `icons` module.
