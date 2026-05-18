# Impeccable — Design Token System

## Overview

Impeccable defines its design token system through its own DESIGN.md specification — a warm-paper editorial design that serves as both the skill's own site and a demonstration of its principles. This document captures all explicit tokens and the implied design constraints that govern every project built under the methodology.

## Color Tokens (OKLCH-Based)

### Impeccable Site Palette (Editorial Sanctuary)
A two-chord system: warm paper neutrals carrying a near-invisible magenta tint, plus one decisive accent.

#### Primary Accent
- `--color-accent` / **Editorial Magenta**: `oklch(60% 0.25 350)` — The one vibrant voice. Used on <=10% of any screen. Primary CTAs, active nav states, live indicators, rare editorial emphasis. Never as gradient, background wash, or text fill.
- `--color-accent-deep` / **Editorial Magenta Deep**: `oklch(52% 0.25 350)` — Hover/active state darkening. Small shift, confirms interaction without shouting.
- `--color-accent-dim` / **Magenta Whisper**: `oklch(60% 0.25 350 / 0.15)` — Glow backdrop under accent elements on hover, subtle selection highlights.
- `--color-accent-veil` / **Magenta Veil**: `oklch(60% 0.25 350 / 0.25)` — Focus rings, emphasis shells.

#### Neutrals (Tinted Toward Brand Hue at chroma 0.005)
- `--color-surface-primary` / **Warm Ash Cream**: `oklch(96% 0.005 350)` — Default page background. Near-white with near-imperceptible magenta tint. Subconscious cohesion with accent. Used on body and standard surfaces.
- `--color-surface-pure` / **Crisp Paper White**: `oklch(98% 0 0)` — Pure background. Inverted text moments (white-on-dark CTAs), surfaces needing maximum contrast. Almost never the page background — too cold alone.
- `--color-text-primary` / **Deep Graphite**: `oklch(10% 0 0)` — Body copy and headlines. Softer than pure black. Confident-but-not-aggressive on warm paper. Background of primary CTA.
- `--color-text-secondary` / **Soft Charcoal**: `oklch(25% 0 0)` — Taglines, hook paragraphs, supporting copy. Clearly subordinate without being washed out. Only for headings or body >=16px.
- `--color-text-tertiary` / **Mid Ash**: `oklch(55% 0 0)` — Micro-labels, captions, meta lines. At small sizes reads as intentionally recessed metadata.
- `--color-border` / **Paper Mist**: `oklch(92% 0 0)` — Hairline borders, section dividers, barely-visible structural seams.

### Named Color Rules
- **The One Voice Rule**: Only one vibrant color in the system. If a layout "wants" a second emphasis point, use scale or weight, never a second hue.
- **The Paper-Not-White Rule**: Page background is the tinted neutral (Warm Ash Cream), never pure white. Warmth is load-bearing — without it, the design reads generic and the decisive accent reads abrasive.
- **The OKLCH-Only Rule**: All new colors in OKLCH. No hex-declared colors introduced into the system.
- **The Tinted-Shadow-Only-For-Accent Rule**: Neutral shadows (black alpha) for structure. Colored shadows only for deliberate accent-glow moments.

### Implied Color Architecture for Any Project
- **Primitive tokens**: raw color values (OKLCH strings)
- **Semantic tokens**: named roles (`--color-primary: var(--blue-500)` etc.)
- For dark mode, redefine only the semantic layer; primitives stay the same
- Every neutral must carry chroma 0.005-0.015 toward the brand hue
- Never pure black (oklch(0% 0 0)) or pure white (oklch(100% 0 0))
- 9-11 shade neutral scale, 3-5 shade primary scale, 4 semantic colors (success/error/warning/info) with 2-3 shades each
- 2-3 surface elevation levels

### Dark Mode Surface Scale
Depth through lightness (not shadow): base surface at 15%, elevated at 20%, highest at 25%. All use the SAME hue and chroma as brand — only lightness varies.

## Typography Tokens

### Impeccable Site Type Scale
```css
--font-display: "Cormorant Garamond", Georgia, serif;
--font-body: "Instrument Sans", system-ui, sans-serif;
--font-mono: "Space Grotesk", monospace;

--text-display: clamp(2.5rem, 7vw, 4.5rem) / 1 / 300;
--text-headline: clamp(1.75rem, 4vw, 2.5rem) / 1.2 / 400;
--text-title: clamp(1.125rem, 2.5vw, 1.75rem) / 1.3 / 400;
--text-body: 1rem / 1.6 / 400;
--text-body-lead: 1.0625rem / 1.65 / 400;
--text-supporting: 0.875rem / 1.6 / 400;
--text-label: 0.9rem / 1.6 / 500, letter-spacing: 0.05em, uppercase;
--text-micro-label: 0.6875rem / 1.6 / 500, letter-spacing: 0.1em, uppercase;
--text-mono: 0.75rem / 1.6 / 400;
```

