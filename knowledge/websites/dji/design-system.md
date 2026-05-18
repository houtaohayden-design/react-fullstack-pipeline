# DJI.com Complete Design System

> Extracted: 2026-05-18 | URL: https://www.dji.com | Slug: dji
> Category: design-inspiration | Type: Consumer Tech Product Marketing
> Tech stack: jQuery + Swiper.js (homepage), Next.js + React (product pages), custom DUI component library

---

## Executive Summary

DJI.com represents the pinnacle of premium Chinese tech product marketing — a masterful blend of Western minimalist restraint and Eastern visual richness. The design language communicates **engineering precision**, **aerial perspective**, and **cinematic drama** simultaneously. Every design choice serves the product: drones and cameras are the hero, and the interface recedes to let them dominate the viewport.

### Core Design Philosophy

DJI's design system operates on three pillars:

1. **The Product Is the Hero** — Full-bleed photography, 3D product rotations, and large-scale video backgrounds. The UI never competes with the product for attention.
2. **Dark-Theme Dominance** — Dark backgrounds make product photography pop, reduce visual noise, and signal premium positioning.
3. **Bilingual Fluidity** — Chinese and English typography coexist naturally. Every page supports 30+ locale variants through a hreflang infrastructure.

### What Makes DJI's Design Compelling

DJI succeeds where many tech brands fail because:

- **Precision meets drama**: Engineering spec layouts that feel cinematic, not like datasheets
- **Scale contrast**: Hero images that dwarf navigation create an immediate sense of product importance
- **Accent restraint**: One signature warm accent (gold/amber) used sparingly against vast dark/neutral spaces
- **Bilingual harmony**: Chinese characters and Latin text sit together without visual friction
- **Scroll reveals that teach**: Feature sections unfold like product tutorial — each scroll reveals not just a new visual but a new capability

---

## 1. Color System

### 1.1 Core Palette

```
/* Dark Theme (Primary — ~80% of page real estate) */
--dj-bg-primary:        #000000     /* Full black — hero backgrounds, nav in collapsed state */
--dj-bg-secondary:      #0a0a0a     /* Near-black — section backgrounds */
--dj-bg-tertiary:       #111111     /* Dark gray — card backgrounds, alternating sections */
--dj-bg-surface:        #1a1a1a     /* Slightly lighter — elevated surfaces */

/* Light Theme (~15% of page real estate) */
--dj-bg-light:          #f5f5f5     /* Light section backgrounds */
--dj-bg-white:          #ffffff     /* Pure white — product detail pages, sticky nav */

/* Text Colors */
--dj-text-primary:      #ffffff     /* White on dark */
--dj-text-primary-dark: #000000     /* Black on light — hero eyebrows, light-theme slides */
--dj-text-secondary:    rgba(255,255,255,0.65)  /* Dimmed white — hover states */
--dj-text-secondary-dark: rgba(0,0,0,0.85)      /* Dimmed black — sticky-white nav */
--dj-text-body:         #303233     /* Dark gray — learn-more links, body text */

/* Accent */
--dj-accent-buy:        #1e9df7     /* Blue — Buy Now buttons */
--dj-accent-buy-hover:  #4cb5ff     /* Lighter blue — Buy hover */
--dj-accent-buy-dark:   #1392ed     /* Darker blue — Buy gradient bottom */

/* Button Colors */
--dj-btn-gradient-top:    #3c3e40  /* Dark gray gradient top */
--dj-btn-gradient-bottom: #303233  /* Dark gray gradient bottom */
--dj-btn-hover-top:       #545759  /* Lighter hover gradient top */
--dj-btn-hover-bottom:    #303233  /* Same hover gradient bottom */
```

### 1.2 Color Roles & Usage

