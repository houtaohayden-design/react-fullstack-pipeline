# vanilla-extract Design Tokens

> vanilla-extract does not ship with built-in design tokens. Instead, it provides **first-class APIs** for defining type-safe design tokens via `createThemeContract`, `createGlobalTheme`, and `createTheme`. Below is the canonical token architecture and recommended token scales derived from the library's API design and ecosystem patterns.

## Token Architecture

### The Contract Pattern

The library's core design token concept is the **theme contract** — a typed interface defining the shape of tokens without assigning values:

```ts
// contract.css.ts
import { createThemeContract } from '@vanilla-extract/css';

export const vars = createThemeContract({
  colors: {
    background: null,
    surface: null,
    text: { primary: null, secondary: null, muted: null },
    brand: { primary: null, accent: null },
    border: null,
    status: { success: null, warning: null, error: null, info: null }
  },
  space: {
    '0': null, xs: null, sm: null, md: null, lg: null, xl: null, '2xl': null, '3xl': null
  },
  typography: {
    fontFamily: { body: null, heading: null, mono: null },
    fontSize: { xs: null, sm: null, base: null, lg: null, xl: null, '2xl': null, '3xl': null, '4xl': null },
    fontWeight: { normal: null, medium: null, semibold: null, bold: null },
    lineHeight: { tight: null, normal: null, relaxed: null, loose: null }
  },
  radii: { none: null, sm: null, md: null, lg: null, full: null },
  shadows: { sm: null, md: null, lg: null, xl: null },
  zIndices: { base: null, dropdown: null, sticky: null, modal: null, toast: null },
  breakpoints: { tablet: null, desktop: null, wide: null }
});
```

Each `null` leaf becomes a CSS custom property like `var(--colors-background-xxx)`, fully type-safe in consuming code.

### Token Resolution Flow

```
createThemeContract(tokens) → typed CSS var() references
    ↓
createGlobalTheme(':root', tokens)  → assigns values to :root, auto-creates contract
    OR
createTheme(contract, values)       → creates theme class scoped to the class
    ↓
style({ color: vars.text.primary }) → consumes token → var(--text-primary-xxx)
    ↓
Build time: CSS output with real custom properties + fallbacks
```

---

## Color Palette

### Semantic Color Architecture

The recommended token tree follows a 3-layer architecture:

```
LAYER 1: Raw palette (not exported as tokens)
  blue: { 50, 100, 200, ... 900 }
  gray: { 50, 100, 200, ... 900 }
  red: { 400, 500 }
  green: { 400, 500 }
  yellow: { 400, 500 }

LAYER 2: Semantic tokens (contract)
  colors: {
    background        → gray.50  / gray.950 (dark)
    surface           → white    / gray.900
    text.primary      → gray.900 / gray.50
    text.secondary    → gray.600 / gray.400
    text.muted        → gray.400 / gray.500
    brand.primary     → blue.500
    brand.accent      → purple.500
    border            → gray.200 / gray.700
    status.success    → green.500
    status.warning    → yellow.500
    status.error      → red.500
    status.info       → blue.400
  }

LAYER 3: Component-level (derived in style rules)
  button.bg       → vars.colors.brand.primary
  button.text     → white
  input.border    → vars.colors.border
  input.focusRing → vars.colors.brand.primary
```

### Common Color System (Recommended Defaults)

```ts
export const lightColors = {
  background: '#ffffff',
  surface: '#f8f9fa',
  text: {
    primary: '#111827',
    secondary: '#6b7280',
    muted: '#9ca3af'
  },
  brand: {
    primary: '#3b82f6',
    primaryHover: '#2563eb',
    accent: '#8b5cf6'
  },
  border: '#e5e7eb',
  status: {
    success: '#10b981',
    warning: '#f59e0b',
    error: '#ef4444',
    info: '#3b82f6'
  }
};

export const darkColors = {
  background: '#111827',
  surface: '#1f2937',
  text: {
    primary: '#f9fafb',
    secondary: '#9ca3af',
    muted: '#6b7280'
  },
  brand: {
    primary: '#60a5fa',
    primaryHover: '#3b82f6',
    accent: '#a78bfa'
  },
  border: '#374151',
  status: {
    success: '#34d399',
    warning: '#fbbf24',
    error: '#f87171',
    info: '#60a5fa'
  }
};
```

