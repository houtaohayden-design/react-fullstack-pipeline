---
name: react-pipeline:subagent-dev
description: Use when executing an implementation plan with independent tasks — builds dependency graph, dispatches parallel groups, with two-stage review per task.
---

# Subagent-Driven Development

## Core Principle
Execute an implementation plan by building a dependency graph, dispatching independent tasks in parallel groups, and applying two-stage review per task. Sequential execution is the safe fallback when tasks form a chain.

## When to Use
- After writing an implementation plan with `depends_on` and `parallel_group` metadata
- Multiple independent tasks to execute
- User wants automated review cycle

## Two Execution Modes

### Mode A: Parallel (when tasks have `parallel_group`)
```
Parse plan → build dependency graph
    ↓
For each group in topological order:
├── Create per-task branches: feature/<name>/task-{N}
├── Dispatch ALL tasks in group → parallel subagents
├── Block until all implementers complete
├── Run two-stage review on each task (parallelizable)
├── Fix failures → re-review (only failing task)
├── Merge all task branches into {BASE_BRANCH}
├── npm test + npm run build on merged state
└── Delete task branches, move to next group
```

### Mode B: Sequential (when no `parallel_group` or chain dependencies)
```
Task 1 → Implement → Spec Review → Code Review → Commit → Task 2 → ...
```
Identical to original behavior. The executor auto-detects which mode to use.

---

## Workflow

### Step 1: Verify Prerequisites
- [ ] Plan exists with `depends_on` and `parallel_group` fields (optional: sequential fallback)
- [ ] Isolation (worktree or clean branch) confirmed
- [ ] All dependencies installed
- [ ] Baseline tests pass (`npm test`)

### Step 2: Build Dependency Graph
Parse the plan and construct the execution graph:

```
1. Extract all tasks with depends_on and parallel_group
2. Validate: no cycles, no missing references, no shared files within a group
3. Topological sort groups by dependencies
4. Schedule: groups with all deps resolved → ready now

Example (healthy-recipes):
  Round 1: [Task 1]                       (schema, no deps)
  Round 2: [Task 2, Task 3, Task 4, Task 5] (backend-apis, all depend on Task 1)
  Round 3: [Task 6, Task 7, Task 8, Task 9] (frontend-pages, depend on Task 5)
  Round 4: [Task 10]                      (depends on 6-9)
  Round 5: [Task 11]                      (depends on 10)
```

### Step 3: Dispatch Parallel Group

For each task in the ready group:

```
1. CREATE per-task branch:
   git checkout -b feature/<name>/task-{N} {BASE_BRANCH}

2. DISPATCH implementer (all tasks in group simultaneously):
   SUBAGENT: react-implementer
   Template: implementer-prompt.md
   Variables:
     TASK_BRANCH = feature/<name>/task-{N}
     BASE_BRANCH = feature/<name>
     TASK_NUM = N
     TASK_TOTAL = total
     PLAN_PATH = <plan-path>

3. WAIT for ALL implementers in the group to complete
   (group wall-time = slowest task, not sum of all tasks)
```

**Model selection for implementers:**
- Simple tasks (CRUD, boilerplate): fast/cheap model
- Complex tasks (algorithms, state machines): standard model
- All must be the same model tier within a group (consistency)

### Step 4: Spec Compliance Review (per task)

Run spec review on each task in the group. These are independent and can be dispatched simultaneously:

```
FOR EACH task IN parallel_group:
  SUBAGENT: react-spec-reviewer
  Template: spec-reviewer-prompt.md
  Check:
  - Does implementation match spec exactly?
  - Are all specified files created/modified?
  - Are all props/types as specified?
  Result: PASS (proceed) or FAIL (list specific gaps)

If any task FAILS:
  - Return to implementer for THAT task only
  - Other tasks in group are unaffected
  - Re-review the fix, then proceed
```

### Step 5: Code Quality Review (per task)

```
FOR EACH task IN parallel_group:
  SUBAGENT: react-code-reviewer
  Template: code-quality-reviewer-prompt.md
  Check:
  - React best practices (hook rules, key usage, memo)
  - Component composition and props design
  - Accessibility (aria, keyboard, semantic HTML)
  - Performance (unnecessary re-renders, heavy computations)
  Result: PASS | COMMENT (suggestions) | CHANGE_REQUIRED (must fix)

If CHANGE_REQUIRED:
  - Return to implementer for THAT task only
  - Re-review after fix
```

### Step 6: Merge Group into Base Branch

When ALL tasks in the group pass both reviews:

```
FOR EACH task IN parallel_group:
  1. git checkout {BASE_BRANCH}
  2. git merge feature/<name>/task-{N} --no-ff
  3. git branch -d feature/<name>/task-{N}

AFTER all merges:
  4. npm test          (verify merged state)
  5. npm run build     (verify build integrity)
  6. Report: merged {N} tasks, tests pass, ready for next group
```

**Conflict handling:** If a merge conflicts (indicates plan error — shared files in group), resolve on {BASE_BRANCH}, then `git merge --continue`.

### Step 7: Loop or Finish

```
While unexecuted tasks remain:
  next_group = group_with_all_deps_satisfied()
  if next_group has parallel_group:
    execute Mode A (Steps 3-6)
  else:
    execute Mode B (single task sequential: Steps 3-5, commit directly)
```

---

## Orchestrator Responsibilities

The orchestrator (your session) manages:
- Building and validating the dependency graph
- Creating and cleaning up per-task branches
- Deciding which mode (A or B) per group
- Merging completed groups and running integrity checks
- Escalating design questions to the user

Implementers should NEVER merge their own branches or modify other tasks' files.

---

## State Handling
If a subagent asks questions:
1. Answer if simple (one-line)
2. Escalate to user if design decision needed
3. Never guess design decisions

---

## Model Selection
- **react-implementer**: Fast/cheap for simple tasks, standard for complex. Same tier within a group.
- **react-spec-reviewer**: Standard model
- **react-code-reviewer**: Most capable model (quality matters)

---

## Next Step
After all tasks: **REQUIRED SUB-SKILL:** Use `react-pipeline:finish-branch`
