# Motion Design — Animation Principles & Token System

Animation as a design tool, not decoration. Principles, tokens, and reusable motion patterns for premium UI.

---

## 1. Disney's 12 Principles → UI Animation

| # | Principle | UI Application | Example |
|---|-----------|----------------|---------|
| 1 | **Squash & Stretch** | Button press, card expansion | Scale(0.96) on click |
| 2 | **Anticipation** | Hover pre-states, pull-to-refresh tension | Button lifts 2px before clicking |
| 3 | **Staging** | Modal entrance, page transitions | Darken backdrop before modal appears |
| 4 | **Straight Ahead / Pose to Pose** | Scroll-triggered animations (pose-to-pose) | Sections animate on scroll enter |
| 5 | **Follow Through** | Overshoot on counter, list reorder | Count animates past target then back |
| 6 | **Slow In & Slow Out** | Easing curves, natural motion | CSS `ease-in-out`, custom bezier |
| 7 | **Arcs** | Circular reveal, radial menu open | Circular clip-path expansion |
| 8 | **Secondary Action** | Like button particles + scale | Heart scales + sparkles fly out |
| 9 | **Timing** | Duration tokens, rhythm | Fast for micro, slow for page transitions |
| 10 | **Exaggeration** | Empty state illustrations, onboarding | Oversized icon with gentle float |
| 11 | **Solid Drawing** | 3D card tilt, perspective transforms | Cards that follow cursor in 3D |
| 12 | **Appeal** | Brand personality through motion | Bouncy for kids, smooth for luxury |

---

## 2. Animation Duration Tokens

```css
:root {
  /* === Duration Tokens === */
  --duration-instant:   100ms;   /* micro: button press, toggle, checkbox */
  --duration-fast:      200ms;   /* hover reveal, tooltip, dropdown */
  --duration-normal:    300ms;   /* modal, fade, standard transition */
  --duration-slow:      500ms;   /* page transition, drawer slide */
  --duration-dramatic:  800ms;   /* hero animation, splash screen */
  --duration-epic:      1200ms;  /* brand story, onboarding flow */

  /* === Stagger Tokens === */
  --stagger-char:       30ms;    /* per character reveal */
  --stagger-word:       80ms;    /* per word reveal */
  --stagger-item:       100ms;   /* list item, card grid */
  --stagger-section:    150ms;   /* page section reveal */
}
```

### Duration Decision Tree
```
Is the animation interactive (triggered by user)?
  YES → duration-fast (100-200ms). User is waiting.
  NO → duration-normal (300-500ms). User is watching.

How large is the animated area?
  Small (< 100px) → 100-200ms
  Medium (100-500px) → 200-400ms
  Large (> 500px) → 400-800ms
  Full page → 500-1200ms

Is it purely decorative?
  YES → can be slower, user isn't waiting
  NO → must be faster, animation serves a functional purpose
```

---

## 3. Easing Curve Catalog

### Standard CSS Easings — When to Use Each
```css
/* DEFAULT: Best all-purpose ease */
--ease-default: cubic-bezier(0.4, 0, 0.2, 1);  /* Material Design standard */

/* ENTRANCE: Decelerate (start fast, end slow) — elements appearing */
--ease-out: cubic-bezier(0, 0, 0.2, 1);         /* modal, toast, tooltip enter */
--ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1); /* dramatic reveal, hero text */

/* EXIT: Accelerate (start slow, end fast) — elements disappearing */
--ease-in: cubic-bezier(0.4, 0, 1, 1);          /* modal exit, drawer close */
--ease-in-expo: cubic-bezier(0.7, 0, 0.84, 0);  /* rapid dismissal */

/* EMPHASIS: Overshoot — attention-grabbing */
--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);    /* button pop, badge appear */
--ease-elastic: cubic-bezier(0.68, -0.6, 0.32, 1.6); /* extreme bounce */

/* NATURAL: Asymmetric — organic motion */
--ease-natural: cubic-bezier(0.22, 1, 0.36, 1);      /* scroll reveal, stagger */

/* SMOOTH: Symmetric — looping animations */
--ease-smooth: cubic-bezier(0.45, 0, 0.55, 1);       /* pulse, shimmer, marquee */
```

### Custom Bezier Curves Visualized
```
ease-out (decelerate):   ████████████████▌▌▌▌▌▌       Starts fast, ends slow
ease-in (accelerate):    ▌▌▌▌▌████████████████████       Starts slow, ends fast
ease-spring (overshoot): ██████████████████████▌▌       Goes past, bounces back
ease-natural:            ████████████████▌▌▌            Asymmetric, feels organic
```

---

## 4. Spring Physics Recipes (Framer Motion)

