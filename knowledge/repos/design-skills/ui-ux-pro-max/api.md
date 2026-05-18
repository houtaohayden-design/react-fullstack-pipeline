# UI/UX Pro Max — API & Complete Catalog Reference

## Overview

UI/UX Pro Max (v2.5.0) is the most comprehensive AI-powered design intelligence skill available. It provides a searchable database of 67+ UI styles, 161 color palettes, 57+ font pairings, 99+ UX guidelines, 25 chart types, 34+ landing page patterns, 100+ icon recommendations, and 161 product type mappings — all accessible through a BM25 + regex hybrid search engine.

**Source**: https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
**Installation**: `npx uipro-cli init --ai <platform>`

---

## Architecture

```
src/ui-ux-pro-max/
├── data/                         # Canonical CSV databases
│   ├── styles.csv                # 67 UI styles with full specs
│   ├── colors.csv                # 161 product-type-specific color palettes
│   ├── typography.csv            # 57+ font pairings with CSS/Tailwind configs
│   ├── products.csv              # Product type taxonomy
│   ├── ux-guidelines.csv         # 99+ UX best practices & anti-patterns
│   ├── charts.csv                # 25 chart types with library recommendations
│   ├── landing.csv               # 34 landing page patterns
│   ├── design.csv                # Design system component specs
│   ├── icons.csv                 # 100+ Phosphor icon recommendations
│   ├── google-fonts.csv          # Google Fonts catalog
│   ├── app-interface.csv         # Mobile app interface guidelines
│   ├── ui-reasoning.csv          # Design reasoning rules (AI decision engine)
│   ├── react-performance.csv     # React/Next.js performance tips
│   ├── draft.csv                 # Draft/work-in-progress designs
│   └── stacks/                   # 15+ stack-specific guidelines files
│       ├── react.csv, nextjs.csv, vue.csv, svelte.csv
│       ├── swiftui.csv, react-native.csv, flutter.csv
│       ├── shadcn.csv, angular.csv, astro.csv
│       ├── nuxtjs.csv, nuxt-ui.csv, jetpack-compose.csv
│       ├── html-tailwind.csv, laravel.csv, threejs.csv
├── scripts/
│   ├── search.py                 # CLI entry point
│   ├── core.py                   # BM25 + regex hybrid search engine
│   └── design_system.py          # Design system generator (aggregator + reasoning)
└── templates/
    ├── base/
    │   ├── skill-content.md      # Common skill instructions
    │   └── quick-reference.md    # Rule categories by priority (1-10)
    └── platforms/                # Platform configs (18 platforms)
        ├── claude.json, cursor.json, windsurf.json
        ├── copilot.json, gemini.json, codex.json
        └── ... +12 more
```

---

## Search API

### CLI Command

```bash
python3 src/ui-ux-pro-max/scripts/search.py "<query>" --domain <domain> [-n <max_results>]
```

### Available Domains (10)

| Domain | Purpose | Example Query |
|--------|---------|---------------|
| `product` | Product type recommendations | `"entertainment social video"` |
| `style` | UI styles with CSS keywords & AI prompts | `"glassmorphism dark mode"` |
| `typography` | Font pairings with Google Fonts | `"playful modern professional"` |
| `color` | Color palettes by product type | `"healthcare beauty fintech"` |
| `landing` | Page structure & CTA strategies | `"hero social-proof pricing"` |
| `chart` | Chart types & library recommendations | `"real-time dashboard trend"` |
| `ux` | UX best practices & anti-patterns | `"animation accessibility z-index"` |
| `react` | React/Next.js performance guidance | `"waterfall bundle suspense memo"` |
| `web` | App interface guidelines (iOS/Android/RN) | `"accessibilityLabel touch areas"` |
| `prompt` | AI prompts & CSS keywords for styles | `"minimalism"` |

### Stack-Specific Search

```bash
python3 src/ui-ux-pro-max/scripts/search.py "<query>" --stack <stack>
```

**Available Stacks (15+)**:
- **Web**: `html-tailwind` (default), `react`, `nextjs`, `astro`, `vue`, `nuxtjs`, `nuxt-ui`, `svelte`, `shadcn`, `angular`
- **Mobile**: `react-native`, `flutter`, `swiftui`, `jetpack-compose`
- **3D**: `threejs`
- **Backend**: `laravel`

### Design System Generation (KEY FEATURE)

