# tRPC API Design Patterns

> Query/mutation design, pagination, subscriptions, optimistic updates, cache invalidation, server-side helpers, and OpenAPI generation.

## Query vs Mutation Design

### When to Use Each

| Use `.query()` for | Use `.mutation()` for |
|---|---|
| Reading data (no side effects) | Creating, updating, deleting data |
| Idempotent operations | Non-idempotent operations |
| Auto-cached and revalidated | Manually invalidated after success |
| Can be called multiple times safely | Each call changes state |
| Used with `useQuery` / `useSuspenseQuery` | Used with `useMutation` |

### Query Design Guidelines

```typescript
// Good: Single-purpose query with typed input
t.procedure
  .input(z.object({ userId: z.string() }))
  .query(async ({ input, ctx }) => {
    return ctx.db.user.findUnique({ where: { id: input.userId } });
  });

// Good: List query with filters + pagination
t.procedure
  .input(z.object({
    limit: z.number().min(1).max(100).default(20),
    cursor: z.string().optional(),
    search: z.string().optional(),
    status: z.enum(['draft', 'published']).optional(),
  }))
  .query(async ({ input, ctx }) => {
    const where = buildWhereClause(input);
    const items = await ctx.db.post.findMany({
      take: input.limit + 1,
      cursor: input.cursor ? { id: input.cursor } : undefined,
      where,
      orderBy: { createdAt: 'desc' },
    });
    return extractCursor(items, input.limit);
  });
```

### Mutation Design Guidelines

```typescript
// Good: Single action with clear input
t.procedure
  .input(z.object({ postId: z.string(), content: z.string().min(1) }))
  .mutation(async ({ input, ctx }) => {
    return ctx.db.comment.create({
      data: { content: input.content, postId: input.postId, authorId: ctx.user.id },
    });
  });

// Good: Complex mutation with multiple steps in resolver
t.procedure
  .input(z.object({ orderId: z.string() }))
  .mutation(async ({ input, ctx }) => {
    return ctx.db.$transaction(async (tx) => {
      const order = await tx.order.update({
        where: { id: input.orderId },
        data: { status: 'CANCELLED' },
      });
      await tx.inventory.restock(order.items);
      return order;
    });
  });
```

## Pagination Patterns

### Cursor-Based Pagination (Recommended)

```typescript
const listInput = z.object({
  limit: z.number().min(1).max(100).default(10),
  cursor: z.string().optional(), // Typically an ID or encoded cursor
});

t.procedure
  .input(listInput)
  .query(async ({ input, ctx }) => {
    const items = await ctx.db.post.findMany({
      take: input.limit + 1, // Fetch one extra to detect hasMore
      cursor: input.cursor ? { id: input.cursor } : undefined,
      orderBy: { id: 'desc' },
    });

    let nextCursor: typeof input.cursor | undefined;
    if (items.length > input.limit) {
      const nextItem = items.pop()!;
      nextCursor = nextItem.id;
    }

    return { items, nextCursor };
  });
```

Frontend with `useInfiniteQuery`:

```typescript
const { data, fetchNextPage, hasNextPage, isFetchingNextPage } =
  trpc.post.list.useInfiniteQuery(
    { limit: 10 },
    {
      getNextPageParam: (lastPage) => lastPage.nextCursor,
    }
  );

// All pages flattened
const allPosts = data?.pages.flatMap((page) => page.items) ?? [];

// Load more button
<button
  onClick={() => fetchNextPage()}
  disabled={!hasNextPage || isFetchingNextPage}
>
  {isFetchingNextPage ? 'Loading...' : 'Load More'}
</button>
```

### Offset/Limit Pagination (Simple cases)

```typescript
t.procedure
  .input(z.object({
    page: z.number().int().min(1).default(1),
    limit: z.number().int().min(1).max(100).default(20),
  }))
  .query(async ({ input, ctx }) => {
    const [items, total] = await Promise.all([
      ctx.db.post.findMany({
        skip: (input.page - 1) * input.limit,
        take: input.limit,
        orderBy: { createdAt: 'desc' },
      }),
      ctx.db.post.count(),
    ]);

    return {
      items,
      total,
      page: input.page,
      totalPages: Math.ceil(total / input.limit),
    };
  });
```

## Subscription Patterns

### Event-Driven Subscriptions

