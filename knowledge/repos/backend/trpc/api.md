# tRPC API Reference

> End-to-end typesafe APIs without code generation. Source: `@trpc/server` `@trpc/client` `@trpc/react-query` `@trpc/next`
> Version: v11 (current). Packages in monorepo at `packages/`.

## Architecture Overview

tRPC defines procedures on the server and exposes their types to the client. The client calls them as if they were local functions -- no code generation, no REST endpoints, no GraphQL schema. The type system bridges server and client automatically.

```
Server                          Client
  router                         trpc.post.query({...})
    .query("list", ...)  --->    trpc.post.useMutation()
    .mutation("create", ...)
    .subscription("onUpdate", ...)
```

## Core Packages

| Package | Purpose |
|---------|---------|
| `@trpc/server` | Router definition, procedures, middleware, context, adapters |
| `@trpc/client` | Generic client with link chain, batching, WebSocket |
| `@trpc/react-query` | React hooks integrated with TanStack Query |
| `@trpc/next` | Next.js Pages Router + App Router adapters |
| `@trpc/openapi` | OpenAPI v3.1 document generation from tRPC router |

## initTRPC

The entry point. Creates a tRPC instance with typed context and metadata.

```typescript
import { initTRPC } from '@trpc/server';
import type { Context } from './context';

const t = initTRPC.context<Context>().create();
// or with meta
const t = initTRPC.context<Context>().meta<{ permission: string }>().create();
```

Options passed to `.create()`:
- `transformer`: Data transformer (e.g., `superjson`) for serializing Dates, Maps, Sets
- `errorFormatter`: Custom error shape formatting function
- `allowOutsideOfServer`: For testing (default `false`, checks `typeof window === 'undefined'`)
- `isServer`: Override server detection
- `isDev`: Override dev detection

Returns `t` with:
- `t.router` -- create a router
- `t.procedure` -- base procedure builder
- `t.middleware` -- create middleware
- `t.mergeRouters` -- merge multiple routers

## Router & Procedure Pattern

### Router Definition

```typescript
// server/routers/user.ts
import { t } from '../trpc';
import { z } from 'zod';

export const userRouter = t.router({
  // Query: reads data
  getById: t.procedure
    .input(z.object({ id: z.string() }))
    .query(async ({ input, ctx }) => {
      return ctx.db.user.findUnique({ where: { id: input.id } });
    }),

  // Mutation: writes data
  create: t.procedure
    .input(z.object({ name: z.string(), email: z.string().email() }))
    .mutation(async ({ input, ctx }) => {
      return ctx.db.user.create({ data: input });
    }),

  // Subscription: real-time stream
  onUpdate: t.procedure
    .input(z.object({ userId: z.string() }))
    .subscription(async function* ({ input, ctx }) {
      while (true) {
        yield ctx.db.user.findUnique({ where: { id: input.userId } });
        await new Promise(resolve => setTimeout(resolve, 1000));
      }
    }),
});
```

### Procedure Builder Chain

`t.procedure` is the base. The chain is:

```
t.procedure
  .input(z.schema)         // Zod / Yup / superstruct validation
  .output(z.schema)        // Optional: transform output, runtime validation
  .meta({ permission: ... }) // Attach metadata for middleware
  .use(middlewareA)         // Attach middleware
  .use(middlewareB)
  .query(async ({ input, ctx, rawInput }) => { ... })
  // or .mutation(...) or .subscription(...)
```

Types of procedure resolvers:

| Type | Behavior | Client calls |
|------|----------|-------------|
| `.query(fn)` | Read-only, idempotent | `useQuery`, `useSuspenseQuery`, `useInfiniteQuery` |
| `.mutation(fn)` | Side-effects, mutations | `useMutation` |
| `.subscription(fn)` | Async iterable / Observable stream | `useSubscription` |

### Resolver Context

All resolver functions receive:

```typescript
{
  input: TInput;       // Parsed and validated input
  ctx: Context;        // Your typed context (DB, auth session, etc.)
  rawInput: unknown;   // Raw unparsed input (before validation)
  type: 'query' | 'mutation' | 'subscription';  // Procedure type
  path: string;        // Full procedure path, e.g. "user.getById"
  signal?: AbortSignal; // AbortSignal if supported
}
```

