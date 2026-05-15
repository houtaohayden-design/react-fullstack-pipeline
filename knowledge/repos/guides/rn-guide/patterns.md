# React Native Guide — Patterns

## 定位

React Native 中文社区的学习指南资源库。不是组件库，而是**知识地图**——指向教程、开源APP、组件库和工具的索引。

## 使用场景

### 适合：
- 学习 React Native 时查找教程和示例
- 寻找 React Native 开源项目作为参考
- 了解 RN 生态中的组件库和工具
- 解决 RN 特定问题（布局、通信、原生桥接）

### 不适合：
- 直接获取组件 API（用具体组件库）
- 开箱即用的代码（这是索引，不是实现）

## react-tool 知识库整合

该指南引用的以下组件库在知识库中可组合使用：

### Web 端
- **Shineout** — 企业级 React Web 组件库（知识库中已训练）
- **react-bits** — 动画动效库

### React Native 端
- **Beeshell** — 美团 React Native 组件库（知识库中已训练）
- 指南推荐的库（待训练）：react-native-paper, react-native-elements, Shoutem

## RN 项目技术栈建议（基于指南）

```
导航: react-native-router-flux 或 React Navigation
UI组件: react-native-paper / react-native-elements / beeshell
状态管理: Redux / MobX
网络: rn-fetch-blob
轮播: react-native-swiper
模态框: react-native-modal
```

## 与知识库现有库的关系

| 知识库已有 | 平台 | 指南中对应 |
|-----------|------|-----------|
| beeshell | RN | 美团内部组件库，移动端企业级 |
| shineout | Web | 无直接对应（Shineout是Web） |
| react-bits | Web | 无直接对应（react-bits是动效） |

## 后续可训练目标

指南中推荐的 RN 组件库，适合逐一训练：
1. `react-native-paper` — Material Design 组件库（最推荐，GitHub stars 多）
2. `react-native-elements` — 跨平台 UI 工具包
3. `BlankApp UI` — 高可定制组件库
4. `Shoutem UI` — 样式组件库
