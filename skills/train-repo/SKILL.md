---
name: react-pipeline:train-repo
description: Use when user provides a GitHub URL to a React library — clones, extracts structured knowledge (api.md + patterns.md + interaction-patterns.md + design-tokens.md), and updates the knowledge base registry.
---

# Training a Repository

## Core Principle
Digest a GitHub React library into structured knowledge so `react-pipeline:react-tool` can reference it when writing code. Now extracts 4 knowledge dimensions: API, patterns, interactions, and design tokens.

## Workflow

### Step 1: Determine Slug & Category
Extract slug from repo URL:
- `https://github.com/sheinsight/shineout` → `shineout`
- `https://github.com/TanStack/query` → `tanstack-query`

Auto-detect category or assign to one of the 13 categories:
```
ui-libraries / headless / data-fetching / hooks-utilities /
animation / routing / state-management / charts /
guides / backend / database / deployment / auth
```

### Step 2: Clone (Shallow)
```bash
git clone --depth 1 <repo-url> "knowledge/repos/<category>/<slug>"
```

### Step 3: Extract Knowledge — api.md
```markdown
# <Repo Name> — API Reference
> package-name vX.Y | type | React >= X

## Setup
```bash
npm install <package>
```

## Core API
### Component/Hook Name
- **Props/Options:** <table with types and defaults>
- **Usage:** <minimal working example>
```

### Step 4: Extract Knowledge — patterns.md
```markdown
# <Repo Name> — Patterns

## 定位
What this library is, what it solves.

## Standard Patterns
Common usage patterns and integration examples.

## Compatibility
How this works with:
- react-bits (animation layer)
- Other trained repos in registry
- Tailwind CSS
```

### Step 5: Extract Interactions — interaction-patterns.md
Extract every interactive behavior from source code:
```markdown
# <Repo Name> — Interaction Patterns

## Hover States
[List with trigger, behavior, implementation, duration]

## Focus States
## Active/Press States
## Transitions
## Gestures
## Keyboard Navigation
## Loading States
## Empty/Error States
## Feedback Patterns
## Motion Tokens
```

### Step 6: Extract Design Tokens — design-tokens.md
Extract the design token system:
```markdown
# <Repo Name> — Design Tokens

## Color Palette
[Token table with light/dark values and usage]

## Typography
[Scale with size, weight, line-height]

## Spacing
## Border Radius
## Shadow/Elevation
## Breakpoints
## Z-Index
## Animation Tokens
```

### Step 7: Clean Source Files
Remove cloned source, keep only knowledge files:
```bash
# Delete everything except .md files
Get-ChildItem -Exclude "*.md" | Remove-Item -Recurse -Force
```

### Step 8: Update Registry
Add entry to `knowledge/registry.json` → `trained` array:
```json
{
  "slug": "<slug>",
  "name": "<package-name>",
  "source": "<repo-url>",
  "type": "<type>",
  "category": "<category>",
  "platform": "<web|react-native|vue>",
  "style": "<style description>",
  "components": <count>,
  "highlights": ["key1", "key2", "key3"],
  "extracted": {
    "interactions": <count>,
    "designTokens": <count>
  },
  "compatibility": { "tailwind": "<yes|partial|no>", "react-bits": "<yes|complementary|no>", "react-version": ">=X" },
  "trained": "<YYYY-MM-DD>"
}
```

### Step 9: Verify
Confirm all knowledge files exist:
```
knowledge/repos/<category>/<slug>/api.md ✓
knowledge/repos/<category>/<slug>/patterns.md ✓
knowledge/repos/<category>/<slug>/interaction-patterns.md ✓
knowledge/repos/<category>/<slug>/design-tokens.md ✓
registry.json entry ✓
```

## Subagent Option
For complex repos, dispatch `react-trainer` subagent:
```markdown
SUBAGENT: react-trainer
Task: Train <repo-url> into knowledge base
Category: <assigned category>
Slug: <determined slug>
```

See `trainer-prompt.md` for the full subagent template.
