# TTPolyglot API 设计文档

## API 设计原则

### 版本控制
所有API端点都使用版本前缀 `/api/v1/`，例如：
- `/api/v1/auth/login`
- `/api/v1/projects`
- `/api/v1/users/me`

### RESTful 设计
遵循 RESTful API 设计规范：
- GET: 获取资源
- POST: 创建资源
- PUT: 更新资源（完整更新）
- PATCH: 更新资源（部分更新）
- DELETE: 删除资源

## API 端点设计

### 身份验证
```
POST   /api/v1/auth/login           # 用户登录
POST   /api/v1/auth/logout          # 用户登出
POST   /api/v1/auth/refresh         # 刷新Token
POST   /api/v1/auth/register        # 用户注册
POST   /api/v1/auth/forgot-password # 忘记密码
POST   /api/v1/auth/reset-password  # 重置密码
GET    /api/v1/auth/verify-email    # 邮箱验证
POST   /api/v1/auth/resend-verification # 重新发送验证邮件
```

### 用户管理
```
GET    /api/v1/users               # 获取用户列表 (管理员)
GET    /api/v1/users/{id}          # 获取用户详情
PUT    /api/v1/users/{id}          # 更新用户信息
DELETE /api/v1/users/{id}          # 删除用户 (管理员)
GET    /api/v1/users/me            # 获取当前用户信息
PUT    /api/v1/users/me            # 更新当前用户信息
POST   /api/v1/users/me/avatar     # 上传用户头像
DELETE /api/v1/users/me/avatar     # 删除用户头像
GET    /api/v1/users/me/sessions   # 获取当前用户会话列表
DELETE /api/v1/users/me/sessions/{id} # 删除指定会话
POST   /api/v1/users/me/change-password # 修改密码
```

### 项目管理
```
GET    /api/v1/projects            # 获取项目列表
POST   /api/v1/projects            # 创建项目
GET    /api/v1/projects/{id}       # 获取项目详情
PUT    /api/v1/projects/{id}       # 更新项目
DELETE /api/v1/projects/{id}       # 删除项目
POST   /api/v1/projects/{id}/archive   # 归档项目
POST   /api/v1/projects/{id}/restore   # 恢复项目

# 项目成员管理
GET    /api/v1/projects/{id}/members    # 获取项目成员
POST   /api/v1/projects/{id}/members    # 添加项目成员
PUT    /api/v1/projects/{id}/members/{userId} # 更新成员角色
DELETE /api/v1/projects/{id}/members/{userId} # 移除项目成员

# 项目语言管理
GET    /api/v1/projects/{id}/languages  # 获取项目支持的语言
POST   /api/v1/projects/{id}/languages  # 添加项目语言
PUT    /api/v1/projects/{id}/languages/{code} # 更新语言设置
DELETE /api/v1/projects/{id}/languages/{code} # 移除项目语言

# 项目统计
GET    /api/v1/projects/{id}/statistics # 获取项目统计信息
GET    /api/v1/projects/{id}/activity   # 获取项目活动日志
```

