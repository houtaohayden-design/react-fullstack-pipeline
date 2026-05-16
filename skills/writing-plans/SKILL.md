---
name: react-pipeline:writing-plans
description: Use when you have approved requirements/design and need to create an implementation plan before touching code.
---

# Writing Implementation Plans

## Core Principle
Break design into bite-sized tasks (2-5 minutes each). Each task has exact file paths, complete code, no placeholders. Add dependency metadata so the executor can dispatch independent tasks in parallel.

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
- Depends on: []
- Parallel group: schema
- Create `src/components/<Name>.tsx`
- Props: `{ title: string; onAction: () => void }`
- Uses: `<Card>` from Shineout, `<motion.div>` from framer-motion
- Test: `src/components/__tests__/<Name>.test.tsx`
- Commit: `feat: add <Name> component`

### Task 2: <Title> (~5 min)
- Depends on: [Task 1]
- Parallel group: backend-apis
- Create `src/routes/<name>.ts`
- ...
```

## Task Dependency Model

### Field Definitions
| Field | Type | Required | Purpose |
|-------|------|----------|---------|
| `depends_on` | `[Task N, ...]` | Task 2+ | Which tasks must complete before this one starts |
| `parallel_group` | `"name"` | Optional, default: none (sequential) | Tasks with same group AND same `depends_on` run simultaneously |

### How to Assign Parallel Groups
1. **Identify phases.** Group tasks by logical phase (e.g., "schema", "backend-apis", "frontend-pages", "integration").
2. **Check file conflicts.** Two tasks in the same group MUST touch different files. If both modify `index.ts`, they are NOT parallel-safe — extract the shared change to a separate task.
3. **Check data dependencies.** A task that consumes data produced by another task must `depends_on` it, not share a `parallel_group`.
4. **When in doubt, omit `parallel_group`.** Sequential execution is always correct; incorrect parallelism causes merge conflicts.

### Example: healthy-recipes (11 tasks)
```
Phase 1 (schema):
  Task 1: depends_on: [], parallel_group: "schema"           → runs first, alone

Phase 2 (backend-apis):
  Task 2: depends_on: [1], parallel_group: "backend-apis"    ┐
  Task 3: depends_on: [1], parallel_group: "backend-apis"    │ 4 agents
  Task 4: depends_on: [1], parallel_group: "backend-apis"    │ in parallel
  Task 5: depends_on: [1], parallel_group: "backend-apis"    ┘

Phase 3 (frontend-pages):
  Task 6: depends_on: [5], parallel_group: "frontend-pages"  ┐
  Task 7: depends_on: [5], parallel_group: "frontend-pages"  │ 4 agents
  Task 8: depends_on: [5], parallel_group: "frontend-pages"  │ in parallel
  Task 9: depends_on: [5], parallel_group: "frontend-pages"  ┘
  Task 10: depends_on: [6,7,8,9]                              → runs after group

Phase 4 (verify):
  Task 11: depends_on: [10]                                    → runs alone, last
```

## Task Rules
1. **Exact file paths** — never "add somewhere" or "create as needed"
2. **Complete props interfaces** — write out the full TypeScript
3. **Reference knowledge base** — note which trained repos are used
4. **2-5 min each** — if longer, split further
5. **Dependencies explicit** — every Task 2+ lists `depends_on: [...]`. Tasks with identical prerequisites touching different files share a `parallel_group`.
6. **Each task includes its test** — TDD in every task
7. **Exact commit message** — conventional commits format
8. **File-conflict check** — two tasks in the same `parallel_group` MUST NOT modify the same file
9. **Sequential by default** — omit `parallel_group` when unsure; executor falls back to sequential
10. **No cycles** — `depends_on` must form a valid topological ordering

## React Plan Checklist
- [ ] Components referenced from trained repos where possible
- [ ] State management approach chosen (local/zustand/TanStack Query)
- [ ] Styling approach specified (Tailwind classes/CSS modules/styled)
- [ ] Accessibility considered (aria labels, keyboard nav)
- [ ] Loading/error/empty states planned
- [ ] Router/lazy loading decisions made
- [ ] Backend and frontend tasks separated into different `parallel_group`s

## Next Steps
- If no isolation: **REQUIRED SUB-SKILL:** Use `react-pipeline:git-worktrees`
- To execute: **REQUIRED SUB-SKILL:** Use `react-pipeline:subagent-dev`
- Fallback: Execute sequentially when `parallel_group` is absent
