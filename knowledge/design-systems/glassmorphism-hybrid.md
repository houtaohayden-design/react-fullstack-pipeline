# Design System C: Glassmorphism Hybrid (玻璃拟态混合)

## Identity
Futuristic, premium, multi-layered depth. Frosted glass panels floating over animated WebGL backgrounds. Combines the structure of a UI kit with the "wow" of creative coding. Every surface catches light and blurs what's behind it.

**Tagline:** "The future feels transparent"

## When to Choose
- Creative portfolios, design agency sites
- Luxury/premium brand experiences
- Tech showcases, product launches
- Music/entertainment platforms
- Any project where visual impact is the #1 priority

## Stack

| Layer | Library | Purpose |
|-------|---------|---------|
| Base UI | animal-island-ui OR shadcn/ui | Structural components (user picks) |
| Glass overlay | react-bits | FluidGlass, GlassSurface |
| WebGL BG | react-bits | Hyperspeed, Particles, MetallicPaint |
| Text FX | react-bits | TrueFocus, VariableProximity, BlurText |
| Cards | react-bits | ReflectiveCard, TiltedCard, SpotlightCard |
| Animation | framer-motion | Page transitions, gesture, scroll-linked |
| Cursor | react-bits | SplashCursor (water ripple effect) |
| State | zustand | Auth, UI state |
| Data | TanStack Query | Server state |
| Routing | react-router v6 | Pages |

## Component Mapping

| UI Element | Library | Component |
|------------|---------|-----------|
| Glass card | react-bits | `GlassSurface` (frosted glass with blur) |
| Fluid glass panel | react-bits | `FluidGlass` (animated fluid gradient + glass) |
| Hero background | react-bits | `Hyperspeed` (Three.js warp tunnel) |
| Ambient particles | react-bits | `Particles` (ogl 3D particle system) |
| Metallic card | react-bits | `MetallicPaint` (WebGL metallic shader) |
| Recipe card | react-bits | `ReflectiveCard` (light-reflective surface) |
| Tilted card | react-bits | `TiltedCard` (3D hover parallax) |
| Mouse highlight | react-bits | `SpotlightCard` (cursor-follow gradient) |
| Text reveal | react-bits | `TrueFocus` (proximity blur/focus) |
| Heading | react-bits | `VariableProximity` (cursor-distance sizing) |
| Paragraph | react-bits | `BlurText` (scroll-in blur reveal) |
| Cursor | react-bits | `SplashCursor` (water ripple on click) |
| Button (base) | animal-island-ui or shadcn | `Button` |
| Modal | react-bits | `GlassSurface` wrapping base Modal |
| Page transition | framer-motion | `AnimatePresence` with scale+blur |
| Scroll reveal | framer-motion | `useScroll` + `useTransform` |
| Toast | sonner | `toast()` |

## Color Palette (Glass-Optimized)

```
Glass surfaces need vibrant backgrounds behind them to pop:

Backgrounds (behind glass):
  Deep Navy:   #0a0e27  (Hyperspeed space)
  Deep Purple: #1a0533  (Particles field)
  Deep Teal:   #0d1f1c  (Aurora night)

Glass Surface:
  Background: rgba(255, 255, 255, 0.05)
  Border:     rgba(255, 255, 255, 0.15)
  Backdrop:   blur(20px) saturate(180%)
  Shadow:     0 8px 32px rgba(0, 0, 0, 0.3)

Text (on glass):
  Primary:   rgba(255, 255, 255, 0.95)
  Secondary: rgba(255, 255, 255, 0.65)
  Accent:    #60a5fa (blue glow)

Light mode (rare for glassmorphism):
  Background: rgba(255, 255, 255, 0.15)
  Border:     rgba(255, 255, 255, 0.3)
  Text:       rgba(0, 0, 0, 0.85)
```

## Typography

**Primary pairing:** Glass Futurism (Clash Display + Satoshi) — bold, geometric, cinematic. Neo-Brutalist Bold (Bebas Neue + Inter) for hero impact statements.

```
Display Font: 'Clash Display', 'Outfit', sans-serif (hero, glass panels)
Heading Font: 'Space Grotesk', system-ui, sans-serif
Body Font:    'Satoshi', 'Inter', system-ui, sans-serif
Mono Font:    'Fira Code', monospace
Impact Font:  'Bebas Neue', 'Anton', sans-serif (hero CTAs only)

Scale: Perfect Fourth (1.333) — dramatic luxury feel
  xs: 0.75rem / sm: 0.875rem / base: 1rem / lg: 1.333rem
  xl: 1.777rem / 2xl: 2.369rem / 3xl: 3.157rem / 4xl: 4.209rem / 5xl: 5.61rem

Weight: 200 extra-light / 300 light / 400 regular / 500 medium / 600 semibold / 700 bold
```