```bash
# Generate complete design system with reasoning
python3 src/ui-ux-pro-max/scripts/search.py "<product_type> <industry> <keywords>" --design-system -p "Project Name"

# Output formats
python3 ... --design-system -f ascii     # Terminal (default) with ANSI color swatches
python3 ... --design-system -f markdown  # Documentation format

# Persistence (Master + Overrides pattern)
python3 ... --design-system --persist -p "Project Name"
python3 ... --design-system --persist -p "Project Name" --page "dashboard"
```

The `--design-system` flag triggers a 5-step pipeline:
1. Search product type to identify category
2. Load reasoning rules from `ui-reasoning.csv`
3. Execute multi-domain search (product, style, color, landing, typography in parallel)
4. Select best matches using weighted keyword scoring
5. Build complete recommendation: pattern, style, colors, typography, effects, anti-patterns

---

## Platform Support (18 AI Coding Assistants)

The skill installs as a native plugin/skill on these platforms:

| Platform | Format | How to Install |
|----------|--------|----------------|
| Claude Code | `.claude/skills/` | `uipro init --ai claude` |
| Cursor | `.cursor/rules/` | `uipro init --ai cursor` |
| Windsurf | `.windsurf/rules/` | `uipro init --ai windsurf` |
| GitHub Copilot | `.github/prompts/` | `uipro init --ai copilot` |
| Kiro | `.kiro/skills/` | `uipro init --ai kiro` |
| RooCode | `.clinerules/` | `uipro init --ai roocode` |
| KiloCode | `.kilocode/rules/` | `uipro init --ai kilocode` |
| Codex | `.codex/skills/` | `uipro init --ai codex` |
| Qoder | `.qoder/skills/` | `uipro init --ai qoder` |
| Gemini CLI | `.gemini/skills/` | `uipro init --ai gemini` |
| Trae | `.trae/rules/` | `uipro init --ai trae` |
| OpenCode | `.opencode/skills/` | `uipro init --ai opencode` |
| Continue | `.continue/prompts/` | `uipro init --ai continue` |
| CodeBuddy | `.codebuddy/skills/` | `uipro init --ai codebuddy` |
| Droid (Factory) | `.factory/skills/` | `uipro init --ai droid` |
| Warp | `.warp/skills/` | `uipro init --ai warp` |
| Augment | `.augment/rules/` | `uipro init --ai augment` |
| AntiGravity | `.antigravity/skills/` | `uipro init --ai antigravity` |

---

## Complete Style Catalog (67 Styles)

### General Purpose Styles (19)
1. **Minimalism & Swiss Style** — Grid-based, high contrast, monochrome, sans-serif, functional
2. **Neumorphism** — Soft 3D, embossed/debossed, pastel, monochromatic, rounded
3. **Glassmorphism** — Frosted glass, backdrop blur, translucent overlays, vibrant backgrounds
4. **Brutalism** — Raw, stark, pure primary colors, sharp corners, bold typography
5. **3D & Hyperrealism** — WebGL, realistic textures, complex shadows, immersive depth
6. **Vibrant & Block-based** — Bold, energetic, geometric shapes, duotone, large typography
7. **Dark Mode (OLED)** — Deep black, neon accents, minimal glow, power-efficient
8. **Accessible & Ethical** — WCAG AAA, high contrast 7:1+, large text, keyboard nav
9. **Claymorphism** — Soft 3D, chunky, bubbly, thick borders, double shadows, pastel
10. **Aurora UI** — Vibrant gradients, Northern Lights, mesh gradient, iridescent
11. **Retro-Futurism** — 80s sci-fi, neon glow, CRT scanlines, glitch, monospace
12. **Flat Design** — 2D, bold solids, no shadows/gradients, clean lines, icon-heavy
13. **Skeuomorphism** — Realistic textures, leather/wood/metal, complex gradients
14. **Liquid Glass** — Morphing shapes, fluid animations, chromatic aberration, iridescent
15. **Motion-Driven** — Animation-heavy, scroll-triggered, parallax, page transitions
16. **Micro-interactions** — Small 50-100ms animations, gesture-based, tactile feedback
17. **Inclusive Design** — Universal accessibility, voice interaction, haptic, screen reader
18. **Zero Interface** — Voice-first, gesture-based, AI-driven, minimal visible UI
19. **Soft UI Evolution** — Improved neumorphism with better contrast, modern aesthetics

### Landing Page Styles (8)
20. **Hero-Centric Design** — Full-bleed hero, compelling headline, single CTA focus
21. **Conversion-Optimized** — Form-focused, minimal distractions, urgency elements
22. **Feature-Rich Showcase** — Multi-feature grid, benefit cards, interactive demos
23. **Minimal & Direct** — Single column, massive white space, clean typography
24. **Social Proof-Focused** — Testimonials, client logos, reviews, credibility markers
25. **Interactive Product Demo** — Embedded demos, product walkthrough, step-by-step
26. **Trust & Authority** — Certificates, expert credentials, security badges
27. **Storytelling-Driven** — Narrative flow, scroll-triggered reveals, emotional messaging

