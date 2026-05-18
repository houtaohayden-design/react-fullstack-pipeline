# Tailwind CSS v4 — Interaction & State Variants

> Extracted from `packages/tailwindcss/src/variants.ts` (lines 349-1212)
> Complete registry of all 60+ built-in variant modifiers

## Variant Architecture

Tailwind v4 has three variant kinds:

| Kind | Registration | CSS Output |
|------|-------------|------------|
| **static** | `variants.static(name, selectors)` | Fixed selectors or at-rules |
| **functional** | `variants.functional(name, applyFn)` | Parameterized with value resolution |
| **compound** | `variants.compound(name, compoundsWith, applyFn)` | Wraps another variant's output |

Compounds define `compoundsWith` (bitmask) — what output the child must generate:
- `Compounds.StyleRules (2)` — pseudo-classes, selectors
- `Compounds.AtRules (1)` — @media, @supports, @container queries
- `Compounds.StyleRules | Compounds.AtRules (3)` — either (used by `not`)

## Hover, Focus & Active States

### Hover (`hover:`)
```css
/* & :hover { ... } wrapped in @media (hover: hover) */
```
```html
<button class="bg-blue-500 hover:bg-blue-600">
```
CSS: `@media (hover: hover) { .hover\:bg-blue-600:hover { background-color: ... } }`

The `@media (hover: hover)` wrapper prevents sticky hover states on touch devices. Registered as a static variant with style rule wrapping.

### Focus (`focus:`)
```css
/* &:focus */
```
```html
<input class="border-gray-300 focus:border-blue-500 focus:ring-2" />
```

### Focus-Visible (`focus-visible:`)
```css
/* &:focus-visible */
```
```html
<button class="focus-visible:outline-2 focus-visible:outline-blue-500">
```
Use for keyboard focus indicators. Preferred over `focus:` for interactive elements.

### Focus-Within (`focus-within:`)
```css
/* &:focus-within */
```
```html
<div class="focus-within:ring-2 focus-within:ring-blue-500">
  <input />
</div>
```
Styles parent when any child is focused.

### Active (`active:`)
```css
/* &:active */
```
```html
<button class="active:scale-95 active:bg-blue-700">
```

### Visited (`visited:`)
```css
/* &:visited */
```
```html
<a class="text-blue-600 visited:text-purple-600">
```

### Target (`target:`)
```css
/* &:target */
```
```html
<div id="section-1" class="target:bg-yellow-50">
```

## Group-Based Interactions

Group variants use the **compound** variant mechanism. The parent element gets `.group`, children use `group-{variant}:`.

### How Group Works

```css
/* group: :where(.group) descendant */
/* group-hover: :where(.group):hover descendant */
/* group/name: :where(.group\/name) descendant */
```

```html
<div class="group">
  <h3 class="group-hover:text-blue-500">Title</h3>
  <p class="group-hover:opacity-100 opacity-0">Description</p>
</div>
```

### Named Groups (Modifier)

```html
<div class="group/card">
  <div class="group/edit">
    <button class="opacity-0 group-hover/card:opacity-100 group-hover/edit:opacity-100">
    </button>
  </div>
</div>
```

Named groups use `\/` escaping: `group\/name` -> `.group\/name` CSS class.

### All Group Variants

Any style-rule variant can be combined with group: `group-hover`, `group-focus`, `group-focus-visible`, `group-active`, `group-visited`, `group-target`, `group-first`, `group-last`, `group-odd`, `group-even`, `group-disabled`, `group-checked`, `group-required`, `group-invalid`, `group-valid`, `group-open`, `group-empty`, `group-aria-*`, `group-data-*`, `group-has-*`, `group-in-*`.

## Peer-Based Interactions

Peer variants use the sibling combinator (`~`) instead of descendant:

### How Peer Works

```css
/* peer: :where(.peer) ~ & */
/* peer-hover: :where(.peer):hover ~ & */
```

