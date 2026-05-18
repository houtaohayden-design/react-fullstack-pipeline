# Impeccable — Interaction & UX Patterns

## Motion Philosophy

### Core Principle: Motion Conveys State, Not Decoration
Every animation must communicate something about the interface state: state change, feedback, loading, or reveal. Motion that exists purely for visual interest is banned. This applies doubly in Product register where users are in flow and don't want choreography.

### Compositor-Friendly Only
Animate only `transform` and `opacity` by default. Premium materials (blur, backdrop-filter, clip-path) are permitted when the effect justifies the cost and remains smooth on target viewports. The hard rule is against casually animating layout-driving properties: `width`, `height`, `top`, `left`, `padding`, `margin`.

For collapsing/expanding sections, transition `grid-template-rows` rather than `height` — it avoids the jank of animated height. FLIP-style transforms are the alternative for reflowing layout without animating layout properties directly.

## Duration Tokens

### The 100/300/500 Rule
Timing matters more than easing for perceived quality:

| Duration | Use Case | Examples |
|----------|----------|----------|
| 100-150ms | Instant feedback | Button press, toggle, color change |
| 200-300ms | State changes | Menu open, tooltip appear, hover transitions |
| 300-500ms | Layout changes | Accordion expand, modal in/out, drawer slide |
| 500-800ms | Entrance animations | Page load, hero reveals, staggered entrances |

**Exit animations are faster than entrances** — use ~75% of enter duration. An element leaving takes less perceived time.

**80ms threshold**: our brains buffer sensory input for ~80ms to synchronize perception. Anything under 80ms feels instant. This is the target for micro-interactions.

### Product Register Duration
150-250ms on most transitions. Users are in flow; don't make them wait for choreography. No orchestrated page-load sequences — product loads into a task.

## Easing Curve Catalog

### Exponential Curves (Recommended Defaults)
Exponential curves mimic real physics (friction, deceleration) and feel natural:

```css
--ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);    /* Snappy, confident (signature) */
--ease-out-quart: cubic-bezier(0.25, 1, 0.5, 1);    /* Smooth, refined (default) */
--ease-out-quint: cubic-bezier(0.22, 1, 0.36, 1);   /* Slightly more dramatic */
```

### Standard Curves
```css
--ease-out: cubic-bezier(0.16, 1, 0.3, 1);          /* Elements entering */
--ease-in: cubic-bezier(0.7, 0, 0.84, 0);           /* Elements leaving */
--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1);      /* State toggles (there and back) */
```

**Never use `ease` (CSS default)** — it's a compromise that's rarely optimal for any specific context.

### Banned Curves
- **Bounce** — real objects don't bounce when they stop; they decelerate smoothly
- **Elastic** — overshoot effects draw attention to the animation itself rather than content
- Both were 2015 trends that now feel tacky and amateurish

### Easing and Perceived Duration
Ease-in toward a task's end compresses perceived time because the peak-end effect weights final moments heavily. Ease-out feels satisfying for entrances. Match the curve to the psychological goal of the interaction.

## Interaction States

### The Eight Interactive States
Every interactive element must have ALL of these designed:

| State | Visual Treatment | Requirement |
|-------|-----------------|------------|
| Default | Base styling at rest | Baseline |
| Hover | Subtle lift (2px), color shift | Pointer users only |
| Focus | Visible ring (2-3px, high contrast, offset) | Keyboard users |
| Active | Pressed in, darker, scale(0.98) | Momentary press |
| Disabled | Reduced opacity, no pointer cursor | Non-interactive signal |
| Loading | Spinner or skeleton, not blank | Feedback during wait |
| Error | Red border, icon, message near source | Validation failure |
| Success | Green check, brief confirmation | Task completion |

**The common miss**: Designing hover without focus. Keyboard users never see hover states — they need focus-visible.

### Focus Ring Design
- Never `outline: none` without replacement (accessibility violation)
- Use `:focus-visible` to show focus only for keyboard users (not mouse/touch)
- High contrast (3:1 minimum against adjacent colors)
- 2-3px thick, offset from element (not inside)
- Consistent across all interactive elements

### Hover State Design
- Subtle lift via `transform: translateY(-2px)` + color shift
- 200ms transition, ease-out
- Never bounce or overshoot
- Hover is for pointer users only — touch devices skip this state

### Touch Targets vs Visual Size
Buttons can look small but need 44px minimum touch targets. Use padding or pseudo-elements to expand tap area without increasing visual size.

## Animation Patterns

### Staggered Animations
Use CSS custom properties for cleaner stagger: `animation-delay: calc(var(--i, 0) * 50ms)` with inline `style="--i: 0"`. Cap total stagger time at 500ms (10 items at 50ms). For many items, reduce per-item delay or cap staggered count.

### Premium Motion Materials
Transform/opacity are reliable defaults, not the whole palette:
- **Blur/filter/backdrop-filter**: focus pulls, depth, glass/lens effects, atmospheric transitions
- **Clip path/masks**: wipes, reveals, editorial cropping, product-like transitions
- **Shadow/glow/color filters**: energy, affordance, focus, warmth, active state
- **Grid-template rows or FLIP transforms**: expanding/reflowing layout without animating height
- Keep expensive effects bounded to small or isolated areas

### Page-Load Orchestration (Brand Only)
One well-orchestrated page-load with staggered reveals beats scattered micro-interactions. Tech-minimal brands often skip entrance motion entirely — restraint IS the voice.

### No Page-Load Orchestration (Product)
Product loads into a task. Users don't want to watch it load. Motion conveys state only.

