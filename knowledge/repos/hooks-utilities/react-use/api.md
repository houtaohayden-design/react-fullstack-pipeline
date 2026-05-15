# react-use -- API Reference

## Setup
```bash
npm install react-use
```

## Overview
113 exported hooks covering sensors, UI, animations, side-effects, lifecycles, and state management. Every hook is independently importable for tree-shaking.

## Hooks by Category

### Sensors (30 hooks) -- browser events and device APIs as hooks

#### useMouse
- **Signature:** `useMouse(ref: RefObject<Element>): State`
- **Returns:** `{ docX, docY, posX, posY, elX, elY, elH, elW }`
  - `docX/docY` -- mouse position relative to document
  - `elX/elY/elW/elH` -- position relative to the referenced element + its dimensions
  - `posX/posY` -- element position in document coordinates
- **Usage:** Pass a ref to the element you want to track. Updates on RAF for smooth performance.

#### useMouseHovered
- Tracks whether mouse is hovering over an element and its position.

#### useMouseWheel
- Tracks `deltaY` and scroll direction of mouse wheel events.
- **Returns:** `number` -- accumulated deltaY.

#### useKey
- **Signature:** `useKey(filter: string | string[] | ((e: KeyboardEvent) => boolean), handler: (e: KeyboardEvent) => void, options?: UseKeyOptions)`
- Listen for a specific key press with optional event type filter (keydown/keyup/keypress).
- **Usage:** `useKey('Escape', () => close())` or `useKey(['a', 'b'], handler)`.

#### useKeyPress
- **Signature:** `useKeyPress(keyFilter: KeyFilter): [boolean, KeyboardEvent | null]`
- Returns pressed state for a key. Unlike `useKey`, this is a sensor that tracks if a key is currently held down.

#### useKeyPressEvent
- **Signature:** `useKeyPressEvent(key: string, keydown?: (e) => void, keyup?: (e) => void)`
- Convenience wrapper that calls callbacks on keydown/keyup instead of returning state.

#### useKeyboardJs
- **Purpose:** Combo key binding using keyboardjs library (requires keyboardjs peer dependency).
- **Status:** Not exported by default -- peer dependency required.

#### useWindowSize
- **Returns:** `{ width: number, height: number }`
- Reactive window dimensions. Updates on resize.

#### useWindowScroll
- **Returns:** `{ x: number, y: number }`
- Reactive window scroll position. Updates on scroll.

#### useMeasure
- **Signature:** `useMeasure<E>(): [(element: E) => void, UseMeasureRect]`
- **Returns:** `[ref, { x, y, width, height, top, right, bottom, left }]`
- Uses ResizeObserver for element dimension tracking. Returns a callback ref, not a RefObject.
- Falls back gracefully if ResizeObserver is unavailable.

#### useSize
- Similar to useMeasure via `<div ref={sized.ref}><p>{sized.width}x{sized.height}</p></div>`
- **Returns:** `[SizedRef, { width, height }]`

#### useMedia
- **Signature:** `useMedia(query: string, defaultState?: boolean): boolean`
- Matches a CSS media query reactively.
- **Usage:** `const isWide = useMedia('(min-width: 1024px)')`

#### useMediaDevices
- **Returns:** `{ devices: MediaDeviceInfo[], ... }`
- Tracks connected media devices (cameras, microphones, speakers).

#### useGeolocation
- **Returns:** `{ latitude, longitude, accuracy, altitude, speed, timestamp, error }`
- Wraps the browser Geolocation API. Updates reactively as position changes.

#### useOrientation
- **Returns:** `{ angle, type }` (screen orientation)
- Tracks device screen orientation changes.

#### useNetworkState
- **Returns:** `{ online: boolean, downlink, downlinkMax, effectiveType, rtt, saveData, type }`
- Tracks NetworkInformation API -- online state, connection type, bandwidth estimates.

#### useBattery
- **Returns:** `{ charging, level, chargingTime, dischargingTime }`
- Wraps the Battery Status API.

