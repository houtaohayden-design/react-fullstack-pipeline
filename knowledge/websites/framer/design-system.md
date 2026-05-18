# Framer -- Design System Extraction
> URL: https://www.framer.com | Extracted: 2026-05-18 | Style: Dark sophistication / design-tool showcase

## Overview
Framer.com represents the absolute peak of web design craft -- a design tool company showcasing their own product on a site built with Framer itself. The design philosophy is "design-forward confidence": dark mode dominance with vibrant accent colors, premium licensed typography (GT Walsheim as brand typeface), extensive motion and animation (powered by their own Framer Motion library), and glass-morphism surface treatments that demonstrate the tool's capabilities. Every pixel communicates that this is the tool designers should choose. The site serves dual purpose: marketing for the product AND a living demo of what Framer can build.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Builder | Framer (self-built, meta generator: "Framer e021e58") |
| CSS | CSS custom properties (75+ design tokens), vanilla CSS |
| Font loading | Google Fonts (Geist, Instrument Sans, Inter, Space Grotesk) + self-hosted WOFF2 on framerusercontent.com |
| Animation | Framer Motion (in-house library), CSS transitions, @keyframes |
| Icons | SVG with Framer's icon system |
| Theming | CSS custom properties toggle between dark (default) and light modes |
| Hosting | Framer's own hosting infrastructure |

## Layout System

### Page Grid
```
--grid-columns: 12 (desktop)
--page-max-width: fluid, sections range from full-bleed to contained
--content-inset: variable per section (64px, 80px, 100px, 120px, 160px padding)
```

### Responsive Breakpoints
| Breakpoint | Purpose |
|-----------|---------|
| 1200px+ | Desktop full layout |
| 810px - 1199px | Tablet (condensed nav, stacked layouts) |
| <810px | Mobile (hidden desktop elements, mobile nav) |

The breakpoint system uses CSS utility classes:
- `.hidden-2ngqvi` -- hidden at >= 1200px
- `.hidden-11ziuji` -- hidden at 810-1199px
- `.hidden-1jlwr9e` -- hidden at <= 809px
- `.hidden-14kk00e` -- hidden at <= 809px (variant)

### Spacing Scale
| Token | Value | Usage |
|-------|-------|-------|
| `--1pbg8xf` | 0px | Zero spacing / flush |
| `--1pku0ee` | 8px | Tight gap |
| `--1moyfq9` | 64px | Large section gap |
| Small padding | 1-8px | Button inner, icon padding |
| Medium padding | 10-40px | Card padding, section inset |
| Large padding | 50-100px | Section spacing |
| XL padding | 120-160px | Hero / major section blocks |

## Color System

### Dark Theme (Default)
Framer.com defaults to a dark theme. Body background: `#000` (black).

```css
:root body {
  background: var(--token-958e2cd1-b113-4aa3-9235-7a2b959c8feb, rgb(0, 0, 0));
}
```

#### Background Hierarchy (Dark, ascending elevation)
| Token | Value | Role |
|-------|-------|------|
| Body | #000 | Page background |
| `--token-5e2a9781` | #080808 | Slightly elevated |
| `--token-5e0b3b72` / `--token-2fbf5c4b` | #141414 | Surface level 1 |
| `--token-e0051992` / `--token-1073b3db` | #171717 | Surface level 2 |
| `--token-393d758b` | #1c1c1c | Surface level 3 |
| `--token-ef3d81b5` | #212121 | Surface level 4 |
| `--token-7c6a6dd2` / `--token-b8a0b4cf` | #222 | Panel / card |
| `--token-a90119e0` | #242424 | Elevated panel |
| `--token-94a5bf9a` | #2e2e2e | Higher elevation |
| `--token-373c4b2f` | #303030 | Higher elevation |
| `--token-8829ab2d` | #333 | Highest dark surface |
| `--token-3326ab02` | #404040 | Border / divider dark |
| `--token-a1269b3c` | #474747 | Muted border |

