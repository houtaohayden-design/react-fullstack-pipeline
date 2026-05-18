# GitHub -- Design System Extraction
> URL: https://github.com | Extracted: 2026-05-18 | Style: Developer-tool precision -- dark-first, monospace-native, high-contrast accessibility

## Overview
GitHub is the world's largest developer platform with a design system forged by 15+ years of serving 100M+ developers. The design philosophy is "developer-first subtlety": a dark canvas (#0d1117) with precisely calibrated contrast ratios optimized for code readability, a custom variable font (Mona Sans VF), 12 theme variants for accessibility, and a complete motion system driven entirely by CSS (no third-party animation library). The marketing surface layers Primer Brand components (large-scale typography, cinematic reveals) atop the Primer product design system. The result is a design that feels like a professional tool rather than a decorated website -- every color, spacing token, and animation has a functional purpose related to code interaction.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | React + Turbo + PJAX (hybrid SPA/MPA) |
| CSS Architecture | CSS layers: `primer-css-base`, `primer-react`, `recipes` |
| Design System | Primer v2 (open source) + Primer Brand (marketing extension) |
| Font | Mona Sans VF (custom variable font, WOFF2, self-hosted via CDN) |
| Icons | Octicons (SVG, self-hosted via `@primer/octicons-react`) |
| Animation | CSS `@keyframes` + `transition` only -- no GSAP, no Framer Motion |
| Theming | `data-color-mode` + `data-light-theme` / `data-dark-theme` attributes on `<html>` |
| Build | Webpack + hashed filenames + CDN (github.githubassets.com) |

## Layout System

### Breakpoints (5-stop scale)

| Token | Value | Usage |
|-------|-------|-------|
| `--breakpoint-xsmall` | 20rem (320px) | Minimum supported width |
| `--breakpoint-small` | 34rem (544px) | Mobile landscape, small tablets |
| `--breakpoint-medium` | 48rem (768px) | Tablets, narrow desktop |
| `--breakpoint-large` | 63.25rem (1012px) | Desktop navigation break |
| `--breakpoint-xlarge` | 80rem (1280px) | Wide desktop |
| `--breakpoint-xxlarge` | 87.5rem (1400px) | Extra-wide |

### Page Structure
```
<html data-color-mode="dark" data-dark-theme="dark">
├── <header> (HeaderMktg -- light theme, sticky, 64px height)
│   ├── GitHub logo (Octicon lockup SVG)
│   ├── Search bar (global command palette trigger)
│   ├── Navigation links (dropdown mega menus)
│   └── Sign in / Sign up CTA buttons
├── <main> (data-color-mode="dark" -- content in dark theme)
│   ├── lp-IntroHero (hero section)
│   ├── lp-SectionHero (feature showcase sections)
│   ├── lp-SectionTemplate-accordionVisual (accordion features)
│   ├── lp-CustomerStories (customer logo grid + testimonials)
│   ├── lp-SectionTemplate-grid (grid feature sections)
│   └── lp-Cta (call-to-action pre-footer)
└── <footer> (data-color-mode="dark")
    ├── GitHub wordmark SVG
    ├── 4-column link navigation (Product, Platform, Support, Company)
    └── Legal links + newsletter signup
```

### Landing Page Components (86 unique BEM classes with `lp-` prefix)

**Hero Section** (`lp-IntroHero`, `lp-HeroCarousel`):
- Full-bleed dark background with gradient glows
- H1: "The future of building happens together" (Mona Sans display weight)
- Animated carousel with play button

**SectionHero** (`lp-SectionHero`):
- Alternating visual + text two-column layout
- Background color variants: default, `--deeperBlue`
- CSS glow effects for depth
- Embedded product UI video/image frames

**SectionTemplate** variants:
- `accordionVisual` -- Expandable feature details with side visual
- `grid` -- Multi-column feature cards
- `customer` -- Customer logo + testimonial with link

**CustomerStories** (`lp-CustomerStories`):
- Sticky-container logo grid (auto-scrolling)
- Toggle between customer stories and logos
- Testimonial cards with company attribution

**CTA Banner** (`lp-Cta`):
- Dark background with mascot illustrations
- Heading + description + primary button

### Responsive Layout System (Primer)

