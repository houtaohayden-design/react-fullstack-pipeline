# Notion Design System

> Extracted from `https://www.notion.so` on 2026-05-18
> Source: homepage + /product/ai + 2 CSS bundles (2890+ custom properties)
> Stack: Next.js + CSS Modules + @layer cascade

---

## 1. Overview

Notion's marketing website is built on a **massive, systematically architected CSS custom properties design system** with 2890+ tokens. It uses CSS `@layer` cascade for strict ordering, CSS Modules for scoping, and supports both **light/dark themes** plus **8 campaign palette themes** (black, brown, orange, red, purple, teal, yellow, gray). The architecture is multi-tier: raw primitive tokens feed into semantic tokens, which feed into component tokens, which feed into CSS Modules classes.

### Architecture Layers

```
@layer front-tokens { @layer base, dark, palette, palette-dark }
@layer normalize
@layer base-components
@layer markdown-renderer
@layer front-ui-normalize
@layer front-ui-utilities
@layer front-ui-foundations
@layer front-ui-atoms
@layer front-ui-components
```

### Tech Stack
- **Framework**: Next.js (SSR, hashed CSS filenames)
- **CSS**: CSS Modules with `{Component}_{element}__{hash}` naming
- **Fonts**: Custom NotionInter (self-hosted), Lyon Text (serif), iA Writer Mono, Permanent Marker
- **Hosting**: Vercel (from robots.txt and `/_vercel/insights/view` disallow)
- **Taxonomy**: 12 CSS files (page-specific code splitting)

---

## 2. Layout System

### Grid
```css
--grid-columns: 12;
--grid-column-width: 1fr;
--grid-gutter: 28px;
--grid-sm-gutter: 12px;
```

12-column fluid grid with 28px gutters on desktop, collapsing to 12px on mobile.

### Breakpoints
| Breakpoint | Value | Usage |
|-----------|-------|-------|
| sm | 600px | Mobile landscape, small tablet |
| md | 840px | Tablet portrait |
| lg | 1080px | Tablet landscape, small desktop |
| xl | 1280px | Standard desktop |
| xxl | 1440px | Wide desktop |

All breakpoints use `min-width` (mobile-first approach). Re-declared per responsive property across all 5 breakpoints.

### Page Structure
```css
--global-navigation-height: 64px;
--header-height: 60px;
--base-padding: 20px;   /* mobile */
--base-padding: 40px;   /* tablet */
--base-padding: 60px;   /* desktop */
```

Responsive base padding scales from 20px -> 40px -> 60px.

### Semantic HTML
Uses `<nav>`, `<header>`, `<main>`, `<footer>`, `<section>` with proper ARIA labels. Not a div soup.

### Section Architecture
```css
--spacing-section: var(--spacing-160);        /* 10rem / 160px max */
--spacing-section-inner: var(--spacing-32);   /* 2rem internal section gap */
```

Sections scale responsively:
- `--spacing-xs`: 20px
- `--spacing-s`: 40px
- `--spacing-m`: 40px -> 60px
- `--spacing-l`: 60px -> 80px -> 120px
- `--spacing-xl`: 60px -> 80px -> 160px

---

## 3. Color System

### Primitive Palette: 11 Hues x 9 Steps

Each hue follows a 100 (lightest) to 900 (darkest) scale:

#### Gray
| Step | Hex |
|------|-----|
| 100 | `#f9f9f8` |
| 200 | `#f6f5f4` |
| 300 | `#dfdcd9` |
| 400 | `#a39e98` |
| 500 | `#78736f` |
| 600 | `#615d59` |
| 700 | `#494744` |
| 800 | `#31302e` |
| 900 | `#191918` |

#### Blue (Primary Accent)
| Step | Hex |
|------|-----|
| 100 | `#f2f9ff` |
| 200 | `#e6f3fe` |
| 300 | `#93cdfe` |
| 400 | `#62aef0` |
| 500 | `#097fe8` |
| 600 | `#0075de` |
| 700 | `#005bab` |
| 800 | `#00396b` |
| 900 | `#002a4f` |

#### Red
| Step | Hex |
|------|-----|
| 100 | `#fef3f1` |
| 200 | `#fdd3cd` |
| 300 | `#ff8b7c` |
| 400 | `#f77463` |
| 500 | `#f64932` |
| 600 | `#e32d14` |
| 700 | `#b01601` |
| 800 | `#6f0d00` |
| 900 | `#4f0900` |

#### Orange
| Step | Hex |
|------|-----|
| 100 | `#fff5ed` |
| 200 | `#ffdec4` |
| 300 | `#ffad71` |
| 400 | `#ff8a33` |
| 500 | `#ff6d00` |
| 600 | `#dd5b00` |
| 700 | `#ab4a00` |
| 800 | `#793400` |
| 900 | `#532200` |

#### Yellow
| Step | Hex |
|------|-----|
| 100 | `#fff5e0` |
| 200 | `#ffe4af` |
| 300 | `#ffd786` |
| 400 | `#ffc95e` |
| 500 | `#ffb110` |
| 600 | `#e89d01` |
| 700 | `#c78600` |
| 800 | `#a16c00` |
| 900 | `#704b00` |

#### Green
| Step | Hex |
|------|-----|
| 100 | `#f0faf2` |
| 200 | `#d0f4d8` |
| 300 | `#abe5b8` |
| 400 | `#68ce7e` |
| 500 | `#1aae39` |
| 600 | `#14832b` |
| 700 | `#0f6220` |
| 800 | `#0a4216` |
| 900 | `#05210b` |