```tsx
// Bouncy spring — buttons, toggles, badges
const springBouncy = { type: 'spring', stiffness: 500, damping: 25 };

// Gentle spring — cards, modals, panels
const springGentle = { type: 'spring', stiffness: 300, damping: 30 };

// Snappy spring — dropdowns, tooltips (no visible bounce)
const springSnappy = { type: 'spring', stiffness: 400, damping: 35 };

// Smooth spring — page transitions, large elements
const springSmooth = { type: 'spring', stiffness: 200, damping: 25 };

// Heavy spring — draggable elements, bottom sheets
const springHeavy = { type: 'spring', stiffness: 150, damping: 20 };
```

### Spring Decision Table
| Use Case | stiffness | damping | mass | Feel |
|----------|-----------|---------|------|------|
| Button press | 500 | 25 | 0.5 | Bouncy, responsive |
| Modal | 300 | 30 | 1 | Smooth, professional |
| Dropdown | 400 | 35 | 0.5 | Snappy, no overshoot |
| Page transition | 200 | 25 | 1 | Smooth, cinematic |
| Drawer/sheet | 150 | 20 | 1.5 | Heavy, draggable |
| Toast/snackbar | 400 | 30 | 0.5 | Quick, noticeable |
| List reorder | 350 | 25 | 0.5 | Natural feel |
| Card hover | 400 | 25 | 0.5 | Responsive lift |

---

## 5. Scroll-Driven Animation Patterns

### Parallax Depth
```tsx
function ParallaxSection({ speed = 0.5 }: { speed?: number }) {
  const ref = useRef(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ['start end', 'end start'],
  });
  const y = useTransform(scrollYProgress, [0, 1], ['-20%', '20%']);

  return (
    <div ref={ref} className="relative overflow-hidden">
      <motion.div style={{ y }} className="absolute inset-0">
        <img src="/bg.jpg" className="w-full h-full object-cover scale-125" />
      </motion.div>
      <div className="relative z-10">{/* content */}</div>
    </div>
  );
}
```

### Scroll-Triggered Reveal
```tsx
function ScrollReveal({ children }: { children: React.ReactNode }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 40 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: '-80px' }}
      transition={{ duration: 0.6, ease: [0.22, 1, 0.36, 1] }}
    >
      {children}
    </motion.div>
  );
}
```

### Progress-Linked Animation (scrub)
```tsx
function ScrubAnimation() {
  const { scrollYProgress } = useScroll();
  const scale = useTransform(scrollYProgress, [0, 1], [0.8, 1]);
  const opacity = useTransform(scrollYProgress, [0, 0.5, 1], [0, 1, 1]);
  const rotate = useTransform(scrollYProgress, [0, 1], [5, 0]);

  return (
    <motion.div style={{ scale, opacity, rotate }}>
      Scrub-linked content
    </motion.div>
  );
}
```

### Sticky Scroll Sections
```tsx
function StickyScrollSection() {
  const ref = useRef(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ['start start', 'end end'],
  });

  return (
    <section ref={ref} className="relative h-[300vh]">
      <div className="sticky top-0 h-screen flex items-center justify-center">
        {/* Content changes as user scrolls */}
        <motion.div style={{ opacity: useTransform(scrollYProgress, [0, 0.3, 0.6, 1], [1, 0, 0, 0]) }}>
          Panel 1
        </motion.div>
        <motion.div style={{ opacity: useTransform(scrollYProgress, [0, 0.3, 0.6, 1], [0, 1, 0, 0]) }}>
          Panel 2
        </motion.div>
        <motion.div style={{ opacity: useTransform(scrollYProgress, [0, 0.3, 0.6, 1], [0, 0, 1, 0]) }}>
          Panel 3
        </motion.div>
      </div>
    </section>
  );
}
```

---

## 6. Gesture Design

### Swipe (Tinder-style cards)
```tsx
function SwipeableCard({ onSwipe }: { onSwipe: (direction: 'left' | 'right') => void }) {
  const x = useMotionValue(0);
  const rotate = useTransform(x, [-200, 0, 200], [-30, 0, 30]);
  const opacity = useTransform(x, [-200, -100, 0, 100, 200], [0, 0.5, 1, 0.5, 0]);

  const handleDragEnd = () => {
    const xValue = x.get();
    if (xValue > 100) onSwipe('right');
    else if (xValue < -100) onSwipe('left');
  };

  return (
    <motion.div
      drag="x"
      dragConstraints={{ left: 0, right: 0 }}
      style={{ x, rotate, opacity }}
      onDragEnd={handleDragEnd}
      whileTap={{ scale: 1.05 }}
      className="cursor-grab active:cursor-grabbing"
    />
  );
}
```

