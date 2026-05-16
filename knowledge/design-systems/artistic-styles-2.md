# Artistic Styles — Batch 2 (8 More Premium Visual Directions)

Continues `artistic-styles.md`. Each style layers onto a base design system (A/B/C).

---

## Style 9: Scandinavian Minimal (北欧极简)

Clean, functional, light. Pale wood tones, whitespace reverence, hygge warmth. Form follows function with softness.

**Mood:** Calm, trustworthy, airy, functional

```
Color Palette:
  Background:  #fafaf8  snow white
  Surface:     #f5f3ef  light birch
  Foreground:  #2d2a26  warm charcoal
  Primary:     #7c9a8e  sage green
  Secondary:   #c4a882  light oak
  Accent:      #e8a87c  terracotta
  Muted:       #a8a098  stone grey

Materials: light wood, linen, matte ceramic, wool
Shapes: rounded rectangles (8-12px radius), no sharp corners
Shadows: very subtle, barely visible — max 4px blur
Borders: thin, 1px, low contrast — almost invisible
```

```css
.scandi-card {
  background: #f5f3ef;
  border-radius: 12px;
  border: 1px solid rgba(0, 0, 0, 0.04);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
  transition: box-shadow 0.3s ease;
}
.scandi-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
}

.scandi-button {
  background: #7c9a8e;
  color: white;
  border: none;
  border-radius: 8px;
  padding: 12px 28px;
  font-weight: 500;
  letter-spacing: 0.02em;
  transition: background 0.2s, transform 0.2s;
}
.scandi-button:hover {
  background: #6b8a7e;
  transform: translateY(-1px);
}

/* Subtle divider — not a line, just whitespace */
.scandi-divider {
  height: 1px;
  background: rgba(0, 0, 0, 0.04);
  margin: 3rem 0;
}
```

```tsx
function ScandiRecipeCard({ recipe }: { recipe: Recipe }) {
  return (
    <article className="scandi-card p-6 group cursor-pointer">
      <div className="aspect-[4/3] overflow-hidden rounded-lg mb-4 bg-stone/10">
        <img
          src={recipe.image}
          alt={recipe.title}
          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700"
        />
      </div>
      <span className="text-xs uppercase tracking-widest text-sage font-medium">
        {recipe.category}
      </span>
      <h3 className="text-xl font-light mt-2 tracking-tight text-charcoal">
        {recipe.title}
      </h3>
      <div className="flex gap-6 mt-3 text-sm text-stone">
        <span className="flex items-center gap-1">
          <span className="w-1 h-1 rounded-full bg-sage inline-block" />
          {recipe.cookTime} min
        </span>
        <span>{recipe.calories} kcal</span>
      </div>
    </article>
  );
}
```

**Typography:** Swiss Modernist (Space Grotesk + DM Sans) — clean geometric matches the functional aesthetic. Nature Organic for softer variant.

**Best for:** Meal kit delivery, nutrition tracking apps, clean-eating blogs, Scandinavian cooking

**Compatibility:** Best with B (shadcn专业). Works with A (动森) for a softer take.

---

## Style 10: Cyberpunk (赛博朋克)

High-tech, low-life. Neon on black, data rain, holographic interfaces, augmented reality overlays. Dense information aesthetic.

**Mood:** Rebellious, technological, intense, underground

```
Color Palette:
  Background:  #0a0a0f  void black
               #0d1117  terminal black
  Surface:     rgba(0, 255, 65, 0.03)  hologram green tint
  Foreground:  #c0ffc0  phosphor green
  Primary:     #00ff41  terminal green
  Secondary:   #ff006e  neon magenta
  Accent:      #00d4ff  cyan
  Warning:     #ffcc00  amber
  Danger:      #ff3333  red alert

Effects: scanlines, CRT flicker, data rain, hologram glow, chromatic aberration
```

