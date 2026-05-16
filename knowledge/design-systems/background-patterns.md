# Background Patterns & Textures — Premium CSS Visuals

CSS-only patterns, noise textures, mesh gradients, geometric backgrounds, and animated backdrops for premium UI depth.

---

## 1. CSS-Only Repeating Patterns

### Dot Grid (subtle, SaaS)
```css
.bg-dots {
  background-image: radial-gradient(circle, rgba(0,0,0,0.1) 1px, transparent 1px);
  background-size: 20px 20px;
}

/* Dark mode */
[data-theme='dark'] .bg-dots {
  background-image: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
}
```

### Grid + Dots (notebook/blueprint feel)
```css
.bg-grid-dots {
  background-image:
    radial-gradient(circle, rgba(0,0,0,0.15) 0.5px, transparent 0.5px),
    linear-gradient(rgba(0,0,0,0.04) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,0,0,0.04) 1px, transparent 1px);
  background-size: 24px 24px, 24px 24px, 24px 24px;
  background-position: 0 0, 0 0, 0 0;
}
```

### Stripes (diagonal, dynamic)
```css
.bg-stripes {
  background: repeating-linear-gradient(
    45deg,
    transparent,
    transparent 5px,
    rgba(var(--primary-rgb), 0.05) 5px,
    rgba(var(--primary-rgb), 0.05) 10px
  );
}

.bg-stripes-vertical {
  background: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 40px,
    rgba(var(--foreground-rgb), 0.03) 40px,
    rgba(var(--foreground-rgb), 0.03) 41px
  );
}
```

### Chevron (energetic, sporty)
```css
.bg-chevron {
  --size: 40px;
  background: repeating-linear-gradient(
    45deg,
    transparent,
    transparent calc(var(--size) / 4),
    rgba(var(--primary-rgb), 0.08) calc(var(--size) / 4),
    rgba(var(--primary-rgb), 0.08) calc(var(--size) / 2),
    transparent calc(var(--size) / 2),
    transparent calc(var(--size) * 3 / 4),
    rgba(var(--primary-rgb), 0.08) calc(var(--size) * 3 / 4),
    rgba(var(--primary-rgb), 0.08) var(--size)
  );
  background-size: var(--size) var(--size);
}
```

### Crosshatch (artisanal, textured)
```css
.bg-crosshatch {
  background-image:
    repeating-linear-gradient(0deg, transparent, transparent 3px, rgba(0,0,0,0.03) 3px, rgba(0,0,0,0.03) 4px),
    repeating-linear-gradient(90deg, transparent, transparent 3px, rgba(0,0,0,0.03) 3px, rgba(0,0,0,0.03) 4px);
}
```

### Zigzag (playful, kids/brands)
```css
.bg-zigzag {
  --size: 30px;
  background:
    linear-gradient(135deg, rgba(var(--primary-rgb), 0.06) 25%, transparent 25%) -10px 0,
    linear-gradient(225deg, rgba(var(--primary-rgb), 0.06) 25%, transparent 25%) -10px 0,
    linear-gradient(315deg, rgba(var(--primary-rgb), 0.06) 25%, transparent 25%),
    linear-gradient(45deg, rgba(var(--primary-rgb), 0.06) 25%, transparent 25%);
  background-size: var(--size) var(--size);
}
```

---

## 2. Noise & Grain Textures

### SVG Noise Filter (reusable)
```html
<svg class="hidden">
  <filter id="noise">
    <feTurbulence type="fractalNoise" baseFrequency="0.65" numOctaves="3" stitchTiles="stitch"/>
    <feColorMatrix type="saturate" values="0"/>
    <feBlend in="SourceGraphic" mode="multiply"/>
  </filter>
</svg>
```

```css
/* Apply noise overlay */
.bg-noise {
  position: relative;
}
.bg-noise::after {
  content: '';
  position: absolute;
  inset: 0;
  opacity: 0.04;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
  background-size: 256px;
  pointer-events: none;
}
```

