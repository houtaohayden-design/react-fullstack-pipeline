# UI Patterns — Premium Interaction Design

Catalog of premium UI patterns. Framework-agnostic CSS + React patterns. Mix and match with any design system (A/B/C) and artistic style.

---

## 1. Card Design Patterns

### Pattern A: Lift on Hover
```css
.card-lift {
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1),
              box-shadow 0.3s ease;
}
.card-lift:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
}
```

### Pattern B: Reveal Content on Hover
```tsx
function RevealCard({ title, description, image }: CardProps) {
  return (
    <div className="group relative overflow-hidden rounded-2xl">
      <img src={image} alt={title} className="w-full aspect-[4/3] object-cover" />
      <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent
        translate-y-[60%] group-hover:translate-y-0 transition-transform duration-500">
        <div className="absolute bottom-0 p-6 text-white">
          <h3 className="text-xl font-bold">{title}</h3>
          <p className="mt-2 text-sm text-white/70 opacity-0 group-hover:opacity-100
            transition-opacity duration-300 delay-100">
            {description}
          </p>
        </div>
      </div>
    </div>
  );
}
```

### Pattern C: Stacked Deck
```css
.card-stack {
  position: relative;
}
.card-stack::before,
.card-stack::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  background: inherit;
  transition: transform 0.3s ease;
}
.card-stack::before {
  transform: rotate(-3deg) translateY(4px);
  opacity: 0.5;
  z-index: -1;
}
.card-stack::after {
  transform: rotate(2deg) translateY(8px);
  opacity: 0.25;
  z-index: -2;
}
.card-stack:hover::before {
  transform: rotate(-1deg) translateY(2px);
}
.card-stack:hover::after {
  transform: rotate(0deg) translateY(4px);
}
```

### Pattern D: Glass Overlay Card
```css
.glass-overlay-card {
  position: relative;
  overflow: hidden;
}
.glass-overlay-card::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(
    135deg,
    rgba(255,255,255,0.2) 0%,
    rgba(255,255,255,0.05) 50%,
    rgba(255,255,255,0) 100%
  );
  opacity: 0;
  transition: opacity 0.3s;
}
.glass-overlay-card:hover::after {
  opacity: 1;
}
```

### Pattern E: Border Glow
```css
.card-border-glow {
  position: relative;
  border-radius: 16px;
  background: #fff;
}
.card-border-glow::before {
  content: '';
  position: absolute;
  inset: -2px;
  border-radius: 18px;
  background: linear-gradient(135deg, #667eea, #764ba2, #f093fb);
  z-index: -1;
  opacity: 0;
  transition: opacity 0.4s;
}
.card-border-glow:hover::before {
  opacity: 1;
}
```

### Pattern F: Parallax Depth
```tsx
function ParallaxCard({ image, title, description }: CardProps) {
  const cardRef = useRef<HTMLDivElement>(null);
  const { x, y } = useMousePosition(cardRef);

  return (
    <div ref={cardRef} className="relative overflow-hidden rounded-2xl perspective-1000">
      <motion.div
        className="w-full"
        style={{
          rotateX: useTransform(y, [-0.5, 0.5], [8, -8]),
          rotateY: useTransform(x, [-0.5, 0.5], [-8, 8]),
        }}
        transition={{ type: 'spring', stiffness: 300 }}
      >
        <img src={image} alt={title} className="w-full aspect-[4/3] object-cover scale-110" />
      </motion.div>
      <div className="p-6">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

// Hook for mouse position relative to element
function useMousePosition(ref: RefObject<HTMLElement>) {
  const [pos, setPos] = useState({ x: 0, y: 0 });
  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const handler = (e: MouseEvent) => {
      const rect = el.getBoundingClientRect();
      setPos({
        x: (e.clientX - rect.left) / rect.width - 0.5,
        y: (e.clientY - rect.top) / rect.height - 0.5,
      });
    };
    el.addEventListener('mousemove', handler);
    el.addEventListener('mouseleave', () => setPos({ x: 0, y: 0 }));
    return () => el.removeEventListener('mousemove', handler);
  }, [ref]);
  return pos;
}
```

---

## 2. Navigation Patterns