| Role | Color | Usage |
|------|-------|-------|
| Hero background (dark) | `#000` | Video/photo hero sections on homepage |
| Hero background (light) | Image-specific | Light-theme slides alternate with dark for rhythm |
| Nav collapsed | Transparent → `#fff` text | Initial state on homepage |
| Nav sticky-white | `#fff` bg, `rgba(0,0,0,.85)` text | Scroll-down state |
| Primary CTA | `#1e9df7 → #1392ed` gradient | "立即购买" (Buy Now) button |
| Secondary CTA | `#3c3e40 → #303233` gradient | "了解更多" (Learn More) button |
| Link | `#303233` | `dui-learn-more` text links |

### 1.3 DJI's Signature Accent

DJI does NOT use a single signature accent across its website. Instead:

- **Product-accent coordination**: Each product page adopts the product's own color identity
  - Mavic series: Dark charcoal + white + subtle warm tones from photography
  - Osmo series: Often lighter, outdoor-action oriented palettes
  - Power stations: Industrial gray + safety yellow hints
- **The "DJI Gold"**: While the website itself is monochrome-dominant, DJI's brand gold/amber appears in the logo and packaging — the website lets products carry their own color stories

### 1.4 Section Background Alternation

DJI creates visual rhythm through deliberate background alternation:

```
Section 1: Full black (hero carousel)
Section 2: Near-black (#0a0a0a) or product photography background
Section 3: White/light gray (light theme slide)
Section 4: Dark again
```

This light-dark-light-dark alternation prevents visual monotony on long-scrolling pages.

### 1.5 Gradient Usage

Gradients are subtle and functional, never decorative:

```css
/* Button gradients — 3D depth effect */
background-image: linear-gradient(-180deg, #3c3e40 0%, #303233 100%);

/* Buy button — attention gradient */
background-image: linear-gradient(-180deg, #1e9df7 0%, #1392ed 100%);

/* Hover — lift effect via lighter top */
background-image: linear-gradient(-180deg, #545759 0%, #303233 100%);
```

All gradients use `-180deg` (top-to-bottom), creating a subtle 3D button effect with light hitting from above.

---

## 2. Typography System

### 2.1 Font Stack

```
/* Primary (Latin) */
font-family: 'Open Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif;

/* Product pages load specific weights */
OpenSans-Semibold (woff2) — for headings and emphasis

/* Icons */
FontAwesome 4.4.0 — for UI icons (arrows, social, etc.)
DJI Atom Icon Light — for product-specific icons on Next.js pages
```

### 2.2 Chinese + English Bilingual Typography

DJI's bilingual approach is one of their strongest design features:

| Element | Chinese | English/Latin |
|---------|---------|---------------|
| Nav links | 中文 | Class `font-opensans` for Latin fallback |
| Hero eyebrow | Chinese description | English product names integrate seamlessly |
| Hero slogan | Poetic Chinese (e.g., "天地为你所动") | Translates to poetic English on EN locale |
| Product names | Brand names in English | "MAVIC 4 PRO" as SVG logos |
| Body text | Chinese throughout on CN site | Full English on US/global sites |

**Bilingual layout strategy**: Rather than displaying both languages simultaneously, DJI uses locale-specific rendering. The CN site is predominantly Chinese with English product names as branded logos. The EN site is fully English. Both feel native, not translated.

### 2.3 Size Hierarchy

```
Hero Product Logo (SVG):    32px height (renders as scalable vector)
Hero Eyebrow Text:           ~14-16px, uppercase feel (Chinese characters)
Hero Slogan:                 ~24-36px (h3), poetic and impactful
Navigation Links:            14px (desktop nav items)
Button Text:                 16px (standard), 14px (small)
Body/Learn More:             16px
Footer:                      12-14px

Button Heights:
  Standard: 46px height, 15px 32px padding, 16px font
  Small:    30px height, 8px 16px padding, 14px font
```

### 2.4 Font Weights

```
Regular:  400  — Body text, descriptions
Semibold: 600  — Headings, buttons, navigation, learn-more links
Bold:     700  — Reserved for emphasis
```

