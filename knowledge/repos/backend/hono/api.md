# Hono API Reference

> Source: [honojs/hono](https://github.com/honojs/hono) — 20K+ stars, v4.12
> Ultrafast edge-native web framework built on Web Standards. Runs on Cloudflare Workers, Deno, Bun, AWS Lambda, Vercel, and Node.js.

## Setup

```bash
# Create a new project
npm create hono@latest

# Or install into existing project
npm install hono
```

Minimal entry point:

```ts
import { Hono } from 'hono'
const app = new Hono()

app.get('/', (c) => c.text('Hono!'))

export default app
```

## All Exports (v4)

### Core (`'hono'`)
```ts
import { Hono } from 'hono'
export { Hono }

// Types
export type {
  Env, ErrorHandler, Handler, MiddlewareHandler, Next,
  NotFoundResponse, NotFoundHandler, ValidationTargets,
  Input, Schema, ToSchema, TypedResponse,
} from './types'
export type { Context, ContextVariableMap, ContextRenderer, ExecutionContext } from './context'
export type { HonoRequest } from './request'
export type { InferRequestType, InferResponseType, ClientRequestOptions } from './client'
```

### Standalone Sub-path Exports
```ts
// Presets (smaller bundles)
import { Hono } from 'hono/tiny'     // ~12KB, only TrieRouter
import { Hono } from 'hono/quick'    // QuickRouter

// Client (RPC)
import { hc } from 'hono/client'     // typesafe RPC client

// Middleware
import { cors } from 'hono/cors'
import { jwt, verify, decode, sign } from 'hono/jwt'
import { bearerAuth } from 'hono/bearer-auth'
import { basicAuth } from 'hono/basic-auth'
import { logger } from 'hono/logger'
import { etag } from 'hono/etag'
import { compress } from 'hono/compress'
import { csrf } from 'hono/csrf'
import { timeout } from 'hono/timeout'
import { timing } from 'hono/timing'
import { prettyJSON } from 'hono/pretty-json'
import { poweredBy } from 'hono/powered-by'
import { bodyLimit } from 'hono/body-limit'
import { cache } from 'hono/cache'
import { secureHeaders } from 'hono/secure-headers'
import { requestId } from 'hono/request-id'
import { combine } from 'hono/combine'
import { cors } from 'hono/cors'
import { jsxRenderer } from 'hono/jsx-renderer'
import { serveStatic } from 'hono/serve-static'
import { ipRestriction } from 'hono/ip-restriction'
import { methodOverride } from 'hono/method-override'
import { language } from 'hono/language'
import { trailingSlash } from 'hono/trailing-slash'
import { contextStorage, getContext } from 'hono/context-storage'

// Helpers
import { stream, streamSSE, SSEStreamingApi, streamText } from 'hono/streaming'
import { upgradeWebSocket, WSContext, WSEvents } from 'hono/ws'
import { getConnInfo } from 'hono/conninfo'
import { getCookie, setCookie, deleteCookie } from 'hono/cookie'
import { validator } from 'hono/validator'
import { factory } from 'hono/factory'
import { HTTPException } from 'hono/http-exception'
import { testClient } from 'hono/testing'

// Adapters
import { handle } from 'hono/cloudflare-workers'
import { handle } from 'hono/cloudflare-pages'
import { handle } from 'hono/deno'
import { handle } from 'hono/bun'
import { handle } from 'hono/aws-lambda'
import { handle } from 'hono/vercel'
import { handle } from 'hono/lambda-edge'
import { handle } from 'hono/netlify'
import { handle } from 'hono/service-worker'
```

## Hono Constructor

```ts
const app = new Hono({
  strict?: boolean,    // default: true. false = /hello == /hello/
  router?: Router,     // custom router
  getPath?: (req, options?) => string,  // custom path extraction
})
```

### Router Options
- SmartRouter (default): RegExpRouter + TrieRouter — fastest for most cases
- RegExpRouter: best for apps with many routes
- TrieRouter: smallest, bundled in `hono/tiny`
- PatternRouter: ultrasmall
- LinearRouter: simplest

## Routing

### HTTP Methods
```ts
app.get('/users', (c) => c.text('GET'))
app.post('/users', (c) => c.json({ created: true }))
app.put('/users/:id', (c) => c.json({ updated: c.req.param('id') }))
app.patch('/users/:id', (c) => c.text('PATCHED'))
app.delete('/users/:id', (c) => c.text('DELETED'))
app.options('/users', (c) => c.text('OPTIONS'))
app.all('/users', (c) => c.text('ALL methods'))
```

### Multi-method and Multi-path with `on()`
```ts
app.on(['GET', 'POST'], '/users', (c) => c.text('GET or POST'))
app.on('GET', ['/users', '/accounts'], (c) => c.text('multiple paths'))
app.on('PUT', '/users/:id', handler1, handler2)
```

### Path Parameters and Wildcards
```ts
app.get('/users/:id', (c) => {
  const id = c.req.param('id')       // named param
  return c.text(id)
})

app.get('/posts/:id/comment/:commentId', (c) => {
  const { id, commentId } = c.req.param()
  return c.json({ id, commentId })
})

app.get('/static/*', (c) => {
  return c.text(`Matched: ${c.req.path}`)  // /static/js/app.js
})
```

### Route Grouping (`route()`)
```ts
const api = new Hono()
api.get('/users', (c) => c.json([]))
api.get('/posts', (c) => c.json([]))

const app = new Hono()
app.route('/api', api)  // mounts api routes under /api
// Now: GET /api/users, GET /api/posts
```

### Base Path (`basePath()`)
```ts
const api = new Hono().basePath('/api')
api.get('/users', (c) => c.json([]))  // GET /api/users
```

### Chaining
```ts
app.get('/hello', (c) => c.text('Hello'))
   .post('/hello', (c) => c.text('Created'))
```

### Routing Priority
Routes are matched in the order they are defined. More specific paths take priority over wildcards.

## Context (`c`)

The Context object is available in every handler and middleware.

### Request Access
```ts
c.req.url          // full URL string
c.req.path         // pathname
c.req.method       // HTTP method
c.req.query('key') // query parameter
c.req.queries('key') // all values for repeating query param
c.req.param('id')  // path parameter
c.req.header('X-Custom') // request header
c.req.parseBody()  // parse body (any format)
c.req.json()       // parse JSON body
c.req.text()       // parse text body
c.req.formData()   // parse FormData
c.req.arrayBuffer()// parse ArrayBuffer
c.req.blob()       // parse Blob
c.req.valid('json') // validated input from middleware
c.req.raw          // native Request object
```

### Response Methods
```ts
c.text('Hello')                    // text/plain
c.json({ message: 'Hello' })      // application/json
c.html('<h1>Hello</h1>')          // text/html
c.body('raw data')                 // custom body
c.redirect('/home')                // 302 redirect
c.redirect('/home', 301)           // permanent redirect
c.notFound()                       // 404 response
c.newResponse(data, status, headers) // raw Response builder
```

### Headers and Status
```ts
c.header('X-Custom', 'value')      // set response header
c.header('X-Multi', 'a', { append: true }) // append header
c.status(201)                       // set status code
c.res                              // Response object (read/write)
```

### Environment Variables
```ts
// In Cloudflare Workers
c.env.KV_NAMESPACE
c.env.DATABASE_ID
```

### Context Variables (Middleware -> Route communication)
```ts
// Middleware sets value
app.use('*', async (c, next) => {
  c.set('user', { id: 1, name: 'Alice' })
  await next()
})

// Route reads value
app.get('/profile', (c) => {
  const user = c.get('user')
  c.var.user  // also accessible via .var
  return c.json(user)
})
```

### Layout and Renderer
```ts
// Set a layout renderer in middleware
app.use('*', async (c, next) => {
  c.setRenderer((content) => {
    return c.html(`<html><body>${content}</body></html>`)
  })
  await next()
})

// Routes use render via c.render()
app.get('/page', (c) => {
  return c.render('<p>page content</p>')
})
```

## Handler and MiddlewareHandler Types

```ts
import type { Handler, MiddlewareHandler, Env } from 'hono'

// Handler = (c: Context, next: Next) => Response | Promise<Response>
const handler: Handler = (c) => c.text('OK')

// MiddlewareHandler = (c: Context, next: Next) => Promise<void | Response>
const middleware: MiddlewareHandler = async (c, next) => {
  // before
  await next()
  // after
}

// Custom environment (for Cloudflare bindings)
type MyEnv = {
  Bindings: { KV: KVNamespace }
  Variables: { userId: number }
}
const app = new Hono<MyEnv>()
```

## Middleware Usage

### App-level (all routes)
```ts
app.use('*', logger())
app.use('*', cors())
app.use('*', prettyJSON())
```

### Path-scoped
```ts
app.use('/api/*', bearerAuth({ token: 'secret' }))
app.use('/admin/*', basicAuth({ username: 'admin', password: 'pass' }))
```

### Route-specific
```ts
app.post('/submit', validator('json', schema), (c) => {
  const data = c.req.valid('json')
  return c.json(data)
})
```

## Built-in Middleware (27 total)

| Middleware | Import | Purpose |
|------------|--------|---------|
| cors | `hono/cors` | Cross-Origin Resource Sharing |
| jwt | `hono/jwt` | JWT authentication |
| bearer-auth | `hono/bearer-auth` | Bearer token auth |
| basic-auth | `hono/basic-auth` | Basic auth |
| logger | `hono/logger` | Request/response logging |
| compress | `hono/compress` | Gzip/brotli/deflate compression |
| csrf | `hono/csrf` | Cross-Site Request Forgery protection |
| etag | `hono/etag` | ETag-based caching |
| body-limit | `hono/body-limit` | Limit request body size |
| cache | `hono/cache` | Response caching headers |
| timeout | `hono/timeout` | Request timeout |
| timing | `hono/timing` | Server-Timing header |
| pretty-json | `hono/pretty-json` | Pretty-print JSON responses |
| powered-by | `hono/powered-by` | X-Powered-By header |
| secure-headers | `hono/secure-headers` | Security headers (XSS, frame, etc.) |
| request-id | `hono/request-id` | X-Request-Id header |
| combine | `hono/combine` | Combine multiple middleware into one |
| ip-restriction | `hono/ip-restriction` | IP allow/deny lists |
| method-override | `hono/method-override` | _method param/POST override |
| language | `hono/language` | Content-Language negotiation |
| trailing-slash | `hono/trailing-slash` | Append/remove trailing slash |
| context-storage | `hono/context-storage` | Access context outside handler |
| jsx-renderer | `hono/jsx-renderer` | JSX layout/middleware renderer |
| serve-static | `hono/serve-static` | Serve static files |
| jwk | `hono/jwk` | JWT via JSON Web Key set |

## Validation (zValidator)

Hono does NOT bundle Zod. Use `hono/validator` with Zod:

```ts
import { z } from 'zod'
import { zValidator } from '@hono/zod-validator'

const userSchema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
  age: z.number().int().min(0),
})

app.post('/users', zValidator('json', userSchema), (c) => {
  const data = c.req.valid('json')  // typed as { name: string, email: string, age: number }
  return c.json({ created: data.name })
})
```

Built-in validator (without Zod):
```ts
import { validator } from 'hono/validator'

app.post('/users', validator('json', (value, c) => {
  if (!value || typeof value.name !== 'string') {
    return c.json({ error: 'Invalid' }, 400)
  }
  return { name: value.name }
}), (c) => {
  const { name } = c.req.valid('json')
  return c.json({ name })
})
```

## RPC Client (`hc`)

Type-safe client that shares route types with the server:

### Server (define routes with types)
```ts
// server.ts
const app = new Hono()
  .get('/users/:id', (c) => c.json({ id: c.req.param('id'), name: 'Alice' }))
  .post('/users', async (c) => {
    const body = await c.req.json()
    return c.json({ created: body.name }, 201)
  })

type AppType = typeof app
export type { AppType }
export default app
```

### Client (type-safe calls)
```ts
// client.ts
import { hc } from 'hono/client'
import type { AppType } from './server'

const client = hc<AppType>('http://localhost:3000')

// GET with path params
const getRes = await client.users[':id'].$get({ param: { id: '1' } })
const getUser = await getRes.json()

// POST with JSON body
const postRes = await client.users.$post({ json: { name: 'Bob' } })
const created = await postRes.json()

// Query params, headers, cookies
const res = await client.users.$get({
  query: { page: '1' },
  header: { Authorization: 'Bearer token' },
  cookie: { session: 'abc' },
})

// Duplicate query params with arrays
const res = await client.search.$get({
  query: { tag: ['foo', 'bar'] }  // ?tag=foo&tag=bar
})

// Form data
const res = await client.upload.$post({ form: { file: blob } })

// WebSocket
const ws = client.chat.$ws()

// Access URL/Path
client.users[':id'].$url({ param: { id: '1' } })   // URL object
client.users[':id'].$path()                          // /users/:id
```

## Error Handling

### HTTPException
```ts
import { HTTPException } from 'hono/http-exception'

app.get('/admin', (c) => {
  throw new HTTPException(401, { message: 'Unauthorized' })
})

// Custom response
throw new HTTPException(403, {
  res: new Response('Forbidden', { status: 403 })
})
```

### Custom Error Handler
```ts
app.onError((err, c) => {
  if (err instanceof HTTPException) {
    return err.getResponse()
  }
  console.error(err)
  return c.json({ error: 'Internal Server Error' }, 500)
})
```

### Not Found Handler
```ts
app.notFound((c) => {
  return c.json({ error: 'Not Found', path: c.req.path }, 404)
})
```

## Adapters (Runtime Entry Points)

```ts
// Cloudflare Workers
import { Hono } from 'hono'
import { handle } from 'hono/cloudflare-workers'
const app = new Hono()
// ... routes
export default app  // ES module worker format
// OR: export default handle(app) // for service-worker format

// Deno
import { Hono } from 'hono'
import { handle } from 'hono/deno'
const app = new Hono()
Deno.serve(handle(app))

// Bun
import { Hono } from 'hono'
import { handle } from 'hono/bun'
const app = new Hono()
Bun.serve({ fetch: handle(app) })

// Node.js (via @hono/node-server)
import { Hono } from 'hono'
import { serve } from '@hono/node-server'
const app = new Hono()
serve(app)  // default port 3000

// AWS Lambda
import { Hono } from 'hono'
import { handle } from 'hono/aws-lambda'
export const handler = handle(app)

// Vercel Edge Functions
import { Hono } from 'hono'
import { handle } from 'hono/vercel'
export default handle(app)
```

## Presets (Bundle Size Optimization)

| Preset | Import | Router | Size | Use Case |
|--------|--------|--------|------|----------|
| Default | `hono` | SmartRouter | ~17KB | General use |
| Tiny | `hono/tiny` | TrieRouter | <12KB | Minimal/minimal routes |
| Quick | `hono/quick` | LinearRouter | ~7KB | Few routes, minimal overhead |

## Testing

```ts
import { testClient } from 'hono/testing'

const app = new Hono().get('/hello', (c) => c.json({ message: 'Hi' }))
const client = testClient(app)

test('GET /hello returns message', async () => {
  const res = await client.hello.$get()
  expect(res.status).toBe(200)
  expect(await res.json()).toEqual({ message: 'Hi' })
})

// Or use app.request() directly
test('GET /hello', async () => {
  const res = await app.request('/hello')
  expect(res.status).toBe(200)
})
```
