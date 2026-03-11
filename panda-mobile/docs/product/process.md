# Panda Mobile 开发过程记录

更新时间: 2026-03-11

## 记录规则

1. 每完成一个重要功能或里程碑后，必须追加一条记录。
2. 每条记录建议包含：
   - 时间
   - 里程碑名称
   - 完成项
   - 验证方式与结果
   - 风险与下一步

## 里程碑记录

> 示例模板（复制后填写）  
> 日期: YYYY-MM-DD  
> 里程碑: xxx  
> 完成项: xxx  
> 验证: `npm run ui:check` / 手测路径  
> 风险: xxx  
> 下一步: xxx

日期: 2026-03-11  
里程碑: D1 P0 登录主流程落地  
完成项:
1. 新增 `LoginPage`（`pages/auth/login.uvue`），实现手机号/验证码输入校验与禁用提交逻辑。
2. 新增登录 mock 服务（`services/mock/login-service.uts`），规则为 11 位手机号 + 6 位验证码 + 测试码 `123456`。
3. 新增内存会话模块（`services/session/session-store.uts`），登录成功后写入会话。
4. 新增本地事件日志模块（`services/analytics/local-event-logger.uts`），用于 MVP 本地埋点打印。
5. 新增 `AffinityWallActivePage`（`pages/affinity/active.uvue`）并在登录成功后 `reLaunch` 跳转。
6. 登录失败弹窗实现 3 秒自动关闭 + 全屏交互锁；协议/隐私入口实现文案与独立节流。
7. 更新 `pages.json`，默认启动页切换为 `pages/auth/login`。
验证:
1. 执行 `npm run ui:check` 通过（UI token scan passed）。
2. 代码级路径验证完成：登录成功跳转逻辑、失败弹窗自动关闭逻辑、输入非法禁用逻辑均已接入。
风险:
1. 尚未进行真机/模拟器交互验证（仅完成静态检查与代码路径核对）。
2. `onBackPress` 的平台行为需要在端上验证是否符合“弹窗期间阻断返回”。
下一步:
1. 进入 D2，接入缘分墙随机资料流与页面状态细节。
2. 进行一次端上联调验证登录全流程。

日期: 2026-03-11  
里程碑: D2 P0 缘分墙活跃态接入随机资料流  
完成项:
1. 新增 `services/mock/affinity-wall-service.uts`，提供 600ms loading + 随机资料返回能力。
2. 将 `pages/affinity/active.uvue` 从占位页升级为业务页，接入 `loading -> active` 状态流。
3. 页面接入 `ProfileCard` + 推荐理由 + 在线状态展示。
4. 保持会员入口灰态且不可点击。
5. 数据层头像统一使用 `/static/logo.png` 占位。
验证:
1. 执行 `npm run ui:check` 通过（UI token scan passed）。
2. 代码路径验证：页面 onLoad 后先进入 loading，再加载随机资料并切换 active。
风险:
1. 随机资料当前在 service 内维护，尚未与 `mock/affinity-profiles.mock.json` 做自动同步机制。
2. 尚未进行端上视觉验收（仅完成规则检查和代码级验证）。
下一步:
1. 进入 D3，完成本地埋点完整校对与回归手测。
2. 补一次端上联调，确认交互细节与状态切换表现。

日期: 2026-03-11  
里程碑: D3 P1 埋点对齐与测试清单沉淀  
完成项:
1. 补齐 `app_launch` 本地埋点（含 `app_version` 字段）。
2. 对照 `analytics-events.md` 校对事件接入点，确认登录与导航关键事件均已覆盖。
3. 新增手测清单文档：`docs/product/manual-test-checklist.md`。
4. 将 D1-D3 关键验证项沉淀为可重复执行的检查条目。
验证:
1. 执行 `npm run ui:check` 通过（UI token scan passed）。
2. 代码级埋点路径检查通过（事件名与字段符合文档约束）。
风险:
1. 真机/模拟器手测尚未完成，平台行为（如返回键拦截）仍需端上确认。
下一步:
1. 执行手测清单并记录结果。
2. 根据手测反馈做小范围修正后准备提交。

