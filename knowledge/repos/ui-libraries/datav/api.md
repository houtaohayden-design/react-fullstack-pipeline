# DataV — API Reference

> @jiaminghi/data-view v2.10.0 | Vue 2 大屏数据可视化组件库

**重要：Vue 组件库，非 React。** React 版本见 https://github.com/DataV-Team/DataV-React

## Setup

```bash
npm install @jiaminghi/data-view
```

```js
import Vue from 'vue'
import DataV from '@jiaminghi/data-view'
Vue.use(DataV)

// 按需引入
import { borderBox1 } from '@jiaminghi/data-view'
Vue.use(borderBox1)
```

## Components

### 容器
- **FullScreenContainer** — 全屏容器，自适应缩放

### Loading
- **Loading** — 加载动画

### 边框 (13 种)
`borderBox1` ~ `borderBox13` — SVG 动态边框装饰

### 装饰 (12 种)
`decoration1` ~ `decoration12` — SVG 装饰元素

### 图表
- **Charts** — 折线图等通用图表
- **ActiveRingChart** — 动态环形图
- **CapsuleChart** — 胶囊柱状图
- **WaterLevelPond** — 水位图
- **PercentPond** — 百分比池
- **FlylineChart** — 飞线图
- **FlylineChartEnhanced** — 增强版飞线图
- **ConicalColumnChart** — 锥形柱状图
- **DigitalFlop** — 数字翻牌器
- **ScrollBoard** — 轮播表
- **ScrollRankingBoard** — 轮播排名表

## React 版本

https://github.com/DataV-Team/DataV-React
- 同名 React 移植版
- 如使用 React，直接用 DataV-React 而非本库