```css
.cyberpunk-bg {
  background: #0a0a0f;
  background-image:
    radial-gradient(ellipse at 50% 0%, rgba(0, 255, 65, 0.03), transparent 70%),
    linear-gradient(0deg, transparent 49%, rgba(0, 255, 65, 0.02) 50%, transparent 51%);
  background-size: 100% 100%, 100% 4px;
}

/* Scanline overlay */
.cyberpunk-scanlines::after {
  content: '';
  position: absolute;
  inset: 0;
  background: repeating-linear-gradient(
    0deg,
    transparent,
    transparent 2px,
    rgba(0, 0, 0, 0.03) 2px,
    rgba(0, 0, 0, 0.03) 4px
  );
  pointer-events: none;
}

.cyberpunk-card {
  background: rgba(0, 255, 65, 0.03);
  border: 1px solid rgba(0, 255, 65, 0.2);
  border-radius: 0;
  box-shadow:
    0 0 10px rgba(0, 255, 65, 0.05),
    inset 0 0 10px rgba(0, 255, 65, 0.02);
  clip-path: polygon(
    0 10px, 10px 0, 100% 0, 100% calc(100% - 10px),
    calc(100% - 10px) 100%, 0 100%
  );
}

.neon-text-green {
  color: #00ff41;
  text-shadow:
    0 0 5px #00ff41,
    0 0 10px #00ff4180;
}

/* Hologram flicker animation */
@keyframes hologramFlicker {
  0%, 100% { opacity: 1; }
  92% { opacity: 1; }
  93% { opacity: 0.8; }
  94% { opacity: 1; }
  96% { opacity: 0.9; }
  97% { opacity: 1; }
}

.hologram {
  animation: hologramFlicker 3s infinite;
}

/* Glitch text effect */
.glitch-text {
  position: relative;
  color: #00ff41;
}
.glitch-text::before,
.glitch-text::after {
  content: attr(data-text);
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 0.8;
}
.glitch-text::before {
  color: #ff006e;
  z-index: -1;
  animation: glitchShift 0.3s infinite reverse;
}
.glitch-text::after {
  color: #00d4ff;
  z-index: -2;
  animation: glitchShift 0.5s infinite;
}

@keyframes glitchShift {
  0% { transform: translate(0); }
  20% { transform: translate(-2px, 2px); }
  40% { transform: translate(2px, -1px); }
  60% { transform: translate(-1px, -1px); }
  80% { transform: translate(1px, 2px); }
  100% { transform: translate(0); }
}

/* Data rain (CSS-only) */
.data-rain {
  position: relative;
  overflow: hidden;
}
.data-rain::before {
  content: '';
  position: absolute;
  inset: 0;
  background: repeating-linear-gradient(
    0deg,
    transparent,
    transparent 20px,
    rgba(0, 255, 65, 0.03) 20px,
    rgba(0, 255, 65, 0.03) 22px
  );
  animation: dataRain 1s linear infinite;
}

@keyframes dataRain {
  0% { transform: translateY(-22px); }
  100% { transform: translateY(0); }
}
```

```tsx
function CyberpunkDashboard() {
  return (
    <div className="cyberpunk-bg min-h-screen p-8 cyberpunk-scanlines relative">
      {/* HUD corners */}
      <div className="fixed top-4 left-4 text-xs font-mono" style={{ color: '#00ff41' }}>
        SYS::ONLINE // NODE-7F
      </div>
      <div className="fixed top-4 right-4 text-xs font-mono" style={{ color: '#00ff41' }}>
        <span className="animate-pulse">●</span> LIVE
      </div>

      <div className="relative z-10 max-w-6xl mx-auto">
        <h1 className="glitch-text text-5xl font-mono font-bold mb-8" data-text="NUTRITION_MATRIX">
          NUTRITION_MATRIX
        </h1>

        <div className="grid grid-cols-3 gap-4">
          <div className="cyberpunk-card p-6">
            <div className="text-xs font-mono mb-2 opacity-50" style={{ color: '#00ff41' }}>
              {'>'} CALORIC_INTAKE
            </div>
            <div className="text-4xl font-mono font-bold neon-text-green">
              1,850
            </div>
            <div className="text-xs font-mono mt-1 opacity-50" style={{ color: '#ffcc00' }}>
              STATUS: OPTIMAL
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
```

**Typography:** Mono Technical (Geist Mono + Inter) — terminal aesthetic. Glass Futurism for titles.

**Best for:** Gaming food apps, futuristic meal planning, tech-forward nutrition trackers

**Compatibility:** Best with C (玻璃拟态) dark variant. Clashes with A (动森).

---

## Style 11: Vaporwave (蒸汽波)

Surreal nostalgia. Greek statues, magenta-cyan gradients, tropical plants, glitch art, Japanese text overlays. Internet dreamscape.

