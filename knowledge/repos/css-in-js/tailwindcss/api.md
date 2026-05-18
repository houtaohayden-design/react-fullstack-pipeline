# Tailwind CSS v4 — API Reference

> Extracted from https://github.com/tailwindlabs/tailwindcss (v4.x, 80k+ stars)
> Source files: `packages/tailwindcss/src/index.ts`, `theme.ts`, `utilities.ts`, `variants.ts`, `design-system.ts`, `theme.css`

## Overview

Tailwind CSS is a utility-first CSS framework that scans your markup and generates CSS on demand through a JIT (Just-In-Time) compiler. Version 4 is a complete rewrite using a Rust-based engine (`oxide`) for the parser/scanner, with the CSS generator remaining in TypeScript. It uses CSS-based configuration via `@theme` instead of JavaScript `tailwind.config.js`.

## Setup (v4)

### Installation
```bash
npm install tailwindcss @tailwindcss/vite
```

### Vite Configuration
```ts
// vite.config.ts
import tailwindcss from '@tailwindcss/vite'
import { defineConfig } from 'vite'

export default defineConfig({
  plugins: [tailwindcss()],
})
```

### PostCSS Configuration (alternative)
```js
// postcss.config.js
export default {
  plugins: {
    '@tailwindcss/postcss': {},
  },
}
```

### Entry CSS
```css
@import "tailwindcss";
```

The `@import "tailwindcss"` directive automatically loads:
- `@tailwind base` — CSS reset (preflight)
- `@tailwind components` — container class
- `@tailwind utilities` — all utility classes

## Configuration (`tailwind.config` equivalent)

In v4, configuration is done via CSS, not JavaScript. The `@theme` directive replaces `tailwind.config.js`:

```css
@import "tailwindcss";

@theme {
  --color-primary: oklch(62.3% 0.214 259.815);
  --color-primary-dark: oklch(48.8% 0.243 264.376);
  --font-display: "Clash Display", sans-serif;
  --breakpoint-tablet: 960px;
  --spacing: 0.25rem;
}
```

### Theme Namespace Options

The `@theme` directive accepts flags:

| Flag | Purpose |
|------|---------|
| `default` | Mark these as default values (can be overridden) |
| `inline` | Inline the theme value directly (no CSS variable) |
| `reference` | Register the variable in the theme namespace but don't emit it as CSS |
| `static` | Mark the theme variable as static (custom property not generated) |
| `prefix(name)` | Custom prefix for generated CSS variables |

```css
@theme default reference {
  --color-background: #fff;
}
```

### Custom Prefix

```css
@import "tailwindcss" prefix(tw);
/* All classes become tw-flex, tw-bg-red-500, etc. */
```

## Core Concepts

### Layer System

Tailwind v4 uses CSS layers in this order:

```css
@layer theme, base, components, utilities;
```

- **theme** — CSS custom properties (design tokens)
- **base** — Preflight reset (normalize equivalent)
- **components** — Container and component classes
- **utilities** — All utility classes

### Important Directive

In the JavaScript API, set `important: true` on the design system to make all utility declarations `!important`:

```ts
const designSystem = buildDesignSystem(theme)
designSystem.important = true
```

There is no CSS `!important` directive syntax in v4; this is configured in the build tool API.

## At-Rules & Directives

### `@tailwind` Directive

The `@tailwind` directive injects Tailwind's layers:

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

In practice, `@import "tailwindcss"` handles these automatically.

### `@theme` Directive

Defines design tokens that become CSS custom properties and theme values:

```css
@theme {
  --color-primary: #3b82f6;
  --font-family-heading: "Inter", sans-serif;
  --spacing-gutter: 2rem;
}
```

Theme keys follow a hierarchical namespace pattern (e.g., `--color-red-500` matches utility `bg-red-500`). Namespaces include:

| Namespace | Maps to utility |
|-----------|----------------|
| `--color-*` | `text-*`, `bg-*`, `border-*`, `ring-*`, `outline-*`, etc. |
| `--font-*` | `font-*` (font family utility) |
| `--text-*` | `text-*` (font size + line height) |
| `--font-weight-*` | `font-*` weight modifiers |
| `--tracking-*` | `tracking-*` (letter spacing) |
| `--leading-*` | `leading-*` (line height) |
| `--radius-*` | `rounded-*` |
| `--shadow-*` | `shadow-*` |
| `--inset-shadow-*` | `inset-shadow-*` |
| `--drop-shadow-*` | `drop-shadow-*` |
| `--breakpoint-*` | Responsive breakpoints (`sm:`, `md:`, etc.) |
| `--container-*` | Container query sizes (`@container`, `@lg`, etc.) |
| `--animate-*` | `animate-*` |
| `--blur-*` | `blur-*`, `backdrop-blur-*` |
| `--ease-*` | `ease-*` |
| `--perspective-*` | `perspective-*` |

### `@apply` Directive

Extract repeated utility patterns into custom CSS rules:

```css
.btn-primary {
  @apply bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600;
}
```

Works within any layer. The compiler resolves `@apply` by replacing the rule node with the AST from the named utility classes.

### `@layer` Directive

Add custom styles to Tailwind's layer system:

```css
@layer components {
  .card {
    @apply rounded-xl shadow-md bg-white p-6;
  }
}

@layer utilities {
  .content-auto {
    content-visibility: auto;
  }
}
```

Layers control the cascade order: `theme < base < components < utilities`.

### `theme()` Function

Reference theme values in custom CSS:

```css
.my-element {
  color: theme(--color-red-500);
  padding: theme(--spacing-4);
  border-radius: theme(--radius-lg);
}
```

The `theme()` function is resolved at build time. In v4, it can be called as a CSS function:

```css
.element {
  /* These are equivalent in v4 */
  color: theme(--color-blue-500);
  color: --theme(--color-blue-500);
}
```

### `@custom-variant` Directive

Register custom variants:

```css
@custom-variant pointer-coarse (@media (pointer: coarse));
@custom-variant theme-midnight (&:is(.theme-midnight &));
```

### `@variant` Directive

Apply a variant within a custom utility/component:

```css
@utility my-utility {
  color: red;
  @variant hover {
    color: blue;
  }
}
```

### `@utility` Directive

Register custom utilities:

```css
@utility content-auto {
  content-visibility: auto;
}
```

This makes `content-auto` available as a utility class.

### `@reference` Directive

Import a stylesheet into the reference layer (not emitted as CSS, only for theme variable reference):

```css
@reference "./other-theme.css";
```

### `@source` Directive

Specify which files to scan for class names:

```css
@source "../src";
@source "./node_modules/@my-org/ui-lib";
@source "none"; /* disable automatic source detection */
```

### `source()` Function

Control content scanning paths:

```css
@import "tailwindcss" source("../src");
@import "tailwindcss" source(none); /* disable content scan */
```

### `@plugin` Directive (v4 plugin)

Load a v4-compatible plugin:

```css
@plugin "@tailwindcss/typography";
```

Note: v3 plugins require the compatibility bridge (`@tailwindcss/upgrade`).

## Utility Classes — Complete Registry

All utilities are registered via `utilities.static()` or `utilities.functional()` in `packages/tailwindcss/src/utilities.ts` (6751 lines). The categories are:

### Layout
- **container** — `static`: centers content with responsive max-width
- **columns** — `columns-{count}`
- **break-*** — `break-before-*`, `break-after-*`, `break-inside-*`
- **box-decoration-*** — `box-decoration-clone`, `box-decoration-slice`
- **box-sizing / display** — (handled through arbitrary properties `[display:flex]`)

