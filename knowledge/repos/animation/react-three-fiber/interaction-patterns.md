# @react-three/fiber Interaction Patterns

> 3D interaction design — pointer events, camera controls, gestures, physics, and loading states

## 1. Pointer Events & Raycasting

R3F provides DOM-like pointer events on any Three.js Object3D using GPU raycasting behind the scenes.

### The Pointer Event Lifecycle

```
pointerdown -> pointermove (hover) -> pointerup -> click
              |-> pointerover/enter
              |-> pointerout/leave
```

### Basic Click + Hover

```tsx
function InteractiveSphere() {
  const [isHovered, setIsHovered] = useState(false)
  const [isActive, setIsActive] = useState(false)

  return (
    <mesh
      onClick={() => setIsActive(!isActive)}
      onPointerOver={() => setIsHovered(true)}
      onPointerOut={() => setIsHovered(false)}
      scale={isActive ? 1.5 : 1}
    >
      <sphereGeometry args={[1, 32, 32]} />
      <meshStandardMaterial
        color={isHovered ? 'hotpink' : (isActive ? '#a855f7' : '#6366f1')}
        roughness={0.2}
        emissive={isHovered ? '#ff6080' : '#000000'}
        emissiveIntensity={0.3}
      />
    </mesh>
  )
}
```

### Pointer Capture

Prevent events from firing on other objects during drag:

```tsx
function DraggableMesh() {
  const meshRef = useRef<THREE.Mesh>(null!)

  const handlePointerDown = useCallback((e: ThreeEvent<PointerEvent>) => {
    e.stopPropagation()
    // Capture this pointer — only this object receives events until released
    ;(e.target as any).setPointerCapture(e.pointerId)
  }, [])

  const handlePointerUp = useCallback((e: ThreeEvent<PointerEvent>) => {
    ;(e.target as any).releasePointerCapture(e.pointerId)
  }, [])

  return (
    <mesh
      ref={meshRef}
      onPointerDown={handlePointerDown}
      onPointerUp={handlePointerUp}
      onPointerMove={(e) => {
        // Only fires if pointer is captured
        console.log('dragging...', e.point)
      }}
    >
      <boxGeometry />
      <meshStandardMaterial color="orange" />
    </mesh>
  )
}
```

### Event Bubbling & stopPropagation

Events bubble up the Three.js scene graph (parent-child hierarchy), mirroring DOM events:

```tsx
<group
  onClick={(e) => {
    console.log('group clicked at', e.point)
  }}
>
  <mesh
    onClick={(e) => {
      e.stopPropagation()  // Group handler won't fire
      console.log('mesh clicked — propagation stopped')
    }}
  >
    <boxGeometry />
    <meshStandardMaterial color="hotpink" />
  </mesh>
</group>
```

### onPointerMissed (Canvas-level)

Handle clicks that miss all 3D objects (useful for deselect):

```tsx
<Canvas onPointerMissed={() => {
  // User clicked on empty space
  setSelectedObject(null)
  deselectAll()
}}>
```

### Custom Raycaster Configuration

```tsx
<Canvas
  raycaster={{
    // Only intersect objects within this range
    near: 0.1,
    far: 50,
    // Use different raycasting strategy
    params: {
      Points: { threshold: 0.1 },
      Line: { threshold: 0.1 },
    },
  }}
>
```

## 2. Drag & Orbit Controls

### OrbitControls (via drei)

The standard camera control for product views and architectural scenes:

```tsx
import { OrbitControls } from '@react-three/drei'

function Scene() {
  return (
    <Canvas camera={{ position: [3, 3, 3] }}>
      <OrbitControls
        enableDamping={true}
        dampingFactor={0.05}
        minDistance={2}
        maxDistance={10}
        maxPolarAngle={Math.PI / 2}  // Prevent going below ground
        autoRotate
        autoRotateSpeed={0.5}
      />
      {/* Scene content */}
    </Canvas>
  )
}
```

### Drag Objects in 3D (via drei DragControls)