```
--Layout-content-width    (main content column)
--Layout-gutter           (page margin)
--Layout-sidebar-width    (sidebar pane)
--Layout-pane-width       (secondary pane)
--Layout-column-gap       (horizontal gap between columns)
--Layout-row-gap          (vertical gap between rows)
--Layout-inner-spacing-min/max  (responsive inner padding)
--Layout-outer-spacing-x/y      (responsive outer padding)
```

Stack gaps adapt responsively:
- `--Stack-gap-whenNarrow` (mobile)
- `--Stack-gap-whenRegular` (tablet/desktop)
- `--Stack-gap-whenWide` (wide desktop)

## Color System

### Architecture: 12 Theme Variants

GitHub's color system is built for accessibility at scale:

| Theme Group | Variants |
|-------------|----------|
| **Light** | standard, high contrast, colorblind, tritanopia |
| **Dark** | standard, high contrast, colorblind, tritanopia |
| **Dark dimmed** | standard, high contrast |

Each variant is a complete CSS file with full token overrides. All 12 variants share identical token names; only hex values change.

### Dark Theme (Default)

```css
[data-color-mode="dark"][data-dark-theme="dark"] {
  /* Background hierarchy */
  --bgColor-default: #0d1117;      /* Page background */
  --bgColor-muted: #151b23;        /* Card surfaces */
  --bgColor-emphasis: #3d444d;     /* Active / hover */
  --bgColor-disabled: #212830;     /* Inactive */

  /* Semantic accent */
  --bgColor-accent-emphasis: #1f6feb;   /* Primary accent (GitHub Blue) */
  --bgColor-accent-muted: #388bfd1a;     /* Subtle accent bg */
  --fgColor-accent: #4493f8;            /* Accent text/links */

  /* Semantic feedback */
  --bgColor-success-emphasis: #238636;   /* Green */
  --bgColor-danger-emphasis: #da3633;    /* Red */
  --bgColor-attention-emphasis: #9e6a03; /* Yellow */
  --bgColor-done-emphasis: #8957e5;      /* Purple */
  --bgColor-severe-emphasis: #bd561d;    /* Orange */
  --bgColor-sponsors-emphasis: #bf4b8a;  /* Pink */

  /* Borders */
  --borderColor-default: #3d444d;
  --borderColor-emphasis: #656c76;
  --borderColor-muted: #656c761a;        /* rgba transparent for subtle rules */

  /* Controls */
  --control-bgColor-rest: #212830;
  --control-bgColor-hover: #262c36;
  --control-bgColor-active: #2a313c;
  --control-borderColor-selected: #f0f6fc;
}
```

### Light Theme (Reference)

```css
[data-color-mode="light"][data-light-theme="light"] {
  --bgColor-default: #ffffff;
  --bgColor-muted: #f6f8fa;
  --bgColor-emphasis: #25292e;
  --bgColor-accent-emphasis: #0969da;
  --bgColor-accent-muted: #ddf4ff;
  --fgColor-accent: #0969da;
  --bgColor-success-emphasis: #1f883d;
  --bgColor-danger-emphasis: #cf222e;
  --borderColor-default: #d1d9e0;
  --borderColor-emphasis: #818b98;
}
```

### 16-Color Data Visualization Scale

GitHub includes a full 10-stop display color scale for 16 semantic colors, used in charts, labels, and data visualization:

| Color | Scale 0 (bg-muted) | Scale 5 (emphasis) | Scale 9 (fg-bright) |
|-------|--------------------|---------------------|----------------------|
| Blue | #001a47 | #0576ff | #a3d3ff |
| Green | #122117 | #388f3f | #99e090 |
| Red | #3c0614 | #eb3342 | -- |
| Purple | #211047 | #975bf1 | #c8cbf9 |
| Orange | #311708 | #c46212 | #fac68f |
| Cyan | #001f29 | #0587b3 | #80dbf9 |
| Pink | #2d1524 | #d34591 | -- |
| Gray | #1c1c1c | #6e7f96 | #c4cfde |
| Teal | #041f25 | #106c70 | -- |
| Yellow | #2e1a00 | #895906 | -- |
| Coral | #351008 | #e1430e | #ffc0a3 |
| Lime | #141f0f | #5f892f | #bcda67 |
| Olive | #171e0b | #7a8321 | #e2d04b |
| Brown | #241c14 | #94774c | #dbceb3 |
| Auburn | #271817 | #a86f6b | #dfcac8 |
| Pine | #082119 | #18915e | -- |

### Code Syntax Highlighting (Prettylights)

