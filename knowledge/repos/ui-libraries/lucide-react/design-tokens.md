# Lucide React — Design Tokens

> Source: [lucide-icons/lucide](https://github.com/lucide-icons/lucide) | Consistent design language across 1,711 icons

## Core Default Attributes

Every Lucide icon renders with these SVG defaults (from `defaultAttributes.ts`):

```typescript
export default {
  xmlns: 'http://www.w3.org/2000/svg',
  width: 24,        // Render size in pixels
  height: 24,       // Render size in pixels
  viewBox: '0 0 24 24',  // Coordinate system
  fill: 'none',     // No fill — stroke-only icons
  stroke: 'currentColor',  // Inherits text color
  strokeWidth: 2,   // Stroke thickness
  strokeLinecap: 'round',  // Rounded line ends
  strokeLinejoin: 'round', // Rounded corners
};
```

## Visual Token Table

| Token | Default Value | Override Via | Notes |
|-------|--------------|-------------|-------|
| `size` | `24` | `<Icon size={n} />` / `LucideProvider size={n}` | Sets both `width` and `height` uniformly |
| `viewBox` | `0 0 24 24` | Fixed (not customizable) | 24x24 grid system |
| `fill` | `none` | Not customizable via props | Achieved via CSS `.lucide { fill: currentColor; }` |
| `stroke` | `currentColor` | `<Icon color={s} />` / `LucideProvider color={s}` | Any CSS color value |
| `strokeWidth` | `2` | `<Icon strokeWidth={n} />` / `LucideProvider strokeWidth={n}` | Number (px) |
| `strokeLinecap` | `round` | Fixed (consistent style) | Rounded line terminations |
| `strokeLinejoin` | `round` | Fixed (consistent style) | Rounded corner joins |
| `absoluteStrokeWidth` | `false` | `<Icon absoluteStrokeWidth />` | Scales stroke proportionally to size |

## Icon Grid System

All 1,711 icons are designed on a **24x24 pixel grid**:

```
    0px                          24px
  0  +----------------------------+
     |                            |
     |   icons drawn within the   |
     |   24x24 viewBox coordinate |
     |   system, typically with   |
     |   1-2px padding from edges |
     |                            |
 24px +----------------------------+
```

**Design constraints:**
- Icons are drawn within the 24x24 coordinate space
- 1-2px padding from viewBox edges is standard
- Icons are optical-size balanced (not mathematically centered) — the visual weight is balanced by eye
- Stroke-based design (no filled shapes) maintains consistent visual density across the set

## Size Scale

The sizing system multiplies the 24x24 viewBox to any render size:

| Size (px) | ViewBox Mapping | Visual Weight | Common Context |
|-----------|----------------|---------------|----------------|
| `12` | 0.5x | Very small icons | Inline text, badges, dense UI |
| `14` | 0.58x | Small | Compact interfaces |
| `16` | 0.67x | Compact | Buttons, form fields, shadcn/ui buttons |
| `18` | 0.75x | Medium-compact | Secondary buttons |
| `20` | 0.83x | Medium | Navigation items, tooltips, shadcn/ui dropdowns |
| `24` | **1x (default)** | Standard | Most UI icons |
| `28` | 1.17x | Medium-large | Feature grids |
| `32` | 1.33x | Large | Empty states, feature sections |
| `40` | 1.67x | Display | Hero sections, large decorative |
| `48` | 2x | Hero | Landing page features, app icons |

## Stroke Width Scale

The stroke width is independent of icon size by default. Use `absoluteStrokeWidth` for proportional scaling:

```
strokeWidth   Visual Character
    1         ─── Hairline, delicate, minimal
    1.5       ─── Light, modern UI
    2         ─── Default, balanced
    2.5       ─── Semi-bold, emphasis
    3         ─── Bold, strong presence
```

### Visual comparison (same icon, size 24):

```
strokeWidth={1}   ░░░  (thin outline, open feel)
strokeWidth={2}   ▓▓▓  (standard weight, clear visibility)
strokeWidth={3}   ███  (bold, high contrast)
```

### absoluteStrokeWidth Behavior

```
<Search size={48} strokeWidth={2} />
// Effective stroke: 2px (thin at 48px)

<Search size={48} strokeWidth={2} absoluteStrokeWidth />
// Effective stroke: (2 * 24) / 48 = 1px (even thinner!)

// To get visually "standard" thickness at 48px:
<Search size={48} strokeWidth={4} absoluteStrokeWidth />
// Effective stroke: (4 * 24) / 48 = 2px
```

## Color System

Lucide icons are designed around **one color** (the stroke color). There is no fill color, no multi-color, no gradient support built into the API.

```css
/* Default: inherits text color */
stroke: currentColor;

/* Override with any CSS color */
color="#ff0000"        /* Named/prop */
color="var(--brand)"   /* CSS variable */
color="rgb(99 102 241)" /* RGB */
color="#6366f1"        /* HEX */
color="oklch(0.62 0.21 265)" /* OKLCH */
```

### Color Integration Patterns

```tsx
// Tailwind text color (currentColor inheritance)
<Search className="text-blue-500" />    // blue
<Search className="text-gray-400 dark:text-gray-500" />  // theme-aware

// Explicit color (overrides currentColor)
<AlertTriangle color="#ef4444" />  // always red

// CSS variable (design token)
<Check color="var(--color-success)" />

// Dynamic color
<Star color={isGold ? '#f59e0b' : '#d1d5db'} />
```

## Rounded vs Sharp Variants

Lucide icons are **exclusively rounded** — there are no sharp-corner variants. The consistency comes from:

- `strokeLinecap: "round"` — rounded line endpoints (no sharp/cut-off ends)
- `strokeLinejoin: "round"` — rounded corner joins (no mitered/beveled corners)

This rounded aesthetic is a core part of the Lucide visual identity and applies to all 1,711 icons uniformly.

## Weight Variants

Lucide does **not** provide filled/duotone/bold weight variants. Each icon has exactly one weight:

- **Single weight**: All icons share the same stroke weight (default 2px, customizable to any value)
- **No filled variants**: Icons are stroke-only by design
- **No duotone**: Single-color stroke design

### Simulating Variants

```tsx
// "Filled" appearance (set fill via CSS)
<Heart className="fill-current text-red-500" />

// "Bold" appearance
<Search strokeWidth={3} />

// "Thin" appearance
<Search strokeWidth={1} />

// "Duotone" appearance (CSS hacks)
<Star className="text-yellow-300 [&_path:last-child]:opacity-50" />
```

## Icon Metadata Structure

Each icon has metadata defined in a companion JSON file:

```json
{
  "$schema": "../icon.schema.json",
  "contributors": ["colebemis", "ericfennis"],
  "tags": ["find", "scan", "magnifying glass"],
  "categories": ["text", "social"],
  "aliases": [
    {
      "name": "search-icon",
      "deprecated": true,
      "deprecationReason": "alias.name",
      "toBeRemovedInVersion": "v1.0"
    }
  ]
}
```

| Field | Required | Description |
|-------|----------|-------------|
| `$schema` | Yes | Schema reference |
| `contributors` | Yes | GitHub usernames (min 1) |
| `tags` | Yes | Search keywords (min 1) |
| `categories` | Yes | Category slugs from the 42-category enum |
| `aliases` | No | Deprecated/alternate names |
| `deprecated` | No | Whether the icon is deprecated |
| `deprecationReason` | No | Reason enum: `icon.renamed` |
| `toBeRemovedInVersion` | No | Version number when alias will be removed |

### Aliases

Lucide maintains backward compatibility through aliases. Common deprecation reasons:

- `alias.name` — Better name chosen (e.g., `loader-2` -> `loader-circle`)
- `alias.typo` — Typo in original name
- `alias.duplicate` — Duplicate icon

## SVG Element Types Used

Icons are composed of these SVG elements only:

| Element | Usage |
|---------|-------|
| `path` | Most icon shapes (primary element) |
| `circle` | Circular shapes (pupils, dots, radio indicators) |
| `line` | Straight lines |
| `rect` | Rectangles (checkboxes, containers) |
| `polyline` | Connected line segments |
| `polygon` | Closed polygon shapes |
| `ellipse` | Elliptical shapes |
| `g` | Grouping (rarely used) |

## CSS Class Convention

Every icon gets two CSS classes based on its name:

```html
<!-- <CheckCircle /> renders: -->
<svg class="lucide lucide-check-circle" ...>

<!-- <ArrowUpRight /> renders: -->
<svg class="lucide lucide-arrow-up-right" ...>
```

Class generation rule:
1. `lucide` base class (always present)
2. `lucide-{kebab-name}` icon-specific class

Use for targeted CSS:

```css
.lucide {
  flex-shrink: 0;
  vertical-align: middle;
}

.lucide-alert-triangle {
  /* Specific styling for alert icon */
}
```

## Integration with Design Systems

### Tailwind CSS Harmony

Lucide's `currentColor` stroke + 24x24 viewBox aligns perfectly with Tailwind:

```js
// tailwind.config.js — define icon sizes as theme extensions
module.exports = {
  theme: {
    extend: {
      width: {
        'icon-sm': '16px',
        'icon': '20px',
        'icon-lg': '24px',
        'icon-xl': '32px',
      },
      height: {
        'icon-sm': '16px',
        'icon': '20px',
        'icon-lg': '24px',
        'icon-xl': '32px',
      },
    },
  },
};
```

### CSS Variable Integration

```css
:root {
  --icon-size: 20px;
  --icon-stroke-width: 1.5;
  --icon-color: currentColor;
}
```

```tsx
<Search
  size="var(--icon-size)"
  strokeWidth="var(--icon-stroke-width)"
  color="var(--icon-color)"
/>

// Or via LucideProvider
<LucideProvider size={20} strokeWidth={1.5}>
  {/* All icons use these tokens */}
</LucideProvider>
```

### Design Token Mapping

| Lucide Prop | Corresponding Design Token | Recommended Value |
|-------------|---------------------------|-------------------|
| `size` | `--icon-size` | `24` (default) or `20` (modern) |
| `strokeWidth` | `--icon-stroke-width` | `2` (default) or `1.5` (modern, shadcn/ui) |
| `color` | `--icon-color` | `currentColor` (default, inherits from context) |
| `className` | N/A | `lucide` (auto-applied) + custom |

## Performance Token: Bundle Weight

| Import | Approx Gzipped Size | Notes |
|--------|---------------------|-------|
| Single icon | ~300-600 bytes | Typical icon weight |
| `DynamicIcon` module | ~2.5 KB | Dynamic loader + runtime |
| Full library (tree-shaken) | Only imported icons | Side-effect-free |
| Full library (un-tree-shaken) | ~400 KB | `import * as Icons` anti-pattern |

## Summary: The Lucide Visual Formula

Every Lucide icon = **24x24 viewBox** + **currentColor stroke** + **2px weight** + **round caps/joins** + **no fill** + **consistent optical sizing**. This formula produces a visually cohesive set of 1,711 icons that works seamlessly with any React design system.