The `OpenSans-Semibold.woff2` file is explicitly preloaded on product pages, indicating its importance as the primary emphasis weight.

### 2.5 Hero Typography Pattern

Each carousel slide follows a precise typographic sequence:

```
1. EYEBROW (small, category descriptor)
   └─ "三摄旗舰影像航拍机" / "四发内录迷你无线麦克风"

2. PRODUCT LOGO (SVG, 32px height, scalable)
   └─ Acts as the h1 visual — product name as brand mark

3. SLOGAN (h3, impactful)
   └─ "天地为你所动" / "尽显风光" / "声无巨细，尽收其中"

4. CTA BUTTONS
   └─ "了解更多" + "立即购买" (Learn More + Buy Now)
```

### 2.6 Accessibility Typography

```html
<h1 class="visuallyhidden">DJI 大疆创新官网</h1>
<h2 class="visuallyhidden">MAVIC 3</h2>
```

Critical headings exist in the DOM for screen readers but are visually hidden — the visual hierarchy relies on images and SVGs, but the document outline remains accessible.

---

## 3. Layout & Spacing System

### 3.1 Grid System

DJI uses a custom 12-column flexbox grid:

```css
.grid-container {
  width: 1200px;
  margin: 0 auto;
}

/* Responsive: At ≤768px, grid goes full-width */
@media (max-width: 768px) {
  .grid-container { width: 100%; }
}

/* Column structure */
.cell.is-6  { flex-basis: 50%; max-width: 50%; }
.cell.is-4  { flex-basis: 33.33%; max-width: 33.33%; }
.cell.is-3  { flex-basis: 25%; max-width: 25%; }
/* ... full 1-12 range */
```

Grid alignment modifiers:
- `.top` / `.middle` / `.bottom` — vertical alignment
- `.left` / `.center` / `.right` / `.between` / `.around` — horizontal distribution

### 3.2 Section Rhythm

```
Section padding:     ~80-120px vertical (estimated from full-viewport sections)
Content max-width:   1200px (grid container)
Nav height:          64px (fixed)
Hero height:         100vh (full viewport)
```

### 3.3 Product Image Sizing

- **Hero product images**: Full-bleed, viewport-filling. Drone/camera centered, shot against sky or dark studio background. Product typically occupies 40-60% of frame.
- **Feature section images**: Large (800-1200px wide), detail-focused — close-ups of camera arrays, gimbal mechanics, propellers.
- **Thumbnail/card images**: Medium (300-600px), consistent aspect ratio within each section.

### 3.4 Card Design Patterns

DJI's product cards follow a consistent pattern:

```
┌──────────────────────────┐
│                          │
│    [Product Image]       │  ← Large, dominant photo
│    (dark bg or cutout)   │
│                          │
├──────────────────────────┤
│  PRODUCT NAME            │  ← Bold, centered or left-aligned
│  Short description line  │  ← Gray, smaller
│                          │
│  [Learn More →] [Buy →]  │  ← Dual CTAs
└──────────────────────────┘
```

Card characteristics:
- Minimal borders — separation by spacing and background contrast, not lines
- Rounded corners: `border-radius: 2px` (near-sharp — engineering precision feel)
- Subtle hover: CTA buttons change gradient, product images may have slight scale transform (inferred from Apple-like product page patterns)

### 3.5 Spacing Scale

```
2px   — Border radius (near-sharp corners)
8px   — Small gaps, icon spacing
10px  — Grid gutter half (20px total)
16px  — Button small padding, standard inline spacing
20px  — Grid gutter total
32px  — Button standard horizontal padding
64px  — Nav height
1200px — Max content width
```

---

## 4. Hero Section Design

### 4.1 Hero Architecture

DJI's homepage hero is a **Swiper.js carousel**, not a single static hero:

