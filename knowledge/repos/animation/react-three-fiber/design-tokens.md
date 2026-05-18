# @react-three/fiber Design Tokens

> 3D scene design tokens — lighting, materials, camera, environment, post-processing, and performance budgets

## 1. Lighting Presets

### Studio Lighting (Product Showcase)

Soft, even lighting for product visualization. Minimizes harsh shadows.

```tsx
function StudioLighting() {
  return (
    <>
      {/* Key light */}
      <directionalLight
        position={[5, 5, 5]}
        intensity={1.5}
        castShadow
        shadow-mapSize={[1024, 1024]}
      />
      {/* Fill light */}
      <directionalLight
        position={[-3, 3, -3]}
        intensity={0.5}
      />
      {/* Rim/back light */}
      <directionalLight
        position={[0, 5, -5]}
        intensity={0.8}
      />
      {/* Ambient */}
      <ambientLight intensity={0.4} />
    </>
  )
}
```

### Outdoor / Daylight

Strong directional sun + blue sky ambient:

```tsx
function OutdoorLighting() {
  return (
    <>
      {/* Sun */}
      <directionalLight
        position={[10, 15, 5]}
        intensity={2}
        color="#fff5e6"  // Warm sunlight
        castShadow
        shadow-mapSize={[2048, 2048]}
        shadow-camera-far={50}
        shadow-camera-left={-20}
        shadow-camera-right={20}
        shadow-camera-top={20}
        shadow-camera-bottom={-20}
      />
      {/* Sky ambient */}
      <ambientLight intensity={0.6} color="#b8d4ff" />
      {/* Ground bounce */}
      <hemisphereLight
        args={['#b8d4ff', '#3d5a1e', 0.4]}  // Sky color, ground color, intensity
      />
    </>
  )
}
```

### Dramatic / Cinematic

High contrast, strong directional key, minimal fill:

```tsx
function DramaticLighting() {
  return (
    <>
      {/* Single strong key */}
      <spotLight
        position={[8, 10, 3]}
        angle={0.3}
        penumbra={1}
        intensity={50}
        color="#ffe8cc"
        castShadow
        shadow-mapSize={[2048, 2048]}
      />
      {/* Minimal ambient */}
      <ambientLight intensity={0.15} />
      {/* Accent */}
      <pointLight
        position={[-5, 2, -3]}
        intensity={10}
        color="#ff4060"
      />
    </>
  )
}
```

### Three-Point Lighting (Portrait / Character)

Classic film lighting with Key, Fill, and Rim:

```tsx
function ThreePointLighting() {
  return (
    <>
      {/* Key - main directional */}
      <directionalLight
        position={[3, 4, 5]}
        intensity={1.8}
        castShadow
      />
      {/* Fill - softer, opposite side */}
      <directionalLight
        position={[-5, 2, -2]}
        intensity={0.6}
      />
      {/* Rim - behind subject, separates from bg */}
      <directionalLight
        position={[0, 3, -5]}
        intensity={1.2}
      />
      <ambientLight intensity={0.3} />
    </>
  )
}
```

### Neon / Cyberpunk

Colored point lights, emissive materials, dark environment:

```tsx
function NeonLighting() {
  return (
    <>
      <pointLight position={[3, 2, 3]} intensity={10} color="#ff00ff" />
      <pointLight position={[-3, 1, -2]} intensity={10} color="#00ffff" />
      <pointLight position={[0, -1, 4]} intensity={8} color="#ff6000" />
      <ambientLight intensity={0.05} />
    </>
  )
}
```

## 2. Material Properties

### PBR Material Properties (meshStandardMaterial / meshPhysicalMaterial)

