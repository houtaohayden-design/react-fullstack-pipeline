# Raycast Design System

> Extracted from https://www.raycast.com on 2026-05-18
> Platform: Web (Next.js 15 App Router, React Server Components, CSS Modules)
> Style: Dark-first developer-productivity SaaS -- near-black canvas, single blue action color, Inter + JetBrains Mono typography, CSS-only animation, BEM CSS Modules architecture

## Overview

Raycast is a macOS productivity launcher (now expanding to iOS and Windows). Their marketing website is a Next.js 15 App Router application with CSS Modules using BEM-style class naming. The design is dark-first with a restrained, developer-focused aesthetic: near-black backgrounds, white text hierarchy, a single blue accent, and CSS-only animations (no external animation libraries). The system is token-driven with 89 CSS custom properties covering color, spacing, radius, typography, and container widths.

### Tech Stack
- **Framework**: Next.js 15 (App Router, React Server Components)
- **Styling**: CSS Modules with BEM naming (`ComponentName_element__hash`)
- **Hosting**: Vercel (production)
- **Monitoring**: Sentry
- **Fonts**: Inter (variable), JetBrains Mono (variable), GeistMono (variable)
- **Animation**: CSS-only (no GSAP, no Framer Motion, no third-party animation lib)
- **Analytics**: Rewardful (affiliate)

---

## Layout System

### Container Widths
| Token | Value | Use |
|-------|-------|-----|
| `--container-xs-width` | 746px | Narrow content (blog posts, FAQs) |
| `--container-sm-width` | 1064px | Medium sections |
| `--container-width` | 1204px | Default content width |
| `--container-lg-width` | 1280px | Wide layouts (extensions grid) |
| `--navbar-width` | 1204px | Navbar matches container width |

### Grid System
- **Grid gap**: 32px desktop, 24px mobile (`--grid-gap`)
- **Column layout**: CSS Grid with fractional units
- **Content alignment**: Centered containers with max-width constraints
- **Navbar**: Sticky/fixed at top, 58px height mobile, 76px height desktop (880px+)

### Breakpoints
Raycast uses 19 distinct min-width and 8 max-width breakpoints:

| Min-Width | Max-Width | Target |
|-----------|-----------|--------|
| 480px | 408px | Small mobile |
| 520px | 480px | Mobile landscape |
| 640px | 563px | Tablet portrait |
| 720px | 720px | Primary responsive break (most used) |
| 767px | 768px | Tablet landscape |
| 768px | 840px | Small desktop |
| 800px | 1000px | Medium desktop |
| 840px | | |
| 880px | | Navbar height change (58->76px) |
| 920px | | |
| 960px | | |
| 1000px | | |
| 1024px | | |
| 1064px | | |
| 1080px | | |

### Page Structure
The homepage follows a stacked section layout:
1. **Navbar** -- fixed top, transparent/blurred
2. **Hero** -- "Your shortcut to everything" with animated keyboard visualization
3. **Value Proposition** -- "It's not about saving time. It's about feeling like you're never wasting it."
4. **Features Pillars** -- Fast / Ergonomic / Native / Reliable
5. **Extensions Showcase** -- Card grid with app integrations
6. **AI Section** -- "Your Mac just got smarter"
7. **Social Proof** -- Testimonial carousel from tech leaders
8. **Automation Features** -- Snippets, Quicklinks, Hotkeys
9. **"What Else" Grid** -- Feature discovery cards
10. **Community** -- Slack/X stats + blog carousel
11. **Developer Platform** -- API/extension builder pitch
12. **CTA Footer** -- Download prompt
13. **Full Footer** -- Product, Developers, Company, Community link columns

---

## Color System

### Design Philosophy
Dark-first, single-accent strategy. Black and near-black backgrounds with white text. One blue accent carries all interactive meaning. Yellow, red, and green are semantic (warnings, errors, success) with transparent backgrounds. No purple, no gradients, no glassmorphism.