```html
<section class="homepage-banner homepage-big-banner">
  <div class="swiper-container banner-swiper-container">
    <!-- Prev/Next controls -->
    <div class="swiper-wrapper">
      <!-- Multiple slides, each full-viewport -->
      <div class="swiper-slide" data-theme="dark|light">
        <div class="banner-content theme-dark|light">
          <!-- Background image with image-set for responsive loading -->
          <div class="banner-text">
            <div class="eyebrow-text">Category descriptor</div>
            <img class="banner-logo">   <!-- SVG product logo -->
            <h3 class="banner-slogan">   <!-- Poetic tagline -->
          </div>
          <div class="banner-btn-box">
            <!-- Dual CTAs per slide -->
          </div>
        </div>
      </div>
    </div>
  </div>
</section>
```

### 4.2 Hero Background Strategy

- **Static photography preferred over video** — DJI uses high-resolution product photography (JPG) with `image-set` for 2x retina support
- **Full-bleed images** — Products shot aerially or against dramatic skies
- **Dark slides** (`data-theme="dark"`) — White text, dark product photography, `fill-opacity: .85` SVG icons
- **Light slides** (`data-theme="light"`) — Black text, lighter product photography (sky backgrounds)

### 4.3 Hero Text Placement

- **Eyebrow**: Top of text block, small, descriptive — sets context
- **Logo**: Center, SVG product name — the visual h1 (32px height)
- **Slogan**: Below logo, h3, poetic Chinese — emotional hook
- **CTAs**: Below slogan, dual button pair — Learn More + Buy Now

Vertical alignment: Text block is centered-left or centered within the slide, allowing the product image (background) to dominate the remaining space.

### 4.4 CTA Design

Two buttons per hero slide:

```html
<a class="banner-button">  <!-- Standard dark gradient -->
  <div class="text">了解更多</div>
  <div class="icon fa fa-angle-right"></div>
</a>

<a class="banner-button">  <!-- Blue gradient buy button -->
  <div class="text">立即购买</div>
  <div class="icon fa fa-angle-right"></div>
</a>
```

Pattern: Dual CTA with hierarchy — Learn More (secondary, dark) + Buy Now (primary, blue). Both use `fa-angle-right` arrow icon to reinforce forward momentum.

### 4.5 Carousel Navigation

- **Swiper prev/next**: Custom styled arrow buttons
- **Pagination**: Swiper pagination bullets at bottom
- **Autoplay**: Likely configured for auto-rotation (standard product hero pattern)
- **Theme-aware**: Controls adapt color based on `data-theme`

---

## 5. Navigation System

### 5.1 Desktop Navigation Structure

```html
<nav id="site-header" class="dui-navbar site-header collapsed">
  <!-- Logo (left) -->
  <div class="navbar-header">
    <a class="navbar-brand"><span class="navbar-brand-logo"></span></a>
  </div>

  <!-- Category links (center-left) -->
  <ul class="navbar-category">
    <li>航拍无人机 (Camera Drones)</li>
    <li>手持摄影设备 (Handheld)</li>
    <li>储能及家居科技 (Power & Home Tech)</li>
    <li>商用产品及方案 (Enterprise)</li>
    <li>探索精彩 (Explore)</li>
    <li>服务与支持 (Support)</li>
    <li>购买渠道 (Where to Buy)</li>
  </ul>

  <!-- Right-side utilities -->
  <ul class="navbar-right">
    <li>Search</li>
    <li>User/Account</li>
    <li>Language/Region selector</li>
    <li>Store button (商城)</li>
  </ul>
</nav>
```

### 5.2 Sticky Header Behavior

DJI's nav has a sophisticated multi-state system:

| State | Class | Behavior |
|-------|-------|----------|
| Initial (homepage) | `collapsed` | Transparent bg, white text/icons, absolute positioned |
| Scrolled | `sticky-nav` | Fixed, dark semi-transparent bg, white text, z-index: 900 |
| Light pages | `sticky-white-nav` | White bg, dark text `rgba(0,0,0,.85)`, full shadow |
| Dark pages | `theme-dark` | Transparent/adaptive, black text |
| Search active | `navbar-searching` | White bg, search input expanded |

