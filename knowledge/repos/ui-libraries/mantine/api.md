# Mantine — API Reference

> React component library with 100+ components, 70+ hooks, and dedicated packages for dates, forms, charts, and more.

## Setup

```bash
npm install @mantine/core @mantine/hooks @emotion/react
# In your app root, import CSS:
import '@mantine/core/styles.css';
```

Wrap app with `MantineProvider`:
```tsx
import { MantineProvider, createTheme } from '@mantine/core';

const theme = createTheme({
  primaryColor: 'blue',
  fontFamily: 'Inter, sans-serif',
});

function App() {
  return <MantineProvider theme={theme}><YourApp /></MantineProvider>;
}
```

---

## @mantine/core (96 components)

### Layout
| Component | Key Props |
|-----------|-----------|
| **Container** | `size`, `fluid`, `mx` |
| **Grid** | `gutter`, `justify`, `align`, `cols`, `grow` |
| **Grid.Col** | `span`, `offset`, `order` |
| **SimpleGrid** | `cols`, `spacing`, `verticalSpacing` |
| **Stack** | `gap`, `align`, `justify`, `wrap` |
| **Group** | `gap`, `align`, `justify`, `wrap`, `grow`, `preventGrowOverflow` |
| **Flex** | `direction`, `gap`, `align`, `justify`, `wrap` |
| **Center** | `inline` |
| **Space** | `h`, `w` |
| **AspectRatio** | `ratio` |

### Inputs
| Component | Key Props |
|-----------|-----------|
| **TextInput** | `label`, `description`, `error`, `placeholder`, `value`, `onChange`, `leftSection`, `rightSection`, `size`, `radius`, `disabled`, `required` |
| **Textarea** | `label`, `description`, `error`, `autosize`, `minRows`, `maxRows`, `resize` |
| **NumberInput** | `label`, `min`, `max`, `step`, `decimalScale`, `fixedDecimalScale`, `thousandSeparator`, `allowNegative`, `hideControls`, `rightSection` |
| **PasswordInput** | `label`, `description`, `error`, `visibilityToggleIcon` |
| **ColorInput** | `label`, `value`, `onChange`, `format`, `swatches`, `eyeDropperIcon`, `disallowInput` |
| **FileInput** | `label`, `value`, `onChange`, `multiple`, `accept`, `clearable` |
| **Select** | `data`, `value`, `onChange`, `searchable`, `clearable`, `allowDeselect`, `nothingFoundMessage`, `limit`, `creatable` |
| **MultiSelect** | `data`, `value`, `onChange`, `searchable`, `clearable`, `hidePickedOptions`, `maxValues` |
| **Autocomplete** | `data`, `value`, `onChange`, `limit` |
| **Combobox** | `store`, `onOptionSubmit`, `withinPortal`, `position`, `offset` |
| **TagsInput** | `value`, `onChange`, `data`, `maxTags`, `clearable`, `acceptValueOnBlur` |
| **Checkbox** | `checked`, `onChange`, `indeterminate`, `label`, `description`, `icon` |
| **Checkbox.Group** | `value`, `onChange`, `children` |
| **Radio** | `value`, `checked`, `onChange`, `label`, `description`, `color` |
| **Radio.Group** | `value`, `onChange`, `name` |
| **Switch** | `checked`, `onChange`, `label`, `description`, `thumbIcon`, `onLabel`, `offLabel`, `color` `size` |
| **Slider** | `value`, `onChange`, `min`, `max`, `step`, `marks`, `label`, `showLabelOnHover`, `size`, `color`, `disabled`, `inverted`, `thumbSize` |
| **RangeSlider** | `value` (2 values), same props as Slider |
| **Rating** | `value`, `onChange`, `count`, `fractions`, `color`, `size`, `emptySymbol`, `fullSymbol` |
| **PinInput** | `value`, `onChange`, `length`, `type`, `mask`, `placeholder`, `oneTimeCode` |
| **JsonInput** | `label`, `value`, `onChange`, `formatOnBlur`, `validationError` |
| **MaskInput** | `mask`, `value`, `onChange` |
| **NativeSelect** | `data`, `value`, `onChange` |
| **ColorPicker** | `value`, `onChange`, `format`, `swatches`, `fullWidth` |
| **PillsInput** | `size`, `radius`, `variant`, container for `Pill` children |
| **Pill** | `withRemoveButton`, `onRemove`, `size`, `radius`, `bg`, `c` |