```typescript
import { EventEmitter } from 'events';

const ee = new EventEmitter();

t.procedure
  .input(z.object({ postId: z.string() }))
  .subscription(async function* ({ input, signal }) {
    // Listen for events
    const handler = (data: Comment) => {
      // Use an internal queue to bridge EventEmitter to async generator
    };

    ee.on(`comment:${input.postId}`, handler);

    try {
      while (true) {
        // Yield new comments as they arrive
        const comment = await waitForEvent(ee, `comment:${input.postId}`, signal);
        yield comment;
      }
    } finally {
      ee.off(`comment:${input.postId}`, handler);
    }
  });

// Trigger from a mutation
t.procedure
  .input(z.object({ postId: z.string(), content: z.string() }))
  .mutation(async ({ input, ctx }) => {
    const comment = await ctx.db.comment.create({
      data: { ...input, authorId: ctx.user.id },
    });
    ee.emit(`comment:${input.postId}`, comment); // Notify subscribers
    return comment;
  });
```

### Polling-Based Subscriptions (Alternative)

```typescript
t.procedure
  .input(z.object({ userId: z.string() }))
  .subscription(async function* ({ input, ctx }) {
    while (true) {
      yield await ctx.db.user.findUnique({ where: { id: input.userId } });
      await new Promise((resolve) => setTimeout(resolve, 5000)); // Poll interval
    }
  });
```

### WebSocket Client

```typescript
import { createWSClient, wsLink } from '@trpc/client';

const wsClient = createWSClient({ url: `ws://localhost:3001` });

const trpc = createTRPCClient<AppRouter>({
  links: [
    splitLink({
      condition: (op) => op.type === 'subscription',
      true: wsLink({ client: wsClient }),
      false: httpBatchLink({ url: '/api/trpc' }),
    }),
  ],
});
```

### SSE Client (via httpSubscriptionLink)

```typescript
import { httpSubscriptionLink } from '@trpc/client';

const trpc = createTRPCClient<AppRouter>({
  links: [
    splitLink({
      condition: (op) => op.type === 'subscription',
      true: httpSubscriptionLink({ url: '/api/trpc' }),
      false: httpBatchLink({ url: '/api/trpc' }),
    }),
  ],
});
```

## Optimistic Updates

```typescript
const utils = trpc.useUtils();

const addComment = trpc.post.addComment.useMutation({
  onMutate: async (newComment) => {
    // Cancel outgoing refetches
    await utils.post.getComments.cancel();

    // Snapshot previous value
    const previousComments = utils.post.getComments.getData({
      postId: newComment.postId,
    });

    // Optimistically insert
    utils.post.getComments.setData(
      { postId: newComment.postId },
      (old) => [
        ...(old ?? []),
        {
          id: `temp-${Date.now()}`,
          content: newComment.content,
          author: { name: 'You' },
          createdAt: new Date(),
          isOptimistic: true,
        },
      ]
    );

    return { previousComments }; // Return rollback context
  },

  onError: (err, newComment, context) => {
    // Rollback on error
    utils.post.getComments.setData(
      { postId: newComment.postId },
      context?.previousComments
    );
    toast.error('Failed to add comment');
  },

  onSettled: (data, error, variables) => {
    // Always refetch after error or success
    utils.post.getComments.invalidate({ postId: variables.postId });
  },
});
```

## Cache Invalidation Patterns

### Broad vs. Targeted Invalidation

```typescript
// Broad: Invalidate all queries for a router key
utils.post.invalidate(); // Invalidates all "post.*" queries

// Targeted: Invalidate specific query
utils.post.getById.invalidate({ id: '123' });

// Partial match: All queries matching input pattern
utils.post.getById.invalidate(); // All getById queries regardless of input
```

### Invalidation Strategy by Operation

```typescript
const createPost = trpc.post.create.useMutation({
  onSuccess: () => {
    // Create: invalidate the list that now includes the new item
    utils.post.list.invalidate();
  },
});

const updatePost = trpc.post.update.useMutation({
  onSuccess: (data) => {
    // Update: invalidate both the detail and the list
    utils.post.getById.invalidate({ id: data.id });
    utils.post.list.invalidate();
  },
});

const deletePost = trpc.post.delete.useMutation({
  onSuccess: (_, variables) => {
    // Delete: invalidate the list and remove from detail cache
    utils.post.list.invalidate();
    utils.post.getById.invalidate({ id: variables.id });
  },
});
```

### Refetch vs. Invalidate

```typescript
// Invalidate: marks stale, refetches only if component is mounted/mounts
utils.post.list.invalidate();

