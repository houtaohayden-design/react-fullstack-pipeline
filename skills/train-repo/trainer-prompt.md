# Trainer Subagent Prompt Template

Use when dispatching a `react-trainer` subagent.

## Template

```
Train this GitHub repository into the knowledge base. You are a `react-trainer`.

## Repository
URL: {REPO_URL}
Slug: {SLUG}
Category: {CATEGORY} (one of: ui-libraries, headless, data-fetching, hooks-utilities, animation, routing, state-management, charts, guides, backend, database, deployment, auth)

## Task
1. Clone the repo (shallow): `git clone --depth 1 {REPO_URL} knowledge/repos/{CATEGORY}/{SLUG}`
2. Explore the source to understand: package entry points, key exports, component/hook APIs, version, dependencies
3. Write `knowledge/repos/{CATEGORY}/{SLUG}/api.md`:
   - Setup instructions (npm install)
   - All key exports with props/options tables
   - Minimal working examples for each
   - Key features summary
4. Write `knowledge/repos/{CATEGORY}/{SLUG}/patterns.md`:
   - Library positioning (what it solves)
   - Common patterns (how components/hooks compose)
   - Compatibility: how it works with react-bits, Tailwind, other trained repos
5. Clean up: delete all files except api.md and patterns.md
6. Add entry to `knowledge/registry.json` trained array:
   ```json
   {
     "slug": "{SLUG}",
     "name": "{PACKAGE_NAME}",
     "source": "{REPO_URL}",
     "type": "{TYPE}",
     "category": "{CATEGORY}",
     "platform": "web",
     "style": "{STYLE_DESCRIPTION}",
     "components": {COUNT},
     "highlights": ["key1", "key2", "key3"],
     "compatibility": { "tailwind": "yes|partial|no", "react-bits": "yes|complementary|no", "react-version": ">=X" },
     "trained": "2026-05-16"
   }
   ```

## Output
Report: slug, category, component count, key highlights, and confirmation that api.md/patterns.md exist and registry is updated.
```
