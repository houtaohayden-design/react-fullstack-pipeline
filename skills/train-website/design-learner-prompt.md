# Design Learner Subagent Prompt Template

Use when dispatching a `react-design-learner` subagent.

> **CRITICAL:** All agents MUST follow the Responsible Fetching Policy at `knowledge/responsible-fetching.md`. Read it before starting. Hard limits: 15 requests max, 2s delay between requests, stop on 429/403/503, max 500KB per resource.

## Template

```
Analyze this website and extract its complete design system. You are a `react-design-learner`.

## ⚠️ Responsible Fetching (READ FIRST — MANDATORY)

Read `D:\Claude\react-fullstack-pipeline\knowledge\responsible-fetching.md` before making ANY requests.

**Hard limits this session:**
- Max 15 HTTP requests to the target domain (pages + CSS + JS — all count)
- Max 3 pages (homepage + up to 2 key sub-pages)
- Max 5 external CSS files, max 3 JS files
- Max 500KB per resource, max 2MB total download
- Minimum 2-second delay between requests — always sequential, never concurrent
- STOP immediately on: HTTP 429, 403, 503, or 3 consecutive non-2xx responses

**Pre-fetch assessment (BEFORE first request):**
- Identify small/personal sites → reduce to 5 requests, homepage only
- Identify enterprise/CDN-backed sites → standard 15-request budget OK
- When in doubt, treat as small site (5 requests, homepage only)

**User-Agent for all requests:**
`DesignSystemAnalyzer/1.0 (design research; 1 request/2s)`

**CSS strategy — parse efficiently:**
1. FIRST: extract CSS from homepage inline `<style>` tags and `style` attributes (zero extra requests)
2. SECOND: fetch up to 5 external CSS files — prioritize those with design tokens (`theme`, `tokens`, `variables`, `global` in filename)
3. Skip: third-party CSS (Google Fonts CSS, analytics, ad trackers, CDN library defaults)
4. Only extract: `--*` custom properties, `@font-face`, `@keyframes`, media query breakpoints

## Target
URL: {WEBSITE_URL}
Slug: {SLUG}
Category: design-inspiration

## Task

### Phase 1: Fetch & Capture (with safeguards)
1. Run pre-fetch assessment — log whether small site or enterprise
2. Fetch homepage HTML and extract ALL inline CSS from `<style>` tags (zero additional requests)
3. Extract CSS custom properties directly from the homepage HTML
4. If budget remains and site allows: fetch up to 2 key sub-pages
5. Fetch up to 5 prioritized external CSS files only — extract design tokens, skip vendor CSS
6. DO NOT download full CSS bundles — extract only custom properties, font declarations, keyframes, breakpoints
7. Count every request — stop when budget exhausted
8. If circuit breaker trips, work with what you have and note limitations in the output

### Phase 2: Layout System Analysis
Map the spatial architecture:
- **Page grid** — content width, column count, gutter sizes, margin/padding on root containers
- **Section rhythm** — vertical spacing between sections, padding within sections, max-width containers
- **Component layout** — flex vs grid usage, alignment patterns, gap tokens, responsive collapse behavior
- **Breakpoint strategy** — exact breakpoint values, what changes at each breakpoint (stack/reflow/hide)
- **Content flow** — reading direction, visual hierarchy, F/Z-pattern usage, hero-to-content transition
- **Aspect ratios** — hero area ratios, card media ratios, thumbnail sizes

### Phase 3: Color System Extraction
Build the complete color architecture:
- **Primary palette** — brand color(s) with hex/hsl values, where applied (buttons, links, accents)
- **Secondary palette** — supporting colors, their semantic meaning
- **Neutral scale** — grays used for text (headings, body, muted), backgrounds (page, surface, elevated), borders
- **Semantic colors** — success (green), error (red), warning (amber), info (blue) — exact values
- **Dark mode** — if detected: how colors shift (invert, desaturate, lighten, darken)
- **Gradient strategy** — types used (linear/radial/conic), angle/direction conventions, multi-stop patterns
- **Opacity layering** — how transparency creates depth (overlays, glass effects, text on images)
- **Color proportions** — estimated distribution (60% neutral, 30% primary, 10% accent — or what?)

Format as CSS custom properties:
```css
:root {
  --color-primary: #...;
  --color-primary-hover: #...;
  --color-bg-page: #...;
  --color-bg-surface: #...;
  --color-text-primary: #...;
  --color-text-secondary: #...;
  /* etc. */
}
```

### Phase 4: Typography System Analysis
Deconstruct the type system:
- **Font stack** — primary font (headings), secondary font (body), monospace (code), fallback chain
- **Font source** — Google Fonts, Adobe Fonts, self-hosted, system font stack
- **Type scale** — all text sizes with rem/px values, what each size is used for
- **Weight distribution** — which weights are loaded, where each is applied (headings bold, body regular, etc.)
- **Line height** — per text size, whether absolute or relative
- **Letter spacing** — any tracking adjustments (headings tighter, buttons wider, uppercase looser)
- **Font features** — ligatures, tabular numbers, stylistic sets if used
- **Text treatments** — gradient text, text-shadow, text-stroke, background-clip usage
- **Fluid scaling** — clamp() usage for responsive type, viewport-relative units

### Phase 5: Motion & Animation Analysis
Catalog every animated element:
- **Page load** — hero entrance animation, stagger delay pattern, content reveal strategy
- **Scroll-driven** — parallax layers, sticky elements, scroll-triggered reveals, horizontal scroll sections
- **Hover effects** — button hover (scale/color/shadow), card hover (lift/glow/border), link hover (underline/color)
- **Micro-interactions** — icon animations, toggle switches, checkbox feedback, copy confirmation
- **Page transitions** — route change animations, fade/dissolve patterns, shared element transitions
- **Attention cues** — pulsing, glowing, bouncing indicators; notification badges
- **Loading animations** — skeleton screens, spinner design, progress bar style, infinite scroll trigger
- **Background animations** — particles, gradients, waves, blob morphing, grid movement
- **Easing preferences** — ease-out for entering, ease-in for exiting, custom cubic-bezier values observed
- **Duration patterns** — fast (100-150ms), normal (200-300ms), slow (400-600ms), very slow (800ms+)

For each: note trigger, properties animated, duration, easing, and whether CSS or JS-driven.

### Phase 6: Interaction & UX Patterns
Document interaction behaviors:
- **Navigation** — menu style (top/side/hamburger/mega), mobile menu behavior, active state indicator, breadcrumbs
- **Scrolling** — smooth scroll behavior, scroll snap sections, back-to-top button, sticky header offset
- **Forms** — input style (outlined/filled/underlined), label behavior (static/floating), validation feedback, submit state
- **Search** — search bar style, autocomplete behavior, result display, keyboard shortcut (⌘K)
- **Modals/Dialogs** — entrance animation, backdrop style, close triggers (X/click-outside/Escape), focus trap
- **Tooltips/Popovers** — trigger (hover/click), delay, placement, arrow style
- **Selection** — text selection color, checkbox/radio custom styling, range slider style
- **Drag & drop** — drag handle design, drop zone indication, reorder animation
- **Touch** — swipe gestures, pull-to-refresh, long-press, haptic feedback indicators
- **Accessibility** — focus ring style, skip-to-content link, reduced motion handling, contrast ratios

### Phase 7: Spacing & Visual Rhythm
Measure the spacing system:
- **Base unit** — likely 4px or 8px grid
- **Section spacing** — padding-top/bottom values per section type (hero, features, CTA, footer)
- **Card padding** — internal padding of card components
- **Component gaps** — gap between related items (card grids, feature lists, nav items)
- **Content width** — max-width containers, narrow text columns (prose), full-bleed elements
- **Visual density** — information density: airy (<8 items per viewport), balanced (8-15), dense (>15)
- **White space ratio** — estimated content vs white space: editorial (~40% white), balanced (~30%), dense (~20%)

### Phase 8: Component Pattern Extraction
Identify reusable UI patterns:
- **Buttons** — variants (primary/secondary/ghost/outline/text), sizes, icon positioning, loading state
- **Cards** — variants (default/elevated/bordered/interactive), internal structure, hover behavior
- **Hero sections** — layout pattern, headline/tagline/CTA structure, visual treatment
- **Feature sections** — grid layout, icon/illustration/numbers style, alternating row pattern
- **Testimonials** — card style, avatar treatment, quote styling, carousel or grid
- **Pricing tables** — tier structure, highlight card, feature checklist, CTA style
- **Footers** — column layout, link grouping, social icons, copyright placement
- **Stats/numbers** — large number treatment, label style, grid layout
- **Logo wall** — client logo grid, grayscale/color treatment, spacing
- **FAQ** — accordion or list style, expand/collapse animation, search if present

### Phase 9: Generate design-system.md
Write `knowledge/websites/{SLUG}/design-system.md` with this structure:

```markdown
# {Site Name} — Design System Extraction

