# Tailwind CSS v4 — Common Patterns

> Extracted from the Tailwind CSS v4 source code (packages/tailwindcss/src/utilities.ts, variants.ts, theme.css, index.css)

## Responsive Design

### Breakpoint Variants

Breakpoints are registered from the `--breakpoint-*` theme namespace as **static variants** — each generates a `@media (width >= {value})` wrapper:

| Variant | Default Value | CSS Output |
|---------|---------------|------------|
| `sm:` | 640px (40rem) | `@media (width >= 40rem)` |
| `md:` | 768px (48rem) | `@media (width >= 48rem)` |
| `lg:` | 1024px (64rem) | `@media (width >= 64rem)` |
| `xl:` | 1280px (80rem) | `@media (width >= 80rem)` |
| `2xl:` | 1536px (96rem) | `@media (width >= 96rem)` |

Custom breakpoints are defined in `@theme`:
```css
@theme {
  --breakpoint-tablet: 960px;
  --breakpoint-desktop: 1440px;
}
/* Usage: tablet:flex desktop:grid */
```

### Directional Responsive Variants

- `min-{breakpoint}:` — `@media (width >= {value})` — any arbitrary or named breakpoint
- `max-{breakpoint}:` — `@media (width < {value})` — max-width queries
- `min-[800px]:`, `max-[1200px]:` — arbitrary width values

### Sorting

Breakpoint variants are sorted by their resolved pixel values. `min-*` sorts ascending; `max-*` sorts descending. This ensures the cascade order in generated CSS is always correct regardless of source order.

### Mobile-First Pattern

Since all breakpoints use `width >=`, the mobile-first approach is natural:

```html
<!-- Mobile: stacked, md: row, lg: 3-column -->
<div class="flex flex-col md:flex-row lg:grid lg:grid-cols-3">
```

To target mobile-only, use `max-*`:
```html
<!-- Only on screens below md (768px) -->
<div class="max-md:hidden">
```

## Dark Mode

### Media-Based (default)
```html
<div class="bg-white dark:bg-gray-900">
```
Generates: `@media (prefers-color-scheme: dark) { .dark\:bg-gray-900 { ... } }`

### Class-Based Strategy

In v4, class-based dark mode requires a custom variant:

```css
@custom-variant dark (&:where(.dark, .dark *));
```

Then toggle a `.dark` class on `<html>` or a parent element.

## Component Extraction Patterns

### Pattern 1: @apply (CSS-first)

```css
@layer components {
  .btn {
    @apply inline-flex items-center justify-center px-4 py-2
           rounded-lg font-medium transition-colors duration-150;
  }
  .btn-primary {
    @apply btn bg-blue-500 text-white hover:bg-blue-600
           focus-visible:ring-2 focus-visible:ring-blue-500;
  }
}
```

**When to use**: Multi-use component classes that need consistent styling across many elements.

### Pattern 2: @utility (Custom utility)

```css
@utility scrollbar-thin {
  scrollbar-width: thin;
  scrollbar-color: var(--color-gray-300) transparent;
}

@utility content-auto {
  content-visibility: auto;
}
```

**When to use**: Single-property utilities that you want available everywhere, or project-specific utilities that don't exist in core Tailwind.

### Pattern 3: Component Classes (no @apply)

```html
<!-- Component class + utilities -->
<button class="btn bg-blue-500 text-white hover:bg-blue-600">
```

Define `btn` as a shared base, then compose with utilities for variants. This is the idiomatic Tailwind approach and avoids the specificity issues of `@apply`.

### Pattern 4: CSS-only components

```css
@layer components {
  .card {
    display: grid;
    gap: var(--spacing-4, 1rem);
    padding: var(--spacing-6, 1.5rem);
    border-radius: var(--radius-xl, 0.75rem);
    background: var(--color-white);
    box-shadow: var(--shadow-md);
  }
}
```

Using `theme()` or `var()` for design tokens keeps components in sync with the design system.

## Layout Patterns

### Flex Patterns

```html
<!-- Centered content -->
<div class="flex items-center justify-center h-screen">

<!-- Holy grail: sticky header + scrollable content + fixed footer -->
<div class="flex flex-col min-h-screen">
  <header class="sticky top-0">...</header>
  <main class="flex-1">...</main>
  <footer>...</footer>
</div>

<!-- Sidebar layout -->
<div class="flex">
  <aside class="w-64 shrink-0">Sidebar</aside>
  <main class="flex-1">Content</main>
</div>

<!-- Responsive nav -->
<nav class="flex flex-col md:flex-row md:items-center md:gap-6">
```

### Grid Patterns

```html
<!-- Responsive card grid -->
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">

<!-- Dashboard layout -->
<div class="grid grid-cols-12 gap-4">
  <aside class="col-span-12 lg:col-span-3">Sidebar</aside>
  <main class="col-span-12 lg:col-span-6">Content</main>
  <aside class="col-span-12 lg:col-span-3">Right panel</aside>
</div>

<!-- Auto-fit (no media queries needed) -->
<div class="grid grid-cols-[repeat(auto-fit,minmax(300px,1fr))] gap-6">

<!-- Centered single column with max-width -->
<div class="grid place-items-center min-h-screen">
  <div class="max-w-md w-full">...</div>
</div>

<!-- Subgrid for aligned cards -->
<div class="grid grid-cols-3 gap-4">
  <div class="grid grid-rows-subgrid row-span-3">
```

### Container Pattern

```html
<div class="container mx-auto px-4">
```

The `container` utility:
- Sets `width: 100%` at all breakpoints
- Uses `max-width` matching each breakpoint
- Centers with `mx-auto`

Customize container sizes via `--container-*` theme keys.

