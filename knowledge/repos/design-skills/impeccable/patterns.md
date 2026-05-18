# Impeccable — Design Patterns & Techniques

## Style Direction Catalog

Impeccable does not mandate a single visual style but provides a decision framework for selecting one. Style direction selection follows the brief, physical-object reasoning, and the reflex-reject discipline below.

### Aesthetic Lanes (Brand Register)
Brand surfaces span every genre. The methodology recognizes but warns against the currently saturated lanes:
- **Editorial-typographic**: display serif (often italic) + small mono labels + ruled separators + monochromatic restraint. By 2026, saturated by Stripe-adjacent and Notion-adjacent brands.
- **Brutalist-utility**: raw, functional, grid-exposed. Approaching saturation.
- **Acid-maximalism**: high chroma, deliberate visual chaos. Approaching saturation.

The key principle: if a brief lands in a saturated lane without a register reason that *requires* it (a literal magazine, a literal terminal, a literal industrial signage system), look further.

### Physical-Object Reasoning
Before committing to visual moves, derive the aesthetic from a physical object: a museum caption, a 1970s terminal manual, a fabric label, a cheap-newsprint children's book, a concert poster, a receipt from a mid-century diner. "Elegant" is not necessarily serif. "Technical" is not necessarily sans. "Warm" is not Fraunces.

## Typography Pairings & Strategy

### Font Selection Procedure (Brand Register)
1. Read the brief. Write three concrete brand-voice words (not "modern" or "elegant" — "warm and mechanical and opinionated" or "calm and clinical and careful")
2. List the three fonts you'd reach for by reflex. If any appear in the reflex-reject list, reject them.
3. Browse a real catalog (Google Fonts, Pangram Pangram, Future Fonts, Adobe Fonts, ABC Dinamo, Klim, Velvetyne) with the three words.
4. Cross-check. If the final pick lines up with the original reflex, start over.

### Reflex-Reject Font List
Training-data defaults that produce monoculture. Banned: Fraunces, Newsreader, Lora, Crimson, Crimson Pro, Crimson Text, Playfair Display, Cormorant, Cormorant Garamond, Syne, IBM Plex Mono/Sans/Serif, Space Mono, Space Grotesk, Inter, DM Sans, DM Serif Display/Text, Outfit, Plus Jakarta Sans, Instrument Sans, Instrument Serif.

### Pairing by Genre
- **Editorial/long-form/luxury**: display serif + sans body (magazine shape)
- **Tech/dev tools/fintech**: one committed sans, custom-tight tracking, strong weight contrast inside single family
- **Consumer/food/travel**: warmer pairings, humanist sans + script or display serif
- **Creative studios/agencies**: rule-breaking welcome — mono-only, display-only, or custom-drawn

### The One-Family Truth
Two families minimum is a rule only when the voice needs it. A single well-chosen family with committed weight/size contrast is stronger than a timid display+body pair. Only add a second font when you need genuine contrast.

### Contrast Axes for Pairing
- Serif + Sans (structure contrast)
- Geometric + Humanist (personality contrast)
- Condensed display + Wide body (proportion contrast)
- Never pair fonts that are similar but not identical (two geometric sans-serifs create tension without hierarchy)

### Anti-Reflex Corrections
- A technical/utilitarian brief does NOT need a serif "for warmth"
- An editorial/premium brief does NOT need the same expressive serif everyone uses
- A children's product does NOT need a rounded display font
- A "modern" brief does NOT need a geometric sans

### Fluid vs. Fixed Typography
- **Fluid via clamp()**: headings and display text on marketing/content pages. Bound clamp() at max-size <= ~2.5x min-size.
- **Fixed rem scales**: app UIs, dashboards, data-dense interfaces. Body text is fixed even on marketing pages.
- Scale container width and font-size together so character measure stays 45-75ch at every viewport.

