# Panda Mobile 开发执行清单 (MVP)

更新时间: 2026-03-11
适用范围: 当前 MVP（登录 -> 缘分墙活跃态）

## 1. 基线文档

开发前请以以下文档作为唯一产品基线：
1. `docs/product/prd-lite.md`
2. `docs/product/api-contract.md`
3. `docs/product/ui-schema.stitch.json`
4. `docs/ui_rules.md`
5. `docs/ui_lint_rules.md`
6. `docs/product/development-constraints.md`

## 2. D0 准备（0.5 天）

1. 建立开发分支并锁定需求基线文档。
2. 确认 mock 数据入口文件：`panda-mobile/mock/affinity-profiles.mock.json`。
3. 执行一次基线检查：`npm run ui:check`，记录当前结果。
4. 明确 UI 仅使用 `tokens/panda.tokens.json`（唯一真源）。
5. 明确里程碑文档同步责任：每个重要功能完成后更新 `docs/product/process.md` 与 `docs/product/architect.md`。

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
2. 从 `panda-mobile/mock/affinity-profiles.mock.json` 随机读取 1 条资料展示（mock 池最小 3 条）。
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
   - 输入非法即触发
   - 不去重
   - 点击禁用按钮不触发
3. 走完整手测清单并回归 `npm run ui:check`。
4. 提交 PR，附验收截图与测试结论。

## 6. 最小验收清单

1. 启动默认进入登录页。
2. 输入非法时提交按钮禁用。
3. 错误验证码弹窗展示并 3 秒后关闭，期间页面不可交互。
4. 验证码 `123456` 可登录成功并跳转缘分墙。
5. 缘分墙随机展示资料，会员入口灰态不可点。
6. 协议/隐私 toast 文案正确，1500ms 各自独立节流生效。
7. 视觉实现全部通过 token 约束与 UI 检查。
