# Vercel Design System

> Extracted from vercel.com (May 2026). Vercel uses a custom CSS Modules-based design system called "Geist" with CSS custom properties (design tokens), Tailwind-like utility classes, and container-query-based responsive breakpoints.

## Design Philosophy

Vercel's design identity is **geometric precision with developer credibility**. The aesthetic bridges the gap between creative developer tools and enterprise platform:

- **Dark-mode-native**: Pure black `#000000` canvas as the default backdrop. Light mode is the secondary theme, inverted per section.
- **Code-first credibility**: Geist Mono integration, CLI-style prompts, and syntax-highlighted blocks woven into marketing -- not just documentation.
- **Geometric motif**: Hexagonal dots, triangular blocks, and angular connecting lines form a recurring visual language across backgrounds, icons, and section dividers.
- **Multi-accent strategy**: Unlike single-accent brands (Stripe's indigo, Linear's single purple), Vercel uses per-section accent colors (blue, purple, cyan, pink, green, amber) while keeping blue `#0070f7` as the primary action color.
- **Border-based depth**: Uses `rgba()` border hierarchy (0.06/0.08/0.12/0.15 opacity) instead of heavy box-shadows for surface separation in dark mode.
- **Precision engineering aesthetic**: 6px default radius, geometric triangular arrows, mathematical grid overlays -- everything feels measured and intentional.

---

## Color System

Vercel uses a 100-1000 scale (10 stops per hue) with both hex and LAB color space definitions. The system supports light theme, dark theme, and invert-theme for alternating sections.

### Gray Scale (Neutral)

| Token | Light (hex) | Dark (hex) | Usage |
|-------|-------------|-----------|-------|
| `--ds-gray-100` | `#f2f2f2` | `#1a1a1a` | Subtle backgrounds, hover states |
| `--ds-gray-200` | `#ebebeb` | `#1f1f1f` | Elevated surfaces |
| `--ds-gray-300` | `#e6e6e6` | `#292929` | Borders (light) |
| `--ds-gray-400` | `#eaeaea` | `#2e2e2e` | Default borders |
| `--ds-gray-500` | `#c9c9c9` | `#454545` | Disabled text |
| `--ds-gray-600` | `#a8a8a8` | `#878787` | Secondary text |
| `--ds-gray-700` | `#8f8f8f` | `#8f8f8f` | Placeholder text |
| `--ds-gray-800` | `#7d7d7d` | `#7d7d7d` | Tertiary text |
| `--ds-gray-900` | `#4d4d4d` | `#a0a0a0` | Body text (light) |
| `--ds-gray-1000` | `#171717` | `#ededed` | Primary text, heading text |
| `--ds-background-100` | `#ffffff` | `#000000` | Page background |
| `--ds-background-200` | `#fafafa` | `#000000` | Surface background |

### Alpha Gray (Transparency Variants)

Used for border-based depth, hover interactions, and overlay effects:

| Token | Light | Dark | Purpose |
|-------|-------|------|---------|
| `--ds-gray-alpha-100` | `#0000000d` (5%) | `#ffffff12` (7%) | Subtle hover |
| `--ds-gray-alpha-200` | `#00000015` (8%) | `#ffffff17` (9%) | Hover state |
| `--ds-gray-alpha-300` | `#0000001a` (10%) | `#ffffff21` (13%) | Active state |
| `--ds-gray-alpha-400` | `#00000014` (8%) | `#ffffff24` (14%) | Default border |
| `--ds-gray-alpha-500` | `#00000036` (21%) | `#ffffff3d` (24%) | Strong border |
| `--ds-gray-alpha-600` | `#0000003d` (24%) | `#ffffff82` (51%) | Focus border |
| `--ds-gray-alpha-700` | `#00000070` (44%) | `#ffffff8a` (54%) | Overlay |
| `--ds-gray-alpha-800` | `#00000082` (51%) | `#ffffff78` (47%) | Strong overlay |
| `--ds-gray-alpha-900` | `#000000b3` (70%) | `#ffffff9c` (61%) | Heavy overlay |
| `--ds-gray-alpha-1000` | `#000000e8` (91%) | `#ffffffeb` (92%) | Near-solid overlay |

### Accent Colors (Semantic Palette)

Each semantic color follows the 100-1000 scale. Key accents used on Vercel marketing:

**Blue (Primary Action)** -- `--ds-blue-700`: `#0070f7` (light) / `#0071f6` (dark)

| Token | Light | Dark |
|-------|-------|------|
| `--ds-blue-100` | `#f0f7ff` | `#06193a` |
| `--ds-blue-400` | `#cce7ff` | `#003771` |
| `--ds-blue-500` | `#97ccff` | `#004287` |
| `--ds-blue-600` | `#51aeff` | `#0090ff` |
| `--ds-blue-700` | `#0070f7` | `#0071f6` |
| `--ds-blue-800` | `#005edc` | `#005fd8` |
| `--ds-blue-900` | `#0064e2` | `#50a8ff` |
| `--ds-blue-1000` | `#002453` | `#ebf6ff` |

