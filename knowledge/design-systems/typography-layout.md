# Typography & Layout — Premium Design Layer

Cross-cutting design layer. Any of the 3 UI design systems can adopt these typography and layout patterns for instant premium elevation.

---

## 1. Font Pairings

### Pairing 1: Editorial Luxury
```
Heading: 'Playfair Display', Georgia, serif
Body:    'Inter', system-ui, -apple-system, sans-serif
Mono:    'JetBrains Mono', monospace
```
Best for: Recipe detail pages, food blogs, lifestyle content, 动森增强

### Pairing 2: Swiss Modernist
```
Heading: 'Space Grotesk', system-ui, sans-serif
Body:    'DM Sans', system-ui, sans-serif
Mono:    'Geist Mono', monospace
```
Best for: Dashboards, data displays, shadcn专业, nutrition tracking

### Pairing 3: Glass Futurism
```
Heading: 'Clash Display', 'Outfit', sans-serif
Body:    'Satoshi', 'Inter', sans-serif
Mono:    'Fira Code', monospace
```
Best for: Glass Hero sections, luxury brands, 玻璃拟态

### Pairing 4: Japanese Warmth
```
Heading: 'Zen Maru Gothic', 'M PLUS Rounded 1c', sans-serif
Body:    'Noto Sans JP', system-ui, sans-serif
Mono:    'Fira Code', monospace
```
Best for: 动森增强 Japanese flavor, cozy food content

### Pairing 5: Neo-Brutalist Bold
```
Heading: 'Bebas Neue', 'Anton', sans-serif
Body:    'Inter', system-ui, sans-serif
Mono:    'JetBrains Mono', monospace
```
Best for: Hero statements, call-to-action sections

### Pairing 6: Serif Authority
```
Heading: 'Cormorant Garamond', Georgia, serif
Body:    'Lato', system-ui, sans-serif
Mono:    'Source Code Pro', monospace
```
Best for: Nutrition science content, authoritative data

### Pairing 7: Handwritten Artisanal
```
Heading: 'Caveat', 'Kalam', cursive
Body:    'Quicksand', 'Nunito Sans', sans-serif
Mono:    'Fira Code', monospace
```
Best for: Personal recipe journals, artisanal food blogs, craft breweries

### Pairing 8: Mono Technical
```
Heading: 'Geist Mono', 'JetBrains Mono', monospace
Body:    'Inter', system-ui, sans-serif
Mono:    'Geist Mono', monospace (same as heading)
```
Best for: Developer tools, API docs, code-heavy dashboards, nutrition calculators

### Pairing 9: Art Deco Geometric
```
Heading: 'Poiret One', 'Josefin Sans', sans-serif
Body:    'Josefin Sans', 'Quicksand', sans-serif
Mono:    'Fira Code', monospace
Accent:  'Abril Fatface', Georgia, serif (hero numbers, dates)
```
Best for: Luxury hotel brands, vintage cocktail menus, premium event pages

### Pairing 10: Editorial Newspaper
```
Heading: 'Merriweather', Georgia, serif
Body:    'Source Sans 3', system-ui, sans-serif
Mono:    'Source Code Pro', monospace (matching family)
```
Best for: Nutrition news, health journalism, research publications

### Pairing 11: Fashion Runway
```
Heading: 'Bodoni Moda', 'Didot', serif
Body:    'Montserrat', 'Inter', sans-serif
Mono:    'Fira Code', monospace
```
Best for: High-end food photography, luxury restaurant sites, premium meal delivery

### Pairing 12: Nature Organic
```
Heading: 'Fraunces', 'Lora', serif
Body:    'Nunito Sans', system-ui, sans-serif
Mono:    'Fira Code', monospace
```
Best for: Farm-to-table concepts, organic food brands, sustainable living, biophilic design

### Font Loading Strategy
```html
<!-- Preconnect to Google Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700;900&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
```

```css
/* System font fallback — no layout shift on load */
@font-face {
  font-family: 'Heading';
  src: local('Playfair Display'), local('Georgia');
  size-adjust: 105%; /* match fallback metrics */
}
```

---

## 2. Type Scales

