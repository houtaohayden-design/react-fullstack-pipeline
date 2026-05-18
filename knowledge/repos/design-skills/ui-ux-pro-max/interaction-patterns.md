# UI/UX Pro Max — Interaction & Motion Patterns

## Overview

This document catalogs the complete interaction design and motion system from UI/UX Pro Max v2.5.0. It covers 67 style-specific animation profiles, 24 detailed motion rules, 17 touch/interaction rules, gesture design framework, page transition patterns, scroll behavior specifications, loading state patterns, and platform-specific interaction guidance for web, iOS, and Android.

**Source**: https://github.com/nextlevelbuilder/ui-ux-pro-max-skill

---

## 1. Animation Rules (Priority 7 — MEDIUM)

The Quick Reference defines 24 animation rules organized as a comprehensive motion design system. These rules are mandatory for any production UI.

### Duration & Timing

| Rule | Value | Rationale |
|------|-------|-----------|
| Micro-interactions | 150–300ms | Short enough to feel instant, long enough to perceive |
| Complex transitions | <=400ms | Multi-step or full-screen transitions |
| Maximum duration | 500ms | Anything longer feels sluggish |
| Exit animations | 60-70% of enter | Exit faster than enter to feel responsive |
| Stagger delay | 30–50ms per item | Natural sequential reveal without feeling slow |
| Tap feedback | Within 100ms | Apple HIG standard for perceived instantaneity |

### Easing Curves

```
Enter:  ease-out         (fast start, gentle finish — feels responsive)
Exit:   ease-in          (gentle start, fast finish — feels decisive)
Never:  linear           (robotic, unnatural — fails Apple HIG requirement)
Prefer: spring/physics   (natural, interruptible, fluid — Apple HIG fluid animations)
```

### Property Constraints (CRITICAL)

**Must animate only compositor-friendly properties:**
- `transform` (translate, scale, rotate)
- `opacity`
- `clip-path` (sparingly)
- `filter` (sparingly)

**Must NOT animate layout-bound properties:**
- `width` / `height` (triggers layout reflow)
- `top` / `left` / `right` / `bottom` (triggers layout reflow)
- `margin` / `padding` (triggers layout reflow)
- `border` (triggers paint)
- `font-size` (triggers layout reflow)

### Motion Semantics

| Rule | Description | Source |
|------|-------------|--------|
| Motion meaning | Every animation must express cause-effect, not just decoration | Apple HIG |
| State transition | Hover/active/expanded/collapsed/modal must animate smoothly, not snap | MD |
| Continuity | Page transitions maintain spatial continuity (shared element, directional slide) | Apple HIG |
| Hierarchy motion | Enter from below = deeper. Exit upward = back.Translate/scale direction expresses hierarchy | MD |
| Navigation direction | Forward = left/up. Backward = right/down. Keep direction logically consistent | HIG |
| Fade crossfade | Content replacement within same container uses crossfade | MD |
| Scale feedback | Subtle 0.95–1.05 scale on press. Restore on release | HIG, MD |
| Gesture feedback | Drag/swipe/pinch provide real-time visual response tracking finger | MD Motion |
| Modal motion | Modals/sheets animate from trigger source (scale+fade or slide-in) for spatial context | HIG, MD |

### Interactivity & Accessibility

| Rule | Description |
|------|-------------|
| Interruptible | Animations must be interruptible. User tap/gesture cancels in-progress animation immediately |
| No blocking animation | Never block user input during animation. UI must stay interactive |
| Parallax subtlety | Use parallax sparingly. Must respect reduced-motion and not cause disorientation |
| Excessive motion | Animate 1–2 key elements per view max. Avoid "animation soup" |
| Opacity threshold | Fading elements should not linger below opacity 0.2. Either fade fully or remain visible |
| Layout shift avoid | Animations must not cause layout reflow or CLS. Use transform for position changes |
| Motion consistency | Unify duration/easing tokens globally. All animations share the same rhythm and feel |

### Loading & Performance

