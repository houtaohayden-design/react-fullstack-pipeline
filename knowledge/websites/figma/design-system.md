# Figma Design System

> Extracted from https://www.figma.com on 2026-05-18
> Built with Next.js on Netlify, Sanity CMS, emotion CSS-in-JS + motion library

---

## Overview

Figma's marketing website is a masterclass in design-tool self-demonstration -- the product that makes design tools eats its own dogfood. Built on Next.js with emotion CSS-in-JS and the motion library (framer-motion), it uses a 40-column precision grid system, a custom variable font weight axis, and a comprehensive `--f-*` CSS custom property namespace. The design communicates engineering precision with designer sensibility: non-standard font weights, asymmetric grid splits, conic-gradient color wheels, and section-specific accent colors that map directly to Figma's product palette.

| Property | Value |
|----------|-------|
| **Framework** | Next.js (SSG via Netlify) |
| **CMS** | Sanity (headless CMS) |
| **CSS-in-JS** | emotion |
| **Animation** | motion (framer-motion) + CSS @keyframes |
| **Font System** | ABC Whyte Plus Variable (brand) + figmaSans (UI) + figmaMono (code) |
| **Grid** | 40-column flexible grid (`--f-col-width` base unit) |
| **Design Token Namespace** | `--f-*` prefix |
| **Dark Mode** | `@media (prefers-color-scheme: dark)` system-following |
| **Languages** | 12 locales (en, de, es-es, es-la, fr, hi, id, it, ja, ko, nl, pl, pt-br, th) |

---

## Layout System

### Page Grid

Figma uses a sophisticated 40-column flexible grid system built on a `--f-col-width` base unit. Column counts per section vary from 6 to 40, distributed asymmetrically.

**CSS Custom Properties:**
```css
--f-col-width          /* Base column width unit */
--f-columns            /* Active column count */
--f-gutter             /* Gutter width */
--f-max-content-width  /* Maximum content width (137.5rem ≈ 2200px) */
```

**Asymmetric Grid Templates (homepage):**
```css
grid-template-columns: calc(var(--f-col-width) * 18) calc(var(--f-col-width) * 24);  /* 18+24 split */
grid-template-columns: calc(var(--f-col-width) * 18) calc(var(--f-col-width) * 26);  /* 18+26 split */
grid-template-columns: calc(var(--f-col-width) * 20) calc(var(--f-col-width) * 24);  /* 20+24 split */
grid-template-columns: calc(var(--f-col-width) * 28) calc(var(--f-col-width) * 12);  /* 28+12 split */
grid-template-columns: calc(var(--f-col-width) * 29) calc(var(--f-col-width) * 11);  /* 29+11 split */
grid-template-columns: calc(var(--f-col-width) * 29) calc(var(--f-col-width) * 13);  /* 29+13 split */
grid-template-columns: calc(var(--f-col-width) * 30) calc(var(--f-col-width) * 10);  /* 30+10 split */
grid-template-columns: calc(var(--f-col-width) * 13) repeat(4, calc(var(--f-col-width) * 6)); /* 13+4x6 */
grid-template-columns: repeat(2, calc(var(--f-col-width) * 4));   /* 2x4 blocks */
grid-template-columns: repeat(2, calc(var(--f-col-width) * 8));   /* 2x8 blocks */
```

### Content Flow

| Zone | Width | Notes |
|------|-------|-------|
| Max content width | 137.5rem (2200px) | Very generous -- showcases the product |
| Content inner | 908px | Narrower reading width for text-heavy sections |
| Mobile content | 90% | Fluid percentage on mobile |
| Mobile full | 100% | Full-bleed on mobile (< 559px) |

### Breakpoints

| Breakpoint | Width | Target |
|------------|-------|--------|
| xs | `< 559px` | Small mobile |
| sm | `≥ 560px` | Mobile landscape |
| md | `≥ 768px` | Tablet |
| lg | `≥ 960px` | Small desktop |
| xl | `≥ 1280px` | Desktop |
| 2xl | `≥ 1440px` | Large desktop |
| 3xl | `≥ 1920px` | Full HD |

### Section Rhythm

