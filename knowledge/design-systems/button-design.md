# Button Design System — Premium Button Architecture

Buttons as affordance, not decoration. Variants, sizes, states, loading, icon placement, and button group patterns for premium UI.

---

## 1. Button Variant System

```css
/* === Base Button === */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-weight: 500;
  border: 1.5px solid transparent;
  border-radius: var(--radius-md);
  cursor: pointer;
  user-select: none;
  white-space: nowrap;
  transition: all var(--duration-fast) var(--ease-out);
  position: relative;
  overflow: hidden;
}
.btn:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}
.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  pointer-events: none;
}
```

### Primary
```css
.btn-primary {
  background: var(--color-primary);
  color: white;
  box-shadow: 0 1px 2px rgba(0,0,0,0.06), 0 1px 3px rgba(var(--primary-rgb), 0.3);
}
.btn-primary:hover {
  filter: brightness(1.1);
  box-shadow: 0 2px 4px rgba(0,0,0,0.08), 0 2px 8px rgba(var(--primary-rgb), 0.35);
  transform: translateY(-1px);
}
.btn-primary:active {
  filter: brightness(0.95);
  transform: translateY(0);
  box-shadow: 0 1px 2px rgba(0,0,0,0.06);
}
```

### Secondary
```css
.btn-secondary {
  background: rgba(var(--foreground-rgb), 0.06);
  color: var(--color-foreground);
  border-color: var(--color-border);
}
.btn-secondary:hover {
  background: rgba(var(--foreground-rgb), 0.1);
  border-color: rgba(var(--foreground-rgb), 0.2);
}
```

### Ghost / Tertiary
```css
.btn-ghost {
  background: transparent;
  color: var(--color-foreground);
}
.btn-ghost:hover {
  background: rgba(var(--foreground-rgb), 0.06);
}
```

### Outline
```css
.btn-outline {
  background: transparent;
  color: var(--color-primary);
  border-color: var(--color-primary);
}
.btn-outline:hover {
  background: rgba(var(--primary-rgb), 0.06);
}
```

### Danger
```css
.btn-danger {
  background: var(--color-error);
  color: white;
}
.btn-danger:hover {
  filter: brightness(1.1);
}
```

### Success
```css
.btn-success {
  background: var(--color-success);
  color: white;
}
```

### Glass (frosted)
```css
.btn-glass {
  background: rgba(var(--surface-rgb), 0.7);
  backdrop-filter: blur(12px);
  color: var(--color-foreground);
  border-color: rgba(255, 255, 255, 0.2);
}
.btn-glass:hover {
  background: rgba(var(--surface-rgb), 0.85);
  border-color: rgba(255, 255, 255, 0.3);
}
```

---

## 2. Button Sizes

```css
.btn-xs  { height: 28px; padding: 0 10px; font-size: 12px; border-radius: var(--radius-sm); gap: 4px; }
.btn-sm  { height: 36px; padding: 0 14px; font-size: 13px; border-radius: var(--radius-sm); gap: 5px; }
.btn-md  { height: 44px; padding: 0 20px; font-size: 14px; border-radius: var(--radius-md); gap: 6px; }
.btn-lg  { height: 52px; padding: 0 24px; font-size: 16px; border-radius: var(--radius-lg); gap: 8px; }
.btn-xl  { height: 60px; padding: 0 32px; font-size: 18px; border-radius: var(--radius-lg); gap: 10px; }

/* Icon-only sizes */
.btn-icon-sm  { width: 36px; height: 36px; padding: 0; }
.btn-icon-md  { width: 44px; height: 44px; padding: 0; }
.btn-icon-lg  { width: 52px; height: 52px; padding: 0; }

/* Pill / rounded variant */
.btn-pill { border-radius: 9999px; }
```

---

## 3. Button with Loading State

