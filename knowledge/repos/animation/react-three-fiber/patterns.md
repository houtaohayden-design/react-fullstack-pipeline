# @react-three/fiber Patterns

> Battle-tested 3D patterns for building production scenes with R3F and the pmndrs ecosystem

## 1. Scene Composition

The fundamental R3F scene tree follows a predictable pattern: Canvas sets up the renderer, lights illuminate, meshes render geometry with materials.

### Basic Scene Architecture

```
Canvas
  ambientLight          ← base illumination
  directionalLight      ← key light + shadows
  group                 ← logical grouping
    mesh                ← individual object
      geometry          ← shape (boxGeometry, sphereGeometry, ...)
      material          ← appearance (meshStandardMaterial, ...)
```

```tsx
<Canvas shadows camera={{ position: [3, 3, 3], fov: 50 }}>
  {/* Lighting */}
  <ambientLight intensity={0.3} />
  <directionalLight
    position={[5, 5, 5]}
    intensity={1}
    castShadow
    shadow-mapSize-width={1024}
    shadow-mapSize-height={1024}
  />

  {/* Scene content */}
  <mesh receiveShadow position={[0, -1, 0]} rotation={[-Math.PI / 2, 0, 0]}>
    <planeGeometry args={[10, 10]} />
    <meshStandardMaterial color="#f0f0f0" />
  </mesh>

  <mesh castShadow position={[0, 0.5, 0]}>
    <boxGeometry args={[1, 1, 1]} />
    <meshStandardMaterial color="hotpink" roughness={0.3} metalness={0.1} />
  </mesh>
</Canvas>
```

### Camera Conventions

| Perspective | Use Case |
|-------------|----------|
| fov: 50, position: [0, 0, 10] | Product showcase, closer, less distortion |
| fov: 75, position: [3, 3, 5] | General scene viewing (default) |
| fov: 90-100, position: near | First-person / immersive |
| Orthographic | Isometric, 2D+ depth, architectural |

### Color Spaces

```tsx
// Default (recommended): sRGB color space + ACES filmic tone mapping
<Canvas />  // outputColorSpace=SRGB, toneMapping=ACESFilmic

// Linear workflow (raw color values, manual gamma):
<Canvas linear />

// No tone mapping (for post-processing):
<Canvas flat />

// Legacy mode (Three.js r138 and below):
<Canvas legacy />
```

## 2. Reusable 3D Components

R3F components are just React components that return Three.js JSX. They participate fully in the React lifecycle.

```tsx
interface BoxProps {
  position?: [number, number, number]
  color?: string
  scale?: number
  onClick?: () => void
}

function Box({ position = [0, 0, 0], color = 'orange', scale = 1, onClick }: BoxProps) {
  const meshRef = useRef<THREE.Mesh>(null!)
  const [hovered, setHovered] = useState(false)

  useFrame((state, delta) => {
    meshRef.current.rotation.x += delta * 0.3
    meshRef.current.rotation.y += delta * 0.5
  })

  return (
    <mesh
      ref={meshRef}
      position={position}
      scale={scale}
      onClick={onClick}
      onPointerOver={() => setHovered(true)}
      onPointerOut={() => setHovered(false)}
    >
      <boxGeometry args={[1, 1, 1]} />
      <meshStandardMaterial
        color={hovered ? 'hotpink' : color}
        roughness={0.3}
      />
    </mesh>
  )
}
```

### The attach Pattern

Control how a child attaches to its parent using the `attach` prop:

```tsx
// Attach a custom shader material to a mesh
<mesh>
  <sphereGeometry args={[0.5, 32, 32]} />
  <shaderMaterial attach="material" args={[MyShader]} />
</mesh>

// Attach to arbitrary parent properties
<mesh>
  <planeGeometry attach="geometry" args={[2, 2]} />
</mesh>
```

### The primitive Pattern

Wrap non-R3F Three.js objects (from loaders, procedural generation):

