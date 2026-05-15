# Radix UI Primitives -- API Reference

## Setup
```bash
npm install @radix-ui/react-<component>
# or install the Radix UI CLI
npx radix-ui@latest init
# Available as individual packages from @radix-ui/*
```

## Components (33 total)

---

### Accordion (Root / Item / Header / Trigger / Content)
- **Package:** `@radix-ui/react-accordion`
- **Props (Root):** `type` ("single"|"multiple"), `value`/`defaultValue`, `collapsible`, `onValueChange`, `disabled`, `orientation` ("vertical"|"horizontal"), `dir`
- **Props (Item):** `value` (string), `disabled`
- **Props (Trigger):** all button props, `asChild`
- **Props (Content):** all div props, CSS vars `--radix-accordion-content-height`, `--radix-accordion-content-width`
- **Props (Header):** all h3 props
- **States:** `data-state="open"|"closed"` on Item/Header/Trigger/Content, `data-orientation`, `data-disabled`
- **Accessibility:** Arrow keys, Home/End navigation, ARIA attributes (role="region", aria-labelledby)

### AlertDialog (Root / Trigger / Portal / Overlay / Content / Action / Cancel / Title / Description)
- **Package:** `@radix-ui/react-alert-dialog`
- **Props (Root):** `open`, `defaultOpen`, `onOpenChange`
- **Props (Trigger):** all button props, `asChild`
- **Props (Content):** `forceMount`, `onOpenAutoFocus`, `onCloseAutoFocus`, `onEscapeKeyDown`, `onPointerDownOutside`
- **Props (Overlay):** all div props, `forceMount`
- **Props (Action/Cancel):** all button props (Action performs destructive action, Cancel closes)
- **Props (Title/Description):** all h2/p props
- **States:** `data-state="open"|"closed"` on Trigger/Overlay/Content
- **Accessibility:** focus trap, ESC close, outside click prevented (modal), ARIA alert-dialog pattern

### AspectRatio (Root)
- **Package:** `@radix-ui/react-aspect-ratio`
- **Props:** `ratio` (number, default 1)
- **Usage:** Wrap any content to maintain aspect ratio. Child fills using absolute positioning.
- **Accessibility:** No ARIA needed -- purely layout

### Avatar (Root / Image / Fallback)
- **Package:** `@radix-ui/react-avatar`
- **Props (Root):** all span props
- **Props (Image):** `src`, `alt`, `onLoadingStatusChange` ("loading"|"loaded"|"error")
- **Props (Fallback):** all span props (shown when Image fails to load)
- **States:** `data-status="loading"|"loaded"|"error"` via Image's onLoadingStatusChange
- **Accessibility:** renders as `<span role="img" aria-label>` when image has alt text

### Checkbox (Root / Indicator / BubbleInput)
- **Package:** `@radix-ui/react-checkbox`
- **Props (Root):** `checked` ("boolean"|"indeterminate"), `defaultChecked`, `onCheckedChange`, `disabled`, `required`, `name`, `value`, `asChild`
- **Props (Indicator):** `forceMount` (for animations)
- **States:** `data-state="checked"|"unchecked"|"indeterminate"`, `data-disabled`
- **Accessibility:** role="checkbox", aria-checked, keyboard toggle (Space)

### Collapsible (Root / Trigger / Content)
- **Package:** `@radix-ui/react-collapsible`
- **Props (Root):** `open`, `defaultOpen`, `onOpenChange`, `disabled`
- **Props (Trigger):** all button props, `asChild`
- **Props (Content):** `forceMount`, exposes CSS vars `--radix-collapsible-content-height`, `--radix-collapsible-content-width`
- **States:** `data-state="open"|"closed"`, `data-disabled`
- **Accessibility:** button disclosure pattern, aria-expanded

