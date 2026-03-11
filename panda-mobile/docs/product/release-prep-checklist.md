# Panda Mobile 封版与内测准备清单 (D4 P2)

更新时间: 2026-03-11  
适用范围: D4-A（仅稳定性/体验优化，不扩业务 scope）

## 1. 封版范围确认

1. 本轮封版范围仅包含：登录页 + 缘分墙活跃态（mock 数据）。
2. 不包含：聊天页、再等等/感兴趣策略、真实后端验证码服务、会员/IAP。
3. 封版基线文档：
   - `docs/product/prd-lite.md`
   - `docs/product/ui-schema.stitch.json`
   - `docs/product/manual-test-checklist.md`

## 2. 提交前门禁

1. `npm run mock:sync` 通过。
2. `npm run ui:check` 通过（token scan + script setup scan）。
3. `main` 分支 GitHub Actions 全绿。

## 3. HBuilderX 打包前配置检查

1. 打开 `manifest.json`，确认：
   - `appid`：`__UNI__8AD3E01`
   - `versionName`：`1.0.0`
   - `versionCode`：`100`
2. 确认应用名称、图标、启动图、隐私政策配置满足内测要求。
3. 确认测试环境说明：当前为 mock 登录（测试码 `123456`）。

## 4. HBuilderX 内测包执行步骤

1. 使用 HBuilderX 打开 `panda-mobile`。
2. 选择目标平台（iOS 内测优先）并执行云打包/本地打包。
3. 安装到测试设备后执行最小验收路径：
   - 启动进入登录页
   - 非法输入禁用提交（含手机号/验证码超长）
   - 错码弹窗 3 秒自动关闭且全屏禁交互
   - 正确码 `123456` 登录并跳转缘分墙
4. 记录内测结果与问题列表（如有）。

## 5. 封版记录

1. 封版 commit: `待回填`
2. 内测包版本: `待回填`
3. 内测日期: `待回填`
4. 内测结论: `待回填`
5. 责任人: `待回填`
