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
| P0 | Canvas per-frame dimension assignment | Backing-store reallocation at 60fps |
| P0 | rAF loop restart on scroll tick | MotionValue in useEffect deps |
| P1 | Missing accessibility | Blocks users |
| P1 | Memory leaks (useEffect cleanup) | Degrades UX over time |
| P1 | Missing ErrorBoundary | Single exception → white screen |
| P1 | No HiDPI canvas scaling | Blurry on Retina displays |
| P2 | Unnecessary re-renders | Performance |
| P2 | Large components (>200 lines) | Maintainability |
| P2 | Module-level mutable state | Leaks between tests, survives HMR |
| P2 | Fragile string manipulation | `str.replace('rgb'...` breaks on `rgba` input |
| P3 | Naming conventions | Consistency |

## Creative Coding Specific Checks (Canvas 2D, WebGL, Particles)

When reviewing code that uses Canvas 2D or rAF loops:

### Canvas 2D
- [ ] **No `canvas.width`/`canvas.height` assignment in rAF**: Every assignment destroys backing store. Must use ResizeObserver.
- [ ] **HiDPI support**: `canvas.width = w * dpr; canvas.height = h * dpr; ctx.scale(dpr, dpr)`
- [ ] **Context null check**: `const ctx = canvas.getContext('2d'); if (!ctx) return;`
- [ ] **No string-replace for colors**: `color.replace('rgb', 'rgba').replace(')', ',0.5)')` is fragile. Use regex `^rgb\((\d+),\s*(\d+),\s*(\d+)\)$` or a proper color library.

### requestAnimationFrame
- [ ] **No reactive values in effect deps**: framer-motion values (`chapterProgress`, `scrollY`) must live in refs, not trigger effect restarts
- [ ] **dt clamping**: `const clampedDt = Math.min(dt, 0.05)` — prevents tab-switch spike
- [ ] **Cleanup cancels rAF**: `return () => cancelAnimationFrame(rafRef.current)`
- [ ] **lastTimeRef reset on chapter/scene switch**: Avoid stale delta on re-entry

### Particle / Module State
- [ ] **No bare `let` at module scope**: `let particles = []` leaks between tests. Use factory functions or export `reset*()`.
- [ ] **Reset wired**: If renderers have reset functions, they must be called from the parent component on scene switch
- [ ] **Lifecycle**: Dead particles replaced, not accumulated (array grows boundlessly otherwise)

## Receiving External Review
When consuming code review feedback:
1. Read each comment completely before responding
2. Verify the issue exists before fixing
3. Ask for clarification if feedback is unclear
4. Fix → verify → push incremental commit

## Next Step
After all reviews pass: **REQUIRED SUB-SKILL:** Use `react-pipeline:finish-branch`