### Flexbox & Grid
- **flex** — `flex`, `flex-{grow}`, `flex-{shrink}`, `flex-{basis}` 
- **flex-direction**: `flex-row`, `flex-col`, `flex-row-reverse`, `flex-col-reverse`
- **flex-wrap**: `flex-wrap`, `flex-nowrap`, `flex-wrap-reverse`
- **justify-***: `justify-start`, `justify-end`, `justify-center`, `justify-between`, `justify-around`, `justify-evenly`, `justify-stretch`, `justify-normal`
- **align-***: `items-*`, `content-*`, `self-*`
- **order** — `order-{n}`
- **grid-cols** — `grid-cols-{n}`, `grid-cols-subgrid`
- **grid-rows** — `grid-rows-{n}`, `grid-rows-subgrid`
- **col-span**, **col-start**, **col-end** — grid column placement
- **row-span**, **row-start**, **row-end** — grid row placement
- **auto-cols**, **auto-rows** — implicit grid track sizing
- **place-*** — `place-content-*`, `place-items-*`, `place-self-*`
- **gap** — `gap-{size}`, `gap-x-{size}`, `gap-y-{size}`

### Spacing
- **p-*** — `p-{size}`, `px-{size}`, `py-{size}`, `pt-{size}`, `pr-{size}`, `pb-{size}`, `pl-{size}`
- **m-*** — `m-{size}`, `mx-{size}`, `my-{size}`, `mt-{size}`, `mr-{size}`, `mb-{size}`, `ml-{size}`
- **space-*** — `space-x-{size}`, `space-y-{size}`
- **inset** — `inset-{size}`, `inset-x-{size}`, `inset-y-{size}`, `top-{size}`, `right-{size}`, `bottom-{size}`, `left-{size}`
- Spacing scale: 0..96 in 0.25rem increments

### Sizing
- **w-*** — `w-{size}`, `w-full`, `w-screen`, `w-min`, `w-max`, `w-fit`, `w-1/2`, `w-1/3`, etc.
- **h-*** — same pattern as width
- **min-w-***, **max-w-***, **min-h-***, **max-h-***
- **size-*** — shorthand for both width and height

### Typography
- **font** — `font-{family}` (registered as functional utility with full font stack resolution)
- **text** — `text-{size}`, `text-{size}/{leading}` (combines fontSize + lineHeight)
- **font-weight** — `font-{weight}`
- **tracking** — `tracking-{size}`
- **leading** — `leading-{size}`
- **list-style-*** — `list-none`, `list-disc`, `list-decimal`
- **text-align** — `text-left`, `text-center`, `text-right`, `text-justify`, `text-start`, `text-end`
- **text-color**: `text-{color}` — resolves from `--color-*` theme namespace
- **decoration** — `decoration-{color}`, `decoration-{style}`, `decoration-{thickness}`
- **underline-offset** — `underline-offset-{size}`
- **text-shadow** — `text-shadow-{size}`
- **text-transform**: `uppercase`, `lowercase`, `capitalize`, `normal-case`
- **text-wrap**: `text-wrap`, `text-nowrap`, `text-balance`, `text-pretty`
- **truncate**, **text-ellipsis**, **text-clip**
- **indent** — `indent-{size}`
- **vertical-align** — `align-*`
- **white-space** — `whitespace-*`
- **word-break** — `break-normal`, `break-words`, `break-all`, `break-keep`
- **hyphens** — `hyphens-*`
- **line-clamp** — `line-clamp-{n}`
- **tab** — `tab-{2|4|8}`

### Backgrounds
- **bg** — `bg-{color}` (resolved from `--color-*`), `bg-{position}`, `bg-{size}`
- **bg-linear** — `bg-linear-{direction}` (linear gradients)
- **bg-radial** — `bg-radial-{shape}` (radial gradients)
- **bg-conic** — `bg-conic-{start}` (conic gradients)
- **bg-*** attachment: `bg-fixed`, `bg-local`, `bg-scroll`
- **bg-*** clip: `bg-clip-border`, `bg-clip-padding`, `bg-clip-content`, `bg-clip-text`
- **bg-*** origin: `bg-origin-*`
- **bg-*** repeat: `bg-repeat`, `bg-no-repeat`, `bg-repeat-x`, `bg-repeat-y`
- **bg-*** blend: `bg-blend-*`