| Rule | Description |
|------|-------------|
| Loading states | Show skeleton or progress indicator when loading exceeds 300ms |
| Progressive loading | Use skeleton screens/shimmer instead of long blocking spinners for >1s operations |
| No decorative-only | Every animation must have purpose. Purely decorative motion fails Apple HIG |

---

## 2. Touch & Interaction (Priority 2 — CRITICAL)

17 rules define the touch interaction system, drawn from Apple HIG and Material Design.

### Touch Target Specification

| Platform | Minimum Size | Standard |
|----------|-------------|----------|
| iOS (Apple HIG) | 44x44pt | Extend hit area beyond visual bounds if needed |
| Android (Material) | 48x48dp | Touch target + 8dp minimum gap |
| Web | 44x44px minimum | Use cursor-pointer on clickable elements |

### Touch Spacing & Density

- Minimum 8px/8dp gap between touch targets
- Keep component spacing comfortable for touch: not cramped, not causing mis-taps
- Avoid requiring pixel-perfect taps on small icons or thin edges
- Safe area awareness: keep primary touch targets away from notch, Dynamic Island, gesture bar and screen edges

### Interaction Feedback

| Type | Implementation | Source |
|------|---------------|--------|
| Press feedback | Visual feedback on press: ripple (MD state layers) or highlight | MD |
| Haptic feedback | Use for confirmations and important actions. Avoid overuse | Apple HIG |
| Scale feedback | Subtle 0.95–1.05 scale on press, restore on release | HIG, MD |
| Loading buttons | Disable button during async operations. Show spinner or progress | General |
| Tap delay | Use `touch-action: manipulation` to reduce 300ms delay on web | Web |
| Tap feedback speed | Visual feedback within 100ms of tap | Apple HIG |
| Input latency | Keep input latency under ~100ms for taps/scrolls | MD |

### Hover vs Tap Strategy

- Primary interactions: use click/tap
- Never rely on hover alone for critical functionality
- Hover states are supplemental, not essential
- On mobile, hover states don't exist — design for tap-first

### Gesture Design

| Rule | Description |
|------|-------------|
| Gesture conflicts | Avoid horizontal swipe on main content. Prefer vertical scroll |
| Standard gestures | Use platform standard gestures consistently. Don't redefine swipe-back, pinch-zoom |
| System gestures | Don't block system gestures (Control Center, back swipe, etc.) |
| Gesture alternative | Don't rely on gesture-only interactions. Always provide visible controls for critical actions |
| Swipe clarity | Swipe actions must show clear affordance or hint (chevron, label, tutorial) |
| Drag threshold | Use movement threshold before starting drag to avoid accidental drags |
| No precision required | Avoid requiring pixel-perfect taps on small icons or thin edges |

### Debounce & Throttle

```
High-frequency events requiring debounce:
  - scroll events
  - resize events
  - input/keystroke events (search-as-you-type)

Target: debounce 150-300ms for search input, throttle 16ms for scroll handlers
```

---

## 3. Style-Specific Animation Profiles

Each of the 67 UI styles defines unique motion characteristics extracted from the `Effects & Animation` column of styles.csv.

### Minimal & Professional Styles

| Style | Animation Profile | Key Characteristics |
|-------|------------------|---------------------|
| Minimalism & Swiss (Style 1) | Subtle hover 200-250ms, smooth transitions, sharp shadows if any | Fast loading, clear type hierarchy, no decorative motion |
| Corporate/Material Design (Style 16) | Ripple effects, elevation changes, consistent 250ms motion | Material Design motion system, state layers |
| Flat Design (Style 5) | Simple, fast transitions. Minimal or no animation | Instant state changes acceptable |
| Modern Professional (Style 12) | Subtle hover elevation, smooth color transitions | Understated but polished |

### Glass & Depth Styles

| Style | Animation Profile | Key Characteristics |
|-------|------------------|---------------------|
| Glassmorphism (Style 3) | Backdrop blur 10-20px, light reflection, Z-depth layering | Frosted glass depth perception through blur |
| Neumorphism (Style 4) | Soft box-shadow multiple layers, smooth press 150ms, inner subtle shadow | Embossed/debossed depth illusion |
| Dark Mode (Style 13) | Ambient glow, smooth dark-to-darker transitions | Subdued motion in low-light context |
| 3D & Depth (Style 25) | Perspective transforms, parallax layers, Z-axis motion | True 3D CSS transforms |

