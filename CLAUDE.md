# React Full-Stack Pipeline v2.3

Complete React development lifecycle: brainstorming → worktrees → plan → subagent-dev → TDD → code-review → deploy → backend. Triple-path training: frontend repos (4D) + website design systems + backend repos (4D).

## Skills (23 total)

### Process Pipeline
| Skill | When |
|-------|------|
| `react-pipeline:bootstrap` | 会话入口，自动路由 |
| `react-pipeline:brainstorming` | 构建/创建 React 应用前 **(支持批量提问)** |
| `react-pipeline:git-worktrees` | 开始功能开发前 |
| `react-pipeline:writing-plans` | 头脑风暴通过后 **(支持 depends_on + parallel_group)** |
| `react-pipeline:subagent-dev` | 执行实施计划 **(支持并行 Agent 调度)** |
| `react-pipeline:tdd` | 编写实现代码前 |
| `react-pipeline:code-review` | 任务间/合并前 |
| `react-pipeline:finish-branch` | 所有任务完成时 |
| `react-pipeline:visual-check` | 浏览器视觉验证、截图对比、响应式检查 |

### React Domain
| Skill | When |
|-------|------|
| `react-pipeline:react-tool` | 写 React 代码 |
| `react-pipeline:train-repo` | 喂 GitHub 链接训练知识库 **(4D提取: API+Patterns+Interactions+Tokens)** |
| `react-pipeline:train-website` | 喂网站 URL 提取设计系统 **(全维度: 布局+配色+字体+动效+交互+组件)** |
| `react-pipeline:component-design` | 设计新组件 |
| `react-pipeline:styling-system` | CSS/主题架构决策 |

### Deployment
| Skill | When |
|-------|------|
| `react-pipeline:server-setup` | 配置服务器 |
| `react-pipeline:frontend-deploy` | 部署前端 |
| `react-pipeline:docker-setup` | 容器化 |
| `react-pipeline:ci-cd` | CI/CD 管道 |

### Backend
| Skill | When |
|-------|------|
| `react-pipeline:backend-api` | 构建 API |
| `react-pipeline:database` | 数据库设计 |
| `react-pipeline:auth` | 认证授权 |
| `react-pipeline:api-client` | 前端 API 集成 |
| `react-pipeline:train-backend` | 训练后端知识库 **(4D: API+Patterns+Backend+API-Design)** |

## Agents (8 types)
- **react-implementer** — Execute single task from plan (runs in parallel groups when tasks are independent)
- **react-spec-reviewer** — Verify impl matches spec
- **react-code-reviewer** — Code quality review
- **react-trainer** — Train GitHub frontend repos into knowledge base (4D: api + patterns + interactions + tokens)
- **react-design-learner** — Extract complete design system from live websites (layout, color, typography, motion, interactions, components)
- **react-backend-learner** — Search and train backend repos (500+ stars): API frameworks, ORMs, auth, database tools (4D: api + patterns + backend-patterns + api-patterns)
- **react-deployer** — Deploy and configure servers
- **react-backend-engineer** — Build backend APIs

### Parallel Execution
- Brainstorming: batches all 4 discovery questions into 1 message (saves ~3 round-trips)
- Subagent-dev: Mode A (parallel) when plan has `parallel_group` fields — dispatches N agents simultaneously
- Subagent-dev: Mode B (sequential) when plan has no `parallel_group` — identical to original behavior
- Expected speedup: ~53% faster execution (backend + frontend tasks run concurrently)

## Knowledge Base
- `knowledge/registry.json` — Repository index (63 trained, 16 categories)
- `knowledge/repos/<category>/<slug>/` — Structured knowledge (api.md + patterns.md + optional interaction-patterns.md + design-tokens.md)
- `knowledge/websites/<slug>/design-system.md` — 20 live website design system extractions
- `knowledge/design-skills/<slug>/` — 4 design methodology frameworks (gstack, impeccable, taste-skill, ui-ux-pro-max)
- `knowledge/design-systems/` — 20+ premium design reference guides (typography, color, motion, layout, components)
- Builtin: animal-island-ui (17 components), react-bits (110+ animations)
- Trained: 63 entries — frontend repos (35), backend repos (5), design skills (4), websites (20), auth/database/css-in-js (4)
- Categories: ui-libraries (10), headless (7), data-fetching (2), hooks-utilities (3), animation (5), routing (1), state-management (2), charts (1), guides (1), backend (3), database (1), auth (1), css-in-js (2), design-skills (4), design-inspiration (20), deployment (reserved)

