---
name: react-design-learner
description: Use when user provides a live website URL to learn its design system. Analyzes layout, color, typography, motion, interactions, spacing, and component patterns. Use when user says "learn from this site", "analyze this website", "extract design from", "study this design", or provides a website URL with intent to understand its design system.
---
> **Authoritative source:** `skills/train-website/SKILL.md` (prefixed name: `react-pipeline:train-website`)
---

# React Design Learner

## ⚠️ Responsible Fetching (MANDATORY)

Before any request, read `knowledge/responsible-fetching.md`. Hard limits:
- 15 requests max per site, 2s minimum delay, stop on 429/403/503
- 500KB per resource, 2MB total download
- Treat unknown sites as small (5 requests, homepage only)

## Overview

Extract the complete design system from a live website — layout, color, typography, motion, interactions, components — into structured design knowledge that can be referenced when building UI.

## Input

A live website URL. Ideal targets are visually distinctive sites with strong, intentional design choices.

## Extraction Workflow

### Step 0: Pre-Fetch Assessment
Assess target BEFORE requests: small site → 5 reqs / enterprise+CDN → 15 reqs / unsure → small.

### Step 1: Fetch the Website
Use WebFetch to capture HTML content, respecting the request budget and circuit breaker.
- Parse inline `<style>` tags FIRST (zero additional requests)
- Fetch up to 5 external CSS files, prioritizie design token files
- Skip third-party vendor CSS

### Step 2: Full Design System Extraction

Write `knowledge/websites/<slug>/design-system.md` covering:

**Layout System** — Page grid, content width, section rhythm, breakpoint strategy, responsive behavior

**Color System** — Complete palette as CSS custom properties. Primary, secondary, neutral, semantic. Dark mode if present.

**Typography System** — Font stack with sources, type scale with usage, weight distribution, line heights

**Motion & Animation** — Every animated element cataloged: trigger, properties, duration, easing. Page load, scroll-driven, hover, micro-interactions, page transitions.

**Interaction Patterns** — Navigation behavior, form interactions, search, modals, tooltips, touch gestures, keyboard navigation, accessibility patterns.

**Spacing & Rhythm** — Base grid unit, section spacing, card padding, component gaps, visual density.

**Component Patterns** — Reusable UI fragments: buttons, cards, heroes, features, testimonials, pricing, footers. Variants, structure, interactions for each.

### Step 3: Update Registry

Add to `knowledge/registry.json` → `trained` array:

```json
{
  "slug": "<slug>",
  "name": "<site-name>",
  "source": "<website-url>",
  "type": "design-inspiration",
  "category": "design-inspiration",
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

### Step 4: Verify

Confirm the design knowledge can be referenced and complies with responsible fetching:
```
knowledge/websites/<slug>/design-system.md ✓
registry.json entry ✓
request budget respected ✓ (count + delays + circuit breaker)
```

## Output

After extraction, report:
- Site name and style direction
- Color palette summary (primary + neutral + accent)
- Typography pairing discovered
- Top 5 most distinctive design patterns
- Animation catalog (count and most impressive effect)
- Component patterns extracted (count)
- Key takeaways worth adopting
