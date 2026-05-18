# Design Quality Tokens — taste-skill

## The Implied Design System

While taste-skill does not define explicit CSS custom properties as a token file, every skill variant encodes precise, opinionated design constraints. This document extracts the **implied design system** — the exact values, ratios, and rules that define a "tasteful" interface according to the framework.

---

## Typography System

### Approved Font Stacks

**Primary Sans-Serif (Display & Headlines):**
- `Geist` (default premium recommendation)
- `Outfit` (alternative for creative/playful)
- `Cabinet Grotesk` (alternative for bold/expressive)
- `Satoshi` (alternative for clean/modern)
- `Clash Display` (for high-impact headers)
- `Neue Haas Grotesk` (for Swiss/industrial)
- `Archivo Black` (for brutalist structural headers)
- `Monument Extended` (for compressed statement typography)
- `Plus Jakarta Sans` (for soft-structuralism)
- `SF Pro Display` (for minimalist Apple-esque)
- `Switzer` (for utilitarian minimalism)

**Editorial Serif (Creative/Editorial Contexts Only):**
- `Lyon Text` (for editorial luxury)
- `Newsreader` (digital-native serif)
- `Playfair Display` (high-contrast classic)
- `Instrument Serif` (modern editorial)
- `Fraunces` (distinctive modern serif)
- `Gambarino` (expressive display serif)
- `Editorial New` (contemporary premium)
- `PP Editorial New` (high-end editorial)

**Monospace (Code, Data, Technical):**
- `Geist Mono` (default pairing with Geist)
- `JetBrains Mono` (pairing with Satoshi)
- `SF Mono` (Apple ecosystem)
- `IBM Plex Mono` (industrial/technical)
- `Space Mono` (design-forward)
- `VT323` (CRT/terminal aesthetic)
- `Courier Prime` (typewriter feel)

**Explicitly Banned Fonts:**
- Inter — banned universally for premium contexts
- Roboto — banned (too generic, Android-default)
- Arial — banned (too generic)
- Open Sans — banned (too generic)
- Helvetica — banned for premium-only soft-skill variant
- Times New Roman — banned (generic serif)
- Georgia — banned (generic serif)
- Garamond — banned (generic serif)
- Palatino — banned (generic serif)

### Typographic Scale

**Display/Headlines:**
```
Base: text-4xl md:text-6xl tracking-tighter leading-none
```

**Fluid Headline Scaling (Brutalist/Expressive):**
```
clamp(3rem, 5vw, 5.5rem) — gpt-taste hero maximum
clamp(4rem, 10vw, 15rem) — brutalist macro-typography
```

**Body Text:**
```
text-base text-gray-600 leading-relaxed max-w-[65ch]
```

**Line Length Limit:**
```
max-w-[65ch] — all body text
max-w-4xl to max-w-5xl — main typography content width
max-w-5xl to max-w-6xl — hero headline containers (gpt-taste)
max-w-7xl or max-w-[1400px] — page layout containment
```

**Tracking (Letter-Spacing):**
```
-0.06em to -0.03em — large display headlines (tight)
-0.04em to -0.02em — editorial serif headers
0.05em to 0.1em — monospace/metadata/labels (wide)
tracking-tight — bento card headers
tracking-[0.2em] — eyebrow tags (uppercase micro-labels)
```

**Line Height:**
```
0.85 to 0.95 — compressed brutalist headers
1.1 — editorial serif headers
1.2 to 1.4 — monospace data rows
1.6 — body text (generous legibility)
leading-none — display headlines
leading-relaxed — body paragraphs
```

**Font Weights (Required Range):**
Minimum four weights:
- 400 (Regular)
- 500 (Medium)
- 600 (SemiBold)
- 700 (Bold)

For editorial contexts, add 300 (Light) for large display settings.

### Special Typography Rules

**Dashboard/SaaS Font Pairing:**
```
Sans-Serif + Monospace only
Example: Geist + Geist Mono
Example: Satoshi + JetBrains Mono
```

**High-Density Override (VISUAL_DENSITY > 7):**
All numbers must use Monospace (`font-mono`)

**Serif Usage Restriction:**
Allowed ONLY for creative/editorial/lifestyle contexts
BANNED for dashboards, SaaS, admin panels, software UIs

