# Iconography Design — Premium Icon Systems

Icon systems as visual language. Sizing, animation, SVG best practices, icon libraries, and custom animated icons for premium interfaces.

---

## 1. Icon Sizing System

```css
:root {
  /* Icon size scale — consistent across the application */
  --icon-xs:   12px;  /* Badges, inline with 10px text */
  --icon-sm:   14px;  /* Secondary text, table cells */
  --icon-md:   16px;  /* Standard — buttons, form fields, links */
  --icon-lg:   20px;  /* Navigation items, card actions */
  --icon-xl:   24px;  /* Feature icons, empty states */
  --icon-2xl:  32px;  /* Modal headers, hero icons */
  --icon-3xl:  48px;  /* Empty state illustrations, onboarding */
}
```

### Sizing Decision Table
| Context | Icon Size | Example |
|---------|-----------|---------|
| Inline with body text (16px) | 16px | `CheckCircle` in paragraph |
| Inline with small text (12px) | 12px | `ExternalLink` in footnote |
| Button with text | 16px | `Plus` in "Add item" button |
| Icon-only button (32px) | 18px | `X` close button |
| Icon-only button (40px+) | 20-24px | `Search` in search bar |
| Navigation item | 20px | Sidebar items |
| Feature card header | 24-32px | "Fast performance" icon |
| Empty state | 48px | "No items" illustration |
| App / brand mark | 32-48px | Logo icon variant |

---

## 2. Icon Library Selection

| Library | Style | Count | Bundle Impact | Best For |
|---------|-------|-------|---------------|----------|
| **Lucide** | Clean outline | 1400+ | Tree-shakeable | General UI, SaaS |
| **Phosphor** | 6 styles per icon | 1400+ | Tree-shakeable | Apps needing multiple weights |
| **Tabler** | Outline | 5000+ | Tree-shakeable | Extensive coverage |
| **Radix Icons** | Crisp 15×15 | 300+ | Tree-shakeable | Accessibility focus |
| **Heroicons** | Outline + Solid | 300+ | Tree-shakeable | Tailwind ecosystem |
| **react-bits** | Animated/text | 110+ | Component-based | Premium animations |

### Import Pattern
```tsx
// Tree-shakeable — only the icons you import end up in the bundle
import { Search, Plus, X, ChevronRight, Check, AlertCircle } from 'lucide-react';

// DO NOT: import * as Icons from 'lucide-react'; // imports ALL 1400+ icons
```

---

## 3. Icon Component System

### Base Icon Wrapper
```tsx
interface IconProps {
  size?: number;
  className?: string;
  'aria-label'?: string;
  decorative?: boolean;
}

function createIcon(Icon: React.ComponentType<any>) {
  return function StyledIcon({
    size = 16,
    className,
    'aria-label': ariaLabel,
    decorative = false,
  }: IconProps) {
    return (
      <Icon
        size={size}
        className={className}
        aria-label={ariaLabel}
        aria-hidden={decorative || !ariaLabel}
        role={decorative ? 'presentation' : undefined}
      />
    );
  };
}

// Usage
const StyledSearch = createIcon(Search);
```

### Icon with Badge (notification pattern)
```tsx
function IconBadge({
  icon: Icon,
  count,
  size = 20,
}: {
  icon: React.ComponentType<any>;
  count: number;
  size?: number;
}) {
  return (
    <span className="relative inline-flex">
      <Icon size={size} />
      {count > 0 && (
        <span className="
          absolute -top-1.5 -right-1.5
          min-w-[16px] h-4
          bg-error text-white
          text-[9px] font-bold
          rounded-full
          flex items-center justify-center
          px-1
          leading-none
        ">
          {count > 99 ? '99+' : count}
        </span>
      )}
    </span>
  );
}
```

---

## 4. Animated Icons