```tsx
import { DragControls } from '@react-three/drei'

function DragScene() {
  const [dragging, setDragging] = useState(false)

  return (
    <DragControls
      onDragStart={() => setDragging(true)}
      onDragEnd={() => setDragging(false)}
      autoTransform  // Objects move with the pointer plane
    >
      <mesh>
        <boxGeometry />
        <meshStandardMaterial color={dragging ? 'hotpink' : 'orange'} />
      </mesh>
    </DragControls>
  )
}
```

### Manual Drag Implementation

```tsx
function ManualDragBox() {
  const meshRef = useRef<THREE.Mesh>(null!)
  const dragPlaneRef = useRef(new THREE.Plane(new THREE.Vector3(0, 0, 1), 0))
  const intersectionRef = useRef(new THREE.Vector3())
  const offsetRef = useRef(new THREE.Vector3())
  const [isDragging, setIsDragging] = useState(false)

  const handlePointerDown = useCallback((e: ThreeEvent<PointerEvent>) => {
    e.stopPropagation()
    setIsDragging(true)
    // Calculate offset between object center and hit point
    offsetRef.current.copy(e.point).sub(meshRef.current.position)
  }, [])

  const handlePointerMove = useCallback((e: ThreeEvent<PointerEvent>) => {
    if (!isDragging) return
    // Move object to pointer position minus offset (keeps relative position)
    meshRef.current.position.copy(e.point).sub(offsetRef.current)
  }, [isDragging])

  const handlePointerUp = useCallback(() => {
    setIsDragging(false)
  }, [])

  return (
    <mesh
      ref={meshRef}
      onPointerDown={handlePointerDown}
      onPointerMove={handlePointerMove}
      onPointerUp={handlePointerUp}
      onPointerLeave={handlePointerUp}
    >
      <boxGeometry args={[1, 1, 1]} />
      <meshStandardMaterial
        color={isDragging ? '#a855f7' : '#6366f1'}
      />
    </mesh>
  )
}
```

### Restrict Drag to Plane

```tsx
// Use the ThreeEvent's ray to intersect a plane
const dragPlane = useRef(new THREE.Plane(new THREE.Vector3(0, 1, 0), 0))
const intersection = useRef(new THREE.Vector3())

const handlePointerMove = (e: ThreeEvent<PointerEvent>) => {
  // Cast ray against a horizontal plane at y=0
  e.ray.intersectPlane(dragPlane.current, intersection.current)
  meshRef.current.position.copy(intersection.current)
}
```

## 3. Scroll-Driven 3D Animation

### Page Scroll to 3D Rotation

```tsx
function ScrollDrivenScene() {
  const groupRef = useRef<THREE.Group>(null!)

  useFrame(() => {
    const scrollY = window.scrollY
    const maxScroll = document.body.scrollHeight - window.innerHeight
    const progress = Math.min(scrollY / maxScroll, 1)

    groupRef.current.rotation.y = progress * Math.PI * 2
  })

  return <group ref={groupRef}>...</group>
}
```

### Fixed Canvas with Scrolling Page

```tsx
function App() {
  return (
    <>
      {/* Fixed 3D canvas behind scrollable content */}
      <div style={{ position: 'fixed', inset: 0, zIndex: 0 }}>
        <Canvas>
          <ScrollScene />
        </Canvas>
      </div>

      {/* Scrollable HTML content */}
      <div style={{ position: 'relative', zIndex: 1, height: '300vh' }}>
        <section style={{ height: '100vh' }}>Section 1</section>
        <section style={{ height: '100vh' }}>Section 2</section>
        <section style={{ height: '100vh' }}>Section 3</section>
      </div>
    </>
  )
}
```

### ScrollTrigger with GSAP + R3F

```tsx
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
gsap.registerPlugin(ScrollTrigger)

function AnimatedModel() {
  const meshRef = useRef<THREE.Mesh>(null!)

  useEffect(() => {
    const ctx = gsap.context(() => {
      ScrollTrigger.create({
        trigger: '#trigger-section',
        start: 'top center',
        end: 'bottom center',
        scrub: true,
        onUpdate: (self) => {
          meshRef.current.rotation.y = self.progress * Math.PI * 2
          meshRef.current.position.z = self.progress * 5
        },
      })
    })

    return () => ctx.revert()
  }, [])

  return (
    <mesh ref={meshRef}>
      <torusKnotGeometry args={[1, 0.3, 100, 16]} />
      <meshStandardMaterial color="#6366f1" roughness={0.1} metalness={0.8} />
    </mesh>
  )
}
```

