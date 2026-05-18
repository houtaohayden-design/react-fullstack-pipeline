# Design Review -- Visual Audit, Fix Loop, and Design QA

## Source
Derived from `design-review/SKILL.md` in the gstack repository (github.com/garrytan/gstack).

---

## Overview

The design-review skill is a comprehensive visual design audit system that operates on live rendered sites (via headless Chromium). It finds visual inconsistencies, spacing problems, hierarchy issues, AI slop patterns, and interaction problems -- then fixes them in source code atomically, committing each fix individually and verifying with before/after screenshots.

The agent persona is a senior product designer AND frontend engineer. It has zero tolerance for generic or AI-generated-looking interfaces.

---

## Modes of Operation

### Full (default)
Systematic review of 5-8 pages reachable from homepage. Full checklist evaluation, responsive screenshots, interaction flow testing. Produces complete design audit report with letter grades.

### Quick (`--quick`)
Homepage + 2 key pages. First Impression + Design System Extraction + abbreviated checklist. Fastest path to a design score.

### Deep (`--deep`)
Comprehensive: 10-15 pages, every interaction flow, exhaustive checklist. For pre-launch audits or major redesigns.

### Diff-Aware (automatic on feature branches)
When on a feature branch with no URL specified:
1. Analyze branch diff: `git diff main...HEAD --name-only`
2. Map changed files to affected pages/routes
3. Detect running app on common local ports (3000, 4000, 8080)
4. Audit only affected pages, compare design quality before/after

### Regression (`--regression`)
Run full audit, load previous `design-baseline.json`. Compare per-category grade deltas, new findings, resolved findings. Output regression table.

---

## Phase 1: First Impression (The Designer's Gut Reaction)

The most uniquely designer-like output. Before analyzing anything systematically:

1. Navigate to the target URL
2. Take a full-page desktop screenshot
3. Write a first-person structured critique:
   - "The site communicates [what]."
   - "I notice [observation]."
   - "The first 3 things my eye goes to are: [1], [2], [3]." -- hierarchy check: are these the intended focal points?
   - "If I had to describe this in one word: [word]."

**Page Area Test:** Point at each clearly defined area. Can you instantly name its purpose in 2 seconds? Areas you can't name are poorly defined. List them.

**Narration mode:** Write in first person as if a user scanning the page for the first time: "I'm looking at this page... my eye goes to the logo, then a wall of text I skip entirely, then... wait, is that a button?" Name specific elements, positions, visual weights.

---

## Phase 2: Design System Extraction (Infer the System Being Used)

Extract the ACTUAL design system the site renders (not what DESIGN.md says):

```javascript
// Fonts in use (capped at 500 elements)
JSON.stringify([...new Set([...document.querySelectorAll('*')].slice(0,500)
  .map(e => getComputedStyle(e).fontFamily))])

// Color palette in use
JSON.stringify([...new Set([...document.querySelectorAll('*')].slice(0,500)
  .flatMap(e => [getComputedStyle(e).color, getComputedStyle(e).backgroundColor])
  .filter(c => c !== 'rgba(0, 0, 0, 0)'))])

// Heading hierarchy
JSON.stringify([...document.querySelectorAll('h1,h2,h3,h4,h5,h6')]
  .map(h => ({tag:h.tagName, text:h.textContent.trim().slice(0,50),
              size:getComputedStyle(h).fontSize, weight:getComputedStyle(h).fontWeight}))

// Touch target audit
JSON.stringify([...document.querySelectorAll('a,button,input,[role=button]')]
  .filter(e => {const r=e.getBoundingClientRect();
                return r.width>0 && (r.width<44||r.height<44)})
  .map(e => ({tag:e.tagName, text:(e.textContent||'').trim().slice(0,30),
              w:Math.round(e.getBoundingClientRect().width),
              h:Math.round(e.getBoundingClientRect().height)})))

// Performance baseline
page performance API metrics
```

Structure findings as an **Inferred Design System:** fonts (flag >3 families), colors (flag >12 unique non-gray), heading scale (flag skipped levels), spacing patterns (flag non-scale values).

---

## Phase 3: Page-by-Page Visual Audit

For each page in scope, run:
- Annotated snapshot with ref labels overlaid
- Responsive screenshots (mobile 375, tablet 768, desktop 1280)
- Console error capture
- Performance metrics