**Mood:** Nostalgic, surreal, ironic, dreamy

```
Color Palette:
  Background:  #1a1a3e  deep purple
  Surface:     rgba(255, 113, 206, 0.05)  pink tint
  Foreground:  #ffddee  soft pink-white
  Primary:     #ff71ce  hot pink
  Secondary:   #01cdfe  cyan
  Accent:      #b967ff  lavender
  Gold:        #fffb96  pastel yellow

Key motifs: Greek statue silhouettes, wireframe sun, grid floor, palm trees, Japanese text
```

```css
.vaporwave-bg {
  background:
    linear-gradient(180deg, #1a1a3e 0%, #2d1b4e 30%, #3d1a4e 60%, #1a1a3e 100%);
}

.vaporwave-sun {
  background: linear-gradient(180deg, #ff71ce 0%, #fffb96 40%, #01cdfe 70%, #1a1a3e 100%);
  border-radius: 50%;
  position: relative;
}

/* Chrome text (gradient + reflection) */
.chrome-text {
  background: linear-gradient(180deg,
    #ff71ce 0%,
    #fffb96 30%,
    #01cdfe 60%,
    #ff71ce 100%
  );
  background-size: 100% 200%;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: chromeShift 4s ease-in-out infinite;
}

@keyframes chromeShift {
  0%, 100% { background-position: 0% 0%; }
  50% { background-position: 0% 100%; }
}

/* Glitch block (colored rectangles offset) */
.vaporwave-glitch {
  position: relative;
}
.vaporwave-glitch::after {
  content: '';
  position: absolute;
  left: 4px;
  top: 0;
  width: 100%;
  height: 2px;
  background: #ff71ce;
  opacity: 0.6;
  animation: vaporwaveBar 2s ease-in-out infinite;
}

@keyframes vaporwaveBar {
  0%, 100% { transform: translateY(0); opacity: 0; }
  10% { opacity: 0.6; }
  30% { transform: translateY(20px); opacity: 0; }
}

.vaporwave-card {
  background: rgba(255, 113, 206, 0.05);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(1, 205, 254, 0.15);
  border-radius: 4px;
  position: relative;
  overflow: hidden;
}

/* Grid overlay */
.vaporwave-card::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    linear-gradient(90deg, rgba(1, 205, 254, 0.03) 1px, transparent 1px),
    linear-gradient(0deg, rgba(1, 205, 254, 0.03) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none;
}
```

```tsx
function VaporwaveHero() {
  return (
    <div className="vaporwave-bg relative min-h-screen overflow-hidden flex items-center justify-center">
      {/* Sun */}
      <div className="vaporwave-sun absolute top-[15%] left-1/2 -translate-x-1/2 w-80 h-80 opacity-60" />

      {/* Grid floor */}
      <div className="absolute bottom-0 inset-x-0 h-[40%]"
        style={{
          background: `
            linear-gradient(90deg, rgba(1,205,254,0.05) 1px, transparent 1px),
            linear-gradient(0deg, rgba(1,205,254,0.05) 1px, transparent 1px)
          `,
          backgroundSize: '60px 60px',
          transform: 'perspective(500px) rotateX(45deg)',
          transformOrigin: 'bottom center',
        }}
      />

      {/* Content */}
      <div className="relative z-10 text-center">
        <p className="text-xs tracking-[0.5em] uppercase mb-4 opacity-50"
          style={{ color: '#01cdfe' }}>
          未来の料理
        </p>
        <h1 className="chrome-text text-7xl font-display font-bold tracking-tight mb-8">
          Digital Kitchen
        </h1>
        <div className="vaporwave-card inline-block px-8 py-4">
          <span className="text-lg opacity-70" style={{ color: '#ffddee' }}>
            Enter the dreamscape
          </span>
        </div>
      </div>
    </div>
  );
}
```

**Typography:** Glass Futurism (Clash Display + Satoshi) or Fashion Runway (Bodoni Moda + Montserrat)

**Best for:** Music-themed food brands, Gen-Z restaurant concepts, ironic/artsy cooking content

**Compatibility:** Best with C (玻璃拟态). Complete clash with A (动森).

---

## Style 12: Memphis Design (孟菲斯)

