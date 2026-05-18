# Linear — Design System Extraction
> URL: https://linear.app | Extracted: 2026-05-18 | Style: Dark minimal / precision-product

## Overview
Linear is the gold standard for product-tool design — a dark, minimalist interface that feels engineered rather than decorated. The design philosophy is "purposeful minimalism": every pixel serves a function, animation clarifies state changes, and the color palette is nearly monochromatic with a single indigo accent. The type system uses Inter Variable with precisely tuned weights and negative tracking for a crisp, modern feel. The design rejects decorative elements entirely — no gradients, no shadows, no bloat — just razor-sharp typography, strategic use of transparency, and micro-interactions that make the tool feel fast and responsive.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Next.js (App Router) |
| CSS | styled-components v6.1.24 + CSS custom properties |
| Font loading | Self-hosted WOFF2 variable fonts |
| Animation | CSS @keyframes + transitions, no third-party animation library on marketing pages |
| Icons | SVG (inline, fill via `currentColor` / custom properties) |
| Theming | `data-theme` attribute on `<html>`: `dark`, `light`, `glass` |

## Layout System

### Page Grid
```
--grid-columns: 12 (desktop), 8 (tablet <=768px), 4 (mobile <=640px)
--page-max-width: 1024px (app pages)
--homepage-max-width: calc(1344px + var(--homepage-outer-padding) * 2)
--prose-max-width: 624px (article/readable content)
```

### Content Widths
| Token | Value | Usage |
|-------|-------|-------|
| `--page-max-width` | 1024px | App interior pages |
| `--homepage-max-width` | 1344px + 2x padding | Marketing homepage |
| `--prose-max-width` | 624px | Blog/documents/legal |

### Section Rhythm
```
--page-padding-inline: 24px
--page-padding-block: 64px
--homepage-outer-padding: 46px (desktop), 28px (<=1024px), 10px (<=1280px... special), 16px (<=640px)
--page-inset: 32px
--homepage-padding-inset: 32px (desktop), 8px (<=1024px)
```

### Responsive Breakpoints
| Breakpoint | Affects |
|-----------|---------|
| 1280px | `--homepage-outer-padding` shrinks to 10px |
| 1024px | Title scales down 1 step, `--homepage-outer-padding` to 28px, `--homepage-padding-inset` to 8px |
| 768px | `--grid-columns` to 8, homepage padding adjusts |
| 640px | Title scales to title-5, `--grid-columns` to 4, `--homepage-outer-padding` to 16px |

### Section Components
The homepage uses `PageSection_root__kFVv1 PageSection_rootHomepage__2x22W` for each feature section, organized as:
1. **Hero** (`Hero_container__inGFW`) — Full-width with inset padding
2. **GenericHero** (`GenericHero_outer__zcrAV` / `GenericHero_inner__2NG_o`) — Used for feature pages
3. **Feature sections** — Repeated `PageSection` blocks with h2, description, and media
4. **CustomerQuotes** (`CustomerQuotes_container__Grlfj`) — Customer logo carousel + quotes
5. **CTA / Pre-footer** (`CTA_homepagePrefooter__FWdih`) — Final call-to-action before footer
6. **Footer** (`Footer_footer__lJt10`) — Multi-column link grid

## Color System