### Trunk Test (applied to every page)
Dropped on this page with no context, can you immediately answer:
1. What site is this? (Site ID)
2. What page am I on? (Page name)
3. What are the major sections? (Primary nav)
4. What are my options at this level? (Local nav)
5. Where am I in the scheme of things? (Breadcrumbs)
6. How can I search? (Search box)

Score: PASS (all 6) / PARTIAL (4-5) / FAIL (3 or fewer). A FAIL on the trunk test is HIGH-impact regardless of visual polish.

### Design Audit Checklist: 10 categories, ~80 items

**1. Visual Hierarchy & Composition (8 items, 15% weight)**
- Clear focal point? One primary CTA per view?
- Eye flows naturally top-left to bottom-right?
- Visual noise assessment (competing elements)
- Information density appropriate for content type
- Z-index clarity (nothing unexpectedly overlapping)
- Above-the-fold communicates purpose in 3 seconds?
- Squint test: hierarchy still visible when blurred?
- White space is intentional, not leftover?

**2. Typography (15 items, 15% weight)**
- Font count <=3 (flag if more)
- Scale follows ratio (1.25 major third or 1.333 perfect fourth)
- Line-height: 1.5x body, 1.15-1.25x headings
- Measure: 45-75 chars per line (66 ideal)
- Heading hierarchy: no skipped levels
- Weight contrast: >=2 weights used
- No blacklisted fonts
- If primary font is Inter/Roboto/Open Sans/Poppins: flag as potentially generic
- `text-wrap: balance` or `text-pretty` on headings
- Curly quotes used, not straight quotes
- Ellipsis character not three dots
- `font-variant-numeric: tabular-nums` on number columns
- Body text >= 16px
- Caption/label >= 12px
- No letterspacing on lowercase text

