# Algolia Design System

> Extracted from https://www.algolia.com on 2026-05-18
> Platform: Web (Tailwind CSS + custom CSS, Java-based CMS backend)
> Status: Live production homepage

---

## Overview

Algolia is a leading AI search-and-retrieval SaaS platform. Its marketing website projects confidence through a **dark-first, video-rich aesthetic** anchored by a distinctive blue-to-purple gradient identity. The design system marries a custom two-font stack (Sora for brand personality, Inter for legibility), a precise component kit built on Tailwind utility classes, and a restrained but polished motion language. Key themes: **depth through layered video/overlays, hover-state richness, and a single-accent gradient used consistently across buttons, headings, and stat numbers.**

---

## Layout System

### Container Architecture

| Container | Max Width | Usage |
|-----------|-----------|-------|
| `max-w-screen-xl` | 1280px | Standard content sections |
| `max-w-[1512px]` | 1512px | Hero section overflow container |
| `max-w-[1210px]` | 1210px | Accordion media section inner |

### Grid System

Uses a 12-column CSS grid with responsive gap:

```
grid grid-cols-12 md:gap-x-16 gap-y-8
```

Common column spans:
- Full-width: `col-span-12`
- Hero split: Left 47.7% text + Right 53.3% visual
- Accordion split: Left 60% media + Right 40% accordion list

### Section Rhythm

Sections alternate between **dark** (`bg-xenon-900`) and **light** (`bg-white` or `bg-secondary`) backgrounds, creating a visual breathing rhythm. Each section follows the pattern:

1. Section wrapper with optional background video + overlay images
2. `max-w-screen-xl` container with `px-4 lg:px-14`
3. Heading block (centered or left-aligned)
4. Content grid
5. Optional CTA container

### Breakpoints (Tailwind-based)

| Name | Min Width | Usage |
|------|-----------|-------|
| sm | 375px | Small mobile |
| md | 768px | Tablet |
| lg | 960px / 1024px | Desktop nav, layout split |
| xl | 1200px | Desktop wide |
| 2xl | 1440px / 1536px | Very wide |

Additional custom breakpoints: 500px, 1280px, 1366px, 1920px

---

## Color System

### Brand Identity Colors

| Token | Value | Usage |
|-------|-------|-------|
| Xenon Primary | `#003DFF` | Theme color, meta tags, logo accent |
| Xenon Medium | `#1E59FF` | Button base, SVG icon strokes |
| Xenon Light | `#457AFF` | Gradient start, link hover |
| Xenon Nav | `#2C60E8` | Navigation chevron arrows |
| Xenon Label | `#8A9DCD` | Nav section labels, tertiary text |

### Xenon Scale (Tailwind-extended)

| Token | Hex | CSS Class Pattern |
|-------|-----|-------------------|
| xenon-100 | Lightest blue tint | `bg-xenon-100`, `text-xenon-100` |
| xenon-200 | Light blue tint | `bg-xenon-200` (active lang item bg) |
| xenon-400 | `#003DFF` | **Primary CTA** (`bg-xenon-400`) |
| xenon-600 | Medium-dark blue | `bg-xenon-600`, `text-xenon-600` |
| xenon-800 | Dark blue | `bg-xenon-800` |
| xenon-900 | `#000e68` / `#00002d` | **Dark section BG** (`bg-xenon-900`) |

### Grey Scale

| Token | Hex | Usage |
|-------|-----|-------|
| grey-100 | `#f5f5fa` | Dropdown item bg (hover) |
| grey-200 | `#e5e5ef` | Borders, active dropdown items |
| grey-400 | Light grey | Footer headings |
| grey-700 | `#374151` | Body text (light mode), borders |
| grey-900 | `#111827` | Primary text (light mode), headings |

### Accent Colors

| Token | Value | Usage |
|-------|-------|-------|
| blue-600 | `#2563eb` | Card heading default, accordion active |
| blue-purple-100 | Light blue-purple | Nav item headings |
| purple-500/600 | Purple | Gradient text end point |
| blue-500 | Blue | Gradient stat numbers start |
| green | `#00a648` | Bar chart fills |
| zinc-400 | Grey-zinc | Card description text |
| dark-gray-100 | Dark grey | Card description (dark mode) |

