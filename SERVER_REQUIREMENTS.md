# TTPolyglot 服务端需求文档

## 项目概述

### 背景
TTPolyglot 是一个多语言翻译管理系统，目前为本地应用。为了支持团队协作、数据同步、用户管理等功能，需要开发对应的服务端系统。

### 目标
构建一个基于 Dart 的 RESTful API 服务端，支持：
- 多用户协作的翻译项目管理
- 细粒度的权限控制
- 数据持久化和同步
- 可扩展的架构设计

## 技术架构

### 后端技术栈
- **语言**: Dart
- **框架**: Shelf + Shelf Router (轻量级 HTTP 服务器)
- **反向代理**: Nginx (HTTP/HTTPS处理，负载均衡，静态文件服务)
- **数据库**: PostgreSQL (容器化部署)
- **ORM**: Drift (原 Moor) - Dart 的类型安全数据库层
- **身份验证**: JWT (JSON Web Tokens)
- **缓存**: Redis (用于会话、API响应和热点数据缓存)
- **容器化**: Docker + Docker Compose
- **监控**: 健康检查端点，系统指标收集
- **日志**: 结构化日志记录和分析
- **API 文档**: OpenAPI 3.0 (Swagger)

### 系统架构
```
                                           数据流和缓存策略
                    ┌────────────────────────────────────────────────────────────────┐
                    │                                                                │
┌─────────────────┐ │ ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐ │ ┌─────────────────┐
│  Flutter Client │─┼─│  Nginx Proxy    │───▶│  Dart Server    │───▶│ PostgreSQL DB   │ │ │  Redis Cache    │
│                 │ │ │  (Reverse Proxy)│    │  (Shelf)        │    │   Container     │ │ │   Container     │
│  • 用户会话     │ │ │  • 静态文件缓存  │    │  • 业务逻辑     │    │  • 持久化数据   │ │ │  • 会话存储     │
│  • API 请求     │ │ │  • 请求分发     │    │  • 权限验证     │    │  • 用户数据     │ │ │  • API 响应缓存 │
│  • 界面展示     │ │ │  • 负载均衡     │    │  • 缓存管理     │    │  • 项目数据     │ │ │  • 热点数据     │
└─────────────────┘ │ └─────────────────┘    └─────────────────┘    └─────────────────┘ │ │  • JWT Token    │
         │          │          │                         │                         │    │ │  • 翻译接口配置 │
         │          │          │                         │                         │    │ └─────────────────┘
         │          │          │          ┌──────────────┼─────────────────────────┼────┘          ▲
         │          │          │          │              ▼                         │               │
         │          │          │          │    ┌─────────────────┐                │               │
         │          │          │          │    │   缓存策略：    │                │               │
         │          │          │          │    │                 │                │               │
         │          │          │          │    │ 1.读取时机：    │                │               │
         │          │          │          │    │  • 频繁查询API  │                │               │
         │          │          │          │    │  • 用户会话验证  │               │               │
         │          │          │          │    │  • 翻译接口配置  │               │               │
         │          │          │          │    │  • 项目权限检查  │               │               │
         │          │          │          │    │                 │                │               │
         │          │          │          │    │ 2.写入时机：    │                │               │
         │          │          │          │    │  • 用户登录后   │                │               │
         │          │          │          │    │  • API响应缓存  │                │               │
         │          │          │          │    │  • 配置更新后   │                │               │
         │          │          │          │    │  • 热点数据计算  │               │               │
         │          │          │          │    └─────────────────┘                │               │
         │          │          │          └──────────────────────────────────────┘               │
         │          │          │                                                                   │
         ▼          │          ▼                         ▼                                        │
┌─────────────────┐ │ ┌─────────────────┐    ┌─────────────────┐                                 │
│  Nginx Docker   │ │ │   App Docker    │    │   DB Docker     │ ◄──────────────────────────────┘
│   Container     │ │ │   Container     │    │   Container     │    Redis Docker Container
└─────────────────┘ │ └─────────────────┘    └─────────────────┘    ┌─────────────────┐
         │          │          │                         │           │ Redis Docker    │
         │          │          │                         │           │   Container     │
         │          │          │                         │           │                 │
         │          │          │                         │           │ 缓存场景：      │
         │          │          │                         │           │ • TTL: 1-24小时 │
         │          │          │                         │           │ • 自动过期清理   │
         │          │          │                         │           │ • 集群同步支持   │
         │          │          │                         │           └─────────────────┘
         │          │          │                         │                    │
         │          └──────────┼─────────────────────────┼────────────────────┘
         │                     │                         │
         └─────────────────────┼─────────────────────────┼──────────────────────────────────┐
                               ▼                         ▼                                   │
                    ┌─────────────────────────────────────────────────────────────────────┐ │
                    │                    Docker Network                                    │ │
                    │                    ttpolyglot-net                                    │ │
                    │                                                                     │ │
                    │ 容器间通信：                                                        │ │
                    │ • App ↔ DB: 数据持久化操作                                          │ │
                    │ • App ↔ Redis: 缓存读写操作                                        │ │
                    │ • Nginx ↔ App: HTTP 请求代理                                       │ │
                    └─────────────────────────────────────────────────────────────────────┘ │
                                                     │                                       │
                                                     └───────────────────────────────────────┘
```

