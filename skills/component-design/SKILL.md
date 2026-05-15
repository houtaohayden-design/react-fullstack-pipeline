---
name: react-pipeline:component-design
description: Use when designing a new React component — guides props interface design, composition patterns, accessibility, and performance considerations.
---

# Component Design for React

## Core Principle
Design the component API before implementing it. Good props interfaces prevent refactors. Consider: what goes in (props), what comes out (events), and what's inside (composition).

## Props Design

### Required vs Optional
```tsx
interface ButtonProps {
  // Required: component can't function without it
  children: React.ReactNode

  // Optional with sensible default
  variant?: 'primary' | 'secondary' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
  disabled?: boolean
  loading?: boolean

  // Events: use onXxx naming
  onClick?: () => void

  // Pass-through: for HTML attributes
  className?: string
  id?: string
}
```

### Extension Pattern
```tsx
// Extend native HTML when wrapping a native element
interface InputProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'size'> {
  label: string
  error?: string
  size?: 'sm' | 'md' | 'lg'
}
```

## Composition Patterns

### Pattern 1: Compound Components
```tsx
<Select value={val} onChange={setVal}>
  <Select.Trigger />
  <Select.Options>
    <Select.Option value="a">Option A</Select.Option>
  </Select.Options>
</Select>
```

### Pattern 2: Render Props
```tsx
<DataLoader url="/api/users">
  {({ data, loading, error }) => (
    loading ? <Skeleton /> : error ? <Error /> : <List items={data} />
  )}
</DataLoader>
```

### Pattern 3: Slot-based
```tsx
<Card>
  <Card.Header>Title</Card.Header>
  <Card.Body>Content</Card.Body>
  <Card.Footer><Button>Action</Button></Card.Footer>
</Card>
```

## Accessibility Checklist
- [ ] Interactive elements use `<button>`, not `<div onClick>`
- [ ] Images have `alt` text (or `alt=""` for decorative)
- [ ] Form inputs have associated `<label>`
- [ ] Keyboard: Tab order logical, Enter/Space work on buttons
- [ ] Screen reader: `aria-label` on icon-only buttons
- [ ] Color: Not the only way to convey information

## Performance Considerations
- **React.memo** for list items and frequently re-rendered components
- **useMemo** for expensive derivations (filtering, sorting large arrays)
- **useCallback** for callbacks passed to memo'd children
- **Lazy loading** for below-fold / route-level components

## Before Implementation
1. Check `knowledge/registry.json` — does a trained repo already solve this?
2. Write the props interface in TypeScript
3. Get approval on the design
4. Then implement with `react-pipeline:tdd`