The homepage alternates between:
1. **Navigation** -- sticky top bar, transparent → solid on scroll
2. **Hero** -- full-bleed product demonstration with interactive canvas
3. **Logo Marquee** -- client/partner logos in auto-scrolling carousel
4. **Feature Sections** -- asymmetric grid splits (18+24, 20+24, 28+12)
5. **Interactive Demos** -- "Make anything possible" carousel with Figma canvas examples
6. **Template Gallery** -- grid of template categories (Websites, Apps, Presentations, etc.)
7. **CTA Section** -- final call-to-action

---

## Color System

```css
/* ============================================
   Figma Design Tokens — Color System
   Extracted from www.figma.com (2026-05-18)
   ============================================ */

:root {
  /* === Primary Brand === */
  --f-brand-primary: #4D49FC;        /* Indigo-blue — primary action color */
  --f-brand-primary-hover: #3D39EC;  /* Darker indigo for hover states */
  --f-brand-primary-light: #EBEBFF;  /* Light indigo for selection/background */

  /* === Text & Neutral Scale === */
  --f-text-color: #000000;           /* Primary text */
  --f-text-secondary: #697485;       /* Secondary/muted text */
  --f-text-tertiary: #D2DAE4;        /* Tertiary/placeholder text */
  --f-surface-primary: #FFFFFF;      /* Primary surface/background */
  --f-surface-secondary: #E2E2E2;    /* Secondary surface */
  --f-surface-tertiary: #E6E6E6;     /* Tertiary surface */

  /* === Semantic Colors === */
  --f-success: #24CB71;              /* Success/positive indicators */
  --f-success-dark: #009951;         /* Darker success for text on green bg */
  --f-success-light: #CFF7D3;        /* Light success for backgrounds */
  --f-warning: #FF5C16;              /* Warning/caution */
  --f-error: #972121;                /* Error/destructive */
  --f-error-dark: #721C1C;           /* Darker error */

  /* === Accent Palette (Section & Category Colors) === */
  /* Purple family */
  --f-accent-purple: #8638E5;        /* Deep purple accent */
  --f-accent-purple-light: #F1E5FF;  /* Light purple background */
  --f-accent-purple-alt: #CB9FD2;    /* Muted purple */
  --f-accent-indigo: #874FFF;        /* Indigo accent */
  --f-accent-indigo-light: #C4BAFF;  /* Light indigo accent */

  /* Blue family */
  --f-accent-blue: #0D99FF;          /* Bright blue */
  --f-accent-blue-alt: #00B6FF;      /* Cyan-blue */
  --f-accent-blue-light: #E5F4FF;    /* Light blue background */

  /* Cyan/Teal family */
  --f-accent-teal: #33DFDF;          /* Teal accent */
  --f-accent-teal-light: #C7F8FB;    /* Light teal */
  --f-accent-teal-alt: #CEF0F8;      /* Alternate teal */

  /* Green family */
  --f-accent-lime: #E4FF97;          /* Bright lime */
  --f-accent-lime-light: #F3FFE3;    /* Light lime */
  --f-accent-sage: #95B9AC;          /* Muted sage green */

  /* Orange family */
  --f-accent-orange: #FF7237;        /* Orange accent */
  --f-accent-peach: #FFDFCC;         /* Peach background */
  --f-accent-coral: #FF3737;         /* Coral red */

  /* Pink family */
  --f-accent-pink: #FFC9C1;          /* Soft pink */
  --f-accent-salmon: #FFB3B3;        /* Salmon pink */

  /* Gold family */
  --f-accent-gold: #FADCA2;          /* Gold accent */
  --f-accent-gold-dark: #B98E01;     /* Dark gold */

  /* === Icon & Component Colors === */
  --f-icon-bg-color: initial;        /* Icon background (context-dependent) */
  --f-list-header-color: initial;    /* List header text color */

  /* === Form Colors === */
  --f-form-input-bg-color: rgba(0, 0, 0, 0.08);  /* Input background */
}
```

### Color Distribution

| Hex | Frequency | Role |
|-----|-----------|------|
| #000000 | 276 | Primary text / UI chrome |
| #FFFFFF | 167 | Primary surface / backgrounds |
| #4D49FC | 7 | Brand primary / CTAs |
| #24CB71 | 469 (pricing) | Success / "Start for free" emphasis |
| #697485 | 4+ | Secondary text |
| #972121 | 25 | Error / destructive actions |

