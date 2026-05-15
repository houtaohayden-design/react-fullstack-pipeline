# usehooks-ts — API Reference

## Setup
```bash
npm install usehooks-ts
```

## Hooks (33 total)

---

### State Management Hooks

#### useBoolean
- **Returns:** `{ value, setValue, setTrue, setFalse, toggle }`
- **Usage:** `const { value, setTrue, setFalse, toggle } = useBoolean(false)`
- **Type:** Boolean state with explicit setters and toggle
- **Params:** `defaultValue?: boolean` (default `false`)

#### useToggle
- **Returns:** `[boolean, () => void, Dispatch<SetStateAction<boolean>>]` — tuple of `[value, toggle, setValue]`
- **Usage:** `const [isOpen, toggle, setOpen] = useToggle(false)`
- **Type:** Boolean toggle with tuple return (simpler alternative to useBoolean)

#### useCounter
- **Returns:** `{ count, increment, decrement, reset, setCount }`
- **Usage:** `const { count, increment, decrement, reset } = useCounter(5)`
- **Type:** Number counter with increment/decrement/reset
- **Params:** `initialValue?: number` (default `0`)

#### useStep
- **Returns:** `[number, { goToNextStep, goToPrevStep, reset, canGoToNextStep, canGoToPrevStep, setStep }]`
- **Usage:** `const [currentStep, { goToNextStep, goToPrevStep }] = useStep(3)`
- **Type:** Multi-step navigation (1-indexed). Throws if step out of range.
- **Params:** `maxStep: number`

#### useMap
- **Returns:** `[Omit<Map<K,V>, 'set'|'clear'|'delete'>, { set, setAll, remove, reset }]`
- **Usage:** `const [map, { set, remove, reset }] = useMap<string, number>()`
- **Type:** Immutable Map state with setter actions
- **Params:** `initialState?: Map<K,V> | [K,V][]`

#### useCountdown
- **Returns:** `[number, { startCountdown, stopCountdown, resetCountdown }]`
- **Usage:** `const [seconds, { startCountdown, stopCountdown }] = useCountdown({ countStart: 60 })`
- **Type:** Configurable countdown/count-up with controls
- **Params:** `{ countStart, intervalMs?, isIncrement?, countStop? }`

---

### Dark Mode Hooks

#### useDarkMode
- **Returns:** `{ isDarkMode, toggle, enable, disable, set }`
- **Usage:** `const { isDarkMode, toggle } = useDarkMode({ defaultValue: true })`
- **Type:** Dark mode with localStorage persistence + system preference detection
- **Params:** `{ defaultValue?, localStorageKey?, initializeWithValue? }`

#### useTernaryDarkMode
- **Returns:** `{ isDarkMode, ternaryDarkMode, setTernaryDarkMode, toggleTernaryDarkMode }`
- **Usage:** `const { ternaryDarkMode, toggleTernaryDarkMode } = useTernaryDarkMode()`
- **Type:** Three-state dark mode: `'system'` | `'dark'` | `'light'`. Cycles between them on toggle.
- **Params:** `{ defaultValue?, localStorageKey?, initializeWithValue? }`

---

### Debounce Hooks

#### useDebounceValue
- **Returns:** `[T, DebouncedState<(value: T) => void>]` — debounced value + updater with cancel/flush/isPending
- **Usage:** `const [debouncedSearch, update] = useDebounceValue(searchInput, 500)`
- **Type:** Debounces a value update. Supports `leading`, `trailing`, `maxWait`, and custom `equalityFn`.
- **Params:** `initialValue: T | (() => T), delay: number, options?: { leading?, trailing?, maxWait?, equalityFn? }`

#### useDebounceCallback
- **Returns:** `DebouncedState<T>` — a debounced function with `.cancel()`, `.flush()`, `.isPending()`
- **Usage:** `const debouncedSearch = useDebounceCallback(searchApi, 500)`
- **Type:** Debounces a callback function. Uses lodash.debounce internally.
- **Params:** `func: T, delay?: number (default 500), options?: { leading?, trailing?, maxWait? }`