#### useIdle
- **Signature:** `useIdle(ms: number): boolean`
- Returns `true` after user has been idle (no mouse/keyboard/touch) for `ms` milliseconds.

#### useHover
- **Signature:** `useHover(ref: RefObject<Element>): boolean`
- Tracks whether the referenced element is being hovered. Uses mouseenter/mouseleave.

#### useHoverDirty
- Like useHover but uses mouseover/mouseout -- more accurate for elements with children.

#### useIntersection
- **Signature:** `useIntersection(ref: RefObject<Element>, options?: IntersectionObserverInit): IntersectionObserverEntry | null`
- Wraps IntersectionObserver for scroll-based animations, lazy loading, etc.

#### useScroll
- **Signature:** `useScroll(ref: RefObject<Element>): { x: number, y: number }`
- Tracks an HTML element's scroll position.

#### useScrolling
- **Signature:** `useScrolling(ref: RefObject<Element>): boolean`
- Returns `true` while the element is being scrolled.

#### useLocation
- **Returns:** `{ trigger: string, state?: any, ... }`
- Tracks browser location (history state + URL) changes via popstate/hashchange.

#### useSearchParam
- **Signature:** `useSearchParam(param: string): string | null`
- Reads a single URL search parameter. Updates on URL changes.

#### useHash
- **Returns:** `string`
- Tracks `window.location.hash` reactively.

#### useMotion
- Tracks device motion sensor data (DeviceMotionEvent).

#### useLongPress
- **Signature:** `useLongPress(onLongPress, options: { delay: 300, ... })`
- Calls a callback when user holds a pointer down long enough on the referenced element.

#### usePinchZoom
- Tracks pinch-zoom gestures using pointer events on a referenced element.

#### useScratch
- Tracks mouse click-and-scrub state (like a scratch card).

#### useStartTyping
- **Signature:** `useStartTyping(callback: (e: KeyboardEvent) => void)`
- Fires when user starts typing (ignores focus on input/textarea/contenteditable elements).

#### usePageLeave
- Fires a callback when the mouse leaves the page boundaries.

#### useScrollbarWidth
- **Returns:** `number | undefined`
- Detects the browser's native scrollbar width in pixels.

#### createBreakpoint
- **Signature:** `useBreakpoint = createBreakpoint(queryMap)`
- Factory that creates a breakpoint hook. Returns an object with boolean keys.
- **Usage:** `const useBreakpoint = createBreakpoint({ laptopL: 1440, tablet: 768 })` then `const { laptopL } = useBreakpoint()`


### UI (10 hooks) -- component behavior helpers

#### useClickAway
- **Signature:** `useClickAway(ref: RefObject<HTMLElement>, handler: (e: Event) => void, events?: string[])`
- Triggers handler when user clicks/touches outside the referenced element.
- Default events: `['mousedown', 'touchstart']`. Customizable.
- **Usage:** `useClickAway(ref, () => setIsOpen(false))`

#### useDrop
- **Signature:** `useDrop(options): UseDropState`
- Listen for file/link drops on an element. Returns `{ over: boolean, ... }` with drop state.

#### useDropArea
- **Signature:** `useDropArea(options): { bonded: {} }`
- Creates a bonded area that tracks drag-and-drop. Simpler API than useDrop.

#### useFullscreen
- **Signature:** `useFullscreen(ref): { show, hide, toggle, isFullscreen }`
- Manages fullscreen mode for a referenced element.

#### useAudio
- Creates and controls an HTMLAudioElement via hooks.
- **Returns:** `{ time, playing, volume, ...controls }`

#### useVideo
- Same pattern as useAudio but for HTMLVideoElement.
- **Returns:** `{ time, playing, volume, muted, ...controls }`

#### useSpeech
- Synthesizes speech from text using the Web Speech API.
- **Returns:** `{ speak, stop, ... }`

#### useSlider
- **Signature:** `useSlider(ref: RefObject<Element>, options?): { isSliding, value: number, pos, length }`
- Adds slide/drag behavior with value tracking.

#### useVibrate
- Controls device vibration using the Vibration API.
- **Returns:** `[vibrating, { vibrate, stop }]`