```tsx
function ProceduralTerrain() {
  const geometry = useMemo(() => {
    const geo = new THREE.PlaneGeometry(10, 10, 128, 128)
    // Modify vertices...
    return geo
  }, [])

  return (
    <mesh geometry={geometry}>
      <meshStandardMaterial wireframe color="green" />
    </mesh>
  )
}

// Or use <primitive> for pre-constructed objects:
<primitive object={preBuiltMesh} position={[0, 0, 0]} />
```

## 3. Animation with useFrame

### Continuous Rotation / Float

```tsx
function FloatingMesh() {
  const ref = useRef<THREE.Mesh>(null!)
  const initialY = useRef(0)

  useFrame(({ clock }) => {
    const t = clock.getElapsedTime()
    ref.current.position.y = initialY.current + Math.sin(t * 2) * 0.2
    ref.current.rotation.y = t * 0.5
  })

  return (
    <mesh ref={ref} position={[0, 0, initialY.current]}>
      <torusKnotGeometry args={[1, 0.3, 128, 32]} />
      <meshStandardMaterial color="#6366f1" roughness={0.2} metalness={0.8} />
    </mesh>
  )
}
```

### Scroll-Driven Animation

```tsx
function ScrollScene() {
  const groupRef = useRef<THREE.Group>(null!)

  useFrame(({ viewport }) => {
    const scrollY = window.scrollY
    const maxScroll = document.body.scrollHeight - window.innerHeight
    const progress = scrollY / maxScroll

    // Rotate based on scroll
    groupRef.current.rotation.y = progress * Math.PI * 2
    // Scale viewport-aware
    const scale = viewport.width / 5
    groupRef.current.scale.setScalar(scale)
  })

  return (
    <group ref={groupRef}>
      {/* 3D content */}
    </group>
  )
}
```

### State-Driven Animations

For complex sequences, combine R3F with animation libraries:

```tsx
import { useSpring, animated } from '@react-spring/three'

function AnimatedBox() {
  const [active, setActive] = useState(false)
  const { scale } = useSpring({ scale: active ? 1.5 : 1 })

  return (
    <animated.mesh
      scale={scale}
      onClick={() => setActive(!active)}
    >
      <boxGeometry />
      <meshStandardMaterial color="coral" />
    </animated.mesh>
  )
}
```

### Render Priority & Post-Processing

```tsx
// useFrame with priority 0: pre-render
useFrame((state, delta) => {
  // Update scene objects
}, 0)

// useFrame with priority 1: post-render (for post-processing composers)
useFrame(({ gl, scene, camera }) => {
  gl.autoClear = false  // for multi-pass
  composer.render()
}, 1)
```

## 4. Event Handling in 3D Space

### Click Interaction with State

```tsx
function InteractiveCube() {
  const [color, setColor] = useState('#ff6080')
  const meshRef = useRef<THREE.Mesh>(null!)

  const handleClick = useCallback(() => {
    setColor(`#${Math.floor(Math.random() * 16777215).toString(16)}`)
    // Can also access the 3D hit point
  }, [])

  return (
    <mesh ref={meshRef} onClick={handleClick}>
      <boxGeometry args={[1, 1, 1]} />
      <meshStandardMaterial color={color} />
    </mesh>
  )
}
```

### Hover States

```tsx
function HoverableMesh() {
  const [hovered, setHovered] = useState(false)
  const meshRef = useRef<THREE.Mesh>(null!)

  useFrame((_, delta) => {
    if (hovered) {
      meshRef.current.scale.lerp(
        new THREE.Vector3(1.2, 1.2, 1.2), delta * 5
      )
    } else {
      meshRef.current.scale.lerp(
        new THREE.Vector3(1, 1, 1), delta * 5
      )
    }
  })

  return (
    <mesh
      ref={meshRef}
      onPointerOver={() => setHovered(true)}
      onPointerOut={() => setHovered(false)}
    >
      <icosahedronGeometry args={[1, 1]} />
      <meshStandardMaterial
        color={hovered ? '#a855f7' : '#6366f1'}
        roughness={0.3}
        emissive={hovered ? '#a855f7' : '#000000'}
        emissiveIntensity={hovered ? 0.5 : 0}
      />
    </mesh>
  )
}
```

### Drag in 3D (with drei)

```tsx
import { DragControls } from '@react-three/drei'

