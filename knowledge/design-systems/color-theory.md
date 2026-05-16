# Color Theory & Palette Architecture

Comprehensive color science for premium UI design. From color spaces to palette generation to dark mode architecture.

---

## 1. Color Spaces & When to Use Them

| Space | Axes | Best For |
|-------|------|----------|
| **HEX** | #RRGGBB | Simple color declaration |
| **RGB** | 0-255, 0-255, 0-255 | CSS, digital screens |
| **HSL** | Hue(0-360), Sat%, Light% | Intuitive palette creation, tints/shades |
| **OKLCH** | Lightness, Chroma, Hue | Perceptually uniform, modern CSS, accessible palettes |
| **LAB** | Lightness, A(green-red), B(blue-yellow) | Perceptual uniformity, color difference calculation |

### OKLCH — The Modern Standard
```css
:root {
  /* Perceptually uniform — same Lightness value = same perceived brightness */
  --primary: oklch(65% 0.18 250);      /* blue at 65% lightness */
  --secondary: oklch(65% 0.15 150);    /* green at 65% lightness — appears equally bright */
  --accent: oklch(65% 0.18 20);        /* red at 65% lightness — same perceived brightness */

  /* Unlike HSL where 50% lightness on yellow vs blue look completely different */
}
```

### Generating Palettes with OKLCH
```css
/* Same hue, varying lightness = perfect monochromatic scale */
--brand-50:  oklch(97% 0.02 250);
--brand-100: oklch(90% 0.05 250);
--brand-200: oklch(82% 0.08 250);
--brand-300: oklch(74% 0.12 250);
--brand-400: oklch(66% 0.16 250);
--brand-500: oklch(55% 0.20 250);  /* base */
--brand-600: oklch(46% 0.18 250);
--brand-700: oklch(37% 0.14 250);
--brand-800: oklch(28% 0.10 250);
--brand-900: oklch(18% 0.05 250);
```

---

## 2. Color Harmony Rules

### Rule 1: Complementary (180° apart on wheel)
```
Blue (#2563eb)  +  Orange (#ea580c)
Purple (#7c3aed)  +  Yellow (#ca8a04)
Teal (#0d9488)  +  Coral (#e11d48)
```
Best for: Call-to-action buttons on opposite-colored backgrounds

### Rule 2: Analogous (30° apart)
```
Blue (#3b82f6)  →  Teal (#14b8a6)  →  Green (#22c55e)
Orange (#f97316)  →  Yellow (#eab308)  →  Lime (#84cc16)
```
Best for: Gradients, data visualizations, category color coding

### Rule 3: Triadic (120° apart)
```
Red  +  Blue  +  Yellow
Orange  +  Green  +  Purple
```
Best for: Playful/creative brands, children's apps

### Rule 4: Split-Complementary
```
Blue + Yellow-Orange + Red-Orange (instead of pure Orange)
```
Best for: Softer contrast than pure complementary, more sophisticated

### Rule 5: Tetradic (Rectangle — two complementary pairs)
```
Blue + Orange  +  Green + Red
```
Best for: Complex data viz, multi-category systems

### Rule 6: Monochromatic
```
Single hue, varying lightness + saturation
```
Best for: Minimal luxury, single-brand emphasis

---

## 3. Palette Architecture (CSS Custom Properties)

### The 3-Layer System
```css
:root {
  /* === Layer 1: Raw Primitives (HSL for intuition) === */
  --hue-primary: 250;
  --hue-secondary: 160;
  --hue-accent: 25;

  /* === Layer 2: Semantic Tokens === */
  --color-primary:       hsl(var(--hue-primary), 80%, 55%);
  --color-primary-hover: hsl(var(--hue-primary), 80%, 48%);
  --color-primary-muted: hsl(var(--hue-primary), 40%, 94%);
  --color-secondary:     hsl(var(--hue-secondary), 70%, 45%);
  --color-accent:        hsl(var(--hue-accent), 90%, 55%);

  --color-background:    hsl(40, 30%, 98%);
  --color-surface:       hsl(0, 0%, 100%);
  --color-foreground:    hsl(240, 5%, 15%);
  --color-muted:         hsl(240, 5%, 45%);
  --color-border:        hsl(240, 5%, 90%);

  --color-success:       hsl(150, 70%, 45%);
  --color-warning:       hsl(40, 90%, 50%);
  --color-error:         hsl(0, 80%, 55%);

  /* === Layer 3: RGB variants (for opacity/alpha usage) === */
  --primary-rgb: 99, 102, 241;
  --foreground-rgb: 30, 30, 40;
}
```