### Pattern A: Sticky Shrink Header
```tsx
function ShrinkHeader() {
  const { scrollY } = useScroll();
  const height = useTransform(scrollY, [0, 100], [80, 56]);
  const shadow = useTransform(scrollY, [0, 100], [0, 1]);

  return (
    <motion.header
      style={{ height, boxShadow: shadow.to(v => `0 ${v * 8}px ${v * 24}px rgba(0,0,0,${v * 0.08})`) }}
      className="sticky top-0 z-50 bg-white/80 backdrop-blur-xl flex items-center px-8"
    >
      {/* nav content */}
    </motion.header>
  );
}
```

### Pattern B: Morphing Bottom Tab Bar
```tsx
function MorphingTabBar({ tabs }: { tabs: Tab[] }) {
  const [active, setActive] = useState(0);

  return (
    <nav className="fixed bottom-6 left-1/2 -translate-x-1/2 bg-white/90 backdrop-blur-xl
      rounded-2xl shadow-lg border border-white/20 px-2 py-2 flex gap-1">
      {tabs.map((tab, i) => (
        <button
          key={i}
          onClick={() => setActive(i)}
          className="relative px-4 py-2 rounded-xl text-sm font-medium transition-colors duration-200"
          style={{ color: active === i ? tab.color : '#999' }}
        >
          {active === i && (
            <motion.div
              layoutId="tabBg"
              className="absolute inset-0 rounded-xl"
              style={{ background: tab.color + '20' }}
              transition={{ type: 'spring', stiffness: 500, damping: 30 }}
            />
          )}
          <span className="relative z-10 flex items-center gap-2">
            {tab.icon} {tab.label}
          </span>
        </button>
      ))}
    </nav>
  );
}
```

### Pattern C: Breadcrumb Trail
```tsx
function Breadcrumbs({ path }: { path: { label: string; href?: string }[] }) {
  return (
    <nav className="flex items-center gap-2 text-sm">
      {path.map((crumb, i) => (
        <Fragment key={i}>
          {i > 0 && (
            <ChevronRight className="w-4 h-4 text-muted-foreground/40" />
          )}
          {crumb.href ? (
            <a href={crumb.href} className="text-muted-foreground hover:text-foreground transition-colors">
              {crumb.label}
            </a>
          ) : (
            <span className="font-medium text-foreground">{crumb.label}</span>
          )}
        </Fragment>
      ))}
    </nav>
  );
}
```

### Pattern D: Slide-Out Drawer Nav (mobile)
```tsx
function MobileDrawerNav() {
  const [open, setOpen] = useState(false);

  return (
    <>
      <button onClick={() => setOpen(true)} className="p-2">
        <MenuIcon className="w-6 h-6" />
      </button>

      <AnimatePresence>
        {open && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="fixed inset-0 bg-black/40 z-40"
              onClick={() => setOpen(false)}
            />
            <motion.nav
              initial={{ x: '100%' }}
              animate={{ x: 0 }}
              exit={{ x: '100%' }}
              transition={{ type: 'spring', damping: 30, stiffness: 300 }}
              className="fixed right-0 top-0 bottom-0 w-80 bg-background z-50 p-6 shadow-2xl"
            >
              {/* nav links */}
            </motion.nav>
          </>
        )}
      </AnimatePresence>
    </>
  );
}
```

### Pattern E: Mega Menu Dropdown
```tsx
function MegaMenu() {
  const [open, setOpen] = useState<string | null>(null);

  return (
    <nav className="relative" onMouseLeave={() => setOpen(null)}>
      <ul className="flex gap-0">
        {categories.map(cat => (
          <li key={cat.id} onMouseEnter={() => setOpen(cat.id)}>
            <button className="px-4 py-2 text-sm font-medium">{cat.label}</button>
          </li>
        ))}
      </ul>

      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ opacity: 0, y: -8 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -8 }}
            transition={{ duration: 0.2 }}
            className="absolute top-full left-0 right-0 bg-background border rounded-xl shadow-xl p-8"
          >
            <div className="grid grid-cols-4 gap-8">
              {/* mega menu content */}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </nav>
  );
}
```

---

## 3. Loading States

### Pattern A: Skeleton Screen
```tsx
function SkeletonCard() {
  return (
    <div className="rounded-2xl overflow-hidden animate-pulse">
      <div className="aspect-[4/3] bg-muted" />
      <div className="p-4 space-y-3">
        <div className="h-4 bg-muted rounded w-3/4" />
        <div className="h-3 bg-muted rounded w-1/2" />
        <div className="flex gap-2">
          <div className="h-6 bg-muted rounded-full w-16" />
          <div className="h-6 bg-muted rounded-full w-16" />
        </div>
      </div>
    </div>
  );
}

function SkeletonGrid({ count = 6 }: { count?: number }) {
  return (
    <div className="grid grid-cols-3 gap-6">
      {Array.from({ length: count }).map((_, i) => (
        <SkeletonCard key={i} />
      ))}
    </div>
  );
}
```