### Gradient Catalog

| Name | CSS | Usage |
|------|-----|-------|
| **Primary Blue** | `linear-gradient(220deg, #457AFF 0%, #1E59FF 60.16%)` | Default CTA buttons |
| **Hover Blue** | `linear-gradient(138deg, rgba(118,160,255,0.7) 0%, rgba(0,61,255,0.7) 25.08%, rgba(151,71,255,0.7) 56.38%, rgba(118,160,255,0.7) 100%), #003DFF` | Button hover |
| **Logo Popover** | `linear-gradient(to right, #022eb9, #003dff)` | Logo dropdown bg |
| **Text Gradient** | `from-blue-600 to-purple-500` | Card headings on hover |
| **Stat Gradient** | `from-blue-500 to-purple-500` | Stat numbers (bg-clip-text) |
| **Hover Transparent** | `linear-gradient(138deg, rgba(187,209,255,0.2)...)` | Outline button hover |
| **Accordion Active (Light)** | `linear-gradient(90deg, #FFF 2.5%, rgba(242,244,255,0.51) 100%)` | Active accordion item |
| **Accordion Active (Dark)** | `linear-gradient(90deg, #000E68 2.5%, #00002D 100%)` | Active accordion item dark |
| **Bar Chart** | `linear-gradient(90deg, rgba(0,166,72,0) 0%, rgb(0,166,72) 50%)` | Animated bar fills |

### Dark Mode Token Overrides

| Context | Light | Dark |
|---------|-------|------|
| Page BG | `bg-white` | `bg-xenon-900` |
| Text primary | `text-grey-900` | `dark:text-white` |
| Text secondary | `text-grey-700` | `dark:text-grey-200` |
| Border | `border-grey-200` | `dark:border-white` |
| Header border bottom | `#D6D6E7` | `#242757` |
| Accordion active text | `rgb(37, 99, 235)` | `#F9F9FF` |
| Card description | `text-gray-700` | `dark:text-gray-200` |

### Theme Architecture

The HTML body carries `data-site-theme="dark"` with per-page override via `data-page-theme="light"`. A `dark` class is used at the container level for dark sections. The site uses a **dark-homepage, light-child-page** pattern.

---

## Typography

### Font Stack

**Primary Brand: Sora** (7 weights, self-hosted WOFF2+WOFF)
- Light (300), Regular (400), Medium (500), SemiBold (600), Bold (700), ExtraBold (900)
- Used for: Hero headings, section titles, buttons, CTAs, accordion titles, stat numbers, nav labels

**Body/UI: Inter** (6 weights, self-hosted WOFF2+WOFF)
- Regular (400), Medium (500), SemiBold (600), Bold (700), ExtraBold (800), Black (900)
- Used for: Body text, navigation items, footer links, promo banner, language switcher

**Legacy: Avenir Next** (2 weights)
- Bold (700), Heavy (900)
- Minimal usage, appears in older components

### Type Scale

| Level | Size (mobile -> desktop) | Weight | Font | Line-Height | Letter-Spacing | Usage |
|-------|--------------------------|--------|------|-------------|----------------|-------|
| Hero h1 | 40px -> 56px -> 70px -> 77px | Bold (700) | Sora | 105% | -4px | Homepage hero |
| Section h2 | 2.125rem (34px) -> 2.625rem (42px) | Bold (700) | Sora | 2.75rem -> 3.438rem | -0.01em | Section headings |
| Stat Number | 5rem (80px) | Black (900) | Sora | 1.1 | -4% | Statistic cards |
| Accordion Title | 18px -> 21px | Bold (700) | Sora | 140% (lg) | - | Accordion items |
| Card h4 | 21px | SemiBold (600) | Sora | 28px | - | Feature card headings |
| Card Description | 14px | Normal (400) | Inter | - | - | Card body text |
| Button Text | 14px -> 16px | SemiBold (600) | Sora | 1.5 | 0.28px -> 0.32px | All CTAs/buttons |
| Body | 16px (text-base) | Normal (400) | Inter | 1.5 | - | General body text |
| Hero Subtitle | 16px -> 18px -> 19px | Normal (400) | Sora | relaxed | - | Hero description |
| Nav Label (Caps) | 10px | Bold (700) | Sora | 13px | 3px | Mega menu section labels |
| Nav Item | 14px -> 16px | Normal (400) | Inter | - | - | Top nav / dropdown items |
| Promo Banner | 14px | Normal (400) / SemiBold (600) | Inter | 1.5 | - | Header promo bar |
| Footer Link | 12px -> 14px | Normal (400) | Inter | - | - | Footer nav |
| "New Report" Badge | 14px | SemiBold (600) | Inter | 1.5 | - | Promo label |

