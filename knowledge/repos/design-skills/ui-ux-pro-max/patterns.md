# UI/UX Pro Max — Design Patterns Library

This document catalogs the complete design pattern intelligence from UI/UX Pro Max: every style direction with its characteristics, component patterns, layout patterns, composition rules, and decision frameworks. This is the most comprehensive design pattern library available for AI-assisted UI development.

---

## Part 1: Complete Style Direction Catalog

### Minimalism & Swiss Style
- **Origin**: 1950s Swiss Design School
- **Color Tendencies**: Monochromatic (Black #000000, White #FFFFFF), single vibrant accent, neutral beige/grey
- **Typography Defaults**: Inter/Helvetica, 400-700 weight scale, clean sans-serif
- **Shadows**: None or extremely subtle sharp shadows
- **Border Radius**: 0px (sharp) to 4px
- **Spacing**: Mathematical, 8px base unit, generous white space
- **Appropriate For**: Enterprise apps, dashboards, documentation, SaaS, professional tools
- **Not For**: Creative portfolios, entertainment, playful brands, artistic experiments
- **Mood**: Functional, rational, clean, professional, high-contrast
- **Key Effects**: Subtle hover (200-250ms), smooth transitions, clear type hierarchy
- **Performance**: Excellent (no heavy rendering)
- **Accessibility**: WCAG AAA possible, high contrast inherent
- **Mobile-Friendly**: High — translates well to small screens
- **Conversion-Focused**: Medium

### Neumorphism
- **Origin**: 2020s Soft UI trend (Dribbble/Behance aesthetic)
- **Color Tendencies**: Light pastels — Soft Blue #C8E0F4, Soft Pink #F5E0E8, Soft Grey #E8E8E8. Monochromatic with +/-30% tints/shades
- **Typography Defaults**: Rounded sans-serif, medium weight
- **Shadows**: Multiple soft shadows (-5px -5px 15px, 5px 5px 15px), inner shadows for press states
- **Border Radius**: 12-16px consistent
- **Appropriate For**: Health/wellness apps, meditation platforms, fitness trackers, minimal interaction UIs
- **Not For**: Complex apps, critical accessibility, data-heavy dashboards
- **Mood**: Soft, tactile, physical, gentle, 3D but subtle
- **Key Effects**: Soft box-shadow layers, smooth press (150ms), inner shadow depth
- **Performance**: Good
- **Accessibility**: Low contrast primary concern — needs careful validation
- **Dark Mode**: Only partial support (shadows break on dark backgrounds)

### Glassmorphism
- **Origin**: 2020s Apple/Windows design language
- **Color Tendencies**: Translucent white rgba(255,255,255,0.1-0.3) layered over vibrant backgrounds — Electric Blue #0080FF, Neon Purple #8B00FF, Vivid Pink #FF1493, Teal #20B2AA
- **Typography Defaults**: Clean sans-serif, white or dark depending on background
- **Shadows**: Subtle elevation shadows on glass layers
- **Border Radius**: 12-20px
- **Appropriate For**: Modern SaaS, financial dashboards, high-end corporate, lifestyle apps, modals, nav overlays
- **Not For**: Low-contrast backgrounds, critical accessibility, performance-limited devices
- **Mood**: Modern, premium, layered, translucent, depth without weight
- **Key Effects**: Backdrop-blur (10-20px), subtle border (1px solid rgba white 0.2), light reflection, Z-depth layering
- **Performance**: Moderate (backdrop-filter is GPU-intensive)
- **Conversion-Focused**: High — premium look drives trust

### Brutalism
- **Origin**: 1950s Brutalist architecture, 2010s web revival
- **Color Tendencies**: Pure primary colors — Red #FF0000, Blue #0000FF, Yellow #FFFF00, Black #000000, White #FFFFFF. Neon accents #00FF00, #FF00FF
- **Typography Defaults**: Bold (700+), system fonts or monospace, large sizes
- **Shadows**: Hard visible shadows (4px 4px 0 #000)
- **Border Radius**: 0px (completely sharp, no rounding)
- **Appropriate For**: Design portfolios, artistic projects, counter-culture brands, editorial/media sites, tech blogs
- **Not For**: Corporate, conservative industries, critical accessibility, customer-facing professional
- **Mood**: Raw, unpolished, bold, confrontational, anti-design, honest
- **Key Effects**: No smooth transitions (instant), visible borders (2-4px), large type blocks, visible grid
- **Performance**: Excellent
- **Accessibility**: WCAG AAA possible (high contrast inherent)

### Neubrutalism
- **Origin**: 2020s Gen Z design trend (Figma, Notion, Linear aesthetic)
- **Color Tendencies**: #FFEB3B (Yellow), #FF5252 (Red), #2196F3 (Blue), #000000 (black borders). High saturation, bright pop
- **Typography Defaults**: Bold sans-serif, 700+ weight
- **Shadows**: Hard offset shadows (5px 5px 0 #000) — the signature element
- **Border Radius**: 0-4px (sharp to slightly rounded)
- **Key Distinction from Brutalism**: Playful rather than raw. Hard shadows + bright colors create a "ugly-cute" aesthetic. More functional and usable than pure brutalism.
- **Appropriate For**: Gen Z brands, startups, creative agencies, Figma-style apps, Notion-style interfaces
- **Not For**: Luxury, finance, healthcare, conservative industries (too playful)

### Claymorphism
- **Origin**: 2020s 3D illustration trend (Meta, Microsoft)
- **Color Tendencies**: Pastel — Soft Peach #FDBCB4, Baby Blue #ADD8E6, Mint #98FF98, Lilac #E6E6FA
- **Typography Defaults**: Rounded fonts, bold weight for headings
- **Shadows**: Double shadows — inner + outer, soft, no hard lines
- **Border Radius**: 16-24px (very rounded, chunky)
- **Appropriate For**: Educational apps, children's apps, SaaS platforms, creative tools, fun-focused onboarding, casual games
- **Not For**: Formal corporate, professional services, data-critical, serious/medical, legal, finance
- **Mood**: Playful, toy-like, bubbly, friendly, soft 3D, approachable
- **Key Effects**: Inner+outer shadow combos, soft press (200ms ease-out), fluffy elements, smooth transitions with slight bounce

### Aurora UI
- **Origin**: 2020s gradient design trend, Northern Lights aesthetic
- **Color Tendencies**: Complementary pairs — Blue-Orange, Purple-Yellow, Electric Blue #0080FF, Magenta #FF1493, Cyan #00FFFF. Smooth transitions across spectrum
- **Typography Defaults**: Clean sans-serif, white or dark, often with gradient text fills
- **Shadows**: Minimal, depth through color layering instead
- **Border Radius**: Varied, typically 8-16px
- **Appropriate For**: Modern SaaS, creative agencies, branding, music platforms, lifestyle, premium products, hero sections
- **Not For**: Data-heavy dashboards, critical accessibility, content-heavy where distraction matters
- **Mood**: Luminous, atmospheric, premium, vibrant, fluid, mesmerizing
- **Key Effects**: Large flowing CSS/SVG gradients, subtle 8-12s animations, iridescent effects, blend modes (screen, multiply)

### Bento Box Grid
- **Origin**: Apple design language, 2020s
- **Color Tendencies**: Off-white #F5F5F7, Clean White #FFFFFF, Text #1D1D1F. Subtle accent colors. Soft shadows.
- **Typography Defaults**: Inter or SF Pro, varied weights
- **Shadows**: Very subtle (0 4px 6px rgba(0,0,0,0.05))
- **Border Radius**: 16-24px (generous rounding)
- **Appropriate For**: Dashboards, product pages, portfolios, Apple-style marketing, feature showcases, SaaS homepages
- **Not For**: Dense data tables, text-heavy content, real-time monitoring
- **Mood**: Organized, premium, clean, modern, modular, Apple-like
- **Key Effects**: Varied grid spans (1x1, 2x1, 2x2), hover scale (1.02), smooth transitions, soft shadow expansion on hover
- **Layout Pattern**: CSS Grid with `grid-template-columns: repeat(4, 1fr)` at desktop, `grid-auto-rows: 200px`, `gap: 16px`

### Cyberpunk UI
- **Origin**: 1980s cyberpunk fiction, 2020s UX revival
- **Color Tendencies**: #00FF00 (Matrix Green), #FF00FF (Magenta), #00FFFF (Cyan), #0D0D0D (Deep Black)
- **Typography Defaults**: Monospace (JetBrains Mono, Space Mono), angular shapes
- **Shadows**: Neon text-shadow glow (0 0 10px), no traditional shadows
- **Border Radius**: 0-4px (sharp, angular, no softness)
- **Appropriate For**: Gaming platforms, tech products, crypto apps, sci-fi applications, developer tools
- **Not For**: Corporate, healthcare, family apps, conservative brands, elderly users
- **Mood**: Dystopian, tech noir, futuristic, high-tech, terminal aesthetic
- **Key Effects**: Neon glow (text-shadow), glitch animations (skew/offset), scanlines (::before overlay), terminal fonts

### Spatial UI (VisionOS)
- **Origin**: Apple Vision Pro design language, 2024
- **Color Tendencies**: Frosted Glass #FFFFFF at 15-30% opacity, vibrant system colors for active states
- **Typography Defaults**: Inter, clean sans-serif, system fonts
- **Shadows**: Deep shadows for depth perception
- **Border Radius**: 24px+ (very rounded glass panels)
- **Appropriate For**: Spatial computing apps, VR/AR interfaces, immersive media, futuristic dashboards
- **Not For**: Text-heavy documents, high-contrast requirements, non-3D capable devices
- **Mood**: Immersive, depth-aware, translucent, futuristic, floating
- **Key Effects**: backdrop-filter: blur(40px) saturate(180%), dynamic lighting response, gaze-hover effects, parallax depth

### Editorial Grid / Magazine
- **Origin**: Print magazine design translated to digital
- **Color Tendencies**: High contrast — Black #000000, White #FFFFFF, single accent brand color. Muted supporting colors.
- **Typography Defaults**: Serif body (Georgia, Merriweather), bold sans headings, drop caps, pull quotes
- **Shadows**: Minimal or none
- **Border Radius**: 0px
- **Key Elements**: Asymmetric grid, pull quotes, drop caps (::first-letter), multi-column text (column-count), large imagery, bylines, section dividers
- **Appropriate For**: News sites, blogs, magazines, editorial content, long-form articles, journalism
- **Not For**: Dashboards, apps, e-commerce catalogs, real-time data, short-form content
- **Layout Pattern**: CSS Grid with named areas, `column-count` for text, `::first-letter` for drop caps at 4em

### AI-Native UI
- **Origin**: ChatGPT/Claude era design patterns, 2023-2025
- **Color Tendencies**: Neutral + single accent — AI Purple #6366F1, Success Green #10B981. Light backgrounds #F5F5F5.
- **Typography Defaults**: Clean sans-serif (Inter), message bubble distinction
- **Shadows**: Minimal, chat bubble backgrounds instead
- **Border Radius**: 8-12px for bubbles, varied for context cards
- **Key Elements**: Conversation layout (flex-direction: column), streaming text (overflow: hidden + animation), typing indicators (3-dot pulse), context cards (border-left accent), sticky input
- **Appropriate For**: AI products, chatbots, voice assistants, copilots, conversational interfaces
- **Mood**: Intelligent, assistive, ambient, conversational, minimal-chrome

### Gen Z Chaos / Maximalism
- **Origin**: 2023+ internet culture, TikTok/Brat aesthetic
- **Color Tendencies**: Clashing brights — #FF00FF, #00FF00, #FFFF00, #0000FF. Rainbow, glitch, heavily saturated.
- **Typography Defaults**: Loud, varied sizes, mixed fonts, uppercase
- **Shadows**: Hard, layered, chaotic
- **Border Radius**: Mixed — intentionally inconsistent
- **Key Effects**: Marquee scrolls, jitter, sticker layering, GIF overload, random placement, drag-and-drop chaos
- **Appropriate For**: Gen Z lifestyle, music artists, creative portfolios, viral marketing, fashion
- **Mood**: Chaotic, loud, ironic, internet-native, raw, unpolished

### E-Ink / Paper
- **Origin**: Digital well-being movement, 2020s
- **Color Tendencies**: Off-White #FDFBF7 (paper), Ink Black #1A1A1A, Pencil Grey #4A4A4A, Highlighter Yellow #FFFF00 (sole accent)
- **Typography Defaults**: Serif for reading (Georgia), monochrome
- **Shadows**: None
- **Border Radius**: 0-4px
- **Key Distinction**: No animations whatsoever (instant transitions). Paper texture overlays. Grain/noise effects. Print-friendly color scheme.
- **Appropriate For**: Reading apps, digital newspapers, minimal journals, distraction-free writing, slow-living brands
- **Mood**: Calm, focused, book-like, slow tech, distraction-free

### Anti-Polish / Raw Aesthetic
- **Origin**: 2025+ anti-digital perfection movement
- **Color Tendencies**: Paper White #FAFAF8, Pencil Grey #4A4A4A, Marker Black #1A1A1A, Kraft Brown #C4A77D. Watercolor washes, ink splatters.
- **Typography Defaults**: Hand-drawn fonts, sketch fonts, varied weights
- **Key Elements**: Hand-drawn SVG borders, scanned paper textures, tape/sticker overlays, intentional imperfections, no smooth transitions, random small rotations (-3deg to 3deg)
- **Appropriate For**: Creative portfolios, artist sites, indie brands, handmade products, authentic storytelling
- **Mood**: Human, authentic, imperfect, artisanal, handmade

### Tactile Digital / Deformable UI
- **Origin**: 2025+ physical-digital convergence
- **Color Tendencies**: Gradient metallics, Chrome Silver #C0C0C0, Jelly Pink #FF9ECD, Soft Blue #87CEEB
- **Typography Defaults**: Bold, playful sans-serif
- **Key Effects**: Press deformation (scale(0.95) + squish), bounce-back (cubic-bezier(0.34, 1.56, 0.64, 1)), spring physics, glossy highlights, material response
- **Appropriate For**: Modern mobile apps, playful brands, entertainment, gaming UI, consumer products
- **Mood**: Physical, responsive, juicy, bouncy, material-rich

---

## Part 2: Component Design Patterns

### Button Design System
From the design system generator (design_system.py), buttons follow this spec:

**Primary Button**:
```css
.btn-primary {
  background: var(--color-accent);
  color: white;
  padding: 12px 24px;
  border-radius: 8px;
  font-weight: 600;
  transition: all 200ms ease;
  cursor: pointer;
}
.btn-primary:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}
```

**Secondary Button**:
```css
.btn-secondary {
  background: transparent;
  color: var(--color-primary);
  border: 2px solid var(--color-primary);
  padding: 12px 24px;
  border-radius: 8px;
  font-weight: 600;
  transition: all 200ms ease;
  cursor: pointer;
}
```

### Card Design System
```css
.card {
  background: var(--color-background);
  border-radius: 12px;
  padding: 24px;
  box-shadow: var(--shadow-md);
  transition: all 200ms ease;
  cursor: pointer;
}
.card:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-2px);
}
```

### Input Design System
```css
.input {
  padding: 12px 16px;
  border: 1px solid #E2E8F0;
  border-radius: 8px;
  font-size: 16px;
  transition: border-color 200ms ease;
}
.input:focus {
  border-color: var(--color-primary);
  outline: none;
  box-shadow: 0 0 0 3px var(--color-primary)20;
}
```

### Modal Design System
```css
.modal-overlay {
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
}
.modal {
  background: white;
  border-radius: 16px;
  padding: 32px;
  box-shadow: var(--shadow-xl);
  max-width: 500px;
  width: 90%;
}
```

---

## Part 3: Design System Token Architecture

Generated design systems follow a three-part architecture:

### Shadow Depth Scale
| Level | Value | Usage |
|-------|-------|-------|
| `--shadow-sm` | `0 1px 2px rgba(0,0,0,0.05)` | Subtle lift |
| `--shadow-md` | `0 4px 6px rgba(0,0,0,0.1)` | Cards, buttons |
| `--shadow-lg` | `0 10px 15px rgba(0,0,0,0.1)` | Modals, dropdowns |
| `--shadow-xl` | `0 20px 25px rgba(0,0,0,0.15)` | Hero images, featured cards |

### Spacing Scale
| Token | Value | Usage |
|-------|-------|-------|
| `--space-xs` | `4px` / `0.25rem` | Tight gaps |
| `--space-sm` | `8px` / `0.5rem` | Icon gaps, inline spacing |
| `--space-md` | `16px` / `1rem` | Standard padding |
| `--space-lg` | `24px` / `1.5rem` | Section padding |
| `--space-xl` | `32px` / `2rem` | Large gaps |
| `--space-2xl` | `48px` / `3rem` | Section margins |
| `--space-3xl` | `64px` / `4rem` | Hero padding |

---

## Part 4: Landing Page Pattern Library (34 Patterns)

### Pattern 1: Hero + Features + CTA
- **Section Order**: Hero > Value Prop > Key Features (3-5) > CTA Section > Footer
- **CTA Placement**: Hero (sticky) + Bottom
- **Color Strategy**: Hero = Brand primary/vibrant. Features = Card bg #FAFAFA. CTA = Contrasting accent (7:1 ratio)
- **Effects**: Hero parallax, feature card hover lift, CTA glow on hover

### Pattern 2: Hero + Testimonials + CTA (Social Proof)
- **Section Order**: Hero > Problem > Solution > Testimonials Carousel > CTA
- **Color Strategy**: Testimonials in Light bg #F5F5F5. Quotes in italic muted #666. CTA vibrant.
- **Conversion**: Social proof BEFORE CTA. 3-5 testimonials with photo + name + role.

### Pattern 3: Pricing Page + CTA
- **Section Order**: Hero > Pricing Cards (3 tiers) > Feature Comparison > FAQ > Final CTA
- **Color Strategy**: Free = Grey, Starter = Blue, Pro = Green/Gold, Enterprise = Dark. Popular plan highlighted (brand color border/bg).
- **Conversion**: Annual discount 20-30%. Most popular badge on mid-tier. FAQ addresses objections.

### Pattern 4: Minimal Single Column
- **Section Order**: Hero Headline > Short Description > Benefit Bullets (3 max) > CTA > Footer
- **CTA Placement**: Center, large button
- **Color Strategy**: Brand + White #FFFFFF + single accent
- **Key Principle**: Single CTA focus. Large typography. Massive white space. No nav clutter. Mobile-first.

### Pattern 5: Funnel (3-Step Conversion)
- **Section Order**: Hero > Step 1 (Problem) > Step 2 (Solution) > Step 3 (Action) > CTA progression
- **Color Strategy**: Step 1 = Red/Problem, Step 2 = Orange/Process, Step 3 = Green/Solution. CTA = Brand color.
- **Effects**: Step number animations, progress bar fill, smooth scroll between steps

### Pattern 6: Scroll-Triggered Storytelling
- **Section Order**: Intro Hook > Chapter 1 (Problem) > Chapter 2 (Journey) > Chapter 3 (Solution) > Climax CTA
- **Color Strategy**: Progressive reveal. Each chapter distinct color. Building intensity.
- **Effects**: ScrollTrigger animations, parallax layers (3-5), progressive disclosure, chapter transitions

### Pattern 7: Bento Grid Showcase
- **Section Order**: Hero > Bento Grid (Key Features) > Detail Cards > Tech Specs > CTA
- **CTA**: Floating Action Button or Bottom of Grid
- **Color**: Card backgrounds #F5F5F7 or glass. Icons in vibrant brand colors. Text dark.
- **Effects**: Hover card scale (1.02), video inside cards, tilt effect, staggered reveal
- **Mobile**: Stacks vertically — cards reflow to single column

### Pattern 8: Before-After Transformation
- **Section Order**: Hero (Problem state) > Transformation Slider > How It Works > Results CTA
- **Color**: Muted/grey (before) vs vibrant/colorful (after). Success green for results.
- **Conversion**: 45% higher with visual proof. Real results. Specific metrics. Guarantee offer.

### Additional Patterns (26 more):
- Video-First Hero, Waitlist/Coming Soon, Lead Magnet + Form, Comparison Table + CTA, Product Demo + Features, App Store Style, FAQ/Documentation, Immersive/Interactive Experience, Event/Conference, Product Review/Ratings, Community/Forum, Marketplace/Directory, Newsletter/Content First, Webinar Registration, Enterprise Gateway, Portfolio Grid, Horizontal Scroll Journey, Interactive 3D Configurator, AI-Driven Dynamic Landing, Feature-Rich Showcase, Hero-Centric Design, Trust & Authority + Conversion, Real-Time/Operations Landing, and more.

---

## Part 5: Composition Rules & Decision Framework

### Style-to-Product Matching Logic
The design_system.py generator uses `ui-reasoning.csv` to match styles to product categories through a weighted decision algorithm:

1. **Product type detection** -> maps to UI category
2. **Reasoning rules lookup** -> gets recommended pattern, style priority list, color mood, typography mood, key effects, anti-patterns
3. **Multi-domain parallel search** -> searches product, style, color, landing, typography simultaneously
4. **Best match selection** -> scores results against priority keywords (exact style name = +10, keyword match = +3, field match = +1)
5. **Final recommendation** -> aggregates pattern, style, colors (14 tokens), typography (heading + body + mood), effects, anti-patterns

### Style Selection Heuristics
From the Quick Reference (Priority 4: Style Selection):
- Match style to product type (use `--design-system` for recommendations)
- Maintain consistency across all pages
- Use SVG icons (not emojis)
- Choose palette from product/industry (search `--domain color`)
- Match effects to chosen style (shadows for glass, none for flat, etc.)
- Respect platform idioms (iOS HIG vs Material Design)
- Make hover/pressed/disabled states visually distinct while on-style
- Use consistent elevation/shadow scale for cards, sheets, modals
- Design light/dark variants together
- Use one icon set/visual language
- Prefer native/system controls; customize only when branding requires
- Each screen should have one primary CTA; secondary actions visually subordinate

### Anti-Patterns (Universal "Do NOT Use" Rules)
- Emojis as icons (use SVG instead)
- Missing `cursor:pointer` on clickable elements
- Layout-shifting hovers (avoid scale transforms that shift layout)
- Low contrast text (maintain 4.5:1 minimum)
- Instant state changes (always use 150-300ms transitions)
- Invisible focus states (2-4px outline required)
- Icon-only buttons without aria-label
- Placeholder-only form labels
- Red/green only for error/success (add icons/text)
- Animating width/height (use transform instead)
- Linear easing for UI transitions (use ease-out/ease-in)
- Multiple primary CTAs per screen
- Horizontal scroll on mobile
- Content hidden behind fixed navbars

---

## Part 6: Data Visualization Patterns

### Chart Type Selection Rules
| Data Story | Best Chart | When NOT to Use |
|------------|-----------|-----------------|
| Trend over time | Line Chart | <4 data points; >6 series |
| Compare categories | Bar Chart | >15 categories; time dimension exists |
| Part-to-whole | Pie/Donut | >5 categories; need precise values |
| Correlation | Scatter Plot | <20 points; categorical variables |
| Hierarchy | Treemap | >3 levels deep; precision needed |
| Flow/Process | Sankey Diagram | <3 source-target pairs; mobile |
| Distribution | Box Plot | Non-statistical audience |
| Real-time | Streaming Chart | <1/min update frequency |

### Dashboard Layout Patterns
1. **Data-Dense Dashboard**: 12-column grid, 8px gaps, compact cards, sticky headers, sortable tables, export functionality
2. **Executive Dashboard**: 4-6 large KPI cards, trend sparklines, traffic-light indicators (red/yellow/green), at-a-glance, print-friendly
3. **Real-Time Monitoring**: Live status (pulsing dots), streaming charts, alert notifications, system health overview, offline fallback
4. **Drill-Down Analytics**: Breadcrumb nav, expandable sections, context preservation, deep links, back navigation, summary-to-detail flow

---

## Part 7: Mobile-Specific Patterns (from skill-content.md)

### Icon & Visual Rules for Mobile Apps
- Default icon library: Phosphor (`@phosphor-icons/react`)
- No emojis as structural icons
- Vector-only assets (SVG or platform vector icons)
- Stable interaction states (color/opacity/elevation transitions, NOT layout shifts)
- Consistent icon sizing via design tokens (icon-sm, icon-md=24pt, icon-lg)
- Consistent stroke width within visual layer (1.5px or 2px)
- Filled vs outline discipline per hierarchy level
- Minimum 44x44pt touch target (use hitSlop for smaller icons)
- Icon alignment to text baseline
- WCAG contrast: 4.5:1 for small, 3:1 for larger glyphs

### Interaction Rules for Mobile Apps
- Tap feedback within 80-150ms (ripple/opacity/elevation)
- Micro-interactions at 150-300ms with platform-native easing
- Screen reader focus order matches visual order
- Disabled states = reduced emphasis + no tap action + semantic disabled
- Touch targets >=44x44pt (iOS) or >=48x48dp (Android)
- One primary gesture per region, avoid nested tap/drag conflicts
- Prefer native interactive primitives (Button, Pressable)

### Light/Dark Mode Rules
- Cards/surfaces clearly separated from background with sufficient opacity/elevation
- Body text contrast >=4.5:1 on light surfaces
- Primary text contrast >=4.5:1 on dark surfaces
- Secondary text contrast >=3:1 on dark surfaces
- Dividers/borders visible in both themes
- Pressed/focused/disabled states distinguishable in both
- Token-driven theming (semantic color tokens mapped per theme)
- Modal scrim 40-60% black for foreground isolation

### Layout & Spacing Rules
- Respect top/bottom safe areas (notch, status bar, gesture bar)
- Add spacing for system bars (status/navigation/gesture indicator)
- Consistent content width per device class
- 8dp spacing rhythm (4/8dp system)
- Readable text measure on large devices (avoid edge-to-edge paragraphs)
- Clear vertical rhythm tiers (16/24/32/48 by hierarchy)
- Adaptive gutters by breakpoint
- Scroll padding for fixed bar coexistence