### Dark Theme (Default)
```css
[data-theme="dark"] {
  color-scheme: dark;

  /* Background hierarchy — near-black ascending stack */
  --color-bg-primary: #08090a;       /* Page background */
  --color-bg-marketing: #010102;      /* Marketing-specific darkest bg */
  --color-bg-secondary: #1c1c1f;      /* Card surfaces */
  --color-bg-tertiary: #232326;       /* Elevated surfaces */
  --color-bg-quaternary: #28282c;     /* Higher elevation */
  --color-bg-quinary: #282828;        /* Highest elevation */
  --color-bg-panel: #0f1011;          /* Panel/drawer backgrounds */
  --color-bg-translucent: rgba(255,255,255,0.05); /* Glass surfaces */

  /* Alternate level system (used in app UI) */
  --color-bg-level-0: #08090a;
  --color-bg-level-1: #0f1011;
  --color-bg-level-2: #141516;
  --color-bg-level-3: #191a1b;
  --color-bg-tint: #141516;

  /* Border hierarchy — transparent whites */
  --color-border-primary: #23252a;
  --color-border-secondary: #34343a;
  --color-border-tertiary: #3e3e44;
  --color-border-translucent: rgba(255,255,255,0.05);
  --color-border-translucent-strong: rgba(255,255,255,0.08);

  /* Text hierarchy — 4-step gray scale */
  --color-text-primary: #f7f8f8;      /* Headlines, body */
  --color-text-secondary: #d0d6e0;    /* Labels, secondary text */
  --color-text-tertiary: #8a8f98;     /* Muted, captions */
  --color-text-quaternary: #62666d;   /* Most faded, placeholders */

  /* Links */
  --color-link-primary: #828fff;      /* Link blue (slightly purple) */
  --color-link-hover: #fff;           /* Link hover goes white */

  /* Accent — the ONE color */
  --color-accent: #7170ff;
  --color-accent-hover: #828fff;
  --color-accent-tint: #18182f;       /* Subtle tinted background */

  /* Brand */
  --color-brand-bg: #5e6ad2;
  --color-brand-text: #fff;

  /* Selection */
  --color-selection-text: var(--color-white);
  --color-selection-bg: color-mix(in lch, var(--color-brand-bg), black 10%);
  --color-selection-dim: color-mix(in lch, var(--color-brand-bg), transparent 80%);

  /* Overlays */
  --color-overlay-dim-rgb: 255,255,255;
  --color-overlay-primary: rgba(0,0,0,0.85);

  /* Invert button (light button on dark) */
  --color-button-invert-bg: #e5e5e6;
  --color-button-invert-bg-hover: #fff;

  /* Focus ring */
  --focus-ring-color: var(--color-indigo);

  /* Header */
  --header-bg: rgba(11,11,11,0.8);
  --header-border: rgba(255,255,255,0.08);
}
```

### Light Theme
```css
[data-theme="light"] {
  --color-bg-primary: #fff;
  --color-bg-secondary: #f9f8f9;
  --color-bg-tertiary: #f4f2f4;
  --color-bg-quaternary: #eeedef;
  --color-bg-quinary: #e9e8ea;
  --color-bg-translucent: rgba(0,0,0,0.02);

  --color-border-primary: #e9e8ea;
  --color-border-secondary: #e4e2e4;
  --color-border-tertiary: #dcdbdd;
  --color-border-translucent: rgba(0,0,0,0.05);
  --color-border-translucent-strong: rgba(0,0,0,0.08);

  --color-text-primary: #282a30;
  --color-text-secondary: #3c4149;
  --color-text-tertiary: #6f6e77;
  --color-text-quaternary: #86848d;

  --color-link-primary: #7070ff;
  --color-link-hover: var(--color-text-primary);

  --color-accent: #7170ff;
  --color-accent-hover: #8989f0;
  --color-accent-tint: #f1f1ff;

  --color-button-invert-bg: #282a30;
  --color-button-invert-bg-hover: #1f2024;

  --color-overlay-dim-rgb: 0,0,0;
  --color-overlay-primary: rgba(255,255,255,0.65);
}
```

### Product Semantic Colors (used across themes)
```css
:root {
  --color-blue: #4ea7fc;              /* (Display P3: 0.431 0.6816 0.9988) */
  --color-red: #eb5757;               /* Errors, destructive */
  --color-green: #27a644;             /* Success, done */
  --color-orange: #fc7840;            /* Warning, in-progress */
  --color-yellow: #f0bf00;            /* Attention */
  --color-indigo: #5e6ad2;            /* Focus, selection */
  --color-teal: #00b8cc;             /* Info */
  --color-linear-plan: #68cc58;       /* Plan feature color */
  --color-linear-build: #d4b144;      /* Build feature color */
  --color-linear-security: #7a7fad;  /* Security feature color */
}
```

### Palette Summary

| Role | Dark Value | Light Value | Usage |
|------|-----------|-------------|-------|
| Page bg | `#08090a` | `#fff` | Root background |
| Surface | `#1c1c1f` | `#f9f8f9` | Cards, panels |
| Border primary | `#23252a` | `#e9e8ea` | Card borders, separators |
| Text primary | `#f7f8f8` | `#282a30` | Headlines, body |
| Text secondary | `#d0d6e0` | `#3c4149` | Labels |
| Text tertiary | `#8a8f98` | `#6f6e77` | Muted text |
| Text quaternary | `#62666d` | `#86848d` | Placeholders, disabled |
| Accent | `#7170ff` | `#7170ff` | Primary action, focus |
| Link | `#828fff` | `#7070ff` | Hyperlinks |
| Selection bg | indigo mix | indigo mix | Text selection |
| Overlay | `rgba(0,0,0,0.85)` | `rgba(255,255,255,0.65)` | Modal backdrops |