## 4. Camera Transitions & Animations

### Smooth Camera Transition with lerp

```tsx
function SmoothCameraController({
  target,
}: {
  target: THREE.Vector3 | [number, number, number]
}) {
  useFrame(({ camera }, delta) => {
    const targetVec = Array.isArray(target)
      ? new THREE.Vector3(...target)
      : target

    camera.position.lerp(targetVec, delta * 2)
    camera.lookAt(0, 0, 0)
  })

  return null
}
```

### Camera Animation with GSAP

```tsx
function CameraAnimator() {
  const { camera } = useThree()

  const animateTo = useCallback((position: [number, number, number]) => {
    gsap.to(camera.position, {
      x: position[0],
      y: position[1],
      z: position[2],
      duration: 2,
      ease: 'power2.inOut',
      onUpdate: () => camera.lookAt(0, 0, 0),
    })
  }, [camera])

  return (
    <group>
      <mesh onClick={() => animateTo([5, 2, 5])} position={[1, 0, 0]}>
        <sphereGeometry args={[0.3]} />
        <meshBasicMaterial color="red" />
      </mesh>
      <mesh onClick={() => animateTo([0, 5, 0])} position={[0, 0, 1]}>
        <sphereGeometry args={[0.3]} />
        <meshBasicMaterial color="green" />
      </mesh>
    </group>
  )
}
```

### Camera Rig Pattern

```tsx
function CameraRig({ children }: { children: React.ReactNode }) {
  const rigRef = useRef<THREE.Group>(null!)
  const { camera } = useThree()

  useFrame(() => {
    // Camera follows the rig
    const rigPos = rigRef.current.position
    camera.position.lerp(
      new THREE.Vector3(rigPos.x + 3, rigPos.y + 2, rigPos.z + 5),
      0.05
    )
    camera.lookAt(rigPos)
  })

  return <group ref={rigRef}>{children}</group>
}
```

### Multi-View Camera Switching

```tsx
function CameraSwitcher() {
  const { camera, size } = useThree()

  const views = {
    front: { position: [0, 0, 5], target: [0, 0, 0] },
    top: { position: [0, 5, 0], target: [0, 0, 0] },
    side: { position: [5, 0, 0], target: [0, 0, 0] },
    iso: { position: [3, 3, 3], target: [0, 0, 0] },
  }

  const switchView = (view: keyof typeof views) => {
    const { position, target } = views[view]
    camera.position.set(...position)
    camera.lookAt(...target)
  }

  return null
}
```

## 5. Gesture Handling in 3D

### Pinch-to-Zoom (via use-gesture)

```tsx
import { usePinch } from '@use-gesture/react'

function ZoomableScene() {
  const { camera } = useThree()

  usePinch(
    ({ offset: [scale] }) => {
      // Map pinch scale to camera zoom
      camera.zoom = Math.max(0.5, Math.min(3, scale))
      camera.updateProjectionMatrix()
    },
    { target: typeof window !== 'undefined' ? window : undefined },
  )

  return null
}
```

### Combined Gestures (Drag + Pinch + Wheel)

```tsx
import { useGesture } from '@use-gesture/react'

function GestureCamera() {
  const { camera } = useThree()
  const pos = useRef({ x: 0, y: 0 })

  useGesture(
    {
      onDrag: ({ offset: [x, y] }) => {
        camera.position.x = pos.current.x + x * 0.01
        camera.position.y = pos.current.y - y * 0.01
      },
      onPinch: ({ offset: [d] }) => {
        camera.zoom = Math.max(0.5, Math.min(3, d))
        camera.updateProjectionMatrix()
      },
      onWheel: ({ delta: [, dy] }) => {
        camera.position.z = Math.max(1, Math.min(20, camera.position.z + dy * 0.01))
      },
    },
    { target: typeof window !== 'undefined' ? window : undefined },
  )

  return null
}
```

### Touch-Specific Optimizations

