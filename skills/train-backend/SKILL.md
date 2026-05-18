---
name: react-pipeline:train-backend
description: Use when user wants to learn backend patterns — searches GitHub for high-quality backend repos (API frameworks, ORMs, auth, database tools), extracts structured backend knowledge, and updates the knowledge base.
---

# Training Backend Knowledge

## Core Principle
Search and digest GitHub backend repositories into structured knowledge covering API design, database architecture, auth flows, and deployment patterns. Complements the frontend-focused `train-repo` and `train-website` skills.

## When to Use
- User says "learn backend", "train backend libraries", "study backend patterns"
- User provides a GitHub URL to a backend framework, ORM, auth library, or API tool
- Autonomous background learning of backend ecosystem

## Input Sources
- GitHub repos for backend frameworks (Hono, Express, Fastify, NestJS, tRPC)
- GitHub repos for ORMs/databases (Prisma, Drizzle, Kysely, TypeORM, Mongoose)
- GitHub repos for auth (NextAuth, Lucia, Clerk SDK, Auth0 SDK)
- GitHub repos for backend utilities (Zod, tRPC, BullMQ, Redis clients)
- Open-source full-stack starter templates (create-t3-app, Next.js examples, etc.)

## Workflow

### Step 1: Search & Select
Use WebSearch + GitHub code search to find high-quality backend repos (500+ stars, active maintenance). Prioritize repos NOT already in the knowledge base.

### Step 2: Clone
```bash
git clone --depth 1 <repo-url> "knowledge/repos/<category>/<slug>"
```

Categories: `backend`, `database`, `auth`, `deployment`

### Step 3: Extract Backend Knowledge — api.md
```markdown
# <Repo Name> — API Reference
> package-name vX.Y | type | Runtime: Node/Bun/Deno/Edge

## Setup
```bash
npm install <package>
```

## Core API
### Function/Class/Route
- **Signature:** <with types>
- **Usage:** <minimal example>
```

### Step 4: Extract Patterns — patterns.md
```markdown
# <Repo Name> — Patterns

## 定位
What this library solves in the backend stack.

## Architecture Patterns
How routes/middleware/handlers are organized. Project structure conventions.

## Standard Patterns
Common usage patterns: CRUD operations, middleware chains, error handling, validation, auth guards.

## Integration
How this works with databases (Drizzle, Prisma), auth (JWT, OAuth), deployment (Docker, Vercel, Cloudflare).
```

### Step 5: Extract Backend-Specific Knowledge — backend-patterns.md
```markdown
# <Repo Name> — Backend Patterns

## API Route Design
- RESTful conventions (GET/POST/PUT/DELETE organization)
- Route grouping/nesting patterns
- Path parameter conventions
- Query parameter patterns (pagination, filter, sort, search)
- Response envelope format (success/error/data/meta)

## Middleware Architecture
- Auth middleware (JWT verification, session validation, API key check)
- Validation middleware (Zod schema, request body/query/params)
- Error handling middleware (global error handler, custom error classes)
- Logging middleware (request ID, timing, structured logging)
- Rate limiting middleware (token bucket, sliding window, IP-based)
- CORS configuration patterns

## Database Patterns
- Connection management (pooling, singleton, per-request)
- Migration strategies (auto-migration, manual, versioned)
- Query patterns (raw SQL, query builder, ORM relations)
- Transaction handling (auto-commit, manual, nested)
- Seeding patterns

## Auth & Security
- JWT patterns (access/refresh token, rotation, blacklisting)
- Session patterns (cookie-based, database-backed, stateless)
- OAuth flows (PKCE, state verification, callback handling)
- Password hashing (bcrypt/argon2, salt rounds, upgrade strategy)
- Input sanitization (XSS, SQL injection, path traversal)
- CSRF protection patterns

## Performance & Reliability
- Caching strategies (in-memory, Redis, HTTP cache headers, ETag)
- Background jobs (queue system, retry logic, dead letter)
- Connection pooling and timeouts
- Graceful shutdown patterns
- Health check endpoints
```

### Step 6: Extract API Design Reference — api-patterns.md
```markdown
# <Repo Name> — API Design Reference

## Route Conventions
## Request/Response Formats
## Error Handling Patterns
## Pagination Patterns
## File Upload Patterns
## WebSocket / Real-time Patterns
## Testing Patterns (integration tests, API tests)
```

### Step 7: Cleanup
Remove cloned source, keep only: api.md, patterns.md, backend-patterns.md, api-patterns.md

### Step 8: Update Registry
Add to `knowledge/registry.json` → `trained` array:
```json
{
  "slug": "<slug>",
  "name": "<package-name>",
  "source": "<repo-url>",
  "type": "<backend-framework|orm|auth|database-tool|backend-utility>",
  "category": "<backend|database|auth|deployment>",
  "platform": "<node|bun|deno|edge|universal>",
  "runtime": "<node|bun|deno|edge>",
  "style": "<style-description>",
  "highlights": ["key1", "key2", "key3"],
  "extracted": {
    "apiPatterns": <count>,
    "backendPatterns": <count>
  },
  "trained": "<YYYY-MM-DD>"
}
```

### Step 9: Verify
```
knowledge/repos/<category>/<slug>/api.md ✓
knowledge/repos/<category>/<slug>/patterns.md ✓
knowledge/repos/<category>/<slug>/backend-patterns.md ✓
knowledge/repos/<category>/<slug>/api-patterns.md ✓
registry.json entry ✓
```

## Subagent Option
Dispatch `react-backend-learner` subagent:
```markdown
SUBAGENT: react-backend-learner
Task: Train backend knowledge from <repo-url>
Category: <backend|database|auth|deployment>
Slug: <determined slug>
```

See `backend-learner-prompt.md` for the full subagent template.
