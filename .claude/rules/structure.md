---
paths: "{apps,packages}/**/*.dart"
---

# 项目结构与架构约束

> 本文档提供 TTPolyglot 项目结构、架构约束和依赖规则。编写代码时必须遵守。

---

## 快速定位

| 我要找... | 路径 |
|-----------|------|
| **Flutter 应用** | `apps/ttpolyglot/` |
| **后端 API** | `packages/server/` |
| **共享数据模型** | `packages/model/` |
| **文件解析器** | `packages/parsers/` |
| **翻译 API 集成** | `packages/translators/` |
| **共享工具类** | `packages/utils/` |

---

## 架构依赖规则

### 层级关系

```
apps/ttpolyglot
    ↓ 依赖
packages/{model, parsers, translators, utils}
    ↓ 被依赖
packages/server（独立后端，仅依赖 model）
```

### 禁止的依赖

- `packages/model` 不可依赖任何其他 packages
- `packages/parsers` 不可依赖 `packages/server`
- `packages/translators` 不可依赖 `packages/server`
- `packages/server` 不可依赖 `apps/`
- `apps/` 不可依赖 `packages/server`（通过 HTTP API 通信）

---

## apps/ttpolyglot - Flutter 跨平台应用

### 目录结构

```
apps/ttpolyglot/lib/
├── main.dart                    # 入口（平台初始化 + GetX 注入）
└── src/
    ├── app.dart                 # GetMaterialApp 配置
    ├── core/                    # 核心层
    │   ├── layout/              #   响应式布局（MainShell、ResponsiveSidebar）
    │   ├── routing/             #   路由定义（AppPages、AppRoutes）
    │   ├── theme/               #   主题控制（亮色/暗色）
    │   ├── services/            #   核心服务（Project、Translation、Export、Sync）
    │   ├── storage/             #   平台存储（FileSystem/Web/Memory）
    │   ├── platform/            #   平台适配（Desktop/Web/Mobile）
    │   ├── widgets/             #   通用组件（StatCard、FormatCard）
    │   └── utils/               #   工具类（FileSaveUtil）
    ├── common/                  # 公共层
    │   ├── api/                 #   API 调用类（8 个）
    │   ├── network/             #   Dio 封装 + 4 个拦截器
    │   ├── config/              #   AppConfig（环境变量）
    │   └── services/            #   认证/Token 存储
    └── features/                # 功能模块
        ├── root/                #   应用入口（认证检查）
        ├── sign_in/             #   登录
        ├── sign_up/             #   注册
        ├── forgot_password/     #   忘记密码
        ├── reset_password/      #   重置密码
        ├── join/                #   接受邀请
        ├── dashboard/           #   仪表板
        ├── projects/            #   项目列表
        ├── project/             #   项目详情（7 个子页面）
        ├── translation/         #   翻译管理
        ├── settings/            #   用户设置
        └── profile/             #   个人资料
```

### Feature 模块规范

每个 feature 遵循统一结构：

```
features/{name}/
├── controllers/         # GetX Controller
├── views/               # 页面视图
├── widgets/             # 功能专属组件
└── {name}.dart          # 桶文件导出
```

**规则**：
- 每个 feature 必须有桶文件导出
- Controller 通过 GetX Bindings 注册
- 视图通过 `GetBuilder<Controller>` 绑定状态
- feature 之间不直接依赖，通过路由导航

### 路由结构

```dart
// 命名路由
/signIn                                    # 登录
/signUp                                    # 注册
/forgotPassword                            # 忘记密码
/resetPassword/:token                      # 重置密码
/join/:inviteCode                          # 接受邀请
/home/dashboard                            # 仪表板
/home/settings                             # 设置
/home/profile                              # 个人资料
/home/projects/:projectId/dashboard        # 项目仪表板
/home/projects/:projectId/translations     # 翻译管理
/home/projects/:projectId/languages        # 语言管理
/home/projects/:projectId/members          # 成员管理
/home/projects/:projectId/settings         # 项目设置
/home/projects/:projectId/import           # 导入
/home/projects/:projectId/export           # 导出
```

---

## packages/server - 后端 REST API

### 目录结构

