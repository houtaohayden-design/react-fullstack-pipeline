# Interaction Quality Standards — taste-skill

## Motion Philosophy: The Tasteful vs. Tacky Divide

Taste-skill establishes a clear quality bar for animation and interaction: **motion must feel like real-world physics, not default CSS**. The framework distinguishes four categories of motion quality:

1. **Tacky:** Linear easing, instant state changes, no transition at all, overuse of neon glow effects on hover, auto-rotating carousels
2. **Functional:** Basic CSS transitions with `ease-in-out`, hover color shifts only, simple fade-ins
3. **Fluid:** Custom cubic-beziers, staggered reveals, GPU-compositable properties only, spring physics for interactive elements
4. **Cinematic:** Scroll-triggered reveals, parallax, physics-based interactions (magnetic buttons), perpetual infinite-loop micro-animations, scroll-linked video/3D sequences

The skill's default baseline targets levels 3-4, with the MOTION_INTENSITY dial controlling the ceiling.

## Motion Intensity Scale

### Level 1-3: Static
- No automatic animations
- CSS `:hover` and `:active` states only
- No scroll animations
- No animated load-ins
- **Use case:** Data-heavy dashboards, accessibility-first apps, high-density tools

### Level 4-7: Fluid CSS
- Default transition: `transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1)`
- Staggered load-in cascades: `animation-delay: calc(var(--index) * 100ms)`
- Animate exclusively `transform` and `opacity`
- Use `will-change: transform` sparingly
- Hover states with smooth scale (`group-hover:scale-105`, 700ms duration)
- Entry animations: `translateY(12px)` + `opacity: 0` resolving over 600-800ms
- **Critical:** Never use `window.addEventListener('scroll')` — use IntersectionObserver or Framer Motion's `whileInView`

### Level 8-10: Advanced Choreography
- Complex scroll-triggered reveals using GSAP ScrollTrigger or Framer Motion
- Parallax scroll effects
- Scroll-linked animation (framerate tied to scrollbar for video/3D sequences)
- Advanced Framer Motion hooks (`useScroll`, `useTransform`, `useSpring`)
- GSAP pinning, stacking, and scrubbing
- Scroll progress SVG path drawing
- Liquid wipe page transitions
- **Division of labor:** Framer Motion for UI/bento interactions; GSAP/ThreeJS for isolated full-page scrolltelling or canvas backgrounds. Never mix in same component tree.

## Spring Physics: The Signature Motion Feel

The framework mandates spring physics as the default easing for all interactive elements:

```
type: "spring"
stiffness: 100
damping: 20
```

This combination produces a **premium, weighty feel** — responsive but not snappy, smooth but not floaty. The specific 100/20 ratio is calibrated to feel "expensive" rather than "bouncy."

**Spring physics are required for:**
- All button and card hover/active states
- Modal open/close transitions
- Dropdown/select menu expand/collapse
- Navigation reveal animations
- Badge/notification appearance ("Overshoot" effect)
- Toast/snackbar entrance and exit

## Custom Easing Curves

For transitions where spring physics aren't practical (CSS-only motion), the framework specifies:

- **Default fluid:** `cubic-bezier(0.16, 1, 0.3, 1)` — premium deceleration with no bounce
- **Agency-level (soft-skill):** `cubic-bezier(0.32, 0.72, 0, 1)` — heavier, more deliberate feel
- **Duration:** 700ms for significant transitions (hover scale), 300ms for micro state changes, 600-800ms for scroll entry reveals

## Mandatory Interaction States

The framework treats missing interaction states as a **hard design failure**. Every interactive component must implement:

### Hover State
- Background shift (color or opacity change)
- Slight scale or translate
- For cards: ultra-subtle shadow lift (`box-shadow` from `0 0 0` to `0 2px 8px rgba(0,0,0,0.04)`)
- For buttons: directional fill entering from cursor side (Directional Hover Aware)
- For images: `group-hover:scale-105` inside `overflow-hidden` containers

### Active/Pressed State
- Physical press simulation: `scale(0.98)` or `translateY(1px)`
- For buttons: "Button-in-Button" — nested icon circle translates diagonally (`group-hover:translate-x-1 group-hover:-translate-y-[1px]`) and scales up (`scale-105`)
- **Critical:** This tactile feedback is non-negotiable — it simulates a physical push confirming action

### Focus State
- Visible focus ring for keyboard navigation (accessibility requirement)
- Focus ring in accent color
- Never remove `:focus-visible` outlines without providing a custom replacement

### Loading State
- Skeleton loaders matching exact layout dimensions (not generic circles)
- Skeleton shimmer effect: shifting light reflections across placeholder boxes
- For async operations: progressive loading transitions

### Empty State
- Beautifully composed "getting started" views
- Clear indication of how to populate data
- Not just "No data" text — illustrated, composed compositions

### Error State
- Clear, inline error messages (especially for forms)
- Never use `window.alert()`
- Direct language: "Connection failed. Please try again." — not "Oops!"
- No exclamation marks

