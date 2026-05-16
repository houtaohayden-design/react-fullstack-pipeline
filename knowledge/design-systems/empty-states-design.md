# State Design — Empty, Error, Loading & Edge Cases

Every screen has multiple states. Design for all of them — not just the ideal case. Comprehensive patterns for empty states, errors, loading, and edge cases.

---

## 1. The State Matrix

Every component/screen has these states:

```
┌────────────────────────────────────────┐
│  LOADING    │  EMPTY      │  IDEAL     │
│  Skeleton,  │  No data,   │  Content   │
│  spinner,   │  first use, │  loaded,   │
│  shimmer    │  no results │  ready     │
├─────────────┼─────────────┼────────────┤
│  ERROR      │  PARTIAL    │  OVERFLOW  │
│  Network,   │  Some data, │  Too much  │
│  server,    │  partial    │  data,     │
│  permission │  failure    │  pagination│
└────────────────────────────────────────┘
```

### State Decision Tree
```tsx
function StateRouter({
  isLoading,
  isError,
  error,
  data,
  emptyMessage,
  children,
}: {
  isLoading: boolean;
  isError: boolean;
  error?: Error;
  data: any[] | null;
  emptyMessage?: string;
  children: React.ReactNode;
}) {
  if (isLoading) return <LoadingSkeleton />;
  if (isError) return <ErrorState error={error} onRetry={() => refetch()} />;
  if (data && data.length === 0) return <EmptyState message={emptyMessage} />;
  return <>{children}</>;
}
```

---

## 2. Loading States — Skeleton Screens

### Skeleton Component System
```tsx
function Skeleton({ className }: { className?: string }) {
  return (
    <div
      className={`animate-shimmer bg-gradient-to-r from-muted/5 via-muted/10 to-muted/5 bg-[length:200%_100%] rounded ${className}`}
      aria-hidden="true"
    />
  );
}

/* Animation */
@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
.animate-shimmer {
  animation: shimmer 1.5s infinite;
}
```

### Card Grid Skeleton
```tsx
function CardGridSkeleton({ count = 6 }: { count?: number }) {
  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
      {Array.from({ length: count }).map((_, i) => (
        <div key={i} className="bg-surface border rounded-xl p-5 space-y-3">
          <Skeleton className="w-full aspect-video rounded-lg" />
          <Skeleton className="h-5 w-3/4" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-1/2" />
          <div className="flex gap-2 pt-2">
            <Skeleton className="h-8 w-20 rounded-full" />
            <Skeleton className="h-8 w-16 rounded-full" />
          </div>
        </div>
      ))}
    </div>
  );
}
```

### Profile / Detail Page Skeleton
```tsx
function ProfileSkeleton() {
  return (
    <div className="max-w-3xl mx-auto py-12 px-[--page-gutter] space-y-8">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Skeleton className="w-20 h-20 rounded-full" />
        <div className="space-y-2 flex-1">
          <Skeleton className="h-7 w-48" />
          <Skeleton className="h-4 w-32" />
        </div>
      </div>
      {/* Content blocks */}
      <div className="space-y-4">
        <Skeleton className="h-4 w-full" />
        <Skeleton className="h-4 w-full" />
        <Skeleton className="h-4 w-3/4" />
        <Skeleton className="h-4 w-5/6" />
      </div>
      <div className="grid grid-cols-3 gap-4">
        <Skeleton className="h-24 rounded-xl" />
        <Skeleton className="h-24 rounded-xl" />
        <Skeleton className="h-24 rounded-xl" />
      </div>
    </div>
  );
}
```

### Table Skeleton
```tsx
function TableSkeleton({ rows = 5, cols = 4 }: { rows?: number; cols?: number }) {
  return (
    <div className="border rounded-xl overflow-hidden">
      <div className="bg-muted/5 p-4 border-b">
        <Skeleton className="h-4 w-full max-w-[600px]" />
      </div>
      {Array.from({ length: rows }).map((_, r) => (
        <div key={r} className="flex gap-4 p-4 border-b last:border-0">
          {Array.from({ length: cols }).map((_, c) => (
            <Skeleton key={c} className="h-4 flex-1" style={{ maxWidth: `${40 + Math.random() * 200}px` }} />
          ))}
        </div>
      ))}
    </div>
  );
}
```

