# Xiaomi mi.com Complete Design System

> Extracted: 2026-05-18 | URL: https://www.mi.com | Slug: mi
> Category: design-inspiration | Type: Chinese Consumer Tech Product Marketing
> Tech stack: Vue.js SSR (custom `__mipage` framework) + Swiper.js + Custom CDN asset pipeline

---

## Executive Summary

Xiaomi.com represents the pinnacle of **Chinese consumer tech marketing design** — a masterclass in information density, visual vibrancy, and ecosystem storytelling that differs fundamentally from Western tech minimalism. Where Apple whispers, Xiaomi shouts (but with precision). The design philosophy is "以人为中心，构建人车家全生态" (Human-centered, building the full Human-Car-Home ecosystem).

### Core Design Philosophy

Xiaomi's design system operates on four pillars:

1. **Dark Canvas Dominance** — Full-black and near-black backgrounds make product photography explode with contrast, saturation, and dramatic lighting. This isn't restrained minimalism — it's cinematic product theater.
2. **Orange as the Irreplaceable Signal** — The signature `#ff6900` orange is used strategically for navigation hovers, CTA buttons, and active states. It appears sparingly enough to maintain impact, frequently enough to build brand recognition.
3. **Ecosystem Storytelling** — Every section reinforces the "人车家" (Human-Car-Home) narrative. Products aren't shown in isolation — they're positioned as nodes in a connected ecosystem (phone talks to car, car to home, home to wearable).
4. **Viewport-Scaled Typography** — Rather than breakpoint-based font sizes, Xiaomi uses viewport-based scaling (`--base: 1vw`) with a hard cap at 2560px. This creates fluid, always-proportional type that fills the screen at any resolution.

### What Makes Xiaomi's Design Distinctly Chinese Tech

Xiaomi succeeds where many global tech brands fail because:

- **Richer color saturation**: Chinese consumer markets respond to vibrancy — Xiaomi's product photography uses deeper blacks, warmer accents, and more dramatic lighting than Western equivalents
- **Higher information density**: Chinese consumers expect more information per scroll — Xiaomi packs product names, specs, slogans, and CTAs into every carousel slide without feeling cluttered
- **Bilingual fluidity without compromise**: Chinese and English coexist naturally. Product names are English (brand globalism), while descriptions and navigation are Chinese (market-native). Both typefaces are custom-designed (MiSans, Mi Lan Pro).
- **Flash-sale urgency**: Countdown timers, "立即购买" (Buy Now) buttons, and promotional urgency elements that are standard in Chinese e-commerce but rare in Western tech marketing
- **Ecosystem over individual product**: The "人车家全生态" framing positions everything as a connected lifestyle, not isolated gadgets. This holistic narrative resonates deeply with Chinese consumer values.

---

## 1. Color System

### 1.1 Core Palette

```
/* Background Hierarchy */
--mi-bg-black:          #000000     /* Hero backgrounds, full-bleed sections */
--mi-bg-near-black:     #12151a     /* Footer, secondary dark sections */
--mi-bg-nav-scrolled:   rgba(0,0,0,0.85)  /* Sticky nav after scroll */
--mi-bg-nav-transparent: transparent /* Nav at page top */

/* Footer/Light Backgrounds */
--mi-bg-footer-light:   #fafafa     /* Desktop footer background */
--mi-bg-white:          #ffffff     /* Light section cards, dialogs */

/* Xiaomi Signature Orange (THE accent) */
--mi-accent-primary:    #ff6900     /* Nav hover, active states, buttons */
--mi-accent-secondary:  #ff6700     /* Alternative orange (button borders, phone) */
--mi-accent-hover-dark: #f25807     /* Darker orange on hover/active */

/* Text Colors */
--mi-text-white:        #ffffff     /* Primary text on dark backgrounds */
--mi-text-dimmed:       hsla(0,0%,100%,0.3)  /* Legal text, footer dimmed */
--mi-text-mid-dimmed:   hsla(0,0%,100%,0.8)  /* Subtitles */
--mi-text-dark:         #000000     /* Text on light backgrounds */
--mi-text-footer:       #616161     /* Footer body text */
--mi-text-footer-head:  #424242     /* Footer heading text */
--mi-text-footer-link:  #757575     /* Footer link text */
--mi-text-footer-light: #b0b0b0     /* Footer legal/copyright text */

/* Borders & Dividers */
--mi-border-footer:     #e0e0e0     /* Footer section dividers */
--mi-border-mobile:     hsla(0,0%,100%,0.3)  /* Mobile menu borders */

/* Overlay */
--mi-overlay-dialog:    rgba(0,0,0,0.3725)  /* Dialog backdrop */
--mi-overlay-shadow:    rgba(0,0,0,0.3725)  /* Dialog perimeter shadow */
```

### 1.2 Color Roles & Usage

| Role | Color | Usage |
|------|-------|-------|
| Hero background | `#000` | All carousel slide backgrounds |
| Product backdrop | `#000` | Product photography uses black studio setups |
| Nav (top state) | `transparent` | White text over hero image |
| Nav (scrolled) | `rgba(0,0,0,0.85)` | 85% opacity black for legibility |
| Primary CTA | `#ff6900` bg, `#fff` text | Pill buttons (appointment, buy) |
| Secondary CTA | `#fff` bg, `#ff6700` border + text | Outline buttons |
| Nav hover/active | `#ff6900` | All interactive states in nav |
| Footer bg (desktop) | `#fafafa` | Light, distinct from dark hero |
| Footer bg (mobile) | `#12151a` | Dark, consistent with site |
| Dialog confirm | `#ff6900` bg, border-radius 24px | Modal confirm buttons |
| Text on hero | `#fff` | Title, subtitle, explanatory text |

### 1.3 Xiaomi's Signature Orange Strategy

Xiaomi uses orange as its **single irreplaceable brand accent**. Unlike many brands that use multiple accents, Xiaomi commits fully to one:

- **`#ff6900`**: Exactly this warm orange — not red, not amber. Sits between safety orange and warm gold.
- **Where it appears**: Navigation hover states, active pagination bullets, CTA buttons, section links, footer phone number
- **Where it does NOT appear**: Product logos (which use their own product colors), body text, section backgrounds
- **The discipline**: Orange never appears as decoration. It is ALWAYS functional — telling the user "this is interactive" or "this is Xiaomi."

This single-accent strategy creates remarkably strong brand recall — seeing orange on a dark tech site immediately signals Xiaomi.

### 1.4 Section Background Alternation

Xiaomi creates visual rhythm through deliberate dark-to-dark alternation rather than light-dark:

```
Hero Carousel 1: Full black (#000)          — SU7/YU7 cars
Hero Carousel 2: Full black (#000)          — Xiaomi 17 Ultra
Hero Carousel 3: Full black (#000)          — Xiaomi 17 Pro / 17
Carousel 4:     Full black (#000)          — Pad 8 Pro
Carousel 5:     Full black (#000)          — Redmi phones
Carousel 6:     Full black (#000)          — AIoT products
...
Footer:         Near-black (#12151a) or light (#fafafa)
```

Unlike DJI's light-dark alternation, Xiaomi commits to **consistent darkness** — every product section is full-black-background photography. The rhythm comes from product scale contrast (car → phone → tablet → phone → appliance), not from background color changes. This creates a more immersive, cinema-like scroll experience.

### 1.5 Gradient Usage

Xiaomi uses gradients minimally and only for functional depth:

```css
/* Button pill — solid color, no gradient */
.btn-primary { background: #ff6900; }

/* Button line — flat, no gradient */
.btn-line-primary { background: #fff; border: 1px solid #ff6700; color: #ff6700; }

/* Nav scroll transition — opacity-based, not gradient */
.header-wrapper.scroll-theme { background-color: rgba(0,0,0,.85); }
```

Unlike DJI's button gradients, Xiaomi prefers **flat, solid color buttons** with rounded pill shapes. The depth comes from the contrast of the bright orange against the dark background, not from gradient simulation.

---

## 2. Typography System

### 2.1 Font Stack

```css
/* Primary: MiSans (Xiaomi custom sans-serif) */
font-family: 'MiSans', serif;
/* Weights loaded: 200, 300, 400, 450, 500, 600, 650, 700 */
/* Subset: Chinese_Simplify + Latin */
/* Loading: font-display: swap via onload pattern */

/* Secondary: Mi Lan Pro (Xiaomi custom branding font) */
font-family: 'MI Lan Pro', serif;
/* Weights loaded: 200, 300, 400, 500, 600, 700, 800 */
/* Subset: Chinese_Simplify + Latin */

/* Font CDN: https://font.sec.miui.com/font/css */
```

**Key insight**: Xiaomi invested in TWO custom typefaces. MiSans is the workhorse — used in navigation, body text, titles. Mi Lan Pro is the brand font — used for the logo and special branding moments. Both support full Chinese character sets with Latin fallback, ensuring consistent rendering across all locales.

### 2.2 Size Hierarchy (Desktop, based on viewport scaling)

The type system uses `rem` units where `1rem = 1vw` (capped at 133.33px at 2560px):

| Token | Approx Size (at 1440px) | Weight | Usage |
|-------|------------------------|--------|-------|
| Countdown number | 52px | 700 | Flash sale countdown |
| Hero title | ~40px (0.315rem) | 500 | Carousel slide titles |
| Hero subtitle | ~24px (0.188rem) | 400 | Carousel slide descriptions |
| Section title | ~40px (0.43rem) | 600 | Award/gallery section headings |
| Section subtitle | ~23px (0.18rem) | 400 | Supporting text |
| Nav items | 14px | 500 | Desktop navigation links |
| Nav container | 20px (item wrapper) | — | Nav flex container font-size |
| Logo text | 14px | 400 (Mi Lan Pro) | Logo text beside SVG |
| CTA button | 18px | — | Button text |
| Dialog title | 32px | — | Region selector dialog |
| Dialog body | 16-18px | — | Dialog content |
| Footer headings | 14px | — | Footer column titles |
| Footer links | 12px | — | Footer link items |
| Footer contact | 22px | — | Phone number (orange) |
| Mobile nav items | ~15px (0.38rem) | 500 | Mobile menu links |
| Mobile product title | ~28px (0.735rem) | — | Mobile hero title |
| Mobile product subtitle | ~16px (0.413rem) | — | Mobile hero subtitle |

### 2.3 Font Weight Distribution

| Element | Family | Weight |
|---------|--------|--------|
| Navigation links | MiSans | 500 (Medium) |
| Navigation text | MiSans | 400 (Regular) |
| Logo | Mi Lan Pro | 400 (Regular) |
| Hero titles | MiSans | 500 (Medium) |
| Hero subtitles | — | 300-400 |
| Mobile nav | MiSans | 500 (Medium) |
| Appointment title | MiSans | 700 (Bold) for numbers |

### 2.4 Chinese + English Bilingual Typography

Xiaomi's bilingual approach is distinct from DJI's locale-native strategy:

| Element | Chinese | English/Latin |
|---------|---------|---------------|
| Page title | "Xiaomi官方网站" | Brand name in English |
| Navigation | Chinese category names | "Location", "IoT" in English |
| Hero titles | Chinese product slogans | Product model numbers ("SU7", "17 Ultra") |
| Hero subtitles | Chinese descriptions | English tech terms ("Leica", "HyperOS") |
| Product names | — | English brand names treated as logos |
| Footer | Chinese legal text | "mi.com" domain |

**Bilingual strategy**: Xiaomi uses **mixed-script** more aggressively than DJI. Chinese and English appear within the same sentence, the same card, the same navigation bar. This reflects the reality of Chinese tech culture — English product names are aspirational, Chinese descriptions are practical. MiSans handles both scripts seamlessly.

### 2.5 Hero Typography Pattern

Each carousel slide follows a precise typographic sequence:

```
1. PRODUCT IMAGE (full-bleed, silent)
   └─ The product IS the h1 — dramatic photography dominates

2. TITLE OVERLAY (MiSans 500, ~40px, white, centered-left)
   └─ "Xiaomi SU7" / "Xiaomi 17 Ultra" / "Redmi K90 Pro Max"

3. SUBTITLE (MiSans 400, ~24px, white 80% opacity)
   └─ Supporting tagline or key feature highlight

4. EXPLANATORY TEXT (rare, ~24px, white 80% opacity)
   └─ Additional detail when needed

5. CTA (present on non-first carousels)
   └─ Jump link or play button
```

Unlike DJI's three-line hierarchy (eyebrow + logo + slogan), Xiaomi uses a cleaner two-line system (title + subtitle) that lets the product photography do more of the communication.

---

## 3. Layout & Spacing System

### 3.1 Viewport-Scaled Grid

Xiaomi uses a radical viewport-based scaling system:

```css
/* Base unit scales with viewport width */
@media screen and (max-width: 2560px) {
  html { font-size: 5.208203125vw !important; }
  /* At 1440px viewport: 1rem = 75px */
  /* At 1920px viewport: 1rem = 100px */
}
@media screen and (min-width: 2560px) {
  html { font-size: 133.33px !important; }
  /* Hard cap: 1rem = 133.33px */
}
@media screen and (max-width: 800px) {
  html { font-size: 9.2592592593vw !important; }
  /* Mobile scaling: more aggressive to fill smaller screens */
}

/* Component-level base override */
--base: 1vw;       /* Default viewport base */
--base: 12.6px;    /* Mobile fallback at ≤1226px */
```

