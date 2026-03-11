# Panda Mobile 架构记录

更新时间: 2026-03-11

## 记录规则

1. 每完成一个重要功能或里程碑后，若模块边界或依赖关系发生变化，必须更新本文件。
2. 重点记录以下内容：
   - 页面/组件/服务模块划分
   - 关键依赖关系
   - 新增或调整的设计决策
   - 对测试与维护性的影响

## 当前架构（MVP）

1. 页面层：`LoginPage`、`AffinityWallActivePage`
2. 数据层：本地 mock（`panda-mobile/mock/affinity-profiles.mock.json`）
3. 样式层：`tokens/panda.tokens.json` 为唯一真源
4. 运行时：`uni-app x + Vue 3 + UTS/.uvue`

## 架构变更记录

> 示例模板（复制后填写）  
> 日期: YYYY-MM-DD  
> 变更点: xxx  
> 原方案: xxx  
> 新方案: xxx  
> 影响评估: xxx  
> 回滚方案: xxx