---

## 3. Empty States

### The 3 Types of Empty States

| Type | When | Emotional Goal |
|------|------|---------------|
| **First Use** | User just signed up, no data yet | Excitement, guidance |
| **No Results** | User searched/filtered, nothing found | Helpful redirection |
| **Cleared** | User deleted everything | Reassurance, recovery |

### First Use — Inspiring & Actionable
```tsx
function EmptyFirstUse({
  icon,
  title,
  description,
  action,
}: {
  icon: React.ReactNode;
  title: string;
  description: string;
  action: { label: string; onClick: () => void };
}) {
  return (
    <div className="flex flex-col items-center justify-center py-20 px-6 text-center">
      <motion.div
        initial={{ scale: 0.8, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={{ type: 'spring', stiffness: 300, damping: 25 }}
        className="w-20 h-20 rounded-2xl bg-primary/10 flex items-center justify-center text-primary mb-6"
      >
        {icon}
      </motion.div>

      <h2 className="text-xl font-bold mb-2">{title}</h2>
      <p className="text-muted text-sm max-w-md mb-8">{description}</p>

      <button onClick={action.onClick} className="btn-primary">
        {action.label}
      </button>

      {/* Illustration / Suggestion */}
      <div className="mt-12 text-xs text-muted">
        <p>Not sure where to start? <a href="/templates" className="text-primary hover:underline">Browse templates</a></p>
      </div>
    </div>
  );
}
```

### No Results — Helpful & Redirecting
```tsx
function EmptyNoResults({ query, suggestions }: {
  query: string;
  suggestions: string[];
}) {
  return (
    <div className="flex flex-col items-center py-16 px-6 text-center">
      <div className="w-16 h-16 rounded-full bg-muted/10 flex items-center justify-center mb-5">
        <Search size={24} className="text-muted" />
      </div>
      <h3 className="text-lg font-semibold mb-1">No results for "{query}"</h3>
      <p className="text-sm text-muted mb-6">Try adjusting your search or filter criteria</p>

      {suggestions.length > 0 && (
        <div className="text-sm">
          <p className="text-muted mb-2">Try searching:</p>
          <div className="flex flex-wrap gap-2 justify-center">
            {suggestions.map(s => (
              <button key={s} className="px-3 py-1.5 bg-muted/5 border rounded-full text-sm hover:bg-muted/10 transition-colors">
                {s}
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
```

### Cleared All — Reassuring
```tsx
function EmptyCleared({ itemName, onUndo }: { itemName: string; onUndo: () => void }) {
  return (
    <div className="flex flex-col items-center py-16 px-6 text-center">
      <CheckCircle size={40} className="text-success mb-4" />
      <h3 className="text-lg font-semibold mb-1">All {itemName} cleared</h3>
      <p className="text-sm text-muted mb-4">Your {itemName} have been removed</p>
      <button onClick={onUndo} className="text-sm text-primary hover:underline">
        Undo
      </button>
    </div>
  );
}
```

---

## 4. Error States

### Error Severity Levels
```css
/* Info — blue, no action needed */
.alert-info  { background: rgba(var(--primary-rgb), 0.05); border-color: rgba(var(--primary-rgb), 0.2); }

/* Warning — yellow, action recommended */
.alert-warning { background: rgba(var(--warning-rgb), 0.05); border-color: rgba(var(--warning-rgb), 0.2); }

/* Error — red, action required */
.alert-error { background: rgba(var(--error-rgb), 0.05); border-color: rgba(var(--error-rgb), 0.2); }

/* Critical — red + stronger visual, immediate action */
.alert-critical { background: var(--color-error); color: white; }
```

