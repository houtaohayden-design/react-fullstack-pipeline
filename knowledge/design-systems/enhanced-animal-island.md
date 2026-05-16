# Design System A: Enhanced animal-island-ui (动森温馨增强)

## Identity
Cozy, warm, playful, Nintendo-inspired. The 动森 (Animal Crossing) aesthetic — rounded everything, warm parchment tones, 3D button presses, NookPhone card colors. Enhanced with premium animations while preserving the cozy core.

**Tagline:** "Your cozy corner of the internet"

## When to Choose
- Recipe/food apps, personal blogs, lifestyle content
- Family/kids sites, gaming communities
- Any brand wanting warm, approachable feel
- Content-heavy sites where readability matters

## Stack

| Layer | Library | Purpose |
|-------|---------|---------|
| Base UI | animal-island-ui (18 components) | Cards, Buttons, Modals, Inputs, Tabs |
| Animation | framer-motion (~30KB gzip) | Page transitions, stagger lists, spring physics |
| Visual FX | react-bits (selective, ~30KB added) | BlurText, TiltedCard, Aurora, BlobCursor |
| State | zustand | Auth, UI state |
| Data | TanStack Query | Server state, caching |
| Routing | react-router v6 | Page navigation |

## Component Mapping

| UI Element | Library | Component |
|------------|---------|-----------|
| Primary button | animal-island-ui | `Button` (5 types, 3D press) |
| Card | animal-island-ui | `Card` (13 NookPhone colors) |
| Recipe card (enhanced) | react-bits | `TiltedCard` wrapping animal-island-ui Card |
| Modal | animal-island-ui | `Modal` (SVG blob shape, built-in Typewriter) |
| Text input | animal-island-ui | `Input` |
| Toggle | animal-island-ui | `Switch` |
| Tabs | animal-island-ui | `Tabs` (items prop) |
| Hero heading | react-bits | `BlurText` (per-word blur-in reveal) |
| Hero background | react-bits | `Aurora` (ambient gradient animation) |
| Page transition | framer-motion | `AnimatePresence` + `motion.div` |
| Card list | framer-motion | `motion.div` with `staggerChildren` |
| Custom cursor | react-bits | `BlobCursor` (desktop only) |
| Loading state | animal-island-ui | `Loading` (GSAP island illustration) |
| Toast | sonner | `toast()` |
| Form feedback | framer-motion | `motion.span` spring-in for errors |

## Color Palette

```
Primary:    #19c8b9  薄荷青绿 (mint teal) — buttons, links, active states
Secondary:  #725d42  温暖棕色 (warm brown) — text, headings, borders
Background: #f8f8f0  米白 (cream white) — page background
Card BG:    #fffdf7  暖白 (warm white) — card surfaces
Accent 1:   #f4a261  橘色 (orange) — warnings, highlights
Accent 2:   #e76f51  珊瑚 (coral) — errors, destructive actions
Accent 3:   #2a9d8f  深青 (deep teal) — hover states
```

## Typography

**Primary pairing:** Editorial Luxury (Playfair Display + Inter) for recipe detail pages. Japanese Warmth (Zen Maru Gothic + Noto Sans JP) for Japanese-flavored cozy content.

```
Heading Font: 'Playfair Display', Georgia, serif (recipe titles, hero)
             'Zen Maru Gothic', sans-serif (Japanese cozy variant)
Body Font:    'Inter', system-ui, -apple-system, sans-serif
Mono Font:    'Fira Code', monospace (nutrition data)

Scale: Major Third (1.25) — warm, natural progression
  xs: 0.75rem / sm: 0.875rem / base: 1rem / lg: 1.25rem
  xl: 1.563rem / 2xl: 1.953rem / 3xl: 2.441rem / 4xl: 3.052rem

Weight: 300 light / 400 body / 500 medium / 600 emphasis / 700 bold / 900 hero
```

### Typography Patterns
```tsx
// Recipe title with serif elegance
<h1 className="font-serif text-4xl font-bold tracking-tight leading-tight">
  {recipe.title}
</h1>

// Drop cap for recipe descriptions
<span className="float-left text-7xl font-serif font-bold leading-[0.8] mr-3 mt-1 text-mint">
  {firstChar}
</span>

// Pull quote for chef notes
<blockquote className="border-l-4 border-mint pl-6 my-8 text-xl font-serif italic text-brown/70">
  &ldquo;{chefNote}&rdquo;
</blockquote>

// Stat numbers for nutrition
<span className="stat-number text-mint">{calories}</span>
<span className="stat-label">kcal per serving</span>
```

## Layout

**Primary layout:** Editorial Magazine — full-bleed recipe hero images, pull quotes, drop caps, asymmetric sidebar for ingredient lists.

