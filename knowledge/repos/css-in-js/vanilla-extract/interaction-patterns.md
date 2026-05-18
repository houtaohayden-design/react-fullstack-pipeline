# vanilla-extract Interaction Patterns

> vanilla-extract is a CSS-in-TypeScript library, not a component library. Interaction patterns described here reflect the CSS interaction primitives accessible through its type-safe API and recommended usage patterns for building interactive UIs.

## Pseudo-Selector Support

All standard CSS pseudo-classes and pseudo-elements are supported as camelCase object keys in `style()` rules. The library uses `csstype` for full type safety on CSS property values within these selectors.

### Hover States

```ts
const button = style({
  background: 'blue',
  color: 'white',
  transition: 'background 200ms ease',
  ':hover': {
    background: 'darkblue',
    transform: 'scale(1.05)'
  }
});
```

**Supported hover variants:**
- `':hover'` — mouse hover
- `':any-link'` — any link element
- Selector nesting: `selectors: { '&:hover': { ... } }` for complex hover targets

**Best practice:** Always pair hover with `transition` for smooth feedback. Use `@media (hover: hover)` to disable hover effects on touch devices:

```ts
const card = style({
  transform: 'scale(1)',
  transition: 'transform 300ms',
  ':hover': { transform: 'scale(1.02)' },
  '@media': {
    '(hover: none)': { ':hover': { transform: 'scale(1)' } }
  }
});
```

### Focus States

```ts
const input = style({
  border: '1px solid #ccc',
  outline: 'none',
  ':focus': {
    borderColor: 'blue',
    boxShadow: '0 0 0 3px rgba(0, 102, 255, 0.3)'
  },
  ':focus-visible': {
    outline: '2px solid blue',
    outlineOffset: '2px'
  },
  ':focus-within': {
    // Applied when any child has focus
  }
});
```

**Focus ring design tokens (recommended):**
```ts
export const focusRing = {
  outline: 'none',
  ':focus-visible': {
    outline: `2px solid ${vars.colors.primary}`,
    outlineOffset: '2px'
  }
};
```

**Supported focus variants:**
- `':focus'` — element has focus
- `':focus-visible'` — keyboard focus (not mouse click)
- `':focus-within'` — element or descendant has focus

### Active / Press States

```ts
const button = style({
  background: 'blue',
  transform: 'scale(1)',
  transition: 'all 100ms ease',
  ':active': {
    background: 'navy',
    transform: 'scale(0.97)'
  }
});
```

### Other Interactive Pseudo-Classes

| Pseudo-class | Usage |
|-------------|-------|
| `':disabled'` | Disabled controls |
| `':enabled'` | Enabled controls |
| `':checked'` | Checked radio/checkbox |
| `':indeterminate'` | Indeterminate checkbox |
| `':valid'` / `':invalid'` | Form validation |
| `':in-range'` / `':out-of-range'` | Numeric input range |
| `':required'` / `':optional'` | Required form fields |
| `':placeholder-shown'` | Placeholder visible |
| `':read-only'` / `':read-write'` | Editable state |
| `':empty'` | No children |
| `':first-child'` / `':last-child'` | Position selectors |
| `':first-of-type'` / `':last-of-type'` | Type position |
| `':only-child'` / `':only-of-type'` | Singular elements |
| `':target'` | Fragment target |
| `':link'` / `':visited'` | Link states |

### Pseudo-Elements

```ts
const tooltip = style({
  position: 'relative',
  '::after': {
    content: 'attr(data-tooltip)',
    position: 'absolute',
    opacity: 0,
    transition: 'opacity 200ms'
  },
  ':hover::after': { opacity: 1 }
});

const listItem = style({
  '::marker': { color: vars.colors.primary },
  '::before': { content: '""' },
  '::selection': { background: vars.colors.primary, color: 'white' }
});
```

**Supported pseudo-elements:** `::before`, `::after`, `::backdrop`, `::first-letter`, `::first-line`, `::marker`, `::placeholder`, `::selection`, `::file-selector-button`, `::cue`, `::grammar-error`, `::spelling-error`, `::view-transition`, `::view-transition-group`, `::view-transition-image-pair`, `::view-transition-old`, `::view-transition-new`, plus vendor-prefixed variants (`::-webkit-scrollbar`, `::-moz-placeholder`, etc.).

---

## Transitions & Animations

### CSS Transitions

```ts
const button = style({
  background: vars.colors.primary,
  color: 'white',
  transform: 'scale(1)',
  opacity: 1,
  transition: 'all 200ms cubic-bezier(0.4, 0, 0.2, 1)',
  ':hover': {
    background: vars.colors.accent,
    transform: 'scale(1.05)'
  },
  ':active': {
    transform: 'scale(0.97)'
  }
});
```

