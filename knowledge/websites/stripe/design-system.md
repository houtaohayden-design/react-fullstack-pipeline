# Stripe Design System — Complete Extraction

> **Source**: https://stripe.com (extracted 2026-05-18)
> **Design Framework**: Harmony Design System (HDS) — Stripe's internal design token system
> **Stack**: Next.js SSR, CSS custom properties (`--hds-*`), Sohne Variable font, CSS layers (reset/base/app)

---

## 1. Color System

Stripe's color system is built on a semantic token architecture with 3 tiers: **core** (raw palette) -> **util** (generic aliases) -> **semantic** (context-aware). All tokens live under `--hds-color-*`.

### 1.1 Brand Core Palette

| Token | Hex | Usage |
|-------|-----|-------|
| `--hds-color-core-brand-25` | `#f5f5ff` | Subtle brand background |
| `--hds-color-core-brand-50` | `#e8e9ff` | Brand background quiet |
| `--hds-color-core-brand-75` | `#e2e4ff` | Brand background subdued |
| `--hds-color-core-brand-100` | `#d6d9fc` | Brand border quiet |
| `--hds-color-core-brand-200` | `#b9b9f9` | Brand border subdued |
| `--hds-color-core-brand-300` | `#9a9afe` | Brand icon subdued |
| `--hds-color-core-brand-400` | `#7f7dfc` | Brand gradient start, icon |
| `--hds-color-core-brand-500` | `#665efd` | Brand text soft |
| `--hds-color-core-brand-600` | `#533afd` | **Primary brand / action color** |
| `--hds-color-core-brand-700` | `#4032c8` | Brand hover / emphasized |
| `--hds-color-core-brand-800` | `#2e2b8c` | Brand max emphasis |
| `--hds-color-core-brand-900` | `#1c1e54` | Brand deepest |
| `--hds-color-core-brand-925` | `#1c1e54` | Brand darkest surface |
| `--hds-color-core-brand-950` | `#161741` | Brand near-black |
| `--hds-color-core-brand-975` | `#0f1137` | Brand black |

**Signature gradient**: `#7f7dfc` (400) -> `#9a9afe` (300) -> `#4032c8` (700)

### 1.2 Neutral Core Palette (Gray-Blue)

Stripe uses a distinctive gray-blue neutral palette (not pure gray) that gives the UI warmth.

| Token | Hex | Usage |
|-------|-----|-------|
| `--hds-color-core-neutral-0` | `#fff` | White surface |
| `--hds-color-core-neutral-25` | `#f8fafd` | Default page background |
| `--hds-color-core-neutral-50` | `#e5edf5` | Border quiet, surface subdued |
| `--hds-color-core-neutral-100` | `#d4dee9` | Border subdued |
| `--hds-color-core-neutral-200` | `#bac8da` | Icon surface |
| `--hds-color-core-neutral-300` | `#95a4ba` | Text inactive |
| `--hds-color-core-neutral-400` | `#7d8ba4` | Text quiet |
| `--hds-color-core-neutral-500` | `#64748d` | **Text subdued (body default)** |
| `--hds-color-core-neutral-600` | `#50617a` | Text soft |
| `--hds-color-core-neutral-700` | `#3c4f69` | Icon solid dark |
| `--hds-color-core-neutral-800` | `#273951` | Icon solid |
| `--hds-color-core-neutral-900` | `#1a2c44` | Heading dark |
| `--hds-color-core-neutral-950` | `#11273e` | Near-black |
| `--hds-color-core-neutral-975` | `#0d253d` | Deeper black |
| `--hds-color-core-neutral-990` | `#061b31` | **Text solid (heading default)** |

### 1.3 Dark Mode Variants

Brand dark and neutral dark palettes exist (`--hds-color-core-brandDark-*`, `--hds-color-core-neutralDark-*`) with shifted values for dark backgrounds.

### 1.4 Accent Color Modes

Each accent has a full "color mode" with gradient, solid, and subdued surface tokens:

| Mode | Gradient End | Gradient Middle | Gradient Start | Solid |
|------|-------------|-----------------|----------------|-------|
| **Lemon** | `#ff9014` | `#ffaf2d` | `#ffd552` | `#e8a30b` |
| **Magenta** | `#b262f9` | `#f96bee` | `#f98bf9` | `#f44bcc` |
| **Orange** | `#fd5d7c` | `#fd6252` | `#fe8c2d` | `#ff6118` |
| **Ruby** | `brand-600` | `brand-400` | `#fd7184` | `#ea2261` |

### 1.5 Semantic Color Architecture

```
Core (raw palette values)
  -> Util (generic aliases: util-brand-600, util-neutral-500)
    -> Semantic (context-aware: action-bg-solid, text-soft, button-primary-bg)
```

**Action colors** (primary interactive):
- `action-bg-solid`: `#533afd` (brand-600)
- `action-bg-solidHover`: `#4032c8` (brand-700)
- `action-text-solid`: `#533afd`
- `action-border-solid`: `#533afd`

**Button color scheme**:
| Variant | Background | Text/Border |
|---------|-----------|-------------|
| Primary | `#533afd` | `#fff` |
| Primary Hover | `#4032c8` | `#fff` |
| Secondary | transparent | border `#d6d9fc`, text `#533afd` |
| Secondary Hover | transparent | border `#4032c8`, text `#4032c8` |
| UI (quiet) | `#e8e9ff` | icon `#533afd` |
| UI Hover | `#d6d9fc` | icon `#2e2b8c` |
| UI on Subdued | `#e2e4ff` | icon `#533afd` |
| Translucent | `rgba(255,255,255,0.65)` | text `#533afd` |

**Text color scale** (4-stop):
| Stop | Token | Hex | Use |
|------|-------|-----|-----|
| Solid | `text-solid` | `#061b31` | Headings, primary text |
| Soft | `text-soft` | `#50617a` | Navigation links, secondary |
| Subdued | `text-subdued` | `#64748d` | Body text, descriptions |
| Quiet | `text-quiet` | `#7d8ba4` | Placeholders, meta |

### 1.6 Background Surfaces

| Token | Value | Use |
|-------|-------|-----|
| `surface-bg-quiet` | `#fff` | Cards, elevated surfaces |
| `surface-bg-subdued` | `#f8fafd` | Page background, sections |
| `surface-border-quiet` | `#e5edf5` | Card borders, dividers |

### 1.7 Semantic Color System

| Token | Value | Use |
|-------|-------|-----|
| Error 400 | `#f3432a` | Error icon |
| Error 500 | `#d8351e` | Error text |
| Error 600 | `#a01400` | Error dark |
| Success 400 | `#00b261` | Success icon |
| Success 600 | `#006f3a` | Success dark |