## Premium Design Systems (brainstorming Round 1, question 5)
User selects one of three premium UI styles during initial inquiry. Full specs at `knowledge/design-systems/`:

| # | Design System | Base UI | Animation | Visual FX | Best For |
|---|--------------|---------|-----------|-----------|----------|
| A | 动森温馨增强 | animal-island-ui | framer-motion | react-bits (BlurText, TiltedCard, Aurora, BlobCursor) | Recipe/food, personal blogs, lifestyle |
| B | 专业现代 | shadcn/ui (Radix) | framer-motion | react-bits (DecryptedText, SpotlightCard, Dock) | SaaS, dashboards, enterprise |
| C | 玻璃拟态混合 | shadcn or animal-island | framer-motion | react-bits (Hyperspeed, Particles, FluidGlass, SplashCursor) | Creative portfolios, luxury brands |

Cross-cutting layers (apply to any design system):
- `knowledge/design-systems/typography-layout.md` — 12 font pairings, 8 layout systems (Swiss Grid, Editorial Magazine, Minimal Luxury, Bento Grid, Staggered Asymmetric, Masonry Cascade, Full-Screen Immersive, Timeline Narrative), fluid type scales, whitespace architecture, micro-typography patterns
- `knowledge/design-systems/artistic-styles.md` + `artistic-styles-2.md` — 16 premium visual directions: Neo-Brutalism, Wabi-Sabi, Neumorphism, Synthwave, Art Deco, Claymorphism, Dark Academia, Liquid Glass, Scandinavian, Cyberpunk, Vaporwave, Memphis, Bauhaus, Paper Craft, Pop Art, Steampunk. Each with color palette, CSS, TSX, typography pairing
- `knowledge/design-systems/ui-patterns.md` — 60+ premium UI patterns: 6 card designs, 5 navigation, 5 loading states, empty/error states, search/filter, modal/dialog, data display, 6 page transitions, 8 micro-interactions
- `knowledge/design-systems/text-design.md` — Kinetic typography, gradient text (4 variants), text masking (image/video/reveal), 3D CSS text, typewriter/scramble, glitch/distort, split/reveal, number animations, highlights, CSS one-liners
- `knowledge/design-systems/color-theory.md` — Color spaces (HEX/RGB/HSL/OKLCH), 6 harmony rules, 3-layer palette architecture, dark mode architecture, WCAG contrast, cultural meanings, gradient pairing, 5 quick palette templates
- `knowledge/design-systems/motion-design.md` — Disney's 12 principles for UI, duration tokens (100ms–1200ms), easing curve catalog (5 custom beziers), spring physics (6 presets), scroll-driven animation, gesture design, reduced motion, animation quality tiers
- `knowledge/design-systems/landing-patterns.md` — 8 hero patterns (Centered Statement, Split, Full-Bleed, Search-First), feature sections, stats/social proof, pricing, CTA banner, FAQ accordion, premium footer, how-it-works steps
- `knowledge/design-systems/form-design.md` — Input anatomy, 4 style variants (outlined/filled/underlined/pill), 5 validation states, form layouts, multi-step wizard, password strength meter, OTP input, search autocomplete, auto-save, submit states
- `knowledge/design-systems/background-patterns.md` — 7 CSS-only patterns (dots/grid/stripes/chevron/crosshatch/zigzag), noise/grain textures, mesh gradients, geometric backgrounds, floating blobs, hero backgrounds, animated backgrounds
- `knowledge/design-systems/data-viz-design.md` — 12-color categorical palette, sequential/divergent schemes, chart anatomy (7 elements), Recharts theme, premium tooltip, chart type selection, 4 dashboard layouts, KPI cards, sparklines, zoomable timeline, dark mode charts, data tables, accessibility
- `knowledge/design-systems/responsive-patterns.md` — Content-based breakpoints, container queries, fluid typography (clamp-based), fluid spacing, mobile-first patterns, adaptive navigation, responsive images, touch vs mouse, safe areas, print styles, performance patterns
- `knowledge/design-systems/navigation-design.md` — 7 navigation types (top nav, sidebar, mega menu, bottom tab, command palette, floating dock, breadcrumbs), NavLink with active indicator, collapsible sidebar, ⌘K palette, adaptive mobile patterns
- `knowledge/design-systems/empty-states-design.md` — State matrix (loading/empty/ideal/error/partial/overflow), skeleton components, 3 empty state types, error severity levels, offline banner, rate limit handling, progressive loading, permission gates, 12-state checklist
- `knowledge/design-systems/iconography-design.md` — Icon sizing system (12-48px), library comparison (Lucide/Phosphor/Tabler/Radix/Heroicons), animated icons (morphing, hamburger, check, spinner), favicon system, accessibility rules, icon colors, spacing, bundling strategy
- `knowledge/design-systems/search-experience.md` — Search bar variants (inline/fullscreen/hero), autocomplete, faceted search, filter chips, sort controls, result cards, debounced search, UX checklist
- `knowledge/design-systems/modal-dialog-design.md` — Modal types (dialog/drawer/sheet/popover), size presets, stacked modals, focus traps, animation variants (scale/slide/flip), alert dialogs, bottom sheets, anti-patterns
- `knowledge/design-systems/button-design.md` — 8 button variants (primary/secondary/ghost/outline/danger/success/glass), 5 sizes, loading state, icon button, button group, split button, FAB, destructive confirmation, success animation
- `knowledge/design-systems/feedback-patterns.md` — Toast system with progress bar, 5 toast variants, linear/circular/step progress, tooltip, popover, copy feedback, anti-patterns
- `knowledge/design-systems/onboarding-patterns.md` — 8 onboarding patterns (welcome, tour, coach marks, walkthrough, setup, prompts, checklist, video), preference picker, spotlight overlay, activation metrics, anti-patterns