```tsx
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'ghost' | 'outline' | 'danger';
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  loading?: boolean;
  icon?: React.ReactNode;
  iconPosition?: 'left' | 'right';
  children?: React.ReactNode;
}

function Button({
  variant = 'primary',
  size = 'md',
  loading,
  icon,
  iconPosition = 'left',
  children,
  disabled,
  className,
  ...props
}: ButtonProps) {
  return (
    <button
      className={`btn btn-${variant} btn-${size} ${className || ''}`}
      disabled={disabled || loading}
      {...props}
    >
      {loading ? (
        <Spinner size={size === 'xs' || size === 'sm' ? 14 : 16} className="shrink-0" />
      ) : (
        icon && iconPosition === 'left' && <span className="shrink-0">{icon}</span>
      )}
      {children && (
        <span className={loading ? 'opacity-0' : ''}>{children}</span>
      )}
      {!loading && icon && iconPosition === 'right' && <span className="shrink-0">{icon}</span>}
    </button>
  );
}
```

---

## 4. Icon Button

```tsx
function IconButton({
  icon,
  label,
  variant = 'ghost',
  size = 'md',
  ...props
}: {
  icon: React.ReactNode;
  label: string;
  variant?: 'ghost' | 'secondary' | 'primary';
  size?: 'sm' | 'md' | 'lg';
} & React.ButtonHTMLAttributes<HTMLButtonElement>) {
  return (
    <button
      className={`btn btn-${variant} btn-icon-${size}`}
      aria-label={label}
      {...props}
    >
      {icon}
    </button>
  );
}
```

---

## 5. Button Group

```tsx
function ButtonGroup({
  children,
  variant = 'secondary',
}: {
  children: React.ReactNode;
  variant?: 'secondary' | 'outline';
}) {
  return (
    <div className="inline-flex rounded-lg overflow-hidden border" role="group">
      {React.Children.map(children, (child, i) => (
        <div className={`
          ${i > 0 ? 'border-l' : ''}
          ${variant === 'secondary' ? 'bg-muted/5 hover:bg-muted/10' : 'bg-transparent hover:bg-muted/5'}
          transition-colors cursor-pointer
          px-3 py-1.5 text-sm font-medium
        `}>
          {child}
        </div>
      ))}
    </div>
  );
}

// Usage
<ButtonGroup>
  <button onClick={() => setView('list')}>List</button>
  <button onClick={() => setView('grid')}>Grid</button>
</ButtonGroup>
```

---

## 6. Split Button

```tsx
function SplitButton({
  children,
  onPrimaryClick,
  menuItems,
}: {
  children: React.ReactNode;
  onPrimaryClick: () => void;
  menuItems: { label: string; onClick: () => void }[];
}) {
  const [menuOpen, setMenuOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(e.target as Node)) setMenuOpen(false);
    };
    document.addEventListener('mousedown', handleClick);
    return () => document.removeEventListener('mousedown', handleClick);
  }, []);

  return (
    <div className="inline-flex rounded-lg overflow-hidden" ref={menuRef}>
      <button onClick={onPrimaryClick} className="btn btn-primary rounded-r-none border-r border-white/20">
        {children}
      </button>
      <div className="relative">
        <button
          onClick={() => setMenuOpen(!menuOpen)}
          className="btn btn-primary rounded-l-none !px-2"
          aria-label="More options"
          aria-expanded={menuOpen}
        >
          <ChevronDown size={16} />
        </button>
        {menuOpen && (
          <div className="absolute right-0 top-full mt-1 bg-surface border rounded-lg shadow-xl py-1 min-w-[160px] z-50">
            {menuItems.map(item => (
              <button
                key={item.label}
                onClick={() => { item.onClick(); setMenuOpen(false); }}
                className="w-full text-left px-3 py-2 text-sm hover:bg-muted/5 transition-colors"
              >
                {item.label}
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
```

---

## 7. FAB (Floating Action Button)

```tsx
function FAB({
  icon,
  label,
  onClick,
  position = 'bottom-right',
}: {
  icon: React.ReactNode;
  label: string;
  onClick: () => void;
  position?: 'bottom-right' | 'bottom-left' | 'bottom-center';
}) {
  const positions = {
    'bottom-right': 'bottom-6 right-6',
    'bottom-left': 'bottom-6 left-6',
    'bottom-center': 'bottom-6 left-1/2 -translate-x-1/2',
  };

  return (
    <motion.button
      whileHover={{ scale: 1.05 }}
      whileTap={{ scale: 0.95 }}
      onClick={onClick}
      aria-label={label}
      className={`fixed ${positions[position]} z-40
        w-14 h-14 rounded-2xl
        bg-primary text-white
        shadow-lg shadow-primary/30
        flex items-center justify-center
        hover:shadow-xl hover:shadow-primary/40
        transition-shadow
      `}
    >
      {icon}
    </motion.button>
  );
}
```

