# react-use -- Patterns

## Styling Approach
- **No UI**: This is purely logic/state hooks. No components, no CSS, no visual output.
- Works with any styling system (Tailwind, CSS Modules, styled-components, etc.).
- Each hook is independently importable for tree-shaking. `import { useToggle } from 'react-use'` only bundles that hook.

## Architecture
- Every hook is a single file in `src/` -- no internal dependencies (mostly).
- Factory hooks (`createBreakpoint`, `createReducer`, `createGlobalState`, etc.) produce custom hooks at runtime.
- No framework-specific dependencies beyond React 16.8+.
- Written in TypeScript -- full type definitions included.

## Common Composition Patterns

### Dropdown / Modal
```tsx
const ref = useRef(null);
const [open, toggle] = useToggle(false);
useClickAway(ref, () => toggle(false));
// <div ref={ref}>{open && <Dropdown />}</div>
```

### Search Input with Debounce
```tsx
const [query, setQuery] = useState('');
const debouncedQuery = useDebounce(query, 300);
// Trigger API call when debouncedQuery changes
useEffect(() => { fetchResults(debouncedQuery); }, [debouncedQuery]);
```

### Async Data Fetching
```tsx
const { loading, error, value } = useAsync(() => fetchUser(id), [id]);
// Render loading spinner, error message, or user data
```

### Keyboard Shortcuts
```tsx
useKey('Escape', () => close());
useKey(['ctrl+s', 'meta+s'], (e) => { e.preventDefault(); save(); });
// useKeyPressEvent for separate keydown/keyup handlers
```

### Scroll-Based Animation
```tsx
const ref = useRef(null);
const { y } = useScroll(ref);
const springValue = useSpring(y, { stiffness: 100, damping: 20 });
// Use springValue for smooth transitions
```

### Element Measurement
```tsx
const [measureRef, { width, height }] = useMeasure();
// <div ref={measureRef}>{width}x{height}</div>
// Returns a callback ref, not a RefObject -- pass directly
```

### Window-Size Responsive
```tsx
const { width } = useWindowSize();
const isMobile = width < 768;
// vs useMedia:
const isMobile = useMedia('(max-width: 767px)');
```

### Toggle + Hover Combo
```tsx
const hoverRef = useRef(null);
const isHovered = useHover(hoverRef);
const [open, toggle] = useToggle(false);
// <div ref={hoverRef} onMouseEnter={() => toggle(true)}>...</div>
```

### localStorage-Backed State
```tsx
const [value, setValue, remove] = useLocalStorage('my-key', 'default');
// Persists across page reloads, syncs across open tabs
```

### Copy to Clipboard
```tsx
const [{ value, error, success }, copyToClipboard] = useCopyToClipboard();
// onClick={() => copyToClipboard('text to copy')}
```

### Mouse Tracking for Effects
```tsx
const ref = useRef(null);
const { elX, elY } = useMouse(ref);
// Track mouse position within the element for tilt/card effects
```

### Fullscreen Toggle
```tsx
const ref = useRef(null);
const { show, hide, toggle, isFullscreen } = useFullscreen(ref);
// <div ref={ref}><img src="..." /><button onClick={toggle}>Fullscreen</button></div>
```

### List State Management
```tsx
const [list, { push, filter, updateAt, removeAt, sort, clear }] = useList(initialItems);
// Immutable-like operations that trigger re-renders
```

### Lifecycle Logging
```tsx
useLogger('MyComponent', props);
// Logs: "[MyComponent] mounted", "[MyComponent] updated", "[MyComponent] unmounted"
```

### Ref-Based State (No Stale Closures)
```tsx
const [getState, setState] = useGetSet(0);
// Always read latest: getState()
// No need for useEffect dependency arrays for state
```

## Compatibility

| Integration | Notes |
|---|---|
| **Tailwind CSS** | Compatible -- hooks are pure logic, no styling conflict |
| **react-bits** | Excellent complement -- react-bits for visual effects, react-use for interaction logic |
| **animal-island-ui** | Compatible -- use react-use hooks to power interactions in animal-island components |
| **ahooks** | Overlaps significantly. react-use has ~28 more hooks; ahooks has Chinese docs + useRequest plugin system |
| **React 16.8+** | Minimum requirement. Some hooks (useIdle, useMeasure) use newer browser APIs |
| **React 18** | Fully supported. Concurrent features work (useSyncExternalStore not needed -- no external stores) |
| **SSR** | Most hooks work. useIsomorphicLayoutEffect helps with SSR-safe layout effects. Some sensor hooks (geolocation, battery) return safe defaults on server |
| **React Native** | Partial support. DOM-specific hooks (useMouse, useClickAway) won't work. State/lifecycle hooks work fine |
| **Tree-shaking** | Fully supported. Each hook is a separate file with default export. Named imports pick only what you use |

## Performance Notes
- Sensor hooks: Most use RAF-based state updates (useRafState) for smooth performance.
- `useMeasure` uses ResizeObserver with a single shared observer instance.
- `useAsync` creates a new async function on each dependency change -- memoize callbacks if needed.
- `useDebounce` / `useThrottle` wrap `useTimeoutFn` -- cancel/reset controls available.

## Comparison: react-use vs ahooks

| Aspect | react-use | ahooks |
|---|---|---|
| Total hooks | 113 | ~85 |
| Sensors | Best -- 30 hooks covering every browser API | ~10 |
| State | 34 hooks (deep) | ~20 (useRequest focused) |
| Lifecycle | 14 hooks (fine-grained) | ~8 |
| Async | Basic (useAsync, useAsyncFn) | Elite (useRequest with plugins, cache, retry, polling) |
| Animations | 8 hooks (RAF, spring, tween) | ~3 |
| UI helpers | 10 hooks (clickaway, drop, slider, speech) | ~5 |
| Language | English docs | Chinese + English docs |
| Maintenance | Active (15k+ stars) | Active (15k+ stars) |
