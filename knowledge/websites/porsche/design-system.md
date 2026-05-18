# Porsche Design System v4

**Source:** https://www.porsche.com (Hong Kong locale, zh-HK)  
**Extraction Date:** 2026-05-18  
**Stack:** Astro + Porsche Design System v4 (Web Components) + Plyr  
**CMS:** Storyblok  
**CDN:** cdn.ui.porsche.com

---

## Overview

Porsche's digital design system is a masterclass in luxury automotive branding translated to the web. The system is anchored by the proprietary **Porsche Design System (PDS) v4**, a Web Components-based framework with custom elements, served from a dedicated CDN. The homepage is built with **Astro** (island architecture), consuming PDS components alongside page-specific components (HomeStage, CarRange, Teaser, etc.).

The aesthetic is **dark-first luxury minimalism** -- a deliberate departure from the "safe gray-on-white" template approach. Every surface is dark-themed (`scheme-dark`), with video-forward hero sections, staggered entrance animations, and a sophisticated fluid typography scale. The result is editorial, cinematic, and unmistakably Porsche.

**Style Direction:** Dark Luxury / Editorial Cinematic

**Standout Design Qualities:**
- Dark-first design with light mode as secondary (inverted from typical web)
- Video-as-hero with full-bleed background video and gradient overlays
- Staggered word-by-word headline animations on scroll
- Custom proprietary typeface (Porsche Next) with 7 writing system variants
- Glass-morphism frosted surfaces with backdrop-filter blur
- Sophisticated 6/16 column grid with named placement zones
- Fluid typography and spacing scales using CSS clamp()
- `light-dark()` CSS function for single-source dual-theme tokens

---

## Layout System

### Grid Architecture

Porsche uses a **named-line CSS Grid** with contextual column zones:

**Mobile (<760px): 6-column grid**
```
[full-start] [wide-start extended-start basic-start narrow-start] 
  1fr 1fr 1fr 1fr 1fr 1fr 
[narrow-end basic-end extended-end wide-end] [full-end]
```

**Desktop (>=760px): 16-column grid**
```
[full-start] outer-col [wide-start] 1fr [extended-start] 1fr [basic-start] 
  1fr 1fr [narrow-start] 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr [narrow-end] 
  1fr 1fr [basic-end] 1fr [extended-end] 1fr [wide-end] outer-col [full-end]
```

**Grid Properties:**
- Max width: `2560px`
- Min width: `320px`
- Grid gap: `clamp(16px, 1.25vw + 12px, 36px)` (fluid)
- Container padding: `calc(50% - margin - 1280px)` (centered, 1280px content area)
- Safe zone: `max(22px, 10.625vw - 12px)` mobile / `calc(5vw - 16px)` desktop(>=760px) / `min(50vw - 880px, 400px)` >=1920px

### Named Grid Zones (content placement)

| Zone | Width (mobile) | Width (desktop) | Use |
|------|------|------|------|
| `full` | 6 cols + outers | 16 cols + outers | Background videos, full-bleed images |
| `wide` | 6 cols | 14 cols | Slightly constrained from full |
| `extended` | 6 cols | 12 cols | Wider content, car range tiles |
| `basic` | 6 cols | 8 cols (center) | Primary content, text, CTAs |
| `narrow` | 6 cols | 8 cols (center) | Narrow reading content |

**Span Helpers:**
- `.PcomGridItem__width-basic` -- full basic width
- `.PcomGridItem__width-basic-half` -- half basic width (span 3 mobile, span 6 desktop)
- `.PcomGridItem__width-basic-one-third` -- one third (span 2 mobile, span 4 desktop)
- `.PcomGridItem__width-basic-two-thirds` -- two thirds (span 4 mobile, span 8 desktop)
- `.PcomGridItem__width-full` -- full bleed
- `.PcomGridItem__width-extended` -- extended width
- `.PcomGridItem__width-narrow` -- narrow width

### Breakpoints

