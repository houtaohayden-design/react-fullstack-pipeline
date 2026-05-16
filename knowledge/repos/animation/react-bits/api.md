# react-bits -- API Reference

> **Source**: https://reactbits.dev | **GitHub**: https://github.com/DavidHDev/react-bits
> **Maintainer**: David Haz | **License**: MIT + Commons Clause
> **130 components** across 4 categories (4 variants each: JS-CSS, JS-TW, TS-CSS, TS-TW)
> React 19, GSAP 3.13, Motion 12, Three.js 0.167, ogl 1.0.11

## Setup

react-bits uses **copy-paste** distribution -- each component is a standalone file you add to your project. No single npm package to install.

```bash
# Option A: shadcn CLI (preferred)
npx shadcn@latest add @react-bits/BlurText-TS-TW

# Option B: jsrepo CLI
npx jsrepo add @react-bits/BlurText-TS-TW

# Option C: Manual copy from reactbits.dev
# Visit a component page, select your variant (JS/TS, CSS/TW), copy code
```

**Per-component dependencies** (install only what your chosen components need):
```bash
# Core (used by ~80% of components)
npm install motion          # Motion (formerly Framer Motion) -- spring animations, gestures

# Advanced animations
npm install gsap @gsap/react   # GSAP -- SplitText, ScrollTrigger

# 3D / WebGL (used by Backgrounds and some Components)
npm install three @react-three/fiber @react-three/drei
npm install ogl                    # Lightweight WebGL (Particles, etc.)
npm install postprocessing         # Post-processing effects (Hyperspeed)

# Physics
npm install matter-js              # 2D physics (Ballpit, etc.)
npm install @react-three/rapier    # 3D physics

# Utilities
npm install clsx                   # Conditional classNames
npm install lenis                  # Smooth scrolling
```

---

## Components: 130 Total

---

### Text Animations (23)

Text entrance, hover, and scroll-driven animation components.

| # | Component | Purpose | Key Props | Dependencies |
|---|-----------|---------|-----------|--------------|
| 1 | **ASCIIText** | Converts text into ASCII art with dynamic character resolution | `text`, `resolution`, `className` | React only |
| 2 | **BlurText** | Staggered blur-in letter/word sequence on viewport entry | `text`, `delay`, `animateBy` ('words'/'letters'), `direction` ('top'/'bottom'), `threshold`, `easing`, `stepDuration`, `animationFrom`, `animationTo`, `onAnimationComplete` | `motion` |
| 3 | **CircularText** | Text arranged in a circle with rotation animation | `text`, `radius`, `className` | React only |
| 4 | **CountUp** | Animated number counter that counts up to target | `from`, `to`, `duration`, `separator`, `decimals`, `className` | React only |
| 5 | **CurvedLoop** | Infinite curved text marquee/loop animation | `text`, `speed`, `className` | React only |
| 6 | **DecryptedText** | Text decrypts/scrambles character by character to reveal content | `text`, `speed`, `maxIterations`, `chars`, `className` | React only |
| 7 | **FallingText** | Characters fall into place from above with physics-like motion | `text`, `delay`, `className` | `motion` |
| 8 | **FuzzyText** | Fuzzy/blurred text that sharpens into focus | `text`, `baseSize`, `className` | React only (canvas) |
| 9 | **GlitchText** | Glitch/corruption text effect with random character swaps | `text`, `speed`, `className` | React only |
| 10 | **GradientText** | Text with an animated gradient color flow | `text`, `colors`, `speed`, `className` | React only |
| 11 | **RotatingText** | Words rotate/carousel through a list cyclically | `texts`, `interval`, `className` | `motion` |
| 12 | **ScrambledText** | Text scramble reveal (matrix-like character shuffling) | `text`, `duration`, `chars`, `className` | React only |
| 13 | **ScrollFloat** | Text floats/animate based on scroll position | `text`, `scrollSpeed`, `className` | `motion` |
| 14 | **ScrollReveal** | Text reveals on scroll with customizable animation | `text`, `direction`, `threshold`, `className` | `motion` |
| 15 | **ScrollVelocity** | Text scroll speed linked to velocity of scroll | `text`, `velocity`, `className` | `motion` |
| 16 | **ShinyText** | Shimmer/shine highlight sweeps across text | `text`, `speed`, `className` | React only (CSS) |
| 17 | **Shuffle** | Characters shuffle/rearrange on interaction | `text`, `shuffleSpeed`, `className` | React only |
| 18 | **SplitText** | GSAP-powered text split animation (chars/words/lines) on scroll | `text`, `splitType` ('chars'/'words'/'lines'), `delay`, `duration`, `ease`, `from`, `to`, `threshold`, `rootMargin`, `tag`, `onLetterAnimationComplete` | `gsap`, `@gsap/react`, GSAP SplitText, GSAP ScrollTrigger |
| 19 | **TextCursor** | Typewriter-style blinking cursor after text | `text`, `cursorChar`, `blinkSpeed`, `className` | React only (CSS) |
| 20 | **TextPressure** | Text characters respond to pointer pressure/proximity | `text`, `pressureFactor`, `className` | `motion` |
| 21 | **TextType** | Typewriter effect -- text types out character by character | `text`, `speed`, `showCursor`, `className` | React only |
| 22 | **TrueFocus** | Characters come into focus based on viewport/cursor proximity | `text`, `focusRadius`, `blurAmount`, `className` | `motion` |
| 23 | **VariableProximity** | Text size varies based on mouse proximity to each character | `text`, `minSize`, `maxSize`, `radius`, `className` | `motion` |