### Font Loading Strategy

All fonts are **self-hosted** from `/modules/algolia-base-template/css/fonts/` with WOFF2 (primary) + WOFF (fallback). The CSS uses standard `@font-face` declarations with `font-display` not explicitly set (defaults to `auto`).

---

## Motion Catalog

### Keyframe Animations

| Name | Duration | Easing | Effect |
|------|----------|--------|--------|
| `slideIn` | 0.5s | ease-in-out | translateX(-100%) -> 0 + opacity 0 -> 1 |
| `slideOut` | 0.5s | ease-in-out | reverse of slideIn |
| `agentic-hero-dot-fill` | (driven by JS) | - | scaleX(0) -> scaleX(1) progress bar |
| `spin` | 1s | linear (infinite) | rotate(0deg) -> rotate(360deg) loader |
| `af-preopen-entry` | 0.5s | ease-out | translateY(10px) + opacity 0 -> translateY(0) + opacity 1 |
| `af-preopen-pulse` | (infinite) | - | scale(1) <-> scale(1.03) attention pulse |
| `fadeInLeft` | 0.3s | - | opacity 0 + translateX(100px) -> opacity 1 + translateX(0) |
| `animation-iw05yv` | 1s | cubic-bezier(0.785, 0.135, 0.15, 0.86) | Width bar fill (various percentages) |
| `socialtitleanimation` | - | - | right: 50px -> 80px slide |

### Transition Patterns

| Pattern | Duration | Easing | Properties |
|---------|----------|--------|------------|
| Hero slide crossfade | 1.5s | ease-out | opacity (image carousel) |
| Card hover lift | 300ms | ease-in-out | transform (translateY), box-shadow |
| Accordion content expand | 300ms | ease-in-out | max-height, opacity |
| Accordion icon rotate | 300ms | - | transform (rotate-0 -> rotate-90) |
| Button icon hover | 400ms | ease-in | transform (scale 1.1), fill color |
| Dropdown visibility | 0.3s | - | opacity, visibility, animation: fadeInLeft |
| Underline gradient expand | 500ms | ease-in-out | width (0 -> 100% on hover) |
| CTA reveal (cards) | 300ms | ease-out | max-height, opacity |
| Footer link color | 200ms | - | color (white -> xenon-400) |
| Cursor tracking glow | 0.2s | - | opacity (radial gradient follow) |

### Hover Interaction Patterns

1. **Button hover**: Gradient color shift (blue-gradient to multi-stop blue-purple gradient), mouse-tracking radial glow via `--x`/`--y` CSS custom properties
2. **Card hover**: Translate up 8px (-translate-y-8), shadow-lg, heading text shifts to blue-purple gradient (bg-clip-text), hidden CTA button reveals
3. **Nav item hover**: Color shift to xenon-600, mega dropdown appears with fadeInLeft animation
4. **Accordion item hover/active**: Left border gradient background appears, icon becomes visible (opacity 0->1), text color shifts to blue
5. **Footer link hover**: Color transitions from white to xenon-400 over 200ms
6. **Promo arrow hover**: Icon fills with xenon-400, scales 1.1

### Reduced Motion

`@media (prefers-reduced-motion: reduce)` disables:
- `agentic-hero-dot-fill` animation (sets transform: scaleX(1) statically)
- `af-preopen-pulse` animation (sets animation: none)

---

## Spacing System

Based on a **4px grid** (Tailwind default). Key spacing tokens:

### Section-Level Spacing

| Token | Value | Usage |
|-------|-------|-------|
| `py-8` | 32px | Compact sections |
| `py-20` | 80px | Standard sections |
| `py-28` | 112px | Major sections, CTA areas |
| `lg:py-28` | 112px (desktop) | Feature sections |
| `mt-18` | 72px | Before headings |

