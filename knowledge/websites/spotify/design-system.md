# Spotify Design System — Complete Extraction

> **Source**: https://spotify.design (redirects to https://open.spotify.com)
> **Note**: spotify.design (the design blog) has been sunset and now 301-redirects to the Spotify Web Player at open.spotify.com. This extraction analyzes the production Spotify Web Player, which is the canonical representation of Spotify's current design system.
> **Design Framework**: Encore Design System — Spotify's internal design system
> **Class Prefix**: `e-10451-`
> **Stack**: React SSR, CSS custom properties (`--encore-*`), styled-components, Woff2 custom fonts
> **Extracted**: 2026-05-18

---

## 1. Overview

Spotify's Encore Design System powers the Web Player — a dark-first, music-focused application with a disciplined semantic token architecture. The system is production-grade, serving 600M+ monthly active users.

**Core philosophy**: Dark-first semantic theming, minimal decoration, content-first hierarchy, accessibility-forward.

### Key Stats

| Metric | Count |
|--------|-------|
| CSS Custom Properties | 197 (under `--encore-*` namespace) |
| Semantic Color Tokens | 26 |
| Font Families | 5 (3 custom + 5 fallback scripts) |
| Typography Scale Stops | 12 |
| Spacing Scale Stops | 12 |
| Border Radius Stops | 7 |
| Border Width Stops | 4 |
| Duration Tokens | 4 (+ composite enter/exit tokens) |
| Theme Variants | Dark (primary), Light |
| Z-Index Layers | 3 named (dialog/popover/skiplink) |
| Keyframe Animations | 20 |
| Component Pattern Families | 25+ |

---

## 2. Layout System

### 2.1 Application Shell

The Web Player uses a classic app-shell layout:

```
+----------+------------------------------------------+
| Sidebar  |  Main Content Area                       |
| 200px    |  (scrollable)                            |
|          |                                          |
| Nav      |  Home / Search / Library                  |
| Links    |                                          |
|          |  +-- Content Sections (Home)              |
| Playlists|  |   - Top Banner                          |
|          |  |   - Carousel Rows (Recently Played)    |
|          |  |   - Artist Cards                       |
|          |  |   - Album Cards                        |
|          |  |   - Playlist Radio                     |
|          |  |   - Charts (Top 50)                    |
|          |  +--------------------------------------  |
+----------+------------------------------------------+
|                  Now Playing Bar                    |
+----------------------------------------------------+
|              Bottom Tab Navigation (mobile)         |
+----------------------------------------------------+
```

### 2.2 Layout Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `--encore-sidebar-base-width` | 200px | Left sidebar width |
| `--encore-layout-margin-base` | 16px | Default content margin |
| `--encore-layout-margin-looser` | 24px | Wide layout margin |
| `--encore-layout-margin-tighter` | 16px | Tight layout margin |
| `--encore-app-inline-size` | (dynamic) | Application width |
| `--encore-app-max-inline-size` | (dynamic) | Application max-width |

### 2.3 Responsive Breakpoints

| Breakpoint | Usage |
|------------|-------|
| `max-width: 280px` | Extra-small constraints |
| `max-width: 479px` | Mobile (small) |
| `max-width: 767px` | Mobile / Tablet portrait |
| `min-width: 480px` | Large mobile |
| `min-width: 767px` | Tablet landscape |
| `min-width: 768px` | Desktop |
| `min-width: 992px` | Large desktop |

### 2.4 Structural Patterns

- **Sidebar + Main Content**: 200px fixed sidebar, fluid main content
- **Bottom Tab Navigation** (mobile): Fixed bottom bar with Home/Search/Library
- **Now Playing Bar**: Persistent bottom bar for playback controls
- **Carousel Rows**: Horizontal scrolling sections with `data-testid="carousel-mwp"`, custom `--gap` and `--fullbleed-margin` properties
- **Card Grids**: Multiple card rows for artists, albums, playlists, radio stations

---

## 3. Color System

### 3.1 Dark Theme (Primary)

All values from `encore-dark-theme`. Note: The Web Player is served in dark mode by default with no user-toggle for light mode on the player page.

#### Background Tokens (Dark)

| Token | Value | Usage |
|-------|-------|-------|
| `--background-base` | `#121212` | Page background |
| `--background-elevated-base` | `#1f1f1f` | Cards, modals, dropdowns |
| `--background-elevated-highlight` | `#2a2a2a` | Elevated hover state |
| `--background-elevated-press` | `#191919` | Elevated active state |
| `--background-highlight` | `#1f1f1f` | Hover state on base |
| `--background-press` | `#000` | Active/press state (pure black) |
| `--background-tinted-base` | `rgba(255,255,255,0.1)` | Subtle tinted surfaces (chips, pills) |
| `--background-tinted-highlight` | `rgba(255,255,255,0.14)` | Tinted hover state |
| `--background-tinted-press` | `rgba(255,255,255,0.21)` | Tinted active state |

