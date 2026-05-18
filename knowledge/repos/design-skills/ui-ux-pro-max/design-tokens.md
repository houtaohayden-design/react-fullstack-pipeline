# UI/UX Pro Max — Design Tokens Architecture

## Overview

This document catalogs the complete design token system from UI/UX Pro Max v2.5.0. It covers the 14-token semantic color architecture used across 161 product-type palettes, 57+ font pairing specifications with full Tailwind CSS configurations, the spacing/shadow/elevation token hierarchy, border radius scale, design system variable templates for all 67 UI styles, and the complete token naming convention used throughout the system.

**Source**: https://github.com/nextlevelbuilder/ui-ux-pro-max-skill

---

## 1. Semantic Color Token Architecture

Every color palette in the system uses exactly 14 semantic color tokens, organized by purpose and role within the design system.

### The 14-Color Token Model

```
Token Architecture (from colors.csv columns):

Core Brand Tokens:
  1.  Primary             — Main brand color (buttons, links, active states)
  2.  On Primary          — Text/icon color on top of Primary
  3.  Secondary           — Supporting brand color (secondary buttons, chips)
  4.  On Secondary        — Text/icon color on top of Secondary
  5.  Accent              — Highlight/Call-to-action elements
  6.  On Accent           — Text/icon color on top of Accent

Surface Tokens:
  7.  Background          — Main page/app background
  8.  Foreground          — Main text color on Background
  9.  Card                — Elevated surface (cards, modals, sheets)
  10. Card Foreground     — Text color on Card surface

Utility Tokens:
  11. Muted               — Subtle backgrounds, disabled states, secondary surfaces
  12. Muted Foreground    — Secondary/tertiary text, captions, placeholder text
  13. Border              — Separators, outlines, input borders

Destructive Tokens:
  14. Destructive         — Delete, remove, error actions
  15. On Destructive      — Text/icon color on Destructive backgrounds
  16. Ring                — Focus ring / outline for interactive elements
```

### Product-Type Color Palette Examples

The system contains 161 palettes, each mapped to a specific product type. Here are representative examples:

**SaaS / Enterprise (Professional Blue):**
```
Primary:    #2563EB (Blue-600)
On Primary: #FFFFFF
Secondary:  #7C3AED (Purple-600)
On Secondary: #FFFFFF
Accent:     #06B6D4 (Cyan-500)
On Accent:  #000000
Background: #F8FAFC
Foreground: #0F172A
Card:       #FFFFFF
Card FG:    #1E293B
Muted:      #F1F5F9
Muted FG:   #64748B
Border:     #E2E8F0
Destructive:#EF4444
On Destructive: #FFFFFF
Ring:       #3B82F6
```

**E-Commerce (Warm & Inviting):**
```
Primary:    #FF6B35 (Warm Orange)
On Primary: #FFFFFF
Secondary:  #004E89 (Deep Blue)
On Secondary: #FFFFFF
Accent:     #FFD166 (Warm Yellow)
On Accent:  #1A1A2E
Background: #FFF8F0
Foreground: #1A1A2E
Card:       #FFFFFF
Card FG:    #2D3436
Muted:      #FFF0E5
Muted FG:   #636E72
Border:     #FDCBBA
Destructive:#D63031
On Destructive: #FFFFFF
Ring:       #FF6B35
```

**Healthcare / Wellness (Calm & Trustworthy):**
```
Primary:    #0891B2 (Teal-600)
On Primary: #FFFFFF
Secondary:  #059669 (Emerald-600)
On Secondary: #FFFFFF
Accent:     #F59E0B (Amber-500)
On Accent:  #000000
Background: #ECFEFF
Foreground: #164E63
Card:       #FFFFFF
Card FG:    #155E75
Muted:      #CFFAFE
Muted FG:   #0E7490
Border:     #A5F3FC
Destructive:#DC2626
On Destructive: #FFFFFF
Ring:       #0891B2
```