---

## Typography Scale

### Font Family

```ts
fonts: {
  body: "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
  heading: "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
  mono: "'JetBrains Mono', 'Fira Code', 'Cascadia Code', monospace"
}
```

### Font Size Scale (Modular Scale 1.25)

| Token | Size | Line Height | Usage |
|-------|------|-------------|-------|
| `xs` | 0.75rem (12px) | 1rem (16px) | Captions, labels |
| `sm` | 0.875rem (14px) | 1.25rem (20px) | Small body, help text |
| `base` | 1rem (16px) | 1.5rem (24px) | Body text |
| `lg` | 1.125rem (18px) | 1.75rem (28px) | Large body, lead |
| `xl` | 1.25rem (20px) | 1.75rem (28px) | h4 |
| `2xl` | 1.5rem (24px) | 2rem (32px) | h3 |
| `3xl` | 1.875rem (30px) | 2.25rem (36px) | h2 |
| `4xl` | 2.25rem (36px) | 2.5rem (40px) | h1 |
| `5xl` | 3rem (48px) | 1 | Hero title |

```ts
fontSize: {
  xs: '0.75rem', sm: '0.875rem', base: '1rem',
  lg: '1.125rem', xl: '1.25rem', '2xl': '1.5rem',
  '3xl': '1.875rem', '4xl': '2.25rem', '5xl': '3rem'
},
lineHeight: {
  tight: '1.25',   // Headings
  normal: '1.5',   // Body
  relaxed: '1.75', // Lead paragraphs
  loose: '2'       // Large text blocks
}
```

### Font Weight

```ts
fontWeight: {
  normal: '400',
  medium: '500',
  semibold: '600',
  bold: '700'
}
```

### Font Face (via vanilla-extract API)

```ts
import { fontFace, globalFontFace } from '@vanilla-extract/css';

// Scoped font (hashed name)
const interFont = fontFace([
  { src: 'url("/fonts/Inter-Regular.woff2")', fontWeight: 400 },
  { src: 'url("/fonts/Inter-Bold.woff2")', fontWeight: 700 }
]);

// Global font
globalFontFace('JetBrains Mono', {
  src: 'url("/fonts/JetBrainsMono.woff2")',
  fontWeight: 400
});
```

---

## Spacing Scale

Based on a 4px grid unit:

| Token | Value | px | Usage |
|-------|-------|----|-------|
| `0` | 0 | 0px | No spacing |
| `xs` | 0.25rem | 4px | Tight inline spacing |
| `sm` | 0.5rem | 8px | Compact padding |
| `md` | 1rem | 16px | Default padding |
| `lg` | 1.5rem | 24px | Section inner padding |
| `xl` | 2rem | 32px | Section spacing |
| `2xl` | 3rem | 48px | Large section spacing |
| `3xl` | 4rem | 64px | Page-level spacing |

```ts
space: {
  '0': '0',
  xs: '0.25rem',  sm: '0.5rem', md: '1rem',
  lg: '1.5rem',   xl: '2rem',   '2xl': '3rem', '3xl': '4rem'
}
```

---

## Border Radius Scale

| Token | Value | Usage |
|-------|-------|-------|
| `none` | 0 | Sharp edges |
| `sm` | 2px | Inputs, small elements |
| `md` | 4px | Buttons, cards |
| `lg` | 8px | Cards, modals |
| `xl` | 12px | Large containers |
| `2xl` | 16px | Panels, sheets |
| `full` | 9999px | Pill shapes, avatars |

