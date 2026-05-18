# Design Taste Framework — taste-skill

## What Is "Good Taste" According to taste-skill?

Taste Skill defines "good taste" as the **active rejection of AI-default generic patterns** in favor of intentional, art-directed, premium visual decisions. It is a framework purpose-built to override the statistical biases that cause LLMs to produce uniform, boilerplate-looking interfaces. The core philosophy: **every design decision must be a choice, not a default**.

Good taste is measured by what the skill calls the **"Anti-Slop" standard** — the systematic elimination of generic AI signatures from frontend output. A design has taste when it looks like a human designer made deliberate choices about typography, spacing, color, motion, and layout rather than falling back on the most statistically probable design patterns in an LLM's training distribution.

## The "Slop" Definition

"Slop" is the term taste-skill uses for AI-generated design output that exhibits recognizable machine fingerprints. Slop is characterized by:

- **Statistical convergence:** The LLM picks the most common patterns from its training data (centered layouts, Inter font, purple-blue gradients, 3-card feature rows)
- **Lack of intentionality:** Design elements exist because the model defaulted to them, not because a designer chose them
- **Uniform emphasis:** Everything looks equally important; no hierarchy through scale, color, or whitespace
- **Boilerplate composition:** Repeated templates across sections, cloned left-text/right-image blocks, identical card grids
- **Missing interaction states:** Static "happy path" only — no loading, empty, error, or active states
- **Lazy copy:** AI cliches like "Elevate", "Seamless", "Next-Gen", generic names like "John Doe" or "Acme Corp"

## The Taste Quality Bar

The skill enforces a quality bar equivalent to **"Awwwards-level"** or **"$150k agency build"** output. Design must feel:

- **Premium:** Not template-level. Intentional materiality, refined surfaces, bespoke typography
- **Art-directed:** Every element has a reason for being there
- **Memorable:** Visually distinctive, not another generic SaaS page
- **Structured:** Clear hierarchy, readable, analyzable
- **Implementation-friendly:** Designed so a developer can faithfully reproduce it in code
- **Breathable:** Generous whitespace, never cramped or over-packed

## The Three Tuning Dials

Taste-skill uses three 1-10 dials that control global design behavior:

| Dial | 1 (Low) | 4-7 (Medium) | 8-10 (High) |
|------|---------|-------------|------------|
| **DESIGN_VARIANCE** | Predictable symmetry, flexbox `justify-center`, 12-column grids, equal padding | Offset layouts, overlapping elements, mixed aspect ratios, left-aligned headers | Masonry layouts, fractional CSS grid units, massive empty zones (`padding-left: 20vw`) |
| **MOTION_INTENSITY** | Static, CSS `:hover` only | Fluid CSS (`cubic-bezier(0.16, 1, 0.3, 1)`), staggered load-in cascades | Complex scroll-triggered reveals, parallax, Framer Motion hooks, scroll-linked animation |
| **VISUAL_DENSITY** | Art Gallery Mode — huge whitespace, expensive/clean feel | Normal app spacing | Cockpit Mode — tiny padding, 1px line separators, no card boxes, monospace numbers |

**Default baseline:** Variance 8, Motion 6, Density 4

## Core Design Principles

### 1. Deterministic Typography
Typography is a primary design material, not filler. Every font choice must be deliberate. The skill bans Inter font (the most common AI default) and enforces premium alternatives: Geist, Outfit, Cabinet Grotesk, Satoshi. Headlines use tight tracking and controlled scale — hierarchy through weight and color, not just massive size. Body text is capped at 65 characters per line with relaxed leading.