### Data/BI/Analytics Styles (11)
28. **Data-Dense Dashboard** — Multi-widget, data tables, KPI cards, efficient grid
29. **Heat Map & Heatmap Style** — Color-coded grid/matrix, gradient intensity
30. **Executive Dashboard** — High-level KPIs, large metrics, at-a-glance insights
31. **Real-Time Monitoring** — Live data, streaming charts, alert notifications
32. **Drill-Down Analytics** — Hierarchical exploration, expandable sections, breadcrumbs
33. **Comparative Analysis Dashboard** — Side-by-side, period-over-period, delta indicators
34. **Predictive Analytics** — Forecast lines, confidence intervals, anomaly detection
35. **User Behavior Analytics** — Funnel visualization, user flow diagrams, cohorts
36. **Financial Dashboard** — Revenue metrics, P&L, budget tracking, portfolio
37. **Sales Intelligence Dashboard** — Pipeline, quota tracking, leaderboard, win-loss

### Specialty & Avant-Garde Styles (30)
38. **Neubrutalism** — Bold borders, hard shadows, pop colors, Gen Z aesthetic
39. **Bento Box Grid** — Modular cards, Apple-style, varied sizes, soft shadows
40. **Y2K Aesthetic** — Neon pink, chrome, metallic, 2000s nostalgia
41. **Cyberpunk UI** — Neon on dark, terminal, HUD, sci-fi, glitch
42. **Organic Biophilic** — Nature-inspired, organic shapes, earth tones, flowing
43. **AI-Native UI** — Chatbot, conversational, streaming text, AI interactions
44. **Memphis Design** — 80s geometric, playful, postmodern, shapes/patterns
45. **Vaporwave** — Synthwave, sunset gradients, 80s-90s nostalgic, dreamy
46. **Dimensional Layering** — Z-index depth, overlapping cards, elevation, spatial
47. **Exaggerated Minimalism** — Oversized typography, extreme negative space
48. **Kinetic Typography** — Animated text, scroll-triggered, typing effects
49. **Parallax Storytelling** — Scroll-driven narrative, layered scrolling, cinematic
50. **Swiss Modernism 2.0** — Strict grid, Helvetica/Inter, mathematical spacing
51. **HUD / Sci-Fi FUI** — Fine lines, neon cyan/blue, technical markers, holographic
52. **Pixel Art** — 8-bit/16-bit, pixelated fonts, NES palette, retro gaming
53. **Bento Grids** — Modular cards, soft backgrounds, Apple/Linear aesthetic
54. **Spatial UI (VisionOS)** — Glass, depth, immersion, translucent, gaze-hover
55. **E-Ink / Paper** — Paper-like, matte, monochrome, reading-focused, calm
56. **Gen Z Chaos / Maximalism** — Clashing colors, stickers, collage, ironic
57. **Biomimetic / Organic 2.0** — Cellular shapes, breathing animations, generative
58. **Anti-Polish / Raw Aesthetic** — Hand-drawn, scanned textures, imperfect, human
59. **Tactile Digital / Deformable UI** — Jelly buttons, chrome, squishy, spring physics
60. **Nature Distilled** — Muted earthy, terracotta, sand, organic warmth
61. **Interactive Cursor Design** — Custom cursor, magnetic, morphing, trail effects
62. **Voice-First Multimodal** — Voice UI, waveform visualization, ambient
63. **3D Product Preview** — 360 rotation, AR preview, product configurator
64. **Gradient Mesh / Aurora Evolved** — Complex mesh gradients, flowing colors
65. **Editorial Grid / Magazine** — Asymmetric grid, pull quotes, drop caps
66. **Chromatic Aberration / RGB Split** — Color fringing, glitch, VHS, lens distortion
67. **Terminal CLI Monospace** — JetBrains Mono only, strict sizes, hacker aesthetic

