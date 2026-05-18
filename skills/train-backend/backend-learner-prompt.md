# Backend Learner Subagent Prompt Template

Use when dispatching a `react-backend-learner` subagent.

## Template

```
Search for and train a high-quality backend GitHub repository. You are a `react-backend-learner`.

## Already Trained (DO NOT re-train)
Check /d/Claude/react-fullstack-pipeline/knowledge/registry.json for the full list.

## Task

### Phase 1: Search & Select
Use WebSearch to find high-quality backend repos (500+ stars) in ONE of these uncovered areas:

**API Frameworks:**
- Hono (honojs/hono) — edge-native, 14KB
- Fastify (fastify/fastify) — high-perf Node.js
- NestJS (nestjs/nest) — enterprise Node.js framework
- tRPC (trpc/trpc) — end-to-end typesafe APIs
- Elysia (elysiajs/elysia) — Bun-native, fast
- Express (expressjs/express) — classic, ubiquitous

**ORMs & Databases:**
- Prisma (prisma/prisma) — type-safe ORM
- Drizzle (drizzle-team/drizzle-orm) — SQL-like ORM
- Kysely (kysely-org/kysely) — type-safe SQL builder
- TypeORM (typeorm/typeorm) — traditional ORM
- MikroORM (mikro-orm/mikro-orm) — mature ORM
- Better-sqlite3 — synchronous SQLite for Node

**Auth & Security:**
- NextAuth (nextauthjs/next-auth) — auth for Next.js
- Lucia (lucia-auth/lucia) — session-based auth
- Clerk (clerk/javascript) — embedded auth UI
- Auth0 (auth0/nextjs-auth0) — enterprise auth
- Passport (jaredhanson/passport) — authentication middleware

**Backend Utilities:**
- Zod (colinhacks/zod) — schema validation
- tRPC — typesafe API client
- BullMQ (taskforcesh/bullmq) — job queue
- Socket.io — real-time WebSocket
- Redis clients (ioredis, node-redis)

**Database Tools:**
- Drizzle Kit / Prisma Studio
- pgAdmin / DBeaver alternatives
- Migration tools (node-pg-migrate, db-migrate)

Pick ONE best candidate: highest stars, most useful for backend architecture learning.

### Phase 2: Clone & Explore
```bash
git clone --depth 1 <repo-url> /d/Claude/react-fullstack-pipeline/knowledge/repos/<category>/<slug>
```
Explore thoroughly: package.json, src structure, entry points, key exports, examples directory, test directory.

### Phase 3: API Documentation (api.md)
Write `/d/Claude/react-fullstack-pipeline/knowledge/repos/<category>/<slug>/api.md`:
- **Setup** — install, peer deps, runtime requirements (Node/Bun/Deno/Edge)
- **All key exports** — with signatures, type parameters, options
- **Minimal working examples** — copy-paste ready
- **Configuration** — how to configure, environment variables, options

### Phase 4: Usage Patterns (patterns.md)
Write `/d/Claude/react-fullstack-pipeline/knowledge/repos/<category>/<slug>/patterns.md`:
- **Library positioning** — what it replaces, when to use vs alternatives
- **Architecture patterns** — project structure, route organization, middleware chain
- **Common patterns** — CRUD, auth guard, validation, error handling
- **Integration** — how it connects with databases, auth, deployment platforms
- **Anti-patterns** — common mistakes

### Phase 5: Backend Patterns (backend-patterns.md)
Write `/d/Claude/react-fullstack-pipeline/knowledge/repos/<category>/<slug>/backend-patterns.md`:

Extract from source and examples:
- **API Route Design** — REST conventions, route grouping, path parameters, query parameter patterns (pagination/filter/sort/search), response envelope format
- **Middleware Architecture** — auth middleware (JWT verification, session, API key), validation middleware (Zod integration), error handling (global handler, custom errors), logging (request ID, timing), rate limiting
- **Database Patterns** — connection management (pooling, singleton), migration strategies, query patterns (raw/query builder/ORM), transaction handling, seeding
- **Auth & Security** — JWT patterns (access/refresh, rotation), session patterns (cookie, DB-backed), OAuth flows (PKCE, state), password hashing, input sanitization, CSRF
- **Performance & Reliability** — caching strategies, background jobs/queues, connection pooling, graceful shutdown, health checks

### Phase 6: API Design Reference (api-patterns.md)
Write `/d/Claude/react-fullstack-pipeline/knowledge/repos/<category>/<slug>/api-patterns.md`:
- **Route conventions** — URL structure, HTTP method usage, status code conventions
- **Request/Response formats** — success envelope, error envelope, pagination metadata
- **Error handling patterns** — error codes, validation error format, server error format
- **Pagination patterns** — offset-based, cursor-based, page-based
- **File upload patterns** — multipart, presigned URLs, streaming
- **Real-time patterns** — WebSocket, SSE, polling
- **Testing patterns** — integration tests, API tests, database test helpers

### Phase 7: Cleanup
Delete all source files, keep only: api.md, patterns.md, backend-patterns.md, api-patterns.md

### Phase 8: Registry Entry
Add to `/d/Claude/react-fullstack-pipeline/knowledge/registry.json` → `trained` array:
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
  "trained": "<TODAY_DATE>"
}
```

## Output
Report:
- Repo name, stars, slug, category, runtime
- API patterns extracted (count + top 3)
- Backend patterns extracted (count + top 3)
- Key architectural insights worth adopting
- Confirmation all 4 knowledge files exist
- Confirmation registry is updated
```
