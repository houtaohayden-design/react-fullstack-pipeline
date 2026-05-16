# Data Visualization Design — Premium Chart Styling & Dashboards

Charts as visual storytelling. Color palettes, chart anatomy, dashboard layouts, and interactive patterns for premium data display.

---

## 1. Data Color Palettes

### Categorical (qualitative data — distinct categories)
```css
:root {
  /* 12-color categorical — perceptually distinct, colorblind-safe */
  --data-cat-1: #4e79a7;   /* blue */
  --data-cat-2: #f28e2b;   /* orange */
  --data-cat-3: #e15759;   /* red */
  --data-cat-4: #76b7b2;   /* teal */
  --data-cat-5: #59a14f;   /* green */
  --data-cat-6: #edc948;   /* yellow */
  --data-cat-7: #b07aa1;   /* purple */
  --data-cat-8: #ff9da7;   /* pink */
  --data-cat-9: #9c755f;   /* brown */
  --data-cat-10: #bab0ac;  /* gray */
  --data-cat-11: #86bcb6;  /* mint */
  --data-cat-12: #d4a6c8;  /* lavender */
}
```

### Sequential (quantitative — low to high)
```css
:root {
  /* Blue sequential — trust, professional */
  --data-seq-blue-1: #f0f6fc;
  --data-seq-blue-2: #c6dbf0;
  --data-seq-blue-3: #9ec5e8;
  --data-seq-blue-4: #6baed6;
  --data-seq-blue-5: #4292c6;
  --data-seq-blue-6: #2171b5;
  --data-seq-blue-7: #08519c;
  --data-seq-blue-8: #08306b;

  /* Green sequential — growth, positive */
  --data-seq-green-1: #f0faf0;
  --data-seq-green-2: #c6e8c6;
  --data-seq-green-3: #9ed69e;
  --data-seq-green-4: #6bc46b;
  --data-seq-green-5: #42a842;
  --data-seq-green-6: #218a21;
  --data-seq-green-7: #086b08;
  --data-seq-green-8: #004d00;
}
```

### Divergent (bipolar — -N to +N, above/below average)
```css
:root {
  /* Red-White-Blue divergent */
  --data-div-rdbu-1: #b2182b;  /* most negative */
  --data-div-rdbu-2: #d6604d;
  --data-div-rdbu-3: #f4a582;
  --data-div-rdbu-4: #fddbc7;
  --data-div-rdbu-5: #f7f7f7;  /* neutral */
  --data-div-rdbu-6: #d1e5f0;
  --data-div-rdbu-7: #92c5de;
  --data-div-rdbu-8: #4393c3;
  --data-div-rdbu-9: #2166ac;  /* most positive */
}
```

### Highlight / Threshold
```css
/* Use vibrant color against muted data for emphasis */
.highlight-bar { fill: var(--color-primary); }
.normal-bar    { fill: rgba(var(--foreground-rgb), 0.15); }

/* Above threshold → green, below → red */
.above-threshold { fill: var(--color-success); }
.below-threshold { fill: var(--color-error); }
```

---

## 2. Chart Anatomy & Styling

### The 7 Chart Elements to Style
```
1. AXES           → minimal, lighter than data
2. GRID LINES     → subtle, barely visible
3. LABELS         → readable, consistent color
4. DATA MARKS     → prominent, brand colors
5. TOOLTIPS       → premium glass, informative
6. LEGEND         → interactive, compact
7. TITLE/SUBTITLE → clear hierarchy
```

### Recharts Theme Configuration
```tsx
const premiumChartTheme = {
  // Axes: subtle, not distracting
  axis: {
    stroke: 'var(--color-border)',
    strokeWidth: 1,
    tickLine: false,
    tick: { fill: 'var(--color-muted)', fontSize: 12 },
  },
  // Grid: barely visible
  grid: {
    stroke: 'rgba(var(--foreground-rgb), 0.05)',
    strokeDasharray: '3 3',
    vertical: false, // horizontal grid only
  },
  // Tooltip: premium glass
  tooltip: {
    contentStyle: {
      background: 'rgba(var(--surface-rgb), 0.95)',
      backdropFilter: 'blur(12px)',
      border: '1px solid var(--color-border)',
      borderRadius: 'var(--radius-md)',
      boxShadow: 'var(--shadow-lg)',
      padding: '12px 16px',
      fontSize: '13px',
    },
    labelStyle: { fontWeight: 600, marginBottom: 4 },
  },
};

// Usage
<ResponsiveContainer>
  <LineChart data={data}>
    <CartesianGrid stroke="rgba(0,0,0,0.04)" strokeDasharray="3 3" />
    <XAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: 'var(--color-muted)' }} />
    <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 12, fill: 'var(--color-muted)' }} />
    <Tooltip content={<PremiumTooltip />} />
    <Line type="monotone" dataKey="value" stroke="var(--color-primary)" strokeWidth={2.5} dot={false} activeDot={{ r: 4 }} />
  </LineChart>
</ResponsiveContainer>
```