| Property | Range | Default | Description |
|----------|-------|---------|-------------|
| `roughness` | 0-1 | 0.5 | 0 = mirror, 1 = matte |
| `metalness` | 0-1 | 0.5 | 0 = dielectric (plastic), 1 = metal |
| `clearcoat` | 0-1 | 0 | Glossy coating layer (physical only) |
| `clearcoatRoughness` | 0-1 | 0 | Roughness of clearcoat |
| `transmission` | 0-1 | 0 | Glass-like transparency (physical only) |
| `ior` | 1-3 | 1.5 | Index of refraction (physical only) |
| `emissive` | Color | #000000 | Self-illumination |
| `emissiveIntensity` | 0-∞ | 1 | Emissive brightness |
| `reflectivity` | 0-1 | 0.5 | Non-metallic reflectivity |
| `sheen` | 0-1 | 0 | Fabric/cloth-like sheen (physical only) |

### Material Presets

```tsx
// Polished Metal
<meshStandardMaterial
  color="#c0c0c0"
  metalness={0.9}
  roughness={0.1}
/>

// Matte Plastic
<meshStandardMaterial
  color="#ff6080"
  metalness={0}
  roughness={0.8}
/>

// Brushed Steel
<meshStandardMaterial
  color="#888899"
  metalness={0.8}
  roughness={0.4}
/>

// Glossy Car Paint (with clearcoat)
<meshPhysicalMaterial
  color="#ff2200"
  metalness={0}
  roughness={0.3}
  clearcoat={1}
  clearcoatRoughness={0.1}
/>

// Glass
<meshPhysicalMaterial
  color="#ffffff"
  metalness={0}
  roughness={0}
  transmission={1}
  ior={1.5}
  thickness={0.5}
/>

// Gold
<meshStandardMaterial
  color="#ffd700"
  metalness={1}
  roughness={0.2}
/>

// Velvet (sheen)
<meshPhysicalMaterial
  color="#8800aa"
  metalness={0}
  roughness={0.8}
  sheen={0.8}
  sheenRoughness={0.5}
  sheenColor="#ff00ff"
/>

// Glowing/Emissive
<meshStandardMaterial
  color="#000000"
  emissive="#ff4060"
  emissiveIntensity={2}
/>
```

### Material Color Tips

- **Rough surfaces** appear lighter/duller — increase saturation to compensate
- **Metal surfaces** derive color from the `color` prop (not from environment reflections alone)
- **PBR materials** work best with environment maps — without them, metals look black
- **meshPhysicalMaterial** is more expensive than meshStandardMaterial — use only when needed

## 3. Camera Configurations

### Perspective Camera Presets

| Use Case | fov | near | far | Position | Notes |
|----------|-----|------|-----|----------|-------|
| **Product (close-up)** | 35-50 | 0.1 | 100 | [0, 0, 5-8] | Less perspective distortion |
| **General Scene** | 60-75 | 0.1 | 100 | [3, 3, 5] | Good balance |
| **Wide / Immersive** | 90-100 | 0.1 | 100 | [0, 1.6, 2] | First-person feel |
| **Architectural** | 50-60 | 0.5 | 200 | [10, 5, 10] | Minimal distortion |
| **Mobile (portrait)** | 60 | 0.1 | 100 | [0, 0, 5] | Narrower aspect ratio |

```tsx
// Product camera
<Canvas camera={{ fov: 45, position: [0, 0, 7], near: 0.1, far: 100 }} />

// Wide cinematic
<Canvas camera={{ fov: 90, position: [0, 2, 3], near: 0.1, far: 50 }} />
```

### Orthographic Camera

```tsx
<Canvas orthographic camera={{ zoom: 50, position: [0, 0, 10] }}>
  {/* Isometric or 2.5D scenes */}
</Canvas>
```

### Camera Distance vs Subject Size

For a perspective camera, the visible height at distance `d` is:

```
visibleHeight = 2 * d * tan(fov / 2)
visibleWidth = visibleHeight * aspect
```

Example: fov=75, distance=5, aspect=16/9
```
visibleHeight = 2 * 5 * tan(37.5 deg) = 7.66 units
visibleWidth = 7.66 * 1.778 = 13.62 units
```