80s postmodern rebellion. Squiggles, geometric shapes, bold clashing colors, terrazzo patterns. Playful maximalism.

**Mood:** Energetic, playful, irreverent, creative

```
Color Palette:
  Background:  #f5f0eb  warm off-white (let shapes pop)
  Surface:     #ffffff
  Foreground:  #1a1a2e  dark navy
  Primary:     #ff6b6b  coral red
  Secondary:   #4ecdc4  teal
  Accent-1:    #ffe66d  yellow
  Accent-2:    #a29bfe  lavender
  Accent-3:    #fd79a8  pink
  Black:       #2d3436

Shapes: squiggles, dots, triangles, zigzags — never straight lines alone
Patterns: terrazzo speckle, geometric repeat, wavy stripes
```

```css
.memphis-bg {
  background-color: #f5f0eb;
  background-image:
    radial-gradient(circle, #ff6b6b 2px, transparent 2px),
    radial-gradient(circle, #4ecdc4 3px, transparent 3px),
    radial-gradient(circle, #ffe66d 2px, transparent 2px);
  background-size: 60px 60px, 90px 90px, 70px 70px;
  background-position: 0 0, 30px 20px, 15px 45px;
}

/* Squiggle divider */
.memphis-squiggle {
  height: 24px;
  background: repeating-linear-gradient(
    90deg,
    transparent,
    transparent 8px,
    #ff6b6b 8px,
    #ff6b6b 12px,
    transparent 12px,
    transparent 20px,
    #4ecdc4 20px,
    #4ecdc4 24px
  );
  background-size: 44px 100%;
  animation: squiggleMove 2s linear infinite;
}

@keyframes squiggleMove {
  0% { background-position: 0 0; }
  100% { background-position: 44px 0; }
}

.memphis-card {
  background: white;
  border: 3px solid #2d3436;
  border-radius: 0;
  position: relative;
  box-shadow: 8px 8px 0 rgba(45, 52, 54, 0.1);
}

/* Decorative corner triangle */
.memphis-card::before {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  width: 0;
  height: 0;
  border-left: 30px solid transparent;
  border-top: 30px solid #ff6b6b;
}

/* Polka dot overlay */
.memphis-dots {
  background-image: radial-gradient(circle, #4ecdc4 1.5px, transparent 1.5px);
  background-size: 16px 16px;
}
```

```tsx
function MemphisRecipeCard({ recipe }: { recipe: Recipe }) {
  return (
    <div className="memphis-card p-0 overflow-hidden group">
      {/* Image with squiggle border */}
      <div className="relative">
        <img
          src={recipe.image}
          alt={recipe.title}
          className="w-full h-48 object-cover"
        />
        <div className="memphis-squiggle absolute -bottom-3 inset-x-0" />
      </div>

      <div className="p-6 pt-6">
        {/* Category pill */}
        <div className="inline-block px-3 py-1 text-xs font-bold uppercase border-2 border-coral bg-yellow/20 mb-3"
          style={{ borderColor: '#ff6b6b', backgroundColor: 'rgba(255,230,109,0.2)' }}>
          {recipe.category}
        </div>

        <h3 className="text-xl font-black uppercase tracking-tight mb-3" style={{ color: '#2d3436' }}>
          {recipe.title}
        </h3>

        {/* Decorative dots */}
        <div className="memphis-dots h-2 mb-3" />

        <div className="flex gap-4 font-mono text-sm" style={{ color: '#2d3436' }}>
          <span>{recipe.cookTime} MIN</span>
          <span>{recipe.calories} KCAL</span>
        </div>
      </div>
    </div>
  );
}
```

**Typography:** Neo-Brutalist Bold (Bebas Neue + Inter) — matches the bold energy. Art Deco Geometric for a more refined take.

**Best for:** Quirky food startups, youth-oriented cooking apps, creative food magazines

**Compatibility:** Best with B (shadcn) or standalone. Clashes with A (动森) warm tones.

---

## Style 13: Bauhaus (包豪斯)

Form follows function. Geometric purity, primary colors (red/blue/yellow), circles and rectangles. The original design system.

**Mood:** Rational, timeless, artistic, disciplined

