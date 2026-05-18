# Airbnb Design System — Complete Extraction

**Source:** https://www.airbnb.com  
**Date:** 2026-05-18  
**Platform:** Web (React + proprietary DLS atomic CSS)  
**Category:** design-inspiration  
**Style:** Warm hospitality marketplace — Rausch coral-pink signature accent, Airbnb Cereal VF custom typeface, glass-morphism navigation, spring-physics animation engine, atomic CSS architecture (700+ utility classes), horizontal peek-carousel layout system, 8-step responsive breakpoint cascade

---

## 1. Overview

Airbnb's public-facing web platform uses a proprietary **Design Language System (DLS)** implemented as an **atomic CSS utility framework** with **CSS custom properties** for all design tokens. The system is compiled by **Linaria** (zero-runtime CSS-in-JS), resulting in a single inline `<style>` tag containing ~700 atomic utility classes and 550+ CSS custom property design tokens.

### Architecture Highlights

- **Linaria CSS-in-JS**: Zero-runtime; compiles to static CSS at build time
- **Atomic CSS**: Single-purpose utility classes following `atm_<property>_<value>` convention, each setting exactly one CSS declaration
- **Token-driven theming**: Every visual decision refers to a `--palette-*`, `--typography-*`, `--spacing-*`, `--motion-*`, or `--corner-radius-*` token
- **DLS override layer**: `--dls-*` custom properties allow per-component overrides of base tokens (e.g., `--dls-button_border-radius`, `--dls-icon-button_color`)
- **RTL-first**: Direction-aware classes using `dir-ltr` / `dir-rtl` selector prefixes; LTR and RTL gradient variants stored as separate tokens
- **Responsive breakpoint cascade**: 7 breakpoints (0, 375, 744, 950, 1128, 1440, 1920) + landscape variants + min-height-aware (480px threshold)
- **Reduced motion support**: Spring animations wrapped in `@media (prefers-reduced-motion: no-preference)`
- **Safe area handling**: `env(safe-area-inset-*)` used throughout for notched device support

---

## 2. Layout System

### Page Shell & Max Width

| Token | Value | Usage |
|-------|-------|-------|
| `--page-shell-max-content-width` | 1920px (default) | Overall page max-width |
| `--explore_max-width` | 1344px (1440+) / 1824px (1920+) | Explore/content sections |
| `--explore_padding-inline` | 16px / 24px / 32px / 48px | Responsive side padding |

### Responsive Breakpoint Cascade

| Breakpoint | Name | explore padding | peek variable | Use Case |
|------------|------|-----------------|---------------|----------|
| 0px+ | base | 16px | `peek_sm` | Mobile |
| 375px+ | sm | 24px | `peek_sm` | Small phone |
| 744px+ | md | 24px | `peek_md` | Tablet |
| 950px+ | mdp | 32px | `peek_mdp` | Small desktop |
| 1128px+ | lg | 32px | `peek_lg` | Desktop |
| 1440px+ | xl | 48px | `peek_xl` | Large desktop |
| 1920px+ | xxl | 48px (1824px max-width) | `peek_xl` | Ultra-wide |

**Landscape variant**: Separate peek values (`peek_sm_landscape`, etc.) for when height < 480px.

### Header Height

| Breakpoint | Header Height | Token |
|------------|--------------|-------|
| Default | 80px | `--header_v2_height-px: 80px` |
| 1440px+ | 96px | `--header_v2_height-px: 96px` |

### Grid System

Grid-based layout using CSS Grid:

- **Content Scroller Grid**: `'header' 'scroller' 'footer' / minmax(0, 1fr)` (3-row, 1-column template)
- **Card Content Grid**: `minmax(0, 1fr) max-content` (2-column, fluid + auto)
- **Search Input Grid**: `[location] minmax(0, 2fr) 1px [center-start] minmax(0, 1fr) 1px minmax(0, 1fr) [center-end] 1px [last] minmax(0, 2fr)` (named grid lines with 1px divider columns)
- **3-Column Min-Content Grid**: `repeat(3, min-content)` with 35px gap

### Directionality

Full bidirectional support:
- `dir-ltr` / `dir-rtl` prefixed classes for all directional properties
- Separate gradient tokens for LTR and RTL (`--palette-rausch-gradient-linear-gradient` / `--palette-rausch-gradient-linear-gradient-rtl`)
- Logical properties used where available (`margin-inline-start`, `padding-inline-start`, `padding-block`)

---

## 3. Color System

### Primary Brand Palette (Named Semantic Colors)

