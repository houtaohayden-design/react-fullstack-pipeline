---
name: react-pipeline:brainstorming
description: Use when building or creating a React application, component, or feature — before any code. Explores requirements, user intent, and design approach.
---

# Brainstorming for React Projects

## Core Principle
Understand WHAT the user wants before thinking about HOW. Batch independent clarifying questions, propose 2-3 technical approaches, write a design document.

## When to Use
- "build a React app/dashboard/website"
- "create a component/feature"
- "add functionality to existing app"
- Any creative work before implementation

## Workflow

### Step 1: Understand Requirements (1-2 rounds)

**Round 1 — Batch independent questions.** All 5 discovery areas are independent (no answer depends on a prior answer). Present them all in a single numbered message:

1. **Core Functionality** — What does the app/component DO? What actions can users take? Primary workflow?
2. **User Personas** — Who uses it? (role, skill level, device: desktop/mobile/both)
3. **Constraints** — Bundle size target? Accessibility (WCAG level)? Browser support? Mobile responsive? Performance goals?
4. **Design Reference** — Figma link, mockup, existing app to emulate, or "build from scratch"?
5. **UI Style** — Choose a premium design system:
   - **A: 动森温馨增强** (Enhanced animal-island-ui) — cozy, warm, playful. react-bits animations + framer-motion transitions over animal-island-ui base. Best for recipe/food, personal blogs, lifestyle.
   - **B: 专业现代** (shadcn/ui Professional) — clean, production-grade, dark mode native, WCAG AA. Radix primitives + Tailwind v4 + framer-motion. Best for SaaS, dashboards, enterprise.
   - **C: 玻璃拟态混合** (Glassmorphism Hybrid) — futuristic, premium, depth-rich. WebGL backgrounds (Hyperspeed/Particles) + frosted glass panels + reflective cards. Best for creative portfolios, luxury brands, tech showcases.

Reference: `knowledge/design-systems/<slug>.md` for full specs. `knowledge/design-systems/typography-layout.md` for 12 font pairings + 8 layout systems. `knowledge/design-systems/artistic-styles.md` (16 styles across 2 batches). `knowledge/design-systems/ui-patterns.md` for 60+ premium interaction patterns. `knowledge/design-systems/text-design.md` for kinetic typography and text effects. `knowledge/design-systems/color-theory.md` for color science + palettes. `knowledge/design-systems/motion-design.md` for animation principles + tokens. `knowledge/design-systems/landing-patterns.md` for page section architecture. `knowledge/design-systems/form-design.md` for premium form patterns. `knowledge/design-systems/background-patterns.md` for CSS backgrounds & textures. `knowledge/design-systems/form-design.md` for premium form patterns. `knowledge/design-systems/data-viz-design.md` for chart styling & dashboards. `knowledge/design-systems/responsive-patterns.md` for responsive strategies. `knowledge/design-systems/navigation-design.md` for navigation patterns. `knowledge/design-systems/empty-states-design.md` for state handling. `knowledge/design-systems/iconography-design.md` for icon systems. `knowledge/design-systems/search-experience.md` for search UX. `knowledge/design-systems/modal-dialog-design.md` for overlays. `knowledge/design-systems/button-design.md` for button systems. `knowledge/design-systems/feedback-patterns.md` for toast & notifications. `knowledge/design-systems/onboarding-patterns.md` for user onboarding.

**Round 2 (only if needed)** — If any answer reveals ambiguity needing clarification, batch ALL remaining follow-ups into one message. Never ask one at a time.

### Step 2: Propose Approach (2-3 options)
Present approaches as recommendations, not decisions. The UI style (from Round 1 question 5) determines the design system; the tech approach determines the stack underneath.

| Approach | Stack | Pros | Cons |
|----------|-------|------|------|
| A: Lightweight | Vite + Tailwind + lightweight libs | Fast, small bundle | Less pre-built |
| B: Full-featured | Next.js + Component library | Rich ecosystem | Larger, more complex |
| C: Enterprise | Shineout + zustand + TanStack Query | Enterprise-ready | Learning curve |

**UI style selection is independent from tech stack.** Any of the 3 premium design systems (动森增强 / shadcn专业 / 玻璃拟态) can layer onto any tech approach. Reference `knowledge/design-systems/` for the full spec of each style.

### Step 3: Check Knowledge Base
**REQUIRED:** Check `knowledge/registry.json` for relevant trained repos BEFORE proposing custom solutions.

```
/ knowledge/registry.json
   check categories matching user's needs
   → recommend trained repos first
   → only suggest untrained libs when gaps exist
```

### Step 4: Write Design Document
Save to `knowledge/specs/<project-name>.md`:
```markdown
# Project: <name>
## Requirements
- Core function:
- Users:
- Constraints:

## Approach: <chosen>
- Stack: <list>
- Design system: <A: 动森增强 / B: shadcn专业 / C: 玻璃拟态>
- Typography: <Editorial Luxury / Swiss Modernist / Glass Futurism / Japanese Warmth>
- Layout: <Editorial Magazine / Swiss Grid / Minimal Luxury / Bento Grid / Staggered Asymmetric>
- Key libraries: <from knowledge base>
- Component tree: <outline>

## Routes (if applicable)
/ → <Page>
  /feature → <SubPage>

## Data Flow
- State: zustand / TanStack Query
- API: <backend>
```

### Step 5: Get Approval
Present the design doc summary. User must approve before moving to `react-pipeline:writing-plans`.

## Next Step
After approval: Set up isolation with `react-pipeline:git-worktrees`, then **REQUIRED SUB-SKILL:** Use `react-pipeline:writing-plans` to create implementation plan.