### Mobile-Specific Style Configurations (In Typography)
Beyond the 67 main styles, the typography.csv includes 15 mobile-first style configurations:
- Neo Brutalism Mobile (Space Grotesk Heavy)
- Bold Typography Mobile (Inter-Tight Poster)
- Academia Mobile (Cormorant + Crimson + Cinzel)
- Cyberpunk Mobile (Orbitron + JetBrains Mono)
- Web3 Bitcoin DeFi (Space Grotesk + Inter + Mono)
- Claymorphism Mobile (Nunito + DM Sans)
- Enterprise SaaS Mobile (Plus Jakarta Sans)
- Sketch Hand-Drawn Mobile (Kalam + Patrick Hand)
- Neumorphism Mobile (Plus Jakarta Sans + System)
- Kinetic Brutalism (Space Grotesk)
- Flat Design Mobile (System Bold)
- Material You MD3 (Roboto System)
- Modern Dark Cinema (Inter System)
- SaaS Mobile Boutique (Calistoga + Inter)
- Bauhaus Geometric (Outfit)

---

## Complete Color Palette System (161 Palettes)

Organized by product type, each palette defines 14 color tokens:

```
Primary, On Primary, Secondary, On Secondary, Accent, On Accent,
Background, Foreground, Card, Card Foreground, Muted, Muted Foreground,
Border, Destructive, On Destructive, Ring
```

### Product Categories Covered
- SaaS (General, Micro, B2B, Enterprise)
- E-commerce (General, Luxury)
- Finance (Dashboard, Fintech/Crypto, Banking, Insurance, Personal Finance)
- Healthcare (App, Medical Clinic, Pharmacy, Dental, Veterinary, Mental Health)
- Education (App, Online Course, Coding Bootcamp, Language Learning)
- Media (News, Magazine/Blog, Podcast, Music Streaming, Video Streaming)
- Lifestyle (Beauty/Spa, Fitness/Gym, Wedding, Travel, Restaurant, Hotel)
- Gaming (General, Puzzle, Trivia, Card/Board, Idle, Word, Arcade)
- Real Estate, Automotive, Photography, Architecture
- Government, Non-profit, Legal, Church
- Developer Tools, Cybersecurity, IoT Dashboard
- Productivity, Notes, Calendar, Email, File Manager
- Social Media, Dating, Chat/Messaging
- Creator Economy, Freelancer, Marketing Agency
- NFT/Web3, AI/Chatbot, AI Photo, Generative Art
- Sports, Coworking, Delivery/Ride-Hailing
- Kids, Parenting, Senior Care, Childcare
- Home Services, Agriculture, Construction
- And 60+ more specialized types

---

## Complete Typography System (57+ Font Pairings)

Each font pairing includes:
- Font pair name and category
- Heading font + Body font
- Mood/style keywords
- Best-for use cases
- Google Fonts URL (share link)
- CSS `@import` statement
- Tailwind `fontFamily` config
- Design notes/context

### Pairing Categories
- **Serif + Sans**: Classic Elegant (Playfair Display/Inter), Luxury Serif (Cormorant/Montserrat), Editorial Classic, News Editorial
- **Sans + Sans**: Modern Professional (Poppins/Open Sans), Tech Startup (Space Grotesk/DM Sans), Minimal Swiss (Inter/Inter), Friendly SaaS (Plus Jakarta Sans), Corporate Trust (Lexend/Source Sans), Financial Trust (IBM Plex Sans)
- **Display + Sans**: Bold Statement (Bebas Neue/Source Sans), Playful Creative (Fredoka/Nunito), Retro Vintage (Abril Fatface/Merriweather), Fashion Forward (Syne/Manrope), Gaming Bold (Russo One/Chakra Petch), Sports/Fitness (Barlow Condensed/Barlow)
- **Mono + Sans**: Developer Mono (JetBrains Mono/IBM Plex Sans), Dashboard Data (Fira Code/Fira Sans)
- **Script + Sans/Serif**: Handwritten Charm (Caveat/Quicksand), Wedding/Romance (Great Vibes/Cormorant Infant)
- **Multi-language**: Vietnamese (Be Vietnam Pro/Noto Sans), Japanese (Noto Serif JP/Noto Sans JP), Korean (Noto Sans KR), Chinese Traditional/Simplified, Arabic, Thai, Hebrew
- **Specialty**: Brutalist Raw (Space Mono/Space Mono), Pixel Retro (Press Start 2P/VT323), Art Deco, Crypto/Web3 (Orbitron/Exo 2), Music/Entertainment, Accessibility First, Science/Tech, Kids/Education, Indie/Craft, Academic/Research, Minimalist Portfolio, Startup Bold

---

## Icon System

**Primary Library**: Phosphor Icons (`@phosphor-icons/react`)
**Fallback Library**: Heroicons (`@heroicons/react`)
**Strategy**: Use Phosphor's full collection (not limited to recommended list). When Phosphor lacks the right icon, use Heroicons maintaining stylistic consistency (outline/fill, stroke width, corner style).