### Typography Patterns
```tsx
// Glass panel heading
<h1 className="font-display text-5xl font-bold tracking-tighter text-white/95">
  Discover Healthy Recipes
</h1>

// Gradient text on glass (hero only)
<h2 className="gradient-text from-blue-400 to-cyan-300 text-4xl font-display">
  Nutrition Meets Artistry
</h2>

// Impact CTA (neo-brutalist)
<span className="font-impact text-6xl tracking-wider uppercase">
  Start Cooking
</span>

// Data on glass (high contrast for readability)
<div className="font-mono tabular-nums text-3xl font-light text-white/90">
  {calories.toLocaleString()}
  <span className="text-sm text-white/40 ml-1">kcal</span>
</div>

// Eyebrow on glass
<span className="text-xs font-medium tracking-[0.2em] uppercase text-white/40">
  Daily Nutrition
</span>
```

## Layout

**Primary layout:** Staggered Asymmetric — alternating left-right blocks with dramatic offset spacing. Creates visual rhythm through irregularity.

**Secondary layout:** Minimal Luxury — glass panels floating in abundant dark space. Single column centered on mobile, asymmetric on desktop.

**Spacing:** Dramatic, maximal. 2:1 content-to-whitespace minimum, often 1:1 for hero sections. Section spacing: clamp(4rem, 8vw, 10rem).

**Measure:** 55ch for glass text panels (tighter, more intimate on glass). 75ch for standard content sections.

**Z-Layers:**
```
z-0: WebGL background (Hyperspeed/Particles)
z-10: Content sections
z-20: Glass panels and cards
z-30: Navigation (sticky)
z-40: Modal overlays
z-50: Custom cursor
```

Reference `knowledge/design-systems/typography-layout.md` for full layout system specs, fluid type scales, and responsive patterns.

## Animation Patterns

### Hyperspeed Hero (Home page)
```tsx
import Hyperspeed from 'react-bits/Backgrounds/Hyperspeed/Hyperspeed';
import GlassSurface from 'react-bits/Components/GlassSurface/GlassSurface';
import VariableProximity from 'react-bits/TextAnimations/VariableProximity/VariableProximity';

function Hero() {
  return (
    <div className="relative h-screen overflow-hidden">
      <Hyperspeed
        effectOptions={{
          onSpeedUp: () => {},
          onSlowDown: () => {}
        }}
        className="absolute inset-0"
      />
      <div className="absolute inset-0 flex items-center justify-center">
        <GlassSurface blur={20} className="p-12 rounded-3xl text-center">
          <VariableProximity
            label="Discover Healthy Recipes"
            className="text-6xl font-bold text-white"
          />
          <p className="mt-4 text-white/60 text-xl">
            Nutrition meets artistry
          </p>
        </GlassSurface>
      </div>
    </div>
  );
}
```

### Glass Recipe Card with Reflective Surface
```tsx
import ReflectiveCard from 'react-bits/Components/ReflectiveCard/ReflectiveCard';

function RecipeCard({ recipe }) {
  return (
    <ReflectiveCard
      className="rounded-2xl overflow-hidden"
      reflectionStrength={0.3}
    >
      <div className="p-6 bg-white/5 backdrop-blur-xl border border-white/10">
        <img
          src={recipe.image}
          alt={recipe.title}
          className="w-full h-48 object-cover rounded-xl mb-4"
        />
        <h3 className="text-xl font-semibold text-white/90">
          {recipe.title}
        </h3>
        <div className="flex gap-3 mt-2 text-white/50 text-sm">
          <span>{recipe.cookTime} min</span>
          <span>{recipe.calories} kcal</span>
        </div>
      </div>
    </ReflectiveCard>
  );
}
```

### Particles Background (Nutrition Dashboard)
```tsx
import Particles from 'react-bits/Backgrounds/Particles/Particles';
import GlassSurface from 'react-bits/Components/GlassSurface/GlassSurface';

function NutritionDashboard() {
  return (
    <div className="relative min-h-screen">
      <Particles
        particleCount={200}
        particleSpread={10}
        speed={0.1}
        particleBaseSize={100}
        className="absolute inset-0"
      />
      <div className="relative z-10 p-8">
        <GlassSurface blur={15} className="p-6 rounded-2xl mb-6">
          <h2>Daily Calories</h2>
          <recharts.BarChart ... />
        </GlassSurface>
      </div>
    </div>
  );
}
```