### Neutral Scale (Gray)
| Token | Value | Usage |
|-------|-------|-------|
| `--Base-White` | #ffffff | Inverse/button text |
| `--grey-50` | #e6e6e6 | Lightest UI chrome |
| `--grey-100` | #cdcece | Disabled text |
| `--grey-200` | #9c9c9d | Muted text |
| `--grey-300` | #6a6b6c | Secondary text |
| `--grey-400` | #434345 | Tertiary text |
| `--grey-500` | #2f3031 | Elevated surface |
| `--grey-600` | #1b1c1e | Card surface |
| `--grey-700` | #111214 | Secondary background |
| `--grey-800` | #0c0d0f | Primary background |
| `--grey-900` | #07080a | Root background |
| `--Base-Black` | #000000 | Deepest black |

### Surface Background Hierarchy (Elevation)
| Token | Value | Usage |
|-------|-------|-------|
| `--color-bg` | #07080a (grey-900) | Root canvas |
| `--color-bg-100` | rgb(16,17,17) | Slightly elevated |
| `--color-bg-200` | rgb(24,25,26) | Card surface |
| `--color-bg-300` | rgb(49,49,51) | Interactive surface |
| `--color-bg-400` | rgb(73,75,77) | Highest surface |

### Foreground/Text Hierarchy
| Token | Value | Usage |
|-------|-------|-------|
| `--color-fg` | hsl(240,11%,96%) | Primary text (near-white) |
| `--color-fg-200` | rgb(194,199,202) | Secondary text |
| `--color-fg-300` | #78787c | Tertiary/muted text |
| `--color-fg-400` | rgb(94,99,102) | Quaternary text |

Text color is also available as RGB channels for alpha compositing:
- `--font-color-rgb: 255,255,255` (for `rgba(var(--font-color-rgb), 0.6)` opacity variations)
- `--reverse-font-color-rgb: 0,0,0` (for light-background sections)
- `--lines-color-rgb: 255,255,255` (for divider/border lines)

### Accent Palette
| Token | Color | Usage |
|-------|-------|-------|
| `--color-blue` | hsl(202,100%,67%) | **Primary action** -- links, buttons, CTAs |
| `--color-blue-transparent` | hsla(202,100%,67%,0.15) | Blue tint backgrounds |
| `--color-yellow` | hsl(43,100%,60%) | Warnings, highlights |
| `--color-yellow-transparent` | hsla(43,100%,60%,0.15) | Yellow tint backgrounds |
| `--color-red` | hsl(0,100%,69%) | Errors, destructive actions |
| `--color-red-transparent` | hsla(0,100%,69%,0.15) | Red tint backgrounds |
| `--color-green` | hsl(151,59%,59%) | Success states |
| `--color-green-transparent` | hsla(151,59%,59%,0.15) | Green tint backgrounds |

### Gradients (5-stop accent spectrum)
| Token | Value |
|-------|-------|
| `--color-step-1` | Yellow (hsl(43,100%,60%)) |
| `--color-step-2` | #d3b2ff (purple) |
| `--color-step-3` | Red (rgba(255,99,99,1)) |
| `--color-step-4` | Red |
| `--color-step-5` | Blue (hsl(202,100%,67%)) |

This 5-stop gradient spans yellow -> purple -> red -> red -> blue for decorative accent gradients.

### Button Colors
| Token | Value |
|-------|-------|
| `--color-button-bg` | hsla(0,0%,100%,0.815) |
| `--color-button-bg-hover` | hsl(0,0%,100%) |
| `--color-button-fg` | rgb(24,25,26) (dark text on white) |
| `--color-border` | hsl(195,5%,15%) |

### Special Named Colors
| Token | Value | Notes |
|-------|-------|-------|
| `--blue-dark` | #56c2ff | Dark mode blue variant |
| `--red-dark` | rgba(255,99,99,1) | Dark mode red variant |