---

### Animations (29)

Hover, cursor, scroll-driven, and pointer-interactive animation components.

| # | Component | Purpose | Key Props | Dependencies |
|---|-----------|---------|-----------|--------------|
| 1 | **AnimatedContent** | Content wrapper that animates children on viewport entry | `children`, `animation`, `threshold`, `className` | `motion` |
| 2 | **Antigravity** | Elements float with anti-gravity physics on hover | `children`, `strength`, `className` | `motion` |
| 3 | **BlobCursor** | Cursor replaced by a morphing blob that follows mouse | `color`, `size`, `blobliness`, `className` | `motion` |
| 4 | **ClickSpark** | Particle spark burst at click/tap location | `color`, `particleCount`, `duration`, `className` | React only (canvas) |
| 5 | **Crosshair** | Custom crosshair cursor replacement | `color`, `size`, `thickness`, `className` | React only (CSS) |
| 6 | **Cubes** | 3D rotating cubes animation | `count`, `speed`, `size`, `className` | `three`, `@react-three/fiber`, `@react-three/drei` |
| 7 | **ElectricBorder** | Animated electric/border glow effect around an element | `color`, `speed`, `intensity`, `className` | React only (CSS) |
| 8 | **FadeContent** | Content fades in/out based on scroll position | `children`, `threshold`, `direction`, `className` | `motion` |
| 9 | **GhostCursor** | Ghost/ethereal cursor trail effect | `color`, `size`, `trail`, `className` | React only (canvas) |
| 10 | **GlareHover** | Card glare/light sweep on mouse hover | `children`, `glareColor`, `intensity`, `className` | React only (CSS) |
| 11 | **GradualBlur** | Progressive blur applied to content | `children`, `blurAmount`, `threshold`, `className` | `motion` |
| 12 | **ImageTrail** | Trail of images follows mouse movement | `images`, `trailCount`, `className` | `motion` |
| 13 | **LaserFlow** | Laser/beam flow animation | `color`, `speed`, `className` | React only (canvas/SVG) |
| 14 | **LogoLoop** | Infinite rotating/scrolling logo carousel | `logos`, `speed`, `direction`, `className` | React only |
| 15 | **MagicRings** | Concentric magic ring animations | `count`, `color`, `speed`, `className` | `three`, `@react-three/fiber` |
| 16 | **Magnet** | Elements are attracted to mouse cursor (magnetic effect) | `children`, `padding`, `disabled`, `magnetStrength`, `activeTransition`, `inactiveTransition`, `wrapperClassName`, `innerClassName` | React only |
| 17 | **MagnetLines** | Lines bend toward mouse cursor magnetically | `color`, `lineCount`, `className` | `motion` |
| 18 | **MetaBalls** | Organic gooey metaball blobs (WebGL shader) | `color`, `count`, `speed`, `className` | `ogl` or `three` |
| 19 | **MetallicPaint** | Metallic/iridescent paint shader on elements | `color1`, `color2`, `intensity`, `className` | `three`, `@react-three/fiber` |
| 20 | **Noise** | Perlin/simplex noise overlay effect | `opacity`, `speed`, `scale`, `className` | `three`, shader |
| 21 | **OrbitImages** | Images orbit/rotate around a central point | `images`, `radius`, `speed`, `className` | `motion` |
| 22 | **PixelTrail** | Pixel/firework trail follows cursor | `color`, `particleSize`, `className` | React only (canvas) |
| 23 | **PixelTransition** | Pixel dissolve transition between content states | `children`, `pixelSize`, `duration`, `className` | `gsap` |
| 24 | **Ribbons** | 3D flowing ribbon/tentacle animations (WebGL) | `color`, `count`, `speed`, `className` | `three`, `@react-three/fiber` |
| 25 | **ShapeBlur** | Blur that follows custom SVG shapes | `shapes`, `className` | `motion` |
| 26 | **SplashCursor** | Cursor creates splash/ripple effect | `color`, `rippleSize`, `className` | React only (canvas) |
| 27 | **StarBorder** | Star/glowing border effect around element | `color`, `speed`, `starCount`, `className` | React only (CSS) |
| 28 | **StickerPeel** | Sticker peel-off reveal animation | `children`, `peelDirection`, `className` | `motion` |
| 29 | **TargetCursor** | Target/crosshair cursor with scanning animation | `color`, `size`, `className` | React only (CSS) |

