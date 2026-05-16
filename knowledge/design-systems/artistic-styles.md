# Artistic Styles — Premium Visual Directions

Layer any of these 8 artistic directions onto a base design system (A/B/C) for a unique visual identity. Each style defines its own color mood, texture language, and spatial rules.

---

## Style 1: Neo-Brutalism (新粗野主义)

Bold, raw, unapologetic. Thick black borders, primary colors, no subtlety. A rebellion against soft UI.

**Mood:** Confident, loud, memorable, anti-corporate

```
Color Palette:
  Background:  #fffdf7  warm white
  Foreground:  #1a1a1a  near-black
  Primary:     #ff6b35  orange-red
  Secondary:   #004ecc  electric blue
  Accent:      #ffd700  yellow
  Border:      #1a1a1a  solid black (always)

Borders: 3-4px solid black on everything
Shadows: offset 4px 4px 0 #1a1a1a (hard shadow, no blur)
Radius: 0 (sharp corners) or 2px max
```

```css
.neo-brutalist-card {
  border: 3px solid #1a1a1a;
  box-shadow: 6px 6px 0 #1a1a1a;
  border-radius: 0;
  background: #fff;
  transition: box-shadow 0.15s, transform 0.15s;
}
.neo-brutalist-card:hover {
  box-shadow: 2px 2px 0 #1a1a1a;
  transform: translate(4px, 4px);
}

.neo-brutalist-button {
  border: 3px solid #1a1a1a;
  background: #ff6b35;
  color: #1a1a1a;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  box-shadow: 4px 4px 0 #1a1a1a;
}
.neo-brutalist-button:active {
  box-shadow: 0px 0px 0 #1a1a1a;
  transform: translate(4px, 4px);
}
```

```tsx
function BrutalistRecipeCard({ recipe }: { recipe: Recipe }) {
  return (
    <div className="neo-brutalist-card p-6 max-w-sm">
      <span className="px-3 py-1 text-xs font-bold uppercase bg-yellow border-2 border-black">
        {recipe.category}
      </span>
      <h3 className="text-2xl font-black mt-4 uppercase tracking-tight">
        {recipe.title}
      </h3>
      <div className="flex gap-4 mt-4 font-mono text-sm">
        <span>{recipe.cookTime} MIN</span>
        <span>{recipe.calories} KCAL</span>
      </div>
    </div>
  );
}
```

**Typography:** Neo-Brutalist Bold (Bebas Neue + Inter) or Mono Technical (Geist Mono + Inter)

**Best for:** Creative agencies, street food brands, Gen-Z apps, music platforms

**Compatibility:** Layer onto B (shadcn专业) — shadcn's button variants adapt well. Avoid with A (动森) — style clash.

---

## Style 2: Wabi-Sabi Zen (侘寂禅意)

Japanese aesthetic of imperfect beauty. Asymmetry, roughness, simplicity, natural materials. Calm and grounded.

**Mood:** Serene, timeless, authentic, meditative

```
Color Palette:
  Background:  #f5f0e8  warm rice paper
  Surface:     #ede4d3  aged linen
  Foreground:  #3d3929  charcoal brown
  Primary:     #8b7355  weathered wood
  Accent:      #c8a882  dried bamboo
  Muted:       #a09887  stone grey
  Error:       #c44d34  rust red (muted, not bright)

Textures: rice paper grain, rough ceramic, linen weave
Shapes: irregular, hand-drawn feel
Radius: asymmetric (12px top-left, 20px bottom-right, etc.)
```

```css
.wabi-card {
  background: linear-gradient(135deg, #ede4d3 0%, #f5f0e8 50%, #e8dfd0 100%);
  border: 1px solid rgba(139, 115, 85, 0.2);
  border-radius: 12px 24px 12px 24px;
  box-shadow: 0 4px 24px rgba(61, 57, 41, 0.06);
}

/* Rice paper texture overlay */
.wabi-texture::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.03'/%3E%3C/svg%3E");
  background-size: 256px 256px;
  pointer-events: none;
}

.wabi-divider {
  height: 1px;
  background: linear-gradient(90deg, transparent, #8b7355, transparent);
  opacity: 0.3;
  margin: 2rem 0;
}
```