### Container Padding

| Token | Value | Usage |
|-------|-------|-------|
| `px-4` | 16px | Mobile horizontal padding |
| `lg:px-14` | 56px | Desktop horizontal padding |
| `px-8` | 32px | Medium padding |

### Component-Level Spacing

| Component | Spacing | Detail |
|-----------|---------|--------|
| Hero text top margin | `mt-10` (40px) | Below header |
| Hero CTA gap | `gap-4` (16px) | Between buttons |
| Card padding | `p-6` (24px) | Inner card |
| Accordion item | `py-[29px]` (29px) vertical, `px-4` horizontal | Precise control |
| Accordion left padding (desktop) | `lg:pl-6` (24px) / `lg:pr-10` (40px) | |
| Section heading bottom | `mb-8` (32px) | After h2 |
| Card grid gap | `gap-11` (44px) / `lg:gap-4` (16px desktop) | |
| Footer gap | `gap-x-2 lg:gap-x-8` | Between columns |
| Gap between CTA buttons | `gap-4` (16px) | flex container |
| Stat card size | `w-[380px] h-[520px]` | Fixed dimensions |

### Max Content Widths

| Element | Max Width |
|---------|-----------|
| Hero text block | `max-w-[520px]` mobile, `lg:max-w-none` desktop |
| Hero subtitle | `lg:max-w-[430px]` |
| Section heading text | `lg:w-[90%]` |
| Feature card | `lg:max-w-[280px]` |
| Nav item text | `lg:max-w-[10rem]` / `xl:max-w-[13.125rem]` |
| Accordion media section | `md:max-w-[1210px]` |
| Logo popover | `width: 500px` |

### Custom Spacing Tokens

| Value | Context |
|-------|---------|
| `lg:pl-[85px]` | Hero text left offset |
| `lg:pl-[112px]` | Feature section heading offset |
| `lg:mb-[117px]` | Hero text bottom margin |
| `lg:gap-[55px]` | Accordion left-right gap |
| `lg:mr-[85px]` | Content area right margin |

---

## Component Patterns

### 1. Header / Navigation

**Structure**: Three-layer sticky header (z-[999])
- **Top Nav Bar**: `h-10` (40px), promo banner (left) + utility nav (right: Company, Partners, Support, Login/Logout)
- **Middle Bar**: `h-20` (80px), logo (left) + main navigation (center) + global search (right)
- **Mobile Toggle**: Hamburger/close icon swap, hidden on lg+

**States**: 
- Light bg `bg-white` with `text-grey-900` text
- Dark bg `dark:bg-xenon-900` with `dark:text-white` text
- Sticky scroll: `sticky inset-0`
- Border bottom: `lg:border-b lg:border-grey-200` (light) / `#242757` (dark)

**Mega Dropdown** (`.dropdown-menu-v2`):
- White card: `lg:bg-white lg:shadow-md lg:rounded-md lg:mt-[14px]`
- Layout: featured image (left, 16rem square) + column sections (right)
- Section headers: `font-sora text-[10px] font-bold tracking-[3px] uppercase text-[#8A9DCD]`
- Item headings: `text-sm text-blue-purple-100 font-bold`
- Item descriptions: `text-xs text-zinc-400 font-normal`
- Animation: `fadeInLeft 0.3s`, visibility + opacity toggle on hover

### 2. Hero Banner

**Component**: `.agentic-hero-banner`
- Full-width dark background (`bg-xenon-900 dark overflow-hidden`)
- Background video (auto-play, loop, muted) at `opacity-60`
- 3-slide image carousel with:
  - Middle blur overlay layer (`agentic-hero-blur`): mask-image gradient (transparent -> black -> transparent) for edge fade
  - 1.5s ease-out opacity crossfade between slides
  - Dot navigation: `.agentic-hero-dots` with `.agentic-hero-dot--active` (scaleX fill animation)