**Secondary layout:** Minimal Luxury — centered single column for recipe detail, generous whitespace, large serif headings.

**Spacing:** Generous, warm. 2:1 content-to-whitespace ratio. Vertical rhythm at 1.75 leading.

Reference `knowledge/design-systems/typography-layout.md` for full layout system specs, fluid type scales, and responsive patterns.

## Animation Patterns

### Page Transition (all routes)
```tsx
import { AnimatePresence, motion } from 'framer-motion';

function Layout() {
  const location = useLocation();
  return (
    <AnimatePresence mode="wait">
      <motion.main
        key={location.pathname}
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        exit={{ opacity: 0, y: -20 }}
        transition={{ duration: 0.3, ease: 'easeInOut' }}
      >
        <Outlet />
      </motion.main>
    </AnimatePresence>
  );
}
```

### Hero Section (Home page)
```tsx
import BlurText from 'react-bits/TextAnimations/BlurText/BlurText';
import Aurora from 'react-bits/Backgrounds/Aurora/Aurora';

function Hero() {
  return (
    <div className="relative overflow-hidden h-[60vh]">
      <Aurora className="absolute inset-0" />
      <div className="relative z-10 flex flex-col items-center justify-center h-full">
        <BlurText
          text="Discover Healthy Recipes"
          className="text-5xl font-bold text-brown"
          delay={100}
        />
      </div>
    </div>
  );
}
```

### Recipe Card (3D hover)
```tsx
import TiltedCard from 'react-bits/Components/TiltedCard/TiltedCard';

function RecipeCard({ recipe }) {
  return (
    <TiltedCard
      tiltMaxAngleX={5}
      tiltMaxAngleY={5}
      glareEnable={true}
      glareMaxOpacity={0.15}
    >
      <Card color="mint" className="cursor-pointer">
        <img src={recipe.image} alt={recipe.title} />
        <h3>{recipe.title}</h3>
        <span>{recipe.cookTime} min</span>
      </Card>
    </TiltedCard>
  );
}
```

### Stagger List Reveal
```tsx
const container = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: { staggerChildren: 0.1 }
  }
};

const item = {
  hidden: { opacity: 0, y: 20 },
  show: { opacity: 1, y: 0 }
};

function RecipeList({ recipes }) {
  return (
    <motion.div variants={container} initial="hidden" animate="show">
      {recipes.map(recipe => (
        <motion.div key={recipe.id} variants={item}>
          <RecipeCard recipe={recipe} />
        </motion.div>
      ))}
    </motion.div>
  );
}
```

### Custom Cursor (desktop only)
```tsx
import BlobCursor from 'react-bits/Animations/BlobCursor/BlobCursor';

function App() {
  return (
    <>
      <BlobCursor />
      <RouterProvider router={router} />
    </>
  );
}
```

## Layout Patterns

```
┌────────────────────────────────────────────┐
│  Nav: animal-island-ui Nav                  │
│  - Logo (BlurText on hover)                 │
│  - Links + Auth Button (Button variant)     │
├────────────────────────────────────────────┤
│  Hero: Aurora BG + BlurText heading         │
│  (Home page only)                           │
├────────────────────────────────────────────┤
│  Content: Card grid (motion stagger)        │
│  ┌──────┐ ┌──────┐ ┌──────┐               │
│  │Tilted│ │Tilted│ │Tilted│               │
│  │ Card │ │ Card │ │ Card │               │
│  └──────┘ └──────┘ └──────┘               │
├────────────────────────────────────────────┤
│  Footer: animal-island-ui Footer            │
│  - Simple links, copyright                  │
└────────────────────────────────────────────┘
```

## Loading States

```tsx
// Full page loading
import { Loading } from 'animal-island-ui';

// Skeleton card (custom, matches Card dimensions)
function SkeletonCard() {
  return (
    <motion.div
      className="rounded-2xl bg-warm-white animate-pulse"
      initial={{ opacity: 0.5 }}
      animate={{ opacity: 1 }}
      transition={{ repeat: Infinity, duration: 1.5, ease: 'easeInOut' }}
    />
  );
}
```

## Bundle Budget

| Layer | Size |
|-------|------|
| animal-island-ui | ~45KB |
| framer-motion | ~30KB gzip |
| react-bits (selective) | ~30KB gzip |
| Tailwind CSS | ~15KB gzip |
| **Total** | **~120KB** |

## Compatibility
- Full: animal-island-ui, react-bits, framer-motion, Tailwind
- Caution: No dark mode in animal-island-ui (use Card warm colors only)
- Avoid: Mixing with shadcn/ui or Mantine components (style clash)
