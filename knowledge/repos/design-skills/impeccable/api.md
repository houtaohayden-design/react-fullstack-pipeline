# Impeccable — Design Methodology Reference

## Overview

Impeccable is a Claude Code skill for design language methodology created by Paul Bakaus. It defines a rigorous, opinionated framework for AI-assisted frontend design that spans websites, landing pages, dashboards, product UI, components, and empty states. The skill operates as a command system (`/impeccable`) with 23 sub-commands covering build, evaluate, refine, enhance, fix, and iterate flows.

## Core Design Philosophy

### The Editorial Mindset
Impeccable treats design as a craft discipline, not a template-filling exercise. Its philosophical stance: **design should look intentional, opinionated, and specific to the product it serves**. The methodology explicitly rejects the "AI slop" aesthetic — the converged visual language of generic AI-generated interfaces (purple gradients, glassmorphism, hero-metric templates, identical card grids).

### Creative North Star
The skill's own site demonstrates its philosophy as "The Editorial Sanctuary" — a warm-paper editorial design with committed serif display typography, a single decisive accent color, flat surfaces at rest, and asymmetric magazine-scale spacing. The aesthetic is **restraint in service of craft**.

## The Two-Register Architecture

Impeccable splits all design work into two registers:

### Brand Register
**Design IS the product.** Applies to: brand sites, landing pages, marketing surfaces, campaign pages, portfolios, long-form content, about pages. The bar is **distinctiveness** — a visitor should ask "how was this made?", not "which AI made this?" Brand surfaces need a POV, a specific audience, and a willingness to risk strangeness. Restraint without intent reads as mediocre, not refined.

Brand affordances: ambitious first-load motion, single-purpose viewports, typographic risk (enormous display type, unexpected italic cuts, mixed cases), unexpected color strategies, art direction per section.

### Product Register
**Design SERVES the product.** Applies to: app UIs, admin dashboards, settings panels, data tables, tools, authenticated surfaces. The bar is **earned familiarity** — a user fluent in Linear/Figma/Notion/Raycast/Stripe should trust it immediately. Failure mode is strangeness without purpose: over-decorated buttons, mismatched form controls, gratuitous motion.

Product affordances: system fonts, standard navigation patterns, density, consistency over surprise.

## Shared Design Laws

These apply across both registers, every design:

### Color Principles
- **Use OKLCH exclusively.** Perceptually uniform; equal lightness steps look equal. Never HSL.
- **Reduce chroma as lightness approaches 0 or 100.** High chroma at extremes looks garish.
- **Never use pure black (#000) or pure white (#fff).** Tint every neutral toward the brand hue (chroma 0.005-0.01 minimum).
- **Four-step color strategy commitment axis:**
  1. **Restrained** — tinted neutrals + one accent at <=10% (product default, brand minimalism)
  2. **Committed** — one saturated color carries 30-60% of the surface (brand default for identity-driven pages)
  3. **Full palette** — 3-4 named roles, each used deliberately (brand campaigns, product data viz)
  4. **Drenched** — the surface IS the color (brand heroes, campaign pages)

### Theme Choice
Dark vs. light is never a default. Not dark "because tools look cool," not light "to be safe." Before choosing, write one sentence of physical scene: who uses this, where, under what ambient light, in what mood. If the sentence doesn't force the answer, add detail until it does. Example: "SRE glancing at incident severity on a 27-inch monitor at 2am in a dim room" forces dark mode.

### Typography
- Cap body line length at 65-75ch.
- Hierarchy through scale AND weight contrast (>=1.25 ratio between steps). Avoid flat scales.
- Light text on dark backgrounds: add 0.05-0.1 to line-height, add 0.01-0.02em letter-spacing, optionally step weight up one notch.

### Layout
- Vary spacing for rhythm. Same padding everywhere is monotony.
- Cards are the lazy answer. Use only when truly the best affordance.
- Nested cards are always wrong.
- Don't wrap everything in a container. Most things don't need one.

### Motion
- Don't animate CSS layout properties (width, height, padding, margin, top, left). Use transform and opacity.
- Ease out with exponential curves (ease-out-quart/quint/expo). No bounce, no elastic.

## The AI Slop Test

The defining quality gate: **if someone could look at this interface and say "AI made that" without doubt, it's failed.**

### Category-Reflex Check (two altitudes)
- **First-order**: If someone could guess the theme + palette from the category alone ("observability => dark blue", "healthcare => white + teal", "finance => navy + gold", "crypto => neon on black"), it's the training-data reflex. Rework until the answer isn't obvious from the domain.
- **Second-order**: If someone could guess the aesthetic family from category-plus-anti-references ("AI workflow tool that's not SaaS-cream => editorial-typographic", "fintech that's not navy-and-gold => terminal-native dark mode"), it's the trap one tier deeper. Rework until both answers are not obvious.

## Absolute Design Bans

Match-and-refuse rules. If you're about to write any of these, rewrite with different structure:
- **Side-stripe borders** — `border-left`/`border-right` > 1px as colored accents on cards, list items, callouts. Never intentional. Rewrite with full borders, background tints, leading numbers/icons, or nothing.
- **Gradient text** — `background-clip: text` with gradient background. Decorative, never meaningful. Use solid color; emphasis via weight or size.
- **Glassmorphism as default** — blurs and glass cards used decoratively. Rare and purposeful, or nothing.
- **The hero-metric template** — big number, small label, supporting stats, gradient accent. SaaS cliche.
- **Identical card grids** — same-sized cards with icon + heading + text, repeated endlessly.
- **Modal as first thought** — usually laziness. Exhaust inline/progressive alternatives first.

## Copy Laws
- Every word earns its place. No restated headings, no intros that repeat the title.
- **No em dashes.** Use commas, colons, semicolons, periods, or parentheses.
- Button labels use specific verb+object: "Save changes" not "OK"; "Create account" not "Submit"; "Delete message" not "Yes".
- For destructive actions, name the destruction: "Delete 5 items" not "Remove selected."
- Error messages answer: what happened, why, how to fix it.

## Anti-Pattern Detection System

Impeccable ships with a detection engine (CLI + browser extension) that identifies 25+ anti-patterns in live UIs, categorized as:

### AI Slop (design tells that reveal AI generation)
- Side-tab accent borders, border accent on rounded elements
- Overused fonts (Inter, Roboto, Fraunces, Geist, Plus Jakarta Sans, Space Grotesk)
- Single font for everything, flat type hierarchy
- Gradient text, AI color palettes (purple/violet gradients, cyan-on-dark)
- Nested cards, monotonous spacing, everything centered
- Bounce/elastic easing, dark mode with glowing accents
- Icon tile stacked above heading, italic serif display headlines
- Hero eyebrow/pill chips, repeated section kicker labels

### Quality (general design and accessibility)
- Pure black/white (#000/#fff), gray text on colored background
- Low contrast text (fails WCAG AA), layout property animation
- Line length too long (>80ch), cramped padding, body text touching viewport edge
- Tight line height (<1.3x), skipped heading levels
- Justified text without hyphenation, tiny body text (<12px)
- All-caps body text, wide letter-spacing on body

## Cognitive Load Framework

Evaluates interfaces against 8 items: single focus, chunking (<=4 items per group), visual grouping, hierarchy clarity, one-thing-at-a-time flow, minimal choices (<=4 visible options), working memory demands, progressive disclosure. Scores 0-1 failures = low cognitive load; 4+ = critical fix needed.

Working memory rule: humans hold <=4 items at once (Cowan's revision of Miller's Law). Applied to nav menus (<=5 top-level), form sections (<=4 fields per group), action buttons (1 primary + 1-2 secondary), dashboard widgets (<=4 key metrics), pricing tiers (<=3 options).

## Heuristic Evaluation System

Full Nielsen's 10 Usability Heuristics scoring (0-4 per heuristic, 40 max): visibility of system status, match between system and real world, user control and freedom, consistency and standards, error prevention, recognition rather than recall, flexibility and efficiency of use, aesthetic and minimalist design, error recovery help, help and documentation. Issues tagged P0 (blocking) through P3 (polish).

## Context-Driven Design

Impeccable requires two project context files for on-brand output:
- **PRODUCT.md** (required): users, brand, tone, anti-references, strategic principles, register field
- **DESIGN.md** (recommended): colors, typography, elevation, components, spacing tokens

Missing context triggers `/impeccable teach` (interactive setup interview) before any design work proceeds.