| Name | Min Width | Purpose |
|------|-----------|---------|
| `xs` | 480px | Small device adjustments |
| `s` (base) | 760px | Grid switches 6->16 cols, desktop layout |
| `m` | 1000px | Medium desktop refinements |
| `l` | 1300px | Large desktop, 2rem video icons |
| `xl` | 1760px | Extra large |
| `2xl` | 1920px | Grid safe zone recalculation |

### Page Layout (Homepage)

```
┌─────────────────────────────────────────────┐
│  HomeStage (hero)                            │
│  - Full-bleed background video              │
│  - Large Display headline (h1)              │
│  - CTA button                                │
│  - Scroll indicator                          │
│  - 3 model tiles (HomeStageTile)            │
├─────────────────────────────────────────────┤
│  DesktopCarRange (5 model tiles)             │
│  - Medium Display headline                   │
│  - Video/poster per tile                     │
│  - Gradient overlay, fuel tag, description  │
├─────────────────────────────────────────────┤
│  ContentInfo (brand content)                 │
│  - Inverse theme (dark bg + light text)     │
│  - Image + text box layout                   │
├─────────────────────────────────────────────┤
│  Teaser (3 promotional tiles)                │
│  - Dark theme                                │
│  - Staggered entrance animation             │
│  - P-link-tile Web Components               │
├─────────────────────────────────────────────┤
│  Footer (pnav-footer Web Component)          │
└─────────────────────────────────────────────┘
```

---

## Color System

### Design Token Architecture

Porsche uses the modern CSS `light-dark()` function for a single-source dual-theme token system with a `@supports` fallback for older browsers.

**Theme Strategy:** Dark-first. Most sections use `scheme-dark` class. The light theme exists as a fallback and alternative.

### Core Canvases

| Token | Light | Dark | Role |
|-------|-------|------|------|
| `--p-color-canvas` | `#ffffff` | `#010205` | Page background (near-black dark) |
| `--p-color-surface` | `#f1f1f4` | `#19191a` | Card/surface background |
| `--p-color-focus` | `#1a44ea` | `#1a44ea` | Focus ring color (consistent) |
| `--p-color-primary` | `#010205` | `#fafbff` | Primary text color |

### Frosted Surfaces (Glass-morphism)

| Token | Light | Dark | Use |
|-------|-------|------|-----|
| `--p-color-frosted` | `hsla(240,5%,70%,.148)` | `hsla(240,2%,43%,.228)` | Default frosted |
| `--p-color-frosted-soft` | `rgba(143,145,163,.06)` | `rgba(65,65,70,.154)` | Subtle frosted |
| `--p-color-frosted-strong` | `rgba(100,101,114,.236)` | `rgba(156,156,159,.302)` | Strong frosted |

**Blur:** `--p-blur-frosted: blur(32px)`

### Contrast Scale (Text)

| Token | Light (on white) | Dark (on near-black) | Opacity |
|-------|------|------|------|
| `--p-color-contrast-lower` | `rgba(79,80,89,.324)` | `rgba(156,156,159,.302)` | Border/divider |
| `--p-color-contrast-low` | `rgba(36,36,40,.5)` | `rgba(246,246,248,.45)` | Disabled/subtle |
| `--p-color-contrast-medium` | `rgba(17,17,19,.6)` | `rgba(246,246,248,.56)` | Secondary text |
| `--p-color-contrast-high` | `rgba(26,26,30,.7)` | `rgba(246,246,248,.67)` | Body text |
| `--p-color-contrast-higher` | `rgba(21,21,25,.8)` | `rgba(246,246,248,.78)` | Headings/emphasis |

### Semantic Colors

| State | Light | Dark | Low (bg) | Medium (border) |
|-------|-------|------|------|------|
| **Success** | `#197e10` | `#10c47f` | rgba 18% | rgba 60% |
| **Warning** | `#ac5102` | `#f4882a` | rgba 18% | rgba 60% |
| **Error** | `#ba171f` | `#fc4040` | rgba 18% | rgba 60% |
| **Info** | `#1a44ea` | `#178bff` | rgba 18% | rgba 60% |

