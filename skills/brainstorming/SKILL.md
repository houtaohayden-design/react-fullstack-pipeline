---
name: react-pipeline:brainstorming
description: Use when building or creating a React application, component, or feature — before any code. Explores requirements, user intent, and design approach.
---

# Brainstorming for React Projects

## Core Principle
Understand WHAT the user wants before thinking about HOW. Present ALL design options in ONE message — never incremental. Every visual choice gets a CSS-rendered preview card.

## When to Use
- "build a React app/dashboard/website"
- "create a component/feature"
- "add functionality to existing app"
- Any creative work before implementation

## Knowledge Base Inventory (complete — for LLM reference)

Before presenting to the user, know what's available:

### Design Systems & Visual Direction (23 files)
| File | Content |
|------|---------|
| `enhanced-animal-island.md` | 动森温馨增强 — cozy warm UI with animal-island-ui + react-bits + framer-motion |
| `shadcn-professional.md` | 专业现代 — shadcn/ui (Radix) + Tailwind v4 + framer-motion, WCAG AA |
| `glassmorphism-hybrid.md` | 玻璃拟态混合 — WebGL backgrounds + frosted glass panels + react-bits |
| `artistic-styles.md` | Styles 1-8: Neo-Brutalism, Wabi-Sabi, Neumorphism, Synthwave, Art Deco, Claymorphism, Dark Academia, Liquid Glass |
| `artistic-styles-2.md` | Styles 9-16: Scandinavian, Cyberpunk, Vaporwave, Memphis, Bauhaus, Paper Craft, Pop Art, Steampunk |
| `typography-layout.md` | 12 font pairings + 8 layout systems + fluid type scales |
| `color-theory.md` | Color spaces (HEX/RGB/HSL/OKLCH), 6 harmony rules, 3-layer palette architecture |
| `motion-design.md` | Disney's 12 principles for UI, easing curves, spring physics, scroll-driven animation |
| `text-design.md` | Kinetic typography, gradient text, 3D CSS text, typewriter/scramble effects |
| `ui-patterns.md` | 60+ premium UI patterns: cards, nav, loading, transitions, micro-interactions |
| `landing-patterns.md` | 8 hero patterns, feature sections, pricing, CTA, FAQ, footer |
| `background-patterns.md` | 7 CSS-only patterns, noise/grain, mesh gradients, animated backgrounds |
| `button-design.md` | 8 button variants, 5 sizes, loading, icon, split, FAB |
| `form-design.md` | Input anatomy, 4 style variants, validation, multi-step wizard |
| `feedback-patterns.md` | Toast system, progress, tooltip, popover, copy feedback |
| `navigation-design.md` | 7 nav types, command palette, sidebar, mobile patterns |
| `modal-dialog-design.md` | Modal types, size presets, focus traps, animations |
| `data-viz-design.md` | 12-color palette, chart theme, 4 dashboard layouts, KPI cards |
| `empty-states-design.md` | State matrix, skeleton, error, offline, permission gates |
| `iconography-design.md` | Icon sizing, library comparison, animated icons, favicon |
| `search-experience.md` | Search bar variants, autocomplete, faceted, debounced |
| `responsive-patterns.md` | Breakpoints, container queries, fluid type, mobile-first |
| `onboarding-patterns.md` | 8 onboarding patterns, preference picker, activation metrics |

### Website Design Inspirations (20 sites — extracted live design systems)
`knowledge/websites/<slug>/design-system.md`. Each contains: colors, typography, spacing, components, motion, interaction patterns.