```html
<label>
  <input type="checkbox" class="peer sr-only" />
  <span class="peer-checked:text-blue-500">Label text</span>
  <svg class="peer-checked:opacity-100 opacity-0">...</svg>
</label>
```

### All Peer Variants

Any style-rule variant: `peer-hover`, `peer-focus`, `peer-focus-visible`, `peer-active`, `peer-checked`, `peer-disabled`, `peer-required`, `peer-invalid`, `peer-valid`, `peer-placeholder-shown`, `peer-autofill`, `peer-empty`, `peer-open`, `peer-aria-*`, `peer-data-*`, `peer-has-*`, `peer-in-*`.

## Form States

### Checked (`checked:`)
```css
/* &:checked */
```
```html
<input type="checkbox" class="checked:bg-blue-500" />
```

### Indeterminate (`indeterminate:`)
```css
/* &:indeterminate */
```

### Disabled (`disabled:`)
```css
/* &:disabled */
```
```html
<button class="disabled:opacity-50 disabled:cursor-not-allowed" disabled>
```

### Enabled (`enabled:`)
```css
/* &:enabled */
```

### Required (`required:`)
```css
/* &:required */
```
```html
<input class="required:border-red-500" required />
```

### Valid / Invalid (`valid:` / `invalid:`)
```css
/* &:valid, &:invalid */
```
```html
<input class="invalid:border-red-500 valid:border-green-500" />
```

### User-Valid / User-Invalid (`user-valid:` / `user-invalid:`)
```css
/* &:user-valid, &:user-invalid */
```
Only marked after user interaction.

### In-Range / Out-of-Range (`in-range:` / `out-of-range:`)
```css
/* &:in-range, &:out-of-range */
```

### Read-Only (`read-only:`)
```css
/* &:read-only */
```

### Placeholder-Shown (`placeholder-shown:`)
```css
/* &:placeholder-shown */
```
```html
<div class="relative">
  <input class="peer placeholder-shown:border-gray-300 border-blue-500" placeholder=" " />
  <label class="peer-placeholder-shown:top-2 peer-placeholder-shown:text-base peer-focus:top-0 peer-focus:text-sm absolute transition-all">
    Label
  </label>
</div>
```

### Autofill (`autofill:`)
```css
/* &:autofill */
```
```html
<input class="autofill:bg-yellow-50" />
```

### Default (`default:`)
```css
/* &:default */
```
```html
<input type="radio" class="default:ring-2" />
```

### Optional (`optional:`)
```css
/* &:optional */
```

## ARIA States

### aria-* (`aria-{state}:`)
```css
/* &[aria-{state}="true"] */
```

Built-in suggestions: `aria-busy`, `aria-checked`, `aria-disabled`, `aria-expanded`, `aria-hidden`, `aria-pressed`, `aria-readonly`, `aria-required`, `aria-selected`.

```html
<button aria-expanded="true" class="aria-expanded:rotate-180">
  <svg class="transition-transform">...</svg>
</button>
```

Arbitrary: `aria-[label="Search"]:text-sm`, `aria-[current="page"]:font-bold`

### data-* (`data-{attr}:`)
```css
/* &[data-{attr}] */
```

```html
<div data-state="open" class="data-[state=open]:block hidden">
```

Arbitrary: `data-[size=large]:text-lg`, `data-[disabled]:opacity-50`

## Motion and Accessibility Preferences

### Motion Safety
```css
motion-safe:   @media (prefers-reduced-motion: no-preference)
motion-reduce: @media (prefers-reduced-motion: reduce)
```

```html
<div class="motion-safe:animate-spin">
<!-- Only animates if user hasn't requested reduced motion -->
```

### Contrast Preferences
```css
contrast-more: @media (prefers-contrast: more)
contrast-less: @media (prefers-contrast: less)
```

```html
<div class="border border-gray-200 contrast-more:border-gray-900">
```

### Forced Colors
```css
forced-colors: @media (forced-colors: active)
```

