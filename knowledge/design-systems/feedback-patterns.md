# Feedback Patterns — Toast, Notification & Progress

System feedback that feels responsive, not annoying. Toast notifications, progress indicators, tooltips, popovers, and confirmation patterns for premium UI.

---

## 1. Toast Notification System

### Toast Provider + System
```tsx
interface Toast {
  id: string;
  title: string;
  description?: string;
  variant?: 'default' | 'success' | 'error' | 'warning' | 'info';
  duration?: number;
  action?: { label: string; onClick: () => void };
}

// Simple toast store
const toastState = atom<Toast[]>([]);

function useToast() {
  const [toasts, setToasts] = useAtom(toastState);

  const toast = (t: Omit<Toast, 'id'>) => {
    const id = crypto.randomUUID();
    setToasts(prev => [...prev, { ...t, id }]);
    if (t.duration !== 0) {
      setTimeout(() => setToasts(prev => prev.filter(x => x.id !== id)), t.duration || 4000);
    }
  };

  return { toast, toasts, dismiss: (id: string) => setToasts(prev => prev.filter(t => t.id !== id)) };
}
```

### Toast Container
```tsx
function ToastContainer() {
  const { toasts, dismiss } = useToast();

  return (
    <div
      className="fixed bottom-4 right-4 z-[100] flex flex-col-reverse gap-2 max-w-sm w-full"
      aria-live="polite"
      aria-label="Notifications"
    >
      <AnimatePresence>
        {toasts.map(toast => (
          <ToastItem key={toast.id} toast={toast} onDismiss={() => dismiss(toast.id)} />
        ))}
      </AnimatePresence>
    </div>
  );
}
```

### Toast Item
```tsx
function ToastItem({ toast, onDismiss }: { toast: Toast; onDismiss: () => void }) {
  const progress = useMotionValue(100);

  useEffect(() => {
    if (toast.duration === 0) return;
    const controls = animate(progress, 0, {
      duration: (toast.duration || 4000) / 1000,
      ease: 'linear',
    });
    return controls.stop;
  }, []);

  const icons = {
    success: <CheckCircle size={16} className="text-success" />,
    error: <AlertCircle size={16} className="text-error" />,
    warning: <AlertTriangle size={16} className="text-warning" />,
    info: <Info size={16} className="text-primary" />,
    default: null,
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20, scale: 0.95 }}
      animate={{ opacity: 1, y: 0, scale: 1 }}
      exit={{ opacity: 0, y: 10, scale: 0.95 }}
      transition={{ duration: 0.2 }}
      className="relative bg-surface/95 backdrop-blur-xl border rounded-xl shadow-xl overflow-hidden"
      role="alert"
    >
      <div className="flex items-start gap-3 p-4 pr-10">
        {icons[toast.variant || 'default']}
        <div className="min-w-0 flex-1">
          <p className="text-sm font-semibold">{toast.title}</p>
          {toast.description && (
            <p className="text-xs text-muted mt-0.5">{toast.description}</p>
          )}
          {toast.action && (
            <button onClick={toast.action.onClick} className="text-xs text-primary hover:underline mt-1.5 font-medium">
              {toast.action.label}
            </button>
          )}
        </div>
      </div>

      <button
        onClick={onDismiss}
        className="absolute top-3 right-3 p-0.5 hover:bg-muted/10 rounded transition-colors"
        aria-label="Dismiss"
      >
        <X size={14} className="text-muted" />
      </button>

      {/* Progress bar */}
      {toast.duration !== 0 && (
        <motion.div
          className="h-0.5 bg-muted/10"
          style={{ width: useTransform(progress, v => `${v}%`) }}
        />
      )}
    </motion.div>
  );
}
```

---

## 2. Toast Variants & When to Use

| Variant | Use Case | Auto-Dismiss | Example |
|---------|----------|-------------|---------|
| **Success** | Action completed | 3-4s | "Profile saved" |
| **Error** | Action failed | 6-8s | "Failed to upload file" |
| **Warning** | Potential issue | 5-6s | "Session expiring soon" |
| **Info** | Neutral information | 4-5s | "New feature available" |
| **Persistent** | Critical, needs action | Manual only | "Payment method expired" |

---

## 3. Progress Indicators

### Linear Progress (top-of-page loading bar)
```tsx
function TopProgressBar() {
  const { isFetching } = useIsFetching();

  return (
    <AnimatePresence>
      {isFetching && (
        <motion.div
          initial={{ scaleX: 0, opacity: 0 }}
          animate={{ scaleX: 1, opacity: 1 }}
          exit={{ scaleX: 1, opacity: 0 }}
          transition={{ duration: 0.3 }}
          className="fixed top-0 left-0 right-0 z-[100] h-0.5 bg-primary origin-left"
        >
          <motion.div
            className="h-full bg-primary/30"
            animate={{ x: ['-100%', '200%'] }}
            transition={{ repeat: Infinity, duration: 1.5, ease: 'linear' }}
          />
        </motion.div>
      )}
    </AnimatePresence>
  );
}
```

