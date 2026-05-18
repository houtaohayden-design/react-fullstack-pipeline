# Design Consultation -- Building a Design System from Scratch

## Source
Derived from `design-consultation/SKILL.md` in the gstack repository (github.com/garrytan/gstack).

---

## Overview

The design-consultation skill builds a complete design system from scratch through a structured 6-phase conversation: product context gathering, competitive research, a coherent full-system proposal with safe/risk breakdown, drill-down adjustment, visual preview (AI mockups or HTML), and DESIGN.md generation.

The agent posture is "design consultant, not form wizard" -- opinionated but not dogmatic, explaining reasoning and welcoming pushback.

---

## Phase 0: Pre-Checks and Preparation

### Preexisting DESIGN.md
If DESIGN.md already exists, read it and ask: update, start fresh, or cancel. Never overwrite without explicit instruction.

### Product Context Auto-Gathering
Before asking the user anything, automatically gather context from:
- README.md (first 50 lines)
- package.json (first 20 lines)
- Source directory structure (src/, app/, pages/, components/)
- Office-hours output (product brainstorming artifacts if they exist)
- Taste profile from prior sessions (persistent design preferences)

If the codebase is empty and purpose is unclear, suggest running office-hours first.

### Browse and Design Binary Setup
Two progressive enhancements to check availability for:
- **Browse binary:** enables visual competitive research via headless Chromium
- **Design binary:** enables AI mockup generation instead of HTML wireframes

Both are optional. The skill works without them using WebSearch and built-in design knowledge.

---

## Phase 1: Product Context

Ask a single comprehensive question covering:

1. CONFIRM: What the product is, who it's for, what space/industry
2. CLARIFY: What project type (web app, dashboard, marketing site, editorial, internal tool)
3. OPTION: Whether to research competitive landscape or work from design knowledge
4. REMIND: "At any point you can drop into chat -- this is a conversation, not a rigid form"

**Memorable-thing forcing question:** "What's the one thing you want someone to remember after they see this product for the first time?"

This answer becomes the anchor for all subsequent design decisions. It could be a feeling, a visual element, a claim, or a posture.

### Taste Profile Integration
If a persistent taste profile exists from prior sessions:
- Summarize top 3 approved entries per dimension (fonts, colors, layouts, aesthetics)
- Bias generation toward demonstrated preferences
- Avoid strong rejections
- If current request contradicts strong signals, flag it explicitly
- Confidence scores decay 5% per week -- recent approvals carry more weight

---

## Phase 2: Competitive Research

Only if the user opted in. Uses a three-layer synthesis:

### Layer 1 (Tried and True)
What design patterns does every product in this category share? These are table stakes -- users expect them.

### Layer 2 (New and Popular)
What are search results and current design discourse saying? What's trending? What new patterns are emerging?

### Layer 3 (First Principles)
Given what we know about THIS product's specific users and positioning -- is there a reason the conventional design approach is wrong? Where should we deliberately break from category norms?

### Research Methods (in order of preference)
1. Browse binary available: visit top 3-5 competitors, take screenshots, snapshot their accessibility trees
2. Browse unavailable: WebSearch for "[category] website design" and "best [industry] web apps"
3. WebSearch unavailable: the agent's built-in design knowledge

### Eureka Check
If Layer 3 reasoning reveals a genuine design insight -- a reason the category's visual language fails THIS product -- name it explicitly: "EUREKA: Every [category] product does X because they assume [assumption]. But this product's users [evidence] -- so we should do Y instead."

---

## Phase 3: The Complete Proposal

The soul of the skill. Propose EVERYTHING as one coherent package with SAFE/RISK breakdown:

### Proposal Structure
```
AESTHETIC: [direction] -- [one-line rationale]
DECORATION: [level] -- [why this pairs with the aesthetic]
LAYOUT: [approach] -- [why this fits the product type]
COLOR: [approach] + proposed palette (hex values) -- [rationale]
TYPOGRAPHY: [3 font recommendations with roles] -- [why these fonts]
SPACING: [base unit + density] -- [rationale]
MOTION: [approach] -- [rationale]

Coherence explanation: [how choices reinforce each other]

SAFE CHOICES (category baseline):
  - [2-3 decisions that match category conventions]

RISKS (where your product gets its own face):
  - [2-3 deliberate departures from convention]
  - For each: what it is, why it works, gain, cost
```

### Design Knowledge Taxonomy

**10 Aesthetic Directions:**
- Brutally Minimal -- Type and whitespace only. No decoration. Modernist.
- Maximalist Chaos -- Dense, layered, pattern-heavy. Y2K meets contemporary.
- Retro-Futuristic -- Vintage tech nostalgia. CRT glow, pixel grids, warm monospace.
- Luxury/Refined -- Serifs, high contrast, generous whitespace, precious metals.
- Playful/Toy-like -- Rounded, bouncy, bold primaries. Approachable and fun.
- Editorial/Magazine -- Strong typographic hierarchy, asymmetric grids, pull quotes.
- Brutalist/Raw -- Exposed structure, system fonts, visible grid, no polish.
- Art Deco -- Geometric precision, metallic accents, symmetry, decorative borders.
- Organic/Natural -- Earth tones, rounded forms, hand-drawn texture, grain.
- Industrial/Utilitarian -- Function-first, data-dense, monospace accents, muted palette.

