# Panda Mobile 开发执行清单 (MVP)

更新时间: 2026-03-11
适用范围: 当前 MVP（登录 -> 缘分墙动作 -> 消息栏占位）

## 1. 基线文档

开发前请以以下文档作为唯一产品基线：
1. `docs/product/prd-lite.md`
2. `docs/product/api-contract.md`
3. `docs/product/ui-schema.stitch.json`
4. `docs/ui_rules.md`
5. `docs/ui_lint_rules.md`
6. `docs/product/development-constraints.md`
7. `docs/product/release-prep-checklist.md`（进入 D4 P2 后必读）

## 2. D0 准备（0.5 天）

1. 建立开发分支并锁定需求基线文档。
2. 确认 mock 数据入口文件：`panda-mobile/mock/affinity-profiles.mock.json`。
3. 执行一次基线检查：`npm run ui:check`，记录当前结果。
4. 明确 UI 仅使用 `tokens/panda.tokens.json`（唯一真源）。
5. 明确里程碑文档同步责任：每个重要功能完成后更新 `docs/product/process.md` 与 `docs/product/architect.md`。
6. 明确代码风格约束：页面/组件统一 `<script setup>`，`App.uvue` 为框架例外。

## 3. D1 P0 主流程（1 天）

1. 实现 `LoginPage` 基础 UI 与 token 化样式。
2. 实现输入校验：
   - 手机号 11 位数字（不限号段）
   - 验证码 6 位数字
   - 输入非法即禁用提交按钮
3. 实现 mock 登录校验：
   - 验证码 `123456` -> 成功
   - 其他 -> 失败并提示 `验证码错误`
4. 实现失败弹窗：
   - 3 秒自动关闭
   - 期间全屏完全禁交互
5. 登录成功后：
   - 写入内存会话（不持久化）
   - 跳转 `AffinityWallActivePage`

## 4. D2 P0 缘分墙与交互细节（1 天）

1. 实现 `AffinityWallActivePage`。
2. 从 `panda-mobile/mock/affinity-profiles.mock.json` 读取 1 条资料展示（mock 池最小 3 条；D5 采用同日稳定选取）。
3. 头像统一占位：`/static/logo.png`。
4. `membership_entry` 灰态展示且不可点击。
5. 协议/隐私入口 toast：
   - 用户协议：`用户协议建设中`
   - 隐私政策：`隐私政策建设中`
   - 1500ms 节流，且两者各自独立计时
6. `loading` 当前默认最小时长 `600ms`（可按体验调整）。

## 5. D3 P1 埋点与验收（0.5-1 天）

1. 接入本地打印埋点（不接远端平台）。
2. `login_submit_blocked` 规则：
   - 仅在输入状态“合法 -> 非法”时触发
   - 持续非法不重复触发，恢复合法后再次变非法可再次触发
   - 首次进入页面初始非法态不触发
   - 点击禁用按钮不触发
3. 走完整手测清单并回归 `npm run ui:check`。
4. 提交 PR，附验收截图与测试结论。

## 6. 最小验收清单

1. 启动默认进入登录页。
2. 输入非法时提交按钮禁用。
3. 错误验证码弹窗展示并 3 秒后关闭，期间页面不可交互。
4. 验证码 `123456` 可登录成功并跳转缘分墙。
5. 缘分墙展示资料，会员入口灰态不可点。
6. 协议/隐私 toast 文案正确，1500ms 各自独立节流生效。
7. 视觉实现全部通过 token 约束与 UI 检查。
8. Vue/uvue 文件通过 `code:script-setup-scan`（`App.uvue` 例外）。
9. 点击 `再等等` 后不刷新卡片，当天保持同一推荐对象。
10. 点击 `感兴趣` 后执行 mock 匹配，`matched=true` 时可进入消息栏占位页。

## 7. D4 A 稳定性收口（不扩范围）

1. 仅做稳定性和体验修正，不新增页面/业务能力。
2. HBuilderX 复测以下场景并记录结果：
   - 手机号超长（>11）+ 验证码 6 位时，提交按钮禁用。
   - 验证码超长（>6）时，提交按钮禁用。
   - 错码弹窗 3 秒自动关闭，期间全屏禁交互。
   - 正确码登录后稳定跳转 `pages/affinity/active`。
3. 每次改动后执行：
   - `npm run mock:sync`
   - `npm run ui:check`
4. 完成回归后更新：
   - `docs/product/manual-test-checklist.md`
   - `docs/product/process.md`
   - `docs/product/architect.md`
5. 满足以上条件后再进入打包与内测流程。

## 8. D4 P2 封版与内测准备

1. 按 `docs/product/release-prep-checklist.md` 执行封版前检查。
2. 对齐 `main` 分支最新提交并确认 GitHub Actions 全绿。
3. 在 HBuilderX 完成内测包打包与安装验证。
4. 将封版 commit、内测包版本、日期、结论回填到 `release-prep-checklist.md`。

## 9. D5 P0 缘分墙动作闭环（mock）

1. 更新页面 schema 与契约：
   - `docs/product/prd-lite.md`
   - `docs/product/api-contract.md`
   - `docs/product/ui-schema.stitch.json`
2. 在 `AffinityWallActivePage` 实现动作区按钮：
   - `再等等`
   - `感兴趣`
3. 实现同日单推荐约束：
   - 点击动作后当天不刷新下一张卡片
   - 同一自然日内重新登录仍展示同一对象
   - 同一用户当前循环内已推荐对象后续不再推荐
   - 未推荐池耗尽时保持当前卡片，下一天 00:00 重置循环历史后重新循环
   - 次日 00:00 进入新循环后，首个推荐对象优先不等于上一自然日最后展示对象；若无可选候选允许重复
   - “上一自然日最后展示对象”按系统最后一次成功分配推荐对象定义
   - 长期历史仅在卸载/清除应用数据后清空
   - `再等等` 仅提示次日推荐
   - `再等等` toast 固定为 `已为你安排明日推荐`
   - 当天动作点击即锁定，不可改选
   - 锁定后再次点击静默忽略（不弹 toast）
   - 日期边界按设备本地自然日（00:00），并在 00:00 自动重置
   - 页面停留跨越 00:00 时立即重置并换到历史未推荐卡片（不依赖 `onShow`）
   - App 进程被杀后动作锁定不保留
4. 实现 mock 匹配逻辑：
   - 固定规则：`profileId=="p_001"` -> `matched=true`，否则 `matched=false`
   - `matched=true` 跳转 `/pages/message/index`
   - `matched=true` 时 `conversationId = profileId + "_" + dateKey`
   - `matched=false` 停留当前页并 toast：`今日匹配已用完，请明日再来`
5. 新增消息栏占位页（不实现真实聊天能力）。
6. 从消息栏占位页返回时按当前 `dateKey` 立即重算并展示缘分墙当前卡片（MVP 不处理消息占位页跨 00:00 特殊逻辑）。
7. 补齐动作相关本地埋点并更新手测清单。
8. 非 MVP 聊天组件保留但不接入：主流程页面禁止 import，主流程路由禁止跳转到非 MVP 聊天路由。