---

## 2. Typography

### 2.1 Font Families

| Role | Font Stack | Format |
|------|-----------|--------|
| **Primary (variable)** | `"sohne-var", "Helvetica Neue", Arial, sans-serif` | woff2-variations (weight axis 1-1000) |
| **Code** | `"SourceCodePro", "SFMono-Regular", monospace` | woff2 (weight 500) |

Font loading strategy: `font-display: block` for desktop (>=600px), `font-display: swap` for mobile. Preloaded in `<head>` with `crossorigin="anonymous"`.

### 2.2 Heading Type Scale (Desktop >=940px)

| Token | Size | Line Height | Weight | Letter Spacing |
|-------|------|-------------|--------|----------------|
| `heading-xxs` | `0.875rem` | 1.2 | 400 | 0 |
| `heading-xs` | `1rem` | 1.2 | 400 | 0 |
| `heading-sm` | `1.375rem` | 1.1 | 300 | -0.01em |
| `heading-md` | `1.625rem` | 1.12 | 300 | -0.01em |
| `heading-lg` | `2rem` | 1.1 | 300 | -0.02em |
| `heading-xl` | `3rem` | 1.03 | 300 | -0.02em |
| `heading-xxl` | `3.5rem` | 1.03 | 300 | -0.025em |

### 2.3 Hero Heading Scale (Desktop >=940px)

| Token | Size | Line Height | Weight | Letter Spacing |
|-------|------|-------------|--------|----------------|
| `hero-sm` | `2rem` | 1.1 | 300 | -0.02em |
| `hero-md` | `2.25rem` | 1.05 | 300 | -0.02em |
| `hero-lg` | `2.5rem` | 1.2 | 300 | -0.02em |

**Hero title is actually responsive via language-specific fluid sizing** using `--lang-font-*` variables:
```css
font-size: max(min(var(--lang-font-flex), var(--lang-font-max)), var(--lang-font-min));
```
Hero titles use `mix-blend-mode: hard-light` and a `<span>` overlay technique with `color: rgba(0,14,255,0.5)` for gradient text effect.

### 2.4 Body Text Scale (Desktop >=940px)

| Token | Size | Line Height | Weight | Letter Spacing |
|-------|------|-------------|--------|----------------|
| `text-xxs` | `0.75rem` | 1.45 | 300 | 0 |
| `text-xs` | `0.875rem` | 1.4 | 300 | 0 |
| `text-sm` | `0.875rem` | 1.4 | 300 | 0 |
| `text-md` | `1rem` | 1.4 | 300 | 0 |
| `text-lg` | `1.125rem` | 1.4 | 300 | 0 |
| `text-xl` | `1.25rem` | 1.4 | 300 | -0.01em |
| `text-xxl` | `3rem` | 1 | 300 | -0.02em |

### 2.5 Quote Style

| Token | Size | Line Height | Weight |
|-------|------|-------------|--------|
| `quote-md` | `1.625rem` | 1.12 | 300 |
| `quoteAttribution-md` | `1.125rem` | 1.4 | 300 |

### 2.6 Input Typography

| Token | Size | Use |
|-------|------|-----|
| `input-label-sm` | `0.75rem` | Small labels |
| `input-label-md` | `0.875rem` | Medium labels |
| `input-label-lg` | `1rem` | Large labels |
| `input-text-sm` | `0.75rem` | Small input text |
| `input-text-md` | `0.875rem` | Medium input text |
| `input-text-lg` | `1rem` | Large input text |
| `input-description` | `0.875rem` | Help text |
| `input-groupHeading` | `0.75rem` | Field group titles |

### 2.7 Font Weights

Stripe uses Sohne Variable with a weight axis from 1-1000. CSS tokens:
- `--hds-font-weight-normal`: `300` (most text)
- `--hds-font-weight-bold`: variable (400-600 depending on context)
- Eyebrows use weight `400` (via `font-variation-settings: "wght" 400`)
- Japanese locale overrides to `font-weight: 600` for links and labels

### 2.8 Typography Key Principles

- **Light weight everywhere**: 300 is the default for body, headings, and even hero text. This creates Stripe's signature airy, elegant feel.
- **Tight line heights on headings**: 1.03-1.12, making large text feel compact and premium.
- **Negative letter spacing**: Hero and large headings use -0.02em to -0.025em for a tightened, refined look.
- **Tabular numbers**: `.tabular-nums` class enables `font-feature-settings: "tnum"` for monospaced numerals in data displays.
- **Superscript**: `<sup>` uses `font-feature-settings: "sups" 1` for proper superscript glyphs.

---

## 3. Spacing System

### 3.1 Core Space Scale (4px base grid)

Stripe uses a numeric scale where each unit represents approximately 0.04px (25="1px" at 4px grid). The actual pixel values from computed styles:

| Token | Approx Pixels | Use |
|-------|--------------|-----|
| `space-core-25` | 1px | Hairline borders, tiny gaps |
| `space-core-50` | 2px | Tight icon gaps |
| `space-core-75` | 3px | Nav padding vertical |
| `space-core-100` | 4px | Button gap, tight padding |
| `space-core-150` | 6px | Link list gaps |
| `space-core-200` | 8px | Standard gap, content padding |
| `space-core-250` | 10px | Button horizontal padding |
| `space-core-300` | 12px | Content section padding |
| `space-core-400` | 16px | Section gap, stat padding |
| `space-core-500` | 20px | Section title padding |
| `space-core-600` | 24px | Large section gap |
| `space-core-700` | 28px | Dialog padding block start |
| `space-core-800` | 32px | Section gap bottom/top (mobile) |
| `space-core-900` | 36px | Hero top padding |
| `space-core-1200` | 48px | Section gap (desktop) |
| `space-core-1400` | 56px | Nav scroll-margin (mobile) |
| `space-core-1500` | 60px | Nav scroll-margin |
| `space-core-1600` | 64px | Nav scroll-margin (tablet) |
| `space-core-1900` | 76px | Nav scroll-margin (desktop) |
| `space-core-2100` | 84px | Nav subsection scroll-margin |

### 3.2 Layout Tokens

| Token | Value | Use |
|-------|-------|-----|
| `space-layout-columns` | `8` (mobile) / `12` (desktop) | Grid columns |
| `space-layout-gap` | `8px` | Column gap |
| `space-layout-content-margin` | `8px` | Content inset |
| `space-layout-page-margin` | `8px` | Page edge margin |
| `space-layout-content-maxWidth` | (computed) | Max content width |

