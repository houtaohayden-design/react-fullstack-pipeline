---
name: react-pipeline:finish-branch
description: Use when all implementation tasks complete and tests pass — presents structured options for merge/PR/cleanup to complete the development work.
---

# Finishing a Development Branch

## Core Principle
Verify everything is clean, then present the user structured options. Don't auto-merge or auto-push — let the user decide.

## When to Use
- All tasks in implementation plan are complete
- Code review passed
- Tests pass
- Ready to integrate work

## Workflow

### Step 1: Final Verification
```bash
npm run lint
npm run build
npm test
git status
git diff --stat main...HEAD
```

Report: what changed, test results, any warnings.

### Step 2: Detect Environment
Check what the user's environment supports:
```bash
git remote -v          # Is there a remote?
gh auth status         # Is GitHub CLI available?
git branch -a          # What branches exist?
```

### Step 3: Present Options

| Option | When | Command |
|--------|------|---------|
| **Create PR** | Remote + GitHub CLI | `gh pr create` |
| **Merge locally** | No remote, main branch | `git checkout main && git merge feature/x` |
| **Keep branch** | Work in progress | `git checkout main` (branch preserved) |
| **Discard branch** | Experiment, not needed | `git checkout main && git branch -D feature/x` |

### Step 4: Execute Decision
Present the recommendation and execute the chosen option.

### Step 5: Clean Worktree (if applicable)
If using a git worktree:
```bash
rm -rf ../feature-worktree
git worktree prune
```

## Deployment Trigger
If the user wants to deploy after merge:
**REQUIRED SUB-SKILL:** Use `react-pipeline:frontend-deploy` and/or `react-pipeline:server-setup`.