**Transition tokens (recommended pattern):**
```ts
// tokens.css.ts
export const motion = createGlobalThemeContract({
  duration: { fast: null, normal: null, slow: null },
  easing: { easeOut: null, easeInOut: null, spring: null }
}, (value) => `motion-${value}`);

createGlobalTheme(':root', motion, {
  duration: { fast: '150ms', normal: '300ms', slow: '500ms' },
  easing: {
    easeOut: 'cubic-bezier(0.16, 1, 0.3, 1)',
    easeInOut: 'cubic-bezier(0.65, 0, 0.35, 1)',
    spring: 'cubic-bezier(0.34, 1.56, 0.64, 1)'
  }
});
```

Usage:
```ts
style({ transition: `all ${motion.duration.normal} ${motion.easing.easeOut}` });
```

### CSS Keyframe Animations

```ts
import { keyframes, style } from '@vanilla-extract/css';

const fadeIn = keyframes({
  '0%': { opacity: 0, transform: 'translateY(10px)' },
  '100%': { opacity: 1, transform: 'translateY(0)' }
});

const slideUp = keyframes({
  from: { transform: 'translateY(100%)', opacity: 0 },
  to: { transform: 'translateY(0)', opacity: 1 }
});

export const animatedCard = style({
  animationName: fadeIn,
  animationDuration: '400ms',
  animationTimingFunction: 'ease-out',
  animationFillMode: 'both'
});
```

Global keyframes (shared across files, non-hashed name):
```ts
import { globalKeyframes } from '@vanilla-extract/css';

globalKeyframes('shared-spin', {
  '0%': { transform: 'rotate(0deg)' },
  '100%': { transform: 'rotate(360deg)' }
});

// Usage in any file
style({ animationName: 'shared-spin' });
```

### Transitions with Recipes

```ts
const accordionItem = recipe({
  base: {
    overflow: 'hidden',
    maxHeight: 0,
    opacity: 0,
    transition: 'max-height 300ms ease, opacity 300ms ease'
  },
  variants: {
    expanded: {
      true: { maxHeight: 1000, opacity: 1 },
      false: { maxHeight: 0, opacity: 0 }
    }
  }
});
```

### View Transitions API

```ts
import { createViewTransition } from '@vanilla-extract/css';

// Scoped view transition name
const cardVT = createViewTransition('card');

export const card = style({ viewTransitionName: cardVT });

// Global view transition styles
globalStyle('::view-transition-old(root)', { animationDuration: '300ms' });
globalStyle('::view-transition-new(root)', { animationDuration: '400ms' });
```

### @starting-style (CSS Transition on Mount)

```ts
const popover = style({
  opacity: 1,
  transform: 'scale(1)',
  transition: 'opacity 200ms, transform 200ms',
  '@starting-style': {
    opacity: 0,
    transform: 'scale(0.95)'
  }
});
```

---

## Gesture Handling Patterns

vanilla-extract only provides styling. Gesture logic lives in the framework layer. CSS states work with React event handlers:

```tsx
// Pressed state via CSS class toggle
const pressed = style({ transform: 'scale(0.97)', opacity: 0.8 });
const base = style({ transition: 'all 100ms ease' });

function PressableButton() {
  const [isPressed, setIsPressed] = useState(false);
  return (
    <button
      className={`${base} ${isPressed ? pressed : ''}`}
      onPointerDown={() => setIsPressed(true)}
      onPointerUp={() => setIsPressed(false)}
      onPointerLeave={() => setIsPressed(false)}
    >
      Press me
    </button>
  );
}
```

### Drag feedback
```ts
const dragging = style({
  opacity: 0.8,
  transform: 'scale(1.02)',
  boxShadow: '0 8px 24px rgba(0,0,0,0.15)',
  cursor: 'grabbing'
});
```

---

## Keyboard Navigation Patterns

### Focus ring via focus-visible

```ts
const interactive = style({
  outline: 'none',
  ':focus-visible': {
    outline: `2px solid ${vars.colors.primary}`,
    outlineOffset: '2px',
    borderRadius: vars.radii.sm
  }
});
```

### Skip link
```ts
const skipLink = style({
  position: 'absolute',
  top: '-100%',
  left: vars.space.md,
  padding: `${vars.space.sm} ${vars.space.md}`,
  background: vars.colors.primary,
  color: 'white',
  zIndex: 9999,
  ':focus': { top: vars.space.sm }
});
```

---

## Loading / Empty / Error States

### Skeleton Loading

```ts
import { keyframes, style } from '@vanilla-extract/css';

const shimmer = keyframes({
  '0%': { backgroundPosition: '-200% 0' },
  '100%': { backgroundPosition: '200% 0' }
});

export const skeleton = style({
  background: 'linear-gradient(90deg, #eee 25%, #f5f5f5 50%, #eee 75%)',
  backgroundSize: '200% 100%',
  animation: `${shimmer} 1.5s ease-in-out infinite`,
  borderRadius: vars.radii.sm,
  height: 16
});

// Skeleton variants
const skeletonVariants = styleVariants({
  text: [skeleton, { height: 16, width: '100%' }],
  title: [skeleton, { height: 24, width: '60%' }],
  avatar: [skeleton, { height: 48, width: 48, borderRadius: '50%' }],
  card: [skeleton, { height: 200, width: '100%' }]
});
```