### 3.2 Content Widths

| Context | Width | Notes |
|---------|-------|-------|
| Page max-width | 2560px | Hard cap for ultra-wide displays |
| Header container | 1440px | Nav items align within this |
| Swiper text content | 1226px | Title/subtitle text width |
| Product card (pc) | 5.94rem (~445px at 75px/rem) | Individual product cards in grid |
| Product card (mobile) | 8.16rem (~755px at 92.6px/rem) | Mobile full-width cards |
| Video player | 819px | Fixed pixel width for video modals |
| Dialog (QR) | 300px x 256px | Compact QR code modal |
| CTA button | 224px | Standard button width |
| CTA button small | 118px | Footer small buttons |
| Confirm button | 130px x 45px | Dialog confirmation |

### 3.3 Section Rhythm

```
Header:               65px height (fixed, transparent → dark on scroll)
Hero carousel:        Full-viewport height (each slide)
Sub-carousels:        Variable height based on content
Footer (desktop):     Multi-column with service + links + info sections
Footer (mobile):      Compact with "了解小米" (About Xiaomi) link + legal
```

Each content carousel occupies its own full section. There are no half-height or shared sections — every product category gets a dedicated carousel.

### 3.4 Product Image Dimensions

| Context | PC Dimensions | Mobile Dimensions |
|---------|---------------|-------------------|
| Hero carousel | 2560 x 1180 | 1080 x 1440 |
| Product carousel | 2560 x 1080 | 1080 x 1320 |
| Separator strips | 2560 x 20 | 1080 x 20 |
| Aspect ratio (pc) | ~2.17:1 to 2.37:1 | 0.75:1 to 0.82:1 |

**Key insight**: The mobile aspect ratio is nearly the inverse of desktop. PC images are ultra-wide landscapes; mobile images are tall portraits. This means Xiaomi creates completely separate photography for mobile vs desktop — not just responsive scaling, but fundamentally different compositions.

### 3.5 Carousel Spacing

```
Hero carousel:         full-width, edge-to-edge
Product grid carousel: 5.94rem cards, variable gap
Text overlay position: absolute, within 1226px centered container
Pagination bullets:    bottom, ~0.585rem from edge
Prev/Next arrows:      ~0.33rem from edges
```

### 3.6 Card Design Patterns

Xiaomi's product cards (secondary carousels) follow this pattern:

```
┌──────────────────────────────┐
│                              │
│    [Product Image]           │  ← Full-bleed within card
│    (dark studio shot)       │     border-radius: 0.4rem
│                              │
│    ┌────────────────────┐    │
│    │ PRODUCT NAME       │    │  ← Overlaid text (hidden by default)
│    │ Short description  │    │     Revealed on hover with dimming
│    └────────────────────┘    │
│                              │
│    [Video Play Button]       │  ← Center overlay on video cards
└──────────────────────────────┘
```

Card hover behavior:
- Image: `filter: brightness(0.6)` (darkens)
- Text overlay: `opacity: 0 → 1`, `transition: 0.3s`
- Like/heart button: `opacity: 0 → 1`

---

## 4. Hero Section Design

### 4.1 Hero Architecture

Xiaomi's homepage hero is NOT a single hero — it's a **vertically stacked series of full-width Swiper carousels**, each dedicated to a product family:

```html
<div class="content">
  <!-- Carousel 1: Xiaomi SU7/YU7/Ultra cars (4 slides) -->
  <div id="_6720bfd0352df30001ebf72c" class="carousel-wrapper">
    <div class="swiper firstswiper">
      <!-- 4 slides, each 2560x1180 -->
    </div>
  </div>

  <!-- Carousel 2: Thin separator strip -->
  <div class="carousel-wrapper"><!-- 2560x20 --></div>

  <!-- Carousel 3: Xiaomi 17 Ultra (1-2 slides) -->
  <div class="carousel-wrapper">
    <div class="swiper firstswiper">
      <!-- 1-2 slides, 2560x1080 -->
    </div>
  </div>

  <!-- ... 10+ carousels stacked vertically ... -->
</div>
```

### 4.2 Carousel Stack Strategy

The homepage contains **10+ stacked carousels**, organized by product priority:

| # | Carousel ID | Product | Slides | Type |
|---|------------|---------|--------|------|
| 1 | `6720bfd0...` | SU7/YU7/Ultra/Customization | 4 | First (hero) |
| 2 | `671f01c8...` | Separator strip | 1 | Spacer |
| 3 | `68d51dec...` | Xiaomi 17 Ultra / P1 | 2 | First (hero) |
| 4 | `68d09299...` | Separator strip | 1 | Spacer |
| 5 | `68d0931c...` | Xiaomi 17 Pro / 17 | 2 | First (hero) |
| 6 | `68cd3ead...` | Xiaomi Pad 8 Pro | 1 | First (hero) |
| 7 | `682a8b4a...` | Separator strip | 1 | Spacer |
| 8 | `6699ccb7...` | Redmi Turbo 5 / K90 Pro / Note 15 | 3 | First (hero) |
| 9 | `68268f9e...` | AIoT (6 products) | 6 | Non-first (grid) |
| 10 | `67bbbfa7...` | Separator strip | 1 | Spacer |
| 11 | `67c05a5e...` | Imaging Award | 1 | First (hero) |
| 12 | `6720c092...` | HyperOS | 1 | First (hero) |
| 13 | `6719ba0c...` | Separator strip | 1 | Spacer |
| 14 | `65d72ec1...` | Human-Car-Home | 1 | First (hero) |

### 4.3 Two Carousel Types

**Type A: "firstswiper" (Product Hero)**
- Full-viewport height
- Product title as text overlay (not image-based)
- Swiper prev/next arrows (triangle style, white → orange on hover)
- Custom progress-bar pagination bullets
- Text animation on slide active (opacity + translateY)
- Centered 1226px text content width

**Type B: "nonfirst" (Product Grid)**
- Constrained to 1440px max-width
- Shows 3-6 product cards
- Card border-radius: 0.4rem
- Hover: dim + reveal text/like buttons
- No arrows on mobile
- Pagination visible on mobile

### 4.4 Hero Text Animation

```css
/* Initial state — hidden below */
.swiper-text {
  position: absolute;
  opacity: 0;
  transform: translateY(10px);
  transition: all 0.6s;
}

/* Active slide — reveal */
.my-slide-active .swiper-text {
  opacity: 1;
  transform: translateY(0);
}
```

