---
name: react-tool-train
description: Use when user provides a GitHub URL to a React component library, UI kit, or frontend tool and wants to train the knowledge base. Use when user says "train", "add to knowledge base", "learn this repo", or provides a GitHub link with intent to use it as a reference. Enhanced with interaction pattern and design token extraction.
---
> **Authoritative source:** `skills/train-repo/SKILL.md` (prefixed name: `react-pipeline:train-repo`)
---

# React Frontend Tool — Training

## Overview

Digest a GitHub React component library and add it to the shared knowledge base so `react-tool` can use it when writing code. Now extracts 4 knowledge dimensions: API docs, usage patterns, interaction patterns, and design tokens.

## Input

A GitHub repo URL. The repo should be a React component library, UI kit, or frontend tool with discoverable components.

## Training Workflow

### Step 1: Clone & Explore

```bash
git clone --depth 1 <repo-url> "D:\Claude\react-fullstack-pipeline\knowledge\repos\<category>\<slug>"
```

Determine the slug from the repo name (e.g., `radix-ui/primitives` → `radix-primitives`).
Category is auto-detected from source code analysis (ui-libraries, headless, hooks-utilities, animation, state-management, etc.).

### Step 2: Extract Knowledge — 4 Files

Create four knowledge files:

**`api.md`** — Component API reference:
```markdown
# <Repo Name> — API Reference

## Setup
```bash
npm install <package>
```

## Components (N total)

### <ComponentName>
- **Props:** <list with types and defaults>
- **Usage:** <minimal example>
- **Dependencies:** <if any>
```

**`patterns.md`** — Usage patterns and conventions:
```markdown
# <Repo Name> — Patterns

## Styling Approach
How styles are applied (CSS modules, Tailwind, styled-components, etc.)

## Common Patterns
How components are typically composed together.

## Compatibility
How this works with react-bits (animations) and animal-island-ui.
```

**`interaction-patterns.md`** — Interactive behaviors extracted from source:
```markdown
# <Repo Name> — Interaction Patterns

## Hover States
## Focus States
## Active/Press States
## Transitions (duration, easing, properties)
## Gesture Handling
## Keyboard Navigation
## Loading/Empty/Error States
## Motion Tokens
```

**`design-tokens.md`** — Design tokens extracted from CSS/theme files:
```markdown
# <Repo Name> — Design Tokens

## Color Palette (with light/dark values)
## Typography Scale (size, weight, line-height)
## Spacing System
## Border Radius Scale
## Shadow/Elevation
## Breakpoints
## Z-Index
## Animation Tokens
```

### Step 3: Update Registry

Add to `knowledge/registry.json` → `trained` array:

```json
{
  "slug": "<slug>",
  "name": "<package-name>",
  "source": "<repo-url>",
  "type": "component-library|ui-kit|animation|utility",
  "category": "<category>",
  "style": "<style-description>",
  "components": <count>,
  "highlights": ["key1", "key2", "key3"],
  "extracted": {
    "interactions": <count>,
    "designTokens": <count>
  },
  "compatibility": { "tailwind": "yes|partial|no", "react-bits": "yes|complementary|no", "react-version": ">=X" },
  "trained": "<YYYY-MM-DD>"
}
```

### Step 4: Verify

Confirm the skill can now find and use the trained repo's components.

## Output

After training, report:
- Repo name and component count
- Interaction patterns extracted (count + top 3)
- Design tokens extracted (count + palette summary)
- Key components worth highlighting
- Style compatibility notes
- How it fits with react-bits and animal-island-ui
