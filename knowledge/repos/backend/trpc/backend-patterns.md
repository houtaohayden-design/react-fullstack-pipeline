# tRPC Backend Architecture Patterns

> Server-side architecture: router composition, middleware pipelines, auth propagation, error hierarchies, rate limiting, logging, and request lifecycle.

## API Architecture: Router Composition

tRPC uses a tree-based router composition model where sub-routers form a hierarchy. This maps naturally to domain boundaries.

```
appRouter (root)
  ├── auth (sub-router)
  │   ├── login (mutation)
  │   ├── register (mutation)
  │   └── me (query)
  ├── user (sub-router)
  │   ├── getById (query)
  │   ├── updateProfile (mutation)
  │   └── deleteAccount (mutation)
  ├── post (sub-router)
  │   ├── list (query)
  │   ├── getById (query)
  │   ├── create (mutation)
  │   └── delete (mutation)
  └── subscription
      └── onPostUpdate (subscription)
```

Router merge strategies:

| Approach | Use Case |
|----------|----------|
| `t.router({ key: subRouter })` | Namespaced, clear URL paths: `/trpc/post.list` |
| `mergeRouters(r1, r2)` | Flat merged, no extra namespace |
| `lazy(() => import('./r'))` | Code-split, loaded on first call |

## Middleware Pipeline Architecture

### Execution Order

Middleware executes in LIFO (stack) order around the resolver:

```
Request
  -> Middleware 1 (before)
    -> Middleware 2 (before)
      -> Middleware 3 (before)
        -> Resolver (core logic)
      <- Middleware 3 (after)
    <- Middleware 2 (after)
  <- Middleware 1 (after)
Response
```

Each middleware calls `await next()` to proceed. Without `next()`, the pipeline stops (short-circuit).

### Middleware Categories

```
Layer 1: Transport middleware
  - CORS headers
  - Request logging
  - Response timing

Layer 2: Security middleware
  - Rate limiting
  - Auth token extraction
  - Session validation

Layer 3: Domain middleware
  - Context enrichment (attach user, tenant, db)
  - Permission checks
  - Input preprocessing

Layer 4: Procedure middleware
  - Procedure-specific validation
  - Feature flags
  - Audit logging
```

### Composing Middleware

```typescript
// Independent middleware pieces
const withTiming = t.middleware(async ({ path, next }) => {
  const start = Date.now();
  const result = await next();
  const duration = Date.now() - start;
  console.log(`[${path}] ${duration}ms`);
  return result;
});

const withAuth = t.middleware(async ({ ctx, next }) => {
  const user = await validateSession(ctx.req);
  if (!user) throw new TRPCError({ code: 'UNAUTHORIZED' });
  return next({ ctx: { user } });
});

const withTenant = t.middleware(async ({ ctx, next }) => {
  const tenantId = ctx.req.headers.get('x-tenant-id');
  return next({ ctx: { tenantId } });
});

// Chain them
const baseProcedure = t.procedure
  .use(withTiming)
  .use(withAuth)
  .use(withTenant);
```

### Pipe Composition (Middleware Builder)

Combine middleware into a reusable builder without attaching to a procedure:

```typescript
const authPipeline = t.middleware
  .unstable_pipe(withAuth, withTenant, withTiming);

// Use the composed pipeline
const protectedProcedure = t.procedure.use(authPipeline);
```

## Auth Context Propagation Pattern

### Three-Layer Auth Architecture

```typescript
// Layer 1: Extract token/session from request
const extractSession = t.middleware(async ({ ctx, next }) => {
  const token = ctx.req.headers.get('authorization')?.split(' ')[1];
  // Don't throw here -- allow unauthenticated requests to pass
  return next({ ctx: { ...ctx, token } });
});

// Layer 2: Validate and attach user (for protected routes)
const requireAuth = t.middleware(async ({ ctx, next }) => {
  if (!ctx.token) throw new TRPCError({ code: 'UNAUTHORIZED' });
  const user = await verifyToken(ctx.token);
  return next({ ctx: { user } });
});

// Layer 3: Role-level authorization
const requireRole = (role: string) =>
  t.middleware(async ({ ctx, next }) => {
    if (ctx.user.role !== role) throw new TRPCError({ code: 'FORBIDDEN' });
    return next();
  });

// Procedure tiers
export const publicProcedure = t.procedure.use(extractSession);
export const protectedProcedure = publicProcedure.use(requireAuth);
export const adminProcedure = protectedProcedure.use(requireRole('admin'));
```

Context flows through all layers typed:

```
Request -> extractSession -> ctx.token: string
       -> requireAuth     -> ctx.token + ctx.user: User
       -> requireRole     -> ctx.token + ctx.user: User (narrowed role)
       -> Resolver        -> Full typed context
```

## Input Validation Layer

### Validation Pipeline

```
Raw HTTP body
  -> Content-type detection (application/json by default)
  -> Standard Schema v1 parse (Zod, Valibot, ArkType)
  -> Success: typed input -> resolver
  -> Failure: TRPCError BAD_REQUEST (400) with formatted ZodError
```

### Input Architecture

```typescript
// Reusable schemas
const idSchema = z.object({ id: z.string().uuid() });
const paginationSchema = z.object({
  limit: z.number().int().min(1).max(100).default(20),
  cursor: z.string().optional(),
});
const sortSchema = z.object({
  sortBy: z.enum(['createdAt', 'updatedAt', 'title']).default('createdAt'),
  sortOrder: z.enum(['asc', 'desc']).default('desc'),
});

// Compose schemas
const listInput = paginationSchema.merge(sortSchema).extend({
  search: z.string().max(200).optional(),
  status: z.enum(['draft', 'published', 'archived']).optional(),
});

// Each procedure validates independently
postRouter.list = t.procedure.input(listInput).query(...);
postRouter.getById = t.procedure.input(idSchema).query(...);
postRouter.create = t.procedure.input(createSchema).mutation(...);
```

### Output Validation (Optional)

```typescript
const userOutput = z.object({
  id: z.string(),
  name: z.string(),
  email: z.string().email(),
});

t.procedure
  .input(...)
  .output(userOutput)  // Runtime output validation in dev
  .query(async ({ input, ctx }) => {
    const user = await ctx.db.user.findUnique(...);
    return user; // Validated against userOutput
  });
```

## Error Handling Hierarchy

### Error Layers

```
Layer 1: Zod validation errors  -> TRPCError BAD_REQUEST (auto)
Layer 2: Middleware errors       -> TRPCError UNAUTHORIZED / FORBIDDEN
Layer 3: Resolver errors         -> TRPCError NOT_FOUND / CONFLICT
Layer 4: Uncaught exceptions     -> TRPCError INTERNAL_SERVER_ERROR (auto)
```

### Centralized Error Formatter

```typescript
const t = initTRPC.context<Context>().create({
  errorFormatter({ shape, error, ctx, type, path, input }) {
    // Log all errors centrally
    if (error.code === 'INTERNAL_SERVER_ERROR') {
      logger.error(`[${path}]`, { error, input, userId: ctx?.user?.id });
    }

    return {
      ...shape,
      data: {
        ...shape.data,
        path,                    // Procedure path
        type,                    // query | mutation | subscription
        // Add custom fields
        requestId: ctx?.requestId,
        ...(error.code === 'BAD_REQUEST' && {
          validationErrors: (error.cause as ZodError)?.flatten(),
        }),
      },
    };
  },
});
```

### Error Handling in Procedures

```typescript
t.procedure.query(async ({ input, ctx }) => {
  // NotFound -> 404
  const user = await ctx.db.user.findUnique({ where: { id: input.id } });
  if (!user) throw new TRPCError({ code: 'NOT_FOUND', message: 'User not found' });

  return user;
});

t.procedure.mutation(async ({ input, ctx }) => {
  // Conflict -> 409
  const existing = await ctx.db.user.findUnique({ where: { email: input.email } });
  if (existing) throw new TRPCError({
    code: 'CONFLICT',
    message: 'Email already in use',
  });

  return ctx.db.user.create({ data: input });
});

t.procedure.mutation(async ({ input, ctx }) => {
  // Wrap unknown errors
  try {
    return await externalAPI.call(input);
  } catch (cause) {
    throw new TRPCError({
      code: 'INTERNAL_SERVER_ERROR',
      message: 'External API failed',
      cause,
    });
  }
});
```

## Rate Limiting Integration

```typescript
// Rate limiting middleware
const rateLimit = t.middleware(async ({ ctx, path, next }) => {
  const key = `ratelimit:${ctx.session?.user?.id ?? ctx.req.ip}:${path}`;
  const { success, limit, remaining, reset } = await rateLimiter.limit(key);

  // Set rate limit headers (for fetch adapter)
  ctx.res?.headers.set('X-RateLimit-Limit', String(limit));
  ctx.res?.headers.set('X-RateLimit-Remaining', String(remaining));
  ctx.res?.headers.set('X-RateLimit-Reset', String(reset));

  if (!success) {
    throw new TRPCError({
      code: 'TOO_MANY_REQUESTS',
      message: `Rate limit exceeded. Retry after ${reset} seconds.`,
    });
  }

  return next();
});

// Apply to specific procedures
const rateLimitedProcedure = t.procedure.use(rateLimit);

// Or apply to mutation-heavy routers only
const authRouter = router({
  login: rateLimitedProcedure.input(loginSchema).mutation(...),
  register: rateLimitedProcedure.input(registerSchema).mutation(...),
});
```