日期: 2026-03-11  
里程碑: D3 P2 手测清单自动确认填充  
完成项:
1. `manual-test-checklist.md` 已按“可自动确认 / 待端上验证 / 待修正”完成状态标注。
2. 自动可确认项已逐条校对并标记。
3. 识别并记录 1 个待修正项：缘分墙资料源当前为 service 内置池，尚未读取 `panda-mobile/mock/affinity-profiles.mock.json`。
验证:
1. 文档与当前代码实现对照完成。
2. 关键状态（登录校验、错误弹窗、节流、埋点）已完成代码级确认。
风险:
1. “资料源文件化”未完成前，代码与产品文档存在轻微偏差。
2. 端上行为验证仍未执行。
下一步:
1. 先修正缘分墙资料源读取逻辑，与文档完全对齐。
2. 执行真机/模拟器手测并回填最终结果。

日期: 2026-03-11  
里程碑: D3 P3 修复缘分墙资料源与文档不一致  
完成项:
1. 新增 `scripts/sync-affinity-profiles-mock.mjs`，将 `mock/affinity-profiles.mock.json` 转换为运行时可直接引用的 `mock/affinity-profiles.mock.uts`。
2. 新增 npm 脚本 `mock:sync`，用于手动触发同步生成。
3. `services/mock/affinity-wall-service.uts` 改为读取 `AFFINITY_PROFILES_MOCK`，移除 service 内置资料池。
4. 更新手测清单，关闭“资料源待修正”项。
验证:
1. 执行 `npm run mock:sync` 通过（成功生成 `mock/affinity-profiles.mock.uts`）。
2. 执行 `npm run ui:check` 通过（UI token scan passed）。
风险:
1. 若后续仅修改 `mock/affinity-profiles.mock.json` 但忘记执行 `npm run mock:sync`，运行时数据不会自动更新。
下一步:
1. 在开始 D4 前执行一次真机/模拟器手测，完成端上行为确认。

日期: 2026-03-11  
里程碑: D3 P4 端上手测执行与环境阻塞记录  
完成项:
1. 按手测清单尝试启动可验证环境，先后执行 `npm run dev:h5` 与 `npx -y uni -v`。
2. 回填 `manual-test-checklist.md`，补充本轮执行结果与阻塞细节。
3. 明确当前剩余待验证项仅为“错误弹窗期间返回键拦截与全屏禁交互”端上行为。
验证:
1. `npm run dev:h5` 执行失败（缺失脚本）。
2. `npx -y uni -v` 执行失败（CLI 与当前 Node 版本不兼容）。
风险:
1. 在未完成真机/模拟器验证前，`onBackPress` 行为仍存在平台侧不确定性。
2. 若不锁定 uni-app x 工具链版本，后续端上验证可能持续受环境差异影响。
下一步:
1. 由你确认并提供可用端上运行方式（HBuilderX 或指定 CLI 版本）。
2. 环境就绪后优先完成第 2.5 条手测并回填“通过/不通过”。

日期: 2026-03-11  
里程碑: D3 P5 端上运行方式锁定为 HBuilderX  
完成项:
1. 端上验证工具链确定为 `HBuilderX`，不再使用当前 CLI 方案。
2. 更新 `manual-test-checklist.md`，新增 HBuilderX 手测执行步骤。
3. 将剩余验证项收敛为第 2.5 条（错误弹窗期间全屏禁交互 + 返回键拦截）。
验证:
1. 文档交叉核对通过（process / architect / checklist / tech-stack 一致）。
2. `npm run ui:check` 无受影响项（通过）。
风险:
1. 端上手测仍需在 HBuilderX 实际执行后才能最终闭环。
下一步:
1. 通过 HBuilderX 执行第 2.5 条手测并回填结果。
2. 若不通过，按现象补充缺陷条目并进入 D4 修正。

