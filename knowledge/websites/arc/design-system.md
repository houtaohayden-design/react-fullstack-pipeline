# Arc Browser — Design System Extraction

**Source:** https://arc.net
**Brand:** Arc Browser by The Browser Company
**Date Extracted:** 2026-05-18
**Status:** Partial — blocked by Cloudflare (HTTP 403). Analysis compiled from training knowledge and design research.

---

## Overview

Arc is a radical reimagining of the web browser, built by The Browser Company. The marketing website at arc.net embodies the same design philosophy as the product itself — clean minimalism with vibrant, personality-driven color accents, premium typography, and a strong focus on product-as-hero visual storytelling. The design communicates "the browser that doesn't feel like a browser" through warm, human-centric aesthetics that deliberately avoid traditional tech-product coldness.

**Design DNA:**
- **Visual Identity:** Gradient-first brand system with multicolor spectrum palette
- **Aesthetic Lane:** Warm modernism — soft whites, rounded surfaces, personality colors
- **Design Philosophy:** Product-centric, human-warmth, "software with soul"
- **Key Differentiator:** Multicolor gradient as primary brand signature (not single-accent like most SaaS)

---

## Layout System

### Page Grid Architecture

Arc's marketing site uses a single-column centered layout with section-based scrolling:

```
+-------------------------------------------+
|              NAVIGATION (fixed)            |
+-------------------------------------------+
|              HERO SECTION                  |
|         (product visualization)            |
+-------------------------------------------+
|         FEATURE SECTION (cards)            |
+-------------------------------------------+
|         PRODUCT DEMO / SHOWCASE            |
+-------------------------------------------+
|         SOCIAL PROOF / TESTIMONIALS        |
+-------------------------------------------+
|         DOWNLOAD / CTA SECTION             |
+-------------------------------------------+
|              FOOTER                        |
+-------------------------------------------+
```

### Section Rhythm

- **Hero:** Full-viewport emphasis with large product illustration/animation
- **Feature Sections:** Alternating light-background sections, each with headline + supporting cards
- **Product Demos:** Large product screenshots or interface animations showing Arc's browser UI
- **Background Alternation:** White → off-white/tinted → white → gradient-accented
- **Section Spacing:** Generous vertical padding (~120-160px between sections)

### Content Flow

- Single-column centered content area (max-width approximately 1200px)
- Product illustrations often break the grid for visual impact
- Card-based layouts for feature descriptions (2-3 column grids)
- Alternating left/right layouts for feature breakdowns

### Breakpoints (Standard Web)

- Mobile: <768px (stacked single column)
- Tablet: 768-1024px (2-column cards)
- Desktop: >1024px (full layout, 3-column grids)

---

## Color System

### Brand Palette

Arc's signature color identity is a **multicolor gradient spectrum** — the defining visual element that sets it apart from single-accent SaaS brands.

#### Primary Brand Gradient

```css
--arc-gradient-primary: linear-gradient(
  135deg,
  #FF6B9D,  /* warm pink */
  #C44DFF,  /* vibrant purple */
  #6B8CFF,  /* blue */
  #4DE1FF,  /* cyan/teal */
  #FFB347   /* warm orange/amber */
);
```

This gradient appears on:
- Hero section backgrounds
- Call-to-action buttons
- Decorative elements
- Brand logo and wordmark
- Section dividers/highlights

#### Neutral Scale

```css
--arc-white: #FFFFFF;
--arc-off-white: #FAFAFA;
--arc-warm-gray-50: #F5F5F5;
--arc-warm-gray-100: #EEEEEE;
--arc-warm-gray-200: #E0E0E0;
--arc-warm-gray-300: #CCCCCC;
--arc-warm-gray-400: #AAAAAA;
--arc-warm-gray-500: #888888;
--arc-warm-gray-600: #666666;
--arc-warm-gray-700: #444444;
--arc-warm-gray-800: #333333;
--arc-warm-gray-900: #1A1A1A;
--arc-off-black: #111111;
--arc-black: #000000;
```

#### Accent Colors (Spectrum Stops)

```css
--arc-pink: #FF6B9D;
--arc-purple: #C44DFF;
--arc-blue: #6B8CFF;
--arc-cyan: #4DE1FF;
--arc-orange: #FFB347;
--arc-coral: #FF7B6B;
```

#### Semantic Colors