```
Color Palette:
  Background:  #f8f6f0  cream paper
  Surface:     #ffffff
  Foreground:  #1a1a1a  black
  Primary:     #e03c31  bauhaus red
  Secondary:   #0050a0  bauhaus blue
  Accent:      #ffc845  bauhaus yellow
  Shape:       #1a1a1a  black (for lines, circles, rectangles)

Geometry: circles, rectangles, triangles — no curves, no gradients
Typography: geometric sans-serif, asymmetric layouts
```

```css
.bauhaus-card {
  background: #f8f6f0;
  border: 2px solid #1a1a1a;
  border-radius: 0;
  position: relative;
  overflow: hidden;
}

/* Floating geometric decoration */
.bauhaus-circle {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  border: 3px solid #e03c31;
  position: absolute;
}

.bauhaus-rect {
  width: 40px;
  height: 20px;
  background: #0050a0;
  position: absolute;
}

.bauhaus-triangle {
  width: 0;
  height: 0;
  border-left: 20px solid transparent;
  border-right: 20px solid transparent;
  border-bottom: 35px solid #ffc845;
}

/* Bauhaus button — pure geometry */
.bauhaus-button {
  display: inline-block;
  padding: 12px 32px;
  border: 2px solid #1a1a1a;
  background: transparent;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  position: relative;
  transition: background 0.2s, color 0.2s;
}
.bauhaus-button:hover {
  background: #1a1a1a;
  color: #f8f6f0;
}

/* Red circle accent */
.bauhaus-button::after {
  content: '';
  position: absolute;
  top: -6px;
  right: -6px;
  width: 12px;
  height: 12px;
  background: #e03c31;
  border-radius: 50%;
}
```

```tsx
function BauhausLayout() {
  return (
    <div className="min-h-screen bg-cream relative p-12">
      {/* Decorative geometry */}
      <div className="bauhaus-circle absolute top-20 left-12 opacity-30" />
      <div className="bauhaus-circle absolute top-40 left-32 w-20 h-20 border-yellow opacity-40"
        style={{ borderColor: '#ffc845' }} />
      <div className="bauhaus-rect absolute top-24 right-20 w-16 h-16 !w-24 !h-10"
        style={{ background: '#e03c31' }} />

      {/* Asymmetric grid layout */}
      <div className="max-w-6xl mx-auto grid grid-cols-12 gap-0">
        {/* Title — offset to right */}
        <div className="col-span-7 col-start-6 mt-24">
          <div className="h-1 w-16 mb-6" style={{ background: '#e03c31' }} />
          <h1 className="text-6xl font-black uppercase tracking-tighter leading-none mb-6">
            The Bauhaus<br />Kitchen
          </h1>
        </div>

        {/* Content — offset to left */}
        <div className="col-span-5 col-start-2 row-start-2 mt-16">
          <p className="text-lg leading-relaxed" style={{ color: '#444' }}>
            Geometric purity meets culinary precision. Every recipe a composition.
          </p>
          <button className="bauhaus-button mt-8">Explore Recipes</button>
        </div>
      </div>
    </div>
  );
}
```

**Typography:** Swiss Modernist (Space Grotesk + DM Sans) — born for this. Mono Technical for labels.

**Best for:** Design-forward food brands, architecture-inspired cooking, modernist cuisine

**Compatibility:** Best with B (shadcn). Works standalone. Clashes with C (玻璃拟态) philosophy.

---

## Style 14: Paper Craft (纸艺)

Layered cut paper, subtle drop shadows, cardboard textures. Tactile handmade warmth. Everything looks cut and pasted.

**Mood:** Handcrafted, artisanal, tactile, warm

```
Color Palette:
  Background:  #faf7f2  cream cardstock
  Surface:     #ffffff  white paper
  Foreground:  #3d3529  dark ink
  Primary:     #e8985e  kraft orange
  Secondary:   #8fb09c  moss green
  Accent:      #d4a76a  washi gold
  Paper 1:     #f2ede4  warm buff
  Paper 2:     #e8e0d0  kraft tone

Textures: paper grain, deckle edges, washi tape, stitching
Shadows: layered — each piece of paper casts a shadow on the one below
```