#### Teal
| Step | Hex |
|------|-----|
| 100 | `#f2fafa` |
| 200 | `#bde6e4` |
| 300 | `#83cbc9` |
| 400 | `#2a9d99` |
| 500 | `#27918d` |
| 600 | `#0a7b77` |
| 700 | `#126764` |
| 800 | `#0a4d4b` |
| 900 | `#042b29` |

#### Purple
| Step | Hex |
|------|-----|
| 100 | `#f8f5fc` |
| 200 | `#eadbfa` |
| 300 | `#d6b6f6` |
| 400 | `#ad6ded` |
| 500 | `#9849e8` |
| 600 | `#7237ae` |
| 700 | `#562983` |
| 800 | `#391c57` |
| 900 | `#1c0e2c` |

#### Pink
| Step | Hex |
|------|-----|
| 100 | `#fff5fc` |
| 200 | `#ffcdf1` |
| 300 | `#ffb5eb` |
| 400 | `#ff83dd` |
| 500 | `#ff64c8` |
| 600 | `#d13f9d` |
| 700 | `#9d2472` |
| 800 | `#6c1b4f` |
| 900 | `#481034` |

#### Brown
| Step | Hex |
|------|-----|
| 100 | `#fcf8f5` |
| 200 | `#ebd5c5` |
| 300 | `#d9b79f` |
| 400 | `#b18164` |
| 500 | `#9c7054` |
| 600 | `#885d3d` |
| 700 | `#744d2d` |
| 800 | `#654124` |
| 900 | `#523410` |

### Alpha Transparency Scales

Two parallel 9-step alpha scales for overlays:

**Alpha Black**: `#0000000d` -> `#0000001a` -> `#0003` -> `#0000004d` -> `#0000008a` -> `#00000096` -> `#000000bf` -> `#000000e6` -> `#000000f2`

**Alpha White**: `#ffffff0d` -> `#ffffff1a` -> `#fff3` -> `#ffffff4d` -> `#ffffff80` -> `#ffffffa8` -> `#ffffffbf` -> `#ffffffd9` -> `#fffffff2`

### Campaign-Specific Palettes

**Agents Launch (dark blue theme)**:
```css
--color-campaigns-agents-launch-blue-300: #607df6;
--color-campaigns-agents-launch-blue-400: #455dd3;
--color-campaigns-agents-launch-blue-500: #394ea3;
--color-campaigns-agents-launch-blue-600: #213183;
--color-campaigns-agents-launch-blue-900: #02093a;
--color-campaigns-agents-launch-yellow: #fefcd5;
```

**Dev Platform (purple-blue theme)**:
```css
--color-campaigns-dev-platform-dos-blue: #1313ba;
--color-campaigns-dev-platform-dos-black: #0a0a5d;
--color-campaigns-dev-platform-dos-neon: #6666fd;
--color-campaigns-dev-platform-dos-slate: #7171a8;
--color-campaigns-dev-platform-dos-lavender: #cbcbef;
```

### Semantic Color Tokens (Light Theme)

```css
/* Text */
--color-text: var(--color-gray-900);           /* #191918 */
--color-text-dark: var(--color-gray-900);
--color-text-regular: #040404;
--color-text-extra-light: #0003;
--color-text-light: #0006;
--color-text-medium: #0009;
--color-text-normal: var(--color-alpha-black-800);
--color-text-strong: var(--color-alpha-black-900);
--color-text-muted: var(--color-alpha-black-500);
--color-text-disabled: var(--color-alpha-black-400);
--color-text-success: var(--color-green-600);
--color-text-warning: var(--color-orange-500);
--color-text-error: var(--color-red-500);

/* Background */
--color-page: var(--color-white);
--color-background-base: var(--color-white);
--color-background-base-hover: var(--color-alpha-black-100);
--color-background-surface-neutral: var(--color-gray-200);
--color-background-surface-accent: var(--color-blue-400);
--color-background-surface-accent-muted: var(--color-blue-100);

/* Border */
--color-border: var(--color-alpha-black-200);
--color-border-hover: var(--color-alpha-black-300);
--color-border-base: var(--color-alpha-black-200);
--border-color-regular: #00000014;

/* Links */
--color-link: var(--color-blue-500);
--color-link-hover: var(--color-blue-800);
--color-link-primary-text: var(--color-blue-600);
--color-link-primary-text-hover: var(--color-blue-800);
--color-link-secondary-text: var(--color-alpha-black-600);

/* Buttons */
--color-button-primary: var(--color-gray-900);
--color-button-primary-hover: var(--color-gray-800);
--color-button-primary-active: var(--color-gray-700);
--color-button-primary-text: var(--color-white);
--color-button-secondary: var(--color-white);
--color-button-secondary-text: var(--color-gray-900);
--color-button-tertiary: var(--color-white);
--color-button-ghost-text: var(--color-alpha-black-900);

/* Icons */
--color-icon: var(--color-blue-500);
--color-icon-background: var(--color-blue-100);
--color-icon-button: var(--color-gray-400);
--color-icon-button-hover: var(--color-gray-600);

/* Navigation */
--color-navigation: var(--color-gray-200);
--color-navigation-dropdown: var(--color-white);
--color-navigation-dropdown-hover: var(--color-gray-200);

/* Focus */
--color-interaction-focus-ring: var(--color-blue-600);
--color-interaction-indicator: var(--color-alpha-black-200);

/* Badges */
--color-badge-mono-background: var(--color-gray-200);
--color-badge-mono-text: var(--color-black);
--color-badge-bold-background: var(--color-blue-500);
--color-badge-bold-text: var(--color-white);
--color-badge-light-background: var(--color-blue-100);
--color-badge-light-text: var(--color-blue-500);

/* Cards */
--color-card-accent: var(--color-blue-500);
--color-card-border: var(--color-alpha-black-200);
--color-card-background: var(--color-white);
--color-card-title-text: var(--color-black);
--color-card-body-text: var(--color-alpha-black-600);

/* Code */
--color-code-foreground: var(--color-alpha-black-800);
--color-code-comment: var(--color-alpha-black-500);
--color-code-keyword: var(--color-blue-500);
--color-code-string: var(--color-green-600);
--color-code-number: var(--color-red-500);
--color-code-function: var(--color-red-500);
--color-code-variable: var(--color-orange-500);
--color-code-class: var(--color-red-500);
--color-code-operator: var(--color-orange-500);
--color-code-literal: var(--color-alpha-black-500);

/* Interaction states follow pattern: hover/focus/active for each token */
```