### Circular Progress (determinate)
```tsx
function CircularProgress({ value, size = 48, strokeWidth = 3 }: {
  value: number; // 0-100
  size?: number;
  strokeWidth?: number;
}) {
  const radius = (size - strokeWidth) / 2;
  const circumference = radius * 2 * Math.PI;
  const offset = circumference - (value / 100) * circumference;

  return (
    <div className="relative inline-flex items-center justify-center" role="progressbar" aria-valuenow={value} aria-valuemin={0} aria-valuemax={100}>
      <svg width={size} height={size}>
        <circle cx={size / 2} cy={size / 2} r={radius} fill="none" stroke="currentColor" strokeWidth={strokeWidth} className="text-muted/10" />
        <motion.circle
          cx={size / 2} cy={size / 2} r={radius}
          fill="none"
          stroke="var(--color-primary)"
          strokeWidth={strokeWidth}
          strokeLinecap="round"
          strokeDasharray={circumference}
          initial={{ strokeDashoffset: circumference }}
          animate={{ strokeDashoffset: offset }}
          transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
          transform={`rotate(-90 ${size / 2} ${size / 2})`}
        />
      </svg>
      <span className="absolute text-xs font-semibold tabular-nums">{Math.round(value)}%</span>
    </div>
  );
}
```

### Step Progress (multi-step)
```tsx
function StepProgress({ steps, current }: { steps: string[]; current: number }) {
  return (
    <nav aria-label="Progress" className="flex items-center">
      {steps.map((step, i) => (
        <div key={step} className="flex items-center flex-1 last:flex-none">
          <div className="flex items-center gap-2">
            <div className={`
              w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold
              transition-all duration-300
              ${i < current
                ? 'bg-primary text-white'
                : i === current
                ? 'bg-primary/10 text-primary ring-2 ring-primary/30'
                : 'bg-muted/10 text-muted'
              }
            `}>
              {i < current ? <Check size={12} /> : i + 1}
            </div>
            <span className={`text-sm font-medium hidden sm:inline ${i <= current ? 'text-foreground' : 'text-muted'}`}>
              {step}
            </span>
          </div>
          {i < steps.length - 1 && (
            <div className={`
              flex-1 h-0.5 mx-3 rounded-full transition-colors duration-300
              ${i < current ? 'bg-primary' : 'bg-muted/10'}
            `} />
          )}
        </div>
      ))}
    </nav>
  );
}
```

---

## 4. Tooltip System

```tsx
function Tooltip({
  content,
  side = 'top',
  children,
}: {
  content: string;
  side?: 'top' | 'bottom' | 'left' | 'right';
  children: React.ReactNode;
}) {
  const [open, setOpen] = useState(false);

  const sideStyles = {
    top: 'bottom-full left-1/2 -translate-x-1/2 mb-2',
    bottom: 'top-full left-1/2 -translate-x-1/2 mt-2',
    left: 'right-full top-1/2 -translate-y-1/2 mr-2',
    right: 'left-full top-1/2 -translate-y-1/2 ml-2',
  };

  return (
    <div
      className="relative inline-flex"
      onMouseEnter={() => setOpen(true)}
      onMouseLeave={() => setOpen(false)}
      onFocus={() => setOpen(true)}
      onBlur={() => setOpen(false)}
    >
      {children}
      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ opacity: 0, scale: 0.92 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.92 }}
            transition={{ duration: 0.12 }}
            className={`absolute ${sideStyles[side]} z-50 pointer-events-none`}
          >
            <div className="bg-foreground text-background text-xs px-2.5 py-1.5 rounded-lg whitespace-nowrap shadow-lg">
              {content}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
```

---

## 5. Popover

```tsx
function Popover({
  trigger,
  children,
  align = 'center',
}: {
  trigger: React.ReactNode;
  children: React.ReactNode;
  align?: 'start' | 'center' | 'end';
}) {
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, []);

  const alignStyles = {
    start: 'left-0',
    center: 'left-1/2 -translate-x-1/2',
    end: 'right-0',
  };

  return (
    <div className="relative inline-flex" ref={ref}>
      <div onClick={() => setOpen(!open)}>{trigger}</div>
      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ opacity: 0, y: 4, scale: 0.96 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 4, scale: 0.96 }}
            transition={{ duration: 0.15 }}
            className={`absolute top-full mt-2 ${alignStyles[align]} z-50
              bg-surface border rounded-xl shadow-xl min-w-[200px] p-1.5`}
          >
            {children}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
```

---

## 6. Copy Feedback

```tsx
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
      className={`btn btn-icon-sm transition-all duration-200 ${
        copied ? 'btn-success scale-110' : 'btn-ghost'
      }`}
      aria-label={copied ? 'Copied' : 'Copy to clipboard'}
    >
      <AnimatePresence mode="wait">
        {copied ? (
          <motion.span key="check" initial={{ scale: 0 }} animate={{ scale: 1 }} exit={{ scale: 0 }}>
            <Check size={14} />
          </motion.span>
        ) : (
          <motion.span key="copy" initial={{ scale: 0 }} animate={{ scale: 1 }} exit={{ scale: 0 }}>
            <Copy size={14} />
          </motion.span>
        )}
      </AnimatePresence>
    </button>
  );
}
```

---

## 7. Feedback Anti-Patterns

```
❌ Too many toasts (stack max 3 — older ones auto-dismiss)
❌ Error toasts that disappear too fast (min 6s for errors)
❌ Generic messages ("Error occurred" — say what and how to fix)
❌ Toast for every save (only for explicit actions, not auto-save)
❌ Progress bar that jumps backwards (monotonic only)
❌ Tooltip on touch devices (no hover — use tap or inline help)
❌ Popover that overflows viewport (detect and flip alignment)
❌ Confirmation for non-destructive actions (let people undo instead)
```