### Pattern B: Shimmer Effect
```css
.shimmer {
  background: linear-gradient(
    90deg,
    #f0f0f0 0%,
    #f8f8f8 40%,
    #f0f0f0 80%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s ease-in-out infinite;
}

@keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}
```

### Pattern C: Progressive Loading
```tsx
function ProgressiveImage({ src, alt, className }: {
  src: string; alt: string; className?: string;
}) {
  const [loaded, setLoaded] = useState(false);

  return (
    <div className={cn('relative overflow-hidden', className)}>
      {/* Blurred placeholder */}
      <img
        src={`${src}?w=20`}
        alt=""
        className={cn(
          'absolute inset-0 w-full h-full object-cover scale-110 blur-2xl transition-opacity duration-500',
          loaded ? 'opacity-0' : 'opacity-100'
        )}
      />
      {/* Full image */}
      <img
        src={src}
        alt={alt}
        onLoad={() => setLoaded(true)}
        className={cn(
          'w-full h-full object-cover transition-opacity duration-500',
          loaded ? 'opacity-100' : 'opacity-0'
        )}
      />
    </div>
  );
}
```

### Pattern D: Animated Progress Bar
```tsx
function AnimatedProgress({ value, max, label }: {
  value: number; max: number; label: string;
}) {
  const percentage = (value / max) * 100;

  return (
    <div className="space-y-2">
      <div className="flex justify-between text-sm">
        <span>{label}</span>
        <span className="font-mono tabular-nums">{Math.round(percentage)}%</span>
      </div>
      <div className="h-2 bg-muted rounded-full overflow-hidden">
        <motion.div
          className="h-full rounded-full bg-primary"
          initial={{ width: 0 }}
          animate={{ width: `${percentage}%` }}
          transition={{ duration: 1, ease: [0.34, 1.56, 0.64, 1] }}
        />
      </div>
    </div>
  );
}
```

### Pattern E: Spinner Variants
```css
/* Pulse dots */
.spinner-dots {
  display: flex;
  gap: 6px;
  justify-content: center;
}
.spinner-dots span {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: currentColor;
  animation: dotBounce 1.4s ease-in-out infinite both;
}
.spinner-dots span:nth-child(1) { animation-delay: -0.32s; }
.spinner-dots span:nth-child(2) { animation-delay: -0.16s; }

@keyframes dotBounce {
  0%, 80%, 100% { transform: scale(0); }
  40% { transform: scale(1); }
}

/* Morphing spinner */
.spinner-morph {
  width: 24px;
  height: 24px;
  border: 2px solid currentColor;
  animation: morphSpin 1s ease-in-out infinite;
  opacity: 0.3;
}

@keyframes morphSpin {
  0% { border-radius: 50%; transform: rotate(0deg); }
  50% { border-radius: 0%; transform: rotate(180deg); }
  100% { border-radius: 50%; transform: rotate(360deg); }
}
```

---

## 4. Empty States

```tsx
function EmptyState({
  icon,
  title,
  description,
  action,
}: {
  icon: React.ReactNode;
  title: string;
  description: string;
  action?: { label: string; onClick: () => void };
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      className="flex flex-col items-center justify-center py-20 px-6 text-center"
    >
      <motion.div
        animate={{ y: [0, -6, 0] }}
        transition={{ duration: 3, repeat: Infinity, ease: 'easeInOut' }}
        className="text-6xl mb-6 opacity-40"
      >
        {icon}
      </motion.div>
      <h3 className="text-xl font-semibold mb-2">{title}</h3>
      <p className="text-muted-foreground max-w-sm mb-8">{description}</p>
      {action && (
        <button
          onClick={action.onClick}
          className="px-6 py-3 bg-primary text-primary-foreground rounded-xl font-medium
            hover:scale-105 active:scale-95 transition-transform"
        >
          {action.label}
        </button>
      )}
    </motion.div>
  );
}
```

---

## 5. Error States