The 0.6s transition with translateY creates a subtle "rise into view" effect when each slide becomes active.

### 4.5 Pagination Bullets

Xiaomi uses **custom progress-bar-style pagination bullets** — a distinctive design choice:

```css
.swiper-pagination-bullet-custom {
  width: 1.27rem;        /* Very wide — like mini progress bars */
  height: 3px;           /* Thin, minimal */
  background: #b2b2b2;    /* Inactive: light gray */
  opacity: 0.7;
  border-radius: 0;       /* Sharp corners — precision feel */
  transition: all 0.1s;
}

.swiper-pagination-bullet-custom.swiper-pagination-bullet-active {
  background: #ff6900;    /* Active: Xiaomi orange */
  opacity: 1;
}
```

These are not dots — they are wide, thin bars that feel like loading progress indicators. On hover they go fully opaque gray; when active they turn Xiaomi orange.

### 4.6 Custom Arrow Navigation

```css
/* Built from CSS borders — no SVG/icons needed */
.swiper-button-prev {
  width: 0.135rem;
  height: 0.135rem;
  border-top: 5px solid #fff;
  border-left: 5px solid #fff;
  transform: rotate(-45deg);   /* Left-pointing arrow */
}

.swiper-button-next {
  transform: rotate(135deg);   /* Right-pointing arrow */
}

/* Hover state */
.swiper-button-prev:hover {
  border-top: 5px solid #ff6900;
  border-left: 5px solid #ff6900;
}
```

The arrows are pure CSS — border-based triangles rotated 45 degrees. This is elegant, performant, and scales perfectly with the viewport. On mobile, arrows are hidden; pagination takes over.

### 4.7 Video Play Button

Centered on video-enabled slides:

```css
.play-button {
  position: absolute;
  left: 50%; top: 50%;
  transform: translate(-50%, -50%);
  width: 0.878rem;   /* Scale: ~66px at 75px/rem */
  height: 0.878rem;
  background: url(play1.png);  /* Normal state */
}
.play-button:hover {
  background: url(play2.png);  /* Hover state — different PNG */
}
```

Simple image swap on hover — no animation, no scale. Consistent with the engineering-precision aesthetic.

---

## 5. Navigation System

### 5.1 Desktop Navigation Structure

```html
<header class="header-wrapper">
  <div class="header-container">
    <!-- Left: Logo -->
    <div class="logo">
      <span>|</span>
      <span><!-- SVG logo --></span>
    </div>

    <!-- Center: Main nav (10 items, 14px MiSans 500) -->
    <nav class="nav-menu">
      <a>小米官网</a>        <!-- Home -->
      <a>小米商城</a>        <!-- Store -->
      <a>小米澎湃OS</a>      <!-- HyperOS -->
      <a>小米汽车</a>        <!-- EV -->
      <a>小米影像</a>        <!-- Imaging -->
      <a>云服务</a>          <!-- Cloud -->
      <a>IoT</a>             <!-- IoT -->
      <a>有品</a>            <!-- Youpin -->
      <a>小爱开放平台</a>     <!-- XiaoAI Platform -->
      <a>Location</a>        <!-- Region -->
    </nav>

    <!-- Right: Login/Register -->
    <nav class="login-menu">
      <a>登录</a> | <a>注册</a>
    </nav>
  </div>
</header>
```

### 5.2 Header States

| State | Class | Behavior |
|-------|-------|----------|
| Page top | (default) | `transparent` bg, `#fff` text, `position: fixed` |
| Scrolled | `.scroll-theme` | `rgba(0,0,0,.85)` bg, `#fff` text |
| Link default | — | `#fff`, MiSans 400-500 |
| Link hover/active | `.active`, `:hover` | `#ff6900` (orange) |
| Mobile menu closed | `.menu` | `opacity: 0`, `z-index: -1` |
| Mobile menu open | `.menu.visible` | `opacity: 1`, `z-index: 99`, full-screen overlay |

### 5.3 Navigation Spacing

```
Header height:   65px (fixed)
Logo area:       left-aligned
Nav items:       14px font, 20px container
Nav item gap:    20px margin each side (desktop)
Nav item gap:    10px at ≤1140px, 6px at ≤900px
Login area:      right-aligned, 13px left margin
```

### 5.4 Logo Treatment

The Xiaomi logo is an SVG icon with optional "MI" text in Mi Lan Pro:

```css
.mi-logo {
  height: 34px;       /* Desktop */
  height: 0.71rem;    /* Mobile (scaled) */
}
.logo span {
  margin: 0 13px;     /* Spacing around logo */
  font-family: 'MI Lan Pro', serif;
  font-weight: 400;
  font-size: 14px;
}
```

### 5.5 Mobile Navigation

```css
/* Mobile header: compact */
.ismobile.header-wrapper {
  padding: 0 0.46rem;
  height: 1.45rem;        /* ~55px */
}

/* Full-screen overlay menu */
.ismobile .menu {
  width: 100vw;
  position: fixed;
  top: calc(1.45rem - 1px);
  left: 0;
  background: #000;
  max-height: calc(100% - 1.45rem);
  overflow: auto;
  transition: all 0.1s ease-in-out;
}

/* Menu items */
.ismobile .menu-item.nav-menu-item a {
  font-size: 0.38rem;     /* ~15px */
  color: #ccc;            /* Slightly dimmed white */
  width: 100%;
}

/* Active state */
.ismobile .menu-item.nav-menu-item.active a {
  color: #ff6900;
}

/* Right arrow icon on each item */
.right-arrow-icon {
  width: 0.14rem;
  height: 0.26rem;
  background-image: url(header-right-arrow.png);
}
```

Mobile menu items have right-arrow icons and top-border separators. The login/register area is split 50/50 with a pipe separator.

### 5.6 Search Integration

Unlike DJI's elaborate search overlay, Xiaomi's homepage navigation does NOT include a search bar. This is a notable design choice — the homepage is purely for product discovery via curated carousels. Search is delegated to subdomains (mi.com/shop for e-commerce search, etc.).

---

## 6. Motion & Animation System

### 6.1 Animation Philosophy

Xiaomi's animations are **functional and restrained** — they clarify state without distracting. The most common duration is 0.3s for UI transitions and 0.6s for content reveals.

### 6.2 Transition Tokens

| Context | Duration | Easing | Property |
|---------|----------|--------|----------|
| Nav background | 0.5s | ease | background-color |
| Carousel text reveal | 0.6s | (default) | opacity, transform |
| Button/dialog fade | 0.2s | ease-in-out | opacity |
| Product card hover | 0.3s | (default) | filter, opacity |
| Pagination bullet | 0.1s | (default) | background |
| Mobile menu toggle | 0.1s | ease-in-out | opacity, z-index |
| Carousel slide | Swiper default | Swiper default | transform |

