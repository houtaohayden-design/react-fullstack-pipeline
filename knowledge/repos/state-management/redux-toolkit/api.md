# Redux Toolkit API Reference

> Source: https://github.com/reduxjs/redux-toolkit | Package: `@reduxjs/toolkit`

## Setup

```bash
npm install @reduxjs/toolkit react-redux
```

Redux Toolkit (RTK) is the official, batteries-included toolset for Redux. It bundles `redux`, `immer`, `reselect`, and `redux-thunk`.

---

## Store Setup

### `configureStore(options)`

Creates a Redux store with good defaults: combines slice reducers, adds middleware (redux-thunk + dev check middleware), and enables Redux DevTools.

```tsx
import { configureStore } from '@reduxjs/toolkit'
import counterReducer from './counterSlice'
import { api } from './api'

export const store = configureStore({
  reducer: {
    counter: counterReducer,
    [api.reducerPath]: api.reducer,    // RTK Query
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(api.middleware),
})
```

**Key options**:
- `reducer` -- reducer function or an object of slice reducers (auto-combined via `combineReducers`)
- `middleware` -- callback receiving `getDefaultMiddleware`, return a middleware array
- `devTools` -- `true` (default) or DevTools config object
- `preloadedState` -- initial state for hydration/SSR
- `enhancers` -- callback receiving `getDefaultEnhancers`

---

## Core Reducer & Action Helpers

### `createSlice(options)`

The primary API. Accepts `name`, `initialState`, `reducers` object (or creator callback), and optional `extraReducers`. Returns `{ name, reducer, actions, getInitialState, selectors }`.

```tsx
import { createSlice, PayloadAction } from '@reduxjs/toolkit'

const counterSlice = createSlice({
  name: 'counter',
  initialState: { value: 0 },
  reducers: {
    increment: (state) => { state.value += 1 },
    addBy: (state, action: PayloadAction<number>) => {
      state.value += action.payload
    },
  },
})

export const { increment, addBy } = counterSlice.actions
export default counterSlice.reducer
```

**Key insight**: Mutate `state` directly inside reducers -- Immer produces immutable updates under the hood. No spread operators needed.

### `createSlice` with `create` callback notation

```tsx
createSlice({
  name: 'posts',
  initialState: [] as Post[],
  reducers: (create) => ({
    addPost: create.reducer<string>((state, action) => {
      state.push({ id: nanoid(), title: action.payload })
    }),
    fetchPosts: create.asyncThunk(
      async () => fetch('/api/posts').then(r => r.json()),
      { fulfilled: (state, action) => action.payload }
    ),
  }),
})
```

### `createAction(type, prepare?)`

Creates a standard Redux action creator. Useful for actions not tied to a specific slice.

```tsx
const resetAll = createAction('app/resetAll')
const addTodo = createAction('todos/add', (text: string) => ({
  payload: { id: nanoid(), text },
}))
```

### `createReducer(initialState, builder)`

Build a reducer using a builder callback (addCase, addMatcher, addDefaultCase). Used internally by `createSlice`.

```tsx
const reducer = createReducer(0, (builder) => {
  builder
    .addCase(increment, (state) => state + 1)
    .addMatcher(isRejectedAction, (state, action) => 0)
    .addDefaultCase((state) => state)
})
```

---

## Async Logic

### `createAsyncThunk(typePrefix, payloadCreator)`

Creates a thunk that dispatches `pending`/`fulfilled`/`rejected` actions automatically. Returns a promise.

```tsx
const fetchUser = createAsyncThunk('users/fetch', async (userId: string) => {
  const response = await fetch(`/api/users/${userId}`)
  return response.json()
})

// In createSlice extraReducers:
extraReducers: (builder) => {
  builder
    .addCase(fetchUser.pending, (state) => { state.loading = true })
    .addCase(fetchUser.fulfilled, (state, action) => {
      state.data = action.payload
      state.loading = false
    })
    .addCase(fetchUser.rejected, (state, action) => {
      state.error = action.error.message
    })
}

// Dispatch it:
dispatch(fetchUser('123'))
```

**Thunk API**: payload creator receives `(arg, { dispatch, getState, rejectWithValue, fulfillWithValue, signal, abort, requestId, extra })`.

---

## RTK Query

### `createApi(options)`

Defines an API service with endpoints for data fetching and caching. Returns an object with hooks (when used with `reactHooksModule`) and a reducer.

```tsx
import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react'

export const api = createApi({
  reducerPath: 'api',
  baseQuery: fetchBaseQuery({ baseUrl: '/api' }),
  tagTypes: ['Post'],
  endpoints: (builder) => ({
    getPosts: builder.query<Post[], void>({
      query: () => '/posts',
      providesTags: ['Post'],
    }),
    addPost: builder.mutation<Post, Partial<Post>>({
      query: (body) => ({ url: '/posts', method: 'POST', body }),
      invalidatesTags: ['Post'],
    }),
  }),
})

export const { useGetPostsQuery, useAddPostMutation } = api
```