## Context

Context is created per-request and flows through middleware to procedures.

```typescript
// server/context.ts
import { type CreateContextCallback } from '@trpc/server';

interface Context {
  db: PrismaClient;
  session: Session | null;
  req: Request; // or Express Request / IncomingMessage
  res: Response; // or Express Response / ServerResponse
}

export const createContext: CreateContextCallback<{
  /* adapter-specific opts */
}> = async (opts) => {
  const session = await getSession(opts.req);
  return {
    db: prisma,
    session,
    req: opts.req,
    res: opts.res,
  };
};
```

Bind to adapter:

```typescript
// Express
import * as trpcExpress from '@trpc/server/adapters/express';
app.use('/trpc', trpcExpress.createExpressMiddleware({ router: appRouter, createContext }));

// Fetch (Next.js, Cloudflare, Deno, Bun)
import { fetchRequestHandler } from '@trpc/server/adapters/fetch';
export const handler = (req: Request) =>
  fetchRequestHandler({ endpoint: '/api/trpc', req, router: appRouter, createContext });

// Standalone Node
import { createHTTPServer } from '@trpc/server/adapters/standalone';
createHTTPServer({ router: appRouter, createContext }).listen(3000);

// Fastify
import { fastifyTRPCPlugin } from '@trpc/server/adapters/fastify';
```

## Middleware

Middleware wraps procedures to extend context, validate, log, or short-circuit.

```typescript
import { t } from './trpc';
import { TRPCError } from '@trpc/server';

// Define middleware
const isAuthed = t.middleware(async ({ ctx, next }) => {
  if (!ctx.session?.user) {
    throw new TRPCError({ code: 'UNAUTHORIZED' });
  }
  return next({
    ctx: {
      // Extend context -- typed flow through all downstream
      user: ctx.session.user,
    },
  });
});

// Usage on a procedure
const protectedProcedure = t.procedure.use(isAuthed);

// Usage on a router sub-tree
const adminRouter = t.router({
  dashboard: t.router({
    stats: protectedProcedure.query(() => '...'),
  }),
});
```

Middleware chain signature:
```typescript
t.middleware(async ({ ctx, path, type, input, rawInput, meta, next, signal }) => {
  // Before resolver
  const result = await next();
  // After resolver
  return result;
});
```

Key points:
- `next()` passes control to the next middleware or resolver
- Pass `{ ctx: {...} }` to `next()` to extend context -- types flow through
- Throw `TRPCError` to short-circuit with an error
- `meta` matches the procedure's `.meta()` value
- Middleware can be composed: `t.middleware.pipe(mw1, mw2, mw3)`
- `.unstable_pipe()` chains middleware builders together

### TRPCError Codes

```typescript
new TRPCError({
  code: 'BAD_REQUEST' | 'UNAUTHORIZED' | 'FORBIDDEN' | 'NOT_FOUND' |
        'TIMEOUT' | 'CONFLICT' | 'PRECONDITION_FAILED' |
        'PAYLOAD_TOO_LARGE' | 'METHOD_NOT_SUPPORTED' |
        'UNPROCESSABLE_CONTENT' | 'TOO_MANY_REQUESTS' |
        'CLIENT_CLOSED_REQUEST' | 'INTERNAL_SERVER_ERROR',
  message: 'Human-readable message',
  cause: originalError, // Optional underlying error
});
```

## Input Validation (Zod Integration)

tRPC uses Standard Schema (v1) for validation. Zod, Valibot, ArkType supported.

```typescript
import { z } from 'zod';

const procedure = t.procedure
  .input(
    z.object({
      name: z.string().min(1).max(100),
      email: z.string().email(),
      age: z.number().int().min(0).max(150).optional(),
      tags: z.array(z.string()).default([]),
    })
  )
  .query(({ input }) => {
    // input is fully typed from the Zod schema
    input.name;     // string
    input.age;      // number | undefined
    input.tags;     // string[]
  });
```

The `.input()` method:
- Parses and validates at runtime
- Infers TypeScript type for the resolver
- Returns `TRPCError` with `code: 'BAD_REQUEST'` on validation failure
- Supports `.default()` and `.transform()` from Zod

