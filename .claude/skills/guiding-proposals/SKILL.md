---
name: guiding-proposals
description: "提案创建框架。当用户想要提出新功能或改进建议时使用。"
tools: Read, Write, Edit, Bash(ls:*), Bash(mkdir:*)
---

# 提案创建框架

## 概述

引导用户通过 3 轮访谈创建功能提案（Proposal），用于团队讨论和评审。

## 命名规则

格式: `{feature-name}`
示例: `batch-translation`、`conflict-resolution`、`cli-tool`

## 目录结构

```
docs/team/proposals/{YYYY-MM}/{feature-name}/
├── proposal.md
└── attachments/（可选）
```

## 访谈流程

### 第 1 轮：问题与目标

必须确认：
1. 要解决什么问题？（现状痛点）
2. 期望的理想状态？
3. 目标用户是谁？
4. 涉及的功能模块？（server / app / model / parsers / translators）

### 第 2 轮：方案与范围

必须确认：
1. 初步的解决方案？
2. 功能边界（做什么、不做什么）？
3. 对现有功能的影响？
4. 是否需要新的依赖或服务？

### 第 3 轮：优先级与风险

必须确认：
1. 优先级（P0-P3）？
2. 预估工作量（S/M/L/XL）？
3. 已知风险和挑战？
4. 是否需要拆分为多个 Spec？

## 输出模板

```markdown
# 提案: {功能名称}

## 状态
- 状态: 待评审
- 优先级: {P0-P3}
- 工作量: {S/M/L/XL}
- 作者: {作者}
- 日期: {YYYY-MM-DD}

## 问题描述
{现状和痛点}

## 目标
{期望达到的效果}

## 方案概述
{初步解决方案}

## 范围
### 包含
- {功能点 1}
- {功能点 2}

### 不包含
- {排除项 1}

## 影响分析
### 涉及的包
- [ ] packages/server
- [ ] packages/model
- [ ] packages/parsers
- [ ] packages/translators
- [ ] packages/utils
- [ ] apps/ttpolyglot

### 数据库变更
{是否需要新迁移}

### API 变更
{是否需要新端点}

## 风险
- {风险 1}: {缓解措施}

## 后续步骤
批准后拆分为 Spec:
- [ ] Spec 1: {名称}
- [ ] Spec 2: {名称}（如需要）
```

## 状态流转

```
待评审 → 已批准 → 转入 Spec
       → 已拒绝
       → 需修改 → 待评审
```

## 注意事项

- 每轮访谈后总结确认，再进入下一轮
- 不要跳过任何一轮
- 如果用户不确定某些细节，标记为 TBD
- 提案批准后，使用 `/spec:create` 创建具体的 Spec