#### useCss
- **Signature:** `useCss(css: CSSProperties): { className }`
- Dynamically injects CSS rules and returns a generated className.


### Animations (8 hooks)

#### useRaf
- **Returns:** `number` (elapsed ms)
- Re-renders the component on every requestAnimationFrame tick.
- **Usage:** `const elapsed = useRaf(); const progress = (elapsed / duration) % 1;`

#### useRafLoop
- **Signature:** `useRafLoop(callback: (time: number) => void, autoStart?: boolean): [start, stop, isActive]`
- Calls a function every RAF frame with timestamp. Prefer over useRaf for side effects.

#### useTimeout
- **Signature:** `useTimeout(ms: number): [isReady: () => boolean | null, cancel, reset]`
- Re-renders component after a timeout (like a delayed boolean).

#### useTimeoutFn
- **Signature:** `useTimeoutFn(fn: Function, ms: number): [isReady, cancel, reset]`
- Calls a function after a timeout. Returns controls for cancel/reset.

#### useInterval
- **Signature:** `useInterval(callback: Function, delay: number | null)`
- Runs callback on a setInterval schedule. Pass `null` to pause.

#### useHarmonicIntervalFn
- Alternative to useInterval using a harmonic interval approach (synchronized intervals).

#### useTween
- **Signature:** `useTween(duration: number): number`
- Tweens a value from 0 to 1 over `duration` ms. Resets when dependencies change.

#### useSpring
- **Signature:** `useSpring(target: number, options?: { stiffness?: 100, damping?: 10 }): number`
- Spring physics simulation. Interpolates a number to `target` with configurable spring tension.
- **Status:** Implemented but requires `rebound` peer dependency; not exported by default.

#### useUpdate
- **Returns:** `() => void`
- Returns a function that forces a re-render when called.


### Side-effects & Async (17 hooks)

#### useAsync
- **Signature:** `useAsync<T>(fn: () => Promise<T>, deps?: DependencyList): AsyncState<T>`
- **Returns:** `{ loading: boolean, error?: Error, value?: T }`
- Wraps an async function, auto-executes on mount/deps change. Sets `loading: true` initially.
- **Usage:** `const { loading, error, value } = useAsync(() => fetchUser(id), [id])`

#### useAsyncFn
- **Signature:** `useAsyncFn<T>(fn: (...args) => Promise<T>, deps?: DependencyList): [AsyncState<T>, (...args) => T]`
- Like useAsync but returns `[state, execute]`. Does NOT auto-execute -- you control when to call the function.
- **Returns:** `[{ loading, error, value }, executeFunction]`

#### useAsyncRetry
- Extends useAsync with a `retry` function to re-execute.

#### useDebounce
- **Signature:** `useDebounce(fn: Function, ms: number, deps?: DependencyList): [isReady: () => boolean | null, cancel: () => void]`
- Debounces a function call. Resets the timer when deps change.

#### useThrottle
- **Signature:** `useThrottle(value: any, ms: number): any`
- Throttles a value to only update at most once per `ms`.

#### useThrottleFn
- **Signature:** `useThrottleFn(fn: Function, ms: number, deps?: DependencyList): [isReady, cancel, reset]`
- Throttles a function execution.

#### usePromise
- Resolves a promise only while component is mounted. Prevents setState on unmounted components.

#### useCopyToClipboard
- **Returns:** `[CopyToClipboardCopyState, copy]`
- Copies text to clipboard. Returns copy state and copy function.

#### useCookie
- **Signature:** `useCookie(name: string): [string | null, updateFn, deleteFn]`
- CRUD operations for a browser cookie via React state.

#### useLocalStorage
- **Signature:** `useLocalStorage(key: string, initialValue?: any): [value, setValue, remove]`
- Sync state to localStorage with cross-tab sync (storage event listener).

#### useSessionStorage
- Same as useLocalStorage but for sessionStorage.

#### useTitle
- **Signature:** `useTitle(title: string, options?: { restoreOnUnmount?: true })`
- Sets `document.title`. Optionally restores previous title on unmount.