## Known Gotchas (from production pipeline verification)

### animal-island-ui
1. **CSS import MUST be JS, not CSS @import**: Use `import 'animal-island-ui/style'` in main.tsx. `@import 'animal-island-ui/style'` in `.css` files silently fails with Vite.
2. **No deep path imports**: package.json `exports` blocks all paths except root and `./style`. Import types from root: `import type { CardColor } from 'animal-island-ui'`.
3. **Select uses `options` prop, Tabs uses `items` prop** — not compound children pattern.

### Hono + Drizzle + SQL.js
4. **Auth context key**: Middleware stores `c.set('user', { userId, email })` — routes MUST use `c.get('user').userId`, NOT `c.get('userId')`.
5. **No `lastInsertRowid`**: SQL.js `.run()` returns `{ changes }` only. Query by unique key after INSERT.
6. **Batch with `inArray`**: Never fetch related rows in a loop. Use `inArray(column, values)` for single-query batch fetch.
7. **Schema sync**: Raw SQL CREATE TABLE in seed scripts duplicates Drizzle schema. Extract to shared `migrations.ts`.

### Website Design Extraction
8. **Responsible Fetching**: ALL website extraction agents MUST follow `knowledge/responsible-fetching.md`. Max 15 requests, 2s delay, stop on 429/403/503. Small sites (non-CDN): 5 requests, homepage only. User-Agent: `DesignSystemAnalyzer/1.0`.

### Tool Environment
9. **Tab indentation breaks Edit tool**: Use spaces in `.ts` files. The Edit tool string matcher fails on tab-indented code.
10. **Complex TypeScript generics break esbuild**: Simplify deeply nested generic types. esbuild's parser can fail on complex `ReturnType<...>` chains.
11. **Windows PowerShell**: `$pid` is reserved. `nohup` doesn't exist. Use `Start-Process` for background processes. `&&` not available — use `; if ($?) { }`.

