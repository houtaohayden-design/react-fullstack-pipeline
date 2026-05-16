---
name: react-pipeline:react-tool
description: Use when writing React UI code — checks knowledge base (26+ trained libraries in 13 categories) before writing custom components.
---

# React Tool — Code with Knowledge Base

## Core Principle
Never write custom code when a trained repository already provides the solution. Check the knowledge base in priority order.

## Knowledge Check Order

```
0. Design system spec (if user selected UI style → knowledge/design-systems/)
1. Trained repos (user's preferred libraries)
2. react-bits (animation/motion/visual effects)
3. animal-island-ui (ONLY when 动森风格 explicitly requested)
4. Custom implementation (only when nothing above fits)
```

## Knowledge Base Structure
`knowledge/registry.json` — index of all trained repos (v2 with categories)
`knowledge/repos/<category>/<slug>/` — api.md + patterns.md

### Categories

| Category | When to Check | Trained Repos |
|----------|--------------|---------------|
| `headless` | Forms, state, tables, drag/drop, accessibility | react-hook-form, zustand, tanstack-table, dnd-kit, downshift, radix-primitives, react-aria |
| `data-fetching` | API calls, caching, mutations | tanstack-query, swr |
| `animation` | Page transitions, gesture, scroll | framer-motion (react-bits for text/background effects) |
| `routing` | URL routing, navigation | react-router |
| `hooks-utilities` | General React hooks | ahooks (85+), react-use (113+), usehooks-ts (33) |
| `ui-libraries` | Styled components | shineout, shadcn-ui, mantine, nextui, sonner, datav-react, beeshell (RN) |
| `state-management` | Global/atomic state | jotai, redux-toolkit |
| `charts` | Data visualization | recharts |
| `guides` | Reference, ecosystem | rn-guide |

## Component Selection Priority

| Priority | Source | When |
|----------|--------|------|
| P0 | Design system (if chosen) | Follow the selected premium design system spec |
| P1 | Trained repos | Any standard UI pattern |
| P2 | react-bits | Animation, motion, text effects, backgrounds |
| P3 | animal-island-ui | ONLY when 动森/Animal Island style explicitly requested |
| P4 | Custom CSS/Tailwind | Layout, spacing, colors not covered above |
| P5 | Custom components | Only when nothing in knowledge base fits |

## Premium Design Systems

When the user has selected a UI style during brainstorming, follow the corresponding design system spec. Each spec defines the full stack — base UI library, animation layer, visual FX, color palette, typography, and code patterns.

**Location:** `knowledge/design-systems/`

| # | Design System | Base UI | Animation | Visual FX | Best For |
|---|--------------|---------|-----------|-----------|----------|
| A | `enhanced-animal-island.md` | animal-island-ui | framer-motion | react-bits (BlurText, TiltedCard, Aurora, BlobCursor) | Recipe/food, personal blogs, lifestyle |
| B | `shadcn-professional.md` | shadcn/ui (Radix) | framer-motion | react-bits (DecryptedText, SpotlightCard, Dock) | SaaS, dashboards, enterprise |
| C | `glassmorphism-hybrid.md` | shadcn or animal-island | framer-motion | react-bits (Hyperspeed, Particles, FluidGlass, ReflectiveCard, SplashCursor) | Creative portfolios, luxury brands, tech |

**Cross-cutting references:**
- `typography-layout.md` — 12 font pairings, 8 layout systems, fluid type scales
- `artistic-styles.md` + `artistic-styles-2.md` — 16 premium visual directions
- `ui-patterns.md` — 60+ UI interaction patterns
- `text-design.md` — Kinetic typography, gradient text, masking, 3D, glitch, typewriter
- `color-theory.md` — Color spaces, harmony rules, palette architecture, dark mode, WCAG contrast
- `motion-design.md` — Animation principles, duration/easing tokens, spring physics, scroll-driven patterns
- `landing-patterns.md` — Hero patterns, feature sections, pricing, CTA, footer, how-it-works
- `form-design.md` — Input anatomy, style variants, validation, multi-step, auto-save
- `background-patterns.md` — CSS patterns, noise, mesh gradients, blobs, animated backgrounds
- `form-design.md` — Input anatomy, style variants, validation, multi-step, auto-save
- `data-viz-design.md` — Chart styling, dashboard layouts, KPI cards, dark mode charts
- `responsive-patterns.md` — Breakpoints, container queries, fluid type, mobile-first, touch/mouse
- `navigation-design.md` — Top nav, sidebar, mega menu, ⌘K palette, breadcrumbs, tabs, dock
- `empty-states-design.md` — Loading skeleton, empty/error/offline states, permission gates
- `iconography-design.md` — Icon sizing, animated icons, favicon, accessibility, bundling
- `search-experience.md` — Search bars, autocomplete, faceted search, filters
- `modal-dialog-design.md` — Modals, dialogs, drawers, sheets, focus traps
- `button-design.md` — Variants, sizes, states, FAB, split button, button group
- `feedback-patterns.md` — Toast, progress, tooltip, popover, copy feedback
- `onboarding-patterns.md` — Welcome screens, tours, coach marks, checklists

### How to Apply a Design System

1. Read the full spec at `knowledge/design-systems/<slug>.md`
2. Install the base UI library and configure theme
3. Use the Component Mapping table — every UI element has a prescribed component
4. Apply animation patterns from the spec (page transitions, card hover, scroll reveals)
5. Follow the color palette and typography exactly
6. Optionally layer an artistic style from `knowledge/design-systems/artistic-styles.md` (8 premium directions)
7. Respect the bundle budget and performance rules

## Workflow

### 1. Understand the Request
What component/feature is needed? What libraries are already in the project?

### 2. Check Knowledge Base
```
/ Read knowledge/registry.json
  Identify relevant categories
  Read api.md for matching repos
  Check patterns.md for integration patterns
```

### 3. Select Libraries
Choose the best-fit library from trained repos. Consider:
- Already installed? (check package.json)
- Bundle size impact
- Style compatibility (Tailwind? CSS modules?)
- Learning curve for the team

### 4. Write Code
```tsx
// Example: Form with validation
// Uses: react-hook-form (headless category)
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
})

function LoginForm() {
  const { register, handleSubmit, formState: { errors } } = useForm({
    resolver: zodResolver(schema)
  })

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email')} />
      {errors.email && <span>{errors.email.message}</span>}
      <input type="password" {...register('password')} />
      <button type="submit">Login</button>
    </form>
  )
}
```

## Key Rules
- Always check knowledge base before writing custom code
- Prefer trained repos over untrained alternatives
- Combine repos following their patterns.md cross-compatibility guides
- framer-motion for page/panel animation, react-bits for text/background effects
- animal-island-ui is opt-in only for 动森 style