### Named Typography Rules
- **The Italic-Is-Voice Rule**: Italic used as voice choice for display type, not as emphasis within body copy. Body emphasis carried by weight.
- **The 1.6 Leading Rule**: Body line-height is 1.6 everywhere. The load-bearing readability decision.
- **The Fluid-Headlines-Only Rule**: Headings use clamp() fluid sizing. Body uses fixed rem. Fluid body sizes make line-lengths wander off spec.

### Implied Typography Architecture
- Name tokens semantically: `--text-body`, `--text-heading`, not `--font-size-16`
- Include font stacks, size scale, weights, line-heights, and letter-spacing in the token system
- Cap body line length at 65-75ch via max-width
- Hierarchy through scale + weight contrast (>=1.25 ratio between steps)
- Light text on dark: bump line-height 0.05-0.1, add 0.01-0.02em letter-spacing, step weight up one notch
- Paragraph rhythm: pick space between OR first-line indent. Never both. Digital usually wants space.
- 5-size system minimum: xs (0.75rem), sm (0.875rem), base (1rem), lg (1.25-1.5rem), xl+ (2-4rem)

## Spacing Tokens

### Impeccable Site Spacing Scale
```
--spacing-xs: 8px
--spacing-sm: 16px
--spacing-md: 24px
--spacing-lg: 32px
--spacing-xl: 48px
--spacing-2xl: 80px
--spacing-3xl: 120px
```
Deliberately omits the 4px step — this is an editorial scale, not app-UI scale.

### Implied Spacing Architecture
- 4px base granularity (not 8px) for app UI contexts: 4, 8, 12, 16, 24, 32, 48, 64, 96px
- Name tokens semantically (`--space-sm`, `--space-lg`), not by value (`--spacing-8`)
- Use `gap` instead of margins for sibling spacing
- Vary spacing for rhythm. Same padding everywhere is monotony.
- Rhythm: 80-120px between top-level sections, 24-48px between content groups, 6-16px inside tight clusters
- Vertical rhythm: line-height should be the base unit for all vertical spacing. If body is 16px/1.5 = 24px baseline, spacing values should be multiples of 24px.

## Elevation / Shadow Tokens

### Impeccable Site Shadow Vocabulary
Flat by default. Depth conveyed through state response, not structural shadow.

```
--shadow-hover-soft: 0 4px 24px -4px rgba(0,0,0,0.12), 0 1px 3px rgba(0,0,0,0.06);
--shadow-lifted: 0 20px 40px rgba(0,0,0,0.08);
--shadow-accent-glow: 0 20px 60px var(--color-accent-dim);
--shadow-tooltip: 0 0 20px rgba(0,0,0,0.15);
--shadow-popover: 0 2px 8px rgba(0,0,0,0.1);
```

### Named Elevation Rules
- **The Flat-By-Default Rule**: Surfaces flat at rest. Shadows only on hover or for deliberate elevation. Adding shadow to a non-interactive element = Material Design muscle memory to suppress.
- **The Low-Alpha Rule**: Every shadow uses <=0.15 alpha on strongest blur. Higher reads as 2014 Material Design.
- **The Tinted-Shadow-Only-For-Accent Rule**: Neutral shadows for structure. Colored shadows only for accent-glow moments.

### Implied Shadow Architecture
- Create semantic z-index scale: dropdown(100) -> sticky(200) -> modal-backdrop(300) -> modal(400) -> toast(500) -> tooltip(600)
- Shadow scale: sm -> md -> lg -> xl
- Shadows should be subtle. If clearly visible, probably too strong.
- Dark mode depth: lighter surfaces for elevation (15%/20%/25%), not shadows

## Border Radius Tokens

### Impeccable Site Radius Scale
```
--radius-none: 0
--radius-sm: 4px     (chips, inline callouts)
--radius-md: 8px     (standard cards, card-CTAs)
--radius-lg: 12px    (feature cards, install blocks)
--radius-xl: 16px    (large content frames)
```

### Named Radius Rules
- No single "rounded-lg" default. Radius picked per component weight.
- Primary CTAs: `border-radius: 0` — sharp, squared as editorial signature. Rejects the rounded-rectangle-with-drop-shadow default that marks AI-adjacent pages.

### Implied Radius Architecture
- Controlled vocabulary: 4 distinct radius tokens, each with specific component role
- Sharp corners (radius-none) for primary actions on brand surfaces
- Smaller radii (4-8px) for interaction-dense UI
- Larger radii (12-16px) for large editorial frames and feature cards

## Breakpoint & Responsive Tokens

