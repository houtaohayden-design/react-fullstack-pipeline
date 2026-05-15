---
name: react-pipeline:styling-system
description: Use when making CSS/styling architecture decisions — guides framework choice, theme system design, responsive breakpoints, and design tokens.
---

# Styling System for React

## Core Principle
Choose one primary styling approach and be consistent. Mixing approaches (Tailwind + CSS modules + styled-components) leads to maintenance chaos.

## Framework Selection

| Approach | Best For | Bundle Impact | Learning Curve |
|----------|----------|---------------|----------------|
| **Tailwind CSS** | Most projects | ~3KB (purged) | Low-medium |
| **CSS Modules** | Teams avoiding utility CSS | 0 (built-in) | Low |
| **styled-components** | Dynamic styling | ~12KB | Medium |
| **Panda CSS** | Type-safe, zero-runtime | 0 (build-time) | Medium |
| **Vanilla Extract** | Type-safe, zero-runtime | 0 | Medium |

**Default recommendation:** Tailwind CSS for most projects. Fastest iteration, smallest bundle with purging.

## Theme System

### Design Tokens
```css
/* tokens.css */
:root {
  --color-primary: #3b82f6;
  --color-primary-hover: #2563eb;
  --color-bg: #ffffff;
  --color-text: #111827;
  --radius-sm: 4px;
  --radius-md: 8px;
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
}
```

### Tailwind Config
```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: { 500: '#3b82f6', 600: '#2563eb' }
      },
      borderRadius: { DEFAULT: '8px' }
    }
  }
}
```

## Responsive Breakpoints

```css
/* Mobile-first: start smallest, go up */
/* sm:640px  md:768px  lg:1024px  xl:1280px  2xl:1536px */

/* Tailwind */
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3">

/* CSS Modules */
.container { max-width: 100%; }
@media (min-width: 768px) { .container { max-width: 720px; } }
@media (min-width: 1024px) { .container { max-width: 960px; } }
```

## Integration with Knowledge Base

| Library | Styling Approach | How to Style |
|---------|-----------------|--------------|
| Shineout | Theme system (7 themes) | `<Shineout theme="antd">` |
| TanStack Table | Headless (no styles) | Add Tailwind classes to `<table>` |
| dnd-kit | Headless (no styles) | Add classes to `<div ref={setNodeRef}>` |
| framer-motion | Component props | `className` + `style` prop |
| react-bits | Inline + CSS vars | Override `--color` etc. |

## Pre-Implementation Checklist
- [ ] Primary styling approach chosen
- [ ] Design tokens defined (colors, spacing, radius, shadows)
- [ ] Responsive breakpoints established
- [ ] Dark mode strategy (if needed): `prefers-color-scheme` or toggle
- [ ] Font stack defined
- [ ] CSS reset/normalize included