### Dark Theme Overrides

The dark theme systematically inverts the semantic tokens:
```css
--color-page: var(--color-black);
--color-text: var(--color-white);
--color-text-normal: var(--color-gray-200);
--color-text-strong: var(--color-white);
--color-background-base: var(--color-gray-900);
--color-border: var(--color-alpha-white-300);
--color-navigation: var(--color-black);
--color-navigation-dropdown: var(--color-gray-900);
```

### Palette Themes

Each campaign page can switch to one of 8 palette themes where accent colors are re-mapped (e.g., brown theme uses `--color-brown-*` for buttons, icons, links, badges).

---

## 4. Typography System

### Font Families

**Primary**:
```css
--font-family-primary-sans: NotionInter;          /* Custom, self-hosted */
--font-family-primary-serif: "Lyon Text";          /* Commercial serif */
--font-family-primary-mono: "iA Writer Mono";
--font-family-primary-handwriting: "Permanent Marker";
--font-family-primary-emoji: "Apple Color Emoji";
```

**Fallback stacks** (full cascade with international support):
```css
--font-family-fallback-sans: Inter, -apple-system, BlinkMacSystemFont,
  "Segoe UI", Helvetica, "Apple Color Emoji", Arial, sans-serif,
  "Segoe UI Emoji", "Segoe UI Symbol";

--font-family-fallback-serif: Georgia, YuMincho, "Yu Mincho",
  "Hiragino Mincho ProN", "Hiragino Mincho Pro", "Songti TC",
  "Songti SC", SimSun, "Nanum Myeongjo", NanumMyeongjo, Batang, serif;

--font-family-fallback-mono: Nitti, Menlo, Courier, monospace;
```

**International overrides**:
- Vietnamese: `ui-sans-serif` / `ui-serif` (native system fonts)
- Arabic: `"Noto Sans Arabic"` + NotionInter fallback
- Hebrew: `"Noto Sans Hebrew"` + NotionInter fallback
- Japanese: `Lyon Text` + `YuMincho` serif stack
- Chinese Simplified: `Lyon Text` + `"Songti TC"` serif stack
- Chinese Traditional: `Lyon Text` + `"Songti SC"` serif stack

### Font Size Scale

11-step scale from 0.75rem to 4.75rem:

| Token | Size | Equivalent |
|-------|------|------------|
| `--font-size-50` | 0.75rem | 12px |
| `--font-size-100` | 0.875rem | 14px |
| `--font-size-150` | 0.9375rem | 15px |
| `--font-size-200` | 1rem | 16px (base) |
| `--font-size-300` | 1.125rem | 18px |
| `--font-size-350` | 1.25rem | 20px |
| `--font-size-400` | 1.375rem | 22px |
| `--font-size-500` | 1.625rem | 26px |
| `--font-size-600` | 2rem | 32px |
| `--font-size-700` | 2.625rem | 42px |
| `--font-size-800` | 3.375rem | 54px |
| `--font-size-900` | 4rem | 64px |
| `--font-size-1000` | 4.75rem | 76px |

### Line Height Scale

Referenced from spacing scale:
```css
--font-line-height-50: var(--spacing-16);   /* 1rem / 16px */
--font-line-height-100: var(--spacing-20);  /* 1.25rem */
--font-line-height-200: var(--spacing-24);  /* 1.5rem */
--font-line-height-300: var(--spacing-28);  /* 1.75rem */
--font-line-height-400: var(--spacing-28);
--font-line-height-500: var(--spacing-32);  /* 2rem */
--font-line-height-600: var(--spacing-40);  /* 2.5rem */
--font-line-height-700: var(--spacing-48);  /* 3rem */
--font-line-height-800: var(--spacing-56);  /* 3.5rem */
--font-line-height-900: var(--spacing-64);  /* 4rem */
--font-line-height-1000: var(--spacing-80); /* 5rem */
```

### Letter Spacing

**Sans-serif** pattern: spacing tightens as size increases, with per-weight variants at display sizes:
```
--font-letter-spacing-sans-50: 0.0078125rem   (slightly open)
--font-letter-spacing-sans-100-200: 0         (neutral at body sizes)
--font-letter-spacing-sans-300-350: -0.0078125rem
--font-letter-spacing-sans-400: -0.015625rem
--font-letter-spacing-sans-500: -0.0390625rem
--font-letter-spacing-sans-600-regular: -0.0625rem
--font-letter-spacing-sans-600-semibold: -0.046875rem  (tighter for bold)
--font-letter-spacing-sans-700-regular: -0.125rem
--font-letter-spacing-sans-700-bold: -0.09375rem
--font-letter-spacing-sans-800-regular: -0.21875rem
--font-letter-spacing-sans-800-bold: -0.1171875rem
--font-letter-spacing-sans-900-regular: -0.171875rem
--font-letter-spacing-sans-1000-regular: -0.25rem
```

