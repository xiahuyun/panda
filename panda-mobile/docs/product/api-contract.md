# Panda Mobile API Contract (Draft)

## 1. 约定

1. Base URL: `/api/v1`
2. Auth: `Authorization: Bearer <token>`
3. 响应结构：

```json
{
  "code": 0,
  "message": "ok",
  "data": {}
}
```

4. 错误码（首版）：
   - `1001` 参数错误
   - `1002` 未登录或 token 失效
   - `2001` 资源不存在
   - `3001` 业务限制（如连接已结束）
   - `5000` 服务器异常

## 2. 登录

### POST `/auth/login`

请求：

```json
{
  "phone": "13800138000",
  "code": "1234"
}
```

响应：

```json
{
  "code": 0,
  "message": "ok",
  "data": {
    "userId": "u_001",
    "nickname": "熊猫同学",
    "token": "jwt-token"
  }
}
```

## 3. 缘分墙推荐

### GET `/affinity/wall`

响应（content）：

```json
{
  "code": 0,
  "message": "ok",
  "data": {
    "state": "content",
    "profile": {
      "id": "p_001",
      "name": "林静宜",
      "meta": "26岁 · 165cm · 上海",
      "bio": "热爱生活中的小确幸...",
      "reason": "你们都偏爱安静但有温度的关系..."
    }
  }
}
```

响应（empty）：

```json
{
  "code": 0,
  "message": "ok",
  "data": {
    "state": "empty"
  }
}
```

## 4. 聊天

### GET `/chat/sessions/{sessionId}/messages`

响应：

```json
{
  "code": 0,
  "message": "ok",
  "data": {
    "list": [
      { "id": 1, "sender": "Sarah", "direction": "incoming", "text": "嗨，很高兴认识你。" },
      { "id": 2, "sender": "我", "direction": "outgoing", "text": "我也是，今天过得怎么样？" }
    ],
    "nextCursor": ""
  }
}
```

### POST `/chat/sessions/{sessionId}/messages`

请求：

```json
{
  "text": "你好呀"
}
```

响应：

```json
{
  "code": 0,
  "message": "ok",
  "data": {
    "id": 3,
    "sender": "我",
    "direction": "outgoing",
    "text": "你好呀"
  }
}
```

## 5. 安全与风控接口

1. POST `/chat/sessions/{sessionId}/report`
2. POST `/chat/sessions/{sessionId}/block`
3. DELETE `/users/me`（账号删除）

