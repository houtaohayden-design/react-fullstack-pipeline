---
name: react-pipeline:react-tool
description: Use when writing React UI code — checks knowledge base (26+ trained libraries in 13 categories) before writing custom components.
---

# React Tool — Code with Knowledge Base

## Core Principle
Never write custom code when a trained repository already provides the solution. Check the knowledge base in priority order.

## Knowledge Check Order

```
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
| P0 | Trained repos | Any standard UI pattern |
| P1 | react-bits | Animation, motion, text effects, backgrounds |
| P2 | animal-island-ui | ONLY when 动森/Animal Island style explicitly requested |
| P3 | Custom CSS/Tailwind | Layout, spacing, colors not covered above |
| P4 | Custom components | Only when nothing in knowledge base fits |

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