| # | Site | Style Signature |
|---|------|----------------|
| 1 | Apple | SF Pro typography, full-bleed product photos, 96-120px hero, single blue accent, cinematic scroll |
| 2 | Stripe | Sohne Variable 300-weight, indigo #533afd, dual-layer blue-tinted shadows, time-of-day gradients |
| 3 | Linear | Dark precision, monochromatic near-black, single indigo #7170ff, border-based depth, Inter Variable |
| 4 | Vercel | Black canvas #000, Geist font, triangular/hexagonal motifs, alternating section bg rhythm |
| 5 | GitHub | Dark-first #0d1117, 12-theme accessibility, Mona Sans VF, CSS-only animation, single blue #1f6feb |
| 6 | Supabase | Dark #121212, emerald green #3ECF8E, Circular font, HSL tokens, CSS-only animation |
| 7 | Notion | 2890+ CSS properties, 4-tier tokens, 11 palettes, 56 semantic typography variants, CSS @layer |
| 8 | Figma | 40-column grid, ABC Whyte Plus Variable, 20+ section accents, 150ms micro-interactions |
| 9 | Framer | GT Walsheim, 75+ CSS tokens, Framer Motion, glass surfaces, 30+ font stack |
| 10 | Arc | Multicolor gradient spectrum, off-white base, Instrument Sans + Inter, warm modernism |
| 11 | Raycast | Dark #07080a, single blue #56c2ff, CSS-only 27 keyframes, BEM CSS Modules, 8px grid |
| 12 | Airbnb | Rausch coral #FF385C, Airbnb Cereal VF, spring physics, atomic CSS 700+ classes, glass nav |
| 13 | DJI | Dark premium, bilingual zh-CN/EN, 2px radius precision, 300ms motion, Swiper carousels |
| 14 | Xiaomi | Full-black + orange #ff6900, MiSans font, stacked carousels, viewport-scaled typography |
| 15 | Tailwind CSS | Sky-blue accent, transparency-based depth, 4-font CLS strategy, 350ms transitions |
| 16 | Algolia | Dark SaaS, blue-purple gradient accent, Sora + Inter, video-rich, hover-state discovery |
| 17 | Spotify | Dark #121212, Encore Design System 197 tokens, SpotifyMixUI, single green #1ed760 |
| 18 | Hermès | Warm cream #fcf7f1, orange accent, EB Garamond italic, zero border-radius luxury |
| 19 | Porsche | Dark-first luxury, Porsche Next typeface, full-bleed video, fluid clamp() system |
| 20 | Rimowa | German luxury minimalism, aluminum-groove motif, monochromatic, Swiss typography |

### Design Skills & Methodology (4 frameworks)
| # | Skill | What It Provides |
|---|-------|-----------------|
| 1 | gstack | 80-item design audit checklist, SAFE/RISK framework, AI slop detection, browser QA |
| 2 | impeccable | 25 anti-pattern rules, OKLCH color, category-reflex check, 6 absolute design bans |
| 3 | taste-skill | 108 anti-patterns, 13 approved styles, spring physics mandate, full interaction cycle |
| 4 | ui-ux-pro-max | 67 UI styles, 161 color palettes, 57 font pairings, 99 UX guidelines, 34 landing patterns |

### Trained Repos (63 entries — implementation phase, not visual selection)
`knowledge/registry.json`. Categories: ui-libraries (11), headless (7), data-fetching (2), hooks-utilities (3), animation (5), routing (1), state-management (2), charts (1), backend (4), database (1), auth (1), css-in-js (2), design-inspiration (20), design-skills (4).

These are presented in **Step 3** when matching libraries to the chosen design approach — NOT during visual selection.

---

## Workflow

### Step 1: Understand Requirements (1-2 rounds)

**Round 1 — Batch ALL discovery questions + Visual Direction Catalog in ONE message.**

CRITICAL: Never split discovery into multiple messages. Never present styles incrementally. ALL visual options MUST appear in this single Round 1 response.

#### Discovery Questions (ask all 5 together):

1. **Core Functionality** — What does the app/component DO? What actions can users take? Primary workflow?
2. **User Personas** — Who uses it? (role, skill level, device: desktop/mobile/both)
3. **Constraints** — Bundle size target? Accessibility (WCAG level)? Browser support? Mobile responsive? Performance goals?
4. **Design Reference** — Figma link, mockup, existing app to emulate, or "build from scratch"? If they mention a brand (e.g., "像 Apple 一样"), reference the corresponding website design system from Part E.
5. **Image & Media Needs** — Will the project need images, videos, or illustrations? We have 7 integrated image sources — see Part F for the full catalog.

#### 6. Resources Catalog (REQUIRED — present immediately after questions 1-5)

