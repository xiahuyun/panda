# UI Rules for Panda

适用范围: 本仓库所有新建或重构 UI（页面、组件、弹窗、空态、加载态）

关联设计源:
- Design tokens（唯一真源）: `tokens/panda.tokens.json`
- 设计说明（辅助文档，非约束源）: `docs/panda-design-tokens.md`

---

## 1. 设计目标（Style Direction）

`小熊交友` 的 UI 风格应保持:

1. 温暖治愈: 暖底色、柔和对比、圆润形态。
2. 轻社交感: 信息密度中等，不压迫，不极简到冷淡。
3. 可亲近: 大圆角、清晰按钮、可读性优先。
4. 一致性高于“单页创意”: 优先复用已有模式与 token。

---

## 2. 非协商规则（Must）

1. 所有颜色、字号、间距、圆角必须来自 `panda.tokens.json`（唯一真源）。
2. 禁止在业务 UI 中硬编码值（如 `#FF8A8A`、`padding: 13`、`font-size: 15px`）。
3. 所有组件优先使用 semantic token，不直接引用 primitive token（除 token 定义层）。
4. 页面状态按业务需要定义，不强制所有页面都覆盖 `loading`、`empty`、`error`、`content` 四态。
5. 交互控件最小可点区域 >= 44x44（iOS 规范）。
6. 文字对比度需满足可读性要求（正文优先使用 `semantic.text.primary/secondary`）。

---

## 3. 视觉语言约束

### 3.1 颜色

1. 主操作按钮: `semantic.action.primary.bg` + `semantic.action.primary.text`。
2. 页面底色: `semantic.bg.app`。
3. 卡片底色: `semantic.bg.surface`。
4. 聊天气泡:
   - incoming: `semantic.chat.incoming.bg`
   - outgoing: `semantic.chat.outgoing.bg`

### 3.2 字体

1. 字体家族统一使用 token 中的 `font.family.base`。
2. 标题建议使用 `font.weight.bold`，正文优先 `regular/medium`。
3. 不新增未经审批的字号档位。

### 3.3 间距与圆角

1. 页面主栅格以 `space.4`、`space.6`、`space.8` 为基准。
2. 输入框/主按钮高度统一 `space.14`。
3. 输入框/按钮圆角使用 `radius.full`。
4. 卡片圆角优先 `radius.lg`。

### 3.4 阴影

1. 常规卡片优先 `shadow.sm`。
2. 强调按钮可用 `shadow.brandSm` 或 `shadow.brandMd`。
3. 禁止叠加多层重阴影导致“脏 UI”。

---

## 4. 组件级规则

1. `PrimaryButton`
   - 必须使用 `component.button.primary.*` token。
   - 禁止出现次级配色“看起来像主按钮”。
2. `TextInput`
   - 必须使用 `component.input.*` token。
   - 前缀图标与输入文字垂直居中。
3. `ProfileCard`
   - 使用 `component.card.profile.*` token。
4. `ChatBubble`
   - 非 MVP 组件，当前主分支不实现。
   - 后续启用时再按 `component.chatBubble.*` token 落地。

---

## 5. 内容与排版规则

1. 单屏优先一个主任务，避免多主 CTA。
2. 关键动作按钮固定在用户拇指易达区（底部或中下）。
3. 文案语气保持温和、简短，避免运营腔和过度营销词。
4. 空态必须包含:
   - 当前状态说明
   - 下一步建议动作（按钮或链接）

---

## 6. 动效与反馈

1. 动效应“短、轻、可解释”，避免炫技。
2. 推荐时长:
   - 微交互: 120ms - 180ms
   - 页面切换: 180ms - 260ms
3. 所有异步操作必须有反馈:
   - 提交中: loading
   - 成功: toast/snackbar
   - 失败: 可操作错误提示

---

## 7. 可访问性（Accessibility）

1. 动态字体放大后布局不应破坏主流程。
2. 图标按钮必须有可读 label。
3. 不仅用颜色表达状态（需配图标或文案）。
4. 表单错误提示要明确到字段。

---

## 8. Codex 生成 UI 的执行要求（可直接复制到任务描述）

```md
请严格遵守 `docs/ui_rules.md` 与 `tokens/panda.tokens.json` 生成 UI：
1) 只使用 token，不写硬编码视觉值；
2) 复用现有组件模式（按钮/输入框/卡片；聊天相关组件暂不纳入 MVP）；
3) 输出页面状态按业务需要定义，不强制四态全覆盖；
4) 保持“小熊交友”温暖、圆润、轻社交风格；
5) 若需要新增样式，请先新增 token 再使用。
```

---

## 9. Review Checklist（提交前自检）

1. 是否存在硬编码颜色、字号、间距、圆角？
2. 是否所有主操作都使用 primary action token？
3. 页面状态是否与当前业务流程一致？
4. 是否保持视觉风格一致（暖色、圆润、清晰层级）？
5. 是否满足可访问性与点击区域规范？