### Typographic Scale
Modular scale with >=1.25 ratio between steps. Popular ratios: 1.25 (major third), 1.333 (perfect fourth), 1.5 (perfect fifth). Pick one and commit. A 5-size system: xs (0.75rem, captions), sm (0.875rem, secondary), base (1rem, body), lg (1.25-1.5rem, subheadings), xl+ (2-4rem, headlines).

### OpenType Features for Polish
- `font-variant-numeric: tabular-nums` for data tables
- `font-variant-numeric: diagonal-fractions` for fractions
- `font-variant-caps: all-small-caps` for abbreviations
- `font-variant-ligatures: none` for code
- `font-kerning: normal` explicitly on body
- `text-wrap: balance` on headings, `text-wrap: pretty` on long prose
- `font-optical-sizing: auto` for variable fonts
- ALL-CAPS tracking: add 0.05em to 0.12em letter-spacing

### Web Font Loading
- `font-display: swap` for visibility (shows fallback immediately, swaps when loaded)
- `font-display: optional` when zero layout shift matters more than branded font
- Preload only the critical weight (typically regular-weight body font above fold)
- Variable fonts for 3+ weights/styles (single file, fractional weight control, `font-optical-sizing: auto`)
- `size-adjust`, `ascent-override`, `descent-override`, `line-gap-override` to match fallback metrics

## Color Strategies

### OKLCH-Only Rule
All colors declared in OKLCH: `oklch(lightness chroma hue)`. Perceptually uniform — equal lightness steps look equal. HSL does not have this property.

### The 60-30-10 Rule (Visual Weight, Not Pixel Count)
- 60%: neutral backgrounds, white space, base surfaces
- 30%: secondary colors (text, borders, inactive states)
- 10%: accent (CTAs, highlights, focus states)
- Accent colors work because they're rare. Overuse kills their power.

### Tinted Neutrals
Pure gray (`oklch(50% 0 0)`) is dead. Add chroma 0.005-0.015 to all neutrals, hued toward the brand color. The chroma is small enough not to read as "tinted" consciously, but creates subconscious cohesion. Never default to warm orange or cool blue — tint toward the specific brand.

### Palette Structure
- Primary: 1 color, 3-5 shades (brand, CTAs, key actions)
- Neutral: 9-11 shade scale (text, backgrounds, borders)
- Semantic: 4 colors, 2-3 shades each (success, error, warning, info)
- Surface: 2-3 elevation levels (cards, modals, overlays)
- Skip secondary/tertiary unless needed. One accent suffices for most apps.

### Dark Mode Architecture
Depth comes from surface lightness, not shadow. Build a 3-step surface scale where higher elevations are lighter (15%/20%/25%). Use the SAME hue and chroma as brand color; only vary lightness. Reduce body text weight slightly (350 vs 400) because light-on-dark reads heavier. Desaturate accents slightly. Use two-layer token hierarchy: primitive tokens (unchanging) + semantic tokens (redefined for dark).

### Tinted Neutrals for Dark Mode
Tint dark neutrals toward the brand hue at 0.005-0.01 chroma. Never pure black. No "warm yellow" defaults — cool-leaning brands should cool-tint their dark neutrals.

### Brand Register Color Permissions
Brand surfaces have permission for Committed, Full palette, and Drenched strategies:
- Name a real reference before picking ("Klim Type Foundry #ff4500 orange drench", "Stripe purple-on-white restraint")
- Palette IS voice. A calm brand and a restless brand should not share palette mechanics
- Don't converge across projects. If last brand surface was restrained-on-cream, this one is not
- When cultural-symbol palette is the obvious pull, reach past it. Let cultural reading come from typography, imagery, and copy

## Layout Patterns

### Spacing Systems
- **4px base, not 8px**: 8px systems are too coarse; 12px sits between 8 and 16. Use 4, 8, 12, 16, 24, 32, 48, 64, 96px.
- Name tokens semantically (`--space-sm`, `--space-lg`), not by value (`--spacing-8`).
- Use `gap` instead of margins for sibling spacing — eliminates margin collapse.
- Vary for rhythm. Same spacing everywhere is monotony.