**Key insight**: Linear's dark theme uses an extremely subtle background hierarchy — the jump from `#08090a` to `#1c1c1f` is barely perceptible, creating a surface system that feels unified rather than card-based. Borders are the primary separator, not shadows (which are explicitly set to `none` in dark mode).

### Border System
```
--border-hairline: 1px (retina: 0.5px)
--radius-4, 6, 8, 12, 16, 24, 32 (geometric scale)
--radius-rounded: 9999px (pills)
--radius-circle: 50%
```

## Typography System

### Font Stack
```css
/* Primary */
--font-regular: "Inter Variable", "SF Pro Display", -apple-system, BlinkMacSystemFont,
  "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Open Sans",
  "Helvetica Neue", sans-serif;

/* Serif (rare, marketing only) */
--font-serif-display: "Tiempos Headline", ui-serif, Georgia, Cambria,
  "Times New Roman", Times, serif;

/* Monospace */
--font-monospace: "Berkeley Mono", ui-monospace, "SF Mono", "Menlo", monospace;

/* Emoji */
--font-emoji: "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol",
  "Segoe UI", "Twemoji Mozilla", "Noto Color Emoji", "Android Emoji";
```

**Font sources**: Self-hosted `InterVariable.woff2` (v4.1) and `Berkeley-Mono-Variable.woff2` (v3.2), loaded via `@font-face` with `font-display: swap`.

### Weight Scale
```css
--font-weight-light: 300;
--font-weight-normal: 400;
--font-weight-medium: 510;     /* Inter's "Medium" — note 510, not 500 */
--font-weight-semibold: 590;   /* Inter's "Semi Bold" — note 590, not 600 */
--font-weight-bold: 680;       /* Inter's "Bold" */
```

**Key insight**: Linear uses Inter's variable font axis values precisely — 510 for Medium and 590 for SemiBold, not the rounded 500/600. This produces visually optimal weight distinction.

### Type Scale

#### Titles (Headings)
| Token | Size | Line Height | Letter Spacing | Usage |
|-------|------|-------------|----------------|-------|
| `--title-1` | 1.0625rem (17px) | 1.4 | -0.012em | Small card titles, sidebar headings |
| `--title-2` | 1.25rem (20px) | 1.33 | -0.012em | Section sub-headings |
| `--title-3` | 1.5rem (24px) | 1.33 | -0.012em | Modal titles, feature headings |
| `--title-4` | 2rem (32px) | 1.125 | -0.022em | Page section headings |
| `--title-5` | 2.5rem (40px) | 1.1 | -0.022em | Major section titles |
| `--title-6` | 3rem (48px) | 1.0 | -0.022em | Hero sub-headings |
| `--title-7` | 3.5rem (56px) | 1.1 | -0.022em | Large marketing headers |
| `--title-8` | 4rem (64px) | 1.06 | -0.022em | Homepage hero title |
| `--title-9` | 4.5rem (72px) | 1.0 | -0.022em | Max hero (rare) |

All titles use `font-weight: var(--font-weight-semibold)` (590).

#### Body Text
| Token | Size | Line Height | Letter Spacing | Usage |
|-------|------|-------------|----------------|-------|
| `--text-tiny` | 0.625rem (10px) | 1.5 | -0.015em | Badges, legal footnotes |
| `--text-micro` | 0.75rem (12px) | 1.4 | 0 | Labels, keyboard shortcuts, metadata |
| `--text-mini` | 0.8125rem (13px) | 1.5 | -0.01em | Form labels, small UI text |
| `--text-small` | 0.875rem (14px) | calc(21/14) ≈ 1.5 | -0.013em | Navigation, secondary UI |
| `--text-regular` | 0.9375rem (15px) | 1.6 | -0.011em | Default body text |
| `--text-large` | 1.0625rem (17px) | 1.6 | 0 | Feature descriptions, lead paragraphs |

**Key insight**: Linear avoids the conventional 16px body size. The default is `0.9375rem` (15px), which looks sharper on screen and pairs better with their 17px and 20px title sizes. The type scale is unusually tight — body text is only 15px while the hero title goes to 64px (4rem), creating dramatic hierarchy.