### Pull-to-Refresh
```tsx
function PullToRefresh({ onRefresh }: { onRefresh: () => Promise<void> }) {
  const y = useMotionValue(0);
  const [refreshing, setRefreshing] = useState(false);

  return (
    <motion.div
      drag="y"
      dragConstraints={{ top: 0, bottom: 120 }}
      dragElastic={0.2}
      style={{ y }}
      onDragEnd={async () => {
        if (y.get() > 80) {
          setRefreshing(true);
          await onRefresh();
          setRefreshing(false);
        }
      }}
    >
      <motion.div
        style={{ y: useTransform(y, [0, 80], [-40, 0]), opacity: useTransform(y, [0, 80], [0, 1]) }}
        className="flex justify-center"
      >
        {refreshing ? 'Refreshing...' : 'Pull to refresh'}
      </motion.div>
      {/* list content */}
    </motion.div>
  );
}
```

---

## 7. Reduced Motion

```css
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

```tsx
function useReducedMotion(): boolean {
  const [reduced, setReduced] = useState(false);

  useEffect(() => {
    const mq = window.matchMedia('(prefers-reduced-motion: reduce)');
    setReduced(mq.matches);
    const handler = (e: MediaQueryListEvent) => setReduced(e.matches);
    mq.addEventListener('change', handler);
    return () => mq.removeEventListener('change', handler);
  }, []);

  return reduced;
}

// Usage
function AnimatedComponent() {
  const reducedMotion = useReducedMotion();

  return (
    <motion.div
      animate={reducedMotion ? { opacity: 1 } : { opacity: 1, y: 0 }}
      initial={reducedMotion ? { opacity: 1 } : { opacity: 0, y: 20 }}
      transition={reducedMotion ? { duration: 0 } : { duration: 0.5 }}
    />
  );
}
```

---

## 8. Animation Quality Tiers

### Tier 1: Performance-Critical (60fps always)
```css
/* Only animate transform + opacity — GPU composited, no layout/paint */
.anim-perf {
  will-change: transform, opacity;
  transform: translateZ(0); /* force GPU layer */
}
```

### Tier 2: Visual Quality (occasional repaint OK)
```css
/* Animate filter, background-color — triggers paint, not layout */
.anim-visual {
  will-change: filter, background-color;
  transition: filter 0.3s ease, background-color 0.3s ease;
}
```

### Tier 3: Cinematic (expensive — use sparingly)
```css
/* Animate clip-path, mask, height — triggers layout */
.anim-cinematic {
  will-change: clip-path;
}

/* Avoid at all costs: width, height, top, left, margin, padding animation */
```

### The Golden Rule
```
If it animates, animate: transform + opacity (GPU-only, zero repaint)
If it must animate something else: accept the performance cost knowingly
```

---

## 9. Timing Function Visual Reference

```
linear:                      ────────────────  (robotic, never use for UI)
ease:                        ───▄▄▄▄▄▄▄▄▄▄▄▄▄  (CSS default, decent)
ease-in:                     ───▄▄▄▄▄████████  (good for exits)
ease-out:                    ████████▄▄▄▄▄▄───  (good for entrances)
ease-in-out:                 ──▄▄████████▄▄───  (good for looping)
cubic-bezier(0.34,1.56,0.64,1): ████████▌▌██  (spring overshoot)
cubic-bezier(0.22,1,0.36,1):   ██████▌▌▌▌▌    (natural, no overshoot)
steps(4, end):               ▐▌▐▌▐▌▐▌           (typewriter, sprite animation)
```

---

## 10. Motion Tokens — Complete CSS Variables

```css
:root {
  /* Duration */
  --motion-instant: 100ms;
  --motion-fast:    200ms;
  --motion-normal:  300ms;
  --motion-slow:    500ms;
  --motion-epic:    800ms;

  /* Easing */
  --ease-out:    cubic-bezier(0, 0, 0.2, 1);
  --ease-in:     cubic-bezier(0.4, 0, 1, 1);
  --ease-default:cubic-bezier(0.4, 0, 0.2, 1);
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);
  --ease-natural:cubic-bezier(0.22, 1, 0.36, 1);

  /* Stagger */
  --stagger-char:  30ms;
  --stagger-word:  80ms;
  --stagger-card: 100ms;

  /* Distance */
  --move-micro:  4px;
  --move-small:  8px;
  --move-medium: 16px;
  --move-large:  32px;
  --move-hero:   64px;
}

/* Usage */
.card-enter {
  animation: cardIn var(--motion-normal) var(--ease-out) both;
}
@keyframes cardIn {
  from {
    opacity: 0;
    transform: translateY(var(--move-medium)) scale(0.97);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}
```