### Buttons & Actions
| Component | Key Props |
|-----------|-----------|
| **Button** | `variant` (filled/light/outline/transparent/white/subtle/default/gradient), `color`, `size`, `radius`, `loading`, `disabled`, `leftSection`, `rightSection`, `fullWidth`, `justify`, `gradient` |
| **ActionIcon** | `variant`, `color`, `size`, `radius`, `loading`, `disabled` |
| **Button.Group** | `orientation` (horizontal/vertical), `borderWidth` |
| **CopyButton** | `value`, `timeout`, children render prop |
| **FileButton** | `onChange`, `accept`, `multiple`, children render prop |
| **CloseButton** | `size`, `icon` |
| **Burger** | `opened`, `onClick`, `transitionDuration`, `size`, `color` |
| **UnstyledButton** | Base for custom buttons, no default styles |
| **SegmentedControl** | `data`, `value`, `onChange`, `size`, `radius`, `fullWidth`, `orientation` |

### Overlays
| Component | Key Props |
|-----------|-----------|
| **Modal** | `opened`, `onClose`, `title`, `size`, `centered`, `overlayProps`, `fullScreen`, `closeOnClickOutside`, `closeOnEscape`, `zIndex`, `transitionProps`, `withCloseButton`, `returnFocus`, `lockScroll` |
| **Drawer** | `opened`, `onClose`, `title`, `position` (left/right/top/bottom), `size`, `offset` |
| **Popover** | `opened`, `onChange`, `position`, `offset`, `withArrow`, `width`, `shadow`, `closeOnClickOutside` |
| **Tooltip** | `label`, `position`, `color`, `withArrow`, `multiline`, `openDelay`, `closeDelay`, `disabled`, `events` (hover/focus/touch) |
| **HoverCard** | `position`, `shadow`, `withArrow`, `openDelay`, `closeDelay` |
| **Menu** | `trigger`, `opened`, `onChange`, `position`, `offset`, `shadow`, `withArrow`, `closeOnItemClick`, `loop` |
| **Dialog** | `opened`, `onClose`, `position`, `size`, `withCloseButton` |

### Navigation
| Component | Key Props |
|-----------|-----------|
| **Tabs** | `value`, `onChange`, `orientation`, `variant` (default/outline/pills), `activateTabWithKeyboard`, `color`, `radius` |
| **Tabs.Tab** | `value`, `leftSection`, `rightSection`, `disabled`, `color` |
| **NavLink** | `label`, `description`, `leftSection`, `rightSection`, `active`, `children`, `color`, `variant` (light/filled/subtle), `opened`, `onChange` |
| **Stepper** | `active`, `onStepClick`, `orientation` (horizontal/vertical), `color`, `size`, `radius`, `allowNextStepsSelect`, `iconPosition` |
| **Stepper.Step** | `label`, `description`, `icon`, `loading`, `disabled`, `completedIcon` |
| **Pagination** | `total`, `value`, `onChange`, `boundaries`, `siblings`, `color`, `size`, `radius`, `withEdges`, `withControls` |
| **Breadcrumbs** | `separator`, `separatorMargin` |
| **Anchor** | `underline` (always/hover/never), `size`, `c` (color), `inherit` |
| **AppShell** | `header`, `navbar`, `aside`, `footer`, `layout` (default/alt), `padding`, `disabled` |