**Hero Content**:
- Split layout: 47.7% text (left) + 53.3% visual (right)
- h1: `font-sora font-bold text-white`, 40-77px fluid, `line-height: 105%`, `letter-spacing: -4px`
- Subtitle: `font-sora text-base/18px/19px font-normal leading-relaxed`
- CTA: Primary blue-gradient button ("Explore the platform")
- Terminal-style decorative image inline with h1 text

### 3. Button System

All buttons share a common anatomy:
```html
<a class="relative z-50 cmp-button overflow-hidden flex flex-wrap items-center cursor-pointer font-sora w-full
          ctaGradient justify-center [color-class] px-4 lg:px-6 [bg-class] rounded-lg min-h-12 lg:min-h-14"
   style="--x: 0px; --y: 0px;">
  <span class="cmp-button__text font-semibold mx-auto font-sora leading-1.5 text-sm lg:text-base tracking-[0.28px] lg:tracking-[0.32px]">
    Label
  </span>
</a>
```

**Variants**:

| Variant | Background | Text | Border/Shadow | Hover |
|---------|-----------|------|---------------|-------|
| **Primary** | `bg-xenon-400` + `blue-gradient` class | `text-white` | none | Multi-stop blue-purple gradient |
| **Outline** | `bg-transparent` | `dark:text-white text-grey-900` | `shadow-[0_0_6px_2px_rgba(0,61,255,0.12)] border-2 dark:border-white border-grey-200` | Subtle blue-purple tint overlay |
| **White** | `bg-white` | `text-grey-900` | `shadow-md border-2 border-white` | `hover:text-grey-700` |

**Button properties**:
- `rounded-lg` (8px border-radius)
- `min-h-12` (48px mobile) / `lg:min-h-14` (56px desktop)
- Mouse tracking glow effect via `--x`/`--y` CSS custom properties (radial gradient following cursor)
- Font: Sora SemiBold, 14-16px, tight tracking

### 4. Media Accordion

**Component**: `.media-accordion`
- Split layout: 60% embedded media (Arcade/iframe) + 40% accordion list
- Each accordion item (`.accordion_item`):
  - Default: transparent border, normal text
  - Hover (`:hover` / `.hovered`): gradient background slides in from left, 1.5px blue-tinted border, icon becomes visible
  - Active (`.current`): Same as hover, text turns blue (light) or bright white (dark)
  - Border radius: `14px 0px 0px 14px` (left-side rounded, right-side flush)
- Content expand: `max-h-0` -> expanded, 300ms ease-in-out
- Icon: chevron right, rotates, `opacity-0` -> `opacity-1` on hover/active

**Dark mode accordion backgrounds**:
- Active: `linear-gradient(90deg, #000E68 2.5%, #00002D 100%)` + `border: 1.5px solid #6B83D1`

### 5. Feature Teaser Cards

**Component**: `.teaser-with-cta`
- White card: `bg-white rounded-lg p-6`
- Fixed size on desktop: `lg:max-w-[280px] lg:min-h-[250px]`
- **Hover effects** (300ms ease-in-out):
  - Card lifts: `-translate-y-8`
  - Shadow appears: `shadow-lg`
  - Heading gradient: text shifts to `bg-gradient-to-r from-blue-600 to-purple-500 bg-clip-text text-transparent`
  - CTA button reveals: `max-h-0 opacity-0` -> `max-h-[100px] opacity-100`
  - Bottom underline expands then fades (500ms): `w-0` -> `w-full` then `opacity-0`
- Focus-visible: `focus-within:z-10` (lifts card above siblings)

### 6. Statistic Cards

**Component**: Scrolling stat cards
- Fixed dimensions: `w-[380px] h-[520px]`
- `bg-white rounded-xl overflow-hidden shadow-2xl`
- Three-part layout:
  - Top (120px): Customer logo, bottom-aligned
  - Middle (250px): Gradient stat number (`text-[5rem] font-black font-sora`, blue-to-purple bg-clip-text) + description (`text-[21px] font-sora text-gray-700`)
  - Bottom (170px): Full-width customer image (`object-cover`)
- Horizontal scroll container: `flex overflow-x-visible gap-4 scrollbar-hide snap-x cursor-grab`

### 7. Compliance/Security Card Grid