> URL: {URL} | Extracted: {DATE} | Category: {STYLE_DIRECTION}

## Overview
2-3 sentences describing the visual direction. What style/aesthetic. Core design philosophy detected.

## Layout System
### Page Architecture
[Grid structure, content width, column ratios, responsive behavior]

### Section Composition
[How pages are built from sections, rhythm, hierarchy]

## Color System
```css
:root { /* complete palette */ }
```
### Palette Summary
[Primary, secondary, neutral, semantic — with usage notes]

## Typography System
### Font Stack
| Role | Font | Weight | Source |
|------|------|--------|--------|
### Type Scale
| Token | Size | Weight | Line | Usage |
|-------|------|--------|------|-------|

## Motion System
### Animation Catalog
[Each animation with trigger, properties, duration, easing]
### Easing Conventions
[When each easing is used]

## Interaction Patterns
### Navigation
### Forms
### Feedback
### Micro-interactions

## Spacing System
| Token | Value | Usage |
|-------|-------|-------|

## Component Library
### [Component Name]
- **Variants:** [list]
- **Structure:** [sub-parts]
- **Interactions:** [hover, focus, active]
- **Usage context:** [where it appears]

## Design Tokens Summary
Complete CSS custom properties file usable as a starting point for implementation.

## Key Takeaways
3-5 most distinctive design patterns worth adopting.
What makes this site visually stand out.
What technical approaches enable its aesthetic.