```tsx
// Increase raycaster threshold for touch inputs
<Canvas
  raycaster={{
    params: {
      Mesh: {},
      Line: { threshold: 0.1 },
      Points: { threshold: 0.05 },
    },
  }}
/>
```

## 6. Physics-Based Interactions

### With @react-three/rapier

```tsx
import { RigidBody, CuboidCollider } from '@react-three/rapier'

function PhysicsScene() {
  return (
    <Physics debug>
      {/* Static ground */}
      <RigidBody type="fixed">
        <mesh receiveShadow position={[0, -2, 0]} rotation={[-Math.PI / 2, 0, 0]}>
          <planeGeometry args={[20, 20]} />
          <meshStandardMaterial color="#f0f0f0" />
        </mesh>
      </RigidBody>

      {/* Dynamic falling objects */}
      {Array.from({ length: 10 }).map((_, i) => (
        <RigidBody key={i} position={[(i - 5) * 0.8, 5 + i * 0.1, 0]}>
          <mesh castShadow>
            <boxGeometry args={[0.5, 0.5, 0.5]} />
            <meshStandardMaterial color={`hsl(${i * 36}, 80%, 60%)`} />
          </mesh>
        </RigidBody>
      ))}
    </Physics>
  )
}
```

### Physics-Driven Animation

```tsx
function PhysicsButton() {
  const rigidBodyRef = useRef<RigidBody>(null!)

  const handleClick = () => {
    // Apply impulse on click
    rigidBodyRef.current.applyImpulse({ x: 0, y: 5, z: 0 }, true)
  }

  return (
    <RigidBody ref={rigidBodyRef}>
      <mesh onClick={handleClick}>
        <boxGeometry />
        <meshStandardMaterial color="hotpink" />
      </mesh>
    </RigidBody>
  )
}
```

## 7. Loading States for 3D Assets

### Suspense Fallback Components

```tsx
function LoadingFallback() {
  return (
    <mesh>
      <sphereGeometry args={[1, 16, 16]} />
      <meshBasicMaterial color="#6366f1" wireframe />
    </mesh>
  )
}

function Scene() {
  return (
    <Canvas>
      <Suspense fallback={<LoadingFallback />}>
        <Model url="/models/heavy.glb" />
      </Suspense>
    </Canvas>
  )
}
```

### Animated Loading Indicator

```tsx
function AnimatedLoadingIndicator() {
  const ringRef = useRef<THREE.Mesh>(null!)
  const ring2Ref = useRef<THREE.Mesh>(null!)

  useFrame(({ clock }) => {
    const t = clock.getElapsedTime()
    ringRef.current.rotation.z = t * 1.5
    ring2Ref.current.rotation.z = -t * 2
    const s = 1 + Math.sin(t * 3) * 0.1
    ringRef.current.scale.setScalar(s)
  })

  return (
    <group>
      <mesh ref={ringRef}>
        <torusGeometry args={[1, 0.05, 16, 64]} />
        <meshBasicMaterial color="#6366f1" />
      </mesh>
      <mesh ref={ring2Ref}>
        <torusGeometry args={[0.7, 0.05, 16, 64]} />
        <meshBasicMaterial color="#a855f7" />
      </mesh>
    </group>
  )
}
```

### Progressive Loading with Placeholder

```tsx
function ProgressiveModel({ url }: { url: string }) {
  const [progress, setProgress] = useState(0)
  const gltf = useLoader(GLTFLoader, url, undefined, (event) => {
    if (event.total > 0) {
      setProgress((event.loaded / event.total) * 100)
    }
  })

  if (progress < 100) {
    return (
      <group>
        <mesh>
          <boxGeometry args={[1, 1, 1]} />
          <meshBasicMaterial color={`hsl(${progress * 3}, 80%, ${30 + progress * 0.3}%)`} />
        </mesh>
        {/* Progress value displayed via drei Html */}
        <Html center>
          <div style={{ color: 'white', fontFamily: 'monospace' }}>
            {Math.round(progress)}%
          </div>
        </Html>
      </group>
    )
  }

  return <primitive object={gltf.scene} />
}
```

### Multiple Suspense Boundaries