### Major Third (1.25) — Versatile, works everywhere
```
text-xs:    0.75rem  (12px)  — captions, labels, microcopy
text-sm:    0.875rem (14px)  — secondary text, metadata
text-base:  1rem     (16px)  — body text
text-lg:    1.25rem  (20px)  — lead paragraphs, card titles
text-xl:    1.563rem (25px)  — section headings
text-2xl:   1.953rem (31px)  — page headings
text-3xl:   2.441rem (39px)  — hero subheadings
text-4xl:   3.052rem (49px)  — hero headings
text-5xl:   3.815rem (61px)  — landing titles
```

### Perfect Fourth (1.333) — Dramatic, luxury feel
```
text-xs:    0.75rem  (12px)
text-sm:    0.875rem (14px)
text-base:  1rem     (16px)
text-lg:    1.333rem (21px)
text-xl:    1.777rem (28px)
text-2xl:   2.369rem (38px)
text-3xl:   3.157rem (51px)
text-4xl:   4.209rem (67px)
text-5xl:   5.61rem  (90px)  — massive impact
```

### Tailwind Config
```js
// tailwind.config.js
module.exports = {
  theme: {
    fontSize: {
      'xs':  ['0.75rem',  { lineHeight: '1rem' }],
      'sm':  ['0.875rem', { lineHeight: '1.25rem' }],
      'base':['1rem',     { lineHeight: '1.75rem' }],
      'lg':  ['1.25rem',  { lineHeight: '1.75rem' }],
      'xl':  ['1.563rem', { lineHeight: '2rem', letterSpacing: '-0.01em' }],
      '2xl': ['1.953rem', { lineHeight: '2.25rem', letterSpacing: '-0.02em' }],
      '3xl': ['2.441rem', { lineHeight: '2.75rem', letterSpacing: '-0.02em' }],
      '4xl': ['3.052rem', { lineHeight: '3.25rem', letterSpacing: '-0.03em' }],
      '5xl': ['3.815rem', { lineHeight: '4rem', letterSpacing: '-0.04em' }],
    },
  },
};
```

---

## 3. Layout Systems

### A: Swiss Grid (International Style)

Grid-based, asymmetric, mathematical precision. Bold headings, generous whitespace, strict column alignment.

```
┌─────────────────────────────────────────────┐
│ 12-column grid (80px cols, 20px gutters)    │
│                                              │
│ ┌────────────┐                               │
│ │ Logo       │          ┌──┐ ┌──┐ ┌──┐     │
│ │            │          │Nav│ │Nav│ │Nav│     │
│ └────────────┘          └──┘ └──┘ └──┘     │
│                                              │
│ ┌──────────────────┐                         │
│ │                  │  ┌────────────────────┐ │
│ │  Hero Image      │  │  Hero Headline     │ │
│ │  (8 cols)        │  │  (4 cols)          │ │
│ │                  │  │                    │ │
│ │                  │  │  Subtitle here     │ │
│ └──────────────────┘  └────────────────────┘ │
│                                              │
│ ┌────┐ ┌────┐ ┌────┐ ┌────┐                │
│ │ C1 │ │ C2 │ │ C3 │ │ C4 │  (3 cols each) │
│ └────┘ └────┘ └────┘ └────┘                │
└─────────────────────────────────────────────┘
```

```css
.swiss-grid {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 1.25rem;
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 2rem;
}

.swiss-hero {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 1.25rem;
  min-height: 80vh;
  align-items: center;
}
```

### B: Editorial Magazine

Large hero image, pull quotes, drop caps, asymmetric columns. Content-first with dramatic visual breaks.

```
┌─────────────────────────────────────────────┐
│                                              │
│  ┌────────────────────────────────────────┐  │
│  │  Full-bleed hero image                 │  │
│  │                                        │  │
│  │  ┌──────────────────────────────┐      │  │
│  │  │  Title overlay on image      │      │  │
│  │  │  Subtitle                    │      │  │
│  │  └──────────────────────────────┘      │  │
│  └────────────────────────────────────────┘  │
│                                              │
│  ┌──────┐ ┌─────────────────────────────┐   │
│  │      │ │  Main content (8 cols)      │   │
│  │ Side │ │                              │   │
│  │ bar  │ │  "Pull quote spanning       │   │
│  │ (3c) │ │   3 lines of dramatic text"  │   │
│  │      │ │                              │   │
│  │ tips │ │  Drop cap paragraph...       │   │
│  └──────┘ └─────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

```tsx
// DropCap component
function DropCap({ children }: { children: string }) {
  const firstChar = children.charAt(0);
  const rest = children.slice(1);
  return (
    <p className="text-lg leading-relaxed text-brown/80">
      <span className="float-left text-7xl font-bold leading-[0.8] mr-3 mt-1 font-serif text-mint">
        {firstChar}
      </span>
      {rest}
    </p>
  );
}

