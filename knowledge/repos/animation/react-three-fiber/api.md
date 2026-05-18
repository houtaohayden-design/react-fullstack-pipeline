# @react-three/fiber API Reference

> Declarative React renderer for Three.js — 30,832 stars, 4.4M+ weekly downloads

## Overview

react-three-fiber (R3F) is a React renderer for Three.js. It translates JSX into Three.js imperative calls:
`<mesh />` becomes `new THREE.Mesh()` automatically. Everything in Three.js works without exception.

```
npm install three @types/three @react-three/fiber
```

**Version pairing**: R3F@8 pairs with React 18, R3F@9 pairs with React 19.

## Installation & Setup

```tsx
import { createRoot } from 'react-dom/client'
import { Canvas } from '@react-three/fiber'

function App() {
  return (
    <Canvas>
      <ambientLight intensity={Math.PI / 2} />
      <mesh>
        <boxGeometry args={[1, 1, 1]} />
        <meshStandardMaterial color="orange" />
      </mesh>
    </Canvas>
  )
}

createRoot(document.getElementById('root')!).render(<App />)
```

## Canvas Component

The `Canvas` is the entry point. It creates:
- A `<div>` wrapper (100% width/height, `position: relative`, `overflow: hidden`)
- An internal `<canvas>` element
- A Three.js `WebGLRenderer`, default `PerspectiveCamera`, default `Scene`
- A Zustand store for shared state
- The render loop (requestAnimationFrame-based)

### Canvas Props

```tsx
interface CanvasProps {
  children?: React.ReactNode
  ref?: React.Ref<HTMLCanvasElement>
  /** Fallback content inside <canvas> (like alt text) */
  fallback?: React.ReactNode
  /** useMeasure resize options */
  resize?: ResizeOptions
  /** DOM element that receives pointer events (default: wrapper div) */
  eventSource?: HTMLElement | React.RefObject<HTMLElement>
  /** Coordinate system for pointer events: "offset" | "client" | "page" | "layer" | "screen" */
  eventPrefix?: 'offset' | 'client' | 'page' | 'layer' | 'screen'

  // Renderer configuration
  /** Three.js renderer instance or constructor props */
  gl?: GLProps
  /** Shadow map config: boolean | 'basic' | 'percentage' | 'soft' | 'variance' | Partial<WebGLShadowMap> */
  shadows?: boolean | 'basic' | 'percentage' | 'soft' | 'variance' | Partial<THREE.WebGLShadowMap>
  /** Disable r139+ color management */
  legacy?: boolean
  /** Use LinearSRGBColorSpace output (no automatic sRGB encoding) */
  linear?: boolean
  /** Use NoToneMapping instead of ACESFilmicToneMapping */
  flat?: boolean
  /** Create OrthographicCamera instead of PerspectiveCamera */
  orthographic?: boolean
  /** Render mode: 'always' | 'demand' | 'never' */
  frameloop?: 'always' | 'demand' | 'never'
  /** Adaptive performance config */
  performance?: Partial<Omit<Performance, 'regress'>>
  /** Device pixel ratio, can clamp via tuple: [min, max] */
  dpr?: number | [min: number, max: number]
  /** Raycaster config */
  raycaster?: Partial<THREE.Raycaster>
  /** Custom Scene instance or props */
  scene?: THREE.Scene | Partial<THREE.Scene>
  /** Custom Camera instance or props */
  camera?: CameraProps
  /** Custom event manager factory */
  events?: (store: RootStore) => EventManager<HTMLElement>
  /** Called after canvas initializes (before first render commits) */
  onCreated?: (state: RootState) => void
  /** Called when a click misses all 3D objects */
  onPointerMissed?: (event: MouseEvent) => void
}
```

### Default Renderer Settings

```
powerPreference: 'high-performance'
antialias: true
alpha: true
toneMapping: THREE.ACESFilmicToneMapping
outputColorSpace: THREE.SRGBColorSpace
```

### Render Mode: frameloop

| Value | Behavior |
|-------|----------|
| `'always'` | Continuous render loop (default) |
| `'demand'` | Render only on state change or manual `invalidate()` |
| `'never'` | No automatic rendering — manual `advance(timestamp)` required |

```tsx
<Canvas frameloop="demand" />
```

## Core Hooks

### useFrame

Subscribes a callback to the render loop. Called every frame with `(state, delta, frame?)`.