### Inverted Colors
```css
inverted-colors: @media (inverted-colors: inverted)
```

### Scripting
```css
noscript: @media (scripting: none)
```

## Dark Mode & Color Scheme

### Dark Mode (`dark:`)
```css
@media (prefers-color-scheme: dark)
```

### Color Scheme (light/dark)
```css
light: @media (prefers-color-scheme: light)  /* via custom variant */
```

## Pointer & Device

```css
pointer-none:        @media (pointer: none)        /* no pointing device */
pointer-coarse:      @media (pointer: coarse)      /* touch */
pointer-fine:        @media (pointer: fine)        /* mouse/stylus */
any-pointer-none:    @media (any-pointer: none)
any-pointer-coarse:  @media (any-pointer: coarse)
any-pointer-fine:    @media (any-pointer: fine)
```

```html
<div class="pointer-coarse:text-lg pointer-fine:text-sm">
  <!-- Larger tap targets on touch devices -->
</div>
```

## Orientation

```css
portrait:  @media (orientation: portrait)
landscape: @media (orientation: landscape)
```

## Direction (RTL/LTR)

```css
ltr: &:where(:dir(ltr), [dir="ltr"], [dir="ltr"] *)
rtl: &:where(:dir(rtl), [dir="rtl"], [dir="rtl"] *)
```

```html
<div class="ltr:ml-4 rtl:mr-4">
  <!-- ml-4 in LTR, mr-4 in RTL -->
</div>
```

## Print

```css
print: @media print
```

```html
<div class="print:hidden">Screen only</div>
<table class="print:text-black print:text-sm">
```

## Negation: `not-*`

The `not` variant is a **compound** variant that negates any other variant:

```html
<!-- All children except the first -->
<div class="not-first:border-t">

<!-- Not on small screens -->
<div class="not-sm:grid-cols-2">

<!-- Not hovered -->
<div class="not-hover:opacity-100 hover:opacity-50">
```

Technically, `not-{variant}:` generates `:not({negated-selector})` wrappers. It supports negating both style rules (selectors) and at-rules (`@media`, `@supports`, `@container`).

## Hover with Queries: `@supports`

```html
<div class="supports-[display:grid]:grid">
<div class="supports-[backdrop-filter]:backdrop-blur">
```

Functional variant that wraps styles in `@supports {query}`.

## Container Queries

```css
@container:  @container (width >= {value})  /* min-width */
@min:        @container (width >= {value})  /* min-width (alias) */
@max:        @container (width < {value})   /* max-width */
```

```html
<div class="@container">
  <div class="grid @md:grid-cols-2 @lg:grid-cols-3">
```

Named containers via modifier:
```html
<div class="@container/sidebar">
  <div class="@md/sidebar:grid-cols-2">
```

Arbitrary:
```html
<div class="@[400px]:flex-col">
```

## Combinator-Based: `*`, `**`, `has-*`, `in-*`

### Direct Children (`*:`)
```css
*: :is(& > *)
```
```html
<ul class="*:rounded-full">
  <li>Round</li> <li>Round</li>
</ul>
```

### All Descendants (`**:`)
```css
**: :is(& *)
```

### Has (`has-*:`)
```css
has-{variant}: &:has({selector})
```
```html
<div class="has-[img]:border has-[input:invalid]:border-red-500">
```

### In (`in-*:`)
```css
in-{variant}: :where({selector}) &
```
```html
<div class="dark:in-[.dark-section]:bg-white">
```

## Positional / Structural

```css
first:          &:first-child
last:           &:last-child
only:           &:only-child
odd:            &:nth-child(odd)
even:           &:nth-child(even)
first-of-type:  &:first-of-type
last-of-type:   &:last-of-type
only-of-type:   &:only-of-type
empty:          &:empty
```

### nth-child Variants