**架构说明：**
- **Nginx 反向代理**: 处理HTTP/HTTPS请求，SSL终止，负载均衡，静态文件服务
- **Dart 服务器**: 处理API业务逻辑，身份验证，数据处理，缓存策略管理
- **PostgreSQL**: 持久化数据存储，主数据源
- **Redis 缓存**: 
  - **会话存储**: JWT Token，用户登录状态缓存
  - **API响应缓存**: 频繁查询的数据（如项目列表、用户权限）
  - **热点数据缓存**: 翻译接口配置、系统配置、语言列表
  - **临时数据**: 密码重置token、邮件验证码
  - **使用时机**: 
    * 读取：每次API权限验证、用户会话检查、频繁查询数据时优先从缓存读取
    * 写入：用户登录成功、数据更新后、定时任务计算的统计数据
    * 过期：根据数据性质设置1小时-24小时TTL，自动过期清理
- **Docker 网络**: 容器间安全通信，支持服务发现和负载均衡

**数据流说明：**
1. **客户端请求** → Nginx → Dart Server
2. **权限验证** → Dart Server 首先检查 Redis 中的用户会话
3. **数据查询** → Dart Server 优先从 Redis 读取缓存，缓存miss时查询 PostgreSQL
4. **数据更新** → Dart Server 更新 PostgreSQL 后，同步更新或删除 Redis 相关缓存
5. **响应返回** → 新数据缓存到 Redis（如有必要）→ 返回客户端

## 数据库设计

### 核心表结构

