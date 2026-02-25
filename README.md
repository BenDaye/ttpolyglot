# TTPolyglot

> **让每个开发者都成为多语言专家**

TTPolyglot 是一个开发者友好的翻译管理平台，专为让非开发人员也能轻松参与翻译工作而设计。就像 Polyglot 程序员精通多种编程语言一样，TTPolyglot 帮助团队精通多种人类语言，打造真正的全球化产品。

![TTPolyglot](https://img.shields.io/badge/TTPolyglot-v1.0.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.27+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.6+-0175C2.svg)
![Shelf](https://img.shields.io/badge/Shelf-Backend-green.svg)
![Melos](https://img.shields.io/badge/Melos-Monorepo-orange.svg)
![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)

---

## 目录

- [核心特性](#核心特性)
- [技术架构](#技术架构)
- [快速开始](#快速开始)
- [开发指南](#开发指南)
- [API 文档](#api-文档)
- [开发路线图](#开发路线图)
- [与 i18n-ally 的对比](#与-i18n-ally-的对比)
- [贡献指南](#贡献指南)
- [常见问题](#常见问题)
- [相关资源](#相关资源)

## 核心特性

### 全栈 Dart Monorepo

前后端统一使用 Dart 语言，通过 Melos 管理 monorepo，模型层跨前后端共享，降低维护成本。

### 跨平台客户端

基于 Flutter 构建，一套代码支持 Web、macOS、Windows、Linux、iOS、Android 六大平台。桌面端支持离线编辑，网络恢复后自动同步。

### 完整的后端服务

基于 Shelf 框架的 REST API，具备：
- JWT + RBAC 权限系统，细粒度角色控制（管理员、翻译员、审核员）
- PostgreSQL 持久化 + Redis 多级缓存
- 完善的中间件链：认证、权限、限流、CORS、日志、错误处理
- 22 个数据库迁移，6 个种子数据文件
- Docker + Nginx 一键部署

### 多格式文件解析

内置 6 种翻译文件格式的完整解析器（读取 + 写入 + 校验）：

| 格式 | 扩展名 | 常见用途 |
|------|--------|----------|
| JSON | `.json` | 通用 (React, Vue 等) |
| YAML | `.yml` / `.yaml` | Ruby on Rails, Spring 等 |
| ARB | `.arb` | Flutter / Dart |
| PO | `.po` | Gettext (WordPress, Django 等) |
| CSV | `.csv` | 电子表格交换 |
| Properties | `.properties` | Java / Android |

### AI 翻译集成

已集成 3 个翻译 API 提供商 + 自定义 API 支持：

| 提供商 | 状态 |
|--------|------|
| Google Translate | 已实现 |
| 百度翻译 | 已实现 |
| 有道翻译 | 已实现 |
| 自定义 API | 已实现 |

支持单条翻译和批量翻译（并行请求多目标语言），内置取消令牌支持。

### 多语言支持

内置 10 种语言：

`en-US` `zh-CN` `zh-TW` `th-TH` `ja-JP` `ko-KR` `my-MM` `tr-TR` `de-DE` `sv-SE`

### 团队协作

- 项目成员管理与邀请链接
- RBAC 权限系统（Owner / Admin / Translator / Reviewer）
- 翻译状态工作流：待翻译 → 翻译中 → 已完成 → 审核中 → 已批准
- 通知系统与审计日志

## 技术架构

### 架构概览

```
Flutter 客户端 (Web/Desktop/Mobile)
         │
         ▼
    Nginx 反向代理 (HTTPS)
         │
         ▼
   Shelf REST API (/api/v1/)
    ├── 中间件链 (RequestId → Logging → CORS → RateLimit → Auth → ErrorHandler)
    ├── Controllers (请求处理)
    ├── Services (业务逻辑)
    └── Infrastructure
         ├── PostgreSQL (Drift ORM)
         └── Redis (Session + Cache)
```

### 技术栈

| 层级 | 技术 |
|------|------|
| 语言 | Dart 3.6+ |
| 前端框架 | Flutter 3.27 |
| 后端框架 | Shelf + shelf_router |
| 状态管理 | GetX |
| HTTP 客户端 | Dio |
| 数据库 | PostgreSQL 15 |
| ORM | Drift + drift_postgres |
| 缓存 | Redis 7 |
| 认证 | JWT (dart_jsonwebtoken) + bcrypt |
| 代码生成 | Freezed + json_serializable + Drift codegen |
| 日志 | Talker |
| Monorepo | Melos |
| 容器化 | Docker + Nginx |

### 项目结构

```
ttpolyglot/
├── apps/
│   └── ttpolyglot/                 # Flutter 跨平台应用
│       └── lib/src/
│           ├── core/               # 核心层
│           │   ├── layout/         #   响应式布局
│           │   ├── routing/        #   路由定义 (GetX)
│           │   ├── theme/          #   主题 (亮色/暗色)
│           │   ├── services/       #   翻译/项目/导出/同步 服务
│           │   ├── storage/        #   平台适配存储
│           │   ├── widgets/        #   通用组件
│           │   ├── platform/       #   平台适配
│           │   └── utils/          #   工具类
│           ├── common/             # 公共层
│           │   ├── api/            #   API 调用 (8 个 API 类)
│           │   ├── network/        #   Dio 封装 + 拦截器
│           │   ├── config/         #   应用配置
│           │   └── services/       #   认证/Token 服务
│           └── features/           # 功能模块
│               ├── sign_in/        #   登录
│               ├── sign_up/        #   注册
│               ├── forgot_password/#   忘记密码
│               ├── reset_password/ #   重置密码
│               ├── dashboard/      #   仪表板
│               ├── projects/       #   项目列表
│               ├── project/        #   项目详情/设置/导入/导出/成员/语言
│               ├── translation/    #   翻译管理
│               ├── settings/       #   用户设置/通知设置
│               ├── profile/        #   个人资料
│               ├── join/           #   接受邀请
│               └── root/           #   应用入口
│
├── packages/
│   ├── server/                     # 后端 REST API
│   │   ├── bin/                    #   server.dart + migrate.dart 入口
│   │   ├── lib/src/
│   │   │   ├── controllers/        #   HTTP 控制器 (auth/project/system/user/language)
│   │   │   ├── services/           #   服务层
│   │   │   │   ├── infrastructure/ #     数据库/Redis/连接池/多级缓存
│   │   │   │   ├── business/       #     认证/用户/项目/翻译/权限/配置 等
│   │   │   │   └── feature/        #     邮件/文件上传/IP定位/监控指标
│   │   │   ├── middleware/         #   中间件 (auth/security/observability/error)
│   │   │   ├── routes/             #   路由定义 (9 个模块)
│   │   │   ├── config/             #   服务器配置
│   │   │   ├── di/                 #   依赖注入
│   │   │   ├── exceptions/         #   自定义异常
│   │   │   └── utils/              #   工具类 (JWT/Crypto/Validator/Response 等)
│   │   ├── database/
│   │   │   ├── migrations/         #   22 个迁移文件
│   │   │   └── seeds/              #   6 个种子文件
│   │   ├── Dockerfile              #   多阶段 AOT 编译
│   │   └── docker-compose.yml      #   PostgreSQL + Redis + Server + Nginx
│   │
│   ├── model/                      # 共享数据模型 (Freezed)
│   │   └── lib/src/
│   │       ├── auth/               #   认证模型 (12 个)
│   │       ├── project/            #   项目模型 (7 个)
│   │       ├── translation/        #   翻译模型 (6 个)
│   │       ├── language/           #   语言模型
│   │       ├── user/               #   用户设置模型
│   │       ├── system/             #   系统/通知/审计模型
│   │       ├── file/               #   文件模型
│   │       ├── network/            #   网络基础模型
│   │       ├── enums/              #   枚举定义 (8 个)
│   │       ├── converter/          #   JSON 转换器
│   │       └── utils/              #   模型工具类
│   │
│   ├── parsers/                    # 翻译文件解析器
│   │   └── lib/src/
│   │       └── parsers/            #   6 个解析器 (JSON/YAML/CSV/ARB/PO/Properties)
│   │
│   ├── translators/                # 翻译 API 集成
│   │   └── lib/src/
│   │       └── translation_api_service.dart  # Google/百度/有道/自定义
│   │
│   └── utils/                      # 共享工具类
│       └── lib/src/                #   Dialog/Logger(Talker)/Toast
│
└── melos.yaml                      # Melos 工作区配置
```

## 快速开始

### 前置要求

- **Dart SDK** >= 3.6.1
- **Flutter SDK** >= 3.27.3
- **PostgreSQL** >= 15
- **Redis** >= 7 (用于 Session 和缓存)
- **Melos** >= 6.0
- **Docker** & **Docker Compose** (推荐)

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

### 启动后端服务

#### 方式 1：Docker Compose（推荐）

```bash
cd packages/server

# 配置环境变量
cp .env.example .env
# 编辑 .env，至少配置: JWT_SECRET, ENCRYPTION_KEY, SESSION_SECRET

# 一键启动 (PostgreSQL + Redis + Server + Nginx)
sh start-docker.sh

# 查看日志
docker-compose logs -f
```

#### 方式 2：本地开发

```bash
cd packages/server

# 配置环境变量
cp .env.example .env
# 编辑 .env 文件，配置:
#   DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD
#   REDIS_PASSWORD, REDIS_PORT
#   JWT_SECRET, ENCRYPTION_KEY, SESSION_SECRET

# 运行数据库迁移
dart run bin/migrate.dart

# 启动服务 (默认 http://localhost:8080)
dart run bin/server.dart
```

### 启动前端应用

```bash
cd apps/ttpolyglot

# Web
flutter run -d chrome

# 桌面 (默认窗口 1680x800，最小 1280x640)
flutter run -d macos    # 或 windows / linux

# 移动端
flutter run -d ios      # 或 android
```

## 开发指南

### 常用命令

```bash
# 代码分析
melos exec -- dart analyze

# 运行测试
melos exec -- dart test

# 代码生成 (Freezed / json_serializable / Drift)
cd packages/model && dart run build_runner build --delete-conflicting-outputs
cd packages/server && dart run build_runner build --delete-conflicting-outputs
cd apps/ttpolyglot && dart run build_runner build --delete-conflicting-outputs

# 清理构建产物
melos clean
```

### 数据库管理

```bash
cd packages/server

# 运行迁移
dart run bin/migrate.dart

# 修改 Drift 模型后重新生成
dart run build_runner build --delete-conflicting-outputs

# 单独启动数据库
docker-compose up -d ttpolyglot-db ttpolyglot-redis
```

### 构建与部署

```bash
# 构建 Web 应用
cd apps/ttpolyglot && flutter build web

# 构建桌面应用
flutter build macos    # 或 windows / linux

# 构建移动应用
flutter build apk      # Android
flutter build ios      # iOS

# 构建后端 Docker 镜像 (多阶段 AOT 编译)
cd packages/server && docker build -t ttpolyglot-server .
```

### 代码规范

- 使用 `dart:developer` 的 `log` 替代 `print`
- catch 时捕获 `error` 和 `stackTrace`，格式: `log('[函数名]', error: error, stackTrace: stackTrace, name: '[类名]')`
- 使用 package 风格导入，不使用相对路径
- 每个 feature 文件夹提供桶文件导出
- Flutter 尺寸值始终使用 `double`（`10.0` 而非 `10`）
- Border radius 只使用 `2.0` / `4.0` / `8.0`
- 行宽 120 字符
- 始终使用 trailing commas
- 不手动编辑 `*.g.dart` 和 `*.freezed.dart`

### Commit 规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/)，支持 scope：

```
feat(translation-service): add batch import support
fix(auth): handle token refresh race condition
refactor(project-controller): simplify error handling
```

类型：`feat` | `fix` | `docs` | `style` | `refactor` | `test` | `chore`

## API 文档

### REST API

后端提供完整的 REST API，默认运行在 `http://localhost:8080`，所有业务接口挂载在 `/api/v1/` 下。

#### 认证

```bash
# 登录获取 Token
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password"}'

# 使用 Token 访问 API
curl -X GET http://localhost:8080/api/v1/projects \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### 端点概览

```
健康检查
GET    /health                                    # 健康状态
GET    /health/db                                 # 数据库状态
GET    /health/ready                              # 就绪检查
GET    /metrics                                   # Prometheus 指标

系统
GET    /api/v1/version                            # API 版本
GET    /api/v1/status                             # 系统状态

认证
POST   /api/v1/auth/register                      # 注册
POST   /api/v1/auth/login                         # 登录
POST   /api/v1/auth/logout                        # 登出
POST   /api/v1/auth/refresh                       # 刷新 Token
POST   /api/v1/auth/forgot-password               # 忘记密码
POST   /api/v1/auth/reset-password                # 重置密码
POST   /api/v1/auth/verify-email                  # 邮箱验证
POST   /api/v1/auth/resend-verification           # 重发验证邮件

用户
GET    /api/v1/users                              # 用户列表
GET    /api/v1/users/:id                          # 用户详情
PUT    /api/v1/users/:id                          # 更新用户
DELETE /api/v1/users/:id                          # 删除用户

项目
GET    /api/v1/projects                           # 项目列表
POST   /api/v1/projects                           # 创建项目
GET    /api/v1/projects/:id                       # 项目详情
PUT    /api/v1/projects/:id                       # 更新项目
DELETE /api/v1/projects/:id                       # 删除项目

项目成员
GET    /api/v1/projects/:id/members               # 成员列表
POST   /api/v1/projects/:id/members               # 添加成员
DELETE /api/v1/projects/:id/members/:memberId     # 移除成员

翻译
GET    /api/v1/projects/:id/translations          # 翻译列表
POST   /api/v1/projects/:id/translations          # 创建翻译
PUT    /api/v1/translations/:id                   # 更新翻译
DELETE /api/v1/translations/:id                   # 删除翻译

语言
GET    /api/v1/languages                          # 支持的语言列表

文件
POST   /api/v1/files/upload                       # 上传文件
POST   /api/v1/projects/:id/import                # 导入翻译文件
GET    /api/v1/projects/:id/export                # 导出翻译文件

角色与权限
GET    /api/v1/roles                              # 角色列表
GET    /api/v1/permissions                        # 权限列表
POST   /api/v1/roles/:id/permissions              # 分配权限

系统配置
GET    /api/v1/configs                            # 配置列表
PUT    /api/v1/configs/:key                       # 更新配置

通知
GET    /api/v1/notifications                      # 通知列表
PUT    /api/v1/notifications/:id/read             # 标记已读
```

## 开发路线图

### 第一阶段：基础架构 (已完成)

- [x] Melos Monorepo 工作区
- [x] Model 包：40+ 个共享数据模型 (Freezed)
- [x] Server 包：完整后端 REST API
  - [x] JWT 认证 + RBAC 权限系统
  - [x] Drift ORM + PostgreSQL
  - [x] Redis Session + 多级缓存
  - [x] 中间件链 (Auth / Permission / RateLimit / CORS / Logging / ErrorHandler)
  - [x] 22 个数据库迁移 + 6 个种子文件
  - [x] Docker 多阶段 AOT 编译 + Nginx 部署
- [x] Parsers 包：6 种格式解析器 (JSON / YAML / ARB / PO / CSV / Properties)
- [x] Translators 包：3 个翻译 API + 自定义 API
- [x] Utils 包：Logger / Dialog / Toast

### 第二阶段：核心功能 (已完成)

- [x] Flutter 跨平台应用 (12 个功能模块)
- [x] 用户认证流程 (登录 / 注册 / 忘记密码 / 重置密码 / 邮箱验证)
- [x] 项目管理 (创建 / 编辑 / 删除 / 统计)
- [x] 翻译键管理与编辑
- [x] 多语言文件导入
- [x] 文件导出 (JSON / CSV / ARB / Excel / PO，桌面端)
- [x] 项目成员管理与邀请链接
- [x] 离线同步队列 (桌面端)
- [x] 响应式布局 + 亮色/暗色主题
- [x] 用户设置与通知设置

### 第三阶段：增强功能 (进行中)

- [ ] YAML / Properties 格式导出
- [ ] Web / 移动端文件导出
- [ ] AI 自动翻译 (后端集成)
- [ ] 批量自动翻译
- [ ] 翻译质量校验
- [ ] 导入冲突解决机制
- [ ] 移动端持久化存储

### 第四阶段：高级功能 (规划中)

- [ ] 实时多人协作编辑 (WebSocket)
- [ ] 翻译记忆与术语库
- [ ] 审核工作流
- [ ] 评论与讨论系统
- [ ] CLI 工具
- [ ] DeepL 翻译集成
- [ ] 更多语言支持

## 与 i18n-ally 的对比

| 特性 | i18n-ally | TTPolyglot |
|------|-----------|------------|
| 运行环境 | VS Code 扩展 | 跨平台应用 + Web |
| 多人协作 | - | 已实现 (成员管理 + 邀请) |
| 自托管 | N/A | 已实现 (Docker 部署) |
| 权限管理 | - | 已实现 (RBAC) |
| AI 翻译 | - | 已实现 (3 个 API) |
| 文件格式 | 多格式 | 6 种格式 |
| 离线使用 | 完全离线 | 混合模式 (离线 + 同步) |
| 非技术用户 | 需要 VS Code | Web 即可使用 |
| 翻译状态管理 | - | 已实现 (5 阶段工作流) |
| 审核工作流 | - | 规划中 |
| 实时同步 | - | 规划中 |

## 贡献指南

欢迎所有形式的贡献！

### 如何贡献

1. Fork 项目
2. 创建功能分支
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. 提交更改
   ```bash
   git commit -m 'feat(scope): add amazing feature'
   ```
4. 推送并创建 Pull Request

### 开发规范

- 使用 `dart analyze` 检查代码质量
- 遵循 [Dart 官方代码规范](https://dart.dev/effective-dart)
- 为新功能添加单元测试
- 更新相关文档

## 常见问题

<details>
<summary><strong>Q: TTPolyglot 与其他翻译管理平台有什么区别？</strong></summary>

TTPolyglot 的核心理念是"本地文件优先"。开发者可以继续使用 Git 管理翻译文件，同时享受云端协作的便利。全栈 Dart 架构使得前后端代码共享成为可能，开源且支持自托管部署。
</details>

<details>
<summary><strong>Q: 支持哪些翻译文件格式？</strong></summary>

目前支持 6 种格式：JSON、YAML、CSV、ARB (Flutter)、PO (Gettext)、Properties (Java)。所有格式均支持读取、写入和校验。
</details>

<details>
<summary><strong>Q: 是否需要修改现有项目代码？</strong></summary>

不需要。TTPolyglot 可以直接导入现有的翻译文件。只要你的项目使用支持的文件格式，就可以无缝接入。
</details>

<details>
<summary><strong>Q: 数据安全如何保障？</strong></summary>

- 支持自托管部署，数据完全自控
- JWT + RBAC 权限系统，细粒度控制
- Nginx HTTPS 加密传输
- bcrypt 密码加密
- Redis Session 管理，支持登出失效
- 账户登录锁定保护
</details>

<details>
<summary><strong>Q: 可以离线使用吗？</strong></summary>

桌面端应用支持离线模式。离线时编辑的翻译会进入同步队列，网络恢复后自动同步到服务器。
</details>

<details>
<summary><strong>Q: 技术栈为什么选择全栈 Dart？</strong></summary>

- **Flutter** 提供真正的跨平台能力，一套代码支持 6 大平台
- **Shelf** 轻量级高性能，与 Flutter 共用同一语言
- **Drift** 提供编译时类型安全的数据库访问
- **Freezed** 保证数据模型的不可变性和类型安全
- 前后端共享 model 包，消除序列化不一致问题
</details>

## 相关资源

| 类别 | 链接 |
|------|------|
| Flutter 文档 | [docs.flutter.dev](https://docs.flutter.dev/) |
| Dart 指南 | [dart.dev/guides](https://dart.dev/guides) |
| Shelf 文档 | [pub.dev/packages/shelf](https://pub.dev/packages/shelf) |
| Drift ORM | [drift.simonbinder.eu](https://drift.simonbinder.eu/) |
| Melos | [melos.invertase.dev](https://melos.invertase.dev/) |
| GetX | [pub.dev/packages/get](https://pub.dev/packages/get) |
| Freezed | [pub.dev/packages/freezed](https://pub.dev/packages/freezed) |
| Material Design 3 | [m3.material.io](https://m3.material.io/) |

## 许可证

[Apache License 2.0](LICENSE)

---

**TTPolyglot** - 让复杂的事情变简单
