# Hono Patterns & Project Structure

> Source: [honojs/hono](https://github.com/honojs/hono)
> Proven patterns for building Hono applications.

## Project Structure

### Domain-based Organization (Recommended)
```
src/
  index.ts              # main entry, creates and exports app
  app.ts                # Hono instance + global middleware
  routes/
    auth/
      auth.route.ts     # auth-related endpoints
      auth.service.ts   # business logic
    users/
      users.route.ts    # user CRUD endpoints
      users.service.ts  # user business logic
    posts/
      posts.route.ts
      posts.service.ts
  middleware/
    auth.middleware.ts   # auth guard middleware
    logger.middleware.ts # custom logger
  lib/
    db.ts                # database client
    validation.ts        # shared zod schemas
    types.ts             # shared types
  adapters/
    cloudflare.ts        # Cloudflare entry
    node.ts              # Node.js entry
```

### Feature-based Organization
```
src/
  index.ts
  features/
    auth/
      route.ts
      handler.ts
      service.ts
      middleware.ts
      schema.ts
      test.ts
    dashboard/
      route.ts
      handler.ts
      ...
  shared/
    lib/
    middleware/
    types/
```

## Route Organization Patterns

### Pattern 1: Separate Route Files with `route()` Grouping
```ts
// src/routes/users/users.route.ts
import { Hono } from 'hono'

const users = new Hono()
  .get('/', (c) => c.json([{ id: 1, name: 'Alice' }]))
  .get('/:id', (c) => c.json({ id: c.req.param('id') }))
  .post('/', async (c) => {
    const body = await c.req.json()
    return c.json({ created: true }, 201)
  })

export { users }

// src/app.ts
import { Hono } from 'hono'
import { users } from './routes/users/users.route'
import { posts } from './routes/posts/posts.route'

const app = new Hono()
  .route('/api/users', users)
  .route('/api/posts', posts)
```

### Pattern 2: Factory-Based Router Creation
```ts
import { Hono } from 'hono'
import { factory } from 'hono/factory'

const app = new Hono()
const { createHandlers, createMiddleware } = factory

// Create pre-wired routes with environment
```

### Pattern 3: Route File with Export Pattern
```ts
// Each route file exports a configured Hono instance
// src/routes/comments/comments.route.ts
const comments = new Hono()

comments
  .get('/', listComments)
  .post('/', createComment)
  .delete('/:id', deleteComment)

export default comments

// src/routes/index.ts
import { Hono } from 'hono'
import comments from './comments/comments.route'
import users from './users/users.route'

const router = new Hono()
  .route('/comments', comments)
  .route('/users', users)

export default router
```

## Middleware Composition

### Pattern 1: Global + Scoped Middleware Stack
```ts
const app = new Hono()

// Global — applied to ALL routes
app.use('*', logger())
app.use('*', cors({ origin: '*' }))
app.use('*', secureHeaders())
app.use('*', requestId())

// Scoped — only for /api
app.use('/api/*', bearerAuth({ token: SECRET }))

// Route-specific — only for this route
app.post('/api/users', bodyLimit({ maxSize: 1024 * 50 }), handler)
```

### Pattern 2: Middleware Combinator
```ts
import { combine } from 'hono/combine'

const security = combine(cors(), secureHeaders(), csrf())
app.use('/api/*', security)
```

### Pattern 3: Auth Guard Middleware
```ts
// src/middleware/auth.middleware.ts
import type { MiddlewareHandler } from 'hono'

export const authGuard = (): MiddlewareHandler => async (c, next) => {
  const token = c.req.header('Authorization')?.replace('Bearer ', '')
  if (!token) {
    return c.json({ error: 'Unauthorized' }, 401)
  }
  try {
    const payload = await verify(token, JWT_SECRET)
    c.set('user', payload)  // downstream routes access via c.get('user')
    await next()
  } catch {
    return c.json({ error: 'Invalid token' }, 401)
  }
}
```

### Pattern 4: Computed Middleware Factory
```ts
// Middleware that accepts options
const rateLimiter = (maxRequests: number, windowMs: number): MiddlewareHandler => {
  const store = new Map<string, { count: number; resetAt: number }>()

  return async (c, next) => {
    const key = c.req.header('x-forwarded-for') || 'unknown'
    const now = Date.now()
    const entry = store.get(key)

    if (!entry || now > entry.resetAt) {
      store.set(key, { count: 1, resetAt: now + windowMs })
      return next()
    }

    if (entry.count >= maxRequests) {
      return c.json({ error: 'Too many requests' }, 429)
    }

    entry.count++
    await next()
  }
}

app.use('/api/*', rateLimiter(100, 60_000))
```

## Error Handling Patterns

### Pattern 1: HTTPException + onError Handler
```ts
import { HTTPException } from 'hono/http-exception'

// In service or route
const requireAdmin = (c: Context) => {
  const user = c.get('user')
  if (user.role !== 'admin') {
    throw new HTTPException(403, { message: 'Admin only' })
  }
}

// Global error handler
app.onError((err, c) => {
  if (err instanceof HTTPException) {
    return c.json({ error: err.message }, err.status)
  }
  console.error('Unhandled error:', err)
  return c.json({ error: 'Internal Server Error' }, 500)
})
```

### Pattern 2: Structured Error Codes
```ts
class AppError extends HTTPException {
  constructor(status: number, code: string, message: string) {
    super(status, { message })
    this.code = code
  }
  code: string
}

// Usage
throw new AppError(422, 'VALIDATION_ERROR', 'Email already exists')

// Handler
app.onError((err, c) => {
  if (err instanceof AppError) {
    return c.json({ code: err.code, message: err.message }, err.status)
  }
  return c.json({ code: 'INTERNAL_ERROR', message: 'Internal server error' }, 500)
})
```

### Pattern 3: 404 Handling
```ts
app.notFound((c) => {
  const accept = c.req.header('Accept')
  if (accept?.includes('application/json')) {
    return c.json({ error: 'Not Found' }, 404)
  }
  return c.html('<h1>404 — Page Not Found</h1>', 404)
})
```

## RPC Pattern (End-to-End Type Safety)

### Server Setup
```ts
// src/app.ts
import { Hono } from 'hono'
import { z } from 'zod'
import { zValidator } from '@hono/zod-validator'

const app = new Hono()
  .get(
    '/users/:id',
    zValidator('param', z.object({ id: z.string().uuid() })),
    async (c) => {
      const { id } = c.req.valid('param')
      const user = await db.users.findById(id)
      if (!user) return c.json({ error: 'Not found' }, 404)
      return c.json(user)
    }
  )
  .post(
    '/users',
    zValidator('json', z.object({ name: z.string(), email: z.string().email() })),
    async (c) => {
      const data = c.req.valid('json')
      const user = await db.users.create(data)
      return c.json(user, 201)
    }
  )

export type AppType = typeof app
export default app
```

### Client Usage
```ts
// src/client.ts
import { hc } from 'hono/client'
import type { AppType } from './app'

const client = hc<AppType>('http://localhost:3000')

// Type-safe: path params, query, JSON body ALL infer from server schemas
const { data: user } = await client.users[':id'].$get({
  param: { id: 'uuid-here' }
})

const { data: created } = await client.users.$post({
  json: { name: 'Bob', email: 'bob@example.com' }
})
```

### Honorable Pattern: Custom `api` wrapper
```ts
// lib/api.ts — wraps hc with base URL and auto auth
import { hc } from 'hono/client'
import type { AppType } from '@/server/app'

const getBaseUrl = () => {
  if (typeof window !== 'undefined') return ''
  return process.env.API_URL || 'http://localhost:3000'
}

const getAuthHeader = () => {
  const token = getToken() // from cookie or local storage
  return token ? { Authorization: `Bearer ${token}` } : {}
}

export const api = hc<AppType>(getBaseUrl(), {
  headers: () => getAuthHeader(),
})
```

## Testing Patterns

### Pattern 1: Using `app.request()` (Lightweight)
```ts
import { Hono } from 'hono'

const app = new Hono()
  .get('/hello', (c) => c.json({ message: 'Hi' }))
  .post('/echo', async (c) => c.json(await c.req.json()))

test('GET /hello returns message', async () => {
  const res = await app.request('/hello')
  expect(res.status).toBe(200)
  expect(await res.json()).toEqual({ message: 'Hi' })
})

test('POST /echo returns body', async () => {
  const res = await app.request('/echo', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ foo: 'bar' }),
  })
  expect(await res.json()).toEqual({ foo: 'bar' })
})

test('can pass headers', async () => {
  const res = await app.request('/hello', {
    headers: { Authorization: 'Bearer test' },
  })
})
```

### Pattern 2: Using `testClient()` (Type-safe)
```ts
import { testClient } from 'hono/testing'

const client = testClient(app)

test('type-safe route testing', async () => {
  const res = await client.users[':id'].$get({ param: { id: '1' } })
  expect(res.status).toBe(200)
})
```

### Pattern 3: Environment/Services Mocking
```ts
// src/app.ts
const app = new Hono<{ Bindings: { DB: D1Database } }>()

// In tests — pass env directly
test('with mocked env', async () => {
  const mockDB = { /* mock D1 */ }
  const res = await app.request('/users', {}, { DB: mockDB })
  expect(res.status).toBe(200)
})
```

## Deployment Patterns

### Multi-Runtime Entry Pattern
```ts
// src/index.ts — shared app definition
import { Hono } from 'hono'
import routes from './routes'

const app = new Hono()
  .use('*', cors())
  .route('/', routes)

export default app

// src/adapters/cloudflare.ts
import app from '../index'
export default app  // Cloudflare Workers ES module format

// src/adapters/node.ts
import { serve } from '@hono/node-server'
import app from '../index'
serve(app, (info) => console.log(`Listening on ${info.port}`))

// src/adapters/deno.ts
import { handle } from 'hono/deno'
import app from '../index'
Deno.serve(handle(app))

// src/adapters/bun.ts
import { handle } from 'hono/bun'
import app from '../index'
Bun.serve({ fetch: handle(app) })

// src/adapters/aws-lambda.ts
import { handle } from 'hono/aws-lambda'
import app from '../index'
export const handler = handle(app)

// src/adapters/vercel.ts
import { handle } from 'hono/vercel'
import app from '../index'
export default handle(app)
```

## Monorepo Pattern (Server + Client)
```
my-app/
  packages/
    server/
      src/
        app.ts           # Hono app + AppType export
        index.ts          # entry
      package.json
    client/
      src/
        api.ts            # hc<AppType>('...') client
        App.tsx
      package.json
```

## Caching Patterns

```ts
import { cache } from 'hono/cache'

// Global cache for GET requests
app.get(
  '/api/posts/*',
  cache({ cacheName: 'posts', cacheControl: 'max-age=3600' }),
  (c) => c.json({ posts: [] })
)

// Per-route cache control
app.get('/api/weather', (c) => {
  c.header('Cache-Control', 'public, max-age=300')
  return c.json({ temp: 22 })
})
```