```tsx
function WabiSabiSection({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="relative py-24 px-6">
      <div className="max-w-3xl mx-auto">
        <div className="flex items-center gap-6 mb-12">
          <span className="text-4xl opacity-30 text-wood">&#12300;</span>
          <h2 className="text-3xl font-light tracking-wide text-charcoal">
            {title}
          </h2>
        </div>
        <div className="wabi-divider" />
        <div className="mt-8">{children}</div>
      </div>
    </section>
  );
}
```

**Typography:** Japanese Warmth (Zen Maru Gothic + Noto Sans JP) or Nature Organic (Fraunces + Nunito Sans)

**Best for:** Japanese cuisine, tea brands, wellness retreats, mindfulness apps, artisanal pottery

**Compatibility:** Excellent with A (动森增强). Good with C (玻璃拟态) for zen-tech fusion.

---

## Style 3: Soft Neumorphism (软拟态)

Soft, extruded, almost tactile. Elements push out from or sink into the background. Calm and physical.

**Mood:** Soothing, modern, tactile, wellness-oriented

```
Color Palette:
  Background:  #e8edf2  soft grey-blue (MUST be the base for shadows)
  Surface:     #e8edf2  same as background
  Foreground:  #3a4a5a  muted navy
  Primary:     #7c9eb2  dusty blue
  Secondary:   #a8c4d4  light sky
  Accent:      #f0c8a0  warm peach

Shadows: dual shadows (dark + light) to create extrusion
  Dark shadow:  #c8d4dd  (darker than bg)
  Light shadow: #ffffff  (lighter than bg)
Radius: 16-24px (large, soft)
No borders — shadows define edges
```

```css
.neumorphic-raised {
  background: #e8edf2;
  border-radius: 20px;
  box-shadow:
    8px 8px 16px #c8d4dd,
    -8px -8px 16px #ffffff;
}
.neumorphic-pressed {
  background: #e8edf2;
  border-radius: 20px;
  box-shadow:
    inset 6px 6px 12px #c8d4dd,
    inset -6px -6px 12px #ffffff;
}
.neumorphic-flat {
  background: #e8edf2;
  border-radius: 20px;
  box-shadow: none;
}

.neumorphic-button:active {
  box-shadow:
    inset 4px 4px 10px #c8d4dd,
    inset -4px -4px 10px #ffffff;
}
```

```tsx
function NeumorphicCard({ children }: { children: React.ReactNode }) {
  return (
    <div className="neumorphic-raised p-8 transition-shadow duration-300 hover:shadow-[12px_12px_24px_#c8d4dd,-12px_-12px_24px_#ffffff]">
      {children}
    </div>
  );
}

function NeumorphicStat({ label, value }: { label: string; value: number }) {
  return (
    <div className="neumorphic-pressed p-6 rounded-2xl">
      <div className="text-3xl font-light text-center" style={{ color: '#3a4a5a' }}>
        {value.toLocaleString()}
      </div>
      <div className="text-xs text-center mt-2 uppercase tracking-widest opacity-50">
        {label}
      </div>
    </div>
  );
}
```

**Typography:** Swiss Modernist (Space Grotesk + DM Sans) — clean geometric complements the soft shapes

**Best for:** Health tracking apps, meditation timers, wellness dashboards, sleep trackers

**Compatibility:** Best with B (shadcn专业). Color restriction: MUST use a mid-tone background — white or dark backgrounds don't produce neumorphic shadows.

---

## Style 4: Synthwave Retro (合成器浪潮)

80s neon, chrome, and nostalgia. Grid lines, sunsets, glowing edges. Retro-futuristic energy.

**Mood:** Electric, nostalgic, energetic, fun

```
Color Palette:
  Background:  #1a0533  deep purple (dark)
               #0d0221  deep space black
  Foreground:  #fff5e6  warm white
  Primary:     #ff6ac1  neon pink
  Secondary:   #00f0ff  cyan
  Accent:      #ffd700  gold
  Grid lines:  rgba(0, 240, 255, 0.1)

Effects: glow, chromatic aberration, scanlines, neon flicker
```