### Empty State

```ts
const emptyState = style({
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  justifyContent: 'center',
  padding: vars.space.xl,
  color: vars.colors.textSecondary,
  textAlign: 'center',
  gap: vars.space.md
});

const emptyIcon = style({
  fontSize: 48,
  opacity: 0.3,
  marginBottom: vars.space.sm
});
```

### Error State

```ts
const errorBanner = style({
  background: '#fff0f0',
  border: '1px solid #ffcccc',
  color: '#cc0000',
  padding: `${vars.space.sm} ${vars.space.md}`,
  borderRadius: vars.radii.md
});
```

### Disabled/Loading Button

```ts
const button = recipe({
  base: {
    cursor: 'pointer',
    transition: 'all 200ms ease',
    ':disabled': {
      opacity: 0.5,
      cursor: 'not-allowed',
      transform: 'none'
    }
  },
  variants: {
    loading: {
      true: {
        color: 'transparent',
        position: 'relative',
        pointerEvents: 'none'
      }
    }
  }
});
```

---

## Feedback Patterns

### Toast / Notification enter/exit

```ts
const toastEnter = keyframes({
  from: { transform: 'translateX(100%)', opacity: 0 },
  to: { transform: 'translateX(0)', opacity: 1 }
});

const toastExit = keyframes({
  from: { transform: 'translateX(0)', opacity: 1 },
  to: { transform: 'translateX(100%)', opacity: 0 }
});

export const toast = style({
  animation: `${toastEnter} 300ms ${motion.easing.easeOut} both`
});

export const toastExiting = style({
  animation: `${toastExit} 200ms ${motion.easing.easeIn} both`
});
```

### Validation Feedback

```ts
const input = style({
  border: `1px solid ${vars.colors.border}`,
  transition: 'border-color 200ms, box-shadow 200ms',
  ':focus': {
    borderColor: vars.colors.primary,
    boxShadow: `0 0 0 3px ${vars.colors.primary}20`
  },
  selectors: {
    '&[data-invalid="true"]': {
      borderColor: 'red',
      boxShadow: '0 0 0 3px rgba(255,0,0,0.1)'
    },
    '&[data-valid="true"]': {
      borderColor: 'green'
    }
  }
});
```

---

## Motion Tokens (via CSS Custom Properties)

```ts
// motion-tokens.css.ts
import { createGlobalTheme } from '@vanilla-extract/css';

export const motionVars = createGlobalTheme(':root', {
  duration: {
    instant: '50ms',
    fast: '150ms',
    normal: '300ms',
    slow: '500ms',
    glacial: '1000ms'
  },
  easing: {
    default: 'ease',
    easeIn: 'cubic-bezier(0.4, 0, 1, 1)',
    easeOut: 'cubic-bezier(0, 0, 0.2, 1)',
    easeInOut: 'cubic-bezier(0.4, 0, 0.2, 1)',
    spring: 'cubic-bezier(0.175, 0.885, 0.32, 1.275)',
    bounce: 'cubic-bezier(0.68, -0.55, 0.265, 1.55)'
  }
});
```

Duration scale: 50ms (micro-interactions) → 150ms (hover/active) → 300ms (enter/exit) → 500ms (page transitions) → 1000ms (reveals).

---

## Reduced Motion

```ts
const animatedElement = style({
  transition: 'transform 300ms',
  '@media': {
    '(prefers-reduced-motion: reduce)': {
      transition: 'none',
      animation: 'none'
    }
  }
});
```

Global reduced-motion reset:
```ts
globalStyle('@media (prefers-reduced-motion: reduce)', {
  '*, *::before, *::after': {
    animationDuration: '0.01ms !important',
    animationIterationCount: '1 !important',
    transitionDuration: '0.01ms !important'
  }
});
```

---

## Sprinkles Conditional Interactions

Responsive + conditional interaction values via sprinkles:

```ts
const interactionProps = defineProperties({
  conditions: {
    base: {},
    hover: { selector: '&:hover' },
    focus: { selector: '&:focus-visible' },
    active: { selector: '&:active' }
  },
  defaultCondition: 'base',
  properties: {
    transform: {
      none: 'none',
      scaleUp: 'scale(1.05)',
      scaleDown: 'scale(0.97)',
      lift: 'translateY(-2px)'
    },
    opacity: { full: '1', dim: '0.7', hidden: '0' },
    boxShadow: {
      none: 'none',
      sm: '0 1px 3px rgba(0,0,0,0.1)',
      md: '0 4px 12px rgba(0,0,0,0.15)',
      lg: '0 8px 24px rgba(0,0,0,0.2)'
    }
  }
});

// Usage
sprinkles({
  transform: { base: 'none', hover: 'scaleUp', active: 'scaleDown' },
  boxShadow: { base: 'sm', hover: 'md' }
});
```