### Inline Error (data failed to load, contained)
```tsx
function InlineError({ error, onRetry }: { error: Error; onRetry: () => void }) {
  return (
    <div className="alert-error border rounded-xl p-6 max-w-lg mx-auto my-8" role="alert">
      <div className="flex items-start gap-3">
        <AlertCircle size={20} className="text-error shrink-0 mt-0.5" />
        <div>
          <h3 className="text-sm font-semibold">Something went wrong</h3>
          <p className="text-sm text-muted mt-1">{error.message || 'An unexpected error occurred'}</p>
          <button onClick={onRetry} className="text-sm text-primary hover:underline mt-3 font-medium">
            Try again →
          </button>
        </div>
      </div>
    </div>
  );
}
```

### Full-Page Error
```tsx
function FullPageError({ statusCode = 500 }: { statusCode?: number }) {
  const messages: Record<number, { title: string; description: string }> = {
    404: { title: 'Page not found', description: 'The page you\'re looking for doesn\'t exist or has been moved.' },
    403: { title: 'Access denied', description: 'You don\'t have permission to view this page.' },
    500: { title: 'Server error', description: 'Something went wrong on our end. We\'re working on it.' },
    503: { title: 'Under maintenance', description: 'We\'ll be back shortly. Thanks for your patience.' },
  };

  const msg = messages[statusCode] || messages[500];

  return (
    <div className="min-h-screen flex items-center justify-center px-[--page-gutter]">
      <div className="text-center max-w-md">
        <p className="text-[10rem] font-bold text-muted/10 leading-none select-none">
          {statusCode}
        </p>
        <h1 className="text-2xl font-bold mt-8 mb-2">{msg.title}</h1>
        <p className="text-muted mb-8">{msg.description}</p>
        <div className="flex gap-3 justify-center">
          <a href="/" className="btn-primary">Go home</a>
          <button onClick={() => window.location.reload()} className="btn-ghost">Refresh</button>
        </div>
      </div>
    </div>
  );
}
```

---

## 5. Offline & Connectivity States

```tsx
function useOnlineStatus() {
  const [online, setOnline] = useState(navigator.onLine);

  useEffect(() => {
    const goOnline = () => setOnline(true);
    const goOffline = () => setOnline(false);
    window.addEventListener('online', goOnline);
    window.addEventListener('offline', goOffline);
    return () => {
      window.removeEventListener('online', goOnline);
      window.removeEventListener('offline', goOffline);
    };
  }, []);

  return online;
}

function OfflineBanner() {
  const online = useOnlineStatus();

  return (
    <AnimatePresence>
      {!online && (
        <motion.div
          initial={{ height: 0, opacity: 0 }}
          animate={{ height: 'auto', opacity: 1 }}
          exit={{ height: 0, opacity: 0 }}
          className="bg-warning/10 border-b border-warning/20 overflow-hidden"
        >
          <div className="max-w-7xl mx-auto px-[--page-gutter] py-2 flex items-center justify-center gap-2 text-sm">
            <WifiOff size={14} className="text-warning" />
            <span>You're offline. Changes will sync when reconnected.</span>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
```

---

## 6. Rate Limit / Too Many Requests

```tsx
function RateLimitState({ retryAfter }: { retryAfter: number }) {
  const [countdown, setCountdown] = useState(retryAfter);

  useEffect(() => {
    if (countdown <= 0) return;
    const timer = setInterval(() => setCountdown(c => c - 1), 1000);
    return () => clearInterval(timer);
  }, [countdown]);

  return (
    <div className="flex flex-col items-center py-16 px-6 text-center">
      <div className="w-16 h-16 rounded-full bg-warning/10 flex items-center justify-center mb-5">
        <Clock size={24} className="text-warning" />
      </div>
      <h3 className="text-lg font-semibold mb-1">Too many requests</h3>
      <p className="text-sm text-muted mb-4">
        Please wait {countdown} seconds before trying again
      </p>
      {countdown === 0 && (
        <button onClick={() => window.location.reload()} className="btn-primary">
          Try again
        </button>
      )}
    </div>
  );
}
```

---

## 7. Progressive Loading Patterns