```css
.synthwave-bg {
  background:
    linear-gradient(180deg, #0d0221 0%, #1a0533 50%, #2d0a4e 100%);
}

/* Grid floor (perspective) */
.synthwave-grid {
  background:
    linear-gradient(90deg, rgba(0, 240, 255, 0.06) 1px, transparent 1px),
    linear-gradient(0deg, rgba(0, 240, 255, 0.06) 1px, transparent 1px);
  background-size: 60px 60px;
  transform: perspective(500px) rotateX(45deg);
  transform-origin: bottom center;
}

.neon-text {
  color: #ff6ac1;
  text-shadow:
    0 0 7px #ff6ac1,
    0 0 20px #ff6ac1,
    0 0 40px #ff6ac180;
}

.neon-border {
  border: 2px solid #00f0ff;
  box-shadow:
    0 0 7px #00f0ff,
    0 0 20px #00f0ff40,
    inset 0 0 7px #00f0ff20;
}

/* Chromatic aberration on hover */
.synthwave-card:hover {
  filter: drop-shadow(2px 0 2px #ff6ac180) drop-shadow(-2px 0 2px #00f0ff80);
}

/* Sunset gradient (classic synthwave sky) */
.synthwave-sunset {
  background: linear-gradient(180deg,
    #ff6ac1 0%,
    #ff8c6b 30%,
    #ffd700 60%,
    #1a0533 100%
  );
}
```

```tsx
function SynthwaveHero() {
  return (
    <div className="synthwave-bg relative min-h-screen overflow-hidden">
      {/* Grid */}
      <div className="synthwave-grid absolute inset-x-0 bottom-0 h-[60%]" />

      {/* Sun */}
      <div className="absolute left-1/2 bottom-[30%] -translate-x-1/2 w-64 h-64 rounded-full"
        style={{
          background: 'radial-gradient(circle, #ffd700, #ff8c6b 40%, #ff6ac1 70%, transparent)',
        }}
      />

      {/* Content */}
      <div className="relative z-10 flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h1 className="neon-text text-6xl font-display font-bold tracking-tight">
            Future Kitchen
          </h1>
          <p className="mt-6 text-xl opacity-70" style={{ color: '#00f0ff' }}>
            Recipes from the neon grid
          </p>
        </div>
      </div>
    </div>
  );
}
```

**Typography:** Glass Futurism (Clash Display + Satoshi) — bold, futuristic, cinematic

**Best for:** Music festivals, gaming food brands, futuristic recipe apps, Gen-Z dining

**Compatibility:** Excellent with C (玻璃拟态). Avoid with A (动森) — complete aesthetic clash.

---

## Style 5: Art Deco Geometric (装饰艺术)

Gilded Age opulence meets geometric precision. Gold, symmetry, marble, and elaborate borders. The Great Gatsby in pixels.

**Mood:** Luxurious, timeless, celebratory, grand

```
Color Palette:
  Background:  #faf8f2  cream marble
               #1a1a2e  midnight (dark variant)
  Foreground:  #1a1a2e  deep navy
  Primary:     #c9a84c  gold
  Secondary:   #8b7355  bronze
  Accent:      #e8d5b7  champagne
  Dark:        #0f0f1a  ink black

Shapes: geometric, symmetric, stepped, fan motifs
Borders: double/triple lines, gold rules, ornate corners
```

```css
.art-deco-card {
  background: linear-gradient(135deg, #faf8f2, #f0ebe0);
  border: 2px solid #c9a84c;
  border-radius: 4px;
  position: relative;
  box-shadow: 0 8px 32px rgba(201, 168, 76, 0.1);
}

/* Ornate corner decorations */
.art-deco-card::before {
  content: '';
  position: absolute;
  top: 8px; left: 8px; right: 8px; bottom: 8px;
  border: 1px solid rgba(201, 168, 76, 0.3);
  border-radius: 2px;
  pointer-events: none;
}

.art-deco-divider {
  height: 2px;
  background: linear-gradient(90deg,
    transparent,
    #c9a84c 20%,
    #e8d5b7 50%,
    #c9a84c 80%,
    transparent
  );
  margin: 2rem 0;
}

/* Gold gradient text */
.gold-text {
  background: linear-gradient(135deg, #c9a84c 0%, #e8d5b7 40%, #c9a84c 60%, #8b7355 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* Stepped geometric border (fan motif) */
.art-deco-border {
  border: 3px solid #c9a84c;
  outline: 1px solid #c9a84c;
  outline-offset: 4px;
  outline-width: 1px;
}
```

