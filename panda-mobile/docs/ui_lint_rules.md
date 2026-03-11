# UI Lint Rules for Panda

适用范围: 本仓库所有 UI 代码（`.uvue`, `.vue`, `.scss`, `.css`, `.ts`, `.js`）

关联规范:
- `docs/ui_rules.md`
- `tokens/panda.tokens.json`（唯一真源）

目标: 在提交前自动发现并阻止“未使用 token 的视觉硬编码”。

---

## 1. 核心原则

1. 视觉值必须来自 token，不允许在业务层硬编码。
2. 先定义 token，再使用 token；不允许“先写死，后补票”。
3. Lint 结果必须可自动化执行（本地 + CI 一致）。

---

## 2. 必拦截（Error）

以下命中应直接失败:

1. 颜色硬编码:
   - `#RGB / #RRGGBB / #RRGGBBAA`
   - `rgb()/rgba()/hsl()/hsla()`
2. 尺寸硬编码:
   - `font-size: 15px`、`padding: 13px`、`border-radius: 18px` 等裸值
3. 非 token 字体声明:
   - 业务代码直接写 `font-family`
4. 新增未备案字号档位:
   - 非 token 对应值（10/11/12/14/16/18/20/24/30/32）
5. 主按钮未走 `component.button.primary.*`

---

## 3. 允许例外（需在代码注释标注原因）

仅以下情况可临时豁免:

1. 第三方库覆盖样式（仅限隔离文件）。
2. 渐进迁移中的历史页面（需有迁移任务 ID）。
3. 平台兼容 hack（如特定 iOS 版本 bug）。

标注格式:

```css
/* ui-lint-disable-next-line reason: iOS16 keyboard safe-area bug, ticket: PANDA-123 */
```

---

## 4. 规则实现（推荐）

优先级:
1. `stylelint` 负责 CSS/SCSS/`<style>`。
2. `eslint` 负责 JS/TS/模板内 style object。
3. `rg` 快速兜底扫描（CI second-pass）。

---

## 5. Stylelint 规则建议

建议启用:

1. `declaration-property-value-disallowed-list`
   - 禁止 `color/background/font-size/padding/margin/border-radius` 等属性使用裸值
2. `scale-unlimited/declaration-strict-value`
   - 强制使用变量（token 变量）
3. `font-family-no-missing-generic-family-keyword`
4. `color-no-hex`（若你决定完全禁止 hex）

示例（思路）:

```json
{
  "rules": {
    "declaration-property-value-disallowed-list": {
      "/^(color|background|background-color|font-size|padding|margin|border-radius)$/": ["/.*/"]
    }
  }
}
```

说明: 真正落地时请改为“允许 token 引用，禁止裸值”，不要一刀切禁用所有值。

---

## 6. ESLint 规则建议

针对 TS/JS/模板内对象样式:

1. 禁止对象中出现硬编码色值和 px 值。
2. 禁止 `style={{ color: "#..." }}` 这类直写。
3. 若框架支持，新增自定义规则: `no-raw-ui-values`。

---

## 7. rg 兜底检查（可直接用于 CI）

在仓库根目录执行:

```bash
# 1) 扫颜色硬编码
rg -n --glob '*.{uvue,vue,scss,css,ts,js}' '#([0-9a-fA-F]{3,8})|rgba?\\(|hsla?\\(' .

# 2) 扫常见尺寸硬编码
rg -n --glob '*.{uvue,vue,scss,css,ts,js}' '(font-size|padding|margin|border-radius|gap)\\s*:\\s*[0-9]+px' .

# 3) 扫模板内 style 硬编码
rg -n --glob '*.{uvue,vue}' 'style\\s*=\\s*\"[^\"]*(#|rgba?\\(|[0-9]+px)' .
```

命中处理:
1. 若为业务 UI，必须改为 token。
2. 若为例外，按规范添加 `ui-lint-disable` 注释。

---

## 8. 建议目录约定

1. Token 定义: `tokens/panda.tokens.json`
2. Token 导出层: `src/theme/` 或 `styles/tokens/`
3. 禁止在 `pages/**` 直接维护视觉常量。

---

## 9. CI 门禁建议

合并前至少执行:

1. `ui-lint`（stylelint + eslint）
2. `ui-token-scan`（rg 兜底）

任一失败即阻止合并。

---

## 10. PR Review 清单

1. 有没有新增硬编码颜色和尺寸？
2. 是否优先使用 semantic token？
3. 组件是否遵循 `docs/ui_rules.md`？
4. 是否新增了未备案视觉档位？
5. 异常豁免是否有原因和任务 ID？