#### useFavicon
- **Signature:** `useFavicon(url: string)`
- Dynamically sets the page favicon.

#### useLockBodyScroll
- **Signature:** `useLockBodyScroll(locked?: boolean)`
- Locks body scroll (useful for modals). Saves and restores `overflow` style.

#### useBeforeUnload
- **Signature:** `useBeforeUnload(enabled?: boolean, message?: string)`
- Shows browser confirmation when user tries to reload/close with unsaved changes.

#### useError
- Error dispatcher. Throws an error from a hook context.

#### usePermission
- **Signature:** `usePermission(name: PermissionName): PermissionState`
- Queries permission status for browser APIs (camera, microphone, geolocation, etc.).

#### useRafLoop (also listed under Animations)
- Calls a function in a RAF loop. Categorized under Side-effects in docs.


### Lifecycles (14 hooks)

#### useMount
- **Signature:** `useMount(fn: () => void)`
- Calls `fn` once after initial mount (equivalent to useEffect with [] deps). Throws if args change.

#### useUnmount
- **Signature:** `useUnmount(fn: () => void)`
- Calls `fn` on unmount.

#### useEffectOnce
- **Signature:** `useEffectOnce(effect: EffectCallback)`
- A useEffect that only runs once (on mount) and properly cleans up on unmount.

#### useLifecycles
- **Signature:** `useLifecycles(mount: () => void, unmount?: () => void)`
- Declarative mount/unmount callbacks.

#### useUpdateEffect
- **Signature:** `useUpdateEffect(effect: EffectCallback, deps: DependencyList)`
- Like useEffect but skips the first render (only runs on dependency updates).

#### useDeepCompareEffect
- **Signature:** `useDeepCompareEffect(effect: EffectCallback, deps: DependencyList)`
- useEffect with deep equality check on dependencies (uses lodash isEqual or equivalent).

#### useShallowCompareEffect
- Same as useDeepCompareEffect but with shallow comparison.

#### useCustomCompareEffect
- **Signature:** `useCustomCompareEffect(effect, deps, compareFn: (a, b) => boolean)`
- useEffect with a custom comparison function for dependencies.

#### useEvent
- **Signature:** `useEvent(name: string, handler: (...args) => void, target?: EventTarget, options?)`
- Subscribe to a DOM event. Cleans up automatically.

#### useMountedState
- **Returns:** `() => boolean`
- Returns a getter function that tells you if the component is still mounted.

#### useUnmountPromise
- Returns a `PromiseLike` wrapper that never updates state if component unmounted.

#### useLogger
- **Signature:** `useLogger(componentName: string, ...rest: any[])`
- Logs component lifecycle events (mount, update, unmount) to console.

#### useIsomorphicLayoutEffect
- useLayoutEffect that works in SSR environments (falls back to useEffect on server).

#### usePromise (also under Side-effects)
- Resolves a promise only while component is mounted.


### State (34 hooks)

#### useToggle
- **Signature:** `useToggle(initialValue: boolean): [boolean, (nextValue?: any) => void]`
- **Usage:** `const [on, toggle] = useToggle(false)`
- Calling `toggle()` flips. `toggle(true)` or `toggle(false)` sets explicitly.

#### useBoolean
- Alias for useToggle with semantic naming. `const [value, { toggle, setTrue, setFalse }] = useBoolean(false)`

#### useCounter
- **Signature:** `useCounter(initialValue?: number, max?: number | null, min?: number | null): CounterState`
- **Returns:** `{ count, inc, dec, get, set, reset }`
- Numeric counter with optional min/max bounds and step config.

#### useNumber
- Simplified counter. `const [num, { inc, dec, set, reset }] = useNumber(0)`

#### useList
- **Signature:** `useList<T>(initialList?: T[]): [T[], { set, push, filter, sort, updateAt, removeAt, clear, reset }]`
- Immutable-like array state with built-in mutation methods.