日期: 2026-03-11  
里程碑: D3 P6 HBuilderX 端上手测闭环  
完成项:
1. 按 `manual-test-checklist.md` 在 HBuilderX 完成第 2.5 条验证。
2. 将登录流程第 2.5 条状态回填为“已端上验证通过”。
3. 更新本轮执行结果，关闭“仅剩端上验证”待办状态。
验证:
1. 用户反馈：HBuilderX 手测执行步骤 2.5 通过。
2. 文档状态已同步到 checklist / process / architect。
风险:
1. 当前 D1-D3 主流程无新增阻塞项。
下一步:
1. 进入 D4 迭代（如新增交互或异常分支）时复用同一手测基线。

日期: 2026-03-11  
里程碑: D3 P7 修复登录成功后跳转失败（reLaunch 异常）  
完成项:
1. `pages/auth/login.uvue` 登录成功跳转由 `uni.reLaunch` 调整为 `uni.redirectTo`。
2. 新增降级路径：`redirectTo` 失败时自动尝试 `navigateTo`。
3. 新增失败兜底提示，避免出现未捕获 Promise 报错并给出可感知反馈。
验证:
1. 代码路径验证通过：成功分支统一走 `navigateToAffinityActive()`。
2. `npm run ui:check` 通过（UI token scan passed）。
风险:
1. 若运行环境仍被识别为单页面工程，降级后仍可能跳转失败，但会转为可观测错误与用户提示。
下一步:
1. 在 HBuilderX 按登录成功路径复测一次跳转，确认是否已恢复到 `pages/affinity/active`。

日期: 2026-03-11  
里程碑: D3 P8 页面/组件脚本范式统一为 script setup  
完成项:
1. `pages/auth/login.uvue` 从 `export default` 重构为 `<script setup lang=\"uts\">`，行为保持一致。
2. `pages/affinity/active.uvue` 从 `export default` 重构为 `<script setup lang=\"uts\">`，行为保持一致。
3. 新增 `scripts/script-setup-scan.sh`，扫描 `.vue/.uvue` 文件是否使用 `<script setup>`（`App.uvue` 例外）。
4. `package.json` 更新 `ui:check`，将 `code:script-setup-scan` 纳入提交前门禁。
5. 同步更新 `development-constraints.md`、`development-checklist.md`、`tech-stack.md`。
验证:
1. 执行 `npm run ui:check` 通过（token scan + script setup scan）。
2. 执行 `npm run code:script-setup-scan` 通过。
风险:
1. `App.uvue` 受 uni-app x 框架能力限制，暂无法改为 `<script setup>`。
下一步:
1. 后续新增页面/组件按同一门禁执行，禁止回退到选项式写法。

日期: 2026-03-11  
里程碑: D3 P9 修复登录页“超长输入仍可提交”回归问题  
完成项:
1. 定位根因：`pages/auth/login.uvue` 对手机号/验证码输入做了“超长截断”（11/6 位），导致超长输入被截断成合法值后可提交。
2. 调整输入处理策略为“仅过滤非数字，不截断长度”，让 `>11` 手机号和 `>6` 验证码维持非法态并禁用提交。
3. 更新手测清单，将登录页长度规则项标记为“待端上回归确认”。
验证:
1. `npm run ui:check` 通过（token scan + script setup scan）。
2. 代码级校验：`isLoginFormValid` 仍使用“长度严格等于 11/6”规则，修复后与输入层行为一致。
风险:
1. 需在 HBuilderX 再跑一次长度规则回归，确认端上输入显示与按钮禁用状态一致。
下一步:
1. 在 HBuilderX 验证“手机号 12 位/13 位 + 验证码 6 位”场景必须禁用提交并不可跳转。