#### Static Font Sizes (used in-class only)
```css
--font-size-micro: 0.6875rem;   /* 11px */
--font-size-mini: 0.75rem;      /* 12px */
--font-size-small: 0.8125rem;   /* 13px */
--font-size-regular: 0.9375rem; /* 15px */
--font-size-large: 1.125rem;    /* 18px */
--font-size-title1: 2.25rem;    /* 36px */
--font-size-title2: 1.5rem;     /* 24px */
--font-size-title3: 1.25rem;    /* 20px */
```

### Text Decoration
```css
/* Underlines use thin, offset style */
--underline-thickness: clamp(1px, 0.0625em, 3px);
/* Falls back to from-font when supported */
--underline-offset: clamp(2px, 0.225em, 6px);
```

## Motion & Animation

### Animation Philosophy
Linear's animations are **purposeful and fast** — they clarify state changes rather than decorating them. No animation exceeds 1 second. The most common duration is 0.15-0.25s. All animations respect `prefers-reduced-motion`.

### Speed Tokens
```css
--speed-highlightFadeIn: 0s;       /* Instant appear */
--speed-highlightFadeOut: 0.15s;   /* Quick fade-out */
--speed-quickTransition: 0.1s;     /* Hover micro-changes */
--speed-regularTransition: 0.25s;  /* Standard transitions */
```

### Easing Curves
```css
--ease-in-quad:  cubic-bezier(0.55,0.085,0.68,0.53);
--ease-in-cubic:  cubic-bezier(0.55,0.055,0.675,0.19);
--ease-in-quart:  cubic-bezier(0.895,0.03,0.685,0.22);
--ease-in-quint:  cubic-bezier(0.755,0.05,0.855,0.06);
--ease-in-expo:   cubic-bezier(0.95,0.05,0.795,0.035);
--ease-in-circ:   cubic-bezier(0.6,0.04,0.98,0.335);
--ease-out-quad:  cubic-bezier(0.25,0.46,0.45,0.94);
--ease-out-cubic: cubic-bezier(0.215,0.61,0.355,1);
--ease-out-quart: cubic-bezier(0.165,0.84,0.44,1);
--ease-out-quint: cubic-bezier(0.23,1,0.32,1);
--ease-out-expo:  cubic-bezier(0.19,1,0.22,1);
--ease-out-circ:  cubic-bezier(0.075,0.82,0.165,1);
--ease-in-out-quad:  cubic-bezier(0.455,0.03,0.515,0.955);
--ease-in-out-cubic: cubic-bezier(0.645,0.045,0.355,1);
--ease-in-out-quart: cubic-bezier(0.77,0,0.175,1);
--ease-in-out-quint: cubic-bezier(0.86,0,0.07,1);
--ease-in-out-expo:  cubic-bezier(1,0,0,1);
--ease-in-out-circ:  cubic-bezier(0.785,0.135,0.15,0.86);
```

**Primary easings used**: `--ease-out-quad` for UI transitions, `--ease-out-cubic` for opacity fades, `cubic-bezier(.32,.72,0,1)` for panel slide-ins (custom spring-like overshoot).

### Animation Catalog

#### 1. Image Fade-In Reveal
- **Trigger**: Image `data-loaded=true` attribute set by JS
- **Properties**: `opacity` + `mask` (linear gradient wipe)
- **Duration**: 0.8s
- **Easing**: `animation: Image_load__7V4j_ .8s both`
- **Mechanism**: CSS `@keyframes` — fades opacity 0 to 1 while sliding a gradient mask from 150% to 0%, creating a directional reveal. Initial state uses `--mask-start`, final uses `--mask-end`.
- **JS/CSS**: JS sets `data-fade=true` and `data-loaded=true`, CSS handles the animation.

#### 2. Marquee / Logo Carousel
- **Trigger**: Auto-playing on mount
- **Properties**: `transform: translateX()` / `translateY()`
- **Duration**: 30s per cycle (`--Marquee-duration`)
- **Easing**: `linear` (seamless infinite loop)
- **Gap**: 24px between items (`--Marquee-gap`)
- **Fade edges**: 64px gradient mask on sides (`--Marquee-shadow-size`)
- **Pause on hover**: `animation-play-state: paused` via `Marquee_pauseOnHover__kVgZZ`
- **Reduced motion**: Shows static single row with `[aria-hidden=true]` hidden
- **JS/CSS**: Pure CSS animation