**Gaming / Entertainment (Vibrant & Energetic):**
```
Primary:    #7C3AED (Purple-600)
On Primary: #FFFFFF
Secondary:  #F43F5E (Rose-500)
On Secondary: #FFFFFF
Accent:     #10B981 (Emerald-400)
On Accent:  #000000
Background: #0F0F23
Foreground: #E2E8F0
Card:       #1A1A2E
Card FG:    #E2E8F0
Muted:      #16213E
Muted FG:   #94A3B8
Border:     #2D2D44
Destructive:#EF4444
On Destructive: #FFFFFF
Ring:       #8B5CF6
```

### Color Role Assignment Rules

```
Primary:     Main CTA buttons, active nav, links, selected states, focus rings
Secondary:   Secondary buttons, chips, badges, icon accents
Accent:      Special highlights, promotional elements, notification dots
Background:  Entire page/app background. Never use for text containers
Foreground:  Default text color. Must achieve 4.5:1 on Background
Card:        Elevated surface background. Lighter than Background in dark mode
Muted:       Disabled button bg, secondary nav, subtle section dividers
Muted FG:    Captions, helper text, placeholder text, disabled text
Border:      Input borders, card borders, table dividers, separator lines
Destructive: Delete buttons, error alerts, remove icons, danger zones
Ring:        Focus visible indicator. Must contrast with Background + Primary
```

---

## 2. Typography Token System

The system catalogs 57+ font pairings, each with complete specifications.

### Typography Scale Tokens

```
Core Scale (Mobile-First):
  --text-xs:     0.75rem   (12px)   — Captions, overlines, badges
  --text-sm:     0.875rem  (14px)   — Secondary text, labels, helper text
  --text-base:   1rem      (16px)   — Body text (minimum 16px on mobile)
  --text-lg:     1.125rem  (18px)   — Large body, emphasized paragraphs
  --text-xl:     1.25rem   (20px)   — Small headings, card titles
  --text-2xl:    1.5rem    (24px)   — Section headings
  --text-3xl:    1.875rem  (30px)   — Page headings
  --text-4xl:    2.25rem   (36px)   — Hero subheadings
  --text-5xl:    3rem      (48px)   — Hero headlines
  --text-6xl:    3.75rem   (60px)   — Landing page hero
  --text-7xl:    4.5rem    (72px)   — Mega display text

Line Heights:
  --leading-tight:    1.25    — Headings
  --leading-snug:     1.375   — Subheadings
  --leading-normal:   1.5     — Body text (default)
  --leading-relaxed:  1.625   — Long-form reading
  --leading-loose:    1.75    — Legal/financial text, accessibility

Font Weights:
  --font-thin:        100
  --font-extralight:  200
  --font-light:       300
  --font-normal:      400     — Body text default
  --font-medium:      500     — Labels, small UI text
  --font-semibold:    600     — Subheadings, card titles
  --font-bold:        700     — Headings, CTAs
  --font-extrabold:   800     — Hero headlines
  --font-black:       900     — Mega display (rare)
```

### Font Pairing Categories

The 57+ pairings are organized by mood and use case:

**Professional / Enterprise:**
| Pairing | Heading | Body | Best For |
|---------|---------|------|----------|
| Inter + Source Sans | Inter 600/700 | Source Sans Pro 400 | SaaS, dashboards, enterprise |
| Poppins + Open Sans | Poppins 600/700 | Open Sans 400 | Modern corporate, startups |
| DM Sans + DM Mono | DM Sans 500/700 | DM Mono 400 | Developer tools, tech products |

**Elegant / Luxury:**
| Pairing | Heading | Body | Best For |
|---------|---------|------|----------|
| Playfair Display + Lato | Playfair Display 700 | Lato 300/400 | Fashion, luxury, editorial |
| Cormorant + Montserrat | Cormorant Garamond 600 | Montserrat 300 | High-end brands, magazines |
| Cinzel + Raleway | Cinzel 500/700 | Raleway 400 | Jewelry, premium services |

