# Design Patterns & Anti-Patterns — taste-skill

## Anti-Pattern Catalog: What taste-skill Bans

The following catalog documents every "NEVER DO" rule extracted from the taste-skill framework. Each anti-pattern includes the banned pattern and the recommended replacement. Patterns are organized by domain.

---

## Typography Anti-Patterns

### 1. Inter Font
**Banned:** Inter (the most common AI font default)
**Replace with:** Geist, Outfit, Cabinet Grotesk, Satoshi, Clash Display, Plus Jakarta Sans
**Scope:** Universal across all skill variants

### 2. Generic Web Fonts
**Banned:** Roboto, Arial, Open Sans, Helvetica, system-ui defaults
**Replace with:** Premium geometric/neo-grotesque fonts with character
**Rationale:** These fonts signal "default browser" and remove brand personality

### 3. Serif Fonts in Dashboards/Software UI
**Banned:** Any serif font in dashboard, SaaS, or software interfaces
**Replace with:** High-end sans-serif pairings: Geist + Geist Mono, Satoshi + JetBrains Mono
**Exception:** Serif is allowed for creative/editorial/lifestyle projects only

### 4. Generic Serif Fonts (Even in Editorial Contexts)
**Banned:** Times New Roman, Georgia, Garamond, Palatino
**Replace with:** Distinctive modern serifs: Fraunces, Gambarino, Editorial New, Instrument Serif

### 5. Oversized H1 Headings
**Banned:** Screamingly large headings that are just massive scale without hierarchy
**Replace:** Control hierarchy through weight and color contrast, not only massive font size

### 6. All-Caps Everywhere
**Banned:** Lazy all-caps for every subheader
**Replace:** Try lowercase italics, sentence case, or small-caps for variety

### 7. Title Case On Every Header
**Banned:** Uniform Title Case formatting on all headings
**Replace:** Use sentence case — reads more naturally and feels designed

### 8. Only Regular (400) and Bold (700) Weights
**Banned:** Two-weight typographic scale
**Replace:** Introduce Medium (500) and SemiBold (600) for more subtle hierarchy tiers

### 9. Numbers in Proportional Font
**Banned:** Data/metrics in proportional/variable-width fonts
**Replace:** Monospace font or tabular figures (`font-variant-numeric: tabular-nums`)

### 10. Orphaned Words
**Banned:** Single words sitting alone on the last line of paragraphs
**Replace:** `text-wrap: balance` or `text-wrap: pretty`

### 11. Excessive Gradient Text
**Banned:** Text-fill gradients on large headers as a lazy "premium" effect
**Replace:** Use typographic contrast and weight hierarchy instead

### 12. 6-Line Wrapped Hero Headings
**Banned:** Hero headlines spanning 4-6 lines
**Replace:** Ultra-wide containers (`max-w-5xl`, `max-w-6xl`), smaller font size (`clamp(3rem, 5vw, 5.5rem)`), max 2-3 lines

---

## Color Anti-Patterns

### 13. THE LILA BAN — Purple/Blue AI Gradient Aesthetic
**Banned:** Purple/blue neon gradients, purple button glows, purple-to-blue mesh gradients
**Replace:** Neutral bases (Zinc/Slate) with high-contrast singular accents (Emerald, Electric Blue, Deep Rose)
**Scope:** Universal — this is the #1 AI design fingerprint

### 14. Pure Black (#000000)
**Banned:** Any use of absolute black
**Replace:** Off-Black, Zinc-950 (`#18181B`), Charcoal, or tinted dark backgrounds

### 15. Oversaturated Accent Colors
**Banned:** Accent colors with saturation above 80%
**Replace:** Desaturate accents to blend elegantly with neutrals

### 16. More Than One Accent Color
**Banned:** Multiple competing accent colors in one project
**Replace:** Pick exactly one accent, use it consistently

### 17. Mixing Warm and Cool Grays
**Banned:** Warm gray in one section, cool gray in another
**Replace:** Stick to one gray family, tint all grays with consistent hue

### 18. Neon/Outer Glow Shadows
**Banned:** Default `box-shadow` glows, auto-glows, neon edges, glow halos
**Replace:** Inner borders, subtle tinted shadows, colored shadows matching background hue

### 19. Generic Box-Shadow
**Banned:** Untinted `box-shadow: rgba(0,0,0,0.1)` on everything
**Replace:** Tint shadows to background hue; colored shadows on colored backgrounds