**Frosted Semantic Surfaces:** Each state also has `-frosted` (strong, ~55-66% opacity) and `-frosted-soft` (subtle, ~55-66% opacity) variants for notification backgrounds.

### Backdrop

| Token | Value | Use |
|-------|-------|-----|
| `--p-color-backdrop` | `rgba(36,36,40,.5)` (both themes) | Modal/overlay backdrop |

### Shadow Tokens

| Token | Value |
|-------|-------|
| `--p-shadow-sm` | `0px 3px 8px rgba(0,0,0,.16)` |
| `--p-shadow-md` | `0px 4px 16px rgba(0,0,0,.16)` |
| `--p-shadow-lg` | `0px 8px 40px rgba(0,0,0,.16)` |

All shadows use the same color (`rgba(0,0,0,.16)`) varying only spread/blur -- a restrained approach fitting the dark luxury aesthetic.

### Theme Classes

- `.scheme-light` -- Forces light color scheme
- `.scheme-dark` -- Forces dark color scheme
- `.scheme-light-dark` -- Follows system preference (via `prefers-color-scheme: dark` media query)

---

## Typography

### Typeface: Porsche Next

Proprietary custom typeface created exclusively for Porsche. Served as WOFF2 from `cdn.ui.porsche.com`.

**Font Stack:** `"Porsche Next", "Arial Narrow", Arial, "Heiti SC", SimHei, sans-serif`

**Features:**
- `font-display: swap` on all faces
- Preloaded on homepage (regular + semi-bold Latin subsets)
- Narrow, geometric proportions -- distinctively automotive/racing aesthetic

### Writing System Variants (19 @font-face declarations)

| Script | Weights | Subsets |
|--------|---------|---------|
| Arabic | 400, 700 | Arabic Unicode range |
| Cyrillic | 400, 600, 700 | Cyrillic Unicode range |
| Greek | 400, 600, 700 | Greek Unicode range |
| Latin | 400, 600, 700 | Full Latin + Extended |
| Pashto | 400, 700 | Pashto Unicode range |
| Thai | 400, 600, 700 | Thai Unicode range |
| Urdu | 400, 700 | Urdu Unicode range |

### Weight System

| Token | Value | Use |
|-------|-------|-----|
| `--p-font-weight-normal` | `400` | Body text, descriptions |
| `--p-font-weight-semibold` | `600` | Subheadings, emphasis |
| `--p-font-weight-bold` | `700` | Display headlines, CTAs |

Note: The typeface has **no thin or light weight**. The narrow geometry makes 400 feel lighter already.

### Fluid Type Scale

All sizes use CSS `clamp()` for viewport-responsive scaling:

| Token | CSS | Min (320px) | Base (~760px) | Max (~1920px) |
|-------|-----|-------------|---------------|---------------|
| `--p-typescale-2xs` | `.75rem` | 12px | 12px | 12px (static) |
| `--p-typescale-xs` | `.875rem` | 14px | 14px | 14px (static) |
| `--p-typescale-sm` | `1rem` | 16px | 16px | 16px (static) |
| `--p-typescale-md` | `clamp(1.13rem, .21vw + 1.08rem, 1.33rem)` | ~18px | ~19px | ~21px |
| `--p-typescale-lg` | `clamp(1.27rem, .51vw + 1.16rem, 1.78rem)` | ~20px | ~23px | ~28px |
| `--p-typescale-xl` | `clamp(1.42rem, .94vw + 1.23rem, 2.37rem)` | ~23px | ~28px | ~38px |
| `--p-typescale-2xl` | `clamp(1.6rem, 1.56vw + 1.29rem, 3.16rem)` | ~26px | ~34px | ~51px |
| `--p-typescale-3xl` | `clamp(1.8rem, 2.41vw + 1.32rem, 4.21rem)` | ~29px | ~41px | ~67px |
| `--p-typescale-4xl` | `clamp(2.03rem, 3.58vw + 1.31rem, 5.61rem)` | ~32px | ~50px | ~90px |
| `--p-typescale-5xl` | `clamp(2.28rem, 5.2vw + 1.24rem, 7.48rem)` | ~36px | ~60px | ~120px |