### Dark Mode Strategy

```css
@media (prefers-color-scheme: dark) {
  body {
    color: #fff;
    /* Background: follows system preference */
    /* Accent colors: adjusted for dark context */
  }
}
```

Dark mode follows the system preference (`prefers-color-scheme: dark`). Body text inverts to white. Accent colors maintain palette integrity.

### Gradient Usage

- **Conic gradients** (2 instances): Color wheel visualizations demonstrating Figma's color picker capabilities
- **Radial gradients** (3 instances): Atmospheric background effects
- **Linear gradients**: 117 gradient mentions throughout, used for section backgrounds and hover states

---

## Typography System

### Font Stack

| Role | Font Family | Format | Weight |
|------|-------------|--------|--------|
| **Brand** | ABC Whyte Plus Variable | WOFF2 (variable) | Variable axis |
| **UI Sans** | figmaSans | WOFF2 | 320 |
| **UI Mono** | figmaMono | WOFF2 | 400 |
| **Sans Fallback** | figmaSans Fallback (Arial metrics) | Local | N/A |
| **Mono Fallback** | figmaMono Fallback (Arial metrics) | Local | N/A |
| **System Backup** | SF Pro Display, system-ui, helvetica | System | N/A |
| **System Mono** | SF Mono, menlo, monospace | System | N/A |
| **Japanese** | Zen Kaku Gothic New | System | N/A |

```css
/* CSS Custom Properties */
--f-font-sans: "figmaSans", "figmaSans Fallback", SF Pro Display, system-ui, helvetica, sans-serif;
--f-font-mono: "figmaMono", "figmaMono Fallback", SF Mono, menlo, monospace;

/* Brand font */
.__className_de45c5 {
  font-family: ABCWhytePlusVariable, ABCWhytePlusVariable Fallback, Whyte, sans-serif;
}
```

### Font Metrics Overrides

```css
/* figmaSans Fallback (Arial-aligned) */
ascent-override: 93.72%;
descent-override: 19.36%;
line-gap-override: 0.00%;
size-adjust: 98.16%;

/* ABC Whyte Plus Fallback */
ascent-override: 101.25%;
descent-override: 36.97%;
line-gap-override: 0.00%;
size-adjust: 104.40%;
```

The metrics overrides ensure near-identical layout with fallback fonts, preventing CLS (Cumulative Layout Shift).

### Type Scale

| Step | Size (rem) | Size (~px at 16) | Usage |
|------|-----------|-------------------|-------|
| xs | 0.6875 | 11px | Legal, fine print |
| sm | 0.75 | 12px | Captions, badges, tags |
| base-sm | 0.875 | 14px | Small body, labels |
| base | 1 | 16px | Body text (root) |
| lg | 1.125 | 18px | Emphasized body |
| xl | 1.25 | 20px | Lead paragraphs |
| 2xl | 1.375 | 22px | Section intros |
| 3xl | 1.5 | 24px | Small headings |
| 4xl | 1.625 | 26px | Card titles |
| 5xl | 1.75 | 28px | Sub-headings |
| 6xl | 1.875 | 30px | Section headings |
| 7xl | 2 | 32px | Emphasis headings |
| 8xl | 2.25 | 36px | Feature titles |
| 9xl | 2.5 | 40px | Major headings |
| 10xl | 2.75 | 44px | Section heroes |
| 11xl | 3.5 | 56px | Page heroes |
| 12xl | 4 | 64px | Display |
| 13xl | 4.5 | 72px | Large display |
| 14xl | 5.375 | 86px | Hero display |
| 15xl | 6 | 96px | Maximum display |

### Font Weight Scale

Figma uses a **custom variable font weight axis** -- not the standard CSS 100-900 scale:

| Weight | Usage |
|--------|-------|
| **320** | Body text, UI labels (default figmaSans) |
| 330 | Light-emphasized text |
| 340 | Slightly bolder body |
| **400** | Mono text, normal emphasis (default figmaMono) |
| 450 | Medium-light |
| 480 | Medium |
| 520 | Medium-bold |
| **530** | Bold (primary emphasis) |
| 540 | Bolder |
| **550** | Heavy bold (heading emphasis) |

