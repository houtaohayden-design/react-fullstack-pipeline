# animal-island-ui -- Patterns & Design System

## Styling Approach

### Architecture: Less + CSS Modules + CSS Custom Properties

The library uses a three-layer styling approach:

1. **Less Modules** (`*.module.less`): Each component has its own scoped CSS Module file. Class names compile to `animal-[local]-[hash]` format, preventing conflicts.

2. **Less Variables** (`src/styles/variables.less`): Design tokens as Less variables. Automatically injected into every component's `.module.less` via Vite config -- no explicit `@import` needed per component.

3. **CSS Custom Properties** (`:root { --animal-* }`): The global stylesheet exposes all design tokens as CSS custom properties on `:root`. Available for runtime theme customization by consumers.

### Design Token Categories

| Category | CSS Variable Prefix | Example |
|----------|---------------------|---------|
| Colors | `--animal-*-color` | `--animal-primary-color: #19c8b9` |
| Font | `--animal-font-*` | `--animal-font-family`, `--animal-font-size-base` |
| Spacing | `--animal-spacing-*` | `--animal-spacing-sm` (8px), `--animal-spacing-lg` (16px) |
| Border Radius | `--animal-border-radius-*` | `--animal-border-radius-base` (18px) |
| Shadow | `--animal-shadow-*` | `--animal-shadow-base`, `--animal-shadow-lg` |
| Motion | `--animal-motion-*` | `--animal-motion-duration-base` (0.25s) |
| Size | `--animal-height-*` | `--animal-height-base` (40px) |

### Font Stack

Bundled via `@fontsource` (not external CDN):
```
Nunito, 'Noto Sans SC', 'Zen Maru Gothic',
'HarmonyOS Sans SC', 'MiSans',
-apple-system, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif
```

- **Nunito**: Latin characters -- rounded, friendly, chubby letterforms (weights: 500, 700, 900)
- **Noto Sans SC**: Chinese (Simplified) -- clean, rounded (weights: 400, 500, 700)
- **Zen Maru Gothic**: Japanese -- warm, circular (weights: 500, 700, 900)
- Font weights: body=500, buttons/headings=600-700, time digits=900, placeholder=400

---

## Color System

### Core Palette

| Role | Color | Notes |
|------|-------|-------|
| Primary accent | `#19c8b9` | Mint teal -- focus rings, collapse icons, checkbox fill |
| Primary bg | `#f8f8f0` | Warm parchment -- default background |
| Content bg | `rgb(247,243,223)` | Slightly warmer -- card/modal content area |
| Body text | `#725d42` | Warm brown -- component body text |
| Header text | `#794f27` | Darker brown -- sidebar, headings |
| Secondary text | `#9f927d` | Muted brown -- labels, hints |
| Disabled text | `#c4b89e` | Light tan -- disabled/placeholder |
| Focus yellow | `#ffcc00` | Game-style focus highlight (NOT blue) |
| 3D shadow | `#bdaea0` | Button bottom shadow color |
| Input shadow | `#d4c9b4` | Input bottom shadow color |

### Status Colors

| Status | Color | Active |
|--------|-------|--------|
| Success | `#6fba2c` | `#5a9e1e` |
| Warning | `#f5c31c` | `#dba90e` |
| Error | `#e05a5a` | `#c94444` |
| Switch ON | `#86d67a` | (border: `#6fba2c`) |

### 13 Card Colors (NookPhone App Palette)

Each color maps to a NookPhone app theme. The text color is auto-selected for contrast.

| Color | Background | Text | NookPhone App |
|-------|-----------|------|---------------|
| `default` | `rgb(247,243,223)` | `#725d42` | (Parchment) |
| `app-pink` | `#f8a6b2` | `#fff` | Shopping |
| `purple` | `#b77dee` | `#fff` | Camera |
| `app-blue` | `#889df0` | `#fff` | App (Messages) |
| `app-yellow` | `#f7cd67` | `#725d42` | Critterpedia |
| `app-orange` | `#e59266` | `#fff` | DIY Recipes |
| `app-teal` | `#82d5bb` | `#fff` | Variant |
| `app-green` | `#8ac68a` | `#fff` | Design |
| `app-red` | `#fc736d` | `#fff` | Map |
| `lime-green` | `#d1da49` | `#3d5a1a` | Chat |
| `yellow-green` | `#ecdf52` | `#725d42` | -- |
| `brown` | `#9a835a` | `#fff` | -- |
| `warm-peach-pink` | `#e18c6f` | `#fff` | -- |