### Display Component (PcomDisplay)

The `PcomDisplay` component renders headlines with these preset sizes:

| Size | CSS | Use |
|------|-----|-----|
| Small | `clamp(1.8rem, 2.41vw + 1.32rem, 4.21rem)` | Section headings |
| Medium | `clamp(2.03rem, 3.58vw + 1.31rem, 5.61rem)` | Car range headline |
| Large | `clamp(2.28rem, 5.2vw + 1.24rem, 7.48rem)` | Hero headline |

All Display sizes use **weight 400** (regular) -- counterintuitively, the narrow typeface at large sizes carries visual weight without needing bold.

### Line Height

`--p-leading-normal: calc(6px + 2.125ex)` -- A clever formula that scales line-height proportionally with font size using the x-height unit. At 16px text: ~22px line-height (1.375 ratio). At 120px display: ~130px line-height (1.08 ratio). This prevents excessive spacing on large headlines while maintaining readability on body text.

### Text Utility Classes

| Class | Purpose |
|-------|---------|
| `.text__color-primary` | Primary text (light-dark aware) |
| `.text__color-contrast-low` | Subtle text |
| `.text__color-contrast-medium` | Secondary text |
| `.text__color-contrast-high` | Body/headings |
| `.text__color-notification-success` | Success text |
| `.text__color-notification-error` | Error text |
| `.text__color-notification-info` | Info text |
| `.text__color-notification-warning` | Warning text |
| `.text__weight-regular` | font-weight: 400 |
| `.text__weight-semi-bold` | font-weight: 600 |
| `.text__weight-bold` | font-weight: 700 |
| `.text__align-start` | text-align: start |
| `.text__align-center` | text-align: center |
| `.text__align-end` | text-align: end |
| `.text__ellipsis` | Truncation |
| `.text__wrap-balance` | text-wrap: balance (headlines) |
| `.text__wrap-pretty` | text-wrap: pretty (body) |

All color classes include `.text__theme-dark` variants for auto-switching.

---

## Motion Catalog

### Easing System

| Token | Value | Character |
|-------|-------|-----------|
| `--p-ease-in-out` | `cubic-bezier(.25, .1, .25, 1)` | Smooth symmetric |
| `--p-ease-in` | `cubic-bezier(0, 0, .2, 1)` | Gentle entry |
| `--p-ease-out` | `cubic-bezier(.4, 0, .5, 1)` | Deceleration exit |

### Duration Tokens

| Token | Value | Use |
|-------|-------|-----|
| `--p-duration-sm` | `.25s` | Hover transitions, micro-interactions |
| `--p-duration-md` | `.4s` | Standard transitions |
| `--p-duration-lg` | `.6s` | Section reveals, page transitions |
| `--p-duration-xl` | `1.2s` | Extended reveals, ambient animations |

### Keyframe Animations

#### 1. Scroll Indicator Bounce (`PcomScrollIndicator__scrollIndicatorMoving`)
```css
@keyframes scrollIndicatorMoving {
  0%, 20%, 50%, 80%, to { transform: translateY(6px); }
  40%, 60%              { transform: translateY(0); }
}
```
- Duration: 2s, infinite
- Start delay: 1s
- A subtle vertical bounce that guides the user to scroll
- Opacity entrance: `.25s` ease-out for visibility, `.4s` ease-in for the actual animation

#### 2. HomeStage Headline Animation (`homeStageHeadlineAnimation`)
```css
@keyframes homeStageHeadlineAnimation {
  0% { opacity: 0; transform: translateY(40px); }
  to { opacity: 1; transform: translateY(0); }
}
```
- Words stagger-enter from below with opacity fade
- Each word delayed incrementally
- Creates the signature Porsche cinematic headline reveal

#### 3. HomeStage Button Animation (`homeStageStopButtonAnimation`)
```css
@keyframes homeStageStopButtonAnimation {
  0% { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}
```
- CTA and pause buttons fade up