The ABC Whyte Plus Variable font allows these precise weight values, creating a uniquely Figma typographic voice.

### Letter Spacing

```css
/* Negative tracking for display text (tighter) */
letter-spacing: -0.1075rem;   /* Largest negative — hero display */
letter-spacing: -0.09rem;     /* Large display */
letter-spacing: -0.06rem;     /* Display headings */
letter-spacing: -0.0525rem;   /* Major headings */
letter-spacing: -0.04rem;     /* Section headings */
letter-spacing: -0.0275rem;   /* Feature titles */
letter-spacing: -0.0225rem;   /* Card titles */
letter-spacing: -0.01625rem;  /* Sub-headings */
letter-spacing: -0.015rem;    /* Minor headings */
letter-spacing: -0.00875rem;  /* Lead text */
letter-spacing: -0.0075rem;   /* Slightly tight */
letter-spacing: -0.006875rem; /* Near-normal */
letter-spacing: -0.00625rem;  /* Near-normal */
letter-spacing: -0.005625rem; /* Minimal compression */

/* Positive tracking for body text (looser for readability) */
letter-spacing: 0;            /* Default */
letter-spacing: 0.03rem;      /* Body text */
letter-spacing: 0.03375rem;   /* Emphasized body */
letter-spacing: 0.0375rem;    /* Small text for legibility */
letter-spacing: 0.04rem;      /* Fine print */
```

**Pattern:** Negative tracking scales inversely with font size -- the larger the text, the tighter the tracking. This is a hallmark of professional typography.

---

## Motion System

### Animation Engine

Figma's marketing site uses the **motion** library (framer-motion ecosystem) combined with CSS @keyframes for lightweight animations.

### Duration Tokens

| Duration | Context |
|----------|---------|
| 100ms | Micro-interactions (opacity fades) |
| 150ms | Hover transitions (opacity, color) |
| 160ms | Border-radius transitions |

### Easing Curves

```css
/* Primary ease-out — fast start, gentle settle */
--f-ease-out: cubic-bezier(0.8, 0, 0.2, 1);

/* Spring overshoot — bounce for emphasis */
--f-ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);

/* Standard easings */
ease           /* Default CSS ease */
ease-out       /* Standard ease-out */
ease-in-out    /* Standard ease-in-out */
```

### Custom Keyframe Animations

Four named keyframe animations discovered on the homepage:

1. `animation-6j0toc` — (context-specific)
2. `animation-jpvf7s` — (context-specific)
3. `animation-yh21v4` — (context-specific)
4. `animation-zsk7zs` — (context-specific)

These are generated by emotion's CSS-in-JS compiler with hashed names.

### Animation Techniques by Count

| Technique | Occurrences | Context |
|-----------|-------------|---------|
| `transform` | 276 | Heavy transform usage — likely GPU-composited |
| `transition` | 224 | CSS transitions for state changes |
| `animation` | 52 | CSS animations (keyframes) |
| `motion` | 38 | motion library component usage |
| `spring` | 7 | Spring physics animations |

### Motion Patterns Observed

1. **Scroll-driven reveals** — Elements animate in as they enter viewport
2. **Hover transitions** — 211 hover states with 150-160ms ease-out transitions
3. **Carousel animations** — Slide transitions with next/previous controls
4. **Logo marquee** — Auto-scrolling partner logos
5. **Spring physics** — 7 spring animation instances for organic motion
6. **Loading states** — 104 loading mentions for async content

### Accessibility

```css
@media (prefers-reduced-motion) {
  /* Animations disabled/reduced for motion-sensitive users */
}
```

---

## Interaction Patterns

### State Matrix

| State | Mentions | Pattern |
|-------|----------|---------|
| Hover | 211 | 150ms ease-out transitions on interactive elements |
| Focus | 52 | Visible focus ring (keyboard navigation) |
| Active | 9 | Pressed/active state for clickable elements |
| Disabled | 8 | Muted styling for non-interactive elements |
| Loading | 104 | Skeleton/spinner patterns for async content |

### Navigation

