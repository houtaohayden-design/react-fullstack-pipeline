# Lucide React — API Reference

> Source: [lucide-icons/lucide](https://github.com/lucide-icons/lucide) | 12k+ stars | ISC license

## Installation

```bash
npm install lucide-react
# or
pnpm add lucide-react
# or
yarn add lucide-react
# or
bun add lucide-react
```

Peer dependency: `react` ^16.5.1 || ^17 || ^18 || ^19

## Icon Count & Categories

**1,711 icons** across **42 categories**:

| Category | Title | Sample Icons |
|----------|-------|-------------|
| accessibility | Accessibility | accessibility, blinds, braille |
| account | Accounts & access | user, users, user-plus, fingerprint |
| animals | Animals | dog, cat, fish, bird, rabbit |
| arrows | Arrows | arrow-left, arrow-right, chevron-down, move |
| buildings | Buildings | building, home, warehouse, school |
| charts | Charts | chart-pie, chart-bar, chart-line, chart-area |
| communication | Communication | message-circle, phone, mail, at-sign |
| connectivity | Connectivity | wifi, bluetooth, antenna, signal |
| cursors | Cursors | mouse-pointer, hand, pointer |
| design | Design | palette, pencil, ruler, pen-tool |
| development | Coding & development | code-xml, terminal, git-branch, braces |
| devices | Devices | smartphone, tablet, monitor, laptop |
| emoji | Emoji | smile, frown, angry, heart |
| files | File icons | file, folder, file-text, image |
| finance | Finance | piggy-bank, dollar-sign, credit-card |
| food-beverage | Food & beverage | coffee, pizza, beef, wine |
| gaming | Gaming | gamepad-2, joystick, dice-1 |
| home | Home | house, door-open, bed, sofa |
| layout | Layout | panels-top-left, columns, rows, grid-2x2 |
| mail | Mail | mail, inbox, send, mailbox |
| math | Mathematics | divide, pi, sigma, infinity |
| medical | Medical | heart, stethoscope, pill, syringe |
| multimedia | Multimedia | play, pause, volume, camera, film |
| nature | Nature | sprout, tree-pine, flower, mountain |
| navigation | Navigation, Maps, POIs | compass, map, map-pin, navigation |
| notifications | Notification | bell, triangle-alert, info, badge-x |
| people | People | person-standing, user-round, contact |
| photography | Photography | camera, aperture, image, focus |
| science | Science | flask-conical, atom, microscope, dna |
| seasons | Seasons | leaf, snowflake, sun, cloud-rain |
| security | Security | shield, lock, key, scan-eye |
| shapes | Shapes | circle, square, triangle, star |
| shopping | Shopping | shopping-bag, cart, store, barcode |
| social | Social | thumbs-up, share-2, bookmark, link |
| sports | Sports | trophy, medal, target, dumbbell |
| sustainability | Sustainability | recycle, leaf, bike, sun |
| text | Text formatting | type, bold, italic, underline, list |
| time | Time & calendar | calendar, clock, timer, alarm-clock |
| tools | Tools | wrench, hammer, screwdriver, scissors |
| transportation | Transportation | car, train-front, plane, bus, ship |
| travel | Travel | backpack, luggage, tent, compass |
| weather | Weather | cloud, sun, cloud-rain, snowflake |

Each icon also has searchable `tags` (e.g., "search" icon tags: find, scan, magnifier, magnifying glass, lens).

## Basic Usage

Every icon is a React component exported from `lucide-react`:

```tsx
import { Search, Heart, User } from 'lucide-react';

function MyComponent() {
  return (
    <div>
      <Search />
      <Heart />
      <User />
    </div>
  );
}
```

## Icon Props

All icons accept these props (type: `LucideProps`):

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `size` | `string \| number` | `24` | Icon width and height in pixels |
| `color` | `string` | `currentColor` | Stroke color (CSS color value) |
| `strokeWidth` | `string \| number` | `2` | Stroke width in pixels |
| `absoluteStrokeWidth` | `boolean` | `false` | When true, strokeWidth scales proportionally with size |
| `className` | `string` | `""` | CSS class name(s) |
| `ref` | `Ref<SVGSVGElement>` | — | Forwarded ref to the `<svg>` element |

Plus all standard SVG element attributes (`onClick`, `style`, `aria-label`, `data-*`, etc.).

### Prop Examples

```tsx
import { Search, Heart } from 'lucide-react';

// Custom size
<Search size={48} />

// Custom color
<Search color="#ff0000" />
<Search color="var(--color-primary)" />

// Thinner or thicker stroke
<Search strokeWidth={1} />   // hairline
<Search strokeWidth={3} />   // bold

// Fixed stroke at any size (scales proportionally)
<Search size={48} strokeWidth={3} absoluteStrokeWidth />

// With CSS classes
<Search className="text-red-500 hover:text-red-700" />

// With accessibility label
<Search aria-label="Search products" />

// Combined
<Search
  size={20}
  color="currentColor"
  strokeWidth={2}
  className="inline-block"
  aria-label="Search"
/>
```

## `absoluteStrokeWidth` Explained

When `absoluteStrokeWidth={true}`, the stroke width stays visually consistent regardless of icon size. The formula is:

```
effectiveStrokeWidth = (strokeWidth * 24) / size
```

This means a `strokeWidth={2}` at `size={48}` would render at `(2 * 24) / 48 = 1` pixel stroke. Without this flag, stroke width remains exactly 2px regardless of size (making small icons look thick and large icons look thin).

## LucideProvider — Global Defaults

Set default props for all icons in a subtree:

```tsx
import { LucideProvider, Search, Heart } from 'lucide-react';

function App() {
  return (
    <LucideProvider size={20} strokeWidth={1.5} color="#333">
      {/* These inherit the provider defaults */}
      <Search />         {/* size=20, strokeWidth=1.5, color=#333 */}
      <Heart />          {/* size=20, strokeWidth=1.5, color=#333 */}
      <Search size={32} />  {/* overrides size, keeps other defaults */}
    </LucideProvider>
  );
}
```

Props passed directly to an icon take precedence over provider values.

## Dynamic Icon Loading

Lucide React supports dynamic (lazy) icon loading via `DynamicIcon`:

```tsx
import { DynamicIcon } from 'lucide-react/dynamic';

function IconRenderer({ name }: { name: string }) {
  return (
    <DynamicIcon
      name="search"
      size={24}
      fallback={() => <div className="w-6 h-6 bg-gray-200 rounded animate-pulse" />}
    />
  );
}
```

**Props for DynamicIcon:**
| Prop | Type | Description |
|------|------|-------------|
| `name` | `IconName` | Icon name (kebab-case from the icon set) |
| `fallback` | `() => JSX.Element \| null` | Shown while loading (use skeleton/spinner) |
| `size`, `color`, `strokeWidth`, `className` | (same as static icons) | Forwarded to the rendered icon |

**Available icon names:**
```tsx
import { iconNames } from 'lucide-react/dynamic';
console.log(iconNames); // ["accessibility", "activity", ..., "zoom-out"]
```

**Manual dynamic import:**
```tsx
import { dynamicIconImports } from 'lucide-react/dynamic';

async function loadIcon(name: string) {
  const icon = await dynamicIconImports[name]();
  // icon.default is the component
  // icon.__iconNode is the raw icon node for custom rendering
}
```

## createLucideIcon — Custom Icon Factory

Build your own Lucide-compatible icons from an `IconNode` array:

```tsx
import { createLucideIcon } from 'lucide-react';
import type { IconNode } from 'lucide-react';

const bananaIconNode: IconNode = [
  ['path', { d: 'M12 2c-1.5 0-3 1-4 3...', key: '1' }],
  ['path', { d: 'M8 12c0 2 1.5 3 4 3...', key: '2' }],
];

const Banana = createLucideIcon('Banana', bananaIconNode);

// Use like any Lucide icon
<Banana size={24} color="#f0c040" />
```

- The first argument is the icon name (used for `displayName` and CSS class generation)
- The CSS class will be `lucide-banana` and `lucide-Banana` (kebab and pascal variants)
- All standard Lucide props (size, color, strokeWidth, etc.) work automatically

## IconNode Type

```typescript
type IconNode = [elementName: 'circle' | 'ellipse' | 'g' | 'line' | 'path' | 'polygon' | 'polyline' | 'rect', attrs: Record<string, string>][];
```

Each entry is a tuple of SVG element tag + attributes object. The attributes must include a unique `key` for React reconciliation.

## Exports Summary

| Export | Path | Type |
|--------|------|------|
| 1,711 icon components | `lucide-react` | `ForwardRefExoticComponent<LucideProps>` |
| `createLucideIcon` | `lucide-react` | Factory function |
| `Icon` (base component) | `lucide-react` | Internal renderer |
| `LucideProvider` | `lucide-react` | Context provider |
| `DynamicIcon` | `lucide-react/dynamic` | Lazy-loading component |
| `iconNames` | `lucide-react/dynamic` | `string[]` |
| `dynamicIconImports` | `lucide-react/dynamic` | Record of lazy imports |
| `LucideProps` (type) | `lucide-react` | Props interface |
| `LucideIcon` (type) | `lucide-react` | Component type |
| `IconNode` (type) | `lucide-react` | Raw icon data type |

## Tree-Shaking

Lucide React is tree-shakeable. Only imported icons are included in the bundle:

```tsx
// GOOD: Only Search is bundled
import { Search } from 'lucide-react';

// BAD: Entire library is bundled (1400+ icons)
import * as Icons from 'lucide-react';
```

The package has `"sideEffects": false` in package.json, enabling aggressive tree-shaking by bundlers (Webpack, Rollup, esbuild, Turbopack).