## Perpetual Micro-Interactions

When MOTION_INTENSITY exceeds 5, the framework requires **continuous infinite micro-animations** embedded in standard components. These make the interface feel "alive" rather than static:

| Animation | Use Case | Implementation |
|-----------|----------|----------------|
| **Pulse** | Status indicators, notification badges | Opacity loop: 1.0 -> 0.5 -> 1.0 |
| **Typewriter** | Search bars, command inputs | Cycling through prompts with blinking cursor and shimmer gradient |
| **Float** | Avatars, icons, decorative elements | Gentle Y-axis oscillation (3-5px) |
| **Shimmer** | Loading skeletons, processing states | Diagonal gradient light sweep |
| **Carousel** | Data metrics, partner logos, content cards | Seamless infinite horizontal scroll (`x: ["0%", "-100%"]`) |
| **Breathing** | Live status indicators, connectivity dots | Scale loop: 1.0 -> 1.05 -> 1.0 with spring easing |

**Performance critical rule:** Every perpetual motion or infinite loop MUST be memoized (`React.memo`) and completely isolated in its own microscopic Client Component. Never trigger re-renders in the parent layout.

## Staggered Orchestration

The framework strictly forbids mounting lists or grids instantly. All multi-element content must use staggered reveals:

```
Animation delay per child = calc(var(--index) * 100ms)
```

For Framer Motion:
- Parent defines `staggerChildren` in its `variants`
- Children reside in the identical Client Component tree as the Parent
- If data is fetched asynchronously, pass data as props into a centralized Parent Motion wrapper
- Use `<AnimatePresence>` wrapper for dynamic lists

**Minimum stagger values:**
- Dense lists (6+ items): 50ms per item
- Feature cards (3-4 items): 100ms per item
- Navigation links: 150ms per item
- Major sections: 200ms per section

## Specific Interaction Patterns

### Magnetic Button Hover
Buttons pull slightly toward the mouse cursor, creating a physical attraction effect:
- Use Framer Motion's `useMotionValue` and `useTransform` (NEVER `useState`)
- Operates outside React render cycle for 60fps performance
- Applied when MOTION_INTENSITY > 5
- Combine with active press: `scale(0.98)` on click

### The Fluid Island Navigation
A signature navigation pattern for premium designs:
1. **Closed state:** Navbar is a floating glass pill detached from top (`mt-6`, `mx-auto`, `w-max`, `rounded-full`)
2. **Hamburger morph:** 2-3 lines fluidly rotate and translate to form a perfect 'X' (`rotate-45` and `-rotate-45`)
3. **Modal expansion:** Opens as massive screen-filling overlay with heavy glass effect (`backdrop-blur-3xl bg-black/80`)
4. **Staggered reveal:** Links inside fade in and slide up (`translate-y-12 opacity-0` to `translate-y-0 opacity-100`) with staggered delays (100ms, 150ms, 200ms)

### The Button-in-Button Trailing Icon
For CTA buttons with arrows (`arrow-right`):
- Icon NEVER sits naked next to the text
- It lives inside its own distinct circular wrapper (`w-8 h-8 rounded-full bg-black/5 dark:bg-white/10`)
- Wrapper is flush with the main button's right inner padding
- On hover: icon circle translates diagonally (`group-hover:translate-x-1 group-hover:-translate-y-[1px]`) and scales up (`scale-105`)

### The Hamburger Morph
- 2 or 3 lines of the hamburger icon fluidly rotate and translate to form a perfect 'X'
- Not simply disappearing — transforming through intermediate states
- Uses `rotate-45` and `-rotate-45` with absolute positioning
- Transition: 300ms with spring physics

### Scroll Entry Animations
All major content blocks must animate on viewport entry:
- **Default:** `translateY(16px) blur-md opacity-0` resolving to `translateY(0) blur-0 opacity-100` over 600-800ms
- **Minimalist variant:** `translateY(12px) opacity-0` over 600ms with `cubic-bezier(0.16, 1, 0.3, 1)`
- **Agency variant (soft-skill):** Heavy fade-up with blur over 800ms+
- Implementation: IntersectionObserver or Framer Motion `whileInView`
- **Never:** `window.addEventListener('scroll')` — causes continuous reflows

### Directional Hover Aware Button
Button fill/background enters from the exact side the mouse entered:
- Track cursor entry direction (top/bottom/left/right)
- Animate background fill originating from that side
- Creates a "chasing the cursor" effect that feels intelligent

### Ripple Click Effect
Visual waves rippling precisely from the click coordinates:
- Calculate click position relative to element
- Animate expanding circle from click origin
- Fade out over 400ms
- Applied to cards, buttons, and interactive surfaces

### Morphing Modal
A button that seamlessly expands into its own full-screen dialog:
- Uses Framer Motion's shared `layoutId` for the morph
- Button scales and rounds into modal container
- Content fades in after morph completes
- Close reverses the animation

