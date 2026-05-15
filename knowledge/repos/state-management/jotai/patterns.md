# Jotai Patterns & Best Practices

## Core Philosophy: Bottom-Up State

Jotai uses a **bottom-up** approach to state management. Instead of a single monolithic store, state is defined in small, independent "atoms" at the module level. Components subscribe to only the atoms they need -- no selectors, no context providers (by default), no prop drilling.

```tsx
// atoms.ts -- define globally, anywhere
export const countAtom = atom(0)
export const userAtom = atom(null)

// ComponentA.tsx
const count = useAtomValue(countAtom) // subscribes only to countAtom

// ComponentB.tsx
const [user, setUser] = useAtom(userAtom) // subscribes only to userAtom
```

This is the opposite of top-down approaches like Redux or Zustand where state shape is centralised up front.

---

## Atoms vs `useState`

| `useState` | `atom()` |
|---|---|
| Scoped to one component | Can be shared across any component |
| Lifted up or passed as props | No lifting or prop drilling needed |
| Hook rule: only in components | Defined outside components |
| Loses value on unmount | Persists in store regardless of mount state |

**When to replace `useState` with an atom**: the moment state needs to be shared between two components that are not in a parent-child relationship.

---

## Derived Atoms

Atoms can derive from other atoms. The derived value is cached and only recomputes when a dependency changes.

```tsx
const priceAtom = atom(100)
const quantityAtom = atom(2)
const totalAtom = atom((get) => get(priceAtom) * get(quantityAtom))
```

**Key insight**: Derived atoms are the Jotai equivalent of Redux selectors. They are always up-to-date and memoized automatically.

Multi-source derivation works too:

```tsx
const fullNameAtom = atom((get) => {
  const user = get(userAtom)
  return `${user.firstName} ${user.lastName}`
})
```

---

## Async Atoms + Suspense

Atoms can be `async`. When an async atom is read, React Suspense handles the loading state.

```tsx
const dataAtom = atom(async () => {
  const res = await fetch('/api/data')
  return res.json()
})

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <DataDisplay />
    </Suspense>
  )
}

function DataDisplay() {
  const [data] = useAtom(dataAtom) // throws promise, Suspense catches it
  return <div>{data.title}</div>
}
```

### Async without Suspense: `unwrap()`

For components that cannot be wrapped in Suspense (e.g., legacy code), use `unwrap()` to get `undefined`/fallback during loading:

```tsx
const safeAtom = unwrap(asyncDataAtom, () => []) // returns [] while loading
```

### Async actions (write side)

Write functions can also be async. The setter updates the atom once the async work completes:

```tsx
const submitAtom = atom(null, async (get, set, formData) => {
  const result = await api.submit(formData)
  set(responseAtom, result)
})
```

---

## `atomWithStorage` for Persistence

Persist any atom to `localStorage` (or any custom storage backend) automatically:

```tsx
const settingsAtom = atomWithStorage('appSettings', {
  theme: 'light',
  fontSize: 14,
})
```

Works with `sessionStorage`, `AsyncStorage` (React Native), or any object implementing `getItem`/`setItem`/`removeItem`. Multi-tab sync is possible with the `subscribe` callback on the storage interface.

---

## Jotai vs Zustand

| | Jotai | Zustand |
|---|---|---|
| **Model** | Atomic (many small atoms) | Store-based (single/flat object) |
| **Granularity** | Per-value re-render | Selector-based re-render (shallow by default) |
| **Dependencies** | Automatic via `get()` | Manual selectors |
| **Best for** | Fine-grained reactive state; derived/computed values | Single object stores; middleware-heavy patterns |
| **Size** | ~2KB core | ~1KB |
| **Learning curve** | Low (just `useState` semantics) | Low (just hook pattern) |

**Guideline**: Use Jotai when state is naturally independent (theme, auth token, form field values, feature flags). Use Zustand when state forms a cohesive object (e.g., a map editor with many interdependent properties).

They can coexist: `jotai-zustand` or manual bridging lets you read Jotai atoms from Zustand and vice versa.

---

## Provider and Scoping

By default, Jotai uses a global default store. Wrap part of the tree with `<Provider>` to create an isolated scope:

```tsx
<Provider>
  <Dashboard />  {/* all atoms inside get a fresh store */}
</Provider>
```

**Use cases for Provider**:
- SSR: each request gets its own store to avoid cross-request leakage
- Testing: isolate each test with a fresh store
- Multi-instance: render the same component tree with independent state (e.g., side-by-side editors)

Use `createStore()` + `<Provider store={store}>` for full control.

---

## SSR / Next.js Integration

Jotai works with Next.js App Router (server + client components):

1. Define atoms in files marked `'use client'`
2. Use `<Provider>` at the layout level for RSC boundaries
3. Use `useHydrateAtoms()` to seed atoms with server-rendered data on first render:

```tsx
// page.tsx (server component)
const serverData = await fetchData()

// ClientHydrator.tsx (client component)
'use client'
function ClientHydrator({ data }: { data: Data }) {
  useHydrateAtoms([[dataAtom, data]])
  return <App />
}
```

The `dangerouslyForceHydrate` option forces re-hydration on every render (useful when server data changes between navigations).

---

## Compatibility

- **react-bits animations**: Fully compatible. Wrap animated values in atoms and use `useAtom` in `AnimatedComponent` props.
- **animal-island-ui**: Fully compatible. Use atoms for UI state (modals, toasts, theme) consumed by animal-island-ui components.
- **Tailwind CSS**: No interaction -- Jotai manages state, not styles.
- **React version**: Requires React >= 17.0. Works with React 18/19 including `use()` for promise unwrapping.
- **React Native**: Fully supported; use `atomWithStorage` with AsyncStorage.
- **Concurrent Mode**: Compatible with React Suspense and transitions.

---

## Common Pitfalls

1. **Atom defined at component level**: Atoms must be defined at module scope. Defining inside a component body creates a new atom every render.
2. **Infinite loops**: An atom that writes to a dependency it reads from in `write` can loop. Ensure write targets are not in the read chain.
3. **Over-atomizing**: Creating one atom per character of a string is unnecessary. Group related values into object atoms.
4. **Large object atoms with unrelated consumers**: If many components read different slices of the same large object, use `selectAtom` to avoid unnecessary re-renders.
5. **Memory leaks with `atomFamily`**: Remove atoms from the family when they are no longer needed (`family.remove(param)`), especially with unbounded parameter domains.
