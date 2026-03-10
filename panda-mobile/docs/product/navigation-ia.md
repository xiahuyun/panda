# Panda Mobile 导航与信息架构 (V0.2)

## 1. 页面清单（MVP）

1. `LoginPage`：小熊交友 - 吃苹果熊猫 Logo 登录页
2. `AffinityWallActivePage`：缘分墙 - 活跃状态 (普通用户版)

## 2. 路由关系

1. 启动 -> `LoginPage`
2. `LoginPage` 登录成功 -> `AffinityWallActivePage`
3. `LoginPage` 登录失败 -> 停留 `LoginPage`（验证码错误弹窗）

## 3. 导航规则

1. 登录成功后清理登录页回退栈，避免返回未登录页。
2. MVP 不接入聊天页与设置页导航。
3. MVP 不持久化登录状态，每次启动默认进入登录页。

## 4. 信息架构（MVP）

1. 账户域：手机号、验证码、登录结果
2. 缘分墙域：活跃态卡片展示

## 5. 后续扩展位（未启用）

1. 聊天域
2. 举报/拉黑域
3. 账号管理域

