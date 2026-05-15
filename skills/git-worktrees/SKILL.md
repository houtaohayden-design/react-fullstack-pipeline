---
name: react-pipeline:git-worktrees
description: Use when starting feature work or executing an implementation plan — ensures isolated workspace via native tools or git worktree.
---

# Git Worktrees for React Development

## Core Principle
Isolate feature work from the main working directory. Prevents cross-contamination, enables parallel features, provides clean baseline.

## When to Use
- Before starting any feature implementation
- When executing an implementation plan
- When user says "start work on..."

## Workflow

### Step 1: Detect Current Isolation
Check if already in a git worktree or isolated environment:
```bash
git worktree list 2>/dev/null
git status
```

### Step 2: Create Isolation
If not already isolated, create a worktree:
```bash
# Named worktree on new branch
git worktree add -b feature/<name> ../<name>-worktree
```

### Step 3: Verify Baseline
```bash
# In worktree
git status
npm install
npm run build  # verify it works
npm test       # verify tests pass
```

Report baseline state before making changes.

## React-Specific Considerations
- Node modules are shared from parent (linked), so `npm install` may not be needed
- `.env.local` files are NOT shared — copy or create in worktree
- Build artifacts should be separate per worktree

## Next Step
After isolation established: **REQUIRED SUB-SKILL:** Use `react-pipeline:writing-plans` to create bite-sized implementation plan.
