# Modal & Dialog Design — Premium Overlay Patterns

Modals, dialogs, drawers, sheets, and confirmation popups. Sizing, animation, stacking, and accessibility for premium overlays.

---

## 1. Modal Type Decision Matrix

| Type | Best For | Size | Animation | Mobile |
|------|----------|------|-----------|--------|
| **Dialog** | Confirmation, alert | sm (400px) | Scale + fade | Centered |
| **Modal** | Forms, detail views | md-lg (480-640px) | Slide up + fade | Full sheet |
| **Drawer** | Navigation, filters, cart | sm-md (320-400px) | Slide from edge | Full screen |
| **Sheet** | Bottom actions, pickers | Full width | Slide from bottom | Native feel |
| **Popover** | Context menus, dropdowns | auto | Scale | Adaptive |

---

## 2. Base Modal Component

```tsx
interface ModalProps {
  open: boolean;
  onClose: () => void;
  title?: string;
  description?: string;
  size?: 'sm' | 'md' | 'lg' | 'xl' | 'full';
  children: React.ReactNode;
}

const sizeClasses = {
  sm: 'max-w-sm',
  md: 'max-w-md',
  lg: 'max-w-lg',
  xl: 'max-w-xl',
  full: 'max-w-[calc(100vw-2rem)]',
};

function Modal({ open, onClose, title, description, size = 'md', children }: ModalProps) {
  useEffect(() => {
    if (!open) return;
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    document.addEventListener('keydown', onKeyDown);
    document.body.style.overflow = 'hidden';
    return () => {
      document.removeEventListener('keydown', onKeyDown);
      document.body.style.overflow = '';
    };
  }, [open, onClose]);

  return (
    <AnimatePresence>
      {open && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          {/* Backdrop */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-black/40 backdrop-blur-sm"
            onClick={onClose}
            aria-hidden="true"
          />

          {/* Panel */}
          <motion.div
            initial={{ opacity: 0, scale: 0.95, y: 10 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95, y: 10 }}
            transition={{ duration: 0.2, ease: [0, 0, 0.2, 1] }}
            className={`relative w-full ${sizeClasses[size]} bg-surface border rounded-2xl shadow-2xl max-h-[85vh] flex flex-col`}
            role="dialog"
            aria-modal="true"
            aria-labelledby={title ? 'modal-title' : undefined}
            aria-describedby={description ? 'modal-desc' : undefined}
          >
            {/* Header */}
            {title && (
              <div className="flex items-center justify-between px-6 py-4 border-b shrink-0">
                <div>
                  <h2 id="modal-title" className="text-lg font-semibold">{title}</h2>
                  {description && <p id="modal-desc" className="text-sm text-muted mt-0.5">{description}</p>}
                </div>
                <button
                  onClick={onClose}
                  className="p-1.5 hover:bg-muted/10 rounded-lg transition-colors"
                  aria-label="Close dialog"
                >
                  <X size={18} />
                </button>
              </div>
            )}

            {/* Content */}
            <div className="overflow-y-auto px-6 py-5 flex-1">
              {children}
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
```

---

## 3. Alert Dialog (Confirmation)

```tsx
function AlertDialog({
  open,
  onClose,
  onConfirm,
  title,
  description,
  confirmLabel = 'Confirm',
  cancelLabel = 'Cancel',
  variant = 'default', // 'default' | 'danger'
}: {
  open: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  description: string;
  confirmLabel?: string;
  cancelLabel?: string;
  variant?: 'default' | 'danger';
}) {
  const [loading, setLoading] = useState(false);

  const handleConfirm = async () => {
    setLoading(true);
    try { await onConfirm(); }
    finally { setLoading(false); onClose(); }
  };

  return (
    <Modal open={open} onClose={onClose} size="sm">
      <div className="text-center py-4">
        {variant === 'danger' && (
          <div className="w-12 h-12 rounded-full bg-error/10 flex items-center justify-center mx-auto mb-4">
            <AlertTriangle size={22} className="text-error" />
          </div>
        )}
        <h3 className="text-lg font-semibold mb-2">{title}</h3>
        <p className="text-sm text-muted">{description}</p>
      </div>

      <div className="flex gap-3 mt-6">
        <button onClick={onClose} className="btn-ghost flex-1" disabled={loading}>
          {cancelLabel}
        </button>
        <button
          onClick={handleConfirm}
          className={`flex-1 ${variant === 'danger' ? 'bg-error text-white hover:bg-error/90' : 'btn-primary'}`}
          disabled={loading}
        >
          {loading ? <Spinner size={14} /> : confirmLabel}
        </button>
      </div>
    </Modal>
  );
}
```