#### 4. Tile Entrance Animation (`tilesAnimation`)
```css
@keyframes tilesAnimation {
  0% { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}
```
- Model tiles fade up from 30px below
- Staggered delays: `tilesAnimationDelay-0`, `tilesAnimationDelay-1`, `tilesAnimationDelay-2`

#### 5. Car Range Tile Animation (`carRangeTileAnimation`)
```css
@keyframes carRangeTileAnimation {
  0% { opacity: .3; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}
```

#### 6. AI Car Search Animations (AiCarSearchBar)
- **hide/show**: Opacity transitions
- **headlineAnimation**: translateY(40px) + opacity fade up
- **imageAnimation**: translateX(300px) slide-in
- **circleHalf**: rotate(0) + scale(1.1) rotation reveal
- **selectedCircle**: border-radius morphing (circle -> pill)
- **reversedCircle**: Reverse morphing
- **growUp**: height 0 -> full
- **closeDown**: height 82% -> 0
- **fadeToWhiteBg/fadeToDarkBg**: Background color transitions
- **fontToWhite/fontToDark**: Text color transitions
- **pulse**: Opacity pulse (1 -> 0.5 -> 1)

#### 7. Plyr Video Player Animations
- **plyr-progress**: Loading bar stripe animation
- **plyr-popup**: Opacity + translateY popup entrance
- **plyr-fade-in**: Simple opacity fade

### Background Video Transitions
```css
.PcomBackgroundVideo__image {
  transition: visibility .25s ease-in 0s, opacity .25s ease-in 0s;
}
```
Poster image fades out when video loads.

### Scroll Indicator Hover
```css
/* Dark theme */
.PcomScrollIndicator__theme-dark:hover {
  background: hsla(240,2%,43%,.228);  /* frosted surface */
}
/* Light theme */
.PcomScrollIndicator__theme-light:hover {
  background: rgba(122,123,138,.15);  /* subtle gray */
}
```

---

## Interaction Patterns

### Hover: Media Query Gating

All hover effects use `@media (hover: hover) and (pointer: fine)` to prevent sticky hover states on touch devices:

```css
@media (hover: hover) and (pointer: fine) {
  .element:hover { /* hover effect */ }
}
```

### Video Player Play Button
```css
.plyr__control--overlaid:not(.plyr__control--custom) {
  background-color: #fff;
  border: 2px solid #fff;
  border-radius: 4px;
  color: #010205;
  padding: 16px;
}

@media (hover: hover) and (pointer: fine) {
  .plyr__control--overlaid:hover {
    background-color: #afb0b3;  /* gray-400 */
    border-color: #afb0b3;
  }
}

.plyr__control--overlaid:focus-visible {
  outline: 2px solid #1a44ea;  /* Porsche focus blue */
}
```

### Small Video Button (PcomVideoPlyr)
```css
.plyr__control.PcomVideoPlyr__smallButton {
  background: none;
  border: 2px solid;
  border-radius: 4px;
  color: #fafbff;
  padding: 13px;
}

@media (hover: hover) and (pointer: fine) {
  .plyr__control.PcomVideoPlyr__smallButton:hover {
    backdrop-filter: blur(32px);
    background-color: rgba(110,110,115,.15);
    border-color: rgba(246,246,248,.56);
    color: #fff;
  }
}
```

### Video Controls Gradient
```css
.plyr--video .plyr__controls {
  background: linear-gradient(transparent, rgba(0,0,0,.5));
  padding: 7%;
  transition: opacity .4s ease-in-out, transform .4s ease-in-out;
}
```
Controls slide up/down with opacity transition. Hidden when inactive:
```css
.plyr--video.plyr--hide-controls .plyr__controls {
  opacity: 0;
  pointer-events: none;
  transform: translateY(100%);
}
```

### Focus Ring

Consistent `2px solid #1a44ea` focus-visible outline with `2px` offset:
```css
.element:focus-visible {
  outline: 2px solid #1a44ea;
  outline-offset: 2px;
}
```

### Touch Device Handling

