# Hermès Design System

> Extracted from `https://www.hermes.com/us/en/` on 2026-05-18
> Stack: Angular 20.3.15 + SSR + Custom Component Library (`h-` prefix)
> CSS framework: normalize-scss + Custom CSS Custom Properties

---

## 1. Overview

Hermès operates one of the most disciplined luxury e-commerce websites. The design system reflects the brand's 187-year heritage: **restrained opulence, editorial sophistication, and impeccable craft**. Key architectural characteristics:

- **Angular 20.3.15** with server-side rendering (SSR)
- **Custom component library** with `h-` prefix (50+ components)
- **Three-tier typography system** (EB Garamond editorial + Overpass Mono labels + Manrope UI)
- **Single brand accent** (Hermès orange #fc6) used sparingly
- **Warm neutral palette** (cream/beige/taupe) as foundation
- **Minimal animation** (CSS-only, fade + rotate, reduced-motion aware)
- **Angular CDK** for overlays/modals/trays
- **Accessibility-first**: skip links, ARIA roles, keyboard navigation, sr-only text
- **Multi-lang**: English, Korean, Simplified Chinese, Traditional Chinese with per-locale typography overrides

---

## 2. Layout System

### Core Grid

| Property | Value |
|----------|-------|
| Content max-width | `1258px` (adaptive), `1290px` (main container) |
| Full-width max | `1920px` |
| Mobile margin | `15px` (adaptive), `4px` (fixed) |
| Desktop margin | `calc(100% - 48px)` center with `1258px` cap (adaptive), `24px` (fixed) |
| Header height (mobile) | `50px` |
| Header height (desktop) | `64px` |
| Header height (with menu) | `110px` |
| Menu bar height | `46px` |

### Layout Classes

- `.layout-with-margin-adaptative` — responsive margins, centered, max 1258px
- `.layout-with-margin-fixe` — fixed 4px mobile / 24px desktop
- `.layout-with-margin-full` — full-width, max 1920px, centered

### Breakpoints

| Name | Value | Usage |
|------|-------|-------|
| Mobile | `< 1024px` (`max-width: 1023px`) | Primary mobile/desktop split |
| Desktop | `>= 1024px` (`min-width: 1024px`) | Desktop layout, nav changes |
| Image 320-414 | `min-width: 320px and max-width: 414px` | Small mobile images |
| Image 415-767 | `min-width: 415px and max-width: 767px` | Large mobile images |
| Image 768-1024 | `min-width: 768px and max-width: 1024px` | Tablet images |
| Image 1025-1280 | `min-width: 1025px and max-width: 1280px` | Small desktop images |
| Image 1281-1920 | `min-width: 1281px and max-width: 1920px` | Desktop images |
| Image 1921+ | `min-width: 1921px` | Large/retina desktop images |

**Image CDN**: Scene7/Adobe Experience Manager (`assets.hermes.com/is/image/hermesedito/`), responsive `srcset` with `wid` parameter.

### Structure

```
h-root
  h-shell
    h-notification-modal
    h-header
      h-header-links (skip links: Go to main content, product browsing, accessibility)
      h-header-bar
        h-logo (SVG logo + SEO img fallback)
        h-header-search-bar (form with autocomplete)
        nav: account + cart
      h-menu-bar (horizontal category nav: Women, Men, etc.)
    h-main-content
    h-footer-deprecated (columns, social, newsletter, copyright)
  h-tray-container (slide-out trays)
  h-tray-overlay
  h-overlay (modals)
```

---

## 3. Color System

### Brand Colors

| Token | Hex | Role |
|-------|-----|------|
| Hermès Orange | `#fc6` | Primary accent, interactive states |
| Hermès Red | `#9d2a1e` | Sale/urgency accent |

### Surface & Background

| Token | Hex | Role |
|-------|-----|------|
| Warm White | `#fcf7f1` | Primary background (cream-tinted) |
| Warm Beige | `#f6f1eb` | Secondary background, notification overlay |
| Light Grey | `#f5f5f5` | Tertiary background |
| Pure White | `#fff` / `#FFFFFF` | Card surfaces, tray, modal |
| Warm Taupe | `#D0C2B0` | Decorative elements, borders |
| Warm Light Grey | `#DDD3C6` | Subtle surface variation |

### Text Colors

| Token | Hex | Role |
|-------|-----|------|
| Pure Black | `#000` | Primary text, links, buttons |
| Dark Warm Grey | `#2e2d2d` | Secondary text |
| Dark Blue-Grey | `#2b333f` | Tertiary text, loading bar |
| Medium Grey | `#444` / `#444444` | Muted text, loading bar color |
| Dim Grey | `#696969` | Tray overlay, disabled states |
| Light Grey | `#888` | Placeholder text |
| Grey | `#919191` | Secondary muted |
| Light Silver | `#cbcbcb` | Borders, dividers |

### UI Accent Colors

| Token | Hex | Role |
|-------|-----|------|
| Soft Blue | `#66a8cc` | Links, informational |
| Muted Blue-Grey | `#73859f` | Secondary interactive |
| Dark Charcoal | `#323232` | Alternative dark elements |

### Overlay Opacities (Black)

| Hex | Opacity | Role |
|-----|---------|------|
| `#0003` | ~1% | Subtle shadow |
| `#0009` | ~3.5% | Light overlay |
| `#000c` | ~5% | Medium overlay |
| `#0000004d` | 30% | Dark overlay, backdrop |
| `#00000052` | 32% | CDK dark backdrop |
| `#00000080` | 50% | Strong overlay |
| `#000000b3` | 70% | Heavy overlay |
| `#000000e6` | 90% | Near-opaque overlay |

### Overlay Opacities (White)

| Hex | Opacity | Role |
|-----|---------|------|
| `#fff0` | 0% | Transparent (transition start) |
| `#fff3` | ~1% | Minimal white tint |
| `#fffc` | ~5% | Light white tint |
| `#ffffffe6` | 90% | Modal overlay (warm) |

### Color Philosophy

1. **Orange is sacred**: `#fc6` appears only in meaningful interactive moments
2. **Warm, not sterile**: Cream/beige base (`#fcf7f1`) rather than pure white
3. **Black text on warm white**: High contrast without harshness
4. **Taupe as neutral**: `#D0C2B0` replaces generic grey for warmth
5. **Transparency-based depth**: Overlays use `rgba(0,0,0,X)` not hex greys

---

## 4. Typography System

### Font Stack (Three-Tier)

| Tier | Font | Role | Weight Range | Format |
|------|------|------|-------------|--------|
| 1. Editorial | **EB Garamond** Variable | Brand headlines, editorial, quotes | 400-800 + italic | woff2-variations |
| 2. Secondary | **Overpass Mono** Variable | Navigation labels, headings, UI labels | 300-700 | woff2-variations |
| 3. Primary | **Manrope** Variable | Body text, paragraphs, UI elements | 200-800 | woff2-variations |

All fonts use `font-display: swap` for performance.

### Registered (But Unused) Custom Fonts

The CSS declares but does not actively load these brand typefaces — likely reserved for campaigns:
- `Filosofia` (serif)
- `Akkurat` (serif)
- `Jungle-Regular` (serif)
- `BridesdeGala-Regular` (serif)

### Font Size Scale (rem-based, root 16px)

| Token | rem | px | Usage |
|-------|-----|-----|-------|
| `--font-size-heading-xxl` | 2.125rem | 34px | Hero editorial title |
| `--font-size-heading-xl` | 1.875rem | 30px | Section title |
| `--font-size-heading-l` | 1.625rem | 26px | Large heading |
| `--font-size-heading-m` | 1.5rem | 24px | Medium heading |
| `--font-size-heading-default` | 1.375rem | 22px | Default heading |
| `--font-size-heading-s` | 1.25rem | 20px | Small heading |
| `--font-size-heading-xs` | 1.125rem | 18px | Extra small heading |
| `--font-size-body-xl` | 1rem | 16px | Large body, edito text |
| `--font-size-body-l` | 0.875rem | 14px | Medium body, paragraph-medium |
| `--font-size-body-m` | 0.75rem | 12px | Small body, paragraph-small |
| `--font-size-body-default` | 0.6875rem | 11px | Default body, labels |
| `--font-size-body-s` | 0.625rem | 10px | Menu nav labels, fine print |
| `--font-size-body-xs` | 0.5rem | 8px | Tiny text |

### Typography Classes

#### Editorial (EB Garamond, italic by default)

| Class | Size | Weight | Style | Line Height |
|-------|------|--------|-------|-------------|
| `.edito-1` | heading-xxl | 500 | italic | normal |
| `.edito-2` | heading-xl | 500 | italic | normal |
| `.edito-subtitle` | heading-s | 400 | italic | normal |
| `.edito-text` | body-xl | 400 | normal | 38px |

#### Headings (Overpass Mono, uppercase)

| Class | Size | Weight | Line Height |
|-------|------|--------|-------------|
| `.heading-1` | heading-m | 300 | 34px |
| `.heading-2` | heading-s | 300 | 28px |
| `.heading-3` | body-xl | 300 | 24px |
| `.heading-4` | body-l | 300 | 22px |
| `.heading-5` | body-m | 300 | 18px |

#### Headlines (Manrope, sentence case)

| Class | Size | Weight | Line Height |
|-------|------|--------|-------------|
| `.headline-1` | heading-m | 400 | 34px |
| `.headline-3` | body-xl | 400 | 24px |

#### Paragraphs (Manrope)

| Class | Size | Weight | Line Height |
|-------|------|--------|-------------|
| `.paragraph-medium` | body-l | 400 | 22px |
| `.paragraph-small` | body-m | 400 | 20px |
| `.paragraph-xsmall` | body-default | 400 | 18px |

#### Labels (Overpass Mono, uppercase)

| Class | Size | Weight | Letter Spacing |
|-------|------|--------|----------------|
| `.label-menu-nav` | body-s (10px) | 700 | 1px |
| `.label-medium` | body-m (12px) | 500 | 0 |
| `.label-small` | body-s (10px) | 500 | 0 |

### Font Weight Tokens

`--font-weight-100` through `--font-weight-800` (100-step increments)

### Locale-Specific Overrides

**Korean** (`:root[lang^=ko]`):
- Editorial font: `Arial unicode MS, Overpass Mono, Gill Sans, Gill Sans MT, Calibri, serif`
- Smaller heading scale (xxl: 1.875rem, xl: 1.75rem, l: 1.375rem)

**Simplified Chinese** (`:root[lang^=zh-Hans]`):
- Editorial font: `PingFang SC, 苹方, Noto Sans, Microsoft YaHei, 微软雅黑, SimHei, 黑体, Manrope, Roboto, sans-serif`
- Custom size scale (xxl: 2rem, xl: 2rem)

**Traditional Chinese** (`:root[lang^=zh-Hant]`):
- Editorial font: `Overpass Mono, Gill Sans MT, calibri, sans-serif`
- Custom size scale (xxl: 2rem, sizes vary)

### Typography Philosophy

1. **EB Garamond = brand voice** (editorial, aspirational, luxury)
2. **Overpass Mono = structure** (navigation, labels, system voice)
3. **Manrope = readability** (body text, accessible, modern grotesk)
4. **Uppercase discipline**: Only Overpass Mono labels use uppercase (1px letter-spacing for menu nav)
5. **Italic = editorial marker**: EB Garamond italic distinguishes brand voice from UI
6. **Variable fonts**: All three families are variable, enabling precise weight tuning without multiple file downloads

---

## 5. Motion Catalog

### CSS Keyframes

```css
@keyframes fade-in {
  0% { opacity: 0; }
  /* ... fades to 1 */
}

@keyframes rotative-animation {
  0% { transform: rotate(0); }
  /* ... rotates (loader) */
}
```

### Transition Patterns

| Element | Property | Duration | Easing |
|---------|----------|----------|--------|
| CDK overlay backdrop | opacity | 0.4s | `cubic-bezier(.25, .8, .25, 1)` |
| CDK transparent backdrop | visibility, opacity | 1ms | linear |
| Tray/dialog enter | opacity, transform | 0ms | `cubic-bezier(0, 0, .2, 1)` |

### Angular Animation Triggers

- `logoAnimation` — header logo appears (opacity)
- `animateContainer` — container expand/collapse (opacity + height)
- `animateSuggestions` — search suggestions slide in (opacity + translateX 5%)

### Reduced Motion

```css
@media (prefers-reduced-motion) {
  .cdk-overlay-backdrop {
    transition-duration: 1ms; /* effectively instant */
  }
}
```

### Motion Philosophy

1. **Restrained**: No elaborate page transitions, no scroll-triggered reveals, no parallax
2. **Functional**: Motion serves purpose — loader spin, fade-in for content appear, tray slide
3. **Fast**: 0.4s max for overlay transitions, 0ms for tray enter (near-instant)
4. **Accessible**: Full `prefers-reduced-motion` support
5. **CSS-only**: No JavaScript animation libraries detected (no GSAP, Framer Motion, etc.)

---

## 6. Interaction Patterns

### Header Navigation

- **Transparent header** at page top, becomes opaque on scroll
- **Sticky header** with `position: fixed; top: var(--scroll-y)`
- **Loading bar**: `ngx-loading-bar` with `#444444` color, fixed position
- **Skip links**: Three skip-to links (main content, product browsing, accessibility)

### Mega Menu

- **Trigger**: Hover on category buttons (Women, Men, etc.)
- **Structure**: Editorial image card (left) + category link lists (right)
- **Images**: Responsive `srcset` from Scene7 CDN with 6 breakpoint widths
- **Image overlay**: Title caption on editorial images
- **Category height**: `--category-max-height: 294px`, `--category-min-height: 42px`

### Search

- **Inline search bar** in header (not a separate page)
- **Combobox pattern**: `role="combobox"`, `aria-haspopup="listbox"`, `aria-expanded`
- **Autocomplete suggestions**: Dropdown with `animateContainer` + `animateSuggestions` triggers
- **Icons**: Search icon (open), close icon (clear), SVG sprite system

### Tray System (Slide-out Panels)

- **Width**: 100% mobile, 94% max 510px (31.875rem) desktop
- **Position**: Fixed, right side (`.tray-wrapper-right`)
- **Background**: White (`#fff`)
- **Overlay**: `#696969` at z-index 1900
- **Tray**: z-index 2000
- **Content padding**: `0 1.5rem 1.5rem` (with no-padding variants)
- **Title**: Sticky header within tray (`position: sticky; top: 0`)
- **Scroll**: Independent scroll within tray (`overflow-y: auto`, `min-height: 100dvh`)

### Modal / Overlay

- **Light overlay**: `#ffffffe6` (warm white, 90% opacity), z-index 2002
- **Dark overlay**: `#0000004d` (30% black), class `.black-overlay`
- **Opaque notification**: `#f6f1eb` (warm beige)
- **Loader**: 200px (12.5rem) square, background image
- **CDK dark backdrop**: `#00000052`

### Cart

- **Button**: SVG cart icon + "Cart" label + sr-only status text
- **Empty state**: sr-only "empty"
- **Tray**: Cart opens in slide-out tray

### Account

- **Button**: SVG person icon + "Account" label
- **Offline state**: sr-only indicator
- **Login redirect**: `/us/en/login/`

### Buttons

- **Base**: border-0, border-radius-0, padding-0, background transparent, cursor pointer, color `#000`
- **Variants**: `.button-icon`, `.button-not-black` (for non-black icon buttons)
- **Icon labels**: Icon + text label pattern (`.icon-label`)
- **Focus**: Keyboard navigation outline `2px solid #000`, `:focus-visible` pattern

### Forms

- **Inputs**: Inherit `font-family: var(--font-primary)`
- **Checkboxes**: Absolute positioning (custom styled, visually hidden native input)
- **Focus**: All focusable elements get `outline: 2px solid #000` under `.keyboard-navigation`
- **Normal focus**: `outline: none` (custom focus ring only on keyboard nav)

### Keyboard Navigation

```css
h-root.keyboard-navigation a:focus,
h-root.keyboard-navigation button:focus,
h-root.keyboard-navigation input:focus,
h-root.keyboard-navigation [tabindex="0"]:focus {
  outline: 2px solid #000;
}
```

Toggled via `.keyboard-navigation` class on root (mouse users get no visible focus ring, keyboard users get thick black outline).

### Accessibility Features

1. **Skip links**: Three target links (main content, product browsing, accessibility page)
2. **ARIA landmarks**: `role="banner"`, `role="navigation"`, `role="combobox"`, `role="listbox"`
3. **Screen reader text**: `.sr-only` class throughout (logo description, cart status, account status, offline indicator)
4. **Aria attributes**: `aria-label`, `aria-haspopup`, `aria-expanded`, `aria-controls`, `aria-hidden`
5. **Keyboard nav**: Distinct focus ring only on keyboard interaction
6. **Reduced motion**: Full `prefers-reduced-motion` support
7. **Forced colors**: `@media (forced-colors: active)` support
8. **External accessibility site**: `http://accessibility.hermes.com/us/en/`

---

## 7. Spacing & Sizing

### Layout Spacing

| Context | Value |
|---------|-------|
| Adaptive margin (mobile) | `0 15px` |
| Adaptive margin (desktop) | `0 auto`, width `calc(100% - 48px)`, max `1258px` |
| Fixed margin (mobile) | `0 4px` |
| Fixed margin (desktop) | `0 24px` |
| Tray content padding | `0 1.5rem 1.5rem` |
| Tray desktop width | `94%`, max `31.875rem` (510px) |

### Component Dimensions

| Component | Value |
|-----------|-------|
| Header height (mobile) | `--header-height-mobile: 50px` |
| Header height (desktop) | `--header-height-desktop: 64px` |
| Header height (with menu) | `--header-height-desktop-with-menu: 110px` |
| Menu bar height | `--header-menu-height: 46px` |
| Menu top offset | `--header-menu-top: 58px` |
| Loader size | `12.5rem` (200px) square |
| Category menu max height | `--category-max-height: 294px` |
| Category menu min height | `--category-min-height: 42px` |

### Border Radius

| Value | Usage |
|-------|-------|
| `0` | All buttons, inputs, cards (default) |
| `50%` | Circular elements (likely radio buttons/avatars) |

**Key insight**: Hermès uses **zero border-radius** almost everywhere — a deliberate sharp, architectural aesthetic that contrasts with the common rounded-corners trend in luxury UI.

---

## 8. Component Patterns

### Component Library (h-* prefix, 50+ components)

#### Navigation
- `h-header` — Full header container with scroll-aware transparency
- `h-header-bar` — Top bar: logo, search, account, cart
- `h-header-links` — Skip links for accessibility
- `h-header-search-bar` — Inline search with autocomplete
- `h-header-search-suggestions` — Search dropdown results
- `h-menu-bar` — Horizontal category navigation
- `h-menu-parent-category` — Top-level category (Women, Men, etc.)
- `h-menu-sub-category` — Dropdown menu panels
- `h-menu-bar-edito` — Editorial image cards in mega menu
- `h-menu-bar-link` — Simple menu link

#### Layout
- `h-root` — Application root (Angular bootstrap)
- `h-shell` — Shell layout wrapper
- `h-main-content` — Main content area
- `h-home-page` — Homepage-specific layout
- `h-positioned-under-header` — Content offset helper

#### Media
- `h-media-picture` — Responsive picture element with 6-breakpoint srcset
- `h-media-picture-cta` — Picture with link wrapper
- `h-media-cta` — Media with call-to-action
- `h-block-media` — Media block in editorial layouts
- `h-video` — Video component
- `h-image-resizer` — Responsive image sizing

#### Content Blocks
- `h-block-text` — Rich text block
- `h-block-category` — Category block
- `h-block-merchandising` — Merchandising/product block
- `h-block-text-on-full-media` — Text overlay on full-bleed media
- `h-story-blocks-container` — Storytelling block container
- `h-editorial-cta` — Editorial call-to-action

#### Product
- `h-product-card` — Product card
- `h-price` — Price display
- `h-call-to-action` — CTA button
- `h-cta-link-container` — CTA with link wrapper

#### Overlays
- `h-tray-container` — Slide-out tray (cart, mobile menu)
- `h-tray-overlay` — Tray backdrop
- `h-overlay` — General overlay
- `h-modal-container` — Modal dialog
- `h-notification-modal` — Notification banner/modal

#### UI Elements
- `h-logo` — Hermès SVG logo + SEO img fallback
- `h-svg-icon` — SVG sprite icon (uses `<use href="#ng__icon-name">`)
- `h-svg-symbol` — SVG symbol definitions
- `h-loader` — Loading indicator (200px square)
- `h-banners-top-container` — Top banner placement

#### Footer (Deprecated Pattern)
- `h-footer-deprecated` — Footer wrapper
- `h-footer-columns-deprecated` — Column layout
- `h-footer-links-group-deprecated` — Link groups
- `h-footer-newsletter-deprecated` — Newsletter signup
- `h-footer-social-networks-deprecated` — Social links
- `h-footer-copyright-deprecated` — Copyright text
- `h-footer-country-selector-button-deprecated` — Country/language selector
- `h-footer-here-to-help-deprecated` — Customer service links
- `h-customer-service-contact` — Contact info

### Image Handling

```html
<h-media-picture>
  <picture>
    <source media="(min-width: 320px) and (max-width: 414px)" 
            srcset="...?wid=414">
    <source media="(min-width: 415px) and (max-width: 767px)" 
            srcset="...?wid=767">
    <source media="(min-width: 768px) and (max-width: 1024px)" 
            srcset="...?wid=1024">
    <source media="(min-width: 1025px) and (max-width: 1280px)" 
            srcset="...?wid=1280">
    <source media="(min-width: 1281px) and (max-width: 1920px)" 
            srcset="...?wid=1920">
    <source media="(min-width: 1921px)" 
            srcset="...?wid=3840">
    <img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==" 
         alt="..." loading="lazy">
    <figcaption class="media-title-overlay">...</figcaption>
  </picture>
</h-media-picture>
```

**Key patterns**:
- 6-breakpoint responsive images via Scene7 CDN `wid` parameter
- Lazy loading default (`loading="lazy"`)
- Base64 transparent placeholder for intrinsic ratio
- `<figcaption>` overlay for editorial image titles
- `fetchpriority="auto"` default

---

## 9. CSS Custom Properties (Design Tokens)

### Font Families
```css
--font-primary: "Manrope", "Roboto", sans-serif;
--font-secondary: "Overpass Mono", "Gill Sans MT", calibri, sans-serif;
--font-edito: "EBGaramond", "Bell MT", Times New Roman, sans-serif;
--font-filosofia: "Filosofia", serif;
--font-akkurat: "Akkurat", serif;
--font-jungle-love: "Jungle-Regular", serif;
--font-brides-de-gala: "BridesdeGala-Regular", serif;
```

### Font Sizes
```css
--font-size-heading-xxl: 2.125rem;  /* 34px */
--font-size-heading-xl: 1.875rem;   /* 30px */
--font-size-heading-l: 1.625rem;    /* 26px */
--font-size-heading-m: 1.5rem;      /* 24px */
--font-size-heading-default: 1.375rem; /* 22px */
--font-size-heading-s: 1.25rem;     /* 20px */
--font-size-heading-xs: 1.125rem;   /* 18px */
--font-size-body-xl: 1rem;          /* 16px */
--font-size-body-l: .875rem;        /* 14px */
--font-size-body-m: .75rem;         /* 12px */
--font-size-body-default: .6875rem; /* 11px */
--font-size-body-s: .625rem;        /* 10px */
--font-size-body-xs: .5rem;         /* 8px */
```

### Font Weights
```css
--font-weight-100 through --font-weight-800
```

### Layout
```css
--header-height-mobile: 50px;
--header-height-desktop: 64px;
--header-height-desktop-with-menu: 110px;
--header-menu-top: 58px;
--header-menu-height: 46px;
--scroll-y: [dynamic, set by JS];
--category-max-height: 294px;
--category-min-height: 42px;
```

### Note on Color Tokens

Hermès does **not** use CSS custom properties for colors. Colors are hardcoded hex values directly in CSS rules. This is a notable architectural choice — likely for:
1. Brand color discipline (few colors to manage)
2. Angular scoped styles (`_ngcontent` attributes) already provide isolation
3. Historical codebase evolution (pre-CSS-custom-property era patterns)

---

## 10. Key Takeaways

### What Makes Hermès Design Distinctive

1. **Typography as architecture**: Three distinct voices (EB Garamond / Overpass Mono / Manrope) create hierarchy without relying on size alone
2. **Restrained color**: Single orange accent (`#fc6`), warm cream foundation, black text. No gradients, no color ramps, no multi-accent system
3. **Zero radius aesthetic**: Sharp corners everywhere — architectural precision over softness
4. **Multi-locale type**: Per-language font stacks and size scales, not just translations
5. **Accessibility-first**: Skip links, keyboard-only focus ring, sr-only text throughout, dedicated accessibility site
6. **Minimal motion**: No scroll-driven animation, no page transitions, CSS-only keyframes, reduced-motion from the ground up
7. **Editorial first**: EB Garamond italic titles, image captions, "edito" component naming — the site is a magazine as much as a store
8. **Image sophistication**: 6-breakpoint responsive srcset, Scene7 CDN, lazy loading, transparent placeholders
9. **Angular SSR**: Server-side rendering with client hydration (ng-server-context="ssr")
10. **Self-contained**: Custom component library (no third-party UI kit), normalize-scss base, Angular CDK for overlays

### Design Principles Inferred

1. **Heritage over trend**: EB Garamond (16th century typeface roots), warm cream palette, zero-radius sharpness
2. **Craft over convenience**: Custom component library, per-locale typography, handwritten accessibility
3. **Whisper, don't shout**: Orange used sparingly, motion barely perceptible, black text on cream
4. **Universal access**: Skip links, keyboard nav, screen reader text, reduced motion, forced-colors, external accessibility microsite
5. **Editorial authority**: Magazine-like content hierarchy, image captions, italic editorial voice

---

## 11. Extraction Limitations

### HTTP Access
- **Root path** (`/`) returned **HTTP 403** with DataDome + Cloudflare bot detection
- **Sub-path** (`/us/en/`) returned **HTTP 200** with full Angular SSR HTML (598KB)
- **Main CSS** (`hermes.ef2936e76bedc435.css`) fetched successfully (61KB)
- **CDN assets** (`assets.hermes.com`) returned 404 on root, but Scene7 images are accessible

### What Was Analyzed
- Full inline `<style>` blocks (10+ Angular component styles)
- Complete main CSS file (all typography classes, breakpoints, keyframes, transitions, reset, CDK styles)
- Body HTML structure (component tree, ARIA attributes, image patterns, nav structure)
- All CSS custom properties (30 tokens)
- All `@font-face` declarations (4 variable fonts)
- All `@keyframes` animations (2)
- All media queries (4 breakpoint patterns)
- All color hex values (43 unique colors from HTML + CSS)

### What Could Not Be Analyzed
- **Runtime-only styles**: Styles applied via Angular `[ngStyle]` or component state
- **JavaScript-driven animations**: Angular animation triggers are declared but exact motion curves are in TS code
- **Dynamic color states**: Hover, active, focus states not fully visible in static CSS
- **Authenticated states**: Account dashboard, order history, wishlist
- **Checkout flow**: Cart and purchase funnel
- **Search results page**: Only the search form structure was visible
- **Category pages**: Only mega menu structure, not full PLP
- **Product detail pages**: Only product card component, not full PDP
- **Footer**: Component names extracted but footer was not in fetched HTML snapshot

### Request Budget Used
- **Requests made**: 4 (1 homepage attempt [403], 1 /us/en/ [200], 1 CSS [200], 1 CDN test [404])
- **Budget remaining**: 11 of 15
- **Circuit breaker**: Tripped on root path (403) but recovered via sub-path
- **Total downloaded**: ~660KB (598KB HTML + 61KB CSS)