### 20. Rainbow/Mesh Blob Gradients
**Banned:** Multi-color rainbow gradients, floating colored blobs
**Replace:** Low-chroma palette-matched tonal gradients, single-hue atmospheric grades

### 21. Pink-to-Orange "Creator" Gradients
**Banned:** Default pink-orange social media gradient aesthetic
**Replace:** Brand-matched tonal gradients with purpose

### 22. Inconsistent Lighting Direction
**Banned:** Shadows suggesting different light sources across components
**Replace:** Audit all shadows to ensure a single, consistent light source

### 23. Random Dark Sections in Light Mode (or Vice Versa)
**Banned:** A single dark-background section breaking an otherwise light page
**Replace:** Consistent background tone throughout; use slightly darker shade of same palette for contrast

### 24. Primary Colored Large Backgrounds (Minimalist)
**Banned:** Large elements/sections with bright blue, green, or red backgrounds
**Replace:** Warm monochrome palette with muted pastel accents

### 25. Gradients/Neon/3D Glassmorphism (Minimalist)
**Banned:** Any gradients, neon colors, or 3D glass effects
**Replace:** Ultra-flat design with subtle ambient depth through spacing and typography

### 26. Gradients/Soft Shadows/Translucency (Brutalist)
**Banned:** All gradient, soft shadow, and glass-like effects
**Replace:** Hard mechanical colors, visible dividing lines, CRT-like emissive displays

---

## Layout Anti-Patterns

### 27. Centered Hero/H1 Sections (When Variance > 4)
**Banned:** Perfectly centered hero text/sections
**Replace:** Split screen (50/50), left-aligned content/right asset, asymmetric whitespace structures
**Override:** Allowed only when DESIGN_VARIANCE is 1-3

### 28. Three Equal Card Columns as Feature Row
**Banned:** The generic "3 equal cards horizontally" feature row
**Replace:** 2-column zig-zag, asymmetric grid, horizontal scrolling, masonry layout
**Scope:** Universal — this is the #2 AI layout fingerprint

### 29. Complex Flexbox Percentage Math
**Banned:** `w-[calc(33%-1rem)]` and similar flexbox percentage hacks
**Replace:** CSS Grid: `grid grid-cols-1 md:grid-cols-3 gap-6`

### 30. Using `h-screen` for Full-Height Sections
**Banned:** `height: 100vh` or Tailwind's `h-screen`
**Replace:** `min-height: 100dvh` or `min-h-[100dvh]` (prevents iOS Safari viewport jumping)

### 31. Edge-to-Edge Sticky Navbars
**Banned:** Full-width, glued-to-top navigation bars
**Replace:** Floating glass pill nav (`mt-6 mx-auto w-max rounded-full`)

### 32. Symmetrical 3-Column Bootstrap-Style Grids
**Banned:** Uniform 3-column grids without massive whitespace gaps
**Replace:** Asymmetric bento, masonry, or oversized negative-space layouts

### 33. Cards-Inside-Cards-Inside-Cards
**Banned:** Nested container hierarchies: cards inside larger cards inside outer cards
**Replace:** Open layouts, clearer whitespace, fewer but stronger containers, flatter hierarchy

### 34. Giant Rounded Section Wrappers
**Banned:** Massive rounded containers wrapping entire sections
**Replace:** One primary framing move rather than many layered frames; direct alignment

### 35. No Max-Width Container
**Banned:** Content stretching edge-to-edge on wide screens
**Replace:** `max-w-[1400px] mx-auto` or `max-w-7xl` containment

### 36. Cards of Equal Height Forced by Flexbox
**Banned:** Uniform card heights when content varies in length
**Replace:** Allow variable heights or use masonry layout

### 37. Uniform Border-Radius on Everything
**Banned:** Same border-radius on every element
**Replace:** Vary radius: tighter on inner elements, softer on containers

### 38. No Overlap or Depth (Flat-Only Layout)
**Banned:** Elements sitting flat next to each other with zero layering
**Replace:** Negative margins for layering, z-axis cascades, subtle rotations (-2deg to 3deg)

### 39. Symmetrical Vertical Padding
**Banned:** Identical top and bottom padding everywhere
**Replace:** Adjust optically — bottom padding often needs to be slightly larger

### 40. Dashboard Always Has Left Sidebar
**Banned:** Default sidebar+dashboard architecture for every dashboard
**Replace:** Try top navigation, floating command menu, or collapsible panels