### ContextMenu (Root / Trigger / Portal / Content / Group / Label / Item / CheckboxItem / RadioGroup / RadioItem / ItemIndicator / Separator / Arrow)
- **Package:** `@radix-ui/react-context-menu`
- **Props (Root):** `open`, `defaultOpen`, `onOpenChange`, `modal`
- **Props (Trigger):** `disabled` (disables right-click), `asChild`
- **Props (Content):** `forceMount`, `side`, `sideOffset`, `align`, `alignOffset`, `avoidCollisions`, `collisionBoundary`, `onCloseAutoFocus`
- **Props (Item):** `disabled`, `onSelect`, `textValue`
- **Props (CheckboxItem):** `checked`, `onCheckedChange`
- **Props (RadioGroup):** `value`, `onValueChange`
- **Props (RadioItem):** `value`, `disabled`
- **Props (Separator):** all div props
- **Props (Arrow):** `width`, `height`
- **States:** `data-state="open"|"closed"`, `data-highlighted`, `data-disabled`, `data-orientation` on Arrow
- **Accessibility:** right-click trigger, menu role, arrow key nav, typeahead

### Dialog (Root / Trigger / Portal / Overlay / Content / Title / Description / Close)
- **Package:** `@radix-ui/react-dialog`
- **Props (Root):** `open`, `defaultOpen`, `onOpenChange`, `modal` (default true)
- **Props (Trigger):** all button props, `asChild`
- **Props (Portal):** `container`, `forceMount`
- **Props (Overlay):** all div props, `forceMount`
- **Props (Content):** `forceMount`, `trapFocus`, `onOpenAutoFocus`, `onCloseAutoFocus`, `onEscapeKeyDown`, `onPointerDownOutside`, `onInteractOutside`
- **Props (Title):** all h2 props
- **Props (Description):** all p props
- **Props (Close):** all button props, `asChild`
- **States:** `data-state="open"|"closed"` on Trigger, Overlay, Content
- **Accessibility:** focus trap, ESC close, outside click close (modal), aria-labelledby/describedby, dev warnings for missing title/description
- **Notes:** Non-modal variant available (`modal={false}`) -- doesn't trap focus or hide others

### DropdownMenu (Root / Trigger / Portal / Content / Group / Label / Item / CheckboxItem / RadioGroup / RadioItem / ItemIndicator / Separator / Arrow / Sub / SubTrigger / SubContent)
- **Package:** `@radix-ui/react-dropdown-menu`
- **Props (Root):** `open`, `defaultOpen`, `onOpenChange`, `modal`, `dir`
- **Props (Trigger):** all button props, `asChild`
- **Props (Content):** `side`, `sideOffset`, `align`, `alignOffset`, `forceMount`, `avoidCollisions`, `collisionBoundary`, `collisionPadding`, `loop`
- **Props (Item):** `disabled`, `onSelect`, `textValue`
- **Props (CheckboxItem):** `checked` ("boolean"|"indeterminate"), `onCheckedChange`
- **Props (RadioGroup):** `value`, `onValueChange`
- **Props (RadioItem):** `value`, `disabled`
- **Props (Sub):** `open`, `defaultOpen`, `onOpenChange`
- **Props (SubTrigger):** `disabled`
- **Props (SubContent):** same as Content props + `sideOffset`, `alignOffset`
- **States:** `data-state="open"|"closed"`, `data-highlighted`, `data-disabled`
- **Accessibility:** menu role, full keyboard nav, typeahead, sub-menus

### Form (Root / Field / Label / Control / Message / ValidityState / Submit)
- **Package:** `@radix-ui/react-form`
- **Props (Root):** `onSubmit`, `onClearServerErrors`, `noValidate`, `asChild`
- **Props (Field):** `name`, `serverInvalid`, `onClearServerErrors`, `formMessage`, `asChild`
- **Props (Label):** `asChild` (all label props)
- **Props (Control):** `asChild` -- renders a child input; provides `formControlId`, `formControlDescriptionId`, `formMessageId`, `validity` via render prop
- **Props (Message):** `match` ("valueMissing"|"typeMismatch"|"tooShort"|"tooLong"|"rangeUnderflow"|"rangeOverflow"|"stepMismatch"|"badInput"|"patternMismatch"), `asChild`
- **Props (ValidityState):** render prop with `validity` (ValidityState), `validationMode` ("onBlur"|"onChange"|"onSubmit")
- **Props (Submit):** all button props, `asChild`
- **States:** `data-valid`, `data-invalid` on Field, Label, Control
- **Accessibility:** constraint validation, server validation, form-control linking