**Modern / Creative:**
| Pairing | Heading | Body | Best For |
|---------|---------|------|----------|
| Space Grotesk + Inter | Space Grotesk 500/700 | Inter 400 | Creative agencies, portfolios |
| Clash Display + Satoshi | Clash Display 600 | Satoshi 400 | Modern startups, Gen Z brands |
| Cabinet Grotesk + General Sans | Cabinet Grotesk 700 | General Sans 400 | Design-forward products |

**Playful / Friendly:**
| Pairing | Heading | Body | Best For |
|---------|---------|------|----------|
| Fredoka + Nunito | Fredoka 600 | Nunito 400 | Children's apps, education |
| Baloo 2 + Quicksand | Baloo 2 700 | Quicksand 400 | Games, entertainment, food |
| Bangers + Comic Neue | Bangers 400 | Comic Neue 400 | Comic-style, casual brands |

**Technical / Monospace:**
| Pairing | Heading | Body | Best For |
|---------|---------|------|----------|
| JetBrains Mono + IBM Plex Sans | JetBrains Mono 600 | IBM Plex Sans 400 | IDEs, developer tools, CLI |
| Fira Code + Fira Sans | Fira Code 500 | Fira Sans 400 | Code editors, technical docs |
| Source Code Pro + Source Sans | Source Code Pro 600 | Source Sans 400 | Documentation, API references |

### Font Pairing Specification Format

Each pairing includes complete implementation details:

```
Font Pairing: Inter + Source Sans Pro
Category: Professional/SaaS
Heading Font: Inter (weight 600 for headings, 700 for hero)
Body Font: Source Sans Pro (weight 400 for body, 600 for emphasis)
Mood: Clean, modern, highly readable, neutral
Best For: SaaS platforms, dashboards, enterprise applications

Google Fonts URL:
https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Source+Sans+Pro:wght@400;600&display=swap

CSS Import:
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Source+Sans+Pro:wght@400;600&display=swap');

Tailwind Config:
fontFamily: {
  'heading': ['Inter', 'sans-serif'],
  'body': ['Source Sans Pro', 'sans-serif'],
}
```

### Mobile Brand Typography Presets

The system includes mobile-specific brand configurations (rows 58-74 in typography.csv):

| Brand Style | Heading | Body | Character |
|-------------|---------|------|-----------|
| Bauhaus Geometric | Archivo Black | Space Grotesk | Bold geometric, modernist |
| Minimalist Monochrome Editorial | DM Serif Display | Inter | Editorial clarity |
| Kinetic Brutalism | Space Mono | DM Sans | Raw, monospace energy |
| Cyberpunk Mobile | Orbitron | Rajdhani | Futuristic, neon-inspired |
| Academia Mobile | Cormorant Garamond | EB Garamond | Classic scholarly |
| Enterprise SaaS Mobile | Inter | Inter | Consistent, professional |
| Sketch Hand-Drawn Mobile | Caveat | Nunito | Organic, human touch |
| Neumorphism Mobile | Quicksand | Quicksand | Soft, rounded feel |

---

## 3. Spacing System

### 4pt/8dp Incremental Scale

The spacing system follows Material Design's 8dp grid with Apple's 4pt micro-spacing:

```
Spacing Token Scale:
  --space-0:     0px         — No spacing (edge-to-edge)
  --space-0_5:   2px         — Micro-spacing (icon-to-label gap)
  --space-1:     4px         — Tight inline (badge padding, icon gaps)
  --space-1_5:   6px         — Compact grouping
  --space-2:     8px         — Default inline gap (standard touch spacing)
  --space-2_5:   12px        — Relaxed inline / compact block
  --space-3:     16px        — Card padding, section padding (mobile)
  --space-4:     24px        — Section padding (desktop), container padding
  --space-5:     32px        — Section gaps, component separation
  --space-6:     48px        — Large section separators
  --space-7:     64px        — Hero/landing section padding
  --space-8:     96px        — Page-level spacing, mega sections
  --space-9:     128px       — Full-viewport section gaps

  --space-section: clamp(4rem, 3rem + 5vw, 10rem)  — Fluid section spacing
```

