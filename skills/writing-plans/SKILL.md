---
name: react-pipeline:writing-plans
description: Use when you have approved requirements/design and need to create an implementation plan before touching code.
---

# Writing Implementation Plans

## Core Principle
Break design into bite-sized tasks (2-5 minutes each). Each task has exact file paths, complete code, no placeholders. This is the bridge between "what to build" and "how to build it."

## When to Use
- After brainstorming approval
- When implementing any non-trivial React feature
- Before `react-pipeline:subagent-dev`

## Plan Format

```markdown
# Implementation Plan: <Feature>
## Context
Design doc: `knowledge/specs/<name>.md`
Base branch: `feature/<name>`

## Prerequisites
- [ ] Isolation verified (worktree or clean branch)
- [ ] Knowledge base checked for relevant trained repos
- [ ] Dependencies installed

## Tasks

### Task 1: <Title> (~3 min)
- Create `src/components/<Name>.tsx`
- Props: `{ title: string; onAction: () => void }`
- Uses: `<Card>` from Shineout, `<motion.div>` from framer-motion
- Test: `src/components/__tests__/<Name>.test.tsx`
- Commit: `feat: add <Name> component`

### Task 2: <Title> (~5 min)
...
```

## Task Rules
1. **Exact file paths** — never "add somewhere" or "create as needed"
2. **Complete props interfaces** — write out the full TypeScript
3. **Reference knowledge base** — note which trained repos are used
4. **2-5 min each** — if longer, split further
5. **Independent tasks** — no shared state between tasks
6. **Each task includes its test** — TDD in every task
7. **Exact commit message** — conventional commits format

## React Plan Checklist
- [ ] Components referenced from trained repos where possible
- [ ] State management approach chosen (local/zustand/TanStack Query)
- [ ] Styling approach specified (Tailwind classes/CSS modules/styled)
- [ ] Accessibility considered (aria labels, keyboard nav)
- [ ] Loading/error/empty states planned
- [ ] Router/lazy loading decisions made

## Next Steps
- If no isolation: **REQUIRED SUB-SKILL:** Use `react-pipeline:git-worktrees`
- To execute: **REQUIRED SUB-SKILL:** Use `react-pipeline:subagent-dev`
- Fallback: `react-pipeline:executing-plans` (no subagents)