**Component**: Certification cards
- `bg-white rounded-xl border border-gray-200 px-4 py-4 shadow-sm`
- Hover: `hover:shadow-md transition`
- Layout: Icon (80px height, centered) + label (`text-[14px] font-semibold text-grey-900`)
- Grid of 6 cards for certifications (SOC2, SOC3, ISO27001, GDPR, CCPA, HIPAA)

### 8. Auto-Slider / Logo Carousel

- Powered by Splide.js (v4.1.4)
- Auto-scroll extension for continuous movement
- CSS custom property: `--auto-slider-header-color` (adapts to theme)
- Scrollbar hidden: `scrollbar-hide`

### 9. CTA Container

Standard CTA row pattern:
```html
<div class="flex gap-4 shrink-0 flex-wrap lg:flex-row flex-col justify-center">
  <!-- Primary CTA button -->
  <!-- Secondary/Outline CTA button -->
</div>
```

Always uses Sora font, always 2-button max per row.

### 10. Footer

- Background: `bg-xenon-900` (deep dark blue)
- Layout: flex columns (`flex gap-x-2 lg:gap-x-8`)
- Column headings: `font-inter text-base/18px text-grey-400`
- Link items: `font-inter text-xs/14px text-white`, hover: `text-xenon-400` (200ms transition)
- Max width: `max-w-screen-xl`, padding: `lg:px-14 px-4 py-8 lg:py-10`

### 11. Language Switcher

- Button: globe icon + language code text + chevron
- Dropdown: `w-[150px] rounded-lg shadow-small-light`, white bg
- Active item: `bg-xenon-200 text-xenon-600`
- Inactive items: `bg-grey-100 hover:bg-grey-200 text-grey-900`

### 12. Chat Widget (Agentforce Facade)

- Fixed position: `right: 24px, bottom: 37px`
- Entry animation: `af-preopen-entry` (0.5s ease-out)
- Pulse animation: `af-preopen-pulse` (infinite scale pulse)
- Consent-gated (OneTrust integration)
- Dismissable with sessionStorage persistence

### 13. Logo Popover

- Triggered from logo hover
- Width: 500px
- Gradient background: `linear-gradient(to right, #022eb9, #003dff)`
- White text on dark blue
- Slide-in/out animations (0.5s ease-in-out)

---

## Design Tokens Summary

### CSS Custom Properties

| Property | Value | Scope |
|----------|-------|-------|
| `--x` | `0px` (JS-updated) | Mouse tracking on buttons |
| `--y` | `0px` (JS-updated) | Mouse tracking on buttons |
| `--auto-slider-header-color` | `#111827` (light) / `#ffffff` (dark) | Logo carousel header |

### Border Radius Scale

| Token | Value | Usage |
|-------|-------|-------|
| `rounded-lg` | 8px | Buttons, cards, dropdowns |
| `rounded-xl` | 12px | Stat cards, compliance cards |
| `rounded-md` | 6px | Mega dropdown container |
| Custom | `14px 0px 0px 14px` | Active accordion item (left-side only) |

### Shadow Scale

| Token | Value | Usage |
|-------|-------|-------|
| `shadow-sm` | Subtle | Compliance cards (default) |
| `shadow-md` | Medium | Mega dropdown, white buttons, compliance cards (hover) |
| `shadow-lg` | Large | Feature cards (hover) |
| `shadow-2xl` | Extra large | Stat cards |
| `shadow-small-light` | Custom | Language dropdown |
| `shadow-[0_0_6px_2px_rgba(0,61,255,0.12)]` | Blue glow | Outline buttons |
| `0 2px 12px 0 rgba(0,0,0,0.12)` | Custom | Chat bubble |

### Z-Index Layer System

| Layer | Token | Component |
|-------|-------|-----------|
| Content | `z-10` | Accordion content, hero content |
| Overlay | `z-20` | Hero text, section content over video |
| Elevated | `z-50` | Buttons (relative within cards) |
| Dropdown | `z-[99]` | Navigation dropdown, language switcher |
| Chat | `z-[101]` | Agentforce chat widget |
| Header | `z-[999]` | Main sticky header |
| Logo popover | `z-[9999]` | Logo hover popover |

---

## Section Architecture (Homepage)

The homepage follows this section sequence:

1. **Header**: Sticky, multi-layer, promo banner + utility nav + main nav
2. **Hero**: "Agentic. Generative. Search." — dark video bg, 3-slide carousel, primary CTA
3. **Use Cases Accordion**: "Powering AI retrieval across use cases" — media accordion with 4 items (Product Discovery, Generative AI, Guided Shopping, Documentation)
4. **Business Goals Cards**: "Solutions that fulfill your business goals" — 5 feature teaser cards with hover reveals
5. **Customer Logos Auto-Slider**: Splide-powered horizontal scroll
6. **Proven Impact Stats**: "Proven impact" — horizontally scrollable stat cards with customer metrics
7. **Compliance & Security**: Grid of 6 certification badges
8. **CTA Banner**: "Harness the power of goal driven AI search" — dark video bg with overlay, dual CTA
9. **Footer**: 5-column link footer on xenon-900 dark bg

---

## Key Design Takeaways

1. **Single-accent gradient discipline**: The blue (#003DFF) to purple gradient is the sole accent strategy — applied to buttons, stat numbers, card headings on hover, and accordion active states. No secondary accent colors compete.

2. **Dual-font clarity**: Sora (geometric, expressive) for brand moments; Inter (neutral, legible) for information. The boundary is rigid: Sora never appears in body paragraphs; Inter never appears in headings or CTAs.

3. **Dark-first with light alternation**: The homepage leads with dark (xenon-900), alternates to light sections, then returns to dark for the CTA banner. Each transition provides visual breathing room.

4. **Hover-state as discovery mechanism**: Cards hide their CTAs until hover, gradients appear on headings only on hover, accordion items reveal their icons on hover. The interface is clean by default and rich on interaction.

5. **Video as atmosphere, not content**: Background videos run at 60% opacity with additional overlay images using `mix-blend-mode: overlay` — the video provides texture, not information.

6. **Precision spacing**: The design uses Tailwind's 4px grid but freely breaks out with arbitrary values for precise optical alignment (29px accordion padding, 85px hero text offset, 77px hero size).

7. **Responsive type that scales aggressively**: Hero text goes from 40px (mobile) to 77px (xl desktop) — nearly 2x scale. Section headings scale from 34px to 42px. This creates dramatically different visual weight across viewports.

8. **Cursor-aware interactivity**: Buttons track mouse position via `--x`/`--y` custom properties to position a radial gradient glow, adding a polished, reactive feel.

9. **Tailwind as the foundation, custom CSS for the signature**: The system uses Tailwind for layout, spacing, and typography utilities, but all the distinctive visual moments (gradients, masks, cursor tracking, accordion borders) are custom CSS.

10. **Content-driven component sizing**: Stat cards have fixed dimensions (380x520px), feature cards have min-height constraints (250px), accordion items have precise padding (29px). Components are sized for their content, not abstractly.

---

## Extraction Limitations

1. **No JS analysis performed**: JavaScript behavior (Splide carousel initialization, accordion toggle logic, mouse tracking JS, hero carousel auto-rotation timing, chat widget state machine) was not analyzed. Only CSS animation definitions were captured.

2. **Single page only**: Only the homepage was analyzed. Child pages (product pages, documentation, blog) may use different layouts, color themes, or component variants.

3. **CSS is minified**: The primary stylesheet (`6c596c30f9ba6e4e6c69fb4a8836.min.css`) is 316KB of minified CSS, making it impractical to fully decompile. Custom property extraction focused on identifiable tokens; utility classes were excluded.

4. **Font files not downloaded**: The self-hosted WOFF2/WOFF font files were not fetched. Font metrics, OpenType features, and subset details are unknown.

5. **Dynamic states not captured**: Modal dialogs, form validation states, loading states, empty states, and error states were not observed since only the static homepage HTML was analyzed.

6. **Third-party integrations**: The site uses OneTrust (cookie consent), Amplitude (analytics), Arcade (product demos), Splide (carousels), and Algolia Autocomplete — all external dependencies. Their specific contributions to the visual design were noted but not deep-analyzed.

7. **CMS layer opaque**: The HTML contains Java CMS artifacts (JSP includes, data attributes like `data-finalurl`, `data-sly-*`). The component model in the CMS may expose more variants than visible on the homepage.