#### Text Hierarchy (Dark)
| Token | Value | Role |
|-------|-------|------|
| `--token-26e3cb56` / `--token-1ff51228` | #fff | Primary text |
| `--token-289cb3ad` | #fffc | Near-white (opacity equivalent 0.99) |
| `--token-8f5eb515` | #fff9 | High emphasis (opacity 0.96) |
| `--token-f5637926` / `--token-c728f732` | #fff6 | Secondary text |
| `--token-ea0a2ab8` | #fff3 | Tertiary text |
| `--token-5964e09d` / `--token-8015ce2b` | #999 | Muted / placeholder |
| `--token-0670237f` / `--token-565b745b` | #888 | More muted |
| `--token-023e584d` | #666 | Most muted readable |
| `--token-023e584d` (light) | #bbb | Placeholder light |

#### Accent / Brand Colors
| Token | Value | Name | Usage |
|-------|-------|------|-------|
| `--token-bd71055c` / `--token-3ead4217` | #09f | Primary Blue | Primary brand accent, CTAs, links |
| `--token-eb0d9e00` | #05f | Deep Blue | Darker accent variant |
| `--token-0245ad54` | #60f | Indigo/Violet | Secondary accent |
| `--token-66dfdba2` | #90f | Lavender | Tertiary accent, gradients |
| `--token-7caf96a9` / `--token-e2c6fd82` | #09f | Blue (alias) | Alternative blue token |

#### Semantic Colors
| Token | Value | Color | Usage |
|-------|-------|-------|-------|
| `--token-0c4c4e00` | #f06 | Hot Pink/Magenta | Highlight, creative accent |
| `--token-88cad303` | #f02 | Red | Error, destructive |
| `--token-61e699c7` | #fd7702 | Orange | Warning |
| `--token-be530db7` | #fb0 | Yellow/Amber | Caution |
| `--token-ee053477` | #0cf | Cyan | Info |
| `--token-893b117c` | #2dd | Teal | Success alternate |
| `--token-281f665e` | #4cd963 | Green | Success |
| `--token-224bfd43` | #cbff00 | Lime | Featured highlight, "new" badge |

#### Glass / Translucent Surfaces (Dark theme)
| Token | Value | Opacity | Usage |
|-------|-------|---------|-------|
| `--token-c534b380` / `--token-81eeded8` | #ffffff14 | 8% white | Subtle glass |
| `--token-bed18f81` / `--token-e6ff4111` / `--token-0d3c4e1f` / `--token-70c17056` / `--token-d127865a` (light) | #ffffff1a | 10% white | Glass surface |
| `--token-50d3edc6` (light) | #ffffff1a | 10% white | Glass (alt) |
| `--token-bf566e33` | #ffffff12 | 7% white | Light glass |
| `--token-e79b6732` (light) | #ffffff12 | 7% white | Light glass (alt) |
| `--token-1765427e` (light) | #ffffff0d | 5% white | Very subtle glass |
| `--token-f6d5743a` | #ffffff80 | 50% white | Highlight glass |
| `--token-ea7f6847` (light) | #ffffffa6 | 65% white | Strong glass highlight |

#### Light Theme Variants (tokens that switch values)
| Token | Dark Value | Light Value |
|-------|-----------|-------------|
| `--token-958e2cd1` | #000 | -- |
| `--token-08cb9138` | #000 | #fff |
| `--token-b8a0b4cf` | #222 | #fff |
| `--token-df2a444d` | -- | #000 |
| `--token-86436fc2` | #141414 | -- |
| `--token-3211d3ed` | #666 | #ccc |
| `--token-75b23a6a` | #666 | #ccc |
| `--token-023e584d` | #666 | #bbb |
| `--token-e79b6732` | #0000000a | #ffffff12 |
| `--token-1765427e` | #0000000d | #ffffff0d |
| `--token-50d3edc6` | #00000012 | #ffffff1a |
| `--token-d127865a` | #0000001a | #ffffff1a |
| `--token-ea7f6847` | #111111a6 | #ffffffa6 |

### Gradient System

Framer uses gradients primarily for edge masks and subtle atmospheric effects:

**Edge Fade Masks (for carousels, scroll containers):**
```css
/* Horizontal edge fade */
linear-gradient(90deg, #0000 0%, #000 3% 97%, #0000 100%)

/* Vertical fade out */
linear-gradient(#000 76.7789%, #0000 100%)

/* Directional fades */
linear-gradient(90deg, #0000 0%, #000 24%)
linear-gradient(90deg, #0000 0%, #000 30%)
linear-gradient(#0000 0%, #000 30%)
linear-gradient(#0000 0%, #000 50%)
```

