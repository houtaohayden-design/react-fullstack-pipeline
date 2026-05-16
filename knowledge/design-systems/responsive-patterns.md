# Responsive & Adaptive Design — Premium Breakpoint Strategies

Responsive architecture, container queries, fluid scaling, mobile-first patterns, and adaptive components for seamless cross-device experiences.

---

## 1. Breakpoint System

### Modern Fluid Breakpoints (content-based, not device-based)
```css
:root {
  /* Content-driven breakpoints — not tied to specific devices */
  --bp-xs: 480px;   /* Small phones → two-column grid possible */
  --bp-sm: 640px;   /* Large phones → comfortable single-column */
  --bp-md: 768px;   /* Tablets → sidebars possible */
  --bp-lg: 1024px;  /* Small laptops → full layouts */
  --bp-xl: 1280px;  /* Desktops → spacious layouts */
  --bp-2xl: 1536px; /* Large screens → extra whitespace */
  --bp-3xl: 1920px; /* Ultra-wide → max-width containers */
}
```

### Tailwind v4-Style Custom Media Queries
```css
@custom-media --sm  (width >= 640px);
@custom-media --md  (width >= 768px);
@custom-media --lg  (width >= 1024px);
@custom-media --xl  (width >= 1280px);
@custom-media --2xl (width >= 1536px);

/* Usage */
.card-grid {
  display: grid;
  grid-template-columns: 1fr;

  @media (--sm) { grid-template-columns: repeat(2, 1fr); }
  @media (--lg) { grid-template-columns: repeat(3, 1fr); }
  @media (--xl) { grid-template-columns: repeat(4, 1fr); }
}
```

### Breakpoint Decision Tree
```
When to add a breakpoint:
  Content breaks (text wraps badly, images overflow) → YES
  Design looks "cramped" → YES
  A specific device width (iPad, iPhone) → NO (use content triggers)
  "Just in case" → NO

How to choose the value:
  Resize browser slowly until layout breaks → note width → that's your breakpoint
  Add 20-40px buffer for scrollbar
```

---

## 2. Container Queries (Modern, Recommended)

Container queries respond to parent size, not viewport — perfect for reusable components.

```css
/* Define a containment context */
.card-container {
  container-type: inline-size;
  container-name: card;
}

/* Style based on container width, not viewport */
@container card (min-width: 400px) {
  .card {
    display: grid;
    grid-template-columns: 200px 1fr;
    gap: 16px;
  }
  .card-image { border-radius: 12px 0 0 12px; }
}

@container card (min-width: 600px) {
  .card {
    grid-template-columns: 300px 1fr;
    gap: 24px;
  }
  .card-title { font-size: 1.25rem; }
}
```

### Container Query Component Pattern
```tsx
function AdaptiveCard({ image, title, description, children }: CardProps) {
  return (
    <div className="card-container @container/card">
      <div className="
        p-4 rounded-xl border bg-surface
        flex flex-col
        @[400px]/card:grid @[400px]/card:grid-cols-[200px_1fr] @[400px]/card:gap-4
        @[600px]/card:grid-cols-[300px_1fr] @[600px]/card:gap-6
        @[600px]/card:p-6
      ">
        <div className="
          aspect-video @[400px]/card:aspect-auto @[400px]/card:h-full
          rounded-lg @[400px]/card:rounded-xl
          overflow-hidden shrink-0
        ">
          <img src={image} className="w-full h-full object-cover" />
        </div>
        <div className="flex flex-col justify-center pt-3 @[400px]/card:pt-0">
          <h3 className="text-base @[600px]/card:text-lg font-semibold">{title}</h3>
          <p className="text-sm text-muted mt-1 @[600px]/card:text-base">{description}</p>
          {children}
        </div>
      </div>
    </div>
  );
}
```

---

## 3. Fluid Typography (Viewport-Relative)

### Clamp-Based Fluid Scale (no breakpoints needed)
```css
:root {
  /* f(min, preferred, max) = clamp(min, vw + rem, max) */

  --text-xs:   clamp(0.75rem,  0.7rem  + 0.25vw, 0.875rem);
  --text-sm:   clamp(0.875rem, 0.8rem  + 0.25vw, 1rem);
  --text-base: clamp(1rem,     0.875rem + 0.5vw,  1.125rem);
  --text-lg:   clamp(1.125rem, 0.95rem  + 0.75vw, 1.375rem);
  --text-xl:   clamp(1.25rem,  1rem    + 1vw,    1.75rem);
  --text-2xl:  clamp(1.5rem,   1.1rem  + 1.5vw,  2.25rem);
  --text-3xl:  clamp(2rem,     1.25rem + 2.5vw,  3.25rem);
  --text-4xl:  clamp(2.5rem,   1.5rem  + 3.5vw,  4.5rem);
  --text-5xl:  clamp(3rem,     1.75rem + 5vw,    6rem);

  /* Hero title (extreme range) */
  --text-hero: clamp(3rem, 2rem + 5vw, 7rem);
}
```

