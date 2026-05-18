# tRPC Design Patterns

> Project structure, procedure composition, error formatting, and SSR patterns for production tRPC applications.

## Project Structure

### Monorepo Router Sharing

The canonical tRPC pattern: define routers in a shared package, consume types in frontend and backend.

```
monorepo/
  packages/
    api/                        # Shared tRPC routers
      src/
        trpc.ts                 # initTRPC + context type
        routers/
          _app.ts               # Root router (merges sub-routers)
          post.ts               # Post router
          user.ts               # User router
          auth.ts               # Auth router
        context.ts              # createContext factory
    web/                        # Next.js / React frontend
      src/
        trpc/
          client.ts             # createTRPCReact<AppRouter>
          server.ts             # Server-side caller
        app/
          api/trpc/[trpc]/route.ts  # tRPC handler
    db/                         # Prisma / Drizzle schema
```

### Root Router Composition

```typescript
// packages/api/src/routers/_app.ts
import { router } from '../trpc';
import { postRouter } from './post';
import { userRouter } from './user';
import { authRouter } from './auth';

export const appRouter = router({
  post: postRouter,
  user: userRouter,
  auth: authRouter,
});

export type AppRouter = typeof appRouter;
```

### Procedure Organization

Each domain router lives in its own file:

```typescript
// packages/api/src/routers/post.ts
import { router, publicProcedure, protectedProcedure } from '../trpc';
import { z } from 'zod';

export const postRouter = router({
  list: publicProcedure
    .input(z.object({
      limit: z.number().min(1).max(100).default(10),
      cursor: z.string().optional(),
    }))
    .query(async ({ input, ctx }) => {
      const posts = await ctx.db.post.findMany({
        take: input.limit + 1,
        cursor: input.cursor ? { id: input.cursor } : undefined,
        orderBy: { createdAt: 'desc' },
      });
      let nextCursor: string | undefined;
      if (posts.length > input.limit) {
        const next = posts.pop();
        nextCursor = next!.id;
      }
      return { items: posts, nextCursor };
    }),

  getById: publicProcedure
    .input(z.object({ id: z.string() }))
    .query(({ input, ctx }) => ctx.db.post.findUnique({ where: { id: input.id } })),

  create: protectedProcedure
    .input(z.object({ title: z.string().min(1), content: z.string() }))
    .mutation(({ input, ctx }) =>
      ctx.db.post.create({ data: { ...input, authorId: ctx.user.id } })
    ),

  delete: protectedProcedure
    .input(z.object({ id: z.string() }))
    .mutation(async ({ input, ctx }) => {
      const post = await ctx.db.post.findUnique({ where: { id: input.id } });
      if (!post || post.authorId !== ctx.user.id) {
        throw new TRPCError({ code: 'FORBIDDEN' });
      }
      return ctx.db.post.delete({ where: { id: input.id } });
    }),
});
```

## Protected Procedures Pattern

Create a reusable `protectedProcedure` that extends context with authenticated user info:

```typescript
// packages/api/src/trpc.ts
const isAuthed = t.middleware(async ({ ctx, next }) => {
  if (!ctx.session?.user) {
    throw new TRPCError({ code: 'UNAUTHORIZED', message: 'Not authenticated' });
  }
  return next({ ctx: { user: ctx.session.user } });
});

export const protectedProcedure = t.procedure.use(isAuthed);
```

For role-based authorization:

```typescript
const isAdmin = t.middleware(async ({ ctx, next }) => {
  if (!ctx.session?.user || ctx.session.user.role !== 'admin') {
    throw new TRPCError({ code: 'FORBIDDEN', message: 'Admin only' });
  }
  return next({ ctx: { user: ctx.session.user } });
});

export const adminProcedure = t.procedure.use(isAuthed).use(isAdmin);
```

## Procedure Chaining (Builder Pattern)

The builder is immutable -- each call returns a new builder:

```typescript
// Reusable input schema
const paginationInput = z.object({
  limit: z.number().min(1).max(100).default(10),
  cursor: z.string().optional(),
});

// Extend with additional validation
const listInput = paginationInput.extend({
  search: z.string().optional(),
  sortBy: z.enum(['createdAt', 'title']).default('createdAt'),
});

// Reusable procedure with input + middleware
const listProcedure = publicProcedure
  .input(listInput)
  .use(loggingMiddleware);

// Different resolvers on same base
listProcedure.query(({ input, ctx }) => { ... });  // Read
listProcedure.mutation(({ input, ctx }) => { ... }); // Write
```

## Batching & Link Composition

### Split Link Pattern

Route queries/mutations to HTTP batch, subscriptions to WebSocket:

```typescript
const trpc = createTRPCClient<AppRouter>({
  links: [
    loggerLink({ enabled: (opts) => process.env.NODE_ENV === 'development' }),
    splitLink({
      condition: (op) => op.type === 'subscription',
      true: wsLink({ url: `ws://localhost:3001` }),
      false: httpBatchLink({ url: '/api/trpc', headers: () => getAuthHeaders() }),
    }),
  ],
});
```

### HTTP Batch Streaming

For large responses, stream them individually instead of waiting for all:

```typescript
import { httpBatchStreamLink } from '@trpc/client';