Present ALL 6 parts below in ONE message. This is NOT optional. Every project needs visual direction + knows what resources are available.

---

**Part A: Base Design System (pick 1 of 3)**

Present all 3 systems as visual preview cards. Each card gets a CSS code block showing the system's signature UI element. Source: `knowledge/design-systems/enhanced-animal-island.md`, `shadcn-professional.md`, `glassmorphism-hybrid.md`.

For each system show:
- Name + tagline (bold header)
- Color palette (5 hex values as inline code blocks)
- Signature CSS snippet (the most iconic card/button for that system, ~12 lines)
- Typography pairing (heading + body font names)
- Best-for tag (one line)

Format:
```
### A: 动森温馨增强 — "Your cozy corner of the internet"
Colors: `#19c8b9` `#725d42` `#f8f8f0` `#fffdf7` `#f4a261`
Typography: Playfair Display / Zen Maru Gothic + Inter
```css
.cozy-card {
  background: #fffdf7;
  border-radius: 24px;
  box-shadow: 0 4px 16px rgba(114,93,66,0.08);
  border: 1px solid rgba(25,200,185,0.15);
}
```
Best for: Recipe/food, personal blogs, lifestyle, family/kids

### B: 专业现代 (shadcn/ui) — "Ship quality UI, fast"
Colors: `#0f172a` `#3b82f6` `#ffffff` `#f8fafc` `#64748b`
Typography: Space Grotesk + DM Sans
```css
.shadcn-card {
  background: hsl(var(--card));
  border: 1px solid hsl(var(--border));
  border-radius: var(--radius);
  box-shadow: var(--shadow-sm);
}
```
Best for: SaaS, dashboards, enterprise, admin panels

### C: 玻璃拟态混合 — "The future feels transparent"
Colors: `#0a0e27` `rgba(255,255,255,0.05)` `rgba(255,255,255,0.15)` `#60a5fa` `rgba(255,255,255,0.95)`
Typography: Clash Display + Satoshi
```css
.glass-surface {
  background: rgba(255,255,255,0.05);
  backdrop-filter: blur(20px) saturate(180%);
  border: 1px solid rgba(255,255,255,0.15);
  border-radius: 24px;
}
```
Best for: Creative portfolios, luxury brands, tech showcases
```

---

**Part B: Artistic Styles (16 options — Quick Reference Matrix)**

Present ALL 16 artistic styles in a single compact table. Source: `knowledge/design-systems/artistic-styles.md` + `artistic-styles-2.md`.

IMPORTANT: This table MUST include all 16 rows. NEVER present only partial subsets. Display as:

| # | Style | Key Visual | Color Mood | Typography | Best DS |
|---|-------|-----------|------------|------------|---------|
| 1 | Neo-Brutalism | 4px black borders, hard shadows | `#ff6b35` `#004ecc` `#ffd700` `#1a1a1a` `#fffdf7` | Neo-Brutalist Bold | B |
| 2 | Wabi-Sabi Zen | Rice paper, rough textures, wood | `#8b7355` `#f5f0e8` `#3d3929` `#ede4d3` `#c8a882` | Japanese Warmth | A |
| 3 | Soft Neumorphism | Extruded shadows, no borders | `#7c9eb2` `#e8edf2` `#3a4a5a` `#a8c4d4` `#f0c8a0` | Swiss Modernist | B |
| 4 | Synthwave Retro | Neon glow, grid lines, sunset | `#ff6ac1` `#00f0ff` `#ffd700` `#1a0533` `#0d0221` | Glass Futurism | C |
| 5 | Art Deco | Gold rules, symmetry, geometric | `#c9a84c` `#faf8f2` `#1a1a2e` `#8b7355` `#e8d5b7` | Art Deco Geometric | C |
| 6 | Claymorphism | 32px radius, 3D shadows, chunky | `#ff8c6b` `#f5f0eb` `#7ec8a4` `#4a3728` `#ffd700` | Nature Organic | A |
| 7 | Dark Academia | Candlelight, aged leather, gold | `#c9a84c` `#1a1410` `#e8dcc8` `#2a2218` `#8b4513` | Serif Authority | B |
| 8 | Liquid Glass | Iridescent, morphing blobs, 40px blur | `#a78bfa` `#60a5fa` `#34d399` `#060610` | Glass Futurism | C |
| 9 | Scandinavian | Light birch, whitespace, hygge | `#7c9a8e` `#fafaf8` `#e8a87c` `#f5f3ef` `#2d2a26` | Swiss Modernist | A/B |
| 10 | Cyberpunk | Neon rain, dystopian grids | `#00ff41` `#ff003c` `#ffff00` `#0d0d0d` | Mono Technical | C |
| 11 | Vaporwave | Pastels, marble statues, 3D grid | `#ff71ce` `#01cdfe` `#05ffa1` `#b967ff` | Glass Futurism | C |
| 12 | Memphis | Squiggles, triangles, wild patterns | `#ff6b6b` `#4ecdc4` `#ffe66d` `#292f36` | Neo-Brutalist Bold | B |
| 13 | Bauhaus | Geometric primitives, primary colors | `#e03a3e` `#f5c400` `#0057b8` `#f5f0e0` `#1a1a1a` | Swiss Modernist | B |
| 14 | Paper Craft | Layered cut-out, drop shadows | `#faf3e0` `#e8d5b7` `#8b7355` `#c9a84c` | Nature Organic | A |
| 15 | Pop Art | Ben-Day dots, halftones, comic | `#ff0000` `#ffd700` `#0099ff` `#ffffff` | Neo-Brutalist Bold | B |
| 16 | Steampunk | Brass, copper, gears, sepia | `#8b6914` `#5c3a1e` `#d4a853` `#2a1a0a` | Serif Authority | C |