```ts
radii: {
  none: '0',
  sm: '2px', md: '4px', lg: '8px',
  xl: '12px', '2xl': '16px', full: '9999px'
}
```

---

## Shadow / Elevation

```ts
shadows: {
  none: 'none',
  xs: '0 1px 2px rgba(0, 0, 0, 0.05)',
  sm: '0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06)',
  md: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1)',
  lg: '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1)',
  xl: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1)',
  '2xl': '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
  inner: 'inset 0 2px 4px 0 rgba(0, 0, 0, 0.06)'
}
```

Dark mode shadows use darker color:
```ts
darkShadows: {
  sm: '0 1px 3px rgba(0, 0, 0, 0.4), 0 1px 2px rgba(0, 0, 0, 0.3)',
  md: '0 4px 6px -1px rgba(0, 0, 0, 0.4), 0 2px 4px -2px rgba(0, 0, 0, 0.3)'
}
```

---

## Breakpoints (for Sprinkles responsive conditions)

```ts
breakpoints: {
  mobile: {},                                       // default (no media query)
  tablet: { '@media': 'screen and (min-width: 768px)' },
  desktop: { '@media': 'screen and (min-width: 1024px)' },
  wide: { '@media': 'screen and (min-width: 1280px)' }
}

// Sprinkle responsive array order
responsiveArray: ['mobile', 'tablet', 'desktop', 'wide']
```

| Breakpoint | Width | Typical Devices |
|------------|-------|-----------------|
| mobile | < 768px | Phones |
| tablet | >= 768px | Tablets, small laptops |
| desktop | >= 1024px | Laptops, desktops |
| wide | >= 1280px | Large monitors |

Recommended responsive array length: 2–4 breakpoints (2 for simple, 4 for complex). Maximum supported by Sprinkles types: 8.

---

## Z-Index Scale

```ts
zIndices: {
  base: '0',
  raised: '1',        // Slightly elevated (cards)
  dropdown: '100',    // Dropdown menus, popovers
  sticky: '200',      // Sticky headers
  overlay: '300',     // Overlays, drawers
  modal: '400',       // Modals, dialogs
  toast: '500',       // Toast notifications
  tooltip: '600'      // Tooltips (above all)
}
```

| Token | Value | Usage |
|-------|-------|-------|
| `base` | 0 | Default stacking |
| `raised` | 1 | Elevated cards |
| `dropdown` | 100 | Select menus, autocomplete |
| `sticky` | 200 | Sticky nav bars |
| `overlay` | 300 | Sheet backdrops |
| `modal` | 400 | Dialog backdrops |
| `toast` | 500 | Notification toasts |
| `tooltip` | 600 | Floating tooltips |

---

## Animation Duration & Easing Tokens

```ts
motion: {
  duration: {
    instant: '50ms',    // Micro-interactions (ripple, check)
    fast: '150ms',      // Hover on/off, active press
    normal: '300ms',    // Enter/exit, toggle, expand
    slow: '500ms',      // Page transitions, modal open/close
    glacial: '1000ms'   // Reveals, hero animations
  },
  easing: {
    default: 'ease',
    linear: 'linear',
    easeIn: 'cubic-bezier(0.4, 0, 1, 1)',
    easeOut: 'cubic-bezier(0, 0, 0.2, 1)',
    easeInOut: 'cubic-bezier(0.4, 0, 0.2, 1)',
    // Custom expressive curves
    spring: 'cubic-bezier(0.175, 0.885, 0.32, 1.275)',
    bounce: 'cubic-bezier(0.68, -0.55, 0.265, 1.55)',
    smooth: 'cubic-bezier(0.65, 0, 0.35, 1)',
    decelerate: 'cubic-bezier(0, 0, 0.35, 1)',
    accelerate: 'cubic-bezier(0.4, 0, 0.8, 1)'
  }
}
```