### Borders
- **border** — `border-{size}`, `border-{color}`, `border-{side}`
- **border-x/y/t/r/b/l** — directional borders
- **rounded** — `rounded-{radius}`, `rounded-{corner}`, `rounded-{corner}-{radius}`
- **border-style**: `border-solid`, `border-dashed`, `border-dotted`, `border-double`, `border-none`
- **divide** — `divide-x-{size}`, `divide-y-{size}`, `divide-{color}`
- **outline** — `outline-{size}`, `outline-{color}`, `outline-{style}`, `outline-hidden`
- **outline-offset** — `outline-offset-{size}`
- **ring** — `ring-{size}`, `ring-{color}`, `ring-offset-{size}`, `ring-offset-{color}`
- **inset-ring** — `inset-ring-{size}`, `inset-ring-{color}`

### Effects
- **shadow** — `shadow-{size}`, `shadow-{color}`
- **inset-shadow** — `inset-shadow-{size}`, `inset-shadow-{color}`
- **drop-shadow** — `drop-shadow-{size}`
- **opacity** — `opacity-{value}` (0 to 100)
- **mix-blend-mode** — `mix-blend-*`
- **bg-blend-mode** — `bg-blend-*`

### Filters
- **blur** — `blur-{size}`
- **brightness** — `brightness-{value}`
- **contrast** — `contrast-{value}`
- **grayscale** — `grayscale-{value}`, `grayscale`
- **hue-rotate** — `hue-rotate-{degrees}`
- **invert** — `invert-{value}`, `invert`
- **saturate** — `saturate-{value}`
- **sepia** — `sepia-{value}`, `sepia`
- **backdrop-blur** — `backdrop-blur-{size}`
- **backdrop-brightness**, **backdrop-contrast**, etc. — full backdrop filter suite
- **filter** — enables filter (compound functional utility)
- **backdrop-filter** — enables backdrop filter

### Transforms
- **scale** — `scale-{factor}`, `scale-x-{factor}`, `scale-y-{factor}`
- **rotate** — `rotate-{degrees}`
- **translate** — `translate-x-{size}`, `translate-y-{size}`
- **skew** — `skew-x-{degrees}`, `skew-y-{degrees}`
- **transform-origin**: `origin-*`
- **transform** — enables transforms (functional utility, registers `@property --tw-*` defaults)
- **zoom** — `zoom-{factor}`

### Transitions & Animation
- **transition** — `transition`, `transition-all`, `transition-{property}`, `transition-none`
- **duration** — `duration-{ms}`
- **delay** — `delay-{ms}`
- **ease** — `ease-{type}`
- **animate** — `animate-{name}`

### Interactivity
- **cursor** — `cursor-{type}`
- **pointer-events** — `pointer-events-*`
- **resize** — `resize-*`
- **scroll-*** — scroll behavior
- **select** — `select-none`, `select-text`, `select-all`, `select-auto`
- **appearance** — `appearance-none`

### SVG
- **fill** — `fill-{color}` (resolved from `--color-*`)
- **stroke** — `stroke-{color}`, `stroke-{width}`
- **stroke-width** — numeric values

### Accessibility
- **sr-only** — screen reader only
- **not-sr-only** — undo sr-only

### Position
- **static**, **fixed**, **absolute**, **relative**, **sticky**
- **z** — `z-{index}` (0, 10, 20, 30, 40, 50, auto)

### Mask
- **mask** — `mask-{type}` (functional utility with color resolution)
- **mask-linear** — `mask-linear-{direction}`
- **mask-conic** — `mask-conic-{start}`

### Columns
- **columns** — multi-column layout: `columns-{count}`, `columns-auto`, `columns-3xs` through `columns-7xl`

## Variants System