### Premium Tooltip Component
```tsx
function PremiumTooltip({ active, payload, label }: TooltipProps) {
  if (!active || !payload) return null;
  return (
    <div className="bg-surface/95 backdrop-blur-xl border border-border rounded-xl shadow-xl px-4 py-3 text-sm">
      <p className="text-xs text-muted mb-1">{label}</p>
      {payload.map((p: any, i: number) => (
        <div key={i} className="flex items-center gap-2">
          <div className="w-2 h-2 rounded-full" style={{ backgroundColor: p.color }} />
          <span className="font-semibold tabular-nums">{p.value.toLocaleString()}</span>
          <span className="text-muted text-xs">{p.name}</span>
        </div>
      ))}
    </div>
  );
}
```

---

## 3. Chart Type Selection Guide

| Data Relationship | Chart Type | When to Use |
|------------------|------------|-------------|
| **Trend over time** | Line, Area | Time-series, continuous data |
| **Comparison** | Bar (horizontal), Column (vertical) | Discrete categories |
| **Part-to-whole** | Donut, Stacked Bar, Treemap | Composition, percentages |
| **Distribution** | Histogram, Box Plot, Violin | Statistical spread |
| **Correlation** | Scatter, Bubble | Relationship between 2-3 variables |
| **Ranking** | Bar (sorted), Lollipop | Ordered comparison |
| **Flow/Process** | Sankey, Funnel, Gantt | Movement, stages |
| **Geospatial** | Choropleth, Heatmap | Geographic data |

### Chart Decision Tree
```
How many variables?
  1 variable
    Categorical → Bar chart (horizontal for long labels)
    Time-series → Line chart (smooth) or Area (volume emphasis)
    Part-of-whole → Donut (≤5 segments) or Treemap (many segments)

  2 variables
    Both continuous → Scatter plot (correlation) or Bubble chart (3rd var = size)
    One time, one value → Line chart
    Two categorical → Heatmap

  3+ variables
    Scatter matrix, Parallel coordinates, Radar chart
```

---

## 4. Dashboard Layout Architecture

### The 4 Dashboard Layouts

**A. Analytical Dashboard** (3-tier: summary → detail → drill-down)
```
┌───────────────────────────────────────┐
│  KPI Row: [Metric 1] [Metric 2] [3] [4] │  ← Summary stats
├───────────────────┬───────────────────┤
│                   │                   │
│  Main Chart       │  Secondary Chart  │  ← Primary view
│  (line, large)    │  (bar, donut)     │
│                   │                   │
├───────────────────┴───────────────────┤
│  Detail Table / Drill-down Data        │  ← Detail view
└───────────────────────────────────────┘
```

**B. Monitoring Dashboard** (real-time, alert-driven)
```tsx
function MonitoringDashboard() {
  return (
    <div className="grid grid-cols-12 gap-4">
      {/* Status Banner — full width */}
      <div className="col-span-12 bg-surface border rounded-xl p-4 flex items-center gap-4">
        <StatusDot status="healthy" />
        <span>All systems operational</span>
        <span className="text-muted text-sm ml-auto">Updated 2s ago</span>
      </div>

      {/* KPI Cards */}
      {metrics.map(m => (
        <KpiCard key={m.label} {...m} className="col-span-3" />
      ))}

      {/* Main Timeline */}
      <div className="col-span-8 bg-surface border rounded-xl p-5">
        <SectionHeader title="Response Time (24h)" />
        <LineChart data={timelineData} />
      </div>

      {/* Alert Feed */}
      <div className="col-span-4 bg-surface border rounded-xl p-5">
        <SectionHeader title="Recent Alerts" />
        <AlertFeed alerts={alerts} />
      </div>
    </div>
  );
}
```

**C. Reporting Dashboard** (static, print-friendly, export-ready)
```
┌───────────────────────────────────────┐
│  Report Header + Date Range Picker     │
├───────────────────┬───────────────────┤
│  KPI Card Grid    │  Pie/Donut        │
│  (4-6 metrics)    │  (composition)    │
├───────────────────┴───────────────────┤
│  Full-width Table (sortable, paginated)│
└───────────────────────────────────────┘
```

**D. Embedded Dashboard** (compact, context-specific)
```
Small card (300-400px wide):
  - Sparkline (tiny trend)
  - Primary number (large)
  - Delta indicator (▲ 12%)
  - Time range label
```

---