#### 3. Button Hover / Press
- **Trigger**: `:hover`, `:active`
- **Properties**: `filter`, `color` (via custom property swap `--icon-replacement-color`)
- **Duration**: 0.1-0.15s
- **Easing**: `var(--ease-out-quad)`
- **Pattern**: `transition: filter .16s var(--ease-out-quad), transform .16s var(--ease-out-quad)`

#### 4. Link Fade Hover
- **Trigger**: `:hover` on link elements
- **Properties**: `color`, `text-decoration-color`
- **Duration**: 0.12s
- **Easing**: implicit (no explicit easing on some links)
- **Pattern**: `transition: .12s; transition-property: color`

#### 5. Side Panel Slide-In
- **Trigger**: Panel open (state change)
- **Properties**: `transform` (slide from right)
- **Duration**: 0.5s
- **Easing**: `cubic-bezier(.32,.72,0,1)` — custom overshoot curve
- **Backdrop**: `opacity` transition, same duration/easing

#### 6. Collapsible Chevron Rotation
- **Trigger**: Expand/collapse toggle
- **Properties**: `transform: rotate()`
- **Duration**: 0.2s
- **Easing**: `ease-out`
- **Pattern**: `transition: transform .2s ease-out`

#### 7. GitAutomations Dash Animations
- **Trigger**: Auto-playing (SVG stroke dash animations)
- **Properties**: `stroke-dashoffset`, `translate`
- **Duration**: 1-2.5s
- **Easing**: `linear`
- **Mechanism**: CSS `@keyframes` on SVG elements

#### 8. Hero Video Fade
- **Trigger**: Video `data-loaded` attribute
- **Properties**: `opacity`
- **Duration**: 1s
- **Easing**: `var(--ease-out-cubic)`
- **Initial**: `opacity: 0`; `[data-loaded]` → `opacity: 0.6`
- **Pattern**: `transition: opacity 1s var(--ease-out-cubic)`

#### 9. Selection Styling
- **Trigger**: User text selection
- **Properties**: `color`, `background` (via `color-mix()` with indigo)
- **Pattern**: `::selection` pseudo-element with `color-mix(in lch, var(--color-brand-bg), black 10%)`

#### 10. Scrollbar Styling
- **Colors**: `rgba(255,255,255,0.1)` default, `0.2` hover, `0.4` active
- **Sizes**: 6px default, 10px active
- **Gap**: 4px from edge

### Summary: 10 animation patterns detected
| # | Animation | Trigger | Duration | Easing | Layer |
|---|-----------|---------|----------|--------|-------|
| 1 | Image reveal | JS data-loaded | 0.8s | both (keyframes) | CSS |
| 2 | Marquee scroll | Auto-play | 30s | linear | CSS |
| 3 | Button hover | :hover | 0.16s | ease-out-quad | CSS |
| 4 | Link fade | :hover | 0.12s | — | CSS |
| 5 | Panel slide | State toggle | 0.5s | custom bezier | CSS |
| 6 | Chevron rotate | Expand toggle | 0.2s | ease-out | CSS |
| 7 | SVG dash | Auto-play | 1-2.5s | linear | CSS |
| 8 | Hero video fade | data-loaded | 1s | ease-out-cubic | CSS |
| 9 | Text selection | ::selection | instant | — | CSS |
| 10 | Scrollbar | :hover/:active | — | — | CSS |

**Key finding**: Linear uses NO third-party animation library on the marketing site — not GSAP, not Framer Motion. All animations are CSS-only. This is a deliberate engineering choice that keeps the bundle lean and animations frame-rate independent.

## Interaction Patterns

### Navigation
- **Desktop**: Horizontal nav bar with dropdown submenus (`data-orientation="horizontal"`)
- **Mobile**: Hamburger menu trigger (`Header_mobileMenuTrigger__ignIg`)
- **Structure**: Product dropdown → individual feature pages (/intake, /plan, /build, /diffs, /monitor) + /agents, /asks, /insights, /security, /integrations, /mobile
- **Utility links**: /pricing, /customers, /docs, /changelog, /about, /careers, /blog, /now, /contact
- **Auth**: /login (Open app), /signup (Get started)
- **Sticky header**: 72px height with backdrop blur (`--header-blur: 20px`)
- **Header background**: `rgba(11,11,11,0.8)` with transparency for blur effect

### Forms
- **Input style**: Invisible borders until focus, then indigo focus ring
- **Focus ring**: `--focus-ring-width: 2px` solid with `--focus-ring-offset: 2px` (4px on some controls)
- **Focus visible**: Only shown for keyboard navigation (`:focus-visible`); mouse clicks get `outline: none`
- **Tap target**: `--min-tap-size: 44px` minimum