```tsx
function ArtDecoSection({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="py-16 px-6 max-w-5xl mx-auto">
      <div className="text-center mb-12">
        <div className="flex items-center justify-center gap-4 mb-4">
          <div className="h-px flex-1 max-w-24 bg-gradient-to-r from-transparent to-gold" />
          <span className="gold-text text-sm uppercase tracking-[0.3em] font-semibold">
            {title}
          </span>
          <div className="h-px flex-1 max-w-24 bg-gradient-to-l from-transparent to-gold" />
        </div>
      </div>
      <div className="art-deco-card p-8">{children}</div>
    </section>
  );
}
```

**Typography:** Art Deco Geometric (Poiret One + Josefin Sans) with Abril Fatface accent for numbers

**Best for:** Michelin-star restaurant sites, premium spirits, luxury hotel dining, wedding catering

**Compatibility:** Best with C (玻璃拟态) for gold-on-glass. Can work with B (shadcn) for dark variant.

---

## Style 6: Claymorphism 3D (粘土风)

Chunky, soft, playful 3D. Elements look like molded clay with thick rounded edges, inner shadows, and bubbly personality.

**Mood:** Playful, friendly, approachable, toy-like

```
Color Palette:
  Background:  #f5f0eb  warm clay
  Surface:     #faf7f3  light clay
  Primary:     #ff8c6b  terracotta orange
  Secondary:   #7ec8a4  mint green
  Accent:      #ffd700  sunny yellow
  Dark:        #4a3728  dark clay

Shadows: heavy inner + outer shadows, double shadows for 3D depth
Radius: 24-32px (extremely rounded)
```

```css
.clay-card {
  background: #faf7f3;
  border-radius: 32px;
  box-shadow:
    0 12px 40px rgba(74, 55, 40, 0.12),
    0 4px 12px rgba(74, 55, 40, 0.06),
    inset 0 1px 0 rgba(255, 255, 255, 0.8);
  border: 2px solid rgba(255, 255, 255, 0.5);
}

.clay-button {
  background: #ff8c6b;
  border-radius: 20px;
  padding: 14px 32px;
  border: none;
  font-weight: 700;
  color: white;
  box-shadow:
    0 8px 0 #d47050,
    0 10px 24px rgba(74, 55, 40, 0.15);
  transition: transform 0.15s, box-shadow 0.15s;
}
.clay-button:active {
  transform: translateY(4px);
  box-shadow:
    0 4px 0 #d47050,
    0 6px 16px rgba(74, 55, 40, 0.12);
}

.clay-input {
  background: #f5f0eb;
  border-radius: 20px;
  border: 2px solid rgba(74, 55, 40, 0.1);
  padding: 14px 20px;
  box-shadow:
    inset 0 2px 8px rgba(74, 55, 40, 0.06),
    0 1px 0 rgba(255, 255, 255, 0.8);
}
.clay-input:focus {
  outline: none;
  border-color: #ff8c6b;
  box-shadow:
    inset 0 2px 8px rgba(74, 55, 40, 0.06),
    0 0 0 4px rgba(255, 140, 107, 0.2);
}
```

```tsx
function ClayRecipeCard({ recipe }: { recipe: Recipe }) {
  return (
    <div className="clay-card p-6 max-w-sm hover:scale-[1.02] transition-transform duration-300">
      <div className="clay-button inline-block text-sm mb-4">
        {recipe.category}
      </div>
      <img
        src={recipe.image}
        alt={recipe.title}
        className="w-full h-48 object-cover rounded-3xl mb-4"
      />
      <h3 className="text-xl font-bold text-dark-clay">{recipe.title}</h3>
      <div className="flex gap-3 mt-3">
        <div className="clay-input inline-block px-4 py-1 text-sm">
          {recipe.cookTime} min
        </div>
        <div className="clay-input inline-block px-4 py-1 text-sm">
          {recipe.calories} kcal
        </div>
      </div>
    </div>
  );
}
```

**Typography:** Nature Organic (Fraunces + Nunito Sans) — soft, friendly, rounded

**Best for:** Kids' cooking apps, family recipe sharing, educational nutrition, gamified meal tracking

**Compatibility:** Best with A (动森增强) — both are playful and warm. Avoid with B (shadcn) — too serious.

---

## Style 7: Dark Academia (暗黑学术)

Old libraries, candlelight, aged paper, leather-bound books. Scholarly, mysterious, intellectual warmth in darkness.

**Mood:** Intellectual, mysterious, romantic, nostalgic