---

### Event Hooks

#### useEventListener
- **Returns:** `void`
- **Usage:** 
  ```tsx
  useEventListener('resize', handleResize)
  useEventListener('click', handleClick, elementRef, { capture: true })
  ```
- **Type:** Type-safe addEventListener with auto-cleanup. Works with window, document, elements, and MediaQueryList. Supports overloaded signatures for different event target types.

#### useOnClickOutside
- **Returns:** `void`
- **Usage:** `useOnClickOutside([containerRef], () => closeModal())`
- **Type:** Detects clicks outside a ref element. Supports single ref or array of refs. Configurable event type (mousedown, mouseup, touchstart, touchend, focusin, focusout).
- **Params:** `ref: RefObject<T> | RefObject<T>[], handler, eventType? = 'mousedown', eventListenerOptions?`

#### useClickAnyWhere
- **Returns:** `void`
- **Usage:** `useClickAnyWhere(handler)`
- **Type:** Registers a click handler on the entire document

#### useEventCallback
- **Returns:** `(...args: Args) => R` — stable callback that always calls latest fn
- **Usage:** `const handleClick = useEventCallback((event) => { /* uses latest state */ })`
- **Type:** Like useCallback but never needs dependencies — always calls the latest version of the function without changing reference. Equivalent to "useEffectEvent".

#### useHover
- **Returns:** `boolean`
- **Usage:** `const isHovered = useHover(buttonRef)`
- **Type:** Tracks whether an element is being hovered over
- **Params:** `elementRef: RefObject<T>`

---

### Browser API Hooks

#### useCopyToClipboard
- **Returns:** `[CopiedValue, CopyFn]` — `[copiedText: string | null, copy: (text: string) => Promise<boolean>]`
- **Usage:** `const [copiedText, copy] = useCopyToClipboard()`
- **Type:** Uses Clipboard API. Returns copied text and async copy function that returns success boolean.

#### useLocalStorage
- **Returns:** `[T, Dispatch<SetStateAction<T>>, () => void]` — `[value, setValue, removeValue]`
- **Usage:** `const [name, setName, removeName] = useLocalStorage('name', 'Anonymous')`
- **Type:** Persist state to localStorage. Supports custom serializer/deserializer, SSR-safe with `initializeWithValue: false`. Cross-tab sync via custom events.
- **Params:** `key: string, initialValue: T | (() => T), options?: { serializer?, deserializer?, initializeWithValue? }`

#### useSessionStorage
- **Returns:** `[T, Dispatch<SetStateAction<T>>, () => void]` — `[value, setValue, removeValue]`
- **Usage:** `const [token, setToken, removeToken] = useSessionStorage('token', '')`
- **Type:** Same API as useLocalStorage but uses sessionStorage

#### useReadLocalStorage
- **Returns:** `T | null | undefined`
- **Usage:** `const storedData = useReadLocalStorage('myKey')`
- **Type:** Read-only access to localStorage. Reactively updates when storage changes.
- **Params:** `key: string, options?: { deserializer?, initializeWithValue? }`

#### useMediaQuery
- **Returns:** `boolean`
- **Usage:** `const isSmallScreen = useMediaQuery('(max-width: 600px)')`
- **Type:** Tracks CSS media query state. SSR-safe with defaultValue option.
- **Params:** `query: string, options?: { defaultValue?, initializeWithValue? }`

#### useWindowSize
- **Returns:** `{ width: number | undefined, height: number | undefined }`
- **Usage:** `const { width = 0, height = 0 } = useWindowSize()`
- **Type:** Tracks browser window dimensions. Supports debounce via `debounceDelay`. SSR-safe with `initializeWithValue: false`.
- **Params:** `options?: { initializeWithValue?, debounceDelay? }`

