# React Full-Stack Pipeline v2.0

Complete React development lifecycle: brainstorming → worktrees → plan → subagent-dev → TDD → code-review → deploy → backend.

## Skills (20 total)

### Process Pipeline
| Skill | When |
|-------|------|
| `react-pipeline:bootstrap` | 会话入口，自动路由 |
| `react-pipeline:brainstorming` | 构建/创建 React 应用前 |
| `react-pipeline:git-worktrees` | 开始功能开发前 |
| `react-pipeline:writing-plans` | 头脑风暴通过后 |
| `react-pipeline:subagent-dev` | 执行实施计划 |
| `react-pipeline:tdd` | 编写实现代码前 |
| `react-pipeline:code-review` | 任务间/合并前 |
| `react-pipeline:finish-branch` | 所有任务完成时 |

### React Domain
| Skill | When |
|-------|------|
| `react-pipeline:react-tool` | 写 React 代码 |
| `react-pipeline:train-repo` | 喂 GitHub 链接训练知识库 |
| `react-pipeline:component-design` | 设计新组件 |
| `react-pipeline:styling-system` | CSS/主题架构决策 |

### Deployment
| Skill | When |
|-------|------|
| `react-pipeline:server-setup` | 配置服务器 |
| `react-pipeline:frontend-deploy` | 部署前端 |
| `react-pipeline:docker-setup` | 容器化 |
| `react-pipeline:ci-cd` | CI/CD 管道 |

### Backend
| Skill | When |
|-------|------|
| `react-pipeline:backend-api` | 构建 API |
| `react-pipeline:database` | 数据库设计 |
| `react-pipeline:auth` | 认证授权 |
| `react-pipeline:api-client` | 前端 API 集成 |

## Agents (6 types)
- **react-implementer** — Execute single task from plan
- **react-spec-reviewer** — Verify impl matches spec
- **react-code-reviewer** — Code quality review
- **react-trainer** — Train GitHub repos into knowledge base
- **react-deployer** — Deploy and configure servers
- **react-backend-engineer** — Build backend APIs

## Knowledge Base
- `knowledge/registry.json` — Repository index (14 trained, 12 categories)
- `knowledge/repos/<category>/<slug>/` — Structured knowledge (api.md + patterns.md)
- Builtin: animal-island-ui (17 components), react-bits (110+ animations)
- Trained: shineout, beeshell, datav, datav-react, rn-guide, react-hook-form, zustand, ahooks, tanstack-table, dnd-kit, tanstack-query, react-router, framer-motion, swr

## Server Stack (recommended)
- **Frontend hosting**: Vercel (managed) or Nginx on VPS ($4/mo)
- **Backend**: Hono (fastest, edge-native) or Fastify (high-perf Node)
- **Database**: SQLite+WAL (small) or PostgreSQL/Supabase (scaling)
- **CI/CD**: GitHub Actions
- **Container**: Docker + docker-compose