**Eyebrow Tags:**
```
rounded-full px-3 py-1 text-[10px] uppercase tracking-[0.2em] font-medium
```

---

## Color System

### Palette Architecture

**Mandatory constraints across all variants:**
- Maximum 1 accent color
- Accent saturation < 80%
- Palette: 1 primary + 1 secondary + 1 accent + neutral scale
- Never mix warm and cool grays in one project
- One palette for entire output — no theme swapping per section

### Standard Bento Paradigm Palette

| Role | Value | Usage |
|------|-------|-------|
| Canvas | `#F9FAFB` | Primary background surface |
| Pure Surface | `#FFFFFF` | Card and container fill |
| Charcoal Ink | `#18181B` (Zinc-950) | Primary text |
| Muted Steel | `#71717A` (Zinc-500) | Secondary text, descriptions, metadata |
| Whisper Border | `rgba(226, 232, 240, 0.5)` | Card borders, 1px structural lines |
| Diffusion Shadow | `rgba(0, 0, 0, 0.05)` | Card elevation |

### Ethereal Glass Palette (Dark)

| Role | Value | Usage |
|------|-------|-------|
| OLED Black | `#050505` | Deep background |
| Vantablack Surface | Near-black with blur | Card fill with `backdrop-blur-2xl` |
| Hairline | `rgba(255, 255, 255, 0.1)` | 1px borders on dark surfaces |

### Editorial Luxury Palette (Light)

| Role | Value | Usage |
|------|-------|-------|
| Warm Cream | `#FDFBF7` | Primary background |
| Muted Sage / Espresso | — | Secondary tones |
| Film Grain Overlay | `opacity: 0.03` | Physical paper simulation |

### Minimalist Warm Monochrome

| Role | Value | Usage |
|------|-------|-------|
| Canvas White | `#FFFFFF` | Primary background |
| Warm Bone | `#F7F6F3` | Alternate background |
| Off-White | `#FBFBFA` | Section background |
| Card Surface | `#F9F9F8` | Component backgrounds |
| Ultra-Light Border | `#EAEAEA` or `rgba(0, 0, 0, 0.06)` | All dividers/borders |
| Charcoal Text | `#111111` or `#2F3437` | Primary text (never pure black) |
| Muted Gray Text | `#787774` | Secondary text |
| Solid Black CTA | `#111111` | Primary buttons |

### Minimalist Muted Pastel Accents

| Name | Background | Text |
|------|-----------|------|
| Pale Red | `#FDEBEC` | `#9F2F2D` |
| Pale Blue | `#E1F3FE` | `#1F6C9F` |
| Pale Green | `#EDF3EC` | `#346538` |
| Pale Yellow | `#FBF3DB` | `#956400` |

### Brutalist Palettes

**Swiss Industrial Print (Light):**
| Role | Value | Usage |
|------|-------|-------|
| Documentation Paper | `#F4F4F0` or `#EAE8E3` | Matte background |
| Carbon Ink | `#050505` to `#111111` | Primary foreground |
| Aviation Red | `#E61919` or `#FF2A2A` | ONLY accent — strike-throughs, dividing lines, vital data |

**Tactical Telemetry (Dark):**
| Role | Value | Usage |
|------|-------|-------|
| Deactivated CRT | `#0A0A0A` or `#121212` | Background (NOT pure `#000000`) |
| White Phosphor | `#EAEAEA` | Primary text color |
| Hazard Red | `#E61919` or `#FF2A2A` | Same accent |
| Terminal Green | `#4AF626` | Optional, SINGLE element only |

### Gradient Rules

**Allowed (use confidently):**
- Low-chroma palette-matched tonal gradients (ink to graphite, cream to sand, ivory to warm grey)
- Single-hue atmospheric grades behind hero photography
- Soft vignettes and radial depth that direct the eye
- Noise-textured gradients adding tactile depth without color noise
- Editorial color washes matching brand mood

**Banned (AI gradient slop):**
- Rainbow/mesh blob gradients
- Purple-to-blue "AI" defaults (THE LILA BAN)
- Pink-to-orange "creator" defaults
- Neon edges and glow halos with no purpose
- Gradient text as shortcut for "premium"
- Gradients that compete with imagery

