# Panda Mobile Mock Contract (V0.2)

## 1. 当前约束

1. MVP **不接真实后端**，仅使用本地 mock service。
2. 登录不发放真实 token，不持久化登录状态。
3. 本文档是前端 mock 契约，后续联调前再产出正式 API 合同。

## 2. Mock 登录规则

输入：

```json
{
  "phone": "13800138000",
  "code": "123456"
}
```

校验规则：
1. `phone` 必须为 11 位数字；
2. `code` 必须为 6 位数字；
3. 测试通过码固定为 `123456`；
4. 其余情况统一视为失败：`验证码错误`。

成功返回（示例）：

```json
{
  "success": true,
  "data": {
    "userId": "mock_user_001",
    "nickname": "熊猫同学"
  }
}
```

失败返回（示例）：

```json
{
  "success": false,
  "error": "验证码错误"
}
```

## 3. 登录失败弹窗规则

1. 弹窗文案：`验证码错误`。
2. 自动关闭时长：3 秒。
3. 关闭后停留登录页，允许再次输入并提交。

## 4. 缘分墙活跃态 Mock 数据

登录成功后进入「缘分墙 - 活跃状态 (普通用户版)」，使用以下字段：

```json
{
  "state": "active",
  "profile": {
    "id": "p_001",
    "name": "林静宜",
    "avatarUrl": "/static/mock/avatar-001.png",
    "meta": "26岁 · 165cm · 上海",
    "bio": "热爱生活中的小确幸...",
    "reason": "你们在兴趣和交流节奏上较匹配",
    "isOnline": true
  }
}
```

## 5. 后续切换真实后端

1. 保持 service interface 不变，替换实现层。
2. 联调前补充正式 API Contract（错误码、鉴权、限流、幂等）。