### Spacing Application Rules

| Context | Token | Value |
|---------|-------|-------|
| Icon-to-label gap | space-1 | 4px |
| Button padding (horizontal) | space-2 to space-3 | 8-16px |
| Touch target gap minimum | space-2 | 8px |
| Card padding | space-3 | 16px |
| Modal padding | space-4 | 24px |
| Section padding (mobile) | space-3 | 16px |
| Section padding (desktop) | space-4 to space-5 | 24-32px |
| Container max-width padding | space-3 to space-4 | 16-24px |

### Container Width Limits

```
  --container-sm:     640px     — Narrow content (blog posts, forms)
  --container-md:     768px     — Medium content (landing sections)
  --container-lg:     1024px    — Default desktop container
  --container-xl:     1280px    — Wide dashboards, data tables
  --container-2xl:    1536px    — Maximum content width

  Rule: Never use fixed px containers on mobile. Always responsive.
```

---

## 4. Shadow & Elevation Tokens

### Elevation Scale (0-24dp, Material Design inspired)

```
Level 0:  — box-shadow: none                 (Flat elements, body text)
Level 1:  — 0 1px 2px rgba(0,0,0,0.06),      (Cards resting on surface)
             0 1px 3px rgba(0,0,0,0.1)
Level 2:  — 0 3px 6px rgba(0,0,0,0.07),      (Elevated cards, dropdowns)
             0 3px 6px rgba(0,0,0,0.1)
Level 3:  — 0 10px 20px rgba(0,0,0,0.08),    (Modals, dialogs)
             0 6px 6px rgba(0,0,0,0.1)
Level 4:  — 0 14px 28px rgba(0,0,0,0.1),     (Drawers, sheets)
             0 10px 10px rgba(0,0,0,0.08)
Level 5:  — 0 19px 38px rgba(0,0,0,0.12),    (Top-level modals, popovers)
             0 15px 12px rgba(0,0,0,0.1)
```

### Style-Specific Shadow Variations

| Style | Shadow Approach | Token Overrides |
|-------|----------------|-----------------|
| Minimalism & Swiss | `none` — flat design, no shadows | --shadow: none |
| Neumorphism | Multiple soft shadows: `-5px -5px 15px, 5px 5px 15px` | --shadow-soft-1 / --shadow-soft-2 |
| Neubrutalism | Hard solid shadow: `4px 4px 0 #000` | --shadow-hard: 4px 4px 0 var(--color-text) |
| Glassmorphism | Subtle border instead of shadow: `1px solid rgba(255,255,255,0.2)` | --glass-border: 1px solid rgba(255,255,255,0.2) |
| Material Design | Standard elevation scale 0-24dp | Standard elevation tokens |
| Flat Design | No shadows — border-based separation | --shadow: none, use borders |
| Claymorphism | Soft, inflated 3D shadows (inner + outer) | --shadow-inner-soft, --shadow-outer-soft |

### Shadow Performance Notes

```
DO:
  - Use box-shadow sparingly (GPU-composited but expensive on low-end devices)
  - Prefer filter: drop-shadow() for complex shapes (respects alpha channel)
  - Use will-change: box-shadow only on animating elements, remove after

DON'T:
  - Chain 5+ shadow layers without performance testing
  - Animate box-shadow on elements that also trigger layout (use transform instead)
  - Use box-shadow for separation when border-bottom or background-contrast would work
```

---

## 5. Border Radius Scale

