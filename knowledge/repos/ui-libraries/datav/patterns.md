# DataV — Patterns

## 平台

**Vue 2 only.** 专为大屏数据展示设计。

## 适用场景

- 数据大屏 / 可视化看板
- 监控中心
- 大屏展示
- 数据驾驶舱

## 不适用场景

- 普通后台管理系统（用 Shineout / Ant Design）
- 移动端（用 Beeshell）
- React 项目（用 DataV-React）

## 组件分类

```
容器: FullScreenContainer
加载: Loading
边框: borderBox1-13 (SVG 动态边框)
装饰: decoration1-12 (SVG 装饰元素)
图表: Charts + 10 种专用图表
```

## Design Language

DataV 的视觉风格专为**大屏数据展示**设计：
- 深色背景为主
- SVG 霓虹/发光边框
- 数字翻牌器动效
- 飞线图用于地理/关系可视化
- 轮播表用于实时数据滚动

## react-tool 知识库整合

### Web 端大屏项目技术栈
```
核心组件: DataV-React (React 版)
数据组件: Shineout (Table, Form)
动效增强: react-bits (入场动画, 背景)
```

### 与知识库现有资源的关系

| 库 | 关系 |
|------|------|
| **DataV-React** | React 移植版（建议训练） |
| **react-bits** | 动画层可叠加（如 FadeContent 包裹 DataV 图表） |
| **Shineout** | 大屏中的表格/表单用 Shineout |
| **animal-island-ui** | 不兼容（风格冲突） |

## 后续行动

1. 训练 **DataV-React** (https://github.com/DataV-Team/DataV-React) — React 版本的 DataV
2. 如需要 Vue 大屏项目，直接用 DataV（本库）
3. React 项目中需要大屏效果 → 用 DataV-React + react-bits 动画增强