Variants in Tailwind CSS v4 are registered via `variants.static()`, `variants.functional()`, and `variants.compound()` methods in `packages/tailwindcss/src/variants.ts` (1212 lines). The system has three variant kinds:

| Kind | Pattern | Example |
|------|---------|---------|
| **static** | Fixed selector/at-rule | `hover:`, `dark:`, `sm:` |
| **functional** | Parameterized (value-based) | `min-[640px]:`, `aria-expanded:` |
| **compound** | Variant-of-variant (nested) | `group-hover:`, `peer-focus:`, `not-hover:` |

Compounds define `compoundsWith` — what type of CSS output the child variant must produce for compounding to work:
- `Compounds.StyleRules` (1 << 1) — variant produces selectors
- `Compounds.AtRules` (1 << 0) — variant produces at-rules
- `Compounds.Never` (0) — cannot compound

All variants are listed comprehensively in `interaction-patterns.md`.

## Arbitrary Values

Any utility can accept arbitrary values using bracket syntax:

```
w-[32rem]
bg-[#bada55]
text-[--my-custom-color]
grid-cols-[13]
before:content-['Hello_World']
after:content-['\2014']
bg-[url('/img/hero.png')]
h-[calc(100vh-4rem)]
```

Arbitrary values support:
- CSS functions: `theme()`, `calc()`, `var()`, `clamp()`, `min()`, `max()`
- Theme references: `text-[theme(--color-red-500)]`
- CSS variables: `bg-[var(--brand-color)]`
- Whitespace: use underscore `_` (converted to space)

## JIT Compiler

The JIT (Just-In-Time) engine:
1. Scans source files for class names (via Rust `oxide` crate)
2. Parses candidates into a structured `Candidate` type with `kind`, `root`, `value`, `modifier`
3. Applies variants in order to build selector chains
4. Generates only the CSS needed for the used classes
5. Supports on-the-fly arbitrary values

The compiler function signature (`index.ts`):
```ts
async function compile(css: string, options: CompileOptions): Promise<{
  build: string[]
  globs: { base: string; pattern: string }[]
}>
```

## Plugin System (v4)

v4 plugins use CSS-based APIs:

```css
@plugin "my-plugin";
```

or programmatic:

```ts
// plugin.ts
import type { PluginAPI } from 'tailwindcss/plugin'

export default {
  // Register utilities, variants, theme values
} satisfies PluginAPI
```

Plugins can register:
- Static utilities: `api.addBase()`, `api.addComponents()`, `api.addUtilities()`
- Theme values: `api.theme()`
- Variants: `api.addVariant()`
- Base styles: `api.addBase()`

The plugin API (`plugin.ts`) provides a compatibility layer for both v3 and v4 plugin formats.

## Compile Options

```ts
type CompileOptions = {
  base?: string           // Base directory for resolving relative paths
  from?: string           // Source file path (for source maps)
  polyfills?: Polyfills   // Enable CSS polyfills
  loadModule?: (id, base, hint) => Promise<{...}>  // Module loader
  loadStylesheet?: (id, base) => Promise<{...}>    // Stylesheet loader
}
```

## Polyfills

```ts
enum Polyfills {
  None = 0,
  AtProperty = 1 << 0,    // @property rule fallbacks
  ColorMix = 1 << 1,      // color-mix() fallbacks
  All = AtProperty | ColorMix,
}
```

## Feature Flags

```ts
enum Features {
  None = 0,
  AtApply = 1 << 0,       // @apply was used
  Variants = 1 << 1,      // @variant was used
  HangingPunctuation = ... // hanging-punctuation supported
}
```

## Content Detection

By default, Tailwind scans for class names in all files matching common extensions. You can control this with `@source`:

```css
@source "../src";
@source "../node_modules/@my-org/components";
@source "none"; /* turn off auto-detection */
```

Default scanned patterns: `**/*.{html,js,jsx,ts,tsx,vue,svelte,astro,php,blade,mdx,md,haml,slim,rb,erb,njk,liquid}`