### Exit Animations
- Elements leaving use `ease-in` (accelerating away)
- Duration = ~75% of enter duration
- Exit animations are functional (clear state), not decorative

## Reduced Motion

### Non-Negotiable Compliance
Vestibular disorders affect ~35% of adults over 40. Every animation needs a reduced-motion alternative.

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

**What to preserve**: functional animations (progress bars, loading spinners slowed down, focus indicators) — just without spatial movement.

## Perceived Performance

Nobody cares how fast a site is, just how fast it feels:
- **Preemptive start**: begin transitions immediately while loading (iOS app zoom, skeleton UI)
- **Early completion**: show content progressively, don't wait for everything
- **Optimistic UI**: update interface immediately, handle failures gracefully. Use for low-stakes actions (likes, follows). Never for payments or destructive operations.
- **Active vs passive time**: passive waiting (spinner staring) feels longer than active engagement
- **Too-fast caution**: instant results for complex operations can decrease perceived value. Brief delay signals "real work".

## Keyboard Navigation

### Roving Tabindex
For component groups (tabs, menu items, radio groups): one item has `tabindex="0"`, others `tabindex="-1"`. Arrow keys move focus within the group. Tab moves to next component. Used for: tabs, menu items, radio groups, list boxes, grid cells.

### Skip Links
`<a href="#main-content">Skip to main content</a>` — hidden off-screen, visible on focus. Required for keyboard users to jump past navigation.

### Modals: The Inert Approach
```html
<main inert>  <!-- content behind modal unfocusable -->
<dialog open>  <!-- native focus trap, closes on Escape -->
```

Or use `dialog.showModal()` for automatic focus trapping and Escape-to-close.

## Overlay Positioning

### Dropdown Anti-Pattern
Dropdowns in `position: absolute` inside `overflow: hidden` containers get clipped. This is the single most common dropdown bug in generated code.

### Solutions
- **CSS Anchor Positioning**: tether overlay to trigger with `anchor-name`/`position-anchor`/`position-area`. Chrome 125+. Falls back gracefully.
- **Popover API + Anchor combo**: places element in top layer (above all z-index/overflow), with focus trap and light dismiss
- **Portal/Teleport**: render at document root with `position: fixed` + manual coordinate calculation from `getBoundingClientRect()`
- **Semantic z-index scale**: dropdown(100) -> sticky(200) -> modal-backdrop(300) -> modal(400) -> toast(500) -> tooltip(600). Never `z-index: 9999`.

## Loading States

### Skeleton Screens > Spinners
Skeleton screens preview content shape and feel faster than generic spinners. They show progress through layout rather than an indeterminate wait.

### Optimistic Updates
Show success immediately, roll back on failure. Used for low-stakes actions. Not for payments or destructive operations.

### Loading Copy
Be specific: "Saving your draft..." not "Loading...". For long waits, set expectations: "This usually takes 30 seconds."

## Gesture Discoverability

Swipe-to-delete and similar gestures are invisible. Requirements: partially reveal action (peeking from edge), coach marks on first use, always provide visible fallback (menu with "Delete"). Never rely on gestures as the only way.

## Destructive Actions

**Undo > Confirm.** Users click through confirmations mindlessly:
1. Remove from UI immediately
2. Show undo toast with countdown
3. Actually delete after toast expires
4. Use confirmation only for: truly irreversible actions (account deletion), high-cost actions, batch operations

## Empty States

Empty states are onboarding moments: (1) acknowledge briefly, (2) explain the value, (3) provide a clear action. "No projects yet. Create your first one to get started." Not just "No items."

## UX Writing Conventions

### Button Labels
- Never: "OK", "Submit", "Yes/No", "Click here"
- Always: specific verb + object ("Save changes", "Create account", "Delete message", "Download PDF")
- Destructive: name the destruction ("Delete 5 items" not "Remove selected")

### Error Messages: The Formula
Answer three questions: (1) What happened? (2) Why? (3) How to fix it?
- "Email address isn't valid. Please include an @ symbol." (not "Invalid input")
- "Please enter a date in MM/DD/YYYY format" (not "You entered an invalid date")
- Never blame the user. Reframe errors as the system's limitation.

### Terminology Consistency
Pick one term, stick with it: Delete (not Delete/Remove/Trash), Settings (not Settings/Preferences/Options), Sign in (not Sign in/Log in/Enter), Create (not Create/Add/New).

### Voice vs Tone
Voice = brand personality (consistent everywhere). Tone = adapts to moment:
- Success: celebratory, brief — "Done! Your changes are live."
- Error: empathetic, helpful — "That didn't work. Here's what to try..."
- Loading: reassuring — "Saving your work..."
- Destructive confirm: serious, clear — "Delete this project? This can't be undone."
- Never use humor for errors. Users are already frustrated.

### No Redundant Copy
If the heading explains it, the intro is redundant. If the button is clear, don't explain it again. Say it once, say it well.

## Translation Readiness
- German +30%, French +20%, Finnish +30-40% longer than English
- Keep numbers separate from strings ("New messages: 3" not "You have 3 new messages")
- Use full sentences as single strings (word order varies by language)
- Avoid abbreviations ("5 minutes ago" not "5 mins ago")
- Give translators context about where strings appear

## Accessibility Patterns
- Never disable zoom (`user-scalable=no`)
- Use `rem`/`em` for font sizes (respects user browser settings)
- Minimum 16px body text, 14px for secondary
- Text links need 44px+ tap targets via padding or line-height
- Link text must have standalone meaning ("View pricing plans" not "Click here")
- Alt text describes information: "Revenue increased 40% in Q4" not "Chart"
- Decorative images: `alt=""`
- Icon buttons need `aria-label`