---

## 4. Drawer (Slide from Edge)

```tsx
function Drawer({
  open,
  onClose,
  side = 'right',
  children,
}: {
  open: boolean;
  onClose: () => void;
  side?: 'left' | 'right';
  children: React.ReactNode;
}) {
  return (
    <AnimatePresence>
      {open && (
        <div className="fixed inset-0 z-50">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-black/40"
            onClick={onClose}
          />

          <motion.div
            initial={{ x: side === 'right' ? '100%' : '-100%' }}
            animate={{ x: 0 }}
            exit={{ x: side === 'right' ? '100%' : '-100%' }}
            transition={{ type: 'spring', stiffness: 350, damping: 35 }}
            className={`absolute top-0 bottom-0 ${side === 'right' ? 'right-0' : 'left-0'}
              w-full max-w-sm bg-surface border-l shadow-2xl
              flex flex-col
            `}
            role="dialog"
            aria-modal="true"
          >
            {children}
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
```

---

## 5. Bottom Sheet (Mobile-Native)

```tsx
function BottomSheet({
  open,
  onClose,
  snapPoints = [0.5, 0.9],
  children,
}: {
  open: boolean;
  onClose: () => void;
  snapPoints?: number[]; // fractions of viewport
  children: React.ReactNode;
}) {
  const y = useMotionValue(0);
  const [snap, setSnap] = useState(0);

  const handleDragEnd = (_: any, info: { velocity: { y: number }; offset: { y: number } }) => {
    const threshold = window.innerHeight * snapPoints[0];
    if (info.velocity.y > 500 || info.offset.y > threshold) {
      onClose();
    }
  };

  return (
    <AnimatePresence>
      {open && (
        <div className="fixed inset-0 z-50">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 bg-black/40"
            onClick={onClose}
          />

          <motion.div
            drag="y"
            dragConstraints={{ top: 0, bottom: 0 }}
            dragElastic={0.15}
            onDragEnd={handleDragEnd}
            initial={{ y: '100%' }}
            animate={{ y: 0 }}
            exit={{ y: '100%' }}
            transition={{ type: 'spring', stiffness: 350, damping: 35 }}
            className="absolute bottom-0 left-0 right-0
              bg-surface rounded-t-2xl shadow-2xl
              max-h-[90vh] flex flex-col
            "
          >
            {/* Handle */}
            <div className="flex justify-center pt-3 pb-1">
              <div className="w-10 h-1 rounded-full bg-muted/20" />
            </div>

            <div className="overflow-y-auto px-6 py-4 flex-1">
              {children}
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
```

---

## 6. Modal Sizes & Layout Presets

```css
/* Consistent modal sizing across the application */
.modal-sm  { max-width: 400px; }
.modal-md  { max-width: 480px; }
.modal-lg  { max-width: 640px; }
.modal-xl  { max-width: 800px; }

/* Modal with sidebar layout (settings-style) */
.modal-settings {
  display: grid;
  grid-template-columns: 200px 1fr;
  max-width: 720px;
  max-height: 560px;
}

/* Full-screen modal (on mobile) */
@media (max-width: 640px) {
  .modal-responsive {
    max-width: 100vw;
    max-height: 100vh;
    height: 100vh;
    border-radius: 0;
    margin: 0;
  }
}
```

---

## 7. Stacked Modals (Modal on Modal)