### Search Pattern
- Dedicated search button in sidebar (`Sidebar_searchButton__I0_9C`)
- Command menu pattern (suggested by `--layer-command-menu: 650` z-index)

### Modal/Dialog
- **Z-index layers**: `--layer-dialog: 700`, `--layer-dialog-overlay: 699`
- **Overlay**: `rgba(0,0,0,0.85)` dark, opacity-animated backdrop
- **Panel style**: `background: var(--color-bg-panel)`, 1px translucent border, box-shadow with `0 0 32px 0 rgba(0,0,0,.4)`, 8px border-radius

### Tooltip/Popover
- **Z-index**: `--layer-tooltip: 1100`, `--layer-popover: 600`
- **Context menu**: `--layer-context-menu: 1200`

### Keyboard Accessibility
- **Skip nav**: `--layer-skip-nav: 5000` (highest z-index)
- **Focus visible**: `:focus-visible` gets solid outline, others get transparent outline
- **Cursor**: `cursor: not-allowed` on disabled elements

### Cursor System
```css
--cursor-pointer: pointer;
--cursor-disabled: not-allowed;
--cursor-tooltip: help;
--cursor-none: none !important;
```

### Touch Gestures
- Minimum tap target: `--min-tap-size: 44px`
- `-webkit-tap-highlight-color: transparent` on buttons
- Viewport: `viewport-fit=cover` with safe area insets respected in padding

## Spacing & Rhythm

### Base Unit
The spacing system is based on 4px increments, using a geometric-ish scale: 2, 3, 4, 5, 6, 8, 10, 12, 14, 16, 18, 20, 24, 32, 40, 48.

### Token Reference
| Token | Value | Usage |
|-------|-------|-------|
| `--page-padding-inline` | 24px | Page horizontal padding |
| `--page-padding-block` | 64px | Page vertical padding |
| `--page-inset` | 32px | General inset spacing |
| `--header-height` | 72px | Fixed header |
| `--header-blur` | 20px | Backdrop filter blur |
| Min tap size | 44px | Touch target minimum |
| Card padding | 24px 32px | Customer quote cards |
| Section gap | 40px, 48px | Between major sections |
| Component gap | 4-24px | Within components (flex gap) |

### Common Gap Values (from atomic CSS classes)
```
2px, 3px, 4px, 6px, 8px, 10px, 12px, 14px, 16px, 18px, 20px, 24px, 32px, 40px, 48px
```

### Common Padding Values
```
0, 2px, 3px, 4px, 5px, 6px, 8px, 10px, 12px, 16px, 20px, 24px, 32px
```

### Border Radius Scale
```
--radius-4: 4px;     /* Inputs, small controls */
--radius-6: 6px;
--radius-8: 8px;     /* Cards, panels, dialogs */
--radius-12: 12px;   /* Larger cards */
--radius-16: 16px;
--radius-24: 24px;
--radius-32: 32px;
--radius-rounded: 9999px;  /* Pills, badges */
--radius-circle: 50%;      /* Avatars, status dots */
```

## Component Library

### Buttons
Linear uses a variant + size system via BEM-ish CSS modules.

**Variants**:
| Class suffix | Variant | Usage |
|-------------|---------|-------|
| `variant-invert` | Invert | Primary CTA — white bg on dark, dark bg on light |
| `variant-secondary` | Secondary | Outline/ghost style, secondary actions |
| `variant-ghost` | Ghost | Minimal, icon-only, or inline actions |

**Sizes**:
| Class suffix | Size | Typical height |
|-------------|------|---------------|
| `size-large` | Large | ~48px, homepage CTAs |
| `size-small` | Small | ~36px, inline actions |
| `size-mini` | Mini | ~28px, icon buttons, compact UI |

**States**:
- `:hover`: filter + transform shift, icon color swaps
- `:active`: icon-replacement-color changes
- `:disabled`: reduced opacity, `cursor: not-allowed`
- `:focus-visible`: indigo focus ring

**Base reset class**: `reset_reset-button__5vBZ4` — strips all native button styling, sets `cursor: pointer`, `user-select: none`, `-webkit-tap-highlight-color: transparent`

**Example composition**:
```
Button_root__Stmhv Button_variant-invert__ECHZN Button_size-large__fvxeb
```