### Color Consistency Rules
- Shadows must be tinted to background hue (not generic black)
- Lighting direction must be consistent across all elements
- Random dark sections in light pages (or vice versa) indicate copy-paste errors
- Accents must repeat across panels consistently
- No primary-colored backgrounds for large elements/sections (minimalist)
- Gradients/neon/3D glass banned in minimalist variant
- Gradients/soft shadows/translucency banned in brutalist variant

---

## Spacing System

### Macro-Whitespace (Section Spacing)

| Context | Value |
|---------|-------|
| Standard section gap | `py-24` (96px) |
| Maximum section gap | `py-40` (160px) |
| Cinematic chapter gap (gpt-taste) | `py-32 md:py-48` |
| Minimal section gap | `py-16` (64px) |
| Responsive section gap | `clamp(3rem, 8vw, 6rem)` |

### Card Internal Spacing

| Context | Value |
|---------|-------|
| Standard card padding | `p-8` (32px) |
| Generous card padding | `p-10` (40px) |
| Minimal card padding | `24px` to `40px` (editable minimalism) |

### Form Spacing

| Context | Value |
|---------|-------|
| Input block gap | `gap-2` (8px between label/input/error) |
| Form section gap | `gap-6` (24px between form groups) |

### Button Spacing

| Context | Value |
|---------|-------|
| CTA pill padding | `px-6 py-3` (24px × 12px) |
| Button-in-button icon size | `w-8 h-8` |

### Double-Bezel Spacing (Premium Card Architecture)

```
Outer Shell padding:  p-1.5 or p-2
Outer Shell radius:   rounded-[2rem]
Inner Core radius:    rounded-[calc(2rem-0.375rem)]
```

### Page Layout Constraints

| Context | Value |
|---------|-------|
| Page container | `max-w-[1400px] mx-auto` or `max-w-7xl` |
| Typography content | `max-w-4xl` to `max-w-5xl` |
| Hero H1 container (gpt-taste) | `max-w-5xl` to `max-w-6xl` |
| Body text line length | `max-w-[65ch]` |

### Whitespace Philosophy
- Double your standard padding — the design must breathe heavily
- Macro-whitespace is established first in any layout
- Section-to-section spacing must be even and controlled
- Avoid one cramped section next to an empty section
- Smaller sections still need enough surrounding space to feel polished
- Bottom padding often needs to be slightly larger than top (optical adjustment)
- Use `clamp()` for proportional spacing over rigid pixel values

---

## Border Radius System

### By Skill Variant

| Variant | Container Radius | Card Radius | Button Radius | Badge Radius |
|---------|-----------------|-------------|---------------|--------------|
| **taste-skill (Bento)** | `rounded-[2.5rem]` | `rounded-[2.5rem]` | `rounded-full` | N/A |
| **soft-skill** | `rounded-[2rem]` | Double-bezel (outer 2rem, inner calc) | `rounded-full` | N/A |
| **minimalist** | None / `8px` | `8px` to `12px` max | `4px` to `6px` | `9999px` (pills only for tags) |
| **brutalist** | `0px` (absolute rejection) | `0px` | `0px` | `0px` |
| **gpt-taste** | `rounded-[2.5rem]` | Gapless grid items | `rounded-full` | N/A |
| **output-skill** | Container-appropriate | Project-matched | Project-matched | Project-matched |

### Radius Discipline Rules
- Vary the radius across element types — tighter on inner elements, softer on containers
- Never use uniform radius on everything
- Concentric curves: inner radius mathematically smaller than outer in nested architectures
- Minimalist: `rounded-full` banned for large containers, cards, and primary buttons
- Brutalist: Complete rejection of any radius — all corners must be 90 degrees

---

## Shadow & Depth System

### Diffusion Shadow (Bento Paradigm)
```
shadow-[0_20px_40px_-15px_rgba(0,0,0,0.05)]
```
- Wide-spreading
- Very light
- Creates depth without clutter
- Tinted to background (not generic black at low opacity)

### Tinted Shadow Principle
Shadows must carry the hue of the background:
- Blue background → dark blue shadow
- Cream background → warm brown shadow
- White surface → `rgba(0, 0, 0, 0.04)` max opacity

