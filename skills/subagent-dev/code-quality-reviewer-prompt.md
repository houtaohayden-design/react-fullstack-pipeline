# Code Quality Reviewer Prompt Template

Use when dispatching a `react-code-reviewer` subagent.

## Template

```
Review the code quality of this implementation. You are a `react-code-reviewer`.

## Files to Review
{FILE_LIST}

## React Quality Checklist

### P0 — Must Fix
- [ ] Rules of Hooks: All hooks at top level, called unconditionally
- [ ] Keys on lists: Every array .map() has stable `key` prop
- [ ] Effect cleanup: Every useEffect with subscription/interval has cleanup return

### P1 — Should Fix
- [ ] Accessibility: Interactive elements have accessible names (aria-label, aria-labelledby)
- [ ] Keyboard navigation: onClick handlers have onKeyDown for Enter/Space
- [ ] Semantic HTML: Use button for buttons, nav for navigation, main for content
- [ ] Error boundaries: Dangerous operations wrapped appropriately

### P2 — Performance
- [ ] Component splitting: Components under 200 lines
- [ ] Expensive computations: Wrapped in useMemo if dependencies don't change often
- [ ] Callback stability: Event handlers use useCallback if passed to memo'd children
- [ ] Render optimization: React.memo on list item components

### P3 — Code Quality
- [ ] TypeScript: No `any` types, interfaces over type aliases for objects
- [ ] Naming: Components PascalCase, hooks useXxx, events handleXxx
- [ ] File structure: Consistent with project conventions
- [ ] Imports: No unused imports, clean import order

## Result
Respond with: PASS | COMMENT (suggestions, non-blocking) | CHANGE_REQUIRED (must fix, with exact line references)
```
