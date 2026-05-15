---
name: react-pipeline:code-review
description: Use when finishing a task or before merging — dispatches code review subagents for React-specific quality review.
---

# Code Review for React

## Core Principle
Two-stage review between every task: spec compliance first, then React code quality. Don't treat review as optional — it catches issues cheaply.

## When to Use
- After each task in `react-pipeline:subagent-dev`
- Before merging a feature branch
- After receiving external review feedback

## Two-Stage Review Process

### Stage 1: Spec Compliance Review
Verify implementation matches the task specification exactly.

```markdown
SUBAGENT: react-spec-reviewer
Check:
1. All files from task spec created/modified?
2. All props/types match spec?
3. All behaviors described in spec implemented?
4. Any extras (not in spec)?

Result: PASS or FAIL (with specific gaps listed)
```

### Stage 2: Code Quality Review
Verify React best practices and code quality.

```markdown
SUBAGENT: react-code-reviewer
Check:
- React rules-of-hooks compliance
- Key props on lists
- Unnecessary re-renders (useMemo/useCallback/memo)
- Component composition (not too large, not too many props)
- Accessibility (aria labels, semantic HTML, keyboard)
- Performance (expensive computations in render)
- File organization (consistent structure)
- TypeScript types (no any, proper interfaces)

Result: PASS, COMMENT (suggestions), or CHANGE_REQUIRED (must fix)
```

## Review Priority for React

| Priority | What | Why |
|----------|------|-----|
| P0 | Hook rules violations | Causes subtle bugs |
| P0 | Missing keys on lists | Causes reconciliation bugs |
| P1 | Missing accessibility | Blocks users |
| P1 | Memory leaks (useEffect cleanup) | Degrades UX over time |
| P2 | Unnecessary re-renders | Performance |
| P2 | Large components (>200 lines) | Maintainability |
| P3 | Naming conventions | Consistency |

## Receiving External Review
When consuming code review feedback:
1. Read each comment completely before responding
2. Verify the issue exists before fixing
3. Ask for clarification if feedback is unclear
4. Fix → verify → push incremental commit

## Next Step
After all reviews pass: **REQUIRED SUB-SKILL:** Use `react-pipeline:finish-branch`