Without `.input()`, input is `void` and clients call with no arguments.

## Client Creation

### Generic Client (`@trpc/client`)

```typescript
import { createTRPCClient, httpBatchLink } from '@trpc/client';
import type { AppRouter } from '../server/routers/_app';

const trpc = createTRPCClient<AppRouter>({
  links: [
    httpBatchLink({
      url: 'http://localhost:3000/api/trpc',
    }),
  ],
});

// Type-safe calls
const user = await trpc.user.getById.query({ id: '1' });
await trpc.user.create.mutate({ name: 'Alice', email: 'alice@example.com' });
```

### Link Chain

Links form a pipeline. Each link handles request/response.

| Link | Purpose |
|------|---------|
| `httpLink` | Single-request HTTP POST |
| `httpBatchLink` | Batches multiple calls into one HTTP request (default) |
| `httpBatchStreamLink` | Batched calls with streaming responses via SSE/JSONL |
| `httpSubscriptionLink` | Subscriptions via Server-Sent Events (SSE) |
| `wsLink` | Subscriptions via WebSocket |
| `splitLink` | Route to different links based on procedure type |
| `loggerLink` | Development logging of requests |
| `retryLink` | Retry failed requests with exponential backoff |
| `localLink` | Direct in-memory calls (for testing) |

```typescript
import {
  createTRPCClient,
  httpBatchLink,
  httpSubscriptionLink,
  splitLink,
  loggerLink,
} from '@trpc/client';

const trpc = createTRPCClient<AppRouter>({
  links: [
    loggerLink(),
    splitLink({
      condition: (op) => op.type === 'subscription',
      true: httpSubscriptionLink({ url: '/api/trpc' }),
      false: httpBatchLink({ url: '/api/trpc' }),
    }),
  ],
});
```

## React Hooks (`@trpc/react-query`)

After wrapping your app with TRPCProvider + QueryClientProvider:

```typescript
import { createTRPCReact } from '@trpc/react-query';
import type { AppRouter } from '../server/routers/_app';

export const trpc = createTRPCReact<AppRouter>();
```

### Query Hooks

```typescript
// Standard query
const { data, isLoading, error } = trpc.user.getById.useQuery({ id: '1' });

// Suspense query (throws promise)
const { data } = trpc.user.getById.useSuspenseQuery({ id: '1' });

// Infinite query (cursor-based)
const { data, fetchNextPage, hasNextPage } = trpc.post.list.useInfiniteQuery(
  { limit: 10 },
  { getNextPageParam: (lastPage) => lastPage.nextCursor }
);

// Prefetch
const utils = trpc.useUtils();
await utils.user.getById.prefetch({ id: '1' });

// fetch (without hooks)
await utils.user.getById.fetch({ id: '1' });

// Invalidate
await utils.user.getById.invalidate({ id: '1' });
// or invalidate all
await utils.user.getById.invalidate();

// Set data
utils.user.getById.setData({ id: '1' }, newData);

// Cancel (for optimistic updates)
await utils.user.getById.cancel({ id: '1' });

// Get data from cache
const cached = utils.user.getById.getData({ id: '1' });

// Refetch
await utils.user.getById.refetch({ id: '1' });
```

### Mutation Hooks

```typescript
const utils = trpc.useUtils();
const createUser = trpc.user.create.useMutation({
  onSuccess: () => {
    utils.user.list.invalidate(); // Invalidate cache after mutation
  },
});

// Usage
<button onClick={() => createUser.mutate({ name: 'Bob', email: 'bob@test.com' })}>
  Create
</button>
```

### Subscription Hook

```typescript
trpc.post.onUpdate.useSubscription(
  { postId: '123' },
  {
    onData: (data) => console.log('New data:', data),
    onError: (err) => console.error('Subscription error:', err),
    onStarted: () => console.log('Connected'),
  }
);
```

### TRPCProvider

```tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { createTRPCReact, httpBatchLink } from '@trpc/react-query';

const trpc = createTRPCReact<AppRouter>();
const queryClient = new QueryClient();
const trpcClient = trpc.createClient({
  links: [httpBatchLink({ url: '/api/trpc' })],
});

function App() {
  return (
    <trpc.Provider client={trpcClient} queryClient={queryClient}>
      <QueryClientProvider client={queryClient}>
        <YourApp />
      </QueryClientProvider>
    </trpc.Provider>
  );
}
```

