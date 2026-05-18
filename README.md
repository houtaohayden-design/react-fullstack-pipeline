# React Full-Stack Development Pipeline

> Claude Code Plugin — 23 skills, 8 agents, 63 trained entries, 20 website design systems.
> Complete React development lifecycle from brainstorming to backend deployment.

[![Version](https://img.shields.io/badge/version-2.3.0-blue)](https://github.com/houtaohayden-design/react-fullstack-pipeline)
[![Skills](https://img.shields.io/badge/skills-23-brightgreen)]()
[![Agents](https://img.shields.io/badge/agents-8-orange)]()
[![Knowledge](https://img.shields.io/badge/knowledge-63-purple)]()
[![Websites](https://img.shields.io/badge/websites-20-pink)]()

---

## 简介

一个 Claude Code 插件，自动化完整的 React 开发工作流。受 [Superpowers](https://github.com/obra/superpowers) 插件架构启发，提供从需求分析到生产部署的结构化流水线。

**核心能力：**
- **引导式开发** — 需求 → 设计 → 规划 → 编码 → 审查 → 部署
- **知识库优先** — 写代码前先查 63 个已训练条目（35 前端库 + 5 后端框架 + 4 设计方法论 + 20 网站设计系统）
- **三路径训练** — GitHub 前端仓库（4D提取）+ 网站设计系统提取 + GitHub 后端仓库（4D提取）
- **并行代理** — 独立任务自动并行调度 8 种子代理执行
- **一键部署** — Vercel / Cloudflare Pages / VPS / Docker

---

## 工作流

```
用户请求 → bootstrap(路由) → brainstorming(需求设计) → writing-plans(实施计划)
    → subagent-dev(并行子代理执行) → TDD → code-review → finish-branch → deploy
```

---

## 技能列表 (23 skills)

### 流程管道 (9)

| 技能 | 说明 | 何时触发 |
|------|------|----------|
| `bootstrap` | 会话入口，自动识别意图并路由到对应技能 | 每个会话开始时自动运行 |
| `brainstorming` | **一次性展示完整视觉目录**：3套基础设计系统(CSS预览卡片) + 16种艺术风格(矩阵表格) + 12套字体 + 8种布局 + 20个网站设计灵感 | "创建一个 React 应用"、"添加一个功能" |
| `git-worktrees` | 创建隔离的 git worktree 进行功能开发 | 开始写代码前 |
| `writing-plans` | 将设计拆分为小粒度的可验证任务，支持依赖排序和并行分组 | 设计审批通过后 |
| `subagent-dev` | 调度专业子代理执行计划任务，支持并行分发 | 有计划任务要执行时 |
| `tdd` | 测试驱动开发：红 → 绿 → 重构循环 | 编写实现代码前 |
| `code-review` | 五轴代码审查：正确性、可读性、架构、安全性、性能 | 任务完成后 / 合并前 |
| `visual-check` | 浏览器视觉验证：截图对比、响应式检查、滚动动画验证 | 合并前 / 部署后 |
| `finish-branch` | 完成开发分支：合并、PR、清理 | 所有任务完成时 |

### React 领域 (5)

| 技能 | 说明 | 何时触发 |
|------|------|----------|
| `react-tool` | 写 React 代码前自动查询知识库（63 个条目），匹配合适的组件和模式 | 写任何 React/前端代码 |
| `train-repo` | 训练 GitHub 前端仓库：克隆 → 4D提取(API+Patterns+Interactions+Tokens) → 写入知识库 | 提供 GitHub 库链接 |
| `train-website` | 提取网站设计系统：全维度分析(布局+配色+字体+动效+交互+组件)，含负责任的抓取策略 | 提供网站 URL |
| `component-design` | 设计组件接口：Props、组合模式、无障碍 | 设计新组件时 |
| `styling-system` | CSS 架构 / 主题系统 / 响应式策略 | 设计样式系统时 |

### 部署 (4)

| 技能 | 说明 | 何时触发 |
|------|------|----------|
| `server-setup` | 配置 VPS：Nginx、SSL、防火墙、进程管理 | 需要自托管部署 |
| `frontend-deploy` | 前端部署：构建 → 上传 → CDN → 验证 | 部署 React 应用到生产环境 |
| `docker-setup` | 生成 Dockerfile + docker-compose.yml | 需要容器化部署 |
| `ci-cd` | 生成 GitHub Actions 工作流 | 需要 CI/CD 管道 |

### 后端 (5)

| 技能 | 说明 | 何时触发 |
|------|------|----------|
| `backend-api` | 构建 REST/GraphQL API（Hono / Fastify / Express） | 需要后端 API |
| `database` | 数据库设计：Schema、ORM（Drizzle / Prisma）、迁移 | 需要数据库 |
| `auth` | 认证授权：JWT、OAuth、RBAC | 需要用户认证 |
| `api-client` | 前端 API 集成：TanStack Query、tRPC | 前后端对接 |
| `train-backend` | 训练 GitHub 后端仓库（500+ stars）：4D提取(API+Patterns+Backend+API-Design) | 提供后端库链接 |

---

## 子代理 (8 types)

| 代理 | 职责 | 阶段 |
|------|------|------|
| `react-implementer` | 执行单个任务（组件、Hooks、页面），支持并行分组调度 | 实现 |
| `react-spec-reviewer` | 验证实现是否匹配设计规格 | 审查 Stage 1 |
| `react-code-reviewer` | 代码质量审查：Hooks 规则、无障碍、性能 | 审查 Stage 2 |
| `react-trainer` | 训练前端仓库：克隆 → 探索 → 提取 → 生成知识库文件（4D提取） | 训练 |
| `react-design-learner` | 从网站提取完整设计系统（布局、配色、字体、动效、交互、组件） | 训练 |
| `react-backend-learner` | 搜索并训练后端仓库（500+ stars）：API框架、ORM、认证、数据库工具 | 训练 |
| `react-deployer` | 构建 → 配置 → 部署 → 验证 | 部署 |
| `react-backend-engineer` | 构建 API 端点、数据库 Schema、认证流程 | 后端 |

---

## 知识库 (63 个已训练条目)

### UI 组件库
| 库 | 组件数 | 链接 |
|----|--------|------|
| shineout | 41 | [github.com/sheinsight/shineout](https://github.com/sheinsight/shineout) |
| beeshell | 30 | [github.com/Meituan-Dianping/beeshell](https://github.com/Meituan-Dianping/beeshell) |
| datav-react | 38 | [github.com/datav-team/datav-react](https://github.com/datav-team/datav-react) |
| shadcn/ui | 50+ | [ui.shadcn.com](https://ui.shadcn.com) |
| radix-primitives | 28 | [radix-ui.com](https://www.radix-ui.com) |
| mantine | 100+ | [mantine.dev](https://mantine.dev) |
| nextui | 30+ | [nextui.org](https://nextui.org) |
| animal-island-ui | 17 | 内置（动物森友会风格组件库） |

### 状态管理
| 库 | 链接 |
|----|------|
| zustand | [github.com/pmndrs/zustand](https://github.com/pmndrs/zustand) |
| jotai | [github.com/pmndrs/jotai](https://github.com/pmndrs/jotai) |
| redux-toolkit | [redux-toolkit.js.org](https://redux-toolkit.js.org) |

### 数据获取
| 库 | 链接 |
|----|------|
| tanstack-query | [tanstack.com/query](https://tanstack.com/query) |
| swr | [swr.vercel.app](https://swr.vercel.app) |

### 表单 & 表格
| 库 | 链接 |
|----|------|
| react-hook-form | [react-hook-form.com](https://react-hook-form.com) |
| tanstack-table | [tanstack.com/table](https://tanstack.com/table) |
| downshift | [github.com/downshift-js/downshift](https://github.com/downshift-js/downshift) |

### Hooks / 工具
| 库 | Hooks 数 | 链接 |
|----|----------|------|
| ahooks | 85+ | [ahooks.js.org](https://ahooks.js.org) |
| react-use | 80+ | [github.com/streamich/react-use](https://github.com/streamich/react-use) |
| usehooks-ts | 30+ | [usehooks-ts.com](https://usehooks-ts.com) |

### 动画 & 特效
| 库 | 组件/效果数 | 链接 |
|----|------------|------|
| framer-motion | — | [framermotion.framer.website](https://framermotion.framer.website) |
| react-bits | 110+ | 内置（文字动画、背景特效、交互组件） |

### 拖拽
| 库 | 链接 |
|----|------|
| dnd-kit | [dndkit.com](https://dndkit.com) |

### 路由
| 库 | 链接 |
|----|------|
| react-router | [reactrouter.com](https://reactrouter.com) |

### 图表
| 库 | 链接 |
|----|------|
| recharts | [recharts.org](https://recharts.org) |

### 通知
| 库 | 链接 |
|----|------|
| sonner | [sonner.emilkowal.ski](https://sonner.emilkowal.ski) |

### 无障碍
| 库 | 链接 |
|----|------|
| react-aria | [react-spectrum.adobe.com/react-aria](https://react-spectrum.adobe.com/react-aria) |

---

## 设计系统 (23 份规格文档)

`knowledge/design-systems/` 目录包含完整的设计参考文档，在 brainstorming 阶段自动提供给用户选择：

| 文档 | 内容 |
|------|------|
| [typography-layout.md](knowledge/design-systems/typography-layout.md) | 12 种字体配对、8 种布局系统、流体排版 |
| [color-theory.md](knowledge/design-systems/color-theory.md) | 色彩空间、6 种和声规则、3 层调色板、深色模式、WCAG 对比度 |
| [motion-design.md](knowledge/design-systems/motion-design.md) | Disney 12 原则、缓动曲线、弹簧物理、滚动驱动动画 |
| [artistic-styles.md](knowledge/design-systems/artistic-styles.md) | 8 种视觉风格：新野兽派、侘寂、新拟态、合成波、装饰艺术等 |
| [artistic-styles-2.md](knowledge/design-systems/artistic-styles-2.md) | 8 种进阶风格：暗黑学院、液态玻璃、北欧极简、赛博朋克、孟菲斯等 |
| [ui-patterns.md](knowledge/design-systems/ui-patterns.md) | 60+ UI 模式：卡片、导航、加载、空状态、搜索、模态框 |
| [text-design.md](knowledge/design-systems/text-design.md) | 动态排版、渐变文字、3D CSS 文字、打字机效果、故障效果 |
| [landing-patterns.md](knowledge/design-systems/landing-patterns.md) | 8 种 Hero 模式、功能展示区、定价表、FAQ、页脚 |
| [form-design.md](knowledge/design-systems/form-design.md) | 输入框解构、4 种风格变体、5 种验证状态、多步骤向导 |
| [background-patterns.md](knowledge/design-systems/background-patterns.md) | 7 种 CSS 纯背景图案、噪点纹理、网格渐变、浮动 blob |
| [data-viz-design.md](knowledge/design-systems/data-viz-design.md) | 12 色调色板、图表解构、Recharts 主题、仪表盘布局 |
| [responsive-patterns.md](knowledge/design-systems/responsive-patterns.md) | 内容断点、容器查询、流体排版、移动优先模式 |
| [navigation-design.md](knowledge/design-systems/navigation-design.md) | 7 种导航类型、⌘K 命令面板、自适应移动端导航 |
| [button-design.md](knowledge/design-systems/button-design.md) | 8 种按钮变体、5 种尺寸、加载状态、图标按钮、FAB |
| [modal-dialog-design.md](knowledge/design-systems/modal-dialog-design.md) | 模态框类型、尺寸预设、焦点陷阱、动画变体 |
| [empty-states-design.md](knowledge/design-systems/empty-states-design.md) | 状态矩阵、骨架屏、错误状态、离线横幅、12 步检查清单 |
| [search-experience.md](knowledge/design-systems/search-experience.md) | 搜索栏变体、自动完成、分面搜索、过滤芯片 |
| [iconography-design.md](knowledge/design-systems/iconography-design.md) | 图标尺寸系统、5 个库对比、动画图标、无障碍规则 |
| [feedback-patterns.md](knowledge/design-systems/feedback-patterns.md) | Toast 系统、进度条、工具提示、Popover、复制反馈 |
| [onboarding-patterns.md](knowledge/design-systems/onboarding-patterns.md) | 8 种引导模式、偏好选择器、聚焦覆盖层、激活指标 |
| [glassmorphism-hybrid.md](knowledge/design-systems/glassmorphism-hybrid.md) | 玻璃拟态混合风格完整规格 |
| [enhanced-animal-island.md](knowledge/design-systems/enhanced-animal-island.md) | 动物森友会增强版风格规格 |
| [shadcn-professional.md](knowledge/design-systems/shadcn-professional.md) | shadcn/ui 专业现代风格规格 |

---

## 网站设计灵感 (20 个生产级网站)

`knowledge/websites/<slug>/design-system.md` — 从真实生产网站完整提取的设计系统（色彩、字体、间距、组件、动效、交互模式）：

| # | 网站 | 风格特征 |
|---|------|----------|
| 1 | Apple | SF Pro、全出血产品图、单一蓝色强调色 |
| 2 | Stripe | Sohne Variable 300w、靛蓝 #533afd、双层阴影 |
| 3 | Linear | 暗色精准、单一靛蓝 #7170ff、边框深度 |
| 4 | Vercel | Geist 字体、黑色画布、几何图形主题 |
| 5 | GitHub | Mona Sans VF、12 主题无障碍、CSS 纯动画 |
| 6 | Supabase | 暗色主题、翡翠绿 #3ECF8E、HSL token 架构 |
| 7 | Notion | 2890+ CSS 属性、4 层 token、56 种排版变体 |
| 8 | Figma | 40 列网格、ABC Whyte Plus、150ms 微交互 |
| 9 | Framer | GT Walsheim、75+ token、玻璃表面、Framer Motion |
| 10 | Arc | 多彩渐变、灰白基调、Instrument Sans + Inter |
| 11 | Raycast | 暗色 #07080a、单一蓝色、27 CSS 关键帧、8px 网格 |
| 12 | Airbnb | 珊瑚红 #FF385C、Cereal VF 字体、弹簧物理 |
| 13 | DJI | 暗色高级感、中英双语、2px 圆角精度 |
| 14 | Xiaomi | 全黑 + 橙色、MiSans 字体、视口缩放排版 |
| 15 | Tailwind CSS | 天空蓝强调色、透明度层次、4 字体 CLS 策略 |
| 16 | Algolia | 暗色 SaaS、蓝紫渐变、Sora + Inter |
| 17 | Spotify | 暗色 #121212、Encore Design System、SpotifyMixUI |
| 18 | Hermès | 暖米色 #fcf7f1、橙色点缀、EB Garamond 斜体、零圆角 |
| 19 | Porsche | 暗色奢华、Porsche Next 字体、流体 clamp() 系统 |
| 20 | Rimowa | 德式极简、铝槽纹理主题、单色调、瑞士排版 |

---

## 设计方法论 (4 个框架)

| # | 技能 | 内容 |
|---|------|------|
| 1 | gstack | 80 项设计审计清单、SAFE/RISK 框架、AI 模板检测、浏览器 QA |
| 2 | impeccable | 25 条反模式规则、OKLCH 色彩、类别反射检查、6 条绝对设计禁令 |
| 3 | taste-skill | 108 条反模式、13 种认可风格、弹簧物理要求、完整交互周期 |
| 4 | ui-ux-pro-max | 67 种 UI 风格、161 色调色板、57 种字体配对、99 条 UX 指南、34 种落地页模式 |

---

## 已知踩坑 (来自生产流水线验证)

完整列表见 [CLAUDE.md](CLAUDE.md) Known Gotchas 章节。关键项：

| # | 类别 | 问题 | 解决 |
|---|------|------|------|
| 1 | Vite + TS | `verbatimModuleSyntax` 默认开启 → 类型导入报错 | 使用 `import type { X }` |
| 2 | Vite + TS | `strict: true` 未开启 → null 检查缺失 | 脚手架时启用 |
| 3 | Canvas 2D | rAF 内设置 width/height → 每帧重分配后备存储 | 使用 ResizeObserver |
| 4 | framer-motion | MotionValue 放入 rAF deps → 每帧重建循环 | 使用 useRef |
| 5 | Canvas 2D | 模块级可变状态 → HMR 残留 / 测试泄漏 | 使用闭包或重置器 |
| 6 | Subagent | 创意项目用微任务 → 54+ 次调用开销过大 | 创意项目用大任务，CRUD 项目用微任务 |

---

## 技术栈

| 层级 | 推荐 | 备选 |
|------|------|------|
| **前端框架** | React 18+ (Vite) | Next.js |
| **前端部署** | [Vercel](https://vercel.com) / [Cloudflare Pages](https://pages.cloudflare.com) | Nginx on VPS |
| **后端框架** | [Hono](https://hono.dev) (14KB, edge-native) | Fastify, Express |
| **数据库** | SQLite+WAL (小型) | PostgreSQL ([Supabase](https://supabase.com) / [Neon](https://neon.tech)) |
| **ORM** | [Drizzle](https://orm.drizzle.team) (类型安全 SQL) | Prisma, Kysely |
| **CI/CD** | GitHub Actions | — |
| **容器** | Docker + docker-compose | — |

---

## 项目结构

```
react-frontend-tool/
├── .claude-plugin/
│   └── plugin.json              # 插件身份、子代理类型定义
├── hooks/                       # SessionStart 钩子系统
│   ├── hooks.json
│   ├── run-hook.cmd
│   └── session-start/           # 会话启动时注入 bootstrap
├── skills/                      # 23 个技能
│   ├── bootstrap/               # 入口：意图识别和路由
│   ├── brainstorming/           # 需求 → 视觉目录(CSS预览) → 设计文档
│   ├── git-worktrees/           # 隔离工作空间
│   ├── writing-plans/           # 拆分实施计划（支持 depends_on + parallel_group）
│   ├── subagent-dev/            # 子代理调度 + 并行分发
│   ├── tdd/                     # 测试驱动开发 + 模式参考
│   ├── code-review/             # 两阶段审查 + Canvas/创意编码检查
│   ├── visual-check/            # 浏览器视觉验证、截图对比、滚动动画检查
│   ├── finish-branch/           # 合并/PR/清理选项
│   ├── react-tool/              # 知识库优先编码
│   ├── train-repo/              # 训练 GitHub 前端仓库（4D提取）
│   ├── train-website/           # 提取网站设计系统
│   ├── component-design/        # Props、组合、无障碍
│   ├── styling-system/          # CSS 架构
│   ├── server-setup/            # VPS、Nginx、SSL
│   ├── frontend-deploy/         # 前端构建部署
│   ├── docker-setup/            # 容器化
│   ├── ci-cd/                   # GitHub Actions + 3 个工作流模板
│   ├── backend-api/             # REST API (Hono/Express/Fastify)
│   ├── database/                # Schema、ORM (Drizzle/Prisma)
│   ├── auth/                    # JWT、OAuth、RBAC
│   ├── api-client/              # TanStack Query、tRPC
│   └── train-backend/           # 训练 GitHub 后端仓库（4D提取）
├── knowledge/
│   ├── registry.json            # 主索引（63 条目、16 分类）
│   ├── repos/<category>/<slug>/ # 前端仓库知识（api.md + patterns.md）
│   ├── websites/<slug>/         # 20 个网站设计系统提取
│   ├── design-systems/          # 23 份设计规格文档
│   ├── design-skills/<slug>/    # 4 个设计方法论框架
│   └── lessons-learned/         # 项目经验教训
├── docs/
│   ├── diagrams/                # Mermaid .mmd 源文件
│   └── screenshots/             # 截图
├── scripts/                     # 自动化脚本
├── CLAUDE.md                    # 项目说明
└── README.md                    # 本文件
```

---

## 安装

```bash
# 克隆到 Claude Code 插件目录
git clone https://github.com/houtaohayden-design/react-fullstack-pipeline.git \
  "<你的插件目录>/react-frontend-tool"

# Claude Code 会自动发现 skills 和 hooks
```

---

## 快速开始

1. **安装插件** 到 Claude Code 插件目录
2. **启动会话** — bootstrap 技能通过 SessionStart 钩子自动加载
3. **说出你的需求：**
   - "创建一个 React 管理后台" → 触发 brainstorming 流水线
   - "写一个带拖拽的 Todo 列表" → 触发 react-tool（先查知识库）
   - "部署到生产环境" → 触发 server-setup + frontend-deploy
   - "训练这个库：https://github.com/..." → 触发 train-repo

---

## 引用项目

本插件整合和参考了以下开源项目：

| 项目 | 用途 | 链接 |
|------|------|------|
| **Superpowers** | 插件架构、Skills/Agents 系统 | [github.com/obra/superpowers](https://github.com/obra/superpowers) |
| **animal-island-ui** | 内置 UI 组件库（动森风格） | 同作者维护 |
| **react-bits** | 内置动画特效库（110+ 效果） | [reactbits.dev](https://reactbits.dev) |
| **shadcn/ui** | UI 组件架构参考 | [ui.shadcn.com](https://ui.shadcn.com) |
| **Vercel** | 前端部署平台 | [vercel.com](https://vercel.com) |
| **Hono** | 后端框架 | [hono.dev](https://hono.dev) |
| **Drizzle ORM** | 数据库 ORM | [orm.drizzle.team](https://orm.drizzle.team) |

---

## 训练新库

使用 `train-repo` 技能或 `/react-tool-train` 命令：

```
用户: https://github.com/pmndrs/jotai
插件: [train-repo] 正在克隆... 探索中... 生成 api.md + patterns.md...
      → 已添加到 knowledge/repos/state-management/jotai/
      → 已更新 registry.json
      → 完成。Jotai（原子化状态管理）现在可在 react-tool 中使用。
```

---

## 贡献

### 添加新技能
1. 创建 `skills/<skill-name>/SKILL.md`（含 YAML frontmatter）
2. 在 bootstrap SKILL.md 中添加交叉引用
3. 如涉及子代理，添加代理提示模板

### 训练新库
1. 使用 `train-repo` 技能并提供 GitHub URL
2. `react-trainer` 子代理将自动克隆、探索并提取知识
3. api.md + patterns.md 被添加到知识库

---

