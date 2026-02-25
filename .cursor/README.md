# .cursor 目录说明

本目录内容由 `.claude` 迁移而来，供 Cursor IDE 使用。

## 目录结构

- **rules/** - AI 规则（何时应用、如何编写/审查/提交等）
  - 全局/代码：`styles.mdc`、`code-style.mdc`、`structure.mdc`、`packages.mdc`
  - 角色/流程：`code-reviewer.mdc`、`feature-dev.mdc`、`activity-logger.mdc`
  - 提交与 Spec：`commit.mdc`、`spec-create.mdc`、`spec-design.mdc`、`spec-check.mdc`
  - 提案与知识：`guiding-proposals.mdc`、`guiding-specs.mdc`、`managing-knowledge.mdc`
- **templates/** - 文档模板
  - `proposal.md` - 提案
  - `requirements.md` - 需求规格
  - `design.md` - 技术设计
  - `tasks.md` - 任务分解
- **mcp.json** - MCP 服务器配置（已存在）

## 原 .claude/settings 对应说明

原 `settings.json` 中的配置在 Cursor 中需在「设置」或项目配置中另行设定：

- **env**：如 `ENABLE_TOOL_SEARCH` 等环境开关，按需在 Cursor 或环境中配置。
- **permissions**：如 `defaultMode: bypassPermissions`，在 Cursor 的权限/沙箱设置中配置。
- **enabledPlugins**：原启用插件（commit-commands、code-review、code-simplifier、learning-output-style、feature-dev、security-guidance）对应能力已通过本目录下的规则体现，Cursor 扩展请在扩展市场单独安装并启用。

## 规则使用方式

- 带 `alwaysApply: true` 的规则（如 `styles.mdc`）会始终参与对话。
- 其余规则按描述在相关场景下被引用（如「实现功能」时参考 `feature-dev.mdc`，「写提交信息」时参考 `commit.mdc`）。
- 创建 Spec/提案时，可提示 AI 使用 `rules/spec-create.mdc` 或 `rules/guiding-proposals.mdc`，并引用 `templates/` 下对应模板。