```
packages/server/lib/src/
├── server.dart                  # TTPolyglotServer 主类
├── config/                      # ServerConfig（dotenv）
├── di/                          # DependencyInjection + ServiceRegistry
├── routes/
│   ├── api_routes.dart          # 主路由（/api/v1/）
│   └── modules/                 # 9 个路由模块
│       ├── auth_routes.dart
│       ├── user_routes.dart
│       ├── project_routes.dart
│       ├── translation_routes.dart
│       ├── language_routes.dart
│       ├── role_permission_routes.dart
│       ├── config_routes.dart
│       ├── file_routes.dart
│       └── notification_routes.dart
├── controllers/                 # HTTP 控制器
│   ├── base_controller.dart     #   基类（execute、getCurrentUserId、logInfo/Error）
│   ├── auth/                    #   AuthController、UserController、RoleController、PermissionController
│   ├── project/                 #   ProjectController、ProjectMemberController、TranslationController、FileController、LanguageController
│   ├── language/                #   LanguageController
│   ├── system/                  #   ConfigController、NotificationController
│   └── user/                    #   UserSettingsController
├── services/
│   ├── base_service.dart        #   基类（logInfo/Error、throwNotFound/Business/Validation）
│   ├── infrastructure/          #   DatabaseService、RedisService、MultiLevelCacheService、DatabaseConnectionPool
│   ├── business/                #   AuthService、UserService、ProjectService、TranslationService、PermissionService、BatchImportService、BatchJobService、ConfigService、LanguageService、NotificationSettingsService、ProjectStatsService、StreamExportService、UserSettingsService、ProjectMemberService
│   └── feature/                 #   EmailService、FileUploadService、IpLocationService、MetricsService
├── middleware/
│   ├── auth/                    #   AuthMiddleware（JWT+Redis）、PermissionMiddleware
│   ├── security/                #   CorsMiddleware、RateLimitMiddleware
│   ├── observability/           #   LoggingMiddleware、RequestIdMiddleware
│   └── error_handling/          #   ErrorHandlerMiddleware、RetryMiddleware
├── exceptions/                  # ValidationException、NotFoundException、BusinessException、UnauthorizedException、ForbiddenException
└── utils/                       # CryptoUtils、JwtUtils、ValidatorUtils、ResponseUtils、CacheUtils、DatabaseUtils、RetryUtils、DataUtils、DateUtils、StringUtils
```

### 中间件管道顺序

```
RequestId → StructuredLogging → CORS → RateLimit → RequestSizeLimit(10MB) → SecurityHeaders → Retry → ErrorHandler → [Auth → Permission] → Controller
```

### Controller 架构

```
请求 → Controller.execute() → Service → Infrastructure(DB/Redis) → 响应
```

**规则**：
- Controller 只负责请求解析和响应构建
- 业务逻辑放在 Service 层
- Controller 使用 `execute` 方法自动处理异常
- 响应使用 `ResponseUtils` 标准化

---

## packages/model - 共享数据模型

### 模型分类

| 分类 | 模型数量 | 用途 |
|------|----------|------|
| auth/ | 12 | 登录/注册/Token/Session/角色 |
| project/ | 7 | 项目/成员/权限/统计/邀请 |
| translation/ | 6 | 翻译条目/历史/目标语言/批量任务 |
| language/ | 1 | 语言模型 |
| system/ | 4 | 通知/配置/审计日志 |
| user/ | 1 | 用户设置 |
| file/ | 3 | 文件/上传 |
| network/ | 3 | 基础响应/分页/额外数据 |
| enums/ | 8 | 语言/状态/角色/提供商 等 |
| converter/ | 3 | JSON 类型转换器 |

### 枚举定义

- `LanguageEnum` - 10 种语言（en-US、zh-CN、zh-TW、th-TH、ja-JP、ko-KR、my-MM、tr-TR、de-DE、sv-SE）
- `TranslationStatusEnum` - 翻译状态（pending、translating、completed、reviewing、approved）
- `TranslationProviderEnum` - 翻译提供商（google、baidu、youdao、custom）
- `ProjectRoleEnum` - 项目角色
- `MemberStatusEnum` - 成员状态
- `NotificationTypeEnum` / `NotificationChannelEnum` - 通知类型/渠道
- `DataCodeEnum` / `DataMessageTipsEnum` - 响应代码/提示

---

## packages/parsers - 翻译文件解析器

6 个解析器，统一实现 `TranslationParser` 接口：

| 解析器 | 文件 | 支持操作 |
|--------|------|----------|
| JSON | `json_parser.dart` | 解析/写入/校验（支持嵌套键） |
| YAML | `yaml_parser.dart` | 解析/写入/校验 |
| CSV | `csv_parser.dart` | 解析/写入/校验 |
| ARB | `arb_parser.dart` | 解析/写入/校验 |
| PO | `po_parser.dart` | 解析/写入/校验 |
| Properties | `properties_parser.dart` | 解析/写入/校验 |

通过 `ParserFactory` 注册和获取解析器。

---

## packages/translators - 翻译 API 集成

`TranslationApiService` 静态类：

| 提供商 | API | 签名方式 |
|--------|-----|----------|
| Google | translate.googleapis.com | 无需签名 |
| 百度 | fanyi-api.baidu.com | HMAC-MD5 |
| 有道 | openapi.youdao.com | SHA256 |
| 自定义 | 可配置 | 可配置 |

---

## packages/utils - 共享工具类

- `DialogUtils` - 对话框工具
- `LoggerUtils` - Talker 日志
- `ToastUtils` - BotToast 通知

---

## 数据库结构（22 个迁移）

```
01 users          02 roles           03 permissions      04 role_permissions
05 languages      06 projects        07 user_roles       08 project_languages
09 translation_entries  10 translation_history  11 system_configs  12 user_sessions
13 file_uploads   14 notifications   15 audit_logs       16 user_settings
17 user_translation_configs  18 project_members  19 notification_settings
20 project_member_invite_logs  21 project_translation_stats  22 translation_batch_jobs
```

6 个种子文件：默认角色、权限、角色权限分配、语言、系统配置、管理员账户
