# React Full-Stack Pipeline v2.0

Complete React development lifecycle: brainstorming → worktrees → plan → subagent-dev → TDD → code-review → deploy → backend.

## Skills (20 total)

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

### React Domain
| Skill | When |
|-------|------|
| `react-pipeline:react-tool` | 写 React 代码 |
| `react-pipeline:train-repo` | 喂 GitHub 链接训练知识库 |
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

## Agents (6 types)
- **react-implementer** — Execute single task from plan (runs in parallel groups when tasks are independent)
- **react-spec-reviewer** — Verify impl matches spec
- **react-code-reviewer** — Code quality review
- **react-trainer** — Train GitHub repos into knowledge base
- **react-deployer** — Deploy and configure servers
- **react-backend-engineer** — Build backend APIs

### Parallel Execution
- Brainstorming: batches all 4 discovery questions into 1 message (saves ~3 round-trips)
- Subagent-dev: Mode A (parallel) when plan has `parallel_group` fields — dispatches N agents simultaneously
- Subagent-dev: Mode B (sequential) when plan has no `parallel_group` — identical to original behavior
- Expected speedup: ~53% faster execution (backend + frontend tasks run concurrently)

## Knowledge Base
- `knowledge/registry.json` — Repository index (26 trained, 13 categories)
- `knowledge/repos/<category>/<slug>/` — Structured knowledge (api.md + patterns.md)
- Builtin: animal-island-ui (17 components), react-bits (110+ animations)
- Trained: 26 repos across 13 categories (shineout, beeshell, datav, shadcn-ui, radix-primitives, react-hook-form, zustand, ahooks, tanstack-table, dnd-kit, tanstack-query, react-router, framer-motion, swr, downshift, react-aria, jotai, redux-toolkit, mantine, nextui, sonner, recharts, react-use, usehooks-ts, rn-guide, datav-react)

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

### Tool Environment
8. **Tab indentation breaks Edit tool**: Use spaces in `.ts` files. The Edit tool string matcher fails on tab-indented code.
9. **Complex TypeScript generics break esbuild**: Simplify deeply nested generic types. esbuild's parser can fail on complex `ReturnType<...>` chains.
10. **Windows PowerShell**: `$pid` is reserved. `nohup` doesn't exist. Use `Start-Process` for background processes. `&&` not available — use `; if ($?) { }`.

### Backend Security (pre-deploy checklist)
11. **JWT secret**: Never hardcode fallback secrets. Require `JWT_SECRET` env var or refuse to start.
12. **Rate limiting**: Apply to `/api/auth/login` and `/api/auth/register` before production.
13. **LIKE wildcard sanitization**: Escape `%` and `_` in user-supplied search strings before `LIKE` queries.

## Server Stack (recommended)
- **Frontend hosting**: Vercel (managed) or Nginx on VPS ($4/mo)
- **Backend**: Hono (fastest, edge-native) or Fastify (high-perf Node)
- **Database**: SQLite+WAL (small) or PostgreSQL/Supabase (scaling)
- **CI/CD**: GitHub Actions
- **Container**: Docker + docker-compose
