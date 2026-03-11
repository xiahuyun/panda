# Panda Mobile 开发约束 (MVP)

更新时间: 2026-03-11  
适用范围: `panda-mobile/` 全部前端开发

## 1. 代码结构约束

1. 强制模块化（多文件）实现，禁止把页面、业务逻辑、样式、mock 处理堆叠为单体巨文件（monolith）。
2. 页面层、组件层、服务层、常量/配置层应分离，避免跨层耦合。

## 2. 开发前置约束

1. 写代码前必须先阅读 `docs/` 下相关文档，确保需求、交互、约束、验收标准都已明确。
2. 最低必读文档：
   - `docs/product/prd-lite.md`
   - `docs/product/api-contract.md`
   - `docs/product/ui-schema.stitch.json`
   - `docs/product/development-checklist.md`
   - `docs/ui_rules.md`
   - `docs/ui_lint_rules.md`

## 3. 文档同步约束

1. 每完成一个重要功能或里程碑，必须同步更新以下文档：
   - `docs/product/process.md`
   - `docs/product/architect.md`
2. `process.md` 记录“做了什么、怎么验证、当前风险/下一步”。
3. `architect.md` 记录“模块划分、依赖关系、关键设计决策变化”。

## 4. 变更与可测试性约束

1. 代码改动应保持最小化，只改当前目标相关文件，避免无关重构。
2. 开发步骤必须可测试、可回归，每一步都应能被验证（本地运行、UI 检查、关键路径手测）。
3. 提交前至少执行 `npm run ui:check`。

## 5. Vue/uvue 代码风格约束

1. `pages/` 与 `components/` 下所有 `.vue/.uvue` 文件必须使用 `<script setup>` 写法。
2. 禁止在页面和组件中新增 `export default {}` 选项式写法。
3. 唯一例外: `App.uvue` 仍使用选项式写法（uni-app x 当前不支持 `App.uvue` 使用 `<script setup>`）。
4. 提交前必须通过 `npm run ui:check` 中的 `code:script-setup-scan` 扫描门禁。