**Dark theme syntax colors:**
| Token | Color | Usage |
|-------|-------|-------|
| Comment | #9198a1 | Muted gray |
| Keyword | #ff7b72 | Red |
| String | #a5d6ff | Light blue |
| Entity | #d2a8ff | Purple |
| Variable | #ffa657 | Orange |
| Constant | #79c0ff | Blue |
| Entity-tag | #7ee787 | Green |
| Markup-heading | #1f6feb | GitHub blue |
| Markup-deleted | #ffdcd7 / #67060c | Red tint |
| Markup-inserted | #aff5b4 / #033a16 | Green tint |

### Contribution Graph Colors (4-stop intensity scale)
```
Dark:  #151b23 → #033a16 → #196c2e → #2ea043 → #56d364
Light: #ebedf0 → #9be9a8 → #40c463 → #30a14e → #216e39
```

### Design Principles
- **Single accent color**: GitHub Blue (#1f6feb dark / #0969da light) used exclusively for interactive elements
- **Border-based depth**: Box shadows used almost exclusively as inset borders (`inset 0 0 0 1px`), not drop shadows
- **Transparency for hierarchy**: Muted variants use hex alpha (#RRGGBBaa format), not separate lighten/darken steps
- **12-theme accessibility**: The most comprehensive theme system in production web apps

## Typography

### Font Stack

```css
--fontStack-sansSerif: "Mona Sans VF", -apple-system, BlinkMacSystemFont,
  "Segoe UI", "Noto Sans", Helvetica, Arial, sans-serif,
  "Apple Color Emoji", "Segoe UI Emoji";

--fontStack-sansSerifDisplay: "Mona Sans VF", -apple-system, ...;
--fontStack-system: "Mona Sans VF", -apple-system, ...;
--fontStack-monospace: ui-monospace, SFMono-Regular, SF Mono,
  Menlo, Consolas, Liberation Mono, monospace;
```

### Mona Sans VF (Custom Variable Font)
- **Format**: WOFF2, self-hosted on `github.githubassets.com`
- **Axes**: Width (wdth), Weight (wght), Optical Size (opsz)
- **Preload**: `rel="preload" as="font" type="font/woff2" crossorigin`
- **File**: `MonaSansVF-wdth-wght-opsz-902d64c7ad02.woff2`
- **Design**: Geometric sans-serif with developer-friendly legibility, optimized for UI and code-adjacent display
- **Replaced**: Inter/system fonts in 2024 redesign

### Type Scale (6-stop)

| Token | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| `--text-display` | 2.5rem (40px) | 500 (Medium) | 1.375 (snug) | Hero headings |
| `--text-title-large` | 2rem (32px) | 600 (Semibold) | 1.5 | Section titles |
| `--text-title-medium` | 1.25rem (20px) | 600 (Semibold) | 1.625 | Card titles |
| `--text-title-small` | 1rem (16px) | 600 (Semibold) | 1.5 | Small headings |
| `--text-subtitle` | 1.25rem (20px) | 400 (Normal) | 1.625 | Subtitles, taglines |
| `--text-body-large` | 1rem (16px) | 400 (Normal) | 1.5 | Body copy |
| `--text-body-medium` | 0.875rem (14px) | 400 (Normal) | 1.5 | UI text |
| `--text-body-small` | 0.75rem (12px) | 400 (Normal) | 1.625 | Captions |
| `--text-caption` | 0.75rem (12px) | 400 (Normal) | 1.25 | Labels |
| `--text-codeBlock` | 0.8125rem (13px) | 400 (Normal) | 1.5 | Code blocks |
| `--text-codeInline` | 0.9285em | 400 (Normal) | -- | Inline code |

### Font Weights
| Token | Value | Usage |
|-------|-------|-------|
| `--base-text-weight-light` | 300 | Rare, subtle text |
| `--base-text-weight-normal` | 400 | Body, UI |
| `--base-text-weight-medium` | 500 | Display, emphasis |
| `--base-text-weight-semibold` | 600 | Headings, strong emphasis |

### Line Heights
| Token | Value | Usage |
|-------|-------|-------|
| `--base-text-lineHeight-tight` | 1.25 | Captions, labels |
| `--base-text-lineHeight-snug` | 1.375 | Display text |
| `--base-text-lineHeight-normal` | 1.5 | Default, body, UI |
| `--base-text-lineHeight-relaxed` | 1.625 | Subtitles, long-form body |
| `--base-text-lineHeight-loose` | 1.75 | Marketing paragraphs |

### Typography Design Principles
- **Weight duopoly**: 400 (body/UI) + 600 (headings). 500 used only for display.
- **Shorthand tokens**: Each text style combines weight, size, line-height, and font-family into a single token (e.g., `--text-title-shorthand-large: 600 2rem/1.5 "Mona Sans VF"...`)
- **Code proportion**: Inline code at 0.9285em (not a round rem value) to optically match surrounding text
- **Mono for footer headings**: Footer section titles use `text-mono` class (monospace) for a technical aesthetic
- **Negative tracking on display**: Brand headings use tighter tracking for impact

## Motion System

### Duration Token Scale (11-stop)

| Token | Value | Usage |
|-------|-------|-------|
| `--base-duration-0` | 0s | No animation |
| `--base-duration-50` | 50ms | Micro-interactions, hover instant |
| `--base-duration-100` | 100ms | Quick hover transitions |
| `--base-duration-200` | 200ms | Standard hover, color changes |
| `--base-duration-300` | 300ms | Default transition |
| `--base-duration-400` | 400ms | Component reveal |
| `--base-duration-500` | 500ms | Medium reveal |
| `--base-duration-600` | 600ms | Section transitions |
| `--base-duration-700` | 700ms | Larger reveals |
| `--base-duration-800` | 800ms | Marketing scroll reveals |
| `--base-duration-900` | 900ms | Hero animations |
| `--base-duration-1000` | 1000ms (1s) | Full cinematic moments |

### Easing Curve Catalog (5-stop)

| Token | Cubic Bezier | Character | Usage |
|-------|-------------|-----------|-------|
| `--base-easing-ease` | (0.25, 0.1, 0.25, 1) | Standard CSS ease | Default transitions |
| `--base-easing-easeIn` | (0.7, 0.1, 0.75, 0.9) | Deceleration emphasis | Enter animations |
| `--base-easing-easeOut` | (0.3, 0.8, 0.6, 1) | Gentle settle | Exit animations |
| `--base-easing-easeInOut` | (0.6, 0, 0.2, 1) | Smooth symmetric | Looping, complex reveals |
| `--base-easing-linear` | (0, 0, 1, 1) | Mechanical constant | Progress bars, spinners |

### Custom Marketing Easings (from landing-pages CSS)

| Context | Cubic Bezier | Duration | Usage |
|---------|-------------|----------|-------|
| Gallery figure reveal | (0.04, 0.45, 0.18, 1) | 0.4s | Staggered image reveals |
| YouTube poster | (0.17, 0.51, 0.18, 1) | 1s | Video thumbnail scale |
| Mascot slide-in | (0.06, 0.53, 0.05, 1.02) | 2s | Mascot character entrance |
| Mascot slide-reverse | (0.61, 0.17, 0.05, 1.02) | 2s | Mascot character reverse |
| Cinematic visual reveal | (0.21, 0.27, 0.18, 0.99) | 3s | Slow product screenshots |
| Opacity cross-fade | (1, 0, 0.92, 0.18) | 0.8s | Section transitions |

### Keyframe Animation Catalog

**Primer Design System (20 core animations):**

| Animation Name | Pattern | Usage |
|----------------|---------|-------|
| `Overlay--motion-scaleFade` | Scale 0.8+opacity 0 -> 1 | Modals, dialogs |
| `Overlay--motion-slideDown` | TranslateY(-16px) -> 0 + opacity | Dropdowns |
| `Overlay--motion-slideInLeft` | TranslateX(-16px) -> 0 + opacity | Side panels (left) |
| `Overlay--motion-slideInRight` | TranslateX(16px) -> 0 + opacity | Side panels (right) |
| `Overlay--motion-slideUp` | TranslateY(16px) -> 0 + opacity | Bottom sheets |
| `Toast--animateIn` | Scale+opacity entrance | Toast notifications |
| `Toast--animateOut` | Scale+opacity exit | Toast dismiss |
| `Toast--spinner` | Rotate 360deg | Loading spinner |
| `fade-in` | Opacity 0 -> 1 | Content reveal |
| `fade-out` | Opacity 1 -> 0 | Content hide |
| `fade-up` | Opacity 0+TranslateY -> 1 | Scroll reveals |
| `fade-down` | Opacity 0+TranslateY(-) -> 1 | Top-down reveals |
| `grow-x` | ScaleX 0 -> 1 | Horizontal expand |
| `pulse` | Opacity pulse | Attention indicators |
| `checkmarkIn` | Stroke-dashoffset | Checkbox/checkmark |
| `checkmarkOut` | Reverse checkmark | Uncheck animation |
| `AnimatedEllipsis-keyframes` | Dot sequence | Loading ellipsis |
| `SelectMenu-modal-animation` | Scale+opacity | Select menu open |
| `AppFrame-a11yLink-focus` | Opacity pulse | Skip link focus |

**Landing Page Animations (6 marketing-specific):**

| Animation Name | Pattern | Usage |
|----------------|---------|-------|
| `Hero-module__fadeIn` | Opacity 0 -> 1 | Hero content entrance |
| `Hero-module__drawBorderIn` | Border drawing | Hero frame reveal |
| `Hero-module__fadeBorderIn` | Border opacity fade | Hero border fade |
| `Gallery-module__showFigureAnimation` | Opacity+TranslateX offset | Feature figure reveals |
| `YouTubePlayer-module__PosterImage-anim` | Scale 1.5 -> 1 + opacity | Video thumbnail transition |
| `ThankYou-module__sprite-anim` | Background-position steps | Sprite sheet animation |

### Motion Design Principles
- **CSS-only**: No JavaScript animation libraries. All motion via CSS `@keyframes` + `transition`.
- **100ms micro-interactions**: Hover states, button presses, focus rings at 100-200ms
- **300ms default**: Most UI transitions at 300ms (the standard web duration)
- **2-3s cinematic**: Marketing reveals use 2-3s for product screenshots and mascot animations
- **Reduced motion**: `data-a11y-animated-images="system"` on `<html>` respects OS `prefers-reduced-motion`
- **Staggering via CSS custom properties**: Gallery animations use `--delay` and `--offset` CSS variables for staggered cascades
- **Scroll-driven**: Landing page sections use scroll-triggered reveals with `animation: ... backwards` fill mode

## Interaction Patterns

### Navigation System

**HeaderMktg** (Marketing Header):
- White/light background (`data-color-mode=light`) even on dark-themed pages
- 64px height (desktop), responsive collapse
- Sticky positioning with `header-overlay-fixed`
- Hamburger menu toggle on mobile (3-bar animation: `.HeaderMenu-toggle-bar`)
- Search bar: placeholder-style input button that opens a modal overlay (`Overlay--width-large`)
- Sign in (ghost button) + Sign up (bordered button, `color-border-default rounded px-2 py-1`)
- Dropdown menus: `.HeaderMenu-link-wrap` with hover expand

**Command Palette** (`qbsearch-input`):
- Opens as a `modal-dialog` with `.Overlay--width-large`
- Search suggestions with keyboard navigation
- Custom scope filtering (`custom-scopes`)

**Footer Navigation**:
- 4-column grid: Product, Platform, Support, Company
- Monospace section titles (`text-mono color-fg-muted text-normal`)
- Secondary links (`.Link--secondary`) with subtle hover states

### Button System

**5 semantic variants extracted from tokens:**
| Variant | Background | Text/Icon | Usage |
|---------|-----------|-----------|-------|
| Primary | `#1f883d` (green) | White | Main CTA (Sign up, Get started) |
| Outline | `#f0f6fc` (light) | `#388bfd` (blue) | Secondary action |
| Danger | `#da3633` (red) | White | Destructive actions |
| Invisible | Transparent | Inherits | Icon-only, text buttons |
| Inactive | `#262c36` (muted) | `#9198a1` | Disabled state |

**Button sizing:**
| Size | Token | Height |
|------|-------|--------|
| XSmall | `--control-xsmall-size` | 1.5rem (24px) |
| Small | `--control-small-size` | 1.75rem (28px) |
| Medium | `--control-medium-size` | 2rem (32px) |
| Large | `--control-large-size` | 2.5rem (40px) |
| XLarge | `--control-xlarge-size` | 3rem (48px) |

**Hover pattern**: 100ms `background-color` transition
**Focus pattern**: `--outline-focus-width` (2px) with `--focus-outline-offset` (-2px) -- inset outline for no layout shift

### Links

**Marketing links**:
- Default: `color-fg-accent` (blue #4493f8)
- Secondary: `.Link--secondary` class (muted, underline on hover)
- Footer: Secondary links with analytics tracking

### Cards & Surfaces

GitHub uses border-based surface hierarchy, not shadows:
- Default surface: `--bgColor-default` with `--borderColor-default` 1px border
- Elevated surface: `--bgColor-muted` with slightly lighter border
- Active/hover: `--bgColor-emphasis` shift
- Disabled: `--bgColor-disabled`

### Overlay System

**5 overlay animations:**
| Type | Animation | Duration |
|------|-----------|----------|
| Modal/Dialog | `Overlay--motion-scaleFade` | 200-300ms |
| Dropdown | `Overlay--motion-slideDown` | 200ms |
| Side panel (left) | `Overlay--motion-slideInLeft` | 200ms |
| Side panel (right) | `Overlay--motion-slideInRight` | 200ms |
| Bottom sheet | `Overlay--motion-slideUp` | 200ms |

**Overlay sizes:**
| Size | Width | Height |
|------|-------|--------|
| XSmall | 12rem | -- |
| Small | 20rem | 16rem |
| Medium | 30rem | 20rem |
| Large | 40rem | 27rem |
| XLarge | 60rem | 37.5rem |

### Toast Notifications
- Animate in: `Toast--animateIn` (scale + opacity)
- Animate out: `Toast--animateOut` (reverse)
- Spinner: continuous rotation for loading toasts
- Stroke width: `--spinner-strokeWidth-default` (2px)

### Form Controls

**Checkbox/Radio**: Custom checkmark with `checkmarkIn`/`checkmarkOut` animations
**Select Menu**: Opens with `SelectMenu-modal-animation` (scale+fade)
**Toggle switches**: `--controlTrack-bgColor` + `--controlKnob-bgColor` with `--control-checked-bgColor` state

### Focus Management

- Skip link: `--zIndex-skipLink: 600` (highest z-index)
- Focus outline: Inset box-shadow approach (no layout shift)
- `AppFrame-a11yLink-focus` animation for skip link visibility
- `data-a11y-animated-images="system"` respects OS motion preferences
- `data-a11y-link-underlines="true"` for link visibility

## Spacing System

### Base Scale (4px foundation, 19 stops)

| Token | Rem | Px | Usage |
|-------|-----|-----|-------|
| `--base-size-2` | 0.125rem | 2px | Fine gaps |
| `--base-size-4` | 0.25rem | 4px | Tight spacing |
| `--base-size-6` | 0.375rem | 6px | Compact gaps |
| `--base-size-8` | 0.5rem | 8px | Standard gap |
| `--base-size-12` | 0.75rem | 12px | Element spacing |
| `--base-size-16` | 1rem | 16px | Default padding |
| `--base-size-20` | 1.25rem | 20px | Section gaps |
| `--base-size-24` | 1.5rem | 24px | Card padding |
| `--base-size-28` | 1.75rem | 28px | Large spacing |
| `--base-size-32` | 2rem | 32px | Section padding |
| `--base-size-36` | 2.25rem | 36px | Wide spacing |
| `--base-size-40` | 2.5rem | 40px | Section margins |
| `--base-size-44` | 2.75rem | 44px | -- |
| `--base-size-48` | 3rem | 48px | Large sections |
| `--base-size-64` | 4rem | 64px | Hero padding |
| `--base-size-80` | 5rem | 80px | Major sections |
| `--base-size-96` | 6rem | 96px | Very large |
| `--base-size-112` | 7rem | 112px | Hero spacing |
| `--base-size-128` | 8rem | 128px | Maximum gap |

### Negative Spacing (for overlap/bleed effects)
```
--base-size-negative-2  through --base-size-negative-48
(-0.125rem to -3rem, matching positive scale)
```

### Control Component Spacing
```
Control padding (inline): condensed / normal / spacious (3 tiers per size)
Control gap: small (0.25rem) / medium-large (0.5rem) / xlarge (0.5rem)
Control stack gap: small / medium / large (0.5rem-1rem)
```

### Stack & Layout Gaps
| Token | Value | Usage |
|-------|-------|-------|
| `--stack-gap-condensed` | 0.5rem | Tight lists |
| `--stack-gap-normal` | 1rem | Default stacks |
| `--stack-gap-spacious` | 1.5rem | Loose stacks |
| `--stack-padding-condensed` | 0.5rem | Compact containers |
| `--stack-padding-normal` | 1rem | Default containers |
| `--stack-padding-spacious` | 1.5rem | Generous containers |

### Border Radius Scale (4-stop)

| Token | Value | Usage |
|-------|-------|-------|
| `--borderRadius-small` | 0.1875rem (3px) | Checkboxes, code badges |
| `--borderRadius-medium` (default) | 0.375rem (6px) | Buttons, inputs, cards |
| `--borderRadius-large` | 0.75rem (12px) | Modals, large containers |
| `--borderRadius-full` | 624.938rem | Pills, badges, avatars |

### Border Width Scale (3-stop)

| Token | Value | Usage |
|-------|-------|-------|
| `--borderWidth-thin` | 0.0625rem (1px) | Default borders |
| `--borderWidth-thick` | 0.125rem (2px) | Focus rings, emphasis |
| `--borderWidth-thicker` | 0.25rem (4px) | Thick separators |

## Z-Index System

| Token | Value | Layer |
|-------|-------|-------|
| `--zIndex-behind` | -1 | Background decorative elements |
| `--zIndex-default` | 0 | Normal document flow |
| `--zIndex-sticky` | 100 | Sticky headers |
| `--zIndex-dropdown` | 200 | Dropdown menus |
| `--zIndex-overlay` | 300 | Dialogs, drawers |
| `--zIndex-modal` | 400 | Modal dialogs |
| `--zIndex-popover` | 500 | Tooltips, popovers |
| `--zIndex-skipLink` | 600 | Accessibility skip links |

## Component Patterns

### Landing Page Components (from CSS class analysis)

**1. Hero Section** (`lp-IntroHero` / `lp-HeroCarousel`):
- Full-bleed dark container
- H1 branded heading (Mona Sans Display, textWrap-balance)
- Animated background with gradient glows
- Play button for optional video
- Carousel with visual frame + content overlay

**2. Feature Accordion** (`lp-SectionTemplate-accordionVisual`):
- Left: expandable accordion items (h3 headings, expand/collapse)
- Right: synchronized visual (image/UI frame) updates per accordion item
- Active item has `--current` modifier class on visual

**3. Feature Grid** (`lp-SectionTemplate-grid`):
- Multi-column grid layout with `lp-SectionTemplate-grid-column`
- Optional `--noDesktopBorder` modifier
- Optional `--hidden` state for animation

**4. Customer Stories** (`lp-CustomerStories`):
- Background container with logo grid
- Toggle wrapper (customer stories / customer logos)
- Testimonial cards with company logo + description + link
- Sticky container for auto-scrolling logo carousel
- `sectionBlockDivider` for visual separation

**5. CTA Banner** (`lp-Cta`):
- Full-width dark banner
- Mascot illustrations (Octocat) layered with heading
- Description + primary button
- Pre-footer position in page flow

**6. SectionHero** (`lp-SectionHero`):
- Alternating background variants (default, `--deeperBlue`)
- Content with `--hasText` and `--hidden` states
- Visual frame with embedded product UI media (`--copilotUI` variant)
- Glow effects (`lp-SectionHero-glow`)
- Play button for video content

**7. Navigation** (`HeaderMktg`):
- Light theme overlay on dark content
- Collapsible mobile menu with JS toggle
- Dropdown mega menus with link groups

**8. Footer**:
- 4-column responsive grid
- GitHub Octicon lockup SVG logo (128x30)
- Monospace section headings
- Newsletter subscription input
- Legal/copyright links row

### Primer Design System App Components
Beyond the marketing surface, GitHub's product UI uses Primer's full component library:
- **Overlay** (modal, dialog, drawer) with 5 animation variants
- **Button** (5 variants x 5 sizes) with hover/focus/active/disabled states
- **Form controls** (input, textarea, select, checkbox, radio, toggle)
- **Toast** notifications with animate-in/out + spinner
- **SelectMenu** with open/close animation
- **ActionList** with keyboard navigation
- **SegmentedControl** for filter toggles
- **Label** system with 16+ semantic colors
- **Avatar** with stacked variant and shadow
- **Data tables** with sorting, selection
- **Tab navigation**
- **Breadcrumbs**
- **Progress bars**
- **Spinner** in 3 sizes (1rem, 2rem, 4rem)

## Complete Design Token Reference

### Duration
`0s` `50ms` `100ms` `200ms` `300ms` `400ms` `500ms` `600ms` `700ms` `800ms` `900ms` `1s`

### Easing
`cubic-bezier(.25, .1, .25, 1)` (ease)
`cubic-bezier(.7, .1, .75, .9)` (easeIn)
`cubic-bezier(.6, 0, .2, 1)` (easeInOut)
`cubic-bezier(.3, .8, .6, 1)` (easeOut)
`cubic-bezier(0, 0, 1, 1)` (linear)

### Size (4px base, 19 stops)
`2` `4` `6` `8` `12` `16` `20` `24` `28` `32` `36` `40` `44` `48` `64` `80` `96` `112` `128` (px equivalent: x0.25rem)

### Breakpoints
`320px` `544px` `768px` `1012px` `1280px` `1400px`

### Z-Index
`-1` `0` `100` `200` `300` `400` `500` `600`

### Text Size
`0.75rem` `0.875rem` `1rem` `1.25rem` `2rem` `2.5rem`

### Font Weight
`300` `400` `500` `600`

### Line Height
`1.25` `1.375` `1.5` `1.625` `1.75`

### Border Radius
`3px` `6px` `12px` `round`

### Border Width
`1px` `2px` `4px`

## Key Takeaways

1. **12-theme accessibility is the gold standard**: No other production web app ships this many theme variants (light/dark x standard/high-contrast/colorblind/tritanopia). Every token is scoped to a theme attribute, making the system both comprehensive and maintainable.

2. **Border-based depth instead of box shadows**: GitHub's dark theme uses inset borders (`inset 0 0 0 1px`) for surface hierarchy instead of drop shadows. This creates a flat, tool-like aesthetic that doesn't compete with code content.

3. **Single accent discipline**: GitHub Blue (#1f6feb dark / #0969da light) is the ONLY accent color for interactive elements. Green is reserved for success/CTA, red for danger, purple for "done", but blue alone handles all interactive states (links, buttons, focus, selection).

4. **CSS-only motion system**: Zero third-party animation libraries. The complete motion catalog (20 core animations + 6 marketing animations) is pure CSS `@keyframes` and `transition`. This is remarkable for a site of GitHub's scale and demonstrates that CSS is sufficient for production animation.

5. **Mona Sans VF is a brand-defining investment**: GitHub commissioned their own custom variable font with width, weight, and optical size axes. This single font handles everything from 40px display headings to 12px UI captions, replacing multiple font families and creating consistent brand identity.

6. **Transparency-powered palette**: Instead of maintaining separate "muted" color values, GitHub uses hex alpha notation (#RRGGBBaa) for transparent variants. This means accent-muted, border-muted, and bg-muted tokens are derivations of a single base color rather than manually chosen tints.

7. **4px spacing with negative values**: The 19-stop spacing scale (2px-128px) includes matching negative stops for overlap effects. Combined with 3 border-width stops and 4 border-radius stops, this creates a 26-stop geometric token system.

8. **Complete data visualization palette**: 16 semantic colors x 10-stop scales = 160 display tokens for charts, labels, and data viz. This rivals dedicated charting libraries in color sophistication.

9. **Hybrid rendering architecture**: React + Turbo + PJAX creates a progressive enhancement SPA where marketing pages can be server-rendered while the app shell stays client-side. CSS layers (`primer-css-base`, `primer-react`, `recipes`) manage specificity.

10. **Primer is open source**: The entire design system (Primer) is available at https://primer.style -- meaning these patterns are reproducible, documented, and versioned. The marketing layer (Primer Brand) extends Primer with landing-page-specific components.

## Extraction Limitations

- **No JS analysis**: JavaScript bundles were not fetched (budget conserved for CSS). Component behavior, state machines, and React component APIs are inferred from CSS class names and HTML structure.
- **No sub-page analysis**: Only the homepage was analyzed. Key product pages (repository view, issues, pull requests, actions, projects) have their own component patterns not captured here.
- **Site CSS skipped**: The site.css (786KB) exceeded the 500KB resource limit. Layout-specific custom properties may be missed.
- **No visual regression**: Analysis is purely code-based (CSS tokens + HTML structure). Actual rendered appearance, responsive behavior at breakpoints, and dark/light theme switching were not visually verified.
- **Primer Brand tokens**: The marketing-specific design tokens (Primer Brand) use separate CSS properties from the core Primer system. Some brand-specific spacing/color values may differ from the base tokens documented here.
- **Animation timing**: While keyframe names and easing curves were extracted, the exact `animation` shorthand values (delay, fill mode, iteration count) for some components were partially truncated in minified CSS.