### 3.3 Button Spacing

| Token | Value |
|-------|-------|
| `button-padding-block-start` | `15.5px` |
| `button-padding-block-end` | `16.5px` |
| `button-border-width` | `1px` |
| `button-height` | `44px` (mobile) / `48px` (desktop) |
| `button-radius-lg` | 4px (maps to `radius-sm`) |

Navigation CTA buttons: `padding-top: 11.5-12.5px`, `padding-bottom: 12.5-14.5px`, horizontal `10px`.

### 3.4 Border Radius

| Token | Value |
|-------|-------|
| `radius-xs` | `2px` |
| `radius-sm` | `4px` |
| `radius-md` | `6px` |
| `radius-lg` | `16px` |
| `radius-xl` | `32px` |
| `radius-none` | `0px` |
| `radius-round` | `99999px` |

---

## 4. Shadow System

Stripe uses a unique **dual-layer shadow system** — every elevation has two box-shadows: a "top" shadow (diffuse, higher blur) and a "bottom" shadow (tighter, sharper). All shadows use a blue tint (`#003770` / `#003B89`) rather than black, contributing to the premium brand feel.

### 4.1 Shadow Tokens

| Token | Top Shadow | Bottom Shadow | Use |
|-------|-----------|---------------|-----|
| **xs** | `0 2px 10px 0 rgba(0,55,112,.06)` | `0 1px 4px 0 rgba(0,59,137,.04)` | Subtle cards |
| **sm** | `0 5px 14px 0 rgba(0,55,112,.08)` | `0 2px 8px 0 rgba(0,59,137,.05)` | Light elevation |
| **md** | `0 6px 22px 0 rgba(0,55,112,.1)` | `0 4px 8px 0 rgba(0,59,137,.02)` | Standard cards, nav dropdown |
| **lg** | `0 15px 40px -2px rgba(0,55,112,.1)` | `0 5px 20px -2px rgba(0,59,137,.04)` | Elevated modals |
| **xl** | `0 20px 80px -16px rgba(0,55,112,.14)` | `0 10px 60px -16px rgba(0,59,137,.06)` | Maximum elevation |

### 4.2 Shadow Color Tokens

| Token | Color | Opacity |
|-------|-------|---------|
| `shadow-xs-top` | `#003770` | 6% |
| `shadow-xs-bottom` | `#003B89` | 4% |
| `shadow-sm-top` | `#003770` | 8% |
| `shadow-sm-bottom` | `#003B89` | 5% |
| `shadow-md-top` | `#003770` | 10% |
| `shadow-md-bottom` | `#003B89` | 2% |
| `shadow-lg-top` | `#003770` | 10% |
| `shadow-lg-bottom` | `#003B89` | 4% |
| `shadow-xl-top` | `#003770` | 14% |
| `shadow-xl-bottom` | `#003B89` | 6% |

### 4.3 Additional Shadows

| Token | Value | Use |
|-------|-------|-----|
| `--hds-canary-ui-shadow` | `0px 16px 32px rgba(50,50,93,.12)` | UI component shadow |
| Nav dropdown shadow | `0 30px 60px -50px rgba(0,0,0,.1), 0 30px 60px -10px rgba(50,50,93,.25)` | Mega menu |
| Card graphic shadow | `0 30px 45px -30px rgba(50,50,93,.25), 0 18px 36px -18px rgba(0,0,0,.1)` | Product graphics |
| Agentic card shadow | `0 4px 48.8px -30px rgba(50,50,93,.12), 0 18px 36px -18px rgba(0,0,0,.1)` | Bento cards |
| Heavy card shadow | `0 42.043px 84.087px 0 rgba(26,26,26,.08), 0 12.613px 29.43px 0 rgba(26,26,26,.08), 0 4.204px 12.613px 0 rgba(26,26,26,.12)` | Elevated cards |
| Crypto card shadow | `0 27.478px 41.217px 0 rgba(50,50,93,.12), 0 16.487px 32.973px 0 rgba(0,0,0,.07)` | Crypto product cards |
| Book of the Week shadow | `0 32.239px -14.806px rgba(50,50,93,.25), 0 4.776px 19.343px -9.672px rgba(0,0,0,.1)` | Featured content card |

---

## 5. Gradient & Background Effects

### 5.1 Stats Section Time-of-Day Gradient Animation

The stats section features a stunning animated background that cycles through 6 gradient states representing different times of day. Each is a large radial gradient positioned at the bottom center.

**Pre-Dawn** (blue-purple):
```css
radial-gradient(102.84% 104.98% at 50% 102.63%, #486ffd 0%, #7f81f3 9.84%, #c489ff 20.83%, #dac0ff 34.13%, #eadcff 44.86%, #f9f6ff 58.59%, #f8fafd 100%)
```

**Sunrise** (pink-orange-gold):
```css
radial-gradient(102.68% 99.11% at 50% 104.6%, #cb83ff 0%, #ff90b9 15.77%, #ffc977 30.62%, #ffd79b 38.04%, #fff1dc 50.11%, #fff 63.1%, #fcfdfe 77.95%, #f8fafd 98.81%)
```

**Daytime** (sky blue):
```css
radial-gradient(102.84% 104.98% at 50% 104.98%, #0071c1 1.33%, #60a8e2 15.71%, #b4d8ff 33.15%, #d9ebff 45%, #f8fafd 60%)
```

**Dusk** (warm gold-blue transition):
```css
radial-gradient(102.83% 103.24% at 49.98% 104.51%, #ffb451 0%, #efc680 16.73%, #b4d8ff 33.03%, #d2e8ff 43.38%, #fafdff 59.16%, #fdfeff 76.24%, #f8fafd 100%)
```

**Sunset** (orange-pink-purple):
```css
radial-gradient(103.12% 100% at 50% 100%, #ffa577 0%, #ff90a1 15.52%, #ddadff 30.09%, #ecd8ff 45.72%, #f5eaff 54.96%, #f8fafd 88.16%)
```

**Night** (deep indigo — the default active state on desktop):
```css
radial-gradient(102.82% 106.44% at 50% 106.44%, #fcfdfe 1.11%, #6763e4 28.73%, #453bb3 45.76%, #29227d 63.37%, #1e2064 78.67%, #141e4b 100%)
```

The gradient transitions use `opacity` cross-fade with a configurable `--stats-section-transition-duration` and custom timing function.

### 5.2 Hero Section Gradient Text