```css
@media (hover: none) and (pointer: coarse) {
  .plyr--video .plyr__control.plyr__control--custom:hover {
    background: inherit;
    border-color: currentcolor;
    color: #fafbff;
  }
}
```
Touch devices reset hover states to prevent sticky interactions.

### Scroll Indicator Interaction
- **Visible on load:** `opacity: 1` with `.4s ease-in` transition
- **On hover (desktop):** frost background appears
- **Arrow animation:** starts after 1s delay, 2s infinite loop
- **On click:** scrolls to next section

---

## Spacing System

### Fluid Spacing Scale (viewport-responsive)

| Token | CSS | Min (320px) | Base | Max (~1920px) |
|-------|-----|-------------|------|---------------|
| `--p-spacing-fluid-xs` | `clamp(4px, .25vw + 3px, 8px)` | ~5px | ~6px | 8px |
| `--p-spacing-fluid-sm` | `clamp(8px, .5vw + 6px, 16px)` | ~10px | ~11px | 16px |
| `--p-spacing-fluid-md` | `clamp(16px, 1.25vw + 12px, 36px)` | 20px | 24px | 36px |
| `--p-spacing-fluid-lg` | `clamp(32px, 2.75vw + 23px, 76px)` | ~41px | ~50px | 76px |
| `--p-spacing-fluid-xl` | `clamp(48px, 3vw + 38px, 96px)` | ~58px | ~68px | 96px |
| `--p-spacing-fluid-2xl` | `clamp(80px, 7.5vw + 56px, 200px)` | ~104px | ~132px | 200px |

### Static Spacing Scale

| Token | Value | Use |
|-------|-------|-----|
| `--p-spacing-static-2xs` | `1px` | Borders, dividers |
| `--p-spacing-static-xs` | `4px` | Tight gaps |
| `--p-spacing-static-sm` | `8px` | Icon padding, small gaps |
| `--p-spacing-static-md` | `16px` | Standard padding/gap |
| `--p-spacing-static-lg` | `32px` | Section padding |
| `--p-spacing-static-xl` | `48px` | Large section padding |
| `--p-spacing-static-2xl` | `80px` | Major section separation |

### Component-Level Spacing Tokens

Referenced as CSS variables (PDS convention):
- `--pcom-spacing-x-small`
- `--pcom-spacing-small`
- `--pcom-spacing-medium`
- `--pcom-spacing-large`
- `--pcom-transition-duration`

---

## Component Patterns

### Component Inventory (17 components extracted)

#### Page Sections
| Component | CSS Prefix | Description |
|-----------|------------|-------------|
| **HomeStage** | `HomeStage__` | Hero section: video bg, headline, CTA, scroll indicator, tiles |
| **HomeStageMain** | `HomeStageMain__` | Hero content: headline wrapper, CTA, media, pause button |
| **HomeStageTile** | `HomeStageTile__` | Model card tiles below hero (3 tiles, staggered animation) |
| **CarRange** | `CarRange__` | Car range showcase section |
| **DesktopCarRange** | `DesktopCarRange__` | Desktop car range (5 tiles with video) |
| **DesktopCarRangeTile** | `DesktopCarRangeTile__` | Individual car tile: poster, video, gradient, fuel tag, description |
| **ContentInfo** | `ContentInfo__` | Brand content: image + text box, inverse theme |
| **Teaser** | `Teaser__` | 3 promotion tiles grid, staggered animation |
| **TeaserTile** | `TeaserTile__` | Individual promotion tile |

#### Media Components
| Component | CSS Prefix | Description |
|-----------|------------|-------------|
| **PcomPicture** | `PcomPicture__` | Responsive picture element with fit modes |
| **PcomImage** | `PcomImage__` | Image with contain/cover/fit-container |
| **PcomVideo** | `PcomVideo__` | Aspect-ratio responsive video (6 breakpoint variants) |
| **PcomBackgroundVideo** | `PcomBackgroundVideo__` | Full-bleed bg video with poster image fade |
| **PcomVideoPlyr** | `PcomVideoPlyr__` | Custom Plyr video player integration |