### 翻译管理
```
# 翻译条目 CRUD
GET    /api/v1/projects/{id}/translations           # 获取翻译条目列表
POST   /api/v1/projects/{id}/translations           # 创建翻译条目
GET    /api/v1/projects/{id}/translations/{entryId} # 获取翻译条目详情
PUT    /api/v1/projects/{id}/translations/{entryId} # 更新翻译条目
PATCH  /api/v1/projects/{id}/translations/{entryId} # 部分更新翻译条目
DELETE /api/v1/projects/{id}/translations/{entryId} # 删除翻译条目

# 批量操作
POST   /api/v1/projects/{id}/translations/batch     # 批量创建/更新翻译条目
DELETE /api/v1/projects/{id}/translations/batch     # 批量删除翻译条目
POST   /api/v1/projects/{id}/translations/batch/translate # 批量自动翻译
POST   /api/v1/projects/{id}/translations/batch/approve   # 批量批准翻译

# 翻译历史和版本
GET    /api/v1/projects/{id}/translations/{entryId}/history  # 获取翻译历史
GET    /api/v1/projects/{id}/translations/{entryId}/versions # 获取翻译版本列表
POST   /api/v1/projects/{id}/translations/{entryId}/revert   # 恢复到指定版本

# 翻译状态管理
POST   /api/v1/projects/{id}/translations/{entryId}/assign  # 分配翻译员
POST   /api/v1/projects/{id}/translations/{entryId}/submit  # 提交翻译
POST   /api/v1/projects/{id}/translations/{entryId}/review  # 审核翻译
POST   /api/v1/projects/{id}/translations/{entryId}/approve # 批准翻译
POST   /api/v1/projects/{id}/translations/{entryId}/reject  # 拒绝翻译

# 翻译搜索和过滤
GET    /api/v1/projects/{id}/translations/search    # 搜索翻译条目
GET    /api/v1/projects/{id}/translations/filter    # 过滤翻译条目
```

### 语言管理
```
GET    /api/v1/languages           # 获取支持的语言列表
POST   /api/v1/languages           # 添加语言 (管理员)
GET    /api/v1/languages/{code}    # 获取语言详情
PUT    /api/v1/languages/{code}    # 更新语言信息 (管理员)
DELETE /api/v1/languages/{code}    # 删除语言 (管理员)
```

### 角色权限管理
```
# 角色管理
GET    /api/v1/roles               # 获取角色列表
POST   /api/v1/roles               # 创建角色 (管理员)
GET    /api/v1/roles/{id}          # 获取角色详情
PUT    /api/v1/roles/{id}          # 更新角色 (管理员)
DELETE /api/v1/roles/{id}          # 删除角色 (管理员)

# 权限管理
GET    /api/v1/permissions         # 获取权限列表
GET    /api/v1/permissions/{id}    # 获取权限详情

# 角色权限关联
GET    /api/v1/roles/{id}/permissions    # 获取角色权限
POST   /api/v1/roles/{id}/permissions    # 为角色分配权限
DELETE /api/v1/roles/{id}/permissions/{permissionId} # 撤销角色权限

# 用户角色管理
GET    /api/v1/users/{userId}/roles      # 获取用户角色
POST   /api/v1/users/{userId}/roles      # 为用户分配角色
DELETE /api/v1/users/{userId}/roles/{roleId} # 撤销用户角色
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
PUT    /api/v1/configs/{key}        # 更新配置项 (管理员)
POST   /api/v1/configs              # 创建新配置项 (管理员)
DELETE /api/v1/configs/{key}        # 删除配置项 (管理员)
GET    /api/v1/configs/categories   # 获取配置分类列表
POST   /api/v1/configs/batch        # 批量更新配置 (管理员)
POST   /api/v1/configs/reset/{key}  # 重置配置为默认值 (管理员)
```

### 文件管理
```
POST   /api/v1/files/upload         # 文件上传
GET    /api/v1/files/{id}           # 获取文件信息
GET    /api/v1/files/{id}/download  # 下载文件
DELETE /api/v1/files/{id}           # 删除文件

# 项目文件导入导出
POST   /api/v1/projects/{id}/import # 导入翻译文件
POST   /api/v1/projects/{id}/export # 导出翻译文件
GET    /api/v1/projects/{id}/export/{taskId} # 获取导出任务状态
```

### 通知管理
```
GET    /api/v1/notifications        # 获取当前用户通知列表
GET    /api/v1/notifications/{id}   # 获取通知详情
PUT    /api/v1/notifications/{id}/read    # 标记通知为已读
POST   /api/v1/notifications/mark-all-read # 标记所有通知为已读
DELETE /api/v1/notifications/{id}         # 删除通知
```

