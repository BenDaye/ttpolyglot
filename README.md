# TTPolyglot 🌍

> **让每个开发者都成为多语言专家**

TTPolyglot 是一个开发者友好的翻译管理平台，专为让非开发人员也能轻松参与翻译工作而设计。就像 Polyglot 程序员精通多种编程语言一样，TTPolyglot 帮助团队精通多种人类语言，打造真正的全球化产品。

![TTPolyglot](https://img.shields.io/badge/TTPolyglot-v0.1.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.6+-0175C2.svg)
![Shelf](https://img.shields.io/badge/Shelf-Backend-green.svg)
![Melos](https://img.shields.io/badge/Melos-Monorepo-orange.svg)
![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)

---

> **🚧 项目状态**：目前处于早期开发阶段，核心架构已完成，正在积极开发业务功能。欢迎 Star 关注项目进展！

## 📑 目录

- [核心特性](#-核心特性)
- [技术架构](#️-技术架构)
- [快速开始](#-快速开始)
  - [前置要求](#前置要求)
  - [安装依赖](#安装依赖)
  - [启动开发环境](#启动开发环境)
- [开发指南](#️-开发指南)
  - [开发命令](#开发命令)
  - [数据库管理](#数据库管理)
  - [构建和部署](#构建和部署)
- [API 文档](#-api-文档)
- [开发路线图](#-开发路线图)
- [项目亮点](#-项目亮点)
- [贡献指南](#-贡献指南)
- [常见问题](#-常见问题-faq)
- [相关资源](#-相关资源)

<!-- 
## 📸 功能展示

TODO: 添加应用截图和功能演示

- 翻译项目管理界面
- 多语言翻译编辑器
- 团队协作界面
- 统计仪表板

-->

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
- **跨平台支持**：Web、macOS、Windows、Linux、iOS、Android
- **文件格式支持**：JSON、YAML、CSV、PO、Dart ARB 等
- **实时同步**：本地文件与云端的智能同步（开发中）
- **冲突解决**：自动检测并提供冲突解决方案（计划中）
- **Monorepo 架构**：使用 Melos 管理多包依赖
- **类型安全**：Dart 强类型系统 + Drift ORM 的编译时检查
- **容器化部署**：Docker + Docker Compose 一键部署
- **现代化后端**：基于 Shelf 的轻量级高性能 REST API

## 🏗️ 技术架构

### 架构设计
```
本地项目文件 ←→ TTPolyglot Platform ←→ 其他客户端
     ↑                    ↑                    ↑
   主要编辑             同步中心              拉取数据
```

### 核心包说明

#### 📦 Core Package
核心业务逻辑包，提供：
- **47+ 种语言支持**：内置多种语言及其变体（en-US, zh-CN 等）
- **数据模型**：Language, Project, TranslationEntry, User 等
- **业务逻辑**：项目管理、翻译管理、翻译键创建
- **验证工具**：语言代码验证、翻译键格式验证
- **工具类**：TranslationUtils 提供各种翻译相关工具方法

详见：[packages/core/README.md](packages/core/README.md)

#### 📦 Model Package
共享数据模型包，用于跨包的数据结构定义。

#### 📦 Parsers Package
文件解析器包，支持多种翻译文件格式：
- JSON / JSON5
- PO / POT (Gettext)
- YAML / YML
- CSV
- Dart ARB
- 更多格式开发中...

#### 📦 Translators Package
翻译服务集成包，计划支持：
- Google Translate API
- 百度翻译 API
- 腾讯云翻译 API
- DeepL API
- 自定义翻译服务接口

#### 📦 Server Package
后端服务包，基于 Shelf 框架构建的 REST API：
- **认证授权**：JWT Token + RBAC 权限系统
- **数据库**：Drift ORM + PostgreSQL
- **缓存**：Redis 多级缓存
- **中间件**：
  - 认证中间件（Auth）
  - 权限中间件（Permission）
  - 限流中间件（Rate Limit）
  - 日志中间件（Logging）
  - 错误处理中间件
  - CORS 跨域支持
- **API 模块**：
  - 用户管理
  - 项目管理
  - 翻译管理
  - 文件上传
  - 语言管理
  - 系统配置

### 技术栈
- **后端框架**：Shelf (Dart) + Drift ORM
- **前端框架**：Flutter (支持 Web、Desktop、Mobile)
- **数据库**：PostgreSQL + Redis (缓存)
- **认证授权**：JWT + RBAC 权限系统
- **工作区管理**：Melos

### 项目结构
```
ttpolyglot/
├── packages/
│   ├── core/           # 核心业务逻辑和数据模型
│   ├── model/          # 共享数据模型
│   ├── parsers/        # 多格式文件解析器 (JSON, PO, YAML等)
│   ├── translators/    # 翻译服务集成 (Google, 百度, 腾讯等)
│   └── server/         # 后端 REST API 服务
│       ├── controllers/    # API 控制器
│       ├── services/       # 业务服务层
│       ├── middleware/     # 中间件 (认证、日志、限流等)
│       └── routes/         # 路由定义
└── apps/
    └── ttpolyglot/     # Flutter 跨平台应用
```

## 🚀 快速开始

### 前置要求
- **Flutter SDK** >= 3.0.0
- **Dart SDK** >= 3.6.1
- **PostgreSQL** >= 13.0
- **Redis** >= 6.0 (可选，用于缓存)
- **Melos** >= 6.0.0
- **Docker** & **Docker Compose** (推荐，用于容器化部署)

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

#### 启动后端服务

**方式 1：Docker Compose（推荐）**
```bash
# 进入 server 包目录
cd packages/server

# 一键启动所有服务（PostgreSQL + Redis + Server）
sh start-docker.sh

# 查看日志
docker-compose logs -f server
```

**方式 2：本地开发**
```bash
# 进入 server 包目录
cd packages/server

# 配置环境变量（首次运行）
cp .env.example .env
# 编辑 .env 文件，配置数据库连接等信息：
# DATABASE_HOST=localhost
# DATABASE_PORT=5432
# DATABASE_NAME=ttpolyglot
# DATABASE_USER=postgres
# DATABASE_PASSWORD=your_password
# REDIS_HOST=localhost
# REDIS_PORT=6379
# JWT_SECRET=your_secret_key

# 运行数据库迁移
dart run bin/migrate.dart

# 启动后端服务
dart run bin/server.dart
# 服务默认运行在 http://localhost:8080
```

#### 启动前端应用
```bash
# 进入应用目录
cd apps/ttpolyglot

# 运行 Web 版本
flutter run -d chrome

# 运行桌面版本
flutter run -d macos  # 或 windows / linux

# 运行移动版本
flutter run -d ios    # 或 android
```

### CLI 工具（开发中）
> CLI 工具正在开发中，计划提供以下功能：

```bash
# 初始化项目配置
ttpolyglot init

# 推送本地翻译文件到云端
ttpolyglot push

# 拉取云端更新到本地
ttpolyglot pull

# 实时监听并同步变更
ttpolyglot watch

# 导出翻译文件
ttpolyglot export --format json
```

## 🛠️ 开发指南

### 开发命令
```bash
# 分析代码质量
melos exec -- dart analyze

# 运行所有包的测试
melos exec -- dart test

# 为 server 包生成数据库代码
cd packages/server
dart run build_runner build

# 清理所有包的构建产物
melos clean
```

### 数据库管理
```bash
# 进入 server 目录
cd packages/server

# 修改数据库模型后重新生成代码
dart run build_runner build --delete-conflicting-outputs

# 运行数据库迁移
dart run bin/migrate.dart

# 使用 Docker 启动数据库
docker-compose up -d postgres redis
```

### 构建和部署
```bash
# 构建 Web 应用
cd apps/ttpolyglot
flutter build web

# 构建桌面应用
flutter build macos    # 或 windows / linux

# 构建移动应用
flutter build apk      # Android
flutter build ios      # iOS

# 构建后端 Docker 镜像
cd packages/server
docker build -t ttpolyglot-server .

# 使用 Docker Compose 部署完整系统
sh start-docker.sh
```

## 📡 API 文档

### REST API

后端服务提供完整的 REST API，默认运行在 `http://localhost:8080`

#### 认证

大部分 API 需要 JWT Token 认证：

```bash
# 登录获取 Token
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password"}'

# 使用 Token 访问受保护的 API
curl -X GET http://localhost:8080/api/projects \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### 主要 API 端点

```
认证相关
POST   /api/auth/login              # 用户登录
POST   /api/auth/register           # 用户注册
POST   /api/auth/refresh            # 刷新 Token
POST   /api/auth/logout             # 用户登出

用户管理
GET    /api/users                   # 获取用户列表
GET    /api/users/:id               # 获取用户详情
PUT    /api/users/:id               # 更新用户信息
DELETE /api/users/:id               # 删除用户

项目管理
GET    /api/projects                # 获取项目列表
POST   /api/projects                # 创建项目
GET    /api/projects/:id            # 获取项目详情
PUT    /api/projects/:id            # 更新项目
DELETE /api/projects/:id            # 删除项目

翻译管理
GET    /api/projects/:id/translations           # 获取翻译列表
POST   /api/projects/:id/translations           # 创建翻译
PUT    /api/translations/:id                    # 更新翻译
DELETE /api/translations/:id                    # 删除翻译

语言管理
GET    /api/languages               # 获取支持的语言列表

文件操作
POST   /api/files/upload            # 上传翻译文件
POST   /api/projects/:id/import     # 导入翻译文件
GET    /api/projects/:id/export     # 导出翻译文件

权限管理
GET    /api/roles                   # 获取角色列表
GET    /api/permissions             # 获取权限列表
POST   /api/roles/:id/permissions   # 为角色分配权限
```

详细的 API 文档可以通过访问 `http://localhost:8080/api/docs` 查看（开发中）。

## 📋 开发路线图

### 🎯 第一阶段：基础架构（进行中）
- [x] Melos Monorepo 工作区搭建
- [x] Core 包：核心业务逻辑和数据模型
- [x] Model 包：共享数据模型
- [x] Server 包：后端 REST API 服务
  - [x] JWT 认证授权系统
  - [x] RBAC 权限管理
  - [x] 数据库 ORM (Drift)
  - [x] Redis 缓存支持
  - [x] 完整的中间件系统
- [x] Parsers 包：多格式文件解析
- [x] Flutter 应用基础框架
- [ ] 完善前后端集成
- [ ] 基础 UI 界面开发

### 🤝 第二阶段：核心功能（计划中）
- [ ] 项目管理（创建、编辑、删除）
- [ ] 翻译键管理和编辑
- [ ] 多语言文件导入/导出
- [ ] 本地文件同步机制
- [ ] 用户管理和团队协作
- [ ] 翻译进度统计和可视化

### 🚀 第三阶段：高级功能（规划中）
- [ ] 实时多人协作编辑
- [ ] AI 翻译服务集成（Google, 百度, 腾讯等）
- [ ] 翻译记忆和术语库
- [ ] 审核工作流
- [ ] 评论和讨论系统
- [ ] CLI 工具开发
- [ ] API 接口开放
- [ ] WebSocket 实时通信

## 🎨 与 i18n-ally 的对比

| 特性           | i18n-ally    | TTPolyglot        |
| -------------- | ------------ | ----------------- |
| 运行环境       | VS Code 扩展 | 跨平台应用 + Web  |
| 多人协作       | ❌            | ✅ (计划中)        |
| 实时同步       | ❌            | ✅ (计划中)        |
| 审核工作流     | ❌            | ✅ (计划中)        |
| AI 翻译        | ❌            | ✅ (计划中)        |
| 非技术用户友好 | ❌            | ✅                 |
| 本地文件优先   | ✅            | ✅                 |
| 权限管理       | ❌            | ✅ (已实现 RBAC)   |
| 离线使用       | ✅            | ✅ (桌面应用支持)  |
| 自托管         | N/A          | ✅                 |

## 🎯 项目亮点

### 技术优势
- **🚀 全栈 Dart**：前后端统一使用 Dart 语言，代码共享，降低学习成本
- **📱 真·跨平台**：一套代码，支持 6 大平台（Web + 桌面 + 移动）
- **🏗️ Monorepo 架构**：Melos 管理，模块化清晰，易于维护和扩展
- **🔐 企业级安全**：JWT + RBAC 权限系统，支持细粒度权限控制
- **⚡ 高性能缓存**：Redis 多级缓存 + Drift ORM，性能优异
- **🐳 容器化**：Docker Compose 一键部署，支持自托管
- **🎨 现代化 UI**：Material Design 3，美观易用

### 开发体验
- **类型安全**：Dart 强类型 + 编译时检查，减少运行时错误
- **热重载**：Flutter 热重载，极速开发调试
- **完整工具链**：从开发、测试到部署的完整工具支持
- **清晰架构**：分层设计，Controller → Service → Repository

## 🌟 品牌故事

TTPolyglot 是 **TT 品牌家族** 的一员：
- **TTPOS**：餐饮业的技术专家
- **TTPolyglot**：全球化的语言专家

我们的共同价值观：**让复杂的事情变简单**

## 🤝 贡献指南

我们欢迎所有形式的贡献！无论是报告 bug、提出功能建议，还是提交代码。

### 如何贡献

1. **Fork 项目**
2. **创建功能分支**
   ```bash
   git checkout -b feature/amazing-feature
   # 或者
   git checkout -b fix/bug-fix
   ```
3. **提交更改**
   ```bash
   git commit -m 'feat: Add amazing feature'
   # 遵循 Conventional Commits 规范
   ```
4. **推送到分支**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **创建 Pull Request**

### 开发规范

#### 代码风格
- 使用 `dart analyze` 检查代码质量
- 遵循 Dart/Flutter 官方代码规范
- 遵循项目的 workspace rules（见 `.cursor/rules` 目录）
  - 使用 `dart:developer` 的 `log` 替代 `print`
  - 使用 `double` 类型表示尺寸（如 `10.0` 而非 `10`）
  - border radius 只使用 `2.0`, `4.0`, `8.0`

#### 测试
- 为新功能添加单元测试
- 确保所有测试通过：`melos exec -- dart test`
- 保持测试覆盖率

#### 文档
- 更新相关的 README 文档
- 为公共 API 添加文档注释
- 更新 CHANGELOG

#### Commit 规范
遵循 [Conventional Commits](https://www.conventionalcommits.org/)：
- `feat:` 新功能
- `fix:` Bug 修复
- `docs:` 文档更新
- `style:` 代码格式（不影响代码运行）
- `refactor:` 重构
- `test:` 测试相关
- `chore:` 构建过程或辅助工具的变动

## 📄 许可证

本项目采用 Apache License 2.0 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 💬 社区与支持

- **文档**：[https://docs.ttpolyglot.dev](https://docs.ttpolyglot.dev)（建设中）
- **问题报告**：[GitHub Issues](https://github.com/ttpolyglot/ttpolyglot/issues)
- **讨论**：[GitHub Discussions](https://github.com/ttpolyglot/ttpolyglot/discussions)
- **邮件**：support@ttpolyglot.dev

## ❓ 常见问题 (FAQ)

<details>
<summary><strong>Q: TTPolyglot 与其他翻译管理平台有什么区别？</strong></summary>

A: TTPolyglot 的核心理念是"本地文件优先"，不强制将翻译文件托管在云端。开发者可以继续使用 Git 管理翻译文件，同时享受云端协作的便利。此外，TTPolyglot 是开源的，支持自托管部署。
</details>

<details>
<summary><strong>Q: 是否需要修改现有的项目代码？</strong></summary>

A: 不需要。TTPolyglot 支持多种主流翻译文件格式（JSON, YAML, PO 等），可以直接导入现有的翻译文件。CLI 工具（开发中）可以与现有的开发工作流无缝集成。
</details>

<details>
<summary><strong>Q: 支持哪些编程语言和框架？</strong></summary>

A: TTPolyglot 是语言和框架无关的翻译管理平台。只要您的项目使用支持的文件格式（JSON, YAML, PO 等），就可以使用 TTPolyglot。已在 Flutter、Vue、React 等框架中测试。
</details>

<details>
<summary><strong>Q: 数据安全如何保障？</strong></summary>

A: 
- 支持自托管部署，数据完全掌握在自己手中
- 使用 JWT + RBAC 权限系统，细粒度控制访问权限
- 支持 HTTPS 加密传输
- 密码使用 bcrypt 加密存储
- 支持数据备份和恢复
</details>

<details>
<summary><strong>Q: 可以离线使用吗？</strong></summary>

A: 可以。桌面应用支持离线编辑翻译，待网络恢复后自动同步到云端（功能开发中）。
</details>

<details>
<summary><strong>Q: 如何参与项目开发？</strong></summary>

A: 查看[贡献指南](#-贡献指南)了解如何参与。我们欢迎各种形式的贡献，包括代码、文档、测试、设计等。
</details>

<details>
<summary><strong>Q: 项目的技术栈选择？</strong></summary>

A: 
- **前端**：Flutter - 真正的跨平台，一套代码支持 6 大平台
- **后端**：Shelf + Drift - 轻量级高性能，与前端使用相同语言（Dart）
- **数据库**：PostgreSQL - 成熟稳定的关系型数据库
- **缓存**：Redis - 高性能缓存方案
- **工作区**：Melos - Dart/Flutter 生态的 Monorepo 最佳实践
</details>

## 📚 相关资源

### 技术文档
- [Flutter 官方文档](https://docs.flutter.dev/)
- [Dart 语言指南](https://dart.dev/guides)
- [Shelf 框架文档](https://pub.dev/packages/shelf)
- [Drift ORM 文档](https://drift.simonbinder.eu/)
- [Melos 工作区管理](https://melos.invertase.dev/)

### 设计参考
- [Material Design 3](https://m3.material.io/)
- [Flutter 设计指南](https://docs.flutter.dev/ui)

### 翻译标准
- [Unicode CLDR](https://cldr.unicode.org/)
- [ISO 639 语言代码](https://www.loc.gov/standards/iso639-2/php/code_list.php)
- [ISO 3166 国家代码](https://www.iso.org/iso-3166-country-codes.html)

## 🙏 致谢

感谢 [i18n-ally](https://github.com/lokalise/i18n-ally) 项目提供的灵感和参考。

---

**TTPolyglot - Speak Every Language** 🌍✨ 