```css
--arc-text-primary: #1A1A1A;
--arc-text-secondary: #666666;
--arc-text-tertiary: #999999;
--arc-text-inverse: #FFFFFF;
--arc-surface-primary: #FFFFFF;
--arc-surface-secondary: #FAFAFA;
--arc-surface-elevated: #FFFFFF;
--arc-border-light: #E8E8E8;
--arc-border-medium: #DDDDDD;
```

#### Dark Mode / Dark Sections

Dark sections use a near-black background with the multicolor gradient as accent:

```css
--arc-dark-bg: #0D0D0D;
--arc-dark-surface: #1A1A1A;
--arc-dark-text-primary: #FFFFFF;
--arc-dark-text-secondary: #AAAAAA;
--arc-dark-gradient: linear-gradient(135deg, #FF6B9D, #C44DFF, #6B8CFF, #4DE1FF);
```

#### Gradient Opacity Layering

Gradients are layered at different opacities for various purposes:

```css
--arc-gradient-full: 1.0;    /* CTAs, hero accents */
--arc-gradient-strong: 0.85;  /* Section accents */
--arc-gradient-medium: 0.5;   /* Background washes */
--arc-gradient-subtle: 0.15;  /* Card borders, subtle glow */
--arc-gradient-ghost: 0.05;   /* Surface tinting */
```

---

## Typography System

### Font Stack

Arc uses a clean, modern sans-serif stack with premium custom/curated fonts:

```css
--arc-font-display: 'Instrument Sans', 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
--arc-font-body: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
--arc-font-mono: 'SF Mono', 'JetBrains Mono', 'Fira Code', monospace;
```

**Note:** Instrument Sans is a geometric sans-serif designed for display use, commonly associated with modern product brands. Inter serves as the workhorse body font.

### Type Scale

```css
--arc-text-hero: clamp(3rem, 6vw, 5rem);       /* ~48-80px — Hero headline */
--arc-text-display: clamp(2.25rem, 4vw, 3.5rem); /* ~36-56px — Section titles */
--arc-text-h1: clamp(2rem, 3.5vw, 3rem);        /* ~32-48px */
--arc-text-h2: clamp(1.5rem, 2.5vw, 2.25rem);   /* ~24-36px */
--arc-text-h3: clamp(1.25rem, 2vw, 1.75rem);    /* ~20-28px */
--arc-text-h4: 1.25rem;                          /* 20px */
--arc-text-body-lg: 1.125rem;                    /* 18px */
--arc-text-body: 1rem;                           /* 16px */
--arc-text-body-sm: 0.875rem;                    /* 14px */
--arc-text-caption: 0.75rem;                     /* 12px */
--arc-text-label: 0.75rem;                       /* 12px, uppercase tracking */
```

### Weight Distribution

```css
--arc-font-weight-light: 300;
--arc-font-weight-regular: 400;
--arc-font-weight-medium: 500;
--arc-font-weight-semibold: 600;
--arc-font-weight-bold: 700;
```

- **Hero/Display:** Semibold (600) or Bold (700)
- **Section Headings:** Semibold (600)
- **Body:** Regular (400)
- **Labels/Captions:** Medium (500) with letter-spacing
- **CTAs/Navigation:** Medium (500)

### Line Heights

```css
--arc-line-height-tight: 1.1;    /* Hero, display */
--arc-line-height-snug: 1.25;    /* Headings h1-h3 */
--arc-line-height-normal: 1.5;   /* Body text */
--arc-line-height-relaxed: 1.6;  /* Large body */
--arc-line-height-loose: 1.75;   /* Long-form reading */
```

### Letter Spacing

```css
--arc-tracking-tight: -0.02em;    /* Hero and display headings */
--arc-tracking-snug: -0.01em;     /* h1-h2 headings */
--arc-tracking-normal: 0;         /* Body text */
--arc-tracking-wide: 0.02em;      /* Labels, captions */
--arc-tracking-wider: 0.05em;     /* Uppercase labels */
```

---

## Motion & Animation

### Animation Library

Arc likely uses one or more of: CSS animations, Framer Motion, custom JS, or GSAP for scroll-driven effects.

### Page Load Animations

| Element | Effect | Duration | Easing |
|---------|--------|----------|--------|
| Hero headline | Fade up + blur-in | 0.8s | ease-out |
| Hero product visual | Scale fade-in | 1.0s | ease-out (delayed 0.2s) |
| Navigation | Fade down | 0.4s | ease-out |
| Gradient background | Chromatic shift | 3-6s loop | linear / ease-in-out |
| CTA button | Fade up | 0.6s | ease-out (delayed 0.4s) |

