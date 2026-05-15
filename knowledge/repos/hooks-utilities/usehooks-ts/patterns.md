# usehooks-ts — Patterns & Best Practices

## Core Patterns

### 1. SSR Safety Pattern
Most hooks accept `initializeWithValue: false` for SSR environments (Next.js, Remix, etc.):
```tsx
// SSR-safe: returns defaultValue initially, then syncs on client
const isDarkOS = useMediaQuery('(prefers-color-scheme: dark)', {
  initializeWithValue: false,
  defaultValue: false,
})
```
Hooks with this option: useLocalStorage, useSessionStorage, useReadLocalStorage, useMediaQuery, useWindowSize, useScreen, useDarkMode, useTernaryDarkMode.

### 2. Composability Pattern
Hooks are designed to compose. Built-in hooks use other hooks internally:
- `useDarkMode` composes `useLocalStorage`, `useMediaQuery`, `useIsomorphicLayoutEffect`
- `useCountdown` composes `useCounter`, `useBoolean`, `useInterval`
- `useWindowSize` composes `useEventListener`, `useDebounceCallback`, `useIsomorphicLayoutEffect`
- `useResizeObserver` composes `useIsMounted`
- `useOnClickOutside` composes `useEventListener`
- `useScrollLock` composes `useIsomorphicLayoutEffect`
- `useDebounceValue` composes `useDebounceCallback`

### 3. Ref-for-Latest-Callback Pattern
Timer and event hooks use `useRef` to store the latest callback, preventing stale closures:
```tsx
// Internal pattern used by useInterval, useTimeout, useEventListener, useUnmount, useIsMounted
const savedCallback = useRef(callback)
useIsomorphicLayoutEffect(() => {
  savedCallback.current = callback
}, [callback])
```

### 4. Tuple vs Object Return Pattern
Choose based on renaming needs:
```tsx
// Tuple return — easy to rename
const [value, toggle, setValue] = useToggle()
const [copiedText, copy] = useCopyToClipboard()

// Object return — descriptive, pick what you need
const { isDarkMode, toggle, enable, disable } = useDarkMode()
```

### 5. useIntersectionObserver Dual Destructuring
Supports both tuple and named destructuring:
```tsx
// Tuple style
const [ref, isIntersecting, entry] = useIntersectionObserver({ threshold: 0.5 })

// Object style (same return value)
const { ref, isIntersecting, entry } = useIntersectionObserver({ threshold: 0.5 })
```

---

## Common Use Cases

### Form Search with Debounce
```tsx
function SearchComponent() {
  const [searchTerm, setSearchTerm] = useState('')
  const [debouncedValue] = useDebounceValue(searchTerm, 500)
  
  useEffect(() => {
    if (debouncedValue) fetchResults(debouncedValue)
  }, [debouncedValue])
  
  return <input value={searchTerm} onChange={e => setSearchTerm(e.target.value)} />
}
```

### Modal with Scroll Lock + Click Outside
```tsx
function Modal({ isOpen, onClose, children }) {
  const modalRef = useRef<HTMLDivElement>(null)
  useOnClickOutside(modalRef, onClose)
  useScrollLock({ autoLock: isOpen })
  
  if (!isOpen) return null
  return <div ref={modalRef} role="dialog">{children}</div>
}
```

### Persistent Dark Mode with System Preference
```tsx
function ThemeToggle() {
  const { isDarkMode, toggle, enable, disable } = useDarkMode()
  
  useEffect(() => {
    document.documentElement.classList.toggle('dark', isDarkMode)
  }, [isDarkMode])
  
  return <button onClick={toggle}>{isDarkMode ? 'Light' : 'Dark'}</button>
}
```

### Three-State Theme Toggle (System | Dark | Light)
```tsx
function ThemeToggle() {
  const { ternaryDarkMode, toggleTernaryDarkMode } = useTernaryDarkMode()
  return <button onClick={toggleTernaryDarkMode}>{ternaryDarkMode}</button>
}
```