### Morphing Icon (play → pause toggle)
```tsx
function PlayPauseIcon({ isPlaying, size = 24 }: { isPlaying: boolean; size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor">
      <motion.rect
        animate={isPlaying
          ? { x: 6, y: 4, width: 4, height: 16, rx: 1 }
          : { x: 7, y: 5, width: 3, height: 14, rx: 1 }
        }
        transition={{ type: 'spring', stiffness: 500, damping: 35 }}
      />
      <motion.rect
        animate={isPlaying
          ? { x: 14, y: 4, width: 4, height: 16, rx: 1 }
          : { x: 14, y: 7, width: 2, height: 10, rx: 1 }
        }
        transition={{ type: 'spring', stiffness: 500, damping: 35 }}
      />
      {/* Triangle for play state */}
      {!isPlaying && (
        <motion.path
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          d="M6 5L6 19L18 12L6 5Z"
          fill="currentColor"
          style={{ display: isPlaying ? 'none' : 'block' }}
        />
      )}
    </svg>
  );
}
```

### Animated Hamburger → Close
```tsx
function HamburgerIcon({ open, size = 24 }: { open: boolean; size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round">
      {/* Top line */}
      <motion.line
        animate={open
          ? { x1: 5, y1: 5, x2: 19, y2: 19 }
          : { x1: 4, y1: 6, x2: 20, y2: 6 }
        }
        transition={{ type: 'spring', stiffness: 500, damping: 35 }}
      />
      {/* Middle line */}
      <motion.line
        animate={open ? { opacity: 0, x1: 12, x2: 12 } : { opacity: 1, x1: 4, y1: 12, x2: 20, y2: 12 }}
        transition={{ duration: 0.15 }}
      />
      {/* Bottom line */}
      <motion.line
        animate={open
          ? { x1: 5, y1: 19, x2: 19, y2: 5 }
          : { x1: 4, y1: 18, x2: 20, y2: 18 }
        }
        transition={{ type: 'spring', stiffness: 500, damping: 35 }}
      />
    </svg>
  );
}
```

### Draw / Check Animation
```tsx
function AnimatedCheck({ size = 24, className }: { size?: number; className?: string }) {
  return (
    <motion.svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={2.5}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
    >
      <motion.circle
        cx={12} cy={12} r={10}
        initial={{ pathLength: 0 }}
        animate={{ pathLength: 1 }}
        transition={{ duration: 0.3, ease: 'easeOut' }}
        className="text-success"
      />
      <motion.path
        d="M8 12L11 15L16 9"
        initial={{ pathLength: 0 }}
        animate={{ pathLength: 1 }}
        transition={{ duration: 0.3, delay: 0.15, ease: [0.22, 1, 0.36, 1] }}
        className="text-success"
      />
    </motion.svg>
  );
}
```

### Spinning / Loading Icon
```tsx
function Spinner({ size = 16, className }: { size?: number; className?: string }) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      aria-label="Loading"
      role="status"
      className={className}
    >
      <motion.circle
        cx={12} cy={12} r={10}
        stroke="currentColor"
        strokeWidth={3}
        strokeLinecap="round"
        strokeDasharray="31.4 31.4"
        animate={{ rotate: 360 }}
        transition={{ repeat: Infinity, duration: 1, ease: 'linear' }}
        className="opacity-25"
      />
      <motion.circle
        cx={12} cy={12} r={10}
        stroke="currentColor"
        strokeWidth={3}
        strokeLinecap="round"
        strokeDasharray="31.4 31.4"
        initial={{ pathLength: 0.25 }}
        animate={{ pathLength: 0.75, rotate: 360 }}
        transition={{ repeat: Infinity, duration: 1, ease: 'linear' }}
      />
    </svg>
  );
}
```

---

## 5. Favicon & App Icon System

### Complete Favicon Set (HTML head)
```html
<!-- Primary favicon -->
<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />

<!-- Apple touch icon (iOS home screen) -->
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />

<!-- Android / PWA -->
<link rel="manifest" href="/site.webmanifest" />
<meta name="theme-color" content="var(--color-primary)" />

<!-- Windows tiles -->
<meta name="msapplication-TileColor" content="var(--color-primary)" />
<meta name="msapplication-config" content="/browserconfig.xml" />
```