**Background Elevation Strategy**: Spotify uses a 4-level dark surface hierarchy:
1. **Base** `#121212` — Page background
2. **Elevated Base** `#1f1f1f` — Cards and overlays
3. **Elevated Highlight** `#2a2a2a` — Hovered elevated (then to press `#191919`)
4. **Press** `#000` — Active press (darker than base for tactile feedback)

Tinted surfaces use `rgba(255,255,255, opacity)` overlay on top of base, creating a translucent lift effect rather than a separate solid color.

#### Text Tokens

| Token | Hex | Usage |
|-------|-----|-------|
| `--text-base` | `#fff` | Primary text |
| `--text-subdued` | `#b3b3b3` | Secondary/description text |
| `--text-bright-accent` | `#1ed760` | Interactive links, accent highlights |
| `--text-positive` | `#1ed760` | Success states (same as accent green) |
| `--text-negative` | `#f3727f` | Error/destructive text |
| `--text-warning` | `#ffa42b` | Warning text |
| `--text-announcement` | `#539df5` | Announcement/info text (blue) |

**Text Color Scale**: 4 functional stops:
1. `base` `#fff` — All primary content
2. `subdued` `#b3b3b3` — Secondary metadata
3. `bright-accent` `#1ed760` — Interactive/actionable
4. Semantic colors for feedback states

#### Essential (Icon/Decorative) Tokens

| Token | Hex | Usage |
|-------|-----|-------|
| `--essential-base` | `#fff` | Primary icons |
| `--essential-subdued` | `#7c7c7c` | Subdued icons/separators |
| `--essential-bright-accent` | `#1ed760` | Accent icons (play, active states) |
| `--essential-positive` | `#1ed760` | Success icons |
| `--essential-negative` | `#ed2c3f` | Error icons |
| `--essential-warning` | `#ffa42b` | Warning icons |
| `--essential-announcement` | `#1278f2` | Info/announcement icons (deeper blue) |

#### Decorative Tokens

| Token | Hex | Usage |
|-------|-----|-------|
| `--decorative-base` | `#fff` | Decorative elements |
| `--decorative-subdued` | `#292929` | Subdued decorative (borders, dividers) |

### 3.2 Signature Color: Spotify Green

The brand-defining color is `#1ed760` (Spotify Green). It serves as:
- Primary accent color (`--text-bright-accent`, `--essential-bright-accent`)
- Positive/success indicator (`--text-positive`, `--essential-positive`)
- Active state indicator
- CTA button background (`--background-base: #1ed760` in bright-accent sets)

**Green Palette** (from extracted hex values):
| Shade | Hex | Usage |
|-------|-----|-------|
| X-light | `#c5f7d7` | Success backgrounds light |
| Light | `#96f0b6` | Success backgrounds |
| Base | `#1ed760` | Primary accent |
| Mid | `#1abc54` | Hover green |
| Dark | `#169f47` | Deep green |
| X-dark | `#12833a` | Very deep green |
| Dark forest | `#0e642d` | Dark background green |

The green also has a desaturated variant: `#c5f0c9` (used for verified badges).

### 3.3 Blue System (Announcement/Info)

| Token | Hex | Usage |
|-------|-----|-------|
| `--text-announcement` | `#539df5` | Announcement text |
| `--essential-announcement` | `#1278f2` | Announcement icon |
| Background hint | `#c8e0fc` | Light blue background |
| Hover blue | `#0d72ea` | Blue hover state (tooltips) |
| Action blue | `#4100f5` | Deep blue action |
| Premium blue | `#7358ff` | Premium/purple-blue accent |

### 3.4 Red System (Error/Destructive)

| Token | Hex | Usage |
|-------|-----|-------|
| `--text-negative` | `#f3727f` | Error text |
| `--essential-negative` | `#ed2c3f` | Error icon |
| Light | `#ffadb6` | Error background light |
| Mid | `#e91429` | Warning red |
| Dark | `#cd1a2b` | Deep error |

### 3.5 Warning Orange

| Token | Hex | Usage |
|-------|-----|-------|
| `--text-warning` | `#ffa42b` | Warning text |
| `--essential-warning` | `#ffa42b` | Warning icon |
| Light | `#ffb656` | Warning light |
| Gold | `#ffc742` / `#ffd97e` / `#ffeab8` | Gold/orange tints |
| Deep | `#ffb504` | Deep orange/gold |
| Pastel | `#bf6d00` / `#f18900` | Amber |

### 3.6 Theme Architecture

```
encore-dark-theme (default)
  ├── encore-base-set → sets --parents-essential-base: #fff
  └── encore-bright-accent-set → sets --background-base: #1ed760
      (for green-filled components like play buttons)
```

The system uses a cascade pattern:
1. **Theme** sets base semantic colors
2. **Color sets** override within component context
3. **Components** reference semantic tokens, not raw values