---

### Components (36)

Interactive UI components with built-in animations.

| # | Component | Purpose | Key Props | Dependencies |
|---|-----------|---------|-----------|--------------|
| 1 | **AnimatedList** | List with staggered item entrance animations | `items`, `animation`, `delay`, `className` | `motion` |
| 2 | **BorderGlow** | Container with animated glowing border | `children`, `color`, `speed`, `className` | React only (CSS) |
| 3 | **BounceCards** | Cards bounce on hover with spring physics | `cards`, `springConfig`, `className` | `motion` |
| 4 | **BubbleMenu** | Circular bubble navigation menu | `items`, `bubbleColor`, `className` | `motion` |
| 5 | **CardNav** | Card-based navigation with hover expansion | `items`, `activeItem`, `className` | `motion` |
| 6 | **CardSwap** | Cards swap/transition on interaction | `cards`, `animation`, `className` | `motion` |
| 7 | **Carousel** | Animated image/content carousel | `items`, `autoPlay`, `interval`, `className` | `motion` |
| 8 | **ChromaGrid** | Chromatic color grid with mouse interaction | `rows`, `cols`, `colorScheme`, `className` | `motion` |
| 9 | **CircularGallery** | Images arranged in a 3D circular gallery | `images`, `radius`, `rotationSpeed`, `className` | `three`, `@react-three/fiber` |
| 10 | **Counter** | Animated number counter with formatting | `from`, `to`, `duration`, `prefix`, `suffix`, `className` | `motion` |
| 11 | **DecayCard** | Card that decays/dissolves with particles on hover/interaction | `children`, `decaySpeed`, `className` | `gsap` |
| 12 | **Dock** | macOS-style animated dock with magnification | `items` (icon+label+onClick), `spring`, `magnification`, `distance`, `panelHeight`, `dockHeight`, `baseItemSize` | `motion` |
| 13 | **DomeGallery** | Images displayed on a 3D dome/sphere gallery | `images`, `radius`, `className` | `three`, `@react-three/fiber` |
| 14 | **ElasticSlider** | Slider with elastic/bouncy spring transitions | `slides`, `springConfig`, `className` | `motion` |
| 15 | **FlowingMenu** | Menu items flow with fluid cursor-following animation | `items`, `flowSpeed`, `className` | `motion` |
| 16 | **FluidGlass** | Glassmorphism container with fluid distortion effect | `children`, `blurAmount`, `className` | `motion` |
| 17 | **FlyingPosters** | Posters fly/parallax with 3D perspective on scroll | `posters`, `scrollSpeed`, `className` | `motion` / `gsap` |
| 18 | **Folder** | Animated folder open/close interaction | `children`, `isOpen`, `className` | `motion` |
| 19 | **GlassIcons** | Icon set with glassmorphism style and hover effects | `icons`, `glassIntensity`, `className` | `motion` |
| 20 | **GlassSurface** | Full glass surface with mouse-following highlight | `children`, `intensity`, `className` | `motion` |
| 21 | **GooeyNav** | Navigation with gooey/blobby transition between items | `items`, `gooeyAmount`, `className` | `motion` (SVG filter) |
| 22 | **InfiniteMenu** | Infinite scrolling/rotating menu | `items`, `speed`, `direction`, `className` | `motion` |
| 23 | **Lanyard** | 3D interactive lanyard/card that rotates with mouse | `cardData`, `sensitivity`, `className` | `three`, `@react-three/fiber`, `@react-three/drei` |
| 24 | **MagicBento** | Animated bento grid layout with hover effects | `items`, `layout`, `className` | `motion` |
| 25 | **Masonry** | Masonry/Pinterest-style grid layout with animations | `items`, `columns`, `gap`, `className` | `motion` |
| 26 | **ModelViewer** | 3D model viewer (GLTF/GLB) with orbit controls | `modelPath`, `autoRotate`, `backgroundColor`, `className` | `three`, `@react-three/fiber`, `@react-three/drei` |
| 27 | **PillNav** | Pill-shaped navigation with sliding indicator | `items`, `activeItem`, `className` | `motion` |
| 28 | **PixelCard** | Pixel art style card with scanline/retro effects | `children`, `pixelSize`, `className` | React only (CSS) |
| 29 | **ProfileCard** | Profile/user card component with hover animations | `name`, `role`, `avatar`, `links`, `className` | `motion` |
| 30 | **ReflectiveCard** | Card with reflective/shiny surface effect on hover | `children`, `reflectIntensity`, `className` | `motion` |
| 31 | **ScrollStack** | Cards stack/unstack based on scroll position | `cards`, `stackOffset`, `className` | `motion` / `gsap` ScrollTrigger |
| 32 | **SpotlightCard** | Card with mouse-following spotlight highlight | `children`, `spotlightColor`, `className` | React only (CSS) |
| 33 | **Stack** | Simple card stack component with overlap | `cards`, `offset`, `className` | `motion` |
| 34 | **StaggeredMenu** | Menu items appear with staggered animation | `items`, `staggerDelay`, `className` | `motion` |
| 35 | **Stepper** | Step progress indicator with animated transitions | `steps`, `currentStep`, `orientation`, `className` | `motion` |
| 36 | **TiltedCard** | Card tilts in 3D following mouse position | `children`, `tiltAmount`, `perspective`, `className` | `motion` |