### Scroll-Driven Animations

- **Section reveals:** Content fades up and in as sections enter viewport (Intersection Observer)
- **Product interface animations:** Browser UI elements animate as user scrolls — tabs opening, pages loading, demonstrating product features in-situ
- **Parallax layering:** Subtle parallax on product illustrations and decorative gradient elements
- **Staggered card reveals:** Feature cards stagger in with 100-150ms delays

### Hover Micro-Interactions

- **Cards:** Subtle scale (1.02) + shadow elevation on hover, 200-300ms ease-out
- **Buttons:** Background color/gradient shift, 200ms ease-out
- **Navigation links:** Underline animation or color shift
- **Product screenshots:** Subtle brightness/contrast shift on hover

### Duration Tokens

```css
--arc-duration-instant: 100ms;
--arc-duration-fast: 200ms;
--arc-duration-normal: 300ms;
--arc-duration-slow: 500ms;
--arc-duration-reveal: 800ms;
--arc-duration-ambient: 3000ms;   /* Background gradient shifts */
```

### Easing Tokens

```css
--arc-ease-default: cubic-bezier(0.4, 0, 0.2, 1);     /* Standard ease-out */
--arc-ease-smooth: cubic-bezier(0.32, 0.72, 0, 1);     /* Smoother deceleration */
--arc-ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);  /* Spring-like bounce */
--arc-ease-bounce: cubic-bezier(0.68, -0.55, 0.27, 1.55);
```

---

## Interaction & UX Patterns

### Navigation

- **Fixed top navigation** with the Arc logo (multicolor gradient icon) and CTA
- Clean minimal nav — few links, primary focus on the product
- Mobile: Hamburger menu or simplified nav bar
- Background: Transparent initially, becomes white/semi-transparent on scroll with backdrop blur

### Scrolling

- Smooth scroll behavior
- Section-based scroll with clear visual separation
- Back-to-top implied by fixed navigation

### CTAs

- **Primary CTA:** "Download Arc" or "Try Arc" — gradient-filled button
- **Secondary CTA:** Text link or outlined button
- CTA buttons feature the brand multicolor gradient as background
- Rounded pill shape with generous padding

### Cards

- Feature cards with subtle borders (1px, light gray) or shadow
- Hover: Elevation increase + subtle border color shift
- Card backgrounds: White or off-white
- Card content: Icon + headline + description

### Accessibility

- Semantic HTML structure
- Alt text on product images
- Keyboard navigable
- Respects `prefers-reduced-motion`
- Sufficient color contrast (dark text on light backgrounds)

### Responsive Behavior

- **Desktop (1024px+):** Full multicolumn layout, large product visuals
- **Tablet (768-1024px):** 2-column cards, adjusted hero sizing
- **Mobile (<768px):** Single column, stacked cards, reduced hero complexity, mobile-optimized CTAs

---

## Spacing & Visual Rhythm

### Base Unit

Arc uses a **4px base grid** common in modern web design:

```css
--arc-space-1: 4px;
--arc-space-2: 8px;
--arc-space-3: 12px;
--arc-space-4: 16px;
--arc-space-5: 20px;
--arc-space-6: 24px;
--arc-space-8: 32px;
--arc-space-10: 40px;
--arc-space-12: 48px;
--arc-space-16: 64px;
--arc-space-20: 80px;
--arc-space-24: 96px;
--arc-space-32: 128px;
--arc-space-40: 160px;
```

### Section Padding

- **Vertical section padding:** ~120-160px (--arc-space-32 to --arc-space-40)
- **Horizontal container padding:** 24px mobile, 40px tablet, 80px desktop
- **Content max-width:** ~1200px

### Card Metrics

- **Card padding:** 24-32px
- **Card gap (grid):** 24-32px
- **Card border-radius:** 12-16px
- **Card shadow:** Subtle, 0 2px 8px rgba(0,0,0,0.06)

### Content Width

- **Max content width:** 1200px (centered)
- **Text measure (body):** ~65ch for readability
- **Narrow content (testimonials):** ~720px

### Density & White Space

- **White space ratio:** High — generous breathing room around all elements
- **Section density:** Low — one clear message per section
- **Element density:** Low — cards and features have ample padding
- **Visual rhythm:** Alternating content density creates visual interest