### Minimalist Shadow
```
From: 0 0 0 rgba(0,0,0,0)
To:   0 2px 8px rgba(0,0,0,0.04)
```
- Ultra-subtle, practically non-existent
- Shadow on hover only — cards are flat by default
- Shadow transition: 200ms

### Glass/Liquid Glass Refraction
Beyond `backdrop-blur`:
- 1px inner border: `border-white/10`
- Inner shadow: `shadow-[inset_0_1px_0_rgba(255,255,255,0.1)]`
- Simulates physical edge refraction on frosted glass

### Anti-Shadow Rules
- No harsh dark drop shadows (`shadow-md`, `rgba(0,0,0,0.3)`)
- No generic 1px solid gray borders on premium cards
- No Tailwind default `shadow-md`, `shadow-lg`, `shadow-xl` (minimalist)
- No shadows at all in brutalist — only visible dividing lines
- Cards exist only when elevation communicates hierarchy

---

## Surface & Material System

### The Double-Bezel (Doppelrand) Architecture

Premium containers must use nested enclosures to look like physical, machined hardware:

```
OUTER SHELL (wrapper div):
  - subtle background: bg-black/5 or bg-white/5
  - hairline border: ring-1 ring-black/5 or border border-white/10
  - specific padding: p-1.5 or p-2
  - large outer radius: rounded-[2rem]

INNER CORE (content container):
  - distinct background color (different from outer)
  - inner highlight: shadow-[inset_0_1px_1px_rgba(255,255,255,0.15)]
  - mathematically smaller radius: rounded-[calc(2rem-0.375rem)]
```

### Material Vocabulary (Allowed Surface Treatments)
- Paper feel (CSS noise/film-grain overlay at `opacity: 0.03`)
- Glass feel (backdrop-blur with inner refraction borders)
- Brushed metal feel (subtle gradient + noise)
- Soft blur depth (radial gradient spots at low opacity)
- Tactile matte surfaces (very low opacity colored backgrounds)
- Editorial photo treatment (warm overlay, desaturation)
- CRT scanlines (repeating-linear-gradient for terminal interfaces)
- Halftone patterns (SVG radial dot patterns with `mix-blend-mode: multiply`)
- 1-bit dithering (for image degradation effects)

### Material Constraints
- Grain/noise exclusively on fixed, `pointer-events-none` elements
- Blur only on fixed/sticky elements
- No texture on scrolling containers (GPU repaint cost)
- All textures must feel intentional and premium, not decorative noise
- Minimalist: no gradients, no shadows, no glass effects — only border rules
- Brutalist: no gradients, no soft shadows, no translucency — hard surfaces only

---

## Border & Divider System

### Standard Tasteful Borders
```
1px solid border-slate-200/50  — bento card default
1px solid #EAEAEA              — minimalist all borders
ring-1 ring-black/5             — double-bezel outer
border border-white/10          — dark mode glass hairlines
```

### Divider Strategy
- Cards replaced with `border-t` or `divide-y` for high-density layouts
- `<hr>` elements spanning full container width for brutalist compartmentalization
- `gap: 1px` with contrasting parent/child backgrounds for razor-thin grid lines (brutalist)

---

## Responsive Design Tokens

### Breakpoints
```
sm: 640px
md: 768px  — critical collapse point for asymmetric layouts
lg: 1024px
xl: 1280px
```

### Mobile Override Rules (< 768px)
- All multi-column layouts collapse to single column: `w-full`
- Standard mobile padding: `px-4`
- Standard mobile section spacing: `py-8`
- All `col-span` overrides reset to `col-span-1`
- All rotations removed, negative-margin overlaps removed
- Full-height sections: `min-h-[100dvh]` (NOT `h-screen`)
- Body text minimum: `1rem` / `14px`
- Touch targets: minimum `44px`
- Wrap page: `<main className="overflow-x-hidden w-full max-w-full">`

### Fluid Typography
```
Headlines: clamp() function for viewport-responsive scaling
Body text: minimum 1rem/14px, never smaller
```

### Image Behavior on Mobile
- Inline typography images stack below headline
- Full-bleed backgrounds maintain readability
- Fixed-aspect media blocks scale proportionally