```tsx
function ErrorState({
  error,
  retry,
}: {
  error: Error;
  retry?: () => void;
}) {
  return (
    <div className="flex flex-col items-center justify-center py-20 px-6 text-center">
      <div className="w-16 h-16 rounded-2xl bg-destructive/10 flex items-center justify-center mb-6">
        <AlertTriangle className="w-8 h-8 text-destructive" />
      </div>
      <h3 className="text-lg font-semibold mb-2">Something went wrong</h3>
      <p className="text-muted-foreground max-w-sm mb-2">{error.message}</p>
      {retry && (
        <button
          onClick={retry}
          className="mt-6 px-6 py-2 rounded-xl border font-medium
            hover:bg-muted transition-colors active:scale-95"
        >
          Try Again
        </button>
      )}
    </div>
  );
}
```

---

## 6. Search & Filter

### Search Bar with Animated Focus
```tsx
function SearchBar({ onSearch }: { onSearch: (q: string) => void }) {
  const [focused, setFocused] = useState(false);
  const [query, setQuery] = useState('');

  return (
    <motion.div
      animate={{ scale: focused ? 1.02 : 1 }}
      className={cn(
        'flex items-center gap-3 px-4 py-3 rounded-2xl border-2 transition-colors duration-300',
        focused ? 'border-primary bg-primary/5' : 'border-transparent bg-muted'
      )}
    >
      <SearchIcon className={cn(
        'w-5 h-5 transition-colors',
        focused ? 'text-primary' : 'text-muted-foreground'
      )} />
      <input
        value={query}
        onChange={e => { setQuery(e.target.value); onSearch(e.target.value); }}
        onFocus={() => setFocused(true)}
        onBlur={() => setFocused(false)}
        placeholder="Search recipes..."
        className="flex-1 bg-transparent outline-none text-sm"
      />
      {query && (
        <button onClick={() => { setQuery(''); onSearch(''); }}
          className="text-muted-foreground hover:text-foreground">
          <XIcon className="w-4 h-4" />
        </button>
      )}
    </motion.div>
  );
}
```

### Filter Chips
```tsx
function FilterChips({ options, selected, onChange }: {
  options: string[];
  selected: string[];
  onChange: (selected: string[]) => void;
}) {
  return (
    <div className="flex flex-wrap gap-2">
      {options.map(option => {
        const isSelected = selected.includes(option);
        return (
          <motion.button
            key={option}
            whileTap={{ scale: 0.95 }}
            onClick={() => {
              onChange(isSelected
                ? selected.filter(s => s !== option)
                : [...selected, option]
              );
            }}
            className={cn(
              'px-4 py-2 rounded-full text-sm font-medium transition-colors duration-200',
              isSelected
                ? 'bg-primary text-primary-foreground shadow-sm'
                : 'bg-muted hover:bg-muted/80 text-muted-foreground'
            )}
          >
            {option}
            {isSelected && <CheckIcon className="w-3 h-3 inline ml-1" />}
          </motion.button>
        );
      })}
    </div>
  );
}
```

---

## 7. Modal & Dialog Patterns

### Animated Modal
```tsx
function AnimatedModal({ open, onClose, children }: {
  open: boolean; onClose: () => void; children: React.ReactNode;
}) {
  return (
    <AnimatePresence>
      {open && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          {/* Backdrop */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-black/50 backdrop-blur-sm"
            onClick={onClose}
          />

          {/* Panel */}
          <motion.div
            initial={{ opacity: 0, scale: 0.95, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95, y: 20 }}
            transition={{ type: 'spring', damping: 30, stiffness: 400 }}
            className="relative bg-background rounded-2xl shadow-2xl max-w-lg w-full max-h-[85vh] overflow-auto"
          >
            {children}
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
```

### Confirmation Dialog
```tsx
function ConfirmDialog({ open, onClose, onConfirm, title, message }: {
  open: boolean; onClose: () => void; onConfirm: () => void;
  title: string; message: string;
}) {
  return (
    <AnimatedModal open={open} onClose={onClose}>
      <div className="p-8">
        <div className="w-12 h-12 rounded-full bg-destructive/10 flex items-center justify-center mb-4">
          <AlertTriangle className="w-6 h-6 text-destructive" />
        </div>
        <h3 className="text-lg font-semibold mb-2">{title}</h3>
        <p className="text-muted-foreground mb-8">{message}</p>
        <div className="flex gap-3 justify-end">
          <button onClick={onClose}
            className="px-4 py-2 rounded-xl border font-medium hover:bg-muted transition-colors">
            Cancel
          </button>
          <button onClick={onConfirm}
            className="px-4 py-2 rounded-xl bg-destructive text-destructive-foreground font-medium
              hover:scale-105 active:scale-95 transition-transform">
            Confirm
          </button>
        </div>
      </div>
    </AnimatedModal>
  );
}
```

