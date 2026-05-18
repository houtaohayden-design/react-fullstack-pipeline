# Lucide React — Interaction & Animation Patterns

> Source: [lucide-icons/lucide](https://github.com/lucide-icons/lucide) | 1,711 icons | SVG-based, compositor-friendly

## Design Principle

Lucide icons are pure SVG elements with no built-in animation. All interaction and animation patterns are implemented via CSS (Tailwind) or CSS-in-JS, keeping icons lightweight and letting you control motion precisely.

## Hover Color Transitions

The most common interaction pattern — smoothly transition icon color on hover:

```tsx
import { Heart, Star, Bookmark } from 'lucide-react';

// Tailwind transition
<Heart className="text-gray-400 hover:text-red-500 transition-colors duration-200" />

// Inline style approach
<Star
  className="transition-colors duration-200"
  style={{ color: isHovered ? '#f59e0b' : '#9ca3af' }}
/>

// shadcn/ui pattern — group hover
<div className="group flex items-center gap-2 p-3 rounded-lg hover:bg-gray-100 cursor-pointer">
  <Bookmark className="text-gray-400 group-hover:text-blue-600 transition-colors" />
  <span className="group-hover:text-blue-600 transition-colors">Save</span>
</div>
```

## Rotate on Click (Chevron / Accordion Pattern)

Toggle rotation for expandable elements:

```tsx
import { ChevronDown, ChevronRight } from 'lucide-react';
import { useState } from 'react';

function AccordionItem({ title, children }: { title: string; children: React.ReactNode }) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 w-full p-3 text-left"
      >
        <ChevronDown
          size={18}
          className={`transition-transform duration-200 ${
            isOpen ? 'rotate-180' : 'rotate-0'
          }`}
        />
        <span>{title}</span>
      </button>
      {isOpen && <div className="pl-8">{children}</div>}
    </div>
  );
}
```

### Alternative: Sidebar expand/collapse with ChevronRight

```tsx
<ChevronRight
  className={`transition-transform duration-200 ${
    isExpanded ? 'rotate-90' : 'rotate-0'
  }`}
/>
```

## Spin Animation (Loader / Spinner)

Spinning indicators for loading states:

```tsx
import { Loader2, LoaderCircle, RefreshCw, RotateCw } from 'lucide-react';

// Standard spinner — CSS animate-spin
<Loader2 className="animate-spin" />

// Alternative spinner variants
<LoaderCircle className="animate-spin" />
<RefreshCw className="animate-spin" />

// Button loading state
<button disabled className="flex items-center gap-2 px-4 py-2 rounded bg-blue-600 text-white disabled:opacity-50">
  <Loader2 className="animate-spin" size={16} />
  Loading...
</button>

// Inline loading (text-sized)
<span className="flex items-center gap-1 text-gray-500">
  <Loader2 size={14} className="animate-spin" />
  Saving...
</span>

// Custom spin speed
<Loader2 className="animate-spin" style={{ animationDuration: '800ms' }} />
```

### Available spinner-compatible icons

| Icon | Best For | Class |
|------|----------|-------|
| `Loader2` | Primary loading indicator | `animate-spin` |
| `LoaderCircle` | Full-page loading | `animate-spin` |
| `RefreshCw` | Refresh/reload action | `animate-spin` |
| `RotateCw` | Rotation action indicator | `animate-spin` |

## Pulse Animation

Pulsing effect for attention / notification indicators:

```tsx
import { Bell, Circle, Signal } from 'lucide-react';

// Notification bell with pulse
<div className="relative">
  <Bell className="animate-pulse text-orange-500" />
  <Circle className="absolute -top-1 -right-1 fill-red-500 text-red-500" size={8} />
</div>

// Live/recording indicator
<div className="flex items-center gap-2">
  <Circle className="animate-pulse fill-red-500 text-red-500" size={10} />
  <span className="text-sm text-red-600 font-medium">LIVE</span>
</div>

// Signal strength pulse
<Signal className="animate-pulse text-green-500" size={20} />
```

## Interactive Icon Toggle (Active/Inactive)

State-based icon swaps for toggles:

```tsx
import { Heart, Bookmark, Bell, BellOff, Star } from 'lucide-react';
import { useState } from 'react';

function FavoriteButton() {
  const [isFavorited, setIsFavorited] = useState(false);

  return (
    <button
      onClick={() => setIsFavorited(!isFavorited)}
      className={`p-2 rounded-full transition-all duration-200 ${
        isFavorited ? 'text-red-500 hover:text-red-600' : 'text-gray-400 hover:text-gray-600'
      }`}
      aria-label={isFavorited ? 'Remove from favorites' : 'Add to favorites'}
    >
      <Heart
        className={`transition-all duration-200 ${
          isFavorited ? 'fill-current scale-110' : 'scale-100'
        }`}
      />
    </button>
  );
}

function BookmarkToggle() {
  const [saved, setSaved] = useState(false);
  return (
    <button onClick={() => setSaved(!saved)} aria-label="Bookmark">
      <Bookmark
        className={`transition-all duration-200 ${
          saved ? 'fill-blue-500 text-blue-500' : 'text-gray-400'
        }`}
      />
    </button>
  );
}

function NotificationToggle() {
  const [enabled, setEnabled] = useState(true);
  return (
    <button onClick={() => setEnabled(!enabled)} className="p-2 rounded-lg hover:bg-gray-100">
      {enabled ? (
        <Bell className="text-blue-600" />
      ) : (
        <BellOff className="text-gray-400" />
      )}
    </button>
  );
}
```

## Animated Icon Swap (Play -> Pause, Copy -> Check)

Swap between two icons with a smooth transition:

```tsx
import { Play, Pause, Copy, Check, Eye, EyeOff, Volume2, VolumeX } from 'lucide-react';
import { useState } from 'react';

// Play / Pause
function PlayButton() {
  const [isPlaying, setIsPlaying] = useState(false);

  return (
    <button
      onClick={() => setIsPlaying(!isPlaying)}
      className="p-3 rounded-full bg-blue-600 text-white hover:bg-blue-700 transition-colors"
      aria-label={isPlaying ? 'Pause' : 'Play'}
    >
      {isPlaying ? <Pause /> : <Play />}
    </button>
  );
}

// Copy to clipboard
function CopyButton({ text }: { text: string }) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    await navigator.clipboard.writeText(text);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <button
      onClick={handleCopy}
      className={`p-2 rounded transition-colors ${
        copied ? 'text-green-500 bg-green-50' : 'text-gray-500 hover:bg-gray-100'
      }`}
      aria-label={copied ? 'Copied' : 'Copy to clipboard'}
    >
      {copied ? (
        <Check size={16} className="animate-in zoom-in" />
      ) : (
        <Copy size={16} />
      )}
    </button>
  );
}

// Show/Hide password
function PasswordToggle() {
  const [visible, setVisible] = useState(false);
  return (
    <button onClick={() => setVisible(!visible)} className="text-gray-400 hover:text-gray-600">
      {visible ? <EyeOff size={20} /> : <Eye size={20} />}
    </button>
  );
}

// Mute toggle
function MuteButton() {
  const [muted, setMuted] = useState(false);
  return (
    <button onClick={() => setMuted(!muted)} className="p-2">
      {muted ? <VolumeX size={20} /> : <Volume2 size={20} />}
    </button>
  );
}
```

## Theme Toggle (Sun / Moon)

Dark mode toggle with rotation animation:

```tsx
import { Sun, Moon } from 'lucide-react';
import { useTheme } from 'next-themes';

function ThemeToggle() {
  const { theme, setTheme } = useTheme();

  return (
    <button
      onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
      className="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
      aria-label="Toggle theme"
    >
      <Sun className="h-5 w-5 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      <Moon className="absolute h-5 w-5 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
    </button>
  );
}
```

## Scale Feedback on Click

Micro-interaction with scale on press:

```tsx
import { ThumbsUp, Heart, Star } from 'lucide-react';

// CSS-based scale on active
<button className="active:scale-90 transition-transform duration-100">
  <ThumbsUp size={24} />
</button>

// Programmatic scale feedback
function LikeButton() {
  const [liked, setLiked] = useState(false);
  const [animate, setAnimate] = useState(false);

  const handleClick = () => {
    setLiked(!liked);
    setAnimate(true);
    setTimeout(() => setAnimate(false), 300);
  };

  return (
    <button onClick={handleClick}>
      <Heart
        className={`transition-all duration-200 ${
          liked ? 'fill-red-500 text-red-500' : 'text-gray-400'
        } ${animate ? 'scale-125' : 'scale-100'}`}
      />
    </button>
  );
}
```

## Animated Stroke (Drawing Effect)

CSS stroke-dasharray animation for a draw-in effect:

```tsx
// CSS
// .draw-animation { stroke-dasharray: 100; stroke-dashoffset: 100; animation: draw 1.5s ease forwards; }
// @keyframes draw { to { stroke-dashoffset: 0; } }

<CheckCircle className="draw-animation text-green-500" size={48} />
```

## Star Rating Component

Iterative icons for rating:

```tsx
import { Star } from 'lucide-react';

function StarRating({ rating, onChange }: { rating: number; onChange?: (r: number) => void }) {
  return (
    <div className="flex gap-1">
      {[1, 2, 3, 4, 5].map((star) => (
        <button
          key={star}
          onClick={() => onChange?.(star)}
          className={`transition-transform duration-150 hover:scale-110 ${
            star <= rating ? 'text-yellow-400' : 'text-gray-300'
          }`}
        >
          <Star className={star <= rating ? 'fill-current' : ''} />
        </button>
      ))}
    </div>
  );
}
```

## Motion Library Integration

### framer-motion

```tsx
import { motion } from 'framer-motion';
import { Check, Heart, RotateCw } from 'lucide-react';

// Create motion-enhanced icon components
const MotionCheck = motion.create(Check);
const MotionHeart = motion.create(Heart);

// Animate with Framer Motion
<MotionCheck
  initial={{ scale: 0, rotate: -180 }}
  animate={{ scale: 1, rotate: 0 }}
  transition={{ type: 'spring', stiffness: 260, damping: 20 }}
/>

// Heart burst animation
<MotionHeart
  className="fill-red-500 text-red-500"
  initial={{ scale: 0 }}
  animate={{ scale: [0, 1.3, 1] }}
  transition={{ duration: 0.5 }}
/>

// Continuous spin
<RotateCw as={motion.svg} animate={{ rotate: 360 }} transition={{ repeat: Infinity, duration: 2, ease: 'linear' }} />
```

## Complete CSS Animation Recipes

```css
/* Spin animation (built into Tailwind as animate-spin) */
@keyframes spin {
  to { transform: rotate(360deg); }
}
.icon-spin {
  animation: spin 1s linear infinite;
}

/* Pulse animation (built into Tailwind as animate-pulse) */
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
.icon-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

/* Bounce animation for attention */
@keyframes bounce-attention {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-4px); }
}
.icon-bounce {
  animation: bounce-attention 0.6s ease-in-out 1;
}

/* Ping (notification indicator) */
@keyframes ping {
  75%, 100% { transform: scale(2); opacity: 0; }
}
.icon-ping {
  animation: ping 1s cubic-bezier(0, 0, 0.2, 1) infinite;
}
```

## Performance Notes

- Lucide icons animate `transform` and `opacity` — compositor-only properties that don't trigger layout
- Avoid animating `width`, `height`, `top`, `left` on icons (causes layout recalc)
- Use `animate-spin` (CSS `transform: rotate()`) — it is GPU-composited
- For complex choreographies, use `framer-motion` or `GSAP` with `motion.create()` for zero-cost animation components
- All interactive patterns work with reduced motion: wrap in `prefers-reduced-motion` media query for accessible alternatives