### Dynamic Camera Adjustment

```tsx
function CameraFitter({
  boundingBox,
}: {
  boundingBox: THREE.Box3
}) {
  const { camera, size } = useThree()

  useEffect(() => {
    const center = new THREE.Vector3()
    boundingBox.getCenter(center)
    const sphere = new THREE.Sphere()
    boundingBox.getBoundingSphere(sphere)

    const fov = (camera as THREE.PerspectiveCamera).fov * (Math.PI / 180)
    const distance = sphere.radius / Math.sin(fov / 2)

    camera.position.copy(center).add(new THREE.Vector3(0, 0, distance))
    camera.lookAt(center)
  }, [boundingBox, camera])

  return null
}
```

## 4. Environment & HDR

### Built-in Drei Environment Presets

```tsx
import { Environment } from '@react-three/drei'

// Preset HDR environments
<Environment preset="sunset" />     // Warm golden-hour
<Environment preset="dawn" />       // Cool blue morning
<Environment preset="night" />      // Dark moody
<Environment preset="warehouse" />  // Indoor industrial
<Environment preset="forest" />     // Green woodland
<Environment preset="apartment" />  // Indoor living space
<Environment preset="studio" />     // Neutral studio
<Environment preset="city" />       // Urban skyline
<Environment preset="park" />       // Outdoor park
<Environment preset="lobby" />      // Indoor modern lobby
```

### Custom HDR Environment

```tsx
<Environment
  files="/environments/my-hdr.hdr"
  background         // Renders as scene background
  backgroundBlurriness={0.5}  // Blur the bg for depth
  ground={{          // Ground projection (for reflections)
    height: 7,
    radius: 28,
    scale: 100,
  }}
/>
```

### Environment Intensity & Rotation

```tsx
<Environment
  preset="city"
  environmentIntensity={0.8}  // How much the env affects materials
  backgroundIntensity={0.5}   // Background brightness (separate)
  backgroundRotation={[0, Math.PI / 4, 0]}  // Rotate bg
  environmentRotation={[0, Math.PI / 4, 0]} // Rotate env reflections
/>
```

## 5. Color Spaces & Tone Mapping

### Canvas Color Pipeline

```
Linear color values (sRGB textures auto-converted)
    ↓
Lighting calculations (linear space)
    ↓
Tone mapping (ACESFilmicToneMapping by default)
    ↓
Output color space conversion (SRGBColorSpace by default)
    ↓
Display
```

### Tone Mapping Modes

| Mode | Description | Use |
|------|-------------|-----|
| `ACESFilmicToneMapping` | Film industry standard (default) | General purpose, prevents blow-out |
| `LinearToneMapping` | No curve | Debug, raw output |
| `ReinhardToneMapping` | Smooth roll-off | Vintage/soft look |
| `CineonToneMapping` | Film stock emulation | Cinematic |
| `NoToneMapping` | Disabled | Post-processing takes over |

```tsx
// Canvas-level
<Canvas flat />  // shorthand for NoToneMapping

// Manual
<Canvas gl={{ toneMapping: THREE.CineonToneMapping, toneMappingExposure: 1.2 }} />
```

### Output Color Spaces

```tsx
// Default (recommended): sRGB
<Canvas />  // gl.outputColorSpace = THREE.SRGBColorSpace

// Linear output (for custom post-processing pipeline):
<Canvas linear />  // gl.outputColorSpace = THREE.LinearSRGBColorSpace
```

### Color Handling in Shaders

```tsx
// Custom shader material — note: uniforms are in linear space
const shader = {
  uniforms: {
    uColor: { value: new THREE.Color('#ff6080').convertSRGBToLinear() },
  },
}
```

## 6. Post-Processing Effect Chains

### Common Effect Chains

**Bloom + Vignette** (cinematic):

