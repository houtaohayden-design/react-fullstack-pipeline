# Trainer Subagent Prompt Template

Use when dispatching a `react-trainer` subagent.

## Template

```
Train this GitHub repository into the knowledge base. You are a `react-trainer`.

## Repository
URL: {REPO_URL}
Slug: {SLUG}
Category: {CATEGORY} (one of: ui-libraries, headless, data-fetching, hooks-utilities, animation, routing, state-management, charts, guides, backend, database, deployment, auth)

## Task

### Phase 1: Clone & Explore
1. Clone the repo (shallow): `git clone --depth 1 {REPO_URL} knowledge/repos/{CATEGORY}/{SLUG}`
2. Explore the source thoroughly. Understand:
   - Package entry points (package.json main/module/exports)
   - All key exports (components, hooks, utilities)
   - Version, peer dependencies, runtime dependencies
   - Build tooling (Vite, tsc, Rollup, etc.)
   - Source organization (src/ structure, barrel files, index files)

### Phase 2: API Documentation (api.md)
Write `knowledge/repos/{CATEGORY}/{SLUG}/api.md`:
- **Setup** — npm/yarn/pnpm install, any peer deps, any config needed
- **All key exports** — each with props/options table (name, type, default, required)
- **Minimal working examples** — copy-paste ready, one per export
- **Key dependencies** — major dependencies and what they're used for

### Phase 3: Usage Patterns (patterns.md)
Write `knowledge/repos/{CATEGORY}/{SLUG}/patterns.md`:
- **Library positioning** — what problem it solves, what it replaces, when to use vs alternatives
- **Common patterns** — how components/hooks compose together, real-world recipes
- **Styling approach** — how styles are applied (CSS modules, Tailwind, styled-components, CSS-in-JS, props-based)
- **Anti-patterns** — common mistakes to avoid
- **Compatibility** — how it works with react-bits, Tailwind CSS, other trained repos

### Phase 4: Interaction Patterns (interaction-patterns.md)
Write `knowledge/repos/{CATEGORY}/{SLUG}/interaction-patterns.md`:

Extract from source code every interaction pattern:
- **Hover states** — `:hover` CSS rules, onMouseEnter/onMouseLeave handlers, hover variants (scale, color shift, underline reveal, glow, shadow lift)
- **Focus states** — `:focus-visible` styles, focus ring design (offset, color, width), focus trap behavior
- **Active/press states** — `:active` styles, press-down transforms, ripple effects, color inversion
- **Transition specs** — transition-property, duration, easing per element; CSS transition vs framer-motion vs spring
- **Gesture handling** — drag, swipe, pinch; threshold values; inertia/decay settings
- **Keyboard navigation** — arrow keys, Enter/Escape, Space, Tab; list navigation patterns (roving tabindex)
- **Loading states** — skeleton shapes, spinner placement, progress indicators, optimistic UI patterns
- **Empty/error states** — what renders when data is missing or operations fail
- **Feedback patterns** — toast placement, confirmation dialogs, undo patterns, copy-to-clipboard feedback
- **Motion tokens** — if a design system: duration scale (fast/normal/slow), easing curve catalog, spring presets

Format each interaction as:
```markdown
### <Interaction Name>
- **Trigger:** <what initiates it>
- **Behavior:** <what happens>
- **Implementation:** <CSS class / JS handler / animation config>
- **Duration:** <ms or spring config>
```

### Phase 5: Design Tokens (design-tokens.md)
Write `knowledge/repos/{CATEGORY}/{SLUG}/design-tokens.md`:

Extract the design token system from the source:
- **Color palette** — all named colors with hex/hsl/oklch values; semantic tokens (primary, success, danger, warning, info); neutral scale
- **Typography** — font family stack, font size scale (with rem/px values), font weight usage, line height scale, letter-spacing tokens
- **Spacing** — spacing scale (0.25rem increments or custom), inset/padding/margin tokens
- **Border radius** — radius scale (sm/md/lg/full values), which components use which radius
- **Shadow/elevation** — box-shadow tokens by elevation level, inset shadows, colored shadows (glow effects)
- **Breakpoints** — responsive breakpoint values (sm/md/lg/xl/2xl etc.)
- **Z-index** — z-index scale (dropdown, sticky, modal, tooltip, toast)
- **Animation** — duration tokens, easing tokens, keyframes defined
- **Dark mode** — if supported: how tokens differ between light/dark, color inversion strategy
- **Misc** — border width/color tokens, opacity tokens, backdrop-filter tokens, any custom properties

Format as:
```markdown
## Color Palette
| Token | Light Value | Dark Value | Usage |
|-------|------------|------------|-------|
| --color-primary | #3B82F6 | #60A5FA | Primary actions, links |

## Typography Scale
| Token | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| text-xs | 0.75rem | 400 | 1rem | Captions, helper text |
```

### Phase 6: Cleanup
Delete all source files, keep only:
- api.md
- patterns.md
- interaction-patterns.md
- design-tokens.md

### Phase 7: Registry Entry
Add to `knowledge/registry.json` → `trained` array:
```json
{
  "slug": "{SLUG}",
  "name": "{PACKAGE_NAME}",
  "source": "{REPO_URL}",
  "type": "{TYPE}",
  "category": "{CATEGORY}",
  "platform": "web",
  "style": "{STYLE_DESCRIPTION}",
  "components": {COUNT},
  "highlights": ["key1", "key2", "key3"],
  "extracted": {
    "interactions": {PATTERN_COUNT},
    "designTokens": {TOKEN_COUNT}
  },
  "compatibility": { "tailwind": "yes|partial|no", "react-bits": "yes|complementary|no", "react-version": ">=X" },
  "trained": "{TODAY_DATE}"
}
```

### Phase 8: Auto-Detect Category
If category not pre-assigned, determine from source:
- Has styled React components with CSS/styled → `ui-libraries`
- Has React components with data-attribute selectors, no visual styles → `headless`
- Primarily hooks/utilities, no visual output → `hooks-utilities`
- State management primitives (atoms/stores/reducers) → `state-management`
- Animation/motion/gesture primitives → `animation`
- Data fetching/caching/server-state → `data-fetching`
- Chart/data-viz components → `charts`
- Routing/navigation → `routing`
- API server framework (Hono/Express/Fastify) → `backend`
- Database ORM/migration → `database`
- Auth providers/JWT/session → `auth`
- Deployment/CI/CD/container configs → `deployment`

## Output
Report:
- Repo name, slug, category, component count
- Interaction patterns found (count + top 3 most interesting)
- Design tokens extracted (count + palette summary)
- Key highlights (3-5 most noteworthy features)
- Confirmation that all 4 knowledge files exist
- Confirmation that registry is updated
```