## Spacing Patterns

### Consistent Vertical Rhythm

```html
<section class="space-y-16 py-16">
  <div class="space-y-4">
    <h2 class="text-3xl font-bold">Section Title</h2>
    <p class="text-gray-600">Description text</p>
  </div>
  <!-- More content -->
</section>
```

### Inline Spacing

```html
<!-- Horizontal spacing between inline elements -->
<div class="flex gap-4">
  <span>Item 1</span><span>Item 2</span><span>Item 3</span>
</div>

<!-- Or use space-x on flex-col children (legacy pattern) -->
<div class="flex space-x-4">
```

### Padding vs Margin

- Use **padding** for internal spacing (inside cards, sections, inputs)
- Use **margin** for external spacing (between components)
- Use **gap** for flex/grid container child spacing (preferred over margin on children)
- Use **space-y/space-x** for legacy flex child spacing

## Typography Patterns

### Fluid Typography

```html
<!-- Using arbitrary values with clamp -->
<h1 class="text-[clamp(2rem,5vw,4rem)] leading-tight">

<!-- Or define as a theme utility -->
```
```css
@theme {
  --text-fluid-hero: clamp(2rem, 5vw, 4rem);
  --text-fluid-hero--line-height: 1.1;
}
```
```html
<h1 class="text-fluid-hero">...</h1>
```

### Heading Hierarchy

```html
<h1 class="text-4xl md:text-5xl lg:text-6xl font-bold tracking-tight">
<h2 class="text-2xl md:text-3xl font-semibold tracking-tight">
<h3 class="text-xl font-semibold">
<p class="text-base text-gray-600 leading-relaxed">
```

### Prose / Reading Layout

```html
<article class="prose lg:prose-lg max-w-none">
  <!-- With @tailwindcss/typography plugin -->
</article>

<!-- Without plugin -->
<article class="max-w-[65ch] mx-auto text-base leading-relaxed space-y-4">
```

The deprecated `--max-width-prose: 65ch` theme key is still available for reference.

### Gradient Text

```html
<h1 class="bg-linear-to-r from-blue-500 to-purple-500 bg-clip-text text-transparent">
```

### Text Shadow

```html
<h1 class="text-shadow-sm">Subtle shadow</h1>
<h2 class="text-shadow-lg">Prominent shadow</h2>
```

## Theming with CSS Variables

### Multi-Theme Pattern

```css
@theme {
  --color-surface: var(--surface-light);
  --color-text: var(--text-light);
}

:root {
  --surface-light: oklch(98% 0 0);
  --text-light: oklch(18% 0 0);
  --surface-dark: oklch(15% 0 0);
  --text-dark: oklch(90% 0 0);
}

.dark {
  --color-surface: var(--surface-dark);
  --color-text: var(--text-dark);
}
```

This indirection allows theme switching by changing a single class without modifying the utility classes.

### Brand Color Token Pattern

```css
@theme {
  --color-primary: oklch(62.3% 0.214 259.815);    /* blue-500 */
  --color-primary-dark: oklch(48.8% 0.243 264.376); /* blue-700 */
  --color-primary-light: oklch(93.2% 0.032 255.585); /* blue-100 */
  --color-accent: oklch(70.5% 0.213 47.604);       /* orange-500 */
  --color-success: oklch(72.3% 0.219 149.579);     /* green-500 */
  --color-warning: oklch(76.9% 0.188 70.08);       /* amber-500 */
  --color-danger: oklch(63.7% 0.237 25.331);       /* red-500 */
}
```

Usage: `bg-primary`, `text-primary-dark`, `border-accent`, etc.

## Plugin System Patterns

### Creating a v4 Plugin

```ts
// plugin.ts
const plugin = ({ addUtilities, addVariant, theme }) => {
  addUtilities({
    '.scrollbar-thin': {
      'scrollbar-width': 'thin',
      'scrollbar-color': `${theme('colors.gray.300')} transparent`,
    },
  })

  addVariant('hocus', ['&:hover', '&:focus'])
}

export default plugin
```

## Optimization Patterns

### Performance

- Use `hidden` + breakpoint variants for conditional rendering instead of JS state when possible
- Prefer `gap` over `space-y` for flex/grid (fewer CSS rules)
- Avoid deeply nested component variants (compounds have compile-time cost)
- Use `@utility` for frequently repeated custom declarations

### File Organization

```css
/* main.css */
@import "tailwindcss";
@import "./tokens/colors.css";
@import "./tokens/typography.css";
@import "./components/buttons.css";
@import "./components/cards.css";
@import "./utilities/scrollbar.css";
```

### CSS Cascade Strategy

```css
@layer base {
  /* Element defaults */
  h1 { @apply text-4xl font-bold; }
}

@layer components {
  /* Multi-utility compositions */
  .btn { @apply px-4 py-2 rounded font-medium; }
}

@layer utilities {
  /* Single-property utilities */
  .scrollbar-gutter-stable { scrollbar-gutter: stable; }
}
```

## Migrating from v3 to v4

### Key Changes

1. **CSS-based config replaces JS config**: `@theme` replaces `tailwind.config.js`
2. **No `content` array**: Use `@source` directive or auto-detection
3. **CSS imports replace directives**: `@import "tailwindcss"` replaces `@tailwind base/components/utilities`
4. **Theme uses CSS variables**: `--color-*` instead of `theme.colors`
5. **Opacity modifier syntax**: `bg-red-500/50` uses CSS variable opacity, no longer `bg-opacity-50`
6. **Simplified gradient**: `bg-linear-to-r` instead of `bg-gradient-to-r`
7. **Rust-based scanner**: Faster, no `purge`/`safelist` needed