---

## Component Library

### Hero Section

```
+-------------------------------------------+
|  [Navigation: Logo + Links + CTA Button]   |
|                                            |
|         LARGE GRADIENT VISUAL              |
|     (product browser window / abstract)    |
|                                            |
|     Hero Headline (48-80px, semibold)      |
|     Subheadline (18-20px, secondary)       |
|                                            |
|         [CTA Button (gradient)]            |
|         [Secondary Link / Store Badges]    |
|                                            |
+-------------------------------------------+
```

- **Background:** White or off-white with multicolor gradient accent wash
- **Headline:** 48-80px, semibold, tight line-height, dark text
- **Subheadline:** 18-20px, regular weight, secondary gray
- **Visual:** Large product screenshot or abstract gradient composition
- **CTA:** Pill-shaped button with brand gradient fill, white text

### Feature Cards

```
+---------------------+  +---------------------+  +---------------------+
|                     |  |                     |  |                     |
|    [Icon/Graphic]   |  |    [Icon/Graphic]   |  |    [Icon/Graphic]   |
|                     |  |                     |  |                     |
|  Feature Title      |  |  Feature Title      |  |  Feature Title      |
|  Brief description  |  |  Brief description  |  |  Brief description  |
|  of the feature     |  |  of the feature     |  |  of the feature     |
|                     |  |                     |  |                     |
+---------------------+  +---------------------+  +---------------------+
```

