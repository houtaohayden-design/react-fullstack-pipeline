# Apple.com Design System — Complete Reference

> **URL**: https://www.apple.com  
> **Type**: Product Marketing / Consumer Product  
> **Extracted**: 2026-05-18  
> **Category**: design-inspiration  

Apple.com represents 25+ years of design refinement in product marketing. It is NOT a SaaS app — it's a cinematic product showcase where every pixel, animation frame, and interaction serves to make products feel desirable and premium.

---

## Table of Contents

1. [Design Philosophy](#1-design-philosophy)
2. [Typography System](#2-typography-system)
3. [Color System](#3-color-system)
4. [Hero Section Design](#4-hero-section-design)
5. [Scroll Storytelling](#5-scroll-storytelling)
6. [Navigation System](#6-navigation-system)
7. [Product Grid & Cards](#7-product-grid--cards)
8. [Motion & Animation](#8-motion--animation)
9. [Interaction Patterns](#9-interaction-patterns)
10. [Spacing & Layout](#10-spacing--layout)
11. [Button & CTA System](#11-button--cta-system)
12. [Footer Design](#12-footer-design)
13. [Responsive Strategy](#13-responsive-strategy)

---

## 1. Design Philosophy

### Core Tenets

| Principle | Execution |
|-----------|-----------|
| **Product as Hero** | The product image IS the section. Full-bleed photography, no decorative UI chrome competing for attention. |
| **Cinematic Storytelling** | Sections flow like film scenes — establishing shot (hero) → detail shot (features) → group shot (comparison) → call to action. |
| **Generous Negative Space** | Content density is extremely low. Each screen-height scroll reveals ONE message. |
| **Typography as Architecture** | Type IS the layout structure. Hero titles are 120px+, section heads are 64px+, body is 17-21px. |
| **Motion with Purpose** | Every animation communicates something — product rotation shows build quality, scroll-reveal builds anticipation, parallax creates depth. |
| **Photography, Not Illustration** | Products are shot with real-world lighting, not flat vectors. Materials (aluminum, titanium, glass) are rendered photorealistically. |

### What Apple.com is NOT

- **Not content-dense**: You won't find data tables, sidebar navigation, or dashboard layouts.
- **Not interactive-before-message**: Animations serve the product story, not vice versa.
- **Not trend-chasing**: Glassmorphism, bento grids, brutalist typography — Apple doesn't follow these. They define the baseline that trends react against.
- **Not a design system for SaaS**: The patterns here are for product MARKETING, not product USAGE. An Apple.com design system applied to a dashboard would feel wrong.

### Reference Mentality

Apple.com is the *benchmark* for product marketing on the web. When designers say "make it feel like Apple," they mean: product-first photography, generous whitespace, precise typography hierarchy, and animations that reveal rather than distract.

---

## 2. Typography System

### Font Stack

```css
/* Apple's actual font stack */
font-family: 
  'SF Pro Display',      /* macOS/iOS system font — headlines above 20px */
  'SF Pro Text',          /* macOS/iOS system font — body text below 20px */
  -apple-system,          /* Fallback to system font */
  'Helvetica Neue',       /* Older Apple fallback */
  'Helvetica',            /* Universal fallback */
  'Arial',                /* Windows fallback */
  sans-serif;

/* Note: SF Pro is Apple's custom typeface. The optical size axis automatically 
   switches between SF Pro Display (for large sizes) and SF Pro Text (for small).
   For web recreations, Inter is the closest free alternative. */
```

### Type Scale (Exact Apple.com Sizes)

| Role | Size | Weight | Letter Spacing | Line Height | Notes |
|------|------|--------|----------------|-------------|-------|
| **Hero Title** | 96px–120px | 600 (Semibold) | -0.015em | 1.0 | Product name — "iPhone 16 Pro" |
| **Hero Subtitle** | 28px–32px | 400 (Regular) | -0.005em | 1.2 | Tagline — "Built for Apple Intelligence" |
| **Hero Legal/Tertiary** | 17px–19px | 400 | 0em | 1.3 | "From $999 or $41.62/mo." |
| **Section Title** | 48px–64px | 600 | -0.01em | 1.1 | "iPad." or "Get the highlights." |
| **Section Subtitle** | 21px–24px | 400 | -0.003em | 1.3 | Supporting paragraph |
| **Feature Headline** | 40px–48px | 600 | -0.008em | 1.1 | "A18 Pro chip." |
| **Feature Body** | 17px–19px | 400 | 0em | 1.4 | Description text |
| **Stat/Callout** | 56px–72px | 700 | -0.012em | 1.0 | "48MP" or "2x" stat callouts |
| **Body Text** | 17px | 400 | 0em | 1.47 | Standard body copy |
| **Caption/Label** | 12px–14px | 400 | 0em | 1.3 | Small labels, footnotes |
| **Nav Items** | 12px–14px | 400 | 0em | 1.0 | Global navigation |
| **CTA Text** | 17px–21px | 400 | 0em | 1.0 | Button labels |
| **Price Text** | 17px | 400 | 0em | 1.3 | "From $999" pricing |

### Font Weight Distribution

Apple uses a remarkably restrained weight palette:

- **600 (Semibold)**: Primary headline weight. NOT 700 bold — Apple prefers semibold for refined headlines.
- **400 (Regular)**: Body copy and most UI text. Apple rarely uses 300 (Light) on web anymore — they moved away from ultra-thin type around 2016.
- **700 (Bold)**: Used sparingly — only for stat callouts and very occasional emphasis.
- **300 (Light)**: Rarely seen on current Apple.com. The 2013-2015 era used thin weights extensively (iOS 7 influence). Current design favors legibility over thin aesthetic.

### Typography Rules

1. **Never center-align body text over 3 lines.** Short taglines can be centered; descriptions are always left-aligned.
2. **Headlines are sentence case, not title case.** "iPhone 16 Pro" not "IPhone 16 Pro."
3. **No all-caps for readability.** Apple almost never uses uppercase for body text (except legal footnotes and nav).
4. **Headlines stand alone.** They rarely compete with body text directly adjacent. The pattern is: Big headline → generous space → smaller body.
5. **Color contrast is always high.** White on dark photo, black on white, black on light gray. No low-contrast text.

### When to Use Each Size

```
IS THIS A PRODUCT NAME HERO?
  → 96-120px Semibold, centered, white on dark photo

IS THIS A SECTION INTRODUCING A PRODUCT FAMILY?
  → 48-64px Semibold, left-aligned, dark on light

IS THIS A FEATURE CALL-OUT?
  → 40-48px Semibold headline + 17-19px body, left-aligned

IS THIS A STAT/CALLOUT ("48MP")?
  → 56-72px Bold, centered, paired with 14px label

IS THIS STANDARD BODY COPY?
  → 17px Regular, 1.47 line-height, left-aligned, max-width ~600px

IS THIS A NAVIGATION LABEL?
  → 12-14px Regular, no letter-spacing
```

---

## 3. Color System

### The Apple Color Philosophy

Apple's color system is deceptively simple: they use almost exclusively **black, white, and shades of gray** as structural colors. Color comes from **product photography** — the iPhone's titanium finish, the iMac's green, the Watch's red. The website itself is a neutral frame.

### Background Progression

Apple.com sections alternate backgrounds to create visual rhythm:

```
Section 1: HERO               → Dark (#000 or deep product color background)
Section 2: PRODUCT DETAILS     → White (#ffffff) or near-white (#f5f5f7)
Section 3: FEATURE SHOWCASE    → Black (#000000)
Section 4: COMPARISON/TABLE    → Light gray (#f5f5f7)
Section 5: ACCESSORIES         → White (#ffffff)
Section 6: WHY APPLE           → Near-white (#fafafa)
Section 7: FOOTER              → Light gray (#f5f5f7)
```

**The Apple Rhythm**: Dark → Light → Dark → Light → Light → Light. Hero sections are dark (product photos pop on black). Detail sections alternate between white and `#f5f5f7`.

### Background Color Palette

| Name | Hex | Usage |
|------|-----|-------|
| Hero Black | `#000000` | Full-bleed hero backgrounds. Deepest possible black to make photos glow. |
| Section White | `#ffffff` | Standard content sections |
| Apple Gray | `#f5f5f7` | Alternating section bg, comparison tables, footer |
| Dark Section | `#1d1d1f` | Dark sections that aren't full black (headers, some feature sections) |
| Nav Glass | `rgba(255,255,255,0.72)` | Navigation bar glass effect (when scrolled, on light sections) |
| Nav Glass Dark | `rgba(29,29,31,0.72)` | Navigation bar glass effect (when scrolled, on dark sections) |
| Card Surface | `#ffffff` | Product cards, always white with `#f5f5f7` page background |

### Text Color Scale

| Role | Hex | Usage |
|------|-----|-------|
| Primary Dark | `#1d1d1f` | Headlines on light backgrounds. NOT pure black — very dark gray. |
| Body Dark | `#1d1d1f` | Body text on light backgrounds |
| Secondary Dark | `#86868b` | Captions, secondary info on light backgrounds |
| Tertiary Dark | `#6e6e73` | Footnoted, least important text |
| Primary Light | `#ffffff` | Headlines on dark backgrounds |
| Body Light | `#f5f5f7` | Body text on dark backgrounds |
| Secondary Light | `#a1a1a6` | Captions on dark backgrounds |

### Accent Color — "Apple Blue"

```css
--apple-blue: #0066cc;        /* Primary link/CTA blue */
--apple-blue-hover: #0077ed;  /* Hover state */
--apple-blue-dark-bg: #2997ff; /* Blue used on dark/black backgrounds */
```

The classic Apple blue is used for:
- All text links
- "Learn more" CTAs (with chevron)
- Inline links in body copy
- Some CTA button outlines

Apple uses this single accent color. There is no secondary accent. The discipline is striking — one blue, applied consistently.

### Product-Specific Accent Colors

For hero sections, the background color is often derived from the product:

| Product | Hero Background | Text Color |
|---------|----------------|------------|
| iPhone 16 Pro | Deep dark titanium gradient | White |
| iPhone 16 | Vibrant ultramarine/teal/pink | White |
| MacBook Air | Midnight or Starlight background | White |
| iMac | Matching iMac color (green, blue, pink, silver, etc.) | White |
| Apple Watch | Black with subtle color accent from band | White |
| iPad Pro | Deep space black | White |
| Vision Pro | Dark gradient with product glow | White |

### Gradient Usage

Apple uses gradients sparingly but effectively:

1. **Hero photo gradients**: Radial gradients behind product photos to create "glow" — never harsh, always subtle
2. **Section transitions**: Very subtle gradient fades between sections
3. **Nav bar**: `backdrop-filter: saturate(180%) blur(20px)` with semi-transparent background creates the signature "Apple glass" effect

### Dark Mode

Apple.com does NOT toggle light/dark mode based on system preference. Each section has a fixed, intentional background. The site is designed as a complete visual composition, not a responsive color scheme.

---

## 4. Hero Section Design

### Hero Structure (The Apple Pattern)

```
┌─────────────────────────────────────────┐
│  [Navigation Bar — transparent bg]       │  ← Transparent on dark hero,
│                                          │     blurred glass on scroll
│                                          │
│             ┌─────────────┐              │
│             │             │              │
│             │   PRODUCT   │              │  ← Full-bleed product photo
│             │   PHOTO     │              │     or 3D render
│             │             │              │     Takes up 60-70% of hero
│             │             │              │
│             └─────────────┘              │
│                                          │
│           iPhone 16 Pro                  │  ← 96-120px Semibold
│     Built for Apple Intelligence.        │  ← 28-32px Regular (tagline)
│                                          │
│     [Learn More]    [Buy]                │  ← Two CTAs, blue link + white outlined
│                                          │     or both blue
│                                          │
│                                          │
└─────────────────────────────────────────┘
```

### Hero Types

#### Type 1: Full-Bleed Product on Dark (Most Common)

Used for: iPhone, iPad, Mac, Watch, Vision Pro launches.

**Layout**: Product photo centered, taking 60-70% of viewport height. Below the photo: product name (96px+), tagline (28-32px), two CTAs.

**Background**: Black (#000000) or deep gradient matching product finish.

**Example**: iPhone 16 Pro hero — titanium iPhone floating on black with subtle light source behind.

#### Type 2: Product on Color Background

Used for: iPhone 16 (non-Pro), iMac, colorful products.

**Layout**: Same as Type 1 but with vibrant color background matching the product line.

**Example**: iPhone 16 hero — ultramarine background showing the phone in matching color.

#### Type 3: Split Hero (Rare)

Used for: Mac launches sometimes.

**Layout**: Product photo on one side (usually left), headline + CTAs aligned to the other side.

#### Type 4: Video/Animated Hero (Special Events)

Used for: Major product launches, event promotions.

**Layout**: Auto-playing video fills the entire hero area. Product name and tagline overlaid. Video is silent, usually showing product from multiple angles or a cinematic intro.

### CTA Pattern

Apple's hero always has **exactly two CTAs**:

```
[Learn More]    [Buy]

Where:
- "Learn More" = plain text or blue link, often with > chevron
- "Buy" = white outlined button (on dark bg) or blue filled button (on light bg)
```

**Spacing**: The two CTAs sit side by side, centered, with ~16-20px gap.

**The Promise Pattern**: 
- "Learn More" → Continue the story (no commitment)
- "Buy" → Take action (commitment)

This two-button pattern is consistent across ALL product heroes. Users always know what to expect.

### Hero Content Hierarchy

```
1. PRODUCT PHOTO/VIDEO       ← Dominates visually; sets emotional tone
2. PRODUCT NAME              ← Huge type; instant recognition
3. TAGLINE                   ← One line; the key marketing message
4. PRICE/AVAILABILITY        ← Small text; "From $999" or "Available starting 9.20"
5. CTAs                      ← Learn More + Buy
6. LEGAL/FOOTNOTES           ← Tiny text at bottom of hero (trade-in, terms)
```

Each element has breathing room. The space between each layer is generous — typically 24-32px between the tagline and CTAs, and 16-20px between CTAs and legal.

---

## 5. Scroll Storytelling

### The Narrative Arc

Apple.com sections follow a cinematic structure:

```
SCENE 1: ESTABLISHING SHOT
  └─ Hero: The product in its most dramatic presentation. Full bleed, dark bg.

SCENE 2: CLOSE-UP DETAILS
  └─ "Get the highlights." — Sticky or sequenced feature reveals.
     Each feature gets one screen-height section with a detail photo.

SCENE 3: TECHNICAL DEPTH
  └─ "Designed to make a difference." — Specs woven into visual story.
     Chip section shows processor close-up. Camera section shows photo results.

SCENE 4: THE LINEUP
  └─ "Which iPhone is right for you?" — Comparison grid.
     All models side by side. Simplified spec comparison.

SCENE 5: ECOSYSTEM
  └─ Cross-sells: accessories, AppleCare, trade-in, Apple Card.
     How the product fits into your life.

SCENE 6: CLOSING STATEMENT
  └─ "Why Apple is the best place to buy." — Trust, values, retail experience.
```

### Scroll Reveal Patterns

Apple uses these scroll-triggered reveals:

#### Pattern 1: Opacity Fade-In (Most Common)

```
Element starts at: opacity: 0, transform: translateY(20-40px)
Triggers when: element is 60-70% into viewport
Animate to: opacity: 1, transform: translateY(0)
Duration: 0.6-0.8s, ease-out
```

Product photos, headlines, and body copy all use this. It's subtle — not a dramatic animation, just a gentle reveal.

#### Pattern 2: Scale-Up (Product Hero Images)

```
Starts at: transform: scale(0.92-0.95), opacity: 0
Triggers when: section enters viewport
Animate to: transform: scale(1), opacity: 1
Duration: 0.8-1.0s, custom ease (Apple's own easing curve)
```

#### Pattern 3: Split Reveal (Feature Sections)

```
Left content (text): fades in + slides right 20px
Right content (image): fades in + slides left 20px
Both fire simultaneously when section is ~50% into viewport
Duration: 0.7s, staggered by 0.1s (text first, then image)
```

#### Pattern 4: Sticky Product Sections

```
Section becomes position: sticky; top: 0
As user scrolls, different product states/angles/colors cycle through
Product stays fixed while text/content scrolls
```

Used for: "Take a closer look" sections where the product image stays while you scroll through feature descriptions.

#### Pattern 5: Number/Stat Count-Up

```
Stats like "48MP" count up from 0 when scrolled into view
Duration: ~1.5s, ease-out
Used on: Camera specs, battery life stats, performance numbers
```

### Section Transitions

Between major sections, Apple uses:
- Background color shifts (black → white → gray → white → gray → white)
- A separator line or generous padding (120-200px vertical space)
- Sometimes a thin 1px `#d2d2d7` border as a section divider

### The "Sticky Scroll" Technique (Key Apple Innovation)

```
┌─────────────────────────┐
│ Section Title           │
│                         │
│ ┌─────────────────┐     │
│ │  PRODUCT IMAGE  │     │  ← position: sticky; top: calc(50% - 200px)
│ │  (stays fixed)  │     │     Image stays in center of screen
│ │                 │     │
│ └─────────────────┘     │
│                         │
│ Feature description 1 ──┤  ← scrolls past the fixed image
│ Feature description 2 ──┤
│ Feature description 3 ──┤
│                         │
└─────────────────────────┘
```

This creates a "product stays, story scrolls" effect that is quintessentially Apple. The product image remains visible while different features are called out via scrolling text.

### Animation Timing Philosophy

- **Never fast**: Apple animations are deliberately slow (0.6–1.2s). Fast animations feel cheap.
- **Ease-out dominant**: Almost everything uses ease-out or Apple's proprietary easing. No bounce, no elastic — those feel playful, not premium.
- **Staggered, not simultaneous**: When multiple elements appear, they cascade slightly (50-100ms apart). Never all at once.
- **Once only**: Scroll reveals play exactly once. They don't replay on scroll-back. This is intentional — the story is being told, not reacting to user whims.

---

## 6. Navigation System

### Global Navigation Bar

```
┌──────────────────────────────────────────────────────────┐
│     Store   Mac   iPad   iPhone   Watch   Vision   ...  │
│  AirPods   TV & Home   Entertainment   Accessories    🔍  │
│  Support                                        🛒        │
└──────────────────────────────────────────────────────────┘
```

**Structure**: Single horizontal bar, full-width, centered items.

**Background Behavior**:
- **At top of page (hero)**: `background: transparent` — nav text is white (or adjusted for hero bg color)
- **On scroll**: `background: rgba(255,255,255,0.72)` with `backdrop-filter: saturate(180%) blur(20px)` — the iconic Apple glass nav
- **Transition**: Smooth fade + blur transition over ~200ms of scroll

**Items**: 12 top-level nav items. No icons except Apple logo (left), search (right), bag (right).

**Height**: 44px (desktop) / 48px (mobile). This is the same height as the iOS navigation bar.

**Font**: 12px Regular, `#1d1d1f` (on glass) or `#ffffff` (over dark hero).

### Mega Menu Dropdowns

When hovering a nav item (e.g., "Mac"), a mega dropdown appears:

```
┌──────────────────────────────────────────────────────────┐
│    [Store] [Mac▾]  iPad  iPhone  Watch  Vision  ...    │
│                                                          │
│  ┌──────────────────────────────────────────────────┐    │
│  │ Explore Mac                                      │    │
│  │                                                  │    │
│  │ Explore All Mac      MacBook Air     MacBook Pro │    │  ← With product thumbnails
│  │ iMac                Mac mini        Mac Studio   │    │
│  │ Mac Pro             Displays                      │    │
│  │                                                  │    │
│  │ ─────────────────────────────────────────────    │    │
│  │                                                  │    │
│  │ Shop Mac         Mac Accessories     AppleCare+  │    │  ← Secondary row
│  │                                                  │    │
│  │ ─────────────────────────────────────────────    │    │
│  │                                                  │    │
│  │ Compare Mac     Switch from PC to Mac            │    │  ← Tertiary row
│  │                                                  │    │
│  └──────────────────────────────────────────────────┘    │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

**Dropdown Design**:
- White background with rounded corners
- Subtle shadow: `0 4px 32px rgba(0,0,0,0.08)`
- Product thumbnails with name labels
- Three-tier hierarchy: product categories → shopping links → guides
- Hover state: subtle background highlight on items
- Transition: fade in + subtle slide down (0.2s)

### Mobile Navigation

```
┌──────────────────────┐
│        ☰    🛒     │  ← Hamburger on mobile
├──────────────────────┤
│  [Page Content]      │
│                      │

Hamburger opens full-screen overlay:
┌──────────────────────┐
│                ✕    │
│                      │
│  Store               │
│  Mac                 │
│  iPad                │
│  iPhone        ▸     │  ← Chevron for sub-items
│  Watch               │
│  Vision              │
│  AirPods             │
│  TV & Home           │
│  Entertainment       │
│  Accessories         │
│  Support             │
│                      │
└──────────────────────┘
```

---

## 7. Product Grid & Cards

### The Comparison Grid ("Which iPhone is right for you?")

```
┌──────────────┬──────────────┬──────────────┬──────────────┐
│              │              │              │              │
│  iPhone 16   │  iPhone 16   │  iPhone 16   │  iPhone 16e  │
│     Pro      │              │     Plus     │              │
│              │              │              │              │
│  [IMAGE]     │  [IMAGE]     │  [IMAGE]     │  [IMAGE]     │
│              │              │              │              │
│  From $999   │  From $799   │  From $899   │  From $599   │
│              │              │              │              │
│  6.3″ or     │  6.1″        │  6.7″        │  6.1″        │
│  6.9″        │  display     │  display     │  display     │
│  display     │              │              │              │
│              │              │              │              │
│  A18 Pro     │  A18         │  A18         │  A18         │
│  chip        │  chip        │  chip        │  chip        │
│              │              │              │              │
│  Pro camera  │  48MP        │  48MP        │  48MP        │
│  system      │  dual camera │  dual camera │  single cam  │
│              │              │              │              │
│  [Buy]       │  [Buy]       │  [Buy]       │  [Buy]       │
│  Learn more  │  Learn more  │  Learn more  │  Learn more  │
└──────────────┴──────────────┴──────────────┴──────────────┘
```

**Card Design**:
- White card on `#f5f5f7` background
- Product image at top (same scale for all models for comparison)
- Product name as bold headline
- Price in regular weight
- Key specs in small text (display size, chip, camera)
- "Buy" button (blue) + "Learn more" link below

**Card Spacing**: Equal-width columns with ~20px gap between cards.

**The "New" Badge**: Orange `#ff6b35` pill with "New" text next to the latest product name.

### Accessory Grid

```
┌──────────────┬──────────────┬──────────────┬──────────────┐
│  [AirPods]   │  [AirTag]    │  [MagSafe]   │  [Cases]     │
│   AirPods    │    AirTag    │   MagSafe    │   Cases &    │
│   4 with     │   (4-pack)   │   Charger    │  Protection  │
│  ANC / $179  │   / $99      │   / $39      │              │
└──────────────┴──────────────┴──────────────┴──────────────┘
```

Smaller cards, 4-6 per row, product photo + name + short description + price.

### "Why Apple" / Value Cards

```
┌─────────────────┬─────────────────┐
│  [Trade-in]     │  [Apple Card]   │
│  Save on a new  │  Get 3% Daily   │
│  iPhone with    │  Cash back.     │
│  Apple Trade In.│                 │
│  [Learn more]   │  [Learn more]   │
└─────────────────┴─────────────────┘
```

Icon (SF Symbol) + headline + short description + link. Clean, minimal.

---

## 8. Motion & Animation

### Animation Library

Apple uses their own custom animation framework (not GSAP, not Framer Motion). However, the patterns can be recreated with any modern animation library.

### The Apple Easing Curve

Apple animations use a custom easing curve that is close to but not exactly `ease-out`:

```css
/* Approximation of Apple's custom ease */
--apple-ease: cubic-bezier(0.25, 0.1, 0.25, 1.0);  /* closer to ease-out */
--apple-ease-in: cubic-bezier(0.42, 0.0, 1.0, 1.0);
--apple-ease-in-out: cubic-bezier(0.42, 0.0, 0.58, 1.0);

/* Apple's actual CSS easing (from their website) */
transition-timing-function: cubic-bezier(0.16, 0, 0.22, 1);
/* This is a slightly modified ease-out with a flatter start */
```

### Scroll-Triggered Animations

#### Product Reveal Sequence

```
1. Section scrolls into view (60-70% visible)
2. Product image: opacity 0→1, translateY(40px→0), 0.8s, apple-ease
3. Headline: opacity 0→1, translateY(20px→0), 0.6s, apple-ease (starts 0.1s after image)
4. Subtitle: opacity 0→1, translateY(20px→0), 0.6s, apple-ease (starts 0.15s after headline)
5. CTAs: opacity 0→1, translateY(10px→0), 0.5s, apple-ease (starts 0.2s after subtitle)
```

Each element cascades with a 50-100ms delay. Total reveal sequence: ~1.2 seconds.

#### Image Crossfade (Product Color Switcher)

```
1. Click color swatch
2. Current image fades out (opacity 1→0, 0.3s)
3. New image fades in (opacity 0→1, 0.3s)
4. Text below image crossfades simultaneously
```

#### Navigation Bar Transition

```
At page top (hero):
  background: transparent
  text color: white (or adapted to hero)
  
Scroll beyond hero:
  background transitions to rgba(255,255,255,0.72) over ~150ms
  backdrop-filter: saturate(180%) blur(20px) fades in
  text transitions to #1d1d1f
  
The transition is NOT a toggle — it's a gradual interpolation
tied to scroll position for the first ~100px of scroll.
```

### Video Autoplay

**Where**: Hero sections, feature sections showing product in use.

**How**:
- `<video autoplay muted loop playsinline>`
- No controls visible
- Seamless background — no black bars, no loading indicators
- 60fps, high quality
- Video is usually masked behind the product silhouette

**Loading Strategy**: Video poster frame first, then auto-play when in viewport (or immediately if in hero). Apple uses their own streaming optimization.

### Product 3D Rotation (Model Viewer)

For certain products (iPhone, MacBook), Apple uses a 3D model viewer:

```
1. Product starts at display angle
2. On scroll, product rotates slightly (3-5 degrees) to reveal different angles
3. Rotation is smooth, tied to scroll progress
4. On mobile: touch-drag to rotate (like Quick Look)
```

### Parallax Depth Effect

```
┌──────────────────┐
│                  │
│  Background      │  ← Translates at 0.5x scroll speed
│                  │
│  ┌────────────┐  │
│  │            │  │
│  │  Product   │  │  ← Translates at 1x scroll speed (normal)
│  │            │  │
│  └────────────┘  │
│                  │
│  Text overlay    │  ← Translates at 1x scroll speed
│                  │
└──────────────────┘
```

Subtle parallax — not exaggerated. Usually 0.8x–0.5x speed for background elements.

### Animation Duration Tokens

| Type | Duration | Easing |
|------|----------|--------|
| Button hover | 150ms | apple-ease |
| Nav dropdown | 200ms | apple-ease |
| Scroll reveal (text) | 600ms | apple-ease |
| Scroll reveal (image) | 800ms | apple-ease |
| Image crossfade | 300ms | ease-in-out |
| Color swatch swap | 300ms | ease-in-out |
| Modal open | 400ms | apple-ease |
| Page load hero | 1000ms | apple-ease (staggered) |

### Page Load Animation

When you first load apple.com:

```
0ms:     Page renders with critical CSS (no flash)
0-200ms: Hero product image fades in from slight scale-down (0.95→1)
200ms:   Hero headline fades in + slides up
300ms:   Tagline fades in
400ms:   CTAs fade in
```

Everything after the initial hero is lazy-loaded with scroll reveals.

---

## 9. Interaction Patterns

### Button Hover States

```
Primary Button (Blue fill):
  Default: background #0071e3, color white
  Hover: background #0077ed (slightly brighter)
  Active: background #0062c4 (slightly darker)
  Transition: 150ms

Secondary Button (Outline):
  Default: background transparent, border 1px solid, color #0071e3
  Hover: background #0071e3, color white
  Active: background #0062c4, border-color #0062c4
  Transition: 150ms

Link (Blue text):
  Default: color #0066cc, text-decoration none
  Hover: color #2997ff (or #0077ed), text-decoration underline (on some)
  Transition: 150ms
```

### Link Types

```
Learn more >       ← Blue text with inline chevron (never underlined)
Shop >             ← Blue text with inline chevron
Buy                ← Blue filled button (1-2 words only)
Get started        ← Blue filled button, alternate to "Buy"
View pricing       ← Blue outlined button, secondary CTA
```

### Color Swatch Selector

```
┌──────────────────────────────────────┐
│                                      │
│         [Product Image]              │  ← Image changes to match swatch
│                                      │
│   ●    ●    ●    ●    ●              │  ← Color swatch dots
│  Nat-  Blue  Teal  Pink  Black       │  ← Color name label
│  ural                                │
│                                      │
└──────────────────────────────────────┘

Clicking a swatch:
- Button gets a 2px ring in accent color (focus state)
- Product image crossfades (300ms)
- Color name text crossfades
- URL updates to reflect color selection
```

### Comparison Tool Interactions

On product comparison pages (e.g., iPhone comparison):

- **Sticky header**: Spec categories stick to top as you scroll through features
- **Row hover**: The row you're reading gets a subtle background highlight `#f5f5f7`
- **Expandable sections**: "See all specs" toggles to show full specification list
- **Smooth scroll**: Clicking a category in the sticky header smooth-scrolls to that section

### "Which iPhone is right for you?" Interactive

```
┌──────────────────────────────────────────┐
│  Compare iPhone models                   │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │ [View]  [View]  [View]  [View] │    │  ← "View" pills for each model
│  └──────────────────────────────────┘    │
│                                          │
│  ┌───────┬───────┬───────┬───────┐      │
│  │       │       │       │       │      │
│  │  Pro  │  16   │  16   │  16e  │      │  ← Product images at top
│  │       │       │ Plus  │       │      │
│  └───────┴───────┴───────┴───────┘      │
│                                          │
│  Features grid below                     │
└──────────────────────────────────────────┘
```

The interaction is scrolling, not clicking. The user scrolls through a matrix of features and models.

### Dropdown/Menu States

```
Nav item (top-level):
  Default: nav text color
  Hover: same color, but mega dropdown appears below
  Active page: subtle indicator (sometimes bolder text)

Dropdown item:
  Default: #1d1d1f on white
  Hover: background #f5f5f7, slight highlight
  Product thumbnail: slight scale(1.02) on hover + shadow increase
```

### Focus States

Apple is famously committed to accessibility:

```
Focus ring: 2px solid rgba(0,125,250,0.6)
Offset: 2px from element edge
Border-radius: matches element's radius
Applied to: all interactive elements (links, buttons, form inputs)
```

---

## 10. Spacing & Layout

### Content Max Width

```css
/* Apple's content container */
.apple-content {
  max-width: 1024px;        /* Standard content sections */
  margin: 0 auto;
  padding: 0 22px;           /* Side padding for smaller viewports */
}

/* Full-bleed sections have no max-width */
.apple-hero {
  max-width: none;
  width: 100vw;
}

/* Wide feature sections */
.apple-feature {
  max-width: 1200px;
  margin: 0 auto;
}
```

### Section Padding Scale

| Section Type | Top Padding | Bottom Padding | Notes |
|-------------|-------------|----------------|-------|
| Hero | 44px (nav height) | 60-80px | Product image fills space, not padding |
| Standard Section | 80-120px | 80-120px | Generous whitespace |
| Feature Section | 100-140px | 100-140px | Even more space for impact |
| "Get the highlights" | 60px | 60px | Smaller features, less padding |
| Comparison Grid | 80px | 120px | Extra bottom padding before next section |
| Footer | 40px | 40px | Tighter, more utilitarian |

### The 8px Grid

Apple consistently uses multiples of 8px for spacing:

```
4px   — Tight gaps (label-to-value, icon-to-text)
8px   — Small gaps (CTA pairs, list items)
12px  — Compact padding
16px  — Standard gap (card margins, button padding)
20px  — Common gap (section sub-spacing)
24px  — Section internal padding
32px  — Section spacing (headline-to-body)
40px  — Large gap (CTA group to content below)
48px  — Section chunk spacing
64px  — Major section padding (non-hero)
80-120px — Section-to-section spacing
```

### Product Image Sizing

```
Hero product (iPhone):    ~40-55% of viewport height (desktop)
Hero product (MacBook):   ~50-60% of viewport height (desktop)
Hero product (Watch):     ~40-50% of viewport height
Section product (detail): ~50-70% of containing column width
Comparison card product:  ~80% of card width
Accessory product:        ~70% of card width, smaller scale
```

### Layout Patterns

#### Pattern 1: Centered Single-Column

```
[         Product Image (60% vh)          ]
[          96px Semibold Headline          ]
[             Tagline (28px)               ]
[       [Learn More]    [Buy]             ]
```

Used for: Hero sections, major product announcements.

#### Pattern 2: Two-Column Split (50/50 or 60/40)

```
┌──────────────────┬──────────────────┐
│                  │                  │
│  Headline        │                  │
│  Body text       │  Product Image   │
│  CTA             │                  │
│                  │                  │
└──────────────────┴──────────────────┘
```

Used for: Feature sections, "Get the highlights."

#### Pattern 3: Three-Column Feature

```
┌──────────┬──────────┬──────────┐
│ [Icon]   │ [Icon]   │ [Icon]   │
│ Feature  │ Feature  │ Feature  │
│ text     │ text     │ text     │
└──────────┴──────────┴──────────┘
```

Used for: "Why Apple" value props, accessory features.

#### Pattern 4: Z-Pattern Scrolling

```
Image Right → scroll → Image Left → scroll → Image Right

Alternating image position creates visual rhythm and keeps eyes moving.
```

### Grid Columns

```
Desktop (1024px+):
  - 2-column (50/50) for feature sections
  - 3-column for accessory/product grids
  - 4-column for comparison tables and small accessory cards
  - 12-column invisible grid as base

Tablet (768-1024px):
  - 2-column for most layouts
  - Comparison table becomes horizontal scroll

Mobile (<768px):
  - Single column, stacked
  - Comparison becomes accordion or horizontal scroll
```

---

## 11. Button & CTA System

### Button Hierarchy

```
Level 1: Primary Action
  └─ Solid blue fill (#0071e3), white text, 12-18px padding-x, 8-12px padding-y
     Corner radius: 980px (pill) or 12px (rounded rect)
     Used for: "Buy", primary CTAs

Level 2: Secondary Action  
  └─ Transparent with border (1px solid), blue text and border
     Corner radius: 980px (pill)
     Used for: "Learn more" (when paired with primary), "View pricing"

Level 3: Text Link
  └─ Blue text (#0066cc), no border, no background
     Used for: "Learn more >", "Shop >", inline links

Level 4: Ghost Button
  └─ White text (on dark bg), white border
     Corner radius: 980px
     Used for: "Buy" on dark hero backgrounds (to look elegant against dark)
```

### CTA Size Scale

```
Hero CTA:
  font-size: 17-19px
  padding: 12px 24px
  min-width: 120px

Section CTA:
  font-size: 17px  
  padding: 12px 20px

Card CTA:
  font-size: 14-17px
  padding: 8px 16px

Nav CTA ("Buy" in dropdown):
  font-size: 12-14px
  padding: 6px 12px
```

### CTA Pairing Rules

```
RULE 1: Hero always has TWO CTAs
  [Learn More] [Buy]  or  [Learn More] [View Pricing]

RULE 2: Section CTAs can be solo
  [Learn more about iPhone 16 Pro >]

RULE 3: Card CTAs can be two or one
  [Learn more] [Buy]  or  just [Learn more >]

RULE 4: Primary action always comes second (right side in LTR)
  Not [Buy] [Learn More]
  But  [Learn More] [Buy]  ← the more-committal action is last

RULE 5: At most 1 filled + 1 outlined per CTA group
  Never two filled buttons side by side
  Never two outlined buttons side by side
```

### Button Shape

Apple has standardized on the **pill shape**:

```css
.apple-button {
  border-radius: 980px;  /* Essentially a pill — full rounding */
  padding: 12px 24px;
  font-size: 17px;
  font-weight: 400;
  line-height: 1.0;
  display: inline-block;
  text-align: center;
  min-width: 80px;
  cursor: pointer;
}
```

The ultra-round pill (980px radius) ensures that on any reasonable button width, the ends are fully rounded semicircles.

---

## 12. Footer Design

### Footer Structure

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│  * Pricing footnote text, legal disclaimers, etc.    │  ← Superscript asterisk
│  * Trade-in values may vary.                         │
│                                                      │
│  ──────────────────────────────────────────────────  │
│                                                      │
│  ┌─────────┬─────────┬─────────┬─────────┬────────┐  │
│  │ Shop    │ Account │ Store   │ For     │ Apple  │  │
│  │ and     │         │         │ Business│ Values │  │
│  │ Learn   │         │         │         │        │  │
│  │         │         │         │         │        │  │
│  │ Store   │ Manage  │ Find a  │ Apple   │ Access- │  │
│  │ Mac     │ Your    │ Store   │ and     │ ibility │  │
│  │ iPad    │ Apple   │ Genius  │ Business│ Educ-   │  │
│  │ iPhone  │ Account │ Bar     │ Shop    │ ation   │  │
│  │ Watch   │ Apple   │ Today   │ for     │ Envir-  │  │
│  │ ...     │ Store   │ at      │ Business│ onment  │  │
│  │         │ Account │ Apple   │         │ Privacy │  │
│  │         │ ...     │ ...     │         │ ...     │  │
│  └─────────┴─────────┴─────────┴─────────┴────────┘  │
│                                                      │
│  ──────────────────────────────────────────────────  │
│                                                      │
│  More ways to shop: [Find an Apple Store] or        │
│  [other retailer] near you. Or call 1-800-MY-APPLE.  │
│                                                      │
│  ──────────────────────────────────────────────────  │
│                                                      │
│  Copyright © 2026 Apple Inc. All rights reserved.    │
│  Privacy Policy | Terms of Use | Sales and Refunds  │
│  Legal | Site Map                                    │
│                                                      │
│                        United States                 │  ← Country selector
│                                                      │
└──────────────────────────────────────────────────────┘
```

**Footer Design Notes**:
- Background: `#f5f5f7` (Apple gray)
- Text: 12px Regular, `#6e6e73` (secondary gray) for column body, `#1d1d1f` for column headers
- Column headers: 12px Semibold (600), `#1d1d1f`
- Links: 12px Regular, `#6e6e73`, underline on hover
- Divider: 1px solid `#d2d2d7`
- 5 columns on desktop, stacked on mobile
- Very utilitarian — no icons, no decoration
- Legal superscript note at top

---

## 13. Responsive Strategy

### Breakpoints

```
Desktop:    1024px+          Full multi-column layout, mega nav
Tablet:     768px – 1023px   Stacked features, simplified nav
Mobile:     320px – 767px    Single column, hamburger menu, full-width images
```

### Mobile Adaptations

**Typography on Mobile**:
- Hero title scales down but remains the largest element: 48-56px (from 96-120px)
- Section titles: 32-40px (from 48-64px)
- Body stays at 17px (comfortable reading size)
- All type maintains generous line-height

**Layout on Mobile**:
- All two/three-column layouts stack to single column
- Product images become smaller but still prominent
- Comparison tables become horizontally scrollable or accordion-style
- CTAs stay side-by-side if they fit; stack if too narrow
- Nav becomes hamburger menu with slide-in overlay

**Images on Mobile**:
- Hero images scale proportionally
- Section images go full-width
- No lazy-loading delay for above-the-fold images
- Product color swatches remain tappable (minimum 44x44px touch target)

### Mobile-First vs Desktop-First

Apple.com is **desktop-first** in design but **carefully adapted** for mobile. The desktop layout is the canonical design; mobile is a thoughtful simplification, not a reimagining.

---

## Summary: The Apple Design Principles in 10 Rules

1. **Product is the hero** — Photography dominates, UI chrome fades away.
2. **One message per scroll** — Each screen height communicates a single idea.
3. **Type IS design** — 96px+ headlines, generous white space, precise hierarchy.
4. **Dark → Light rhythm** — Alternate background colors like musical movements.
5. **Two CTAs only** — Always [Learn More] [Buy]. Never more, never less.
6. **Animation reveals, not distracts** — 0.6-0.8s ease-out reveals, once only.
7. **Transparent nav → blurred glass** — Navigation transforms on scroll, never stays static.
8. **Accent with discipline** — One blue (#0066cc for light bg, #2997ff for dark bg). That's it.
9. **Pill buttons** — All CTAs use 980px border-radius. Consistent, recognizable.
10. **Photography, not illustration** — Real product photography. Real materials. Real lighting. No flat vectors.

---

## Implementation Reference

### CSS Custom Properties (Apple-Style Design Tokens)

```css
:root {
  /* Colors */
  --apple-black: #000000;
  --apple-near-black: #1d1d1f;
  --apple-white: #ffffff;
  --apple-gray: #f5f5f7;
  --apple-gray-secondary: #86868b;
  --apple-gray-tertiary: #6e6e73;
  --apple-border: #d2d2d7;
  --apple-blue: #0066cc;
  --apple-blue-hover: #0077ed;
  --apple-blue-dark-bg: #2997ff;
  --apple-blue-button: #0071e3;
  --apple-blue-button-hover: #0077ed;
  --apple-blue-button-active: #0062c4;
  --apple-new-badge: #ff6b35;
  --apple-focus-ring: rgba(0, 125, 250, 0.6);

  /* Typography */
  --font-sf: 'SF Pro Display', 'SF Pro Text', -apple-system, 'Helvetica Neue', Helvetica, Arial, sans-serif;
  --font-hero: 96px;
  --font-hero-tablet: 64px;
  --font-hero-mobile: 48px;
  --font-section-title: 56px;
  --font-section-title-mobile: 36px;
  --font-feature-headline: 44px;
  --font-body: 17px;
  --font-caption: 14px;
  --font-nav: 12px;
  --font-weight-semibold: 600;
  --font-weight-regular: 400;
  --font-weight-bold: 700;
  --line-height-body: 1.47;
  --line-height-headline: 1.1;
  --letter-spacing-hero: -0.015em;

  /* Spacing */
  --space-xs: 8px;
  --space-sm: 16px;
  --space-md: 24px;
  --space-lg: 32px;
  --space-xl: 48px;
  --space-2xl: 64px;
  --space-section: 100px;
  --content-max: 1024px;
  --content-wide: 1200px;

  /* Animation */
  --ease-apple: cubic-bezier(0.16, 0, 0.22, 1);
  --duration-fast: 150ms;
  --duration-normal: 300ms;
  --duration-slow: 600ms;
  --duration-reveal: 800ms;
  --duration-page-load: 1000ms;

  /* Navigation */
  --nav-height: 44px;
  --nav-glass-bg: rgba(255, 255, 255, 0.72);
  --nav-glass-blur: saturate(180%) blur(20px);
  --nav-glass-dark-bg: rgba(29, 29, 31, 0.72);

  /* Buttons */
  --btn-radius: 980px;
  --btn-padding-x: 24px;
  --btn-padding-y: 12px;

  /* Shadows */
  --shadow-dropdown: 0 4px 32px rgba(0, 0, 0, 0.08);
  --shadow-card-hover: 0 8px 48px rgba(0, 0, 0, 0.12);
}
```

### Recreating the Apple Nav Glass Effect

```css
.apple-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 44px;
  background: transparent;
  transition: background 0.3s var(--ease-apple);
  z-index: 1000;
}

.apple-nav.scrolled {
  background: rgba(255, 255, 255, 0.72);
  backdrop-filter: saturate(180%) blur(20px);
  -webkit-backdrop-filter: saturate(180%) blur(20px);
}
```

### Recreating an Apple-Style Hero

```html
<section class="apple-hero">
  <div class="apple-hero-image">
    <img src="iphone-16-pro.jpg" alt="iPhone 16 Pro" />
  </div>
  <h1 class="apple-hero-title">iPhone 16 Pro</h1>
  <p class="apple-hero-tagline">Built for Apple Intelligence.</p>
  <p class="apple-hero-pricing">From $999 or $41.62/mo. for 24 mo.*</p>
  <div class="apple-hero-ctas">
    <a href="#" class="apple-link">Learn more &gt;</a>
    <a href="#" class="apple-button">Buy</a>
  </div>
</section>

<style>
.apple-hero {
  background: #000;
  color: #fff;
  text-align: center;
  padding-top: 44px;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.apple-hero-image {
  width: 100%;
  max-width: 800px;
  margin-bottom: 40px;
}

.apple-hero-image img {
  width: 100%;
  height: auto;
  display: block;
}

.apple-hero-title {
  font-family: var(--font-sf);
  font-size: 96px;
  font-weight: 600;
  letter-spacing: -0.015em;
  margin: 0;
}

.apple-hero-tagline {
  font-size: 28px;
  font-weight: 400;
  margin: 16px 0 0;
  color: #f5f5f7;
}

.apple-hero-pricing {
  font-size: 17px;
  color: #86868b;
  margin: 24px 0 0;
}

.apple-hero-ctas {
  display: flex;
  gap: 20px;
  margin-top: 24px;
}
</style>
```

### Recreating a Scroll Reveal

```js
// Using IntersectionObserver to recreate Apple's scroll reveal
const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
        observer.unobserve(entry.target); // Only play once, like Apple
      }
    });
  },
  { threshold: 0.15 } // Trigger at 15% visibility
);

document.querySelectorAll('.apple-reveal').forEach(el => {
  el.style.opacity = '0';
  el.style.transform = 'translateY(30px)';
  el.style.transition = 'opacity 0.8s cubic-bezier(0.16, 0, 0.22, 1), transform 0.8s cubic-bezier(0.16, 0, 0.22, 1)';
  observer.observe(el);
});
```

---

## Key Distinctions: Apple.com vs SaaS/App Design

| Aspect | Apple.com (Product Marketing) | Typical SaaS/App |
|--------|------------------------------|------------------|
| Content Density | Extremely low — one message per screen | Higher — efficiency is valued |
| Color | Black, white, gray dominate. Color from photos. | Brand colors, semantic colors |
| Typography Scale | Massive range (12px nav to 120px hero) | Compressed range (12px to 36px) |
| Photography | Full-bleed product photos, cinematic | Illustrations, screenshots, icons |
| Animation | Cinematic reveals, 0.6-0.8s | Micro-interactions, 0.15-0.3s |
| Navigation | Slim 44px bar, mega dropdowns | Sidebar, top bar, breadcrumbs |
| CTAs | Two CTAs per hero, always same pattern | Varied CTAs, context-dependent |
| Page Length | Long-scroll storytelling | Structured pages with clear sections |
| Backgrounds | Dark → Light → Dark rhythm | Consistent background |
| Spacing | Extremely generous | Functional, content-appropriate |

---

*This design system document serves as a reference for product marketing website design. When implementing an Apple-inspired design, focus on the principles (product-as-hero, cinematic storytelling, typographic hierarchy, animation restraint) rather than copying specific elements. Apple.com works because every element serves the product narrative — not because of any individual component in isolation.*