### Theme Mode
The site is **dark-first** with reverse sections:
- `--background: var(--grey-900)` (#07080a near-black)
- `--reverse-background: #ffffff` (for light-on-dark contrast sections)
- No automatic light mode detection visible in token layer
- Light sections use `--reverse-background` + `--reverse-font-color-rgb`

---

## Typography System

### Font Families
| Token | Stack | Usage |
|-------|-------|-------|
| `--main-font` | Inter, Inter Fallback, sans-serif | All body/UI text |
| `--monospace-font` | JetBrains Mono, JetBrains Mono Fallback, Menlo, Monaco, Courier, monospace | Code blocks |
| `--font-geist-mono` | GeistMono, ui-monospace, SFMono-Regular, Roboto Mono, Menlo, Monaco, Liberation Mono, DejaVu Sans Mono, Courier New, monospace | UI monospace |

### Font Specifications
- **Inter**: Variable, weight 100-900, 7 Unicode range subsets, `font-display: swap`
- **JetBrains Mono**: Variable, weight 100-800, 6 Unicode range subsets, `font-display: swap`
- **GeistMono**: Variable, weight 100-900, single woff2 file, `font-display: swap`
- **Inter Fallback**: Arial, ascent-override: 90.44%, descent-override: 22.52%, size-adjust: 107.12%
- **JetBrains Mono Fallback**: Arial, ascent-override: 75.79%, descent-override: 22.29%, size-adjust: 134.59%

### Type Scale
| Size | Usage |
|------|-------|
| 12px | Captions, legal text, fine print |
| 14px | Small UI labels, secondary metadata |
| 16px | Body text, UI controls, paragraphs |
| 18px | Large body, small headings |
| 20px | H4 headings, feature titles |
| 24px | H3 headings, section subtitles |
| 32px | H2 headings, feature section titles |
| 40px | H1 headings, major section titles |
| 48px | Hero text, display headings |

### Font Weights
| Weight | Usage |
|--------|-------|
| 300 | Light (rare, decorative) |
| 400 | Body text, UI labels |
| 500 | Medium emphasis |
| 550 | Semibold-ish (custom) |
| 600 | Headings, strong emphasis |
| 650 | Heavy emphasis |
| 700 | Bold (rare) |

### Line Heights
| Value | Usage |
|-------|-------|
| 1.0625 | Tight (hero, display text) |
| 1.15 | Compact headings |
| 1.35 | Medium headings |
| 1.5 (150%) | Body text, markdown |
| 1.6 | Relaxed reading |

### Letter Spacing
- Headings: `-0.02em` (slightly tighter)
- Display: `-0.024em` (tightest)

### Markdown Content Typography
Used on blog, docs, and FAQ sections:
- **h1**: 40px, weight 600, padding-top 48px
- **h2**: 32px, weight 600, padding-top 48px, letter-spacing -0.02em
- **h3**: 24px, weight 600, padding-top 48px
- **h4**: 20px, weight 600, padding-top 8px
- **p**: 16px, line-height 150%, margin-bottom 28-32px
- **strong**: weight 600
- **a**: color #ff6363 (red links in markdown), #56c2ff (blue links in markdown-next)
- **table**: dashed bottom border rows, light border top on thead
- **blockquote**: relative-positioned with custom styling
- **code**: monospace stack

### Text Balance
Raycast uses a custom JavaScript text-balancing technique that detects CSS `text-wrap: balance` support and falls back to a measured max-width calculation for browsers without it.

---

## Motion & Animation

### Philosophy
CSS-only animation system. No external animation libraries (no GSAP, no Framer Motion, no Motion One). All animations are CSS `@keyframes` within CSS Modules, scoped via BEM hashed class names.

### Spring Easing Curve
A custom 82-keyframe `linear()` spring curve replaces the need for JavaScript spring physics:

```css
--spring-1: linear(
  0.000000 0%, 0.005927 1%, ... 0.999650 100%
);
```

This is an overshoot spring (goes above 1.0 at ~29-30% then settles to 1.0). Equivalent to approximately stiffness: 200, damping: 15, mass: 1.

### Keyframe Animations Catalog (27 total)

#### Hero & Marketing
| Animation | Effect | Duration |
|-----------|--------|----------|
| `HeroAnnouncement_x` | Horizontal slide using `--x` custom property | -- |
| `HeroAnnouncement_rotating2` | Rotation using `--r2` property | -- |
| `AIShowCase_progress` | Progress bar fill (scaleX 0->1) | -- |
| `FeatureWall_progress` | Progress bar fill (scaleX 0->1) | -- |
| `Gallery_progress` | Image gallery progress (scaleX 0->1) | -- |

#### UI Component Animations
| Animation | Effect |
|-----------|--------|
| `Dialog_overlayShow` | Overlay fade in (opacity 0->1) |
| `Dialog_contentShow` | Content scale+translate (0.96 scale, -2% Y -> natural) |
| `AlertDialog_overlayShow` | Alert overlay fade in |
| `AlertDialog_contentShow` | Alert content reveal |
| `Tooltip_slideUpAndFade` | Tooltip from below |
| `Tooltip_slideRightAndFade` | Tooltip from left |
| `Tooltip_slideDownAndFade` | Tooltip from above |
| `Tooltip_slideLeftAndFade` | Tooltip from right |
| `Navbar_slideIn` | Navbar enter animation |
| `Input_shake` | Input validation error shake |

#### Loading & Feedback
| Animation | Effect |
|-----------|--------|
| `RaycastWindow_loadingSweep` | Loading sweep across UI mock |
| `RaycastWindow_blink` | Cursor blink (50% opacity pulse) |
| `search_nightRider` | Knight Rider-style scanning light |
| `FeaturebaseContent_spin` | Loading spinner |
| `InstallViaHomebrew_iconSuccess` | Success icon pop (scale + opacity) |
| `InstallViaWinget_iconSuccess` | Success icon pop |
| `BrowserExtensionHeader_moreFadeIn` | Fade-in reveal |
| `BrowserExtensionHeader_animateIn` | Section entrance |
| `Testimonials_fadeIn` | Testimonial fade in |
| `page_fade` | Page transition fade |
| `RelatedExtensions_fadeIn` | Related items fade in |

### Duration & Easing Patterns
- **Fade-ins**: simple opacity transitions
- **Dialog/Modal**: overlay opacity + content scale(0.96) + translateY(-2%)
- **Progress bars**: transform scaleX with `transform-origin: left`
- **Tooltips**: directional slide + fade (4 directions)
- **Success feedback**: scale(0.8) -> scale(1) with opacity fade

### Reduced Motion
The CSS `linear()` spring curve degrades gracefully in reduced-motion contexts. No explicit `prefers-reduced-motion` media queries found in extracted CSS.

---

## Interaction & UX Patterns

### Navigation
- **Sticky top navbar**: 58px height (mobile), 76px (>=880px desktop)
- **Nav items**: Store, Pro, AI, iOS, Windows, Teams, Developers, Blog, Pricing, Log in, Download
- **CTA**: "Download" button always visible in nav
- **Navbar transparency**: Background transitions on scroll
- **Navbar slide-in animation**: on page load

### Buttons
- **Primary**: White background (hsla(0,0%,100%,0.815)), dark text (rgb(24,25,26)), hover -> solid white
- **Style**: Minimal, no visible border on dark backgrounds
- **Placement**: Download CTAs in hero and footer, "Log in" / "Download" in nav

### Dialogs & Modals
- **Entry animation**: Overlay fades in, content scales from 96% + slides up 2%
- **Alert dialogs**: Separate animation from regular dialogs

### Tooltips
- **4-directional entry**: slideUpAndFade, slideRightAndFade, slideDownAndFade, slideLeftAndFade
- **Direction-aware**: Content determines approach direction

### Forms
- **Input validation**: Shake animation on error
- **Subscribe form**: Email input + submit in footer
- **Newsletter**: Privacy-conscious with consent checkbox

### Progress Indicators
- **Progress bars**: ScaleX from 0 to 1, used in multiple components (AI showcase, feature wall, gallery)
- **Loading sweep**: Knight Rider-style scanning animation on command UI
- **Blink cursor**: 50% opacity pulse for text cursor simulation

### Scroll Behaviors
- **Text balancing**: Automatic text-wrap balance with JS polyfill fallback
- **Hover interactions**: `@media (hover:hover)` gated -- touch devices excluded from hover effects

### Social Proof Pattern
- **Testimonial carousel**: Fade-in animation, quotes from tech leaders (@rauchg, @MKBHD, @adamwathan, @wesbos, etc.)
- **Avatar + name + handle + quote** format
- **Community stats**: "Slack 37k members", "X/Twitter 90k followers"

### Content Discovery
- **Feature wall**: Grid of feature cards with progress bars
- **Extension cards**: Icon + app name + description + preview image pattern
- **YouTube carousel**: Video thumbnails with titles
- **"What else" section**: Dense link grid of features

---

## Spacing & Visual Rhythm

### Spacing Scale (8px base)
| Token | Value | Usage |
|-------|-------|-------|
| `--spacing-none` | 0px | Zero spacing |
| `--spacing-0-5` | 4px | Tight icon gaps, inline spacing |
| `--spacing-1` | 8px | Compact padding, small gaps |
| `--spacing-1-5` | 12px | Card inner padding, list gaps |
| `--spacing-2` | 16px | Standard padding, text-image gap |
| `--spacing-2-5` | 20px | Medium section gaps |
| `--spacing-3` | 24px | Section padding, card gaps |
| `--spacing-4` | 32px | Grid gap (mobile) |
| `--spacing-5` | 40px | Large section padding |
| `--spacing-6` | 48px | Section top/bottom |
| `--spacing-7` | 56px | Major section spacing |
| `--spacing-8` | 64px | Hero padding |
| `--spacing-9` | 80px | Generous whitespace |
| `--spacing-10` | 96px | Wide separation |
| `--spacing-11` | 112px | Very wide spacing |
| `--spacing-12` | 168px | Maximum section gap |
| `--spacing-13` | 224px | Extreme whitespace |

**Pattern**: Multiples of 4px with jumps at 4, 8, 12, 20, 24, 32, 40, 48, 56, 64, 80, 96, 112. Then large jumps to 168 and 224 for macro layout.

### Border Radius Scale
| Token | Value | Usage |
|-------|-------|-------|
| `--rounding-none` | 0px | Sharp corners |
| `--rounding-xs` | 4px | Subtle rounding |
| `--rounding-sm` | 6px | Standard UI elements |
| `--rounding-normal` | 8px | Default UI rounding |
| `--rounding-md` | 12px | Cards, modals |
| `--rounding-lg` | 16px | Large cards |
| `--rounding-xl` | 20px | Prominent rounding |
| `--rounding-xxl` | 24px | Maximum rounding |
| `--rounding-full` | 100% | Pills, circles |

**Default**: `--radius-md: 6px` used as the standard radius token.

### Visual Rhythm Observations
- **Section alternation**: Dark and near-black sections alternate to create visual separation
- **Content density**: Dense information layout -- multiple sections stacked vertically
- **Whitespace**: Generous padding within sections, tight spacing between related items
- **Border usage**: Borders (`--color-border: hsl(195,5%,15%)`) are subtle and used for card/input separation rather than shadows

---

## Component Patterns

### Component Architecture
31 distinct BEM-named components extracted from the homepage. Naming convention: `ComponentName_element__hash`.

### Core Components

#### Navigation (Navbar, NavLink)
- Fixed top position
- Height: 58px mobile / 76px desktop (880px breakpoint)
- Container-aligned width (1204px)
- Top padding: 16px (--spacing-2)
- Container padding top from CSS variable
- Slide-in entrance animation
- Links: Store, Pro, AI, iOS, Windows, Teams, Developers, Blog, Pricing
- Actions: "Log in" text link, "Download" button

#### Hero Section (HeroAnnouncement, HeroDownloadInfo, AnimatedCmdSpaceKeyboard)
- Headline: "Your shortcut to everything."
- Subtitle: "A collection of powerful productivity tools all within an extendable launcher."
- Animated keyboard visualization (macOS keyboard layout with function keys)
- Download CTAs: "Download for Mac" + "Download for Windows (beta)"
- Version info: "v 1.104.17 macOS 13+"
- Alternative: "Install via homebrew" link
- "Try the new Raycast" link with "Learn more"
- Animated hero announcement with x-axis slide and rotation

#### Feature Pillars (FeatureBadge, CommandYourTime)
- 4-column grid (mobile: stacked)
- Badges with icon + label (e.g., "Fast", "Ergonomic", "Native", "Reliable")
- Heading + description for each pillar
- Quote section: "It's not about saving time. It's about feeling like you're never wasting it."

#### Extension Cards (ExtensionCard, ExtensionHighlight)
- Grid layout of integration cards
- Each card: icon (64px) + app name + description + preview screenshot
- Extensions shown: Linear, Google Translate, Spotify, Arc, TinyPNG, 1Password, JIRA, Slack, Zoom, Timers, Pomodoro, Notion, Todoist, Google Search, Obsidian, Google Chrome, CleanShot X
- "Plus thousands more..." with "Browse the store" link

#### AI Section (AIShowCase, QuickAi)
- "Your Mac just got smarter. AI where it's most useful - on your OS."
- Features: Ask Anything (Quick AI), Always On ChatGPT, Automation Assistant
- Progress bar animation for AI showcase

#### Social Proof (Testimonials, Avatar)
- Testimonial cards from tech leaders
- Format: avatar + name + Twitter handle + quote
- Fade-in animation
- Featured people: Guillermo Rauch (Vercel), Marques Brownlee (MKBHD), Koen Bok (Framer), Adam Wathan (Tailwind CSS), Wes Bos (SyntaxFM), Max Stoiber (Stellate), etc.
- Highlighted testimonial: "Favorite Feature: AI Chat" and "Top Extension: Notion Search"

#### Automation Features (Automation, SnippetsShowcase, HotkeysShowcase)
- Three-column layout
- **Snippets**: Text expansion with keyboard shortcut illustration
- **Quicklinks**: URL shortcuts with keyboard shortcut (option+command+L)
- **Hotkeys and Aliases**: Keyboard shortcut assignment

#### Feature Discovery (FeatureWall, ArrowLink)
- Dense grid of feature links: "It can take notes. Track your flights. Convert anything. Search files. Run scripts. Manage your windows. Plan your day. Remind you of stuff. Translate into any language. Block distractions. Find text in screenshots. Insert Emojis. And much, much more."
- ArrowLink component for "Learn more" navigation
- Progress bar animations on feature wall

#### Community Section (CommunitySection, YoutubeCarousel)
- Stats: "Slack 37k members", "X/Twitter 90k followers"
- YouTube video carousel with thumbnails
- Blog post grid

#### Developer Platform (APISection)
- "Build the perfect tools" heading
- Three feature cards: React to macOS, Built-in UI, Batteries included, Publish to Store
- "Get started" CTA

#### Footer (Footer, SubscribeForm)
- Multi-column layout
- Product column: Store, Pro, Teams, Pricing, Changelog, Browser Extension
- Developers column: iOS, Windows, Raycast 2.0, API Docs, Manual, Troubleshooting, FAQ
- Core Features column: Raycast AI, Notes, Focus, Clipboard History, etc.
- Top Extensions column: Design Tools, Developer Tools, Pomodoro Timer, etc.
- AI column: Try Raycast AI, Explore Snippets, Prompts, Chat Presets
- Company column: Manifesto, Customers, Careers, Terms, Privacy, etc.
- Community column: Community Stories, Ambassadors, Slack, X/Twitter, GitHub, Dribbble
- "By Raycast" column: ray.so, Icon Maker, Merch, Wallpapers
- Newsletter signup: "Subscribe to our newsletter"
- BEM component: `SubscribeForm`

#### Dialog/Modal
- Overlay: opacity fade in
- Content: translateY(-2%) scale(0.96) -> natural
- Used for: authentication, feature details, confirmation

#### Tooltip
- Four-directional animations
- Direction: context-dependent (avoiding viewport edges)

#### Progress Bars
- Used in multiple contexts: AI Showcase, Feature Wall, Gallery
- Animation: scaleX from 0 to 1, transform-origin left
- No visible track -- just fill bar

#### Success Feedback (FlashMessage, success icons)
- Scale + opacity pop animation
- Checkmark-style icon feedback

#### Input
- Shake animation on validation error
- Standard text input styling

---

## Design Tokens (Complete Reference)

### Colors (52 tokens)
```
--Base-White: #ffffff
--Base-Black: #000000
--grey-50: #e6e6e6
--grey-100: #cdcece
--grey-200: #9c9c9d
--grey-300: #6a6b6c
--grey-400: #434345
--grey-500: #2f3031
--grey-600: #1b1c1e
--grey-700: #111214
--grey-800: #0c0d0f
--grey-900: #07080a
--background: var(--grey-900)
--reverse-background: #ffffff
--font-color-rgb: 255,255,255
--reverse-font-color-rgb: 0,0,0
--lines-color-rgb: 255,255,255
--color-bg: var(--grey-900)
--color-bg-100: rgb(16,17,17)
--color-bg-200: rgb(24,25,26)
--color-bg-300: rgb(49,49,51)
--color-bg-400: rgb(73,75,77)
--color-fg: hsl(240,11%,96%)
--color-fg-200: rgb(194,199,202)
--color-fg-300: #78787c
--color-fg-400: rgb(94,99,102)
--color-blue: hsl(202,100%,67%)
--color-blue-transparent: hsla(202,100%,67%,0.15)
--color-red: hsl(0,100%,69%)
--color-red-transparent: hsla(0,100%,69%,0.15)
--color-yellow: hsl(43,100%,60%)
--color-yellow-transparent: hsla(43,100%,60%,0.15)
--color-green: hsl(151,59%,59%)
--color-green-transparent: hsla(151,59%,59%,0.15)
--color-border: hsl(195,5%,15%)
--color-button-bg: hsla(0,0%,100%,0.815)
--color-button-bg-hover: hsl(0,0%,100%)
--color-button-fg: rgb(24,25,26)
--color-step-1: var(--color-yellow)
--color-step-2: #d3b2ff
--color-step-3: var(--red-dark)
--color-step-4: var(--red-dark)
--color-step-5: var(--color-blue)
--blue-dark: #56c2ff
--red-dark: rgba(255,99,99,1)
```

### Spacing (17 tokens)
```
--spacing-none: 0px
--spacing-0-5: 4px
--spacing-1: 8px
--spacing-1-5: 12px
--spacing-2: 16px
--spacing-2-5: 20px
--spacing-3: 24px
--spacing-4: 32px
--spacing-5: 40px
--spacing-6: 48px
--spacing-7: 56px
--spacing-8: 64px
--spacing-9: 80px
--spacing-10: 96px
--spacing-11: 112px
--spacing-12: 168px
--spacing-13: 224px
```

### Border Radius (9 tokens)
```
--rounding-none: 0px
--rounding-xs: 4px
--rounding-sm: 6px
--rounding-normal: 8px
--rounding-md: 12px
--rounding-lg: 16px
--rounding-xl: 20px
--rounding-xxl: 24px
--rounding-full: 100%
```

### Layout (6 tokens)
```
--container-xs-width: 746px
--container-sm-width: 1064px
--container-width: 1204px
--container-lg-width: 1280px
--navbar-width: var(--container-width)
--grid-gap: 32px (24px mobile)
```

### Typography (7 tokens)
```
--main-font: var(--font-inter), sans-serif
--monospace-font: var(--font-jetbrains-mono), Menlo, Monaco, Courier, monospace
--font-inter: "Inter", "Inter Fallback"
--font-jetbrains-mono: "JetBrains Mono", "JetBrains Mono Fallback"
--font-geist-mono: "GeistMono", ui-monospace, SFMono-Regular, Roboto Mono, Menlo, Monaco, Liberation Mono, DejaVu Sans Mono, Courier New, monospace
--removed-body-scroll-bar-size: 0px
--size: 32px
```

### Animation (1 token)
```
--spring-1: linear(0.000000 0%, ...) [82-keyframe custom spring curve]
```

### Component (3 tokens)
```
--navbar-height: 58px (mobile) / 76px (>=880px)
--navbar-container-padding-top: var(--spacing-2)
--navbar-total-spacing: calc(var(--navbar-height) + (2 * var(--navbar-container-padding-top)))
```

---

## Key Takeaways for React Implementation

### 1. Dark-First with Reverse Sections
Start with a near-black canvas (#07080a). Light sections use `--reverse-background: #ffffff` for contrast. Dark mode is not an afterthought -- it's the default.

### 2. Single Accent Strategy
One blue (`hsl(202,100%,67%)`) for all interactive elements. Yellow/Red/Green are strictly semantic (warnings, errors, success). No purple, no multi-color decorative accents. This creates extreme visual clarity.

### 3. CSS-Only Animation
No GSAP, no Framer Motion dependency. All animations are CSS keyframes within CSS Modules. The custom `linear()` spring curve replaces JavaScript spring physics. This keeps the bundle small and performance predictable.

### 4. 8px Spacing Grid
All spacing is a multiple of 4px, base unit of 8px. The 17-stop scale covers micro (4px) to macro (224px) with consistent rhythm.

### 5. BEM CSS Modules
Component class names follow `ComponentName_element__hash`. Each component is self-contained with locally-scoped styles. This is similar to CSS Modules best practices.

### 6. 4-Stop Text Hierarchy
Text uses exactly four opacity/color stops: primary (near-white), secondary (rgb 194,199,202), tertiary (#78787c), quaternary (rgb 94,99,102). RGB channel variables enable alpha compositing for intermediate values.

### 7. Surface Elevation Without Shadows
Depth is created through background color lightness steps, not box-shadows. Surfaces go from #07080a (root) to rgb(73,75,77) (highest elevation) in 5 stops.

### 8. Typography with Design Intent
Inter Variable is the hero font (not system-ui default). Weight 550 is a custom semibold. Headings have negative letter-spacing. Line heights are precisely tuned per context.

### 9. Progressive Enhancement
The text-balance polyfill pattern shows progressive enhancement: detects native `text-wrap: balance` support and falls back to a JavaScript-measured solution.

### 10. Touch-Aware Interactions
Hover effects are gated behind `@media (hover:hover)` -- touch devices never see hover states, ensuring clean mobile UX.

---

## Extraction Limitations

This analysis was performed via HTML/CSS static extraction from the rendered Next.js output. The following were NOT fully capturable:

- **JavaScript runtime behavior**: Component state transitions, focus management, keyboard navigation handlers
- **Server-rendered dynamic content**: Personalized states, A/B test variants
- **CSS-in-JS runtime styles**: Any styles generated at runtime via style objects
- **Video/animation frame details**: Exact timing of the keyboard animation sequence
- **Dark/light theme toggle**: The token system suggests dark-only; no light theme switch logic was found
- **Form validation messages**: Actual error text content and validation rules
- **Analytics event tracking**: Interaction telemetry
- **Accessibility annotations**: ARIA attributes (present in HTML but not systematically extracted)
- **Image assets**: Only URLs were noted; actual image composition was not analyzed

### Resources Fetched
| Resource | Size | Status |
|----------|------|--------|
| Homepage (HTML) | 367 KB | 200 |
| Pricing page (HTML) | 166 KB | 200 |
| Store page (HTML) | 288 KB | 200 |
| CSS chunk 1 (global/layout) | 81 KB | 200 |
| CSS chunk 2 (components) | 81.5 KB | 200 |
| CSS chunk 3 (navbar) | 6 KB | 200 |
| CSS chunk 4 (design tokens) | 20.6 KB | 200 |
| CSS chunk 5 (misc) | 0.6 KB | 200 |
| JS chunk (animation detection) | 13.8 KB | 200 |
| **Total transferred** | **~1,024 KB** | **9/15 requests used** |

### Key Statistics
- **CSS custom properties**: 89 total
- **Font families**: 3 (Inter, JetBrains Mono, GeistMono)
- **Keyframe animations**: 27 named
- **BEM components**: 31 distinct
- **Color tokens**: 52
- **Spacing stops**: 17
- **Border radius stops**: 9
- **Breakpoints**: 27 (19 min-width + 8 max-width)
- **Font weights**: 7 (300, 400, 500, 550, 600, 650, 700)
- **Type scale stops**: 9 (12-48px)