- **Type:** Sticky top navigation bar
- **Mobile:** Hamburger menu (`aria-label="Open navigation menu"`)
- **Language selector:** `aria-label="Choose a language"` — 12 locales
- **Auth-aware:** Redirects authenticated users to the Figma app
- **Logo:** SVG logos served from Sanity CDN with preload priority

### Cursor System

```css
--f-cursor-default:     /* Default cursor */
--f-cursor-pointer:     /* Clickable elements */
--f-cursor-text:        /* Text selection */
--f-cursor-grab:        /* Draggable areas */
--f-cursor--webkit-grab: /* WebKit grab cursor */
```

### Scrolling Patterns

- **Sticky navigation** — 31 sticky mentions for fixed-position elements
- **Scroll-driven animations** — motion library `useScroll` / `useTransform`
- **Carousel** — Horizontal slide navigation with Previous/Next controls

### Interactive Demos (Homepage)

The homepage features live Figma canvas demos:
- "Make text move on a path"
- "Make these photos rotate in 3D"
- "Make my cursor reveal an image"
- "Make my site squish when scrolled"
- "Make this design move with a parallax effect"
- "Make an infinite canvas gallery"
- "Make a clock with a shader background"

### Accessibility Features

- **Semantic landmarks:** `<main aria-label="Main">`, `<nav>`, `<header>`, `<footer>`
- **ARIA labels:** All interactive elements labeled
- **Keyboard navigation:** 52 focus states
- **Reduced motion:** `prefers-reduced-motion` media query respected
- **Dark mode:** `prefers-color-scheme: dark` supported
- **Lang alternates:** 12 hreflang alternates for SEO/accessibility

### Form Interactions

- Input background: `var(--f-form-input-bg-color, rgba(0, 0, 0, 0.08))`
- Border: 1px solid with variable color
- Hover: `@media (hover: hover) and (pointer: fine)` — precision device detection

---

## Spacing System

### Base Unit: 4px (0.25rem)

The spacing system follows a 4px base grid, reflected in the `--f-col-width` and `--f-gutter` variables.

### Gap Scale

```css
/* CSS Gap Tokens */
0.25rem    (4px)    /* Tight — icon-to-label */
0.3125rem  (5px)    /* Minimal */
0.375rem   (6px)    /* Component internal */
0.5rem     (8px)    /* Compact */
0.75rem    (12px)   /* Standard inline */
1rem       (16px)   /* Base gap */
1.375rem   (22px)   /* Standard card gap */
1.5rem     (24px)   /* Section internal */
1.875rem   (30px)   /* Card-to-card */
2rem       (32px)   /* Section gap */
3rem       (48px)   /* Major section gap */
3.75rem    (60px)   /* Large section gap */
4rem       (64px)   /* Hero section gap */
```

### Padding Scale

```css
/* CSS Padding Tokens */
0.25rem              /* Tight padding */
0.28125rem 0.5rem    /* Badge/tag padding */
0.5rem               /* Compact */
0.5rem 0.75rem       /* Button compact */
0.5rem 1.125rem      /* Button medium */
0.75rem 1rem         /* Standard button */
0.75rem 1.25rem      /* Button large */
0.75rem 1.3125rem    /* Button x-large */
1rem                 /* Card padding */
1rem 2rem            /* Large card padding */
10rem                /* Section padding (extreme) */
```

### Grid-Based Spacing

```css
gap: calc(var(--f-col-width) * 1);   /* 1 column width */
gap: calc(var(--f-col-width) * 2);   /* 2 column widths */
gap: calc(var(--f-col-width) * 4);   /* 4 column widths */
gap: calc(var(--f-col-width) * 6);   /* 6 column widths */
```

### Margin Scale

```css
0                    /* No margin */
0.125rem             /* Micro spacing */
0 0 0.5rem 0         /* Headline bottom margin */
1.5rem 0 0 0         /* Section top margin */
2rem 0 0 0           /* Large top margin */
2.5rem 0             /* Vertical section margin */
2.5rem 0 5rem        /* Section with large bottom */
```

### Border Radius Scale

