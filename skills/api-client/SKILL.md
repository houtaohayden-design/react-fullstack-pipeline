---
name: react-pipeline:api-client
description: Use when connecting a React frontend to a backend API — TanStack Query patterns, tRPC setup, optimistic updates, error handling, and retry logic.
---

# Frontend API Integration

## Core Principle
Use TanStack Query for server state. Never manage API data in useState+useEffect. Separate server state from UI state.

## Standard Pattern: TanStack Query

```tsx
// api/todos.ts — API functions
export async function fetchTodos(): Promise<Todo[]> {
  const res = await fetch('/api/todos')
  if (!res.ok) throw new Error('Failed to fetch todos')
  return res.json()
}

export async function createTodo(data: CreateTodo): Promise<Todo> {
  const res = await fetch('/api/todos', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  })
  if (!res.ok) throw new Error('Failed to create todo')
  return res.json()
}

// hooks/useTodos.ts — Query hooks
export const todoKeys = {
  all: ['todos'] as const,
  list: () => [...todoKeys.all, 'list'] as const,
  detail: (id: string) => [...todoKeys.all, 'detail', id] as const
}

export function useTodos() {
  return useQuery({
    queryKey: todoKeys.list(),
    queryFn: fetchTodos
  })
}

export function useCreateTodo() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: createTodo,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: todoKeys.list() })
  })
}
```

## Optimistic Updates

```tsx
export function useToggleTodo() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: (todo: Todo) => fetch(`/api/todos/${todo.id}`, {
      method: 'PATCH',
      body: JSON.stringify({ done: !todo.done })
    }),
    onMutate: async (updatedTodo) => {
      await queryClient.cancelQueries({ queryKey: todoKeys.list() })
      const previous = queryClient.getQueryData(todoKeys.list())
      queryClient.setQueryData(todoKeys.list(), (old) =>
        old?.map(t => t.id === updatedTodo.id ? { ...t, done: !t.done } : t)
      )
      return { previous }
    },
    onError: (err, todo, context) => {
      queryClient.setQueryData(todoKeys.list(), context?.previous)
    },
    onSettled: () => queryClient.invalidateQueries({ queryKey: todoKeys.list() })
  })
}
```

## API Client with Auto-Auth

```tsx
// lib/api.ts
import { useAuth } from '@/stores/auth'

class ApiClient {
  private baseUrl: string

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl
  }

  private async request<T>(path: string, options: RequestInit = {}): Promise<T> {
    const token = useAuth.getState().accessToken
    const res = await fetch(`${this.baseUrl}${path}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
        ...options.headers
      }
    })
    if (res.status === 401) useAuth.getState().logout()
    if (!res.ok) {
      const error = await res.json().catch(() => ({ message: 'Request failed' }))
      throw new Error(error.message)
    }
    return res.json()
  }

  get<T>(path: string) { return this.request<T>(path) }
  post<T>(path: string, body: unknown) {
    return this.request<T>(path, { method: 'POST', body: JSON.stringify(body) })
  }
  put<T>(path: string, body: unknown) {
    return this.request<T>(path, { method: 'PUT', body: JSON.stringify(body) })
  }
  delete<T>(path: string) {
    return this.request<T>(path, { method: 'DELETE' })
  }
}

export const api = new ApiClient('/api')
```

## Error Handling Pattern

```tsx
function TodoList() {
  const { data, error, isLoading, isError, refetch } = useTodos()

  if (isLoading) return <Skeleton />
  if (isError) return <ErrorDisplay error={error} onRetry={refetch} />
  if (!data?.length) return <EmptyState />

  return <List items={data} />
}
```

## Infinite Loading

```tsx
export function useInfinitePosts() {
  return useInfiniteQuery({
    queryKey: ['posts', 'infinite'],
    queryFn: ({ pageParam }) => fetchPosts(pageParam),
    initialPageParam: 0,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined
  })
}

function Feed() {
  const { data, fetchNextPage, hasNextPage, isFetchingNextPage } = useInfinitePosts()
  return (
    <div>
      {data?.pages.flat().map(post => <PostCard key={post.id} post={post} />)}
      {hasNextPage && (
        <Button loading={isFetchingNextPage} onClick={() => fetchNextPage()}>
          Load More
        </Button>
      )}
    </div>
  )
}
```
