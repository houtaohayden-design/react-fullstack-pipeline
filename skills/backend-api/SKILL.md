---
name: react-pipeline:backend-api
description: Use when building a backend API for a React app — REST/GraphQL route design, middleware patterns, input validation, error handling. Supports Hono, Express, Fastify.
---

# Backend API for React Apps

## Core Principle
Choose the right framework for your scale. Hono for edge/serverless, Fastify for high-throughput, Express for maximum familiarity.

## Framework Selection

| Framework | Bundle | Speed | Best For |
|-----------|--------|-------|----------|
| **Hono** | ~14KB | Fastest (RegExpRouter) | Edge/Cloudflare Workers, Deno, Bun, Node |
| **Fastify** | ~50KB | ~30K req/s | High-throughput REST, plugin ecosystem |
| **Express** | ~60KB | Baseline | Rapid prototyping, max community support |

**Default recommendation:** Hono for new projects — fastest, runs everywhere, best TypeScript DX.

## Hono Quick Start

```ts
import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { z } from 'zod'
import { zValidator } from '@hono/zod-validator'

const app = new Hono()

// Middleware
app.use('*', cors())
app.use('*', async (c, next) => {
  const start = Date.now()
  await next()
  console.log(`${c.req.method} ${c.req.path} ${Date.now() - start}ms`)
})

// Routes
app.get('/api/users', (c) => c.json([{ id: 1, name: 'Alice' }]))

app.get('/api/users/:id', (c) => {
  const id = c.req.param('id')
  return c.json({ id, name: 'Alice' })
})

const createSchema = z.object({
  name: z.string().min(2),
  email: z.string().email()
})

app.post('/api/users', zValidator('json', createSchema), async (c) => {
  const body = c.req.valid('json')
  // Create user
  return c.json({ id: 'new', ...body }, 201)
})

// Error handling
app.onError((err, c) => {
  console.error(err)
  return c.json({ error: 'Internal server error' }, 500)
})

app.notFound((c) => c.json({ error: 'Not found' }, 404))

export default app
```

## Express Quick Start

```ts
import express from 'express'
import { z } from 'zod'

const app = express()
app.use(express.json())

app.get('/api/users', (req, res) => {
  res.json([{ id: 1, name: 'Alice' }])
})

app.post('/api/users', (req, res) => {
  const result = createSchema.safeParse(req.body)
  if (!result.success) return res.status(400).json({ errors: result.error.flatten() })
  res.status(201).json({ id: 'new', ...result.data })
})

app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err)
  res.status(500).json({ error: 'Internal server error' })
})
```

## API Design Rules

### REST Conventions
```
GET    /api/users          → List
GET    /api/users/:id      → Get one
POST   /api/users          → Create
PUT    /api/users/:id      → Replace
PATCH  /api/users/:id      → Update partial
DELETE /api/users/:id      → Delete
```

### Response Envelope
```json
{ "data": {}, "meta": { "total": 100, "page": 1 } }
```

### Error Response
```json
{ "error": { "code": "VALIDATION_ERROR", "message": "...", "details": [...] } }
```

### Input Validation
Always use Zod schemas. Validate at the boundary.
```ts
const schema = z.object({
  email: z.string().email(),
  age: z.number().min(0).max(150).optional()
})
```

## Security Checklist
- [ ] CORS configured (specific origins, not `*`)
- [ ] Rate limiting on auth endpoints
- [ ] Input validation on all routes
- [ ] Helmet/CSP headers set
- [ ] No stack traces in error responses
- [ ] Authentication middleware on protected routes