### Bold & Expressive Styles

| Style | Animation Profile | Key Characteristics |
|-------|------------------|---------------------|
| Neubrutalism (Style 38) | Bold hover state changes, hard shadow shifts, instant or 100-150ms | Gen Z aesthetic, box-shadow: 4px 4px 0 #000, border: 3px solid #000 |
| Brutalism (Style 5) | No smooth transitions (instant), sharp corners 0px | raw/unpolished, intentional |
| Memphis Design (Style 20) | Bouncy transitions, playful staggered reveals | 1980s postmodern, energetic |
| Vaporwave (Style 32) | Synthwave glow, neon pulse, chromatic aberration | Retro-futuristic, synth/neon |
| Cyberpunk (Style 33) | Glitch effects, neon flicker, scan lines, terminal-style reveals | High-tech dystopian |
| Retro-Futurism (Style 35) | Vintage fade effects, CRT scan lines, typewriter text reveals | Nostalgic future aesthetic |
| Y2K (Style 36) | Chrome reflections, bubbly transitions, metallic sheen | Early 2000s aesthetic |

### Organic & Nature Styles

| Style | Animation Profile | Key Characteristics |
|-------|------------------|---------------------|
| Organic/Biophilic (Style 22) | Flowing, natural easing (ease-in-out), gentle organic curves | Nature-inspired smoothness |
| Claymorphism (Style 23) | Soft 3D squash-and-stretch, subtle bounce on press | Playful, tactile, toy-like |
| Wabi-Sabi (Style 24) | Slow, deliberate, imperfect timing. Asymmetric reveals | Japanese aesthetic of imperfection |
| Aurora UI (Style 29) | Gradient animation 8-12s loops, flowing color transitions | Northern lights effect |

### Data & Dashboard Styles

| Style | Animation Profile | Key Characteristics |
|-------|------------------|---------------------|
| Data Dashboard (Style 49) | Chart entrance animations, data update transitions | Respects prefers-reduced-motion |
| Dark Dashboard (Style 51) | Smooth data refresh, subtle glow on updates | Low-light data monitoring |
| Bento Grid (Style 44) | Card hover lift, staggered grid reveal 30-50ms per card | Apple-style widget layout |

---

## 4. Page Transitions & Navigation Motion

### Transition Direction System

```
Forward Navigation:
  - Direction: left slide (push) or up slide (present modally)
  - Easing: ease-out, 300-400ms
  - Type: shared element where applicable

Backward Navigation:
  - Direction: right slide (pop) or down slide (dismiss)
  - Easing: ease-in, 180-280ms (60-70% of forward)
  - Type: reverse of forward transition

Content Replacement (same level):
  - Type: crossfade 200-300ms
  - Use case: tab switches, filter changes
  - MD recommended pattern

Modal Presentation:
  - Animate from trigger source (scale+fade or slide-in)
  - Easing: spring physics recommended
  - Duration: 300-400ms
  - Close: reverse animation at 60-70% duration
  - Escape routes: provide cancel/back affordance
```

### Shared Element Transitions

```
Pattern: Hero/Shared Element Transition
Scope: Between screens that share a visual element (image, title, card)

Implementation rules:
1. Identify shared element between source and destination screens
2. Animate position + scale of shared element during transition
3. Crossfade surrounding chrome (nav bars, backgrounds)
4. Duration: 300-400ms with spring physics
5. Must be interruptible — user can cancel mid-transition

Platform support:
- iOS: Native UINavigationController + UIViewControllerAnimatedTransitioning
- Android: Material Shared Element Transition (Fragment/Compose)
- Web: View Transitions API or FLIP animation technique
```

### Scroll Behaviors

