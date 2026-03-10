# Panda Mobile MVP 决策记录 (2026-03-10)

## 1. 决策结论（已确认）

1. 需要将 `ui-schema` 收敛到 MVP 范围。
2. 路由结构可以拆分为真实页面路由，不再仅用 `pages/index/index` 演示页。
3. mock 验证码规则：
   - 验证码长度必须为 6 位
   - mock 测试码固定为 `123456`
4. MVP 登录失败仅处理一种错误：`验证码错误`，弹窗提示后 **3 秒自动关闭**。
5. MVP 不使用 token，不持久化登录状态。
6. 缘分墙活跃态数据字段需要补全（见下文）。
7. UI 状态规则放宽：不强制所有页面都覆盖 `loading/empty/error/content` 四态，按页面类型定义。
8. 隐私政策/用户协议在 MVP 阶段使用 mock 数据与占位链接。
9. 需要埋点方案，补充事件表（见 `analytics-events.md`）。
10. 非 MVP 聊天组件将移出主分支，避免无用代码干扰。

## 2. 缘分墙活跃态字段（MVP）

```json
{
  "id": "p_001",
  "name": "林静宜",
  "avatarUrl": "/static/mock/avatar-001.png",
  "meta": "26岁 · 165cm · 上海",
  "bio": "热爱生活中的小确幸...",
  "reason": "你们在兴趣和交流节奏上较匹配",
  "isOnline": true
}
```

## 3. 下一步执行清单（未开始写代码）

1. 更新路由为 `LoginPage` -> `AffinityWallActivePage`。
2. 按 6 位规则 + 固定测试码 `123456` 实现 mock 校验。
3. 登录失败弹窗实现自动关闭（3 秒）。
4. 移除主分支中的非 MVP 聊天组件与聊天流代码。
5. 接入 `analytics-events.md` 定义的最小埋点。

