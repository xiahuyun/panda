# Panda Mobile 技术栈说明 (MVP)

更新时间: 2026-03-11  
适用范围: 当前 MVP（登录 -> 缘分墙动作闭环 -> 消息占位）

## 1. 技术栈目标

1. 使用 uni-app x 体系完成跨端移动端 MVP 交付。
2. 保持 UI 与设计 token 一致，避免视觉硬编码。
3. 以本地 mock 数据先跑通主流程，后续可平滑切换真实后端。

## 2. 已确认技术栈

### 2.1 运行时与框架

1. 应用框架: `uni-app x`
2. UI 框架: `Vue 3`
3. 语言形态: `UTS + .uvue`
4. 页面/组件脚本范式: `<script setup>`（`App.uvue` 为框架限制例外）

对应仓库证据:
1. `panda-mobile/main.uts`
2. `panda-mobile/App.uvue`
3. `panda-mobile/manifest.json`（`vueVersion: "3"`）

### 2.2 UI 与样式体系

1. 设计 token 唯一真源: `panda-mobile/tokens/panda.tokens.json`
2. UI 规范文档: `panda-mobile/docs/ui_rules.md`
3. UI lint 规范: `panda-mobile/docs/ui_lint_rules.md`
4. 设计说明辅助文档（非约束源）: `panda-mobile/docs/panda-design-tokens.md`

### 2.3 数据与服务层

1. MVP 不接真实后端，使用本地 mock service。
2. mock 数据池文件: `panda-mobile/mock/affinity-profiles.mock.json`
3. mock 池最小规模: 3 条资料。
4. 头像策略: 统一占位 `/static/logo.png`。

### 2.4 产品交互关键约束（影响实现）

1. 登录验证码规则: 6 位数字，测试码 `123456`。
2. 手机号规则: 仅校验 11 位数字，不限号段。
3. 错误弹窗: 3 秒自动关闭，期间全屏完全禁交互。
4. 协议/隐私 toast: 1500ms 节流，且两者各自独立计时。
5. loading: 当前默认最小时长 600ms（可按体验调整，非固定验收阈值）。
6. `login_submit_blocked`: 仅在输入状态“合法 -> 非法”时触发一次；持续非法不重复触发，点击禁用按钮不触发；首次进入页面初始非法态不触发。
7. 推荐策略: `stable_pick_unseen(userId, dateKey, cycleHistory)`，`userId` 取当前内存会话；具体算法可自定，但行为需满足文档约束。
8. 日期边界策略: 页面停留中跨越本地 00:00 立即重置并换到历史未推荐卡片，不依赖 `onShow`。
9. 会话标识策略: `matched=true` 时 `conversationId = profileId + "_" + dateKey`。
10. 历史生命周期: `cycleHistory` 与 `lifetimeHistory` 均按 `userId` 本地持久化；前者按规则循环重置，后者仅在卸载/清除应用数据时清空。
11. 新循环约束: 次日 00:00 进入新循环后的首个推荐对象优先不等于上一自然日最后展示对象；若无可选候选允许降级重复。
12. “上一自然日最后展示对象”定义: 系统最后一次成功分配给该用户的推荐对象。
13. 消息占位页: MVP 阶段不处理跨 00:00 特殊逻辑；返回缘分墙时按当前 `dateKey` 立即重算。
14. 非 MVP 聊天组件: 保留文件但不接入主流程（禁止主流程页面 import 与主流程路由跳转引用）。

详细约束来源:
1. `panda-mobile/docs/product/prd-lite.md`
2. `panda-mobile/docs/product/api-contract.md`
3. `panda-mobile/docs/product/ui-schema.stitch.json`
4. `panda-mobile/docs/product/analytics-events.md`

### 2.5 端上运行与验证工具链

1. MVP 端上运行方式: `HBuilderX`（已确认）。
2. 当前不使用 CLI 方式进行端上验证（历史原因: `dev:h5` 脚本缺失，`uni` CLI 与当前 Node 版本兼容性失败）。
3. 手测执行入口与步骤以 `docs/product/manual-test-checklist.md` 为准。

## 3. 当前工程化工具（已落地）

1. npm script:
   - `npm run code:script-setup-scan`
   - `npm run ui:token-scan`
   - `npm run ui:check`
2. UI 门禁脚本:
   - `panda-mobile/scripts/ui-token-scan.sh`
   - `panda-mobile/scripts/script-setup-scan.sh`

## 4. 待锁定项（D5 功能完成后统一锁定）

1. 依赖版本锁定:
   - HBuilderX 版本
   - uni-app x SDK 版本
   - Vue 运行时相关版本
2. 代码质量工具实装:
   - stylelint 配置文件
   - eslint 配置文件
3. 自动化测试最小集:
   - 页面主流程 smoke test（登录成功/失败/非法输入）
4. CI 执行顺序:
   - `ui:check` 之外是否增加 lint/test 阶段

说明:
1. 以上 4 项当前不阻塞 D5 功能开发，待 D5 功能完成后一次性锁定并回填本文件。

## 5. 开发准入标准

1. 所有 UI 必须只引用 token，不写视觉硬编码。
2. 页面行为必须满足 `docs/product` 下约束文档。
3. 代码提交前必须通过 `npm run ui:check`。
4. 任何新增规则先改文档，再改实现。