### `fetchBaseQuery(options)`

A lightweight `fetch` wrapper as the default `baseQuery`. Handles JSON parsing, headers, timeout, and credentials.

```tsx
const baseQuery = fetchBaseQuery({
  baseUrl: '/api',
  prepareHeaders: (headers, { getState }) => {
    headers.set('Authorization', `Bearer ${getState().auth.token}`)
    return headers
  },
})
```

### RTK Query React Hooks

Generated by `createApi` per endpoint. Naming convention: `use{EndpointName}Query` / `use{EndpointName}Mutation`.

**Query hooks**:
```tsx
const { data, error, isLoading, isFetching, refetch } = useGetPostsQuery()
const { data } = useGetPostQuery(postId)  // passes arg to query
const [trigger, { data, isUninitialized }] = useLazyGetPostQuery()
```

**Mutation hooks**:
```tsx
const [addPost, { isLoading, isSuccess }] = useAddPostMutation()
await addPost({ title: 'New Post' })
```

**Other exports**:
- `skipToken` -- pass to skip automatic query execution
- `isPending`, `isFulfilled`, `isRejected` -- action matcher utilities
- `<ApiProvider>` -- standalone provider (when not using the main Redux store)

---

## Entity Adapter

### `createEntityAdapter(options?)`

Creates a set of prebuilt CRUD reducers and selectors for normalized data in `{ ids: [], entities: {} }` shape.

```tsx
import { createEntityAdapter, createSlice } from '@reduxjs/toolkit'

const usersAdapter = createEntityAdapter<User>({
  selectId: (user) => user.id,
  sortComparer: (a, b) => a.name.localeCompare(b.name),
})

const usersSlice = createSlice({
  name: 'users',
  initialState: usersAdapter.getInitialState(),
  reducers: {
    addUser: usersAdapter.addOne,
    addUsers: usersAdapter.addMany,
    updateUser: usersAdapter.updateOne,
    removeUser: usersAdapter.removeOne,
    setAll: usersAdapter.setAll,
  },
})

// Selectors:
export const {
  selectAll: selectAllUsers,
  selectById: selectUserById,
  selectEntities: selectUserEntities,
  selectIds: selectUserIds,
  selectTotal: selectUserTotal,
} = usersAdapter.getSelectors((state: RootState) => state.users)
```

Adapter CRUD methods: `addOne`, `addMany`, `setOne`, `setMany`, `setAll`, `removeOne`, `removeMany`, `removeAll`, `updateOne`, `updateMany`, `upsertOne`, `upsertMany`.

---

## React Integration

### `<Provider store={store}>`

From `react-redux`. Wraps the app to make the Redux store available to all hooks.

```tsx
import { Provider } from 'react-redux'
import { store } from './store'

<Provider store={store}>
  <App />
</Provider>
```

### `useSelector(selector)`

Returns extracted state. Component re-renders when the selected value changes (strict `===` comparison).

```tsx
const count = useSelector((state: RootState) => state.counter.value)
```

### `useDispatch()`

Returns the store's `dispatch` function.

```tsx
const dispatch = useDispatch()
dispatch(increment())
```

---

## Listener Middleware

### `createListenerMiddleware()`

Creates a middleware instance for running side effects in response to dispatched actions (replaces sagas/observables for most cases).

```tsx
const listenerMiddleware = createListenerMiddleware()
listenerMiddleware.startListening({
  actionCreator: addPost,
  effect: async (action, api) => {
    await api.delay(1000)
    api.dispatch(showToast('Post added!'))
  },
})

// Add to store middleware:
configureStore({
  middleware: (gDM) => gDM().prepend(listenerMiddleware.middleware),
})
```

---

## Other Utilities

- `createDraftSafeSelector` -- memoized selector aware of Immer drafts
- `nanoid` -- unique string ID generator
- `combineSlices` -- typed combineReducers replacement for code-splitting
- `createDynamicMiddleware` -- add/remove middleware at runtime
- `isAllOf` / `isAnyOf` -- matcher combinators
- `isPending` / `isFulfilled` / `isRejected` / `isAsyncThunkAction` -- async thunk matchers
- `freeze` / `original` / `current` -- Immer utilities for debugging
- `Tuple` -- typed array helper for middleware/enhancer arrays
- `autoBatchEnhancer` -- automatic batching for React 18+ (included by default)

---

## TypeScript Patterns

```tsx
// Infer store types
export type AppStore = typeof store
export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch

// Typed hooks (recommended pattern)
import { useDispatch, useSelector } from 'react-redux'
export const useAppDispatch = useDispatch.withTypes<AppDispatch>()
export const useAppSelector = useSelector.withTypes<RootState>()
```