---

### Backgrounds (42)

Full-screen background effects -- many are WebGL shader-based.

| # | Component | Purpose | Key Props | Dependencies |
|---|-----------|---------|-----------|--------------|
| 1 | **Aurora** | Aurora borealis/northern lights effect | `colors`, `speed`, `className` | `three`, `@react-three/fiber` (shader) |
| 2 | **Balatro** | Balatro card game style joker background | `speed`, `className` | `three`, `@react-three/fiber` |
| 3 | **Ballpit** | Physics-based balls bouncing (matter-js powered) | `ballCount`, `colors`, `className` | `matter-js` |
| 4 | **Beams** | Light beams sweeping across background | `color`, `beamCount`, `speed`, `className` | `three`, `@react-three/fiber` |
| 5 | **ColorBends** | Color bending/blending gradient animation | `colors`, `speed`, `className` | `three` (shader) |
| 6 | **DarkVeil** | Dark translucent veil/overlay with noise | `opacity`, `className` | React only (CSS) |
| 7 | **Dither** | Dithering pattern background (Bayer/blue noise) | `pattern`, `scale`, `className` | React only (CSS/canvas) |
| 8 | **DotField** | Responsive dot field that responds to mouse | `dotSize`, `spacing`, `mouseRadius`, `className` | React only (canvas) |
| 9 | **DotGrid** | Static dot grid pattern background | `dotSize`, `spacing`, `color`, `className` | React only (CSS) |
| 10 | **EvilEye** | Evil eye animation -- rotating eye that follows cursor | `pupilColor`, `size`, `className` | React only (CSS/SVG) |
| 11 | **FaultyTerminal** | Glitchy terminal/render background | `glitchIntensity`, `className` | React only (CSS) |
| 12 | **FloatingLines** | Lines float and drift across background | `lineCount`, `speed`, `color`, `className` | `three`, `@react-three/fiber` |
| 13 | **Galaxy** | Galaxy/starfield space background | `starCount`, `speed`, `colors`, `className` | `three`, `@react-three/fiber` |
| 14 | **GradientBlinds** | Vertical gradient blinds/venetian effect | `colors`, `speed`, `className` | React only (CSS) |
| 15 | **Grainient** | Grainy gradient texture background | `colors`, `grainIntensity`, `className` | React only (CSS/canvas) |
| 16 | **GridDistortion** | Grid distorts/twists based on mouse position | `gridSize`, `distortionStrength`, `className` | `three` (shader) |
| 17 | **GridMotion** | Grid cells animate with motion | `gridSize`, `speed`, `className` | `motion` |
| 18 | **GridScan** | Grid with scanning line effect | `gridSize`, `scanSpeed`, `color`, `className` | React only (CSS/canvas) |
| 19 | **Hyperspeed** | Hyperspeed tunnel/warp effect (Three.js + postprocessing) | `effectOptions` (30+ nested props: distortion, roadWidth, lanesPerRoad, fov, speedUp, colors, carLightsFade, etc.) | `three`, `postprocessing` |
| 20 | **Iridescence** | Iridescent color-shifting gradient | `colors`, `speed`, `className` | `three` (shader) |
| 21 | **LetterGlitch** | Letters/characters glitch across background | `text`, `glitchSpeed`, `className` | React only (canvas) |
| 22 | **Lightning** | Animated lightning bolt effects | `boltCount`, `color`, `speed`, `className` | React only (canvas) |
| 23 | **LightPillar** | Vertical light pillar beams | `pillarCount`, `color`, `className` | `three`, `@react-three/fiber` |
| 24 | **LightRays** | Radial light rays emanating from center | `rayCount`, `color`, `speed`, `className` | React only (CSS/canvas) |
| 25 | **LineWaves** | Sine/cosine wave lines across background | `lineCount`, `amplitude`, `frequency`, `className` | React only (SVG/canvas) |
| 26 | **LiquidChrome** | Liquid metal/chrome flowing surface | `color`, `speed`, `className` | `three` (shader) |
| 27 | **LiquidEther** | Ethereal liquid/fluid background | `color`, `flowSpeed`, `className` | `three` (shader) |
| 28 | **Orb** | Glowing orb with particle trail | `color`, `size`, `speed`, `className` | `three`, `@react-three/fiber` |
| 29 | **Particles** | 3D particle system (WebGL via ogl) | `particleCount`, `particleSpread`, `speed`, `particleColors`, `moveParticlesOnHover`, `particleHoverFactor`, `alphaParticles`, `particleBaseSize`, `sizeRandomness`, `cameraDistance`, `disableRotation`, `pixelRatio` | `ogl` |
| 30 | **PixelBlast** | Pixel explosion/firework effect | `pixelCount`, `color`, `className` | React only (canvas) |
| 31 | **PixelSnow** | Pixel snow/rain falling effect | `particleCount`, `speed`, `wind`, `className` | React only (canvas) |
| 32 | **Plasma** | Plasma/lava lamp effect (shader) | `colors`, `speed`, `className` | `three` (shader) |
| 33 | **PlasmaWave** | Plasma wave propagation effect | `colors`, `waveCount`, `speed`, `className` | `three` (shader) |
| 34 | **Prism** | Prism/rainbow light dispersion | `intensity`, `className` | React only (CSS/canvas) |
| 35 | **PrismaticBurst** | Prismatic burst/explosion of color | `colors`, `burstCount`, `className` | `three`, `@react-three/fiber` |
| 36 | **Radar** | Radar/radar screen scanning effect | `scanSpeed`, `color`, `className` | React only (CSS/canvas) |
| 37 | **RippleGrid** | Grid with mouse-ripple water effect | `gridSize`, `rippleStrength`, `className` | `three` (shader) |
| 38 | **ShapeGrid** | Grid of animated shapes | `shapeType`, `gridSize`, `className` | `motion` |
| 39 | **Silk** | Silk/smooth flowing fabric texture | `colors`, `speed`, `className` | `three` (shader) |
| 40 | **SoftAurora** | Softer/muted aurora variant | `colors`, `speed`, `className` | `three`, `@react-three/fiber` |
| 41 | **Threads** | Thread/wire strands floating in 3D | `threadCount`, `color`, `speed`, `className` | `three`, `@react-three/fiber` |
| 42 | **Waves** | Animated wave/water surface effect | `waveCount`, `amplitude`, `frequency`, `color`, `className` | `three` (shader) or SVG |