### HoverCard (Root / Trigger / Portal / Content / Arrow)
- **Package:** `@radix-ui/react-hover-card`
- **Props (Root):** `open`, `defaultOpen`, `onOpenChange`, `openDelay` (default 700), `closeDelay` (default 300)
- **Props (Trigger):** all button props, `asChild` (also works as `<a>`)
- **Props (Content):** `side`, `sideOffset`, `align`, `alignOffset`, `forceMount`, `avoidCollisions`
- **Props (Arrow):** `width`, `height`
- **States:** `data-state="open"|"closed"`, `data-side`
- **Accessibility:** hover/focus open, ESC close, aria-describedby links trigger to content

### Label (Root)
- **Package:** `@radix-ui/react-label`
- **Props:** `htmlFor`, `asChild`
- **Usage:** Renders `<label>` that auto-focuses the linked control on click (Safari compatibility)
- **Accessibility:** standard label behavior with cross-browser click-to-focus

### Menubar (Root / Menu / Trigger / Portal / Content / Group / Label / Item / CheckboxItem / RadioGroup / RadioItem / ItemIndicator / Separator)
- **Package:** `@radix-ui/react-menubar`
- **Props (Root):** `value` (controlled), `defaultValue`, `onValueChange`, `dir`
- **Props (Menu):** `value` (unique identifier)
- **Props (Trigger):** all button props, `asChild`
- **Props (Content):** `forceMount`, `side`, `align`, `loop`
- **Props (Item):** `disabled`, `onSelect`
- **Props (CheckboxItem):** `checked`, `onCheckedChange`
- **Props (RadioGroup):** `value`, `onValueChange`
- **States:** `data-state="open"|"closed"`, `data-highlighted`
- **Accessibility:** menubar pattern, left/right arrow nav between menus, up/down within menu

### NavigationMenu (Root / Sub / List / Item / Trigger / Link / Indicator / Content / Viewport)
- **Package:** `@radix-ui/react-navigation-menu`
- **Props (Root):** `value`, `defaultValue`, `onValueChange`, `delayDuration` (default 200), `skipDelayDuration` (default 300), `dir`, `orientation`
- **Props (Trigger):** all button props, `asChild`
- **Props (Link):** `active`, `onSelect`, `asChild`
- **Props (Content):** `forceMount`
- **Props (Indicator):** `forceMount`, `asChild` -- animated underline
- **Props (Viewport):** `forceMount` -- container for Content with enter/exit animation
- **States:** `data-state="open"|"closed"`, `data-orientation`, `data-active`
- **Accessibility:** complex nav pattern, arrow key nav, hover delay with grace period

### OneTimePasswordField (Root / Input / HiddenInput)
- **Package:** `@radix-ui/react-one-time-password-field`
- **Props (Root):** `value`, `defaultValue`, `onValueChange`, `onComplete`, `pushPasswordManagerStrategy` ("none"|"increase-width", default "increase-width"), `maxLength`, `disabled`, `type` ("numeric"|"alphanumeric")
- **Props (Input):** all input props, `index` (slot index)
- **Properties:** CSS var `--radix-otp-field-height`, `data-disabled`, `data-complete`
- **Accessibility:** OTP input group, autofill support, paste handling

### PasswordToggleField (Root / Input / Toggle / Slot / Icon)
- **Package:** `@radix-ui/react-password-toggle-field`
- **Props (Root):** all div props, `asChild`
- **Props (Input):** all input props (type handled internally, toggles text/password)
- **Props (Toggle):** all button props
- **Props (Slot):** renders after Input for toggle button placement
- **Props (Icon):** renders inside Toggle (visible/hidden icon)
- **States:** `data-state` on Toggle for visible/hidden
- **Accessibility:** password show/hide toggle pattern

### Popover (Root / Anchor / Trigger / Portal / Content / Close / Arrow)
- **Package:** `@radix-ui/react-popover`
- **Props (Root):** `open`, `defaultOpen`, `onOpenChange`, `modal` (default false)
- **Props (Anchor):** provides custom positioning reference (optional; Trigger auto-anchors)
- **Props (Trigger):** all button props, `asChild`
- **Props (Content):** `side`, `sideOffset`, `align`, `alignOffset`, `forceMount`, `avoidCollisions`, `collisionBoundary`, `collisionPadding`, `arrowPadding`, `sticky`, `hideWhenDetached`, `onOpenAutoFocus`, `onCloseAutoFocus`, `onEscapeKeyDown`, `onPointerDownOutside`
- **Props (Close):** all button props
- **Props (Arrow):** `width`, `height`
- **CSS Vars:** `--radix-popover-content-transform-origin`, `--radix-popover-content-available-width`, `--radix-popover-content-available-height`, `--radix-popover-trigger-width`, `--radix-popover-trigger-height`
- **States:** `data-state="open"|"closed"`, `data-side`, `data-align`
- **Accessibility:** dialog role, focus management, ESC close, click outside close