### Usage Patterns
```css
/* Solid usage */
.button-primary { background: var(--color-primary); }

/* Alpha usage */
.glass-overlay { background: rgba(var(--primary-rgb), 0.1); }
.focus-ring { box-shadow: 0 0 0 3px rgba(var(--primary-rgb), 0.3); }

/* Gradients */
.gradient-brand {
  background: linear-gradient(135deg,
    hsl(var(--hue-primary), 80%, 60%),
    hsl(var(--hue-secondary), 70%, 50%)
  );
}
```

---

## 4. Dark Mode Architecture

### System-Driven Theme Switching
```css
:root {
  /* Light defaults */
  --bg: hsl(40, 30%, 98%);
  --surface: hsl(0, 0%, 100%);
  --text: hsl(240, 5%, 15%);
  --text-muted: hsl(240, 5%, 45%);
  --border: hsl(240, 5%, 90%);

  /* Shadows (light mode — colored shadows) */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.04);
  --shadow-md: 0 4px 16px rgba(0, 0, 0, 0.06);
  --shadow-lg: 0 12px 40px rgba(0, 0, 0, 0.08);
}

[data-theme='dark'] {
  --bg: hsl(240, 10%, 6%);
  --surface: hsl(240, 10%, 12%);
  --text: hsl(40, 20%, 92%);
  --text-muted: hsl(240, 5%, 55%);
  --border: hsl(240, 5%, 20%);

  /* Shadows (dark mode — use larger blur, lower opacity) */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.2);
  --shadow-md: 0 4px 16px rgba(0, 0, 0, 0.3);
  --shadow-lg: 0 12px 40px rgba(0, 0, 0, 0.4);
}

/* Respect OS preference */
@media (prefers-color-scheme: dark) {
  :root:not([data-theme='light']) {
    --bg: hsl(240, 10%, 6%);
    /* ... */
  }
}
```

### Dark Mode Color Adjustments
```css
/*
  CRITICAL RULES:
  1. Never pure white text on pure black — use off-white on near-black
  2. Reduce saturation in dark mode (colors appear more vibrant in dark)
  3. Increase lightness of surface colors (not just invert)
  4. Shadows become glows in dark mode
*/

[data-theme='dark'] {
  /* Desaturate primaries slightly */
  --color-primary: hsl(var(--hue-primary), 65%, 60%);

  /* Surfaces get slightly lighter than background */
  --surface-elevated: hsl(240, 10%, 15%);
  --surface-overlay: hsl(240, 10%, 20%);
}
```

---

## 5. Accessibility & Contrast

### WCAG 2.1 AA Requirements
| Element | Minimum Ratio | Example |
|---------|--------------|---------|
| Body text (< 18px) | 4.5:1 | `#333` on `#fff` = 12.6:1 |
| Large text (≥ 18px bold or ≥ 24px) | 3:1 | `#666` on `#fff` = 5.7:1 |
| UI components, icons | 3:1 | Borders, focus indicators |
| **AAA (optional)** | 7:1 | `#222` on `#fff` = 15.9:1 |

### APCA (Advanced Perceptual Contrast Algorithm)
Modern replacement for WCAG contrast ratio. More accurate for dark mode.
```css
/* APCA-friendly: uses font weight + size in calculation */
/* Light mode: Lc90 (bg) with Lc15 (text) for body — Lc values from 0-100 */
/* Dark mode: Lc10 (bg) with Lc85 (text) for body */
```

### Common Contrast Traps
```
❌ #999 on #fff (2.8:1) — fails AA for body text
✅ #767676 on #fff (4.5:1) — passes AA
❌ #3498db on #fff (3.8:1) — fails for UI elements
✅ #2176ae on #fff (4.7:1) — passes
❌ #888 on black (5.3:1) — passes AA but strains eyes (reverse polarity)
✅ #aaa on black (8.6:1) — comfortable dark mode
```

---

## 6. Cultural Color Meanings

| Color | Western | East Asian | Middle Eastern | Indian |
|-------|---------|------------|----------------|--------|
| Red | Danger, love | Luck, prosperity | Danger, courage | Purity, marriage |
| White | Purity, peace | Death, mourning | Purity | Mourning |
| Green | Nature, go | Prosperity, health | Islam, peace | Prosperity |
| Yellow | Caution, warmth | Royalty, power | Happiness | Knowledge |
| Blue | Trust, calm | Immortality | Protection | Krishna, divinity |
| Purple | Royalty | Wealth, nobility | Wealth | Sorrow (sometimes) |
| Black | Death, formal | Water, mystery | Mourning | Protection from evil |