### Stale-While-Revalidate (show cached, update in background)
```tsx
function StaleDataView() {
  const { data, isFetching, isStale } = useQuery({
    queryKey: ['dashboard'],
    queryFn: fetchDashboard,
    staleTime: 30_000,
    placeholderData: keepPreviousData, // show old data while fetching
  });

  return (
    <div className="relative">
      {isStale && (
        <div className="absolute top-0 left-0 right-0 h-0.5 bg-primary/50 animate-pulse z-10" />
      )}
      {isFetching && !data && <DashboardSkeleton />}
      {data && <Dashboard data={data} />}
    </div>
  );
}
```

### Optimistic Empty → Loaded Transition
```tsx
function OptimisticList() {
  const [items, setItems] = useState<Item[]>([]);
  const [optimistic, setOptimistic] = useState<Item[]>([]);

  const addItem = (newItem: Item) => {
    // Instantly show in UI
    setOptimistic(prev => [...prev, newItem]);

    // Then persist
    saveItem(newItem).then(saved => {
      setOptimistic(prev => prev.filter(i => i.id !== newItem.id));
      setItems(prev => [...prev, saved]);
    });
  };

  if (items.length === 0 && optimistic.length === 0) {
    return <EmptyFirstUse icon={<Plus />} title="Add your first item" description="Get started by adding an item" action={{ label: 'Add item', onClick: () => addItem({ id: crypto.randomUUID(), label: 'New item' }) }} />;
  }

  return (
    <ul>
      {items.map(item => <ItemRow key={item.id} item={item} />)}
      {optimistic.map(item => <ItemRow key={item.id} item={item} optimistic />)}
    </ul>
  );
}
```

---

## 8. Permission / Access Denied

```tsx
function PermissionGate({
  requiredPermission,
  fallback = <AccessDenied />,
  children,
}: {
  requiredPermission: string;
  fallback?: React.ReactNode;
  children: React.ReactNode;
}) {
  const { permissions } = useAuth();

  if (!permissions.includes(requiredPermission)) return <>{fallback}</>;
  return <>{children}</>;
}

function AccessDenied() {
  return (
    <div className="flex flex-col items-center py-20 text-center">
      <div className="w-20 h-20 rounded-2xl bg-muted/10 flex items-center justify-center mb-6">
        <Lock size={32} className="text-muted" />
      </div>
      <h2 className="text-xl font-bold mb-2">Access denied</h2>
      <p className="text-muted text-sm max-w-md mb-6">
        You don't have permission to view this page. Contact your administrator if you need access.
      </p>
      <a href="/" className="btn-ghost">Back to home</a>
    </div>
  );
}
```

---

## 9. Data Not Yet Available (Processing / Generating)

```tsx
function ProcessingState({ estimatedMinutes }: { estimatedMinutes: number }) {
  return (
    <div className="flex flex-col items-center py-16 text-center">
      <motion.div
        animate={{ rotate: 360 }}
        transition={{ repeat: Infinity, duration: 3, ease: 'linear' }}
        className="w-16 h-16 rounded-full border-2 border-primary/20 border-t-primary mb-5"
      />
      <h3 className="text-lg font-semibold mb-1">Processing your data</h3>
      <p className="text-sm text-muted mb-4">
        Estimated time: {estimatedMinutes} min
      </p>
      <div className="w-64 h-2 bg-muted/10 rounded-full overflow-hidden">
        <motion.div
          className="h-full bg-primary rounded-full"
          animate={{ width: ['0%', '70%', '85%', '95%'] }}
          transition={{ repeat: Infinity, duration: 4, ease: 'easeInOut' }}
        />
      </div>
    </div>
  );
}
```

---

## 10. State Checklist (Per Component)

```
Before shipping any component, verify all states:

□ LOADING — Skeleton/spinner shown on first load
□ EMPTY (first use) — Inspiring message + CTA
□ EMPTY (no results) — Helpful suggestions + redirection
□ EMPTY (cleared) — Reassurance + undo option
□ IDEAL — Data loaded, everything works
□ ERROR (network) — Retry button, offline message
□ ERROR (server) — Error details (non-sensitive), contact/retry
□ ERROR (permission) — Access denied with explanation
□ PARTIAL — Some data loaded, pagination works
□ OVERFLOW — Too much data handled (pagination/virtual scroll)
□ STALE — Background refresh indicator
□ REDUCED MOTION — Animations disabled for accessibility
```