### Cards (Customer Quotes)
```
CustomerQuotes_customerCard__51MqY
```
- **Structure**: Flex column, 8px border-radius, 24px 32px padding, 480px fixed height
- **Background**: Semi-transparent layer
- **Hover**: `transition: filter .16s var(--ease-out-quad)`
- **Quotes**: Uses CSS `quotes` property for auto-quotation marks (`"“" "”" "‘" "’"`)

### Hero Sections

#### Homepage Hero (`Hero_*`)
- **Container**: Full-width with `--homepage-outer-padding` insets
- **Title**: `--title-8` (4rem/64px) at desktop, scales down through breakpoints to `--title-5` (2.5rem) at mobile
- **Description**: Below title, `--text-regular` (15px), tertiary color
- **CTA area**: Flex row with large invert button
- **New feature link**: Pill/badge-style link above title (`Hero_newFeatureLink__PHt6b`)
- **Pulse dot**: Animated status indicator (`Hero_pulseDot__oDuNr`)

#### Pillar Hero (`PillarHero_*`)
Used on feature pages:
- **Height**: 460px padding-top + 128px padding-bottom (responsive)
- **Video background**: Object-fit cover, 0.6 opacity, 1s fade-in
- **Gradient overlay**: `linear-gradient(to bottom in oklab, rgba(8,9,10,0) 0%, ...75%, var(--color-bg-primary) 100%)`
- **Title protection**: Radial gradient + blur filter behind title text for readability over video

### Feature Sections (`PageSection_*`)
Each feature section follows a consistent pattern:
```html
<section class="PageSection_root__kFVv1 PageSection_rootHomepage__2x22W">
  <h2 style="max-width:18ch">Feature heading</h2>
  <p>Feature description</p>
  <div><!-- Illustration/media --></div>
</section>
```
- **Heading width**: Constrained to `max-width: 18ch` for optimal readability
- **Spacing**: Consistent alternating sections (Plan, Build, Monitor, etc.)

### Footer (`Footer_footer__lJt10`)
- **Structure**: Multi-column grid of links
- **Sections**: Product, Features, Company, Resources, etc. (each with `Footer_sectionTitle__PrfeJ`)
- **Bottom**: Logo + copyright
- **Style**: Minimal, text-only, no decorative elements

### CTA / Pre-footer (`CTA_*`)
- **Layout**: Centered text block with heading + button
- **Heading**: `max-width:16ch`, large title size
- **Action**: Large invert button

### Marquee Component
```
Marquee_root__pXJQM
```
- **Purpose**: Auto-scrolling horizontal content (logos, features)
- **Animation**: Pure CSS `@keyframes` with `translateX`/`translateY`
- **Configuration**:
  - `--Marquee-gap: 24px`
  - `--Marquee-duration: 30s`
  - `--Marquee-shadow-size: 64px` (edge fade width)
- **Variants**: Horizontal (default) or vertical (`Marquee_vertical__gqGv1`)
- **Features**:
  - Pause on hover (`Marquee_pauseOnHover__kVgZZ`)
  - Edge fade masks (can be disabled: `Marquee_noFade__6oc03`)
  - Duplicate content for seamless looping
  - `prefers-reduced-motion` fallback to static display

### Carousel Component
```
Carousel_item__k73Fv
```
Used in Benefits section for rotating feature cards.

### Scrollbar
Custom minimal scrollbar:
```css
--scrollbar-color: rgba(255,255,255,0.1);
--scrollbar-color-hover: rgba(255,255,255,0.2);
--scrollbar-color-active: rgba(255,255,255,0.4);
--scrollbar-size: 6px;
--scrollbar-size-active: 10px;
--scrollbar-gap: 4px;
```

### Z-Index Layer System
Linear uses a disciplined z-index scale (no magic numbers):
```
--layer-debug: 5100
--layer-skip-nav: 5000
--layer-context-menu: 1200
--layer-tooltip: 1100
--layer-toasts: 800
--layer-dialog: 700
--layer-dialog-overlay: 699
--layer-command-menu: 650
--layer-popover: 600
--layer-overlay: 500
--layer-header: 100
--layer-scrollbar: 75
--layer-footer: 50
--layer-3: 3
--layer-2: 2
--layer-1: 1
```

## Icon System
- **Implementation**: Inline SVGs
- **Color control**: Via `fill: var(--icon-color)` with cascading overrides
- **Pattern**: Icons have `--icon-default-color`, `--icon-replacement-color` (on hover/active), `--icon-color: var(--icon-replacement-color, var(--icon-default-color))`
- **Hover behavior**: Icons inside buttons swap to `var(--btn-highlight-color)` on hover
- **Size**: 16px is standard, 14px for compact, 20px for large

