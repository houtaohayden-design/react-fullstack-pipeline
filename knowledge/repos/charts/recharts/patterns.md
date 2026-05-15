# Recharts — Patterns & Best Practices

## Core Patterns

### 1. ResponsiveContainer Wrapper (ALWAYS use this)
Never hardcode pixel dimensions for production charts. ALWAYS wrap in ResponsiveContainer:
```tsx
// Good: responsive
<ResponsiveContainer width="100%" height={300}>
  <LineChart data={data}>
    {/* ... */}
  </LineChart>
</ResponsiveContainer>

// Good: with Tailwind
<div className="w-full h-64">
  <ResponsiveContainer>
    <BarChart data={data}>
      {/* ... */}
    </BarChart>
  </ResponsiveContainer>
</div>

// Bad: hardcoded
<LineChart width={500} height={300} data={data}>
```

### 2. Tailwind Integration
Use Tailwind classes on the container div, not on chart components:
```tsx
<div className="w-full h-80">
  <ResponsiveContainer>
    <PieChart>
      <Tooltip content={<CustomTooltip />} />
      {/* SVG elements don't use Tailwind classes */}
    </PieChart>
  </ResponsiveContainer>
</div>
```

### 3. Custom Tooltips (render function pattern)
```tsx
const CustomTooltip = ({ active, payload, label }) => {
  if (!active || !payload?.length) return null

  return (
    <div className="bg-white border rounded-lg shadow-lg p-3">
      <p className="font-semibold text-gray-700">{label}</p>
      {payload.map((entry, index) => (
        <p key={index} style={{ color: entry.color }}>
          {entry.name}: {entry.value}
        </p>
      ))}
    </div>
  )
}

// Usage
<Tooltip content={<CustomTooltip />} />
// Or as a render function directly:
<Tooltip content={(props) => <CustomTooltip {...props} />} />
```

### 4. Per-Segment Colors with Cell (Pie charts)
```tsx
const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042']

<PieChart>
  <Pie data={data} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={80}>
    {data.map((_entry, index) => (
      <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
    ))}
  </Pie>
</PieChart>
```

### 5. Multiple Series in One Chart
```tsx
<LineChart data={data}>
  <Line type="monotone" dataKey="uv" stroke="#8884d8" name="UV Index" />
  <Line type="monotone" dataKey="pv" stroke="#82ca9d" name="Page Views" />
  <Line type="monotone" dataKey="amt" stroke="#ffc658" name="Amount" />
</LineChart>
```

### 6. Mixed Chart Types (ComposedChart)
```tsx
<ComposedChart data={data}>
  <XAxis dataKey="name" />
  <YAxis />
  <Bar dataKey="pv" fill="#413ea0" barSize={20} />
  <Line type="monotone" dataKey="uv" stroke="#ff7300" />
  <Area type="monotone" dataKey="amt" fill="#8884d8" stroke="#8884d8" />
</ComposedChart>
```

### 7. Stacked Bars
```tsx
<BarChart data={data}>
  <XAxis dataKey="name" />
  <YAxis />
  <Bar dataKey="uv" stackId="a" fill="#8884d8" />
  <Bar dataKey="pv" stackId="a" fill="#82ca9d" />
  <Bar dataKey="amt" stackId="a" fill="#ffc658" />
</BarChart>
```

### 8. Donut Chart (Pie with innerRadius)
```tsx
<PieChart>
  <Pie
    data={data}
    dataKey="value"
    cx="50%"
    cy="50%"
    innerRadius={60}
    outerRadius={80}
    paddingAngle={5}
    label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
  >
    {data.map((entry, index) => (
      <Cell key={index} fill={COLORS[index % COLORS.length]} />
    ))}
  </Pie>
</PieChart>
```

### 9. Synchronized Charts (syncId)
Multiple charts that share tooltip hover state:
```tsx
<div>
  <LineChart syncId="anyString" data={data}>
    <Line dataKey="pv" />
  </LineChart>
  <BarChart syncId="anyString" data={data}>
    <Bar dataKey="uv" />
  </BarChart>
</div>
```

### 10. Animations Control
```tsx
// Disable all animations
<Line isAnimationActive={false} />

// Customize animation
<Bar
  animationBegin={200}
  animationDuration={1500}
  animationEasing="ease-out"
/>

// Tooltip animation
<Tooltip isAnimationActive={false} />
```

### 11. Reference Lines for Thresholds
```tsx
<LineChart data={data}>
  <ReferenceLine y={4000} stroke="red" strokeDasharray="3 3" label="Target" />
  <ReferenceLine x="Page C" stroke="green" label="Min" />
  <ReferenceArea x1="Page A" x2="Page C" fill="#eee" fillOpacity={0.3} />
</LineChart>
```

### 12. Formatting Axis Labels
```tsx
<YAxis
  tickFormatter={(value) => `$${value.toLocaleString()}`}
  domain={[0, 'dataMax + 1000']}
/>
<XAxis
  dataKey="date"
  tickFormatter={(value) => new Date(value).toLocaleDateString()}
/>
```

### 13. Conditional Dot Rendering
```tsx
// Hide dots, show only on hover
<Line dot={false} activeDot={{ r: 8, fill: '#8884d8' }} />

// Custom dot renderer
<Line
  dot={(props: any) => {
    const { cx, cy, value } = props
    if (value > 2000) return <circle cx={cx} cy={cy} r={6} fill="red" />
    return <circle cx={cx} cy={cy} r={4} fill="#8884d8" />
  }}
/>
```

### 14. Empty State / No Data
```tsx
{data.length === 0 ? (
  <div className="flex items-center justify-center h-64 text-gray-400">
    No data available
  </div>
) : (
  <ResponsiveContainer width="100%" height={300}>
    <BarChart data={data}>
      {/* ... */}
    </BarChart>
  </ResponsiveContainer>
)}
```

---

## Common Data Patterns

### Line/Bar/Area data shape
```tsx
const chartData = [
  { name: 'Mon', sales: 4000, orders: 2400 },
  { name: 'Tue', sales: 3000, orders: 1398 },
  // Each object = one x-axis tick
  // dataKey maps to the property used for that series
]
```

### Pie data shape
```tsx
const pieData = [
  { name: 'Direct', value: 400 },
  { name: 'Referral', value: 300 },
  { name: 'Organic', value: 300 },
]
```

### Scatter data shape
```tsx
const scatterData = [
  { x: 100, y: 200, z: 20 },
  { x: 120, y: 100, z: 30 },
]
```

---

## Anti-Patterns

- **Don't forget ResponsiveContainer** — charts without it won't resize on window change
- **Don't use inline pixel width/height** — use the ResponsiveContainer parent div instead
- **Don't use Tailwind classes directly on SVG elements** — Recharts renders SVG; use stroke/fill props
- **Don't mutate data prop directly** — create new array reference for React re-render
- **Don't nest charts** — Recharts does not support chart-in-chart composition
- **Don't use `useLayoutEffect`-based sizing inside chart children** — use `ResponsiveContainer`
