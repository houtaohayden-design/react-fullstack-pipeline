# Lucide React — Usage Patterns

> Source: [lucide-icons/lucide](https://github.com/lucide-icons/lucide) | 1,711 icons | 42 categories

## Icon Sizing System

Lucide uses a consistent sizing scale. All icons render in a 24x24 viewBox by default:

| Size (px) | Use Case | Example |
|-----------|----------|---------|
| `12` | Inline text icons, badges | `<Info size={12} />` |
| `16` | Tight UI, button icons, form fields | `<Search size={16} />` |
| `20` | Compact buttons, tooltips | `<Bell size={20} />` |
| `24` | **Default** — standard UI icons | `<Home size={24} />` |
| `32` | Medium emphasis, nav icons | `<ShoppingCart size={32} />` |
| `40` | Large decorative icons | `<Heart size={40} />` |
| `48` | Hero/feature icons | `<Shield size={48} />` |

```tsx
// Consistent sizing pattern
<Button>
  <Search size={16} />
  <span>Search</span>
</Button>

<div className="flex gap-2 items-center">
  <MapPin size={20} />
  <span>San Francisco, CA</span>
</div>
```

## Color Inheritance

Icons default to `stroke="currentColor"` — they inherit the text color of their parent. This is the primary pattern for theming:

```tsx
// Icon inherits color from parent class
<a href="/settings" className="text-gray-600 hover:text-blue-600">
  <Settings size={20} />
</a>

// Dark mode via Tailwind
<Sun className="text-yellow-500 dark:text-yellow-300" />

// Explicit color override
<AlertTriangle color="#ef4444" size={24} />

// CSS variable integration
<CheckCircle color="var(--color-success)" />
```

## Stroke Width Conventions

The default stroke width is `2`. Lucide icons are stroked (not filled) — they use consistent `strokeLinecap="round"` and `strokeLinejoin="round"`:

| `strokeWidth` | Visual | Best For |
|---------------|--------|----------|
| `1` | Hairline, delicate | Large decorative icons, minimal UI |
| `1.5` | Light | Modern SaaS, shadcn/ui integration |
| `2` | **Default** — balanced | Most use cases |
| `2.5` | Semi-bold | Emphasis, active states |
| `3` | Bold | Navigation, mobile touch targets |

```tsx
// Custom stroke width
<Star strokeWidth={1.5} />  // lighter, modern look
<Star strokeWidth={3} />    // bolder, more visible
```

## Accessibility

### Automatic aria-hidden

When no accessible props are provided (`aria-label`, `aria-labelledby`, `role`, `title`), icons **automatically** get `aria-hidden="true"` — making them invisible to screen readers. This is the correct pattern for purely decorative icons.

### For meaningful icons

```tsx
// Icon conveys meaning — add aria-label
<AlertTriangle aria-label="Warning: unsaved changes" color="#f59e0b" />

// Alternative: use role="img" with title
<Info role="img" title="Information">
  <title>Information</title>
</Info>

// Decorative icon (no aria-label needed — auto-hidden)
<div className="flex items-center gap-2">
  <Star size={16} />  {/* auto aria-hidden */}
  <span>4.8 rating</span>  {/* text conveys meaning */}
</div>
```

### Button with icon

```tsx
// Icon-only button — label the button, not the icon
<button aria-label="Search">
  <Search size={20} />
</button>

// Icon + text button — icon is decorative
<button>
  <Search size={16} aria-hidden="true" />
  Search
</button>
```

## Tree-Shaking

Lucide React is fully tree-shakeable. Only icons you import are included:

```tsx
// GOOD: 1 icon bundled (~300 bytes gzipped)
import { Search } from 'lucide-react';

// GOOD: Named imports are tree-shaken
import { Search, Heart, User } from 'lucide-react';
// Only Search, Heart, User in bundle

// BAD: Entire library bundled (~400KB gzipped)
import * as Icons from 'lucide-react';
```

The package declares `"sideEffects": false`, enabling bundlers to safely eliminate unused exports.

## Dynamic Icon Loading

When icon names come from data (CMS, API, user config), use `DynamicIcon` from the `/dynamic` subpath:

```tsx
// From CMS content
import { DynamicIcon } from 'lucide-react/dynamic';

interface Feature {
  title: string;
  icon: string; // e.g., "shield-check", "zap", "palette"
  description: string;
}

function FeatureCard({ feature }: { feature: Feature }) {
  return (
    <div className="p-6 rounded-lg border">
      <DynamicIcon
        name={feature.icon}
        size={32}
        className="text-blue-500 mb-4"
      />
      <h3>{feature.title}</h3>
      <p>{feature.description}</p>
    </div>
  );
}

// With loading fallback
function SafeDynamicIcon({ name, ...props }: { name: string }) {
  return (
    <DynamicIcon
      name={name}
      fallback={() => <div className="w-6 h-6 rounded bg-gray-200 animate-pulse" />}
      {...props}
    />
  );
}
```

### Dynamic Icon with Error Handling

```tsx
import { iconNames, DynamicIcon } from 'lucide-react/dynamic';

function SafeIcon({ name, ...props }: { name: string; size?: number }) {
  if (!iconNames.includes(name as any)) {
    return <CircleOff {...props} />; // fallback icon for unknown names
  }
  return <DynamicIcon name={name as keyof typeof iconNames} {...props} />;
}
```

## Custom Icon Creation

Create custom icons that match the Lucide visual system:

```tsx
import { createLucideIcon } from 'lucide-react';
import type { IconNode } from 'lucide-react';

// Define your custom path data
const whatsappIconNode: IconNode = [
  [
    'path',
    {
      d: 'M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347',
      key: '1',
    },
  ],
  [
    'path',
    {
      d: 'M12 2C6.477 2 2 6.477 2 12c0 1.89.525 3.654 1.438 5.168L2.546 20.2a.803.803 0 001.254.254l1.032-1.032A9.96 9.96 0 0012 22c5.523 0 10-4.477 10-10S17.523 2 12 2z',
      key: '2',
    },
  ],
];

const WhatsApp = createLucideIcon('WhatsApp', whatsappIconNode);

// Use like any Lucide icon — inherits all props
<WhatsApp size={24} color="#25D366" />
```

## Integration with shadcn/ui

Lucide is the default icon library for shadcn/ui. shadcn/ui components use Lucide icons internally:

```tsx
// shadcn/ui Button with Lucide icon
import { Button } from '@/components/ui/button';
import { Search, Loader2, ChevronDown } from 'lucide-react';

<Button>
  <Search className="mr-2 h-4 w-4" />
  Search
</Button>

// Loading state
<Button disabled>
  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
  Please wait
</Button>

// Dropdown trigger
<Button variant="outline">
  Options
  <ChevronDown className="ml-2 h-4 w-4" />
</Button>
```

### shadcn/ui Sizing Convention

shadcn/ui typically sizes icons using `h-4 w-4` (16px) via Tailwind, matching button text size:

```tsx
<Search className="mr-2 h-4 w-4" />      // 16px in buttons
<Check className="mr-2 h-5 w-5" />        // 20px in dropdowns
<LucideIcon className="h-8 w-8" />         // 32px in empty states
```

## Batch Icon Imports

When you need many icons, organize them in a barrel file:

```tsx
// lib/icons.ts
import {
  Search,
  Heart,
  User,
  Settings,
  Bell,
  Menu,
  X,
  ChevronLeft,
  ChevronRight,
  Plus,
  Minus,
  Check,
  AlertTriangle,
  Info,
  ExternalLink,
  type LucideIcon,
} from 'lucide-react';

export {
  Search, Heart, User, Settings, Bell,
  Menu, X, ChevronLeft, ChevronRight,
  Plus, Minus, Check, AlertTriangle,
  Info, ExternalLink,
  LucideIcon,
};
```

## Icon as Type

```tsx
import type { LucideIcon } from 'lucide-react';
import { Home, Settings, User } from 'lucide-react';

interface NavItem {
  label: string;
  href: string;
  icon: LucideIcon;  // Type for any Lucide icon component
}

const navItems: NavItem[] = [
  { label: 'Home', href: '/', icon: Home },
  { label: 'Settings', href: '/settings', icon: Settings },
  { label: 'Profile', href: '/profile', icon: User },
];

function Sidebar({ items }: { items: NavItem[] }) {
  return (
    <nav>
      {items.map((item) => (
        <a key={item.href} href={item.href} className="flex items-center gap-3 p-2">
          <item.icon size={20} />
          <span>{item.label}</span>
        </a>
      ))}
    </nav>
  );
}
```

## Context-Aware Defaults

Use `LucideProvider` to set project-wide defaults:

```tsx
import { LucideProvider } from 'lucide-react';

// Application root
function App() {
  return (
    <LucideProvider size={20} strokeWidth={1.5}>
      {/* All icons here default to size=20, strokeWidth=1.5 */}
      <MainLayout />
    </LucideProvider>
  );
}

// Section-level override
function DashboardSection() {
  return (
    <LucideProvider size={32} strokeWidth={2}>
      {/* Larger icons for dashboard feature blocks */}
      <FeatureCards />
    </LucideProvider>
  );
}
```

## Icon Node Pattern (Headless Rendering)

For headless/custom rendering engines, access the raw `IconNode`:

```tsx
import type { IconNode } from 'lucide-react';
import { Icon } from 'lucide-react';

// Render icon node with a custom wrapper
function CustomRenderer({ iconNode, ...props }: { iconNode: IconNode }) {
  return <Icon iconNode={iconNode} {...props} />;
}

// Or build your own SVG renderer using the icon data
function VanillaIcon({ iconNode }: { iconNode: IconNode }) {
  return (
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      {iconNode.map(([tag, attrs], i) => {
        const Tag = tag;
        return <Tag key={i} {...attrs} />;
      })}
    </svg>
  );
}
```

## CSS Class Convention

Each icon renders with CSS classes for targeted styling:

```html
<!-- <Search /> renders: -->
<svg class="lucide lucide-search" ...>...</svg>

<!-- <ChevronDown /> renders: -->
<svg class="lucide lucide-chevron-down" ...>...</svg>
```

Target specific icons or all icons via CSS:

```css
/* All Lucide icons */
.lucide {
  flex-shrink: 0;
}

/* Specific icon */
.lucide-search {
  opacity: 0.7;
}
```

## Bundle-Size Conscious Patterns

### Static imports (best for most apps)
```tsx
import { Search, Heart } from 'lucide-react';
// ~300-500 bytes per icon (gzipped)
```

### Dynamic imports (best for icon pickers, CMS-driven icons)
```tsx
import { DynamicIcon } from 'lucide-react/dynamic';
// ~2KB for the dynamic loader + per-icon lazy chunks
```

### Subset re-export (best for design systems)
```tsx
// @my-app/icons/index.ts
export { Search, Heart, User, Settings } from 'lucide-react';
// Use throughout app — centralizes icon surface
```