### 6.3 Key Animation Patterns

#### 1. Carousel Slide Text Reveal
- **Trigger**: Slide becomes active (`.my-slide-active`)
- **Properties**: `opacity: 0 → 1`, `transform: translateY(10px) → translateY(0)`
- **Duration**: 0.6s
- **Effect**: Text rises gently into position as the slide transitions in

#### 2. Navigation Scroll Transition
- **Trigger**: Window scroll past threshold
- **Properties**: `background-color: transparent → rgba(0,0,0,0.85)`
- **Duration**: 0.5s
- **Easing**: ease
- **Effect**: Smooth darkening of nav as user scrolls away from hero

#### 3. Dialog Open/Close
- **Trigger**: Dialog open
- **Properties**: `opacity: 0 → 1`
- **Duration**: 0.2s
- **Easing**: ease-in-out
- **Keyframe name**: `optical` (suggesting the fade mimics optical perception)

#### 4. Product Card Hover
- **Trigger**: `:hover` on card
- **Properties**: `filter: brightness(0.6)` on image, `opacity: 0 → 1` on overlays
- **Duration**: 0.3s
- **Effect**: Image dims, text and interaction buttons (like) appear

#### 5. Pagination Bullet Transition
- **Trigger**: Slide change
- **Properties**: `background-color` change
- **Duration**: 0.1s
- **Effect**: Quick color swap from gray to orange

### 6.4 What Xiaomi Does NOT Animate

