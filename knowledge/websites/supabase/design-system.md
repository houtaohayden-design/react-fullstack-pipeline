# Supabase Design System

> Extracted from: https://supabase.com | Date: 2026-05-18 | 3 requests, ~837KB total

## Overview

Supabase's marketing website uses a sophisticated dark-first design system powered by **Tailwind CSS v4**, Next.js, and an **HSL-based semantic token architecture**. The design language is developer-focused, clean, and premium -- characterized by a signature emerald-green brand accent against near-black surfaces, a border-based hierarchy system, restrained animations, and a custom Circular typeface. The system employs a Radix-Colors-inspired 12-stop color scale (100-1200) with full dark/light theme support via `[data-theme]` attribute switching.

**Tech stack identified:**
- **Framework:** Next.js (React)
- **Styling:** Tailwind CSS v4 (utility-first with `@theme` CSS custom properties)
- **Animation:** CSS-only (zero JS animation libraries on marketing pages)
- **Typography:** Custom self-hosted Circular font (WOFF2), Source Code Pro (mono)
- **Component primitives:** Radix UI (accordion, collapsible, dialog, navigation, cmdk)
- **Code display:** Code Hike (syntax highlighting)
- **Carousels:** Swiper.js
- **Charts:** Recharts
- **Hosting:** Vercel (frontend-assets.supabase.com CDN)

## Layout System

### Content Max-Widths
| Token | Value | Usage |
|-------|-------|-------|
| `--content-width-screen-xl` | 1128px | Primary content container |
| `--container-xs` through `--container-7xl` | 20rem - 80rem | Tailwind container breakpoints |
| `lg:container` | responsive | Applied to nav and sections |

### Container Padding
- Base: `px-6` (24px) mobile
- `lg:px-16` (64px) desktop
- `xl:px-20` (80px) widescreen
- Vertical: `py-16` (64px) default, `md:py-24` (96px), `lg:py-24`

### Navigation
- **Type:** Sticky top nav with backdrop blur
- **Height:** `h-16` (64px) fixed
- **Z-index:** `z-40` with `transform: translate3d(0,0,999px)` for GPU compositing
- **Background:** `bg-background/90` (light) / `dark:bg-background/95` (dark) -- translucent surface
- **Border:** `border-default border-b` (bottom separator)
- **Blur:** `backdrop-blur-xs` behind semi-transparent background
- **Animation:** `transition-all duration-300` for scroll state changes
- **Desktop:** Horizontal nav with Radix NavigationMenu (`data-orientation="horizontal"`)
- **Mobile:** Hidden (`lg:hidden` hamburger), slide-in panel

### Hero Section
- **Layout:** Centered text, `max-w-2xl`, `lg:col-span-6 lg:flex lg:items-center justify-center text-center`
- **Vertical rhythm:** `pt-[90px] lg:pt-[90px] lg:min-h-[300px]`
- **Content gap:** `gap-4 lg:gap-8` between heading, description, CTAs
- **Negative margin offset:** `mt-[-65px]` to pull content under nav
- **Announcement pill:** Rounded-full gradient badge with `backdrop-blur-md`

### Footer
- **Structure:** 7-column XL grid (`xl:grid-cols-7`)
  - Column 1-2: Brand/logo + social links + newsletter
  - Columns 3-7: Link columns (Product, Solutions, Resources, Developers, Community, Company)
- **Trust bar:** Full-width certifications bar (SOC2, HIPAA, ISO 27001) with checkmark icons
- **Divider:** `h-px bg-linear-to-r from-transparent via-border to-transparent` (edge-fade line)
- **Bottom:** Copyright + theme toggle

### Section Rhythm
- Alternating background surfaces (default / alternative)
- Consistent padding: `py-16 md:py-24 lg:py-24` per section
- `sm:py-18` intermediate breakpoint
- Section dividers use gradient-to-transparent borders

## Color System

### Architecture
Supabase uses a **3-tier semantic token system** built on HSL values:

```
Design Tokens (--brand-default: 153.1deg 60.2% 52.7%)
    ↓
CSS Custom Properties referencing HSL parts
    ↓
Utility Classes (bg-brand, text-foreground, border-border)
```

### Brand Colors (Supabase Green)