**Serif**: mostly 0 letter-spacing, tightening only at display sizes (700-900).

### Font Weights

```css
--font-weight-regular: 400;
--font-weight-medium: 500;
--font-weight-semibold: 600;
--font-weight-bold: 700;

/* Variable font alternatives (for NotionInter variable) */
--font-weight-variable-regular: 420;
--font-weight-variable-medium: 520;
--font-weight-variable-semibold: 620;
--font-weight-variable-bold: 680;
```

### Typography Scale Tokens

The system composes size + weight + line-height + family into font shorthands. Using `font: weight size/lineHeight family`:

```css
--typography-sans-200-regular-font: var(--font-weight-regular) var(--font-size-200)
  /var(--font-line-height-200) var(--font-family-sans);
```

### Semantic Typography Variants (56+ total)

**Global** (used on marketing pages):
| Variant | Font | Weight | Size | Usage |
|---------|------|--------|------|-------|
| GlobalTitle | sans-700 | Bold | 2.625rem | H1 page titles |
| GlobalTitleSm | sans-800 | Bold | 3.375rem | Smaller page titles |
| GlobalTitleMd | sans-900 | Bold | 4rem | Medium page titles |
| GlobalTitleEmphasis | sans-800 | Bold | 3.375rem | Emphasized titles |
| GlobalTitleEmphasisMd | sans-900 | Bold | 4rem | Large emphasized titles |
| GlobalTitleSubtle | sans-700 | Bold | 2.625rem | Subtle titles |
| GlobalHeading | sans-600 | Bold | 2rem | H2 section headings |
| GlobalHeadingMd | sans-700 | Bold | 2.625rem | Medium headings |
| GlobalHeadingLg | sans-800 | Bold | 3.375rem | Large headings |
| GlobalSubheading | sans-400 | Bold | 1.375rem | Section subheadings |
| GlobalContext | sans-100 | Regular | 0.875rem | Small context text |
| GlobalEyebrow | sans-200 | Regular | 1rem | Eyebrow labels |
| GlobalBody | sans-200 | Regular | 1rem | Body text |
| GlobalBodySerif | serif-350 | Regular | 1.25rem | Serif body text |
| GlobalBodyLink | sans-200 | Regular | 1rem | Inline links |
| GlobalCaption | sans-100 | Regular | 0.875rem | Captions |
| GlobalMeta | sans-50 | Regular | 0.75rem | Meta/legal text |
| GlobalQuote | serif-400 | Regular | 1.375rem | Pull quotes |
| GlobalQuoteSm | serif-500 | Regular | 1.625rem | Small quotes |
| GlobalQuoteMd | serif-600 | Regular | 2rem | Medium quotes |
| GlobalDeck | sans-200 | Regular | 1rem | Article deck |
| GlobalDeckSm | sans-350 | Regular | 1.25rem | Small deck |
| GlobalStat | sans-700 | Bold | 2.625rem | Statistics |
| GlobalStatSm | sans-800 | Bold | 3.375rem | Small stats |
| GlobalStatMd | sans-900 | Bold | 4rem | Large stats |
| GlobalCode | mono-100 | Regular | 0.875rem | Inline code |

**Interaction** (buttons, forms, menus):
| Variant | Font | Weight | Size | Usage |
|---------|------|--------|------|-------|
| InteractionButtonSmall | sans-100 | Medium | 0.875rem | Small buttons |
| InteractionButtonMedium | sans-200 | Medium | 1rem | Standard buttons |
| InteractionButtonLarge | sans-200 | Semibold | 1rem | Large buttons |
| InteractionFormLabel | sans-100 | Regular | 0.875rem | Form labels |
| InteractionFormCaption | sans-100 | Regular | 0.875rem | Form captions |
| InteractionFormInput | sans-200 | Regular | 1rem | Input text |
| InteractionMenuButton | sans-100 | Regular | 0.875rem | Menu triggers |
| InteractionMenuListHeading | sans-50 | Medium | 0.75rem | Menu headings |
| InteractionMenuListItemLabel | sans-100 | Medium | 0.875rem | Menu items |
| InteractionMenuListItemLabelEmphasis | sans-100 | Medium | 0.875rem | Emphasized menu items |
| InteractionMenuListItemCaption | sans-50 | Medium | 0.75rem | Menu captions |

**Card**:
| Variant | Font | Weight | Size | Usage |
|---------|------|--------|------|-------|
| CardTitle | sans-400 | Bold | 1.375rem | Card headings |
| CardTitleFeature | sans-500 | Bold | 1.625rem | Feature card titles |
| CardTitleFeatureMd | sans-600 | Bold | 2rem | Medium feature titles |
| CardTitleSummary | sans-200 | Bold | 1rem | Summary card titles |
| CardTitleBlock | sans-300 | Bold | 1.125rem | Block card titles |
| CardBody | sans-200 | Regular | 1rem | Card body |
| CardBodySummary | sans-100 | Regular | 0.875rem | Summary card body |
| CardContext | sans-100 | Regular | 0.875rem | Card context |
| CardContextFeature | sans-100 | Regular | 0.875rem | Feature card context |
| CardNote | sans-100 | Regular | 0.875rem | Card notes |
| CardQuote | serif-350 | Regular | 1.25rem | Card quotes |

