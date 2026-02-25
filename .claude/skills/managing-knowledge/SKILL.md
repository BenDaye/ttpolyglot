---
name: managing-knowledge
description: "TTPolyglot 项目的知识和经验管理。"
tools: Read, Write, Edit
---

# 知识管理

## 概述

管理 TTPolyglot 项目的经验和知识，供团队成员参考和复用。

## 知识存储

知识记录在 Serena memories 中，按主题分类：

### 主题分类

| 主题 | 用途 | 示例 |
|------|------|------|
| `patterns/{名称}` | 代码模式和最佳实践 | `patterns/controller-execute` |
| `troubleshooting/{名称}` | 问题排查和解决方案 | `troubleshooting/drift-migration` |
| `architecture/{名称}` | 架构决策记录 | `architecture/service-layers` |
| `integrations/{名称}` | 第三方集成经验 | `integrations/google-translate` |

## 记录时机

### 应该记录

- 解决了一个非显而易见的问题
- 发现了一个有用的代码模式
- 做出了重要的架构决策
- 集成第三方服务时的关键配置
- 常见错误的排查步骤

### 不应记录

- 显而易见的修改（改个变量名）
- 一次性的调试过程
- 未经验证的猜测
- 已在 CLAUDE.md 或 README.md 中记录的内容

## 经验记录模板

```markdown
# {标题}

## 场景
{遇到的问题或需求}

## 解决方案
{具体的解决方式}

## 关键代码
{核心代码片段}

## 注意事项
{需要注意的坑或限制}

## 相关文件
- `{文件路径}` - {说明}
```

## 使用方式

### 写入知识

使用 Serena 的 `write_memory` 工具：
```
memory_name: patterns/batch-import-merge
content: ...
```

### 查询知识

使用 Serena 的 `read_memory` 或 `list_memories` 工具：
```
topic: troubleshooting
```

### 更新知识

使用 Serena 的 `edit_memory` 工具更新已有记录。