Duration pairing guide:
| Interaction | Duration | Easing |
|-------------|----------|--------|
| Hover on | 150ms | easeOut |
| Hover off | 150ms | easeIn |
| Active press | 50ms | ease |
| Enter (appear) | 300ms | easeOut |
| Exit (disappear) | 200ms | easeIn |
| Modal open | 300ms | spring |
| Modal close | 200ms | easeIn |
| Page transition | 500ms | smooth |
| Scroll reveal | 500-1000ms | easeOut |
| Notification slide | 300ms | bounce |
| Expand/collapse | 300ms | easeInOut |

---

## Dark Mode Architecture

vanilla-extract supports two dark mode patterns:

### Pattern A: Theme Class Toggle (recommended)

```ts
// Uses a class on a container element to switch themes
<div className={isDark ? darkTheme : lightTheme}>
  <App />
</div>
```

Full theme replacement via `createTheme`. Each theme is a separate CSS class with its own variable assignments. Only the active theme's variables are applied.

**Advantage:** All tokens change atomically. No per-property overrides needed.

### Pattern B: System Preference (prefers-color-scheme)

```ts
const systemDark = style({
  '@media': {
    '(prefers-color-scheme: dark)': {
      // Override specific variables
      vars: assignVars(vars, {
        colors: darkColors
      })
    }
  }
});
```

Or via `globalStyle`:
```ts
globalStyle(':root', {
  vars: assignVars(vars, lightTokens),
  '@media': {
    '(prefers-color-scheme: dark)': {
      vars: assignVars(vars, darkTokens)
    }
  }
});
```

### Dark Mode Color Mapping

| Semantic Token | Light Value | Dark Value |
|---------------|-------------|------------|
| `background` | `#ffffff` | `#111827` |
| `surface` | `#f8f9fa` | `#1f2937` |
| `text.primary` | `#111827` | `#f9fafb` |
| `text.secondary` | `#6b7280` | `#9ca3af` |
| `border` | `#e5e7eb` | `#374151` |
| Shadow (sm) | `rgba(0,0,0,0.1)` | `rgba(0,0,0,0.4)` |

---

## CSS @property Type Declarations

vanilla-extract supports `@property` rules for typed/animated custom properties:

```ts
import { createVar, createGlobalVar } from '@vanilla-extract/css';

// Registered property (animatable)
const gradientAngle = createVar(
  { syntax: '<angle>', inherits: false, initialValue: '0deg' },
  'gradient-angle'
);

// Global
createGlobalVar('--accent-hue', {
  syntax: '<number>',
  inherits: true,
  initialValue: '220'
});
```

| Syntax Type | Description |
|-------------|-------------|
| `<color>` | Color values |
| `<length>` | Length values (px, rem, etc.) |
| `<percentage>` | Percentage values |
| `<number>` | Numeric values |
| `<angle>` | Angle values (deg, rad) |
| `<time>` | Time values (s, ms) |
| `<length-percentage>` | Length or percentage |
| `<transform-function>` | Transform functions |
| `*` | Any value (default) |

---

## CSS Layers

```ts
import { globalLayer, layer } from '@vanilla-extract/css';

// Define layer order (global)
globalLayer('reset');
globalLayer('base');
globalLayer('components');
globalLayer('utilities');

// Create styles within a layer
const resetLayer = globalLayer('reset');
const tokenLayer = layer({ parent: 'base' }, 'tokens');
```

Recommended layer stack:
```
@layer reset, tokens, base, components, layouts, utilities, overrides;
```

---

## Sprinkles Token Configuration

For atomic CSS, tokens become Sprinkles property definitions:

```ts
const layoutTokens = defineProperties({
  properties: {
    padding: vars.space,    // Reuse same space scale
    margin: vars.space,
    gap: vars.space,
    borderRadius: vars.radii,
    boxShadow: vars.shadows,
    zIndex: vars.zIndices
  }
});
```

This reuses the same token scales defined in the contract, ensuring consistency between utility-first and component-level styling.