### Fluid Line Height
```css
:root {
  --leading-tight:   clamp(1.1,  0.95 + 0.25vw, 1.25);
  --leading-normal:  clamp(1.4,  1.3  + 0.25vw, 1.6);
  --leading-relaxed: clamp(1.5,  1.4  + 0.5vw,  1.8);
}
```

### The Math Behind Clamp
```
clamp(MIN, PREFERRED, MAX)

PREFERRED = <base-size> + <scale-factor> * (100vw - <min-vw>) / (<max-vw> - <min-vw>)

Example: 1rem at 480px → 1.5rem at 1280px
  base = 1rem (16px)
  scale = 0.5rem (8px growth)
  min-vw = 480px, max-vw = 1280px

  PREFERRED = 1rem + 0.5rem * (100vw - 480px) / (1280px - 480px)
            = 1rem + 0.5rem * (100vw - 480px) / 800px
            ≈ 0.7rem + 0.625vw
```

---

## 4. Fluid Spacing

```css
:root {
  /* Fluid spacing scale */
  --space-xs:  clamp(0.25rem, 0.2rem  + 0.25vw, 0.5rem);
  --space-sm:  clamp(0.5rem,  0.4rem  + 0.5vw,  0.75rem);
  --space-md:  clamp(1rem,    0.75rem + 0.75vw, 1.5rem);
  --space-lg:  clamp(1.5rem,  1rem    + 1.5vw,  2.5rem);
  --space-xl:  clamp(2rem,    1.25rem + 2vw,    3.5rem);
  --space-2xl: clamp(3rem,    2rem    + 3vw,    5rem);
  --space-3xl: clamp(4rem,    2.5rem  + 5vw,    8rem);

  /* Fluid page padding */
  --page-gutter: clamp(1rem, 0.5rem + 3vw, 3rem);

  /* Fluid section gap */
  --section-gap: clamp(3rem, 2rem + 5vw, 8rem);
}
```

---

## 5. Mobile-First Component Patterns

### Navigation: Bottom Tab Bar (mobile) → Sidebar (desktop)
```tsx
function AdaptiveNav() {
  return (
    <>
      {/* Mobile: Bottom fixed bar */}
      <nav className="
        fixed bottom-0 left-0 right-0 z-50
        bg-surface/95 backdrop-blur-xl border-t
        flex items-center justify-around
        h-16 px-2 pb-[env(safe-area-inset-bottom)]
        lg:hidden
      ">
        {navItems.map(item => (
          <NavItem key={item.label} {...item} collapsed />
        ))}
      </nav>

      {/* Desktop: Full sidebar */}
      <nav className="
        hidden lg:flex
        flex-col
        fixed left-0 top-0 bottom-0
        w-64
        bg-surface border-r
        p-6
      ">
        <Logo className="mb-8" />
        {navItems.map(item => (
          <NavItem key={item.label} {...item} />
        ))}
      </nav>

      {/* Content padding compensation */}
      <div className="pb-20 lg:pl-64">
        <Outlet />
      </div>
    </>
  );
}
```

### Grid: Single Column → Multi-Column with Auto-Fit
```css
/* Auto-fit grid — no breakpoints needed */
.grid-responsive {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 300px), 1fr));
  gap: var(--space-md);
}

/* Card grid that works from mobile to ultra-wide */
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: var(--space-md);
}
```

### Content: Stack → Side-by-Side
```css
/* Two-column that stacks on mobile */
.two-col {
  display: grid;
  grid-template-columns: 1fr;
  gap: var(--space-lg);

  @media (--lg) {
    grid-template-columns: 1fr 1fr;
    align-items: center;
  }
}

/* Media + Content (classic landing page pattern) */
.media-content {
  display: flex;
  flex-direction: column;
  gap: var(--space-lg);

  @media (--lg) {
    flex-direction: row;
    align-items: center;
    gap: var(--space-xl);
  }
}
.media-content > * { flex: 1; }

/* Reverse order on alternate rows */
.media-content:nth-child(even) {
  @media (--lg) {
    flex-direction: row-reverse;
  }
}
```

---

## 6. Adaptive Typography Patterns

### Responsive Heading
```tsx
function SectionHeading({ overline, title, subtitle }: {
  overline?: string;
  title: string;
  subtitle?: string;
}) {
  return (
    <div className="
      text-center max-w-3xl mx-auto
      px-[--page-gutter]
    ">
      {overline && (
        <p className="text-xs font-semibold tracking-[0.2em] uppercase text-primary mb-3">
          {overline}
        </p>
      )}
      <h2 className="
        text-[clamp(1.5rem,1rem+3vw,3rem)]
        font-bold leading-[1.1]
        tracking-tight
      ">
        {title}
      </h2>
      {subtitle && (
        <p className="
          mt-4
          text-[clamp(0.875rem,0.75rem+0.5vw,1.125rem)]
          text-muted
          max-w-2xl mx-auto
        ">
          {subtitle}
        </p>
      )}
    </div>
  );
}
```