---

## Signature Design Patterns

### Nintendo Button Press (3D Shadow)

The library's most defining visual language feature. ALL clickable elements have a bottom `box-shadow` that simulates a physical game button:

- **Default**: `box-shadow: 0 5px 0 0 #bdaea0`
- **Hover**: `box-shadow: 0 6px 0 0 #bdaea0; transform: translateY(-1px)`
- **Active**: `box-shadow: 0 1px 0 0 #bdaea0; transform: translateY(2px)`
- **Transition**: `all 0.25s cubic-bezier(0.4, 0, 0.2, 1)`

Cards have a subtle float instead of press: `transform: translateY(-4px)` on hover.

### Pill Shapes

- Buttons: `border-radius: 50px` (middle size), `12px` (small), `24px` (large)
- Inputs: `border-radius: 50px` (middle/large), `40px` (small)
- Cards: `border-radius: 20px` (default), `40px 35px 45px 38px` (title card organic blob)
- Checkbox box: `border-radius: 8px`
- Code block: `border-radius: 20px`
- Minimum anywhere: `12px` -- no sharp right-angle interactive elements

### Warm, Never Cool

Critical design constraint:
- Never use pure black `#000` or `#111` text -- always warm brown tones
- Never use cold blue focus rings (`#0066ff`) -- use `#ffcc00` (yellow) or `#19c8b9` (teal)
- Never use cold gray backgrounds -- always warm parchment tones
- Font-weight never below 400

---

## When to Use This Library

**ONLY when the user explicitly asks for:**
- "动物森友会风格" / "动森风格" (Animal Crossing style)
- "Animal Island UI" or "animal-island-ui"
- A warm, cozy, nature-themed UI
- Pill-shaped buttons with 3D press effect
- NookPhone-style app interface
- Pastel game-inspired UI

**Do NOT use when the user wants:**
- Enterprise / professional UI
- Material Design, Ant Design, or any standard design system
- Minimalist flat design
- Dark mode (library doesn't support it; warm parchment is the only theme)

---

## Compatibility

### With Tailwind CSS
**Compatible but not designed for it.** The library uses Less CSS Modules, not Tailwind classes. You can use Tailwind in your app alongside this library -- just don't expect to theme animal-island-ui components with Tailwind utility classes. Use CSS custom properties (`--animal-*`) in your own CSS to match the design language.

### With react-bits
**Compatible.** react-bits provides animation primitives that can enhance animal-island-ui components. The libraries don't conflict stylistically -- both work at the component level. However, animal-island-ui's 3D button-press effect should not be overridden with react-bits button animations.

### With Other UI Libraries
**Not designed to be mixed.** The warm-parchment, pill-shaped, 3D-shadow design language is highly specific. Mixing with Material UI, Ant Design, or other opinionated libraries will create visual inconsistency. Use animal-island-ui as the sole UI library for any page/section that needs this aesthetic.

### React Version Support
`react >= 17.0.0`, `react-dom >= 17.0.0`

---

## Theme Customization

### CSS Custom Properties Override

Override the `:root` custom properties in your own CSS:

```css
:root {
  --animal-primary-color: #19c8b9;
  --animal-text-color: #827157;
  --animal-bg-color: #f8f8f0;
  --animal-border-radius-base: 20px;
  --animal-motion-duration-base: 0.3s;
}
```

This allows customizing the color palette, border radii, animation speeds, and spacing without touching component source.

### Tailwind-Consistent Theming

If you use Tailwind, define animal-island-ui colors as Tailwind CSS custom properties or in your `tailwind.config`:

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        'animal-primary': '#19c8b9',
        'animal-text': '#725d42',
        'animal-bg': '#f8f8f0',
        // ... match to the 13 card colors as needed
      }
    }
  }
}
```

Include `animal-island-ui/style` AFTER your Tailwind base styles to ensure the CSS custom properties cascade correctly.

### Card Color Extension

The 13 card colors are hard-coded in the Card component (not configurable via CSS custom properties). To create a new card color, wrap a `<Card>` with a styled div or use the `style` prop to override `backgroundColor` and `color`.

### Extending Less Variables (Advanced)

If you fork or build from source, edit `src/styles/variables.less` to change the base design tokens. The `default.less` theme maps Less vars to CSS custom properties, so both internal components and external theme overrides will pick up changes.
