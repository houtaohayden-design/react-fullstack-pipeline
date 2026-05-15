# DataV-React — API Reference

> @jiaminghi/data-view-react v1.2.5 | React 大屏数据可视化 | React >= 16.8

## Setup

```bash
npm install @jiaminghi/data-view-react
```

```tsx
import {
  FullScreenContainer, Loading,
  BorderBox1, Decoration1,
  Charts, ActiveRingChart, CapsuleChart,
  WaterLevelPond, PercentPond,
  FlylineChart, FlylineChartEnhanced,
  ConicalColumnChart, DigitalFlop,
  ScrollBoard, ScrollRankingBoard,
  useAutoResize
} from '@jiaminghi/data-view-react'
```

## Components (38 total)

### 容器 & 基础
- **FullScreenContainer** — 全屏自适应容器，内部元素等比缩放
- **Loading** — 加载动画组件

### SVG 边框 (BorderBox1-13)
13 种动态 SVG 边框，适合卡片/面板装饰。

所有 BorderBox 支持 `width`, `height`, `color`, `backgroundColor` 等通用 props。

### SVG 装饰 (Decoration1-12)
12 种 SVG 装饰元素，适合背景/空位填充。

### 图表 (11 种)
- **Charts** — 通用图表（折线图等），基于 @jiaminghi/charts
- **ActiveRingChart** — 动态环形图，`data`, `color`, `radius`
- **CapsuleChart** — 胶囊柱状图，`data`, `colors`
- **WaterLevelPond** — 水位图/水球图，`data`, `shape` (rect/circle/roundRect)
- **PercentPond** — 百分比池，`value`, `colors`
- **FlylineChart** — 飞线图（地点间飞线动画），`data`, `centerPoint`, `dev`
- **FlylineChartEnhanced** — 增强飞线图，更多配置选项
- **ConicalColumnChart** — 锥形柱状图，`data`, `img`
- **DigitalFlop** — 数字翻牌器，`data`, `config`
- **ScrollBoard** — 轮播表，`data`, `config`
- **ScrollRankingBoard** — 轮播排名表，`data`, `config`

### Hooks
- **useAutoResize(ref)** — 自动监听容器尺寸变化
