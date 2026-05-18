---
name: react-backend-learner
description: Use when user wants to learn backend patterns — searches GitHub for high-quality backend repos (API frameworks, ORMs, auth, database tools, backend utilities) with 500+ stars, extracts structured backend knowledge (api.md + patterns.md + backend-patterns.md + api-patterns.md), and updates the knowledge base. Use when user says "learn backend", "train backend", "study backend patterns".
---
> **Authoritative source:** `skills/train-backend/SKILL.md` (prefixed name: `react-pipeline:train-backend`)
---

# React Backend Learner

## Overview

Search for and train high-quality backend GitHub repositories into the knowledge base. Extracts 4 dimensions of backend knowledge: API reference, usage patterns, backend architecture patterns, and API design reference.

## Input

None required — agent searches autonomously. Optionally provide a GitHub URL to a specific backend repo.

## Extraction Workflow

### Step 1: Search & Select
Use WebSearch to find backend repos (500+ stars) in priority areas:
- **API Frameworks** — Hono, Fastify, NestJS, tRPC, Elysia, Express
- **ORMs & Databases** — Prisma, Drizzle, Kysely, TypeORM, MikroORM
- **Auth & Security** — NextAuth, Lucia, Clerk, Auth0, Passport
- **Backend Utilities** — Zod, BullMQ, Socket.io, Redis clients
- **Database Tools** — Migration tools, admin panels, connection managers

### Step 2: Clone & Extract
```bash
git clone --depth 1 <repo-url> "knowledge/repos/<category>/<slug>"
```

Extract 4 knowledge files:

**api.md** — API reference: setup, all exports with signatures, minimal examples, configuration

**patterns.md** — Usage patterns: architecture patterns, common patterns, integration guides, anti-patterns

**backend-patterns.md** — Backend architecture:
- API route design (REST conventions, route grouping, query patterns, response format)
- Middleware architecture (auth, validation, error handling, logging, rate limiting)
- Database patterns (connection management, migrations, query patterns, transactions)
- Auth & security (JWT, sessions, OAuth, password hashing, input sanitization)
- Performance (caching, background jobs, pooling, graceful shutdown, health checks)

**api-patterns.md** — API design reference:
- Route conventions & HTTP method usage
- Request/Response formats & error handling patterns
- Pagination patterns (offset, cursor, page)
- File upload, WebSocket, real-time patterns
- Testing patterns

### Step 3: Update Registry
```json
{
  "slug": "<slug>",
  "name": "<package-name>",
  "source": "<repo-url>",
  "type": "<backend-framework|orm|auth|database-tool|backend-utility>",
  "category": "<backend|database|auth|deployment>",
  "platform": "<node|bun|deno|edge|universal>",
  "runtime": "<node|bun|deno|edge>",
  "style": "<brief-description>",
  "highlights": ["key1", "key2", "key3"],
  "extracted": {
    "apiPatterns": <count>,
    "backendPatterns": <count>
  },
  "trained": "<YYYY-MM-DD>"
}
```

### Step 4: Verify
```
knowledge/repos/<category>/<slug>/api.md ✓
knowledge/repos/<category>/<slug>/patterns.md ✓
knowledge/repos/<category>/<slug>/backend-patterns.md ✓
knowledge/repos/<category>/<slug>/api-patterns.md ✓
registry.json entry ✓
```

## Output
Report: repo name, stars, category, runtime, API patterns count, backend patterns count, key architectural insights.