### Content Width Constraints
```
--width-content: 900px     (content block max-width)
--width-max: 1400px        (page-level container max-width)
```
Prose further constrained to 65-75ch via `max-width` in `ch` units.

### Implied Responsive Architecture
- **Container queries over viewport queries** for components. Same card adapts if in narrow sidebar vs wide main content.
- **Self-adjusting grids**: `repeat(auto-fit, minmax(280px, 1fr))` for breakpoint-free column layouts
- **No traditional column grid** by default. Hero layouts are asymmetric two-column splits.
- **Fluid spacing** with clamp() that breathes on larger viewports
- **Fluid typography** for headings only (marketing pages); fixed rem for body and app UI
- **Responsive behavior is structural** for product UI: collapse sidebar, responsive tables, breakpoint-driven columns. Not fluid typography.

### Responsive Test Breakpoints
Test at: 320px, 375px, 768px, 1024px, 1440px, 1920px. Verify no overflow, touch interactions functional, navigation adapts correctly.

## Motion Tokens

### Duration Scale
```
--duration-instant: 100ms     (button press, toggle, color)
--duration-fast: 150ms        (instant feedback)
--duration-normal: 250ms      (hover transitions, tooltips)
--duration-slow: 400ms        (modals, drawers, accordions)
--duration-entrance: 600ms    (page load, hero reveals)
--duration-exit: 300ms        (elements leaving, ~75% of enter)
```

### Easing Tokens
```
--ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1)     (signature: snappy, confident)
--ease-out-quart: cubic-bezier(0.25, 1, 0.5, 1)    (default: smooth, refined)
--ease-out-quint: cubic-bezier(0.22, 1, 0.36, 1)   (slightly more dramatic)
--ease-in: cubic-bezier(0.7, 0, 0.84, 0)            (elements leaving)
--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1)       (state toggles)
```

### Implied Motion Rules
- Ease out with exponential curves only — no bounce, no elastic
- Don't animate CSS layout properties (width, height, padding, margin, top, left)
- Use transform and opacity
- 150-250ms for product UI transitions; 300-500ms for brand layout changes
- `prefers-reduced-motion` collapses every non-essential transition
- 80ms threshold for perceived instantaneity

## Component Token Inheritance

### Button Primary
```
background: var(--color-text-primary)
color: var(--color-surface-pure)
typography: var(--text-label) (uppercase, 0.05em tracking)
border-radius: var(--radius-none) (0px)
padding: 16px 48px
hover: background shifts to var(--color-accent), translateY(-2px), 200ms ease-out
focus: browser-default focus-visible + hover treatment
```

### Card
```
background: var(--color-surface-primary) or var(--color-surface-pure)
border-radius: var(--radius-md) (8px) or var(--radius-lg) (12px) per weight
padding: 16-32px (typical) or 48px+ (editorial frames)
border: 1px var(--color-border) when articulation needed
shadow: none at rest; var(--shadow-hover-soft) on hover
```

### Input / Text Field
```
background: transparent
border: 1px var(--color-border)
border-radius: var(--radius-sm) (4-6px)
padding: 8px 12px
focus: border shifts to var(--color-accent), backdrop glow from var(--color-accent-dim)
```

### Navigation
```
header: 62px compact bar
default color: var(--color-text-primary)
hover/active color: var(--color-accent), 200ms transition
typography: body family, weight 500, 0.9-1rem, normal case (prose, not signals)
active indicator: thin accent-colored underline (optional, not at rest)
```

## Design Token Architecture Principles

### Two-Layer Token System
1. **Primitive tokens**: raw values (OKLCH colors, px values, font stacks). Never referenced directly in components.
2. **Semantic tokens**: named by role (`--color-primary`, `--text-heading`, `--space-section`). Referenced in components. Only this layer changes for dark mode.

### Token Naming Convention
- Colors: `--color-{role}` (primary, accent, text-primary, surface-primary, border)
- Typography: `--text-{role}` (display, headline, body, label, caption)
- Spacing: `--space-{size}` (xs, sm, md, lg, xl, 2xl, 3xl)
- Radius: `--radius-{size}` (none, sm, md, lg, xl)
- Shadow: `--shadow-{type}` (hover-soft, lifted, accent-glow, tooltip)
- Motion: `--duration-{speed}`, `--ease-{type}`
- Layout: `--width-{role}` (content, max), `--measure` (for 65ch prose cap)

### Implied Constraints
- No new tokens outside the established scale without strong justification
- Use literal values for one-off pixel gaps rather than polluting the token scale
- Token system favors fewer, more committed values over exhaustive coverage
- Every token must earn its place — no speculative tokens
- Color tokens defined in OKLCH only (legacy hex permitted only in fenced scopes)
- Alpha variants (transparency) kept minimal — define explicit overlay colors instead