```css
0                    /* Sharp — precision engineering */
2px                  /* Subtle — inputs, small elements */
0.25rem  (4px)       /* Default radius */
0.375rem (6px)       /* Medium components */
0.5rem   (8px)       /* Cards, modals */
8px                  /* Alternate card radius */
var(--radius)        /* Base radius variable */
calc(var(--radius) + 0.125rem)  /* Stepped radius */
3.125rem (50px)      /* Pill — CTAs, buttons */
50%                  /* Circle — avatars, icons */
```

### Shadow System

```css
/* Card elevation */
box-shadow: 0 1.5rem 4.375rem 0 rgba(0, 0, 0, 0.10);
/* 0px X, 24px Y, 70px blur, 0 spread, 10% black */

/* Hairline separator */
box-shadow: 0 1px 0 rgba(0, 0, 0, 0.08);

/* Inset text-color border */
box-shadow: inset 0 0 0 1px var(--f-text-color, #000000);
```

**Note on shadows:** Only 3 distinct shadow values found. Figma relies more on border-based separation and color contrast than heavy shadow hierarchies.

---

## Component Library

### Navigation

- **Top bar:** Sticky, transparent background that solidifies on scroll
- **Logo:** SVG wordmark from Sanity CDN
- **Menu items:** Text links with hover state (150ms ease-out)
- **Mobile menu:** Hamburger trigger (`aria-label="Open navigation menu"`)
- **Language picker:** Dropdown with 12 locale options
- **Auth-aware:** Detects `figma.authn-state` cookie to redirect signed-in users

### Buttons

- **Hierarchy:** At least 3 tiers (filled primary, outlined, text link)
- **Primary color:** #4D49FC (indigo)
- **Success color:** #24CB71 (green — "Start for free")
- **Border radius:** 3.125rem (pill shape) for CTAs
- **Padding variants:** 0.5rem 0.75rem → 0.75rem 1.3125rem
- **Hover:** 150ms ease-out color/background transitions
- **Focus:** Visible focus ring

### Cards

- **39 instances** across homepage
- **Background:** #FFFFFF (light theme)
- **Border radius:** 0.5rem (8px) or 8px
- **Shadow:** `0 1.5rem 4.375rem 0 rgba(0, 0, 0, 0.10)` for elevated cards
- **Hover:** 150-160ms transition effects

### Badges & Tags

- **96 badge instances** — likely for product labels (New, Beta, Featured)
- **69 tag instances** — categorization tags
- **Padding:** 0.28125rem 0.5rem (compact)
- **Font size:** 0.75rem (12px)
- **Border radius:** 0.25rem (4px)

### Carousels

- **Horizontal slider:** Previous/Next slide controls
- **Logo marquee:** Auto-scrolling partner/client logos
- **Interactive demo carousel:** Figma canvas demonstrations
- **Pagination:** "Slide controls" with indicators

### Interactive Demos (Hero Section)

The homepage hero is not a traditional static header -- it is a live Figma canvas demonstrating the product:
1. Text on a path
2. 3D photo rotation
3. Cursor image reveal
4. Scroll-driven squish effect
5. Parallax animation
6. Infinite canvas gallery
7. Shader background clock

### Pricing Cards

From the `/pricing/` page:
- **Plans:** 766 plan mentions, 40 tier mentions
- **Enterprise:** 291 enterprise mentions
- **Green accent:** #24CB71 dominates (464 occurrences) — action/signup emphasis
- **Color-coded sections:** Purple, blue, green, orange accents per plan tier

### Templates Gallery

```text
Community templates | Portfolio templates | Websites | Web ads
Mobile apps | Presentations | Illustrations | Icons
```

### Footer

- Minimal mentions (2 footer references) — likely a simple footer with:
  - Social media links (Facebook, Instagram, X)
  - Language selector
  - Legal links

---

## Design Tokens Summary

### Complete CSS Custom Property Index