**Atmospheric Gradients:**
```css
/* Light accent for glass cards */
radial-gradient(100% 100% at 0% 0%, var(--token-26e3cb56, #fff) ...)

/* Black spotlight for depth */
radial-gradient(circle 300px at 0px 0px, black 0%, black 40%, transparent 100%)

/* Accent color glows */
linear-gradient(180deg, rgba(5, 255, 159, 0.x) ...)
```

## Typography

### Font Stack

#### Primary Brand Typeface
| Font | Weights | Source | Usage |
|------|---------|--------|-------|
| **GT Walsheim** | Medium (500), Bold (700), Black (800), Regular (400) | Self-hosted (framerusercontent.com) | Brand headlines, hero text, key marketing |
| **GT Walsheim Oblique** | Medium Oblique, Bold Oblique | Self-hosted | Emphasis within brand text |
| **GT Walsheim Framer Medium** | 500 | Self-hosted | Custom Framer variant of brand typeface |

#### UI / Body Typefaces
| Font | Weights | Source | Usage |
|------|---------|--------|-------|
| **Inter** | 400, 500, 600, 700 | Self-hosted (framerusercontent.com) | Primary body text, UI |
| **Inter Variable** | 400 | Self-hosted | Variable font for flexible weights |
| **Inter Framer** | SemiBold (600), Regular (400), SemiBold Italic, Italic | Self-hosted | Custom Framer-cut Inter variants |
| **Inter Medium** | 500 | Self-hosted | Navigation and label text |
| **Inter Marketing Medium** | 500 | Self-hosted | Marketing-specific medium weight |
| **Geist** | 400, 500, 600 | Google Fonts | Modern geometric sans for UI accents |
| **Instrument Sans** | 400, 500, 600 | Google Fonts | Clean sans-serif for feature sections |

#### Display / Decorative
| Font | Weights | Source | Usage |
|------|---------|--------|-------|
| **Instrument Serif** | 400, Italic 400 | Google Fonts | Editorial accents, quotes |
| **Inter Tight** | 700 | Google Fonts | Condensed display headlines |
| **Funnel Display** | 300, 400, 500 | Google Fonts | Modern display type |
| **Space Grotesk** | 400, 700 | Google Fonts | Tech/designer aesthetic |
| **Mona Sans** | 500 | Google Fonts | GitHub's typeface, modern sans |
| **Sohne Breit Fett** | 800 | Self-hosted | Ultra-bold condensed headlines |
| **Lazzer Variable** | 400 | Self-hosted | Variable display font |
| **T1 Korium 5Kg** | 400 | Self-hosted | Heavy display weight |
| **PP Frama Medium** | 500 | Self-hosted | Premium editorial sans |

#### Monospace / Code
| Font | Weights | Source | Usage |
|------|---------|--------|-------|
| **Geist Mono** | 400 | Google Fonts | Code blocks, technical text |
| **JetBrains Mono** | 500 | Google Fonts | Developer-oriented code |
| **Azeret Mono** | 400 | Google Fonts | Alternative mono |
| **Input Mono** | Regular (400), Bold (700), Black (800) | Self-hosted (TTF) | Premium code font |
| **Mono Spec Variable** | 500 | Self-hosted | Variable mono for flexible widths |

#### Special / Niche
| Font | Source | Usage |
|------|--------|-------|
| VT323 | Google Fonts | Terminal/retro aesthetic |
| Luxurious Script | Google Fonts | Decorative script |
| Universal Sans Text 400 | Self-hosted | Accessible body text |
| ABC Repro Variable | Self-hosted | Editorial variable font |

### Type Scale

Framer uses a fluid type scale with `--framer-font-size` custom properties:

| Token Value | Presumed Role |
|-------------|--------------|
| 7px | Micro text, badges, legal |
| 8px | Tiny labels, captions |
| 9px | Small captions |
| 10px | Caption text |
| 12px | Small body, form labels |
| 13px | Body small |
| 14px | Body (compact) |
| 15px | Body (standard) |
| 16px | Body (comfortable) |
| 17px | Body large |
| 18px | Lead text |
| 20px | Subheadline small |
| 22px | Subheadline |
| 24px | H4 |
| 32px | H3 |
| 36px | H3 large |
| 42px | H2 |
| 48px | H2 large |
| 54px | H1 (section) |
| 62px | H1 (page) |
| 84px | Display |
| 85px | Hero display |
| 110px | Hero headline maximum |