### Progress (Root / Indicator)
- **Package:** `@radix-ui/react-progress`
- **Props (Root):** `value` (number, 0-100 or null for indeterminate), `max` (default 100), `getValueLabel` (accessibility)
- **States:** `data-state="complete"|"indeterminate"|"loading"`, `data-value`, `data-max`
- **CSS Var:** `--radix-progress-transform` applied to Indicator for translateX
- **Accessibility:** role="progressbar", aria-valuenow, aria-valuemin, aria-valuemax

### RadioGroup (Root / Item / Indicator)
- **Package:** `@radix-ui/react-radio-group`
- **Props (Root):** `value`, `defaultValue`, `onValueChange`, `disabled`, `required`, `orientation`, `loop`, `name` (for form integration)
- **Props (Item):** `value` (string), `disabled`, `required`, `asChild`
- **Props (Indicator):** `forceMount`, `asChild`
- **States:** `data-state="checked"|"unchecked"` on Item, Indicator; `data-disabled`, `data-orientation`
- **Accessibility:** role="radiogroup", Arrow key navigation within group, RovingFocus-powered

### ScrollArea (Root / Viewport / Scrollbar / Thumb / Corner)
- **Package:** `@radix-ui/react-scroll-area`
- **Props (Root):** `type` ("auto"|"always"|"scroll"|"hover"), `scrollHideDelay` (for "scroll" type), `dir`
- **Props (Viewport):** `asChild`
- **Props (Scrollbar):** `forceMount`, `orientation` ("vertical"|"horizontal")
- **Props (Thumb):** all div props
- **Props (Corner):** all div props
- **States:** `data-state="visible"|"hidden"` on Scrollbar
- **CSS Vars:** `--radix-scroll-area-corner-width`, `--radix-scroll-area-corner-height`, `--radix-scroll-area-thumb-width`, `--radix-scroll-area-thumb-height`
- **Accessibility:** keyboard scrollable, scrollbar aria-hidden

### Select (Root / Trigger / Value / Icon / Portal / Content / Viewport / Group / Label / Item / ItemText / ItemIndicator / ScrollUpButton / ScrollDownButton / Separator / Arrow)
- **Package:** `@radix-ui/react-select`
- **Props (Root):** `value`, `defaultValue`, `onValueChange`, `open`, `defaultOpen`, `onOpenChange`, `dir`, `name`, `disabled`, `required`
- **Props (Trigger):** all button props, `asChild`
- **Props (Value):** `placeholder` -- shows placeholder when no value selected
- **Props (Icon):** all span props (defaults to "▼")
- **Props (Content):** `position` ("item-aligned"|"popper"), `side`, `sideOffset`, `align`, `alignOffset`, `avoidCollisions`, `collisionPadding`, `sticky`
- **Props (Viewport):** `nonce`
- **Props (Group):** all div props
- **Props (Label):** all div props (labels a group)
- **Props (Item):** `value` (string), `disabled`, `textValue` (for typeahead)
- **Props (ItemText):** all span props -- portaled into Trigger for selected display
- **Props (ItemIndicator):** all span props -- only rendered when item is selected
- **Props (ScrollUpButton/ScrollDownButton):** auto-scroll buttons
- **Props (Separator):** all div props
- **Props (Arrow):** `width`, `height` (only in popper position mode)
- **States:** `data-state="open"|"closed"`, `data-state="checked"|"unchecked"` on Item, `data-highlighted`, `data-disabled`, `data-placeholder`
- **CSS Vars:** `--radix-select-content-transform-origin`, `--radix-select-content-available-width`, `--radix-select-content-available-height`, `--radix-select-trigger-width`, `--radix-select-trigger-height`
- **Accessibility:** role="combobox" + "listbox", typeahead, arrow key nav, bubble input for form integration

