# Hono API Design Patterns

> Source: [honojs/hono](https://github.com/honojs/hono)
> REST conventions, response envelopes, cookies, file uploads, and deployment patterns for Hono.

## REST Conventions

### RESTful Route Design
```ts
const users = new Hono()

// Collection
users.get('/',        listUsers)        // GET    /users
users.post('/',       createUser)       // POST   /users

// Item
users.get('/:id',     getUser)          // GET    /users/:id
users.put('/:id',     replaceUser)      // PUT    /users/:id
users.patch('/:id',   updateUser)       // PATCH  /users/:id
users.delete('/:id',  deleteUser)       // DELETE /users/:id

// Nested resources
users.get('/:id/posts',       listUserPosts)       // GET /users/:id/posts
users.post('/:id/posts',      createUserPost)      // POST /users/:id/posts
users.get('/:id/posts/:postId', getUserPost)       // GET /users/:id/posts/:postId
```

### HTTP Status Code Usage
```ts
// Success
c.json(data)                    // 200 OK
c.json(data, 201)               // 201 Created
c.body(null, 204)               // 204 No Content (delete success)

// Redirect
c.redirect('/new-location')     // 302 Found
c.redirect('/new-location', 301)// 301 Moved Permanently

// Client Errors
c.json({ error: 'Bad Request' }, 400)
c.json({ error: 'Unauthorized' }, 401)
c.json({ error: 'Forbidden' }, 403)
c.json({ error: 'Not Found' }, 404)
c.json({ error: 'Conflict' }, 409)
c.json({ error: 'Unprocessable Entity' }, 422)     // Validation failure
c.json({ error: 'Too Many Requests' }, 429)

// Server Errors
c.json({ error: 'Internal Server Error' }, 500)
c.json({ error: 'Not Implemented' }, 501)
c.json({ error: 'Service Unavailable' }, 503)
```

## Response Envelope Design

### Standard Envelope Pattern
```ts
// lib/response.ts
import type { Context } from 'hono'

export interface Envelope<T> {
  success: boolean
  data?: T
  error?: {
    code: string
    message: string
    details?: unknown
  }
  meta?: {
    total?: number
    page?: number
    limit?: number
    cursor?: string
  }
}

export const ok = <T>(c: Context, data: T, meta?: Envelope<T>['meta'], status = 200) => {
  const body: Envelope<T> = { success: true, data }
  if (meta) body.meta = meta
  return c.json(body, status as any)
}

export const err = (c: Context, status: number, code: string, message: string, details?: unknown) => {
  return c.json({
    success: false,
    error: { code, message, details },
  } as Envelope<never>, status as any)
}
```

### Usage in Routes
```ts
import { ok, err } from '../lib/response'

users.get('/', async (c) => {
  try {
    const { page, limit } = c.req.query()
    const result = await userService.list({ page: +page || 1, limit: +limit || 20 })
    return ok(c, result.users, { total: result.total, page: +page || 1, limit: +limit || 20 })
  } catch (e) {
    return err(c, 500, 'USERS_LIST_ERROR', 'Failed to list users')
  }
})

users.get('/:id', async (c) => {
  const user = await userService.findById(c.req.param('id'))
  if (!user) return err(c, 404, 'USER_NOT_FOUND', 'User not found')
  return ok(c, user)
})

users.post('/', async (c) => {
  const body = await c.req.json()
  const user = await userService.create(body)
  return ok(c, user, undefined, 201)
})
```

## Pagination Helpers

### Offset-based Pagination
```ts
// lib/pagination.ts
export const paginationSchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  sort: z.string().optional(),
  order: z.enum(['asc', 'desc']).default('desc'),
})

app.get(
  '/users',
  zValidator('query', paginationSchema),
  async (c) => {
    const { page, limit, sort, order } = c.req.valid('query')
    const users = await db.users.findMany({
      skip: (page - 1) * limit,
      take: limit,
      orderBy: sort ? { [sort]: order } : undefined,
    })
    const total = await db.users.count()
    return ok(c, users, { total, page, limit })
  }
)
```

### Cursor-based Pagination
```ts
const cursorSchema = z.object({
  cursor: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
})

app.get(
  '/users',
  zValidator('query', cursorSchema),
  async (c) => {
    const { cursor, limit } = c.req.valid('query')

    const users = await db.users.findMany({
      take: limit + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
    })

    const hasMore = users.length > limit
    if (hasMore) users.pop()

    const nextCursor = hasMore ? users[users.length - 1].id : undefined
    return ok(c, users, { cursor: nextCursor, limit })
  }
)
```

## File Upload Handling

### FormData Upload
```ts
app.post('/upload', async (c) => {
  const body = await c.req.parseBody()
  const file = body['file'] as File   // Web standard File
  const name = body['name'] as string

  const buffer = await file.arrayBuffer()
  const key = `uploads/${Date.now()}-${file.name}`

  await c.env.R2.put(key, buffer, {
    httpMetadata: { contentType: file.type },
  })

  return c.json({ url: `/files/${key}` }, 201)
})
```

### Multi-file Upload
```ts
app.post('/upload/multiple', async (c) => {
  const body = await c.req.formData()
  const files = body.getAll('files') as File[]

  const urls = await Promise.all(
    files.map(async (file) => {
      const key = `uploads/${Date.now()}-${file.name}`
      await c.env.R2.put(key, await file.arrayBuffer(), {
        httpMetadata: { contentType: file.type },
      })
      return { name: file.name, url: `/files/${key}`, size: file.size }
    })
  )

  return c.json({ files: urls }, 201)
})
```

## Cookie and Session Patterns

### Cookie Helpers
```ts
import { getCookie, setCookie, deleteCookie } from 'hono/cookie'

app.get('/profile', (c) => {
  const session = getCookie(c, 'session')
  if (!session) return c.json({ error: 'No session' }, 401)
  return c.json({ session })
})

app.post('/login', async (c) => {
  const { email, password } = await c.req.json()
  const user = await authUser(email, password)
  if (!user) return c.json({ error: 'Invalid credentials' }, 401)

  const token = await sign({ sub: user.id }, JWT_SECRET)

  setCookie(c, 'session', token, {
    httpOnly: true,
    secure: true,
    sameSite: 'Strict',
    path: '/',
    maxAge: 60 * 60 * 24 * 7, // 7 days
  })

  return c.json({ userId: user.id })
})

app.post('/logout', (c) => {
  deleteCookie(c, 'session', {
    path: '/',
    secure: true,
  })
  return c.json({ success: true })
})
```

### Session Middleware Pattern
```ts
import { getCookie } from 'hono/cookie'
import { verify } from 'hono/jwt'

const sessionMiddleware = (): MiddlewareHandler => async (c, next) => {
  const token = getCookie(c, 'session')
  if (!token) {
    c.set('user', null)
    return next()
  }

  try {
    const payload = await verify(token, JWT_SECRET)
    c.set('user', { id: payload.sub, ...payload })
  } catch {
    c.set('user', null)
  }

  await next()
}

// Optional auth — accessible to all, but reads session if present
app.use('*', sessionMiddleware())

// Required auth — blocks unauthenticated users
const requireAuth = (): MiddlewareHandler => async (c, next) => {
  const user = c.get('user')
  if (!user) return c.json({ error: 'Unauthorized' }, 401)
  await next()
}

app.get('/me', requireAuth(), (c) => {
  return c.json(c.get('user'))
})
```

## Request Context Storage (AsyncLocalStorage Pattern)
```ts
import { contextStorage, getContext } from 'hono/context-storage'

// Apply early in middleware chain
app.use('*', contextStorage())

// Access context anywhere (service layer, etc.)
import { getContext } from 'hono/context-storage'

async function getUserFromDb(id: string) {
  const c = getContext<MyEnv>()
  const db = c.env.DB
  return db.prepare('SELECT * FROM users WHERE id = ?').bind(id).first()
}
```

## Service Layer Pattern (Dependency Injection via Context)

```ts
// lib/db.ts — service factories
export const createServices = (c: Context<MyEnv>) => ({
  users: {
    findById: (id: string) => c.env.DB.prepare('SELECT * FROM users WHERE id = ?').bind(id).first(),
    list: (opts: { limit: number; offset: number }) => c.env.DB.prepare('SELECT * FROM users LIMIT ? OFFSET ?').bind(opts.limit, opts.offset).all(),
    create: (data: CreateUser) => c.env.DB.prepare('INSERT INTO users (name, email) VALUES (?, ?)').bind(data.name, data.email).run(),
    update: (id: string, data: UpdateUser) => c.env.DB.prepare('UPDATE users SET name = ?, email = ? WHERE id = ?').bind(data.name, data.email, id).run(),
    delete: (id: string) => c.env.DB.prepare('DELETE FROM users WHERE id = ?').bind(id).run(),
  },
})

// Usage in routes
app.get('/users', async (c) => {
  const { users } = createServices(c)
  const list = await users.list({ limit: 20, offset: 0 })
  return c.json(list)
})
```

## Deployment Patterns

### Cloudflare Workers
```ts
// wrangler.toml
// name = "my-api"
// main = "src/index.ts"
// compatibility_date = "2024-01-01"

// src/index.ts
import { Hono } from 'hono'
const app = new Hono<{ Bindings: CloudflareBindings }>()
  .get('/', (c) => c.text('Hello Workers!'))

export default app

// Deploy: npx wrangler deploy
```

### Deno
```ts
// main.ts
import { Hono } from 'hono'
import { handle } from 'hono/deno'
import { serveStatic } from 'hono/deno'

const app = new Hono()
  .use('/static/*', serveStatic({ root: './public' }))
  .get('/api/hello', (c) => c.json({ message: 'Hello Deno!' }))

Deno.serve({ port: 8000 }, handle(app))

// Deploy: deno run --allow-net main.ts
// Or: deployctl deploy --project=my-project main.ts
```

### Bun
```ts
// main.ts
import { Hono } from 'hono'
import { handle } from 'hono/bun'

const app = new Hono()
  .get('/api/hello', (c) => c.json({ message: 'Hello Bun!' }))

Bun.serve({ fetch: handle(app), port: 3000 })

// Run: bun run main.ts
```

### Node.js
```ts
// main.ts
import { Hono } from 'hono'
import { serve } from '@hono/node-server'

const app = new Hono()
  .get('/api/hello', (c) => c.json({ message: 'Hello Node!' }))

serve({ fetch: app.fetch, port: 3000 })
// Or simpler: serve(app)

// Run: tsx main.ts  (or ts-node, bun, etc.)
```

### Vercel Edge Functions
```ts
// api/index.ts (or api/[...route].ts)
import { Hono } from 'hono'
import { handle } from 'hono/vercel'

const app = new Hono()
  .get('/api/hello', (c) => c.json({ message: 'Hello Vercel!' }))

export default handle(app)
// vercel.json: { "rewrites": [{ "source": "/(.*)", "destination": "/api" }] }
```

### AWS Lambda
```ts
// src/lambda.ts
import { Hono } from 'hono'
import { handle } from 'hono/aws-lambda'

const app = new Hono()
  .get('/hello', (c) => c.json({ message: 'Hello Lambda!' }))

export const handler = handle(app)
```

### Netlify Functions
```ts
// netlify/edge-functions/api.ts
import { Hono } from 'hono'
import { handle } from 'hono/netlify'

const app = new Hono()
  .get('/hello', (c) => c.json({ message: 'Hello Netlify!' }))

export default handle(app)
```

## Runtime Support Matrix

| Runtime | Adapter | Serve Static | WebSocket | RPC | JSX | Notes |
|---------|---------|-------------|-----------|-----|-----|-------|
| Cloudflare Workers | built-in `hono/cloudflare-workers` | yes | yes | yes | yes | Primary target |
| Cloudflare Pages | built-in `hono/cloudflare-pages` | yes | yes | yes | yes | Functions + static |
| Deno | built-in `hono/deno` | yes (Deno.serve) | yes | yes | yes | v1.33+ recommended |
| Bun | built-in `hono/bun` | yes (Bun.serve) | yes | yes | yes | v1.2+ recommended |
| Node.js | `@hono/node-server` | yes | yes (via ws) | yes | yes | v16+ required |
| Vercel Edge | built-in `hono/vercel` | — | — | yes | yes | Edge runtime |
| AWS Lambda | built-in `hono/aws-lambda` | — | — | yes | yes | API Gateway v2 |
| Lambda@Edge | built-in `hono/lambda-edge` | — | — | yes | limited | |
| Netlify Functions | built-in `hono/netlify` | — | — | yes | yes | Edge Functions |
| Service Worker | built-in `hono/service-worker` | yes | — | — | — | Legacy |

## Instance Mounting (Interop with Other Frameworks)
```ts
import { Hono } from 'hono'
import { Router as IttyRouter } from 'itty-router'

const itty = IttyRouter()
  .get('/legacy', () => new Response('Legacy response'))

const app = new Hono()
  .mount('/legacy', itty.handle)
  .get('/new', (c) => c.text('New Hono route'))

// both /legacy/legacy and /new work
```

## Proxy Pattern
```ts
import { proxy } from 'hono/proxy'

app.get('/api/*', (c) => {
  return proxy(`https://upstream-api.com${c.req.path}`)
})
```

## SSG (Static Site Generation)
```ts
import { ssg } from 'hono/ssg'

const app = new Hono()
  .get('/about', (c) => c.html('<h1>About</h1>'))

ssg(app, {
  routes: ['/', '/about'],
  outputDir: './dist',
})

// Generates static HTML files from the routes
```