```
Radius Tokens:
  --radius-none:    0px         — Brutalism, sharp minimalism
  --radius-sm:      2px         — Subtle rounding, text inputs
  --radius-md:      4px         — Default cards, buttons (Minimalism)
  --radius-base:    6px         — Standard rounded element
  --radius-lg:      8px         — Softened cards, modals
  --radius-xl:      12px        — Friendly cards, containers
  --radius-2xl:     14px        — Neumorphism default
  --radius-3xl:     16px        — Soft UI, claymorphism
  --radius-full:    9999px      — Pills, circular elements, avatars
  --radius-round:   50%         — Perfect circles (avatars, FABs)
```

### Style-Specific Radius Defaults

| Style | Default Radius | Notes |
|-------|---------------|-------|
| Minimalism & Swiss | 0px or 2px | Clean, geometric, no ornament |
| Neumorphism | 12-16px | Soft rounded corners essential for effect |
| Glassmorphism | 8-16px | Rounded for frosted glass aesthetic |
| Brutalism / Neubrutalism | 0px | Sharp corners are defining characteristic |
| Claymorphism | 16-24px | Extreme rounding for "toy-like" feel |
| Material Design | 4px | Standard MD shape system |
| Flat Design | 2-6px | Minimal rounding, clean edges |
| Bento Grid | 16-24px | Large rounded cards (Apple style) |

---

## 6. Z-Index Management System

```
Z-Index Scale (Layered):
  --z-base:       0       — Default stacking context
  --z-dropdown:   100     — Dropdown menus, select options
  --z-sticky:     200     — Sticky headers, persistent nav
  --z-overlay:    300     — Overlays, backdrop
  --z-modal:      400     — Modal dialogs, alert dialogs
  --z-popover:    500     — Popovers, tooltips (above modals)
  --z-toast:      600     — Toast/snackbar notifications (topmost UI)
  --z-debug:      9999    — Development/debug overlay only

  --z-offcanvas:  250     — Side drawer, bottom sheet (below overlay)
  --z-navbar:     150     — Fixed navigation
```

### Z-Index Rules

```
1. Define all z-index values as tokens — never use arbitrary numbers
2. Every interactive overlay must have a backdrop (z--overlay) below it
3. Sticky elements must stay below dropdowns and modals
4. Toast notifications always topmost
5. Nested modals: increment by +100 per nesting level
6. Never use z-index > 9999 (reserved for dev tools)
```

---

## 7. Design System Variable Templates (Per-Style)

Each style in the system comes with a standardized set of design system variables. Here are the templates as defined in styles.csv:

### Template Structure
```
--spacing:         <value>
--border-radius:   <value>
--font-weight:     <range>
--shadow:          <spec>
--accent-color:    <strategy>
```

### Per-Style Variable Defaults

| Style | --spacing | --border-radius | --font-weight | --shadow | --accent-color |
|-------|-----------|-----------------|---------------|----------|----------------|
| Minimalism & Swiss | 2rem | 0px | 400-700 | none | single primary only |
| Neumorphism | 2rem | 14px | 400-700 | multi-layer soft | single pastel |
| Glassmorphism | 2rem | 12-16px | 400-600 | translucent depth | vibrant accent |
| Brutalism | 2rem | 0px | 700-900 | none/bold | primary colors only |
| Neubrutalism | 2rem | 0px-4px | 600-900 | hard solid 4px | bold contrasting |
| Material Design | 8dp grid | 4px | 400-700 | 0-24dp scale | primary + secondary |
| Claymorphism | 2rem | 16-24px | 500-700 | soft 3D double | pastel |
| Bento Grid | 1.5rem | 16-24px | 500-700 | subtle lift | brand primary |
| Dark Mode (Luxury) | 2rem | 8-12px | 300-600 | ambient glow | gold/metallic |
| Cyberpunk | 2rem | 0-4px | 500-700 | neon glow | neon accent |
| Vaporwave | 2rem | 4-8px | 400-600 | chromatic glow | synth gradient |