function DraggableScene() {
  return (
    <DragControls>
      <mesh>
        <boxGeometry />
        <meshStandardMaterial color="orange" />
      </mesh>
      <mesh position={[2, 0, 0]}>
        <sphereGeometry />
        <meshStandardMaterial color="skyblue" />
      </mesh>
    </DragControls>
  )
}
```

## 5. Loading & Suspense for 3D Assets

### GLTF Model Loading

```tsx
import { Suspense } from 'react'
import { useLoader } from '@react-three/fiber'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js'

function Model({ url }: { url: string }) {
  const gltf = useLoader(GLTFLoader, url)
  return <primitive object={gltf.scene} />
}

function Scene() {
  return (
    <Canvas>
      <Suspense fallback={<LoadingFallback />}>
        <Model url="/models/scene.glb" />
      </Suspense>
    </Canvas>
  )
}

function LoadingFallback() {
  return (
    <mesh>
      <boxGeometry args={[1, 1, 1]} />
      <meshBasicMaterial color="gray" wireframe />
    </mesh>
  )
}
```

### Progressive Loading

```tsx
function ModelWithProgress({ url }: { url: string }) {
  const [progress, setProgress] = useState(0)
  const gltf = useLoader(GLTFLoader, url, undefined, (event) => {
    if (event.total > 0) {
      setProgress((event.loaded / event.total) * 100)
    }
  })

  if (progress < 100) {
    return <LoadingBar progress={progress} />
  }

  return <primitive object={gltf.scene} />
}
```

### Preloading Assets

```tsx
import { useLoader } from '@react-three/fiber'

// Preload before rendering the Canvas
useLoader.preload(GLTFLoader, '/models/heavy-scene.glb', (loader) => {
  loader.setDecoderPath('/draco/')
})
```

## 6. Performance Optimization

### Instanced Rendering

For thousands of identical objects, use instanced meshes (via `@react-three/drei`):

```tsx
import { Instances, Instance } from '@react-three/drei'

function ParticleField({ count = 1000 }: { count?: number }) {
  const positions = useMemo(() =>
    Array.from({ length: count }, () => [
      (Math.random() - 0.5) * 20,
      (Math.random() - 0.5) * 20,
      (Math.random() - 0.5) * 20,
    ] as [number, number, number]),
    [count]
  )

  return (
    <Instances limit={count}>
      <boxGeometry args={[0.1, 0.1, 0.1]} />
      <meshStandardMaterial color="#6366f1" />
      {positions.map((pos, i) => (
        <Instance key={i} position={pos} />
      ))}
    </Instances>
  )
}
```

### Adaptive Performance

```tsx
function PerformanceAwareScene() {
  const { performance } = useThree()

  useFrame(() => {
    // If FPS drops, reduce detail
    if (performance.current < 0.8) {
      // Reduce particle count, lower resolution, etc.
    }
  })

  return null
}

// Canvas-level config
<Canvas performance={{ min: 0.3, max: 1, debounce: 300 }}>
```

### On-Demand Rendering

```tsx
<Canvas frameloop="demand">
  {/* Only renders when state changes or invalidate() is called */}
</Canvas>

// Manual invalidation
const { invalidate } = useThree()
useEffect(() => {
  invalidate()  // trigger a single render
}, [someState, invalidate])
```

### Level of Detail (LOD)

```tsx
import { useThree } from '@react-three/fiber'

