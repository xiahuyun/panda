# Panda Mobile 手测清单 (MVP)

更新时间: 2026-03-11
适用范围: D1-D3 MVP 主流程

## 1. 登录页

1. 启动默认进入登录页（`pages/auth/login`）。【已自动确认】
2. 手机号非 11 位数字时，提交按钮禁用。【已自动确认】
3. 验证码非 6 位数字时，提交按钮禁用。【已自动确认】
4. 输入非法时，控制台出现 `login_submit_blocked` 本地事件日志。【已自动确认】

## 2. 登录提交流程

1. 输入合法手机号 + `123456`，点击登录/注册后进入提交态。【已自动确认】
2. 约 600ms 后登录成功，跳转 `pages/affinity/active`。【已自动确认】
3. 输入合法手机号 + 非 `123456` 验证码，显示 `验证码错误` 弹窗。【已自动确认】
4. 错误弹窗 3 秒后自动关闭。【已自动确认】
5. 错误弹窗期间无法点击页面、无法编辑输入、无法重复提交、返回键被拦截。【待端上验证】

## 3. 协议与隐私入口

1. 点击用户协议，显示 toast：`用户协议建设中`。【已自动确认】
2. 点击隐私政策，显示 toast：`隐私政策建设中`。【已自动确认】
3. 用户协议/隐私政策各自 1500ms 节流，连续点击不重复弹出。【已自动确认】

## 4. 缘分墙活跃态

1. 页面首次进入先显示 loading（约 600ms）。【已自动确认】
2. loading 后显示资料卡片与推荐理由。【已自动确认】
3. 资料来自本地随机 mock 池（最小 3 条）。【已自动确认（`mock/affinity-profiles.mock.json` 为真源，经脚本生成 `mock/affinity-profiles.mock.uts` 后由 service 读取）】
4. 会员入口灰态展示且不可点击。【已自动确认】
5. 头像统一占位 `/static/logo.png`。【已自动确认】

## 5. 埋点日志校对

1. `app_launch`【已自动确认】
2. `login_page_view`【已自动确认】
3. `login_submit_click`【已自动确认】
4. `login_submit_blocked`【已自动确认】
5. `login_verify_success`【已自动确认】
6. `login_verify_fail`【已自动确认】
7. `login_error_modal_show`【已自动确认】
8. `login_error_modal_auto_close`【已自动确认】
9. `nav_to_affinity_active`【已自动确认】
10. `affinity_active_page_view`【已自动确认】

## 6. 本轮执行结果

1. `npm run ui:check`：通过。
2. `npm run mock:sync`：通过（成功生成 `mock/affinity-profiles.mock.uts`）。
3. 代码路径自检：通过（可自动确认项已标注）。
4. 真机/模拟器手测：待执行（重点验证返回键拦截与全屏禁交互）。
5. 待修正项：无（当前仅剩端上行为验证待执行）。