**Navigation**:
| Variant | Font | Weight | Size | Usage |
|---------|------|--------|------|-------|
| NavigationHeading | sans-50 | Medium | 0.75rem | Nav section headings |
| NavigationLink | sans-100 | Medium | 0.875rem | Nav links |
| NavigationLinkEmphasis | sans-100 | Medium | 0.875rem | Emphasized nav links |
| NavigationLinkEmphasisMd | sans-400 | Bold | 1.375rem | Large nav links |
| NavigationCaption | sans-50 | Medium | 0.75rem | Nav captions |
| NavigationCaptionSubtle | sans-50 | Medium | 0.75rem | Subtle captions |
| NavigationBody | sans-100 | Regular | 0.875rem | Nav body text |

**Article** (blog/content pages):
| Variant | Font | Weight | Size |
|---------|------|--------|------|
| ArticleTitle | sans-600 | Bold | 2rem |
| ArticleTitleLg | sans-800 | Bold | 3.375rem |
| ArticleTitleSubtle | sans-600 | Bold | 2rem |
| ArticleTitleSubtleLg | sans-700 | Bold | 2.625rem |
| ArticleHeading | sans-400 | Bold | 1.375rem |
| ArticleHeadingLg | sans-500 | Bold | 1.625rem |
| ArticleSubheading | sans-300 | Bold | 1.125rem |
| ArticleSubheadingLg | sans-400 | Bold | 1.375rem |
| ArticleContext | sans-200 | Regular | 1rem |
| ArticleDeck | sans-350 | Regular | 1.25rem |
| ArticleDeckLg | sans-400 | Regular | 1.375rem |
| ArticleDropcap | sans-500 | Bold | 1.625rem |
| ArticleBody | sans-200 | Regular | 1rem |
| ArticleBodyLg | sans-300 | Regular | 1.125rem |
| ArticleBodyEditorial | serif-200 | Regular | 1rem |
| ArticleBodyEditorialLg | serif-350 | Regular | 1.25rem |
| ArticleBodyBold | sans-200 | Semibold | 1rem |
| ArticleBodyBoldLg | sans-300 | Semibold | 1.125rem |
| ArticleCaption | sans-50 | Medium | 0.75rem |
| ArticleMeta | sans-50 | Medium | 0.75rem |
| ArticleNavigation | sans-100 | Regular | 0.875rem |
| ArticleStatistics | sans-700 | Semibold | 2.625rem |
| ArticleStatisticsLg | sans-800 | Semibold | 3.375rem |
| ArticleQuote | serif-500 | Regular | 1.625rem |
| ArticleQuoteLg | serif-600 | Regular | 2rem |

### Typography Features
- `text-wrap: balance` on all headings and blockquotes
- Semantic `<em>` suppression for CJK languages (`:lang(ja)`, `:lang(ko)`, `:lang(zh)`)
- `font-style: normal` for italicized CJK text (where italic is culturally inappropriate)

---

## 5. Motion & Animation System

### Easing Curves

```css
--motion-timing-function-ease-in-out-quint: cubic-bezier(0.86, 0, 0.07, 1);
--motion-timing-function-ease-in-out-quart: cubic-bezier(0.76, 0, 0.24, 1);
--motion-timing-function-ease-in-out-quad: cubic-bezier(0.45, 0, 0.55, 1);
--motion-timing-function-ease-in-out-cubic: cubic-bezier(0.645, 0.045, 0.355, 1);
--motion-timing-function-ease-in-out-linear: cubic-bezier(0.5, 0, 0.5, 1);
--motion-timing-function-ease-in: ease-in;
--motion-timing-function-ease-out: ease-out;
--motion-timing-function-linear: linear;
```

### Duration Scale

```css
--motion-duration-100: 100ms;
--motion-duration-150: 150ms;
--motion-duration-200: 200ms;
--motion-duration-250: 250ms;
--motion-duration-300: 300ms;
```

### Global Motion Presets

```css
/* Transform animations (open/close, expand/collapse) */
--motion-global-transform-timing-function: var(--motion-timing-function-ease-in-out-quint);
--motion-global-transform-duration: var(--motion-duration-300);

/* Fade in */
--motion-global-fade-in-timing-function: var(--motion-timing-function-ease-out);
--motion-global-fade-in-duration: var(--motion-duration-150);

/* Fade out */
--motion-global-fade-out-timing-function: var(--motion-timing-function-ease-in);
--motion-global-fade-out-duration: var(--motion-duration-200);
```

### Keyframe Animations

6 named keyframes available:
1. **fadeIn** -- opacity 0 -> 1
2. **fadeOut** -- opacity 1 -> 0
3. **scaleIn** -- scale + opacity entrance
4. **scaleOut** -- scale + opacity exit
5. **popIn** -- bouncy entrance (scale overshoot)
6. **rotate** -- continuous rotation (for loading spinners)

### Transition Patterns

The system primarily uses:
- `transition: none` on most elements (immediate state changes)
- `transition: outline-color` with fade timings for focus rings
- Hover effects: predominantly `color` and `text-decoration` changes (no layout-affecting transitions)

### Animation Philosophy
- Minimal motion -- Notion's design is clean and efficient
- No scroll-triggered animations on the marketing site
- Focus ring animations for accessibility
- Transform-based animations for modals/dropdowns (quint easing at 300ms)
- Fade animations for overlays (ease-out 150ms for enter, ease-in 200ms for exit)

---

## 6. Interaction & UX Patterns

### Focus Ring System

```css
--color-interaction-focus-ring: var(--color-blue-600);
--dimension-interaction-focus-ring-outline-offset: var(--offset-2);   /* 2px */
--dimension-interaction-focus-ring-outline-width: var(--thickness-2); /* 2px */
```