### Sticky Scroll Stack
Cards that stick to the top and physically stack over each other:
- Each card section pins during scroll (`position: sticky`)
- Next card slides over/under previous card
- Creates a satisfying physical card-stacking metaphor
- Implementation: GSAP ScrollTrigger with pin or CSS `position: sticky`

### Horizontal Scroll Hijack
Vertical scroll translates into smooth horizontal gallery pan:
- Mouse wheel/scroll drives horizontal movement
- Smooth interpolation with inertia
- Visual indicators show horizontal progress
- **Critical:** Always test on mobile — provide fallback to standard vertical

## Scroll-Driven Animation Catalog

The framework defines these scroll-triggered animation paradigms (for MOTION_INTENSITY 8-10):

| Technique | Description | Implementation |
|-----------|-------------|----------------|
| **GSAP Split** | Pin section title on left while gallery scrolls upwards on right | `ScrollTrigger pin: true` |
| **Image Scale & Fade** | Images start small (scale 0.8), grow to 1.0, then fade/darken on exit | `scale` and `opacity` tied to scroll progress |
| **Scrubbing Text Reveals** | Paragraph words start at opacity 0.1, scrub to 1.0 sequentially | Word-by-word opacity driven by scroll position |
| **Card Stacking** | Cards overlap and stack dynamically from bottom as user scrolls | Z-index changes and translateY transforms |
| **Curtain Reveal** | Hero section parts in the middle like a curtain on scroll | Split panel translation |
| **Split Screen Scroll** | Two screen halves sliding in opposite directions | Left half up, right half down (or vice versa) |
| **Zoom Parallax** | Central background image zooms in/out seamlessly with scroll | Scale transform tied to scroll |
| **Scroll Progress Path** | SVG vector lines draw themselves as user scrolls | `stroke-dashoffset` animation |

## Animation Performance Guardrails

### GPU-Safe Animation Properties
**Animate ONLY:**
- `transform` (translate, scale, rotate, skew)
- `opacity`
- `clip-path` (sparingly)
- `filter` (sparingly on fixed elements only)

**NEVER animate:**
- `top`, `left`, `right`, `bottom`
- `width`, `height`
- `margin`, `padding`
- `border-width`
- `font-size`

### Blur and Filter Constraints
- `backdrop-blur` ONLY on fixed or sticky elements (navbars, overlays)
- NEVER on scrolling containers or large content areas — causes continuous GPU repaints and severe mobile frame drops
- Grain/noise filters ONLY on fixed, `pointer-events-none` pseudo-elements (`position: fixed; inset: 0; z-index: 50`)
- NEVER attach noise to scrolling containers
- `will-change: transform` used sparingly and ONLY on elements actively animating

### Z-Index Discipline
- NEVER spam arbitrary `z-50`, `z-10`, or `z-[9999]` unprompted
- Reserve z-indexes strictly for systemic layer contexts:
  - Sticky navbars
  - Modals and dialogs
  - Overlays and backdrops
  - Tooltips and popovers
  - Toast notifications
- Establish a clean z-index scale in the theme/variables

### Isolation Rule for CPU-Heavy Animations
- Perpetual motion or infinite animation loops MUST be wrapped in `React.memo`
- Isolated in their own microscopic Client Component
- Never trigger re-renders in the parent layout
- Strict cleanup in `useEffect` return functions

## Accessibility as Design Quality

The framework treats accessibility as a design quality metric, not a compliance checkbox:

- **Reduced motion:** Honor `prefers-reduced-motion` media query — disable all perpetual animations and reduce all motion
- **Focus visible:** Every interactive element must have a visible focus indicator for keyboard navigation
- **Skip to content:** Hidden skip-link as first focusable element on every page
- **Semantic HTML:** Use `<nav>`, `<main>`, `<article>`, `<aside>`, `<section>` — never div-only
- **Alt text:** Descriptive on meaningful images, empty on decorative
- **Color contrast:** WCAG AA minimum for all text
- **Touch targets:** Minimum 44px tap target for all interactive elements
- **Custom cursors banned:** They ruin accessibility and performance — never use them

## Responsive Interaction Quality

- **Mobile collapse (< 768px):** All multi-column layouts collapse to single column. No exceptions.
- **No horizontal scroll:** Horizontal overflow on mobile is a critical failure. Wrap page in `<main className="overflow-x-hidden w-full max-w-full">`.
- **Typography scaling:** Headlines scale via `clamp()`. Body text minimum 1rem/14px.
- **Touch vs mouse:** Active states replace hover states on touch devices. No hover-dependent UI.
- **Safe areas:** Account for iOS notch/home indicator safe areas.
- **Asymmetric layout override:** Any asymmetric layout above `md:` MUST fall back to strict single-column layout (`w-full`, `px-4`, `py-8`) below 768px to prevent horizontal scrolling and layout breakage.
- **Rotations removed on mobile:** Remove all element rotations and negative-margin overlaps below 768px. Stack vertically with standard spacing.
- **`h-screen` replaced:** Never use `h-screen` for full-height sections — always `min-h-[100dvh]` to prevent iOS Safari viewport jumping.