Height: **64px** consistently.

### 5.3 Mega Menu (Dropdown)

Categories with sub-items use `.dui-dropdown-menu`:

```html
<div class="dui-dropdown-menu commercial">
  <div class="menu-container">
    <div class="content-container">
      <!-- Tabbed or list-based sub-navigation -->
    </div>
  </div>
</div>
```

Mega menu characteristics:
- Full-width container (min-width: 1230px on sticky)
- Content aligns within the 1200px grid
- Scroll-contained: `max-height: calc(100vh - 64px)`, `overflow-y: auto`
- Enterprise section has additional padding: `calc(100vh - 128px)` max-height

### 5.4 Mobile Navigation

Served via separate mobile subdomain:
```html
<link rel="alternate" media="only screen and (max-width: 414px)"
      href="https://www.dji.com/cn/mobile">
```

Mobile nav uses:
- Hamburger menu (`.collapse-button`)
- Full-screen overlay navigation
- Dedicated mobile search page
- Mobile-specific store button
- Separate mobile CSS and markup

### 5.5 Nav Color Transitions

```
[Homepage top: transparent → collapsed: white text]
         ↓ scroll
[Fixed: sticky-nav → white text on semi-transparent]
         ↓ on light pages
[Fixed: sticky-white-nav → black text on white bg]
```

The `navbar-brand-logo` swaps via background-image based on state (inline SVG base64 in CSS).

### 5.6 Search Experience

- Search icon in nav bar (SVG icon)
- Click triggers `.navbar-searching` state
- Full-width search overlay with:
  - Search input (`placeholder="搜索 dji.com..."`)
  - Quick links ("快速链接")
  - Search suggestions ("搜索结果建议")
  - Close button
- Form action: `GET /search?q=...`

---

## 6. Motion & Animation System

### 6.1 Carousel Transition

- **Technology**: Swiper.js (v3 era)
- **Transition**: Slide-based, `transition-property: transform`
- **Timing**: `ease-out` for free mode
- **3D support**: Swiper cube and coverflow effects available in the CSS

### 6.2 Button Hover Effects

```css
transition: all .3s ease;

/* From CSS — all interactive elements use 300ms easing */
```

- Gradient swap on hover (light top simulates light hitting the button)
- No scale transforms (consistent with engineering-precision aesthetic)
- `.fa-angle-right` arrow provides inherent forward-motion cue

### 6.3 Scroll-Driven Reveals

Inferred from the swiper lazy-loading and DJI's general approach:

- **Lazy loading**: `swiper-lazy` class for deferred image loading with preloader spinner
- **Scroll reveal**: Product feature sections likely use IntersectionObserver or scroll-triggered reveals (common in tech product marketing)
- **Preload priority**: Critical hero images marked `fetchpriority="high"` with explicit `data-prophet-rank` values for predictive loading

### 6.4 Image Loading Strategy

```html
<!-- 2x image-set for retina -->
<div style="
  background-image: url(image@1x.jpg);
  background-image: -webkit-image-set(
    url(image@1x.jpg) 1x,
    url(image@2x.jpg) 2x
  );
  background-image: image-set(
    url(image@1x.jpg) 1x,
    url(image@2x.jpg) 2x
  );
">
```

### 6.5 Transition Tokens

```css
/* All interactive transitions */
transition: all 0.3s ease;

/* Nav collapse/expand */
transition: all 0.3s ease;

/* Swiper pagination */
transition: 300ms;  /* transform transitions */
```

DJI uses a single consistent transition duration: **300ms** with **ease** timing. This is a deliberate choice for engineering-brand consistency — no playful overshoot, no spring physics, just clean precision.

---

## 7. Product Showcase Patterns

### 7.1 Hero Carousel (Product Spotlight)