---

## 8. Icon System Tokens

```
Icon Size Scale:
  --icon-xs:    12px    — Badges, inline status dots
  --icon-sm:    16px    — Inline text icons, metadata icons
  --icon-md:    20px    — Button icons, nav icons
  --icon-lg:    24px    — Standard UI icon size
  --icon-xl:    32px    — Feature icons, section headers
  --icon-2xl:   48px    — Hero illustrations, large feature icons

Icon Stroke Width:
  --icon-stroke-thin:   1px     — Delicate, minimal
  --icon-stroke-normal: 1.5px   — Standard (Phosphor default)
  --icon-stroke-bold:   2px     — Bold, high-contrast (Lucide default)
  --icon-stroke-heavy:  2.5px   — Brutalist, neubrutalist

Icon Color Tokens:
  --icon-primary:        var(--color-foreground)     — Default icons
  --icon-muted:          var(--color-muted-fg)        — Secondary icons
  --icon-accent:         var(--color-primary)         — Active/selected icons
  --icon-danger:         var(--color-destructive)     — Destructive action icons
  --icon-inverse:        var(--color-on-primary)      — Icons on primary bg
  --icon-disabled:       opacity 0.38                 — Disabled state

Icon Library Preference:
  1. Phosphor Icons (default — 100+ recommendations in icons.csv)
  2. Lucide Icons (fallback — similar visual language)
  3. Heroicons (fallback — good stroke consistency)
  4. Tabler Icons (fallback — wide selection)
```

### Icon Sizing by Context

| Context | Size | Stroke | Example |
|---------|------|--------|---------|
| Favicon / App icon | 16-32px | 1.5-2px | Brand mark, logo |
| Button icon | 20px | 1.5px | Search, add, settings |
| Nav icon (bottom tab) | 24px | 1.5px | Home, profile, settings |
| Input icon (prefix/suffix) | 20px | 1.5px | Search, calendar, email |
| Feature icon | 32px | 1-1.5px | Feature sections, cards |
| Hero icon | 48px | 1px | Landing hero illustration |
| Empty state icon | 48-64px | 1px | Empty state illustrations |
| Toast icon | 20px | 2px | Success, error, warning |
| Status indicator | 12px | 2px | Online, offline, pending |

---

## 9. Responsive & Layout Tokens

### Breakpoint System

```
Breakpoints (Mobile-First):
  --bp-sm:    375px     — Small phones
  --bp-md:    768px     — Tablets, small laptops
  --bp-lg:    1024px    — Desktop, landscape tablets
  --bp-xl:    1280px    — Large desktop
  --bp-2xl:   1440px    — Extra large screens
  --bp-3xl:   1920px    — 4K / ultra-wide

Testing breakpoints:
  320px, 375px, 768px, 1024px, 1440px, 1920px
```

### Fluid Typography Tokens

```css
--text-hero:   clamp(3rem, 1rem + 7vw, 8rem);
--text-h1:     clamp(2rem, 1.5rem + 3vw, 4rem);
--text-h2:     clamp(1.5rem, 1rem + 2.5vw, 2.5rem);
--text-body:   clamp(1rem, 0.92rem + 0.4vw, 1.125rem);
```

### Content Density Tokens

```
  --density-compact:    — Tight spacing for data-heavy views (tables, dashboards)
  --density-default:    — Standard spacing for most views
  --density-comfortable:— Relaxed spacing for reading, marketing, onboarding
```

---

## 10. Token Implementation Patterns

### CSS Custom Properties (Design System Root)

