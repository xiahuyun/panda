# Panda Mobile 架构记录

更新时间: 2026-03-11

## 记录规则

1. 每完成一个重要功能或里程碑后，若模块边界或依赖关系发生变化，必须更新本文件。
2. 重点记录以下内容：
   - 页面/组件/服务模块划分
   - 关键依赖关系
   - 新增或调整的设计决策
   - 对测试与维护性的影响

## 当前架构（MVP）

1. 页面层：`LoginPage`、`AffinityWallActivePage`
2. 数据层：本地 mock（`panda-mobile/mock/affinity-profiles.mock.json`）
3. 样式层：`tokens/panda.tokens.json` 为唯一真源
4. 运行时：`uni-app x + Vue 3 + UTS/.uvue`

## 架构变更记录

> 示例模板（复制后填写）  
> 日期: YYYY-MM-DD  
> 变更点: xxx  
> 原方案: xxx  
> 新方案: xxx  
> 影响评估: xxx  
> 回滚方案: xxx

日期: 2026-03-11  
变更点: 登录主流程从 demo 单页切分为业务路由与服务模块  
原方案:
1. 主要逻辑集中在 `pages/index/index.uvue` demo 页面。
2. 登录、缘分墙、聊天 mock 混合在同一页面和同一 mock 服务文件。
新方案:
1. 页面路由拆分：
   - `pages/auth/login.uvue`
   - `pages/affinity/active.uvue`
2. 服务模块拆分：
   - `services/mock/login-service.uts`（登录规则）
   - `services/session/session-store.uts`（内存会话）
   - `services/analytics/local-event-logger.uts`（本地埋点）
3. 组件能力补齐：
   - `components/TextInput.uvue` 新增 `disabled` 能力。
影响评估:
1. 架构从“单页 demo”演进为“按页面/服务分层”，更符合后续迭代与测试要求。
2. 旧 demo 页 `pages/index/index.uvue` 仍保留，避免一次性大删引入回归风险。
3. 业务主路径已独立，可在 D2/D3 继续增量演进。
回滚方案:
1. 若新路由出现阻塞，可临时把 `pages.json` 启动页回退到 `pages/index/index`。
2. 新增服务模块为增量引入，不影响旧 mock 服务文件，回滚成本低。

日期: 2026-03-11  
变更点: 缘分墙活跃态接入独立 mock service 与业务状态流  
原方案:
1. `pages/affinity/active.uvue` 为静态占位页面，无真实数据加载过程。
2. 缘分墙资料未形成独立服务边界。
新方案:
1. 新增 `services/mock/affinity-wall-service.uts`，封装随机资料与 loading 时长。
2. `pages/affinity/active.uvue` 采用状态驱动（`loading` -> `active`）并消费 service。
3. 资料展示结构拆分为：
   - `ProfileCard`（基础资料）
   - 页面内 `reason-card`（推荐理由）
   - `online-row`（在线状态）
影响评估:
1. 缘分墙页面已具备可持续迭代的数据与状态基础，后续可无缝接入真实后端。
2. service 分层更清晰，页面职责聚焦于状态与展示，便于测试和维护。
3. 与产品文档“随机资料 + loading 默认 600ms”约束保持一致。
回滚方案:
1. 若新状态流出现问题，可临时将 `active.uvue` 回退到静态占位实现。
2. `affinity-wall-service.uts` 为新增模块，回滚时可直接移除且不影响登录主流程。

日期: 2026-03-11  
变更点: 补齐本地埋点入口并形成测试清单文档化闭环  
原方案:
1. 应用级生命周期仅有 `console.log`，未输出标准化 `app_launch` 事件。
2. 手测流程依赖临时口头约定，缺少固定 checklist。
新方案:
1. `App.uvue` 在 `onLaunch` 中接入 `logLocalEvent("app_launch", { app_version })`。
2. 维持本地事件日志模块作为统一入口（`services/analytics/local-event-logger.uts`）。
3. 新增 `docs/product/manual-test-checklist.md` 作为回归测试基线。
影响评估:
1. 事件链路从页面级扩展到应用级，埋点覆盖更完整。
2. 测试流程可重复、可审计，降低后续迭代回归成本。
回滚方案:
1. 若需要临时关闭应用级埋点，可移除 `App.uvue` 中 `app_launch` 日志调用。
2. 手测清单文档为非运行时依赖，移除不会影响代码执行。