Uniform 2px blue focus ring with 2px offset across all interactive elements.

### State System

Every interactive token has a complete state matrix:
- **default** -- base appearance
- **hover** -- cursor over element (typically 1 step darker/lighter)
- **focus** -- keyboard focused (same visual as hover usually)
- **active** -- mouse down / pressed (typically 2 steps darker)
- **selected** -- persistent selection state (for menus, tabs)

Example for buttons:
```css
--color-button-primary-background: var(--color-gray-900);
--color-button-primary-background-hover: var(--color-gray-800);
--color-button-primary-background-focus: var(--color-gray-700);
--color-button-primary-background-active: var(--color-alpha-black-700);
```

### Hover Interactions

Analysis of CSS reveals the primary hover response is:
- `color` changes (text, icons, borders)
- `text-decoration: underline` (links)
- `background-color` changes (buttons, surfaces, menu items)
- No scale transforms on hover (clean, professional approach)

### Link Behavior

```css
a {
  color: var(--color-link-primary-text);
  text-decoration: underline;
  text-underline-offset: var(--link-underline-offset);              /* 0.1em */
  text-decoration-thickness: var(--decoration-link-underline-thickness); /* 0.0625rem */
}

a:hover { color: var(--color-link-primary-text-hover); }
a:focus { color: var(--color-link-primary-text-focus); }
a:active { color: var(--color-link-primary-text-active); }
```

Subtle underline with 0.1em offset and thin (1px) stroke.

### Navigation Interactions
- Global nav height: 64px (fixed)
- Dropdown menus: white background with gray hover
- Mobile nav: z-index 200
- Dropdown grid layout (from `globalNavigation_dropdownGrid` class)

### Responsive Behavior
- Mobile-first approach (all breakpoints use `min-width`)
- Navigation collapses (mobile nav at z-index 200)
- Base padding scales: 20px -> 40px -> 60px
- Section spacing scales across all 5 breakpoints
- Typography sizes are NOT fluid (fixed at each breakpoint, not clamp-based)

---

## 7. Spacing & Visual Rhythm

### Primitive Spacing Scale

18-step rem-based scale:

| Token | Value | Pixels (16px base) |
|-------|-------|-------------------|
| `--spacing-0` | 0 | 0 |
| `--spacing-4` | 0.25rem | 4px |
| `--spacing-8` | 0.5rem | 8px |
| `--spacing-12` | 0.75rem | 12px |
| `--spacing-16` | 1rem | 16px |
| `--spacing-20` | 1.25rem | 20px |
| `--spacing-24` | 1.5rem | 24px |
| `--spacing-28` | 1.75rem | 28px |
| `--spacing-30` | 1.875rem | 30px |
| `--spacing-32` | 2rem | 32px |
| `--spacing-40` | 2.5rem | 40px |
| `--spacing-48` | 3rem | 48px |
| `--spacing-56` | 3.5rem | 56px |
| `--spacing-64` | 4rem | 64px |
| `--spacing-72` | 4.5rem | 72px |
| `--spacing-80` | 5rem | 80px |
| `--spacing-96` | 6rem | 96px |
| `--spacing-128` | 8rem | 128px |
| `--spacing-160` | 10rem | 160px |

### Responsive Section Spacing

```css
/* Mobile (< 600px) */
--spacing-xs: 20px; --spacing-s: 40px; --spacing-m: 40px;
--spacing-l: 60px; --spacing-xl: 60px; --base-padding: 20px;

/* Tablet (>= 600px) */
--base-padding: 40px; --spacing-l: 80px; --spacing-xl: 80px;

/* Desktop (>= 840px / 1080px) */
--base-padding: 60px; --spacing-m: 60px; --spacing-l: 120px; --spacing-xl: 160px;
```

### Component-Specific Spacing

**Card**:
```css
--spacing-card-padding-inline: var(--spacing-16);      /* 16px (compact) */
--spacing-card-padding-inline-sm: var(--spacing-24);    /* 24px (standard) */
--spacing-card-padding-block-start: var(--spacing-16);
--spacing-card-padding-block-end: var(--spacing-16);
--spacing-card-padding-inline-block: var(--spacing-32); /* 32px (block cards) */
```

**Block**:
```css
--block-spacing-padding-inline: var(--spacing-32);
--block-spacing-padding-block: var(--spacing-28);
--block-spacing-gap: var(--spacing-28);
--block-spacing-text-gap: var(--spacing-4);
```

**Bento Grid**:
```css
--bento-spacing-padding: var(--spacing-24);
--bento-spacing-asset-margin: var(--spacing-24);
--bento-spacing-text-gap: var(--spacing-4);
--bento-spacing-arrow-gap: var(--spacing-8);
```

### Border Radius System

10-step scale with semantic aliases:

| Token | Value | Usage |
|-------|-------|-------|
| `--border-radius-0` | 0 | Sharp corners |
| `--border-radius-200` | 0.25rem (4px) | Base, icon buttons |
| `--border-radius-300` | 0.3125rem (5px) | -- |
| `--border-radius-400` | 0.375rem (6px) | Bento cards |
| `--border-radius-500` | 0.5rem (8px) | Buttons, menu items |
| `--border-radius-600` | 0.625rem (10px) | Large buttons |
| `--border-radius-700` | 0.75rem (12px) | Cards, blocks, popovers |
| `--border-radius-800` | 0.875rem (14px) | -- |
| `--border-radius-900` | 1rem (16px) | -- |
| `--border-radius-round` | 624.9375rem | Full pill/round |