### CSS Grain (no external image needed)
```css
.bg-grain-css {
  position: relative;
}
.bg-grain-css::after {
  content: '';
  position: absolute;
  inset: -50%;
  width: 200%;
  height: 200%;
  background: repeating-conic-gradient(
    rgba(0,0,0,0.01) 0% 15%,
    transparent 15% 30%
  );
  animation: grain 0.5s steps(5) infinite;
  pointer-events: none;
}
@keyframes grain {
  0%, 100% { transform: translate(0, 0); }
  10% { transform: translate(-1%, -1%); }
  30% { transform: translate(1%, 2%); }
  50% { transform: translate(-2%, 1%); }
  70% { transform: translate(2%, -1%); }
  90% { transform: translate(-1%, -2%); }
}
```

### Paper Texture
```css
.bg-paper {
  background-color: #faf7f2;
  background-image:
    url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='paper'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.04' numOctaves='5' result='noise'/%3E%3CfeColorMatrix type='saturate' values='0' in='noise' result='gray'/%3E%3CfeComponentTransfer in='gray' result='alpha'%3E%3CfeFuncA type='linear' slope='0.06'/%3E%3C/feComponentTransfer%3E%3C/filter%3E%3Crect width='100' height='100' filter='url(%23paper)'/%3E%3C/svg%3E");
}
```

---

## 3. Mesh Gradients (2024+ trend)

### Static Mesh Gradient
```css
.bg-mesh {
  background:
    radial-gradient(at 0% 0%, rgba(var(--primary-rgb), 0.15) 0px, transparent 50%),
    radial-gradient(at 100% 0%, rgba(var(--secondary-rgb), 0.1) 0px, transparent 50%),
    radial-gradient(at 0% 100%, rgba(var(--accent-rgb), 0.1) 0px, transparent 50%),
    radial-gradient(at 100% 100%, rgba(var(--primary-rgb), 0.15) 0px, transparent 50%);
}
```

### Animated Mesh Gradient
```css
.bg-mesh-animated {
  background:
    radial-gradient(at 30% 50%, rgba(99, 102, 241, 0.15) 0px, transparent 50%),
    radial-gradient(at 70% 30%, rgba(236, 72, 153, 0.1) 0px, transparent 50%),
    radial-gradient(at 50% 80%, rgba(34, 197, 94, 0.1) 0px, transparent 50%),
    radial-gradient(at 80% 60%, rgba(251, 146, 60, 0.12) 0px, transparent 50%);
  animation: mesh-shift 15s ease-in-out infinite alternate;
}
@keyframes mesh-shift {
  0% { background-position: 0% 0%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 100%; }
}
```

### Aurora Gradient (figma-style)
```css
.bg-aurora {
  background:
    radial-gradient(ellipse 80% 60% at 50% -20%, rgba(120, 119, 198, 0.3), transparent),
    radial-gradient(ellipse 80% 60% at 50% 120%, rgba(255, 140, 160, 0.2), transparent),
    radial-gradient(ellipse 80% 50% at 80% 50%, rgba(120, 200, 230, 0.15), transparent),
    radial-gradient(ellipse 80% 50% at 20% 50%, rgba(180, 140, 255, 0.15), transparent);
}
```

---

## 4. Geometric CSS Backgrounds

### Hexagon Grid
```css
.bg-hexagons {
  --s: 50px;  /* size */
  --m: 2px;   /* margin */
  --c: rgba(var(--primary-rgb), 0.06);

  background:
    conic-gradient(from 120deg at calc(50% + var(--m)) calc(100% * 2 / 3 - var(--m) / 2), var(--c) 0 60deg, transparent 0),
    conic-gradient(from -60deg at calc(50% - var(--m)) calc(100% * 1 / 3 - var(--m) / 2), var(--c) 0 60deg, transparent 0);
  background-size: calc(var(--s) + 2 * var(--m)) calc(var(--s) * 1.732 / 2);
}
```

### Triangles (geometric, tech)
```css
.bg-triangles {
  --s: 60px;
  background:
    conic-gradient(at 0 100%, transparent 75%, rgba(var(--primary-rgb), 0.06) 0) 0 calc(var(--s) / 2),
    conic-gradient(at 100% 100%, transparent 75%, rgba(var(--secondary-rgb), 0.04) 0) var(--s) calc(var(--s) / 2),
    conic-gradient(at 50% 0, transparent 75%, rgba(var(--accent-rgb), 0.04) 0);
  background-size: calc(var(--s) * 2) var(--s);
}
```