- No scroll-triggered parallax (product photography is too important to distort)
- No spring/bounce physics (engineering-precision brand)
- No auto-playing video (static photography with optional play buttons)
- No cursor followers or decorative WebGL
- No page transitions between sections (it's all one long page)
- No lazy-loading skeleton states (images preload via Swiper's lazy loading)

---

## 7. Product Showcase Patterns

### 7.1 The Stacked Carousel Pattern

Xiaomi's most distinctive product showcase pattern is the **vertically stacked carousel** — each product category gets its own full-width, full-height carousel section. This creates a "product catalog as scroll" experience:

```
Scroll → Car (SU7/YU7/Ultra)
Scroll → Phone (17 Ultra)
Scroll → Phone (17 Pro/17)
Scroll → Tablet (Pad 8 Pro)
Scroll → Phone (Redmi series)
Scroll → AIoT Grid (6 products)
Scroll → Imaging Award
Scroll → HyperOS
Scroll → Human-Car-Home ecosystem
```

### 7.2 Product Family Grid (AIoT Section)

The AIoT section uses a 6-slide horizontal carousel, each slide featuring one product:

- Xiaomi Sound 2 Max (speaker)
- Xiaomi Portable Bluetooth Speaker
- S Pro 85 MiniLED 2026 (TV)
- Mijia Fridge Pro DSFR560L
- Mijia 3-Zone Washer Pro 10kg
- Xiaomi Router BE-10000 Pro

Each slide: Large product photo on dark background with white text title + subtitle overlaid on the left side.

### 7.3 "人车家全生态" (Human-Car-Home Ecosystem) Narrative

The final carousel is dedicated to Xiaomi's ecosystem vision — showing how cars, phones, and home devices connect through HyperOS. This is not a product section; it's a brand narrative section that ties everything together.

### 7.4 Flash Sale / Appointment Pattern

```html
<div class="appointment-content">
  <div class="title">产品名称</div>
  <div class="title-small">发售倒计时</div>
  <div class="time-box">00 : 00 : 00 : 00</div>
  <div class="button-box">
    <div class="btn">立即预约</div>
  </div>
</div>
```

Countdown timer with 52px bold numbers, pill-shaped orange CTA button (224x44px, border-radius: 22px).

### 7.5 Product Comparison Cards (Implied)

While not explicitly coded as comparison tables, the sequential carousel structure naturally enables product comparison — scrolling from Xiaomi 17 Ultra to Xiaomi 17 Pro to Xiaomi 17 creates an implicit feature ladder where the user mentally compares across slides.

### 7.6 Accessory Ecosystem Display

The AIoT carousel serves as the ecosystem showcase — each product is an independent device that connects to the Xiaomi ecosystem (via HyperOS, XiaoAI assistant, Mi Home app). This "ecosystem as marketing" approach means every product reinforces the value of every other product.

---

## 8. Component Library

### 8.1 Pill Button (Primary CTA)

```css
.btn {
  width: 224px;
  height: 44px;
  background: #ff6900;
  border-radius: 22px;       /* Fully rounded pill */
  font-size: 18px;
  color: #fff;
  line-height: 44px;
  text-align: center;
  cursor: pointer;
}
```

Characteristics:
- Pill shape (`border-radius: 22px` = half of height — perfectly rounded ends)
- Solid orange background
- White text
- No border, no shadow, no gradient
- Fixed width (224px) — text is always centered

### 8.2 Outline Button (Secondary CTA)

```css
.btn-line-primary {
  border: 1px solid #ff6700;
  background: #fff;
  color: #ff6700;
}
.btn-line-primary:hover {
  color: #fff;
  background-color: #f25807;
  border-color: #f25807;
}
```

Used in footer sections. White bg with orange border and text. On hover, fills with darker orange.

### 8.3 Small Text Button

```css
.btn-small {
  width: 118px;
  height: 28px;
  font-size: 12px;
  line-height: 28px;
  cursor: pointer;
}
```

Compact variant for footer utility links.

### 8.4 Dialog Modal

```css
.dialog-outer-common {
  position: fixed;
  left: 50%; top: 50%;
  transform: translate(-50%, -50%);
  border-radius: 8px;
  overflow: hidden;
  animation: optical 0.2s ease-in-out;
  background: #fff;
}
.dialog-background {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.3725);
  z-index: 99;
}
```

### 8.5 Confirm Button (in Dialogs)

```css
.confirm-button {
  width: 130px;
  height: 45px;
  border-radius: 24px;
  background: #ff6900;
  color: #fff;
  font-size: 16px;
}
```

### 8.6 Video Player Modal

```css
.mi-video-player {
  width: 819px;
  height: 100%;
}
.mi-video-player video {
  background-color: #000;
}
.video-dialog .close-button {
  position: absolute;
  right: 1px;
  top: -30px;          /* Above the video */
  width: 20px; height: 20px;
  background: url(close.png);
}
```

### 8.7 QR Code Dialog

```css
.dialog-outer-qr {
  width: 300px;
  height: 256px;
}
.qrcode {
  width: 100px;
  margin: 0 auto;
  padding: 24px 0 0;
}
```

Used for WeChat/App download QR codes — common in Chinese tech marketing.

### 8.8 Scroll-to-Top Button

```css
.scroll-button {
  width: 42px;
  height: 62px;
  background: url(top-icon.png);
  position: fixed;
  left: calc(50% + 613px);   /* Right of content area */
  bottom: 150px;
  z-index: 100;
}
```

### 8.9 Play Button (Video Card Overlay)

Two-state PNG sprite:
- Normal: `play1.png`
- Hover: `play2.png`
- Size: ~0.878rem (~66px), centered on video cards

### 8.10 Two-Column Layout

```css
.oneline-twocol {
  display: flex;
  justify-content: space-between;
  max-width: 1440px;
  background: #fff;
}
.oneline-twocol .item-wrap:nth-child(2) {
  margin-left: calc(var(--pcgap) * 1rem / 133.33);
}
```

Used for side-by-side product promotions or split content sections.

### 8.11 Image Hot Zone Links

```html
<div class="figure-Chain-wrapper">
  <div class="content-wrapper">
    <a class="links-item" style="
      --width: 200; --height: 100; --top: 500; --left: 300;
    "><!-- Clickable region overlay --></a>
    <img src="...">
  </div>
</div>
```

Allows positioning clickable links over specific regions of a large image — useful for lifestyle photography where multiple products appear in one shot.

---

## 9. Technology Architecture

### 9.1 Frontend Stack

| Layer | Technology |
|-------|-----------|
| Framework | Vue.js 2 (SSR via `data-server-rendered="true"`) |
| State | Custom `__MIPAGE__` global state injection |
| Carousel | Swiper.js (heavily customized) |
| CSS | Scoped styles with `[data-v-xxxxxxxx]` attributes |
| CSS methodology | Viewport-based `rem` units, BEM-ish naming |
| JS bundling | Webpack with content-hashed filenames |
| CDN | `cdn.cnbj1.fds.api.mi-img.com` (Xiaomi self-hosted) |
| Fonts | Self-hosted `font.sec.miui.com` (MiSans + Mi Lan Pro) |
| Analytics | Baidu Tongji (`hm.baidu.com`) |
| WeChat SDK | `res2.wx.qq.com/open/js/jweixin-1.6.0.js` |
| Icons | PNG/CSS border triangles (no icon font) |

### 9.2 Data Architecture

```javascript
window.__MIPAGE__ = {
  layout: "default",
  data: [{
    floorData: [
      {
        id: "unique-floor-id",
        content: {
          floorName: "新产品名称",
          floorType: 1,           // 1 = carousel
          carousel1: [{
            usefulTime: [start, end],
            pcCarouselEnterImg: "https://...jpeg?w=2560&h=1080",
            mCarouselEnterImg: "https://...jpeg?w=1080&h=1320",
            materialType: 2,      // 2 = image
            pcJumpUrl: "{...}",   // JSON string with link data
            mJumpUrl: "{...}"
          }]
        }
      }
    ],
    navData: { ... }
  }],
  serverRendered: true
};
```

All carousel content is injected as JSON into the initial HTML payload. Each carousel has time-based visibility (`usefulTime` start/end timestamps), separate PC and mobile image URLs, and JSON-encoded jump links.

### 9.3 Content Scheduling

Carousels have `usefulTime` ranges — they appear and disappear based on Unix timestamps. This means the homepage is time-scheduled: pre-announcement carousels appear before launch, product carousels appear during active sales periods, and separators appear between campaigns.

Example schedule:
```
Redmi phones: 1745164800000 → 1906387200000 (May 2025 → May 2030)
AIoT section: some products 1747324800000 → 1940515200000 (May 2025 → Jun 2031)
Cars: 1747670400000 → 1940515200000 (May 2025 → Jun 2031)
```

### 9.4 Image CDN Pipeline

All product images flow through Xiaomi's image CDN with query parameters:
```
https://img.youpin.mi-img.com/ferriswheel/<hash>.jpeg?w=2560&h=1080
https://img.youpin.mi-img.com/ferriswheel/<hash>.jpeg?w=1080&h=1320
```

The `ferriswheel` path suggests a dedicated image processing pipeline (Ferris wheel = rotating carousel imagery). Images are pre-optimized JPGs with explicit dimensions.

---

## 10. Responsive Strategy

### 10.1 Breakpoint System

| Breakpoint | Effect |
|-----------|--------|
| **2560px** | Maximum viewport scale cap (html font-size: 133.33px) |
| **1440px** | Header container max-width, non-first carousel max-width |
| **1226px** | Swiper text content width; mobile/desktop switch trigger |
| **1140px** | Nav item spacing reduces to 10px |
| **900px** | Nav item spacing reduces to 6px |
| **800px** | Full mobile mode (aggressive viewport scaling) |

### 10.2 Mobile vs Desktop Strategy

| Element | Desktop | Mobile |
|---------|---------|--------|
| Image aspect ratio | ~2.2:1 (ultra-wide) | ~0.8:1 (tall/portrait) |
| Navigation | Horizontal top bar | Full-screen overlay menu |
| Footer | Light 6-column layout | Dark compact with accordion |
| Carousel arrows | Visible border-triangles | Hidden (pagination only) |
| Pagination bullets | Optional (on sub-carousels) | Always visible |
| Text size scaling | 1vw base (75px at 1440px) | 9.26vw base (more aggressive) |
| Video player | 819px fixed width | 100vw full width |
| Product cards | Horizontal swiper (5.94rem) | Larger vertical cards (8.16rem) |
| Dialog | Centered fixed | Scaled (--base: 0.8px multiplier) |

### 10.3 Font Scaling Formula

```
Desktop (≤2560px):  html { font-size: 5.208203125vw }
  At 1920px viewport: 1rem = 100px
  At 1440px viewport: 1rem = 75px
  At 1226px viewport: 1rem = 63.86px → capped at 12.6px base

Desktop (≥2560px):  html { font-size: 133.33px }
  Hard cap for ultra-wide monitors

Mobile (≤800px):    html { font-size: 9.2592592593vw }
  At 375px viewport: 1rem = 34.72px
```

The stepped scaling approach ensures the design fills the viewport beautifully at any width without requiring hundreds of breakpoint-specific rules.

---

## 11. E-Commerce Patterns

### 11.1 Price Display (Implied)

Xiaomi's homepage does not show prices directly — it focuses on product desire and ecosystem value. Pricing is delegated to the store subdomain (`mi.com/shop`). However, flash sale sections use countdown timers and "立即预约" (Reserve Now) CTAs.

### 11.2 Quick Buy Flow

```
Product Carousel Slide → Click product image/CTA → mi.com/shop product detail
                                                         ↓
                                                  Price + Variant selection
                                                         ↓
                                                  Add to cart → Checkout
```

The homepage drives traffic to product detail pages, where the full e-commerce experience lives.

### 11.3 Flash Sale Countdown

```html
<div class="time-box">
  <span class="unit-day">00</span> 天
  <span class="unit-day">00</span> :
  <span class="unit-day">00</span> :
  <span class="unit-day">00</span>
</div>
```

52px bold numbers, `unit-day` class for emphasis. The countdown creates urgency — a standard Chinese e-commerce pattern that Xiaomi executes with restraint (no blinking, no animation, just big numbers).

### 11.4 CTA Hierarchy

| CTA | Design | Context |
|-----|--------|---------|
| "立即预约" | Pill btn, orange fill, white text | Pre-sale reservation |
| "立即购买" | (store subdomain) | Buy Now on product pages |
| "了解更多" | Text link, orange color | Learn More (product pages) |
| Nav "小米商城" | Text link, white, hover orange | Persistent store access |

---

## 12. Footer Design

### 12.1 Desktop Footer

6-column link layout with service bar:

```
┌─────────────────────────────────────────────┐
│ [Icon] 1小时快修 [Icon] 7天无理由退货 ...     │ ← Service bar
│         (5 icons, 19.8% width each)          │    border-bottom
├─────────────────────────────────────────────┤
│ 选购手机   选购平板   选购笔记本   选购电视   │ ← Product links (4 cols)
│ ...        ...        ...         ...        │    160px each
│                         │ [Phone: 400-...]   │ ← Contact column (251px)
│                         │ [QR code]          │    border-left
├─────────────────────────────────────────────┤
│ [Logo] © mi.com 京ICP备... 京公网安备...     │ ← Legal/info
│ Slogan background image                      │    bg: #fafafa
└─────────────────────────────────────────────┘
```

### 12.2 Mobile Footer

Compact dark footer:

```
┌──────────────────────────────┐
│        了解小米  →           │ ← "About Xiaomi" link
│   (background image banner)  │    full-width, 2.06rem height
├──────────────────────────────┤
│       © mi.com               │ ← Legal text
│   [beian] 京公网安备...       │    centered, dark bg (#12151a)
│       京ICP备...              │    dimmed white text (30% opacity)
└──────────────────────────────┘
```

### 12.3 Footer Colors

| Element | Color |
|---------|-------|
| Service bar links | `#616161`, hover `#ff6900` |
| Link headings | `#424242`, 14px |
| Link items | `#757575`, 12px, hover `#ff6900` |
| Contact phone | `#ff6900`, 22px |
| Legal text | `#b0b0b0` (desktop), `hsla(0,0%,100%,0.3)` (mobile dark) |
| Section dividers | `#e0e0e0` |
| Background (desktop) | `#fafafa` |
| Background (mobile) | `#12151a` |

---

## 13. Design Patterns to Learn From

### 13.1 What Xiaomi Does Exceptionally Well

1. **The Stacked Carousel Homepage** — Instead of one hero + sections below, Xiaomi uses 10+ stacked carousels. Every product gets a hero moment. This creates an "endless premium catalog" feel.

2. **Viewport-Scaled Typography** — Rather than fixed breakpoints, Xiaomi uses `vw`-based `rem` units that smoothly scale the entire design from 320px to 2560px. This is more elegant and requires fewer breakpoint overrides.

3. **Custom Pagination as Brand Detail** — The wide, 3px-high progress-bar pagination bullets are unmistakably Xiaomi. A small detail that carries brand personality.

4. **Orange Discipline** — One accent color, used only for interactive states and CTAs. Never decorative. Always meaningful. This creates instant brand recognition.

5. **Separate Mobile Photography** — Xiaomi doesn't just resize images; they shoot completely different compositions for mobile (portrait) vs desktop (ultra-wide). This is expensive but creates a flawless experience on every device.

6. **CSS-Only Navigation Arrows** — Border-based triangles instead of SVG/PNG icons. Lighter, scalable, and themable with a single rule change.

7. **Time-Scheduled Content** — Carousels have `usefulTime` ranges, enabling campaign scheduling without code deploys. The homepage is a living content calendar.

8. **Ecosystem Narrative** — Every product reinforces the "人车家全生态" story. The final carousel explicitly ties cars, phones, and home devices together through HyperOS.

9. **Restraint in Animation** — Despite being a consumer tech site, Xiaomi uses minimal animation. No parallax, no scrolljacking, no WebGL flourishes. The product photography is confident enough to stand still.

### 13.2 Patterns Worth Adopting

| Pattern | Why It Works | How to Adapt |
|---------|-------------|--------------|
| Stacked carousel homepage | Every product gets equal hero treatment | Use multiple Swiper instances stacked vertically |
| Viewport-scaled rem typography | Fluid at every screen size | `html { font-size: calc(100vw / N) }` |
| Custom pagination bars | Distinctive brand detail | Override Swiper pagination renderer |
| Single-accent color strategy | Strong brand recall | Define ONE accent, use only for interactivity |
| CSS border-triangle arrows | Zero-image, themable navigation | `border-top/-left: 5px solid; transform: rotate()` |
| Mobile-specific image compositions | Perfect mobile experience | Serve different image URLs per breakpoint |
| Content scheduling via timestamps | Campaign management without code | Store visibility windows in CMS, filter by `Date.now()` |
| Pill-shaped CTAs on dark backgrounds | Visual pop without gradients | `border-radius: 50% of height`, solid accent fill |

### 13.3 Anti-Patterns Xiaomi Avoids

- No gradient buttons (solid orange is more confident on dark backgrounds)
- No decorative borders (product photography provides all the visual interest)
- No simultaneous Chinese+English rendering (mixed-script within same element, not side-by-side columns)
- No auto-playing video (static images with optional play buttons)
- No cookie consent banners (Chinese regulatory environment differs)
- No elaborate mega menus (10 simple nav links, depth handled by subdomains)
- No dark mode toggle (committed to dark by default)

---

## 14. Extracted Design Tokens (CSS Custom Properties Format)

```css
:root {
  /* === Colors === */
  --mi-bg-black:              #000000;
  --mi-bg-near-black:         #12151a;
  --mi-bg-nav-overlay:        rgba(0, 0, 0, 0.85);
  --mi-bg-footer-light:       #fafafa;
  --mi-bg-white:              #ffffff;

  --mi-accent-primary:        #ff6900;
  --mi-accent-secondary:      #ff6700;
  --mi-accent-hover-dark:     #f25807;

  --mi-text-white:            #ffffff;
  --mi-text-dimmed-strong:    hsla(0, 0%, 100%, 0.8);
  --mi-text-dimmed:           hsla(0, 0%, 100%, 0.3);
  --mi-text-dark:             #000000;
  --mi-text-body:             #616161;
  --mi-text-heading:          #424242;
  --mi-text-link:             #757575;
  --mi-text-legal:            #b0b0b0;
  --mi-text-mobile-nav:       #cccccc;

  --mi-border-light:          #e0e0e0;
  --mi-border-mobile:         hsla(0, 0%, 100%, 0.3);

  --mi-overlay-backdrop:      rgba(0, 0, 0, 0.3725);

  --mi-pagination-active:     #ff6900;
  --mi-pagination-inactive:   #b2b2b2;

  /* === Typography === */
  --mi-font-primary:          'MiSans', serif;
  --mi-font-brand:            'MI Lan Pro', serif;
  --mi-font-weight-light:     300;
  --mi-font-weight-regular:   400;
  --mi-font-weight-medium:    500;
  --mi-font-weight-semibold:  600;
  --mi-font-weight-bold:      700;

  --mi-text-xs:               12px;
  --mi-text-sm:               14px;
  --mi-text-base:             16px;
  --mi-text-lg:                18px;
  --mi-text-xl:                22px;
  --mi-text-2xl:              24px;
  --mi-text-hero-title:       ~40px;  /* 0.315rem at 75px/rem base */
  --mi-text-hero-subtitle:    ~24px;  /* 0.188rem at 75px/rem base */
  --mi-text-countdown:        52px;

  --mi-content-width:         1226px;  /* Text content width */
  --mi-page-max-width:        2560px;
  --mi-header-max-width:      1440px;

  /* === Spacing === */
  --mi-header-height:         65px;
  --mi-header-height-mobile:  1.45rem;  /* ~55px */
  --mi-nav-item-gap:          20px;
  --mi-nav-item-gap-md:       10px;
  --mi-nav-item-gap-sm:       6px;

  /* === Border Radius === */
  --mi-radius-pill:           22px;    /* CTA buttons */
  --mi-radius-dialog:         8px;     /* Modal dialogs */
  --mi-radius-card:           0.4rem; /* Product cards */
  --mi-radius-sharp:          0;       /* Pagination bullets */

  /* === Button Sizes === */
  --mi-btn-cta-width:         224px;
  --mi-btn-cta-height:        44px;
  --mi-btn-sm-width:          118px;
  --mi-btn-sm-height:         28px;
  --mi-btn-confirm-width:     130px;
  --mi-btn-confirm-height:    45px;

  /* === Motion === */
  --mi-duration-fast:         100ms;
  --mi-duration-normal:       300ms;
  --mi-duration-slow:         500ms;
  --mi-duration-reveal:       600ms;
  --mi-easing-default:        ease;
  --mi-easing-in-out:         ease-in-out;

  /* === Z-Index === */
  --mi-z-content:             1;
  --mi-z-header:              99;
  --mi-z-dialog-backdrop:     99;
  --mi-z-dialog:              100;
  --mi-z-scroll-top:          100;

  /* === Viewport Scaling === */
  --mi-base-desktop:          5.208203125vw;    /* html font-size */
  --mi-base-cap:              133.33px;         /* ≥2560px */
  --mi-base-mobile:           9.2592592593vw;    /* ≤800px */
  --mi-base-component:        1vw;              /* Per-component override */
}
```

---

## 15. Summary: The Xiaomi Design Formula

Xiaomi's product marketing pages succeed because they follow a consistent formula:

```
DARK CANVAS (full black, cinematic)
    +
FULL-BLEED PRODUCT PHOTOGRAPHY (different composition per device)
    +
STACKED CAROUSEL STRUCTURE (every product gets a hero moment)
    +
ORANGE ACCENT DISCIPLINE (only for interactivity, never decoration)
    +
VIEWPORT-SCALED TYPOGRAPHY (fluid from phone to ultrawide)
    +
MINIMAL ANIMATION (0.1-0.6s, no parallax, no scrolljacking)
    +
ECOSYSTEM NARRATIVE (人车家 — every product connected)
    +
PILL CTAs ON DARK (solid orange, no gradients, confident)
    +
CUSTOM PAGINATION BARS (wide, thin, orange — unmistakably Xiaomi)
    +
CSR-FIRST WITH SSR SHELL (Vue.js, Swiper.js, time-scheduled content)
    =
CHINESE CONSUMER TECH MARKETING EXCELLENCE
```

The emotional arc: **Aspiration** (car hero) → **Mobile Lifestyle** (phone carousels) → **Productivity & Entertainment** (tablet + Redmi) → **Smart Living** (AIoT grid) → **Creativity** (Imaging Award) → **Platform** (HyperOS) → **Ecosystem Vision** (Human-Car-Home).

Where Western tech brands (Apple, Google) minimize and whisper, Xiaomi maximizes and declares — but with the same level of craft and intentionality. The result is design that feels abundant rather than cluttered, vibrant rather than loud, and distinctively Chinese rather than generically international.

---

## 16. Comparison: Xiaomi vs DJI vs Linear vs Apple

| Dimension | Xiaomi | DJI | Linear | Apple |
|-----------|--------|-----|--------|-------|
| **Background** | Full black (#000) | Alternating dark/light | Near-black (#08090a) | White + product colors |
| **Accent** | Single orange (#ff6900) | Product-dependent | Single indigo (#7170ff) | Product-dependent |
| **Typography** | Custom MiSans + Mi Lan Pro | Open Sans Semibold | Custom Inter Variable (510/590/680) | SF Pro + SF Display |
| **Hero pattern** | Stacked carousels (10+) | Single carousel (5-7 slides) | Static hero + video bg | Single product hero |
| **Animation** | Minimal (0.1-0.6s) | Minimal (0.3s ease) | CSS-only (0.1-30s) | Elaborate scroll-driven |
| **Information density** | High (Chinese market) | Medium | Low (tool/product) | Low |
| **Button style** | Pill, solid orange | Gradient (-180deg) | Invert (white on dark) | Flat, rounded |
| **Navigation** | 10 simple links | 7 categories + mega menus | 6 links + dropdown | 10 links + search |
| **Content width** | 1226-2560px | 1200px | 1024-1344px | ~980px (estimated) |
| **Bilingual** | Mixed-script, same element | Locale-native, separate rendering | English-only (mostly) | Per-locale, consistent |

Xiaomi's design sits at the intersection of Chinese consumer culture (high information density, ecosystem thinking, warm accent colors) and global tech aesthetics (dark backgrounds, precision typography, confident photography). It demonstrates that "premium" does not require "minimal" — information richness and visual restraint can coexist when every element earns its place.
