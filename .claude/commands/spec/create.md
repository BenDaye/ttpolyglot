---
description: 创建需求规格文档
argument-hint: [功能名称]
allowed-tools: Read, Write, Edit, Bash(ls:*), Bash(mkdir:*)
---

# 任务

创建一个新的需求规格文档（Spec）。

## 流程

### 第 1 步：确定 Spec 信息

通过与用户对话确认：
1. **功能名称**：简短描述（用于目录名）
2. **功能类型**：story（用户故事）/ task（技术任务）/ bug（缺陷修复）/ spike（技术调研）
3. **涉及范围**：server / app / model / parsers / translators / 多个包

### 第 2 步：创建目录

```bash
mkdir -p .spec-workflow/specs/active/{type}-{feature-name}
```

### 第 3 步：需求访谈（3 轮）

**第 1 轮：核心需求**
- 这个功能要解决什么问题？
- 目标用户是谁？
- 期望的交互方式？

**第 2 轮：细节确认**
- 边界条件和异常场景？
- 与现有功能的关系？
- 数据模型变更？

**第 3 轮：验收标准**
- 如何验证功能正确性？
- 性能要求？
- 需要新增的 API 端点？

### 第 4 步：生成 requirements.md

```markdown
# {功能名称}

## 状态
- Status: draft
- Type: {story|task|bug|spike}
- Scope: {涉及的包}
- Created: {YYYY-MM-DD}

## 背景
{问题描述和上下文}

## 需求
{详细需求列表}

## 验收标准
- [ ] {标准 1}
- [ ] {标准 2}

## 技术约束
{已知的技术限制或依赖}
```

### 第 5 步：确认

将 requirements.md 展示给用户确认，状态改为 `approved` 后可进入设计阶段。