The hero title uses a **dual-layer blend mode approach**:
- Background layer: text with `color: #81b81a` (green) / `#ddd600` (yellow) — varies by language
- Foreground layer: `mix-blend-mode: hard-light` with `color: rgba(0,14,255,.5)` (blue)
- Result: A dynamic gradient text that shifts based on the background

### 5.3 Suite Accent Gradients (Navigation)

Each product suite section in the nav mega menu has a colored gradient underline indicator:
```css
.suite-title:after {
  background: linear-gradient(90deg,
    var(--gradient-color) 0%,
    var(--gradient-color) 20%,
    var(--stop-color) 40%,
    var(--suite-color) 60%,
    var(--suite-color) 100%
  );
}
```

Suite colors:
| Suite | Accent Color | Stop Color | Gradient |
|-------|-------------|------------|----------|
| Payments | `#ff6118` (orange) | `#fb76fa` | `#533afd` |
| Billing | `#fc5` (gold) | `#fb76fa` | `#533afd` |
| Connect | `#f44bcc` (magenta) | `#ec8fff` | `#533afd` |
| Issuing | `#ea2261` (ruby) | `#da56ed` | `#533afd` |

The gradient has an animated reveal: `background-size: 0 100%` -> `background-size: 100% 100%` on hover with `0.3s ease-out`.

### 5.4 Program Card Gradients

Startups program cards use `linear-gradient(288.31deg, #0d1738 -6.87%, #4032c8 105.95%)` — a dark navy-to-brand-purple diagonal gradient for card backgrounds.

---

## 6. Motion & Animation

### 6.1 Navigation Hover Arrow

The `navigation-hover-arrow` uses two keyframes:
```css
@keyframes nav-hover-arrow-in {
  0%   { opacity: 0; transform: translateX(-3px); }
  100% { opacity: 1; transform: translateX(0); }
}
@keyframes nav-hover-arrow-out {
  0%   { opacity: 1; }
  100% { opacity: 0; }
}
```
- In: `0.3s` with stagger (visibility delay removed on hover)
- Out: `0.15s` with `0.3s` visibility delay
- Timing: `cubic-bezier(.25, 1, .5, 1)` (smooth deceleration)

### 6.2 Bento Dialog Reveal

Card content reveals use fade-up:
```css
@keyframes bento-dialog-reveal-fade-in-up {
  0%   { opacity: 0; transform: translate3d(0, 30px, 0); }
  100% { opacity: 1; transform: translate3d(0, 0, 0); }
}
```

### 6.3 Border Spin (Agentic Commerce)

Continuous rotation for card border:
```css
@keyframes agentic-commerce-graphic-border-spin {
  0%   { transform: translate(-50%, -50%) rotate(0deg); }
  100% { transform: translate(-50%, -50%) rotate(360deg); }
}
```

### 6.4 Book of the Week Fade-In

```css
@keyframes book-of-the-week-fade-in {
  0%   { opacity: 0; }
  100% { opacity: 1; }
}
```
Duration: `0.5s`, timing: `cubic-bezier(.33, 1, .68, 1)` (smooth ease-in-out)

### 6.5 Background Opacity Animation

```css
@keyframes opacityAnimation {
  0% { background-color: rgba(229, 237, 245, 0); }
  /* fades to solid */
}
```

### 6.6 Scroll Detection Animation

Uses the modern **scroll-driven animation** API:
```css
@keyframes detect-scroll {
  0%, 100% { --can-scroll: ; }
}
.navigation-menu {
  animation: detect-scroll linear;
  animation-timeline: scroll(inline self);
}
```
This CSS-only approach detects if content is scrollable without JavaScript.

### 6.7 Motion Principles

- **Subtle, purposeful motion**: Animations serve clarity, not decoration
- **Fade + directional movement**: Most reveals combine opacity with translateY/translateX
- **Cubic-bezier timing functions**: Custom curves for natural feel
- **Reduced motion**: `@media (prefers-reduced-motion: no-preference)` guards all animations
- **Duration scale**: Quick (150ms for micro-interactions), Normal (300ms for reveals), Slow (500ms for page elements)
- **Stagger via transition-delay**: Used for sequential element reveals

### 6.8 Transition Patterns

| Element | Property | Duration | Timing |
|---------|----------|----------|--------|
| Nav menu appearance | opacity, visibility | 300ms | ease |
| Nav dropdown background | opacity | 200ms | ease |
| Suite gradient underline | background-size | 300ms | ease-out |
| Button colors | color, background, border | navigation-duration | navigation-easing |
| Sign-in mask | opacity | navigation-duration | navigation-easing |
| Stats gradient | opacity | configurable | configurable |
| Card hover scale | transform | — | — |
| Locale switcher | opacity, transform | 150ms | ease |

---

## 7. Navigation System

### 7.1 Top Navigation Bar

**States**:
1. **Default (at top)**: Transparent background, white/light text
2. **Scrolled**: White background with `box-shadow: var(--hds-shadow-md)`, dark text
3. **Menu open**: White background, dark text

**Structure**:
```
.navigation__layout
  ├── .navigation-menu (flex row)
  │   ├── Home logo link
  │   ├── Navigation buttons (Products, Solutions, Developers, Resources, Pricing)
  │   ├── Guide Me link (with sparkle icon)
  │   ├── Contact Sales button
  │   ├── Sign in button (with mask animation)
  │   └── Hamburger button (mobile only)
  └── .navigation-menu__background (absolute overlay)
```

### 7.2 Sign-In Button Mask Effect

The Sign In button uses a clever mask technique:
- **Default**: Transparent background, border colored white/light
- **On scroll/hover**: White background with brand text color
- The `.navigation-item__sign-in__mask` element covers the button with opacity 0, transitioning to 1 to show the "Sign in" text with proper coloring
- `.navigation-button-measure`: Invisible measuring element for accurate width calculation
- Transition properties: color, background-color, border-color with navigation-* timing variables

### 7.3 Mega Menu

**Products dropdown** (4 columns + sidebar):
```
.navigation__content--products
  ├── section (Payments) — 4 links
  ├── section (Billing) — 4 links
  ├── section (Connect) — 4 links
  ├── section (Issuing) — 4 links
  └── aside (sidebar)
      ├── Navigation links
      └── Sessions banner (promotional card)
```

**Solutions/Developers/Resources dropdowns**: 3-4 column grids with equal sections.

Each section:
- Border-left separators between columns
- Suite titles with gradient underline animating on hover (background-size animation)
- Links with `navigation-hover-arrow` SVG on hover
- `margin-block-start: 16px` between sections

### 7.4 Mobile Menu