| Token | Hex | Role |
|-------|-----|------|
| `--palette-rausch` | `#FF385C` | **Signature brand coral-pink** — primary CTA, logo, core accent |
| `--palette-product-rausch` | `#E00B41` | Product rausch variant (darker) |
| `--palette-arches` | `#C13515` | Warning/error state |
| `--palette-arches2` | `#B32505` | Error hover |
| `--palette-arches12` | `#FFF8F6` | Error background |
| `--palette-hof` | `#222222` | Primary text / dark surfaces |
| `--palette-foggy` | `#6A6A6A` | Secondary text |
| `--palette-bobo` | `#B0B0B0` | Tertiary UI |
| `--palette-deco` | `#DDDDDD` | Borders, dividers |
| `--palette-bebe` | `#EBEBEB` | Subtle backgrounds |
| `--palette-faint` | `#F7F7F7` | Near-white backgrounds |
| `--palette-white` | `#FFFFFF` | White |
| `--palette-black` | `#000000` | Black |
| `--palette-capiz` | `#F7F6F2` | Warm off-white |
| `--palette-hapuna` | `#F5F1EA` | Sand/beige |
| `--palette-mykonou5` | `#428BFF` | Link blue |
| `--palette-ondo` | `#E07912` | Warning orange |
| `--palette-spruce` | `#008A05` | Success green |
| `--palette-plus` | `#92174D` | Airbnb Plus tier (magenta-purple) |
| `--palette-luxe` | `#460479` | Airbnb Luxe tier (deep purple) |

### Gradient System (Tier-Specific)

**Rausch (Core Brand) Gradient:**
```css
--palette-rausch-gradient-linear-gradient: linear-gradient(to right, #E61E4D 0%, #E31C5F 50%, #D70466 100%);
--palette-rausch-gradient-radial-gradient: radial-gradient(circle at center, #FF385C 0%, #E61E4D 27.5%, #E31C5F 40%, #D70466 57.5%, #BD1E59 75%, #BD1E59 100%);
```

**Plus Tier Gradient:**
```css
--palette-plus-gradient-linear-gradient: linear-gradient(to right, #BD1E59 0%, #92174D 50%, #861453 100%);
```

**Luxe Tier Gradient:**
```css
--palette-luxe-gradient-linear-gradient: linear-gradient(to right, #59086E 0%, #460479 50%, #440589 100%);
```

### Semantic Color Roles (3-Tier Architecture)

#### Background (`--palette-bg-*`)
| Token | Value | Context |
|-------|-------|---------|
| `--palette-bg-primary` | `#FFFFFF` | Main surface |
| `--palette-bg-primary-disabled` | `#F7F7F7` | Disabled state |
| `--palette-bg-primary-hover` | `#F7F7F7` | Hover state |
| `--palette-bg-primary-error` | `#FFF8F6` | Error background |
| `--palette-bg-primary-core` | `#FF385C` | Core accent bg |
| `--palette-bg-primary-plus` | `#92174D` | Plus tier bg |
| `--palette-bg-primary-luxe` | `#460479` | Luxe tier bg |
| `--palette-bg-primary-inverse` | `#222222` | Dark surface |
| `--palette-bg-secondary` | `#F7F7F7` | Secondary surface |
| `--palette-bg-secondary-core` | Rausch linear gradient | Core CTA gradient |
| `--palette-bg-secondary-plus` | Plus linear gradient | Plus CTA gradient |
| `--palette-bg-secondary-luxe` | Luxe linear gradient | Luxe CTA gradient |
| `--palette-bg-tertiary` | `#B0B0B0` | Tertiary UI element |

#### Text (`--palette-text-*`)
| Token | Value | Usage |
|-------|-------|-------|
| `--palette-text-primary` | `#222222` | Body text |
| `--palette-text-primary-disabled` | `#DDDDDD` | Disabled text |
| `--palette-text-primary-error` | `#C13515` | Error text |
| `--palette-text-primary-inverse` | `#FFFFFF` | Text on dark |
| `--palette-text-primary-core` | Rausch linear gradient | Gradient text |
| `--palette-text-secondary` | `#6A6A6A` | Secondary text |
| `--palette-text-legal` | `#428BFF` | Legal links |