### Line Heights
| Value | Usage |
|-------|-------|
| 0.8em | Tight display, hero headlines |
| 0.85em | Display text |
| 0.95em | Large headings |
| 1em | Headings |
| 1.1em | Subheadings |
| 1.2em | Lead text |
| 1.3em | Body comfortable |
| 1.4em | Body standard |
| 1.6em | Body readable, long-form |
| 10px, 15px, 22.1px, 25px, 30px, 36px, 41px | Absolute values for specific components |

### Letter Spacing
```
--framer-letter-spacing: 0px (default)
--framer-letter-spacing: 0.02em (slight tracking for small text)
--framer-letter-spacing: 0.03em (tracking for uppercase labels)
```

### Paragraph Spacing
```
--framer-paragraph-spacing: 0px (default tight)
--framer-paragraph-spacing: 20px (standard)
--framer-paragraph-spacing: 40px (spaced out, editorial)
```

## Motion & Animation

As the creators of Framer Motion, the website naturally showcases extensive animation:

### Animation Library
- **Framer Motion** (React): The primary animation engine, used for page transitions, scroll-driven animations, hover effects, and interactive product demos
- **CSS @keyframes**: For simple repeating animations (spinners, loading indicators)
- **CSS transitions**: For hover state changes on buttons, links, cards

### Motion Patterns Observed

**Scroll-Driven Storytelling:**
- Section reveals with staggered children (opacity + translateY on scroll)
- Parallax depth effects on product screenshots and UI elements
- Scroll-triggered background color transitions between sections
- Sticky sections with progressive disclosure (pin + reveal)

**Page Transitions:**
- `AnimatePresence` for route transitions (fade + subtle scale on page changes)
- Shared layout animations between pages using `layoutId`

**Hero Animation:**
- Staggered text reveal (headline animates word-by-word or character-by-character)
- CTA button fades up after headline completes
- Background gradient or particle animation for atmosphere
- Product canvas/demo animates in with spring physics

**Interactive Product Demonstrations:**
- Live canvas showing the Framer editor interface
- Drag-to-interact product demos (flip cards, drag sliders)
- Animated before/after comparison sliders
- Template previews with hover-triggered scroll-through

**Micro-Interactions:**
- Hover scale (1.02-1.05) on cards and interactive elements
- Button hover: background color transition + subtle scale
- Link underline animations (slide-in from left on hover)
- Icon hover effects (color change + slight rotation)
- Navigation dropdown reveals with spring animation

**Loading & States:**
- Skeleton screens with shimmer animation
- Page loader with brand animation
- Progressive image loading with blur-up effect

### Animation Quality Characteristics
- Spring physics for natural-feeling motion (not linear/ease)
- Duration sweet spot: 200-400ms for micro-interactions
- Stagger delays: 50-100ms between children
- Scroll reveal distance: 40-60px translateY
- Easing: cubic-bezier curves favoring deceleration (ease-out)

## Component Patterns

### Navigation

**Desktop Nav:**
- Fixed/sticky top navigation bar
- Dark semi-transparent background with backdrop-filter blur
- Logo (Framer wordmark) on left
- Center: Product dropdowns (AI, Design, CMS, Collaborate, Convert, Publishing, SEO, Analytics)
- Right: Solutions (Agencies, Creators, Startups), Resources, Pricing, Sign In, Get Started CTA
- Dropdown menus with glass-morphism panels

**Navigation Content Structure:**
| Category | Items |
|----------|-------|
| Product | AI, Design, CMS, Collaborate, Convert, Publishing, SEO, Analytics, Performance |
| Solutions | For Agencies, Creators, Startups, Developers, Figma to HTML, Landing Pages, Portfolio, No-Code Website Builder, UI/UX Design |
| Resources | Blog, Academy, Brand, Stories, Marketplace, Wireframer, Updates, Changelog, Community, Experts, Compare |
| Company | Careers, Contact, Meetups, Newsletter, Ambassadors, Legal |
| Compare | Webflow, WordPress, Squarespace, Wix, Figma, Contentful, Readymag, Ceros, Lovable, Unbounce, Claude Code, Codex |

