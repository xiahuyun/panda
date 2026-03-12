# Panda Mobile 埋点事件表 (MVP)

实现说明（当前阶段）：
1. 事件先本地打印（console/logger），不接入远端埋点平台。
2. 事件结构按下表固定，后续可无缝切换到真实上报。

## 1. 事件命名约定

格式：`module_action_result`

示例：
1. `login_submit_click`
2. `login_verify_success`
3. `login_verify_fail`
4. `nav_to_affinity_active`
5. `affinity_wait_click`
6. `affinity_interested_click`
7. `affinity_match_result`

## 2. 事件清单

| 事件名 | 触发时机 | 必填属性 |
| --- | --- | --- |
| `app_launch` | App 启动 | `app_version` |
| `login_page_view` | 登录页展示 | `page_key=login` |
| `login_submit_click` | 点击登录/注册按钮 | `phone_length` |
| `login_submit_blocked` | 输入状态从合法变为非法时触发 | `phone_length`, `code_length` |
| `login_verify_success` | mock 验证通过 | `phone_length`, `code_length` |
| `login_verify_fail` | mock 验证失败 | `phone_length`, `code_length`, `error=验证码错误` |
| `login_error_modal_show` | 错误弹窗展示 | `error=验证码错误` |
| `login_error_modal_auto_close` | 错误弹窗 3 秒自动关闭 | `duration_ms=3000` |
| `nav_to_affinity_active` | 登录成功后跳转缘分墙活跃态 | `from=login`, `to=affinity_active` |
| `affinity_active_page_view` | 缘分墙活跃态展示 | `page_key=affinity_active` |
| `affinity_wait_click` | 点击再等等 | `profile_id`, `date_key` |
| `affinity_interested_click` | 点击感兴趣 | `profile_id`, `date_key` |
| `affinity_daily_action_locked` | 当天动作已锁定再次触发动作（静默忽略，无 UI 反馈） | `date_key`, `locked_action`, `attempted_action`, `ui_feedback=silent_ignore` |
| `affinity_match_result` | 感兴趣后产出 mock 匹配结果 | `profile_id`, `matched`, `rule=profile_id_eq_p_001` |
| `affinity_unmatched_toast_show` | 感兴趣未匹配时 toast 展示 | `message=今日匹配已用完，请明日再来` |
| `nav_to_message_placeholder` | 缘分墙跳转消息占位页 | `from=affinity_active`, `to=message_placeholder`, `conversation_id` |
| `message_placeholder_page_view` | 消息占位页展示 | `page_key=message_placeholder` |
| `nav_back_to_affinity_active` | 从消息占位页返回缘分墙 | `from=message_placeholder`, `to=affinity_active` |

## 3. 字段规范

1. 不上传完整手机号与验证码。
2. `phone_length`、`code_length` 使用整数。
3. 错误码/错误文案字段统一使用 `error`。
4. `login_submit_blocked` 仅在输入状态从合法变为非法时触发，不在点击禁用按钮时触发。
5. 输入持续非法时不重复触发 `login_submit_blocked`；恢复合法后再次变非法可再次触发。
6. 首次进入登录页的初始非法态不触发 `login_submit_blocked`。
7. `date_key` 格式统一为本地自然日 `YYYY-MM-DD`。
8. D5 P0 动作事件只做本地打印，不上报远端。
9. 锁定后再次点击仅记录 `affinity_daily_action_locked`，不触发 toast。
10. `conversation_id` 生成规则固定为 `profile_id + "_" + date_key`。
11. 00:00 重置为到点即时生效（页面停留中也立即执行），不依赖 `onShow` 触发。
12. 推荐分配遵循用户循环历史去重：同一用户当前循环内不应再次产出已推荐 `profile_id`。
13. 当未推荐池耗尽时，次日 00:00 触发 `cycleHistory` 重置后进入新循环推荐（本地打印即可）。
14. “上一自然日最后展示对象”按系统最后一次成功分配推荐对象定义。
15. 新循环首卡优先不等于上一自然日末卡；若无可选候选可允许重复（本地打印即可）。
16. MVP 阶段 `nav_back_to_affinity_active` 不新增 `date_key/profile_id` 字段，也不要求“重算完成后再触发”。
