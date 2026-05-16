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

**Round 1 — Batch independent questions.** All 4 discovery areas are independent (no answer depends on a prior answer). Present them all in a single numbered message:

1. **Core Functionality** — What does the app/component DO? What actions can users take? Primary workflow?
2. **User Personas** — Who uses it? (role, skill level, device: desktop/mobile/both)
3. **Constraints** — Bundle size target? Accessibility (WCAG level)? Browser support? Mobile responsive? Performance goals?
4. **Design Reference** — Figma link, mockup, existing app to emulate, or "build from scratch"?

**Round 2 (only if needed)** — If any answer reveals ambiguity needing clarification, batch ALL remaining follow-ups into one message. Never ask one at a time.

### Step 2: Propose Approach (2-3 options)
Present approaches as recommendations, not decisions:

| Approach | Stack | Pros | Cons |
|----------|-------|------|------|
| A: Lightweight | Vite + Tailwind + lightweight libs | Fast, small bundle | Less pre-built |
| B: Full-featured | Next.js + Component library | Rich ecosystem | Larger, more complex |
| C: Enterprise | Shineout + zustand + TanStack Query | Enterprise-ready | Learning curve |

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