| Pattern | Implementation | Usage |
|---------|---------------|-------|
| Sticky headers | `position: sticky` with transform-only animation | Content scrolling beneath fixed nav/header |
| Scroll-triggered reveal | IntersectionObserver + opacity/translate animation | Staggered content sections revealing on scroll |
| Parallax | `translateY` on scroll, must respect reduced-motion | Hero sections, storytelling, background depth |
| Infinite scroll | Virtualize 50+ items, progressive loading indicators | Social feeds, search results |
| Smooth scroll | `scroll-behavior: smooth`, respect prefers-reduced-motion | Anchor link navigation |
| Scroll-linked effects | Use `requestAnimationFrame` + transform only | Progress indicators, sticky effects |
| Pull-to-refresh | Platform-native pattern with haptic feedback | List/dashboard data refresh |

### Scroll Constraints

```
DO:
  - Use transform for scroll-linked effects
  - Debounce scroll handlers at 16ms (requestAnimationFrame)
  - Provide skeleton/shimmers while loading next page
  - Virtualize lists with 50+ items
  - Respect prefers-reduced-motion for all scroll effects

DON'T:
  - Create nested scroll regions (interferes with main scroll)
  - Animate width/height on scroll (causes layout thrashing)
  - Use parallax without reduced-motion fallback
  - Cause horizontal scroll on mobile
  - Block main thread with heavy scroll handlers
```

---

## 5. Loading State Patterns

### Loading Threshold Hierarchy

| Duration | UX Response | Implementation |
|----------|-------------|---------------|
| 0–300ms | No indicator needed | Perceived as instant |
| 300ms–1s | Skeleton/shimmer | Subtle placeholder reveals content shape |
| 1s–3s | Progress indicator + skeleton | Linear/circular progress with context |
| 3s–10s | Progress + estimated time | Deterministic progress bar with ETA |
| 10s+ | Background task + notification | Move to background, notify on completion |

### Skeleton Screen Specification

```
Purpose: Show content shape before data arrives (Apple HIG recommended)

Design rules:
  - Match skeleton shape to expected content (text lines, image boxes, card shapes)
  - Use shimmer animation: linear-gradient sweep, 1.5s duration
  - Color: muted/200 tone from design palette
  - No sharp edges during loading (radius matches final content)
  - Progressive reveal: skeleton → real content with crossfade 200ms

Component-level skeletons:
  - Text: rounded bars matching line-height and expected width
  - Image: rounded rectangle matching aspect ratio
  - Card: outline shape with inner text skeletons
  - Chart: placeholder rectangle with axis lines
  - Avatar: circle placeholder
  - Button: rounded rectangle with subdued color
```

### Spinner Types & Usage

| Context | Spinner Type | Positioning |
|---------|-------------|-------------|
| Inline loading (button) | Small spinner replacing button text | Inside button, centered |
| Section loading | Skeleton preferred over spinner | Above fold or section container |
| Full page loading | Branded spinner or skeleton + logo | Centered viewport |
| Background refresh | Subtle indicator in nav/header | Non-blocking, corner position |
| Pull-to-refresh | Platform-native refresh indicator | Top of scrollable content |
| Infinite scroll | Small spinner at list bottom | Below last item, triggers next fetch |

### Progressive Loading Strategy

```
Phase 1 (Immediate, 0-300ms):
  - Shell/layout render (nav, header, footer)
  - Critical CSS inlined for above-fold content
  - Above-fold skeleton placeholders

Phase 2 (Async, 300ms-1s):
  - Above-fold content loads → crossfade from skeleton
  - Primary CTA becomes interactive
  - Critical images with eager loading + fetchpriority="high"

Phase 3 (Deferred, 1s+):
  - Below-fold content loads → IntersectionObserver triggered
  - Lazy-loaded images with loading="lazy"
  - Heavy components dynamic import
  - Non-critical data fetches

Phase 4 (Background):
  - Analytics, logging, telemetry
  - Prefetch likely next routes
  - Cache warming for anticipated data
```

---

## 6. Platform-Specific Interaction Guidance

### Web (Desktop Browser)