function LODMesh() {
  const { camera } = useThree()
  const meshRef = useRef<THREE.Mesh>(null!)
  const [detail, setDetail] = useState(2) // high by default

  useFrame(() => {
    const distance = camera.position.distanceTo(meshRef.current.position)
    setDetail(distance < 5 ? 2 : distance < 10 ? 1 : 0)
  })

  const geometry = useMemo(() => {
    const segments = detail === 2 ? 64 : detail === 1 ? 16 : 4
    return new THREE.SphereGeometry(1, segments, segments)
  }, [detail])

  return (
    <mesh ref={meshRef} geometry={geometry}>
      <meshStandardMaterial color="hotpink" />
    </mesh>
  )
}
```

### Geometry Reuse (InstancedBufferGeometry)

```tsx
function SharedGeometryMeshes() {
  const geometry = useMemo(() => new THREE.BoxGeometry(1, 1, 1), [])

  return (
    <>
      {/* All share the same geometry reference — GPU efficient */}
      <mesh geometry={geometry} position={[-2, 0, 0]}>
        <meshStandardMaterial color="red" />
      </mesh>
      <mesh geometry={geometry} position={[0, 0, 0]}>
        <meshStandardMaterial color="green" />
      </mesh>
      <mesh geometry={geometry} position={[2, 0, 0]}>
        <meshStandardMaterial color="blue" />
      </mesh>
    </>
  )
}
```

### Draw Call Budget

| Scene Type | Max Draw Calls | Max Triangles |
|-----------|---------------|--------------|
| Mobile | 100-200 | 50k-100k |
| Desktop (60fps target) | 500-1000 | 500k-1M |
| High-end / WebGL2 | 2000+ | 2M+ |

## 7. Post-Processing Integration

Use `@react-three/postprocessing` for declarative effects:

```tsx
import { EffectComposer, Bloom, Vignette, Noise } from '@react-three/postprocessing'

function Scene() {
  return (
    <Canvas>
      <ambientLight />
      <mesh>...</mesh>

      <EffectComposer>
        <Bloom luminanceThreshold={0.3} luminanceSmoothing={0.9} intensity={0.8} />
        <Vignette eskil={false} offset={0.1} darkness={1.1} />
        <Noise opacity={0.02} />
      </EffectComposer>
    </Canvas>
  )
}
```

**Post-processing render priority**: Effects must render with priority > 0 in useFrame because the EffectComposer takes over the render call:

```tsx
// R3F handles this automatically with @react-three/postprocessing
// but for custom post-processing, use priority 1:
useFrame(({ gl, scene, camera }) => {
  composer.render()
}, 1)
```

## 8. Composing with Other Libraries

### With framer-motion (via framer-motion-3d)

```tsx
import { motion } from 'framer-motion-3d'

function AnimatedBox() {
  return (
    <motion.mesh
      animate={{ rotateY: Math.PI * 2 }}
      transition={{ duration: 2, repeat: Infinity }}
    >
      <boxGeometry />
      <meshStandardMaterial color="hotpink" />
    </motion.mesh>
  )
}
```

### With react-spring (via @react-spring/three)

```tsx
import { useSpring, animated } from '@react-spring/three'

function SpringMesh({ active }: { active: boolean }) {
  const { scale, color } = useSpring({
    scale: active ? 1.5 : 1,
    color: active ? '#ff6080' : '#6366f1',
  })

  return (
    <animated.mesh scale={scale}>
      <sphereGeometry args={[1, 32, 32]} />
      <animated.meshStandardMaterial color={color} roughness={0.2} />
    </animated.mesh>
  )
}
```

### With react-bits 3D Components

R3F scenes can coexist with react-bits UI overlays. HTML overlays rendered via react-dom float on top of the Canvas. Use `Html` from drei to position HTML elements in 3D space:

```tsx
import { Html } from '@react-three/drei'
import { BlurText } from 'react-bits'