### Concentric Circles (hypnotic, brand)
```css
.bg-concentric {
  background:
    repeating-radial-gradient(
      circle at 50% 50%,
      transparent 0,
      transparent 19px,
      rgba(var(--primary-rgb), 0.04) 19px,
      rgba(var(--primary-rgb), 0.04) 20px
    );
}
```

### Isometric Grid (3D feel, illustrator)
```css
.bg-isometric {
  background:
    linear-gradient(30deg, rgba(var(--primary-rgb), 0.04) 1px, transparent 1px),
    linear-gradient(-30deg, rgba(var(--primary-rgb), 0.04) 1px, transparent 1px),
    linear-gradient(90deg, rgba(var(--primary-rgb), 0.03) 1px, transparent 1px);
  background-size: 40px 70px, 40px 70px, 40px 70px;
}
```

---

## 5. Gradient Orbs / Blobs

### Floating Blob Component
```tsx
function BackgroundBlobs() {
  return (
    <div className="fixed inset-0 -z-10 overflow-hidden" aria-hidden="true">
      <div className="absolute -top-40 -right-40 w-[600px] h-[600px] rounded-full
        bg-gradient-to-br from-primary/10 via-primary/5 to-transparent
        blur-3xl animate-float-slow" />
      <div className="absolute -bottom-40 -left-40 w-[500px] h-[500px] rounded-full
        bg-gradient-to-tr from-secondary/10 via-secondary/5 to-transparent
        blur-3xl animate-float-slower" />
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[400px] h-[400px] rounded-full
        bg-gradient-to-tl from-accent/8 to-transparent
        blur-3xl animate-float" />
    </div>
  );
}
```

### Morphing Blob (SVG filter)
```tsx
function MorphingBlob({ className }: { className?: string }) {
  return (
    <div className={`absolute inset-0 -z-10 overflow-hidden ${className}`} aria-hidden="true">
      <svg viewBox="0 0 800 600" className="w-full h-full">
        <filter id="goo">
          <feGaussianBlur in="SourceGraphic" stdDeviation="40" result="blur" />
          <feColorMatrix in="blur" mode="matrix"
            values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 30 -10"
            result="goo" />
        </filter>
        <g filter="url(#goo)">
          <circle cx="300" cy="200" r="120" fill="rgba(99,102,241,0.15)">
            <animate attributeName="cx" values="300;450;300" dur="8s" repeatCount="indefinite" />
            <animate attributeName="cy" values="200;300;200" dur="6s" repeatCount="indefinite" />
            <animate attributeName="r" values="120;150;120" dur="10s" repeatCount="indefinite" />
          </circle>
          <circle cx="500" cy="400" r="100" fill="rgba(139,92,246,0.12)">
            <animate attributeName="cx" values="500;350;500" dur="7s" repeatCount="indefinite" />
            <animate attributeName="cy" values="400;250;400" dur="9s" repeatCount="indefinite" />
            <animate attributeName="r" values="100;130;100" dur="8s" repeatCount="indefinite" />
          </circle>
          <circle cx="200" cy="350" r="90" fill="rgba(236,72,153,0.1)">
            <animate attributeName="cx" values="200;350;200" dur="9s" repeatCount="indefinite" />
            <animate attributeName="cy" values="350;200;350" dur="7s" repeatCount="indefinite" />
          </circle>
        </g>
      </svg>
    </div>
  );
}
```

---

## 6. Hero Section Backgrounds

### Gradient + Noise Hero
```css
.hero-gradient-noise {
  background:
    linear-gradient(180deg, rgba(var(--primary-rgb), 0.05) 0%, transparent 100%),
    linear-gradient(135deg, rgba(var(--accent-rgb), 0.06) 0%, transparent 50%);
  position: relative;
}
.hero-gradient-noise::after {
  content: '';
  position: absolute; inset: 0;
  opacity: 0.03;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.75' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
  pointer-events: none;
}
```

### Spotlight Gradient (focus attention)
```css
.bg-spotlight {
  background:
    radial-gradient(ellipse 80% 80% at 50% 0%, rgba(var(--primary-rgb), 0.08), transparent),
    radial-gradient(ellipse 60% 60% at 50% 50%, rgba(var(--secondary-rgb), 0.04), transparent);
}
```