## 5. KPI / Metric Card Component

```tsx
interface KpiProps {
  label: string;
  value: number;
  prefix?: string;
  suffix?: string;
  change?: number; // percentage change
  changeLabel?: string;
  sparklineData?: number[];
  variant?: 'default' | 'success' | 'warning' | 'error';
}

function KpiCard({ label, value, prefix, suffix, change, changeLabel, sparklineData, variant = 'default' }: KpiProps) {
  const isPositive = change && change > 0;
  const isNegative = change && change < 0;

  return (
    <div className="bg-surface border rounded-xl p-5 hover:shadow-md transition-shadow duration-200">
      <div className="flex items-start justify-between mb-3">
        <p className="text-sm text-muted">{label}</p>
        {variant !== 'default' && (
          <div className={`w-2 h-2 rounded-full bg-${variant === 'success' ? 'success' : variant === 'warning' ? 'warning' : 'error'}`} />
        )}
      </div>

      <div className="flex items-baseline gap-1">
        {prefix && <span className="text-2xl text-muted">{prefix}</span>}
        <span className="text-3xl font-bold tabular-nums">{value.toLocaleString()}</span>
        {suffix && <span className="text-lg text-muted ml-0.5">{suffix}</span>}
      </div>

      {(change !== undefined) && (
        <div className="flex items-center gap-1 mt-2">
          <span className={`text-sm font-medium ${isPositive ? 'text-success' : isNegative ? 'text-error' : 'text-muted'}`}>
            {isPositive ? '▲' : isNegative ? '▼' : '—'} {Math.abs(change)}%
          </span>
          {changeLabel && <span className="text-xs text-muted">{changeLabel}</span>}
        </div>
      )}

      {sparklineData && (
        <div className="mt-3 h-10">
          <Sparkline data={sparklineData} positive={isPositive ?? true} />
        </div>
      )}
    </div>
  );
}
```

### Sparkline (tiny inline chart)
```tsx
function Sparkline({ data, positive }: { data: number[]; positive: boolean }) {
  return (
    <ResponsiveContainer width="100%" height={40}>
      <LineChart data={data.map((v, i) => ({ v }))}>
        <Line
          type="monotone"
          dataKey="v"
          stroke={positive ? 'var(--color-success)' : 'var(--color-error)'}
          strokeWidth={1.5}
          dot={false}
          isAnimationActive={false}
        />
      </LineChart>
    </ResponsiveContainer>
  );
}
```

---

## 6. Interactive Chart Patterns

### Zoomable Timeline
```tsx
function ZoomableTimeline({ data }: { data: any[] }) {
  const [refArea, setRefArea] = useState<{ left: number; right: number } | null>(null);

  return (
    <ResponsiveContainer width="100%" height={300}>
      <AreaChart
        data={data}
        onMouseDown={(e: any) => e && setRefArea({ left: e.activeLabel, right: e.activeLabel })}
        onMouseMove={(e: any) => refArea && setRefArea(prev => ({ ...prev!, right: e.activeLabel }))}
        onMouseUp={() => {
          if (refArea && refArea.left !== refArea.right) {
            // Zoom to selected range
            const [start, end] = [Math.min(refArea.left, refArea.right), Math.max(refArea.left, refArea.right)];
            console.log('Zoom to:', start, end);
          }
          setRefArea(null);
        }}
      >
        <CartesianGrid strokeDasharray="3 3" stroke="rgba(0,0,0,0.04)" />
        <XAxis dataKey="date" />
        <YAxis />
        <Tooltip content={<PremiumTooltip />} />
        <Area type="monotone" dataKey="value" stroke="var(--color-primary)" fill="url(#gradient)" fillOpacity={0.15} />
        {refArea && (
          <ReferenceArea x1={refArea.left} x2={refArea.right} fill="rgba(var(--primary-rgb), 0.08)" />
        )}
      </AreaChart>
    </ResponsiveContainer>
  );
}
```

### Animated Number Counter
```tsx
function AnimatedCounter({ value, duration = 1.5 }: { value: number; duration?: number }) {
  const count = useMotionValue(0);
  const rounded = useTransform(count, v => Math.round(v).toLocaleString());

  useEffect(() => {
    const controls = animate(count, value, { duration, ease: [0.22, 1, 0.36, 1] });
    return controls.stop;
  }, [value]);

  return <motion.span className="tabular-nums font-bold">{rounded}</motion.span>;
}
```

---

## 7. Dark Mode Charts