```css
.paper-card {
  background: #ffffff;
  position: relative;
  box-shadow:
    1px 1px 0 rgba(61, 53, 41, 0.05),
    2px 2px 0 rgba(61, 53, 41, 0.03),
    4px 4px 12px rgba(61, 53, 41, 0.06);
  transition: transform 0.3s, box-shadow 0.3s;
}

.paper-card:hover {
  transform: rotate(-0.5deg) scale(1.01);
  box-shadow:
    1px 1px 0 rgba(61, 53, 41, 0.08),
    2px 2px 0 rgba(61, 53, 41, 0.05),
    6px 6px 20px rgba(61, 53, 41, 0.1);
}

/* Washi tape decoration */
.washi-tape {
  position: absolute;
  top: -10px;
  left: 20px;
  width: 60px;
  height: 20px;
  background: repeating-linear-gradient(
    45deg,
    transparent,
    transparent 4px,
    rgba(255,255,255,0.3) 4px,
    rgba(255,255,255,0.3) 6px
  ),
  linear-gradient(135deg, #e8985e, #d4a76a);
  opacity: 0.8;
  transform: rotate(-3deg);
}

/* Deckle edge (rough paper edge) */
.deckle-edge {
  position: relative;
}
.deckle-edge::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 0;
  right: -4px;
  height: 4px;
  background:
    repeating-linear-gradient(
      90deg,
      transparent,
      transparent 3px,
      #faf7f2 3px,
      #faf7f2 5px,
      transparent 5px,
      transparent 8px,
      #faf7f2 8px,
      #faf7f2 10px
    );
}

/* Stitched border */
.stitched-border {
  border: 2px dashed rgba(61, 53, 41, 0.15);
  outline: 1px solid rgba(61, 53, 41, 0.05);
  outline-offset: 4px;
}
```

```tsx
function PaperCraftRecipeCard({ recipe }: { recipe: Recipe }) {
  return (
    <div className="paper-card p-6 max-w-sm">
      {/* Washi tape */}
      <div className="relative">
        <div className="washi-tape" />
        <img
          src={recipe.image}
          alt={recipe.title}
          className="w-full h-48 object-cover deckle-edge"
        />
      </div>

      {/* Content with stitched border */}
      <div className="stitched-border p-4 mt-4">
        <h3 className="text-xl font-bold tracking-tight" style={{ color: '#3d3529' }}>
          {recipe.title}
        </h3>
        <div className="flex gap-4 mt-3 font-mono text-sm" style={{ color: '#8fb09c' }}>
          <span>{recipe.cookTime} min</span>
          <span>{recipe.calories} kcal</span>
        </div>
      </div>
    </div>
  );
}
```

**Typography:** Handwritten Artisanal (Caveat + Quicksand) — handwritten warmth. Nature Organic for body.

**Best for:** DIY cooking blogs, craft food marketplaces, artisanal bakeries

**Compatibility:** Best with A (动森增强). Both value warmth and tactility.

---

## Style 15: Pop Art (波普艺术)

Bold, comic, high-contrast. Ben-Day dots, thick outlines, primary colors, POW! speech bubbles. Roy Lichtenstein meets Andy Warhol.

**Mood:** Bold, irreverent, energetic, iconic

```
Color Palette:
  Background:  #ffffff  white canvas
  Surface:     #fff9e6  warm tint
  Foreground:  #000000  black ink
  Primary:     #ff0033  pop red
  Secondary:   #ffcc00  pop yellow
  Accent:      #0066ff  pop blue
  Dot:         #000000  (for halftones)

Effects: Ben-Day dots (halftone), thick black outlines, speech bubbles, onomatopoeia (POW! BAM!)
```

```css
.pop-art-card {
  background: #ffcc00;
  border: 4px solid #000;
  position: relative;
  box-shadow: 8px 8px 0 #000;
}

/* Ben-Day dots overlay */
.ben-day-dots {
  background-image: radial-gradient(circle, #000 1px, transparent 1px);
  background-size: 10px 10px;
  opacity: 0.15;
}

/* Comic speech bubble */
.speech-bubble {
  background: #fff;
  border: 3px solid #000;
  border-radius: 12px;
  padding: 12px 18px;
  position: relative;
  font-weight: 900;
  text-transform: uppercase;
}
.speech-bubble::after {
  content: '';
  position: absolute;
  bottom: -15px;
  left: 20px;
  width: 0;
  height: 0;
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;
  border-top: 15px solid #000;
}
.speech-bubble::before {
  content: '';
  position: absolute;
  bottom: -10px;
  left: 22px;
  width: 0;
  height: 0;
  border-left: 8px solid transparent;
  border-right: 8px solid transparent;
  border-top: 12px solid #fff;
  z-index: 1;
}

/* Halftone shadow effect */
.halftone-bg {
  background:
    radial-gradient(circle, #0066ff 2px, transparent 2px);
  background-size: 12px 12px;
  opacity: 0.2;
}

/* POW! accent text */
.pow-text {
  font-size: 3rem;
  font-weight: 900;
  color: #ff0033;
  text-transform: uppercase;
  -webkit-text-stroke: 2px #000;
  text-shadow: 4px 4px 0 #000;
  font-style: italic;
  transform: rotate(-5deg);
  display: inline-block;
}
```