---

## 7. Image & Media Responsive Patterns

### Art Direction (different images per breakpoint)
```html
<picture>
  <source media="(min-width: 1280px)" srcset="/hero-xl.webp" />
  <source media="(min-width: 768px)"  srcset="/hero-md.webp" />
  <source media="(min-width: 480px)"  srcset="/hero-sm.webp" />
  <img src="/hero-xs.webp" alt="Hero" class="w-full h-auto object-cover" loading="eager" />
</picture>
```

### Responsive Aspect Ratio
```css
.aspect-16-9  { aspect-ratio: 16 / 9; }
.aspect-4-3   { aspect-ratio: 4 / 3; }
.aspect-1-1   { aspect-ratio: 1 / 1; }
.aspect-3-4   { aspect-ratio: 3 / 4; }
.aspect-hero  { aspect-ratio: 16 / 9; }

@media (--md)  { .aspect-hero { aspect-ratio: 21 / 9; } }
@media (--lg)  { .aspect-hero { aspect-ratio: 2 / 1; } }
```

### Responsive Video Embed
```css
.video-embed {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 9;
}
.video-embed iframe {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  border: 0;
}
```

---

## 8. Touch vs Mouse Adaptive

```tsx
function useInputMethod(): 'touch' | 'mouse' | 'keyboard' {
  const [method, setMethod] = useState<'touch' | 'mouse' | 'keyboard'>('mouse');

  useEffect(() => {
    const handleTouch = () => setMethod('touch');
    const handleMouse = () => setMethod('mouse');
    const handleKey = (e: KeyboardEvent) => {
      if (e.key === 'Tab') setMethod('keyboard');
    };

    window.addEventListener('touchstart', handleTouch, { once: true });
    window.addEventListener('mousemove', handleMouse, { once: true });
    window.addEventListener('keydown', handleKey);

    return () => {
      window.removeEventListener('keydown', handleKey);
    };
  }, []);

  return method;
}

/* CSS — hide hover affordances on touch */
@media (hover: none) {
  .hover-card:hover { transform: none; box-shadow: var(--shadow-sm); }
  .hover-link:hover { text-decoration: none; }
}

/* CSS — show focus ring only on keyboard nav */
*:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}
*:focus:not(:focus-visible) {
  outline: none;
}
```

---

## 9. Device-Specific CSS

### Safe Area (notched phones)
```css
.page {
  padding-left:  env(safe-area-inset-left);
  padding-right: env(safe-area-inset-right);
}
.bottom-nav {
  padding-bottom: env(safe-area-inset-bottom);
}
.top-banner {
  padding-top: env(safe-area-inset-top);
}
```

### Foldable / Dual Screen
```css
@media (spanning: single-fold-vertical) {
  .app { grid-template-columns: env(fold-left) 1fr; }
}
```

### Print Styles
```css
@media print {
  .no-print { display: none !important; }
  .page { max-width: 100%; padding: 0; }
  body { font-size: 12pt; line-height: 1.5; color: #000; background: #fff; }
  a[href]::after { content: ' (' attr(href) ')'; font-size: 0.8em; }
  nav, footer, .ads { display: none; }
}
```

---

## 10. Performance Patterns

### Conditional Loading (mobile vs desktop)
```tsx
function ConditionalComponent() {
  const isDesktop = useMediaQuery('(min-width: 1024px)');

  return (
    <>
      {/* Always render critical content */}
      <CriticalContent />

      {/* Only render heavy components on desktop */}
      {isDesktop && (
        <Suspense fallback={null}>
          <HeavyThreeJSBackground />
        </Suspense>
      )}
    </>
  );
}
```

### Responsive Image Loading
```tsx
<img
  src="/hero-sm.webp"
  srcSet="/hero-sm.webp 480w, /hero-md.webp 768w, /hero-lg.webp 1280w, /hero-xl.webp 1920w"
  sizes="(max-width: 768px) 100vw, (max-width: 1280px) 80vw, 1200px"
  loading="lazy"
  decoding="async"
  alt="Hero image"
  className="w-full h-auto"
/>
```

---

## 11. Quick Reference — Responsive Patterns

| Pattern | Mobile (< 768px) | Tablet (768-1024px) | Desktop (1024px+) |
|---------|------------------|--------------------|--------------------|
| Navigation | Bottom tab bar | Collapsed sidebar with icons | Full sidebar |
| Grid cards | 1 column | 2 columns | 3-4 columns |
| Hero layout | Stacked | Split 1:1 | Split 3:2 |
| Typography | 16px base | 16px base | 18px base |
| Touch targets | ≥ 44px | ≥ 44px | ≥ 36px |
| Search | Full-screen overlay | Dropdown | Inline + dropdown |
| Modal | Full-screen sheet | Centered 90vw | Centered 500px |
| Data table | Card list view | Horizontal scroll | Full table |
| Sidebar | Off-screen (hamburger) | Overlay | Persistent |
| Images | 1x resolution | 1.5x | 2x (retina) |
