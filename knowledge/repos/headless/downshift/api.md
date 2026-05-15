# Downshift — API Reference

## Setup
```bash
npm install downshift
```

## Hooks (4 total)

### useSelect
- **Purpose:** Build custom select/dropdown components
- **Key props:** `items` (required), `selectedItem`, `defaultSelectedItem`, `initialSelectedItem`, `isOpen`, `defaultIsOpen`, `initialIsOpen`, `highlightedIndex`, `defaultHighlightedIndex`, `initialHighlightedIndex`, `onSelectedItemChange`, `onHighlightedIndexChange`, `onIsOpenChange`, `onStateChange`, `stateReducer`, `isItemDisabled`, `itemToString`, `itemToKey`, `id`, `labelId`, `menuId`, `toggleButtonId`, `getItemId`, `getA11yStatusMessage`, `scrollIntoView`, `environment`
- **Returned getter props:** `getToggleButtonProps`, `getMenuProps`, `getItemProps`, `getLabelProps`
- **Returned actions:** `toggleMenu`, `openMenu`, `closeMenu`, `setHighlightedIndex`, `selectItem`, `reset`, `setInputValue`
- **Returned state:** `isOpen`, `selectedItem`, `highlightedIndex`, `inputValue`
- **Usage:**
```jsx
const { isOpen, getToggleButtonProps, getMenuProps, getItemProps } = useSelect({ items })
return (
  <div>
    <button {...getToggleButtonProps()}>{selectedItem || 'Select'}</button>
    <ul {...getMenuProps()}>
      {isOpen && items.map((item, i) => (
        <li {...getItemProps({ item, index: i })} key={i}>{item}</li>
      ))}
    </ul>
  </div>
)
```

### useCombobox
- **Purpose:** Build autocomplete/combobox components (input + dropdown with filtering)
- **Key props:** `items` (required), `selectedItem`, `defaultSelectedItem`, `initialSelectedItem`, `inputValue`, `defaultInputValue`, `initialInputValue`, `isOpen`, `defaultIsOpen`, `initialIsOpen`, `highlightedIndex`, `defaultHighlightedIndex`, `initialHighlightedIndex`, `onSelectedItemChange`, `onInputValueChange`, `onHighlightedIndexChange`, `onIsOpenChange`, `onStateChange`, `stateReducer`, `isItemDisabled`, `itemToString`, `itemToKey`, `id`, `labelId`, `menuId`, `toggleButtonId`, `inputId`, `getItemId`, `getA11yStatusMessage`, `scrollIntoView`, `environment`
- **Returned getter props:** `getInputProps`, `getComboboxProps`, `getMenuProps`, `getItemProps`, `getToggleButtonProps`, `getLabelProps`
- **Returned actions:** `toggleMenu`, `openMenu`, `closeMenu`, `setHighlightedIndex`, `setInputValue`, `selectItem`, `reset`
- **Returned state:** `isOpen`, `selectedItem`, `inputValue`, `highlightedIndex`
- **Usage:** Similar pattern with `getInputProps` added for the text input

### useMultipleSelection (DEPRECATED — use `useTagGroup` instead)
- **Purpose:** Build multi-select components (tags, chips, selected items list)
- **Key props:** `selectedItems`, `defaultSelectedItems`, `initialSelectedItems`, `activeIndex`, `defaultActiveIndex`, `initialActiveIndex`, `onSelectedItemsChange`, `onActiveIndexChange`, `onStateChange`, `stateReducer`, `itemToKey`, `keyNavigationNext` (default `ArrowRight`), `keyNavigationPrevious` (default `ArrowLeft`), `environment`, `getA11yStatusMessage`
- **Returned getter props:** `getDropdownProps`, `getSelectedItemProps`
- **Returned actions:** `addSelectedItem`, `removeSelectedItem`, `setSelectedItems`, `setActiveIndex`, `reset`
- **Returned state:** `selectedItems`, `activeIndex`
- **Common pattern:** Combine with `useCombobox` or `useSelect` for full multi-select with dropdown

### useTagGroup (replacement for useMultipleSelection)
- **Purpose:** Modern multi-select with roving tabindex focus management
- **Key props:** `items`, `defaultItems`, `initialItems`, `selectedItems` (alias for items), `activeIndex`, `defaultActiveIndex`, `initialActiveIndex`, `onItemsChange`, `onActiveIndexChange`, `onStateChange`, `stateReducer`, `itemToKey`, `getTagId`, `getA11yStatusMessage`, `accessibleDescriptionText`, `environment`
- **Returned getter props:** `getTagGroupProps`, `getTagProps`, `getTagRemoveProps`
- **Returned actions:** `addTag`, `removeTag`, `setTags`, `setActiveIndex`, `reset`
- **Returned state:** `items` (selected items array), `activeIndex`
- **Common pattern:** Combine with `useCombobox` or `useSelect` for full multi-select with dropdown

### Downshift (Render Prop Component — Legacy)
- **Purpose:** Legacy API — the original component. Prefer hooks for new code.
- **Props:** children render function, `itemToString`, `onChange`, `stateReducer`, plus all dropdown shared props
- **Render prop receives:** `getInputProps`, `getItemProps`, `getMenuProps`, `getRootProps`, `getLabelProps`, `getToggleButtonProps` + all state (`isOpen`, `selectedItem`, `highlightedIndex`, `inputValue`)

## Shared Types / Exports
- `useSelect.stateChangeTypes` — enum of all state change types for the hook
- `useCombobox.stateChangeTypes` — enum of all state change types for the hook
- `useMultipleSelection.stateChangeTypes` — enum of all state change types for the hook
- `resetIdCounter()` — resets the internal ID counter (useful for SSR/test environments)