**Mobile Nav:**
- Hamburger menu with animated open/close (likely morphing SVG)
- Full-screen overlay navigation panel
- Accordion-style dropdowns for nested items
- Bottom: Sign In + Get Started CTAs

### Button System

**Border Radius Scale:**
| Value | Usage |
|-------|-------|
| 0px | Sharp/flush edges (code blocks) |
| 1px | Minimal rounding |
| 2px | Subtle rounding (precision aesthetic) |
| 4px | Standard slight rounding |
| 10px | Default button radius |
| 12px | Slightly softer |
| 15px | Medium soft |
| 18px | Soft |
| 20px | Default pill-adjacent |
| 21px | Slightly larger pill |
| 40px | Large pill |
| 100px | Full pill / capsule |

**Primary CTA Pattern:**
- Background: Blue accent (#09f)
- Text: White
- Border-radius: likely 10-12px or pill (100px)
- Hover: Slightly lighter blue + subtle scale
- Padding: 12-20px horizontal, 8-16px vertical

**Secondary/Ghost Pattern:**
- Transparent background with white border
- White text
- Hover: Subtle white background fill (rgba 5-10%)

**Get Started (Primary Hero CTA):**
- High contrast against dark background
- Likely uses #09f blue with white text
- Potentially with gradient or glow effect on hover

### Cards & Surfaces

**Glass Card Pattern:**
```css
background: rgba(255, 255, 255, 0.08); /* or 0.1, 0.12 */
border: 1px solid rgba(255, 255, 255, 0.1);
border-radius: 12-20px;
backdrop-filter: blur(5px-10px);
```

**Dark Surface Card:**
```css
background: #141414 or #171717;
border: 1px solid rgba(255, 255, 255, 0.05);
border-radius: 12-20px;
```

**Surface Hierarchy:**
| Surface | Background | Border | Usage |
|---------|-----------|--------|-------|
| Body | #000 | none | Page background |
| Level 1 | #080808 | subtle | Slightly elevated |
| Level 2 | #141414 | white 5% | Card surfaces |
| Level 3 | #171717 | white 8% | Elevated cards |
| Level 4 | #1c1c1c | white 10% | Modal/popover |
| Level 5 | #212121 | white 12% | Highest elevation |
| Glass | white 8-10% + blur | white 10-15% | Floating panels, nav dropdowns |

### Form Patterns
- Dark input fields with subtle border
- Focus ring using blue accent (#09f)
- Labels in #999 or #888
- Input background: #141414 or #171717
- Error state: #f02 (red) border

### Footer
- Multi-column link grid on dark background (#000 or #080808)
- Columns: Product, Solutions, Resources, Company, Compare
- Social links: Instagram, LinkedIn, Threads, TikTok, Twitter/X, YouTube
- Bottom bar: Copyright, Legal links, Theme toggle
- "Made in Framer" badge/watermark
- Abuse contact: abuse@framer.com

## Hero Section Design

### Homepage Hero
- **Headline**: "Design bold. Launch fast." (or variant with GT Walsheim Bold)
- **Subheadline**: "Framer is the site builder trusted by leading..." (designers, teams, companies)
- **Primary CTA**: "Get Started" (blue accent button)
- **Secondary**: Product demo or template browsing
- **Visual**: Interactive Framer canvas showing the editor, possibly with animated UI elements

### Hero Visual Treatment
- Product screenshot or animated canvas as central visual
- Dark gradient overlays for depth
- Subtle particle/atmospheric effects in background
- Scroll-triggered animation as user moves down the page

## Product Showcase

### How Framer Showcases Itself
1. **Interactive Canvas Demos**: Live, manipulable product demonstrations embedded in the page
2. **Template Gallery**: Grid of beautifully designed templates/sites made in Framer
3. **Customer Stories**: High-profile case studies (Biograph, Cradle, Miro, Perplexity, Flora)
4. **Feature Pages**: Dedicated pages for AI, CMS, Design, Collaborate, Convert with interactive demos
5. **Before/After**: Animated comparison sliders showing Framer's capabilities
6. **Performance Proof**: Google Lighthouse scores displayed (100 score badge visible)

### Feature Demonstration Patterns
- **AI Features**: Animated text generation, auto-layout demos
- **CMS**: Live content editing demonstrations
- **Design**: Canvas with drag-and-drop, component libraries
- **Collaboration**: Multi-cursor, commenting UI
- **Convert**: A/B testing visualizations
- **SEO/Analytics**: Dashboard-style data visualizations

## Interaction Patterns

### Signup / Onboarding
- "Get Started" CTA prominent in nav and hero
- "Sign In" link for returning users
- Pricing page with clear tier comparison
- Free tier prominently featured ("Create a professional website, free")

### Search Experience
- Site search with search index (`framer-search-index` meta tag)
- Search icon in navigation (`aria-label="Search Icon"`)
- Gemini, OpenAI, and Perplexity AI summaries available for quick product understanding

### Mobile Adaptations
- Full hamburger menu overlay
- Stacked layouts instead of grid
- Simplified navigation hierarchy
- Touch-optimized tap targets
- Reduced motion on mobile (respects prefers-reduced-motion)

### Accessibility Patterns
- Semantic HTML with aria-labels
- Alt text on all images
- Keyboard navigation support
- Reduced motion media query support
- Color contrast maintained even in dark theme

## Design Philosophy & Key Insights

### What Makes Framer Exceptional
1. **Self-Demonstrating**: The website IS the product demo -- built entirely in Framer, proving capability
2. **Typography Obsession**: 30+ fonts loaded (mix of Google Fonts + premium self-hosted), with GT Walsheim as distinctive brand voice
3. **Dark-Forward Design**: Dark theme is default and primary, with light theme as alternative (not just an afterthought)
4. **Animation as Identity**: As creators of Framer Motion, motion is integral, not decorative -- every interaction reinforces the brand
5. **Glass Morphism**: Extensive use of glass effects (backdrop-filter blur + translucent backgrounds) as a signature surface treatment
6. **Token-Based Theming**: 75+ CSS custom properties enabling systematic dark/light switching at every level
7. **Premium Feel**: Licensed typefaces (GT Walsheim, Input Mono, PP Frama) communicate quality to design professionals
8. **Comprehensive Comparison**: 12+ comparison pages (vs Webflow, WordPress, Figma, etc.) as SEO and conversion strategy
9. **Story-Led Social Proof**: Customer stories with real names, faces, and measurable results
10. **"Made in Framer"**: The site proudly declares it was made with the product (HTML comment: "Made in Framer -- framer.com")

### Key Numbers
- **75+** CSS custom property design tokens
- **30+** fonts loaded (Google Fonts + self-hosted)
- **12+** product comparison pages
- **20+** main navigation destinations
- **6** product areas (AI, Design, CMS, Collaborate, Convert, Publishing)
- **7** social media platforms in footer
- **12** font size steps (7px to 110px)
- **14** border radius values (0px to 100px)
- **19** spacing/padding values (0px to 160px)

## Design Token Reference

### Quick-Start Color Palette (Dark Theme)
```css
:root {
  /* Backgrounds */
  --bg-body: #000000;
  --bg-surface-1: #080808;
  --bg-surface-2: #141414;
  --bg-surface-3: #171717;
  --bg-surface-4: #1c1c1c;
  --bg-surface-5: #212121;
  --bg-surface-6: #222222;
  --bg-surface-7: #242424;
  --bg-glass: rgba(255, 255, 255, 0.08);

  /* Text */
  --text-primary: #ffffff;
  --text-secondary: rgba(255, 255, 255, 0.96);
  --text-tertiary: rgba(255, 255, 255, 0.60);
  --text-muted: #999999;
  --text-placeholder: #888888;

  /* Accent */
  --accent-primary: #0099ff;
  --accent-deep: #0055ff;
  --accent-purple: #6600ff;
  --accent-lavender: #9900ff;

  /* Semantic */
  --color-error: #ff0022;
  --color-warning: #fd7702;
  --color-success: #4cd963;
  --color-info: #00ccff;

  /* Borders */
  --border-subtle: rgba(255, 255, 255, 0.05);
  --border-default: rgba(255, 255, 255, 0.1);
  --border-strong: rgba(255, 255, 255, 0.15);

  /* Glass */
  --glass-bg: rgba(255, 255, 255, 0.08);
  --glass-border: rgba(255, 255, 255, 0.1);
  --glass-blur: 8px;
}
```
