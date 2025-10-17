# TTPolyglot 服务端

TTPolyglot 多语言翻译管理系统的服务端实现，基于 Dart 和 Shelf 框架构建的高性能 RESTful API 服务。

## 📋 目录

- [特性](#特性)
- [技术栈](#技术栈)
- [系统架构](#系统架构)
- [快速开始](#快速开始)
- [环境配置](#环境配置)
- [部署方式](#部署方式)
- [API 文档](#api-文档)
- [开发指南](#开发指南)
- [性能优化](#性能优化)
- [安全特性](#安全特性)
- [监控与运维](#监控与运维)
- [故障排查](#故障排查)

## ✨ 特性

### 核心功能

- **多语言翻译管理** - 支持项目、语言、翻译条目的完整生命周期管理
- **用户认证与授权** - 基于 JWT 的无状态认证，支持 RBAC 权限控制
- **文件上传处理** - 支持翻译文件的导入导出，多种格式解析
- **审计日志** - 完整的操作记录和历史追溯
- **通知系统** - 实时通知推送，支持多种通知类型

### 技术特性

- **高性能** - 基于 Shelf 框架的异步 IO，支持高并发请求
- **多级缓存** - L1 内存缓存 + L2 Redis 缓存，显著提升响应速度
- **数据库连接池** - PostgreSQL 连接池管理，优化数据库访问
- **中间件架构** - 完整的中间件链路，支持请求追踪、限流、重试等
- **结构化日志** - 统一的日志格式，支持日志聚合和分析
- **健康检查** - 多维度的健康检查端点，便于监控和告警
- **Prometheus 指标** - 内置指标收集，支持性能监控
- **Docker 化** - 完整的容器化方案，支持一键部署

## 🛠 技术栈

### 核心框架

- **Dart** (3.6.1+) - 编程语言
- **Shelf** (1.4.1+) - HTTP 服务器框架
- **Shelf Router** (1.1.4+) - 路由管理

### 数据存储

- **PostgreSQL** (15+) - 主数据库
- **Redis** (7+) - 缓存和会话存储
- **Drift** (2.14.1+) - Dart ORM 框架

### 认证与安全

- **JWT** - 无状态身份认证
- **Bcrypt** - 密码加密
- **Crypto** - 加密工具库

### 开发工具

- **Docker** & **Docker Compose** - 容器化部署
- **Nginx** - 反向代理和负载均衡
- **Melos** - Monorepo 管理工具

## 🏗 系统架构

```
┌─────────────────────────────────────────────────────────┐
│                    Nginx (反向代理)                      │
│                   SSL/TLS 终端                          │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│              TTPolyglot Server                          │
│  ┌────────────────────────────────────────────────┐    │
│  │           中间件层 (Middleware)                 │    │
│  │  • 请求ID  • CORS  • 限流  • 认证  • 日志      │    │
│  └────────────────────┬───────────────────────────┘    │
│  ┌────────────────────▼───────────────────────────┐    │
│  │           路由层 (Routes)                       │    │
│  │  /api/v1/auth  /projects  /translations 等      │    │
│  └────────────────────┬───────────────────────────┘    │
│  ┌────────────────────▼───────────────────────────┐    │
│  │          控制器层 (Controllers)                 │    │
│  │  Auth  User  Project  Translation  File 等      │    │
│  └────────────────────┬───────────────────────────┘    │
│  ┌────────────────────▼───────────────────────────┐    │
│  │          服务层 (Services)                      │    │
│  │  业务逻辑处理、数据访问、缓存管理               │    │
│  └────────────────────┬───────────────────────────┘    │
└───────────────────────┼───────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
   ┌────▼────┐    ┌────▼────┐    ┌────▼────┐
   │PostgreSQL│    │  Redis  │    │  File   │
   │ 数据库   │    │  缓存   │    │ Storage │
   └─────────┘    └─────────┘    └─────────┘
```

### 分层说明

- **中间件层** - 处理横切关注点（认证、日志、限流等）
- **路由层** - URL 映射和请求分发
- **控制器层** - 处理 HTTP 请求和响应
- **服务层** - 业务逻辑实现和数据处理
- **数据层** - 数据持久化和缓存

## 🚀 快速开始

### 前置要求

- Dart SDK 3.6.1 或更高版本
- PostgreSQL 15 或更高版本
- Redis 7 或更高版本
- Docker & Docker Compose (可选，用于容器化部署)

### 本地开发

#### 1. 安装依赖

```bash
# 在项目根目录执行
dart pub get
```

#### 2. 配置环境变量

创建 `.env` 文件：

```bash
cp .env.example .env
```

编辑 `.env` 文件，配置必要的环境变量（详见[环境配置](#环境配置)）。

#### 3. 启动数据库服务

使用 Docker Compose 启动 PostgreSQL 和 Redis：

```bash
docker-compose up -d ttpolyglot-db ttpolyglot-redis
```

或手动启动本地数据库服务。

#### 4. 运行数据库迁移

```bash
# 生成数据库表结构
dart run build_runner build

# 执行数据库迁移（如有迁移脚本）
# dart run bin/migrate.dart
```

#### 5. 启动服务器

```bash
# 开发模式
dart run bin/server.dart

# 或使用可执行文件
dart pub global activate --source path .
server
```

服务器将在 `http://localhost:8080` 启动。

#### 6. 验证服务

访问健康检查端点：

```bash
curl http://localhost:8080/health
```

## ⚙️ 环境配置

### 必需的环境变量

在 `.env` 文件中配置以下变量：

```env
# 环境设置
ENVIRONMENT=dev                    # dev | production
LOG_LEVEL=info                     # debug | info | warning | error

# 服务器配置
HOST=0.0.0.0                      # 监听地址
PORT=8080                         # 监听端口

# 数据库配置
DATABASE_URL=postgresql://user:password@localhost:5432/ttpolyglot
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ttpolyglot
DB_USER=ttpolyglot
DB_PASSWORD=your_secure_password
DB_POOL_SIZE=20                   # 连接池大小
DB_CONNECTION_TIMEOUT=30          # 连接超时（秒）
DB_TABLE_PREFIX=                  # 表前缀（可选）

# Redis 配置
REDIS_URL=redis://localhost:6379
REDIS_PASSWORD=                   # Redis 密码（可选）
REDIS_MAX_CONNECTIONS=10          # 最大连接数
REDIS_CONNECTION_TIMEOUT=5        # 连接超时（秒）

# 安全配置（生产环境必须修改）
JWT_SECRET=your-super-secret-jwt-key-change-in-production
SESSION_SECRET=your-super-secret-session-key-change-in-production
ENCRYPTION_KEY=your-super-secret-encryption-key-32-chars-long

# JWT 配置
JWT_EXPIRES_IN=86400              # JWT 过期时间（秒），默认 24 小时
JWT_REFRESH_EXPIRES_IN=604800     # 刷新令牌过期时间（秒），默认 7 天

# CORS 配置
CORS_ORIGINS=http://localhost:3000,http://localhost:8081
CORS_ALLOW_CREDENTIALS=true

# 文件上传配置
MAX_UPLOAD_SIZE=10485760          # 最大上传大小（字节），默认 10MB
UPLOAD_DIR=./uploads              # 上传文件存储目录

# 限流配置
RATE_LIMIT_MAX_REQUESTS=100       # 时间窗口内最大请求数
RATE_LIMIT_WINDOW_SECONDS=60      # 限流时间窗口（秒）

# 缓存配置
CACHE_L1_MAX_SIZE=1000           # L1 缓存最大条目数
CACHE_L1_TTL_SECONDS=300         # L1 缓存默认 TTL（秒）
CACHE_L2_TTL_SECONDS=3600        # L2 缓存默认 TTL（秒）

# 邮件配置（可选）
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_FROM=noreply@ttpolyglot.com
```

### 生产环境配置建议

1. **安全密钥** - 使用强随机字符串替换所有默认密钥
2. **数据库密码** - 使用强密码并定期轮换
3. **日志级别** - 设置为 `warning` 或 `error`
4. **CORS 来源** - 限制为实际的前端域名
5. **连接池** - 根据服务器资源调整数据库连接池大小

## 🐳 部署方式

### Docker Compose 部署（推荐）

这是最简单快捷的部署方式，包含所有依赖服务。

#### 1. 准备配置文件

```bash
# 复制环境变量模板
cp .env.example .env

# 编辑配置
nano .env
```

#### 2. 启动所有服务

```bash
# 构建并启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f ttpolyglot-server

# 检查服务状态
docker-compose ps
```

#### 3. 访问服务

- API 服务: `http://localhost` (通过 Nginx 代理)
- 直接访问: `http://localhost:8080`
- 健康检查: `http://localhost/health`

#### 4. 停止服务

```bash
# 停止所有服务
docker-compose down

# 停止并删除数据卷
docker-compose down -v
```

### 独立 Docker 部署

如果已有外部数据库和 Redis 服务：

```bash
# 构建镜像
docker build -t ttpolyglot-server .

# 运行容器
docker run -d \
  --name ttpolyglot-server \
  -p 8080:8080 \
  -e DATABASE_URL=your_database_url \
  -e REDIS_URL=your_redis_url \
  -e JWT_SECRET=your_jwt_secret \
  -e SESSION_SECRET=your_session_secret \
  -e ENCRYPTION_KEY=your_encryption_key \
  ttpolyglot-server
```

### 生产环境部署

生产环境建议配置：

1. **使用 Nginx 反向代理** - 提供 SSL/TLS 支持和负载均衡
2. **配置健康检查** - 设置自动重启和故障转移
3. **数据备份** - 定期备份 PostgreSQL 数据
4. **日志收集** - 集成日志聚合系统（如 ELK Stack）
5. **监控告警** - 集成 Prometheus + Grafana
6. **容器编排** - 考虑使用 Kubernetes 进行大规模部署

详细的生产部署指南请参考 `PRODUCTION_DEPLOYMENT.md`。

## 📚 API 文档

### 认证 API

#### 注册用户

```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "username": "user@example.com",
  "password": "SecurePassword123",
  "email": "user@example.com",
  "displayName": "User Name"
}
```

#### 用户登录

```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "username": "user@example.com",
  "password": "SecurePassword123"
}
```

响应：

```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "refresh_token_here",
    "expiresIn": 86400,
    "user": {
      "id": "user_id",
      "username": "user@example.com",
      "email": "user@example.com"
    }
  }
}
```

#### 刷新令牌

```http
POST /api/v1/auth/refresh
Content-Type: application/json

{
  "refreshToken": "refresh_token_here"
}
```

### 项目管理 API

#### 创建项目

```http
POST /api/v1/projects
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "My Project",
  "description": "Project description",
  "defaultLanguage": "en",
  "supportedLanguages": ["en", "zh", "ja"]
}
```

#### 获取项目列表

```http
GET /api/v1/projects
Authorization: Bearer {token}
```

#### 获取项目详情

```http
GET /api/v1/projects/{projectId}
Authorization: Bearer {token}
```

### 翻译管理 API

#### 获取翻译条目

```http
GET /api/v1/projects/{projectId}/translations
Authorization: Bearer {token}
```

#### 创建翻译条目

```http
POST /api/v1/projects/{projectId}/translations
Authorization: Bearer {token}
Content-Type: application/json

{
  "key": "welcome.message",
  "translations": {
    "en": "Welcome!",
    "zh": "欢迎！",
    "ja": "ようこそ！"
  }
}
```

#### 更新翻译

```http
PUT /api/v1/translations/{translationId}
Authorization: Bearer {token}
Content-Type: application/json

{
  "language": "zh",
  "value": "欢迎使用！"
}
```

### 文件管理 API

#### 上传翻译文件

```http
POST /api/v1/projects/{projectId}/import
Authorization: Bearer {token}
Content-Type: multipart/form-data

{
  "file": <binary>,
  "language": "en",
  "format": "json"
}
```

#### 导出翻译文件

```http
GET /api/v1/projects/{projectId}/export
Authorization: Bearer {token}
Query: language=en&format=json
```

### 通用响应格式

#### 成功响应

```json
{
  "success": true,
  "data": { /* 响应数据 */ },
  "message": "操作成功"
}
```

#### 错误响应

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "错误描述",
    "details": { /* 详细错误信息 */ }
  }
}
```

### 错误码说明

- `UNAUTHORIZED` - 未授权，需要登录
- `FORBIDDEN` - 禁止访问，权限不足
- `NOT_FOUND` - 资源不存在
- `VALIDATION_ERROR` - 请求参数验证失败
- `CONFLICT` - 资源冲突
- `INTERNAL_ERROR` - 服务器内部错误
- `RATE_LIMIT_EXCEEDED` - 请求频率超限

完整的 API 文档请访问: `/api/v1/docs` (开发中)

## 💻 开发指南

### 项目结构

```
packages/server/
├── bin/
│   └── server.dart              # 服务器入口文件
├── lib/
│   ├── server.dart              # 库导出文件
│   └── src/
│       ├── config/              # 配置管理
│       │   └── server_config.dart
│       ├── controllers/         # 控制器层
│       │   ├── auth_controller.dart
│       │   ├── user_controller.dart
│       │   ├── project_controller.dart
│       │   └── ...
│       ├── di/                  # 依赖注入
│       │   ├── dependency_injection.dart
│       │   └── service_registry.dart
│       ├── middleware/          # 中间件
│       │   ├── auth_middleware.dart
│       │   ├── cors_middleware.dart
│       │   ├── rate_limit_middleware.dart
│       │   └── ...
│       ├── models/              # 数据模型
│       │   ├── user.dart
│       │   ├── project.dart
│       │   └── ...
│       ├── routes/              # 路由配置
│       │   └── api_routes.dart
│       ├── services/            # 服务层
│       │   ├── auth_service.dart
│       │   ├── database_service.dart
│       │   ├── redis_service.dart
│       │   └── ...
│       └── utils/               # 工具类
│           ├── jwt_utils.dart
│           ├── crypto_utils.dart
│           └── ...
├── test/                        # 测试文件
├── docker-compose.yml           # Docker Compose 配置
├── Dockerfile                   # Docker 镜像配置
└── pubspec.yaml                # 依赖配置
```

### 添加新的 API 端点

1. **创建控制器** (`lib/src/controllers/`)

```dart
import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_server/src/services/services.dart';
import 'package:ttpolyglot_server/src/utils/response_builder.dart';

class MyController {
  final MyService _myService;

  MyController(this._myService);

  Future<Response> handleRequest(Request request) async {
    try {
      final data = await _myService.getData();
      return ResponseUtils.success(data: data);
    } catch (error, stackTrace) {
      return ResponseUtils.error(
        message: '获取数据失败',
        error: error,
      );
    }
  }
}
```

2. **创建服务** (`lib/src/services/`)

```dart
import 'dart:developer' as developer;

class MyService {
  Future<Map<String, dynamic>> getData() async {
    try {
      // 业务逻辑
      return {'key': 'value'};
    } catch (error, stackTrace) {
      developer.log(
        'getData',
        error: error,
        stackTrace: stackTrace,
        name: 'MyService',
      );
      rethrow;
    }
  }
}
```

3. **注册路由** (`lib/src/routes/api_routes.dart`)

```dart
router.get('/my-endpoint', myController.handleRequest);
```

4. **注册服务到 DI 容器** (`lib/src/di/service_registry.dart`)

```dart
serviceRegistry.register<MyService>(() => MyService());
```

### 运行测试

```bash
# 运行所有测试
dart test

# 运行特定测试文件
dart test test/services/auth_service_test.dart

# 生成测试覆盖率报告
dart run coverage:test_with_coverage
```

### 代码格式化

```bash
# 格式化代码
dart format .

# 检查代码规范
dart analyze
```

### 代码生成

项目使用 `build_runner` 进行代码生成（JSON 序列化、数据库模型等）：

```bash
# 一次性生成
dart run build_runner build

# 监听模式
dart run build_runner watch

# 删除冲突文件并重新生成
dart run build_runner build --delete-conflicting-outputs
```

## ⚡ 性能优化

### 多级缓存架构

服务器实现了两级缓存系统：

- **L1 缓存（内存）** - 进程内缓存，响应速度极快
- **L2 缓存（Redis）** - 分布式缓存，支持多实例共享

缓存命中率可通过 `/health` 端点查看。

### 数据库优化

- **连接池** - 复用数据库连接，减少连接开销
- **批量操作** - 使用批量插入和更新减少数据库交互
- **索引优化** - 在常用查询字段上建立索引
- **查询优化** - 使用 EXPLAIN 分析和优化慢查询

### 响应时间优化

- **异步处理** - 所有 IO 操作使用异步模式
- **并发请求** - 利用 Dart 的并发特性处理多个请求
- **压缩响应** - 对大响应体使用 Gzip 压缩
- **分页查询** - 限制单次查询的数据量

## 🔒 安全特性

### 认证与授权

- **JWT 认证** - 无状态的令牌认证机制
- **密码加密** - 使用 Bcrypt 进行密码哈希
- **RBAC 权限控制** - 基于角色的访问控制
- **会话管理** - 支持令牌刷新和撤销

### 安全中间件

- **CORS 限制** - 配置允许的跨域来源
- **速率限制** - 防止 API 滥用和 DDoS 攻击
- **请求大小限制** - 防止大请求消耗服务器资源
- **安全头设置** - X-Frame-Options, CSP, HSTS 等

### 数据安全

- **SQL 注入防护** - 使用参数化查询
- **XSS 防护** - 对用户输入进行验证和转义
- **敏感数据加密** - 使用 AES 加密存储敏感信息
- **审计日志** - 记录所有关键操作

### 安全最佳实践

1. **定期更新密钥** - 定期轮换 JWT 密钥和加密密钥
2. **HTTPS 强制** - 生产环境强制使用 HTTPS
3. **最小权限原则** - 为每个服务账户分配最小必要权限
4. **安全扫描** - 定期进行安全审计和漏洞扫描

## 📊 监控与运维

### 健康检查端点

#### 基础健康检查

```bash
curl http://localhost:8080/health
```

响应示例：

```json
{
  "status": "healthy",
  "timestamp": "2025-10-15T10:30:00.000Z",
  "uptime_seconds": 3600,
  "version": "1.0.0",
  "services": {
    "database": {
      "status": "healthy",
      "response_time_ms": 5
    },
    "redis": {
      "status": "healthy",
      "response_time_ms": 2
    },
    "cache": {
      "status": "healthy",
      "l1_hit_rate": 0.85,
      "l2_hit_rate": 0.95
    }
  }
}
```

#### 数据库健康检查

```bash
curl http://localhost:8080/health/db
```

#### 服务就绪检查

```bash
curl http://localhost:8080/health/ready
```

### Prometheus 指标

访问 `/metrics` 端点获取 Prometheus 格式的指标：

```bash
curl http://localhost:8080/metrics
```

主要指标包括：

- `http_requests_total` - HTTP 请求总数
- `http_request_duration_seconds` - 请求处理时间
- `http_requests_in_progress` - 正在处理的请求数
- `database_connections_active` - 活跃数据库连接数
- `cache_hits_total` - 缓存命中次数
- `cache_misses_total` - 缓存未命中次数

### 日志管理

服务器使用结构化日志，支持以下日志级别：

- `debug` - 调试信息
- `info` - 一般信息
- `warning` - 警告信息
- `error` - 错误信息

日志输出到：

- **控制台** - 开发环境
- **文件** - `./logs/server.log`
- **日志聚合系统** - 生产环境（可选）

### 监控集成

推荐的监控方案：

1. **Prometheus** - 指标收集
2. **Grafana** - 可视化仪表盘
3. **ELK Stack** - 日志聚合和分析
4. **Sentry** - 错误追踪（可选）

## 🔧 故障排查

### 常见问题

#### 1. 服务器启动失败

**问题**: 服务器无法启动

**排查步骤**:
```bash
# 检查环境变量
printenv | grep -E 'DB_|REDIS_|JWT_'

# 检查数据库连接
psql -h $DB_HOST -U $DB_USER -d $DB_NAME

# 检查 Redis 连接
redis-cli -h $REDIS_HOST ping

# 查看详细日志
dart run bin/server.dart 2>&1 | tee server.log
```

#### 2. 数据库连接失败

**问题**: `DatabaseService` 连接失败

**解决方案**:
- 检查数据库服务是否运行
- 验证 `DATABASE_URL` 配置是否正确
- 确认数据库用户权限
- 检查防火墙和网络设置

#### 3. Redis 连接失败

**问题**: `RedisService` 连接失败

**解决方案**:
- 检查 Redis 服务是否运行
- 验证 `REDIS_URL` 配置
- 确认 Redis 密码设置
- 检查 Redis 最大连接数限制

#### 4. 内存占用过高

**问题**: 服务器内存使用率持续上升

**排查步骤**:
```bash
# 查看缓存统计
curl http://localhost:8080/health

# 调整 L1 缓存大小
# 在 .env 中设置: CACHE_L1_MAX_SIZE=500

# 清理缓存
# 重启服务或实现缓存清理 API
```

#### 5. 请求响应慢

**问题**: API 响应时间过长

**排查步骤**:
- 检查 `/metrics` 端点的响应时间指标
- 查看数据库慢查询日志
- 检查缓存命中率
- 分析中间件处理时间

### 调试模式

启用详细日志：

```bash
# 设置日志级别为 debug
export LOG_LEVEL=debug
dart run bin/server.dart
```

### 获取帮助

如遇到问题，请：

1. 查看 [GitHub Issues](https://github.com/your-repo/ttpolyglot/issues)
2. 提交详细的错误报告，包括：
   - 错误信息和堆栈跟踪
   - 环境配置
   - 复现步骤
   - 相关日志

## 📄 相关文档

- [开发设置指南](DEVELOPMENT_SETUP.md) - 开发环境配置
- [生产部署指南](PRODUCTION_DEPLOYMENT.md) - 生产环境部署
- [开发脚本指南](DEVELOPMENT_SCRIPTS_GUIDE.md) - 开发脚本使用
- [API 文档](docs/API.md) - 详细的 API 文档

## 📝 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

## 🤝 贡献

欢迎贡献！请查看 [CONTRIBUTING.md](../../CONTRIBUTING.md) 了解如何参与项目开发。

---

**TTPolyglot** - 让多语言翻译管理更简单 🌍
