# Design System B: shadcn/ui Professional (专业现代)

## Identity
Clean, professional, production-grade. Built on Radix primitives with Tailwind CSS v4. Dark mode native. Accessible by default. The gold standard for modern SaaS and enterprise React applications.

**Tagline:** "Ship quality UI, fast"

## When to Choose
- SaaS dashboards, admin panels, enterprise tools
- Data-heavy applications (tables, forms, charts)
- Multi-tenant platforms needing dark mode
- Teams that value accessibility (WCAG AA)
- Projects where professional credibility matters

## Stack

| Layer | Library | Purpose |
|-------|---------|---------|
| Base UI | shadcn/ui (55 components) | All UI primitives |
| Animation | framer-motion (~30KB gzip) | Page transitions, layout animations, micro-interactions |
| Visual FX | react-bits (selective) | DecryptedText, CloudPulse, Dock, SpotlightCard |
| Forms | react-hook-form + zod | Form validation |
| State | zustand | Auth, UI state |
| Data | TanStack Query | Server state, caching |
| Routing | react-router v6 | Page navigation |
| Charts | recharts | Data visualization |
| Toast | sonner | Notifications |

## Component Mapping

| UI Element | Library | Component |
|------------|---------|-----------|
| Button | shadcn/ui | `Button` (default/destructive/outline/ghost/link, 4 sizes) |
| Card | shadcn/ui | `Card` + `CardHeader` + `CardContent` + `CardFooter` |
| Dialog | shadcn/ui | `Dialog` (built on Radix Dialog) |
| Form | shadcn/ui | `Form` + react-hook-form + zod |
| Input | shadcn/ui | `Input` |
| Table | shadcn/ui | `Table` + tanstack-table for advanced |
| Dropdown | shadcn/ui | `DropdownMenu` |
| Sheet | shadcn/ui | `Sheet` (side drawer) |
| Tabs | shadcn/ui | `Tabs` |
| Command palette | shadcn/ui | `Command` (cmd+k style) |
| Navigation | shadcn/ui | `Sidebar` |
| Hero heading | react-bits | `DecryptedText` (matrix scramble reveal) |
| Dashboard BG | react-bits | `CloudPulse` (subtle animated gradient) |
| Premium cards | react-bits | `SpotlightCard` (mouse-follow highlight) |
| Feature dock | react-bits | `Dock` (macOS-style magnified nav) |
| Page transition | framer-motion | `AnimatePresence` + `motion.div` |
| Layout animation | framer-motion | `layoutId` for shared element transitions |
| Loading | shadcn/ui | `Skeleton` |
| Toast | sonner | `toast()` with `richColors` |
| Charts | recharts | `BarChart`, `LineChart`, `PieChart` |

## Color Palette (CSS Variables)

```css
/* Light mode */
--background: 0 0% 100%;
--foreground: 222.2 84% 4.9%;
--primary: 221.2 83.2% 53.3%;
--primary-foreground: 210 40% 98%;

/* Dark mode */
--background: 222.2 84% 4.9%;
--foreground: 210 40% 98%;
--primary: 217.2 91.2% 59.8%;
--primary-foreground: 222.2 47.4% 11.2%;
```

**Built-in theme generator**: `https://ui.shadcn.com/themes`

## Typography

**Primary pairing:** Swiss Modernist (Space Grotesk + DM Sans) — geometric precision for dashboards and data. Serif Authority (Cormorant Garamond + Lato) for nutrition science content.

```
Heading Font: 'Space Grotesk', system-ui, sans-serif (dashboard, data)
             'Cormorant Garamond', Georgia, serif (science articles)
Body Font:    'DM Sans', 'Inter', system-ui, sans-serif
Mono Font:    'JetBrains Mono', 'Geist Mono', monospace

Scale: Perfect Fourth (1.333) — dramatic, data-focused
  xs: 0.75rem / sm: 0.875rem / base: 1rem / lg: 1.333rem
  xl: 1.777rem / 2xl: 2.369rem / 3xl: 3.157rem / 4xl: 4.209rem

Weight: 300 light / 400 body / 500 medium / 600 semibold / 700 bold
```

### Typography Patterns
```tsx
// Dashboard stat card
<div className="stat-number tabular-nums">{value.toLocaleString()}</div>
<div className="stat-label uppercase tracking-widest">{label}</div>

// Gradient text for hero (CSS variable driven)
<h1 className="gradient-text from-primary to-primary/50">
  Your Nutrition, Visualized
</h1>

// Eyebrow + heading combo
<span className="eyebrow text-muted-foreground">Daily Report</span>
<h2 className="text-2xl font-semibold tracking-tight mt-1">
  Wednesday, May 16
</h2>

// Tabular data alignment
<td className="font-mono tabular-nums text-right">1,850</td>
```

## Layout

**Primary layout:** Bento Grid — rounded cards of varying sizes, Apple-style information architecture. Perfect for dashboard overview and meal plan summary.

**Secondary layout:** Swiss Grid — 12-column strict grid, mathematical precision for data-heavy pages like nutrition tracking.