---

## 8. Destructive Action Pattern

```tsx
function DestructiveButton({
  children,
  onConfirm,
  confirmMessage = 'Click again to confirm',
}: {
  children: React.ReactNode;
  onConfirm: () => void;
  confirmMessage?: string;
}) {
  const [confirming, setConfirming] = useState(false);

  const handleClick = () => {
    if (!confirming) {
      setConfirming(true);
      setTimeout(() => setConfirming(false), 3000); // reset after 3s
      return;
    }
    onConfirm();
    setConfirming(false);
  };

  return (
    <button
      onClick={handleClick}
      className={`btn transition-all duration-200 ${
        confirming
          ? 'btn-danger animate-pulse'
          : 'btn-outline !border-error !text-error hover:!bg-error/5'
      }`}
      onBlur={() => setConfirming(false)}
    >
      {confirming ? confirmMessage : children}
    </button>
  );
}
```

---

## 9. Button with Keyboard Shortcut Hint

```tsx
function ButtonWithShortcut({
  children,
  shortcut,
  ...props
}: ButtonProps & { shortcut: string }) {
  return (
    <button className="btn btn-secondary" {...props}>
      <span>{children}</span>
      <kbd className="hidden sm:inline-block text-[10px] px-1.5 py-0.5 rounded bg-muted/10 font-mono ml-1">
        {shortcut}
      </kbd>
    </button>
  );
}
```

---

## 10. Button State Reference

```
┌──────────┬──────────────────────────────────────────┐
│  STATE   │  VISUAL                                  │
├──────────┼──────────────────────────────────────────┤
│  IDLE    │  Default styling                         │
│  HOVER   │  1px lift, brighter, slightly larger shadow │
│  ACTIVE  │  Pressed down, darker, no lift           │
│  FOCUS   │  2px primary ring, 2px offset            │
│  LOADING │  Spinner replaces icon, text hidden       │
│  SUCCESS │  Brief green state, check mark, auto-reset │
│  ERROR   │  Brief shake animation, red              │
│  DISABLED│  50% opacity, cursor not-allowed          │
└──────────┴──────────────────────────────────────────┘
```

### Success State Animation
```tsx
function ButtonWithSuccess({ children, onClick, ...props }: ButtonProps) {
  const [status, setStatus] = useState<'idle' | 'loading' | 'success'>('idle');

  const handleClick = async () => {
    setStatus('loading');
    try {
      await onClick?.();
      setStatus('success');
      setTimeout(() => setStatus('idle'), 2000);
    } catch {
      setStatus('idle');
    }
  };

  return (
    <button className={`btn btn-primary relative`} onClick={handleClick} {...props}>
      <AnimatePresence mode="wait">
        {status === 'loading' && (
          <motion.span key="loading" initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}>
            <Spinner size={16} />
          </motion.span>
        )}
        {status === 'success' && (
          <motion.span key="success" initial={{ opacity: 0, scale: 0.5 }} animate={{ opacity: 1, scale: 1 }}>
            <CheckCircle size={16} />
          </motion.span>
        )}
        {status === 'idle' && (
          <motion.span key="idle" initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
            {children}
          </motion.span>
        )}
      </AnimatePresence>
    </button>
  );
}
```

---

## 11. Button Anti-Patterns

```
❌ More than 2 primary buttons per screen (dilutes hierarchy)
❌ Buttons without visible hover/active states
❌ Disabled buttons with no explanation (use tooltip)
❌ Tiny touch targets (< 44px on mobile)
❌ All-caps labels (harder to read — use font-weight instead)
❌ Color-only state changes (add text/icon change for colorblind users)
❌ Nested buttons (invalid HTML, unpredictable behavior)
❌ Submit buttons without loading state (double-submit risk)
```