#### useMap
- **Signature:** `useMap<T>(initial?: { [key: string]: T }): [object, { set, setAll, get, has, delete: remove, reset }]`
- Tracks state of a plain object with immutability helpers.

#### useSet
- **Signature:** `useSet<T>(initial?: T[]): [Set<T>, { add, has, remove, reset, toggle }]`
- Tracks state of a JavaScript Set with immutability helpers.

#### useQueue
- **Signature:** `useQueue<T>(initial?: T[]): Queue<T>`
- **Returns:** `{ add, remove, first, last, size }`
- FIFO queue with helper methods.

#### usePrevious
- **Signature:** `usePrevious<T>(state: T): T | undefined`
- Returns the previous value of state/props.
- **Usage:** `const prevId = usePrevious(id); if (id !== prevId) { /* changed */ }`

#### usePreviousDistinct
- Like usePrevious but uses a predicate or comparison function to determine if the value truly changed.

#### useDefault
- **Signature:** `useDefault<T>(defaultValue: T, initialValue?: T): [T, Dispatch<T>]`
- Returns `defaultValue` when state is `null` or `undefined`.

#### useGetSet
- **Signature:** `useGetSet<T>(initial: T): [() => T, (value: T) => void]`
- Returns a getter function `get()` and setter, instead of the value directly.
- Avoids stale closure issues with getter.

#### useGetSetState
- Combines useGetSet and useSetState for a getter/setter pattern on object state.

#### useStateList
- **Signature:** `useStateList<T>(list: T[]): { state: T, prev, next, setStateAt, setState }`
- Circularly iterate over an array. `prev()` goes backward, `next()` goes forward.

#### useStateWithHistory
- **Signature:** `useStateWithHistory<T>(initialState): { value, backward, forward, go, reset }`
- Full undo/redo history with configurable capacity.

#### useSetState
- **Signature:** `useSetState<T extends object>(initial: T): [T, (patch: Partial<T>) => void]`
- Merges partial state updates like `this.setState` in class components.
- **Usage:** `const [state, setState] = useSetState({ a: 1, b: 2 }); setState({ a: 3 })`

#### useRafState
- **Signature:** `useRafState<T>(initialState: T): [T, Dispatch<SetStateAction<T>>]`
- Like useState but batched via RAF -- only updates once per animation frame.

#### useLatest
- **Signature:** `useLatest<T>(value: T): { current: T }`
- Returns a ref whose `.current` always holds the latest value. Avoids stale closures in callbacks.

#### useObservable
- Tracks the latest value from an Observable (RxJS or similar).

#### useStateValidator
- **Signature:** `useStateValidator<T>(state: T, validator: (state: T) => [boolean] | [boolean, string]): [FunctionReturningValidationResult]`
- Validates state on every render and returns validity status.

#### useMultiStateValidator
- Like useStateValidator but validates multiple states simultaneously.

#### useMediatedState
- **Signature:** `useMediatedState(mediator, initialState): [state, setState]`
- Passes every setState through a mediator/transformer function before updating.

#### useFirstMountState
- **Returns:** `boolean`
- Returns `true` if this is the first render of the component.

#### useRendersCount
- **Returns:** `number`
- Increments on every render. Tracks render count.

#### useMethods
- **Signature:** `useMethods(methods, initialState): [state, call]`
- Neat alternative to useReducer. `call('increment', 5)` instead of `dispatch({ type: 'increment', payload: 5 })`.

#### useUpsert
- **Signature:** `useUpsert<T>(predicate: (item: T) => boolean, initialList: T[])`
- Insert or update items in a list (upsert operation).

#### createMemo
- Factory for creating memoized hooks with custom comparator.

#### createReducer
- Factory for creating reducer hooks with custom middleware.

#### createReducerContext / createStateContext
- Factory hooks for sharing state between components via React Context.

#### createGlobalState
- **Signature:** `const useGlobalState = createGlobalState<T>(initialValue: T)`
- Cross-component shared state without Context Provider wrapping.

#### useEnsuredForwardedRef / ensuredForwardRef
- Safely use `React.forwardRef` with proper ref type handling.


## Total: 113 exported hooks