```tsx
import { useFrame } from '@react-three/fiber'

function RotatingBox() {
  const meshRef = useRef<THREE.Mesh>(null!)

  useFrame((state, delta) => {
    meshRef.current.rotation.x += delta * 0.5
    meshRef.current.rotation.y += delta * 0.3
  })

  return (
    <mesh ref={meshRef}>
      <boxGeometry args={[1, 1, 1]} />
      <meshStandardMaterial color="hotpink" />
    </mesh>
  )
}
```

**renderPriority**: Higher priority callbacks run later (on top). Use positive priority to take control of when rendering happens:

```tsx
useFrame((state, delta) => {
  // This runs before the scene renders with priority 0
}, 0)

useFrame((state, delta) => {
  // This runs after, can do post-render work
}, 1)
```

**Manual rendering with useFrame+**: When any subscriber has priority > 0, automatic rendering is suppressed. You must call `gl.render(scene, camera)` yourself. This is used by post-processing passes.

### useThree

Accesses the R3F internal state with optional Zustand selector.

```tsx
import { useThree } from '@react-three/fiber'

function CameraInfo() {
  const camera = useThree((state) => state.camera)
  const size = useThree((state) => state.size)
  const viewport = useThree((state) => state.viewport)
  const gl = useThree((state) => state.gl)

  // Or get everything
  const state = useThree()

  console.log('Canvas size:', size.width, 'x', size.height)
  console.log('Viewport width:', viewport.width, 'factor:', viewport.factor)
  console.log('Camera position:', camera.position)

  return null
}
```

### useLoader

Suspense-based asset loader. Wraps Three.js loaders with React Suspense and caching via `suspend-react`.

```tsx
import { useLoader } from '@react-three/fiber'
import { TextureLoader } from 'three'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js'

function TexturedMesh() {
  // Load a texture — component must be wrapped in <Suspense>
  const texture = useLoader(TextureLoader, '/textures/diffuse.jpg')

  return (
    <mesh>
      <planeGeometry args={[2, 2]} />
      <meshStandardMaterial map={texture} />
    </mesh>
  )
}

function Model() {
  // GLTF loader — automatically builds graph for useGraph
  const gltf = useLoader(GLTFLoader, '/models/scene.glb')

  return <primitive object={gltf.scene} />
}

// With extensions (e.g., Draco)
useLoader(GLTFLoader, '/model.glb', (loader) => {
  const dracoLoader = new DRACOLoader()
  dracoLoader.setDecoderPath('/draco/')
  loader.setDRACOLoader(dracoLoader)
})

// Preload
useLoader.preload(TextureLoader, '/textures/bg.jpg')

// Clear cache
useLoader.clear(TextureLoader, '/textures/bg.jpg')
```

**useLoader return typing**: For GLTF loaders, the result is `GLTF & ObjectMap` (augmented with graph). For single inputs returns the result directly; for array inputs returns an array.

### useGraph

Builds a node/materials map from an Object3D (useful with glTF models).

```tsx
import { useGraph } from '@react-three/fiber'

function Model({ url }: { url: string }) {
  const gltf = useLoader(GLTFLoader, url)
  const { nodes, materials } = useGraph(gltf.scene)

  // Access named mesh nodes and materials from the GLTF
  return (
    <group>
      <mesh geometry={nodes.Chassis.geometry} material={materials.Metal} />
      <mesh geometry={nodes.Wheel_L.geometry} material={materials.Rubber} />
    </group>
  )
}
```

### useStore

Direct access to the Zustand store for transient updates.

```tsx
import { useStore } from '@react-three/fiber'

function Controls() {
  const store = useStore()

  const resetCamera = () => {
    store.getState().camera.position.set(0, 0, 5)
    store.getState().invalidate()
  }

  return <button onClick={resetCamera}>Reset Camera</button>
}
```

### useInstanceHandle

Escape hatch to access the internal R3F Instance from a ref.

```tsx
const meshRef = useRef<THREE.Mesh>(null!)
const instance = useInstanceHandle(meshRef)
// instance.current.root, instance.current.props, instance.current.handlers
```

## Events System

R3F translates DOM pointer events into Three.js raycasting-based events. All Three.js Object3D elements support pointer event handlers.

### Supported Event Handlers