#### Icon (`--palette-icon-*`)
Multiple states: primary, secondary, tertiary, inverse, error, warning (#E07912), info (#428BFF), success (#008A05)

#### Border (`--palette-border-*`)
5 levels: primary (#222), secondary (#B0B0B0), tertiary (#DDDDDD), quarternary (#8C8C8C), with hover/selected/disabled/error variants

### Grey Scale (12 Stops)

| Stop | Hex | Usage |
|------|-----|-------|
| `--palette-grey0` | `#FFFFFF` | White |
| `--palette-grey100` | `#F7F7F7` | Faint near-white |
| `--palette-grey200` | `#F2F2F2` | Subtle bg |
| `--palette-grey300` | `#EBEBEB` | bebe |
| `--palette-grey400` | `#DDDDDD` | deco / borders |
| `--palette-grey500` | `#C1C1C1` | Disabled |
| `--palette-grey600` | `#8C8C8C` | Tertiary text |
| `--palette-grey700` | `#6C6C6C` | foggy variant |
| `--palette-grey800` | `#515151` | Medium dark |
| `--palette-grey900` | `#3F3F3F` | focused text |
| `--palette-grey1000` | `#222222` | hof / primary text |
| `--palette-grey1100` | `#000000` | Black |

### Semantic Color Scales (10 Stops Each)

Complete 10-stop scales (100-1000) for: **Red, Green, Blue, Orange, Purple, Magenta, Rausch (brand coral), Beige**

Each scale follows a consistent pattern: 100 (lightest background) to 1000 (darkest text/icon usable).

### Shadow Opacity Scale

| Token | Value | Usage |
|-------|-------|-------|
| `--palette-shadow50` | `rgba(0,0,0,0.04)` | Subtlest edge |
| `--palette-shadow100` | `rgba(0,0,0,0.08)` | Sharp edge bg |
| `--palette-shadow150` | `rgba(0,0,0,0.12)` | Secondary |
| `--palette-shadow200` | `rgba(0,0,0,0.135)` | Primary border |
| `--palette-shadow250` | `rgba(0,0,0,0.18)` | Tertiary |
| `--palette-shadow300` | `rgba(0,0,0,0.20)` | Primary |
| `--palette-shadow350` | `rgba(0,0,0,0.28)` | High |
| `--palette-shadow600` | `rgba(0,0,0,0.60)` | Modal backdrop |

### Glass Morphism (Material Backgrounds)

5-layer frosted glass system using `backdrop-filter`:

| Layer | Background | Backdrop Filter |
|-------|-----------|-----------------|
| Extra Thin | `rgba(218,218,218,0.40)` | `blur(8px) saturate(1)` |
| Thin | `rgba(240,240,240,0.50)` | `blur(36px) saturate(1.6)` |
| Regular | `rgba(250,250,250,0.72)` | `blur(24px) saturate(1.6)` |
| Thick | `rgba(240,240,240,0.86)` | `blur(12px) saturate(3.00)` |
| Extra Thick | `rgba(255,255,255,0.925)` | `blur(16px) saturate(1.6)` |

---

## 4. Typography System

### Font Family

```
--typography-font-family-cereal-font-family: 'Airbnb Cereal VF', 'Circular', -apple-system, 'BlinkMacSystemFont', 'Roboto', 'Helvetica Neue', sans-serif;
```

Airbnb Cereal VF is a custom variable font designed in partnership with Dalton Maag. The stack falls back through Circular (the predecessor), then system fonts.

### Font Weights (4 Stops)

| Token | Weight | Usage |
|-------|--------|-------|
| `--typography-weight-book400` | `400` | Body text, captions, subtitles |
| `--typography-weight-medium500` | `500` | Medium titles, buttons |
| `--typography-weight-semibold600` | `600` | Titles, display, emphasis |
| `--typography-weight-bold700` | `700` | (Defined but rarely used; semibold is dominant) |

### Letter Spacing

| Token | Value | Usage |
|-------|-------|-------|
| `--typography-tracking-normal-letter-spacing` | `normal` | Most text |
| `--typography-tracking-wide-letter-spacing` | `0.04em` | Special use |

### Complete Type Scale

#### Special Display (Hero/Titles, Weight: 600)

| Token | Size | Line Height | Usage |
|-------|------|-------------|-------|
| `--typography-special-display-medium_72_74` | `4.5rem` (72px) | `4.625rem` (74px) | Maximum hero display |
| `--typography-special-display-medium_60_68` | `3.75rem` (60px) | `4.25rem` (68px) | Hero title |
| `--typography-special-display-medium_48_54` | `3rem` (48px) | `3.375rem` (54px) | Section hero |
| `--typography-special-display-medium_40_44` | `2.5rem` (40px) | `2.75rem` (44px) | Large heading |

#### Titles (Semibold 600 / Medium 500)

| Token | Size | Line Height | Weight |
|-------|------|-------------|--------|
| `titles-semibold_32_36` | `2rem` (32px) | `2.25rem` (36px) | 600 |
| `titles-semibold_26_30` | `1.625rem` (26px) | `1.875rem` (30px) | 600 |
| `titles-semibold_22_26` | `1.375rem` (22px) | `1.625rem` (26px) | 600 |
| `titles-semibold_18_24` | `1.125rem` (18px) | `1.5rem` (24px) | 600 |
| `titles-semibold_16_20` | `1rem` (16px) | `1.25rem` (20px) | 600 |
| `titles-semibold_14_18` | `0.875rem` (14px) | `1.125rem` (18px) | 600 |
| `titles-medium_18_24` | `1.125rem` (18px) | `1.5rem` (24px) | 500 |
| `titles-medium_16_20` | `1rem` (16px) | `1.25rem` (20px) | 500 |
| `titles-medium_14_18` | `0.875rem` (14px) | `1.125rem` (18px) | 500 |

#### Subtitles (Book 400)

| Token | Size | Line Height |
|-------|------|-------------|
| `subtitles-book_18_24` | `1.125rem` (18px) | `1.5rem` (24px) |
| `subtitles-book_16_22` | `1rem` (16px) | `1.375rem` (22px) |
| `subtitles-book_14_18` | `0.875rem` (14px) | `1.125rem` (18px) |

#### Body Paragraphs (400)

| Token | Size | Line Height |
|-------|------|-------------|
| `body-paragraphs-text_18_28` | `1.125rem` (18px) | `1.75rem` (28px) |
| `body-paragraphs-text_16_24` | `1rem` (16px) | `1.5rem` (24px) |
| `body-paragraphs-text_16_22` | `1rem` (16px) | `1.375rem` (22px) |
| `body-paragraphs-text_14_20` | `0.875rem` (14px) | `1.25rem` (20px) |

#### Body Text (Utility sizes)

| Token | Size | Line Height |
|-------|------|-------------|
| `body-text_18_24` | `1.125rem` (18px) | `1.5rem` (24px) |
| `body-text_16_20` | `1rem` (16px) | `1.25rem` (20px) |
| `body-text_14_18` | `0.875rem` (14px) | `1.125rem` (18px) |
| `body-text_12_16` | `0.75rem` (12px) | `1rem` (16px) |
| `body-text_11_15` | `0.6875rem` (11px) | `0.9375rem` (15px) |

#### Captions

| Token | Size | Line Height |
|-------|------|-------------|
| `caption-text_12_16` | `0.75rem` (12px) | `1rem` (16px) |

#### Base Extra Small

| Token | Size | Line Height |
|-------|------|-------------|
| `base-extra-small10px` | `0.625rem` (10px) | `0.75rem` (12px) |

### Typography Naming Convention

`--typography-{category}-{weight}_{fontSize}_{lineHeight}-{property}`

Categories: `special-display`, `titles`, `subtitles`, `body-paragraphs`, `body-text`, `caption-text`

---

## 5. Motion System

### Spring Physics Engine

Airbnb uses a **spring-physics-based animation system** with CSS `linear()` easing to approximate spring curves. Five spring presets, all with `source-mass: 1px`:

| Spring | Duration | Stiffness | Damping | Character |
|--------|----------|-----------|---------|-----------|
| **Fast** | ~452ms | 300px | 35px | Quick snap, no bounce |
| **Standard** | ~584ms | 175px | 26px | Default, subtle overshoot |
| **Medium Bounce** | ~574ms | 175px | 18.5px | Playful bounce |
| **Fast Bounce** | ~449ms | 250px | 22px | Quick bounce |
| **Slow** | ~746ms | 100px | 20px | Smooth reveal |
| **Slow Bounce** | ~762ms | 100px | 14px | Dramatic bounce |

The spring values produce custom `linear()` easing curves with 10-12 stops each, e.g.:
```css
--motion-springs-fast-easing: linear(0, 0.185572..., 0.465305..., 0.682333..., 0.822325..., 0.904974..., 0.951288..., 0.976363..., 0.989611..., 0.996484..., 1);
```

### Standard Cubic-Bezier Curves

| Token | Curve | Usage |
|-------|-------|-------|
| `--motion-standard-curve-animation-timing-function` | `cubic-bezier(0.2, 0, 0, 1)` | Default transitions (enter/exit emphasis) |
| `--motion-enter-curve-animation-timing-function` | `cubic-bezier(0.1, 0.9, 0.2, 1)` | Elements entering screen |
| `--motion-exit-curve-animation-timing-function` | `cubic-bezier(0.4, 0, 1, 1)` | Elements leaving screen |
| `--motion-linear-curve-animation-timing-function` | `cubic-bezier(0, 0, 1, 1)` | Linear (opacity fades) |

### Transition Duration Patterns

| Context | Duration | Easing | Property |
|---------|----------|--------|----------|
| Button box-shadow | 0.2s | standard | box-shadow, transform |
| Button content active | 0.1s | standard | transform |
| Icon button default | 0.25s | standard | transform |
| Image lazy load | 300ms | ease-out | opacity |
| Text link color | 250ms | standard | color |
| Shimmer skeleton | 1.3s ANIMATED | cubic-bezier(0.4,0,0.2,1) | background-color |
| Fade in | defined by keyframe | — | opacity (0.01→1) |
| Search bar expand | ~452ms | springs-fast | transform, background |

### Keyframe Animations

1. **Shimmer Skeleton (`animation-64e8c8`)**:
   - 0%: `--dls-shimmer-animation-start-color`
   - 25%: same
   - 80%: `--dls-shimmer-animation-end-color`
   - 100%: same ends
   - Infinite iteration, 1.3s duration, staggered by `--dls-shimmer_delay` (100ms per item)

2. **Opacity Fade In (`opacity-fade-in-13nlxly`)**:
   - 0%: `opacity: 0.01`
   - 100%: `opacity: 1`

### Button Active Press Transform

Buttons shrink on press via scale transform:
```css
transform: scaleX(calc((width - 2) / width)) scaleY(calc((height - 2) / height))
```
This creates a 2px perceptible press effect (scale down to ~98%).

### Reduced Motion

All spring-based animations are wrapped in:
```css
@media (prefers-reduced-motion: no-preference) {
  transition: transform var(--motion-springs-fast-duration) var(--motion-springs-fast-easing);
}
```

---

## 6. Interaction Patterns

### Focus Visible System

**Nine distinct focus ring styles** depending on context:

| Style | Box Shadow | Context |
|-------|-----------|---------|
| Default button | `0 0 0 2px #fff, 0 0 0 4px #222` | Standard buttons |
| Dark surface button | `0 0 0 2px #222` | Inverse buttons |
| Icon button | `0 0 0 2px #fff, 0 0 0 4px #222` | Icon buttons |
| Input/Form | `0 0 0 2px #222` | Form controls |
| White-on-dark | `0 0 0 2px #fff, 0 0 0 4px #222` | Dark bg elements |
| Outline | `2px solid #222` | Legacy outline |
| Inset | `inset 0 0 0 2px #222` | Inset focus |
| Transparent | `none` | Custom styled |
| Glass surface | `0 0 0 1px rgba(0,0,0,0.5), 0 0 0 5px rgba(255,255,255,0.7)` | Glass morphism |

**Focus offset**: `2px` (standard), `4px` (icon button)

### Hover States

- **Buttons**: Background changes via DLS token (`--dls-button_background_hover`, `--dls-button_color_hover`)
- **Text links**: Color transitions from `--palette-hof` to `--palette-black` (250ms standard curve)
- **Icon buttons**: Pseudo-element background appears using `--dls-icon-button_pseudo-background_hover`
- **Search input**: Background transitions from gradient to expanded color

### Active/Press States

- **Buttons**: Scale-down transform (2px press) + active color tokens
- **Icon buttons**: Scale transform via `--dls-icon-button_transform_active: scale(calc(38 / 40))` (38px from 40px pseudo-element)

### Disabled States

- **Opacity**: `0.3` (default), `0.5` (icon buttons), `1.0` (specific override)
- **Cursor**: `not-allowed`
- **Colors**: Swapped to disabled palette tokens (`--palette-*-disabled`)
- **Transforms**: Reset to `none`

### DLS Token Override Pattern

Every interactive component exposes a DLS property namespace allowing context-specific override:

```css
/* Button defaults */
--dls-button_background: var(--palette-bg-secondary-core);
--dls-button_color: var(--palette-white);
--dls-button_border-radius: var(--corner-radius-small8px-border-radius);
--dls-button_padding-top: 14px;
--dls-button_padding-bottom: 14px;
--dls-button_padding-left: 24px;
--dls-button_padding-right: 24px;
--dls-button_box-shadow: ...;
--dls-button_min-width: ...;
```

```css
/* Icon button defaults */
--dls-icon-button_background: transparent;
--dls-icon-button_color: var(--palette-grey1000);
--dls-icon-button_width: 40px;
--dls-icon-button_height: 40px;
--dls-icon-button_pseudo-width: 40px;
--dls-icon-button_pseudo-height: 40px;
--dls-icon-button_pseudo-border-radius: 50%;
--dls-icon-button_transform_active: scale(calc(38 / 40));
```

---

## 7. Spacing System

### Two-Tier Spacing Scale

#### Macro (Section-Level)
| Token | Value |
|-------|-------|
| `--spacing-macro16px` | 16px |
| `--spacing-macro24px` | 24px |
| `--spacing-macro32px` | 32px |
| `--spacing-macro40px` | 40px |
| `--spacing-macro48px` | 48px |
| `--spacing-macro64px` | 64px |
| `--spacing-macro80px` | 80px |

#### Micro (Component-Level)
| Token | Value |
|-------|-------|
| `--spacing-micro2px` | 2px |
| `--spacing-micro4px` | 4px |
| `--spacing-micro8px` | 8px |
| `--spacing-micro12px` | 12px |
| `--spacing-micro16px` | 16px |
| `--spacing-micro24px` | 24px |
| `--spacing-micro32px` | 32px |

### Common Padding Patterns (from atomic classes)

| Pattern | Value | Usage |
|---------|-------|-------|
| Button default | `14px 24px` | Primary CTAs |
| Button compact | `11px 24px` (top: 11px) | Secondary CTAs |
| Icon button | `7px` | Touch target expansion |
| Input/Form | `15px 32px` | Search inputs |
| Card | `15px 24px` | Card padding |
| Section header | `12px 0` / `12px 16px` | Section headers |
| Small pill | `4px 8px` | Chips, tags |
| Side padding (mobile) | `24px` | Content sides |
| Side padding (desktop) | `32px` / `48px` | Content sides |
| Search bar gap | `35px` between columns | Search form |
| Card gap | `12px` (default) / `8px` (tight) | Card collections |

### Border Radius Scale

| Token | Value | Usage |
|-------|-------|-------|
| `--corner-radius-tiny4px-border-radius` | 4px | Tiny elements |
| `--corner-radius-small8px-border-radius` | 8px | Buttons, inputs (default) |
| `--corner-radius-medium12px-border-radius` | 12px | Cards (default), sections |
| `--corner-radius-large16px-border-radius` | 16px | Large cards |
| `--corner-radius-xlarge20px-border-radius` | 20px | Card containers |
| `--corner-radius-xxlarge24px-border-radius` | 24px | Large containers |
| `--corner-radius-xxlarge28px-border-radius` | 28px | Extra large |
| `--corner-radius-xxxlarge32px-border-radius` | 32px | Search bar, headers |
| (inline value) `50%` | Circle | Icon button pseudo-elements |
| (inline value) `50px` | Pill | Pill buttons/chips |
| (inline value) `100px` | Full pill | Product-rausch badges |

---

## 8. Component Patterns

### ContentScroller (Horizontal Carousel)

Airbnb's signature horizontal scrolling pattern. A CSS Grid-based component with 3 grid areas:

```
Grid Template: 'header' 'scroller' 'footer' / minmax(0, 1fr)
```

**Key Properties:**
- `scroll-snap-type: inline mandatory` with `scroll-snap-align: start`
- `overscroll-behavior-inline: contain`
- `content-visibility: auto` for performance
- `touch-action: pan-x pan-y pinch-zoom`
- Peek mechanism: first/last items partially visible via `--contentscroller_peek` (default 32px)
- Auto-column sizing: `calc((100% - gap * (visible_items - 1)) / visible_items)`
- Edge-fade mask on larger screens: `mask-image: linear-gradient(to right, transparent, black 24px, black calc(100% - 24px), transparent)`
- Responsive visible items: controlled by peek variables (`peek_sm`, `peek_md`, `peek_lg`, `peek_xl`)

### Card System

**Card Container:**
- Border radius: `--card-container_border-radius` (default 12px, can override to 20px)
- Box shadow: `--card-container_box-shadow` (default none)
- Max-width / min-width: configurable
- Width: `--card-container_width` (default auto)

**Card Content Grid:**
```css
grid-template-columns: minmax(0, 1fr) max-content
```
- Gap: `--card-layout_gap` (default 12px)
- Flex direction: `--card-layout_flex-direction` (default column)

**Media Container:**
- Border radius: `--media-container_border-radius` (default 12px)
- Aspect ratio: `--aspect_ratio_wrapper-ratio` (e.g., 20/19 for property cards)
- Object fit: cover, position: center
- Pointer events: configurable via `--media-container_pointer-events`

### Button System

**Button DLS Tokens (Fully Configurable):**
```
--dls-button_background
--dls-button_color
--dls-button_border-radius (default: 8px)
--dls-button_border-color
--dls-button_border-width (default: 1px)
--dls-button_padding-top (default: 14px)
--dls-button_padding-bottom (default: 14px)
--dls-button_padding-left (default: 24px)
--dls-button_padding-right (default: 24px)
--dls-button_min-width
--dls-button_box-shadow
--dls-button_backdrop-filter
--dls-button-content_display
--dls-button-content_will-change
--dls-button-content_transition
```

**States**: Default, Hover (color/background tokens), Active (scale-down press), Focus-visible (ring), Disabled (opacity + tokens)

**Button Variants observed:**
1. **Primary Gradient (Rausch)**: `background: var(--palette-rausch-gradient-linear-gradient)`, white text, borderless
2. **Secondary/Glass**: `background: var(--palette-bg-secondary)`, dark text, 1px border
3. **Inverse**: `background: var(--palette-bg-primary-inverse)`, white text
4. **Tertiary/Text**: `background: transparent`, underline on hover
5. **Error**: Red background/text with error tokens
6. **Product Rausch (CTAs)**: Solid `#E00B41`, 100px border-radius pill

### Icon Button System

40x40px touch target with 40x40px circular pseudo-element for hover/active states.

**DLS Tokens:**
```
--dls-icon-button_background (transparent default)
--dls-icon-button_color (grey1000 default)
--dls-icon-button_width / height (40px)
--dls-icon-button_pseudo-width / height (40px)
--dls-icon-button_pseudo-border-radius (50%)
--dls-icon-button_pseudo-background (grey200)
--dls-icon-button_pseudo-border-color (transparent)
--dls-icon-button_pseudo-border-width (0)
--dls-icon-button_focus-box-shadow (white ring + black ring)
--dls-icon-button_transform_active (scale(38/40))
```

### Search Bar (Hero Search Input)

**Grid layout**: 3 named column areas separated by 1px dividers
```
grid-template-columns: [location] minmax(0, 2fr) 1px [center-start] minmax(0, 1fr) 1px minmax(0, 1fr) [center-end] 1px [last] minmax(0, 2fr)
```

**Key features:**
- Gradient background: `linear-gradient(180deg, #ffffff 39.9%, #f8f8f8 100%)`
- 32px border radius (fully rounded pill)
- Bottom border via pseudo-element (appears on focus/expand)
- 500px max width (centered)
- Margins: `22px auto 24px`
- Auto-height: `calc(var(--typography-body-text_14_18-line-height) * 2 + 30px)`

**Expanded state:**
- Background color swap (`--search-input_background_expanded`)
- Top padding: 15px 32px
- Transform animation via spring physics (fast spring, ~452ms)
- Shadow: `--elevation-elevation3-box-shadow`

### Header / Navigation

**Header V2:**
- Height: 80px (default), 96px (1440px+)
- Position: sticky/fixed with z-index 100
- Glass morphism background (material-backgrounds tokens)
- RTL-aware gradient backgrounds

**Search input transition**: Header search bar expands on scroll/focus with spring physics transform.

### Shimmer Skeleton

Loading placeholder with staggered animation:
- `animation-64e8c8` keyframe cycles background-color
- 1.3s duration, cubic-bezier(0.4, 0, 0.2, 1)
- 100ms delay stagger per skeleton item using `--dls-shimmer_count` counter
- Start color: `--palette-grey100`, End color: `--palette-grey300`

---

## 9. Design Tokens Summary

| Category | Count | Examples |
|----------|-------|----------|
| **Color - Named** | 23 | rausch, hof, foggy, bobo, deco, bebe, faint, arches, capiz, hapuna, mykonou5, ondo, spruce, plus, luxe, etc. |
| **Color - Semantic (bg)** | 30 | Primary, secondary, tertiary, inverse states with disabled/hover/error/core/plus/luxe variants |
| **Color - Semantic (text)** | 15 | Primary, secondary, legal, link states |
| **Color - Semantic (icon)** | 17 | 4 levels + error/warning/info/success |
| **Color - Semantic (border)** | 17 | 4 levels + states |
| **Color - Scales** | 120 | 12 grey + 8 scales x 10 stops (red, green, blue, orange, purple, magenta, rausch, beige) |
| **Color - Shadows** | 8 | Opacity scale 50-600 |
| **Color - Gradients** | 12 | 3 tiers (rausch/plus/luxe) x 3 directions (linear, linear-rtl, radial) |
| **Elevation** | 6 | elevation0-5 (1px ring + layered blurs) |
| **Corner Radius** | 8 | 4px to 32px |
| **Spacing (Macro)** | 7 | 16px to 80px |
| **Spacing (Micro)** | 7 | 2px to 32px |
| **Typography** | 49 | 1 font family + 4 weights + 30 size/line tokens + tracking + base |
| **Motion (Springs)** | 24 | 6 spring presets with duration/easing/mass/stiffness/damping (5 tokens each) |
| **Motion (Curves)** | 4 | standard, enter, exit, linear |
| **Material Backgrounds** | 10 | 5 layers x 2 properties (bg-color + backdrop-filter) |
| **Total CSS Custom Properties** | **~230** (declared) + **~320** (consumer DLS tokens) | |

---

## 10. Key Design Takeaways

1. **Atomic CSS at massive scale**: 700+ single-purpose utility classes generated from token-driven build system (Linaria). Every class sets exactly one CSS property value pair.

2. **Token hierarchy**: Base tokens (`--palette-*`, `--typography-*`) -> Semantic tokens (`--palette-bg-*`, `--palette-text-*`) -> DLS override tokens (`--dls-button_*`, `--dls-icon-button_*`). Three tiers of abstraction.

3. **Spring physics over easing curves**: Airbnb invested in CSS `linear()` spring approximations with 10-12 stop keyframes, providing natural-feeling motion. All 5 springs share source-mass=1 but vary in stiffness (100-300) and damping (14-35).

4. **Single accent color discipline**: Rausch (`#FF385C`) is the one true brand color. It appears as:
   - Primary CTA gradient (linear + radial)
   - Logo/brand element color
   - Product rausch (`#E00B41`) for tangible CTAs
   - Complete 10-stop scale (`rausch100` to `rausch1000`)
   - Everything else uses the neutral grey scale (12 stops)

5. **Glass morphism as navigation material**: The header/nav uses a 5-layer backdrop-filter blur system (8px to 36px) instead of solid backgrounds — a signature Airbnb pattern since the 2014 redesign.

6. **Peek-based carousel**: The ContentScroller component reveals partial next/previous items at edges (32px default peek) — a key UX pattern for horizontal browsing. Responsive visible items scale from `peek_sm` (mobile) to `peek_xl` (ultra-wide).

7. **RTL by design**: Every directional property is mirrored via `dir-ltr`/`dir-rtl` prefixes. Gradient directions are stored as separate tokens for LTR and RTL.

8. **Responsive breakpoint cascade**: 7 breakpoints (0, 375, 744, 950, 1128, 1440, 1920) + landscape-aware variants (min-height 480px threshold) + safe-area handling for notched devices.

9. **Type scale naming encodes the token**: Airbnb's type tokens follow `{category}-{weight}_{size}_{lineHeight}` — the token name IS the specification (e.g., `titles-semibold_18_24` means 18px/24px semibold title).

10. **Pseudo-element decoration**: Icon button hover/active states use `::before` pseudo-elements with scale transforms, making hover feedback purely CSS (no JS, no extra DOM).

---

## 11. Extraction Limitations

1. **No external CSS fetched**: All design tokens and component patterns were extracted from the single inline `<style id="linaria">` tag (~600KB of inline CSS). The external stylesheet at `a0.muscache.com/airbnb/static/...client.a23489c7b7.css` was marked as `media="print"` with `data-linaria-css-swap="true"` (swapped in by JS), confirming the inline style is the primary stylesheet.

2. **No JavaScript analysis**: The JS bundle system (hyperloop, metroRequire, ~30 preloaded JS chunks) was not downloaded to respect the 3-JS-file limit. Animation libraries could not be confirmed but are likely custom (spring physics implemented in pure CSS `linear()`).

3. **Dynamic page content**: As a React SPA, much of the actual page content (property listings, carousel items, footer links) is rendered client-side and was not captured in the static HTML fetch.

4. **Image analysis skipped**: Preloaded hero images are served through Airbnb's image CDN (`a0.muscache.com/im/pictures/...`) with `?im_w=` query parameters for responsive sizing, but no images were downloaded.

5. **Total fetched**: 1 request (homepage HTML, 613KB). Zero additional CSS/JS requests made.

---

## 12. Files Generated

- `knowledge/websites/airbnb/design-system.md` — This document
- `knowledge/registry.json` — Updated with Airbnb entry