// PullQuote component
function PullQuote({ text, author }: { text: string; author?: string }) {
  return (
    <blockquote className="border-l-4 border-mint pl-6 my-10">
      <p className="text-2xl font-serif italic leading-relaxed text-brown/70">
        &ldquo;{text}&rdquo;
      </p>
      {author && (
        <cite className="block mt-3 text-sm text-brown/50 not-italic">
          — {author}
        </cite>
      )}
    </blockquote>
  );
}
```

### C: Minimal Luxury

Abundant whitespace, single narrow column, oversized typography, gold/cream palette. Every element earns its place.

```
┌─────────────────────────────────────────────┐
│                                              │
│                                              │
│           ┌─────────────────────┐            │
│           │                     │            │
│           │   LOGO              │            │
│           │                     │            │
│           └─────────────────────┘            │
│                                              │
│           ┌─────────────────────┐            │
│           │                     │            │
│           │   MASSIVE HEADLINE  │            │
│           │   64px, light       │            │
│           │                     │            │
│           └─────────────────────┘            │
│                                              │
│           ┌─────────────────────┐            │
│           │  Single column      │            │
│           │  max-width: 640px   │            │
│           │  centered           │            │
│           │                     │            │
│           │  Body text here     │            │
│           │  Generous leading   │            │
│           │  1.75 line-height   │            │
│           │                     │            │
│           └─────────────────────┘            │
│                                              │
│           ┌─────────────────────┐            │
│           │  Footer             │            │
│           └─────────────────────┘            │
│                                              │
└─────────────────────────────────────────────┘
```

```css
.minimal-luxury {
  --measure: 640px;
  --leading: 1.75;
  --vertical-rhythm: calc(1rem * var(--leading));

  max-width: var(--measure);
  margin: 0 auto;
  padding: calc(var(--vertical-rhythm) * 4) 2rem;
}

.minimal-luxury h1 {
  font-size: 4rem;
  font-weight: 300;
  letter-spacing: -0.03em;
  line-height: 1.1;
  margin-bottom: calc(var(--vertical-rhythm) * 2);
}

.minimal-luxury p {
  font-size: 1.125rem;
  line-height: var(--leading);
  margin-bottom: var(--vertical-rhythm);
}
```

### D: Bento Grid (Apple-Style)

Rounded cards of varying sizes in a masonry-like grid. Each card is a self-contained piece of information.

```
┌─────────────────────────────────────────────┐
│ ┌──────────────────────┐ ┌──────────────┐  │
│ │                      │ │  Stats       │  │
│ │  Daily Summary       │ │  1,850 cal   │  │
│ │  (2x1)               │ │  (1x1)       │  │
│ │                      │ └──────────────┘  │
│ └──────────────────────┘                    │
│ ┌──────────┐ ┌──────────┐ ┌──────────────┐ │
│ │ Carbs    │ │ Protein  │ │              │ │
│ │ 45%      │ │ 30%      │ │  Meal Plan   │ │
│ │ (1x1)    │ │ (1x1)    │ │  (2x1)       │ │
│ └──────────┘ └──────────┘ │              │ │
│                            └──────────────┘ │
│ ┌──────────────────────────────────────────┐ │
│ │  Weekly Progress Chart (3x1)             │ │
│ └──────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

```tsx
function BentoGrid({ children }: { children: React.ReactNode }) {
  return (
    <div className="grid grid-cols-3 auto-rows-[200px] gap-4 max-w-6xl mx-auto p-6">
      {children}
    </div>
  );
}

// Usage:
function BentoCard({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div
      className={cn(
        'rounded-3xl p-6 bg-white/80 backdrop-blur-sm border border-white/20',
        'shadow-sm hover:shadow-md transition-shadow duration-500',
        'flex flex-col justify-between',
        className,
      )}
    >
      {children}
    </div>
  );
}

// Span helpers:
// col-span-2 = wide card (2 columns)
// row-span-2 = tall card (2 rows)
// col-span-2 row-span-2 = large card
```