### Grid Systems
- **Self-adjusting grid**: `repeat(auto-fit, minmax(280px, 1fr))` for breakpoint-free responsiveness.
- **Named grid areas**: `grid-template-areas` redefined at breakpoints for complex layouts.
- Asymmetric compositions for brand surfaces — break the grid intentionally for emphasis.
- Strict visible grid as voice for brutalist/Swiss/tech-spec aesthetics.
- Don't default to centering everything. Left-aligned with asymmetric layouts feels more designed. Centered-stack hero with icon-title-subtitle cards reads as template.

### Content Width Constraints
- Content blocks cap at 900px
- Page-level containers at 1400px
- Prose at 65-75ch via `max-width`
- Use `ch` units for character-based measure

### Visual Hierarchy Through Multiple Dimensions
Combine 2-3 dimensions at once: a heading that's larger, bolder, AND has more space above it. Tools: size (3:1+ ratio for strong), weight (bold vs regular), color (high contrast), position (top/left primary), space (surrounded by whitespace).

### The Squint Test
Blur your eyes. Can you identify the most important element? The second most important? Clear groupings? If everything looks the same weight blurred, hierarchy is broken.

### Container Queries
Viewport queries for page layouts. Container queries for components. Same card adapts layout based on its container width (narrow sidebar stays compact, main content expands), without viewport hacks.

### Optical Adjustments
Text at `margin-left: 0` looks indented due to letterform whitespace — use negative margin (`-0.05em`). Geometrically centered icons often look off-center (play icons shift right, arrows shift toward their direction).

## Component Design Guidelines

### Buttons
- **Primary**: sharp and squared (`border-radius: 0`) — explicit editorial choice. Flat at rest. Hover lifts 2px with color shift. Focus-visible ring + hover treatment.
- **Secondary**: inline text link in body copy, weight 500, hover shifts to accent. No boxed secondary button — avoids "stack of equal-weight CTAs" pattern.
- No "OK", "Submit", "Yes/No" labels — specific verb+object.
- Destructive actions: name the destruction ("Delete 5 items").

### Cards & Containers
- Corner style: controlled vocabulary — 4px (chips/callouts), 8px (standard cards), 12px (feature cards), 16px (large frames). No single "rounded-lg" default.
- Flat at rest. Shadows on hover only. Hairline 1px border when articulation needed without shadow.
- Internal padding matches visual weight (16-32px typical cards, 48px+ large editorial frames).
- Cards are not required. Spacing and alignment create visual grouping naturally. Use cards only when content is truly distinct and actionable.

### Navigation
- Brand surface: left-aligned lockup, right-aligned link cluster. Body family, weight 500, normal case.
- Product surface: standard patterns (top bar + side nav, breadcrumbs, tabs, command palettes). Consistency IS affordance.
- Mobile: collapses to icon-triggered drawer.

### Forms
- Placeholders aren't labels. Always visible `<label>` elements.
- Validate on blur, not every keystroke (exception: password strength).
- Errors below fields with `aria-describedby`.
- Show format with placeholders, not instructions.
- For non-obvious fields, explain why.

### Imagery (Brand Register)
- When the brief implies imagery (restaurants, hotels, food, travel, fashion, photography, hobbyist communities), ship imagery. Zero images is a bug, not restraint.
- One decisive photo beats five mediocre ones. Hero imagery commits to a mood.
- Search for the physical object, not the generic category: "handmade pasta on a scratched wooden table" beats "Italian food."
- Alt text is part of the voice: "Coastal fettuccine, hand-cut, served on the terrace" beats "pasta dish."

### Layout Spacing Scale
*Preferred token scale (brand default)*: 8/16/24/32/48/80/120px. Deliberately omits 4px step — editorial scale, not app-UI scale. Rhythm: 80-120px between top-level sections, 24-48px between content groups, 6-16px inside tight clusters.