Functional variants:
```html
<div class="nth-3:bg-blue-500">   <!-- &:nth-child(3) -->
<div class="nth-last-2:mb-0">      <!-- &:nth-last-child(2) -->
<div class="nth-of-type-odd:font-bold">  <!-- &:nth-of-type(odd) -->
<div class="nth-last-of-type-1:border-b">  <!-- &:nth-last-of-type(1) -->
```

Arbitrary:
```html
<div class="nth-[2n+1]:bg-gray-100">  <!-- odd -->
<div class="nth-[3n]:mr-0">           <!-- every 3rd -->
```

## Open State

```css
open: &:is([open], :popover-open, :open)
```

Matches `<details open>`, `<dialog open>`, popovers.

## Pseudo-Elements

```css
before:            &::before (with --tw-content property)
after:             &::after (with --tw-content property)
first-letter:      &::first-letter
first-line:        &::first-line
marker:            &::marker, & *::marker
selection:         &::selection, & *::selection
file:              &::file-selector-button
placeholder:       &::placeholder
backdrop:          &::backdrop
details-content:   &::details-content
```

### Content Pseudo-Elements

`before:` and `after:` are special — they register a `@property --tw-content` and set `content: var(--tw-content)`:

```html
<span class="before:content-['→_']">Link text</span>
<span class="after:content-['_✓'] after:text-green-500">Done</span>
<div class="before:absolute before:inset-0 before:bg-black/50">
```

## Inert

```css
inert: &:is([inert], [inert] *)
```

## Starting Style (`@starting-style`)

```css
starting: @starting-style
```

For CSS transition entry effects:
```html
<div class="starting:opacity-0 transition-opacity duration-300">
```

## Transition & Animation Utilities

### Transition Properties
```html
<div class="transition">                     <!-- all properties -->
<div class="transition-colors">              <!-- color, background-color, border-color -->
<div class="transition-opacity">             <!-- opacity -->
<div class="transition-shadow">              <!-- box-shadow -->
<div class="transition-transform">           <!-- transform -->
<div class="transition-none">                <!-- no transitions -->
<div class="transition-[grid-template-rows]"> <!-- arbitrary -->
```

### Duration & Delay
```html
<div class="duration-150">   <!-- 150ms (default) -->
<div class="duration-300">   <!-- 300ms -->
<div class="duration-700">   <!-- 700ms -->
<div class="delay-300">      <!-- 300ms delay -->
<div class="delay-0">        <!-- no delay -->
```

### Easing
```html
<div class="ease-in">        <!-- cubic-bezier(0.4, 0, 1, 1) -->
<div class="ease-out">       <!-- cubic-bezier(0, 0, 0.2, 1) -->
<div class="ease-in-out">    <!-- cubic-bezier(0.4, 0, 0.2, 1) -->
<div class="ease-linear">    <!-- linear -->
<div class="ease-[cubic-bezier(0.34,1.56,0.64,1)]">  <!-- arbitrary -->
```

### Animations
```html
<div class="animate-spin">    <!-- spin 1s linear infinite -->
<div class="animate-ping">    <!-- ping 1s cubic-bezier infinite -->
<div class="animate-pulse">   <!-- pulse 2s cubic-bezier infinite -->
<div class="animate-bounce">  <!-- bounce 1s infinite -->
<div class="animate-none">    <!-- no animation -->
```

### Animation Control
```html
<div class="animate-spin [animation-duration:3s]">     <!-- custom duration -->
<div class="animate-bounce animate-infinite">           <!-- loop forever -->
<div class="animate-spin animate-paused hover:animate-running">
```

## Transform Utilities

### Scale
```html
<div class="scale-75">        <!-- 0.75 -->
<div class="scale-100">       <!-- 1.0 -->
<div class="scale-125">       <!-- 1.25 -->
<div class="scale-x-50">      <!-- 50% horizontally -->
<div class="scale-y-150">     <!-- 150% vertically -->
```

