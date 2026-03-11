# Panda Design Tokens

项目来源: `https://stitch.withgoogle.com/projects/14672720946715964150`  
提取时间: 2026-03-10  
提取范围: 10 个 screen 中 8 个可导出 HTML（2 个为图片资源，无结构化样式可提取）

> 说明: 本文档用于设计评审与语义解释，`tokens/panda.tokens.json` 才是开发与 lint 的唯一真源。

## 提取方法

1. 从 Stitch screen 的 `htmlCode.downloadUrl` 下载 HTML。
2. 解析 `tailwind.config.extend.colors` 和 `borderRadius`。
3. 统计 class token 频次（颜色、字号、间距、圆角、阴影、字重）。
4. 将分散值归一为可落地的设计 token（Primitive + Semantic）。

---

## 1) 原始颜色提取（Custom Colors）

以下颜色来自 Stitch 导出的 Tailwind 配置（非推测）:

| Raw Key | Value | 出现情况 |
| --- | --- | --- |
| `primary` | `#FF8A8A` | 8/8 HTML |
| `background-light` | `#FDF5ED` | 7/8 HTML |
| `background-light` (变体) | `#F8F5F5` | 1/8 HTML |
| `background-dark` | `#230F0F` | 8/8 HTML |
| `text-sub` / `text-secondary` / `soft-taupe` | `#8D5E5E` | 多页面 |
| `text-main` | `#181010` | 3 页 |
| `text-main` (变体) | `#332222` | 1 页 |
| `neutral-warm` | `#F5F0F0` | 3 页 |
| `neutral-muted` | `#E5E1DA` | 1 页 |
| `chat-blue` | `#E3F2FD` | 1 页 |
| `chat-pink` | `#FFE4E4` | 1 页 |
| `accent-green` | `#E8F5E9` | 1 页 |
| `warm-grey` | `#4A4542` | 1 页 |

---

## 2) Primitive Tokens（归一化）

> 命名建议遵循: `color.*` / `font.*` / `space.*` / `radius.*` / `shadow.*`

### 2.1 Color Tokens

```yaml
color.brand.primary: "#FF8A8A"
color.bg.canvas: "#FDF5ED"
color.bg.canvas.alt: "#F8F5F5"   # 少量页面出现
color.bg.dark: "#230F0F"

color.text.primary: "#181010"
color.text.primary.alt: "#332222" # 视觉更柔和的主文字
color.text.secondary: "#8D5E5E"
color.text.tertiary: "#4A4542"

color.surface.base: "#FFFFFF"
color.surface.warm: "#F5F0F0"
color.surface.muted: "#E5E1DA"

color.chat.incoming: "#E3F2FD"
color.chat.outgoingSoft: "#FFE4E4"
color.accent.successSoft: "#E8F5E9"
```

### 2.2 Typography Tokens

原始字体来源:
- 主字体: `Plus Jakarta Sans`（含中文回退 `Noto Sans SC`）
- 图标字体: `Material Symbols Outlined`

字号（由 class 统计得到）:

```yaml
font.family.base: "Plus Jakarta Sans, Noto Sans SC, sans-serif"
font.family.icon: "Material Symbols Outlined"

font.size.xs2: 10
font.size.xs: 11
font.size.sm: 12
font.size.md: 14
font.size.base: 16
font.size.lg: 18
font.size.xl: 20
font.size.2xl: 24
font.size.3xl: 30
font.size.icon.xl: 32

font.weight.regular: 400
font.weight.medium: 500
font.weight.semibold: 600
font.weight.bold: 700

font.lineHeight.tight: 1.25
font.lineHeight.normal: 1.5
font.lineHeight.relaxed: 1.625
```

### 2.3 Spacing Tokens

根据页面高频间距类（`p-4`, `gap-2`, `px-6`, `py-3` 等）归一化:

```yaml
space.1: 4
space.2: 8
space.3: 12
space.4: 16
space.5: 20
space.6: 24
space.8: 32
space.12: 48
space.14: 56   # 常见输入框/按钮高度 h-14
space.24: 96
space.32: 128
```

### 2.4 Radius Tokens

Stitch 导出存在 2 套圆角参数（早期较小 / 新版较大），按多数页面统一:

```yaml
radius.md: 16        # DEFAULT = 1rem
radius.lg: 32        # 主流页面 lg = 2rem
radius.xl: 48        # 主流页面 xl = 3rem
radius.full: 9999
```

补充: 气泡常见 `rounded-2xl`，建议在移动端落地为 `16` 或 `20`，并配合单侧角裁切。

### 2.5 Shadow Tokens

页面高频阴影:

```yaml
shadow.sm: "shadow-sm"
shadow.md: "shadow-md"
shadow.lg: "shadow-lg"
shadow.brand.sm: "shadow-primary/20"
shadow.brand.md: "shadow-primary/30"
```

---

## 3) Semantic Tokens（建议）

```yaml
semantic.bg.app: "{color.bg.canvas}"
semantic.bg.surface: "{color.surface.base}"
semantic.bg.surfaceMuted: "{color.surface.warm}"
semantic.bg.overlay: "rgba(0,0,0,0.5)"

semantic.text.primary: "{color.text.primary}"
semantic.text.secondary: "{color.text.secondary}"
semantic.text.inverse: "#FFFFFF"
semantic.text.brand: "{color.brand.primary}"

semantic.border.soft: "{color.surface.muted}"
semantic.border.brandSoft: "{color.brand.primary}@20%"

semantic.action.primary.bg: "{color.brand.primary}"
semantic.action.primary.text: "#FFFFFF"
semantic.action.secondary.text: "{color.text.secondary}"

semantic.chat.incoming.bg: "{color.chat.incoming}"
semantic.chat.outgoing.bg: "{color.brand.primary}"
semantic.chat.outgoing.text: "#FFFFFF"
```

---

## 4) 组件级 Token 映射（Panda App）

```yaml
component.button.primary.height: "{space.14}"
component.button.primary.radius: "{radius.full}"
component.button.primary.bg: "{semantic.action.primary.bg}"
component.button.primary.text: "{semantic.action.primary.text}"

component.input.height: "{space.14}"
component.input.radius: "{radius.full}"
component.input.paddingX: "{space.4}"
component.input.bg: "{semantic.bg.surface}"
component.input.border: "{semantic.border.soft}"

component.card.profile.radius: "{radius.lg}"
component.card.profile.bg: "{semantic.bg.surface}"
component.card.profile.shadow: "{shadow.sm}"

component.chat.bubble.radius: 16
component.chat.bubble.incoming.bg: "{semantic.chat.incoming.bg}"
component.chat.bubble.outgoing.bg: "{semantic.chat.outgoing.bg}"
```

---

## 5) 差异与决策记录

1. `background-light` 存在 `#FDF5ED` 与 `#F8F5F5` 两个值，建议主用 `#FDF5ED`，后者作为可选背景变体。
2. `text-main` 存在 `#181010` 与 `#332222`，建议作为 `primary / primary.alt` 双 token。
3. 圆角在不同 screen 版本存在差异（`lg: 1.5rem` 与 `2rem`；`xl: 2rem` 与 `3rem`），建议按多数页面统一为 `32/48`。
4. 部分颜色来自 Tailwind 默认色（如 `slate-*`, `green-*`），文档中未强制固化其 HEX；如需跨端 100% 一致，建议在下一版将这些默认色全部显式化为自定义 token。

---

## 6) 建议落地格式

建议把以上 token 同步维护为:

1. `docs/panda-design-tokens.md`（当前文档，面向设计/评审）
2. `tokens/panda.tokens.json`（机器可读，供 iOS/前端生成代码）
3. iOS 侧映射（如 `Color+Tokens.swift`, `Typography.swift`, `Spacing.swift`）