```tsx
<EffectComposer>
  <Bloom
    luminanceThreshold={0.2}
    luminanceSmoothing={0.9}
    intensity={1.5}
    mipmapBlur
  />
  <Vignette
    offset={0.1}
    darkness={1.1}
    eskil={false}
  />
  <ToneMapping />
</EffectComposer>
```

**Retro / Glitch**:

```tsx
<EffectComposer>
  <Glitch
    delay={new THREE.Vector2(1.5, 3.5)}
    duration={new THREE.Vector2(0.6, 1.0)}
    strength={new THREE.Vector2(0.3, 1.0)}
  />
  <Scanline density={10} />
  <ChromaticAberration offset={[0.002, 0.002]} />
</EffectComposer>
```

**Clean / Modern**:

```tsx
<EffectComposer multisampling={8}>
  <SSAO
    radius={0.05}
    intensity={1.5}
    luminanceInfluence={0.5}
  />
  <Bloom
    luminanceThreshold={0.8}
    intensity={0.4}
  />
  <SMAA />
</EffectComposer>
```

**Depth of Field**:

```tsx
<EffectComposer>
  <DepthOfField
    focusDistance={0}
    focalLength={0.02}
    bokehScale={2}
    height={480}
  />
</EffectComposer>
```

### Post-Processing Performance Order

Apply effects in order of computational cost:
1. SMAA/FXAA (anti-aliasing) — first
2. Depth of Field / SSAO — expensive, early
3. Bloom — medium cost
4. Vignette / Chromatic Aberration / Noise — cheap, late
5. ToneMapping — always last

### Custom Effect Composer (Manual)

```tsx
function CustomPostProcessing() {
  const { gl, scene, camera, size } = useThree()
  const composer = useRef<EffectComposer>()

  useEffect(() => {
    composer.current = new EffectComposer(gl)
    const renderPass = new RenderPass(scene, camera)
    composer.current.addPass(renderPass)

    const bloomPass = new UnrealBloomPass(
      new THREE.Vector2(size.width, size.height), 1.5, 0.4, 0.85
    )
    composer.current.addPass(bloomPass)
  }, [])

  useFrame(() => {
    composer.current?.render()
  }, 1)  // Priority 1 = after scene render

  return null
}
```

## 7. Performance Budgets

### Target Budgets by Device

| Budget | Mobile | Desktop Mid | Desktop High |
|--------|--------|-------------|-------------|
| **Draw calls** | < 150 | < 500 | < 1500 |
| **Triangles** | < 100k | < 500k | < 2M |
| **Texture memory** | < 200MB | < 500MB | < 1GB |
| **Shadow maps** | 1 × 512² | 1-2 × 1024² | 2-3 × 2048² |
| **Lights** | < 4 | < 10 | < 20 |
| **Animations** | < 10 bones | < 50 bones | < 200 bones |
| **Particles** | < 1000 | < 10000 | < 100000 |

### Geometry Complexity Budget

| Shape | Segments (Mobile) | Segments (Desktop) |
|-------|-------------------|---------------------|
| SphereGeometry | [1, 16, 16] | [1, 32, 32] |
| CircleGeometry | [1, 32] | [1, 64] |
| TorusGeometry | [1, 0.3, 8, 16] | [1, 0.3, 16, 64] |
| PlaneGeometry | [w, h, 1, 1] | [w, h, 1, 1] (add tessellation if needed) |

### Texture Size Budget

| Asset Type | Mobile Size | Desktop Size |
|------------|-------------|--------------|
| Color/Albedo | 1024² | 2048² |
| Normal map | 512² | 1024² |
| Roughness/Metalness | 512² | 1024² |
| Ambient occlusion | 512² | 1024² |
| Environment map | 512² | 1024² |
| GLB textures | 1024² max | 2048² max |

### Adaptive DPR

```tsx
// Clamp DPR for performance
<Canvas dpr={[1, 2]}>   {/* Min 1x, max 2x */}
<Canvas dpr={[0.5, 1]}> {/* Aggressive mobile optimization */}
```