## Logging Middleware

```typescript
const logger = t.middleware(async ({ path, type, input, ctx, next }) => {
  const start = Date.now();
  const requestId = ctx.requestId ?? crypto.randomUUID();

  // Request log
  console.log(`[${requestId}] ${type.toUpperCase()} ${path}`, {
    userId: ctx.user?.id,
    input: JSON.stringify(input),
  });

  try {
    const result = await next();
    const duration = Date.now() - start;

    // Success log
    console.log(`[${requestId}] ${path} OK ${duration}ms`);

    // Return result with timing metadata
    return {
      ...result,
      headers: {
        ...result.headers,
        'X-Response-Time': `${duration}ms`,
      },
    };
  } catch (error) {
    const duration = Date.now() - start;
    console.error(`[${requestId}] ${path} ERROR ${duration}ms`, error);
    throw error; // Re-throw to let error formatter handle it
  }
});

// Apply to all procedures
export const baseProcedure = t.procedure.use(logger);
```

## Request Lifecycle (Full Flow)

```
1. HTTP Request arrives
   -> Adapter extracts req/res/headers
   -> Adapter parses path (e.g., /api/trpc/post.list?batch=1&input=...)

2. Context creation
   -> createContext({ req, res, ...adapter-info })
   -> Returns typed context object

3. Procedure resolution
   -> Parse procedure path from URL
   -> Resolve router tree: appRouter -> post -> list
   -> Collect middleware chain

4. Input parsing
   -> Decode query string or parse JSON body
   -> Run through Standard Schema v1 parser (Zod)
   -> On failure: throw BAD_REQUEST TRPCError

5. Middleware pipeline
   -> Execute middleware in LIFO order
   -> Each middleware can extend context or short-circuit
   -> Context accumulates through the chain

6. Resolver execution
   -> Call resolver with accumulated context + parsed input
   -> Handle async/await
   -> On error: wrap in TRPCError if not already

7. Output transformation
   -> Apply output parser if defined (.output(schema))
   -> Transform via data transformer (superjson)
   -> Serialize to JSON response

8. Response
   -> Set headers (Content-Type, etc.)
   -> Return { result: { data: ... } } or { error: { ... } }
   -> For subscriptions: start SSE/WebSocket stream
```

## Batch Request Processing

When using `httpBatchLink`, multiple procedure calls arrive in a single HTTP request:

```
POST /api/trpc?batch=1

Body: [
  { "0": { "json": { "id": "1" } } },        // post.getById
  { "1": { "json": { "limit": 10 } } },       // post.list
  { "2": { "json": { "name": "Test" } } }     // post.create
]

Response: [
  { "result": { "data": {...} } },
  { "result": { "data": { "items": [...], "nextCursor": "..." } } },
  { "result": { "data": {...} } }
]
```

Procedures execute sequentially within a batch (they share the same context). Each has its own error isolation -- one failing does not affect others.

## Streaming / Subscription Backend

### SSE Subscription

```typescript
// Server
t.procedure
  .input(z.object({ channel: z.string() }))
  .subscription(async function* ({ input, ctx }) {
    const emitter = ctx.ee; // EventEmitter
    while (true) {
      const data = await waitForEvent(emitter, input.channel);
      yield data;
    }
  });

// Client
const sub = trpc.chat.onMessage.subscribe({ channel: 'general' }, {
  onData: (msg) => console.log(msg),
  onError: (err) => console.error(err),
});
sub.unsubscribe(); // Clean up
```

### Tracked Streaming (sending progress / status)

```typescript
import { tracked } from '@trpc/server';

t.procedure.subscription(async function* ({ input }) {
  yield tracked('5%', { status: 'processing', progress: 5 });
  // ... heavy work
  yield tracked('50%', { status: 'processing', progress: 50 });
  // ... more work
  yield tracked('100%', { status: 'done', result: finalData });
});
```

### WebSocket Subscription Server

```typescript
import { applyWSSHandler } from '@trpc/server/adapters/ws';
import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 3001 });
applyWSSHandler({ wss, router: appRouter, createContext });
```
