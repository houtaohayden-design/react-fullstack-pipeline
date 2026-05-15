# Redux Toolkit Patterns & Best Practices

## Slice Pattern: One Slice Per Feature

Organize Redux state as one slice per domain feature. Each slice owns its own reducer, actions, and (optionally) selectors.

```
src/
  features/
    counter/
      counterSlice.ts
    users/
      usersSlice.ts
      usersApi.ts        # RTK Query
  app/
    store.ts
```

Each slice file exports the auto-generated action creators and the reducer:

```tsx
// counterSlice.ts
const counterSlice = createSlice({
  name: 'counter',
  initialState: 0,
  reducers: {
    increment: (state) => state + 1,
    decrement: (state) => state - 1,
    reset: () => 0,
  },
})
export const { increment, decrement, reset } = counterSlice.actions
export default counterSlice.reducer
```

The store assembles all slices:

```tsx
// store.ts
import { configureStore } from '@reduxjs/toolkit'
import counterReducer from '../features/counter/counterSlice'

export const store = configureStore({
  reducer: {
    counter: counterReducer,
    // ... more slices
  },
})
```

---

## Async Thunk Pattern

Use `createAsyncThunk` for API calls that should write results to the Redux store. Three lifecycle actions are auto-dispatched: `pending`, `fulfilled`, `rejected`.

```tsx
// Fetching data into a slice
const fetchUsers = createAsyncThunk('users/fetchAll', async () => {
  const res = await fetch('/api/users')
  return res.json()
})

const usersSlice = createSlice({
  name: 'users',
  initialState: { items: [], status: 'idle' as 'idle' | 'loading' | 'succeeded' | 'failed' },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchUsers.pending, (state) => { state.status = 'loading' })
      .addCase(fetchUsers.fulfilled, (state, action) => {
        state.status = 'succeeded'
        state.items = action.payload
      })
      .addCase(fetchUsers.rejected, (state, action) => {
        state.status = 'failed'
        // action.error.message is available
      })
  },
})
```

**When to use thunks vs RTK Query**:
- **RTK Query**: For data fetching with caching, polling, invalidation, and subscription lifecycle
- **Thunks**: For side effects (e.g., dispatching multiple actions, accessing third-party APIs, imperative workflows)

---

## RTK Query Pattern

RTK Query manages the entire data-fetching lifecycle: caching, invalidation, polling, optimistic updates, and prefetching. Define an API slice, then use auto-generated hooks in components.

```tsx
// api.ts
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react'

export const api = createApi({
  reducerPath: 'api',
  baseQuery: fetchBaseQuery({ baseUrl: '/api' }),
  tagTypes: ['Post', 'User'],
  endpoints: (builder) => ({
    // Queries (GET, cached, re-fetched on mount/arg change/focus)
    getPosts: builder.query<Post[], void>({
      query: () => '/posts',
      providesTags: (result) =>
        result
          ? [...result.map(({ id }) => ({ type: 'Post' as const, id })), 'Post']
          : ['Post'],
    }),
    getPost: builder.query<Post, string>({
      query: (id) => `/posts/${id}`,
      providesTags: (result, error, id) => [{ type: 'Post', id }],
    }),
    // Mutations (POST/PUT/DELETE, triggers cache invalidation)
    addPost: builder.mutation<Post, Partial<Post>>({
      query: (body) => ({ url: '/posts', method: 'POST', body }),
      invalidatesTags: ['Post'],
    }),
  }),
})

export const { useGetPostsQuery, useGetPostQuery, useAddPostMutation } = api
```

**Component usage**:

```tsx
function PostsList() {
  const { data: posts, isLoading, error } = useGetPostsQuery()
  const [addPost] = useAddPostMutation()

  if (isLoading) return <Loading />
  if (error) return <Error message={error} />

  return (
    <div>
      {posts?.map(post => <PostCard key={post.id} post={post} />)}
      <button onClick={() => addPost({ title: 'New' })}>Add</button>
    </div>
  )
}
```

**Tag-based cache invalidation**: When a mutation completes, any query providing matching tags is automatically re-fetched. This is the core caching model -- no manual cache clearing needed.