```
Input Method: Mouse + Keyboard (primary), Touch (secondary on hybrids)

Interaction Patterns:
  - Hover states: Essential for desktop. Use for tooltips, previews, affordance hints
  - Focus states: Visible focus rings 2-4px on all interactive elements
  - Keyboard navigation: Full Tab order, Enter/Space to activate, Escape to dismiss
  - Right-click: Context menus on complex data (tables, file trees)
  - Drag-and-drop: Mouse-based with keyboard alternatives for accessibility
  - Cursor: pointer on clickable, default on text, not-allowed on disabled
  - Tooltips: On hover with 300-500ms delay. Position above/below with 8px gap

Touch Targets (when touch-capable):
  - Minimum 44x44px clickable area
  - touch-action: manipulation to eliminate 300ms tap delay
  - No hover-dependent interactions for critical paths

Scroll Behavior:
  - Smooth scroll on anchor navigation (scroll-behavior: smooth)
  - Sticky positioning for persistent nav/headers
  - Scroll restoration on back navigation (browser default)
```

### iOS (iPhone/iPad)

```
Input Method: Touch (primary), Keyboard (iPad), Apple Pencil (iPad)

HIG Mandates:
  - Touch targets: 44x44pt minimum. Extend hit area beyond visual bounds
  - System gestures: Never block swipe-back, Control Center, app switcher
  - Safe areas: Respect notch, Dynamic Island, Home Indicator
  - Dynamic Type: Support system text scaling. Avoid truncation as text grows
  - Reduced Motion: Respect system setting. Disable/reduce animations when enabled
  - Haptic feedback: UIImpactFeedbackGenerator for confirmations. Avoid overuse
  - Standard gestures: Use platform defaults. Don't redefine swipe-back or pinch-zoom
  - Press feedback: Visual response within 100ms of tap

Navigation Patterns:
  - Tab Bar: Bottom, 3-5 items, icon + label
  - Navigation Bar: Top with back chevron
  - Modal sheets: Swipe-down to dismiss. Confirm unsaved changes
  - Deep linking: All key screens via URL scheme / universal links

Interaction States:
  - Normal → Highlighted (touch down) → Selected/Active → Normal (touch up)
  - Spring physics for fluid animations
  - Interruptible animations: touch cancels in-progress animation
```

### Android (Material Design)

```
Input Method: Touch (primary), Keyboard (some devices), Stylus

Material Design Mandates:
  - Touch targets: 48x48dp minimum. 8dp gap between targets
  - Ripple effect: Touch feedback via state layers and ripple animation
  - Elevation system: Shadow/elevation for z-ordering (1-24dp scale)
  - Navigation: Top App Bar with nav icon or Bottom Navigation (3-5 items)
  - System back: Predictive back gesture on Android 13+
  - Gesture navigation: Support system gesture bar. Don't conflict
  - Motion: Standard easing: Fast Out Slow In. Duration tokens: 200-400ms

Material Motion System:
  - Container transform: Shared element transition pattern
  - Fade through: Tab/level switching
  - Fade: Dialogs, menus, overlays
  - Slide: Navigation between destinations

Interaction States:
  - Enabled → Hovered → Focused → Pressed → Activated
  - State layers: overlay on press, opacity varies by state
  - Ripple: originates from touch point, expands to fill container
  - Duration: 200-400ms for state transitions
```

### Cross-Platform Interaction Consistency

```
Universal Rules (all platforms):
  1. Touch targets >= 44pt minimum
  2. Visual feedback within 100ms of interaction
  3. Respect system reduced-motion preferences
  4. Don't block system gestures
  5. Provide non-gesture alternatives for critical actions
  6. Support keyboard navigation (where applicable)
  7. Loading feedback for async operations exceeding 300ms
  8. State transitions must be smooth (animate, don't snap)

Platform-Specific Adaptations:
  - Hover states: Web-only. Never critical on mobile
  - Haptic feedback: Native mobile only. No web equivalent
  - System gestures: iOS swipe-back vs Android predictive back
  - Navigation: iOS Tab Bar at bottom vs Android Top App Bar
  - Safe areas: iOS notch/Dynamic Island vs Android camera cutout
  - Typography: SF Pro (iOS) vs Roboto (Android) vs system font stack (Web)
```

---

## 7. Loading State Design Tokens

### Skeleton Color Tokens