### 3.7 Color Usage Patterns

- **Surface separation**: Achieved through brightness difference, not borders or shadows
- **Borders**: `--decorative-subdued` (#292929) for subtle separators
- **Interactive feedback**: Background opacity overlays (tinted-base → tinted-highlight → tinted-press) using `rgba(255,255,255, X)` 
- **Focus**: Uses `--essential-base` (#fff) for focus indicators
- **Disabled**: Opacity at `--encore-opacity-disabled: 0.3`

---

## 4. Typography System

### 4.1 Font Stacks

#### Primary Fonts (Self-Hosted WOFF2, loaded from `encore.scdn.co`)

| Font | Token | Usage | Weights |
|------|-------|-------|---------|
| **SpotifyMixUI** | `--encore-body-font-stack` | Body text, UI elements | Regular, Bold |
| **SpotifyMixUITitle** | `--encore-title-font-stack` | Headings, titles | Variable (Title) |
| **SpotifyMixUITitleVariable** | `--encore-variable-font-stack` | Display text, variable weights | Variable |
| **SpotifyMixMono** | `--encore-bodyMono-font-stack` | Tabular data, code, time displays | Regular |

#### Fallback Script Fonts

```
SpotifyMixUI, CircularSp-Arab, CircularSp-Hebr, CircularSp-Cyrl, CircularSp-Grek, CircularSp-Deva, var(--fallback-fonts, sans-serif)
```

Five region-specific fallback fonts handle Arabic, Hebrew, Cyrillic, Greek, and Devanagari scripts before falling back to system sans-serif.

#### Font Preloading

The HTML preloads fonts with `crossorigin="anonymous"`:
- `SpotifyMixUI-Regular.woff2`
- `SpotifyMixMono-Regular.woff2`
- `SpotifyMixUITitleVariable.woff2`
- `SpotifyMixUI-Bold.woff2`

### 4.2 Type Scale

12 semantic steps from 0.5625rem to 3rem:

| Token | Size (rem) | Size (px @16px) | Usage |
|-------|-----------|-----------------|-------|
| `--encore-text-size-smaller-3` | 0.5625rem | 9px | Micro text, legal |
| `--encore-text-size-smaller-2` | 0.6875rem | 11px | Subtle metadata |
| `--encore-text-size-smaller` | 0.8125rem | 13px | Secondary text |
| `--encore-text-size-base` | 1rem | 16px | Body text (default) |
| `--encore-text-size-large` | 1.125rem | 18px | Emphasis body |
| `--encore-text-size-larger` | 1.25rem | 20px | Subtle heading |
| `--encore-text-size-larger-2` | 1.5rem | 24px | Section title |
| `--encore-text-size-larger-3` | 2rem | 32px | Page heading |
| `--encore-text-size-larger-4` | 2.5rem | 40px | Large heading |
| `--encore-text-size-larger-5` | 3rem | 48px | Hero display |

### 4.3 Typography Classes

Semantic text classes (`encore-text-*`) cascade with the Encore type scale:

| Class | Usage |
|-------|-------|
| `encore-text-marginal` | Smallest UI text (bottom nav labels) |
| `encore-text-body-medium` | Default body text, list row titles |
| `encore-text-body-medium-bold` | Bold body text (button labels) |
| `encore-text-title-small` | Section headings (Home "Recently Played") |
| `encore-text-headline-large` | Uses `var(--encore-title-font-stack)` |

### 4.4 Typography Features

- **Anti-aliasing**: `-webkit-font-smoothing: antialiased` on body
- **Line clamping**: `--encore-line-clamp` CSS custom property
- **Text overflow**: `e-10451-overflow-wrap-anywhere` with `overflow-wrap: anywhere`
- **Text overflow ellipsis**: `e-10451-text-overflow-hidden` with `text-overflow: ellipsis`
- **Line clamp component**: `e-10451-line-clamp` class with `--encore-line-clamp: 2` (configurable)
- **Variable fonts**: Title font stack uses variable weight axis for fine control

---

## 5. Motion System

### 5.1 Easing Curves

| Token | Value | Usage |
|-------|-------|-------|
| `--encore-productive` | `cubic-bezier(0.3, 0, 0, 1)` | Default productive motion |
| `--encore-productive-decelerate` | `cubic-bezier(0, 0, 0.2, 1)` | Entry animations |
| `--encore-productive-accelerate` | `cubic-bezier(0.8, 0, 1, 1)` | Exit animations |

**Signature easing**: The `productive` curve (0.3, 0, 0, 1) provides a quick start with a gentle deceleration — feels responsive without being abrupt. This is the single most-used easing across the entire system.

### 5.2 Duration Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `--encore-shortest-1` | (implicit, ~0.05s) | Instant feedback |
| `--encore-shortest-2` | 0.1s | Micro-interactions |
| `--encore-shortest-3` | 0.15s | Subtle transitions |
| `--encore-shortest-4` | 0.2s | Standard exit |
| `--encore-short-1` | 0.25s | Standard enter |
| `--encore-short-2` | 0.3s | Slower reveals |

### 5.3 Composite Motion Tokens

| Token | Composition | Usage |
|-------|-------------|-------|
| `--encore-productive-enter` | 0.25s + productive-decelerate | Entry animations |
| `--encore-productive-exit` | 0.2s + productive-accelerate | Exit animations |
| `--encore-productive-exit-duration` | 0.2s | Exit duration only |

### 5.4 Motion Patterns

**Standard transition properties** (what gets animated):
- `background-color` — most common, used for hover/press states
- `color` — text color changes
- `transform` — button scale (1.04x on hover)
- `opacity` — reveal/hide
- `border-color` — focus/active state borders
- `box-shadow` — elevation changes
- `outline-color` — focus ring animations
- `inset-inline-start` — toggle switch position

**Button hover scale**: `transform: scale(1.04)` — a subtle 4% expansion on hover

**Transition patterns found**:
```
background-color 0.15s cubic-bezier(0.3,0,0,1)  // box interactive hover
background-color 0.2s ease-in-out                 // legacy transitions
background-color 0.3s                             // standard bg changes
background-color 0.4s                             // slower bg changes
background-color 0.5s                             // slowest bg
opacity 0.2s cubic-bezier(0.3,0,0,1)             // overlay/backdrop shows
opacity 0.3s, transform 0.3s                      // dropdown/menu reveal
transform 0.1s ease-in-out                        // quick scale
transform 0.2s                                    // standard transform
```

### 5.5 Keyframe Animations (20 total)

| Name | Type | Description |
|------|------|-------------|
| `encore-fade-in` | Fade | Opacity 0 → 1 (named animation) |
| `oJb4AJ6P5r0rFBOL` | Fade | Simple opacity 0 → 1 |
| `oEDEasXZ50w_5pcd` | Fade | Opacity 1 start (reverse fade) |
| `cUpzo1sFngEgaURW` | Fade | Opacity variant |
| `uvVUseuPjtIrrnmG` | Fade | Opacity variant |
| `k6a5sQKKiwpfd3hP` | Fade | Opacity fade out |
| `pnwKu7OxsG4qQi8h` | Slide+Fade | Opacity 0 + translateX(25%) |
| `xhml7YYz1oInvoFC` | Slide In | TranslateY(20px) + fade in |
| `Qw4gXqCJS8tQaX3R` | Slide Up | TranslateY(100%) entrance (bottom sheet) |
| `IrPRibip_Gkn0oxY` | Slide Up | TranslateY(100%) + fade entrance |
| `NZZkZaSoZDMVUcnI` | Slide Up | Translate3d(0,100%,0) (3D accelerated) |
| `x5oZrWm1VpQUxpNZ` | Slide Down | Translate3d(0,0,0) (reverse) |
| `vryqPFAYnho6WZ4k` | Slide | TranslateY(0%) + opacity 1 (steady state) |
| `W3rF4GKBMiLCJ6x0` | Translate | Translate(0,0) + opacity 1 |
| `AXLA1auWEEA98EtP` | Scale X | ScaleX(0) → 1 (horizontal expand) |
| `r8LO6E4cmSctSVbQ` | Scale X | ScaleX(0) → 1 (progress bar) |
| `EgxBlzS8CAkH4M7g` | Rotate | Rotate(-45deg) (accordion icon) |
| `progress-circle-indeterminate-animation` | SVG Stroke | Dashoffset + rotate for loading spinners |
| `progress-dots-animation` | Scale | Dot scaling with cubic-bezier(1,0,0.7,1) |
| `loading` | Scale | Skeleton loading with scaling pulse |

### 5.6 Motion Principles

1. **Reduced motion respected**: `@media (prefers-reduced-motion: no-preference)` wraps all non-essential animations
2. **Productive easing only**: One primary easing family — no bouncy/elastic/spring animations
3. **Quick durations**: 100ms-300ms range (no slow 500ms+ decorative animations)
4. **exit-duration pattern**: Used with `visibility 0s var(--encore-productive-exit-duration)` to delay hiding until after the exit animation completes
5. **Background-color as primary target**: Unlike many design systems that animate opacity or transform, Encore frequently animates background-color for interactive state changes

---

## 6. Interaction Patterns

### 6.1 Box Interactive System

The `e-10451-box--interactive` class provides hover/press states using `::after` pseudo-elements:

| Variant | Hover | Press | Description |
|---------|-------|-------|-------------|
| **Naked** | `::after` inset 0 → bg: `--background-highlight` | bg: `--background-press` | Standard interactive surface |
| **Naked + Contrasting** | `--background-highlight` | `--background-press` | High-contrast interactive |
| **Tinted** | `--background-tinted-highlight` | `--background-tinted-press` | Subtle tinted interaction |

The `::after` pseudo-element overlay approach:
- Naked box: `::after` starts with inset matching padding, transitions to `inset: 0` on hover
- This creates a "filling in" visual effect rather than a simple color change
- Press state uses `--bg-inset-change-press` for a reverse inset effect

**Transition**: `background-color, inset` with `var(--animation-speed, var(--encore-shortest-1))`

### 6.2 Button Interactions

| State | Behavior | Duration |
|-------|----------|----------|
| **Hover** | `transform: scale(1.04)` + background change | 0.25s |
| **Press** | `transform: scale(1)` (back to normal) | Instant |
| **Focus-visible** | `outline: 2px solid var(--text-base)` + offset | 0.25s |
| **Disabled** | `cursor: not-allowed` + `opacity: 0.3` | N/A |
| **Loading** | Progress circle appears, label hidden | Immediate |

**Button sizes (min-block-size)**:
- `--encore-control-size-smaller`: 32px (default)
- `--encore-control-size-base`: 48px
- `--encore-control-size-larger`: 56px

### 6.3 Focus System

| Token | Value | Usage |
|-------|-------|-------|
| `--encore-border-width-focus` | 2px | Focus outline thickness |
| `--encore-focus-outline-color` | `var(--essential-negative)` | Default focus color (red, ensuring high contrast on dark) |
| `--encore-focus-outline-offset` | `calc(var(--encore-border-width-focus) * -1)` | Inset focus on some elements |

**Fallback focus**: `outline: var(--encore-border-width-thin) solid var(--text-base)` on buttons

### 6.4 List Row Interactions

| State | Behavior |
|-------|----------|
| **Hover** | `background-color: var(--encore-list-row-hover-bg)` (defaults to `--background-highlight`) |
| **Active** | `background-color: var(--encore-list-row-active-bg)` |
| **Selected** | `--encore-list-row-bg: color-mix(in srgb, var(--text-announcement) 6%, transparent)` + hairline border |
| **Bordered** | Hairline bottom border via `inset` box-shadow |

### 6.5 Overlay System

| Component | Z-Index | Shadow |
|-----------|---------|--------|
| Backdrop | 1040 | N/A (darkens background) |
| Dialog | `--encore-z-index-dialog: 1050` | `0 4px 12px 0 rgba(0,0,0,0.3)` |
| Popover | `--encore-z-index-popover: 1060` | `0 4px 6px rgba(0,0,0,0.3)` |
| Skip Link | `--encore-z-index-skiplink: 9999` | N/A |

### 6.6 Opacity States

| Token | Value | Usage |
|-------|-------|-------|
| `--encore-opacity-active` | 0.7 | Active/pressed opacity |
| `--encore-opacity-disabled` | 0.3 | Disabled state opacity |

---

## 7. Spacing System

12-step spacing scale from 2px to 64px:

| Token | Value | Usage |
|-------|-------|-------|
| `--encore-spacing-tighter-5` | 2px | Minimum gap, hairline offset |
| `--encore-spacing-tighter-4` | 4px | Content-inline padding, icon offset |
| `--encore-spacing-tighter-3` | 6px | Button padding, card gap |
| `--encore-spacing-tighter-2` | 8px | Standard compact gap, icon padding |
| `--encore-spacing-tighter` | 12px | Compact spacing, sidebar padding |
| `--encore-spacing-base` | 16px | Default spacing, layout margin |
| `--encore-spacing-looser` | 20px | Comfortable spacing |
| `--encore-spacing-looser-2` | 24px | Section spacing |
| `--encore-spacing-looser-3` | 32px | Large section gap |
| `--encore-spacing-looser-4` | 40px | Major section divider |
| `--encore-spacing-looser-5` | 48px | Page-level spacing |
| `--encore-spacing-looser-6` | 64px | Maximum spacing |

**Naming convention**: `tighter` (smaller than base) and `looser` (larger than base), with numbered levels indicating degree.

---

## 8. Component Patterns

### 8.1 Core Components (Identified via `data-encore-id`)

| `data-encore-id` | Component | Description |
|-----------------|-----------|-------------|
| `text` | Text | Typography component supporting all size/weight variants |
| `image` | Image | Aspect-ratio aware, lazy loading, rounded corners |
| `listRowTitle` | List Row Title | Overflow-wrap, line-clamp title for cards |
| `icon` | Icon | SVG icon with configurable size |

### 8.2 Class-Based Component Families

**Layout Primitives**:
- **Box** (`e-10451-box`): Container with variants — `--naked` (transparent), `--tinted` (rgba overlay), `--elevated` (`#1f1f1f`), `--interactive` (hover/press states), `--contrasting`, `--min-size`, `--as-link`, `--padding-custom`
- **Card** (`e-10451-card`): Composed from Box, adds `__on-click`, `__main`, `__interactive`, `__column` sub-elements. Variant: `--small`

**Navigation**:
- **NavBar** (`e-10451-nav-bar-list-item`): Bottom tab bar with active/focus/disabled states
- **Navigation List** (`e-10451-navigation-list-item`): Sidebar navigation links
- **Nav Pill** (`e-10451-nav-pill-list-item`): Pill-shaped navigation chips
- **Tab** (`e-10451-tab-item`, `e-10451-tab-list`, `e-10451-tab-panel`): Tabbed interface

**Data Display**:
- **List Row** (`e-10451-list-row`): Horizontal list items with alignment variants (`--align-start/end/center/stretch/baseline`), `--bordered`, `--naked`, `--interactive`, `--selected`
- **Table** (`e-10451-table`): Collapsed border table with thumbnail container
- **Accordion** (`e-10451-accordion`, `e-10451-accordion-title`, `e-10451-accordion-content`): Expandable sections with animated chevron

**Forms**:
- **Button** (`e-10451-button`): Primary, secondary, tertiary variants. Sizes: small/medium. With icon, loading state, floating variant, condensed mode
- **Legacy Button** (`e-10451-legacy-button`): Older button API with tertiary variant
- **Form Control** (`e-10451-form-control`): Input wrapper
- **Form Checkbox** (`e-10451-form-checkbox`): Custom checkbox with `__indicator`
- **Form Radio** (`e-10451-form-radio`): Custom radio with `__indicator`
- **Form Toggle** (`e-10451-form-toggle`): Toggle switch with `__indicator` and `__wrapper`
- **Chip** (`e-10451-chip`): Compact selection chips with `__icon`, `__label`, and clear variant
- **Chip Group** (`e-10451-chip-group`): Horizontal chip container

**Overlays**:
- **Dialog/Modal** (z-index 1050): Backdrop + overlay pattern
- **Popover** (z-index 1060): Floating overlay for dropdowns
- **Dropdown** (`e-10451-dropdown-link`, `e-10451-dropdown-list`, `e-10451-dropdown-trigger`): Selection dropdown
- **Overflow Button** (`e-10451-overflow-button`): Action overflow menu
- **Backdrop** (`e-10451-backdrop`): Z-index 1040 modal backdrop

**Feedback**:
- **Banner** (`e-10451-banner`): Top notification banner with `__icon`, `__close-button`, `--color-set`, `--small` variant
- **Empty State** (`e-10451-empty-state`): Empty state with `__message-container`
- **Progress Circle** (`e-10451-progress-circle`): SVG circle progress (determinate + indeterminate)
- **Progress Dots** (`e-10451-progress-dots`): Animated dot loading indicator `...`
- **Verified Badge** (`e-10451-verified-badge`): Green checkmark badge with `--over-image` variant

**Miscellaneous**:
- **Link** (`e-10451-link`): Inline and standalone link variants
- **Text Link** (`e-10451-text-link`): Text-styled link with color inheritance
- **Horizontal Rule** (`e-10451-horizontal-rule`): Divider line
- **Visually Hidden** (`e-10451-visually-hidden`): Screen-reader-only content
- **Line Clamp** (`e-10451-line-clamp`): Multi-line text truncation
- **Focus Border Bottom** (`e-10451-focus-border-bottom`): Focus ring at bottom only

### 8.3 Card Component Architecture

```
e-10451-card (extends e-10451-box)
  └── e-10451-card__on-click (invisible click target)
  └── e-10451-card__main
      ├── e-10451-image (cover image, 152px min-inline-size, 4px radius)
      └── e-10451-card__column
          ├── e-10451-list-row-title (text link, line-clamp: 2)
          └── e-10451-text (subtitle, subdued color)
```

**Card variants**:
- `e-10451-card--small`: Compact card (home page track/artist/album cards)
- Gap tokens: `--encore-card-horizontal-gap`, `--encore-card-vertical-gap`, `--encore-card-title-gap`

### 8.4 Button Component Architecture

```
e-10451-button
  ├── Sizes: --medium (default, 32px min), --small
  ├── Variants: Primary, Secondary, Tertiary, Icon
  ├── States: hover (scale 1.04), active, focus-visible, disabled, loading
  ├── │── e-10451-button__inner (wraps label/icon)
  ├── │── e-10451-button__progress-circle (loading state)
  ├── Special: --floating (with shadow), --floating-background (elevated bg)
  └── Condensed: --condensed-all for minimal padding
```

### 8.5 Form Component Architecture

**Checkbox**:
```
input[type="checkbox"] (hidden, accessible)
  └── label
      └── e-10451-form-checkbox__indicator (custom visual)
          (border-color changes on :hover, :checked, :active)
```

**Toggle**:
```
input[type="checkbox"] (hidden, accessible)
  └── e-10451-form-toggle__wrapper (track, green when checked)
      └── e-10451-form-toggle__indicator (white knob, slides left/right)
```

### 8.6 Navigation Patterns

**Bottom Tab Bar** (mobile):
```
e-10451-bottom-tab-bar
  ├── Nav Item (Home): active → sdAjopa4wUgt9GQ7 class (white)
  │   ├── FByM6mgNkSMfGIqI (link class)
  │   └── e-10451-text encore-text-marginal (label)
  ├── Nav Item (Search)
  └── Nav Item (Your Library)
```

**Sidebar Navigation**:
- `e-10451-navigation-list-item__link` — primary nav links
- `e-10451-navigation-action` — secondary navigation actions
- `e-10451-nav-bar-list-item__link--focus-border` — focus indicator via `::after` pseudo-element

---

## 9. Design Tokens (Complete Catalog)

### 9.1 Spacing Tokens

| Token | Value |
|-------|-------|
| `--encore-spacing-tighter-5` | 2px |
| `--encore-spacing-tighter-4` | 4px |
| `--encore-spacing-tighter-3` | 6px |
| `--encore-spacing-tighter-2` | 8px |
| `--encore-spacing-tighter` | 12px |
| `--encore-spacing-base` | 16px |
| `--encore-spacing-looser` | 20px |
| `--encore-spacing-looser-2` | 24px |
| `--encore-spacing-looser-3` | 32px |
| `--encore-spacing-looser-4` | 40px |
| `--encore-spacing-looser-5` | 48px |
| `--encore-spacing-looser-6` | 64px |

### 9.2 Border Radius Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `--encore-corner-radius-smaller-2` | (implicit) | Card images |
| `--encore-corner-radius-smaller` | 2px | Subtle rounding |
| `--encore-corner-radius-base` | 4px | Default surface rounding |
| `--encore-corner-radius-larger` | 6px | Cards, panels |
| `--encore-corner-radius-larger-2` | 8px | Elevated surfaces |
| `--encore-corner-radius-larger-3` | 16px | Large containers |
| `--encore-border-radius-rounded` | 9999px | Pills, buttons, chips |

### 9.3 Border Width Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `--encore-border-width-hairline` | 1px | Subtle dividers, list row borders |
| `--encore-border-width-thin` | 2px | Focus rings, button borders |
| `--encore-border-width-focus` | 2px | Focus outline |
| `--encore-border-width-thick` | 4px | Heavy borders |
| `--encore-border-width-thicker` | 8px | Maximum border weight |

### 9.4 Graphic Size Tokens

**Decorative** (icons, small graphics):

| Token | Value | Usage |
|-------|-------|-------|
| `--encore-graphic-size-decorative-smaller-2` | 12px | Micro icons |
| `--encore-graphic-size-decorative-smaller` | 16px | Small icons |
| `--encore-graphic-size-decorative-base` | 24px | Default icons |
| `--encore-graphic-size-decorative-larger` | 32px | Large icons |
| `--encore-graphic-size-decorative-larger-2` | 40px | XL icons |
| `--encore-graphic-size-decorative-larger-3` | 48px | 2XL icons |
| `--encore-graphic-size-decorative-larger-4` | 64px | Hero icons |
| `--encore-graphic-size-decorative-larger-5` | 88px | Display icons |

**Informative** (profile images, album art):

| Token | Value (rem) | Usage |
|-------|------------|-------|
| `--encore-graphic-size-informative-smaller-2` | 0.75rem | Tiny avatars |
| `--encore-graphic-size-informative-smaller` | 1rem | Small avatars |
| `--encore-graphic-size-informative-base` | 1.5rem | Default avatars |
| `--encore-graphic-size-informative-larger` | 2rem | Large avatars |
| `--encore-graphic-size-informative-larger-2` | 2.5rem | XL avatars |
| `--encore-graphic-size-informative-larger-3` | 3rem | 2XL avatars |
| `--encore-graphic-size-informative-larger-4` | 4rem | Profile images |
| `--encore-graphic-size-informative-larger-5` | 5.5rem | Hero profile images |

### 9.5 Control Size Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `--encore-control-size-smaller` | 32px | Compact buttons, chips |
| `--encore-control-size-base` | 48px | Standard touch targets |
| `--encore-control-size-larger` | 56px | Large touch targets |

### 9.6 Duration Tokens

| Token | Value |
|-------|-------|
| `--encore-shortest-1` | ~0.05s (implicit) |
| `--encore-shortest-2` | 0.1s |
| `--encore-shortest-3` | 0.15s |
| `--encore-shortest-4` | 0.2s |
| `--encore-short-1` | 0.25s |
| `--encore-short-2` | 0.3s |

### 9.7 Easing Tokens

| Token | Value |
|-------|-------|
| `--encore-productive` | `cubic-bezier(0.3, 0, 0, 1)` |
| `--encore-productive-decelerate` | `cubic-bezier(0, 0, 0.2, 1)` |
| `--encore-productive-accelerate` | `cubic-bezier(0.8, 0, 1, 1)` |
| `--encore-productive-enter` | `0.25s cubic-bezier(0, 0, 0.2, 1)` |
| `--encore-productive-exit` | `0.2s cubic-bezier(0.8, 0, 1, 1)` |

### 9.8 Miscellaneous Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `--encore-opacity-active` | 0.7 | Active state |
| `--encore-opacity-disabled` | 0.3 | Disabled state |
| `--encore-button-hover-scale` | 1.04 | Button hover scale |
| `--encore-overlay-trigger-corner-offset` | 17px | Popover positioning |
| `--encore-sidebar-base-width` | 200px | Sidebar width |
| `--encore-image-aspect-ratio` | 1/1 | Default image aspect |
| `--encore-line-clamp` | (variable) | Text line clamp count |

---

## 10. Key Takeaways

### 10.1 What Makes Encore Distinctive

1. **Dark-first, not dark-as-afterthought**: The entire design system is built around `#121212` as the foundational color. Light theme is secondary.

2. **Semantic token cascade**: `background-base → background-elevated-base → background-elevated-highlight → background-tinted-base` creates a clear visual hierarchy without shadows or borders.

3. **Opacity-based surface layering**: Instead of solid color variants, Encore uses `rgba(255,255,255, opacity)` overlays for tinted surfaces — this means it works on any background, making theming inherently flexible.

4. **Single green accent discipline**: `#1ed760` serves as accent, positive, and active indicator. No secondary accent colors — everything non-green is neutral white/gray on dark.

5. **Productive easing only**: One easing family (`cubic-bezier(0.3,0,0,1)`) used everywhere. No spring physics, no bouncy animations, no elastic — purely functional and predictable.

6. **Custom font as identity**: SpotifyMixUI (and its Title/Mono/Variable variants) is the sole typographic voice. Combined with 5 script-specific fallbacks for global coverage.

7. **12-step scales**: Both spacing (2-64px) and typography (9-48px) use 12-step scales — comprehensive enough for any UI but not infinite.

8. **Box as universal primitive**: The `e-10451-box` component with its `::after` pseudo-element interactive system provides hover/press states across all components through composition.

9. **Hairline box-shadow borders**: Instead of `border-bottom`, list rows use `inset` box-shadows for borders — enabling cleaner compositing with border-radius and background transitions.

10. **Z-index discipline**: Only 3 named z-index layers (dialog 1050, popover 1060, skiplink 9999) — no z-index wars.

### 10.2 Design Decisions Worth Adopting

- **`color-mix()` for selected states**: `color-mix(in srgb, var(--text-announcement) 6%, transparent)` — programmatic opacity on semantic colors
- **Exit duration + visibility delay pattern**: `visibility 0s var(--encore-productive-exit-duration)` to keep elements visible during exit animation
- **`::after` overlay for interactive states**: Separates interaction styling from content, enabling consistent hover/press across any component
- **Decorative vs Informative graphic scales**: Two parallel size scales — one for UI icons, one for content images
- **Font preloading with crossorigin**: All custom fonts preloaded with `crossorigin="anonymous"` for optimal loading

---

## 11. Extraction Limitations

1. **Redirect from spotify.design**: The original spotify.design design blog has been deprecated and 301-redirects to open.spotify.com. This extraction analyzes the production Web Player rather than the former design blog content.

2. **Single-page analysis**: Only the homepage (web player landing) was analyzed. The Search, Library, playlist detail, and album detail pages may contain additional patterns.

3. **Dark theme only**: The Web Player serves exclusively in dark mode via `encore-dark-theme`. Light theme color values were not extracted from this page context (though they likely exist in the CSS).

4. **CSS minification**: The main stylesheet (277KB) is minified to 1-2 lines, making precise extraction of certain patterns difficult. Some tokens may exist in unmapped hashed class names.

5. **No JavaScript analysis**: Only 1 CSS file was fetched (within the 5-CSS budget). JavaScript bundles were not analyzed — component state management, event handling, and conditional rendering patterns were inferred from HTML structure only.

6. **No light theme extraction**: The `encore-light-theme` values were not present in the page context and could not be definitively extracted from the minified CSS.

7. **Styled-components embedding**: The page uses styled-components (`data-styled="active"`), meaning some styles are embedded in JS and not in the external CSS file.

---

## 12. File Sizes & Request Summary

| Resource | Size | Status |
|----------|------|--------|
| Homepage HTML | 146 KB | Fetched |
| Main CSS (mobile-web-player.css) | 277 KB | Fetched |
| CSS Custom Properties Extracted | 197 tokens | Parsed |
| Semantic Color Tokens | 26 | Parsed |
| Keyframe Animations | 20 | Parsed |
| Media Query Breakpoints | 9 | Parsed |
| **Total HTTP Requests** | **2 of 15 budget** | Used |
| **Total Downloaded** | **423 KB of 2 MB** | Used |