### Separator (Root)
- **Package:** `@radix-ui/react-separator`
- **Props:** `orientation` ("horizontal"|"vertical"), `decorative` (if true, uses role="none"), `asChild`
- **States:** `data-orientation`
- **Accessibility:** renders `<div role="separator">` or `<div role="none">`

### Slider (Root / Track / Range / Thumb)
- **Package:** `@radix-ui/react-slider`
- **Props (Root):** `value` (number[]), `defaultValue`, `min` (default 0), `max` (default 100), `step` (default 1), `minStepsBetweenThumbs`, `disabled`, `orientation`, `dir`, `name`, `onValueChange`, `onValueCommit`, `inverted`
- **Props (Track):** all span props -- the clickable track
- **Props (Range):** all span props -- the filled portion
- **Props (Thumb):** all span props, `asChild`
- **States:** `data-disabled`, `data-orientation`
- **Accessibility:** role="slider", Arrow key increment/decrement, multi-thumb support

### Slot (asChild pattern)
- **Package:** `@radix-ui/react-slot`
- **Props:** `children` (single React element)
- **Usage:** `<Slot>` merges its props onto its immediate child, enabling `asChild` pattern everywhere
- **Notes:** Fundamental to Radix's composition model -- every primitive supports `asChild`

### Switch (Root / Thumb)
- **Package:** `@radix-ui/react-switch`
- **Props (Root):** `checked`, `defaultChecked`, `onCheckedChange`, `disabled`, `required`, `name`, `value`, `asChild`
- **Props (Thumb):** all span props, `asChild`
- **States:** `data-state="checked"|"unchecked"`, `data-disabled`
- **Accessibility:** role="switch", aria-checked, Space toggles

### Tabs (Root / List / Trigger / Content)
- **Package:** `@radix-ui/react-tabs`
- **Props (Root):** `value`, `defaultValue`, `onValueChange`, `orientation`, `dir`, `activationMode` ("automatic"|"manual")
- **Props (List):** `loop` (default true), `asChild`
- **Props (Trigger):** `value` (string), `disabled`, `asChild`
- **Props (Content):** `value` (string), `forceMount`, `asChild`
- **States:** `data-state="active"|"inactive"` on Trigger and Content, `data-orientation`, `data-disabled`
- **Accessibility:** role="tablist"/"tab"/"tabpanel", Arrow key nav (RovingFocus), activationMode controls activation on focus vs click

### Toast (Provider / Root / Title / Description / Action / Close / Viewport)
- **Package:** `@radix-ui/react-toast`
- **Props (Provider):** `duration` (default 5000), `label`, `swipeDirection` ("right"|"left"|"up"|"down"), `swipeThreshold`
- **Props (Root):** `open`, `defaultOpen`, `onOpenChange`, `type` ("foreground"|"background"), `duration`
- **Props (Title):** all h2 props
- **Props (Description):** all div props
- **Props (Action):** `altText` (required for accessibility), `asChild`
- **Props (Close):** all button props, `asChild`
- **Props (Viewport):** `hotkey` (F8 default), `label`
- **States:** `data-state="open"|"closed"`, `data-swipe-direction`, `data-swipe="move"|"cancel"|"end"`
- **Accessibility:** live region, F8 focus, swipe dismiss, auto-dismiss timer

### Toggle (Root)
- **Package:** `@radix-ui/react-toggle`
- **Props:** `pressed`, `defaultPressed`, `onPressedChange`, `disabled`, `asChild`
- **States:** `data-state="on"|"off"`, `data-disabled`
- **Accessibility:** aria-pressed toggle button

### ToggleGroup (Root / Item)
- **Package:** `@radix-ui/react-toggle-group`
- **Props (Root):** `type` ("single"|"multiple"), `value`/`defaultValue`, `onValueChange`, `disabled`, `orientation`, `loop`, `rovingFocus`
- **Props (Item):** `value` (string), `disabled`, `asChild`
- **States:** `data-state="on"|"off"`, `data-disabled`, `data-orientation`
- **Accessibility:** group role with toolbar pattern, RovingFocus keyboard nav