**Red (Error/Danger)** -- `--ds-red-700`: `#fc0035` (light) / `#f13242` (dark)

**Amber (Warning)** -- `--ds-amber-700`: `#ffb200` (both modes, brand orange)

**Green (Success)** -- `--ds-green-700`: `#28a948` (light) / `#00ab3e` (dark)

**Teal** -- `--ds-teal-700`: `#00a694` (light) / `#00a794` (dark)

**Purple (Preview/Deploy)** -- `--ds-purple-700`: `#9f00f4` (light) / `#9440d5` (dark)

**Pink (Preview alternative)** -- `--ds-pink-700`: `#f22782` (light) / `#f12b82` (dark)

### Legacy Geist Tokens (Backward Compatible)

```css
--geist-foreground: #000;         /* Light: #000, Dark: #fff */
--geist-background: #fff;         /* Light: #fff, Dark: #000 */
--geist-success: #0070f3;         /* Appears light; renamed in newer DS */
--geist-error: #e00;
--geist-warning: #f5a623;
--geist-cyan: #50e3c2;
--geist-violet: #7928ca;
--geist-link-color: var(--ds-blue-700);
```

### Product Gradient Tokens (Workflow Visualization)

```css
/* Develop */
--develop-start-gradient: #007cf0;
--develop-end-gradient: #00dfd8;
--develop-text: #0a72ef;

/* Preview */
--preview-start-gradient: #7928ca;
--preview-end-gradient: #ff0080;
--preview-text: #de1d8d;

/* Ship */
--ship-start-gradient: #ff4d4d;
--ship-end-gradient: #f9cb28;
--ship-text: #ff5b4f;
```

### Dark Mode Invert Theme

Sections can invert to light theme within dark pages using `.invert-theme`:

```css
.dark .invert-theme, .dark-theme .invert-theme {
  --ds-background-100: #fff;
  --ds-background-200: #fafafa;
  --ds-gray-1000: #171717;  /* text becomes dark */
  --ds-gray-100: #f2f2f2;
  /* ... full light palette restored */
}
```

---

## Typography

### Font Families

**Geist Sans** -- Primary typeface, variable weight 100-900, used for all UI and headings.

```css
--font-sans: "Geist", Arial, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
```

- `font-display: swap` (marketing-optimized, text visible during load)
- Variable weight axis: 100 (Thin) through 900 (Black)
- Subset per Unicode range (Cyrillic, Latin Extended, etc.)

**Geist Mono** -- Code, CLI, and technical content.

```css
--font-mono: "Geist Mono", ui-monospace, SFMono-Regular, "Roboto Mono", Menlo, Monaco,
             "Liberation Mono", "DejaVu Sans Mono", "Courier New", monospace,
             "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
```

- `font-display: block` (prevents FOUT during code block load)
- Variable weight axis: 100-900
- Tabular figures for number alignment in counters and pricing tables

### Type Scale

Vercel uses semantic type scale classes rather than raw pixel values:

| Class | Size (approx) | Usage |
|-------|---------------|-------|
| `text-copy-14` | 14px | Body text, descriptions |
| `text-copy-16` | 16px | Body text (default) |
| `text-copy-18` | 18px | Larger body, sub-headlines |
| `text-copy-20` | 20px | Lead paragraphs |
| `text-heading-14` | 14px | Small headings, labels |
| `text-heading-16` | 16px | Card headings |
| `text-heading-20` | 20px | Section sub-headings |
| `text-heading-24` | 24px | Card titles |
| `text-heading-32` | 32px | Section headings |
| `text-heading-40` | 40px | Major section headings |
| `text-heading-48` | 48px | Hero sub-headings |
| `text-label-14` | 14px | Labels, badges, metadata |

**Hero heading**: The main hero title uses a custom font-size (not in utility classes), typically `font-semibold` weight with geometric precision -- often paired with Geist at 950 weight equivalent.

### Form Typography

```css
--geist-form-font: 0.875rem;           /* 14px */
--geist-form-line-height: 1.25rem;     /* 20px */
--geist-form-large-font: 1rem;         /* 16px */
--geist-form-large-line-height: 1.5rem; /* 24px */
--geist-form-small-font: 0.875rem;     /* 14px */
--geist-form-small-line-height: 0.875rem;
```

### Weight Distribution

| Weight | Usage |
|--------|-------|
| 400 | Body text (Geist Sans) |
| 500 | Button text, labels, medium emphasis |
| 600 (`font-semibold`) | Hero headings, section titles |
| 700-900 | Ultra-bold hero text (custom weight axis values) |

---

## Layout System

### Container & Grid

Vercel uses a custom CSS Grid-based layout system with configurable columns, rows, and guide lines:

```css
--geist-page-width: 1200px;
--geist-page-margin: var(--geist-space-gap);  /* 24px */
--geist-page-width-with-margin: calc(1200px + 2 * 24px);
```

**Grid System Core Tokens** (from grid-module):