---

## Entity Adapter for Normalized Collections

When managing a collection of items (lists, tables), use `createEntityAdapter` to store data in normalized `{ ids: EntityId[], entities: Record<EntityId, T> }` form. This avoids duplication, enables O(1) lookups, and keeps sort order separate from data.

```tsx
const postsAdapter = createEntityAdapter<Post>({
  sortComparer: (a, b) => b.createdAt.localeCompare(a.createdAt), // newest first
})

const postsSlice = createSlice({
  name: 'posts',
  initialState: postsAdapter.getInitialState({ loading: false }),
  reducers: {
    // Directly use adapter methods as case reducers
    postAdded: postsAdapter.addOne,
    postUpdated: postsAdapter.updateOne,
    postRemoved: postsAdapter.removeOne,
    postsLoaded: postsAdapter.setAll,
  },
})

// Selector factory:
export const {
  selectAll: selectAllPosts,
  selectById: selectPostById,
  selectIds: selectPostIds,
} = postsAdapter.getSelectors<RootState>((state) => state.posts)
```

---

## TypeScript: Typed Hooks Pattern

Define typed versions of `useSelector` and `useDispatch` once, then use them across the app.

```tsx
// store.ts
export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch

// hooks.ts
import { useDispatch, useSelector } from 'react-redux'
export const useAppDispatch = useDispatch.withTypes<AppDispatch>()
export const useAppSelector = useSelector.withTypes<RootState>()
```

This avoids having to type `(state: RootState) => ...` in every `useSelector` call:

```tsx
const count = useAppSelector((state) => state.counter.value)
```

---

## Compatibility

### With react-bits Animations
Fully compatible. Redux store drives animation props. Use `useAppSelector` inside react-bits `AnimatedComponent` or `motion` props. Animate on store changes via `useEffect` watching selected state.

### With animal-island-ui
Fully compatible. Store UI state (active tab, modal open, form values) in Redux slices. animal-island-ui components consume state via `useAppSelector` and dispatch via `useAppDispatch`.

### With Tailwind CSS
No interaction -- Redux manages state, not styles.

### React Version
Requires React 17+. Works with React 18/19 including Suspense (RTK Query `useQuery` supports Suspense mode).

---

## When to Use Redux Toolkit vs Zustand vs Jotai

| Scenario | Recommended |
|----------|-------------|
| Large app with many devs, need predictable patterns | **Redux Toolkit** |
| Data fetching / caching with auto-invalidation | **Redux Toolkit (RTK Query)** |
| Normalized entity collections | **Redux Toolkit (Entity Adapter)** |
| Small-to-medium app, single store object | **Zustand** |
| Fine-grained reactive values (theme, auth, form fields) | **Jotai** |
| SSR-heavy app with per-request isolation | **Jotai** |
| Rapid prototyping, minimal boilerplate | **Zustand** or **Jotai** |

**Redux Toolkit strengths**: DevTools, middleware ecosystem, RTK Query for API caching, opinionated structure (good for teams), listener middleware for complex sagas.

**Redux Toolkit weaknesses**: More boilerplate than Zustand/Jotai, top-down architecture (must know state shape upfront), larger bundle (~11KB for RTK + React-Redux).

---

## Common Pitfalls

1. **Mutating state outside `createSlice`**: Immer only works inside `createSlice` reducers and `createReducer`. Manual `...spread` is fine too but avoid direct mutation in other contexts.
2. **Non-serializable values in store**: `configureStore` includes middleware that warns on non-serializable values (functions, class instances, Symbols). Use plain objects/arrays/primitives.
3. **Putting form state in Redux**: For high-frequency changes (text inputs), prefer local `useState` and only dispatch on submit/blur.
4. **One giant `api` slice**: You can have multiple `createApi` calls for different backend services. Use different `reducerPath` values.
5. **Forgetting to add RTK Query middleware**: `api.middleware` must be added in `configureStore.middleware` for caching, subscriptions, and invalidation to work.
6. **Over-dispatching**: Not every state change needs to go through Redux. Component-local state, URL params, or form state can stay local.
