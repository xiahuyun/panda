# Panda Mobile 埋点事件表 (MVP)

## 1. 事件命名约定

格式：`module_action_result`

示例：
1. `login_submit_click`
2. `login_verify_success`
3. `login_verify_fail`
4. `nav_to_affinity_active`

## 2. 事件清单

| 事件名 | 触发时机 | 必填属性 |
| --- | --- | --- |
| `app_launch` | App 启动 | `app_version` |
| `login_page_view` | 登录页展示 | `page_key=login` |
| `login_submit_click` | 点击登录/注册按钮 | `phone_length` |
| `login_verify_success` | mock 验证通过 | `phone_length`, `code_length` |
| `login_verify_fail` | mock 验证失败 | `phone_length`, `code_length`, `error=验证码错误` |
| `login_error_modal_show` | 错误弹窗展示 | `error=验证码错误` |
| `login_error_modal_auto_close` | 错误弹窗 3 秒自动关闭 | `duration_ms=3000` |
| `nav_to_affinity_active` | 登录成功后跳转缘分墙活跃态 | `from=login`, `to=affinity_active` |
| `affinity_active_page_view` | 缘分墙活跃态展示 | `page_key=affinity_active` |

## 3. 字段规范

1. 不上传完整手机号与验证码。
2. `phone_length`、`code_length` 使用整数。
3. 错误码/错误文案字段统一使用 `error`。

