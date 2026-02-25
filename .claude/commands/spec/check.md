---
description: 检查 Spec 实现进度
argument-hint: [spec 名称]
allowed-tools: Read, Grep, Glob, Bash(git log:*), Bash(git diff:*)
---

# 任务

检查指定 Spec 的实现进度。

## 流程

### 第 1 步：定位 Spec

```bash
ls .spec-workflow/specs/active/
```

如果提供了 `$1`，直接定位到 `.spec-workflow/specs/active/$1/`

### 第 2 步：读取任务列表

读取 `tasks.md`，解析所有任务及其完成状态。

### 第 3 步：验证实现

对每个标记为完成的任务：
1. 检查文件是否存在
2. 检查关键代码是否实现
3. 使用 Serena 验证符号定义

### 第 4 步：输出报告

```markdown
## Spec 进度报告: {spec 名称}

### 概览
- 总任务数: {N}
- 已完成: {N}（{%}）
- 剩余: {N}

### 任务状态
- [x] 1.1 {描述}
- [x] 1.2 {描述}
- [ ] 2.1 {描述} ⚠️ {问题说明}

### 验证结果
- [x] 文件存在
- [x] 关键符号已定义
- [ ] 测试通过

### 下一步
{建议的后续操作}
```