### 2. Color Calibration
Maximum 1 accent color. Saturation stays below 80%. The "AI Purple/Blue Neon" aesthetic is strictly banned — this pattern is so common in AI output that the skill has named it "THE LILA BAN." Pure black (#000000) is never used; off-black, zinc-950, or charcoal replaces it. One palette for the entire project — no mixing warm and cool grays.

### 3. Layout Diversification
Centered hero/H1 sections are banned when layout variance exceeds 4. Instead: split screen (50/50), left-aligned content with right-aligned asset, asymmetric whitespace structures. Three-column equal card feature rows are banned — replaced with 2-column zig-zag, asymmetric grids, or horizontal scrolling. CSS Grid over complex flexbox percentage math.

### 4. Materiality and Surface Quality
Cards are used only when elevation communicates genuine hierarchy, not as default containers. Shadows are tinted to the background hue, not generic black. For high-density layouts, cards are replaced entirely with `border-t`, `divide-y`, or purely negative space.

### 5. Comprehensive Interaction States
Every component must include: loading state (skeleton loaders matching layout shape, not circular spinners), empty state (beautifully composed guidance), error state (inline, clear messages), and tactile active feedback (physical press simulation with `translateY(-1px)` or `scale(0.98)`).

### 6. Performance-Conscious Animation
All animation uses GPU-compositable properties exclusively: `transform` and `opacity`. Never animate `top`, `left`, `width`, `height`. Grain and noise filters only on fixed, pointer-event-none pseudo-elements. Backdrop-blur only on fixed or sticky elements. Magnetic hover effects use Framer Motion's `useMotionValue` and `useTransform` — never React `useState`.

### 7. Content Authenticity
Names, numbers, company names, and copy must feel real and organic. "John Doe", "99.99%", "Acme Corp", and "Elevate your experience" are all banned patterns. Use realistic-sounding diverse names, messy data (47.2% not 50%), contextual brand names, and concrete verbs instead of marketing buzzwords.

## The Research Foundation

Taste-skill's anti-slop philosophy is grounded in documented LLM behavioral research:

- **Training Data Bias:** LLMs learn placeholder patterns from Stack Overflow, tutorials, and documentation that normalize truncated/incomplete output
- **RLHF Brevity Bias:** Model alignment training rewards short, confident summaries over exhaustive analysis
- **Cognitive Shortcuts (LazyBench):** Models reduce computational effort on tasks they perceive as straightforward
- **Seasonal Behavior:** Models produce measurably shorter outputs during periods corresponding to holiday seasons in training data
- **Stopping Pressure:** Aggressive calibration of output termination causes skipped sections, truncated code, and "let me know if you want me to continue" patterns

The skill's full-output enforcement, completeness requirements, and anti-truncation rules are direct countermeasures to these documented LLM behaviors.

## How the Framework Judges Design

The skill provides a "Final Pre-Flight Check" — a 7-item evaluation matrix applied before any output:
1. Is global state used appropriately (deep prop-drilling avoidance, not arbitrarily)?
2. Is mobile layout collapse guaranteed for high-variance designs?
3. Do full-height sections safely use `min-h-[100dvh]` instead of bugged `h-screen`?
4. Do `useEffect` animations contain strict cleanup functions?
5. Are empty, loading, and error states provided?
6. Are cards omitted in favor of spacing where possible?
7. Are CPU-heavy perpetual animations strictly isolated in their own Client Components?

The gpt-taste variant adds an 8-point `<design_plan>` verification: Python-simulated randomization proof, AIDA structure confirmation, Hero math verification (container width to guarantee 2-3 line max), Bento density verification (no empty cells, `grid-flow-dense` applied), label sweep (no meta-labels), and button contrast check.

## The Skill Variants

The framework is distributed across 10 specialized skills, each tuned for different contexts:

| Skill | Purpose | Key Distinction |
|-------|---------|-----------------|
| **taste-skill** | General default | Balanced anti-slop for all frontend work |
| **gpt-tasteskill** | Stricter GPT/Codex variant | Higher layout variance, Python randomization, stronger GSAP direction |
| **soft-skill** | High-end visual design | Softer contrast, double-bezel architecture, spring physics, $150k agency quality |
| **minimalist-skill** | Editorial product UI | Warm monochrome, flat bento, Notion/Linear vibes, no gradients, no shadows |
| **brutalist-skill** | Industrial/mechanical UI | Swiss type, rigid grids, CRT/telemetry aesthetics, no border-radius |
| **image-to-code-skill** | Image-first pipeline | Generate references -> analyze -> code, anti-drift enforcement |
| **redesign-skill** | Existing project upgrades | Audit-first approach, works with existing stack, fix priority order |
| **output-skill** | Full output enforcement | Bans placeholder patterns, enforces complete code generation |
| **stitch-skill** | Google Stitch compatibility | Semantic DESIGN.md export format, natural-language design rules |
| **imagegen-frontend-web** | Image reference generation | One image per section, composition variety enforcement |