### E: Staggered Asymmetric

Alternating left-right content blocks with offset spacing. Visual rhythm through irregular spacing.

```
┌─────────────────────────────────────────────┐
│ ┌────────────────────┐                       │
│ │ Image (5 cols)     │     ┌──────────────┐ │
│ │                    │     │  Text block  │ │
│ │                    │     │  (4 cols)    │ │
│ └────────────────────┘     └──────────────┘ │
│                                              │
│      ┌──────────────┐ ┌────────────────────┐ │
│      │  Text block  │ │ Image (5 cols)     │ │
│      │  (4 cols)    │ │                    │ │
│      │              │ │                    │ │
│      └──────────────┘ └────────────────────┘ │
│                                              │
│ ┌────────────────────┐                       │
│ │ Image (5 cols)     │     ┌──────────────┐ │
│ │                    │     │  Text block  │ │
│ └────────────────────┘     └──────────────┘ │
└─────────────────────────────────────────────┘
```

```tsx
function StaggeredSection({
  image,
  children,
  reverse = false,
}: {
  image: React.ReactNode;
  children: React.ReactNode;
  reverse?: boolean;
}) {
  return (
    <section className="grid grid-cols-12 gap-8 items-center py-24">
      <div className={cn('col-span-5', reverse && 'col-start-8')}>
        {image}
      </div>
      <div className={cn(
        'col-span-4',
        reverse ? 'col-start-3 row-start-1' : 'col-start-7',
      )}>
        {children}
      </div>
    </section>
  );
}
```

### F: Masonry Cascade

Pinterest-style variable-height grid. Columns flow independently, creating organic visual rhythm. Perfect for recipe galleries, food photography collections.

```
┌─────────────────────────────────────────────┐
│ ┌──────────┐ ┌──────────┐ ┌──────────┐     │
│ │ Card     │ │ Card     │ │ Card     │     │
│ │ (tall)   │ │ (short)  │ │ (medium) │     │
│ │          │ │          │ │          │     │
│ │          │ └──────────┘ │          │     │
│ │          │ ┌──────────┐ │          │     │
│ │          │ │ Card     │ └──────────┘     │
│ │          │ │ (tall)   │ ┌──────────┐     │
│ └──────────┘ │          │ │ Card     │     │
│ ┌──────────┐ │          │ │ (short)  │     │
│ │ Card     │ │          │ │          │     │
│ │ (medium) │ └──────────┘ └──────────┘     │
│ │          │ ┌──────────┐                  │
│ │          │ │ Card     │                  │
│ └──────────┘ │ (short)  │                  │
│              └──────────┘                  │
└─────────────────────────────────────────────┘
```

```tsx
// CSS-only masonry (no JS library needed)
function MasonryGallery({ children }: { children: React.ReactNode }) {
  return (
    <div className="columns-1 sm:columns-2 lg:columns-3 gap-4 space-y-4">
      {children}
    </div>
  );
}

// Each child needs break-inside: avoid
function MasonryCard({ recipe }: { recipe: Recipe }) {
  return (
    <div className="break-inside-avoid mb-4 rounded-2xl overflow-hidden bg-white shadow-sm hover:shadow-md transition-shadow duration-300">
      <img
        src={recipe.image}
        alt={recipe.title}
        className="w-full object-cover"
        style={{ height: `${200 + Math.random() * 200}px` }}
      />
      <div className="p-4">
        <h3 className="font-semibold">{recipe.title}</h3>
        <p className="text-sm text-muted">{recipe.cookTime} min</p>
      </div>
    </div>
  );
}
```

### G: Full-Screen Immersive

One viewport = one section. Scroll-snapping creates a cinematic vertical journey. Each panel is a self-contained visual statement.