#### UI Components
| Component | CSS Prefix | Description |
|-----------|------------|-------------|
| **PcomDisplay** | `PcomDisplay__` | Display heading (small/medium/large/inherit) |
| **PcomScrollIndicator** | `PcomScrollIndicator__` | Animated scroll-down indicator |
| **PcomGrid** | `PcomGrid__` | Base grid container |
| **PcomGridItem** | `PcomGridItem__` | Grid item with width positioning |
| **PcomCarouselDescription** | `PcomCarouselDescription__` | Carousel caption text |

### Key Component Details

#### HomeStage (Hero)
- Full-width (`width-full`) grid item
- Background video via `PcomBackgroundVideo`
- Large Display headline with word-stagger animation
- CTA button with entrance animation delay
- Scroll indicator at bottom
- Pause button for autoplay video
- 3 HomeStageTile cards below hero
- **Theme:** Always `scheme-dark`

#### DesktopCarRangeTile
```
┌──────────────────────────────────┐
│ [Video/Poster Background]        │
│ ┌────────────────────────────┐   │
│ │ Gradient Overlay (top)     │   │
│ │                            │   │
│ │ [Model Signature/Logo]     │   │
│ │                            │   │
│ │ [Gradient Overlay (bottom)]│   │
│ │ ├─ Fuel Tag (scheme-dark)  │   │
│ │ ├─ Model Name/Description │   │
│ │ └─ Explore Button         │   │
│ └────────────────────────────┘   │
└──────────────────────────────────┘
```

Each tile has:
- **Video** with poster image that fades out when loaded
- **Two gradients:** top gradient overlay + bottom gradient overlay (creates cinematic lighting)
- **Signature:** Model name logo in Porsche Next
- **Fuel Tag:** Badge showing fuel type (e.g., electric, hybrid)
- **Description:** Model tagline/description text
- **Explore Button:** Primary CTA
- **Hover:** The entire tile is clickable (`.DesktopCarRangeTile__clickableArea`)

#### Teaser
- 3 tiles in a row using basic grid
- Staggered entrance animation (delay-0, delay-1, delay-2)
- Uses PDS Web Components (`<p-link-tile>`, `<p-text>`, `<p-picture>`)
- Dark theme (`scheme-dark`)
- Image-first with text overlay below

### PDS Web Components (Custom Elements)

The page uses Porsche Design System v4 custom elements loaded from CDN:
- `<pnav-footer>` -- Global footer navigation
- `<p-link-tile>` -- Clickable tile component
- `<p-text>` -- Typography component
- `<p-link>` -- Link component
- `<p-picture>` -- Responsive picture element

These are initialized via: `porscheDesignSystem.load()` with CDN configuration.

---

## Design Tokens Summary

### Complete Token Inventory

| Category | Count | Details |
|----------|-------|---------|
| Color tokens | 42 | Light + dark for all semantic + contrast levels |
| Typography tokens | 12 | Type scale (9) + weight (3) |
| Spacing tokens | 14 | Fluid (6) + static (8) |
| Radius tokens | 9 | xs through 4xl + full |
| Shadow tokens | 4 | sm/md/lg + focus |
| Easing tokens | 3 | in-out/in/out |
| Duration tokens | 4 | sm/md/lg/xl |
| Font faces | 19 | 7 scripts, 3 weights |
| Component tokens | 8+ | pcom-spacing-*, pcom-transition-duration |
| **Total** | **115+** | |

### CSS Custom Properties Naming Convention

`--p-{category}-{variant}` for design tokens:  
`--p-color-canvas`, `--p-font-porsche-next`, `--p-spacing-fluid-md`, `--p-radius-sm`, `--p-shadow-md`, `--p-ease-in-out`, `--p-duration-md`, `--p-blur-frosted`

`--pds-{internal}-{property}` for internal grid system:  
`--pds-internal-grid-margin`, `--pds-internal-grid-width-max`, `--pds-internal-grid-safe-zone`