### 系统监控和健康检查
```
GET    /health                      # 健康检查端点 (无版本前缀)
GET    /health/db                   # 数据库连接检查 (无版本前缀)
GET    /health/ready                # 服务就绪检查 (无版本前缀)
GET    /metrics                     # 系统指标 (Prometheus格式，无版本前缀)
GET    /api/v1/status               # 系统状态信息
GET    /api/v1/version              # 服务版本信息
```

## HTTP 状态码规范

### 成功响应 (2xx)
```
200 OK                    # 请求成功，返回数据
201 Created               # 资源创建成功
202 Accepted              # 请求已接受，异步处理
204 No Content            # 成功但无返回内容 (DELETE操作)
```

### 客户端错误 (4xx)
```
400 Bad Request           # 请求参数错误
401 Unauthorized          # 未认证或认证失败
403 Forbidden             # 已认证但无权限
404 Not Found             # 资源不存在
405 Method Not Allowed    # HTTP方法不支持
409 Conflict              # 资源冲突 (如重复创建)
422 Unprocessable Entity  # 请求格式正确但语义错误
429 Too Many Requests     # 请求过于频繁
```

### 服务器错误 (5xx)
```
500 Internal Server Error # 服务器内部错误
502 Bad Gateway           # 上游服务错误
503 Service Unavailable   # 服务暂时不可用
504 Gateway Timeout       # 上游服务超时
```

## 标准响应格式

### 成功响应格式

#### 单个资源响应
```json
{
  "data": {
    "id": "proj_123",
    "name": "我的项目",
    "status": "active",
    "created_at": "2024-12-26T10:30:00.000Z"
  },
  "metadata": {
    "request_id": "req_1234567890abcdef",
    "timestamp": "2024-12-26T10:30:00.000Z"
  }
}
```

#### 列表响应 (带分页)
```json
{
  "data": [
    {
      "id": "proj_123",
      "name": "项目1"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "pages": 5,
    "has_next": true,
    "has_prev": false
  },
  "metadata": {
    "request_id": "req_1234567890abcdef",
    "timestamp": "2024-12-26T10:30:00.000Z"
  }
}
```

#### 批量操作响应
```json
{
  "data": {
    "total": 100,
    "success": 95,
    "failed": 5,
    "results": [
      {
        "id": "entry_1",
        "status": "success",
        "data": { "id": "entry_1", "text": "翻译成功" }
      },
      {
        "id": "entry_2", 
        "status": "failed",
        "error": {
          "code": "BUSINESS_TRANSLATION_FAILED",
          "message": "翻译失败"
        }
      }
    ]
  }
}
```

### 错误响应格式

#### 基础错误结构
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "人类可读的错误信息",
    "details": "详细错误描述或调试信息",
    "field_errors": [
      {
        "field": "字段名",
        "code": "FIELD_ERROR_CODE", 
        "message": "字段错误信息"
      }
    ],
    "metadata": {
      "request_id": "req_1234567890abcdef",
      "timestamp": "2024-12-26T10:30:00.000Z",
      "path": "/api/v1/projects",
      "method": "POST",
      "user_id": "user_uuid_123",
      "trace_id": "trace_xyz789"
    }
  }
}
```

## 错误代码分类

### 认证授权错误 (AUTH_*)
```json
{
  "error": {
    "code": "AUTH_TOKEN_MISSING",
    "message": "认证令牌缺失",
    "details": "请在请求头中提供 Authorization: Bearer <token>"
  }
}

{
  "error": {
    "code": "AUTH_TOKEN_EXPIRED", 
    "message": "认证令牌已过期",
    "details": "请使用 refresh token 刷新或重新登录"
  }
}

{
  "error": {
    "code": "AUTH_INVALID_CREDENTIALS",
    "message": "用户名或密码错误",
    "details": "请检查您的登录凭据"
  }
}

{
  "error": {
    "code": "AUTH_PERMISSION_DENIED",
    "message": "权限不足",
    "details": "您没有执行此操作的权限"
  }
}

