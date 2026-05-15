---
name: react-pipeline:brainstorming
description: Use when building or creating a React application, component, or feature — before any code. Explores requirements, user intent, and design approach.
---

# Brainstorming for React Projects

## Core Principle
Understand WHAT the user wants before thinking about HOW. Ask clarifying questions one at a time, propose 2-3 technical approaches, write a design document.

## When to Use
- "build a React app/dashboard/website"
- "create a component/feature"
- "add functionality to existing app"
- Any creative work before implementation

## Workflow

### Step 1: Understand Requirements (2-4 questions)
Ask one question at a time. Never rapid-fire:
1. What does the app/component DO? (core functionality)
2. Who uses it? (user personas)
3. What constraints exist? (bundle size, accessibility, browser support, mobile?)
4. Any design reference? (Figma, mockup, existing app)

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
After approval: **REQUIRED SUB-SKILL:** Use `react-pipeline:writing-plans` to create implementation plan.