### SVG Favicon (modern, single-file)
```xml
<!-- favicon.svg — supports dark mode via prefers-color-scheme -->
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
  <style>
    path { fill: #2563eb; }
    @media (prefers-color-scheme: dark) {
      path { fill: #60a5fa; }
    }
  </style>
  <path d="M16 2L2 28h28L16 2zm0 6l10 18H6l10-18z"/>
</svg>
```

---

## 6. Icon Accessibility

```tsx
// ✓ Decorative icon (screen readers skip it)
<Search size={16} aria-hidden="true" />

// ✓ Semantic icon (screen readers announce it)
<AlertCircle size={16} aria-label="Warning: your password is weak" role="img" />

// ✓ Button with icon + text (text provides the label)
<button>
  <Plus size={16} aria-hidden="true" />
  Add item
</button>

// ✓ Icon-only button (needs an accessible name)
<button aria-label="Search">
  <Search size={20} aria-hidden="true" />
</button>

// ❌ Icon-only button without label (screen reader sees nothing)
<button>
  <Search size={20} />
</button>

// ❌ Icon with text and both announced (redundant)
<button aria-label="Add item">
  <Plus size={16} aria-label="Plus icon" />  {/* Don't do this */}
  Add item
</button>
```

---

## 7. Icon Color System

```css
/* Icon inherits text color by default — best practice */
.icon { color: inherit; }

/* Explicit icon colors */
.icon-primary    { color: var(--color-primary); }
.icon-success    { color: var(--color-success); }
.icon-warning    { color: var(--color-warning); }
.icon-error      { color: var(--color-error); }
.icon-muted      { color: var(--color-muted); }
.icon-foreground { color: var(--color-foreground); }

/* Interactive icons (hover states) */
.icon-interactive {
  color: var(--color-muted);
  transition: color 150ms ease;
}
.icon-interactive:hover {
  color: var(--color-foreground);
}

/* Dual-tone icons (brand/logo) */
.icon-duotone {
  opacity: 0.4;  /* Secondary paths */
}
.icon-duotone .primary-path {
  opacity: 1;
}
```

---

## 8. Icon Spacing & Alignment

```css
/* Standard icon + text gap */
.icon-with-text {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

/* Icon in button */
.btn-icon {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

/* Vertically center icon with text */
.icon-inline {
  vertical-align: -0.125em; /* Aligns 16px icon with 16px text */
}

/* Centered icon in a fixed container */
.icon-box {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: var(--radius-md);
  background: rgba(var(--primary-rgb), 0.1);
  color: var(--color-primary);
}
```

---

## 9. Custom SVG Icon Template

```tsx
// When you need a custom icon not in any library:
function CustomIcon({ size = 24, className }: { size?: number; className?: string }) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={2}
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <circle cx="12" cy="12" r="10" />
      <path d="M8 12l3 3 5-5" />
    </svg>
  );
}

// Consistency rules for custom icons:
// - 24×24 viewBox (standard)
// - stroke="currentColor" (inherits from CSS color)
// - strokeWidth={2} (matches Lucide / Feather style)
// - strokeLinecap="round" + strokeLinejoin="round" (friendly look)
// - No hardcoded colors (use currentColor)
```

---

## 10. Icon Bundling Strategy

```
Tree-shakeable imports (Lucide, Phosphor):
  ✓ import { Search, Plus } from 'lucide-react'
  Bundle: only Search + Plus (~2KB)
  Recommended for all projects

Sprite sheets (large icon sets, server-rendered):
  ✓ <use href="/icons.svg#search" />
  Bundle: 0KB JS, but requires HTTP request
  Good for: SSR, static sites

Inline SVGs (animated, custom):
  ✓ <svg>...</svg> in JSX
  Bundle: included in JS bundle
  Good for: animated icons, custom brand marks

Font icons (FontAwesome, Material Icons):
  ✗ Deprecated — accessibility issues, renders entire font
  Avoid for new projects
```