- Hamburger button: 40x40px with 4-line SVG
  - Lines 1 & 4 fade out on open
  - Line 2 rotates 45deg
  - Line 3 rotates -45deg
  - Transition duration: `--navigation-hamburger-duration`
- Full-height mobile drawer with white background
- Back button with chevron-left for sub-menus
- Footer: Sticky bottom bar with gradient overlay (`radial-gradient + hsla`) and CTA buttons
- Sign-in appears inline (not separate button)

### 7.5 Navigation Visual Details

- **Chevron indicators**: Two-part chevron (`__left` at 44% 53%, `__right` at 64% 53%) rotating -90deg/90deg to indicate dropdown
- **Dashed separators**: `border-bottom: 1px dashed #e5edf5` between mobile nav items
- **Background**: Nav menu background uses `border-radius: var(--navigation-border-radius)` with `box-shadow: 0 30px 60px -50px rgba(0,0,0,.1), 0 30px 60px -10px rgba(50,50,93,.25)`
- **Borders**: Layout uses pseudo-elements for 1px side borders on the mega menu container
- **Z-index layers**: Navigation `z-index: 2`, background `z-index: -1`

### 7.6 Home Logo Transition

The Stripe logo path fills transition with `var(--navigation-duration)` timing:
- Default: white fill (on transparent nav)
- Scrolled/open: dark fill

---

## 8. Hero Section

### 8.1 Layout Structure

```
.hero-section-container
  └── .hero-section__layout (CSS grid, centered)
      ├── .hero-section__fullbleed-line (border-bottom at bottom)
      ├── .hero-section__eyebrow (label + value)
      │   ├── .hero-section__eyebrow-label (bold, "Available now")
      │   └── .hero-section__eyebrow-value (animated value with gradient mask)
      ├── .hero-section__title (fluid responsive)
      │   ├── .hero-section__title-main (primary text)
      │   └── .hero-section__title--foreground (blend-mode overlay)
      └── .hero-section__actions (CTA buttons)
          ├── Start now (primary)
          └── Contact sales (secondary)
```

### 8.2 Hero Metrics

- **Min height**: `min(68svh, 826px)` — uses small viewport height for mobile browsers
- **Padding top**: `36px` (mobile) / calculated via section container
- **Padding bottom**: `44px`
- **Background**: Full-bleed gradient/illustration positioned behind the nav (`inset: calc(-1 * var(--navigation-height)) 0 0 0`)

### 8.3 Eyebrow Animation

The eyebrow value has:
- **Gradient mask**: `linear-gradient(180deg, #000, #fff 20%, #fff 80%, #000)` — edges fade, center is clear
- **Animated content**: Incoming/outgoing `<span>` elements with absolute positioning that translate vertically
- **Min width**: `12ch` to prevent layout shift
- **Color**: `#061b31` (desktop) / `#64748d` (mobile)

### 8.4 Hero Title Blend Mode

The hero title achieves its gradient look through CSS:
```css
/* Background layer */
.hero-section__title { color: #81b81a; } /* green tint - varies by language */

/* Foreground overlay layer */
.hero-section__title--foreground {
  mix-blend-mode: hard-light;
  color: rgba(0, 14, 255, 0.5); /* blue tint overlay */
}

/* The actual text in foreground */
.hero-section__title--foreground .hero-section__title-main {
  color: #2d2564; /* dark indigo */
}
```

This creates a duotone/gradient text effect without actual CSS gradients — the blend mode mixes the green background text with the blue foreground overlay.

### 8.5 CTA Buttons

- **Primary ("Start now")**: Solid brand-600 background, white text, right arrow icon
- **Secondary ("Contact sales")**: Translucent background (`rgba(255,255,255,0.65)`) / secondary-on-quiet border
- **Google CTA button**: Special variant with `background-color: var(--hds-color-action-bg-translucent)` and Google SVG icon translated 1px up for optical alignment

### 8.6 Responsive Behavior

- Mobile: Full width, stacked layout, smaller title
- Desktop (>=940px): Grid column 2 to -2 (leaving 1 column margin on each side)
- Title `max-width` varies by language: 32ch (Latin), 35ch (some), 42ch (others)

---

## 9. Layout Patterns

### 9.1 General Layout Structure

Stripe.com uses a section-based layout with consistent container patterns:

```css
.section-container {
  /* Uses --hds-space-layout-* tokens */
  padding-inline: var(--hds-space-layout-content-margin);
  max-width: var(--hds-space-layout-content-maxWidth);
}
```

**Breakpoints**:
- Mobile: < 640px (8-column grid)
- Tablet: 640px-939px
- Desktop: >= 940px (12-column grid)
- Wide: >= 1300px

### 9.2 Section Patterns

**Alternating Feature Sections** (features + UI screenshots):
- Content: `.feature-detail__content` with stacked text
- Image: `.feature-detail__image` with product UI graphic
- Footer: Optional `.feature-detail__footer` for links

Each product has dedicated graphic components:
- `payments-graphic` — payment form UI
- `billing-plan-graphic` — plan picker with bars
- `connect-graphic` — platform dashboard
- `platform-graphic` — 3D platform render
- `tax-graphic` — tax calculation card
- `invoicing-graphic` — invoice template
- `terminal-graphic` — POS terminal card
- Multiple crypto graphics (payment form, wallets, issuing)

### 9.3 Stats Section

```
.stats-section__container
  ├── .stats-section__border (full-width top border)
  ├── .stats-section__border-inline-graphic
  ├── .stats-menu (horizontal stat selector)
  │   └── .stats-menu__stat (individual stat pill)
  ├── .stats-list (animated stat values)
  │   └── .stats-list__stat
  ├── .stats-animation-gradient (time-of-day gradient background)
  │   └── .stats-animation-gradient__gradient (6 variants, opacity fade)
  ├── .stats-section__globe (3D globe visualization)
  └── .stats-section__active-indicator (top/bottom position markers)
```

### 9.4 Customer Logo Wall

```
.customer-stories
  └── .carousel__section-container
      ├── .customer-stories__customer (grid of logo cells)
      │   ├── .customer-stories__customer-image (logo SVG)
      │   └── .customer-stories__customer-content (expandable detail)
      └── .customer-stories__customer-data (statistics)
```

### 9.5 Case Study Carousel

```
.case-study-carousel
  └── .carousel__scroller
      └── .carousel__inner
          └── .case-study-card (per card)
              ├── .case-study-card__media (image)
              │   └── .case-study-card__mediaLogo (company logo)
              └── .case-study-card__logo
```

### 9.6 Modular Solutions Bento Grid

