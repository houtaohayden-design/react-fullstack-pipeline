# Recharts — API Reference

## Setup
```bash
npm install recharts
```

---

## Chart Types (12 total)

All chart components share common props: `data` (array of objects), `margin` (`{ top, right, bottom, left }`), `width`, `height`, `className`, `style`, and mouse event handlers (`onClick`, `onMouseMove`, `onMouseEnter`, `onMouseLeave`, `onMouseDown`, `onMouseUp`).

---

### Cartesian Charts (X/Y axes)

#### LineChart
Minimal usage:
```tsx
<LineChart width={500} height={300} data={data}>
  <CartesianGrid strokeDasharray="3 3" />
  <XAxis dataKey="name" />
  <YAxis />
  <Tooltip />
  <Legend />
  <Line type="monotone" dataKey="pv" stroke="#8884d8" />
</LineChart>
```
- **Tooltip event type:** `axis` only
- **Props:** `CartesianChartProps` — data, margin, width, height, children, syncId, layout (horizontal/vertical)

#### BarChart
Minimal usage:
```tsx
<BarChart width={500} height={300} data={data}>
  <CartesianGrid strokeDasharray="3 3" />
  <XAxis dataKey="name" />
  <YAxis />
  <Tooltip />
  <Legend />
  <Bar dataKey="pv" fill="#8884d8" />
</BarChart>
```
- **Tooltip event types:** `axis`, `item`
- **Props:** Same as LineChart

#### AreaChart
Minimal usage:
```tsx
<AreaChart width={500} height={300} data={data}>
  <CartesianGrid strokeDasharray="3 3" />
  <XAxis dataKey="name" />
  <YAxis />
  <Tooltip />
  <Area type="monotone" dataKey="uv" stroke="#8884d8" fill="#8884d8" />
</AreaChart>
```
- **Tooltip event types:** `axis`, `item`
- **Area props:** `type`, `dataKey`, `stroke`, `fill`, `fillOpacity`, `stackId`

#### ComposedChart
Minimal usage:
```tsx
<ComposedChart width={500} height={300} data={data}>
  <XAxis dataKey="name" />
  <YAxis />
  <Tooltip />
  <Legend />
  <CartesianGrid />
  <Bar dataKey="pv" fill="#8884d8" />
  <Line type="monotone" dataKey="uv" stroke="#ff7300" />
  <Area type="monotone" dataKey="amt" fill="#8884d8" stroke="#8884d8" />
</ComposedChart>
```
- **Purpose:** Mix different chart types (Bar + Line + Area) in one chart

#### ScatterChart
Minimal usage:
```tsx
<ScatterChart width={500} height={300}>
  <CartesianGrid />
  <XAxis dataKey="x" name="x" />
  <YAxis dataKey="y" name="y" />
  <Tooltip cursor={{ strokeDasharray: '3 3' }} />
  <Scatter name="A school" data={data} fill="#8884d8" />
</ScatterChart>
```

---

### Polar Charts (radial/angular)

#### PieChart
Minimal usage:
```tsx
<PieChart width={400} height={400}>
  <Pie data={data} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={80} fill="#8884d8" label>
    {data.map((_entry, index) => <Cell key={index} fill={COLORS[index % COLORS.length]} />)}
  </Pie>
  <Tooltip />
  <Legend />
</PieChart>
```
- **Pie props:** `data`, `dataKey`, `nameKey`, `cx`, `cy`, `innerRadius` (donut), `outerRadius`, `startAngle`, `endAngle`, `label`, `labelLine`, `paddingAngle`, `activeShape`, `activeIndex`

#### RadarChart
Minimal usage:
```tsx
<RadarChart outerRadius="80%" width={500} height={500} data={data}>
  <PolarGrid />
  <PolarAngleAxis dataKey="subject" />
  <PolarRadiusAxis angle={30} domain={[0, 150]} />
  <Radar name="Mike" dataKey="A" stroke="#8884d8" fill="#8884d8" fillOpacity={0.6} />
  <Legend />
</RadarChart>
```
- **Tooltip event type:** `axis`

