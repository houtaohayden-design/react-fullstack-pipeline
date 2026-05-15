# Jotai API Reference

> Source: https://github.com/pmndrs/jotai | Version: 2.20.0

## Setup

```bash
npm install jotai
```

Jotai has zero peer dependencies but requires React >= 17. Import from `jotai` for core or `jotai/utils` for utilities.

---

## Core API

### `atom(initialValue)`

Creates a primitive (writable) atom with an initial value. Works like a shareable `useState`.

```tsx
import { atom } from 'jotai'
const countAtom = atom(0)             // primitive value
const userAtom = atom({ name: 'Alice' }) // object
```

### `atom(read)` -- Derived (read-only) atom

Pass a read function that uses `get()` to depend on other atoms. The atom recomputes when any dependency changes.

```tsx
const doubledAtom = atom((get) => get(countAtom) * 2)
```

### `atom(read, write)` -- Derived (writable) atom

Pass both a read and write function. `write` receives `(get, set, ...args)`.

```tsx
const doubleAtom = atom(
  (get) => get(countAtom) * 2,
  (get, set, newValue) => set(countAtom, newValue / 2)
)
```

### `atom(null, write)` -- Write-only atom

Set the first argument to `null` (or anything) and pass only a write function. Reading is meaningless.

```tsx
const multiplyAtom = atom(null, (get, set, factor) => {
  set(countAtom, get(countAtom) * factor)
})
```

### `useAtom(anAtom)`

React hook that returns `[value, setValue]` -- identical in usage to `useState` but backed by an atom.

```tsx
const [count, setCount] = useAtom(countAtom)
```

### `useAtomValue(anAtom)`

Returns only the current value of an atom. Prefer this when the component only reads.

```tsx
const count = useAtomValue(countAtom)
```

### `useSetAtom(anAtom)`

Returns a stable setter function. Prefer this when the component only writes.

```tsx
const setCount = useSetAtom(countAtom)
setCount(42)
```

### `<Provider>`

Creates an isolated store scope. All descendant hooks use this store instead of the default. Optionally pass a pre-created `store`.

```tsx
import { Provider, createStore } from 'jotai'

const myStore = createStore()

<Provider store={myStore}>
  <App />
</Provider>
```

### `createStore()`

Creates a standalone Jotai store (a bag of atom state). Useful for testing, SSR, or manual subscriptions.

```tsx
const store = createStore()
store.get(countAtom)    // read
store.set(countAtom, 5) // write
store.sub(countAtom, () => console.log('changed'))
```

### `getDefaultStore()`

Returns the singleton default store (the one used when no `<Provider>` is in the tree).

```tsx
const store = getDefaultStore()
store.set(countAtom, 100) // imperatively write from outside React
```

---

## Utility API (`jotai/utils`)

Import all from `'jotai/utils'`.

### `atomWithStorage(key, initialValue, storage?)`

Atom that auto-persists to `localStorage` (default) or a custom storage. Survives page refresh.

```tsx
import { atomWithStorage } from 'jotai/utils'

const darkModeAtom = atomWithStorage('darkMode', false)
const [dark, setDark] = useAtom(darkModeAtom)
```

Custom storage (sessionStorage, async, etc.) via `createJSONStorage`:

```tsx
import { atomWithStorage, createJSONStorage } from 'jotai/utils'

const storage = createJSONStorage(() => sessionStorage)
const tokenAtom = atomWithStorage('token', '', storage)
```

### `atomWithReset(initialValue)`

Like `atom(initialValue)` but the setter accepts `RESET` to revert to the initial value.

```tsx
import { atomWithReset, RESET } from 'jotai/utils'

const countAtom = atomWithReset(0)
const setCount = useSetAtom(countAtom)
setCount(RESET) // back to 0
```

### `useResetAtom(anAtom)`

Returns a `reset()` function for any atom that supports `RESET` (e.g. `atomWithReset`, `atomWithStorage`).

```tsx
const reset = useResetAtom(countAtom)
reset()
```

### `atomWithReducer(initialValue, reducer)`

Atom backed by a reducer function -- similar to `useReducer` but shareable.

```tsx
const countAtom = atomWithReducer(0, (prev, action) => {
  switch (action) {
    case 'inc': return prev + 1
    case 'dec': return prev - 1
    default: return prev
  }
})
const [count, dispatch] = useAtom(countAtom)
dispatch('inc')
```

### `atomFamily(initializeAtom, areEqual?)`