```
.modular-solutions-bento__layout
  └── .modular-solutions-bento__card-* (individual feature cards)
      ├── Payments
      ├── Billing
      ├── Connect
      ├── Issuing
      ├── Crypto
      └── Agentic Commerce
```

Each card has a `:hover` state variant (e.g., `.modular-solutions-bento__card-payments--hover`).

### 9.7 Testimonial Carousel

```
.testimonial-carousel-container
  ├── .testimonial-carousel__navigation
  │   ├── .testimonial-carousel__navigation-customers (customer selector)
  │   │   └── .testimonial-carousel__navigation-customers-inner
  │   ├── .testimonial-carousel__navigation-divider
  │   └── .testimonial-carousel__navigation-selection (active indicator bar)
  └── .testimonial-carousel__cards
      └── .testimonial-card
          ├── .testimonial-card__quote
          └── .testimonial-card__author
              └── .testimonial-card__author-role
```

### 9.8 Footer CTA Section

```
.footer-cta-section__grid
  ├── .section-title
  └── .footer-cta-section__content
      ├── .feature-detail (content block)
      │   ├── .feature-detail__content--stacked
      │   └── .feature-detail__image
      └── .footer-cta-section__content-text
```

Has `border-block-end: var(--hds-canary-dashed-border)` — a dashed separator.

### 9.9 Book of the Week Section

```
.book-of-the-week
  ├── .book-of-the-week__image-container
  │   └── .book-of-the-week__picture (.book-of-the-week__image-placeholder)
  ├── .book-of-the-week__content
  │   ├── .book-of-the-week__icon
  │   ├── .book-of-the-week__text
  │   └── .book-of-the-week__author-block
  └── .book-of-the-week__button-container
```

### 9.10 Events Carousel

```
.events-section-container
  ├── .events-section__header
  │   └── .events-section__header-content
  ├── .events-section__controls (carousel nav arrows)
  └── .events-mobile-carousel
      └── .events-mobile-carousel-card
          ├── .events-mobile-carousel-card__media (image)
          └── .events-mobile-carousel-card__title
```

---

## 10. Component Patterns

### 10.1 Button Variants

Based on extracted token structure:

| Variant | CSS Module | Background | Border | Text/Icon |
|---------|-----------|------------|--------|-----------|
| **Primary** | `.hds-button--primary` | `#533afd` | none | `#fff` |
| **Primary Hover** | `:hover` | `#4032c8` | none | `#fff` |
| **Secondary** | `.hds-button--secondary` | transparent | `#d6d9fc` | `#533afd` |
| **Secondary Hover** | `:hover` | transparent | `#4032c8` | `#4032c8` |
| **Secondary on Quiet** | `.hds-button--secondary-on-quiet` | transparent | subdued border | `#533afd` |
| **UI (Quiet)** | `.hds-button--ui` | `#e8e9ff` | none | `#533afd` |
| **UI Hover** | `:hover` | `#d6d9fc` | none | `#2e2b8c` |
| **UI on Subdued** | `.hds-button--ui-on-subdued` | `#e2e4ff` | none | `#533afd` |
| **Translucent** | `.hds-button--translucent` | `rgba(255,255,255,.65)` | none | `#533afd` |
| **Transparent** | `.hds-button--transparent` | transparent | none | `#533afd` |

**Size tokens**:
- Default: `padding: 15.5px 10px 16.5px`, height `48px`
- CTA: `padding: 12.5px 10px 13.5px`, height `44px`
- Border radius: `4px` (maps to `--hds-space-core-radius-sm`)
- Border width: `1px`

**Focus state**: Uses a dual-ring approach with `--hds-color-action-focus-outer` (`#533afd`) and inner colors based on background.

### 10.2 Icon

`.hds-icon` with `hds-icon-hover-arrow` variant:
- Arrow SVG: `<path d="M0.5 5.5h7"/><path d="M1.5 1.5l4 4-4 4"/>`
- Size: 10x10
- Stroke: currentColor, stroke-width: 2
- Animated on hover via `navigation-hover-arrow`

### 10.3 Link

`.hds-link`:
- `display: inline-flex`
- `gap: 2px`
- Color transitions on hover
- In navigation: flex-direction column for product links
- `text-wrap: balance` for product descriptions
- Japanese locale: font-weight 600 override

### 10.4 Card (Case Study)

`.case-study-card`:
- `aspect-ratio: 336/350` (mobile)
- `border-radius: 6px`
- `background-color: #fff`
- `.case-study-card__media`: relative positioned, holds image
- `.case-study-card__mediaLogo`: overlaid company logo
- `.case-study-card__link`: fake-link for clickable card area

### 10.5 Glass/Surface Cards

Cards throughout the site use:
- White background (`#fff`)
- Border: `1px solid #e5edf5` (border-quiet)
- Border-radius: 6px
- Shadow: varies by context (sm for cards, md for elevated, lg for modals)

### 10.6 Testimonial Card

`.testimonial-card`:
- `.testimonial-card__quote`: Large quote text (1.625rem / weight 300)
- `.testimonial-card__author`: Author name
- `.testimonial-card__author-role`: Author role/title

### 10.7 Carousel Navigation

```css
.carousel__scroller {
  /* Horizontal scroll container */
}
.carousel__inner {
  /* Flex row of items */
}
.carousel-nav {
  /* Arrow navigation buttons */
}
```

Mobile carousel: `.mobile-carousel` with `.mobile-carousel__scroller` and `.mobile-carousel__item`

### 10.8 Stats Menu

Horizontal pill selector with:
- `.stats-menu__stat`: Individual stat pill
- `.stats-menu__stat--active`: Active state highlighting
- Stats transition between different metrics with smooth animations

### 10.9 Program Cards (Startups)

`.startups-program-card`:
- `.startups-program-card__inner`: Content container
- `.startups-program-card__border`: Outer border element
- `.startups-program-card__border-color`: Colored border overlay
- `.startups-program-card__border-color-gradient`: Gradient border
- `.startups-program-card__content`: Inner content
- `.startups-program-card__graphic`: SVG/illustration
- `.startups-program-card__text`: Text content

### 10.10 Modular Bento Cards

Complex multi-card layout with per-product hover states:
- `.modular-solutions-bento__card-{product}`: Individual card
- `.modular-solutions-bento__card-{product}--hover`: Hover state variant
- `.modular-solutions-bento__content`: Card content
- `.modular-solutions-bento-card__text`: Card description

### 10.11 Graphic Components (Product UI Demos)

Each product has a custom-built UI graphic that looks like a tiny embedded app:

| Graphic | Key Elements |
|---------|-------------|
| `billing-plan-graphic` | Plan grid, usage bars, cadence indicators |
| `payments-graphic` | Payment form with card fields |
| `connect-graphic` | Dashboard with payout info |
| `tax-graphic` | Tax calculation card with line items |
| `invoicing-graphic` | Invoice preview with line items |
| `terminal-graphic` | POS terminal with card chip |
| `platform-graphic` | 3D platform illustration |
| `agentic-commerce-*` | Multi-step commerce flow graphics |
| `crypto-*` | Crypto payment forms, wallets, issuing |
| `developer-systems-animation` | Pipeline/architecture animation |

These graphics use realistic app UI conventions (small font sizes like 10px, 12px, 13px; box shadows; borders; realistic form fields and buttons).

### 10.12 Sessions Banner (Promotional)

`.sessions-banner`:
- Container query: `container-type: inline-size`
- Card layout with image + content
- `border-radius: 4px`
- `border: 1px solid #e5edf5`
- Responsive: stacks on small containers, side-by-side at >=400px
- Image: `height: 80px`, `object-fit: cover`

### 10.13 Columns Utility

`.columns`:
- `columns--auto`: Auto-fit grid
- `columns-row-gap`: With row gap
- Used throughout for grid layouts

---

## 11. Developer-Focused Design Elements

### 11.1 Code Font Integration

- **Monospace font**: `SourceCodePro` weight 500 specifically loaded for code display
- Stack: `"SourceCodePro", "SFMono-Regular", monospace`
- Used in: API reference sections, code snippets, terminal-style graphics

### 11.2 Terminal/CLI Styling

Stripe embeds developer-authentic elements:
- Monospace typography in marketing context
- Code snippet styling with proper syntax coloring
- API-key-inspired visual patterns
- Request/response mockups in product graphics

### 11.3 Technical Diagram Styling

The `developer-systems-animation` component shows:
- Pipeline app nodes (`40px` square)
- App logos on cards
- Border color transitions (`0.5s cubic-bezier(.4, 0, .2, 1)`)
- System connectivity visualization

### 11.4 Tabular Numbers

`.tabular-nums` and `.tabular-nums--tight`:
- `font-feature-settings: "tnum"`
- `font-variant-numeric: tabular-nums`
- `.tabular-nums--tight` adds `letter-spacing: -0.03em`
- Used on: pricing tables, stat values, data displays

### 11.5 Data Display Patterns

Stats and metrics use:
- Large numbers with tight letter spacing
- Tabular numbers for alignment
- Gradient color transitions for changing values
- Animated counters with smooth transitions

---

## 12. Form & Input Design

### 12.1 Input Color System

| State | Background | Border | Text |
|-------|-----------|--------|------|
| **Default** | `rgba(255,255,255,.25)` | `rgba(212,222,233,.75)` | `#273951` |
| **Hover** | `#f5f5ff` | default | `#273951` |
| **Focus** | `rgba(255,255,255,.5)` | `rgba(212,222,233,.75)` | `#273951` |
| **Disabled** | `#e8e9ff` | `#d4dee9` | inactive |
| **Error** | default | `#d8351e` | `#d8351e` |
| **Selected** | `rgba(172,172,255,.12)` | `#7f7dfc` | `#533afd` |
| **Accent** | `#533afd` | `#533afd` | white |

### 12.2 Select/Listbox

- Popover: white background, `240px` width, `border-radius: 6px`
- Divider: `rgba(212,222,233,.75)`
- Selected item: `background: rgba(172,172,255,.12)`, text: `#533afd`
- Hover item: `background: #d6d9fc`, text: `#4032c8`

### 12.3 Input Typography

| Element | Size | Weight | Line Height |
|---------|------|--------|-------------|
| Small label | 0.75rem | 400 | 1.35 |
| Medium label | 0.875rem | 400 | 1.3 |
| Large label | 1rem | 400 | 1.2 |
| Small text | 0.75rem | 300 | 1.35 |
| Medium text | 0.875rem | 300 | 1.3 |
| Large text | 1rem | 300 | 1 (single) / 1.4 (textarea) |

### 12.4 Input Sizing

- `minHeight`: matches `button-height` (44px mobile / 48px desktop)
- Layered input gap: `24px`
- Layered input max width: `360px`
- Layered input min width: `300px`
- Label max width: `196px`
- Label min width: `120px`

---

## 13. Product Graphics Design Language

Stripe's product UI graphics share a consistent mini-app aesthetic:

### 13.1 Common Graphic Tokens

- **Mini stroke**: `--hds-canary-ui-mini-stroke: #e5edf5`
- **Main stroke**: `--hds-canary-ui-stroke: color-mix(in srgb, #e5edf5 50%, transparent)`
- **Shadow**: `--hds-canary-ui-shadow: 0px 16px 32px rgba(50,50,93,.12)`
- **Border radius**: `6px` (standard), `4px` for inner elements

### 13.2 Graphic Card Pattern

Each product graphic card typically has:
- White background (`#fff`)
- Border: `1px solid` using stroke colors
- Shadow for depth
- Inner elements with realistic app styling
- Small text (10-13px) mimicking real UI
- Semantic color coding for states

### 13.3 Example: Billing Plan Graphic

- `.billing-plan-graphic__plan-grid`: Grid of plan cards
- `.billing-plan-graphic__plan-item`: Individual plan with background gradients
- `.billing-plan-graphic__chart`: Usage visualization with bars
- `.billing-plan-graphic__usage-bar`: Progress bars with brand colors
- Background gradient layers (4 gradient backgrounds for depth)

### 13.4 Example: Crypto Payment Form

- `.crypto-payment-form-graphic__payment-methods-panel`: Methods list
- `.crypto-payment-form-graphic__payment-methods-item`: Each method row
- `.crypto-payment-form-graphic__button--link`: Green accent button (`#00d66f`)

---

## 14. Accessibility Patterns

### 14.1 Screen Reader Only

```css
.sr-only {
  position: absolute;
  width: 1px; height: 1px;
  padding: 0; margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
```

### 14.2 Focus Management

- Dual-ring focus indicators with outer accent + inner surface color
- `--hds-color-action-focus-outer: #533afd`
- `--hds-color-action-focus-inner-quiet: #fff`
- `--hds-color-action-focus-inner-subdued: #f8fafd`
- `--hds-color-action-focus-surface: transparent`

### 14.3 Reduced Motion

All animations are guarded with `@media (prefers-reduced-motion: no-preference)`.

### 14.4 Anchor Offsets

Scroll-margin-top offsets for navigation section anchors, matching the sticky nav height at each breakpoint.

### 14.5 Semantic HTML

