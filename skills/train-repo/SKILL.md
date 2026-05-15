---
name: react-pipeline:train-repo
description: Use when user provides a GitHub URL to a React library — clones, extracts structured knowledge (api.md + patterns.md), and updates the knowledge base registry.
---

# Training a Repository

## Core Principle
Digest a GitHub React library into structured knowledge so `react-pipeline:react-tool` can reference it when writing code.

## Workflow

### Step 1: Determine Slug & Category
Extract slug from repo URL:
- `https://github.com/sheinsight/shineout` → `shineout`
- `https://github.com/TanStack/query` → `tanstack-query`

Assign to one of the 12 categories:
```
ui-libraries / headless / data-fetching / hooks-utilities /
animation / routing / state-management / charts /
guides / backend / database / deployment / auth
```

### Step 2: Clone (Shallow)
```bash
git clone --depth 1 <repo-url> "knowledge/repos/<category>/<slug>"
```

### Step 3: Extract Knowledge — Create api.md
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

### Step 4: Extract Knowledge — Create patterns.md
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

### Step 5: Clean Source Files
Remove cloned source, keep only api.md + patterns.md:
```bash
# Delete everything except api.md and patterns.md
Get-ChildItem -Exclude "api.md","patterns.md" | Remove-Item -Recurse -Force
```

### Step 6: Update Registry
Add entry to `knowledge/registry.json` → `trained` array:
```json
{
  "slug": "<slug>",
  "name": "<package-name>",
  "source": "<repo-url>",
  "type": "<component-library|utility|animation-library|reference-guide>",
  "category": "<category>",
  "platform": "<web|react-native|vue>",
  "style": "<style description>",
  "components": <count>,
  "highlights": ["key", "features"],
  "compatibility": { "tailwind": "<yes|partial|no>", "react-bits": "<yes|complementary|no>", "react-version": ">=X" },
  "trained": "<YYYY-MM-DD>"
}
```

### Step 7: Verify
Confirm api.md and patterns.md are discoverable:
```
knowledge/repos/<category>/<slug>/api.md ✓
knowledge/repos/<category>/<slug>/patterns.md ✓
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