```css
--max-width: 1080px;        /* Content max width */
--min-width: 368px;         /* Minimum viewport width */
--guide-width: 1px;         /* Grid line thickness */
--horizontal-margin: 2rem;  /* 32px edge padding */
```

The grid system uses a unique approach:
- Dashed grid lines (PNG data-URI border images) overlaid on sections
- Container queries (`container-type: inline-size`) for self-aware responsive grids
- Guides and crosses shown at grid intersections
- Debug mode with color-coded guides (`rgba(255, 204, 109, ...)`)

### Responsive Breakpoints

Vercel uses a mix of media queries and container queries:

| Breakpoint | Value | Usage |
|-----------|-------|-------|
| `sm` | 384px | Small mobile |
| `sm+` | 440px | Medium mobile |
| `@md` | 601px | Container query (tablet) |
| `md` | 768px | Tablet |
| `@lg` | 961px | Container query (desktop) |
| `lg` | 961px | Desktop |
| `xl` | 1200px | Large desktop |
| `1400` | 1400px | Wide desktop |
| `1600` | 1600px | Extra wide |
| `2300` | 2300px | Ultra-wide |

### Grid Column Patterns

```css
.grid-cols-1    { grid-template-columns: repeat(1, minmax(0, 1fr)); }
.grid-cols-2    { grid-template-columns: repeat(2, minmax(0, 1fr)); }
.grid-cols-3    { grid-template-columns: repeat(3, minmax(0, 1fr)); }
.grid-cols-4    { grid-template-columns: repeat(4, minmax(0, 1fr)); }
.grid-cols-10   { grid-template-columns: repeat(10, minmax(0, 1fr)); }
.grid-cols-12   { grid-template-columns: repeat(12, minmax(0, 1fr)); }
.grid-cols-14   { grid-template-columns: repeat(14, minmax(0, 1fr)); }

/* Responsive grid overrides (container query) */
.\@lg\:grid-cols-4   { grid-template-columns: repeat(4, minmax(0, 1fr)); }
.\@lg\:grid-cols-7   { grid-template-columns: repeat(7, minmax(0, 1fr)); }
.\@lg\:grid-cols-8   { grid-template-columns: repeat(8, minmax(0, 1fr)); }
.\@lg\:grid-cols-12  { grid-template-columns: repeat(12, minmax(0, 1fr)); }

/* Bento-style layouts */
.lg\:grid-cols-\[220px_560px\]          { grid-template-columns: 220px 560px; }
.lg\:grid-cols-\[240px_1fr_90px\]        { grid-template-columns: 240px 1fr 90px; }
.grid-cols-\[4ch_max-content_1fr_max-content\] { grid-template-columns: 4ch max-content 1fr max-content; }

/* Auto-fit responsive cards */
.grid-cols-\[repeat\(auto-fit\,minmax\(260px\,1fr\)\)\] { ... }
.grid-cols-\[repeat\(auto-fill\,minmax\(200px\,317px\)\)\] { ... }
```

### Section Anatomy

Vercel sections follow a consistent pattern:

```html
<section class="grid-module__grid grid-module__useContainer">
  <!-- Content with max-width containment -->
</section>
```

- Sections use the grid module for content containment
- Borders between sections: `border border-x-0 border-b-0 border-solid border-gray-400`
- Section spacing uses negative margins for overlapping effects
- `h-min` and `-mb-px` for collapsing margins between sections

---

## Navigation

### Header Structure

The header is a sticky, scroll-aware component with built-in theme awareness:

```html
<header class="header-module__header" data-cdp-scope="{&quot;name&quot;:&quot;header&quot;}">
  <div class="header-module__wrapper header-module__sticky header-module__canGrow 
              header-module__transparentUntilScroll" data-navigation-header="">
    <!-- Logo + Nav + CTAs -->
  </div>
</header>
```

Key header behaviors:
- `transparentUntilScroll` -- Background appears only after scrolling past threshold
- `sticky` -- Fixed position at top
- `canGrow` -- Height can expand for dropdowns
- `data-navigation-header` attribute for JS hooks

### Navigation Menu

The navigation uses a compound component pattern with CSS Modules:

```css
.navigation-menu-module__AENi4G__root      /* Root container */
.navigation-menu-module__AENi4G__list      /* Top-level link list */
.navigation-menu-module__AENi4G__trigger   /* Dropdown trigger */
.navigation-menu-module__AENi4G__chevron   /* Dropdown indicator */
.navigation-menu-module__AENi4G__content   /* Dropdown panel */
.navigation-menu-module__AENi4G__column    /* Dropdown column */
.navigation-menu-module__AENi4G__links     /* Link list within column */
.navigation-menu-module__AENi4G__heading   /* Column heading */
.navigation-menu-module__AENi4G__menuSubLink   /* Individual nav item */
.navigation-menu-module__AENi4G__icon      /* Item icon (flex-column centered) */
.navigation-menu-module__AENi4G__menuSubLinkContent  /* Link text + description */
.navigation-menu-module__AENi4G__menuItemHeading     /* Link heading */
.navigation-menu-module__AENi4G__menuItemText        /* Link description */
```