```tsx
function Scene() {
  return (
    <Canvas>
      {/* Environment loads first */}
      <Suspense fallback={<LoadingRing />}>
        <Environment preset="city" />
      </Suspense>

      {/* Main model loads after */}
      <Suspense fallback={<LoadingBox />}>
        <Model url="/models/main.glb" />
      </Suspense>

      {/* Background elements are independent */}
      <Suspense fallback={null}>
        <Particles />
      </Suspense>
    </Canvas>
  )
}
```

### Error Boundaries for Loading Failures

```tsx
class ModelErrorBoundary extends React.Component<
  { children: React.ReactNode; fallback: React.ReactNode },
  { hasError: boolean }
> {
  constructor(props) {
    super(props)
    this.state = { hasError: false }
  }

  static getDerivedStateFromError() {
    return { hasError: true }
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback
    }
    return this.props.children
  }
}
```

## 8. Error Boundaries for WebGL Failures

### Canvas-Level Error Handling

The Canvas component wraps children in an ErrorBoundary internally. Any error thrown within the Canvas is caught and surfaced:

```tsx
function SafeCanvas() {
  const [error, setError] = useState<Error | null>(null)

  if (error) {
    return (
      <div className="webgl-error">
        <h2>Unable to initialize 3D</h2>
        <p>{error.message}</p>
        <p>Please ensure WebGL is enabled in your browser.</p>
      </div>
    )
  }

  return (
    <ErrorBoundary onError={setError}>
      <Canvas>
        <Scene />
      </Canvas>
    </ErrorBoundary>
  )
}
```

### WebGL Context Loss Handling

```tsx
function WebGLContextHandler() {
  const { gl } = useThree()

  useEffect(() => {
    const handleContextLost = (event: Event) => {
      event.preventDefault()
      console.warn('WebGL context lost — pausing render')
    }

    const handleContextRestored = () => {
      console.log('WebGL context restored — resuming')
    }

    gl.domElement.addEventListener('webglcontextlost', handleContextLost)
    gl.domElement.addEventListener('webglcontextrestored', handleContextRestored)

    return () => {
      gl.domElement.removeEventListener('webglcontextlost', handleContextLost)
      gl.domElement.removeEventListener('webglcontextrestored', handleContextRestored)
    }
  }, [gl])

  return null
}
```

### Fallback Rendering

```tsx
function App() {
  const supported = useMemo(() => {
    try {
      const canvas = document.createElement('canvas')
      return !!(
        canvas.getContext('webgl2') || canvas.getContext('webgl')
      )
    } catch {
      return false
    }
  }, [])

  if (!supported) {
    return <WebGLNotSupportedFallback />
  }

  return (
    <Canvas fallback={<WebGLFallbackUI />}>
      <Scene />
    </Canvas>
  )
}
```

## 9. Multiple Event Layers

Advanced scenes can use layered event systems with different priorities:

```tsx
// Custom event layer with lower priority (handles after default)
<group
  onClick={(e) => {
    // This fires after any higher-priority layer handlers
  }}
>
  <mesh>
    <boxGeometry />
    <meshStandardMaterial />
  </mesh>
</group>

// Using createPortal with custom events
createPortal(
  <UIElements />,
  overlayScene,
  {
    events: {
      priority: 2,  // Higher than scene default (1)
      enabled: true,
    },
  },
)
```

## 10. Interaction Performance

### Throttle Pointer Events on Complex Objects

```tsx
function OptimizedPointerHandler() {
  const lastCall = useRef(0)

  const onPointerMove = useCallback((e: ThreeEvent<PointerEvent>) => {
    const now = performance.now()
    if (now - lastCall.current < 16) return  // ~60fps throttle
    lastCall.current = now
    // Handle move...
  }, [])

  return <mesh onPointerMove={onPointerMove}>...</mesh>
}
```

### Reduce Raycaster Targets

Only objects with pointer event handlers are raycasted against. Keep handler-bearing objects minimal:

```tsx
// BAD: Every leaf mesh gets handlers (increases raycast set)
meshes.map(m => <mesh onPointerOver={...} />)

// GOOD: Group overlapping objects, put handlers only where needed
<group onPointerOver={handleGroupHover}>
  {meshes.map(m => <mesh />)}
</group>
```