### 41. Buttons Not Bottom-Aligned in Card Groups
**Banned:** CTAs at random heights when cards have different content lengths
**Replace:** Pin buttons to bottom of each card for clean horizontal line

### 42. Feature Lists Starting at Different Vertical Positions
**Banned:** Misaligned feature lists in pricing tables or comparison cards
**Replace:** Fixed-height title/price blocks, consistent vertical rhythm

### 43. Mathematical Alignment That Looks Optically Wrong
**Banned:** Trusting math over the eye for centering
**Replace:** 1-2px optical adjustments on icons next to text, play buttons, CTA text

### 44. Empty Cells in CSS Grids
**Banned:** Blank/dead cells left in bento grid layouts
**Replace:** `grid-auto-flow: dense`, mathematically verified col-span/row-span interlocking

### 45. Same Composition Anchor Repeating >2 Sections in a Row
**Banned:** Identical text-alignment pattern across consecutive sections
**Replace:** At least 3 different composition anchors across any multi-section site

### 46. Same Background Mode Repeating >3 Sections in a Row
**Banned:** Identical background treatment across consecutive sections
**Replace:** Vary: solid surface, full-bleed image, editorial side-image, tonal gradient

---

## Component Anti-Patterns

### 47. Generic Card Look (Border + Shadow + White Background)
**Banned:** The default "white card with border and drop shadow"
**Replace:** Remove border, or use only background, or use only spacing; cards only when elevation serves hierarchy

### 48. shadcn/ui in Default State
**Banned:** Uncustomized shadcn/ui components with default radii, colors, and shadows
**Replace:** Customize radii, colors, and shadows to match the specific project aesthetic

### 49. Always One Filled Button + One Ghost Button
**Banned:** The same button pairing pattern everywhere
**Replace:** Add text links, tertiary styles, or varied CTA formats to reduce visual noise

### 50. Pill-Shaped "New" and "Beta" Badges
**Banned:** Standard pill badge for status indicators
**Replace:** Square badges, flags, plain text labels, or context-appropriate alternatives

### 51. Accordion FAQ Sections (As Default)
**Banned:** Generic accordion FAQ pattern
**Replace:** Side-by-side list, searchable help, or inline progressive disclosure

### 52. 3-Card Carousel Testimonials with Dots
**Banned:** Auto-rotating testimonial carousel with indicator dots
**Replace:** Masonry wall of quotes, embedded social posts, single rotating quote

### 53. Pricing Table with 3 Towers
**Banned:** Standard three-column pricing table with equal treatment
**Replace:** Highlight recommended tier with color and emphasis, not just extra height

### 54. Modals for Everything
**Banned:** Overuse of modal dialogs for simple actions
**Replace:** Inline editing, slide-over panels, expandable sections

### 55. Avatar Circles Exclusively
**Banned:** Every avatar as a perfect circle
**Replace:** Squircles, rounded squares for less generic look

### 56. Light/Dark Toggle Always Sun/Moon Switch
**Banned:** Default sun/moon icon toggle for theme switching
**Replace:** Dropdown, system preference detection, integrate into settings

### 57. Footer Link Farm with 4 Columns
**Banned:** Dense 4-column footer with every possible link
**Replace:** Simplified footer focused on main navigational paths and legally required links

### 58. Lucide or Feather Icons Exclusively
**Banned:** Defaulting to Lucide or Feather as the only icon set
**Replace:** Phosphor (Bold or Light weights), Radix UI Icons, or custom icon sets

### 59. Cliche Icon Metaphors
**Banned:** Rocketship for "Launch", shield for "Security", gear for "Settings"
**Replace:** Less obvious yet meaningful icons: bolt, fingerprint, spark, vault

### 60. Inconsistent Stroke Widths Across Icons
**Banned:** Icons with different stroke widths in the same interface
**Replace:** Audit and standardize to one stroke weight globally (1.5 or 2.0)

### 61. Thick-Stroked Lucide, FontAwesome, or Material Icons (Soft-Skill)
**Banned:** Standard thick-stroke icon libraries for premium designs
**Replace:** Ultra-light precise lines: Phosphor Light, Remix Line

### 62. Generic Avatars
**Banned:** Standard SVG "egg" or Lucide user icons for avatars
**Replace:** Creative, believable photo placeholders or specific stylistic alternatives