### Page Transition (blur + scale)
```tsx
function Layout() {
  const location = useLocation();
  return (
    <AnimatePresence mode="wait">
      <motion.main
        key={location.pathname}
        initial={{ opacity: 0, scale: 0.98, filter: 'blur(10px)' }}
        animate={{ opacity: 1, scale: 1, filter: 'blur(0px)' }}
        exit={{ opacity: 0, scale: 1.02, filter: 'blur(10px)' }}
        transition={{ duration: 0.5, ease: [0.16, 1, 0.3, 1] }}
      >
        <Outlet />
      </motion.main>
    </AnimatePresence>
  );
}
```

### SplashCursor (interactive cursor)
```tsx
import SplashCursor from 'react-bits/Animations/SplashCursor/SplashCursor';

function App() {
  return (
    <>
      <SplashCursor
        splashColor="#60a5fa"
        backColor="rgba(96, 165, 250, 0.1)"
      />
      <RouterProvider router={router} />
    </>
  );
}
```

### Scroll-Linked Parallax
```tsx
function ParallaxSection() {
  const ref = useRef(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ['start end', 'end start']
  });
  const y = useTransform(scrollYProgress, [0, 1], ['20%', '-20%']);
  const opacity = useTransform(scrollYProgress, [0, 0.5, 1], [0, 1, 0]);

  return (
    <div ref={ref} className="relative h-96 overflow-hidden">
      <motion.div style={{ y, opacity }} className="absolute inset-0">
        <GlassSurface className="h-full">...</GlassSurface>
      </motion.div>
    </div>
  );
}
```

## Layout Patterns

```
┌────────────────────────────────────────────┐
│  Hyperspeed / Particles (full-bleed BG)     │
│  ┌──────────────────────────────────────┐  │
│  │  GlassSurface Nav                     │  │
│  │  [Logo]      [Links]    [Auth]        │  │
│  └──────────────────────────────────────┘  │
│                                             │
│     ┌─────────────────────────────┐         │
│     │  GlassSurface Hero          │         │
│     │  VariableProximity heading  │         │
│     └─────────────────────────────┘         │
│                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐    │
│  │Reflectiv│  │Reflectiv│  │Reflectiv│    │
│  │  Card   │  │  Card   │  │  Card   │    │
│  └─────────┘  └─────────┘  └─────────┘    │
│                                             │
│  Particles / Hyperspeed continue scrolling  │
└────────────────────────────────────────────┘
```

## Performance Considerations

| Concern | Mitigation |
|---------|------------|
| WebGL on mobile | Detect device, fall back to CSS gradient + blur |
| Hyperspeed GPU | `requestAnimationFrame` throttle, reduce on low-power |
| Multiple blurs | CSS `will-change: filter`, limit active blurs to 3 |
| Particle count | Mobile: 50, Desktop: 200 |
| Bundle size | Lazy-load WebGL components behind `React.lazy()` |

```tsx
// Mobile fallback pattern
const Hyperspeed = lazy(() => import('react-bits/Backgrounds/Hyperspeed/Hyperspeed'));

function Hero() {
  const isMobile = useMediaQuery('(max-width: 768px)');
  if (isMobile) {
    return <div className="bg-gradient-to-br from-deep-navy to-deep-purple">...</div>;
  }
  return (
    <Suspense fallback={<Loading />}>
      <Hyperspeed />
    </Suspense>
  );
}
```

## Bundle Budget

| Layer | Size |
|-------|------|
| Base UI (shadcn or animal-island) | ~40KB |
| framer-motion | ~30KB gzip |
| react-bits WebGL (Hyperspeed) | ~60KB gzip (Three.js + postprocessing) |
| react-bits non-WebGL | ~25KB gzip |
| **Total (with WebGL)** | **~155KB** |
| **Total (no WebGL mobile)** | **~95KB** |

## Key Rules
- Always provide mobile fallbacks for WebGL components
- Don't apply `backdrop-filter: blur()` to more than 3-4 elements simultaneously
- Use `isolation: isolate` on glass container to prevent z-index bleed
- Glass surfaces need vibrant/dark backgrounds — avoid on white pages
- Limit `ReflectiveCard` count per page to ~12 (canvas performance)
- Lazy-load ALL WebGL components: `React.lazy(() => import(...))`