**Artistic styles layer ON TOP of the base design system.** They are optional — you can use the base system alone. Reply with any style number (1-16) for its full CSS + TSX component code.

---

**Part C: Typography Pairings (12 options — quick reference)**

Source: `knowledge/design-systems/typography-layout.md`. Present as compact table:

| # | Pairing | Heading Font | Body Font | Best For |
|---|---------|-------------|-----------|----------|
| 1 | Editorial Luxury | Playfair Display | Inter | Recipe detail, food blogs, lifestyle |
| 2 | Swiss Modernist | Space Grotesk | DM Sans | Dashboards, SaaS, data displays |
| 3 | Glass Futurism | Clash Display | Satoshi | Hero sections, luxury, creative |
| 4 | Japanese Warmth | Zen Maru Gothic | Noto Sans JP | Cozy, Japanese-flavored content |
| 5 | Neo-Brutalist Bold | Bebas Neue | Inter | Hero CTAs, impact statements |
| 6 | Serif Authority | Cormorant Garamond | Lato | Science, authoritative, journalism |
| 7 | Handwritten Artisanal | Caveat | Quicksand | Personal journals, craft brands |
| 8 | Mono Technical | Geist Mono | Inter | Developer tools, CLI docs, calculators |
| 9 | Art Deco Geometric | Poiret One | Josefin Sans | Luxury, vintage, premium events |
| 10 | Editorial Newspaper | Merriweather | Source Sans 3 | News, health journalism, research |
| 11 | Fashion Runway | Bodoni Moda | Montserrat | High-end, fashion, luxury dining |
| 12 | Nature Organic | Fraunces | Nunito Sans | Organic, soft, family-friendly |

---

**Part D: Layout Systems (8 options — quick reference)**

| # | Layout | Structure | Best For |
|---|--------|----------|----------|
| 1 | Editorial Magazine | Full-bleed images, pull quotes, asymmetric columns | Content-rich, storytelling |
| 2 | Swiss Grid | 12-column strict, mathematical precision | Data-heavy, dashboards |
| 3 | Minimal Luxury | Centered single column, generous whitespace | Premium brands, focused content |
| 4 | Bento Grid | Rounded cards of varying sizes, Apple-style | Dashboard overviews, portfolios |
| 5 | Staggered Asymmetric | Alternating left-right blocks, dramatic offsets | Creative portfolios, luxury |
| 6 | Masonry Cascade | Variable-height flowing grid | Image galleries, inspiration |
| 7 | Full-Screen Immersive | One section per viewport, scroll-driven | Landing pages, product stories |
| 8 | Timeline Narrative | Horizontal/vertical timeline flow | Process, history, journey |

