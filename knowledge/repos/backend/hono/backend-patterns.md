# Hono Backend Patterns

> Source: [honojs/hono](https://github.com/honojs/hono)
> Backend-specific middleware patterns, validation strategies, and response formats.

## Middleware Patterns

### CORS Configuration
```ts
import { cors } from 'hono/cors'

// Open to all origins (default: *)
app.use('/api/*', cors())

// Restricted origin with credentials
app.use('/api/*', cors({
  origin: 'https://myapp.com',
  allowMethods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowHeaders: ['Content-Type', 'Authorization'],
  exposeHeaders: ['Content-Length', 'X-Request-Id'],
  maxAge: 600,
  credentials: true,
}))

// Dynamic origin list
app.use('/api/*', cors({
  origin: ['https://app1.com', 'https://app2.com'],
}))

// Async origin validation (whitelist from DB)
app.use('/api/*', cors({
  origin: async (origin, c) => {
    const allowed = await checkOriginInDatabase(origin)
    return allowed ? origin : null
  },
}))
```

### Authentication: Bearer Token
```ts
import { bearerAuth } from 'hono/bearer-auth'

// Static token
app.use('/api/*', bearerAuth({ token: 'my-secret-token' }))

// Multiple tokens
app.use('/api/*', bearerAuth({ token: ['token-a', 'token-b'] }))

// Dynamic verification
app.use('/api/*', bearerAuth({
  verifyToken: async (token, c) => {
    const valid = await db.tokens.isValid(token)
    return valid
  },
}))

// Custom error responses
app.use('/api/admin/*', bearerAuth({
  token: ADMIN_TOKEN,
  realm: 'admin',
  invalidTokenMessage: { error: 'Invalid admin token' },
  noAuthenticationHeaderMessage: { error: 'Missing Authorization header' },
}))
```

### Authentication: JWT
```ts
import { jwt, sign, verify, decode } from 'hono/jwt'

// Verify JWT (HS256 default)
app.use('/api/*', jwt({ secret: process.env.JWT_SECRET! }))

// RS256
app.use('/api/*', jwt({ secret: publicKey, alg: 'RS256' }))

// Custom payload validation + store in context
app.use('/api/*', jwt({
  secret: process.env.JWT_SECRET!,
}), async (c, next) => {
  const payload = c.get('jwtPayload')  // JWT middleware sets this
  c.set('userId', payload.sub)
  c.set('userRole', payload.role)
  await next()
})

// Sign tokens
const token = await sign({ sub: 'user-1', role: 'admin' }, JWT_SECRET)

// Decode without verification (for reading headers)
const { header, payload } = decode(token)

// Manual verify (for non-middleware cases)
const validatedPayload = await verify(token, JWT_SECRET)

// JWK (JSON Web Key) support
import { jwk } from 'hono/jwk'
app.use('/api/*', jwk({ jwksUri: 'https://auth.example.com/.well-known/jwks.json' }))
```

### Authentication: Basic Auth
```ts
import { basicAuth } from 'hono/basic-auth'

const credentials = { username: 'admin', password: 'secret' }

app.use('/admin/*', basicAuth(credentials))

// Custom verify function
app.use('/admin/*', basicAuth({
  verifyUser: (username, password, c) => {
    return username === 'admin' && hashVerify(password, storedHash)
  },
}))
```

### Logging
```ts
import { logger } from 'hono/logger'

// Default console.log
app.use('*', logger())

// Custom log function
app.use('*', logger((message, ...rest) => {
  myLogger.info(message, ...rest)
}))
```

### Rate Limiting (Custom Implementation)
Hono doesn't ship a built-in rate limiter. Use middleware pattern:

```ts
import type { MiddlewareHandler } from 'hono'

interface RateStore {
  [ip: string]: { count: number; resetTime: number }
}

const rateLimiter = (options: { max: number; windowMs: number }): MiddlewareHandler => {
  const store: RateStore = {}

  return async (c, next) => {
    const ip = c.req.header('CF-Connecting-IP') ||
               c.req.header('X-Forwarded-For') ||
               'unknown'
    const now = Date.now()

    const entry = store[ip]
    if (entry && now < entry.resetTime) {
      if (entry.count >= options.max) {
        return c.json({ error: 'Too many requests' }, 429)
      }
      entry.count++
    } else {
      store[ip] = { count: 1, resetTime: now + options.windowMs }
    }

    await next()
  }
}

app.use('/api/*', rateLimiter({ max: 100, windowMs: 60_000 }))
```

### Security Headers
```ts
import { secureHeaders } from 'hono/secure-headers'

// Apply all recommended security headers
app.use('*', secureHeaders())

// Customize specific headers
app.use('*', secureHeaders({
  xFrameOptions: 'DENY',
  xContentTypeOptions: 'nosniff',
  referrerPolicy: 'strict-origin-when-cross-origin',
  contentSecurityPolicy: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'", 'https://cdn.example.com'],
  },
  strictTransportSecurity: 'max-age=63072000; includeSubDomains',
}))
```

### Body Size Limit
```ts
import { bodyLimit } from 'hono/body-limit'

app.post('/upload', bodyLimit({ maxSize: 1024 * 1024 * 10 }), handler)  // 10MB

app.post('/contact', bodyLimit({ maxSize: 4096 }), handler)  // 4KB
```

### Compression
```ts
import { compress } from 'hono/compress'

app.use('*', compress())  // gzip/deflate based on Accept-Encoding
```

### Timeout
```ts
import { timeout } from 'hono/timeout'

app.get('/slow', timeout(5000), async (c) => {
  await heavyWork()
  return c.text('Done')
})
```

### Request ID
```ts
import { requestId } from 'hono/request-id'

app.use('*', requestId())
// Sets X-Request-Id header on response. Uses incoming X-Request-Id or generates UUID.
```

### CSRF Protection
```ts
import { csrf } from 'hono/csrf'

app.use('*', csrf())
// For non-GET/HEAD/OPTIONS requests, validates origin matches request origin
```

## Route Grouping Strategies

### Domain-Oriented Grouping
```ts
const app = new Hono()

// Auth routes
const auth = new Hono()
  .post('/login', loginHandler)
  .post('/register', registerHandler)
  .post('/refresh', refreshHandler)

// User routes (protected)
const users = new Hono()
  .use('*', authGuard())
  .get('/', listUsers)
  .get('/:id', getUser)
  .patch('/:id', updateUser)

// Public routes
const public = new Hono()
  .get('/health', (c) => c.json({ status: 'ok' }))
  .get('/posts', listPosts)

app
  .route('/auth', auth)
  .route('/users', users)
  .route('/', public)
```

### Versioned API Grouping
```ts
const v1 = new Hono()
  .get('/users', listUsersV1)
  .get('/posts', listPostsV1)

const v2 = new Hono()
  .get('/users', listUsersV2)
  .get('/posts', listPostsV2)

app
  .route('/api/v1', v1)
  .route('/api/v2', v2)
```

## Validation with Zod

### Full Validation Coverage
```ts
import { z } from 'zod'
import { zValidator } from '@hono/zod-validator'

// All targets: json, form, query, param, header, cookie
const createUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().int().min(0).optional(),
})

const userIdParam = z.object({ id: z.string().uuid() })

const paginationQuery = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
})

app.post(
  '/users',
  zValidator('json', createUserSchema),
  zValidator('header', z.object({ 'content-type': z.string().includes('json') })),
  async (c) => {
    const body = c.req.valid('json')       // typed as createUserSchema
    return c.json({ created: body.name }, 201)
  }
)

app.get(
  '/users/:id',
  zValidator('param', userIdParam),
  zValidator('query', paginationQuery),
  async (c) => {
    const { id } = c.req.valid('param')
    const { page, limit } = c.req.valid('query')
    const user = await paginate(id, page, limit)
    return c.json(user)
  }
)
```

### Custom Error Format for Validation
```ts
const app = new Hono()

app.onError((err, c) => {
  if (err instanceof z.ZodError) {
    return c.json({
      error: 'Validation failed',
      details: err.errors.map(e => ({
        path: e.path.join('.'),
        message: e.message,
      })),
    }, 422)  // Unprocessable Entity
  }
  return c.json({ error: 'Internal error' }, 500)
})
```

### Validation Middleware Factory
```ts
import { validator } from 'hono/validator'

// Built-in validator (no zod needed)
app.post('/login', validator('json', (value, c) => {
  if (!value || typeof value.email !== 'string') {
    return c.json({ error: 'Missing email' }, 400)
  }
  return {
    email: value.email,
    password: value.password,
  }
}), async (c) => {
  const { email, password } = c.req.valid('json')
  // ...
})
```

## Error Response Format

### Standard Error Envelope
```ts
// Consistent error response shape
type ErrorResponse = {
  success: false
  error: {
    code: string
    message: string
    details?: unknown
  }
}

// Helper
const errorResponse = (c: Context, status: number, code: string, message: string, details?: unknown) => {
  return c.json({
    success: false,
    error: { code, message, details },
  }, status as any)
}

app.onError((err, c) => {
  if (err instanceof HTTPException) {
    return errorResponse(c, err.status, 'HTTP_ERROR', err.message)
  }
  console.error(err)
  return errorResponse(c, 500, 'INTERNAL_ERROR', 'An unexpected error occurred')
})
```

### Standard Success Envelope
```ts
type SuccessResponse<T> = {
  success: true
  data: T
  meta?: {
    total: number
    page: number
    limit: number
  }
}

const successResponse = <T>(c: Context, data: T, meta?: SuccessResponse<T>['meta'], status = 200) => {
  return c.json({ success: true, data, meta }, status as any)
}

app.get('/users', async (c) => {
  const { page, limit } = c.req.query()
  const { users, total } = await paginatedUsers(Number(page), Number(limit))
  return successResponse(c, users, { total, page: Number(page), limit: Number(limit) })
})
```

## Streaming and SSE

### Server-Sent Events
```ts
import { streamSSE } from 'hono/streaming'

app.get('/events', (c) => {
  return streamSSE(c, async (stream) => {
    // Write SSE messages
    await stream.writeSSE({ data: 'connected', event: 'open' })

    let count = 0
    while (true) {
      await stream.sleep(1000)
      await stream.writeSSE({ data: String(count++), event: 'tick' })
    }
  })
})

// On client:
// const source = new EventSource('/events')
// source.addEventListener('tick', (e) => console.log(e.data))
```

### Response Streaming
```ts
import { stream, streamText } from 'hono/streaming'

app.get('/stream', (c) => {
  return stream(c, async (stream) => {
    await stream.write(new Uint8Array([0x48, 0x65, 0x6c]))  // "Hel"
    await stream.sleep(500)
    await stream.write(new Uint8Array([0x6c, 0x6f]))         // "lo"
    await stream.close()
  })
})

app.get('/chat', (c) => {
  return streamText(c, async (stream) => {
    const chunks = await aiGenerateStream('hello')
    for (const chunk of chunks) {
      await stream.write(chunk)
      await stream.sleep(50)
    }
  })
})
```

### SSE Chat Completion Pattern
```ts
import { streamSSE, SSEStreamingApi } from 'hono/streaming'

app.post('/chat/completions', async (c) => {
  const { message } = await c.req.json()
  const userId = c.get('userId')

  return streamSSE(c, async (stream) => {
    let fullText = ''
    const generator = await aiGenerate(message)

    for await (const chunk of generator) {
      fullText += chunk
      await stream.writeSSE({ data: JSON.stringify({ delta: chunk, full: fullText }) })
    }

    await stream.writeSSE({ data: '[DONE]', event: 'done' })
  })
})
```

## WebSocket Support

### WebSocket Helper
```ts
import { upgradeWebSocket } from 'hono/cloudflare-workers'
import type { WSContext, WSEvents } from 'hono/ws'

// Or for general use:
// import { upgradeWebSocket } from 'hono/ws'

app.get('/ws', upgradeWebSocket((c) => ({
  onOpen(event, ws) {
    console.log('Connected')
    ws.send('Welcome!')
  },
  onMessage(event, ws) {
    console.log('Message:', event.data)
    ws.send(`Echo: ${event.data}`)
  },
  onClose(event, ws) {
    console.log('Disconnected')
  },
  onError(event, ws) {
    console.error('WebSocket error')
  },
})))
```

### Chat Room Pattern
```ts
const rooms = new Map<string, Set<WSContext>>()

app.get('/chat/:roomId', upgradeWebSocket((c) => {
  const roomId = c.req.param('roomId')

  return {
    onOpen(_, ws) {
      if (!rooms.has(roomId)) rooms.set(roomId, new Set())
      rooms.get(roomId)!.add(ws)
      ws.send(JSON.stringify({ type: 'joined', room: roomId }))
    },
    onMessage(event, ws) {
      const room = rooms.get(roomId)
      room?.forEach(client => {
        if (client !== ws) client.send(event.data.toString())
      })
    },
    onClose(_, ws) {
      rooms.get(roomId)?.delete(ws)
      if (rooms.get(roomId)?.size === 0) rooms.delete(roomId)
    },
  }
}))
```

## Middleware Execution Order

```
Request
  |
  v
Global middleware (app.use('*', ...))
  |
  v
Scoped middleware (app.use('/path/*', ...))
  |
  v
Route-level middleware (app.get('/path', mw, handler))
  |
  v
Handler
  |
  v
Response (after middleware post-hooks in reverse order)
```

Full lifecycle example:
```ts
const mw1 = async (c, next) => {
  console.log('mw1 before')
  await next()
  console.log('mw1 after')
}

const mw2 = async (c, next) => {
  console.log('mw2 before')
  await next()
  console.log('mw2 after')
}

app.use('*', mw1)
app.get('/test', mw2, (c) => {
  console.log('handler')
  return c.text('OK')
})

// Logs: mw1 before -> mw2 before -> handler -> mw2 after -> mw1 after
```

## Custom Middleware Type Safety
```ts
import type { MiddlewareHandler, Env } from 'hono'

// Typed middleware that adds to context
type AuthEnv = {
  Variables: {
    user: { id: string; role: 'user' | 'admin' }
  }
}

const authMiddleware = (): MiddlewareHandler<AuthEnv> => async (c, next) => {
  const payload = await verifyToken(c.req.header('Authorization'))
  c.set('user', { id: payload.sub, role: payload.role })
  await next()
}

// Downstream routes have typed access
const app = new Hono<AuthEnv>()
app.use('*', authMiddleware())
app.get('/me', (c) => {
  const user = c.get('user')  // typed as { id: string; role: 'user' | 'admin' }
  return c.json(user)
})
```
