# Panda Mobile 导航与信息架构

## 1. 页面清单（首发）

1. `LoginPage` 登录页
2. `AffinityWallPage` 缘分墙
3. `ChatPage` 聊天页
4. `SettingsPage` 设置页（含账号删除、隐私政策入口）

## 2. 路由关系

1. 启动后：
   - 未登录 -> `LoginPage`
   - 已登录 -> `AffinityWallPage`
2. `AffinityWallPage` -> `ChatPage`
3. `ChatPage` 返回 -> `AffinityWallPage`
4. 任意主页面 -> `SettingsPage`

## 3. 导航规则

1. 登录成功后清理登录页回退栈（避免返回到登录页）。
2. 聊天页允许返回缘分墙，不直接退出 App。
3. 结束连接后回到缘分墙并刷新推荐。

## 4. 信息架构

1. 账户域：登录状态、用户资料、账号删除
2. 匹配域：推荐卡片、推荐理由、刷新推荐
3. 聊天域：会话、消息列表、发送消息、举报拉黑

## 5. 全局守卫（后续实现）

1. 未登录访问受保护页面时，重定向登录页。
2. token 过期时清理本地会话并跳转登录页。