### Data Display
| Component | Key Props |
|-----------|-----------|
| **Table** | `data`, `highlightOnHover`, `striped`, `withTableBorder`, `withColumnBorders`, `withRowBorders`, `layout` |
| **Table.Th/Td/Tr/Thead/Tbody/Tfoot/Caption** | Standard table sub-components |
| **Card** | `padding`, `radius`, `withBorder`, `shadow`, component for Card.Section |
| **Card.Section** | `withBorder`, `inheritPadding`, `py` |
| **Image** | `src`, `alt`, `fit` (contain/cover/fill/scale-down/none), `radius`, `fallbackSrc` |
| **Avatar** | `src`, `alt`, `size`, `radius`, `color`, `children` (initials), `variant` (filled/light/outline/transparent/white) |
| **Avatar.Group** | `spacing` |
| **Badge** | `variant` (filled/light/outline/dot/transparent/default/white/gradient), `color`, `size`, `radius`, `leftSection`, `rightSection`, `fullWidth` |
| **Indicator** | `label`, `size`, `color`, `position`, `offset`, `processing`, `withBorder`, `disabled`, `inline` |
| **ThemeIcon** | `variant`, `color`, `size`, `radius`, `gradient` |
| **Accordion** | `value`, `onChange`, `multiple`, `variant` (default/contained/filled/separated), `radius`, `chevron`, `chevronPosition`, `disableChevronRotation`, `order` |
| **Accordion.Item** | `value` |
| **Accordion.Control** | `icon` |
| **Accordion.Panel** | Standard content |
| **Timeline** | `active`, `color`, `radius`, `lineWidth`, `bulletSize`, `align` (left/right), `reverseActive` |
| **Timeline.Item** | `title`, `bullet`, `lineVariant` |
| **Spoiler** | `maxHeight`, `showLabel`, `hideLabel`, `hideLabel`, `initialState`, `transitionDuration` |
| **Kbd** | `size` |
| **Code** | `block`, `color` |
| **Highlight** | `highlight` (string or array of strings), `highlightColor`, `children` |
| **Blockquote** | `cite`, `icon`, `color`, `radius` |
| **List** | `type` (ordered/unordered), `size`, `withPadding`, `center`, `icon`, `spacing` |
| **List.Item** | `icon` |
| **TypographyStylesProvider** | `classNames` — applies typography styles to child HTML content |
| **Tree** | `data`, `levelOffset`, `expandedState`, `allowDrop`, `dragOverTarget`, `checkable`, `selectable` |
| **TreeSelect** | `data`, `value`, `onChange`, `searchable`, `clearable` |
| **TableOfContents** | `children`, `minDepth`, `maxDepth`, `scrollOffset` |

### Numeric Display
| Component | Key Props |
|-----------|-----------|
| **NumberFormatter** | `value`, `decimalScale`, `fixedDecimalScale`, `thousandSeparator`, `prefix`, `suffix` |
| **RollingNumber** | `value`, `animationDuration`, `characters` |
| **CountUp** | `start`, `end`, `duration`, `decimals`, `prefix`, `suffix` |

### Motion
| Component | Key Props |
|-----------|-----------|
| **Transition** | `mounted`, `transition` (fade/skew-up/skew-down/rotate-right/rotate-left/slide-down/slide-up/slide-right/slide-left/scale-y/scale-x/scale/pop/pop-top-left/pop-top-right/pop-bottom-left/pop-bottom-right), `duration`, `timingFunction`, `keepMounted` |
| **Collapse** | `in`, `transitionDuration`, `animateOpacity` |
| **Marquee** | `speed`, `direction`, `gap`, `fadeEdges`, `pauseOnHover`, `loop`, `children` |

### Feedback
| Component | Key Props |
|-----------|-----------|
| **Alert** | `variant` (filled/light/outline/transparent/default/white), `color`, `title`, `icon`, `withCloseButton`, `onClose`, `radius` |
| **Notification** | `title`, `color`, `icon`, `loading`, `withCloseButton`, `onClose`, `radius` |
| **Progress** | `value`, `size`, `radius`, `color`, `striped`, `animated`, `transitionDuration` |
| **RingProgress** | `value`, `size`, `thickness`, `roundCaps`, `sections` (array of {value, color}), `label`, `rootColor` |
| **SemiCircleProgress** | `value`, `size`, `thickness`, `orientation` (up/down), `emptySegmentColor`, `filledSegmentColor`, `label` |
| **Skeleton** | `height`, `width`, `radius`, `circle`, `animate`, `visible` (show/hide children) |
| **Loader** | `type` (bars/dots/oval), `size`, `color` |
| **LoadingOverlay** | `visible`, `zIndex`, `overlayProps`, `loaderProps`, `transitionProps` |

