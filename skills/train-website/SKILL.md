---
name: react-pipeline:train-website
description: Use when user provides a live website URL to learn from — fetches the website, extracts the complete design system (layout, color, typography, motion, interactions, components), and writes structured knowledge to the design-inspiration registry.
---

# Training from a Website

## Core Principle
Extract the complete design system from a live website — layout, color, typography, motion, interactions, components — into structured design knowledge that `react-pipeline:react-tool` can reference when building UI.

## When to Use
- User provides a website URL and wants to learn from its design
- User says "learn from this site", "analyze this design", "extract design from"
- User wants design inspiration reference for a specific style

## Input
A live website URL. Ideally a visually distinctive site with strong design choices.

## Responsible Fetching (MANDATORY READ)

Before any extraction, the agent MUST read and follow `knowledge/responsible-fetching.md`. Key rules:

| Rule | Limit |
|------|-------|
| Max requests per site | 15 (pages + CSS + JS) |
| Request spacing | 2s minimum between requests |
| Circuit breaker | Stop on 429/403/503 or 3 consecutive errors |
| Max resource size | 500KB per file, 2MB total |
| Small site detection | Reduce to 5 requests, homepage only |
| User-Agent | `DesignSystemAnalyzer/1.0 (design research; 1 request/2s)` |

## Workflow

### Step 0: Pre-Fetch Assessment
Assess the target site BEFORE any request:
- **Small/personal site** → 5 requests max, homepage only
- **Enterprise/CDN-backed** → standard 15-request budget
- **Unsure** → treat as small site

### Step 1: Determine Slug
Extract slug from domain:
- `https://linear.app` → `linear`
- `https://vercel.com` → `vercel`
- `https://stripe.com/pricing` → `stripe`

### Step 2: Fetch & Analyze
Use WebFetch to get HTML and CSS from:
- Homepage (primary)
- Key sub-pages (features, pricing, about — if relevant and within budget)
- Up to 5 external CSS files (prioritize design token files)

Respect the request budget and circuit breaker from `knowledge/responsible-fetching.md`. If limited, extract from inline styles only — that alone provides significant design data.

### Step 3: Extract Design System → design-system.md
Write `knowledge/websites/<slug>/design-system.md` covering:

**Layout System**
- Grid structure, content width, column ratios
- Section rhythm and spacing
- Breakpoint strategy and responsive behavior

**Color System**
- Complete palette as CSS custom properties
- Primary, secondary, neutral, semantic colors
- Dark mode handling (if present)
- Gradient strategy

**Typography System**
- Font stack with sources
- Type scale with usage mapping
- Weight distribution and line heights

**Motion & Animation**
- Every animated element cataloged
- Trigger, properties, duration, easing for each
- Scroll-driven, hover, page transition, micro-interaction

**Interaction Patterns**
- Navigation behavior, form interactions, search
- Modal/dialog, tooltip, popover patterns
- Touch gestures, keyboard navigation, accessibility

**Spacing & Rhythm**
- Base grid unit, section spacing, card padding
- Component gaps, content width, visual density

**Component Patterns**
- Reusable UI fragments extracted and cataloged
- Variants, structure, interaction states per component

### Step 4: Update Registry
Add to `knowledge/registry.json` → `trained` array:
```json
{
  "slug": "<slug>",
  "name": "<site-name>",
  "source": "<website-url>",
  "type": "design-inspiration",
  "category": "design-inspiration",
  "platform": "web",
  "style": "<style-direction>",
  "highlights": ["pattern1", "pattern2", "pattern3"],
  "extracted": {
    "colors": <count>,
    "animations": <count>,
    "components": <count>,
    "interactions": <count>
  },
  "trained": "<YYYY-MM-DD>"
}
```

### Step 5: Verify
```
knowledge/websites/<slug>/design-system.md ✓
registry.json entry ✓
responsible fetching policy compliant ✓ (request count, delays, circuit breaker)
```

## Subagent Option
Dispatch `react-design-learner` subagent for full analysis:
```markdown
SUBAGENT: react-design-learner
Task: Analyze website design system with responsible fetching
URL: <website-url>
Slug: <determined slug>
Constraints: 15 requests max, 2s delay, stop on 429/403/503
```

See `design-learner-prompt.md` for the full subagent template.
See `knowledge/responsible-fetching.md` for the mandatory fetching policy.