```
Color Palette:
  Background:  #1a1410  dark oak
               #0d0a07  shadow black
  Surface:     #2a2218  aged leather
  Foreground:  #e8dcc8  aged parchment
  Primary:     #c9a84c  gold (muted, tarnished)
  Secondary:   #8b4513  saddle brown
  Accent:      #6b3a2a  burgundy
  Muted:       #a09080  faded ink
```

```css
.dark-academia-bg {
  background:
    radial-gradient(ellipse at 50% 0%, #2a2218 0%, #1a1410 50%, #0d0a07 100%);
}

.academia-card {
  background: linear-gradient(135deg, #2a2218, #1f1912);
  border: 1px solid rgba(201, 168, 76, 0.15);
  border-radius: 2px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.4);
}

/* Warm candlelight glow effect */
.academia-glow {
  position: relative;
}
.academia-glow::after {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse at 50% 0%, rgba(201, 168, 76, 0.08), transparent 70%);
  pointer-events: none;
}

.academia-text {
  color: #e8dcc8;
  font-family: 'Cormorant Garamond', serif;
}

/* Ornate first letter */
.academia-dropcap::first-letter {
  float: left;
  font-size: 4rem;
  line-height: 0.8;
  padding-right: 12px;
  padding-top: 4px;
  color: #c9a84c;
  font-family: 'Playfair Display', serif;
  font-weight: 700;
}
```

```tsx
function DarkAcademiaSection({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="dark-academia-bg min-h-screen py-24 px-6">
      <div className="max-w-3xl mx-auto">
        <div className="flex items-center gap-6 mb-8">
          <div className="h-px flex-1 bg-gradient-to-r from-transparent to-gold/30" />
          <span className="text-xs uppercase tracking-[0.3em] text-gold/60 font-mono">
            {title}
          </span>
          <div className="h-px flex-1 bg-gradient-to-l from-transparent to-gold/30" />
        </div>

        <div className="academia-card p-8 academia-glow">
          <div className="academia-dropcap text-parchment leading-relaxed">
            {children}
          </div>
        </div>

        {/* Page number */}
        <div className="text-center mt-8 text-faded-ink/30 font-mono text-xs">
          &#12300; <span className="tabular-nums">xvii</span> &#12301;
        </div>
      </div>
    </section>
  );
}
```

**Typography:** Serif Authority (Cormorant Garamond + Lato) or Editorial Luxury (Playfair Display + Inter)

**Best for:** Wine & spirits, coffee culture, culinary history, chef's table experiences, rare cookbook collections

**Compatibility:** Best with B (shadcn专业) dark mode. Can work with C (玻璃拟态) for gothic-tech fusion.

---

## Style 8: Liquid Glass Morph (液态玻璃)

Beyond standard glassmorphism — animated liquid gradients inside frosted glass, morphing blobs, iridescent surfaces, oil-slick chromatic effects.

**Mood:** Mesmerizing, premium, fluid, otherworldly

```
Color Palette:
  Background:  #060610  void black
  Surface:     rgba(255,255,255,0.03)  barely-there glass
  Border:      rgba(255,255,255,0.08)  subtle boundary
  Iridescence: hsl(280,80%,70%) → hsl(200,80%,60%) → hsl(160,70%,50%)
  Accent:      #a78bfa  violet
               #60a5fa  blue
               #34d399  emerald

Effects: animated gradients, morphing SVG blobs, chromatic aberration
```

```css
/* Animated liquid gradient background */
.liquid-gradient {
  background: linear-gradient(
    135deg,
    hsl(280, 80%, 8%) 0%,
    hsl(220, 80%, 6%) 25%,
    hsl(180, 70%, 5%) 50%,
    hsl(260, 80%, 8%) 75%,
    hsl(300, 70%, 6%) 100%
  );
  background-size: 400% 400%;
  animation: liquidShift 20s ease infinite;
}

@keyframes liquidShift {
  0%, 100% { background-position: 0% 50%; }
  25% { background-position: 100% 0%; }
  50% { background-position: 100% 100%; }
  75% { background-position: 0% 100%; }
}

/* Iridescent glass panel */
.iridescent-glass {
  background: rgba(255, 255, 255, 0.03);
  backdrop-filter: blur(40px) saturate(180%);
  -webkit-backdrop-filter: blur(40px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 24px;
  position: relative;
  overflow: hidden;
}

/* Iridescent border shimmer */
.iridescent-glass::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  padding: 1px;
  background: linear-gradient(
    135deg,
    rgba(167, 139, 250, 0.4),
    rgba(96, 165, 250, 0.2),
    rgba(52, 211, 153, 0.1),
    rgba(167, 139, 250, 0.4)
  );
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  animation: borderShimmer 6s linear infinite;
  background-size: 300% 300%;
}

@keyframes borderShimmer {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

/* Morphing blob (use as decorative background element) */
.morphing-blob {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.15;
  animation: morphBlob 12s ease-in-out infinite;
}

@keyframes morphBlob {
  0%, 100% {
    border-radius: 60% 40% 30% 70% / 60% 30% 70% 40%;
  }
  25% {
    border-radius: 30% 60% 70% 40% / 50% 60% 30% 60%;
  }
  50% {
    border-radius: 40% 60% 30% 70% / 60% 40% 70% 30%;
  }
  75% {
    border-radius: 60% 40% 70% 30% / 30% 60% 40% 70%;
  }
}
```