```tsx
function ModalStack() {
  const [parentOpen, setParentOpen] = useState(false);
  const [childOpen, setChildOpen] = useState(false);

  return (
    <>
      <button onClick={() => setParentOpen(true)}>Open Parent</button>

      <Modal open={parentOpen} onClose={() => setParentOpen(false)} title="Settings">
        <button onClick={() => setChildOpen(true)}>Change plan</button>

        {/* Child modal — appears on top of parent */}
        <Modal open={childOpen} onClose={() => setChildOpen(false)} title="Change Plan" size="sm">
          <p className="text-sm text-muted">Are you sure you want to change your plan?</p>
          <button onClick={() => { setChildOpen(false); setParentOpen(false); }} className="btn-primary mt-4">
            Confirm
          </button>
        </Modal>
      </Modal>
    </>
  );
}

/* Stacked modal visual depth via scale */
.modal-stacked {
  transform: scale(0.97);
}
.modal-stacked + .modal-stacked {
  transform: scale(0.94);
}
```

---

## 8. Keyboard & Focus Management

```tsx
function useModalFocusTrap(containerRef: RefObject<HTMLElement>, active: boolean) {
  useEffect(() => {
    if (!active || !containerRef.current) return;

    const container = containerRef.current;
    const focusableSelector = 'a[href], button:not([disabled]), textarea, input, select, [tabindex]:not([tabindex="-1"])';

    const handleTab = (e: KeyboardEvent) => {
      if (e.key !== 'Tab') return;
      const focusable = container.querySelectorAll(focusableSelector);
      const first = focusable[0] as HTMLElement;
      const last = focusable[focusable.length - 1] as HTMLElement;

      if (e.shiftKey && document.activeElement === first) {
        e.preventDefault();
        last?.focus();
      } else if (!e.shiftKey && document.activeElement === last) {
        e.preventDefault();
        first?.focus();
      }
    };

    // Focus first element on mount
    const first = container.querySelector(focusableSelector) as HTMLElement;
    first?.focus();

    container.addEventListener('keydown', handleTab);
    return () => container.removeEventListener('keydown', handleTab);
  }, [active]);
}
```

---

## 9. Modal Animation Variants

```tsx
// Standard: scale + fade (dialogs, alerts)
const scaleFade = {
  initial: { opacity: 0, scale: 0.95, y: 10 },
  animate: { opacity: 1, scale: 1, y: 0 },
  exit:    { opacity: 0, scale: 0.95, y: 10 },
  transition: { duration: 0.2, ease: [0, 0, 0.2, 1] },
};

// Slide up: form modals, sheets
const slideUp = {
  initial: { opacity: 0, y: 40 },
  animate: { opacity: 1, y: 0 },
  exit:    { opacity: 0, y: 40 },
  transition: { duration: 0.25, ease: [0.22, 1, 0.36, 1] },
};

// Slide from right: drawers, side panels
const slideRight = {
  initial: { x: '100%' },
  animate: { x: 0 },
  exit:    { x: '100%' },
  transition: { type: 'spring', stiffness: 350, damping: 35 },
};

// 3D Flip: settings/theme panels (playful)
const flip = {
  initial: { opacity: 0, rotateX: 10, scale: 0.96 },
  animate: { opacity: 1, rotateX: 0, scale: 1 },
  exit:    { opacity: 0, rotateX: 10, scale: 0.96 },
  transition: { duration: 0.3, ease: [0.22, 1, 0.36, 1] },
};
```

---

## 10. Modal Anti-Patterns

```
❌ Modal on mobile with scrollable body behind (disable body scroll)
❌ No close button (always provide X button + Escape key + backdrop click)
❌ More than 2 stacked modals (rethink UX — use tabs or steps instead)
❌ Modal for notifications/alerts (use Toast instead)
❌ Large modals on mobile (use full-screen sheet instead)
❌ Auto-focusing the confirm button (dangerous — focus the cancel button)
❌ No aria-labelledby (screen readers need context)
❌ Animation on first render of large content (prefers-reduced-motion)
```