#### 1. 用户表 (users)
```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  is_email_verified BOOLEAN DEFAULT FALSE,
  last_login_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### 2. 角色表 (roles)
```sql
CREATE TABLE roles (
  id TEXT PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  description TEXT,
  is_system BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### 3. 权限表 (permissions)
```sql
CREATE TABLE permissions (
  id TEXT PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL,
  description TEXT,
  resource TEXT NOT NULL,  -- 资源类型: project, translation, user, system
  action TEXT NOT NULL,    -- 操作: create, read, update, delete, manage
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### 4. 角色权限关联表 (role_permissions)
```sql
CREATE TABLE role_permissions (
  role_id TEXT NOT NULL,
  permission_id TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (role_id, permission_id),
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);
```

#### 5. 用户角色关联表 (user_roles)
```sql
CREATE TABLE user_roles (
  user_id TEXT NOT NULL,
  role_id TEXT NOT NULL,
  project_id TEXT NULL,  -- NULL表示全局角色，否则表示项目级角色
  granted_by TEXT NOT NULL,
  granted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NULL,
  PRIMARY KEY (user_id, role_id, COALESCE(project_id, '')),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (granted_by) REFERENCES users(id)
);
```

#### 6. 项目表 (projects)
```sql
CREATE TABLE projects (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  owner_id TEXT NOT NULL,
  primary_language_code TEXT NOT NULL,
  settings JSON,  -- 项目配置信息
  is_active BOOLEAN DEFAULT TRUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id),
  FOREIGN KEY (primary_language_code) REFERENCES languages(code)
);
```

#### 7. 语言表 (languages)
```sql
CREATE TABLE languages (
  code TEXT PRIMARY KEY,  -- ISO 639-1 代码，如 'en', 'zh-CN'
  name TEXT NOT NULL,     -- 英文名称
  native_name TEXT NOT NULL,  -- 本地名称
  direction TEXT DEFAULT 'ltr',  -- 文字方向: ltr, rtl
  is_active BOOLEAN DEFAULT TRUE,
  sort_index INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### 8. 项目语言关联表 (project_languages)
```sql
CREATE TABLE project_languages (
  project_id TEXT NOT NULL,
  language_code TEXT NOT NULL,
  is_enabled BOOLEAN DEFAULT TRUE,
  sort_index INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (project_id, language_code),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (language_code) REFERENCES languages(code)
);
```

#### 9. 翻译条目表 (translation_entries)
```sql
CREATE TABLE translation_entries (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  key TEXT NOT NULL,
  language_code TEXT NOT NULL,
  source_text TEXT,
  target_text TEXT,
  status TEXT DEFAULT 'pending',  -- pending, translating, completed, reviewing, approved
  translation_provider TEXT,     -- 翻译服务提供商
  provider_config_id TEXT,       -- 使用的翻译接口配置ID (关联到user_translation_providers)
  is_ai_translated BOOLEAN DEFAULT FALSE,
  translator_id TEXT,
  reviewer_id TEXT,
  version INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(project_id, key, language_code),
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY (language_code) REFERENCES languages(code),
  FOREIGN KEY (provider_config_id) REFERENCES user_translation_providers(id) ON DELETE SET NULL,
  FOREIGN KEY (translator_id) REFERENCES users(id),
  FOREIGN KEY (reviewer_id) REFERENCES users(id)
);
```

#### 10. 翻译历史表 (translation_history)
```sql
CREATE TABLE translation_history (
  id TEXT PRIMARY KEY,
  translation_entry_id TEXT NOT NULL,
  old_target_text TEXT,
  new_target_text TEXT,
  old_status TEXT,
  new_status TEXT,
  change_type TEXT NOT NULL,  -- create, update, delete, status_change
  changed_by TEXT NOT NULL,
  change_reason TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (translation_entry_id) REFERENCES translation_entries(id) ON DELETE CASCADE,
  FOREIGN KEY (changed_by) REFERENCES users(id)
);
```

#### 11. 用户翻译接口配置表 (user_translation_providers)
```sql
CREATE TABLE user_translation_providers (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  provider_type TEXT NOT NULL,  -- baidu, youdao, google, custom
  display_name TEXT NOT NULL,   -- 用户自定义的显示名称
  app_id TEXT,                  -- API App ID (百度、有道等需要)
  app_key TEXT,                 -- API App Key / Secret Key
  api_url TEXT,                 -- 自定义翻译API的URL (仅custom类型使用)
  is_enabled BOOLEAN DEFAULT TRUE,      -- 是否启用该配置
  is_default BOOLEAN DEFAULT FALSE,     -- 是否为默认翻译接口
  settings JSON,                -- 其他配置参数 (如超时时间、重试次数等)
  last_used_at DATETIME,        -- 最后使用时间
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE(user_id, provider_type, display_name)  -- 同一用户的同类型接口名称不能重复
);
```

#### 12. 系统配置表 (system_configs)
```sql
CREATE TABLE system_configs (
  id TEXT PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,        -- 配置键名，如 'system.max_upload_size'
  value TEXT,                      -- 配置值，JSON格式存储复杂数据
  value_type TEXT DEFAULT 'string', -- 值类型: string, number, boolean, json, array
  category TEXT NOT NULL,          -- 配置分类: system, security, translation, notification
  display_name TEXT NOT NULL,      -- 显示名称
  description TEXT,                -- 配置描述
  is_public BOOLEAN DEFAULT FALSE, -- 是否公开 (前端可读取)
  is_editable BOOLEAN DEFAULT TRUE, -- 是否可编辑
  default_value TEXT,              -- 默认值
  validation_rule TEXT,            -- 验证规则 (JSON格式)
  sort_order INTEGER DEFAULT 0,    -- 排序顺序
  created_by TEXT,
  updated_by TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id),
  FOREIGN KEY (updated_by) REFERENCES users(id)
);
```

### 预设数据

#### 系统角色
```
- SuperAdmin: 超级管理员
- ProjectOwner: 项目所有者  
- ProjectManager: 项目管理员
- Translator: 翻译员
- Reviewer: 审核员
- Viewer: 查看者
```

#### 系统配置
```
系统配置示例:

系统配置:
- system.site_title: 网站标题
- system.site_description: 网站描述
- system.max_upload_size: 最大上传文件大小 (MB)
- system.session_timeout: 会话超时时间 (分钟)
- system.maintenance_mode: 维护模式开关

安全配置:
- security.password_min_length: 密码最小长度
- security.password_require_special: 密码是否需要特殊字符
- security.login_max_attempts: 登录最大尝试次数
- security.jwt_expire_hours: JWT过期时间 (小时)

翻译配置:
- translation.default_provider: 默认翻译服务商
- translation.max_text_length: 单次翻译最大字符数
- translation.auto_save_interval: 自动保存间隔 (秒)
- translation.batch_size_limit: 批量翻译数量限制

通知配置:
- notification.email_enabled: 邮件通知开关
- notification.email_smtp_host: SMTP服务器地址
- notification.email_smtp_port: SMTP端口
- notification.email_from_address: 发件人邮箱
```

#### 系统权限
```
权限格式: {resource}.{action}

项目权限:
- project.create: 创建项目
- project.read: 查看项目
- project.update: 编辑项目
- project.delete: 删除项目
- project.manage: 管理项目成员

翻译权限:
- translation.create: 创建翻译条目
- translation.read: 查看翻译条目
- translation.update: 编辑翻译条目
- translation.delete: 删除翻译条目
- translation.review: 审核翻译
- translation.approve: 批准翻译

翻译接口权限:
- provider.create: 创建翻译接口配置
- provider.read: 查看翻译接口配置
- provider.update: 编辑翻译接口配置
- provider.delete: 删除翻译接口配置
- provider.use: 使用翻译接口

用户权限:
- user.read: 查看用户信息
- user.update: 编辑用户信息
- user.delete: 删除用户
- user.manage_roles: 管理用户角色

系统权限:
- system.admin: 系统管理
- system.backup: 数据备份
- system.restore: 数据恢复

配置权限:
- config.read: 查看系统配置
- config.update: 修改系统配置
- config.create: 创建系统配置
- config.delete: 删除系统配置
- config.public_read: 查看公开配置
```

## API 设计

### API版本控制
所有API端点都使用版本前缀 `/api/v1/`，例如：
- `/api/v1/auth/login`
- `/api/v1/projects`
- `/api/v1/users/me`

### 身份验证
```
POST /api/v1/auth/login
POST /api/v1/auth/logout
POST /api/v1/auth/refresh
POST /api/v1/auth/register
POST /api/v1/auth/forgot-password
POST /api/v1/auth/reset-password
```

### 用户管理
```
GET    /api/v1/users              # 获取用户列表
GET    /api/v1/users/{id}         # 获取用户详情
PUT    /api/v1/users/{id}         # 更新用户信息
DELETE /api/v1/users/{id}         # 删除用户
GET    /api/v1/users/me           # 获取当前用户信息
PUT    /api/v1/users/me           # 更新当前用户信息
```

### 项目管理
```
GET    /api/v1/projects           # 获取项目列表
POST   /api/v1/projects           # 创建项目
GET    /api/v1/projects/{id}      # 获取项目详情
PUT    /api/v1/projects/{id}      # 更新项目
DELETE /api/v1/projects/{id}      # 删除项目
GET    /api/v1/projects/{id}/members    # 获取项目成员
POST   /api/v1/projects/{id}/members    # 添加项目成员
DELETE /api/v1/projects/{id}/members/{userId}  # 移除项目成员
```

### 翻译管理
```
GET    /api/v1/projects/{id}/translations           # 获取翻译条目
POST   /api/v1/projects/{id}/translations           # 创建翻译条目
GET    /api/v1/projects/{id}/translations/{entryId} # 获取翻译条目详情
PUT    /api/v1/projects/{id}/translations/{entryId} # 更新翻译条目
DELETE /api/v1/projects/{id}/translations/{entryId} # 删除翻译条目
POST   /api/v1/projects/{id}/translations/batch     # 批量操作
GET    /api/v1/projects/{id}/translations/{entryId}/history  # 获取翻译历史
```

### 语言管理
```
GET    /api/v1/languages          # 获取支持的语言列表
POST   /api/v1/languages          # 添加语言
PUT    /api/v1/languages/{code}   # 更新语言信息
```

### 角色权限管理
```
GET    /api/v1/roles              # 获取角色列表
POST   /api/v1/roles              # 创建角色
PUT    /api/v1/roles/{id}         # 更新角色
DELETE /api/v1/roles/{id}         # 删除角色
GET    /api/v1/permissions        # 获取权限列表
```

### 翻译接口配置管理
```
GET    /api/v1/users/me/translation-providers           # 获取当前用户的翻译接口配置列表
POST   /api/v1/users/me/translation-providers           # 创建翻译接口配置
GET    /api/v1/users/me/translation-providers/{id}      # 获取翻译接口配置详情
PUT    /api/v1/users/me/translation-providers/{id}      # 更新翻译接口配置
DELETE /api/v1/users/me/translation-providers/{id}      # 删除翻译接口配置
POST   /api/v1/users/me/translation-providers/{id}/test # 测试翻译接口配置
PUT    /api/v1/users/me/translation-providers/{id}/default  # 设置为默认接口
GET    /api/v1/translation-providers/types              # 获取支持的翻译接口类型 (公共端点)
```

### 系统配置管理
```
GET    /api/v1/configs              # 获取系统配置列表 (按分类)
GET    /api/v1/configs/public       # 获取公开配置 (前端可访问)
GET    /api/v1/configs/{key}        # 获取特定配置项
PUT    /api/v1/configs/{key}        # 更新配置项
POST   /api/v1/configs              # 创建新配置项
DELETE /api/v1/configs/{key}        # 删除配置项
GET    /api/v1/configs/categories   # 获取配置分类列表
POST   /api/v1/configs/batch        # 批量更新配置
POST   /api/v1/configs/reset/{key}  # 重置配置为默认值
```

### 系统监控和健康检查
```
GET    /health               # 健康检查端点 (无版本前缀)
GET    /health/db           # 数据库连接检查 (无版本前缀)
GET    /health/ready        # 服务就绪检查 (无版本前缀)
GET    /metrics             # 系统指标 (Prometheus格式，无版本前缀)
GET    /api/v1/status       # 系统状态信息
GET    /api/v1/version      # 服务版本信息
```

## 权限设计

### 权限级别
1. **全局权限**: 影响整个系统的权限
2. **项目权限**: 仅在特定项目内有效的权限

### 权限检查流程
1. 验证 JWT Token 有效性
2. 获取用户的全局角色和项目角色
3. 检查操作所需的权限
4. 返回权限检查结果

### 权限继承
- 项目所有者自动拥有该项目的所有权限
- SuperAdmin 拥有系统所有权限
- 项目级权限不能超越全局权限限制

## 部署方案

### Docker 配置

#### Dockerfile
```dockerfile
FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart compile exe bin/server.dart -o bin/server

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y ca-certificates curl
COPY --from=build /app/bin/server /app/server
COPY --from=build /app/database/ /app/database/

EXPOSE 8080
CMD ["/app/server"]
```

#### docker-compose.yml
```yaml
version: '3.8'

networks:
  ttpolyglot-network:
    driver: bridge

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local

services:
  ttpolyglot-db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=${DB_NAME:-ttpolyglot}
      - POSTGRES_USER=${DB_USER:-ttpolyglot}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_INITDB_ARGS="--encoding=UTF8 --locale=C"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init:/docker-entrypoint-initdb.d
      - ./logs/postgres:/var/log/postgresql
    networks:
      - ttpolyglot-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-ttpolyglot} -d ${DB_NAME:-ttpolyglot}"]
      interval: 30s
      timeout: 10s
      retries: 5

  ttpolyglot-redis:
    image: redis:7-alpine
    environment:
      - REDIS_PASSWORD=${REDIS_PASSWORD:-}
    volumes:
      - redis_data:/data
      - ./logs/redis:/var/log/redis
    networks:
      - ttpolyglot-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3
    command: >
      sh -c "
        if [ -n \"$$REDIS_PASSWORD\" ]; then
          redis-server --requirepass $$REDIS_PASSWORD --appendonly yes --dir /data
        else
          redis-server --appendonly yes --dir /data
        fi
      "

  ttpolyglot-server:
    build: .
    environment:
      - DATABASE_URL=postgresql://${DB_USER:-ttpolyglot}:${DB_PASSWORD}@ttpolyglot-db:5432/${DB_NAME:-ttpolyglot}
      - REDIS_URL=redis://ttpolyglot-redis:6379
      - REDIS_PASSWORD=${REDIS_PASSWORD:-}
      - JWT_SECRET=${JWT_SECRET}
      - LOG_LEVEL=info
      - SERVER_HOST=0.0.0.0
      - SERVER_PORT=8080
    volumes:
      - ./data:/app/data
      - ./logs:/app/logs
    networks:
      - ttpolyglot-network
    restart: unless-stopped
    depends_on:
      ttpolyglot-db:
        condition: service_healthy
      ttpolyglot-redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  ttpolyglot-nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./ssl:/etc/ssl/certs
      - ./logs/nginx:/var/log/nginx
    depends_on:
      - ttpolyglot-server
    networks:
      - ttpolyglot-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "nginx", "-t"]
      interval: 30s
      timeout: 10s
      retries: 3
```

#### Nginx 配置文件

##### nginx/nginx.conf
```nginx
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # 日志格式
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log warn;

    # 基础配置
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size 10M;

    # Gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml
        text/plain
        text/css
        text/xml
        text/javascript
        application/xml
        application/rss+xml;

    # 上游服务器配置
    upstream ttpolyglot_backend {
        server ttpolyglot-server:8080;
        keepalive 32;
    }

    # 包含具体的服务器配置
    include /etc/nginx/conf.d/*.conf;
}
```

##### nginx/conf.d/ttpolyglot.conf
```nginx
server {
    listen 80;
    server_name localhost your-domain.com;
    
    # 重定向 HTTP 到 HTTPS (生产环境)
    # return 301 https://$server_name$request_uri;
    
    # 开发环境可以直接处理 HTTP 请求
    location / {
        proxy_pass http://ttpolyglot_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # 超时配置
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }

    # API 特殊配置
    location /api/ {
        proxy_pass http://ttpolyglot_backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # API 请求的特殊超时配置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # API版本控制支持
        add_header X-API-Version "v1" always;
    }

    # 健康检查端点
    location /health {
        proxy_pass http://ttpolyglot_backend/health;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        access_log off;
    }

    # 静态文件缓存 (如果有前端静态资源)
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
}

# HTTPS 配置 (生产环境)
server {
    listen 443 ssl http2;
    server_name your-domain.com;

    # SSL 证书配置
    ssl_certificate /etc/ssl/certs/your-domain.crt;
    ssl_certificate_key /etc/ssl/certs/your-domain.key;
    
    # SSL 配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # 安全头
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    location / {
        proxy_pass http://ttpolyglot_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # 超时配置
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }

    # API 特殊配置
    location /api/ {
        proxy_pass http://ttpolyglot_backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # API 请求的特殊超时配置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # API版本控制支持
        add_header X-API-Version "v1" always;
    }

    # 健康检查端点
    location /health {
        proxy_pass http://ttpolyglot_backend/health;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        access_log off;
    }
}
```

### 环境配置

#### .env 文件
```bash
# 数据库配置
DB_NAME=ttpolyglot
DB_USER=ttpolyglot
DB_PASSWORD=your-secure-password-change-in-production
DATABASE_URL=postgresql://ttpolyglot:your-secure-password-change-in-production@ttpolyglot-db:5432/ttpolyglot
DB_POOL_SIZE=20
DB_CONNECTION_TIMEOUT=30

# 服务器配置
SERVER_HOST=0.0.0.0
SERVER_PORT=8080
LOG_LEVEL=info
REQUEST_TIMEOUT=30

# JWT 配置
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRE_HOURS=24
JWT_REFRESH_EXPIRE_DAYS=7

# CORS 配置
CORS_ORIGINS=http://localhost:3000,https://your-domain.com
CORS_ALLOW_CREDENTIALS=true

# 请求限制
MAX_REQUEST_SIZE=10MB
RATE_LIMIT_REQUESTS=1000
RATE_LIMIT_WINDOW_MINUTES=15

# 缓存配置 (Redis)
REDIS_URL=redis://ttpolyglot-redis:6379
REDIS_PASSWORD=your-redis-password-change-in-production

# 缓存TTL配置 (根据数据类型设置不同过期时间)
CACHE_SESSION_TTL=86400        # 用户会话缓存：24小时
CACHE_API_RESPONSE_TTL=3600    # API响应缓存：1小时
CACHE_CONFIG_TTL=21600         # 系统配置缓存：6小时
CACHE_PERMISSION_TTL=7200      # 权限数据缓存：2小时
CACHE_TEMP_DATA_TTL=300        # 临时数据（验证码等）：5分钟

# Redis连接池配置
REDIS_MAX_CONNECTIONS=10
REDIS_CONNECTION_TIMEOUT=5
REDIS_RETRY_ATTEMPTS=3
REDIS_RETRY_DELAY=1000

# 安全配置
BCRYPT_ROUNDS=12
SESSION_SECRET=your-session-secret-change-in-production

# 监控配置
HEALTH_CHECK_ENABLED=true
METRICS_ENABLED=true
METRICS_PORT=9090

# 邮件配置 (可选)
SMTP_HOST=
SMTP_PORT=587
SMTP_USER=
SMTP_PASSWORD=
SMTP_FROM_ADDRESS=noreply@your-domain.com

# Nginx 配置
NGINX_DOMAIN=your-domain.com
NGINX_SSL_CERT_PATH=/etc/ssl/certs/your-domain.crt
NGINX_SSL_KEY_PATH=/etc/ssl/certs/your-domain.key

# 开发模式 (dev/prod)
ENVIRONMENT=dev
```

#### 部署脚本

##### deploy.sh
```bash
#!/bin/bash

# TTPolyglot 服务端部署脚本

set -e

echo "🚀 开始部署 TTPolyglot 服务端..."

# 检查必要文件
if [ ! -f ".env" ]; then
    echo "❌ 错误: .env 文件不存在"
    echo "请复制 .env.example 到 .env 并配置相应参数"
    exit 1
fi

# 创建必要的目录
echo "📁 创建目录结构..."
mkdir -p data logs logs/nginx logs/redis ssl nginx/conf.d

# 检查 Docker 和 Docker Compose
if ! command -v docker &> /dev/null; then
    echo "❌ 错误: Docker 未安装"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ 错误: Docker Compose 未安装"
    exit 1
fi

# 构建并启动服务
echo "🔨 构建 Docker 镜像..."
docker-compose build

echo "🚀 启动服务..."
docker-compose up -d

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 10

# 检查服务状态
echo "🔍 检查服务状态..."
if docker-compose ps | grep -q "Up"; then
    echo "✅ 服务启动成功!"
    echo ""
    echo "🌐 访问地址:"
    echo "  HTTP:  http://localhost"
    echo "  HTTPS: https://localhost (如果配置了SSL)"
    echo "  API:   http://localhost/api"
    echo ""
    echo "📊 服务状态:"
    docker-compose ps
else
    echo "❌ 服务启动失败"
    echo "查看日志: docker-compose logs"
    exit 1
fi

echo ""
echo "🎉 部署完成!"
```

##### scripts/ssl-setup.sh
```bash
#!/bin/bash

# SSL 证书配置脚本 (使用 Let's Encrypt)

DOMAIN=${1:-localhost}
EMAIL=${2:-admin@example.com}

echo "🔒 为域名 $DOMAIN 配置 SSL 证书..."

# 安装 certbot (如果未安装)
if ! command -v certbot &> /dev/null; then
    echo "📦 安装 Certbot..."
    sudo apt-get update
    sudo apt-get install -y certbot python3-certbot-nginx
fi

# 生成证书
echo "🎫 生成 SSL 证书..."
sudo certbot certonly --standalone \
    --preferred-challenges http \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    -d $DOMAIN

# 复制证书到项目目录
echo "📋 复制证书文件..."
sudo cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem ./ssl/your-domain.crt
sudo cp /etc/letsencrypt/live/$DOMAIN/privkey.pem ./ssl/your-domain.key
sudo chown $USER:$USER ./ssl/*

# 更新 Nginx 配置中的域名
sed -i "s/your-domain.com/$DOMAIN/g" nginx/conf.d/ttpolyglot.conf

echo "✅ SSL 证书配置完成!"
echo "请重启 Docker 服务: docker-compose restart nginx"
```

##### scripts/backup.sh
```bash
#!/bin/bash

# 数据备份脚本

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="ttpolyglot_backup_$DATE.tar.gz"

echo "💾 开始备份数据..."

# 创建备份目录
mkdir -p $BACKUP_DIR

# 停止应用服务（保持数据库和Redis运行以进行备份）
echo "⏸️  暂停应用服务..."
docker-compose stop ttpolyglot-server nginx

# 备份PostgreSQL数据库
echo "💾 备份数据库..."
DB_BACKUP_FILE="$BACKUP_DIR/database_$DATE.sql"
docker-compose exec -T ttpolyglot-db pg_dump -U ${DB_USER:-ttpolyglot} ${DB_NAME:-ttpolyglot} > "$DB_BACKUP_FILE"

# 备份Redis数据
echo "💾 备份Redis缓存..."
REDIS_BACKUP_FILE="$BACKUP_DIR/redis_$DATE.rdb"
docker-compose exec ttpolyglot-redis redis-cli save
docker cp $(docker-compose ps -q ttpolyglot-redis):/data/dump.rdb "$REDIS_BACKUP_FILE"

# 备份应用数据和配置
echo "📦 创建备份文件..."
tar -czf "$BACKUP_DIR/$BACKUP_FILE" \
    data/ \
    logs/ \
    .env \
    nginx/ \
    --exclude="logs/nginx/access.log*" \
    --exclude="logs/nginx/error.log*"

# 将数据库和Redis备份添加到tar文件
tar -rf "${BACKUP_DIR}/${BACKUP_FILE%.tar.gz}.tar" "$DB_BACKUP_FILE" "$REDIS_BACKUP_FILE"
gzip "${BACKUP_DIR}/${BACKUP_FILE%.tar.gz}.tar"
rm "$DB_BACKUP_FILE" "$REDIS_BACKUP_FILE"

# 重启服务
echo "▶️  重启服务..."
docker-compose start ttpolyglot-server nginx

# 清理旧备份（保留最近10个）
echo "🧹 清理旧备份..."
ls -t $BACKUP_DIR/ttpolyglot_backup_*.tar.gz | tail -n +11 | xargs -r rm

echo "✅ 备份完成: $BACKUP_DIR/$BACKUP_FILE"
```

##### scripts/restore.sh
```bash
#!/bin/bash

# 数据恢复脚本

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
    echo "❌ 用法: $0 <备份文件路径>"
    echo "示例: $0 ./backups/ttpolyglot_backup_20240101_120000.tar.gz"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ 错误: 备份文件 $BACKUP_FILE 不存在"
    exit 1
fi

echo "🔄 开始恢复数据..."
echo "⚠️  警告: 这将覆盖当前数据!"
read -p "确认继续? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 操作已取消"
    exit 1
fi

# 停止服务
echo "⏸️  停止服务..."
docker-compose down

# 备份当前数据
echo "💾 备份当前数据..."
DATE=$(date +%Y%m%d_%H%M%S)
tar -czf "./backups/pre_restore_backup_$DATE.tar.gz" data/ logs/ .env nginx/ 2>/dev/null || true

# 恢复应用数据
echo "📤 恢复应用数据..."
tar -xzf "$BACKUP_FILE"

# 检查是否包含数据库备份文件
if tar -tzf "$BACKUP_FILE" | grep -q "database_.*\.sql"; then
    echo "📥 恢复数据库..."
    # 提取数据库备份文件
    tar -xzf "$BACKUP_FILE" --wildcards "*/database_*.sql" -O > /tmp/db_restore.sql
    
    # 启动数据库服务
    docker-compose up -d ttpolyglot-db
    sleep 10  # 等待数据库启动
    
    # 恢复数据库
    docker-compose exec -T ttpolyglot-db psql -U ${DB_USER:-ttpolyglot} -d ${DB_NAME:-ttpolyglot} < /tmp/db_restore.sql
    rm /tmp/db_restore.sql
    
    echo "✅ 数据库恢复完成"
fi

# 检查是否包含Redis备份文件
if tar -tzf "$BACKUP_FILE" | grep -q "redis_.*\.rdb"; then
    echo "📥 恢复Redis缓存..."
    # 提取Redis备份文件
    tar -xzf "$BACKUP_FILE" --wildcards "*/redis_*.rdb" -O > /tmp/redis_restore.rdb
    
    # 启动Redis服务
    docker-compose up -d ttpolyglot-redis
    sleep 5  # 等待Redis启动
    
    # 停止Redis以恢复数据
    docker-compose stop ttpolyglot-redis
    
    # 复制备份文件到Redis数据目录
    docker cp /tmp/redis_restore.rdb $(docker-compose ps -q ttpolyglot-redis):/data/dump.rdb
    
    # 重启Redis
    docker-compose start ttpolyglot-redis
    rm /tmp/redis_restore.rdb
    
    echo "✅ Redis缓存恢复完成"
fi

# 重启所有服务
echo "🚀 重启所有服务..."
docker-compose up -d

echo "✅ 数据恢复完成!"
```

### 项目目录结构
```
ttpolyglot-server/
├── bin/
│   └── server.dart              # 服务器入口文件
├── lib/
│   ├── src/
│   │   ├── controllers/         # API 控制器
│   │   ├── models/             # 数据模型
│   │   ├── services/           # 业务逻辑服务
│   │   ├── middleware/         # 中间件
│   │   ├── database/           # 数据库相关
│   │   └── utils/              # 工具类
│   └── server.dart             # 服务器核心逻辑
├── database/
│   ├── migrations/             # 数据库迁移文件
│   ├── seeds/                  # 初始数据
│   └── init/                   # PostgreSQL 初始化脚本
├── test/                       # 测试文件
├── nginx/
│   ├── nginx.conf              # Nginx 主配置
│   └── conf.d/
│       └── ttpolyglot.conf     # 项目特定配置
├── scripts/
│   ├── ssl-setup.sh            # SSL 配置脚本
│   ├── backup.sh               # 备份脚本
│   └── restore.sh              # 恢复脚本
├── data/                       # 数据文件 (运行时创建)
├── logs/                       # 日志文件 (运行时创建)
│   ├── nginx/                  # Nginx 日志
│   └── redis/                  # Redis 日志
├── ssl/                        # SSL 证书
├── Dockerfile                  # Docker 构建文件
├── docker-compose.yml          # Docker Compose 配置
├── deploy.sh                   # 部署脚本
├── .env.example                # 环境变量示例
├── .env                        # 环境变量 (需要创建)
├── pubspec.yaml                # Dart 依赖配置
└── README.md                   # 项目说明
```

## 开发计划

### Phase 1: 基础架构 (2-3 周)
- [ ] 项目初始化和依赖配置
- [ ] 数据库 Schema 设计和迁移
- [ ] 基础 HTTP 服务器搭建
- [ ] JWT 身份验证实现
- [ ] 基础中间件 (CORS, 日志, 错误处理)
- [ ] 健康检查和监控端点
- [ ] 容器化配置 (Docker, docker-compose)

### Phase 2: 核心功能 (3-4 周)
- [ ] 用户注册登录系统
- [ ] 角色权限管理系统
- [ ] 系统配置管理
- [ ] 项目 CRUD 操作
- [ ] 语言管理
- [ ] 基础翻译条目管理
- [ ] 用户翻译接口配置管理

### Phase 3: 高级功能 (2-3 周)
- [ ] 翻译历史记录
- [ ] 批量操作 API
- [ ] 项目成员管理
- [ ] 权限细粒度控制
- [ ] API 文档生成 (OpenAPI/Swagger)
- [ ] 数据导入导出功能
- [ ] 邮件通知系统 (可选)

### Phase 4: 部署和优化 (1-2 周)
- [ ] Docker 多阶段构建优化
- [ ] Nginx 反向代理配置
- [ ] SSL/HTTPS 配置
- [ ] **Redis缓存系统实现**:
  - [ ] Redis连接池和配置
  - [ ] 用户会话缓存机制
  - [ ] API响应缓存中间件
  - [ ] 权限数据缓存策略
  - [ ] 系统配置缓存管理
  - [ ] 缓存失效和更新机制
  - [ ] 缓存监控和统计
- [ ] 监控和日志系统
- [ ] 自动化测试 (单元测试、集成测试)
- [ ] 部署脚本和备份策略
- [ ] 安全配置强化
- [ ] 负载测试和性能调优

### Phase 5: 客户端集成 (2-3 周)
- [ ] Flutter 客户端 API 集成
- [ ] 数据同步机制
- [ ] 离线支持
- [ ] 冲突解决策略

## 技术考虑

### 性能优化

#### 数据库优化
- 数据库索引优化（主键、外键、查询字段）
- 分页查询（避免大量数据传输）
- 连接池管理（PostgreSQL连接复用）
- 查询优化（JOIN优化、N+1查询避免）

#### 缓存策略
- **多层缓存架构**:
  ```
  客户端 → Nginx静态缓存 → Redis缓存 → PostgreSQL数据库
  ```

- **Redis缓存使用场景**:
  - **会话管理**: 用户登录状态、JWT Token黑名单
  - **权限缓存**: 用户角色权限矩阵，避免每次请求查询数据库
  - **配置缓存**: 系统配置、翻译接口配置等相对静态的数据
  - **API响应缓存**: GET请求的热点数据（项目列表、语言列表）
  - **计算结果缓存**: 统计数据、报告生成结果
  - **临时数据**: 验证码、密码重置token、文件上传临时ID

- **缓存更新策略**:
  - **Cache-Aside**: 应用层控制缓存读写
  - **Write-Through**: 数据更新时同步更新缓存
  - **TTL过期**: 根据数据特性设置合理的过期时间
  - **手动失效**: 数据变更时主动删除相关缓存

- **缓存键命名规范**:
  ```
  user:session:{userId}           # 用户会话
  user:permissions:{userId}       # 用户权限
  project:list:{userId}          # 用户项目列表
  config:system:{key}            # 系统配置
  api:response:{endpoint}:{hash} # API响应缓存
  temp:reset_token:{token}       # 临时重置token
  ```

### 安全措施
- SQL 注入防护
- XSS 防护
- CSRF 防护
- 访问频率限制
- 敏感信息加密

### 可扩展性
- 微服务架构准备
- 数据库读写分离
- 缓存层设计
- 消息队列集成
- Nginx 负载均衡配置
- 横向扩展支持

### 监控和日志
- 结构化日志
- 性能指标收集
- 错误追踪
- 健康检查端点

## 测试策略

### 单元测试
- 业务逻辑测试
- 数据访问层测试
- 工具函数测试

### 集成测试
- API 端点测试
- 数据库集成测试
- 身份验证流程测试

### 性能测试
- 并发请求测试
- 数据库性能测试
- 内存使用监控

## 快速开始

### 开发环境部署

1. **克隆项目** (未来)
   ```bash
   git clone https://github.com/your-org/ttpolyglot-server.git
   cd ttpolyglot-server
   ```

2. **配置环境变量**
   ```bash
   cp .env.example .env
   # 编辑 .env 文件，设置必要的配置项
   ```

3. **启动开发环境**
   ```bash
   # 使用 Docker Compose 启动
   ./deploy.sh
   
   # 或手动启动
   docker-compose up -d
   ```

4. **验证部署**
   ```bash
   # 检查服务状态
   curl http://localhost/health
   
   # 测试API端点
   curl http://localhost/api/v1/version
   
   # 查看日志
   docker-compose logs -f
   ```

### 生产环境部署

1. **SSL 证书配置**
   ```bash
   # 配置 SSL 证书 (Let's Encrypt)
   chmod +x scripts/ssl-setup.sh
   ./scripts/ssl-setup.sh your-domain.com your-email@example.com
   ```

2. **更新配置**
   ```bash
   # 更新 .env 文件中的生产环境配置
   # 设置强密码、正确的域名等
   ```

3. **启动生产服务**
   ```bash
   ENVIRONMENT=prod ./deploy.sh
   ```

### 常用命令

```bash
# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs ttpolyglot-server
docker-compose logs ttpolyglot-db
docker-compose logs ttpolyglot-redis
docker-compose logs nginx

# 重启服务
docker-compose restart

# 停止服务
docker-compose down

# 数据库操作
# 连接到数据库
docker-compose exec ttpolyglot-db psql -U ttpolyglot -d ttpolyglot

# 查看数据库状态
docker-compose exec ttpolyglot-db pg_isready -U ttpolyglot -d ttpolyglot

# 手动备份数据库
docker-compose exec ttpolyglot-db pg_dump -U ttpolyglot ttpolyglot > backup.sql

# 手动恢复数据库
docker-compose exec -T ttpolyglot-db psql -U ttpolyglot -d ttpolyglot < backup.sql

# 查看数据库大小
docker-compose exec ttpolyglot-db psql -U ttpolyglot -d ttpolyglot -c "\l+"

# Redis 操作
# 连接到Redis
docker-compose exec ttpolyglot-redis redis-cli

# 如果Redis有密码，使用AUTH命令
# docker-compose exec ttpolyglot-redis redis-cli -a your-redis-password

# 查看Redis信息
docker-compose exec ttpolyglot-redis redis-cli info

# 查看Redis缓存统计
docker-compose exec ttpolyglot-redis redis-cli info stats

# 查看Redis内存使用情况
docker-compose exec ttpolyglot-redis redis-cli info memory

# 查看所有键（谨慎使用，数据多时会很慢）
docker-compose exec ttpolyglot-redis redis-cli keys "*"

# 查看特定类型的缓存键
docker-compose exec ttpolyglot-redis redis-cli keys "user:session:*"
docker-compose exec ttpolyglot-redis redis-cli keys "config:*"
docker-compose exec ttpolyglot-redis redis-cli keys "api:response:*"

# 查看缓存命中率
docker-compose exec ttpolyglot-redis redis-cli info stats | grep "keyspace_hits\|keyspace_misses"

# 监控Redis实时命令
docker-compose exec ttpolyglot-redis redis-cli monitor

# 查看特定key的信息
docker-compose exec ttpolyglot-redis redis-cli type "user:session:123"
docker-compose exec ttpolyglot-redis redis-cli ttl "user:session:123"
docker-compose exec ttpolyglot-redis redis-cli get "config:system:max_upload_size"

# 删除特定缓存
docker-compose exec ttpolyglot-redis redis-cli del "user:session:123"

# 批量删除缓存
docker-compose exec ttpolyglot-redis redis-cli eval "return redis.call('del', unpack(redis.call('keys', ARGV[1])))" 0 "user:session:*"

# 查看Redis连接数
docker-compose exec ttpolyglot-redis redis-cli info clients

# 清空Redis缓存（谨慎使用）
docker-compose exec ttpolyglot-redis redis-cli flushall

# 仅清空当前数据库（默认db 0）
docker-compose exec ttpolyglot-redis redis-cli flushdb

# 数据备份
./scripts/backup.sh

# 数据恢复
./scripts/restore.sh ./backups/backup_file.tar.gz

# 更新服务
docker-compose pull
docker-compose up -d --build

# 仅重启应用服务（保持数据库运行）
docker-compose restart ttpolyglot-server nginx

# 清理未使用的Docker资源
docker system prune -f
docker volume prune -f
```

---

*此文档会根据开发进度持续更新和完善*