## Extraction Limitations
[If the circuit breaker tripped or budget was exhausted, document what couldn't be analyzed:
- Pages not fetched
- CSS files skipped
- Resources that exceeded size limits
- Any error responses received
Be honest — future readers need to know what's missing.]
```

### Phase 10: Registry Entry
Add to `knowledge/registry.json` → `trained` array:
```json
{
  "slug": "{SLUG}",
  "name": "{SITE_NAME}",
  "source": "{WEBSITE_URL}",
  "type": "design-inspiration",
  "category": "design-inspiration",
  "platform": "web",
  "style": "{STYLE_DIRECTION_DESCRIPTION}",
  "highlights": ["{TOP_PATTERN_1}", "{TOP_PATTERN_2}", "{TOP_PATTERN_3}"],
  "extracted": {
    "colors": {PALETTE_SIZE},
    "animations": {ANIMATION_COUNT},
    "components": {COMPONENT_PATTERN_COUNT},
    "interactions": {INTERACTION_COUNT}
  },
  "trained": "{TODAY_DATE}"
}
```

## Output
Report:
- Site name, URL, style direction
- Color palette summary (primary + neutral + accent)
- Typography pairing
- Top 5 distinctive patterns
- Animation count and most impressive effect
- Component patterns extracted (count)
- Confirmation that design-system.md exists
- Confirmation that registry is updated
```