---

**Part E: Website Design Inspirations (20 live design systems — compact list)**

We have extracted complete design systems from these 20 production websites. Each has: colors, typography, spacing, components, motion patterns. If the user mentions a brand as reference, immediately suggest the corresponding entry.

```
1. Apple        — SF Pro, minimal, full-bleed product, single blue accent
2. Stripe       — Sohne Variable 300w, indigo #533afd, dual-layer shadows
3. Linear       — Dark precision, single indigo, border-based depth
4. Vercel       — Geist font, black canvas, geometric motifs
5. GitHub       — Mona Sans VF, 12-theme accessibility, CSS-only animation
6. Supabase     — Dark, emerald green #3ECF8E, HSL token architecture
7. Notion       — 2890+ CSS properties, 4-tier tokens, 56 typography variants
8. Figma        — 40-column grid, ABC Whyte Plus, 150ms interactions
9. Framer       — GT Walsheim, 75+ tokens, glass surfaces, Framer Motion
10. Arc         — Multicolor gradient, off-white, Instrument Sans + Inter
11. Raycast     — Dark #07080a, single blue, 27 CSS keyframes, 8px grid
12. Airbnb      — Coral #FF385C, Cereal VF font, spring physics, atomic CSS
13. DJI         — Dark premium, bilingual zh-CN/EN, 2px radius, Swiper
14. Xiaomi      — Full-black, orange #ff6900, MiSans, viewport-scaled type
15. Tailwind CSS — Sky-blue, transparency depth, 4-font CLS strategy
16. Algolia     — Dark SaaS, blue-purple gradient, Sora + Inter, video-rich
17. Spotify     — Dark #121212, Encore Design System, SpotifyMixUI font
18. Hermès      — Cream #fcf7f1, orange accent, EB Garamond italic, zero radius
19. Porsche     — Dark luxury, Porsche Next typeface, fluid clamp(), video hero
20. Rimowa      — German luxury, aluminum-groove motif, monochromatic
```

Reply with any brand name ("Apple", "Stripe", etc.) to see their full extracted design system (color palette, typography tokens, component patterns, motion specs).

---

**Part F: Image & Media Sources (7 free sources available — proactive)**

We have these image/video sources integrated and ready to use. Present this compact table so the user knows what's available:

| # | Source | Best For | Auth |
|---|--------|----------|------|
| 1 | **影视飓风** | 专业摄影+4K视频素材（自然风光/动物/城市/航拍） | 无需 key |
| 2 | Unsplash | 高质量艺术摄影，Hero 大图 | 免费 5000 req/h |
| 3 | Pexels | 通用配图，多样性最高 | 免费 20000 req/m |
| 4 | Pixabay | 照片+矢量图+视频 | 免费无限制 |
| 5 | Lorem Picsum | 开发占位图 | 直接 URL |
| 6 | unDraw | 开源 SVG 插画（空状态/Onboarding） | MIT 开源 |
| 7 | DiceBear / UI Avatars | 头像生成 | 直接 URL |

Ask the user:
- "Will you need images/videos in this project? If so, which source fits best?"
- "影视飓风 has professional Chinese-market photography and 4K video — ideal for content-heavy sites."
- "For dev placeholders, Lorem Picsum needs zero setup."

Detailed API docs and React hooks for all sources → `knowledge/image-sources.md`.

---

**After presenting the full catalog**, ask the user:
- "Which base design system fits your project? (A: 动森 / B: shadcn / C: 玻璃拟态)"
- "Would you like to layer an artistic style? (reply 1-16, or 'none')"
- "Any website design inspiration you'd like to reference? (reply brand name)"
- "Which typography pairing and layout system feel right?"
- "Which image source would you like to use? (reply 1-7, or 'none' — we'll set it up during implementation)"

**Round 2 (only if needed)** — If any answer from Round 1 needs clarification, batch ALL follow-ups into ONE message. Never ask one at a time.