**Deprecated in v3 -- use `jotai-family` package.** Creates a parametrized atom factory. Calling `family(param)` returns a lazily-created atom.

```tsx
const nameAtomFamily = atomFamily((id: number) => atom(`User ${id}`))
const nameAtom = nameAtomFamily(42)
```

### `selectAtom(anAtom, selector, equalityFn?)`

Creates a derived atom that extracts a slice. Re-renders only when the selected slice changes, using `Object.is` (or a custom comparator).

```tsx
const userAtom = atom({ name: 'Alice', age: 30 })
const nameAtom = selectAtom(userAtom, (u) => u.name)
```

### `splitAtom(arrAtom, keyExtractor?)`

"Splits" an array atom into individual item atoms. Returns `[itemAtom[], dispatch]` where dispatch supports `{type: 'insert'|'remove'|'move'}` actions.

```tsx
const itemsAtom = atom([{ id: 1, text: 'hello' }])
const splittedAtom = splitAtom(itemsAtom, (item) => item.id)
const [itemAtoms, dispatch] = useAtom(splittedAtom)
dispatch({ type: 'remove', atom: itemAtoms[0] })
```

### `loadable(anAtom)` (deprecated)

**Deprecated -- use `unwrap` instead.** Wraps an async atom to return a `{ state, data?, error? }` shape instead of throwing.

```tsx
const asyncAtom = atom(async () => fetch('/api').then(r => r.json()))
const loadableAtom = loadable(asyncAtom)
const value = useAtomValue(loadableAtom)
// value: { state: 'loading' } | { state: 'hasData', data } | { state: 'hasError', error }
```

### `unwrap(anAtom, fallback?)`

Unwraps a promise-valued atom so it returns `undefined` (or `fallback`) during loading, then the resolved value. Handles errors by re-throwing.

```tsx
const asyncAtom = atom(async () => fetch('/api').then(r => r.json()))
const unwrappedAtom = unwrap(asyncAtom, () => [])
const data = useAtomValue(unwrappedAtom) // [] while loading, then actual data
```

### `atomWithDefault(getDefault)`

Atom whose initial value is lazily evaluated from other atoms. Supports `RESET` to clear the override.

```tsx
const valAtom = atomWithDefault((get) => get(otherAtom) * 2)
```

### `atomWithRefresh(read, write?)`

Adds a "refresh" action -- calling the setter with zero arguments increments a counter, causing a re-read.

```tsx
const dataAtom = atomWithRefresh(async (get) => {
  const id = get(idAtom)
  return fetch(`/api/${id}`).then(r => r.json())
})
const [, refresh] = useAtom(dataAtom)
<button onClick={refresh}>Refresh</button>
```

### `atomWithLazy(makeInitial)`

Atom whose initial value is lazily computed on first use.

```tsx
const lazyAtom = atomWithLazy(() => expensiveComputation())
```

### `atomWithObservable(getObservable)`

Creates an atom from an RxJS Observable. Updates the atom whenever the observable emits.

```tsx
const observableAtom = atomWithObservable(() => myObservable$)
```

### `freezeAtom(anAtom)`

Deep-freezes the value returned from the atom. Catches accidental mutation in development.

```tsx
const frozenAtom = freezeAtom(myObjectAtom)
```

### `useAtomCallback(callback, options?)`

Returns a stable callback that has access to `(get, set, ...args)` without subscribing.

```tsx
const readCount = useAtomCallback((get, set, multiplier: number) => {
  const count = get(countAtom)
  set(countAtom, count * multiplier)
})
<button onClick={() => readCount(3)}>Triple</button>
```

### `useHydrateAtoms(values, options?)`

Hydrates atoms with SSR data on first render. Accepts `[[atom, value], ...]` tuples or a `Map`.

```tsx
useHydrateAtoms([
  [countAtom, 42],
  [userAtom, { name: 'SSR' }],
])
```

### `useReducerAtom(anAtom, reducer)` (deprecated)

**Deprecated -- use `atomWithReducer`.** Hook that wraps atom setter with a reducer.

```tsx
const [count, dispatch] = useReducerAtom(countAtom, (prev, action) => ...)
```

---

## TypeScript Helpers

```tsx
import type {
  PrimitiveAtom,
  WritableAtom,
  ExtractAtomValue,
  ExtractAtomArgs,
  SetStateAction,
} from 'jotai'
```

`ExtractAtomValue<T>` and `ExtractAtomArgs<T>` infer value/args types from atom types.