`--pcom-{property}` for component-level tokens:  
`--pcom-spacing-medium`, `--pcom-transition-duration`

---

## Takeaways

### What Makes This Design System Exceptional

1. **Dark-first philosophy** -- Inverts the typical web pattern. Most sites default to light and add dark mode. Porsche defaults to dark, treating it as the primary brand surface. This creates immediate differentiation and luxury perception.

2. **Video as the primary hero medium** -- Still images are secondary. Every hero and car tile uses video with poster image fallbacks. This creates a cinematic, premium experience that static images cannot match.

3. **`light-dark()` single-source theming** -- Modern CSS feature elegantly defines both themes in a single property value. No separate dark-mode class overrides needed. The `@supports` fallback provides graceful degradation.

4. **Fluid everything** -- Typography, spacing, and grid gaps all use `clamp()` for viewport-proportional scaling. No hard breakpoint jumps -- everything is smooth. This is premium-level responsive design.

5. **Staggered entrance animations** -- Content reveals progressively (word-by-word for headlines, tile-by-tile for cards) creating a curated, editorial reading experience rather than everything appearing at once.

6. **Proprietary typeface as brand moat** -- Porsche Next cannot be replicated. The narrow, geometric personality is as distinctive as the 911 silhouette. Combined with 7 writing system variants, it works globally without compromise.

7. **Named grid zones** -- Beyond simple column counts, the grid has semantic zones (basic, extended, full, narrow, wide) that communicate intent. Content sits where it means to sit.

8. **Glass-morphism as luxury signifier** -- Frosted surfaces with `backdrop-filter: blur(32px)` appear on hover states and interactive elements. This is subtle luxury -- not over-the-top glassmorphism, but a whisper of transparency.

9. **Restrained color palette** -- Only one true accent color (focus blue `#1a44ea`). Everything else is grayscale with alpha transparency. The brand lets the photography and video carry the color.

10. **Web Components for cross-framework compatibility** -- PDS v4 uses custom elements that work with any framework (Astro, React, Vue, plain HTML). The CDN-hosted script means instant updates across all Porsche digital properties.

### Implementation-Ready Patterns

- **Fluid type scale formula:** `clamp(min, vw-slope + intercept, max)` -- Copy the exact values from the typography section
- **Dark-first color tokens:** Use `light-dark()` in modern browsers with `@supports` fallback
- **Staggered entrance:** Apply CSS animation-delay incrementally to child elements
- **Named grid zones:** Semantic zone names make layouts self-documenting
- **frosted hover:** `backdrop-filter: blur(32px)` + `background-color: rgba(X,X,X,.15)`

---

## Limitations

### Extraction Constraints

- **Single page only:** Analysis based on homepage (Hong Kong locale). May not include sub-page patterns (model detail pages, configurator, etc.).
- **No JavaScript analysis:** Only CSS and HTML structure were extracted. Interactive behaviors (car configurator, navigation dropdowns) are inferred from classes, not tested.
- **PDS Web Components not inspected:** Components like `<pnav-footer>`, `<p-link-tile>` are loaded externally from CDN. Their internal styling and shadow DOM are not analyzed.
- **Images not fetched:** All image analysis is based on `srcset` and class names, not visual inspection.
- **Navigation structure incomplete:** The navigation appears to be client-side rendered. Only footer and main content were analyzed.
- **No CSS from CDN:** PDS component styles are loaded from `cdn.ui.porsche.com`. Only page-level Astro CSS was extracted.

### Estimates and Approximations

- Typography scale min/max values calculated from clamp() formulas at 320px and 1920px viewports
- Exact `pcom-spacing-*` token values were referenced but not extracted from the CDN-hosted PDS CSS
- Animation durations for some section animations were inferred from class naming patterns

### Edge Cases Not Covered

- RTL support (Arabic variants loaded but page is LTR)
- Print stylesheet (not found in extracted CSS)
- Form components (configurator not on homepage)
- Search/autocomplete results (AI car finder uses dynamic rendering)
- Error states beyond the ErrorDisplay component
- Loading states beyond image loading transitions