Dropdown layout: Columns of links with headings, each link having an icon + heading + description structure.

### Navigation States

- **Default**: Transparent background with white/light text (on dark hero)
- **Scrolled**: Opaque background with dark text, subtle border-bottom
- **Mobile**: Hamburger trigger (hidden on desktop), full-screen overlay drawer

---

## Hero Design

Vercel's hero section is grid-based with geometric decoration:

```html
<!-- Mobile hero (hidden on desktop) -->
<section aria-hidden="true" class="grid-module__grid grid-module__useContainer hero-module__mobile">
  ...
</section>

<!-- Desktop hero -->
<section class="grid-module__grid grid-module__useContainer hero-module__root">
  <!-- Geometric background block -->
  <div class="grid-module__block hero-module__gradient"></div>
  <div class="grid-module__block hero-module__triangle"></div>
  
  <!-- Content cell -->
  <div class="hero-module__heroCell">
    <h1 class="text-center font-semibold hero-module__heading">
      <!-- Heading text -->
    </h1>
    <p class="text-center text-gray-900 text-copy-16 @lg:text-copy-20 hero-module__subHeading">
      <!-- Subheading -->
    </p>
    <div class="hero-module__buttons">
      <button class="... button-module__rounded button-module__large button-module__invert">
        <!-- Primary CTA -->
      </button>
      <button class="... button-module__secondary button-module__rounded button-module__large button-module__invert">
        <!-- Secondary CTA -->
      </button>
    </div>
  </div>
</section>
```

Hero CSS characteristics:
```css
.hero-module__heroSection {
  text-align: center;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding-top: 140px;
  padding-bottom: 160px;
  display: flex;
}

@media (max-width: 960px) {
  .hero-module__heroSection {
    padding-top: 70px;
    padding-bottom: 80px;
  }
}
```

Key hero features:
- **Geometric background**: Triangular and gradient blocks overlaid on the grid
- **Dual CTA pattern**: Primary (filled/invert) + Secondary (outlined)
- **Responsive typography**: `text-copy-16 @lg:text-copy-20` (container query scaling)
- **Centered layout**: Flex column, items center, text center
- **Generous vertical padding**: 140px top / 160px bottom (70px/80px mobile)

---

## Button System

Vercel's button system uses `data-geist-button` attribute for targeting in CSS Modules.

### Button Variants

| Variant | Class | Style |
|---------|-------|-------|
| **Default/Primary** | (base) | Solid `var(--ds-gray-1000)`, white text; on hero: invert (white bg, dark text) |
| **Secondary** | `button-module__secondary` | White/black bg with `box-shadow: 0 0 0 1px` border; hover: gray-100 bg |
| **Tertiary** | `button-module__tertiary` | Transparent bg, no border; hover: 8% alpha overlay |
| **Invert** | `button-module__invert` | Inverts color scheme (dark bg sections show white button) |
| **Shadow** | `button-module__shadow` | Adds `--ds-shadow-small`; active: presses down 1px |

### Button Sizes

| Size | Class | Height | Font Size | Padding X |
|------|-------|--------|-----------|-----------|
| **Tiny** | `button-module__tiny` | 24px | -- | -- |
| **Small** | `button-module__small` | 32px | 14px | 6px |
| **Default** | (base) | 40px | 14px | 10px |
| **Large** | `button-module__large` | 48px | 16px | 14px |

### Button Shapes

| Shape | Class | Border Radius |
|-------|-------|---------------|
| **Default** | (base) | 6px |
| **Large (default)** | `button-module__large` | 8px |
| **Rounded/Pill** | `button-module__rounded` | 100px |
| **Circle** | `button-module__circle` | 100% |
| **Tiny** | `button-module__tiny` | 4px |
| **Icon-only** | `button-module__shape` | width = height |

### Button States

```css
/* Default */
[data-geist-button] {
  color: var(--themed-fg, var(--ds-background-100));
  background: var(--themed-bg, var(--ds-gray-1000));
  border-radius: 6px;
  transition: border-color, background, color, transform, box-shadow 0.15s ease;
}

/* Hover (invert) */
[data-hover][data-geist-button].button-module__invert {
  background: var(--themed-hover-bg, #ccc);
}

/* Active/Pressed */
[data-active][data-geist-button] {
  transform: translateY(1px);
  box-shadow: var(--geist-shadow-small);
}

/* Disabled */
[disabled][data-geist-button] {
  background: var(--ds-gray-100);
  color: var(--ds-gray-700);
  cursor: not-allowed;
}

/* Focus */
[data-focus][data-geist-button] {
  outline: var(--ds-focus-ring);
}
```

### Button Implementation Reference

```css
/* Full button CSS custom properties */
.geist-button {
  --x-padding: 10px;
  --height: 40px;
  
  padding: 0 var(--geist-gap-half);
  height: var(--geist-form-height);
  font-size: var(--geist-form-font);
  line-height: var(--geist-form-line-height);
  border-radius: 6px;
  font-weight: 500;
  transition-property: border-color, background, color, transform, box-shadow;
  transition-duration: 0.15s;
  transition-timing-function: ease;
  cursor: pointer;
  user-select: none;
  position: relative;
  outline-offset: 2px;
}
```