{
  "error": {
    "code": "AUTH_ACCOUNT_LOCKED",
    "message": "账户已被锁定",
    "details": "由于多次登录失败，账户已被临时锁定"
  }
}
```

### 验证错误 (VALIDATION_*)
```json
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "请求参数验证失败",
    "field_errors": [
      {
        "field": "email",
        "code": "VALIDATION_EMAIL_INVALID",
        "message": "邮箱格式不正确"
      },
      {
        "field": "password",
        "code": "VALIDATION_PASSWORD_TOO_SHORT", 
        "message": "密码长度至少8位"
      },
      {
        "field": "project_name",
        "code": "VALIDATION_REQUIRED",
        "message": "项目名称为必填项"
      }
    ]
  }
}

{
  "error": {
    "code": "VALIDATION_DUPLICATE_RESOURCE",
    "message": "资源已存在",
    "details": "该项目名称已被使用，请选择其他名称"
  }
}
```

### 资源错误 (RESOURCE_*)
```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "请求的资源不存在",
    "details": "项目ID 'proj_123' 未找到"
  }
}

{
  "error": {
    "code": "RESOURCE_ALREADY_EXISTS", 
    "message": "资源已存在",
    "details": "项目名称 'my-project' 已被使用"
  }
}

{
  "error": {
    "code": "RESOURCE_IN_USE",
    "message": "资源正在使用中，无法删除",
    "details": "该项目包含翻译数据，请先清空后再删除"
  }
}
```

### 业务逻辑错误 (BUSINESS_*)
```json
{
  "error": {
    "code": "BUSINESS_TRANSLATION_LIMIT_EXCEEDED",
    "message": "翻译配额已用完", 
    "details": "本月翻译配额已达上限，请升级套餐或等待下月重置"
  }
}

{
  "error": {
    "code": "BUSINESS_FILE_TOO_LARGE",
    "message": "文件大小超出限制",
    "details": "文件大小不能超过 10MB"
  }
}

{
  "error": {
    "code": "BUSINESS_UNSUPPORTED_FILE_TYPE",
    "message": "不支持的文件类型",
    "details": "仅支持 .json, .csv, .po, .xlsx 格式的文件"
  }
}
```

### 外部服务错误 (EXTERNAL_*)
```json
{
  "error": {
    "code": "EXTERNAL_TRANSLATION_API_ERROR",
    "message": "翻译服务暂时不可用",
    "details": "百度翻译API返回错误，请稍后重试"
  }
}

{
  "error": {
    "code": "EXTERNAL_EMAIL_SEND_FAILED",
    "message": "邮件发送失败", 
    "details": "SMTP服务器连接超时"
  }
}
```

### 系统错误 (SYSTEM_*)
```json
{
  "error": {
    "code": "SYSTEM_DATABASE_ERROR",
    "message": "数据库连接错误",
    "details": "系统正在维护中，请稍后重试"
  }
}

{
  "error": {
    "code": "SYSTEM_RATE_LIMIT_EXCEEDED", 
    "message": "请求频率过高",
    "details": "您在15分钟内的请求次数已达上限，请稍后重试",
    "metadata": {
      "retry_after": 900,
      "limit": 1000,
      "remaining": 0,
      "reset_time": "2024-12-26T11:00:00.000Z"
    }
  }
}

