> ⚠️ **本仓已归档**
>
> TTPolyglot 在 2026-05-21 完成方向转向：放弃通用 i18n 工具方向，
> 推倒重做为**菜品垂类多语言语料库**（新仓 `tt-cuisine`）。
>
> - 决策溯源与完整设计：[docs/superpowers/specs/2026-05-21-dish-corpus-redesign-design.md](docs/superpowers/specs/2026-05-21-dish-corpus-redesign-design.md)
> - M0 实施计划：[docs/superpowers/plans/2026-05-21-tt-cuisine-m0-foundation.md](docs/superpowers/plans/2026-05-21-tt-cuisine-m0-foundation.md)
> - 归档 tag：`v0.1.0-i18n-direction-archive`
>
> 本仓保留作历史档案与决策溯源；新开发请前往 `tt-cuisine`。

---

# TTPolyglot 🌍

> **让每个开发者都成为多语言专家**

TTPolyglot 是一个开发者友好的翻译管理平台，专为让非开发人员也能轻松参与翻译工作而设计。就像 Polyglot 程序员精通多种编程语言一样，TTPolyglot 帮助团队精通多种人类语言，打造真正的全球化产品。

![TTPolyglot](https://img.shields.io/badge/TTPolyglot-v0.1.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-Web-blue.svg)
![Serverpod](https://img.shields.io/badge/Serverpod-Backend-green.svg)
![Melos](https://img.shields.io/badge/Melos-Workspace-orange.svg)

## ✨ 核心特性

### 🎯 **开发者友好**
- **本地文件优先**：保持现有的开发工作流
- **版本控制集成**：翻译文件在 Git 中有完整历史
- **离线工作支持**：无需网络连接即可继续开发
- **CLI 工具**：命令行工具无缝集成到构建流程

### 🤝 **协作增强**
- **实时多人编辑**：团队成员可以同时编辑翻译内容
- **审核工作流**：完整的翻译 → 审核 → 发布流程
- **评论讨论**：针对翻译内容的评论和讨论系统
- **权限管理**：管理员、翻译员、审核员角色分工

### 🧠 **智能翻译**
- **AI 翻译集成**：支持 Google、百度、腾讯等翻译服务
- **翻译记忆**：复用历史翻译，确保术语一致性
- **质量检查**：自动检查格式、长度、特殊字符
- **批量操作**：批量翻译、导入、导出功能

### 🔧 **技术集成**
- **多框架支持**：Flutter、Vue、React、Angular 等
- **文件格式支持**：JSON、YAML、CSV、PO、Dart 等
- **实时同步**：本地文件与云端的智能同步
- **冲突解决**：自动检测并提供冲突解决方案

## 🏗️ 技术架构

### 架构设计
```
本地项目文件 ←→ TTPolyglot Platform ←→ 其他客户端
     ↑                    ↑                    ↑
   主要编辑             同步中心              拉取数据
```

### 技术栈
- **后端框架**：Serverpod (Dart)
- **前端框架**：Flutter Web
- **数据库**：PostgreSQL
- **实时通信**：WebSocket
- **工作区管理**：Melos

### 项目结构
```
ttpolyglot/
├── packages/
│   ├── core/           # 核心逻辑
│   ├── parsers/        # 文件解析器
│   ├── translators/    # 翻译服务集成
│   ├── cli/            # CLI 工具
│   ├── client/         # Serverpod 客户端
│   ├── protocol/       # Serverpod 协议
│   └── ui/             # 共享 UI 组件
├── apps/
│   └── ttpolyglot/                       # Flutter 主应用
├── server/
│   └── server/         # Serverpod 后端
└── tools/
    ├── code_generators/           # 代码生成工具
    └── deployment/                # 部署脚本
```

## 🚀 快速开始

### 前置要求
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- PostgreSQL >= 13.0
- Melos >= 3.0.0

### 安装依赖
```bash
# 安装 Melos
dart pub global activate melos

# 克隆项目
git clone https://github.com/ttpolyglot/ttpolyglot.git
cd ttpolyglot

# 初始化工作区
melos bootstrap
```

### 启动开发环境
```bash
# 生成 Serverpod 代码
melos run serverpod:generate

# 启动后端服务
melos run dev:server

# 启动前端应用
melos run dev:web
```

### 使用 CLI 工具
```bash
# 初始化项目
ttpolyglot init

# 推送本地翻译到云端
ttpolyglot push

# 拉取云端更新到本地
ttpolyglot pull

# 监听模式，自动同步变更
ttpolyglot watch
```

## 🛠️ 开发指南

### 开发命令
```bash
# 代码质量检查
melos run lint

# 运行测试
melos run test

# 构建所有平台
melos run build:all

# 生成代码
melos run generate

# 清理项目
melos run clean
```

### 数据库设置
```bash
# 创建数据库迁移
melos run serverpod:create-migration

# 运行数据库迁移
melos run serverpod:migrate
```

### 部署
```bash
# 构建生产版本
melos run build:all

# 构建 Docker 镜像
melos run docker:build

# 部署到生产环境
melos run deploy:prod
```

## 📋 开发路线图

### 🎯 第一阶段：MVP 核心功能
- [x] 基础翻译编辑器
- [x] 本地文件扫描和解析
- [x] 基础的 push/pull 同步功能
- [x] Web 界面显示云端数据

### 🤝 第二阶段：协作功能
- [ ] 实时多人协作编辑
- [ ] 用户权限管理系统
- [ ] 审核工作流
- [ ] 评论和讨论系统

### 🚀 第三阶段：高级功能
- [ ] AI 翻译服务集成
- [ ] 高级导入导出功能
- [ ] API 接口开放
- [ ] 移动端支持

## 🎨 与 i18n-ally 的对比

| 特性         | i18n-ally    | TTPolyglot |
| ------------ | ------------ | ---------- |
| 运行环境     | VS Code 扩展 | Web 平台   |
| 多人协作     | ❌            | ✅          |
| 实时同步     | ❌            | ✅          |
| 审核工作流   | ❌            | ✅          |
| AI 翻译      | ❌            | ✅          |
| 非技术用户   | ❌            | ✅          |
| 本地文件优先 | ✅            | ✅          |

## 🌟 品牌故事

TTPolyglot 是 **TT 品牌家族** 的一员：
- **TTPOS**：餐饮业的技术专家
- **TTPolyglot**：全球化的语言专家

我们的共同价值观：**让复杂的事情变简单**

## 🤝 贡献指南

我们欢迎所有形式的贡献！

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

### 开发规范
- 使用 `melos run lint` 检查代码质量
- 为新功能添加测试
- 更新相关文档

## 📄 许可证

本项目采用 Apache License 2.0 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 💬 社区与支持

- **文档**：[https://docs.ttpolyglot.dev](https://docs.ttpolyglot.dev)
- **问题报告**：[GitHub Issues](https://github.com/ttpolyglot/ttpolyglot/issues)
- **讨论**：[GitHub Discussions](https://github.com/ttpolyglot/ttpolyglot/discussions)

## 🙏 致谢

感谢 [i18n-ally](https://github.com/lokalise/i18n-ally) 项目提供的灵感和参考。

---

**TTPolyglot - Speak Every Language** 🌍✨ 