- Navigation uses `<nav aria-label="Main navigation">`
- Sections use proper heading hierarchy
- Carousel has navigation controls
- ARIA-expanded on hamburger and dropdown triggers

---

## 15. Performance Patterns

### 15.1 Font Loading

- Preloaded WOFF2 fonts in `<head>` with `crossorigin="anonymous"`
- `font-display: block` for desktop (prevents FOUT for variable font)
- `font-display: swap` for mobile (prioritizes text visibility)

### 15.2 Resource Hints

- Preconnect to analytics (`q.stripe.com`, `r.stripe.com`)
- Preconnect to image CDN (`images.stripeassets.com`, `assets.stripeassets.com`)
- DNS prefetch for external resources

### 15.3 CSS Architecture

- CSS `@layer reset, base, app` for cascade management
- Isolation: `#__next, #root { isolation: isolate }` for stacking context control
- Content-visibility patterns on off-screen sections

### 15.4 Image Loading

- Explicit `width` and `height` attributes
- `object-fit: cover` for graphic images
- Responsive images with `srcset` via Next.js Image component
- Background images with `fetchpriority="high"` for hero

---

## 16. CSS Architecture

### 16.1 Layer System

```css
@layer reset, base, app;
```

### 16.2 Design Token Namespace

All design tokens use the `--hds-` prefix (Harmony Design System):
- `--hds-color-*`: Color tokens
- `--hds-font-*`: Typography tokens
- `--hds-space-*`: Spacing & layout tokens
- `--hds-shadow-*`: Shadow tokens
- `--hds-canary-*`: Experimental/canary features

### 16.3 Component Naming

BEM-inspired naming with section-specific prefixes:
- `hero-section__*`
- `navigation__*`
- `stats-section__*`
- `testimonial-card__*`
- `case-study-*`
- `{product}-graphic__*`

### 16.4 Responsive Approach

Desktop-first with mobile overrides:
```css
:root { /* Mobile defaults */ }
@media (min-width: 640px) { /* Tablet */ }
@media (min-width: 940px) { /* Desktop */ }
@media (min-width: 1300px) { /* Wide */ }
```

### 16.5 Container Queries

Used for component-level responsiveness:
```css
.sessions-banner {
  container-type: inline-size;
  container-name: sessions-banner;
}
@container sessions-banner (min-width: 400px) { ... }
```

### 16.6 Color Mix

Modern CSS `color-mix()` for semi-transparent tokens:
```css
--hds-canary-ui-stroke: color-mix(in srgb, var(--hds-color-util-neutral-50) 50%, transparent);
```

### 16.7 Scroll-Driven Animations

CSS-only scroll detection using animation-timeline:
```css
@keyframes detect-scroll {
  0%, 100% { --can-scroll: ; }
}
.navigation-menu {
  animation: detect-scroll linear;
  animation-timeline: scroll(inline self);
}
```

---

## 17. Design Principles Summary

### Stripe's Design DNA

1. **Developer credibility meets premium brand**: Code snippets in marketing, API-inspired design elements, monospace fonts integrated naturally

2. **Light weight typography as signature**: Weight 300 everywhere creates airiness and elegance; tight line heights on headings create premium feel

3. **Brand purple as the only accent**: `#533afd` is the single dominant action color — everything interactive uses it, creating strong brand recognition

4. **Blue-tinted shadows instead of black**: All shadows use `rgba(0, 55, 112, ...)` and `rgba(0, 59, 137, ...)` — never pure black

5. **Dual-layer shadow system**: Two box-shadows per elevation level for realistic, premium depth

6. **Gray-blue neutral palette**: Neutrals have a blue cast (`#f8fafd`, `#e5edf5`, `#d4dee9`) rather than pure gray, keeping the UI warm

7. **Purposeful, subtle animation**: Motion clarifies interactions; no gratuitous effects. Cubic-bezier curves for smoothness.

8. **Product UI as marketing**: Miniature product UIs (dashboards, payment forms, invoices) serve as feature illustrations

9. **Gradient accents for segmentation**: Each product suite gets its own gradient color (orange/pink/yellow) for navigation differentiation

10. **Time-of-day gradient storytelling**: The stats section's gradient cycle tells a global story (pre-dawn through night)

11. **Blend modes for text effects**: Hero titles use `mix-blend-mode: hard-light` for duotone text effects without JS

12. **4px base grid with explicit spacing**: Systematic spacing with named tokens (not magic numbers)

13. **BEM-inspired component naming**: Clear parent-child-sibling relationships in class names

14. **Responsive typography**: Fluid type scales that adapt across breakpoints while maintaining harmony

15. **Modern CSS features**: Container queries, scroll-driven animations, CSS layers, `color-mix()`, variable fonts — Stripe uses cutting-edge CSS

---

## 18. Quick Reference: Key Tokens

### Colors
```css
--brand-primary:    #533afd;  /* --hds-color-core-brand-600 */
--brand-hover:      #4032c8;  /* --hds-color-core-brand-700 */
--brand-light:      #e8e9ff;  /* --hds-color-core-brand-50 */
--text-primary:     #061b31;  /* --hds-color-core-neutral-990 */
--text-body:        #64748d;  /* --hds-color-core-neutral-500 */
--bg-page:          #f8fafd;  /* --hds-color-core-neutral-25 */
--bg-surface:       #ffffff;  /* --hds-color-core-neutral-0 */
--border-default:   #e5edf5;  /* --hds-color-core-neutral-50 */
```

### Typography
```css
--font-primary:     "sohne-var", "Helvetica Neue", Arial, sans-serif;
--font-code:        "SourceCodePro", "SFMono-Regular", monospace;
--heading-xl:       3rem / 1.03 / 300 / -0.02em;
--heading-lg:       2rem / 1.1 / 300 / -0.02em;
--body-md:          1rem / 1.4 / 300;
```

### Shadows
```css
--shadow-sm:  0 5px 14px 0 rgba(0,55,112,.08), 0 2px 8px 0 rgba(0,59,137,.05);
--shadow-md:  0 6px 22px 0 rgba(0,55,112,.1), 0 4px 8px 0 rgba(0,59,137,.02);
--shadow-lg:  0 15px 40px -2px rgba(0,55,112,.1), 0 5px 20px -2px rgba(0,59,137,.04);
```

### Radius
```css
--radius-sm: 4px;   /* buttons, inputs */
--radius-md: 6px;   /* cards, dialogs */
```

---

*Extracted from live stripe.com CSS and HTML on 2026-05-18. Based on Stripe's Harmony Design System (HDS) design token architecture. All values verified from production CSS custom properties.*