### Misc
| Component | Key Props |
|-----------|-----------|
| **Affix** | `position` (top-right/top-left/bottom-right/bottom-left), `withinPortal`, `zIndex`, `portalProps` |
| **Overlay** | `zIndex`, `color`, `backgroundOpacity`, `blur`, `radius`, `gradient`, `fixed` |
| **Portal** | `target`, children |
| **FocusTrap** | `active`, children |
| **ScrollArea** | `type` (auto/always/scroll/hover/never), `scrollbarSize`, `scrollHideDelay`, `offsetScrollbars`, `viewportProps` |
| **Scroller** | `scrollDirection` (left/right/top/bottom), `callback`, content element |
| **Fieldset** | `legend`, `radius`, `variant` (default/white/filled/unstyled) |
| **Divider** | `label`, `labelPosition` (left/center/right), `size`, `orientation`, `color`, `variant` (dashed/dotted/solid) |
| **BackgroundImage** | `src`, `radius` |
| **AngleSlider** | `value`, `onChange`, `size`, `radius`, `withLabel`, `step`, `restrictToMarks`, `marks` |
| **FloatingIndicator** | `target`, `parent`, `className` — animated indicator between elements |
| **FloatingWindow** | `opened`, `onClose`, `position`, `offset`, `width`, `height`, `withBorder` |
| **VisuallyHidden** | Accessible hidden content |
| **Text** | `size`, `c` (color), `fw`, `inherit`, `lineClamp`, `truncate`, `span`/`inline`, `variant` (gradient), `gradient`, `underline` |
| **Title** | `order` (1-6), `size`, `textWrap` (wrap/balance/nowrap) |
| **Mark** | Inline highlight (uses `<mark>`) |
| **Chip** | `checked`, `onChange`, `color`, `size`, `radius`, `variant` (filled/light/outline), `type` (checkbox/radio), `icon` |
| **Chip.Group** | `value`, `onChange`, `multiple` |
| **OverflowList** | `items`, `itemComponent`, `overflowLabel`, `direction` |

---

## @mantine/hooks (70+ hooks)