```tsx
function LiquidGlassPage() {
  return (
    <div className="liquid-gradient relative min-h-screen overflow-hidden">
      {/* Morphing blobs behind glass */}
      <div className="morphing-blob w-[500px] h-[500px] bg-violet-500 -top-20 -left-20" />
      <div className="morphing-blob w-[400px] h-[400px] bg-blue-500 top-1/2 -right-20"
        style={{ animationDelay: '-4s' }} />
      <div className="morphing-blob w-[300px] h-[300px] bg-emerald-500 -bottom-20 left-1/3"
        style={{ animationDelay: '-8s' }} />

      {/* Glass panel */}
      <div className="relative z-10 flex items-center justify-center min-h-screen p-8">
        <div className="iridescent-glass p-12 max-w-2xl">
          <h1 className="text-5xl font-display font-bold text-white/95 text-center">
            The Future of{" "}
            <span className="gradient-text from-violet-400 via-blue-400 to-emerald-400">
              Nutrition
            </span>
          </h1>
          <p className="mt-6 text-lg text-white/50 text-center leading-relaxed">
            Liquid intelligence for your daily wellness journey
          </p>
        </div>
      </div>
    </div>
  );
}
```

**Typography:** Glass Futurism (Clash Display + Satoshi) or Fashion Runway (Bodoni Moda + Montserrat)

**Best for:** Premium meal delivery, luxury nutrition brands, cutting-edge food-tech, biotech wellness

**Compatibility:** Best with C (玻璃拟态). Can enhance B (shadcn专业) dark mode dramatically.

---

## Quick Reference Matrix

| # | Style | Key Visual | Mood | Typography | Best DS |
|---|-------|-----------|------|------------|---------|
| 1 | Neo-Brutalism | 4px black borders, hard shadows | Confident | Neo-Brutalist Bold | B |
| 2 | Wabi-Sabi Zen | Rice paper, irregular shapes, wood | Serene | Japanese Warmth | A |
| 3 | Soft Neumorphism | Extruded shadows, no borders | Soothing | Swiss Modernist | B |
| 4 | Synthwave | Neon glow, grid, sunset gradient | Electric | Glass Futurism | C |
| 5 | Art Deco | Gold rules, symmetry, geometric | Luxurious | Art Deco Geometric | C |
| 6 | Claymorphism | 32px radius, 3D shadows, chunky | Playful | Nature Organic | A |
| 7 | Dark Academia | Candlelight, aged leather, gold | Intellectual | Serif Authority | B |
| 8 | Liquid Glass | Iridescent, morphing blobs, 40px blur | Otherworldly | Glass Futurism | C |

## How to Apply an Artistic Style

1. Start from a base design system (A/B/C) for structural components
2. Overlay the artistic style's CSS custom properties for colors, shadows, borders
3. Apply the recommended font pairing from `typography-layout.md`
4. Use the style's texture effects (noise overlays, gradients, glow) as decorative layers
5. Keep it to ONE artistic style per project — mixing creates chaos

## Compatibility Rule

```
Design System A (动森增强) + Wabi-Sabi, Claymorphism = natural fit
Design System B (shadcn专业) + Neo-Brutalism, Neumorphism, Dark Academia = natural fit
Design System C (玻璃拟态) + Synthwave, Art Deco, Liquid Glass = natural fit
Cross-compatible: any style can work with any system, but above pairings minimize friction
```