```css
[data-theme='dark'] {
  /* Chart-specific dark mode tokens */
  --chart-bg: transparent;
  --chart-grid: rgba(255, 255, 255, 0.04);
  --chart-axis: rgba(255, 255, 255, 0.15);
  --chart-text: rgba(255, 255, 255, 0.5);

  /* Adjust data colors for dark backgrounds */
  /* Same hue, higher lightness to maintain visibility */
  --data-seq-blue-1: #08306b;
  --data-seq-blue-8: #deebf7;
}
```

### Dark Mode Chart Wrapper
```tsx
function ChartCard({ title, subtitle, children, menu }: {
  title: string;
  subtitle?: string;
  children: React.ReactNode;
  menu?: React.ReactNode;
}) {
  return (
    <div className="bg-surface border rounded-xl p-5">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h3 className="text-sm font-semibold">{title}</h3>
          {subtitle && <p className="text-xs text-muted mt-0.5">{subtitle}</p>}
        </div>
        {menu && <div>{menu}</div>}
      </div>
      <div className="h-[280px]">
        {children}
      </div>
    </div>
  );
}
```

---

## 8. Data Table (Premium)

```tsx
function DataTable<T extends Record<string, any>>({
  columns,
  data,
  sortable = true,
}: {
  columns: { key: string; label: string; align?: 'left' | 'center' | 'right'; format?: (v: any) => string }[];
  data: T[];
  sortable?: boolean;
}) {
  const [sort, setSort] = useState<{ key: string; dir: 'asc' | 'desc' } | null>(null);

  const sorted = sort
    ? [...data].sort((a, b) => {
        const cmp = a[sort.key] < b[sort.key] ? -1 : a[sort.key] > b[sort.key] ? 1 : 0;
        return sort.dir === 'asc' ? cmp : -cmp;
      })
    : data;

  return (
    <div className="overflow-x-auto rounded-xl border">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-muted/5 border-b">
            {columns.map(col => (
              <th
                key={col.key}
                onClick={() => sortable && setSort(s => s?.key === col.key
                  ? { key: col.key, dir: s.dir === 'asc' ? 'desc' : 'asc' }
                  : { key: col.key, dir: 'asc' }
                )}
                className={`px-4 py-3 text-xs font-semibold text-muted uppercase tracking-wider
                  ${col.align === 'right' ? 'text-right' : col.align === 'center' ? 'text-center' : 'text-left'}
                  ${sortable ? 'cursor-pointer hover:text-foreground select-none' : ''}
                `}
              >
                <span className="inline-flex items-center gap-1">
                  {col.label}
                  {sort?.key === col.key && (
                    <span className="text-[10px]">{sort.dir === 'asc' ? '▲' : '▼'}</span>
                  )}
                </span>
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {sorted.map((row, i) => (
            <tr key={i} className="border-b last:border-0 hover:bg-muted/3 transition-colors">
              {columns.map(col => (
                <td
                  key={col.key}
                  className={`px-4 py-3 ${col.align === 'right' ? 'text-right tabular-nums' : col.align === 'center' ? 'text-center' : ''}`}
                >
                  {col.format ? col.format(row[col.key]) : row[col.key]}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
```

---

## 9. Accessibility for Charts

```
✓ Every chart has a text summary (aria-label or adjacent caption)
✓ Color is never the only differentiator (use patterns + labels + shapes)
✓ Min contrast 3:1 between adjacent data colors
✓ Keyboard-navigable tooltips (focusable, Esc to close)
✓ Print-friendly: charts render with visible labels on white background
✓ Reduced motion: disable chart animations when prefers-reduced-motion
```

### Accessible Chart Wrapper
```tsx
function AccessibleChart({ title, description, children }: {
  title: string;
  description: string;
  children: React.ReactNode;
}) {
  return (
    <figure role="img" aria-label={description}>
      <figcaption className="text-sm font-semibold mb-2">{title}</figcaption>
      <div aria-hidden="true">{children}</div>
      <details className="mt-3 text-xs text-muted">
        <summary>View data table</summary>
        {/* Fallback data table for screen readers */}
      </details>
    </figure>
  );
}
```

---

## 10. Chart Anti-Patterns

```
❌ 3D charts (distorted perspective, harder to read)
❌ Pie charts with 6+ segments (use bar chart instead)
❌ Dual Y-axes (misleading correlations)
❌ Truncated Y-axis (exaggerates differences — start at 0 for bar charts)
❌ Rainbow color schemes (use purposeful palettes)
❌ Too many grid lines (max 5 horizontal lines)
❌ Animated charts that re-animate on every render
❌ Missing axis labels or legends
```

### The 5-Second Rule
```
A dashboard viewer should understand the key insight in 5 seconds.
If they can't — the visualization is too complex.

Fix: Add a KPI summary row above the chart.
Fix: Highlight the trend direction with a colored arrow.
Fix: Add a one-line insight caption: "Revenue up 23% vs. last quarter"
```