```css
:root {
  /* Colors — semantic tokens */
  --color-primary: #2563EB;
  --color-on-primary: #FFFFFF;
  --color-secondary: #7C3AED;
  --color-on-secondary: #FFFFFF;
  --color-accent: #06B6D4;
  --color-on-accent: #000000;
  --color-background: #F8FAFC;
  --color-foreground: #0F172A;
  --color-card: #FFFFFF;
  --color-card-foreground: #1E293B;
  --color-muted: #F1F5F9;
  --color-muted-foreground: #64748B;
  --color-border: #E2E8F0;
  --color-destructive: #EF4444;
  --color-on-destructive: #FFFFFF;
  --color-ring: #3B82F6;

  /* Typography */
  --font-heading: 'Inter', sans-serif;
  --font-body: 'Source Sans Pro', sans-serif;
  --font-mono: 'JetBrains Mono', monospace;
  --text-base: clamp(1rem, 0.92rem + 0.4vw, 1.125rem);
  --leading-body: 1.5;
  --leading-heading: 1.25;

  /* Spacing */
  --space-unit: 4px;
  --space-section: clamp(4rem, 3rem + 5vw, 10rem);

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.06);
  --shadow-md: 0 3px 6px rgba(0,0,0,0.07);
  --shadow-lg: 0 10px 20px rgba(0,0,0,0.08);
  --shadow-xl: 0 14px 28px rgba(0,0,0,0.1);

  /* Radius */
  --radius-sm: 2px;
  --radius-md: 4px;
  --radius-lg: 8px;
  --radius-xl: 12px;
  --radius-full: 9999px;

  /* Motion */
  --duration-fast: 150ms;
  --duration-normal: 300ms;
  --duration-slow: 400ms;
  --ease-out: cubic-bezier(0, 0, 0.2, 1);
  --ease-in: cubic-bezier(0.4, 0, 1, 1);
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-spring: cubic-bezier(0.16, 1, 0.3, 1);

  /* Z-Index */
  --z-dropdown: 100;
  --z-sticky: 200;
  --z-overlay: 300;
  --z-modal: 400;
  --z-popover: 500;
  --z-toast: 600;
}
```

### Dark Mode Token Overrides

```css
.dark {
  --color-background: #0F172A;
  --color-foreground: #E2E8F0;
  --color-card: #1E293B;
  --color-card-foreground: #E2E8F0;
  --color-muted: #334155;
  --color-muted-foreground: #94A3B8;
  --color-border: #334155;
  --color-ring: #3B82F6;

  /* Dark mode uses desaturated/lighter tonal variants, not inverted colors */
  /* Each palette must be tested separately for contrast compliance */
}

@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

### Token Usage Discipline

```
CORRECT:
  color: var(--color-foreground);
  background: var(--color-card);
  border: 1px solid var(--color-border);

INCORRECT:
  color: #0F172A;              // Raw hex — unmaintainable
  background: #FFFFFF;          // Not theme-aware
  border: 1px solid #E2E8F0;   // Won't switch in dark mode
  padding: 17px;                // Off-grid spacing
  font-size: 15px;              // Off-scale, may cause zoom on mobile
```

---

## Summary: Design Token Completeness Checklist

- [ ] 14 semantic color tokens defined (Primary through Ring)
- [ ] Dark mode overrides tested for all color tokens
- [ ] Typography scale: 12-72px range with fluid clamp() on key sizes
- [ ] Font pairing with heading + body family + weights specified
- [ ] Google Fonts @import or self-hosted font-face declared
- [ ] Spacing system: 4px unit base, 8px increments for touch spacing
- [ ] Shadow/elevation scale: 0-24dp range with 5 defined levels
- [ ] Border radius scale: 0-9999px with style-appropriate default
- [ ] Z-index scale: 0-9999 with 7 operational levels
- [ ] Icon sizing: 12-48px scale with stroke width variants
- [ ] Breakpoint system: 6 breakpoints mobile-first
- [ ] Motion tokens: 3 duration + 4 easing curve tokens
- [ ] Container widths: narrow to extra-wide responsive max-widths
- [ ] No raw hex/px values in components — all values from tokens
- [ ] Token names are semantic (purpose-based, not value-based)
- [ ] Reduced motion media query wraps all animation tokens
