---
name: react-pipeline:visual-check
description: Use when verifying visual correctness — screenshot comparison, visual regression, "does this look right", post-deploy visual QA, responsive layout verification.
---

# Visual Check — Browser-Based Visual Verification

## When to Use
- "does this look right" / "check the visuals"
- "compare staging vs production"
- "visual regression check"
- "verify the deploy looks correct"
- "screenshot comparison"
- "responsive layout check"
- "did my CSS change break anything"

## Core Principle
Visual correctness is a distinct dimension from code correctness. A component can pass all unit tests and still look broken. This skill provides structured visual verification.

## Pre-check: gstack Detection

If gstack is installed (`~/.claude/skills/gstack/SKILL.md` exists), prefer gstack `browse` for browser-based verification. gstack's Playwright binary provides annotated screenshots, snapshot diffs, and responsive testing at ~100-200ms per command.

If gstack is NOT installed, this skill documents the manual visual review process and provides guidance for setting up Playwright-based visual testing.

## Workflow

### Step 1: Determine Scope

Ask or determine:
1. **What pages/routes** to verify? (landing, dashboard, form, modal states)
2. **What viewports**? (mobile 375, tablet 768, desktop 1440)
3. **Compare against what**? (previous deploy, design spec, staging, nothing — first deploy)
4. **What states**? (loading, empty, error, success, interactive)

### Step 2: Deploy Preview (if not live)

If the app isn't live yet:
- Use `react-pipeline:frontend-deploy` or gstack `ship` to deploy a preview
- Or start local dev server for pre-deploy check

### Step 3: Capture Screenshots

**With gstack (preferred):**
```bash
# Single page check
$B goto https://yourapp.com
$B snapshot -i -a -o /tmp/visual-check/landing-annotated.png
$B responsive /tmp/visual-check/layout

# Compare two environments
$B diff https://staging.app.com https://prod.app.com
```

**Without gstack (manual):**
Document what to check:
- Key elements visible (hero, nav, CTA, footer)
- No layout overflow at any viewport
- Typography renders correctly
- Colors match design tokens
- Images load without distortion
- Forms have proper validation states
- Dark mode (if applicable) looks intentional

### Step 4: Verification Checklist

Run through these checks for each page:

- [ ] **Layout integrity**: No horizontal scroll at any breakpoint (320/768/1024/1440)
- [ ] **Typography**: Fonts load, hierarchy is clear, no fallback flash
- [ ] **Color accuracy**: Colors match design tokens (not just "looks similar")
- [ ] **Spacing consistency**: Padding/margins follow the spacing scale
- [ ] **Interactive states**: Hover, focus, active, disabled all render
- [ ] **Loading states**: Skeleton/spinner renders without layout shift
- [ ] **Empty states**: Renders correctly when data is empty
- [ ] **Error states**: Error messages are visible and styled
- [ ] **Accessibility**: Focus rings visible, contrast meets WCAG AA
- [ ] **Performance**: No visible jank, CLS < 0.1, LCP renders quickly

### Step 5: Diff & Report

**With gstack:**
```bash
# Take baseline screenshot
$B goto https://staging.app.com/page
$B screenshot /tmp/baseline.png

# Take current screenshot
$B goto https://prod.app.com/page  # or localhost
$B screenshot /tmp/current.png

# Diff
$B diff https://staging.app.com/page https://prod.app.com/page
```

**Report format:**
```markdown
## Visual Check Report

### Pages Checked
| Page | Viewports | Status | Issues |
|------|-----------|--------|--------|
| / | 375, 768, 1440 | PASS | - |
| /dashboard | 375, 768, 1440 | WARN | Card overflow at 375px |

### Issues Found
1. **Dashboard card overflow at 375px** — `.dashboard-grid` needs `grid-template-columns: 1fr` for mobile
2. ...

### Responsive Check
| Breakpoint | / | /dashboard | /settings |
|------------|---|------------|-----------|
| 320px | PASS | FAIL | PASS |
| 375px | PASS | FAIL | PASS |
| 768px | PASS | PASS | PASS |
| 1024px | PASS | PASS | PASS |
| 1440px | PASS | PASS | PASS |
```

## Integration with Other Skills

- **Before ship**: Run visual check after `react-pipeline:code-review` and before `react-pipeline:finish-branch`
- **Post-deploy**: Run visual check as part of deployment verification
- **Design review**: Pair with gstack `design-review` for comprehensive visual audit
- **QA flow**: Use gstack `qa` for interactive browser testing with assertions