| Hook | Description |
|------|-------------|
| **useDisclosure** | `[opened, { open, close, toggle }]` — most commonly used |
| **useToggle** | `[value, toggle]` — toggle between two values |
| **useCounter** | Counter state with increment/decrement/set/reset |
| **useDebouncedValue** | Debounce a value with configurable delay |
| **useDebouncedCallback** | Debounced callback function |
| **useThrottledValue** | Throttled value |
| **useThrottledCallback** | Throttled callback function |
| **usePrevious** | Returns previous value of a state/prop |
| **useClickOutside** | Detect clicks outside a ref element |
| **useFocusTrap** | Trap focus within a ref container |
| **useFocusReturn** | Return focus to previously focused element |
| **useFocusWithin** | Detect focus within an element |
| **useMediaQuery** | `useMediaQuery('(min-width: 768px)')` — responsive boolean |
| **useResizeObserver** | `[ref, rect]` — observe element size changes |
| **useElementSize** | `{ ref, width, height }` — simpler element size |
| **useIntersection** | `{ ref, entry }` — IntersectionObserver |
| **useViewportSize** | `{ height, width }` — current viewport dimensions |
| **useWindowScroll** | `[scroll, scrollTo]` — window scroll position and control |
| **useScrollIntoView** | `{ scrollIntoView, targetRef, scrollableRef, cancel }` |
| **useScrollDirection** | Detects scroll direction (up/down) |
| **useWindowEvent** | `useWindowEvent('keydown', handler)` |
| **useEventListener** | Attach event listener to any element |
| **useHover** | `{ ref, hovered }` — hover state on a ref |
| **useMouse** | `{ ref, x, y }` — mouse position relative to ref |
| **useMove** | `{ ref, active }` — mouse/touch drag position tracking |
| **useNetwork** | Online/offline, downlink, effectiveType |
| **useIdle** | `idle` boolean after user inactivity timeout |
| **useTimeout** | `{ start, clear }` — clearable setTimeout |
| **useInterval** | `{ start, stop, toggle, active }` — clearable setInterval |
| **useClipboard** | `{ copy, copied, error, reset }` — copy to clipboard |
| **useColorScheme** | `'light'` / `'dark'` / `'auto'` |
| **useFullscreen** | `{ toggle, fullscreen, ref }` — element fullscreen |
| **useLocalStorage** | `[value, setValue, removeValue]` with serialization |
| **useSessionStorage** | Same as useLocalStorage but session scoped |
| **useDocumentTitle** | Set `document.title` |
| **useDocumentVisibility** | Returns `DocumentVisibility` state |
| **useHotkeys** | Register keyboard shortcuts: `useHotkeys([['mod+S', handler]])` |
| **usePagination** | `{ range, active, setPage, next, previous, first, last }` |
| **useQueue** | `{ state, queue, update, cleanQueue }` — queued state management |
| **useListState** | Array state with handlers (filter, apply, remove, insertAt, etc.) |
| **useSetState** | State management with partial updates (like class setState) |
| **useStateHistory** | Undo/redo state management |
| **useMap** | Map-based state management (like Map data structure) |
| **useSet** | Set-based state management |
| **useShallowEffect** | useEffect that runs only when deps change by reference |
| **useDidUpdate** | useEffect that skips initial render |
| **useIsomorphicEffect** | useLayoutEffect that works with SSR |
| **useMergedRef** | Merge multiple refs into one |
| **useForceUpdate** | Force a re-render |
| **useId** | Generate unique ID (SSR-safe) |
| **useOs** | Returns OS name |
| **useLogger** | Log component lifecycle for debugging |
| **useHeadroom** | Detect if header should be shown/hidden based on scroll |
| **useEyeDropper** | EyeDropper API to pick color from screen |
| **useFavicon** | Dynamically update favicon |
| **useValidatedState** | State with validation function |
| **useInputState** | Input state helper: `[value, { onChange, setValue }]` |
| **useTextSelection** | Returns current text selection |
| **usePageLeave** | Detect when mouse leaves page |
| **useReducedMotion** | Respects `prefers-reduced-motion` |
| **useUncontrolled** | Hybrid controlled/uncontrolled state |
| **useMounted** | Returns true only after component is mounted (avoids hydration mismatch) |
| **useIsFirstRender** | Returns true on first render only |
| **useOrientation** | `{ angle, type }` — screen orientation |
| **useFetch** | Fetch API wrapper: `{ data, error, loading, refetch, abort }` |
| **useFileDialog** | `{ open, reset, onChange }` — programmatic file dialog |
| **useHash** | `[hash, setHash]` — window.location.hash |
| **useLongPress** | Long press detection on element |
| **useRovingIndex** | Roving tabindex for keyboard navigation groups |
| **useScrollSpy** | Active heading detection for table of contents |
| **useScroller** | Scroll element by given direction |
| **useSelection** | Selection state management like checkboxes |
| **useMask** | Input mask formatting |
| **useCollapse** | Animated collapse with content height measurement |
| **useDrag** | Drag-and-drop state management |
| **useRadialMove** | Radial/circular drag position tracking |
| **useFloatingWindow** | Draggable floating window position management |
| **useMutationObserver** | React wrapper for MutationObserver |
| **useInViewport** | Check if element is visible in viewport |
| **useDropzone** (via @mantine/dropzone) | File drop zone logic |

---

## @mantine/form

```tsx
import { useForm } from '@mantine/form';

const form = useForm({
  initialValues: { email: '', password: '' },
  validate: {
    email: (value) => (/^\S+@\S+$/.test(value) ? null : 'Invalid email'),
    password: (value) => (value.length < 6 ? 'Too short' : null),
  },
});
```

Key API: `onSubmit`, `getInputProps`, `setValues`, `setFieldValue`, `validate`, `validateField`, `reset`, `isDirty`, `isValid`, `errors`, `clearErrors`, `setErrors`, `validateOnChange`, `onValuesChange`, `transformValues`, `enhanceGetInputProps`

---

## @mantine/dates

Components: **DatePicker**, **DatePickerInput**, **DateInput**, **DateTimePicker**, **MonthPicker**, **MonthPickerInput**, **YearPicker**, **YearPickerInput**, **TimeInput**

Common props: `value`, `onChange`, `minDate`, `maxDate`, `format`, `valueFormat`, `weekendDays`, `getDayProps`, `firstDayOfWeek`, `hideOutsideDates`, `locale`, `allowDeselect`, `clearable`