#### RadialBarChart
Minimal usage:
```tsx
<RadialBarChart width={500} height={300} cx="50%" cy="50%" innerRadius="10%" outerRadius="80%" data={data}>
  <RadialBar dataKey="uv" fill="#8884d8" label={{ position: 'insideStart' }} />
  <Legend />
  <Tooltip />
</RadialBarChart>
```
- **Tooltip event type:** `axis`
- **Props:** `cx`, `cy`, `startAngle`, `endAngle`, `innerRadius`, `outerRadius`

---

### Specialized Charts

#### FunnelChart
Minimal usage:
```tsx
<FunnelChart width={500} height={300}>
  <Tooltip />
  <Funnel dataKey="value" data={data}>
    <LabelList position="right" fill="#000" stroke="none" />
  </Funnel>
</FunnelChart>
```

#### Treemap
Minimal usage:
```tsx
<Treemap width={500} height={300} data={data} dataKey="size" />
```

#### Sankey
Minimal usage:
```tsx
<Sankey width={500} height={300} data={{ nodes: [...], links: [...] }}>
  <Tooltip />
</Sankey>
```

#### SunburstChart
Minimal usage:
```tsx
<SunburstChart width={500} height={500} data={data} />
```

---

## Axes & Grid Components

### XAxis / YAxis
```tsx
<XAxis dataKey="name" tick={{ fontSize: 12 }} label={{ value: "X Label", position: "bottom" }} />
<YAxis domain={[0, 'auto']} tickFormatter={(v) => `${v}%`} />
```
- **Key props:** `dataKey`, `tick`, `tickFormatter`, `tickCount`, `domain`, `label`, `orientation`, `hide`, `allowDecimals`, `interval`, `padding`, `scale`, `type` (number/category)

### ZAxis
```tsx
<ZAxis dataKey="size" range={[10, 100]} scale="log" />
```

### CartesianGrid
```tsx
<CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#ccc" />
```

### ReferenceLine / ReferenceArea / ReferenceDot
```tsx
<ReferenceLine x={3000} stroke="red" label="Max" />
<ReferenceArea x1={2000} x2={4000} fill="#eee" fillOpacity={0.3} />
<ReferenceDot x={3000} y={4000} r={20} fill="red" />
```
- **Key props:** `x`, `y`, `stroke`, `label`, `ifOverflow` (visible/hidden/extendDomain/discard)

---

## Graphical Elements

### Line
```tsx
<Line type="monotone" dataKey="pv" stroke="#8884d8" strokeWidth={2} dot={false} activeDot={{ r: 8 }} />
```
- **Key props:** `type` (basis/monotone/natural/linear/step), `dataKey`, `stroke`, `strokeWidth`, `dot`, `activeDot`, `name`, `hide`, `animationBegin`, `animationDuration`

### Bar
```tsx
<Bar dataKey="pv" fill="#8884d8" barSize={20} radius={[4, 4, 0, 0]} stackId="a" />
```
- **Key props:** `dataKey`, `fill`, `barSize`, `maxBarSize`, `radius`, `stackId`, `name`, `hide`, `background`, `label`

### Area
```tsx
<Area type="monotone" dataKey="uv" stroke="#8884d8" fill="#c3c3e8" fillOpacity={0.6} stackId="1" />
```
- **Key props:** `type`, `dataKey`, `stroke`, `fill`, `fillOpacity`, `stackId`, `dot`, `activeDot`, `name`, `hide`

### Scatter
```tsx
<Scatter name="A" data={data} fill="#8884d8" shape="star" />
```

### Funnel
```tsx
<Funnel dataKey="value" data={data} fill="#8884d8" />
```

### Pie
```tsx
<Pie data={data} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={80} label />
```

### Radar
```tsx
<Radar dataKey="A" stroke="#8884d8" fill="#8884d8" fillOpacity={0.6} />
```

### RadialBar
```tsx
<RadialBar dataKey="uv" fill="#8884d8" cornerRadius={10} />
```

---

## Tooling Components