### Infinite Scroll with IntersectionObserver
```tsx
function InfiniteList() {
  const { ref, isIntersecting } = useIntersectionObserver({ threshold: 0.1 })
  
  useEffect(() => {
    if (isIntersecting) loadMore()
  }, [isIntersecting])
  
  return (
    <div>
      {items.map(item => <Item key={item.id} {...item} />)}
      <div ref={ref} /> {/* Sentinel element */}
    </div>
  )
}
```

### Responsive Layout with useMediaQuery
```tsx
function Layout() {
  const isMobile = useMediaQuery('(max-width: 768px)')
  const isTablet = useMediaQuery('(min-width: 769px) and (max-width: 1024px)')
  const isDesktop = useMediaQuery('(min-width: 1025px)')
  
  if (isMobile) return <MobileLayout />
  if (isTablet) return <TabletLayout />
  return <DesktopLayout />
}
```

### Copy to Clipboard Button
```tsx
function CopyButton({ text }) {
  const [copiedText, copy] = useCopyToClipboard()
  const [justCopied, setJustCopied] = useState(false)
  
  const handleCopy = async () => {
    await copy(text)
    setJustCopied(true)
    setTimeout(() => setJustCopied(false), 2000)
  }
  
  return <button onClick={handleCopy}>{justCopied ? 'Copied!' : 'Copy'}</button>
}
```

### Countdown Timer
```tsx
function Timer() {
  const [seconds, { startCountdown, stopCountdown, resetCountdown }] = useCountdown({
    countStart: 60,
    intervalMs: 1000,
    countStop: 0,
  })
  
  return (
    <div>
      <p>{seconds}s remaining</p>
      <button onClick={startCountdown}>Start</button>
      <button onClick={stopCountdown}>Pause</button>
      <button onClick={resetCountdown}>Reset</button>
    </div>
  )
}
```

### Multi-Step Form with useStep
```tsx
function MultiStepForm() {
  const [step, { goToNextStep, goToPrevStep, canGoToNextStep, canGoToPrevStep }] = useStep(3)
  
  return (
    <div>
      {step === 1 && <StepOne />}
      {step === 2 && <StepTwo />}
      {step === 3 && <StepThree />}
      <button disabled={!canGoToPrevStep} onClick={goToPrevStep}>Back</button>
      <button disabled={!canGoToNextStep} onClick={goToNextStep}>Next</button>
    </div>
  )
}
```

### Hover Detection
```tsx
function HoverBox() {
  const hoverRef = useRef<HTMLDivElement>(null)
  const isHovered = useHover(hoverRef)
  
  return <div ref={hoverRef} style={{ background: isHovered ? 'blue' : 'gray' }} />
}
```

---

## SSR Considerations

### Pattern: Guard Browser-Only Code
```tsx
const isClient = useIsClient()
if (!isClient) return <Loading />
// Safe to use browser APIs here
```

### Pattern: Avoid State Updates After Unmount
```tsx
const isMounted = useIsMounted()
fetchData().then(data => {
  if (isMounted()) setState(data)
})
```

### Pattern: Dynamic Script Loading
```tsx
const scriptStatus = useScript('https://third-party.com/widget.js')
if (scriptStatus === 'ready') return <ThirdPartyWidget />
if (scriptStatus === 'error') return <Fallback />
return <Spinner />
```

---

## Anti-Patterns to Avoid

- **Don't use useLayoutEffect directly in SSR** — use `useIsomorphicLayoutEffect` instead
- **Don't call setState after unmount** — always check `isMounted()` before async state updates
- **Don't pass changing callbacks to useInterval** — the hook handles this via refs internally
- **Don't use useMediaQuery without `initializeWithValue: false` in SSR** — causes hydration mismatch
- **Don't use useLocalStorage without try/catch wrapper** — localStorage may be unavailable (the hook handles this internally)