### Grid + Gradient Overlay
```css
.hero-grid-gradient {
  background:
    linear-gradient(180deg, var(--color-background) 0%, transparent 20%, transparent 80%, var(--color-background) 100%),
    linear-gradient(90deg, rgba(var(--primary-rgb), 0.03) 1px, transparent 1px),
    linear-gradient(rgba(var(--primary-rgb), 0.03) 1px, transparent 1px);
  background-size: 100% 100%, 60px 60px, 60px 60px;
}
```

---

## 7. Animated Backgrounds

### Moving Gradient
```css
.bg-gradient-move {
  background: linear-gradient(
    270deg,
    var(--color-primary),
    var(--color-secondary),
    var(--color-accent),
    var(--color-primary)
  );
  background-size: 400% 400%;
  animation: gradient-shift 20s ease infinite;
}
@keyframes gradient-shift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}
```

### Parallax Dots (subtle movement)
```tsx
function ParallaxDots() {
  const { scrollY } = useScroll();
  const y = useTransform(scrollY, [0, 1000], [0, 200]);

  return (
    <motion.div
      className="fixed inset-0 -z-10 opacity-20"
      style={{ y }}
      aria-hidden="true"
    >
      <div className="absolute inset-0 bg-dots" />
    </motion.div>
  );
}
```

### Starfield (dark mode sci-fi)
```css
.bg-starfield {
  background:
    radial-gradient(1px 1px at 20px 30px, rgba(255,255,255,0.3), transparent),
    radial-gradient(1px 1px at 40px 70px, rgba(255,255,255,0.2), transparent),
    radial-gradient(1.5px 1.5px at 90px 40px, rgba(255,255,255,0.2), transparent),
    radial-gradient(1px 1px at 130px 80px, rgba(255,255,255,0.15), transparent),
    radial-gradient(1px 1px at 160px 30px, rgba(255,255,255,0.25), transparent);
  background-size: 200px 100px;
  animation: twinkle 4s ease-in-out infinite alternate;
}
@keyframes twinkle {
  0% { opacity: 0.7; }
  100% { opacity: 1; }
}
```

---

## 8. Pattern Composition Utilities

```css
/* Stack multiple patterns */
.bg-layered {
  background:
    /* Top: gradient overlay */
    linear-gradient(180deg, rgba(var(--primary-rgb), 0.04) 0%, transparent 50%),
    /* Middle: dots pattern */
    radial-gradient(circle, rgba(var(--foreground-rgb), 0.06) 1px, transparent 1px);
  background-size: 100% 100%, 24px 24px;
}

/* Fade pattern to solid at edges */
.bg-pattern-fade {
  mask-image: linear-gradient(
    to bottom,
    transparent 0%,
    black 10%,
    black 90%,
    transparent 100%
  );
}
```

---

## 9. Quick Reference — Pattern by Mood

| Mood | Pattern | CSS Class |
|------|---------|-----------|
| **Subtle SaaS** | Dot grid | `.bg-dots` |
| **Data/Tech** | Grid + dots | `.bg-grid-dots` |
| **Energetic** | Chevron | `.bg-chevron` |
| **Artisanal** | Crosshatch | `.bg-crosshatch` |
| **Luxury** | Aurora + noise | `.bg-aurora` + `.bg-noise` |
| **Modern** | Mesh gradient | `.bg-mesh` |
| **Playful** | Zigzag | `.bg-zigzag` |
| **3D/Depth** | Isometric grid | `.bg-isometric` |
| **Dark mode** | Starfield | `.bg-starfield` |
| **Creative** | Morphing blobs | `<MorphingBlob />` |

---

## 10. Performance Notes

```
✓ CSS-only patterns: GPU-friendly, zero JS, instant render
✓ SVG noise <filter>: composited on GPU, use opacity sparingly
⚠ Animated gradients: trigger paint on every frame — use will-change
⚠ Morphing blobs: SVG filters are expensive — use one per page max
❌ Heavy box-shadow patterns: trigger layout — avoid
❌ baseFrequency > 1.0 on noise: shader-heavy on mobile — keep ≤ 0.8

Rule: Test on low-end Android (Moto G4) — if 30+ fps, ship it.
```