| Token | Dark Theme | Light Theme |
|-------|-----------|-------------|
| `--brand-default` | `153.1deg 60.2% 52.7%` (#3ECF8E) | `153.1deg 60.2% 52.7%` (#3ECF8E) |
| `--brand-200` | `162deg 100% 2%` | Not extracted |
| `--brand-300` | `155.1deg 100% 8%` | `147.5deg 72% 80.4%` |
| `--brand-400` | `155.5deg 100% 9.6%` | `151.3deg 66.9% 66.9%` |
| `--brand-500` | ~33% luminance green | `153.1deg 60.2% 52.7%` |
| `--brand-600` | ~primary brand green | `--brand-600` |
| `--brand-700` | `#155b3d` | Not extracted |
| `--brand-800` | `#1d724c` | Not extracted |
| `--brand-900` | `#3fcf8e` | Not extracted |
| `--brand-1000` | `#85e0b7` | Not extracted |
| `--brand-1100` | `#33cc87` | Not extracted |
| `--brand-1200` | `#ebfaf3` | Not extracted |

**Radix color scales** are also defined for amber, blue, crimson, gold, green, emerald, teal, cyan, purple, neutral, stone, slate (100-1200).

### Surface Colors (Dark Theme -- Primary)

| Token | HSL Value | Approx Hex |
|-------|-----------|------------|
| `--background-default` | `0deg 0% 7.1%` | #121212 |
| `--background-200` | `0deg 0% 9%` | #171717 |
| `--background-surface-75` | `0deg 0% 12.2%` | #1f1f1f |
| `--background-surface-100` | `0deg 0% 12.2%` | #1f1f1f |
| `--background-surface-200` | `0deg 0% 12.9%` | #212121 |
| `--background-surface-300` | (slightly lighter) | -- |
| `--background-control` | `0deg 0% 14.1%` | #242424 |
| `--background-selection` | `0deg 0% 19.2%` | #313131 |
| `--background-alternative-default` | `0deg 0% 9%` | #171717 |
| `--background-overlay-default` | (overlay/dialog bg) | -- |
| `--background-muted` | (muted bg) | -- |

### Surface Colors (Light Theme)

| Token | HSL Value |
|-------|-----------|
| `--background-default` | (near white) |
| `--background-surface-100` | `0deg 0% 98.8%` |
| `--background-surface-75` | `0deg 0% 100%` |
| `--background-alternative-default` | `0deg 0% 100%` |

### Text Colors (Foreground Scale)

| Token | Dark Theme | Light Theme | Usage |
|-------|-----------|-------------|-------|
| `--foreground-default` | `0deg 0% 98%` (near-white) | `0deg 0% 7.1%` (near-black) | Primary text, headings |
| `--foreground-light` | (secondary text) | (secondary text) | Body, descriptions |
| `--foreground-lighter` | (tertiary text) | (tertiary text) | Labels, meta, muted |
| `--foreground-muted` | `0deg 0% 30.2%` | `0deg 0% 69.8%` | Disabled, placeholders |
| `--foreground-contrast` | `0deg 0% 8.6%` | `0deg 0% 98.4%` | High contrast variant |

### Border Colors

| Token | Dark Theme | Light Theme |
|-------|-----------|-------------|
| `--border-default` | (default border) | (default border) |
| `--border-muted` | (subtle border) | (subtle border) |
| `--border-strong` | `0deg 0% 21.2%` | `0deg 0% 83.1%` |
| `--border-stronger` | `0deg 0% 27.1%` | `0deg 0% 56.1%` |
| `--border-control` | (input border) | (input border) |
| `--border-overlay` | (modal/dialog border) | (modal/dialog border) |
| `--border-button-default` | `--colors-gray-dark-700` | -- |
| `--border-button-hover` | `--colors-gray-dark-800` | -- |
| `--border-secondary` | (secondary border) | -- |

### Semantic Colors

| Token | Dark | Light |
|-------|------|-------|
| `--warning-default` | `38.9deg 100% 42.9%` (amber) | `30.3deg 80.3% 47.8%` |
| `--warning-200` | `36.6deg 100% 8%` | `40deg 81.8% 97.8%` |
| `--warning-300` | `32.3deg 100% 10.2%` | `44.3deg 100% 91.8%` |
| `--warning-400` | `33.2deg 100% 14.5%` | `41.9deg 100% 81.8%` |
| `--warning-500` | `34.8deg 90.9% 21.6%` | `36.3deg 85.7% 67.1%` |
| `--warning-600` | `38.9deg 100% 42.9%` | `30.3deg 80.3% 47.8%` |
| `--destructive-default` | `10.2deg 77.9% 53.9%` (same) | `10.2deg 77.9% 53.9%` |
| `--destructive-200` | `10.9deg 23.4% 9.2%` | `0deg 100% 99.4%` |
| `--secondary-default` | `247.8deg 100% 70%` (blue-purple) | Not extracted |
| `--secondary-400` | `248deg ...` (purple) | Not extracted |

### Accent Strategy
- **Single primary accent:** Supabase emerald green (#3ECF8E / `hsl(var(--brand-default))`)
- **Secondary accent:** Blue-purple (#6044FF / `247.8deg 100% 70%`)
- **Neutral palette:** Gray scale with blue undertones (not pure gray) -- achieves warmth in dark mode
- **No multi-accent per section** (unlike Vercel/Stripe). Green is the consistent singular brand color.

### Theme Switching
- Attribute-based: `[data-theme="dark"]`, `[data-theme="light"]`, `[data-theme="classic-dark"]`
- `classic-dark` variant provides legacy Supabase dark theme with separate token definitions
- System appearance detection: `--helpers-os-appearance: Dark` / `Light`
- Dark is the primary/hero theme; light is supported for docs/auth surfaces

## Typography

### Font Stack

```css
/* Primary Sans */
--font-custom: "custom-font", Circular, "Helvetica Neue", Helvetica, Arial, sans-serif;
--default-font-family: var(--font-custom, Circular, custom-font, Helvetica Neue, Helvetica, Arial, sans-serif);

/* Monospace */
--font-source-code-pro: "Source Code Pro", "Office Code Pro", Menlo, monospace;
--default-mono-font-family: var(--font-source-code-pro, Source Code Pro, Office Code Pro, Menlo, monospace);
```

### Custom Font (Circular)
Self-hosted WOFF2/WOFF with `font-display: swap`:
- **CustomFont-Book** (weight 400) -- body, UI, labels
- **CustomFont-Medium** (weight 500) -- headings, emphasis, buttons
- CDN-hosted at `frontend-assets.supabase.com/www/[hash]/_next/static/media/CustomFont-Book.woff2`

Circular is the same geometric sans-serif used by Stripe, giving Supabase a similar premium-developer aesthetic -- clean, modern, highly legible at small sizes.

### Type Scale

| Token | Usage |
|-------|-------|
| `--text-xs` | Labels, captions, tiny UI |
| `--text-sm` | Body (small), meta, secondary nav |
| `--text-base` | Standard body text |
| `--text-lg` | Large body, intro text |
| `--text-xl` | Subheadings |
| `--text-2xl` | Section headings |
| `--text-3xl` through `--text-8xl` | Hero, display |

Each size token has a paired `--text-{size}--line-height` token.

### Font Weights

| Token | Value |
|-------|-------|
| `--font-weight-light` | 300 |
| `--font-weight-normal` | 400 |
| `--font-weight-medium` | 500 |
| `--font-weight-semibold` | 600 |
| `--font-weight-bold` | 700 |
| `--font-weight-extrabold` | 800 |

### Letter Spacing

| Token | Usage |
|-------|-------|
| `--tracking-tighter` | Tight headings |
| `--tracking-tight` | Headings |
| `--tracking-normal` | Body |
| `--tracking-wide` | Labels, uppercase |
| `--tracking-wider` | Labels (enhanced) |
| `--tracking-widest` | Maximum spread |

### Line Heights

| Token | Value |
|-------|-------|
| `--leading-tight` | 1.25 |
| `--leading-snug` | 1.375 |
| `--leading-normal` | 1.5 |
| `--leading-relaxed` | 1.625 |

### Typography Patterns Observed
- **h1/h2** have `line-height: 1.2 !important` (tight headings)
- **Labels** use monospace font stack with `text-xs`, `tracking-wider`, `uppercase`, `text-foreground-lighter`
- **Prose** headings use `--foreground-default`, body uses `--foreground-light`
- **Links** within prose styled with `--foreground-light`, underline on hover
- **Code in prose:** `font-mono`, `rounded-lg` border, `bg-background-surface-200`, `text-sm`
- **Scroll margin:** `h1-h6:not(.overwrite)` get `scroll-margin-top: 90px` (accounts for sticky nav height)

## Motion Catalog

### Duration Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `--default-transition-duration` | 150ms | Base transitions |
| `--default-transition-timing-function` | `cubic-bezier(.4,0,.2,1)` | Standard ease-out |

Observed durations in classes: `duration-200` (buttons, hover), `duration-300` (nav, overlays), `duration-150` (accordion, micro).

### Easing Functions

| Token | Value |
|-------|-------|
| `--ease-in` | `cubic-bezier(.4,0,1,1)` |
| `--ease-out` | `cubic-bezier(0,0,.2,1)` |
| `--ease-in-out` | `cubic-bezier(.4,0,.2,1)` |

### Keyframe Animations

#### Fade & Scale (Overlays/Dropdowns)
| Animation | Duration | Easing | Details |
|-----------|----------|--------|---------|
| `fadeIn` | 0.3s | both (fill) | opacity 0 -> 1 |
| `fadeOut` | (CSS-driven) | both | opacity 1->0 + scale 1->0.95 |
| `overlayContentShow` | 0.1s | `cubic-bezier(.16,1,.3,1)` | opacity 0->1 + translateY(-2%)->0 |
| `overlayContentHide` | (CSS-driven) | | reverse of show |
| `dropdownFadeIn` | (CSS-driven) | | opacity 0->1 + scale 0.95->1 |
| `dropdownFadeOut` | (CSS-driven) | | reverse of in |
| `fadeInOverlayBg` | (CSS-driven) | both | opacity 0->0.75 |
| `fadeOutOverlayBg` | (CSS-driven) | both | opacity 0.75->0 |
| `fadeInUp` | (CSS-driven) | `cubic-bezier(.25,.25,0,1)` | opacity 0->1 + translateY(10px)->0 |

#### Accordion & Collapsible
| Animation | Details |
|-----------|---------|
| `slideDown` / `slideUp` | Height animation via `--radix-accordion-content-height` |
| `slideDownNormal` / `slideUpNormal` | Generic height animation |
| `accordion-down` / `accordion-up` | Multi-framework support (Radix/Bits/Reka/Kobalte/NGP) |
| `collapsible-down` / `collapsible-up` | Radix collapsible |

#### Panel & Slide
| Animation | Details |
|-----------|---------|
| `panelSlideLeftOut` / `panelSlideLeftIn` | translateX(-100%) <-> 0 with opacity |
| `panelSlideRightOut` / `panelSlideRightIn` | translateX(100%) <-> 0 with opacity |
| `slideIn` | translateY(-100%) -> 0 (nav/notification) |

#### Marquee (Logo Carousels)
| Animation | Details |
|-----------|---------|
| `marquee` | translateX(0) -> translateX(-100%), linear, infinite |
| `marquee-reverse` | translateX(-100%) -> translateX(0), reverse direction |
| `marquee-vertical` | translateY(0) -> translateY(-100%) |

Observed usage: `animate-[marquee_90000ms_linear_both_infinite]` with `motion-reduce:animate-none` for a 90-second marquee.

#### Loading & Progress
| Animation | Details |
|-----------|---------|
| `spinner` / `spin` | rotate(0) -> rotate(1turn), linear infinite |
| `transformSpin` | Named spin variant |
| `pulse` | opacity 1 -> 0.5 (Tailwind default) |
| `loader-dots1` / `loader-dots2` / `loader-dots3` | scale-based dot loading (3 dots, 0.6s) |
| `lineLoading` | Width oscillation (80px -> 240px -> 80px) with margin-left drift |
| `opacity-pulse` | opacity 0.4 <-> 1 |
| `opacity-pulse-full` | opacity 0 <-> 1 |

#### Special Effects
| Animation | Details |
|-----------|---------|
| `pulse-radar` | scale(0) + opacity 0 -> scale(1) + opacity 0.8 -> scale(1) + opacity 0 (echo pulse) |
| `bounce` | translate3D(0,-5px,0) -> translate3D(0,5px,0), alternate, ease-in-out |
| `flash-code` | background-color #3fcf8e (brand green) at 10% opacity -> transparent |
| `caret-blink` | opacity 1 (0-70%, 100%) / opacity 0 (20-50%) for input cursor |
| `AnimationName` | background-position 0% -> 100% for gradient animation (14s auth container) |

#### Tailwind Enter/Exit
```css
@keyframes enter {
  from { opacity: var(--tw-enter-opacity,1); 
         transform: translate3d(...) scale3d(...) rotate(...); 
         filter: blur(var(--tw-enter-blur,0)); }
}
@keyframes exit {
  to { opacity: var(--tw-exit-opacity,1); 
       transform: translate3d(...) scale3d(...) rotate(...); 
       filter: blur(var(--tw-exit-blur,0)); }
}
```

### Animation Principles
1. **CSS-only motion** -- no JavaScript animation libraries on the main marketing site (no Framer Motion, GSAP, etc.)
2. **Single duration discipline** -- 150ms micro, 200ms buttons, 300ms panels
3. **Ease-out default** -- `cubic-bezier(0,0,.2,1)` everywhere
4. **Reduced motion respected** -- `motion-reduce:animate-none` on marquees, `motion-reduce:will-change-none`
5. **GPU-composited transforms** -- `will-change-transform` on animated elements, translate3d for nav
6. **Staggered fade-in** -- `fade-in-2ms` (0.2s) and `fade-in-4ms` (0.4s) utility classes with `opacity: 0; transform: translateY(10px)` starting state
7. **Once-only policy** -- animations fill `both` (forwards), don't repeat on re-mount

## Interaction Patterns

### Buttons
**Base class pattern:**
```
relative justify-center cursor-pointer inline-flex items-center space-x-2 
text-center font-regular ease-out duration-200 rounded-md 
outline-hidden transition-all outline-0 
focus-visible:outline-4 focus-visible:outline-offset-1 
border
```

**Size variants:**
| Size | Height | Text | Padding |
|------|--------|------|---------|
| Tiny | `h-[26px]` | `text-xs` | `px-2.5 py-1` |
| Small | `h-[34px]` | `text-base md:text-sm` | `px-3 py-2` |
| Default | `h-[38px]` | `text-base md:text-sm` | `px-4 py-2` |

**Visual variants:**
| Variant | Background | Border | Text | Hover |
|---------|-----------|--------|------|-------|
| Default/Secondary | `bg-alternative dark:bg-muted` | `border-strong` | `text-foreground` | `bg-selection border-stronger` |
| Brand/Primary | `bg-brand-400 dark:bg-brand-500` | `border-brand-500/75` | `text-foreground` | `bg-brand/80 border-brand-600` |
| Ghost | Transparent | None | `text-foreground-lighter` | `text-foreground` |
| Link | Transparent | None | `text-brand-link` | Underline |

**Focus state:** All buttons share `focus-visible:outline-4 focus-visible:outline-offset-1 focus-visible:outline-brand-600`
**Open state:** `data-[state=open]:bg-selection data-[state=open]:outline-brand-600`

### Links
- **Inline text links:** `text-foreground-lighter hover:text-foreground transition-colors`
- **Brand links:** `text-brand-link hover:underline` (e.g., CTA, footer "More on Security")
- **Footer links:** `text-foreground-lighter hover:text-foreground`
- **Transition:** Duration 150-200ms, `transition-colors` (color only, no transform)

### Inputs
**Base pattern:**
```
flex w-full rounded-md border border-control
bg-foreground/[.026] (extremely subtle fill)
placeholder:text-foreground-muted
focus:ring-background-control focus:border-control
focus-visible:outline-hidden focus-visible:ring-2 focus-visible:ring-background-control
focus-visible:ring-offset-2 focus-visible:ring-offset-foreground-muted
disabled:cursor-not-allowed disabled:text-foreground-muted
```

**States:**
- **Read-only:** `border-button`, `text-foreground-light`
- **Invalid:** `bg-destructive-200`, `border-destructive-400`, `focus:border-destructive`
- **Sizes:** `h-[34px]` default, `h-[26px]` tiny (`text-xs px-2`)

### Navigation Interactions
- **Mega dropdown:** Revealed on hover with `opacity-0 animate-fade-in scale-100!` entrance
- **Mobile menu:** Slide-in panel with `panelSlideLeftOut`/`panelSlideLeftIn` keyframes
- **Active states:** `data-[state=open]` attributes on Radix primitives
- **Scroll-aware nav:** `transition-all duration-300` with changing background opacity

### Form Validation
- **Invalid:** `aria-[invalid=true]:bg-destructive-200 aria-[invalid=true]:border-destructive-400`
- **Focus within invalid:** `has-[[data-slot][aria-invalid=true]]:border-destructive-400`
- **Ring color:** `--tw-ring-color: hsl(var(--destructive-default))` on dark mode invalid

### Hover States
- **Cards/Surfaces:** `hover:bg-surface-200` (subtle lighten)
- **Interactive rows:** `hover:bg-selection`
- **Border elevation:** `hover:border-stronger` (not shadow-based depth)
- **Opacity transitions:** `transition-opacity` with `opacity-70 hover:opacity-100`

### Focus States
- **Focus ring:** `outline-4 outline-offset-1 outline-brand-600` on buttons
- **Input focus:** `ring-2 ring-background-control ring-offset-2`
- **Menu items:** `focus-visible:bg-selection focus-visible:text-foreground`

### Selection
- **Text selection:** `bg-background-selection` (19.2% luminance in dark)
- **Active item:** `bg-selection` utility, `aria-selected:bg-selection`
- **Command palette:** `[aria-selected=true]:bg-selection` for cmdk items

## Spacing System

### Base Scale
- **Base unit:** `--spacing: 0.25rem` (4px)
- All spacing derived from Tailwind v4 spacing scale (0.25rem increments)
- Multiplied via `calc(var(--spacing) * N)` for arbitrary values

### Layout Spacing
| Token | Value | Usage |
|-------|-------|-------|
| `--xxl` | 128px | Extra-large section gaps |
| `--panel2` | 4px | Tight panel padding |
| `--card-padding-x-md` | `--padding-x-md` | Card horizontal padding |
| Hit area expansion | `calc(var(--spacing) * 6 * -1)` | Touch targets |

### Content Widths
| Token | Value |
|-------|-------|
| `--content-width-screen-xl` | 1128px |
| Section max-widths | `max-w-2xl` (hero), `max-w-4xl`, `max-w-5xl`, `max-w-7xl` |

### Vertical Rhythm
- Section padding: `py-16 md:py-24 lg:py-24` (64px -> 96px)
- Component gaps: `gap-4` (16px), `gap-8` (32px), `gap-12` (48px)
- Footer link columns: `gap-x-4 gap-y-12` (16px horizontal, 48px vertical)
- Menu spacing: `space-y-2` (8px), `space-x-5` (20px)
- Button icon gap: `space-x-2` (8px)

## Component Patterns

### 1. Navigation Bar
```
sticky top-0 z-40
  └── bg-background/90 dark:bg-background/95 (blurred translucent)
  └── backdrop-blur-xs
  └── border-b border-default
  └── h-16 (64px)
  └── container lg:px-16 xl:px-20
      ├── Logo (left)
      ├── Desktop nav (center, Radix NavigationMenu, hidden lg:flex)
      │   ├── Dropdown triggers with chevron
      │   └── Mega dropdown panels with links
      └── CTAs (right, Sign In + Start Project buttons)
```

### 2. Hero Section
```
relative mt-[-65px] (pull under nav)
  └── container py-16 md:py-24 overflow-hidden
      └── max-w-2xl mx-auto text-center
          ├── Announcement pill (rounded-full bg-surface-100/300 gradient)
          ├── h1 headline (large display)
          ├── Description text
          ├── CTA buttons (primary brand + secondary)
          └── Logo marquee (animate-marquee, 90s, with edge-fade mask)
```

### 3. Announcement/Badge Component
```
relative w-fit max-w-xl
  └── announcement-overlay
      ├── absolute inset-0 -z-10
      ├── bg-linear-to-br from-background-surface-100 to-background-surface-300
      ├── opacity-70 group-hover/announcement:opacity-100
      ├── rounded-full
      └── backdrop-blur-md
  └── content with arrow icon
```

### 4. Logo Marquee
```
relative mx-auto max-w-4xl
  └── overflow-hidden
  └── before:absolute before:inset-0 before:bg-linear-gradient(to_right, bg-default_0%, transparent_10%, transparent_90%, bg-default_100%)
  └── flex flex-nowrap
      └── [animate-[marquee_90000ms_linear_both_infinite]]
          └── will-change-transform
          └── motion-reduce:animate-none
          └── motion-reduce:will-change-none
          ├── Logo items (h-12 lg:h-12 w-max)
          └── Duplicated set for seamless loop
```

### 5. Feature Cards/Sections
- Grid: `grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8`
- Surface: `bg-surface-100/75` with `rounded-xl` or `rounded-2xl`
- Border: `border border-default` or borderless (shadow alternative not observed)
- Image/illustration: Full-width with rounded top corners
- Content: Padding with heading + description + optional CTA link

### 6. Code Display (Code Hike)
```
ch-codeblock, ch-codegroup, ch-preview
  box-shadow: 0 13px 27px -5px rgba(50,50,93,.25), 
              0 8px 16px -8px rgba(0,0,0,.3), 
              0 -6px 16px -6px rgba(0,0,0,.025)
```
- Triple-layer shadow for depth
- Dark theme code blocks (`--ch-t-background`, etc.)
- Syntax highlighting via CSS custom properties (light/dark adapted)

### 7. Auth UI
- Gradient background: `linear-gradient(270deg, #71fb8e, #acecbc)` with 14s infinite animation
- Card surface with border and shadow
- CSS `@property --rotate` with gradient border effect (spinning conic gradient)

### 8. Footer
```
footer bg-alternative
  ├── Trust bar (SOC2/HIPAA/ISO certs with check icons)
  │   └── grid-cols-2 md:flex justify-between gap-8
  │   └── h-px divider (gradient-to-transparent)
  ├── Main content
  │   └── xl:grid-cols-7
  │       ├── Col 1-2: Logo + social + newsletter form
  │       └── Col 3-7: 6 link columns (2-col grid on mobile)
  └── Bottom bar
      └── border-t border-default pt-8
      └── Copyright + theme toggle
```

### 9. Command Palette (cmdk)
- Overlay with backdrop blur
- Rounded dialog with border
- Search input at top
- Grouped results with `[cmdk-group-heading]` labels
- Selected item: `aria-selected:bg-selection`
- Monospace font for headings

### 10. Charts (Recharts)
- Styled with CSS custom properties
- `recharts-cartesian-grid line` uses `stroke: hsl(var(--border-default))`
- Tooltip cursor uses `hsl(var(--border-default))`
- Custom dot styling with `stroke='#fff'`

## Design Tokens Reference

### Full Token List (Extracted)

**Colors:**
- `--brand-default`, `--brand-200` through `--brand-1200`
- `--warning-default`, `--warning-200` through `--warning-600`
- `--destructive-default`, `--destructive-200` through `--destructive-600`
- `--secondary-default`, `--secondary-400`
- `--foreground-default`, `--foreground-light`, `--foreground-lighter`, `--foreground-muted`, `--foreground-contrast`
- `--background-default`, `--background-200`, `--background-surface-75/100/200/300`, `--background-control`, `--background-selection`, `--background-alternative-default`, `--background-overlay-default`, `--background-muted`, `--background-dash-canvas`
- `--border-default`, `--border-muted`, `--border-strong`, `--border-stronger`, `--border-control`, `--border-overlay`, `--border-secondary`
- `--color-amber-100` through `--color-amber-1200` (13 stops)
- `--color-blue-100` through `--color-blue-1200`
- `--color-crimson-100` through `--color-crimson-1200`
- `--color-gold-100` through `--color-gold-1200`
- `--color-emerald-50`, `--color-emerald-200`-`700`, `--color-emerald-900`, `--color-emerald-950`
- `--color-teal-500`, `--color-cyan-500`
- `--color-neutral-50` through `--color-neutral-900`
- `--color-stone-500`
- `--color-black`, `--color-white`
- Code block colors: `--code-block-1` through `--code-block-5` (HSL values)

**Typography:**
- `--text-xs` through `--text-8xl` (each with `--line-height`)
- `--font-weight-light`, `--font-weight-normal`, `--font-weight-medium`, `--font-weight-semibold`, `--font-weight-bold`, `--font-weight-extrabold`
- `--tracking-tighter`, `--tracking-tight`, `--tracking-normal`, `--tracking-wide`, `--tracking-wider`, `--tracking-widest`
- `--leading-tight` (1.25), `--leading-snug` (1.375), `--leading-normal` (1.5), `--leading-relaxed` (1.625)
- `--font-family-body: Inter`
- `--font-custom`, `--font-source-code-pro`

**Radius:**
- `--radius-xs` (.125rem / 2px)
- `--radius-sm` (.25rem / 4px)
- `--radius-md`, `--radius-lg`, `--radius-xl`, `--radius-2xl`, `--radius-3xl`

**Spacing:**
- `--spacing: .25rem` (4px base)
- `--xxl: 128px`
- `--panel2: 4px`
- `--card-padding-x-md`
- `--input-sm-height: 28px`
- `--datatable-rowheight: 28px`
- `--datatable-headericon: 16px`
- `--options-icon: 18px`

**Layout:**
- `--content-width-screen-xl: 1128px`
- `--breakpoint-lg: 64rem` (1024px)
- `--breakpoint-2xl`
- `--container-xs` through `--container-7xl`

**Effects:**
- `--blur-xs`, `--blur-md`, `--blur-lg`, `--blur-xl`, `--blur-2xl`
- `--perspective-distant: 1200px`
- `--aspect-video: 16/9`
- `--drop-shadow-xs`, `--drop-shadow-md`, `--drop-shadow-lg`

**Animation:**
- `--default-transition-duration: .15s`
- `--default-transition-timing-function: cubic-bezier(.4,0,.2,1)`
- `--ease-in`, `--ease-out`, `--ease-in-out`
- `--animate-spin`, `--animate-pulse`, `--animate-bounce`
- `--animate-accordion-down`, `--animate-accordion-up`
- `--animate-fade-in: fadeIn .3s both`
- `--animate-dropdown-content-show: overlayContentShow .1s cubic-bezier(.16,1,.3,1)`

## Key Takeaways

1. **Border-based depth over shadows.** Supabase uses a multi-tier border system (default/muted/strong/stronger) for visual hierarchy rather than box-shadows. Only code blocks and auth cards use shadows. This creates a clean, flat, developer-tool aesthetic.

2. **Single brand accent discipline.** One green (`#3ECF8E`) for all interactive states, CTAs, and brand moments. No per-section accent rotation. This is laser-focused branding.

3. **HSL semantic token architecture.** Every color is an HSL component (`hsl(var(--token))`), enabling transparent alpha variants via `color-mix(in oklab, ...)` and theme switching by reassigning HSL channels. This is architecturally identical to shadcn/ui's approach.

4. **Dark-first with light as secondary.** The primary experience is dark mode. Light mode exists for docs and auth but the marketing site lives in near-black (`0deg 0% 7.1%`).

5. **CSS-only motion system.** Despite being a modern app, Supabase uses zero JavaScript animation libraries. Every animation is CSS `@keyframes` or Tailwind's built-in transitions. This is a deliberate performance choice.

6. **Radix-Colors-inspired palette.** The 100-1200 stop scale is borrowed from Radix's color system, providing 13 luminosity stops per hue for precise dark/light adaptation.

7. **Circular is the secret weapon.** Using the same typeface as Stripe (Circular by Lineto) gives Supabase an instant premium-developer-tool aesthetic. Self-hosted WOFF2 with `font-display: swap`.

8. **Container padding grows with viewport.** 24px mobile -> 64px desktop -> 80px widescreen. This proportional padding creates breathing room on larger screens.

9. **Tailwind v4 @theme system.** All design tokens are defined as CSS custom properties via Tailwind v4's new `@theme` directive, making them accessible via both utility classes and direct CSS variable access.

10. **Transparent nav with backdrop-blur.** The navigation uses a semi-transparent background (`90%` / `95%` opacity) with `backdrop-filter: blur()` for the frosted glass effect, common in modern SaaS marketing sites.

## Extraction Limitations

- **Single page only** (homepage). Sub-pages like /pricing, /docs, /auth may have different design patterns not captured.
- **No JS analysis.** The 3 JS file budget was preserved. Animation libraries in interactive components (dashboard, auth) were not directly examined.
- **Dynamic content.** React-rendered content (product demos, interactive code blocks) may have additional styling not present in the static HTML.
- **Brand color exact values.** Some HSL values were extracted context-free and may need cross-referencing. The Radix color scales (amber, blue, crimson, gold) reference variables that were not fully resolved.
- **Shadow system.** The full shadow token hierarchy (box-shadow values, not just drop-shadow) was not fully extracted from the minified CSS.
- **Responsive breakpoints.** Only `--breakpoint-lg: 64rem` was confirmed. The full breakpoint scale (sm/md/lg/xl/2xl) was inferred from Tailwind defaults.
- **Component variants.** Only button, input, and nav variants were fully analyzed. Other components (modals, tables, tabs, etc.) were identified from CSS but not structurally documented.
- **Classic-dark theme.** The `[data-theme=classic-dark]` theme has its own complete token set that was partially captured.