### Food-Specific Color Psychology
```
Green:    Fresh, organic, healthy, vegetable-forward
Orange:   Appetite stimulant, warmth, comfort food
Red:      Hunger trigger, bold flavors, spicy
Yellow:   Happiness, quick-serve, affordable
Brown:    Earthy, artisanal, baked goods, coffee
White:    Clean, dairy, minimalist cuisine
```

---

## 7. Gradient Pairing Rules

### Rule 1: Analogous (safe, beautiful)
```css
background: linear-gradient(135deg, #667eea, #764ba2);  /* blue → purple */
background: linear-gradient(135deg, #f093fb, #f5576c);  /* pink → coral */
background: linear-gradient(135deg, #4facfe, #00f2fe);  /* light blue → cyan */
```

### Rule 2: Monochromatic with Brightness Shift
```css
background: linear-gradient(135deg, #0ea5e9, #0369a1);  /* light blue → dark blue */
background: linear-gradient(135deg, #a78bfa, #5b21b6);  /* lavender → deep purple */
```

### Rule 3: Warm → Cool Cross (dramatic)
```css
background: linear-gradient(135deg, #ff6b6b, #4ecdc4);  /* coral → teal */
background: linear-gradient(135deg, #f97316, #06b6d4);  /* orange → cyan */
```

### Rule 4: Multi-Stop Premium
```css
background: linear-gradient(135deg,
  #667eea 0%,
  #764ba2 30%,
  #f093fb 60%,
  #f5576c 100%
);
```

---

## 8. Palette Extraction from Images

```css
/*
  Technique: Use a hero image as the source of your palette.
  1. Dominant color → primary
  2. Secondary dominant → secondary
  3. Lightest tone → background
  4. Darkest tone → foreground
*/

/* Example: Ocean photography */
/* Dominant: deep blue → --primary: #1e40af */
/* Secondary: sand beige → --secondary: #d4a574 */
/* Lightest: foam white → --bg: #f0f4f8 */
/* Darkest: abyss navy → --text: #0f172a */
```

---

## 9. Color Mode Transitions

```css
/* Smooth theme switching */
:root,
[data-theme] {
  transition:
    background-color 0.3s ease,
    color 0.3s ease,
    border-color 0.3s ease,
    box-shadow 0.3s ease;
}

/* Disable transitions on page load (prevents flash) */
.preload * {
  transition: none !important;
}
```

```tsx
// Theme toggle script (run before paint)
function ThemeScript() {
  return (
    <script dangerouslySetInnerHTML={{ __html: `
      (function() {
        const theme = localStorage.getItem('theme') ||
          (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
        document.documentElement.setAttribute('data-theme', theme);
        document.documentElement.classList.add('preload');
        window.addEventListener('load', () => {
          document.documentElement.classList.remove('preload');
        });
      })();
    `}} />
  );
}
```

---

## 10. Quick Palette Templates

### Nature / Organic
```css
--primary: #2d6a4f;       /* forest green */
--secondary: #8cb369;     /* sage */
--accent: #f4a261;        /* warm orange */
--bg: #faf7f2;            /* cream */
--text: #2d2a26;          /* warm charcoal */
```

### Tech / SaaS
```css
--primary: #2563eb;       /* electric blue */
--secondary: #7c3aed;     /* violet */
--accent: #06b6d4;        /* cyan */
--bg: #f8fafc;            /* slate 50 */
--text: #0f172a;          /* slate 900 */
```

### Luxury / Premium
```css
--primary: #1a1a2e;       /* midnight navy */
--secondary: #c9a84c;     /* gold */
--accent: #8b4513;        /* saddle */
--bg: #faf8f2;            /* cream */
--text: #1a1a2e;          /* deep navy */
```

### Food / Culinary
```css
--primary: #e07a5f;       /* terracotta */
--secondary: #81b29a;     /* herb green */
--accent: #f2cc8f;        /* butter yellow */
--bg: #fefae0;            /* warm cream */
--text: #3d3529;          /* dark roast */
```

### Wellness / Health
```css
--primary: #7ec8a4;       /* mint */
--secondary: #a8d8ea;     /* sky blue */
--accent: #f5cac3;        /* blush */
--bg: #f7f9fb;            /* cool white */
--text: #2d3748;          /* charcoal */
```