---

## 8. Data Display

### Stat Card with Counter Animation
```tsx
function AnimatedCounter({ value, duration = 1.5 }: {
  value: number; duration?: number;
}) {
  const count = useMotionValue(0);
  const rounded = useTransform(count, v => Math.round(v));
  const [display, setDisplay] = useState(0);

  useEffect(() => {
    const unsubscribe = rounded.on('change', setDisplay);
    count.set(value);
    return unsubscribe;
  }, [value]);

  return <span className="tabular-nums">{display.toLocaleString()}</span>;
}

function StatCard({ label, value, unit, trend }: {
  label: string; value: number; unit: string; trend?: number;
}) {
  return (
    <div className="p-6 rounded-2xl bg-card border">
      <p className="text-sm text-muted-foreground mb-2">{label}</p>
      <div className="flex items-baseline gap-1">
        <span className="text-3xl font-bold tracking-tight">
          <AnimatedCounter value={value} />
        </span>
        <span className="text-sm text-muted-foreground">{unit}</span>
      </div>
      {trend !== undefined && (
        <div className={cn('flex items-center gap-1 mt-2 text-sm', trend >= 0 ? 'text-green-500' : 'text-red-500')}>
          <TrendIcon className={cn('w-4 h-4', trend < 0 && 'rotate-180')} />
          {Math.abs(trend)}% from last week
        </div>
      )}
    </div>
  );
}
```

### Data Table with Sticky Header
```tsx
function DataTable<T>({ columns, data }: {
  columns: { key: string; label: string; align?: 'left' | 'right' }[];
  data: T[];
}) {
  return (
    <div className="overflow-auto max-h-96 rounded-xl border">
      <table className="w-full">
        <thead className="sticky top-0 bg-muted/50 backdrop-blur-sm">
          <tr>
            {columns.map(col => (
              <th key={col.key}
                className={cn(
                  'px-4 py-3 text-xs font-medium text-muted-foreground uppercase tracking-wider',
                  col.align === 'right' ? 'text-right' : 'text-left'
                )}>
                {col.label}
              </th>
            ))}
          </tr>
        </thead>
        <tbody className="divide-y">
          {data.map((row, i) => (
            <motion.tr
              key={i}
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.03 }}
              className="hover:bg-muted/30 transition-colors"
            >
              {columns.map(col => (
                <td key={col.key}
                  className={cn(
                    'px-4 py-3 text-sm',
                    col.align === 'right' ? 'text-right font-mono tabular-nums' : ''
                  )}>
                  {String((row as Record<string, unknown>)[col.key] ?? '')}
                </td>
              ))}
            </motion.tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
```

---

## 9. Page Transitions Catalog

```tsx
// Transition 1: Fade + Slide Up
const fadeSlideUp = {
  initial: { opacity: 0, y: 24 },
  animate: { opacity: 1, y: 0 },
  exit: { opacity: 0, y: -24 },
};

// Transition 2: Scale + Blur
const scaleBlur = {
  initial: { opacity: 0, scale: 0.96, filter: 'blur(8px)' },
  animate: { opacity: 1, scale: 1, filter: 'blur(0px)' },
  exit: { opacity: 0, scale: 1.04, filter: 'blur(8px)' },
};

// Transition 3: Slide from Right
const slideRight = {
  initial: { x: '100%' },
  animate: { x: 0 },
  exit: { x: '-100%' },
};

// Transition 4: 3D Flip
const flip3D = {
  initial: { rotateY: 90, opacity: 0 },
  animate: { rotateY: 0, opacity: 1 },
  exit: { rotateY: -90, opacity: 0 },
};

// Transition 5: Zoom In
const zoomIn = {
  initial: { scale: 0.8, opacity: 0 },
  animate: { scale: 1, opacity: 1 },
  exit: { scale: 0.8, opacity: 0 },
};

// Transition 6: Reveal from Bottom
const revealBottom = {
  initial: { clipPath: 'inset(0 0 100% 0)' },
  animate: { clipPath: 'inset(0 0 0% 0)' },
  exit: { clipPath: 'inset(0 0 100% 0)' },
};
```

---

## 10. Micro-Interactions