// Refetch: immediately triggers a network request
await utils.post.list.refetch();

// Invalidate + immediate refetch
await utils.post.list.invalidate();
await utils.post.list.refetch();
```

## Server-Side Helpers

### createCallerFactory

Call procedures directly without HTTP on the server:

```typescript
import { createCallerFactory } from '@trpc/server';
import { appRouter } from './routers/_app';

const createCaller = createCallerFactory(appRouter);

// In RSC, getServerSideProps, API routes, webhooks, etc.
async function handleWebhook(event: WebhookEvent) {
  const ctx = await createContext({ req: mockRequest });
  const caller = createCaller(ctx);

  switch (event.type) {
    case 'user.created':
      await caller.user.createFromWebhook({ email: event.data.email });
      break;
    case 'payment.succeeded':
      await caller.billing.activateSubscription({ userId: event.data.userId });
      break;
  }
}
```

### createServerSideHelpers (Pages Router)

```typescript
import { createServerSideHelpers } from '@trpc/react-query/server';

export async function getServerSideProps(context: GetServerSidePropsContext) {
  const helpers = createServerSideHelpers({
    router: appRouter,
    ctx: await createContext({ req: context.req, res: context.res } as any),
    transformer: superjson,
  });

  // Parallel prefetch
  await Promise.all([
    helpers.post.list.prefetch({ limit: 10 }),
    helpers.user.me.prefetch(),
  ]);

  return {
    props: {
      trpcState: helpers.dehydrate(),
    },
  };
}
```

### createHydrationHelpers (App Router)

```typescript
// trpc/server.ts
import { createHydrationHelpers } from '@trpc/react-query/rsc';
import { appRouter } from '@/server/api/root';
import { createTRPCContext } from '@/server/api/trpc';

export const { trpc, HydrateClient } = createHydrationHelpers(
  appRouter,
  createTRPCContext
);

// Usage in Server Component
import { HydrateClient, trpc } from '@/trpc/server';

export default async function Page() {
  void trpc.post.list.prefetch({ limit: 10 }); // Fire-and-forget prefetch

  return (
    <HydrateClient>
      <PostList />
    </HydrateClient>
  );
}
```

## OpenAPI Generation

Generate OpenAPI 3.1 doc from tRPC router:

```typescript
import { generateOpenAPIDocument } from '@trpc/openapi';
import { appRouter } from './routers/_app';

const doc = generateOpenAPIDocument(appRouter, {
  title: 'My API',
  version: '1.0.0',
  baseUrl: 'http://localhost:3000/api',
});
```

Requires using `@trpc/openapi` procedures instead of standard tRPC procedures (adds `.meta({ openapi: {...} })` for path/method/summary).

## Response Caching (HTTP Headers)

```typescript
t.procedure.query(async ({ ctx }) => {
  // Set cache headers through context
  if (ctx.res) {
    ctx.res.setHeader('Cache-Control', 'public, max-age=60, stale-while-revalidate=300');
  }
  return data;
});
```

## AbortSignal Handling

```typescript
t.procedure
  .input(z.object({ query: z.string() }))
  .query(async ({ input, ctx, signal }) => {
    // Pass signal to underlying calls for proper cancellation
    const result = await ctx.db.post.findMany({
      where: { title: { contains: input.query } },
    });
    // Or pass to fetch:
    // const result = await fetch(url, { signal });
    return result;
  });
```

On the client, queries cancel automatically on unmount. Mutations can be cancelled manually:

```typescript
const mutation = trpc.post.upload.useMutation();
mutation.mutate(data);
// Later:
mutation.reset(); // Cancel & reset state
```

## Performance: Parallel Queries

```typescript
// Individual: each is a separate request (or batched with httpBatchLink)
const { data: posts } = trpc.post.list.useQuery({ limit: 10 });
const { data: user } = trpc.user.me.useQuery();

// Batching: httpBatchLink auto-combines concurrent calls
// With httpBatchLink, the two queries above are sent in one HTTP request

// Manual parallel prefetch
const utils = trpc.useUtils();
await Promise.all([
  utils.post.list.fetch({ limit: 10 }),
  utils.user.me.fetch(),
  utils.post.popular.fetch(),
]);
```