#### useScreen
- **Returns:** `Screen | undefined` — full window.screen object (width, height, availWidth, availHeight, colorDepth, pixelDepth, orientation)
- **Usage:** `const screen = useScreen(); console.log(screen?.width)`
- **Type:** Tracks screen dimensions. Auto-recreates shallow clone on resize for re-render.
- **Params:** `options?: { initializeWithValue?, debounceDelay? }`

#### useIntersectionObserver
- **Returns:** `[(node?: Element | null) => void, boolean, IntersectionObserverEntry?]` — also supports named destructuring: `{ ref, isIntersecting, entry }`
- **Usage:** `const { ref, isIntersecting } = useIntersectionObserver({ threshold: 0.5 })`
- **Type:** Intersection Observer hook. Supports `freezeOnceVisible`, `onChange` callback, custom `root`/`rootMargin`/`threshold`.
- **Params:** `options?: { threshold?, root?, rootMargin?, freezeOnceVisible?, initialIsIntersecting?, onChange? }`

#### useResizeObserver
- **Returns:** `{ width: number | undefined, height: number | undefined }`
- **Usage:** `const { width = 0, height = 0 } = useResizeObserver({ ref: myRef, box: 'border-box' })`
- **Type:** Observes element size changes. Supports `onResize` callback mode (no re-render) or state-based mode. Configurable box model: content-box, border-box, device-pixel-content-box.
- **Params:** `options: { ref, onResize?, box? }`

#### useScript
- **Returns:** `'idle' | 'loading' | 'ready' | 'error'`
- **Usage:** `const status = useScript('https://example.com/script.js', { removeOnUnmount: true })`
- **Type:** Dynamically loads external scripts. Caches status globally, deduplicates across instances.
- **Params:** `src: string | null, options?: { shouldPreventLoad?, removeOnUnmount?, id? }`

#### useScrollLock
- **Returns:** `{ isLocked, lock, unlock }`
- **Usage:** `useScrollLock()` — auto-locks on mount, unlocks on unmount
- **Type:** Locks body scroll (e.g., for modals). Prevents width reflow by compensating for scrollbar. Configurable lockTarget.
- **Params:** `options?: { autoLock?, lockTarget?, widthReflow? }`

#### useDocumentTitle
- **Returns:** `void`
- **Usage:** `useDocumentTitle('My Page Title')`
- **Type:** Sets document.title. Optionally restores previous title on unmount.
- **Params:** `title: string, options?: { preserveTitleOnUnmount? }`

---

### SSR / Lifecycle Hooks

#### useIsClient
- **Returns:** `boolean`
- **Usage:** `const isClient = useIsClient()`
- **Type:** Returns `true` after first useEffect (client-side mount). Used for conditional rendering in SSR.

#### useIsMounted
- **Returns:** `() => boolean` — a function you call to check if component is mounted
- **Usage:** `const isMounted = useIsMounted(); if (isMounted()) setState(data)`
- **Type:** Returns a stable function to check mount status. Useful for avoiding state updates after unmount.

#### useIsomorphicLayoutEffect
- **Returns:** N/A (effect hook)
- **Usage:** `useIsomorphicLayoutEffect(() => { ... }, [deps])`
- **Type:** Uses useLayoutEffect on client, useEffect on server. Use instead of useLayoutEffect when SSR is needed.

---

### Timer Hooks

#### useInterval
- **Returns:** `void`
- **Usage:** `useInterval(() => { console.log('tick') }, 1000)`
- **Type:** setInterval with auto-cleanup. Pass `null` as delay to pause. Uses ref for latest callback (no stale closures).
- **Params:** `callback: () => void, delay: number | null`

#### useTimeout
- **Returns:** `void`
- **Usage:** `useTimeout(() => navigate('/timeout'), 5000)`
- **Type:** setTimeout with auto-cleanup. Pass `null` to cancel. Uses ref for latest callback.
- **Params:** `callback: () => void, delay: number | null`

#### useUnmount
- **Returns:** `void`
- **Usage:** `useUnmount(() => { /* cleanup */ })`
- **Type:** Runs a callback on component unmount. Uses ref to always call latest function.
- **Params:** `func: () => void`