function Label3D({ text, position }: { text: string; position: [number,number,number] }) {
  return (
    <mesh position={position}>
      <sphereGeometry args={[0.1, 16, 16]} />
      <Html center distanceFactor={10}>
        <div className="label">
          <BlurText text={text} />
        </div>
      </Html>
    </mesh>
  )
}
```

### With Zustand for Scene State

```tsx
import { create } from 'zustand'

interface SceneState {
  activeObject: string | null
  setActiveObject: (id: string | null) => void
  colorScheme: 'light' | 'dark'
  toggleColorScheme: () => void
}

const useSceneStore = create<SceneState>((set) => ({
  activeObject: null,
  setActiveObject: (id) => set({ activeObject: id }),
  colorScheme: 'dark',
  toggleColorScheme: () => set((s) => ({ colorScheme: s.colorScheme === 'dark' ? 'light' : 'dark' })),
}))

function SceneObjects() {
  const { activeObject, setActiveObject } = useSceneStore()

  return (
    <>
      <mesh
        onClick={() => setActiveObject('cube')}
        scale={activeObject === 'cube' ? 1.3 : 1}
      >
        <boxGeometry />
        <meshStandardMaterial
          color={activeObject === 'cube' ? '#a855f7' : '#6366f1'}
        />
      </mesh>
    </>
  )
}
```

## 9. Shadow Setup Patterns

### PCF Soft Shadows (Default)

```tsx
<Canvas shadows="soft">
  <directionalLight
    castShadow
    position={[5, 10, 5]}
    intensity={1}
    shadow-mapSize-width={2048}
    shadow-mapSize-height={2048}
    shadow-camera-far={50}
    shadow-camera-left={-10}
    shadow-camera-right={10}
    shadow-camera-top={10}
    shadow-camera-bottom={-10}
  />
  <mesh castShadow>...</mesh>
  <mesh receiveShadow>...</mesh>
</Canvas>
```

### Shadow Types

```tsx
shadows="basic"       // BasicShadowMap (fast, hard edges)
shadows="percentage"  // PCFShadowMap
shadows="soft"        // PCFSoftShadowMap (default)
shadows="variance"    // VSMShadowMap (softer, can suffer light bleeding)
shadows={{            // Custom config
  type: THREE.PCFSoftShadowMap,
  enabled: true,
}}
```

## 10. Cleanup Pattern

Components should clean up resources in useEffect returns:

```tsx
function ProceduralMesh() {
  const geometryRef = useRef<THREE.BufferGeometry>()

  useEffect(() => {
    const geo = new THREE.SphereGeometry(1, 64, 64)
    geometryRef.current = geo
    return () => geo.dispose()
  }, [])

  return <mesh geometry={geometryRef.current}>...</mesh>
}
```

R3F auto-disposes geometries and materials when components unmount. Pass `dispose={null}` to opt out:

```tsx
<mesh dispose={null}>  {/* Won't auto-dispose on unmount */}
```

## 11. Viewport-Aware Layout

```tsx
function ViewportBox() {
  const { viewport } = useThree()

  // Make a plane that fills the viewport at z=0
  // viewport.width/height are in three.js units
  return (
    <mesh>
      <planeGeometry args={[viewport.width, viewport.height]} />
      <meshBasicMaterial color="#f0f0f0" />
    </mesh>
  )
}
```

## 12. Environment Map Setup

```tsx
import { useThree } from '@react-three/fiber'
import { RGBELoader } from 'three/examples/jsm/loaders/RGBELoader.js'

function Environment({ url }: { url: string }) {
  const { scene } = useThree()

  useLoader(RGBELoader, url, (loader) => {
    const pmremGenerator = new THREE.PMREMGenerator(useThree.getState().gl)
    // ... setup
  })

  return null
}
```

For simpler setup, use `Environment` from `@react-three/drei`:

```tsx
import { Environment } from '@react-three/drei'

<Canvas>
  <Environment preset="city" />  {/* Built-in HDR presets */}
</Canvas>
```