```tsx
interface EventHandlers {
  onClick?: (event: ThreeEvent<MouseEvent>) => void
  onContextMenu?: (event: ThreeEvent<MouseEvent>) => void
  onDoubleClick?: (event: ThreeEvent<MouseEvent>) => void
  onPointerUp?: (event: ThreeEvent<PointerEvent>) => void
  onPointerDown?: (event: ThreeEvent<PointerEvent>) => void
  onPointerOver?: (event: ThreeEvent<PointerEvent>) => void
  onPointerOut?: (event: ThreeEvent<PointerEvent>) => void
  onPointerEnter?: (event: ThreeEvent<PointerEvent>) => void
  onPointerLeave?: (event: ThreeEvent<PointerEvent>) => void
  onPointerMove?: (event: ThreeEvent<PointerEvent>) => void
  onPointerMissed?: (event: MouseEvent) => void  // on Canvas, not on mesh
  onPointerCancel?: (event: ThreeEvent<PointerEvent>) => void
  onWheel?: (event: ThreeEvent<WheelEvent>) => void
  onLostPointerCapture?: (event: ThreeEvent<PointerEvent>) => void
}
```

### ThreeEvent Shape

```tsx
interface ThreeEvent<TSourceEvent> {
  // Three.js intersection data
  object: THREE.Object3D
  eventObject: THREE.Object3D   // the object with the handler
  distance: number
  point: THREE.Vector3
  face: THREE.Face | null
  faceIndex: number
  uv: THREE.Vector2
  intersections: Intersection[]
  // Camera/ray data
  pointer: THREE.Vector2       // normalized [-1,1] coordinates
  unprojectedPoint: THREE.Vector3
  ray: THREE.Ray
  camera: THREE.Camera
  // Interaction state
  delta: number               // pointer movement distance
  stopPropagation: () => void
  stopped: boolean
  nativeEvent: TSourceEvent
  // Pointer capture
  target: { hasPointerCapture, setPointerCapture, releasePointerCapture }
}
```

### Event Propagation

Events bubble up the Three.js scene graph, following Object3D parent-child relationships — just like DOM events. `stopPropagation()` prevents handlers higher in the tree from firing.

```tsx
<group onClick={() => console.log('group clicked')}>
  <mesh
    onClick={(e) => {
      e.stopPropagation()  // Stops the group handler from firing
      console.log('mesh clicked')
    }}>
    <boxGeometry />
    <meshStandardMaterial />
  </mesh>
</group>
```

### Event Layers

Multiple event managers can be stacked with different priorities. Higher priority layers handle events first and can stop propagation.

```tsx
// Custom event filter — re-order intersections
<Canvas
  events={(store) => ({
    priority: 1,
    enabled: true,
    filter: (items, state) => items.sort((a, b) => a.distance - b.distance),
  })}
/>
```

### Custom Compute Function

Change how pointer coordinates map to 3D:

```tsx
<Canvas
  eventPrefix="client"
  events={(store) => ({
    priority: 1,
    enabled: true,
    compute: (event, state) => {
      // Use clientX/clientY instead of offsetX/offsetY
      state.pointer.set(
        ((event as PointerEvent).clientX / window.innerWidth) * 2 - 1,
        -((event as PointerEvent).clientY / window.innerHeight) * 2 + 1
      )
      state.raycaster.setFromCamera(state.pointer, state.camera)
    },
  })}
/>
```

## Additional Exports

### Global Render Callbacks

```tsx
import { addEffect, addAfterEffect, addTail } from '@react-three/fiber'

// Before each frame
addEffect((timestamp) => { /* ... */ })

// After each frame (after gl.render)
addAfterEffect((timestamp) => { /* ... */ })

// When rendering stops
addTail((timestamp) => { /* ... */ })
```

### Invalidate & Advance

```tsx
import { invalidate, advance } from '@react-three/fiber'

// Request a re-render (calling state.invalidate() is the safer scoped variant)
invalidate()

// Manual frame advance for frameloop="never"
advance(performance.now())
```

### createRoot (Advanced)

For manual setup without the Canvas component:

```tsx
import { createRoot } from '@react-three/fiber'

const canvas = document.getElementById('canvas') as HTMLCanvasElement
const root = createRoot(canvas)

await root.configure({
  shadows: true,
  dpr: [1, 2],
  camera: { position: [0, 0, 10], fov: 50 },
})

root.render(
  <ambientLight intensity={0.5} />
  <mesh>...</mesh>
)

// Cleanup
root.unmount()
```