### gstack Coexistence
12. **gstack + react-pipeline routing**: When both plugins are installed, route browser/visual tasks to gstack (Playwright), React implementation to react-pipeline (knowledge base). Design review of live sites → gstack. Knowledge extraction → react-pipeline. See `skills/bootstrap/SKILL.md` for full routing table.
13. **Never chain both plugins for the same task**: Don't invoke gstack design-review then react-pipeline code-review for the same component. Pick the right tool for the layer: visual review → gstack, code-level review → react-pipeline.

### Backend Security (pre-deploy checklist)
14. **JWT secret**: Never hardcode fallback secrets. Require `JWT_SECRET` env var or refuse to start.
15. **Rate limiting**: Apply to `/api/auth/login` and `/api/auth/register` before production.
16. **LIKE wildcard sanitization**: Escape `%` and `_` in user-supplied search strings before `LIKE` queries.

### Vite + TypeScript (from wabi-neu project, 2026-05-18)
17. **`verbatimModuleSyntax` is ON by default**: Vite React-TS template enables this. ALL type-only imports MUST use `import type { X }` not `import { type X }`. Affects every file that imports interfaces.
18. **Enable `strict: true` at scaffold time**: Without it, `ctx.getContext('2d')` (returns `null | CanvasRenderingContext2D`) has no null-check enforcement. Add to tsconfig.app.json during project init.
19. **CSS file ordering matters**: If `global.css` imports `tokens.css`, create `tokens.css` FIRST. Vite fails hard on missing CSS imports (unlike JS which shows runtime error).

### Canvas 2D + framer-motion (creative coding, from wabi-neu project)
20. **Never set `canvas.width`/`canvas.height` inside rAF**: Every assignment destroys and reallocates the backing store. 60fps × 8MB allocation = GC thrashing. Use `ResizeObserver` for sizing.
21. **Never put framer-motion values in rAF useEffect deps**: `chapterProgress` changes every scroll tick (~60fps). Putting it in the dependency array tears down and recreates the rAF loop on every frame. Use `useRef` + read `.current` in the loop.
22. **Canvas HiDPI**: Always scale by `window.devicePixelRatio`. Set `canvas.width = w * dpr; canvas.height = h * dpr; ctx.scale(dpr, dpr)`. Without it, Retina displays show blurry particles.
23. **Module-level state survives HMR but breaks tests**: `let particles = []` at module scope persists across hot reloads but leaks between vitest test cases. Use resetters or closure-based state.
24. **Never use string-replace for color manipulation**: `color.replace('rgb', 'rgba').replace(')', ',0.5)')` breaks on `rgba(...)` input → produces `rgbargba(...)`. Use regex parsing or a proper color library.
25. **rAF dt clamping**: Always `Math.min(dt, 0.05)` (50ms cap). Tab-switch away and back produces seconds-long dt spikes that launch particles off-screen.
26. **Always wrap React tree in ErrorBoundary**: A single Canvas 2D exception unmounts the entire tree → white screen. For art pieces this means total visual loss. Add ErrorBoundary at App root.

### Subagent Execution Strategy (from wabi-neu project)
27. **Creative/visual projects → fewer, larger tasks**: Wabi-neu had 18 plan tasks producing ~20 files. Pure subagent execution would be 54+ invocations (implementer + 2 reviewers each). For tightly-coupled creative projects (CSS ↔ components ↔ canvas), prefer inline execution with fewer, larger tasks. Reserve subagent micro-execution for CRUD/SaaS projects with independent features.
28. **Plan content requirements in creative projects**: Text, navigation, and copy ARE implementation for scroll-telling/art pieces. The plan MUST include content tasks. Don't treat "文案" as separate from code.

## Server Stack (recommended)
- **Frontend hosting**: Vercel (managed) or Nginx on VPS ($4/mo)
- **Backend**: Hono (fastest, edge-native) or Fastify (high-perf Node)
- **Database**: SQLite+WAL (small) or PostgreSQL/Supabase (scaling)
- **CI/CD**: GitHub Actions
- **Container**: Docker + docker-compose