```tsx
function PopArtRecipeCard({ recipe }: { recipe: Recipe }) {
  return (
    <div className="pop-art-card overflow-hidden">
      {/* Image with halftone overlay */}
      <div className="relative">
        <img
          src={recipe.image}
          alt={recipe.title}
          className="w-full h-48 object-cover border-b-4 border-black"
        />
        <div className="ben-day-dots absolute inset-0" />
      </div>

      <div className="p-6 relative">
        {/* POW badge */}
        <div className="pow-text text-sm mb-2">NEW!</div>

        <h3 className="text-2xl font-black uppercase leading-tight mb-3">
          {recipe.title}
        </h3>

        <div className="speech-bubble inline-block text-sm">
          {recipe.cookTime} MIN!
        </div>

        <div className="flex gap-3 mt-4">
          <span className="px-3 py-1 bg-white border-2 border-black font-bold text-xs uppercase">
            {recipe.calories} KCAL
          </span>
        </div>
      </div>
    </div>
  );
}
```

**Typography:** Neo-Brutalist Bold (Bebas Neue + Inter) — bold comic energy. Use Impact for POW! accents.

**Best for:** Viral food content, street food brands, food challenges, youth cooking shows

**Compatibility:** Best with B (shadcn) for maximum contrast. Clashes with all soft/cozy styles.

---

## Style 16: Steampunk (蒸汽朋克)

Victorian industrial romance. Brass, gears, leather, steam. Gilded Age machinery meets Jules Verne adventure.

**Mood:** Adventurous, nostalgic, intricate, mechanical

```
Color Palette:
  Background:  #2a2018  aged oak
               #1a1410  deep mahogany
  Surface:     #3d3025  dark leather
  Foreground:  #e8d8b8  aged parchment
  Primary:     #c9a84c  polished brass
  Secondary:   #8b6914  tarnished gold
  Copper:      #b87333  copper
  Iron:        #4a4a4a  wrought iron
  Steam:       rgba(232, 216, 184, 0.1)  wispy white

Materials: brass, copper, leather, dark wood, rivets, gears, gauge faces
```

```css
.steampunk-card {
  background: linear-gradient(135deg, #3d3025, #2a2018);
  border: 2px solid #c9a84c;
  border-radius: 4px;
  position: relative;
  box-shadow:
    0 4px 16px rgba(0, 0, 0, 0.4),
    inset 0 1px 0 rgba(201, 168, 76, 0.1);
}

/* Rivet corners */
.steampunk-card::before {
  content: '';
  position: absolute;
  top: 6px;
  left: 6px;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: radial-gradient(circle at 40% 40%, #c9a84c, #8b6914);
  box-shadow:
    12px 0 0 0 radial-gradient(circle at 40% 40%, #c9a84c, #8b6914),
    0 12px 0 0 radial-gradient(circle at 40% 40%, #c9a84c, #8b6914),
    12px 12px 0 0 radial-gradient(circle at 40% 40%, #c9a84c, #8b6914),
    0 calc(100% - 12px) 0 0 radial-gradient(circle at 40% 40%, #c9a84c, #8b6914),
    calc(100% - 18px) 0 0 0 radial-gradient(circle at 40% 40%, #c9a84c, #8b6914),
    calc(100% - 18px) 6px 0 0 radial-gradient(circle at 40% 40%, #c9a84c, #8b6914),
    6px calc(100% - 12px) 0 0 radial-gradient(circle at 40% 40%, #c9a84c, #8b6914),
    calc(100% - 18px) calc(100% - 12px) 0 0 radial-gradient(circle at 40% 40%, #c9a84c, #8b6914);
}

/* Brass border accent */
.brass-border {
  border: 1px solid #c9a84c;
  outline: 1px solid rgba(201, 168, 76, 0.3);
  outline-offset: 3px;
}

/* Gear decoration (CSS-only) */
.css-gear {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 4px dashed #c9a84c;
  animation: gearSpin 10s linear infinite;
  position: relative;
}
.css-gear::after {
  content: '';
  position: absolute;
  top: 50%; left: 50%;
  transform: translate(-50%, -50%);
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: #c9a84c;
}

@keyframes gearSpin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* Gauge face */
.gauge-text {
  font-family: 'Playfair Display', serif;
  font-variant-numeric: oldstyle-nums;
  color: #e8d8b8;
  letter-spacing: 0.08em;
}
```

