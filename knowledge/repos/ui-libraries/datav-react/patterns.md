# DataV-React — Patterns

## 平台

**React Web.** DataV 的 React 移植版，API 保持一致。

## 适用场景

- 数据大屏 / 可视化看板
- 监控中心 / 运营驾驶舱
- 展会大屏 / 数据展示

## 与 react-bits 配合

DataV-React 负责数据可视化，react-bits 负责 UI 动画增强：

```
大屏页面
├── FullScreenContainer
├── BorderBox1-13 (SVG 边框)
├── Charts + 专用图表 (数据展示)
├── Decoration1-12 (SVG 装饰背景)
└── react-bits (入场动画、粒子背景、文字特效)
```

**组合示例：**
```tsx
<FullScreenContainer>
  <FadeContent from={reactBits}>  {/* react-bits 入场动画 */}
    <BorderBox1>
      <DigitalFlop data={sales} />
    </BorderBox1>
  </FadeContent>
</FullScreenContainer>
```

## 与 Shineout 配合

大屏中的数据表格部分用 Shineout Table：
```tsx
<BorderBox2 title="订单明细">
  <Table data={orders} columns={cols} keygen="id" bordered />
</BorderBox2>
```

## 设计约定

- **深色背景**为主（深蓝、深紫、深灰）
- SVG 边框用**霓虹/发光色**（青、蓝、紫、黄）
- 数字翻牌器用于核心 KPI 展示
- 飞线图用于地理/拓扑关系
- 轮播表用于实时数据滚动

## 知识库中大屏项目技术栈

```
容器: DataV-React FullScreenContainer + useAutoResize
边框: DataV-React BorderBox (13选N)
数据: DataV-React 图表 + Shineout Table
动效: react-bits (FadeContent, particle backgrounds)
```