---

## Installation Notes

### Variant System
Each component comes in **4 variants** per use case:
- `JS-CSS` -- Plain JavaScript + vanilla CSS
- `JS-TW` -- Plain JavaScript + Tailwind CSS classes
- `TS-CSS` -- TypeScript + vanilla CSS
- `TS-TW` -- TypeScript + Tailwind CSS classes

### CLI Usage
```bash
# Component name format: @react-bits/<ComponentName>-<JS|TS>-<CSS|TW>
npx shadcn@latest add @react-bits/BlurText-TS-TW   # TypeScript + Tailwind
npx shadcn@latest add @react-bits/SplitText-JS-CSS  # JavaScript + CSS
```

### Manual Copy
1. Browse https://reactbits.dev
2. Select a component
3. Choose your variant from the tabs
4. Copy the source code into your project
5. Install any per-component dependencies listed above

---

## Key Dependencies by Usage Frequency

| Dependency | Used By | Purpose |
|------------|---------|---------|
| `motion` (Motion) | ~70 components | Spring animations, gestures, scroll transforms |
| `react` (useRef, useEffect, useState) | All components | Core React hooks |
| `three` | ~25 components | WebGL 3D rendering |
| `@react-three/fiber` | ~15 components | React renderer for Three.js |
| `@react-three/drei` | ~10 components | Three.js utilities (OrbitControls, etc.) |
| `ogl` | ~5 components | Lightweight WebGL (Particles, MetaBalls) |
| `gsap` / `@gsap/react` | ~5 components | Advanced timeline animation, SplitText, ScrollTrigger |
| `postprocessing` | ~2 components | Post-processing effects (Hyperspeed) |
| `matter-js` | ~1 component | 2D physics (Ballpit) |
| `clsx` | ~30 components | Conditional class name merging |
| `lenis` | Used with backgrounds | Smooth scrolling |

---

## Creative Tools (Built into reactbits.dev)

| Tool | Purpose |
|------|---------|
| **Background Studio** | Explore & customize animated backgrounds, export as video/image/code |
| **Shape Magic** | Create inner rounded corners between shapes, export SVG/React code/clip-path |
| **Texture Lab** | Apply 20+ effects (noise, dithering, ASCII) to images/videos, export high quality |