```tsx
function SteampunkDashboard() {
  return (
    <div className="min-h-screen p-8" style={{ background: '#1a1410' }}>
      {/* Gear decorations */}
      <div className="css-gear absolute top-12 left-12 opacity-20" />
      <div className="css-gear absolute top-20 right-16 opacity-15 w-8 h-8"
        style={{ animationDuration: '14s', animationDirection: 'reverse' }} />

      <div className="max-w-4xl mx-auto relative">
        <h1 className="gauge-text text-5xl font-bold text-center mb-12"
          style={{ color: '#e8d8b8' }}>
          <span className="text-4xl opacity-40" style={{ color: '#c9a84c' }}>&#12300;</span>
          {" "}Culinary Engine Room{" "}
          <span className="text-4xl opacity-40" style={{ color: '#c9a84c' }}>&#12301;</span>
        </h1>

        <div className="grid grid-cols-3 gap-6">
          <div className="steampunk-card p-6">
            <div className="flex items-center gap-3 mb-4">
              <div className="css-gear w-6 h-6" />
              <span className="text-xs uppercase tracking-[0.2em] opacity-60" style={{ color: '#c9a84c' }}>
                Caloric Pressure
              </span>
            </div>
            <div className="brass-border inline-block px-6 py-3">
              <span className="text-4xl font-bold gauge-text">1,850</span>
              <span className="text-sm ml-2 opacity-50">kcal</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
```

**Typography:** Serif Authority (Cormorant Garamond + Lato) or Editorial Luxury (Playfair Display + Inter)

**Best for:** Craft breweries, speakeasy bars, vintage cocktail lounges, artisanal coffee, gothic restaurants

**Compatibility:** Best with C (玻璃拟态) for brass-on-glass. Works with B (shadcn) dark mode.

---

## Quick Reference — Batch 2

| # | Style | Key Visual | Mood | Typography | Best DS |
|---|-------|-----------|------|------------|---------|
| 9 | Scandinavian Minimal | Pale wood, barely-there shadows | Calm | Swiss Modernist | B |
| 10 | Cyberpunk | Neon on black, scanlines, data rain | Intense | Mono Technical | C |
| 11 | Vaporwave | Chrome text, statue silhouettes, grid | Dreamy | Glass Futurism | C |
| 12 | Memphis Design | Squiggles, dots, clashing colors | Playful | Neo-Brutalist Bold | B |
| 13 | Bauhaus | Circles, rectangles, red/blue/yellow | Rational | Swiss Modernist | B |
| 14 | Paper Craft | Layered shadows, washi tape, deckle | Handcrafted | Handwritten Artisanal | A |
| 15 | Pop Art | Ben-Day dots, thick outlines, POW! | Energetic | Neo-Brutalist Bold | B |
| 16 | Steampunk | Brass rivets, gears, dark wood | Adventurous | Serif Authority | C |

## Full Artistic Styles Master Index (16 styles)

| # | Style | # | Style |
|---|-------|---|-------|
| 1 | Neo-Brutalism | 9 | Scandinavian Minimal |
| 2 | Wabi-Sabi Zen | 10 | Cyberpunk |
| 3 | Soft Neumorphism | 11 | Vaporwave |
| 4 | Synthwave | 12 | Memphis Design |
| 5 | Art Deco | 13 | Bauhaus |
| 6 | Claymorphism | 14 | Paper Craft |
| 7 | Dark Academia | 15 | Pop Art |
| 8 | Liquid Glass | 16 | Steampunk |