### Button Press Feedback
```css
.btn-press {
  transition: transform 0.1s ease;
}
.btn-press:active {
  transform: scale(0.96);
}
```

### Input Focus Glow
```css
.input-glow {
  transition: box-shadow 0.3s ease, border-color 0.3s ease;
}
.input-glow:focus {
  box-shadow: 0 0 0 4px rgba(var(--primary-rgb), 0.15);
  border-color: var(--primary);
}
```

### Heart/Like Animation
```tsx
function LikeButton() {
  const [liked, setLiked] = useState(false);

  return (
    <button onClick={() => setLiked(!liked)} className="relative">
      <motion.div
        animate={{ scale: liked ? [1, 1.3, 1] : 1 }}
        transition={{ duration: 0.3 }}
      >
        <HeartIcon
          className={cn('w-6 h-6 transition-colors', liked ? 'fill-red-500 text-red-500' : 'text-muted-foreground')}
        />
      </motion.div>
      {liked && (
        <>
          {[...Array(6)].map((_, i) => (
            <motion.div
              key={i}
              initial={{ scale: 0, x: 0, y: 0, opacity: 1 }}
              animate={{
                scale: [0, 1, 0],
                x: Math.cos(i * 60 * Math.PI / 180) * 30,
                y: Math.sin(i * 60 * Math.PI / 180) * 30,
                opacity: [1, 1, 0],
              }}
              transition={{ duration: 0.6, ease: 'easeOut' }}
              className="absolute top-1/2 left-1/2 w-2 h-2 rounded-full bg-red-400"
            />
          ))}
        </>
      )}
    </button>
  );
}
```

### Copy to Clipboard Feedback
```tsx
function CopyButton({ text }: { text: string }) {
  const [copied, setCopied] = useState(false);

  const copy = async () => {
    await navigator.clipboard.writeText(text);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <button onClick={copy} className="relative">
      <AnimatePresence mode="wait">
        {copied ? (
          <motion.span
            key="check"
            initial={{ scale: 0, rotate: -90 }}
            animate={{ scale: 1, rotate: 0 }}
            exit={{ scale: 0, rotate: 90 }}
          >
            <CheckIcon className="w-5 h-5 text-green-500" />
          </motion.span>
        ) : (
          <motion.span
            key="copy"
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            exit={{ scale: 0 }}
          >
            <CopyIcon className="w-5 h-5" />
          </motion.span>
        )}
      </AnimatePresence>
    </button>
  );
}
```

### Notification Badge
```tsx
function Badge({ count }: { count: number }) {
  return (
    <AnimatePresence>
      {count > 0 && (
        <motion.span
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          exit={{ scale: 0 }}
          transition={{ type: 'spring', stiffness: 500, damping: 25 }}
          className="absolute -top-1 -right-1 min-w-[18px] h-[18px] rounded-full
            bg-destructive text-destructive-foreground text-[10px] font-bold
            flex items-center justify-center px-1"
        >
          {count > 99 ? '99+' : count}
        </motion.span>
      )}
    </AnimatePresence>
  );
}
```

### Scroll to Top FAB
```tsx
function ScrollToTop() {
  const { scrollY } = useScroll();
  const show = useTransform(scrollY, [0, 400], [0, 1]);

  return (
    <motion.button
      style={{ opacity: show, y: useTransform(show, [0, 1], [20, 0]) }}
      onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
      className="fixed bottom-8 right-8 w-12 h-12 rounded-full bg-primary text-primary-foreground
        shadow-lg flex items-center justify-center hover:scale-110 active:scale-95 transition-transform"
    >
      <ArrowUpIcon className="w-5 h-5" />
    </motion.button>
  );
}
```

---

## Quick Index

| Category | Patterns |
|----------|----------|
| Cards | Lift, Reveal, Stacked, Glass, BorderGlow, Parallax |
| Navigation | Shrink Header, Morphing Tabs, Breadcrumbs, Drawer, Mega Menu |
| Loading | Skeleton, Shimmer, Progressive Image, Progress Bar, Spinner |
| States | Empty State, Error State, Confirmation Dialog, Notification |
| Search | Animated Search Bar, Filter Chips |
| Modal | Animated Modal, Confirmation Dialog |
| Data | Animated Counter, Stat Card, Data Table |
| Transitions | Fade+Slide, Scale+Blur, Slide Right, 3D Flip, Zoom, ClipPath |
| Micro | Button Press, Input Glow, Like Animation, Copy Feedback, Badge, Scroll FAB |