**Semantic radius**:
```css
--border-radius-base: var(--border-radius-200);       /* 4px */
--border-card-radius: var(--border-radius-700);        /* 12px */
--border-badge-radius: var(--border-radius-round);     /* pill */
--border-button-radius: var(--border-radius-500);      /* 8px */
--border-button-radius-lg: var(--border-radius-600);   /* 10px */
--border-icon-button-radius: var(--border-radius-200); /* 4px */
--border-menu-button-radius: var(--border-radius-round);
--border-menu-list-item-radius: var(--border-radius-500);
--border-popover-radius: var(--border-radius-700);
--border-block-media-radius: var(--border-radius-700);
```

### Border Widths

```css
--border-width-1: 0.0625rem;  /* 1px */
--border-width-2: 0.125rem;   /* 2px */
--border-width-4: 0.25rem;    /* 4px */
```

### Shadow System

3 elevation levels, all built from layered rgba shadows:

```css
/* Level 1: Subtle elevation (borders, hover cards) */
--shadow-100: 0px 0.7px 1.462px rgba(0,0,0,.015),
              0px 3px 9px #00000008;

/* Level 2: Card/dialog elevation */
--shadow-200: 0px 0.175px 1.041px rgba(0,0,0,.013),
              0px 0.8px 2.925px #00000005,
              0px 2.025px 7.847px rgba(0,0,0,.027),
              0px 4px 18px #0000000a;

/* Level 3: Modal/popover elevation */
--shadow-300: 0px 0.667px 3.502px #00000003,
              0px 2.933px 7.252px rgba(0,0,0,.016),
              0px 7.2px 14.462px #00000005,
              0px 13.867px 28.348px rgba(0,0,0,.024),
              0px 23.333px 52.123px #00000008,
              0px 36px 89px #0000000a;
```

### Z-Index Scale

```css
--z-index-header: 100;
--z-index-banner: 90;
--z-index-mobile-nav: 200;
--z-index-popup: 500;      /* also used for lightbox and tooltip */
--z-index-lightbox: var(--z-index-popup);
--z-index-tooltip: var(--z-index-popup);
```

---

## 8. Component Patterns

### Buttons

**4 variants**: Primary, Secondary, Tertiary, Ghost + Action Button

```css
/* Primary: filled dark */
--color-button-primary-background: var(--color-gray-900);
--color-button-primary-text: var(--color-white);
--color-button-primary-border: var(--color-transparent);

/* Secondary: outlined */
--color-button-secondary-background: var(--color-white);
--color-button-secondary-text: var(--color-gray-900);
--color-button-secondary-border: var(--color-alpha-black-200);

/* Tertiary: light background */
--color-button-tertiary-background: var(--color-white);
--color-button-tertiary-text: var(--color-alpha-black-900);
--color-button-tertiary-border: var(--color-alpha-black-200);

/* Ghost: transparent */
--color-button-ghost-background: var(--color-transparent);
--color-button-ghost-text: var(--color-alpha-black-900);
--color-button-ghost-border: var(--color-transparent);

/* Action Button: for toolbars */
--color-action-button-primary-background: var(--color-white);
--color-action-button-alpha-background: var(--color-alpha-black-200);
```

**3 sizes**: Small (100), Medium (200), Large (200-semibold)
**Border radius**: 8px (10px for large)
**States**: Every variant has hover/focus/active background and text colors

### Badges

4 styles:
- **mono** -- neutral gray background, black text
- **muted** -- gray background, muted text
- **bold** -- blue background, white text (high emphasis)
- **light** -- blue-100 background, blue-500 text (low emphasis)

All badges are fully rounded (pill).

### Cards

Cards use a consistent pattern:
```css
--color-card-accent: var(--color-blue-500);       /* top accent bar */
--color-card-border: var(--color-alpha-black-200); /* subtle border */
--color-card-background: var(--color-white);
--color-card-title-text: var(--color-black);
--color-card-body-text: var(--color-alpha-black-600);
```

Card spacing: 16px (compact) / 24px (standard) padding.

### Bento Grid

Named from the `bentos_bentoGrid` class, bento cards have:
```css
--bento-border-radius: var(--border-radius-400);   /* 6px */
--bento-border-radius-md: var(--border-radius-700); /* 12px */
--bento-border-width: var(--border-width-1);        /* 1px */
--bento-shadow-level: var(--shadow-200);            /* Card elevation */
--bento-spacing-padding: var(--spacing-24);         /* 24px */
```

Bento grid supports responsive variants: `bento_layoutWide`, and likely a 3-column / 4-column grid.

### Navigation

**Global navigation**: 64px height, fixed
**Dropdown**: Grid layout (`globalNavigation_dropdownGrid`), white background, gray hover
**Mobile**: Z-index 200 overlay

Navigation typography uses 50-100 scale sizes (small, compact fonts for nav).

### Content Blocks

Generic content block component with:
```css
--block-border-radius: var(--border-radius-700);
--block-border-width: var(--border-width-2);
--block-spacing-padding-inline: var(--spacing-32);
--block-spacing-padding-block: var(--spacing-28);
--block-spacing-gap: var(--spacing-28);
```

### Forms

Form tokens cover:
```css
--typography-interaction-form-label-font
--typography-interaction-form-caption-font
--typography-interaction-form-input-font
```

Uses outlined style with consistent focus ring treatment.

### Code Blocks

Full syntax highlighting palette:
- Comments: alpha-black-500
- Keywords: blue-500
- Strings: green-600
- Numbers/Functions/Classes: red-500
- Variables/Operators: orange-500

Terminal variant with gray background and alpha text.

### Logo Wall