---

## Cards & Components

### Card Patterns

Vercel uses bordered surfaces rather than shadow-based cards. Cards are typically:

- Border-based: `border: 1px solid var(--ds-gray-alpha-400)`
- Background: `var(--ds-background-100)` or `var(--ds-background-200)`
- Radius: 6px (`var(--geist-radius)`)
- Padding: 12-24px depending on content density
- Hover: background shifts to `var(--ds-background-200)`

### Framework Display Cards

```html
<div class="frameworks-module__card">
  <!-- Framework icon + name displayed in grid -->
</div>
```

### Context Card (Tooltip/Popover)

```css
.context-card-module__contextCardRoot {
  background: var(--ds-background-100);
  box-shadow: var(--ds-shadow-tooltip), 0 0 0 1px var(--ds-background-100);
  border-radius: 6px;
  position: absolute;
}

.context-card-module__contextCardContent {
  max-width: max-content;
  padding: 12px;
}

/* Arrow/tip with color-coded stroke */
[data-side=top]    { top: 100%; transform: translate(-50%) rotate(0); }
[data-side=right]  { right: 100%; transform: translateY(-50%) rotate(90deg); }
[data-side=bottom] { bottom: 100%; transform: translate(-50%) rotate(180deg); }
[data-side=left]   { left: 100%; transform: translateY(-50%) rotate(270deg); }
```

### Tabs Component

```css
.tabs-module__tabsWrapper {
  background: var(--ds-background-200);
  border-bottom: 1px solid var(--ds-gray-400);
  scrollbar-width: none;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  padding-bottom: 12px;
  display: flex;
  overflow-x: auto;
}
```

### Label / Form Field

```css
.label-module__label {
  color: var(--ds-gray-900);
  margin-bottom: var(--geist-space-2x);  /* 8px */
  max-width: 100%;
  font-size: 13px;
  display: block;
}
```

---

## Motion & Animation

### Transition Tokens

| Duration | Usage |
|----------|-------|
| `0.15s ease` | Button hover/active, micro-interactions |
| `0.2s` | Background transitions |
| `0.25s cubic-bezier(.29, .31, .05, .96)` | Context card position transitions |
| `0.28s` | Duration marker (custom uses) |
| `1.25s` | Code block show/hide |
| `1.5s ease-in-out infinite` | Skeleton/avatar loading |
| `2s ease-out` | Grid disappear animations |
| `1s` | Transition length token |

### Animation Patterns

```css
/* Spinner (loading indicator) */
@keyframes spinner-spin {
  0%   { opacity: 1; }
  100% { opacity: 0.15; }
}
.spinner-module__line {
  animation: spinner-spin var(--animation-duration, 1.2s) linear infinite;
  animation-delay: var(--animation-delay, 0);
}

/* Dialog fade */
.dialog {
  animation: dialog-fadeIn var(--animation-duration) var(--curve) forwards;
}

/* Grid element disappear (geometric background) */
@keyframes grid-xsDisappear { /* 2s ease-out */ }
@keyframes grid-smDisappear { /* 2s ease-out */ }
@keyframes grid-mdDisappear { /* 2s ease-out */ }
@keyframes grid-lgDisappear { /* 2s ease-out */ }

/* Icon button bounce (0.15s) */
@keyframes icon-button-bounce { /* subtle scale bounce */ }

/* Avatar draw-and-erase (onboarding, 1.5s) */
@keyframes avatar-drawAndErase {
  /* 1.5s cubic-bezier(.4, 0, .2, 1) infinite both */
}

/* Skeleton loading */
@keyframes skeleton-loading {
  /* 1.5s ease-in-out infinite reverse */
}

/* Tooltip fade in (0.1s ease-in, 0.4s delay) */
@keyframes tooltip-fadeIn { /* 0.1s ease-in 0.4s forwards */ }

/* Marquee (customer logos, announcements) */
.marquee {
  --marquee-gap: 40px;
  --marquee-speed: 80s;
}
```

### Scroll Effects

- **Sticky header**: `position: sticky` with `backdrop-filter` blur on scroll
- **Transparent-until-scroll**: Header gains background opacity after scroll threshold
- **Scroll-triggered reveals**: Components use staggered delays (0ms / 100ms / 200ms / 300ms) for cascading entrance effects

### Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  .context-card-module__contextCardRoot,
  .context-card-module__contextCardContent,
  .context-card-module__contextCardTip {
    transition: none !important;
  }
}
```

---

## Interaction Patterns

### Focus Ring System

```css
/* Primary focus ring */
--ds-focus-ring: 0 0 0 2px var(--ds-background-100), 0 0 0 4px var(--ds-focus-color);
--ds-focus-color: var(--ds-blue-700);   /* Light mode */
--ds-focus-color: var(--ds-blue-900);   /* Dark mode */