### 63. Faux-OS Window Chrome Without Purpose
**Banned:** Decorative browser chrome that doesn't show real product
**Replace:** Use only when showing actual product interface in context

---

## Content & Copy Anti-Patterns

### 64. Generic Names
**Banned:** "John Doe", "Sarah Chan", "Jack Su", "Jane Smith"
**Replace:** Highly creative, realistic-sounding names from diverse origins

### 65. Fake Round Numbers
**Banned:** `99.99%`, `50%`, `$100.00`, `1234567`
**Replace:** Organic, messy data: `47.2%`, `$99.00`, `+1 (312) 847-1928`

### 66. Startup Slop Names
**Banned:** "Acme", "Nexus", "SmartFlow", "Flowbit", "Quantumly", "NovaCore"
**Replace:** Invent premium, contextual brand names that sound real

### 67. AI Copywriting Cliches
**Banned:** "Elevate", "Seamless", "Unleash", "Next-Gen", "Game-changer", "Delve", "Tapestry", "In the world of...", "Revolutionize", "Powerful solution", "Transformative platform"
**Replace:** Plain, specific, concrete verbs and descriptive language

### 68. Exclamation Marks in Success Messages
**Banned:** "Successfully saved!" — enthusiastic punctuation in system messages
**Replace:** Confident, calm: "Changes saved."

### 69. "Oops!" Error Messages
**Banned:** Cutesy error messaging
**Replace:** Direct and informative: "Connection failed. Please try again."

### 70. Passive Voice in Copy
**Banned:** "Mistakes were made" / "Your changes couldn't be saved"
**Replace:** Active voice: "We couldn't save your changes"

### 71. Lorem Ipsum
**Banned:** Any placeholder Latin text
**Replace:** Write real draft copy or use contextual placeholder text

### 72. Identical Blog Post Dates
**Banned:** All blog posts showing the same date
**Replace:** Randomize dates to appear real

### 73. Same Avatar for Multiple Users
**Banned:** Reusing one avatar image across multiple user profiles
**Replace:** Unique assets for every distinct person

### 74. Filler UI Text
**Banned:** "Scroll to explore", "Swipe down", scroll arrow icons, bouncing chevrons
**Replace:** Let the content pull users in naturally; remove all filler directional prompts

### 75. Meta-Labels
**Banned:** "SECTION 01", "SECTION 04", "QUESTION 05", "ABOUT US" as visible labels
**Replace:** Remove entirely — they look cheap and unprofessional

### 76. Pseudo-Enterprise Jargon
**Banned:** Decorative system markers, fake control labels, "00 orchestration layer", filler operator/control-room labels
**Replace:** Cleaner headings, fewer labels, real hierarchy

### 77. Fake Complexity Slop
**Banned:** Pseudo-enterprise control labels, decorative runtime markers, filler status microcopy
**Replace:** Only include technical text when it serves a genuine brand or function purpose

---

## Image & Asset Anti-Patterns

### 78. Broken Unsplash Links
**Banned:** `unsplash.com` URLs that will break
**Replace:** `https://picsum.photos/seed/{keyword}/1920/1080` or SVG UI Avatars

### 79. Stock "Diverse Team" Photos
**Banned:** Generic stock photography of smiling teams
**Replace:** Real team photos, candid shots, consistent illustration style, or art-directed abstract visuals

### 80. Missing Favicon
**Banned:** No favicon included in the build
**Replace:** Always include a branded favicon

### 81. Missing Alt Text on Images
**Banned:** `alt=""` or `alt="image"` on meaningful images
**Replace:** Describe image content for screen readers

### 82. Giant Meaningless Outline Numbers
**Banned:** Decorative oversized numerals with no semantic purpose
**Replace:** Typography, image crops, real layout tension instead

### 83. Cheap SVG Filler Graphics
**Banned:** Auto-generated-looking SVG decorations
**Replace:** Premium materials, strong framing, real design elements

### 84. Random Floating Blobs/Orbs
**Banned:** Meaningless floating colored spheres as decoration
**Replace:** Structured background treatments: tonal gradients, controlled texture, paper grain

### 85. Compressing Multiple Sections into One Image
**Banned:** One giant collage image for multi-section websites
**Replace:** One separate horizontal image per section for analysis and extraction quality

### 86. Cropping Old Images for New Sections
**Banned:** Slicing/extracting sections from previously generated full-page images
**Replace:** Generate fresh standalone images for each section needing visibility