**Decoration Levels:** minimal (typography does all the work) / intentional (subtle texture, grain) / expressive (full creative direction)

**Layout Approaches:** grid-disciplined / creative-editorial / hybrid

**Color Approaches:** restrained (1 accent + neutrals) / balanced (primary + secondary) / expressive (bold palettes)

**Motion Approaches:** minimal-functional / intentional / expressive

**Font Recommendations by Purpose:**
- Display/Hero: Satoshi, General Sans, Instrument Serif, Fraunces, Clash Grotesk, Cabinet Grotesk
- Body: Instrument Sans, DM Sans, Source Sans 3, Geist, Plus Jakarta Sans, Outfit
- Data/Tables: Geist (tabular-nums), DM Sans (tabular-nums), JetBrains Mono, IBM Plex Mono
- Code: JetBrains Mono, Fira Code, Berkeley Mono, Geist Mono

### Anti-Convergence Directive
Across multiple generations in the same project, VARY light/dark, fonts, and aesthetic directions. Never propose the same choices twice without explicit justification. If the user's prior session used Geist + dark + editorial, propose something different this time.

### Coherence Validation
When the user overrides one section, check if the rest still coheres:
- Brutalist/Minimal aesthetic + expressive motion: flag the mismatch
- Expressive color + restrained decoration: flag the mismatch
- Creative-editorial layout + data-heavy product: flag the mismatch

Always nudge gently, never block. Always accept the user's final choice.

---

## Phase 4: Drill-Downs

When the user wants to adjust a specific section, go deep on that one section:
- **Fonts:** Present 3-5 specific candidates with rationale, explain what each evokes
- **Colors:** Present 2-3 palette options with hex values, explain color theory reasoning
- **Aesthetic:** Walk through which directions fit their product and why
- **Layout/Spacing/Motion:** Present approaches with concrete tradeoffs

Each drill-down is one focused user question. After the user decides, re-check coherence with the rest of the system.

---

## Phase 5: Design System Preview

Two paths depending on whether the AI design binary is available.

### Path A: AI Mockups (DESIGN_READY)
1. Generate N variants (typically 3) of the proposed design applied to realistic product screens
2. Run quality check on each variant via vision model
3. Self-gate: "Would a human designer be embarrassed to put their name on this?" If yes, discard and regenerate
4. Create comparison board with HTTP server for interactive feedback
5. User rates, comments, and submits preferences through the browser interface
6. Extract design tokens from the approved mockup to ground the DESIGN.md in visual reality

### Path B: HTML Preview Page (fallback)
Generate a single self-contained HTML file that:
1. Loads proposed fonts from Google Fonts via `<link>` tags
2. Uses the proposed color palette throughout
3. Shows the product name as hero heading (not Lorem Ipsum)
4. Has font specimen section: each font in its proposed role with real content
5. Has color palette section: swatches with hex values and names, sample UI components
6. Has realistic product mockups: 2-3 page layouts matching the project type (dashboard, marketing, settings, auth)
7. Has light/dark mode toggle via CSS custom properties
8. Is responsive
9. Is polished -- the preview page IS a taste signal for the skill

### Comparison Board and Feedback Loop (Path A)
The comparison board is an interactive browser interface where the user:
- Rates each variant (1-5)
- Leaves per-variant comments
- Provides overall direction feedback
- Can remix elements across variants (e.g., "layout from A, colors from B")
- Submits final choice via a Submit button

The board writes structured feedback JSON with shape: `{ preferred, ratings, comments, overall, regenerated }`. A regeneration loop allows the user to request "more like B", "different approach", or custom remixes.

---

## Phase 6: Write DESIGN.md

Write DESIGN.md to the repo root with this complete structure:

```
# Design System -- [Project Name]

## Product Context
- What this is / Who it's for / Space/industry / Project type

## Aesthetic Direction
- Direction, Decoration level, Mood, Reference sites

## Typography
- Display/Hero, Body, UI/Labels, Data/Tables, Code
- Loading strategy (CDN or self-hosted)
- Scale (modular scale with specific px/rem values)

## Color
- Approach, Primary hex, Secondary hex
- Neutrals (warm/cool grays, range from lightest to darkest)
- Semantic: success, warning, error, info
- Dark mode strategy

## Spacing
- Base unit, Density, Scale

## Layout
- Approach, Grid columns per breakpoint, Max content width
- Border radius hierarchy

## Motion
- Approach, Easing, Duration tokens

## Decisions Log
- Date | Decision | Rationale table
```

### CLAUDE.md Update
Always update CLAUDE.md with a design system reference:
```
## Design System
Always read DESIGN.md before making any visual or UI decisions.
All font choices, colors, spacing, and aesthetic direction are defined there.
Do not deviate without explicit user approval.
In QA mode, flag any code that doesn't match DESIGN.md.
```

### Final Confirmation
List all decisions. Flag any that used agent defaults without explicit user confirmation. The user should know what they're shipping. Offer options: ship it, change something, or start over.