## Shadow System
Linear deliberately MINIMIZES shadows in dark mode:
```css
--shadow-none: 0px 0px 0px transparent;
--shadow-tiny: var(--shadow-none);
--shadow-low: var(--shadow-none);
--shadow-medium: var(--shadow-none);
--shadow-high: var(--shadow-none);
```
All shadow tokens resolve to `none` in dark mode — Linear uses borders and background elevation instead. Light mode likely restores shadow values.

## Key Takeaways

### 1. Border-Based Separation, Not Shadows
Linear's dark theme uses zero shadows. Surface hierarchy is communicated through subtle background color shifts (from `#08090a` to `#1c1c1f` to `#232326`) and translucent borders (`rgba(255,255,255,0.05)` to `0.08`). This creates a flat, modern, engineering-tool aesthetic. This is the single most distinctive design decision.

### 2. Custom Font Weight Values
Linear uses Inter's actual variable axis values: 510 for Medium (not 500) and 590 for SemiBold (not 600). These precise values produce better optical weight distinction than the rounded CSS equivalents. Combined with negative letter-spacing on all headings (-0.012em to -0.022em), the typography feels precision-tuned.

### 3. Aggressively CSS-Only Animation
Despite being a design-forward product, Linear uses exactly zero JavaScript animation libraries on its marketing site. Every animation — marquee scroll, image reveal, button hover, panel slide, SVG dash — is pure CSS with `@keyframes` and `transition`. This is a masterclass in how far CSS animation can go when used deliberately. The bundle stays lean, animations are GPU-composited, and `prefers-reduced-motion` is respected natively.

### 4. The 4-Stop Text Color Scale
Linear's text color system uses exactly 4 stops: primary (#f7f8f8, near-white), secondary (#d0d6e0, light gray), tertiary (#8a8f98, mid-gray), and quaternary (#62666d, dark gray). Nothing is ever pure white or pure black. This creates a softer, more readable visual hierarchy than high-contrast approaches. The quaternary color is specifically reserved for the most de-emphasized content (placeholders, disabled states, legal fine print).

### 5. 15px Body Text Default
Rather than the web-standard 16px, Linear uses 0.9375rem (15px) as its default body size. Paired with 17px headings (title-1) and the dramatic jump to 64px hero titles, this creates an unusually high hierarchy ratio while keeping UI text compact and information-dense. The 1.6 line-height on body text ensures readability despite the smaller size.

### 6. The Single Accent Color Strategy
Linear uses exactly ONE accent color: indigo/purple (#7170ff / #5e6ad2). Everything else is grayscale. Links, focus rings, selection, brand backgrounds, and CTAs all derive from this single hue. Feature-specific colors (plan=green, build=gold, security=indigo) are used sparingly and only in product illustrations, not in the UI chrome itself. This creates exceptional visual coherence.

### 7. Disciplined Z-Index Scale
Linear names and numbers every z-index layer from 1 to 5100, with clear semantic meaning. There are no magic numbers. The scale respects a logical hierarchy: footer (50) < scrollbar (75) < header (100) < overlay (500) < popover (600) < command menu (650) < dialog (700) < toasts (800) < tooltip (1100) < context menu (1200) < skip nav (5000). This is engineering discipline applied to visual design.

### 8. The Image Mask Reveal Pattern
Image loading uses a clever CSS mask animation instead of a simple opacity fade. The mask starts at 150% offset (% position) and animates to 0%, creating a directional wipe effect that feels more intentional than a flat fade. Combined with the 0.8s duration, it creates a premium "images materialize" feel without JavaScript.

### 9. Zero-Decoration Dark Mode
Linear's dark mode has no gradients (except in hero video overlays), no glows, no decorative elements. The entire interface is constructed from flat colors and 0.5-1px hairline borders. Even the "glass" theme uses transparency rather than actual backdrop-filter blur for its translucent surfaces. This rejection of decoration is itself a strong design opinion.

### 10. Marquee as Primary Motion Element
The CSS marquee component (30s duration, linear, auto-scrolling) is the primary persistent animation on the site. It's used for customer logos and feature callouts. The edge-fade mask (64px gradient) prevents hard clipping. The pause-on-hover behavior respects user attention. This single component covers what many sites would use JavaScript libraries (GSAP, Swiper) to accomplish.