Marquee/carousel logo display with responsive variants: Marquee, MarqueeSm, WallMd, WallLg, WallXl, WallXxl.

### Illustrations

Custom SVG illustrations with `pathShadow` effect class.

---

## 9. Design Tokens Summary

### Token Architecture

```
Primitive Tokens (raw values)
  -> font-size-*, font-weight-*, spacing-*, color-*-*, border-radius-*, shadow-*
  -> Typography Scale Tokens (composed)
    -> typography-sans-200-regular-font, etc.
    -> Semantic Typography Variants
      -> typography-global-title-font, typography-card-body-font, etc.
  -> Semantic Color Tokens
    -> color-text-*, color-background-*, color-button-*, color-icon-*, etc.
  -> Component Tokens
    -> bento-*, block-*, card-*, button-*, navigation-*
```

### Scale Systems

| System | Steps | Range |
|--------|-------|-------|
| Font Size | 11 | 0.75rem - 4.75rem |
| Font Weight | 4 (+4 variable) | 400 - 700 (420 - 680) |
| Line Height | 11 | 1rem - 5rem |
| Letter Spacing | 20+ | -0.25rem to 0.0078rem |
| Spacing | 18 | 0 - 10rem |
| Border Radius | 9 + round | 0 - 1rem + pill |
| Border Width | 3 | 1px - 4px |
| Shadow | 3 levels | card - modal |
| Z-Index | 5 | 90 - 500 |
| Motion Duration | 5 | 100ms - 300ms |
| Motion Easing | 7 | linear - quint |
| Color per Hue | 9 steps | 100 (light) - 900 (dark) |
| Alpha Steps | 9 | ~5% - ~95% opacity |
| Breakpoints | 5 | 600 - 1440px |

### Color Palette Summary

| Hue | 500 (Mid) | Character |
|-----|-----------|-----------|
| Gray | `#78736f` | Warm gray |
| Blue | `#097fe8` | Bright primary |
| Red | `#f64932` | Vibrant error |
| Orange | `#ff6d00` | Warm accent |
| Yellow | `#ffb110` | Attention |
| Green | `#1aae39` | Success |
| Teal | `#27918d` | Calm accent |
| Purple | `#9849e8` | Creative accent |
| Pink | `#ff64c8` | Playful accent |
| Brown | `#9c7054` | Earthy accent |

### International Typography Matrix

| Language | Sans | Serif |
|----------|------|-------|
| Latin/Cyrillic | NotionInter | Lyon Text |
| Japanese | NotionInter | Lyon Text + YuMincho |
| Chinese (S) | NotionInter | Lyon Text + Songti TC |
| Chinese (T) | NotionInter | Lyon Text + Songti SC |
| Korean | NotionInter | Batang |
| Vietnamese | ui-sans-serif | ui-serif |
| Arabic | Noto Sans Arabic | -- |
| Hebrew | Noto Sans Hebrew | -- |

---

## 10. Key Takeaways

1. **CSS Custom Properties at scale**: 2890+ tokens organized in a 4-tier architecture (primitive -> composed -> semantic -> component) is the gold standard for enterprise design systems.

2. **`@layer` cascade is the future**: Notion uses CSS `@layer` to guarantee specificity ordering without specificity hacks. Front-tokens always load first, component overrides always win.

3. **Semantic typography is the right approach**: 56+ named variants (GlobalTitle, CardBody, ArticleDeck) rather than utility classes (`.text-2xl .font-bold`) means consistent, meaningful typography across all surfaces.

4. **Dark theme via token swapping**: Not a separate stylesheet -- the same semantic tokens (`--color-text`, `--color-background-base`) are redefined in the dark layer. Components don't need dark-specific styles.

5. **Campaign palette theming**: 8 color palette themes enable completely different look-and-feel for marketing campaigns while reusing ALL components unchanged. This is peak design system architecture.

6. **International typography is built-in**: Language-specific font stacks with serif/sans/mono pairing for CJK, Arabic, Hebrew, and Vietnamese -- not an afterthought.

7. **Motion is minimal and purposeful**: No scroll-triggered animations. Just quint-eased transforms for UI and fade transitions. The product sells itself without flash.

8. **Every color has 4 states minimum**: default/hover/focus/active are tokens for every interactive color. No `darken($color, 10%)` magic numbers in components.

9. **12-column grid with 28px gutters**: Standard but refined -- the gutter shrinks to 12px on mobile, maintaining proportion.

10. **CSS Modules with semantic naming**: `semanticTypography_variantNavigationLinkEmphasis__LHUdD` -- readable, self-documenting class names even with hashed suffixes.

---

## 11. Extraction Limitations

- **No JavaScript analysis**: Animation implementations (GSAP, Framer Motion usage) could not be verified without JS inspection. Only CSS keyframes were captured.
- **Homepage only + 1 sub-page**: The /product/ai page was analyzed but deeper pages (/customers, /pricing, /templates) were not fetched (responsible budget).
- **No dark theme visual verification**: Dark theme tokens exist in CSS but were not visually confirmed.
- **No component markup analysis**: HTML was parsed but the JSX/React component structure (props API, composition patterns) is inferred from CSS classes only.
- **Media queries exhaustive**: All 5 breakpoints were identified but exact responsive behavior per component was not exhaustively cataloged.
- **2 CSS files of 12 analyzed**: Next.js code-splits CSS per page. The two files analyzed contain the token system and typography. Component-specific CSS (forms, menus, dialogs) was partially captured.

---

*Extracted with DesignSystemAnalyzer/1.0 -- 5 requests, ~954KB total downloaded, 2s request delay*