/* Alternative focus border */
--ds-focus-border: 0 0 0 1px var(--ds-gray-alpha-600), 0px 0px 0px 4px #00000029;
```

Focus ring is a double ring: inner white ring (2px) + outer blue ring (4px), ensuring visibility on both light and dark backgrounds.

### Hover State Pattern

Vercel uses `data-hover` attribute (set via JS) instead of CSS `:hover` for consistent behavior:

```css
/* Button hover */
[data-hover][data-geist-button] {
  background: var(--themed-hover-bg, #383838);
}

/* Secondary button hover on dark */
.dark-theme .button-module__secondary[data-hover] {
  background-color: var(--ds-gray-200);
}

/* Tertiary hover */
.button-module__tertiary[data-hover] {
  background-color: var(--ds-gray-alpha-200);
}
```

### Active/Pressed State

```css
[data-active][data-geist-button] {
  box-shadow: var(--geist-shadow-small);
  transform: translateY(1px);
}
```

### Disabled State

```css
.button-module__button[disabled],
.button-module__button[aria-disabled=true] {
  background: var(--ds-gray-100);
  color: var(--ds-gray-700);
  cursor: not-allowed;
}
```

### Counter Animations

Vercel uses CSS counters for stat animations:

```css
[counter-increment: customer-figure] { counter-increment: customer-figure; }
[counter-increment: content]          { counter-increment: content; }
[counter-increment: step-counter]     { counter-increment: step-counter; }
[counter-reset: customer-figure]      { counter-reset: customer-figure; }
[counter-reset: content_var(--start)] { counter-reset: content var(--start); }
```

---

## Spacing System

### Geist Space Scale

Base unit: 4px. All spacing derives from this:

```css
--geist-space: 4px;            /* Base unit */
--geist-space-2x: 8px;         /* Tight spacing */
--geist-space-3x: 12px;        /* Component inner padding */
--geist-space-4x: 16px;        /* Standard padding */
--geist-space-6x: 24px;        /* Section gap */
--geist-space-8x: 32px;        /* Large gap */
--geist-space-10x: 40px;       /* Section padding (small) */
--geist-space-16x: 64px;       /* Section padding (medium) */
--geist-space-24x: 96px;       /* Section padding (large) */
--geist-space-32x: 128px;      /* Hero padding */
--geist-space-48x: 192px;      /* Extra large spacing */
--geist-space-64x: 256px;      /* Maximum spacing */

/* Semantic aliases */
--geist-space-small: 32px;     /* Component gap */
--geist-space-medium: 40px;    /* Form height */
--geist-space-large: 48px;     /* Large form height */
--geist-space-gap: 24px;       /* Default gap */
--geist-space-gap-half: 12px;  /* Default half-gap */
--geist-space-gap-quarter: 8px;

/* Shorthand aliases */
--geist-gap: var(--geist-space-gap);         /* 24px */
--geist-gap-half: var(--geist-space-gap-half); /* 12px */
--geist-gap-quarter: var(--geist-space-gap-quarter); /* 8px */
--geist-gap-double: var(--geist-space-large); /* 48px */
--geist-gap-section: var(--geist-space-small); /* 32px */
```

### Utility Spacing Scale (Tailwind-compatible)

Vercel uses Tailwind-compatible spacing utilities:

```
gap-0 (0)     gap-1 (4px)    gap-2 (8px)    gap-3 (12px)
gap-4 (16px)  gap-5 (20px)   gap-6 (24px)   gap-8 (32px)
gap-10 (40px) gap-12 (48px)  gap-16 (64px)  gap-20 (80px)
gap-24 (96px) gap-28 (112px) gap-64 (256px)
```

### Section Padding

```css
/* Hero */
.hero-module__heroSection {
  padding-top: 140px;      /* ~35x base unit */
  padding-bottom: 160px;   /* ~40x base unit */
}

/* Standard section */
section {
  padding: 6x (24px) / 11x (44px); /* responsive via container queries */
}
```

---

## Shadow System

Vercel uses a dual-layer shadow system: a tight border shadow + atmospheric depth shadow.

```css
/* Base shadow layers */
--ds-shadow-background-border: 0 0 0 1px var(--ds-background-200);
--ds-shadow-border-base: 0 0 0 1px #00000014;     /* Light */
--ds-shadow-border-base: 0 0 0 1px #ffffff25;     /* Dark */

/* Shadow scale */
--ds-shadow-2xs: 0px 1px 1px #0000000a;
--ds-shadow-xs:  0px 1px 2px #0000000a;
--ds-shadow-small: 0px 2px 2px #0000000a;
--ds-shadow-medium: 0px 2px 2px #0000000a, 0px 8px 8px -8px #0000000a;
--ds-shadow-large: 0px 2px 2px #0000000a, 0px 8px 16px -4px #0000000a;
--ds-shadow-xl: 0px 1px 1px #00000005, 0px 4px 8px -4px #0000000a, 0px 16px 24px -8px #0000000f;
--ds-shadow-2xl: 0px 1px 1px #00000005, 0px 8px 16px -4px #0000000a, 0px 24px 32px -8px #0000000f;

/* Composite shadows (border + atmospheric) */
--ds-shadow-border-small: var(--ds-shadow-border-base), var(--ds-shadow-small), var(--ds-shadow-background-border);
--ds-shadow-border-medium: var(--ds-shadow-border-base), var(--ds-shadow-medium), var(--ds-shadow-background-border);
--ds-shadow-border-large: var(--ds-shadow-border-base), var(--ds-shadow-large), var(--ds-shadow-background-border);

/* Context-specific */
--ds-shadow-tooltip: var(--ds-shadow-border-base), 0px 1px 1px #00000005, 0px 4px 8px #0000000a, var(--ds-shadow-background-border);
--ds-shadow-menu: var(--ds-shadow-border-base), 0px 1px 1px #00000005, 0px 4px 8px -4px #0000000a, 0px 16px 24px -8px #0000000f, var(--ds-shadow-background-border);
--ds-shadow-modal: var(--ds-shadow-border-base), 0px 1px 1px #00000005, 0px 8px 16px -4px #0000000a, 0px 24px 32px -8px #0000000f, var(--ds-shadow-background-border);
--ds-shadow-fullscreen: var(--ds-shadow-border-base), 0px 1px 1px #00000005, 0px 8px 16px -4px #0000000a, 0px 24px 32px -8px #0000000f, var(--ds-shadow-background-border);
```

### Dark Mode Shadows

In dark mode, shadows are stronger to compensate for the dark background:

```css
.dark {
  --ds-shadow-2xs: 0px 1px 1px #00000029;
  --ds-shadow-xs:  0px 1px 2px #00000029;
  --ds-shadow-small: 0px 1px 2px #00000029;
  --ds-shadow-medium: 0px 2px 2px #00000052, 0px 8px 8px -8px #00000029;
}
```

---

## Responsive Strategy

### Container Query System

Vercel uses container queries extensively with `@` prefixed breakpoints:

```css
/* Container query breakpoints (respond to parent width, not viewport) */
@container (min-width: 601px) { /* @md rules */ }
@container (min-width: 961px) { /* @lg rules */ }
```

Utility classes:
- `@md:...` -- Apply at 601px+ container width
- `@lg:...` -- Apply at 961px+ container width
- `@xl:...` -- Apply at 1200px+ container width

### Mobile Adaptations

- Hero padding reduces from 140px/160px to 70px/80px at max-width: 960px
- Grid columns collapse from multi-column to single column
- Navigation shifts from horizontal mega menu to hamburger + drawer
- Font sizes scale via container queries: `text-copy-16 @lg:text-copy-20`

### Content Width Strategy

```css
/* Content max-width: 1080px for main grid, 1200px for page */
--geist-page-width: 1200px;
--max-width: 1080px;
--min-width: 368px;

/* Full-bleed to contained transition */
width: clamp(
  calc(var(--min-width) - var(--guide-width)),
  calc(var(--grid-system-width) - var(--guide-width) - (var(--horizontal-margin) * 2)),
  calc(var(--max-width) - var(--guide-width))
);
```

---

## Implementation Reference

### CSS Custom Properties (Core Set)

```css
:root {
  /* ---- Border Radius ---- */
  --geist-radius: 6px;

  /* ---- Spacing ---- */
  --geist-space: 4px;
  --geist-space-2x: 8px;
  --geist-space-4x: 16px;
  --geist-space-6x: 24px;
  --geist-space-8x: 32px;
  --geist-space-16x: 64px;
  --geist-space-gap: 24px;
  --geist-space-gap-half: 12px;
  --geist-page-width: 1200px;
  --geist-page-margin: var(--geist-space-gap);

  /* ---- Form ---- */
  --geist-form-font: 0.875rem;
  --geist-form-line-height: 1.25rem;
  --geist-form-height: var(--geist-space-medium);
  --geist-form-large-font: 1rem;
  --geist-form-large-line-height: 1.5rem;
  --geist-form-large-height: var(--geist-space-large);
  --geist-form-small-font: 0.875rem;
  --geist-form-small-height: var(--geist-space-small);

  /* ---- Fonts (via CSS Modules) ---- */
  --font-sans: "Geist", Arial, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
  --font-mono: "Geist Mono", ui-monospace, SFMono-Regular, "Roboto Mono", Menlo, Monaco,
               "Liberation Mono", "DejaVu Sans Mono", "Courier New", monospace;
}
```

### Geometric Background Pattern (Code Reference)

```css
/* Hexagonal dot grid overlay (from grid system) */
.grid-system {
  --guide-color: var(--ds-gray-400);
  --cross-color: var(--ds-gray-600);
  --guide-width: 1px;
}

.grid-system::before {
  /* Outer border */
  content: "";
  border: var(--guide-width) solid var(--guide-color);
  position: absolute;
  inset: 0;
}

[data-grid] {
  /* Inner grid lines */
  border-bottom: var(--guide-width) solid var(--guide-color);
}

/* Cross markers at intersections */
.grid-module__cross {
  pointer-events: none;
  grid-column-start: var(--cross-column);
  grid-row-start: var(--cross-row);
}

/* Dashed variant for visual lightness */
.systemDashed::before,
.systemDashed [data-grid] {
  border-image: var(--light-dashed-png) 1 round;
}
```

### Button System (Code Reference)

```css
[data-geist-button] {
  outline-offset: 2px;
  color: var(--themed-fg, var(--ds-background-100));
  background: var(--themed-bg, var(--ds-gray-1000));
  padding: 0 var(--geist-gap-half);
  max-width: 100%;
  font-weight: 500;
  font-size: var(--geist-form-font);
  line-height: var(--geist-form-line-height);
  height: var(--geist-form-height);
  border-radius: 6px;
  justify-content: center;
  align-items: center;
  transition-property: border-color, background, color, transform, box-shadow;
  transition-duration: 0.15s;
  transition-timing-function: ease;
  cursor: pointer;
  user-select: none;
  position: relative;
  border: 0;
}

/* Pill variant */
[data-geist-button].rounded {
  border-radius: 100px;
}

/* Large variant */
[data-geist-button].large {
  height: var(--geist-form-large-height);
  font-size: var(--geist-form-large-font);
  border-radius: 8px;
}

/* Secondary variant */
[data-geist-button].secondary {
  --themed-bg: var(--ds-background-100);
  --themed-hover-bg: var(--ds-gray-alpha-200);
  --themed-fg: var(--ds-gray-1000);
  box-shadow: 0 0 0 1px var(--ds-gray-400);
}

/* Tertiary (ghost) variant */
[data-geist-button].tertiary {
  color: var(--themed-bg, var(--ds-gray-1000));
  --themed-border: transparent;
  --themed-hover-bg: var(--ds-gray-alpha-200);
  background: transparent;
}
```

---

## Key Distinctions

### What Makes Vercel Different from Other Developer Platforms

| Aspect | Vercel | Stripe | Linear |
|--------|--------|--------|--------|
| **Background** | Pure black `#000` | Blue-tinted white `#f8fafd` | Near-black `#0d0d0d` |
| **Accent Strategy** | Multi-accent per section | Single indigo `#533afd` | Single indigo `#7170ff` |
| **Typography** | Geist (own typeface) | Sohne Variable (weight 300) | Inter Variable (custom weights) |
| **Depth** | `rgba()` border hierarchy | Dual blue-tinted shadows | Border-only (zero shadows) |
| **Hero Style** | Geometric grid + shapes | Blend-mode text + gradient | Minimal centered text |
| **Code in Marketing** | CLI prompts, syntax blocks | Product mini-screenshots | Inline code in features |
| **Grid System** | CSS Grid + dashed guides | CSS Grid + bento | Flexbox layouts |
| **Animation** | CSS + JS (Geist components) | CSS-only scroll-driven | CSS-only (no JS animation) |
| **Motion Philosophy** | Staggered reveals + geometric animations | Time-of-day gradient cycle | Restrained, single-duration |
| **Font Loading** | `font-display: swap` (sans) / `block` (mono) | `font-display: swap` | `font-display: swap` |

### Ten Defining Characteristics

1. **Own typeface (Geist)**: Vercel commissioned their own variable font family -- a significant brand investment. Both Sans and Mono variants with full 100-900 weight range and international character sets.

2. **Geometric motif across all surfaces**: The hexagon/dot/line pattern is not just a hero background -- it pervades the grid system, icons, section dividers, and loading states.

3. **Design tokens as product**: Vercel's design system ("Geist") is available as open-source packages (`geist` on npm), making their internal tooling external-facing. This is unique among developer platforms.

4. **CSS Grid + container queries forward**: Uses modern CSS features (container queries with `@` prefix syntax, CSS Grid-based guides, `@supports (color: lab(...))` for wide-gamut color) rather than legacy layout methods.

5. **Border-based depth in dark mode**: Avoiding box-shadows entirely on black backgrounds, using `rgba(255,255,255, 0.06-0.24)` borders instead -- creating clean separation without the "glow" effect shadows produce on dark surfaces.

6. **Multi-accent without chaos**: Vercel uses 6 accent colors section-by-section (blue, purple, cyan, pink, green, amber) while maintaining visual coherence through consistent gray-base anchoring and geometric repetition.

7. **Code-as-brand**: CLI prompts (`$ vercel deploy`), Geist Mono in marketing (not just docs), and syntax-highlighted code blocks elevate "developer tool" from description to identity.

8. **Mathematical precision aesthetic**: 4px base unit, 6px default radius, geometric clip-paths for arrows and triangles, counter-based animations -- everything feels calculated rather than eyeballed.

9. **Data-attribute state management**: Uses `data-hover`, `data-active`, `data-focus`, `data-geist-button` attributes (JS-managed) rather than CSS pseudo-classes for consistent cross-browser behavior.

10. **LAB color space progressive enhancement**: Wraps all color tokens in `@supports (color: lab(0% 0 0))` to serve wide-gamut colors to supporting browsers while falling back to sRGB hex for older ones.