**Spacing:** Tight but structured. 8px grid baseline. Information-dense but never crowded. Cards use 24px internal padding, 16px gaps.

**Measure:** 85ch for data pages (wider scanning), 65ch for content pages.

Reference `knowledge/design-systems/typography-layout.md` for full layout system specs, fluid type scales, and responsive patterns.

## Animation Patterns

### Page Transition with Layout Animations
```tsx
import { AnimatePresence, motion } from 'framer-motion';

function Layout() {
  const location = useLocation();
  return (
    <AnimatePresence mode="wait">
      <motion.main
        key={location.pathname}
        initial={{ opacity: 0, filter: 'blur(4px)' }}
        animate={{ opacity: 1, filter: 'blur(0px)' }}
        exit={{ opacity: 0, filter: 'blur(4px)' }}
        transition={{ duration: 0.4, ease: [0.22, 1, 0.36, 1] }}
      >
        <Outlet />
      </motion.main>
    </AnimatePresence>
  );
}
```

### Shared Element Transition (list → detail)
```tsx
// RecipeCard in list
<motion.div layoutId={`recipe-${recipe.id}`}>
  <Card>
    <img src={recipe.image} />
  </Card>
</motion.div>

// RecipeDetail page
<motion.div layoutId={`recipe-${recipe.id}`}>
  <img src={recipe.image} className="w-full rounded-lg" />
</motion.div>
```

### Dashboard Stats Animation
```tsx
function StatCard({ label, value }) {
  return (
    <Card>
      <CardHeader>{label}</CardHeader>
      <CardContent>
        <motion.span
          initial={{ opacity: 0, scale: 0.5 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ type: 'spring', stiffness: 200, delay: 0.1 }}
          className="text-3xl font-bold"
        >
          {value}
        </motion.span>
      </CardContent>
    </Card>
  );
}
```

### Hero with DecryptedText
```tsx
import DecryptedText from 'react-bits/TextAnimations/DecryptedText/DecryptedText';
import CloudPulse from 'react-bits/Animations/CloudPulse/CloudPulse';

function Hero() {
  return (
    <div className="relative h-screen flex items-center justify-center bg-background">
      <CloudPulse className="absolute inset-0 opacity-30" />
      <div className="relative z-10 text-center">
        <DecryptedText
          text="Your Nutrition, Visualized"
          speed={30}
          className="text-6xl font-bold tracking-tight"
        />
      </div>
    </div>
  );
}
```

### Spotlight Card (recipe cards)
```tsx
import SpotlightCard from 'react-bits/Components/SpotlightCard/SpotlightCard';

function RecipeCard({ recipe }) {
  return (
    <SpotlightCard className="rounded-xl" spotlightColor="rgba(59, 130, 246, 0.2)">
      <Card className="border-0 shadow-none">
        <CardHeader>
          <img src={recipe.image} alt={recipe.title} className="rounded-lg" />
        </CardHeader>
        <CardContent>
          <h3 className="text-lg font-semibold">{recipe.title}</h3>
          <p className="text-muted-foreground">{recipe.cookTime} min</p>
        </CardContent>
      </Card>
    </SpotlightCard>
  );
}
```

## Layout Patterns

```
┌────────────────────────────────────────────┐
│  Sidebar (collapsible)                      │
│  ┌──────────┐ ┌───────────────────────────┐│
│  │ Nav      │ │  Main Content              ││
│  │ - Logo   │ │                            ││
│  │ - Links  │ │  Cards / Table / Form      ││
│  │ - Theme  │ │                            ││
│  │ - User   │ │                            ││
│  └──────────┘ └───────────────────────────┘│
└────────────────────────────────────────────┘
```

### Dark Mode Toggle
```tsx
import { useTheme } from '@/components/theme-provider';

function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
    >
      <SunIcon className="h-5 w-5 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      <MoonIcon className="absolute h-5 w-5 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
    </Button>
  );
}
```

## Loading Patterns

```tsx
// Skeleton loading (shadcn/ui)
import { Skeleton } from '@/components/ui/skeleton';

function RecipeListSkeleton() {
  return (
    <div className="grid grid-cols-3 gap-4">
      {Array.from({ length: 6 }).map((_, i) => (
        <div key={i} className="space-y-3">
          <Skeleton className="h-48 w-full rounded-xl" />
          <Skeleton className="h-4 w-3/4" />
          <Skeleton className="h-4 w-1/2" />
        </div>
      ))}
    </div>
  );
}
```

## Bundle Budget

| Layer | Size |
|-------|------|
| shadcn/ui components | ~20KB gzip (per-component copy, only what's used) |
| Radix primitives | ~35KB gzip |
| framer-motion | ~30KB gzip |
| react-bits (selective) | ~25KB gzip |
| Tailwind CSS v4 | ~10KB gzip |
| **Total** | **~120KB** |

## Key Rules
- Copy-paste components from shadcn/ui — never `npm install` the whole library
- Use `cn()` utility for className merging
- Theme via CSS variables in `globals.css` — use shadcn theme generator
- Dark mode: `class` strategy (Tailwind `dark:` prefix)
- All components WCAG AA accessible out of the box (Radix primitives)