---

## Code Quality Anti-Patterns

### 87. Div Soup
**Banned:** Layouts built entirely from `<div>` elements
**Replace:** Semantic HTML: `<nav>`, `<main>`, `<article>`, `<aside>`, `<section>`

### 88. Inline Styles Mixed with CSS Classes
**Banned:** Inline `style=` attributes alongside class-based styling
**Replace:** Move all styling to the project's styling system (Tailwind, CSS modules, styled-components)

### 89. Hardcoded Pixel Widths
**Banned:** Fixed pixel values for layout dimensions
**Replace:** Relative units: `%`, `rem`, `em`, `max-width`, `clamp()`

### 90. Arbitrary Z-Index Values (9999)
**Banned:** Random `z-50`, `z-[9999]`, `z-10` without system
**Replace:** Clean z-index scale reserved for systemic layers: sticky nav, modals, overlays, tooltips

### 91. Commented-Out Dead Code
**Banned:** Debug artifacts, commented-out blocks
**Replace:** Remove all dead code before shipping

### 92. Import Hallucinations
**Banned:** Imports for packages not in `package.json`
**Replace:** Check `package.json` first; output install command if missing

### 93. Missing Meta Tags
**Banned:** Pages without proper `<title>`, description, `og:image`, social sharing tags
**Replace:** Add complete meta tag set for SEO and social sharing

### 94. Missing "Skip to Content" Link
**Banned:** No skip-link for keyboard users
**Replace:** Add a hidden skip-link as the first focusable element

### 95. Placeholder Comments in Code
**Banned:** `// TODO`, `// implement here`, `// rest of code`, `// similar to above`
**Replace:** Write the complete implementation; never output skeletal code

### 96. No Custom 404 Page
**Banned:** Default browser 404 for missing routes
**Replace:** Design a helpful, branded "page not found" experience

### 97. Dead Links (href="#")
**Banned:** Buttons and links pointing to `#`
**Replace:** Link to real destinations or visually disable placeholder links

### 98. No Indication of Current Page in Navigation
**Banned:** All nav links styled identically
**Replace:** Style the active nav link differently so users know their location

---

## Motion & Interaction Anti-Patterns

### 99. Linear or Ease-In-Out Transitions
**Banned:** Standard `linear`, `ease`, `ease-in-out` timing functions
**Replace:** Spring physics (`stiffness: 100, damping: 20`) or custom cubic-beziers (`cubic-bezier(0.16, 1, 0.3, 1)`)

### 100. Instant State Changes Without Interpolation
**Banned:** No transition between component states
**Replace:** Every state change must have interpolated motion (200-300ms minimum)

### 101. Animation of Layout-Triggering Properties
**Banned:** Animating `top`, `left`, `width`, `height`, `margin`, `padding`
**Replace:** Animate exclusively `transform` and `opacity` (GPU compositable)

### 102. Using `window.addEventListener('scroll')`
**Banned:** Scroll handler with direct event listener attachment
**Replace:** IntersectionObserver or Framer Motion's `whileInView`

### 103. Using React useState for Continuous Animations
**Banned:** `useState` for magnetic hover or infinite animation loops
**Replace:** Framer Motion's `useMotionValue` and `useTransform` (outside React render cycle)

### 104. Mixing GSAP/ThreeJS with Framer Motion in Same Component Tree
**Banned:** Multiple animation engines in one component hierarchy
**Replace:** Framer Motion for UI/bento interactions; GSAP/ThreeJS exclusively for isolated full-page scrolltelling or canvas backgrounds

### 105. Grain/Noise on Scrolling Containers
**Banned:** Noise filters on content that scrolls
**Replace:** Apply exclusively to fixed, `pointer-events-none` pseudo-elements

### 106. Backdrop-Blur on Scrolling Content
**Banned:** `backdrop-filter: blur()` on regular content areas
**Replace:** Apply only to fixed or sticky elements (navbars, overlays)

### 107. Auto-Play-Style Hero Dots
**Banned:** Carousel dots with auto-rotation in hero sections
**Replace:** Static, intentional composition — no auto-advancing UI

### 108. Infinity Logo Strips Repeating Same 6 Logos
**Banned:** Auto-scrolling "trusted by" tickers with repetitive logos
**Replace:** Curated, static logo display with real brand relationships

---

## Approved Style Directions

The framework defines these approved visual directions that override generic defaults:

### From taste-skill / soft-skill:
1. **Ethereal Glass (SaaS/AI/Tech):** Deep OLED black backgrounds, radial mesh gradients, Vantablack cards with heavy `backdrop-blur-2xl`, pure white/10 hairlines, wide geometric Grotesk typography
2. **Editorial Luxury (Lifestyle/Real Estate/Agency):** Warm creams (`#FDFBF7`), muted sage, deep espresso tones, high-contrast Variable Serif headers, subtle CSS noise/film-grain overlay
3. **Soft Structuralism (Consumer/Health/Portfolio):** Silver-grey or white backgrounds, massive bold Grotesk typography, airy floating components, highly diffused ambient shadows

### From gpt-tasteskill:
4. **Cinematic Center:** Massively wide center-aligned hero with 2 CTAs below, full-bleed background image with dark radial wash
5. **Artistic Asymmetry:** Text offset left, artistic floating image overlapping from bottom right
6. **Editorial Split:** Text left, image right, massive negative space between

### From imagegen-frontend-web:
7. **Pristine Light Mode:** Off-white/cream/paper tones, sharp dark text, editorial confidence
8. **Deep Dark Mode:** Charcoal/graphite/zinc, elegant glow only when justified
9. **Bold Studio Solid:** Strong controlled color fields (oxblood, royal blue, forest, vermilion, emerald)
10. **Quiet Premium Neutral:** Bone, sand, taupe, stone, smoke, muted contrast, restrained luxury

### From minimalist-skill:
11. **Premium Utilitarian Minimalism:** Warm monochrome palette, editorial serif+sans pairing, ultra-flat bento grids, muted pastel accents only, 1px `#EAEAEA` borders

### From brutalist-skill:
12. **Swiss Industrial Print:** High-contrast light mode, newsprint/off-white substrates, monolithic heavy sans-serif, visible structural grids, primary red as alert/accent
13. **Tactical Telemetry/CRT Terminal:** Dark mode exclusivity, high-density tabular data, monospaced dominance, ASCII framing devices, simulated phosphor glow and scanlines

## Component Quality Checklist

Before marking any component complete, verify against this matrix:

- [ ] Does it avoid looking like a default Tailwind or shadcn/ui template?
- [ ] Does it have intentional hover, focus, active states?
- [ ] Does it use hierarchy rather than uniform emphasis?
- [ ] Does it use the Double-Bezel nested architecture where appropriate?
- [ ] Are CTA buttons using the Button-in-Button trailing icon pattern where applicable?
- [ ] Is `backdrop-blur` only on fixed/sticky elements?
- [ ] Are animations using only `transform` and `opacity`?
- [ ] Does it contain at least one perpetual micro-interaction for live-feeling interfaces?
- [ ] Are loading, empty, and error states provided?
- [ ] Would this look believable in a real product screenshot?
- [ ] Does the mobile collapse work (single-column below 768px)?
- [ ] Is the overall impression "$150k agency build" level?

## Component Architecture: The Double-Bezel (Doppelrand)

A signature premium pattern from soft-skill that defines how cards and containers should be structured:

- **Outer Shell:** Wrapper `<div>` with subtle background (black/5 or white/5), hairline border (`ring-1 ring-black/5` or `border border-white/10`), specific padding (`p-1.5` or `p-2`), large outer radius (`rounded-[2rem]`)
- **Inner Core:** Content container inside shell with distinct background, inner highlight (`shadow-[inset_0_1px_1px_rgba(255,255,255,0.15)]`), mathematically smaller radius (`rounded-[calc(2rem-0.375rem)]`) for concentric curves

This creates a "physical machined hardware" look — like a glass plate sitting in an aluminum tray.

## The Motion-Engine Bento Paradigm

A signature layout philosophy for SaaS dashboards and feature sections:

- Background: `#f9fafb`
- Cards: pure white with `border-slate-200/50`
- Radius: `rounded-[2.5rem]`
- Shadow: "diffusion shadow" — `shadow-[0_20px_40px_-15px_rgba(0,0,0,0.05)]`
- Typography: Geist/Satoshi/Cabinet Grotesk with `tracking-tight`
- Labels: placed outside and below cards (gallery-style)
- Padding: `p-8` or `p-10` inside cards
- Motion: perpetual spring-physics micro-interactions (stiffness 100, damping 20)
- Five archetypes: Intelligent List, Command Input, Live Status, Wide Data Stream, Contextual UI