### Rotate
```html
<div class="rotate-0">        <!-- 0deg -->
<div class="rotate-45">       <!-- 45deg -->
<div class="rotate-90">       <!-- 90deg -->
<div class="rotate-180">      <!-- 180deg -->
<div class="-rotate-45">      <!-- -45deg -->
<div class="rotate-[27deg]">  <!-- arbitrary -->
```

### Translate
```html
<div class="translate-x-4">       <!-- 1rem right -->
<div class="-translate-y-2">      <!-- 0.5rem up -->
<div class="translate-x-1/2">     <!-- 50% of own width -->
<div class="translate-y-full">    <!-- 100% of own height -->
```

### Skew
```html
<div class="skew-x-3">        <!-- 3deg horizontal -->
<div class="skew-y-6">        <!-- 6deg vertical -->
<div class="-skew-x-12">      <!-- -12deg horizontal -->
```

### Transform Origin
```html
<div class="origin-center">
<div class="origin-top-left">
<div class="origin-[200%_50%]">   <!-- arbitrary -->
```

### 3D Transforms
```html
<div class="transform-3d">
<div class="rotate-x-45 rotate-y-12">
<div class="perspective-dramatic">    <!-- 100px -->
<div class="perspective-near">        <!-- 300px -->
<div class="perspective-normal">      <!-- 500px -->
<div class="perspective-midrange">    <!-- 800px -->
<div class="perspective-distant">     <!-- 1200px -->
<div class="backface-visible">
<div class="backface-hidden">
```

### Zoom
```html
<div class="zoom-110">        <!-- 1.1 -->
<div class="zoom-90">         <!-- 0.9 -->
<div class="zoom-[1.15]">     <!-- arbitrary -->
```

## Filter Utilities

### Blur
```html
<div class="blur-xs">         <!-- 4px -->
<div class="blur-sm">         <!-- 8px -->
<div class="blur-md">         <!-- 12px -->
<div class="blur-lg">         <!-- 16px -->
<div class="blur-xl">         <!-- 24px -->
<div class="blur-2xl">        <!-- 40px -->
<div class="blur-3xl">        <!-- 64px -->
```

### Backdrop Filter
```html
<div class="backdrop-blur-md backdrop-brightness-75 bg-white/30">
  Frosted glass effect
</div>
```

All backdrop variants: `backdrop-blur`, `backdrop-brightness`, `backdrop-contrast`, `backdrop-grayscale`, `backdrop-hue-rotate`, `backdrop-invert`, `backdrop-opacity`, `backdrop-saturate`, `backdrop-sepia`.

### Filter Activation

The `filter` and `backdrop-filter` utilities must be present to enable filters (they register `@property --tw-*`):

```html
<!-- Won't work alone -->
<div class="blur-md">

<!-- Must include filter or backdrop-filter -->
<div class="filter blur-md">
<div class="backdrop-filter backdrop-blur-md">
```

## Combinatorial Patterns

Variants can be stacked (left-to-right, outside-in):

```html
<!-- Dark mode + hover + responsive -->
<div class="dark:hover:bg-gray-700 md:dark:hover:bg-gray-800">

<!-- Group + focus-visible + responsive -->
<div class="group-focus-visible:ring-2 lg:group-focus-visible:ring-4">

<!-- peer + checked + hover -->
<label class="peer-checked:bg-blue-500 hover:peer-checked:bg-blue-600">

<!-- not + dark + lg -->
<div class="not-dark:bg-white lg:not-dark:shadow-md">

<!-- supports + hover -->
<div class="supports-[backdrop-filter]:backdrop-blur supports-[backdrop-filter]:hover:backdrop-blur-lg">
```

Compounding rules:
- Style-rule variants (pseudo-classes) can compound within at-rule variants (responsive, dark, etc.)
- At-rule variants can compound within other at-rule variants (e.g., `md:dark:`)
- `group-*` and `peer-*` can only compound with style-rule variants, not at-rules
- `not-*` supports both style rules and at-rules
- `has-*` and `in-*` support style rules only
- `*` and `**` cannot compound at all
