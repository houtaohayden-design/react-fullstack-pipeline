---
name: react-pipeline:subagent-dev
description: Use when executing an implementation plan with independent tasks — dispatches fresh subagent per task with two-stage review (spec compliance + code quality).
---

# Subagent-Driven Development

## Core Principle
Execute each plan task as a fresh subagent. Each subagent sees only its task, implements it completely, and commits. Two-stage review between every task: spec compliance first, then code quality.

## When to Use
- After writing an implementation plan
- Multiple independent tasks to execute
- User wants automated review cycle

## Workflow

```
Task 1 → Implementer → Spec Review → Pass? → Code Review → Pass? → Commit → Next Task
                            ↓ Fail                    ↓ Fail
                         Fix issues               Fix issues
```

### Step 1: Verify Prerequisites
- [ ] Plan exists with complete tasks
- [ ] Isolation (worktree or clean branch) confirmed
- [ ] All dependencies installed
- [ ] Baseline tests pass

### Step 2: Dispatch Implementer (per task)
```markdown
SUBAGENT: react-implementer
Input: Task description from plan + context file paths
Instructions:
1. Read relevant files
2. Follow react-pipeline:tdd (write test FIRST)
3. Implement the code
4. Verify test passes
5. Self-check against spec
6. Stage and commit
7. Report: what was done, test output, commit hash
```

### Step 3: Spec Compliance Review
```markdown
SUBAGENT: react-spec-reviewer
Input: Task spec + implementation + commit diff
Check:
- Does implementation match spec exactly?
- Are all specified files created/modified?
- Are all props/types as specified?
Result: PASS (proceed) or FAIL (list specific gaps, return to implementer)
```

### Step 4: Code Quality Review
```markdown
SUBAGENT: react-code-reviewer
Input: All changed files
Check:
- React best practices (hook rules, key usage, memo)
- Component composition and props design
- Accessibility (aria, keyboard, semantic HTML)
- Performance (unnecessary re-renders, heavy computations)
Result: PASS or CHANGE_REQUIRED (with specific fixes)
```

### Step 5: Repeat
Next task after current is committed and reviewed.

## Model Selection
- **react-implementer**: Fast/cheap model for simple tasks, standard for complex
- **react-spec-reviewer**: Standard model
- **react-code-reviewer**: Most capable model (quality matters)

## State Handling
If a subagent asks questions:
1. Answer if simple (one-line)
2. Escalate to user if design decision needed
3. Never guess design decisions

## Next Step
After all tasks: **REQUIRED SUB-SKILL:** Use `react-pipeline:finish-branch`