Multi-slide carousel where each slide features one flagship product. Products are rotated based on marketing priority. Each slide has:
- Product name as SVG logo (brand-consistent typography)
- Descriptive eyebrow text
- Emotional/promotional slogan
- Background photograph showing product in dramatic context
- Dual CTA buttons

### 7.2 Product Grid Layout

Inferred from the navigation structure and product category pages:

```
Grid: 3-4 columns
Each cell:
  - Product hero image (large, centered, transparent or dark bg)
  - Product name
  - Key spec highlight (e.g., "4K/120fps", "46min flight")
  - Price (on store pages)
  - CTA button(s)
```

### 7.3 Feature Highlight Sections

Product pages (Next.js-based) use a scroll-driven feature reveal pattern:

```
Section: HERO (full viewport product shot)
  ↓
Section: KEY FEATURE 1 (large product detail image + headline + description)
  ↓
Section: KEY FEATURE 2 (alternating image/text layout)
  ↓
Section: TECH SPECS (grid or comparison format)
  ↓
Section: ECOSYSTEM (accessories shown in context)
  ↓
Section: BUY NOW (pricing grid + CTA)
```

### 7.4 Specification Display

Tech specs are presented as clean comparison grids or feature cards, not dense tables. DJI's spec presentation uses:
- **Icon + value** pairs for key metrics
- **Comparison tables** for SKU variants (e.g., different combo packages)
- **Visual specs** — when possible, specs are shown as overlays on product images rather than text alone

### 7.5 Purchase Flow

```
Product Page → [立即购买] button → store.dji.com/cn/product/<slug>
                                     ↓
                              Pricing tier selection
                                     ↓
                              Combo/package selection
                                     ↓
                              Add to cart → Checkout
```

The "商城" (Store) button in the nav provides persistent access to the e-commerce experience.

### 7.6 Accessory Ecosystem Display

- Accessories shown in context with primary product
- "Commonly bought together" or "Recommended accessories" sections
- Each accessory treated as a mini product card

---

## 8. Component Library (DUI Framework)

DJI uses a custom internal component library called **DUI** (DJI UI).

### 8.1 Button (`dui-btn`)

```css
.dui-btn {
  display: inline-block;
  color: #fff;
  height: 46px;
  font-size: 16px;
  line-height: 16px;
  padding: 15px 32px;
  border: none;
  border-radius: 2px;
  outline: none;
  cursor: pointer;
  transition: all 0.3s ease;
}

/* Variants */
.dui-btn-sm       { height: 30px; font-size: 14px; padding: 8px 16px; }
.dui-btn-primary  { /* dark gradient */ }
.dui-btn-normal   { /* dark gradient */ }
.dui-btn-buy      { /* blue gradient */ }
```

### 8.2 Learn More Link (`dui-learn-more`)

```css
.dui-learn-more {
  display: inline-block;
  font-size: 16px;
  font-weight: 600;
  line-height: 46px;
  height: 46px;
  color: #303233;
  cursor: pointer;
}
```

### 8.3 Navbar (`dui-navbar`)

```css
.dui-navbar {
  position: absolute;  /* becomes fixed via .sticky-nav */
  width: 100%;
  height: 64px;
  top: 0;
  left: 0;
  z-index: 900;
}
```

### 8.4 Dropdown (`dui-dropdown-menu`)

Mega menu and simple dropdown variants, used in navigation and user menus.

### 8.5 Lazy Loading (`dui-lazy`)

Custom lazy-loading attributes:
```
dui-lazy-src="{{avatar}}"  — template-based deferred image loading
```

### 8.6 Click Delegation (`dui-click`)

```
dui-click="searchOn"   — opens search
dui-click="searchOff"  — closes search
dui-click="logout"     — triggers logout
```

### 8.7 Data Attributes

```html
data-ga-category="pc_nav_V2"
data-ga-action="click,mouseenter"
data-ga-action-name="click=click,mouseenter=hover"
data-ga-label="top-level-航拍无人机"
```