### Draw Call Optimization Checklist

- [ ] Use InstancedMesh for repeated geometry (>20 instances)
- [ ] Merge static geometry with BufferGeometryUtils.mergeGeometries
- [ ] Share materials across meshes (same material reference)
- [ ] Use MeshStandardMaterial over MeshPhysicalMaterial unless clearcoat/transmission needed
- [ ] Frustum culling enabled (default, but verify)
- [ ] Reduce shadow casting to essential objects only
- [ ] Use 1-2 shadow-casting lights max
- [ ] Texture atlases for many small textures

### Performance Monitoring

```tsx
import { StatsGl } from '@react-three/drei'

function Scene() {
  return (
    <Canvas>
      <StatsGl className="stats" />
      {/* Scene content */}
    </Canvas>
  )
}
```

Or use R3F's built-in performance API:

```tsx
function PerformanceMonitor() {
  const perf = useThree((s) => s.performance)

  useFrame(() => {
    if (perf.current < 0.8) {
      // Running below 80% target performance — reduce quality
    }
  })

  return null
}
```

## 8. Shadow Quality Tiers

| Tier | Map Size | Type | Blur | Use |
|------|----------|------|------|-----|
| Low | 512² | BasicShadowMap | None | Mobile / background |
| Medium | 1024² | PCFSoftShadowMap | Soft | Desktop general |
| High | 2048² | PCFSoftShadowMap | Soft | Hero objects |
| Ultra | 4096² | VSMShadowMap | Very soft | Close-up product |

```tsx
// Quality tier selection
const shadowConfig = {
  low: { shadowMapSize: 512, shadows: 'basic' },
  medium: { shadowMapSize: 1024, shadows: 'soft' },
  high: { shadowMapSize: 2048, shadows: 'soft' },
  ultra: { shadowMapSize: 4096, shadows: 'variance' },
} as const
```

## 9. Scene Backgrounds

```tsx
// Solid color
<Canvas gl={{ alpha: false }}>
  <color attach="background" args={['#1a1a2e']} />
</Canvas>

// Transparent canvas (overlays on HTML)
<Canvas gl={{ alpha: true, premultipliedAlpha: true }}>
  {/* Scene renders on top of HTML content below */}
</Canvas>

// HDR environment as background
<Environment preset="sunset" background />

// Gradient background via shader
<mesh scale={[100, 100, 1]}>
  <planeGeometry args={[1, 1]} />
  <shaderMaterial
    attach="material"
    depthWrite={false}  // Renders behind everything
    args={[{
      uniforms: {
        uColor1: { value: new THREE.Color('#1a1a2e') },
        uColor2: { value: new THREE.Color('#16213e') },
      },
      vertexShader: `...`,
      fragmentShader: `...`,
    }]}
  />
</mesh>
```

## 10. Renderer Configuration Quick Reference

```tsx
// Performance-focused
<Canvas
  gl={{
    powerPreference: 'high-performance',
    antialias: true,          // Enable MSAA
    alpha: false,             // No transparency = faster
    stencil: false,           // Disable if not needed
    depth: true,              // Enable depth buffer
    preserveDrawingBuffer: false,  // Don't keep for toDataURL
  }}
  dpr={[1, 2]}
  performance={{ min: 0.5 }}
/>

// Quality-focused
<Canvas
  gl={{
    powerPreference: 'high-performance',
    antialias: true,
    alpha: true,              // Transparent for overlays
    stencil: true,            // For stencil effects
    preserveDrawingBuffer: true,  // For screenshots
  }}
  dpr={[1, 2]}
  shadows="soft"
/>

// Debug / Development
<Canvas
  gl={{
    powerPreference: 'high-performance',
    antialias: false,         // Faster iteration
    alpha: false,
  }}
  dpr={1}                    // 1x for dev speed
  flat                         // No tone mapping for debugging
/>
```