### Tooltip
```tsx
<Tooltip
  contentStyle={{ backgroundColor: '#fff', border: '1px solid #ccc' }}
  formatter={(value) => [`${value}%`, 'Rate']}
  labelFormatter={(label) => `Year: ${label}`}
  cursor={{ stroke: 'red', strokeWidth: 1 }}
  position={{ x: 100, y: 50 }}
/>
```
- **Key props:** `content` (React element or render function), `contentStyle`, `formatter`, `labelFormatter`, `itemStyle`, `labelStyle`, `wrapperStyle`, `separator` (default `' : '`), `offset` (default 10), `cursor` (true/false/element), `shared`, `trigger` (hover/click), `filterNull`, `active`, `position`, `allowEscapeViewBox`, `isAnimationActive`, `animationDuration`, `animationEasing`

### Legend
```tsx
<Legend
  verticalAlign="top"
  height={36}
  formatter={(value) => <span className="text-blue-600">{value}</span>}
  onClick={(entry) => console.log(entry)}
/>
```
- **Key props:** `verticalAlign` (top/bottom/middle), `align` (left/center/right), `layout` (horizontal/vertical), `iconSize`, `iconType` (line/rect/circle/cross/diamond/square/star/triangle/wye), `formatter`, `content`, `wrapperStyle`

### Brush
```tsx
<Brush dataKey="name" height={30} stroke="#8884d8" startIndex={0} endIndex={10} />
```

### Label / LabelList
```tsx
<Label value="Revenue over time" position="top" offset={10} />
<LabelList dataKey="name" position="insideTop" />
```

### Cell (for per-segment styling)
```tsx
<Pie data={data}>
  {data.map((entry, index) => <Cell key={index} fill={COLORS[index]} />)}
</Pie>
```

### Customized
```tsx
<Customized component={<text>Hello</text>} />
<Customized component={(props) => <g>{/* custom drawing */}</g>} />
```

---

## Layout & Container

### ResponsiveContainer
```tsx
<ResponsiveContainer width="100%" height={400}>
  <LineChart data={data}>
    {/* ... */}
  </LineChart>
</ResponsiveContainer>
```
- **Key props:** `width` (default `'100%'`), `height` (default `'100%'`), `aspect`, `minWidth`, `minHeight`, `maxHeight`, `debounce`, `className`, `onResize`
- **Critical:** Always wrap charts in ResponsiveContainer for responsive layouts

---

## Hooks (exported for advanced use)

Recharts exports internal selectors as hooks for custom tooltips and advanced integrations:
- `useActiveTooltipLabel`, `useActiveTooltipDataPoints`, `useActiveTooltipCoordinate`
- `useIsTooltipActive`, `useOffset`, `usePlotArea`
- `useXAxisDomain`, `useYAxisDomain`, `useXAxisScale`, `useYAxisScale`
- `useXAxisTicks`, `useYAxisTicks`
- `useChartHeight`, `useChartWidth`, `useMargin`, `useChartLayout`

Also exports utility functions: `getNiceTickValues`, `getRelativeCoordinate`, `interpolate`.

---

## Data Shape

All cartesian chart `data` expects an array of objects:
```tsx
const data = [
  { name: 'Jan', uv: 4000, pv: 2400, amt: 2400 },
  { name: 'Feb', uv: 3000, pv: 1398, amt: 2210 },
  // ...
]
```

PieChart data:
```tsx
const data = [
  { name: 'Group A', value: 400 },
  { name: 'Group B', value: 300 },
]
```

Sankey data:
```tsx
const data = {
  nodes: [{ name: 'A' }, { name: 'B' }, { name: 'C' }],
  links: [{ source: 0, target: 1, value: 10 }, { source: 1, target: 2, value: 20 }],
}
```

---

## Styling

- **Colors:** Use `stroke` for lines, `fill` for areas/bars. Recharts auto-generates colors if none specified.
- **Custom colors:** Pass `stroke`/`fill` hex values or use `Cell` for per-segment coloring in Pie.
- **CSS:** All components accept `className`. Use `contentStyle`, `wrapperStyle`, `itemStyle`, `labelStyle` on Tooltip/Legend.
- **Responsiveness:** Always use `ResponsiveContainer` with percentage-based `width`/`height`.
- **Animations:** Control via `isAnimationActive`, `animationDuration`, `animationEasing`, `animationBegin` props.