### Step 2: Propose Technical Approach (2-3 options)

Present approaches as recommendations. The UI style (from Round 1) determines the design system; the tech approach determines the stack.

| Approach | Stack | Pros | Cons |
|----------|-------|------|------|
| A: Lightweight | Vite + Tailwind + lightweight libs | Fast, small bundle | Less pre-built |
| B: Full-featured | Next.js + Component library | Rich ecosystem | Larger, more complex |
| C: Enterprise | Shineout + zustand + TanStack Query | Enterprise-ready | Learning curve |

**UI style selection is independent from tech stack.** Any base design system (A/B/C) can layer onto any tech approach. Any artistic style (1-16) can layer onto any base system. Any website inspiration can inform any design system.

### Step 3: Check Knowledge Base

**REQUIRED:** Check `knowledge/registry.json` (63 trained repos across 16 categories) BEFORE proposing custom solutions. Present matching repos from the relevant category:

- Need UI components? → `ui-libraries/` (shadcn-ui, mantine, nextui, shineout, etc.)
- Need forms? → `headless/react-hook-form` + `backend/zod`
- Need state? → `headless/zustand` or `state-management/jotai`
- Need data fetching? → `data-fetching/tanstack-query` or `swr`
- Need animation? → `animation/framer-motion` + `animation/react-bits`
- Need routing? → `routing/react-router`
- Need charts? → `charts/recharts`
- Need icons? → `ui-libraries/lucide-react`
- Need backend? → `backend/hono` or `backend/nestjs`
- Need auth? → `auth/nextauth`
- Need database? → `database/drizzle-orm`
- Need CSS-in-JS? → `css-in-js/vanilla-extract` or `css-in-js/tailwindcss`
- Need design methodology? → `design-skills/` (gstack, impeccable, taste-skill, ui-ux-pro-max)

### Step 4: Write Design Document

Save to `knowledge/specs/<project-name>.md`:
```markdown
# Project: <name>

## Requirements
- Core function:
- Users:
- Constraints:

## Visual Direction
- Base Design System: <A: 动森增强 / B: shadcn专业 / C: 玻璃拟态>
- Artistic Style (optional): <#: Style Name>
- Typography: <Pairing # and name>
- Layout: <Layout # and name>
- Website Inspiration (optional): <Brand name>

## Approach: <chosen>
- Stack: <list>
- Key libraries: <from knowledge base>
- Component tree: <outline>

## Routes (if applicable)
/ → <Page>
  /feature → <SubPage>

## Data Flow
- State: zustand / TanStack Query
- API: <backend>
```

### Step 5: Get Approval

Present design doc summary. User must approve before moving to `react-pipeline:writing-plans`.

## Next Step

After approval: Set up isolation with `react-pipeline:git-worktrees`, then **REQUIRED SUB-SKILL:** Use `react-pipeline:writing-plans` to create implementation plan.

## Anti-Patterns (CRITICAL)

| NEVER | ALWAYS |
|-------|--------|
| Present 3 styles, then 4 more, then 8 more across multiple rounds | Present ALL 16 styles + 3 systems + 12 fonts + 8 layouts + 20 websites in ONE message |
| Show text-only descriptions without CSS | Every base system card gets a signature CSS snippet |
| Ask "what style do you want?" without showing options | Show the complete visual catalog first |
| Present fonts/layouts/websites as separate questions in separate rounds | Include them as Part C/D/E in the same Round 1 catalog |
| Say "see knowledge/design-systems/artistic-styles.md" without showing content | Show the full 16-row reference matrix inline |
| Hide artistic styles behind a "would you like to see more?" gate | Present them upfront in the catalog |
| Ignore website design inspirations as a resource | Present the 20-site list; offer deep-dive on any brand mentioned |
| Present trained repos as part of visual selection | Repos are for Step 3 (implementation), not visual direction |
| Wait for user to ask "do you have image sources?" | Proactively present Part F (7 image sources) in Round 1 — never hide available resources |
| Only mention Unsplash, forget about 影视飓风/unDraw/DiceBear | Present ALL 7 sources in Part F table |