{
  "error": {
    "code": "SYSTEM_MAINTENANCE_MODE",
    "message": "系统维护中",
    "details": "系统正在进行维护升级，预计30分钟后恢复服务"
  }
}
```

## 请求参数规范

### 查询参数

#### 分页参数
```
?page=1&limit=20         # 页码和每页数量
?offset=0&limit=20       # 偏移量和数量 (可选)
```

#### 排序参数
```
?sort=created_at         # 按字段排序 (默认升序)
?sort=-created_at        # 降序排序 (前缀 -)
?sort=name,created_at    # 多字段排序
```

#### 过滤参数
```
?status=active           # 简单过滤
?status=active,pending   # 多值过滤
?created_at_gte=2024-01-01 # 日期范围过滤
?search=关键词            # 全文搜索
```

#### 字段选择
```
?fields=id,name,status   # 只返回指定字段
?include=members,stats   # 包含关联数据
```

### 请求头规范
```
Authorization: Bearer <jwt_token>    # JWT认证令牌
Content-Type: application/json       # 请求内容类型
Accept: application/json             # 接受的响应类型
X-Request-ID: req_123456789         # 请求追踪ID (可选)
X-Client-Version: 1.0.0             # 客户端版本 (可选)
```

## API 认证与授权

### JWT Token 格式
```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "sub": "user_uuid_123",
    "iat": 1640995200,
    "exp": 1641081600,
    "iss": "ttpolyglot-server",
    "aud": "ttpolyglot-client",
    "user_id": "user_uuid_123",
    "username": "john_doe",
    "email": "john@example.com",
    "roles": ["translator", "reviewer"],
    "permissions": ["project.read", "translation.update"]
  }
}
```

### 权限检查流程
1. 验证 JWT Token 有效性
2. 检查 Token 是否在黑名单中 (Redis)
3. 获取用户的全局角色和项目角色
4. 检查操作所需的权限
5. 返回权限检查结果

### API 版本兼容性
- 向后兼容的更改 (字段添加、可选参数等) 在同一版本内进行
- 破坏性更改需要升级版本号
- 旧版本 API 至少保持 6 个月的支持期
- 通过 `Accept-Version` 头或 URL 路径指定版本

### 速率限制
```
X-RateLimit-Limit: 1000        # 限制总数
X-RateLimit-Remaining: 999     # 剩余次数
X-RateLimit-Reset: 1640995200  # 重置时间戳
Retry-After: 900               # 重试等待时间 (秒)
```

### CORS 配置
```
Access-Control-Allow-Origin: https://app.ttpolyglot.com
Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS
Access-Control-Allow-Headers: Authorization, Content-Type, X-Request-ID
Access-Control-Allow-Credentials: true
Access-Control-Max-Age: 86400
```

## 示例 API 调用

### 用户登录
```bash
curl -X POST /api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'

# 响应
{
  "data": {
    "user": {
      "id": "user_123",
      "username": "user123",
      "email": "user@example.com",
      "display_name": "User Name"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "refresh_token_here",
    "expires_in": 86400
  }
}
```

### 获取项目列表
```bash
curl -X GET "/api/v1/projects?page=1&limit=10&sort=-created_at" \
  -H "Authorization: Bearer <token>"

# 响应
{
  "data": [
    {
      "id": "proj_123",
      "name": "My Project",
      "slug": "my-project",
      "status": "active",
      "members_count": 5,
      "total_keys": 100,
      "translated_keys": 80,
      "completion_percentage": 80.0,
      "created_at": "2024-12-26T10:30:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "pages": 1,
    "has_next": false,
    "has_prev": false
  }
}
```

### 创建翻译条目
```bash
curl -X POST /api/v1/projects/proj_123/translations \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "entry_key": "welcome.message",
    "language_code": "en",
    "source_text": "Welcome to our app!",
    "target_text": "欢迎使用我们的应用！"
  }'

# 响应
{
  "data": {
    "id": "trans_456",
    "entry_key": "welcome.message",
    "language_code": "en",
    "source_text": "Welcome to our app!",
    "target_text": "欢迎使用我们的应用！",
    "status": "pending",
    "created_at": "2024-12-26T10:30:00.000Z"
  }
}
```

### 批量翻译
```bash
curl -X POST /api/v1/projects/proj_123/translations/batch/translate \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "entries": [
      {
        "entry_key": "hello.world",
        "source_language": "en",
        "target_language": "zh-CN",
        "source_text": "Hello World"
      }
    ],
    "provider_id": "provider_789",
    "auto_approve": false
  }'

# 响应
{
  "data": {
    "task_id": "task_abc123",
    "status": "processing",
    "total": 1,
    "processed": 0,
    "estimated_completion": "2024-12-26T10:35:00.000Z"
  }
}
```