### Icon Design Rules
- No emojis as structural icons (use SVG vectors)
- Consistent stroke width (1.5px or 2px) within visual layers
- Consistent filled vs outline discipline per hierarchy level
- Minimum 44x44pt touch target (use hitSlop for smaller icons)
- WCAG contrast: 4.5:1 for small elements, 3:1 for larger glyphs
- Align to text baseline with consistent padding

### Icon Categories (100+ recommendations)
Navigation (8), Actions (12), Status (8), Communication (5), User (5), Media (7), Commerce (7), Data (6), Files (7), Layout (6), Social (6), Device (5), Security (6), Location (4), Time (4), Development (4)

---

## UX Guidelines System (99+ Guidelines)

Organized into 10 priority-ranked categories:

| Priority | Category | Guidelines Count | Critical Checks |
|----------|----------|-----------------|-----------------|
| 1 | Accessibility | 14 | Contrast 4.5:1, focus states, alt text, ARIA labels, keyboard nav |
| 2 | Touch & Interaction | 17 | 44x44pt targets, 8px spacing, press feedback, gesture prevention |
| 3 | Performance | 19 | WebP/AVIF, lazy loading, CLS <0.1, virtualize lists, debounce |
| 4 | Style Selection | 13 | Match product type, SVG icons, platform idioms, semantic tokens |
| 5 | Layout & Responsive | 16 | Mobile-first, spacing scale, z-index system, safe areas |
| 6 | Typography & Color | 16 | Line-height 1.5+, font pairing, semantic colors, dark mode |
| 7 | Animation | 23 | 150-300ms, transform/opacity only, spring physics, reduced motion |
| 8 | Forms & Feedback | 30 | Visible labels, inline validation, error recovery, focus management |
| 9 | Navigation Patterns | 26 | Bottom nav <5, deep linking, back behavior, state preservation |
| 10 | Charts & Data | 30 | Legends, tooltips, accessible colors, data tables, large datasets |

---

## Chart Types System (25 Types)

Each chart type includes: data type, keywords, best chart, secondary options, when to use/not use, data volume thresholds, color guidance, accessibility grade (A-D), accessibility notes, fallback options, library recommendations, and interactive level.

Categories: Trend/Time-Series, Comparison, Part-to-Whole, Correlation/Distribution, Heatmap/Intensity, Geographic, Funnel/Flow, Performance vs Target, Forecasting, Anomaly Detection, Hierarchical, Process Flow, Cumulative Changes, Multi-Variable, Stock/OHLC, Network/Graph, Statistical, Bullet KPIs, Proportional, Hierarchical Proportional, Root Cause Analysis, 3D Spatial, Real-Time Streaming, Sentiment/Emotion, Process Mining.

---

## Landing Page Patterns (34 Patterns)

Each pattern defines: section order, CTA placement strategy, color strategy, recommended effects, conversion optimization notes.

Categories: Hero-centric, Conversion-optimized, Feature-rich, Minimal/Direct, Social-proof, Interactive Demo, Trust/Authority, Storytelling, Video-first, Waitlist/Coming Soon, Pricing-focused, Comparison-focused, Lead magnet, App store style, FAQ/Documentation, Immersive/Interactive, Event/Conference, Review/Ratings, Community/Forum, Before-After Transformation, Marketplace/Directory, Newsletter/Content, Webinar Registration, Enterprise Gateway, Portfolio Grid, Horizontal Scroll Journey, Bento Grid Showcase, 3D Configurator, AI-Driven Dynamic, Real-Time/Operations, and more.

---

## Configuration & Customization

### How to Invoke Specific Features

**Design system generation** (most common workflow):
```bash
python3 skills/ui-ux-pro-max/scripts/search.py "AI search tool modern minimal" --design-system -p "AI Search"
```

**Fine-grained style search**:
```bash
python3 skills/ui-ux-pro-max/scripts/search.py "glassmorphism aurora dark" --domain style -n 3
```

**Color palette for specific product**:
```bash
python3 skills/ui-ux-pro-max/scripts/search.py "luxury fashion" --domain color -n 2
```

**Typography for mood**:
```bash
python3 skills/ui-ux-pro-max/scripts/search.py "playful friendly rounded" --domain typography -n 2
```

**UX validation pass** (before delivery):
```bash
python3 skills/ui-ux-pro-max/scripts/search.py "animation accessibility z-index loading" --domain ux
```

**Stack-specific best practices**:
```bash
python3 skills/ui-ux-pro-max/scripts/search.py "list performance navigation" --stack react-native
```