```css
--skeleton-base: var(--color-muted);       /* Background of skeleton */
--skeleton-shimmer: var(--color-muted-foreground); /* Shimmer highlight */
--skeleton-radius: var(--radius-md);        /* Matches real content radius */
--skeleton-duration: 1500ms;               /* Shimmer animation cycle */
```

### Spinner Specification

```css
--spinner-size-sm: 16px;    /* Inline: buttons, inputs */
--spinner-size-md: 24px;    /* Section: card, panel */
--spinner-size-lg: 48px;    /* Full page: centered */
--spinner-stroke: 2px;      /* Ring thickness */
--spinner-color: var(--color-primary);
--spinner-track: var(--color-muted);
--spinner-duration: 750ms;  /* One full rotation */
```

### Loading WCAG Requirements

```
- Skeleton must not cause layout shift (reserve space with aspect-ratio/min-height)
- Spinners must have aria-label="Loading" or role="status"
- Progress bars must have aria-valuenow, aria-valuemin, aria-valuemax
- Content must be announced when loaded (aria-live="polite")
- Reduced motion: replace shimmer with static skeleton, spinner with text "Loading..."
- Timeout feedback: request timeout must show clear error with retry option
```

---

## 8. Micro-Interaction Catalog

### Button Interactions

| State | Visual Change | Duration | Easing |
|-------|--------------|----------|--------|
| Rest | Base style | — | — |
| Hover (desktop) | Background lightens/darkens 5-10% | 150ms | ease-out |
| Press (active) | Scale 0.97 + background deepens | 100ms | ease-out |
| Loading | Spinner replaces text, button disabled | 150ms crossfade | ease-out |
| Success | Checkmark animation, then return to rest | 600ms total | spring |
| Disabled | Opacity 0.38-0.5, cursor not-allowed | — | — |

### Card/Container Interactions

| State | Visual Change | Duration |
|-------|--------------|----------|
| Rest | Base elevation shadow | — |
| Hover | Elevation increase (shadow deepens + translateY -2px) | 200ms |
| Press | Scale 0.98 + shadow reduction | 100ms |
| Expanded | Content reveal with height animation via max-height | 300ms |
| Drag | Real-time transform tracking pointer/finger | Realtime (RAF) |

### Input/Form Interactions

| State | Visual Change | Duration |
|-------|--------------|----------|
| Rest | Outlined/filled/underlined border | — |
| Focus | Border color → primary, optional ring 2px | 150ms |
| Typing | Cursor blink 1s cycle | CSS animation |
| Valid | Green border + optional checkmark icon | 200ms after blur |
| Invalid | Red border + error message slide-down reveal | 200ms |
| Disabled | Opacity 0.38, cursor not-allowed | — |

### Toggle/Switch Interactions

| State | Visual Change | Duration |
|-------|--------------|----------|
| Off → On | Track color change + thumb slide right | 200ms spring |
| On → Off | Track color change + thumb slide left | 200ms spring |
| Press | Scale 0.9 on thumb | 100ms |

---

## Summary: Interaction Quality Checklist

- [ ] All touch targets >= 44x44pt (iOS) / 48x48dp (Android)
- [ ] Visual feedback within 100ms of any interaction
- [ ] Animations use transform/opacity only (no layout-bound properties)
- [ ] All animations are interruptible by user input
- [ ] Micro-interactions: 150-300ms duration with ease-out
- [ ] Complex transitions: <=400ms with spring physics preferred
- [ ] Exit animations 60-70% of enter duration
- [ ] Stagger sequences: 30-50ms per item
- [ ] Reduced-motion respected for all motion effects
- [ ] Skeleton/shimmer for loads exceeding 300ms
- [ ] Progressive loading: shell → above-fold → below-fold → background
- [ ] Loading buttons disabled during async operations
- [ ] Platform-standard gestures preserved (swipe-back, pinch-zoom)
- [ ] Visible controls provided for all gesture-only interactions
- [ ] Page transitions maintain spatial continuity (direction + shared elements)
- [ ] No decorative-only animation — every motion has purpose
- [ ] Debounce scroll/resize/input at appropriate thresholds
- [ ] System gestures never blocked (Control Center, app switcher, back)