DJI uses a sophisticated Google Analytics tracking system with per-element category/action/label attributes.

---

## 9. Technology Architecture

### 9.1 Frontend Stack

| Layer | Technology |
|-------|-----------|
| Homepage | jQuery 2.1.4 + Swiper.js + Custom DUI framework |
| Product pages | Next.js (React SSR) + CSS Modules |
| CDN | `www-cdn.djiits.com` (DJI Intelligent Technology Services) |
| CSS | Custom build pipeline (minified, hashed filenames) |
| Fonts | FontAwesome 4.4.0 + OpenSans + DJI Atom Icon |
| Analytics | Google Analytics with custom data-attribute system |
| A/B testing | Custom ABTest JavaScript framework |

### 9.2 Build Pipeline

```
Source CSS → build/ → minified with content hash
  v3.base.min-573c73fa0700df2dca9bc979c4dbb03e.css
  www.header-v4.min-b9cead8c66063dd15abdec6a75eaca25.css
  www.homepage.min-52913da765f8ad6b566500e9bde8b33f.css

Product pages (Next.js):
  _app.js.f7ef6d04.chunk.css
  pages/page/product.js.9efeadb0.chunk.css
```

### 9.3 Internationalization

- **30+ locale variants** via `hreflang` alternates
- Separate homepage HTML per locale (or locale-specific rendering)
- Chinese (zh-CN), English (en-*), German (de-*), French (fr-*), Spanish (es-*), Italian (it-*), Japanese (ja-JP), Korean (ko-KR), Portuguese (pt-BR), Russian (ru-RU)
- Mobile versions served from subdomains or `/mobile` paths

---

## 10. Design Patterns to Learn From

### 10.1 What DJI Does Exceptionally Well

1. **Product-as-hero with zero UI competition** — The navigation and UI elements are present but visually recede. The product dominates >70% of every hero viewport.

2. **Dual CTA that works** — "Learn More" + "Buy Now" is a common pattern, but DJI's execution (subtle dark gradient + blue attention gradient) creates clear hierarchy without being pushy.

3. **Carousel as content rhythm** — Using a carousel for the hero isn't just about showing multiple products. It creates visual rhythm through light/dark theme alternation.

4. **SVG product logos** — Using actual SVG files for product name logos (not just text) ensures perfect brand typography regardless of system fonts. These scale perfectly at 32px height.

5. **Bilingual design that doesn't feel translated** — The CN and EN sites feel native, not like one was translated from the other. Different type treatments, different emotional tone in slogans.

6. **2px border-radius everywhere** — In an era of 8-16px rounded corners, DJI's near-sharp corners communicate precision engineering. This is intentional brand character.

7. **Gradient buttons as depth** — Button gradients aren't decorative; they simulate light hitting a 3D surface (all `-180deg` top-to-bottom).

### 10.2 Patterns Worth Adopting

| Pattern | Why It Works | How to Adapt |
|---------|-------------|--------------|
| Hero carousel with theme alternation | Prevents monotony on scroll-heavy pages | Use `data-theme` attribute, swap text/icon colors via CSS |
| SVG product logos as h1 | Consistent brand typography without web fonts | Create SVG wordmarks for product names |
| Dual gradient CTAs with clear hierarchy | Users instantly know which action is primary | Secondary: dark/subtle gradient. Primary: brand accent gradient |
| `image-set` for responsive backgrounds | Serves correct resolution without JS | Use CSS `image-set()` or `<picture>` for backgrounds |
| 2px border-radius precision aesthetic | Communicates engineering brand values | Match border-radius to brand personality — sharp for precision, round for friendly |
| 300ms single transition duration | Consistent motion language | Define a single `--duration-normal` token and use everywhere |
| Preload critical assets with priority hints | Perceived performance | `fetchpriority="high"` + `<link rel="preload">` for hero images |

### 10.3 Anti-Patterns DJI Avoids