---

## @mantine/notifications

```tsx
import { notifications } from '@mantine/notifications';

notifications.show({ title: 'Success', message: 'Saved!', color: 'green' });
notifications.update({ id: 'my-id', title: 'Updated', loading: false });
notifications.hide('my-id');
notifications.clean();
notifications.cleanQueue();
```

---

## @mantine/modals

```tsx
import { modals } from '@mantine/modals';

modals.open({ title: 'Confirm', children: 'Are you sure?', onConfirm: () => {} });
modals.openConfirmModal({ ... });
modals.openContextModal({ modal: 'customModal', ... });
modals.closeAll();
```

---

## @mantine/spotlight

```tsx
import { Spotlight, spotlight } from '@mantine/spotlight';

spotlight.open();
spotlight.close();
```

Spotlight props: `actions` (array of {id, label, description, onClick, leftSection}), `searchProps`, `nothingFound`, `highlightQuery`, `limit`, `filter`, `scrollAreaComponent`

---

## @mantine/carousel

Single component **Carousel** with: `slideSize`, `slideGap`, `align`, `height`, `withIndicators`, `withControls`, `dragFree`, `loop`, `orientation`, `controlSize`

Uses Embla internally. Sub: **Carousel.Slide**

---

## @mantine/charts

Built on top of Recharts. Components:
- **AreaChart** — `data`, `series`, `dataKey`, `curveType`, `areaChartProps`, `gridAxis`, `withLegend`
- **BarChart** — `data`, `series`, `dataKey`, `orientation`, `barChartProps`, `gridAxis`
- **LineChart** — `data`, `series`, `dataKey`, `curveType`, `lineChartProps`, `gridAxis`
- **DonutChart** — `data` (array of {name, value, color}), `withLabels`, `strokeWidth`, `paddingAngle`
- **PieChart** — `data`, `withLabels`, `strokeWidth`, `size`
- **RadarChart** — `data`, `series`, `dataKey`
- **ScatterChart** — `data`, `series`, `dataKey`, `scatterProps`
- **Sparkline** — `data`, `curveType`, `color`, `trendColors`

All chart components share: `h` (height), `w` (width), `data`, `withTooltip`, `referenceLines`, `xAxisLabel`, `yAxisLabel`

---

## @mantine/code-highlight

- **CodeHighlight** — `code` (string), `language` (tsx/typescript/jsx/css/html/bash/json)
- **CodeHighlightTabs** — `code` (array of {fileName, code, language}), `defaultExpandedCode`, `withCopyButton`

---

## @mantine/dropzone

- **Dropzone** — `onDrop`, `onReject`, `maxSize`, `accept`, `loading`, `multiple`, `activateOnClick`, `openRef`
- **Dropzone.FullScreen** — `active`, `onClose`

---

## @mantine/tiptap

Rich text editor built on TipTap. **RichTextEditor** + extensions: Bold, Italic, Underline, Strike, Link, Unlink, Image, Video, Iframe, Table, Youtube, Subscript, Superscript, Highlight, Code, CodeBlock, Blockquote, BulletList, OrderedList, HeadingControl, ColorPicker, AlignControl, TaskList, Hr, ClearFormatting, Undo, Redo, EmojiPicker, Mention, InputRule, SourceCode

---

## @mantine/nprogress

- **NavigationProgress** — Auto-shown on route changes (Next.js/Remix), or manually via `nprogress.start()` / `nprogress.stop()` / `nprogress.reset()` / `nprogress.complete()`

---

## @mantine/emotion

Legacy styling (use CSS Modules instead in v7+):
- `createStyles`, `keyframes`, `Global`, `useCss`

---

### Variants (common across many components)

Input variant system: `default`, `filled`, `unstyled`

Button variant system: `filled`, `light`, `outline`, `transparent`, `white`, `subtle`, `default`, `gradient`

### Sizes (common across many components): `xs`, `sm`, `md`, `lg`, `xl`

### Colors: `dark`, `gray`, `red`, `pink`, `grape`, `violet`, `indigo`, `blue`, `cyan`, `teal`, `green`, `lime`, `yellow`, `orange` + custom via `theme.colors`

### Radii: `xs`, `sm`, `md`, `lg`, `xl`