```
┌─────────────────────────────────────────────┐
│ ┌─────────────────────────────────────────┐ │
│ │                                         │ │
│ │           Panel 1: Hero                 │ │
│ │           100vh                         │ │
│ │           "Discover"                    │ │
│ │                                         │ │
│ └─────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────┐ │
│ │                                         │ │
│ │           Panel 2: Features             │ │
│ │           100vh                         │ │
│ │           Grid of 3 cards               │ │
│ │                                         │ │
│ └─────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────┐ │
│ │                                         │ │
│ │           Panel 3: Gallery              │ │
│ │           100vh                         │ │
│ │           Masonry or carousel           │ │
│ │                                         │ │
│ └─────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────┐ │
│ │                                         │ │
│ │           Panel 4: CTA                  │ │
│ │           100vh                         │ │
│ │           "Start Cooking"               │ │
│ │                                         │ │
│ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

```tsx
function ImmersivePage() {
  return (
    <div className="h-screen overflow-y-scroll snap-y snap-mandatory scroll-smooth">
      <section className="h-screen snap-start flex items-center justify-center">
        <HeroPanel />
      </section>
      <section className="h-screen snap-start flex items-center justify-center">
        <FeaturesPanel />
      </section>
      <section className="h-screen snap-start flex items-center justify-center">
        <GalleryPanel />
      </section>
      <section className="h-screen snap-start flex items-center justify-center">
        <CTAPanel />
      </section>
    </div>
  );
}

// Progress indicator (dots on the side)
function ScrollProgress() {
  const { scrollYProgress } = useScroll();
  const totalSections = 4;

  return (
    <div className="fixed right-8 top-1/2 -translate-y-1/2 flex flex-col gap-3 z-50">
      {Array.from({ length: totalSections }).map((_, i) => {
        const start = i / totalSections;
        const end = (i + 1) / totalSections;
        const opacity = useTransform(scrollYProgress, [start, end], [0.3, 1]);
        return <motion.div key={i} style={{ opacity }} className="w-2 h-2 rounded-full bg-white" />;
      })}
    </div>
  );
}
```

### H: Timeline Narrative

Horizontal or vertical chronology. Events flow along a central spine. Perfect for recipe steps, nutrition journey, meal planning calendar.

```
┌─────────────────────────────────────────────┐
│                                              │
│  ○ Step 1 ─────────────────────────────────  │
│  │  Prepare ingredients                      │
│  │                                          │
│                          Step 2 ──────────○  │
│                          │  Chop vegetables │
│                          │                  │
│  ○ Step 3 ─────────────────────────────────  │
│  │  Sauté in pan                             │
│  │                                          │
│                          Step 4 ──────────○  │
│                          │  Plate & serve   │
│                          │                  │
│  ○ Complete! ──────────────────────────────  │
│                                              │
└─────────────────────────────────────────────┘
```

```tsx
interface TimelineItem {
  title: string;
  description: string;
  duration?: string;
  icon?: React.ReactNode;
}

