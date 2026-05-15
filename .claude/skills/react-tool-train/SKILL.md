---
name: react-tool-train
description: Use when user provides a GitHub URL to a React component library, UI kit, or frontend tool and wants to train the knowledge base. Use when user says "train", "add to knowledge base", "learn this repo", or provides a GitHub link with intent to use it as a reference.
---

# React Frontend Tool — Training

## Overview

Digest a GitHub React component library and add it to the shared knowledge base so `react-tool` can use it when writing code.

## Input

A GitHub repo URL. The repo should be a React component library, UI kit, or frontend tool with discoverable components.

## Training Workflow

### Step 1: Clone & Explore

```bash
git clone --depth 1 <repo-url> "D:\Claude Code\react-frontend-tool\knowledge\repos\<slug>"
```

Determine the slug from the repo name (e.g., `radix-ui/primitives` → `radix-primitives`).

### Step 2: Extract Knowledge

Read and analyze the repo. Create two files:

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
How this works with react-bits (animations) and animal-island-ui (动森风格).
```

### Step 3: Update Registry

Add to `knowledge/registry.json` → `trained` array:

```json
{
  "slug": "<slug>",
  "name": "<package-name>",
  "source": "<repo-url>",
  "type": "component-library|ui-kit|animation|utility",
  "style": "<style-description>",
  "components": <count>,
  "trained": "<YYYY-MM-DD>"
}
```

### Step 4: Verify

Confirm the skill can now find and use the trained repo's components.

## Output

After training, report:
- Repo name and component count
- Key components worth highlighting
- Style compatibility notes (works with Tailwind? CSS modules?)
- How it fits with react-bits and animal-island-ui