## Next.js App Router Integration

### Server-Side Setup

```typescript
// server/api/trpc.ts
import { initTRPC } from '@trpc/server';
import superjson from 'superjson';

const t = initTRPC.create({ transformer: superjson });
export const router = t.router;
export const publicProcedure = t.procedure;
```

### Server-Side Caller

```typescript
// server/api/routers/post.ts
import { router, publicProcedure } from '../trpc';
import { z } from 'zod';

export const postRouter = router({
  list: publicProcedure.query(async ({ ctx }) => {
    return ctx.db.post.findMany();
  }),
});
```

### App Router Handler

```typescript
// app/api/trpc/[trpc]/route.ts
import { fetchRequestHandler } from '@trpc/server/adapters/fetch';
import { appRouter } from '@/server/api/root';

const handler = (req: Request) =>
  fetchRequestHandler({
    endpoint: '/api/trpc',
    req,
    router: appRouter,
    createContext: async () => ({ db: prisma }),
  });

export { handler as GET, handler as POST };
```

### Client Component Usage

```typescript
// components/PostList.tsx
'use client';
import { trpc } from '@/trpc/client';

export function PostList() {
  const { data: posts, isLoading } = trpc.post.list.useQuery();
  if (isLoading) return <div>Loading...</div>;
  return posts?.map(post => <PostCard key={post.id} post={post} />);
}
```

### Server Component Usage (RSC)

```typescript
// app/posts/page.tsx (Server Component)
import { createHydrationHelpers } from '@trpc/react-query/rsc';
import { appRouter } from '@/server/api/root';
import { createContext } from '@/server/api/trpc';

const { trpc, HydrateClient } = createHydrationHelpers(appRouter, createContext);

// Or using the @trpc/next server caller:
import { createCaller } from '@/server/api/root';
const caller = createCaller(await createContext());
const posts = await caller.post.list();
```

### Server-Side Prefetching

```typescript
// In RSC, prefetch queries before render
import { dehydrate, Hydrate } from '@tanstack/react-query';

export default async function Page() {
  const caller = appRouter.createCaller(await createContext());
  const state = await caller.queryClient.getDehydratedState();
  // Pass dehydrated state to client
}
```

## Adapters

tRPC ships with these server adapters:

| Adapter | Path |
|---------|------|
| Express | `@trpc/server/adapters/express` |
| Fastify | `@trpc/server/adapters/fastify` |
| Fetch (Next, Cloudflare, Deno, Bun) | `@trpc/server/adapters/fetch` |
| Standalone Node | `@trpc/server/adapters/standalone` |
| AWS Lambda | `@trpc/server/adapters/aws-lambda` |
| Next.js App Router | `@trpc/server/adapters/next-app-dir` |
| Next.js Pages Router | `@trpc/server/adapters/next` |
| WebSocket | `@trpc/server/adapters/ws` |

## Key Type Inference Utilities

```typescript
import type {
  inferRouterInputs,   // Input types for all procedures
  inferRouterOutputs,  // Output types for all procedures
  inferRouterContext,  // Context type of a router
  inferRouterError,    // Error type of a router
} from '@trpc/server';

type RouterInput = inferRouterInputs<AppRouter>;
// { user: { getById: { id: string }, create: {...}, onUpdate: {...} } }

type RouterOutput = inferRouterOutputs<AppRouter>;
// { user: { getById: User, create: User, onUpdate: User } }
```

## Data Transformer (superjson)

```typescript
import superjson from 'superjson';

const t = initTRPC.create({
  transformer: superjson,
});

// Now Dates, Maps, Sets, BigInts are serialized transparently
t.procedure.query(() => ({
  createdAt: new Date(),    // Serialized as Date, deserialized as Date
  metadata: new Map(),      // Works on both server and client
}));
```

Custom transformer interface:
```typescript
interface DataTransformer {
  serialize: (object: any) => any;
  deserialize: (object: any) => any;
}
```