function Timeline({ items }: { items: TimelineItem[] }) {
  return (
    <div className="relative max-w-3xl mx-auto py-12">
      {/* Spine */}
      <div className="absolute left-8 top-0 bottom-0 w-px bg-gradient-to-b from-mint/0 via-mint to-mint/0" />

      <div className="space-y-12">
        {items.map((item, i) => (
          <motion.div
            key={i}
            initial={{ opacity: 0, x: i % 2 === 0 ? -20 : 20 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true, margin: '-100px' }}
            transition={{ delay: i * 0.1 }}
            className="relative flex items-start gap-8 pl-20"
          >
            {/* Node on spine */}
            <div className="absolute left-6 w-5 h-5 rounded-full border-2 border-mint bg-cream ring-4 ring-cream" />

            {/* Content */}
            <div className={cn(
              'flex-1 p-6 rounded-2xl',
              i % 2 === 0 ? 'bg-mint/5' : 'bg-brown/5'
            )}>
              <div className="flex items-center gap-3 mb-2">
                {item.icon}
                <h3 className="font-semibold text-lg">{item.title}</h3>
                {item.duration && (
                  <span className="text-sm text-muted ml-auto font-mono tabular-nums">
                    {item.duration}
                  </span>
                )}
              </div>
              <p className="text-brown/70 leading-relaxed">{item.description}</p>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
```

---

### The 4-Level Rule
Every page must establish exactly 4 levels of visual dominance:

| Level | Purpose | Size | Weight | Color | Opacity |
|-------|---------|------|--------|-------|---------|
| **L1: Hero/Primary CTA** | Grabs attention in <0.5s | 3-5xl | 700-900 | Primary | 1.0 |
| **L2: Section Headings** | Scannable content sections | xl-2xl | 600-700 | Primary | 0.9 |
| **L3: Body/Content** | Readable information | base | 400 | Foreground | 0.8 |
| **L4: Meta/Support** | Captions, labels, timestamps | xs-sm | 400-500 | Muted | 0.5-0.6 |

```css
/* Hierarchy auto-generated via CSS custom properties */
:root {
  --text-l1: var(--color-primary);
  --text-l2: var(--color-foreground);
  --text-l3: var(--color-foreground) / 0.8;
  --text-l4: var(--color-muted);
}
```

### The 1-Second Test
When a page loads, the eye must land on L1 within 1 second. If L2 or L3 elements compete with L1, reduce their visual weight (size, color saturation, or add whitespace around L1).

---

## 5. Whitespace Architecture

### Spacing Scale (8px base)
```
space-0:   0px      — tightest: icon + label
space-1:   4px      — micro: badge padding
space-2:   8px      — inline: between related items
space-3:   12px     — compact: card padding
space-4:   16px     — default: section padding
space-5:   20px     — relaxed: card gaps
space-6:   24px     — generous: form groups
space-8:   32px     — section: between content blocks
space-10:  40px     — major: before/after headings
space-12:  48px     — hero: around CTA sections
space-16:  64px     — page: top/bottom page padding
space-20:  80px     — dramatic: luxury breathing room
space-24:  96px     — maximal: hero sections
```

### The 2:1 Rule
For every 2 parts of content, give 1 part of whitespace. A 400px content block gets 200px of surrounding whitespace.

### Active vs Passive Whitespace
- **Active whitespace**: Intentional space that guides the eye (margins around a hero CTA)
- **Passive whitespace**: Space that exists because content ends (bottom of a short paragraph)

Premium design uses active whitespace deliberately. Passive whitespace gets absorbed by giving adjacent elements more breathing room.

---

## 6. Micro-Typography

### Ligatures & Kerning
```css
.premium-text {
  font-feature-settings: 'liga' 1, 'kern' 1, 'calt' 1;
  font-kerning: normal;
  text-rendering: optimizeLegibility;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
```

### Hanging Punctuation
```css
blockquote, .pull-quote {
  hanging-punctuation: first allow-end last;
}
```

### Oldstyle Figures (for body text)
```css
.data-text {
  font-variant-numeric: oldstyle-nums proportional-nums;
}

/* For tabular data (tables, stats) */
.tabular-data {
  font-variant-numeric: lining-nums tabular-nums;
}
```

### Smart Quotes & Dashes
Always use typographic quotes and dashes in content, never straight ASCII:
```
"double quotes"  →  &ldquo;double quotes&rdquo;
'single quotes'  →  &lsquo;single quotes&rsquo;
--               →  &mdash; (em dash)
- (range)        →  &ndash; (en dash)
```

---

## 7. Responsive Type

### Fluid Type Scale (clamp-based, no breakpoints)
```css
:root {
  /* Min size at 320px, preferred at 4vw, max at 1280px */
  --text-body:   clamp(1rem, 0.95rem + 0.25vw, 1.125rem);
  --text-h3:     clamp(1.25rem, 1.1rem + 0.75vw, 1.75rem);
  --text-h2:     clamp(1.5rem, 1.2rem + 1.5vw, 2.5rem);
  --text-h1:     clamp(2rem, 1.5rem + 2.5vw, 4rem);
  --text-hero:   clamp(2.5rem, 1.5rem + 5vw, 6rem);

  /* Fluid spacing */
  --space-section: clamp(3rem, 2rem + 5vw, 8rem);
  --space-content: clamp(1rem, 0.8rem + 1vw, 2rem);
}

/* No media queries needed — fluid by default */
h1 { font-size: var(--text-h1); }
h2 { font-size: var(--text-h2); }
h3 { font-size: var(--text-h3); }
p  { font-size: var(--text-body); }
```

### Measure (Line Length)
```css
/* Optimal reading: 45-75 characters per line */
.reading-column {
  max-width: 65ch; /* ~65 characters */
  margin-inline: auto;
}

/* Wider for scanning/overview content */
.scanning-column {
  max-width: 85ch;
}
```

---

## 8. CSS Utility Classes (copy into index.css)

```css
/* === Typography Utilities === */

/* Luxury heading treatment */
.luxury-heading {
  font-feature-settings: 'liga' 1, 'kern' 1;
  text-rendering: optimizeLegibility;
  letter-spacing: -0.02em;
  line-height: 1.1;
}

/* Body text for readability */
.readable-body {
  max-width: 65ch;
  font-size: 1.0625rem;
  line-height: 1.75;
  color: inherit;
  text-rendering: optimizeLegibility;
}

/* Large display text */
.display-text {
  font-size: clamp(3rem, 5vw, 6rem);
  font-weight: 700;
  line-height: 0.95;
  letter-spacing: -0.04em;
}

/* Gradient text (use sparingly — hero only) */
.gradient-text {
  background: linear-gradient(135deg, var(--tw-gradient-from), var(--tw-gradient-to));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* Eyebrow label */
.eyebrow {
  font-size: 0.75rem;
  font-weight: 600;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  opacity: 0.6;
}

/* Divider with text */
.section-divider {
  display: flex;
  align-items: center;
  gap: 1rem;
  opacity: 0.3;
}
.section-divider::before,
.section-divider::after {
  content: '';
  flex: 1;
  height: 1px;
  background: currentColor;
}

/* Number badge (for steps, rankings) */
.number-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2rem;
  height: 2rem;
  border-radius: 50%;
  font-size: 0.875rem;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
}

/* Stat number (large data display) */
.stat-number {
  font-size: clamp(2rem, 4vw, 3.5rem);
  font-weight: 700;
  line-height: 1;
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.02em;
}
.stat-label {
  font-size: 0.75rem;
  font-weight: 500;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  opacity: 0.5;
}
```

---

## 9. Mapping: Layout → Design System

| Layout System | Best Design System | Best Use Case |
|---------------|-------------------|---------------|
| Swiss Grid | B: shadcn专业 | Nutrition dashboard, data pages |
| Editorial Magazine | A: 动森增强 | Recipe detail, food stories |
| Minimal Luxury | A or C | Landing pages, about, hero sections |
| Bento Grid | B: shadcn专业 | Dashboard, meal plan overview |
| Staggered Asymmetric | C: 玻璃拟态 | Creative portfolios, features showcase |
| Masonry Cascade | A: 动森增强 | Recipe gallery, food photography |
| Full-Screen Immersive | C: 玻璃拟态 | Cinematic brand experiences, product launches |
| Timeline Narrative | A or B | Recipe steps, meal planning, nutrition journey |

## 10. Mapping: Font Pairing → Design System

| Pairing | Best Design System | Best Use Case |
|---------|-------------------|---------------|
| Editorial Luxury (1) | A: 动森增强 | Recipe titles, food blog headings |
| Swiss Modernist (2) | B: shadcn专业 | Dashboard stats, data labels |
| Glass Futurism (3) | C: 玻璃拟态 | Hero text, glass panel headings |
| Japanese Warmth (4) | A: 动森增强 | Japanese recipes, cozy food content |
| Neo-Brutalist Bold (5) | B or C | CTA buttons, landing headlines |
| Serif Authority (6) | B: shadcn专业 | Nutrition science, health data |
| Handwritten Artisanal (7) | A: 动森增强 | Personal journals, craft food |
| Mono Technical (8) | B: shadcn专业 | Calculators, API docs, code |
| Art Deco Geometric (9) | C: 玻璃拟态 | Luxury menus, premium events |
| Editorial Newspaper (10) | B: shadcn专业 | Nutrition news, research |
| Fashion Runway (11) | C: 玻璃拟态 | High-end restaurants, luxury delivery |
| Nature Organic (12) | A: 动森增强 | Farm-to-table, organic brands |

---

## 11. Anti-Patterns

| Don't | Do Instead |
|-------|------------|
| Center-align body text > 3 lines | Left-align, max 65ch |
| Use more than 2 font families | 1 heading + 1 body family |
| Full-width text on desktop (>900px) | Constrain to 65-85ch measure |
| Pure black (#000) on white | Dark charcoal (#1a1a1a) on warm white |
| Equal spacing everywhere | Hierarchy: more space around important elements |
| Text smaller than 12px | Minimum 0.75rem for accessibility |
| Line-height: 1.5 for everything | 1.1 for headings, 1.75 for body |
| Capitalize or bold for emphasis only | Use size, color, AND weight together |
| Straight quotes and double hyphens | Typographic quotes and em dashes |