**3. Color & Contrast (10 items, 10% weight)**
- Palette coherent (<=12 unique non-gray colors)
- WCAG AA: body 4.5:1, large text 3:1, UI components 3:1
- Semantic colors consistent
- No color-only encoding (always add labels, icons, or patterns)
- Dark mode: surfaces use elevation, not just lightness inversion
- Dark mode: text off-white (~#E0E0E0), not pure white
- Primary accent desaturated 10-20% in dark mode
- `color-scheme: dark` on html element
- No red/green only combinations
- Neutral palette is warm or cool consistently

**4. Spacing & Layout (12 items, 15% weight)**
- Grid consistent at all breakpoints
- Spacing uses a scale (4px or 8px base)
- Alignment consistent (nothing floats outside grid)
- Rhythm: related items closer, distinct sections further apart
- Border-radius hierarchy (not uniform bubbly)
- Inner radius = outer radius - gap (nested elements)
- No horizontal scroll on mobile
- Max content width set
- `env(safe-area-inset-*)` for notch devices
- URL reflects state (filters, tabs, pagination)
- Flex/grid used for layout (not JS measurement)
- Breakpoints: mobile (375), tablet (768), desktop (1024), wide (1440)

**5. Interaction States (10 items, 10% weight)**
- Hover state on all interactive elements
- `focus-visible` ring present
- Active/pressed state with depth or color shift
- Disabled state: reduced opacity + `cursor: not-allowed`
- Loading: skeleton shapes match real content layout
- Empty states: warm message + primary action + visual
- Error messages: specific + include fix/next step
- Success: confirmation animation or color, auto-dismiss
- Touch targets >= 44px
- `cursor: pointer` on all clickable elements
- Mindless choice audit: every decision point is an obvious click

**6. Responsive Design (8 items, 10% weight)**
- Mobile layout makes DESIGN sense (not just stacked desktop)
- Touch targets sufficient (>= 44px)
- No horizontal scroll on any viewport
- Images handle responsive (srcset, sizes, or CSS containment)
- Text readable without zooming on mobile
- Navigation collapses appropriately
- Forms usable on mobile
- No `user-scalable=no` or `maximum-scale=1`

**7. Motion & Animation (6 items, 5% weight)**
- Easing: ease-out entering, ease-in exiting, ease-in-out moving
- Duration: 50-700ms range
- Purpose: every animation communicates something
- `prefers-reduced-motion` respected
- No `transition: all` (properties listed explicitly)
- Only `transform` and `opacity` animated

**8. Content & Microcopy (8 items, 10% weight)**
- Empty states designed with warmth
- Error messages specific: what + why + what to do
- Button labels specific ("Save API Key" not "Continue")
- No placeholder/lorem ipsum in production
- Truncation handled
- Active voice
- Loading states end with ellipsis character
- Destructive actions have confirmation or undo
- Happy talk detection: scan for "Welcome to..." or self-congratulatory text
- Instructions detection: any visible instructions longer than one sentence

**9. AI Slop Detection (10 items, 5% weight)**
The test: would a human designer at a respected studio ever ship this?
- Purple/violet/indigo gradient backgrounds
- The 3-column feature grid (THE most recognizable AI layout)
- Icons in colored circles as decoration
- Centered everything
- Uniform bubbly border-radius everywhere
- Decorative blobs, floating circles, wavy SVG dividers
- Emoji as design elements
- Colored left-border on cards
- Generic hero copy ("Welcome to [X]", "Unlock the power of...")
- Cookie-cutter section rhythm (hero -> features -> testimonials -> pricing -> CTA)
- `system-ui` or `-apple-system` as PRIMARY display/body font

**10. Performance as Design (6 items, 5% weight)**
- LCP < 2.0s (web apps), < 1.5s (informational)
- CLS < 0.1
- Skeleton quality matches real content layout
- Images: `loading="lazy"`, dimensions, WebP/AVIF
- Fonts: `font-display: swap`, preconnect to CDN origins
- No visible font swap flash (FOUT)

---

## Phase 4: Interaction Flow Review

Walk 2-3 key user flows as a user would:
1. Snapshot the page
2. Click through the flow
3. Diff snapshots to see what changed

Evaluate: response feel, transition quality, feedback clarity, form polish.

### Goodwill Reservoir (track across the flow)
Start at 70/100. Subtract for: hidden info (-15), format punishment (-10), unnecessary info requests (-10), interstitials/splash screens (-15), sloppy appearance (-10), ambiguous choices (-5 each). Add for: obvious top tasks (+10), upfront about costs (+5), saves steps (+5 each), graceful error recovery (+10), apologizes when things go wrong (+5).

Report as visual dashboard showing the step-by-step goodwill trajectory. Below 30 = critical UX debt. 30-60 = needs work. Above 60 = healthy.

---

## Phase 5: Cross-Page Consistency

Compare screenshots across pages for:
- Navigation bar consistency
- Footer consistency
- Component reuse vs one-off designs
- Tone consistency (playful vs corporate on different pages)
- Spacing rhythm carries across pages

---

## Phase 6: Compile Baseline Report

### Scoring System

**Dual headline scores:**
- **Design Score: {A-F}** -- weighted average of all 10 categories
- **AI Slop Score: {A-F}** -- standalone grade with pithy verdict

**Per-category grades:**
- A: Intentional, polished, delightful
- B: Solid fundamentals, minor inconsistencies
- C: Functional but generic, no design point of view
- D: Noticeable problems, feels unfinished
- F: Actively hurting user experience

**Grade computation:** Each category starts at A. Each HIGH-impact finding drops one letter grade. Each MEDIUM-impact finding drops half a letter grade. Polish findings noted but don't affect grade.

### Design Hard Rules

**Classifier (determine rule set before evaluating):**
- MARKETING/LANDING PAGE: hero-driven, brand-forward, conversion-focused
- APP UI: workspace-driven, data-dense, task-focused
- HYBRID: apply appropriate rules per section

**Hard rejection criteria (instant-fail):**
1. Generic SaaS card grid as first impression
2. Beautiful image with weak brand
3. Strong headline with no clear action
4. Busy imagery behind text
5. Sections repeating same mood statement
6. Carousel with no narrative purpose
7. App UI made of stacked cards instead of layout

**Litmus checks (YES/NO):**
1. Brand/product unmistakable in first screen?
2. One strong visual anchor present?
3. Page understandable by scanning headlines only?
4. Each section has one job?
5. Are cards actually necessary?
6. Does motion improve hierarchy or atmosphere?
7. Would design feel premium with all decorative shadows removed?

**Universal rules (apply to ALL types):**
- Define CSS variables for color system
- No default font stacks (Inter, Roboto, Arial, system)
- One job per section
- "If deleting 30% of the copy improves it, keep deleting"
- Cards earn their existence -- no decorative card grids
- NEVER use small, low-contrast type (< 16px body or contrast < 4.5:1)
- NEVER put labels inside form fields as the only label
- ALWAYS preserve visited vs unvisited link distinction
- NEVER float headings between paragraphs

---

## Phase 7: Triage

Sort all findings by impact:
- **High Impact:** Fix first. Affect first impression and user trust.
- **Medium Impact:** Fix next. Reduce polish, felt subconsciously.
- **Polish:** Fix if time allows. Separate good from great.
- **Deferred:** Cannot fix from source code (third-party widgets, content requiring copy from team).

---

## Phase 8: The Fix Loop

For each fixable finding in impact order:

### 8a. Locate Source
Search for CSS classes, component names, style files. Only modify files directly related to the finding. Prefer CSS/styling changes over structural component changes.

### 8a.5. Target Mockup (if design binary available)
For findings involving visual layout, hierarchy, or spacing (not trivial CSS value fixes), generate an AI mockup showing what the corrected version should look like. Show the user: "Here's the current state and here's what it should look like. Now I'll fix the source to match."

### 8b. Fix
- Read the source code, understand the context
- Make the minimal fix -- smallest change that resolves the issue
- CSS-only changes preferred (safer, more reversible)
- Do NOT refactor surrounding code or "improve" unrelated things

### 8c. Commit (Atomic)
```
git add <only-changed-files>
git commit -m "style(design): FINDING-NNN -- short description"
```
One commit per fix. Never bundle multiple fixes. Clean working tree required before starting.

### 8d. Re-Test (Before/After Validation)
Navigate back to the affected page and verify:
- Before/after screenshot pair for every fix
- Console error check
- Snapshot diff to verify change

### 8e. Classify
- **verified:** re-test confirms fix, no new errors
- **best-effort:** applied but couldn't fully verify
- **reverted:** regression detected -> `git revert HEAD` -> mark as deferred

### 8f. Self-Regulation (STOP AND EVALUATE)
Every 5 fixes, compute design-fix risk level:
```
Start at 0%
Each revert:                         +15%
Each CSS-only file change:            +0%   (safe)
Each JSX/TSX/component file change:   +5%   per file
After fix 10:                         +1%   per additional fix
Touching unrelated files:             +20%
```

If risk > 20%: STOP immediately. Show progress, ask whether to continue.
Hard cap: 30 fixes. After 30, stop regardless of remaining findings.

---

## Phase 9: Final Design Audit

After all fixes applied:
1. Re-run the design audit on all affected pages
2. Compute final design score and AI slop score
3. If final scores are WORSE than baseline: WARN prominently

---

## Phase 10: Report

Write comprehensive report with:
- All findings with impact ratings
- Fix status for each: verified / best-effort / reverted / deferred
- Commit SHA and files changed for each fix
- Before/After screenshot pairs for each fix
- Summary: total findings, fixes applied, deferred findings
- Design score delta: baseline -> final
- AI slop score delta: baseline -> final
- PR-ready one-line summary

### Output Structure
```
~/.gstack/projects/$SLUG/designs/design-audit-{YYYYMMDD}/
  design-audit-{domain}.md
  screenshots/
    first-impression.png
    {page}-annotated.png
    {page}-mobile.png
    {page}-tablet.png
    {page}-desktop.png
    finding-NNN-before.png
    finding-NNN-target.png    (if mockup generated)
    finding-NNN-after.png
  design-baseline.json        (for regression mode)
```

### Design Critique Format
Use structured feedback, not opinions:
- "I notice..." -- observation
- "I wonder..." -- question
- "What if..." -- suggestion
- "I think... because..." -- reasoned opinion

Tie everything to user goals and product objectives. Always suggest specific improvements alongside problems.

---

## Landmark Design Rules for Code Generation

These 11 rules define the minimum bar for AI-generated UI to pass a design review:

1. **Think like a designer, not a QA engineer.** Care whether things feel right, look intentional, and respect the user -- not just whether they "work."
2. **Screenshots are evidence.** Every finding needs at least one screenshot. Use annotated screenshots to highlight elements.
3. **Be specific and actionable.** "Change X to Y because Z" -- not "the spacing feels off."
4. **Never read source code** (during the audit phase). Evaluate the rendered site, not the implementation.
5. **AI Slop detection is the superpower.** Most developers can't evaluate whether their site looks AI-generated. gstack can.
6. **Quick wins matter.** Always include the 3-5 highest-impact fixes taking <30 minutes each.
7. **Use `snapshot -C` for tricky UIs.** Finds clickable divs the accessibility tree misses.
8. **Mobile layout must make DESIGN sense,** not just "not broken." Stacked desktop columns on mobile is lazy.
9. **Document incrementally.** Write each finding to the report as found. Don't batch.
10. **Depth over breadth.** 5-10 well-documented findings with screenshots > 20 vague observations.
11. **Show screenshots to the user.** After every screenshot command, display the image inline so the user can see it.