### Toolbar (Root / Button / Link / Separator / ToggleGroup / ToggleItem)
- **Package:** `@radix-ui/react-toolbar`
- **Props (Root):** `orientation`, `dir`, `loop`
- **Props (Button):** all button props, `asChild`
- **Props (Link):** `target`, `href`, `asChild`
- **Props (ToggleGroup):** `type` ("single"|"multiple"), `value`, `onValueChange`
- **Props (ToggleItem):** `value`, `disabled`
- **Props (Separator):** all div props
- **States:** `data-orientation`, `data-state="on"|"off"` on ToggleItem
- **Accessibility:** role="toolbar", Arrow key navigation between items (RovingFocus)

### Tooltip (Provider / Root / Trigger / Portal / Content / Arrow)
- **Package:** `@radix-ui/react-tooltip`
- **Props (Provider):** `delayDuration` (default 700), `skipDelayDuration` (default 300), `disableHoverableContent`
- **Props (Root):** `open`, `defaultOpen`, `onOpenChange`, `delayDuration`, `disableHoverableContent`
- **Props (Trigger):** all button props, `asChild`
- **Props (Content):** `side`, `sideOffset`, `align`, `alignOffset`, `forceMount`, `avoidCollisions`, `aria-label`, `onEscapeKeyDown`, `onPointerDownOutside`
- **Props (Arrow):** `width`, `height`
- **States:** `data-state="closed"|"delayed-open"|"instant-open"`, `data-side`, `data-align`
- **CSS Vars:** `--radix-tooltip-content-transform-origin`, `--radix-tooltip-content-available-width`, `--radix-tooltip-content-available-height`, `--radix-tooltip-trigger-width`, `--radix-tooltip-trigger-height`
- **Accessibility:** tooltip role, hover delay, visually hidden content for screen readers, grace-area polygon for hover intent

### VisuallyHidden (Root)
- **Package:** `@radix-ui/react-visually-hidden`
- **Props:** `as`, `asChild`
- **Usage:** Hides content visually while keeping it accessible to screen readers
- **Notes:** Used internally by many components (Tooltip, Toast, etc.)

---

## Core / Internal Primitives

### AccessibleIcon (Root)
- **Package:** `@radix-ui/react-accessible-icon`
- **Props:** `label` (required), `children` (single icon element)
- **Usage:** Wraps an icon with `aria-label` and `role="img"`, also renders text fallback

### Portal (Root)
- **Package:** `@radix-ui/react-portal`
- **Props:** `container`, `asChild`
- **Usage:** Portals children into a specified container (default document.body). Used internally by overlay components.

### Presence (Root)
- **Package:** `@radix-ui/react-presence`
- **Props:** `present` (boolean)
- **Usage:** Render-prop component -- keeps children mounted during exit animations. Used internally by Content components with `forceMount`.

### Announce (Root)
- **Package:** `@radix-ui/react-announce`
- **Props:** `children` (render prop: `(announce: (message, politeness) => void) => ReactNode`)
- **Usage:** Imperatively announce messages to screen readers via live regions.

### Direction (Provider)
- **Package:** `@radix-ui/react-direction`
- **Usage:** Sets text direction (`ltr`/`rtl`) for the component tree. Components read direction via `useDirection()`.

### RovingFocus (Root / Item)
- **Package:** `@radix-ui/react-roving-focus`
- **Props (Root):** `orientation`, `dir`, `loop`, `currentTabStopId`, `defaultCurrentTabStopId`, `onCurrentTabStopIdChange`, `onEntryFocus`
- **Props (Item):** `focusable`, `active`, `allowMultiple`, `tabStopId`
- **Usage:** Manages focus within a group of items (Arrow key roving). Used by Tabs, RadioGroup, Toolbar, ToggleGroup, Menubar.

### Collection (Provider / Slot / ItemSlot)
- **Package:** `@radix-ui/react-collection`
- **Usage:** Registers child items in a flat list for keyboard navigation. Used by Accordion, Select, NavigationMenu.

---

## Typed Exports Pattern

Every component package exports both the prefixed named components AND their Root-named aliases:
```ts
export { Accordion, AccordionItem, AccordionTrigger, AccordionContent }
export { Root, Item, Trigger, Content }  // aliases for destructuring
export type { AccordionSingleProps, AccordionItemProps, ... }
```

This allows both:
```tsx
import * as Accordion from '@radix-ui/react-accordion'
<Accordion.Root><Accordion.Item><Accordion.Trigger>...</Accordion.Trigger></Accordion.Item></Accordion.Root>
```
