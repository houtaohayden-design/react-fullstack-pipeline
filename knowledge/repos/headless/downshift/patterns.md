# Downshift — Patterns

## Styling Approach
- Fully headless — zero styles included
- You own all rendering: HTML elements, classes, styles
- Getter props spread ARIA attributes and event handlers onto your elements
- Use className directly on your elements (the getter props merge with your props)

## Getter Props Pattern
- NOT render props — hooks return getter functions
- Spread getter props LAST so they don't override your props
- Each getter accepts an optional props object that gets merged
- Example: `getItemProps({ item, index, disabled: item.unavailable })`
- Getters manage: ARIA attributes, keyboard handlers, click handlers, focus management, refs

## State Reducer Pattern
- Pass a `stateReducer` function to intercept and modify state changes
- Useful for: preventing certain transitions, custom multi-select logic, async validation
- Receives `(state, actionAndChanges)` — return modified changes object
- Return the changes object as-is to allow the transition, or modify it to alter behavior

## Controlled Props Pattern
- Every state value supports three forms: `prop` (fully controlled), `defaultProp` (uncontrolled with default), `initialProp` (uncontrolled, set once)
- Example: `isOpen`, `defaultIsOpen`, `initialIsOpen`
- `onStateChange` fires on every state change
- `onSelectedItemChange`, `onIsOpenChange`, `onHighlightedIndexChange`, `onInputValueChange` fire for specific changes
- The `stateChangeTypes` export enumerates all change types for explicit handling

## Common Combinations
- **useMultipleSelection + useCombobox:** multi-select search with dropdown — use `getDropdownProps` from useMultipleSelection on the combobox's root element
- **useMultipleSelection + useSelect:** multi-select from pick list — use `getDropdownProps` on the select's toggle button or wrapper
- **useCombobox + useEffect:** fetch items as user types (debounced) — control `inputValue` and fetch items based on it
- **useSelect** for simple dropdowns, **useCombobox** for search/autocomplete

## Accessibility
- ARIA 1.2 combobox/listbox patterns built-in
- Keyboard navigation (arrows, Enter, Escape, Home, End, PageUp, PageDown) handled automatically
- Type-ahead / character key search built-in (typing characters jump to matching items)
- Screen reader announcements via `getA11yStatusMessage` prop
- Focus management handled by the library
- `aria-activedescendant` tracked for virtual focus in listbox
- `aria-expanded`, `aria-haspopup`, `aria-labelledby` set automatically

## Element IDs
- The library auto-generates stable IDs (uses an incrementing counter internally)
- Override with `id`, `labelId`, `menuId`, `toggleButtonId`, `inputId` (useCombobox), `getItemId` (function)
- Call `resetIdCounter()` to restart IDs (SSR-safe, test-safe)

## Compatibility
- **Tailwind:** Excellent — style your own elements
- **react-bits:** Compatible — Downshift handles behavior, react-bits handles animation
- Any CSS solution works since you control all rendering
- React 17+ (React 18 supported)
- React Native support via `isReactNative` — onPress instead of onClick
- Preact support via `isPreact` — onInput instead of onChange

## Migration Notes
- `useMultipleSelection` is deprecated in favor of `useTagGroup` (migration guide: `src/hooks/useMultipleSelection/MIGRATION_GUIDE.md`)
- Migration guides exist for v7, v8, and v9 in `src/hooks/MIGRATION_V*.md`