```css
/* === Typography === */
--f-font-sans                  /* Sans-serif font stack */
--f-font-mono                  /* Monospace font stack */

/* === Grid & Layout === */
--f-col-width                  /* Base column width unit */
--f-columns                    /* Active column count */
--f-gutter                     /* Gutter width */
--f-max-content-width          /* Max content width (137.5rem) */
--f-lego-block-padding         /* Component block padding */

/* === Cursors === */
--f-cursor-default             /* Default cursor */
--f-cursor-pointer             /* Clickable cursor */
--f-cursor-text                /* Text cursor */
--f-cursor-grab                /* Grab cursor */
--f-cursor--webkit-grab        /* WebKit grab cursor */

/* === Colors === */
--f-text-color                 /* Primary text color */
--f-icon-bg-color              /* Icon background color */
--f-list-header-color          /* List header text color */
--f-form-input-bg-color        /* Form input background */

/* === Carousel (context-specific) === */
--slide-size                   /* Slide dimensions */
--slide-width                  /* Slide width */
--slide-gap                    /* Gap between slides */
--carousel-parent-text-color   /* Parent text color in carousel */
--drawers-img-col-width        /* Drawer image column width */
--scrollbar-width              /* Custom scrollbar width */
```

---

## Key Takeaways

1. **40-column precision grid** — Figma's grid system is unusually detailed, with asymmetric splits (29+11, 30+10) that create dynamic, non-formulaic layouts. This mirrors the product's own auto-layout and constraint system.

2. **Custom variable font weight axis** — Non-standard weights (320, 330, 340, 450, 480, 520, 530, 540, 550) create a unique typographic voice impossible with standard font families. The ABC Whyte Plus Variable is a premium licensed typeface from Dinamo.

3. **Font metrics overrides for CLS prevention** — Both figmaSans and ABC Whyte have Arial-based fallback metrics with ascent/descent/size-adjust overrides, making the layout identical regardless of which font loads.

4. **Section-specific accent colors** — Each content section uses a different accent from a 20+ color palette: purple (#8638E5), blue (#0D99FF), teal (#33DFDF), lime (#E4FF97), orange (#FF7237), pink (#FFC9C1), gold (#FADCA2). This creates visual variety while maintaining system coherence.

5. **Conic gradients as product demonstrations** — The conic-gradient usage (color wheel) is not decorative — it directly demonstrates Figma's color picker capabilities, making the marketing page a product demo.

6. **Self-demonstrating product** — The homepage hero is an interactive Figma canvas showing 7 live demos (text on path, 3D rotation, cursor reveal, etc.), making the marketing page a direct product experience rather than just describing features.

7. **150ms ease-out micro-interaction discipline** — Every hover, focus, and state transition uses a consistent 150ms cubic-bezier(.8,0,.2,1) easing, creating a unified feel across all interactive elements.

8. **Heavy transform usage (276 instances)** — GPU-composited transforms dominate the animation strategy, ensuring smooth 60fps motion without layout thrashing.

9. **Border-based separation over shadows** — Only 3 distinct box-shadow values found. Figma relies on borders (`1px solid var(--f-text-color)`) and color contrast for visual hierarchy rather than elevation shadows.

10. **Dark mode follows system** — No manual theme toggle; dark mode activates automatically via `@media (prefers-color-scheme: dark)`, consistent with a design-tool audience that likely uses system dark mode.

11. **12-language global reach** — Full i18n with hreflang alternates for SEO and locale-specific rendering (not just UI strings but design content per locale).

12. **Emotion CSS-in-JS with hashed class names** — All components use emotion-generated class names (e.g., `.css-14r34si`, `.fig-144u7nr`), with responsive variants at each breakpoint.

---

## Extraction Limitations

- **CSS custom property values:** Full `--f-col-width` and `--f-gutter` numeric values are computed at runtime (JS-driven grid), so exact pixel values could not be extracted from HTML/CSS alone.
- **Keyframe animation content:** The 4 custom keyframe animations have hashed names; their exact transform/opacity frames could not be extracted without fetching JS bundles.
- **Dark mode tokens:** The `prefers-color-scheme: dark` block was identified but its full token overrides are in JS bundles or computed at runtime.
- **Component variants:** Button, card, and badge variant systems (primary/secondary/ghost/outline) were inferred from usage patterns, not extracted from a single source of truth.
- **Font files:** The actual WOFF2 font files were not downloaded (both are preloaded from `/_netlify/_next/static/media/`).
- **Responsive behavior:** Breakpoints were extracted from media queries but the actual responsive layout behavior at each breakpoint was inferred rather than tested.
- **JavaScript-driven animations:** motion library and spring animations are imperative (JS-driven); their exact parameters (stiffness, damping, mass) could not be extracted from static HTML.