const trpc = createTRPCClient<AppRouter>({
  links: [
    httpBatchStreamLink({ url: '/api/trpc' }),
  ],
});
```

## Error Formatting

### Custom Error Formatter

```typescript
const t = initTRPC.context<Context>().create({
  errorFormatter({ shape, error }) {
    return {
      ...shape,
      data: {
        ...shape.data,
        zodError: error.code === 'BAD_REQUEST' && error.cause instanceof ZodError
          ? error.cause.flatten()
          : null,
        timestamp: Date.now(),
      },
    };
  },
});
```

Default error shape:
```typescript
{
  code: string;          // TRPC_ERROR_CODE_KEY
  message: string;       // Error message
  data: {
    code: string;        // Same as above
    httpStatus: number;  // e.g. 400, 401, 500
    stack?: string;      // Only in development
    path?: string;       // Procedure path
  }
}
```

### TRPCError Mapping

| TRPCError Code | HTTP Status |
|---------------|-------------|
| BAD_REQUEST | 400 |
| UNAUTHORIZED | 401 |
| FORBIDDEN | 403 |
| NOT_FOUND | 404 |
| TIMEOUT | 408 |
| CONFLICT | 409 |
| PRECONDITION_FAILED | 412 |
| PAYLOAD_TOO_LARGE | 413 |
| UNPROCESSABLE_CONTENT | 422 |
| TOO_MANY_REQUESTS | 429 |
| CLIENT_CLOSED_REQUEST | 499 |
| INTERNAL_SERVER_ERROR | 500 |
| METHOD_NOT_SUPPORTED | 405 |

## Transformer (superjson)

Enable for transparent Date/Map/Set serialization:

```typescript
// Server (api/src/trpc.ts)
import superjson from 'superjson';
export const t = initTRPC.create({ transformer: superjson });

// Client (web/src/trpc/client.ts)
import superjson from 'superjson';
const trpc = createTRPCReact<AppRouter>();
const trpcClient = trpc.createClient({
  links: [httpBatchLink({ url: '/api/trpc', transformer: superjson })],
});
```

Without transformer: Dates become strings, Maps become plain objects, Sets become arrays.

## SSR Patterns

### Server-Side Prefetching (Pages Router)

```typescript
// pages/posts.tsx
import { createServerSideHelpers } from '@trpc/react-query/server';
import superjson from 'superjson';
import { appRouter } from '~/server/api/root';
import { createContext } from '~/server/api/trpc';
import { prisma } from '~/server/db';

export async function getServerSideProps() {
  const helpers = createServerSideHelpers({
    router: appRouter,
    ctx: await createContext(),
    transformer: superjson,
  });

  await helpers.post.list.prefetch({ limit: 10 });

  return {
    props: { trpcState: helpers.dehydrate() },
  };
}

export default function PostsPage({ trpcState }) {
  return (
    <Hydrate state={trpcState}>
      <PostList />
    </Hydrate>
  );
}
```

### App Router SSR (RSC pattern)

```typescript
// app/posts/page.tsx
import { HydrateClient, trpc } from '@/trpc/server';
import { PostList } from './PostList';

export default async function PostsPage() {
  // Prefetch on the server
  await trpc.post.list.prefetch({ limit: 10 });

  return (
    <HydrateClient>
      <PostList /> {/* Suspense-enabled client component */}
    </HydrateClient>
  );
}
```

### Static Site Generation (SSG)

```typescript
export async function generateStaticParams() {
  const posts = await caller.post.list({ limit: 100 });
  return posts.items.map((post) => ({ slug: post.slug }));
}
```

## Lazy-Loading Routers

For large projects: code-split routers loaded on demand.

```typescript
import { lazy } from '@trpc/server';

export const appRouter = router({
  post: postRouter,              // Always loaded
  admin: lazy(() => import('./admin')), // Loaded on first access
});
```

Lazy routers return `Promise<{ default: RouterRecord }>`. The first access triggers the import.

## Router Merging

Merge multiple routers into one. Useful for multi-module apps:

```typescript
import { mergeRouters } from '@trpc/server';
import { postRouter } from './post';
import { userRouter } from './user';

export const appRouter = mergeRouters(postRouter, userRouter);
// vs. t.router({ post: postRouter, user: userRouter })
```

## Caller Factory (Server-Side API)

Call procedures on the server without HTTP. Used in RSC, getServerSideProps, or server-to-server communication:

```typescript
import { createCallerFactory } from '@trpc/server';
import { appRouter } from './routers/_app';

const createCaller = createCallerFactory(appRouter);

// Use
const caller = createCaller(ctx);
const posts = await caller.post.list({ limit: 10 });
const user = await caller.user.getById({ id: '1' });
```

## Testing Patterns

```typescript
import { createCallerFactory } from '@trpc/server';
import { appRouter } from './routers/_app';

const createCaller = createCallerFactory(appRouter);

test('list returns posts', async () => {
  const caller = createCaller({ db: mockDb, session: null });
  const result = await caller.post.list({ limit: 10 });
  expect(result.items).toHaveLength(2);
});

test('create requires auth', async () => {
  const caller = createCaller({ db: mockDb, session: null });
  await expect(
    caller.post.create({ title: 'Test', content: 'Test' })
  ).rejects.toMatchObject({ code: 'UNAUTHORIZED' });
});
```
