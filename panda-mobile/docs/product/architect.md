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
2. 数据层：`mock/affinity-profiles.mock.json` 为真源，脚本生成 `mock/affinity-profiles.mock.uts` 供运行时读取
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

日期: 2026-03-11  
变更点: 测试清单状态化并补充实现偏差追踪  
原方案:
1. `manual-test-checklist.md` 仅为条目列表，未标注“自动确认/待验证”状态。
2. 资料源一致性偏差未在架构记录中显式追踪。
新方案:
1. 手测清单增加状态标注，区分可自动确认项与端上验证项。
2. 将“缘分墙资料源未读取 mock 文件”的偏差登记为待修正事项。
影响评估:
1. 测试执行更可控，可快速识别剩余阻塞项。
2. 架构与文档一致性问题可被持续跟踪，降低后续返工风险。
回滚方案:
1. 清单状态标注属于文档增量，不影响运行时，必要时可回退到纯列表版本。

日期: 2026-03-11  
变更点: 缘分墙资料源统一为 mock 文件真源 + 生成产物消费  
原方案:
1. `services/mock/affinity-wall-service.uts` 内部维护硬编码资料池。
2. 与文档声明的 `mock/affinity-profiles.mock.json` 真源存在偏差。
新方案:
1. 新增同步脚本 `scripts/sync-affinity-profiles-mock.mjs`，将 JSON 真源转换为 `mock/affinity-profiles.mock.uts`。
2. `affinity-wall-service.uts` 仅消费 `AFFINITY_PROFILES_MOCK`，不再内置数据。
3. npm 脚本新增 `mock:sync`，作为资料源变更后的标准同步入口。
影响评估:
1. 产品文档、数据源、运行时代码三者一致，降低后续维护歧义。
2. service 职责收敛为“随机选择 + loading 时长控制”，边界更清晰。
3. 新增一步生成流程，开发时需保证 JSON 变更后执行同步命令。
回滚方案:
1. 若生成链路异常，可临时恢复 service 内置资料池保证功能可用。
2. 同步脚本与生成文件均为增量文件，可独立回退。

日期: 2026-03-11  
变更点: 补充端上验证工具链约束与执行阻塞结论  
原方案:
1. 默认认为可在当前仓库直接拉起本地运行环境执行端上手测。
2. 手测清单仅记录“待验证”，未沉淀环境层阻塞证据。
新方案:
1. 在 `manual-test-checklist.md` 中记录实际执行命令与失败原因（`dev:h5` 脚本缺失、`uni` CLI 兼容性失败）。
2. 将端上验证前置条件显式化：需 HBuilderX 或已锁定版本的 uni-app x CLI。
影响评估:
1. 手测工作从“口头待办”变为“可复现的环境问题清单”，降低重复排障成本。
2. 当前架构不变，但发布前验证门禁更清晰，避免误判为功能已端上通过。
回滚方案:
1. 文档化约束为非运行时变更，可按需回退，不影响现有代码执行。

日期: 2026-03-11  
变更点: 端上验证工具链正式锁定为 HBuilderX  
原方案:
1. 端上验证工具链为候选态（HBuilderX 或锁定版本 CLI）。
2. CLI 方案在当前环境存在兼容性失败记录。
新方案:
1. MVP 阶段端上运行与手测统一使用 `HBuilderX`。
2. 手测清单新增 HBuilderX 执行步骤，CLI 失败记录保留为历史上下文。
影响评估:
1. 手测入口统一，减少环境分歧与重复排障。
2. 不影响现有页面/服务模块边界，仅影响测试执行路径。
回滚方案:
1. 若后续需要恢复 CLI 路径，需先补齐可用脚本与版本锁定，再更新文档约束。

日期: 2026-03-11  
变更点: 端上验证状态由“待验证”闭环为“已通过”  
原方案:
1. 登录流程第 2.5 条（错误弹窗期间全屏禁交互 + 返回键拦截）处于待端上验证状态。
新方案:
1. 在 HBuilderX 完成端上手测后，将第 2.5 条状态更新为通过。
2. 手测清单执行结果同步到过程文档，形成闭环记录。
影响评估:
1. D1-D3 主路径验证门禁已满足，后续可在此基线上继续迭代。
2. 架构模块边界无变化，本次属于验证状态闭环更新。
回滚方案:
1. 若后续端上回归发现问题，可将第 2.5 条回退为“不通过（附现象）”并按缺陷流程修复。

日期: 2026-03-11  
变更点: 登录成功跳转链路增加降级与错误兜底  
原方案:
1. 登录成功后仅调用 `uni.reLaunch("/pages/affinity/active")`。
2. 当运行环境路由能力异常时，存在未捕获 Promise 报错，且无用户可见反馈。
新方案:
1. 登录成功后改为 `uni.redirectTo("/pages/affinity/active")`。
2. `redirectTo` 失败自动降级到 `navigateTo`。
3. 二次失败时给出 toast 提示并输出 console 错误，便于排障。
影响评估:
1. 跳转链路从“单点调用”变为“主路径 + 降级路径 + 失败提示”，健壮性更高。
2. 不改变页面模块边界，仅调整登录页导航实现细节。
回滚方案:
1. 若后续确认 `reLaunch` 在目标平台完全稳定，可回退为单 API 实现以简化代码。