- **Layout:** 3-column grid (desktop), 2-column (tablet), single column (mobile)
- **Card style:** White background, subtle border (1px #E8E8E8), 12-16px radius
- **Hover:** Shadow elevation, subtle border color shift to gradient tint
- **Icon:** Colored SVG icon or small gradient illustration at top
- **Typography:** h4 title (20px semibold) + body description (16px, secondary)

### Product Demo Section

- Large product screenshot or animated interface mockup
- Shows Arc browser UI (sidebar, tabs, spaces) in context
- Often accompanied by a side headline describing the feature
- May use scroll-triggered animations to "activate" interface elements

### Testimonials / Social Proof

- Quote cards with avatar, name, title, and testimonial text
- Clean card design with subtle shadow
- Publisher/media logos in a logo wall (grayscale, color on hover)

### CTA Section

- Gradient-accented background section (bottom of page)
- Large headline + subheadline
- Primary CTA button (gradient fill, large size)
- Platform badges (App Store, download links)

### Footer

- Multi-column layout (4-5 columns)
- Logo + brief description in first column
- Link categories: Product, Company, Resources, Legal
- Social media icon links
- Bottom bar with copyright

### Buttons

**Primary (Gradient Fill):**
```css
.arc-btn-primary {
  background: var(--arc-gradient-primary);
  color: #FFFFFF;
  padding: 14px 32px;
  border-radius: 9999px;  /* Fully rounded pill */
  font-weight: 500;
  font-size: 16px;
  transition: all 200ms ease-out;
}
.arc-btn-primary:hover {
  transform: scale(1.02);
  box-shadow: 0 8px 24px rgba(196, 77, 255, 0.3);
}
```

**Secondary (Outline):**
```css
.arc-btn-secondary {
  background: transparent;
  color: var(--arc-text-primary);
  border: 1.5px solid var(--arc-border-medium);
  padding: 14px 32px;
  border-radius: 9999px;
  font-weight: 500;
  font-size: 16px;
  transition: all 200ms ease-out;
}
.arc-btn-secondary:hover {
  border-color: var(--arc-purple);
  color: var(--arc-purple);
}
```

**Tertiary (Text Link):**
```css
.arc-btn-tertiary {
  background: none;
  border: none;
  color: var(--arc-text-secondary);
  font-weight: 500;
  font-size: 16px;
  padding: 8px 4px;
  transition: color 200ms ease-out;
}
.arc-btn-tertiary:hover {
  color: var(--arc-purple);
}
```

### Navigation Bar

```css
.arc-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 64px;
  padding: 0 40px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid transparent;
  transition: border-color 300ms ease, background 300ms ease;
  z-index: 100;
}
.arc-nav.scrolled {
  background: rgba(255, 255, 255, 0.95);
  border-bottom-color: var(--arc-border-light);
}
```

---

## Design Tokens Summary

### Complete CSS Custom Properties

```css
:root {
  /* === COLOR: Brand Gradient === */
  --arc-gradient-primary: linear-gradient(135deg, #FF6B9D, #C44DFF, #6B8CFF, #4DE1FF, #FFB347);
  
  /* === COLOR: Spectrum Accents === */
  --arc-pink: #FF6B9D;
  --arc-purple: #C44DFF;
  --arc-blue: #6B8CFF;
  --arc-cyan: #4DE1FF;
  --arc-orange: #FFB347;
  --arc-coral: #FF7B6B;
  
  /* === COLOR: Neutral Scale === */
  --arc-white: #FFFFFF;
  --arc-off-white: #FAFAFA;
  --arc-gray-50: #F5F5F5;
  --arc-gray-100: #EEEEEE;
  --arc-gray-200: #E0E0E0;
  --arc-gray-300: #CCCCCC;
  --arc-gray-400: #AAAAAA;
  --arc-gray-500: #888888;
  --arc-gray-600: #666666;
  --arc-gray-700: #444444;
  --arc-gray-800: #333333;
  --arc-gray-900: #1A1A1A;
  --arc-black: #000000;
  
  /* === COLOR: Semantic === */
  --arc-text-primary: #1A1A1A;
  --arc-text-secondary: #666666;
  --arc-text-tertiary: #999999;
  --arc-text-inverse: #FFFFFF;
  --arc-surface-primary: #FFFFFF;
  --arc-surface-secondary: #FAFAFA;
  --arc-border-light: #E8E8E8;
  --arc-border-medium: #DDDDDD;
  
  /* === COLOR: Dark Mode === */
  --arc-dark-bg: #0D0D0D;
  --arc-dark-surface: #1A1A1A;
  
  /* === TYPOGRAPHY: Font Family === */
  --arc-font-display: 'Instrument Sans', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  --arc-font-body: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  --arc-font-mono: 'SF Mono', 'JetBrains Mono', 'Fira Code', monospace;
  
  /* === TYPOGRAPHY: Font Size === */
  --arc-text-hero: clamp(3rem, 6vw, 5rem);
  --arc-text-display: clamp(2.25rem, 4vw, 3.5rem);
  --arc-text-h1: clamp(2rem, 3.5vw, 3rem);
  --arc-text-h2: clamp(1.5rem, 2.5vw, 2.25rem);
  --arc-text-h3: clamp(1.25rem, 2vw, 1.75rem);
  --arc-text-h4: 1.25rem;
  --arc-text-body-lg: 1.125rem;
  --arc-text-body: 1rem;
  --arc-text-body-sm: 0.875rem;
  --arc-text-caption: 0.75rem;
  
  /* === TYPOGRAPHY: Weight === */
  --arc-weight-light: 300;
  --arc-weight-regular: 400;
  --arc-weight-medium: 500;
  --arc-weight-semibold: 600;
  --arc-weight-bold: 700;
  
  /* === TYPOGRAPHY: Line Height === */
  --arc-leading-tight: 1.1;
  --arc-leading-snug: 1.25;
  --arc-leading-normal: 1.5;
  --arc-leading-relaxed: 1.6;
  
  /* === TYPOGRAPHY: Letter Spacing === */
  --arc-tracking-tight: -0.02em;
  --arc-tracking-snug: -0.01em;
  --arc-tracking-normal: 0;
  --arc-tracking-wide: 0.02em;
  --arc-tracking-wider: 0.05em;
  
  /* === MOTION: Duration === */
  --arc-duration-instant: 100ms;
  --arc-duration-fast: 200ms;
  --arc-duration-normal: 300ms;
  --arc-duration-slow: 500ms;
  --arc-duration-reveal: 800ms;
  
  /* === MOTION: Easing === */
  --arc-ease-default: cubic-bezier(0.4, 0, 0.2, 1);
  --arc-ease-smooth: cubic-bezier(0.32, 0.72, 0, 1);
  --arc-ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);
  
  /* === SPACING: 4px Base Grid === */
  --arc-space-1: 4px;
  --arc-space-2: 8px;
  --arc-space-3: 12px;
  --arc-space-4: 16px;
  --arc-space-5: 20px;
  --arc-space-6: 24px;
  --arc-space-8: 32px;
  --arc-space-10: 40px;
  --arc-space-12: 48px;
  --arc-space-16: 64px;
  --arc-space-20: 80px;
  --arc-space-24: 96px;
  --arc-space-32: 128px;
  --arc-space-40: 160px;
  
  /* === BORDER RADIUS === */
  --arc-radius-sm: 6px;
  --arc-radius-md: 10px;
  --arc-radius-lg: 14px;
  --arc-radius-xl: 20px;
  --arc-radius-full: 9999px;
  
  /* === SHADOWS === */
  --arc-shadow-card: 0 2px 8px rgba(0, 0, 0, 0.06);
  --arc-shadow-card-hover: 0 8px 24px rgba(0, 0, 0, 0.1);
  --arc-shadow-button: 0 4px 16px rgba(196, 77, 255, 0.25);
  --arc-shadow-nav: 0 1px 3px rgba(0, 0, 0, 0.04);
  
  /* === LAYOUT === */
  --arc-content-max-width: 1200px;
  --arc-section-padding-y: 128px;
  --arc-section-padding-x-desktop: 80px;
  --arc-section-padding-x-tablet: 40px;
  --arc-section-padding-x-mobile: 24px;
}
```

---

## Key Takeaways

### What Defines Arc's Design

1. **Gradient-as-Identity:** Arc's multicolor gradient (pink-purple-blue-cyan-orange) is not just decorative — it IS the brand. Unlike most SaaS companies that rely on a single accent color, Arc uses the full spectrum as its primary visual differentiator. This communicates creativity, warmth, and the idea that the browser contains "all of the internet."

2. **Warm Minimalism:** Arc deliberately avoids cold, technical aesthetics. The off-white backgrounds, rounded surfaces, and human-centric typography make a browser feel approachable rather than utilitarian.

3. **Product-as-Hero:** The Arc browser interface itself is the star of the marketing. Large product screenshots and animated UI demonstrations let the product's design speak for itself, rather than relying on abstract illustrations or stock photography.

4. **Personality-Driven Color:** Where most tech brands use color sparingly (accents only), Arc uses vibrant color generously as a brand statement. The gradient appears on buttons, backgrounds, decorative elements, and the logo itself.

5. **Typography as Warmth:** Font choices (Instrument Sans for display, Inter for body) favor geometric warmth over neutral/grotesk coldness. The result is readable but distinctive.

6. **High White Space Ratio:** Generous padding and section spacing create a premium, breathing feel. Content never feels cramped.

7. **Subtle Motion with Purpose:** Animations are restrained — fade-ups and scroll reveals with smooth easing. The product demo animations are the most elaborate, serving a functional purpose of demonstrating the browser's capabilities.

8. **Glass-Morphism Navigation:** The semi-transparent backdrop-blur navigation bar is a signature touch, allowing content to show through while maintaining readability.

### Design Decisions Worth Studying

- **Multicolor gradient as brand signature** — risky but distinctive
- **Warm typography pairing** — Instrument Sans + Inter is warm but professional
- **Product-as-marketing** — the UI is so good it sells itself
- **Glass nav** — functional transparency that feels premium
- **Generous white space** — confidence through breathing room

---

## Extraction Limitations

### Access Blocked

The arc.net website is protected by Cloudflare's bot mitigation and returned HTTP 403 (Forbidden) to automated requests at the time of extraction. Per the responsible fetching policy, all further requests were halted (circuit breaker triggered).

### What Could Not Be Verified

The following aspects of this analysis are based on training knowledge and design research, not direct extraction:

- Exact CSS custom property names and values
- Precise font names beyond inference
- Specific animation durations and easings
- Exact breakpoint pixel values
- Whether the site uses Framer, Webflow, or custom builds
- Specific JavaScript animation libraries (GSAP, Framer Motion, etc.)
- Exact gradient stop positions and angles
- Current (May 2026) site content versus training data knowledge

### What This Analysis Represents

This design system document represents a **best-effort reconstruction** based on:
- Training data knowledge of Arc Browser's brand identity
- Known design patterns of The Browser Company
- Standard web design system conventions
- Visual design principles consistently associated with the Arc brand

For a fully verified extraction, manual browser-based inspection would be required. The design tokens and values provided should be treated as representative approximations rather than exact specifications.

### Requests Made

- 1 HTTP request attempted (blocked at 403)
- 2 Web search queries attempted (API unavailable)
- 0 CSS/JS files fetched
- Total data downloaded: 0 bytes
- Circuit breaker: Triggered by HTTP 403 on first request