- No excessive rounded corners (precision brand)
- No decorative gradients (functional only)
- No bouncing/overshooting animations (engineering precision)
- No cluttered navigation (7 top-level items with mega menus for depth)
- No simultaneous Chinese+English display (locale-native rendering)
- No auto-playing video (static photography preferred — less distracting, better performance)

---

## 11. Extracted Design Tokens (CSS Custom Properties Format)

```css
:root {
  /* === Colors === */
  --dj-bg-black:          #000000;
  --dj-bg-near-black:     #0a0a0a;
  --dj-bg-dark:           #111111;
  --dj-bg-surface:        #1a1a1a;
  --dj-bg-light:          #f5f5f5;
  --dj-bg-white:          #ffffff;

  --dj-text-white:        #ffffff;
  --dj-text-black:        #000000;
  --dj-text-dimmed:       rgba(255, 255, 255, 0.65);
  --dj-text-dimmed-dark:  rgba(0, 0, 0, 0.85);
  --dj-text-body:         #303233;

  --dj-accent-buy:        #1e9df7;
  --dj-accent-buy-hover:  #4cb5ff;
  --dj-accent-buy-dark:   #1392ed;

  --dj-btn-gradient-top:     #3c3e40;
  --dj-btn-gradient-bottom:  #303233;
  --dj-btn-hover-gradient-top: #545759;

  /* === Typography === */
  --dj-font-primary:      'Open Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif;
  --dj-font-weight-regular:   400;
  --dj-font-weight-semibold:  600;
  --dj-font-weight-bold:      700;

  --dj-text-xs:           12px;
  --dj-text-sm:           14px;
  --dj-text-base:         16px;
  --dj-text-lg:           24px;
  --dj-text-xl:           32px;
  --dj-text-hero-logo:    32px;  /* SVG height, not font-size */

  /* === Spacing === */
  --dj-radius:            2px;
  --dj-space-xs:          8px;
  --dj-space-sm:          16px;
  --dj-space-md:          20px;
  --dj-space-lg:          32px;
  --dj-space-xl:          64px;
  --dj-space-2xl:         80px;

  --dj-nav-height:        64px;
  --dj-content-max-width: 1200px;

  /* === Motion === */
  --dj-duration-normal:   300ms;
  --dj-easing:            ease;

  /* === Buttons === */
  --dj-btn-height:        46px;
  --dj-btn-height-sm:     30px;
  --dj-btn-padding-x:     32px;
  --dj-btn-padding-y:     15px;
  --dj-btn-padding-sm-x:  16px;
  --dj-btn-padding-sm-y:  8px;

  /* === Z-Index === */
  --dj-z-nav:             900;
  --dj-z-dropdown:        901;
  --dj-z-modal:           1000;
  --dj-z-overlay:         950;
}
```

---

## 12. Summary: The DJI Design Formula

DJI's product marketing pages succeed because they follow a consistent formula:

```
DARK CANVAS
    +
HERO PRODUCT PHOTOGRAPHY (40-60% of viewport)
    +
MINIMAL UI (receding, transparent/white/black)
    +
SINGLE FOCAL ELEMENT PER SECTION (one feature, one image, one message)
    +
POETIC SLOGAN (emotional hook, 6-8 Chinese characters)
    +
DUAL CTA (Learn More + Buy Now, clear hierarchy)
    +
PRECISION DETAILS (2px radius, 300ms transitions, -180deg gradients)
    +
LIGHT-DARK ALTERNATION (section rhythm)
    +
NATIVE-LOCALE TYPOGRAPHY (not side-by-side bilingual)
    =
PREMIUM TECH PRODUCT MARKETING
```

The emotional arc: **Aspiration** (hero slogan) → **Capability** (feature reveals) → **Specification** (tech details) → **Acquisition** (buy now / pricing).

Every pixel, every gradient direction, every millisecond of transition is intentional. Nothing is decorative. Everything serves the product.