### createPortal

Render into a sub-scene (e.g., for portals in games, or multi-view scenes):

```tsx
import { createPortal } from '@react-three/fiber'

function PortalScene() {
  const viewport = useThree((s) => s.viewport)

  return createPortal(
    <mesh>
      <boxGeometry />
      <meshStandardMaterial color="red" />
    </mesh>,
    new THREE.Scene(),  // Different scene
    { size: { width: viewport.width / 2, height: viewport.height / 2 } },
  )
}
```

### flushSync

Force React to flush updates synchronously within the canvas root:

```tsx
import { flushSync } from '@react-three/fiber'

// Keep DOM and 3D changes in lock-step
flushSync(() => {
  setPosition([x, y, z])
})
```

### extend

Register custom Three.js objects or third-party classes for declarative use:

```tsx
import { extend } from '@react-three/fiber'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'

extend({ OrbitControls })

// Now usable as JSX
<orbitControls args={[camera, gl.domElement]} />
```

### events (default pointer events)

```tsx
import { events } from '@react-three/fiber'

<Canvas events={events} />  // Equivalent to default behavior
```

## RootState Shape

```tsx
interface RootState {
  gl: THREE.WebGLRenderer
  camera: THREE.Camera
  scene: THREE.Scene
  raycaster: THREE.Raycaster
  clock: THREE.Clock
  events: EventManager<any>
  xr: XRManager
  controls: THREE.EventDispatcher | null
  pointer: THREE.Vector2
  frameloop: 'always' | 'demand' | 'never'
  performance: Performance
  size: Size
  viewport: Viewport & { getCurrentViewport(...) }
  // Imperative methods
  invalidate: (frames?: number) => void
  advance: (timestamp: number, runGlobalEffects?: boolean) => void
  setEvents: (events: Partial<EventManager>) => void
  setSize: (width: number, height: number, top?: number, left?: number) => void
  setDpr: (dpr: number | [number, number]) => void
  setFrameloop: (frameloop: 'always' | 'demand' | 'never') => void
  previousRoot?: RootStore
  internal: InternalState
}

interface Size {
  width: number; height: number; top: number; left: number
}

interface Viewport {
  width: number; height: number; top: number; left: number
  initialDpr: number; dpr: number
  factor: number; distance: number; aspect: number
}
```

## Performance API

```tsx
interface Performance {
  current: number    // Between min and max
  min: number        // Low bound (default 0.5)
  max: number        // High bound (default 1)
  debounce: number   // ms to recover to max (default 200)
  regress: () => void  // Set to min temporarily
}

// Configure
<Canvas performance={{ min: 0.3, max: 1, debounce: 300 }} />

// Use in components
const { regress } = useThree((s) => s.performance)
// Call regress() when performance drops (e.g., during drag)
```

## TypeScript Support

```tsx
import { ThreeElements } from '@react-three/fiber'

// All Three.js elements are typed
type MeshProps = ThreeElements['mesh']
type GroupProps = ThreeElements['group']

function MyBox(props: ThreeElements['mesh']) {
  return (
    <mesh {...props}>
      <boxGeometry args={[1, 1, 1]} />
      <meshStandardMaterial color="hotpink" />
    </mesh>
  )
}
```

## React Native

Import from the native entry point:

```tsx
import { Canvas, useFrame } from '@react-three/fiber/native'
```

Configure Metro for asset loading:

```js
// metro.config.js
module.exports = {
  resolver: {
    sourceExts: ['js', 'jsx', 'json', 'ts', 'tsx', 'cjs'],
    assetExts: ['glb', 'png', 'jpg'],
  },
}
```

## Key Architecture Notes

1. **No overhead**: Components render outside of React's DOM cycle. R3F uses React's reconciler to build the Three.js scene graph, then renders natively via requestAnimationFrame.
2. **Everything is dynamic**: `<mesh />` maps to `new THREE.Mesh()`. New Three.js features are available immediately without R3F updates.
3. **Zustand store**: R3F uses Zustand internally for state management. Every Canvas gets its own store.
4. **Sub-tree rendering**: Only changed props are applied — R3F diffs props and applies only what changed.
5. **Dispose on unmount**: Objects are automatically disposed when removed from the tree (unless `dispose={null}`).
6. **attach prop**: Control how objects attach to parents — `attach="material"` on a shader attaches it as the parent mesh's material.
