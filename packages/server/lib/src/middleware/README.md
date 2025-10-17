# 中间件目录结构

本目录包含所有的 HTTP 中间件，按功能类型进行分类组织。

## 目录结构

```
middleware/
├── auth/                    # 认证与授权
│   ├── auth_middleware.dart
│   ├── permission_middleware.dart
│   └── auth.dart           # 导出文件
├── security/               # 安全相关
│   ├── cors_middleware.dart
│   ├── rate_limit_middleware.dart
│   └── security.dart       # 导出文件
├── observability/          # 可观测性
│   ├── logging_middleware.dart
│   ├── metrics_middleware.dart
│   ├── request_id_middleware.dart
│   └── observability.dart  # 导出文件
├── error_handling/         # 错误处理
│   ├── error_handler_middleware.dart
│   ├── retry_middleware.dart
│   └── error_handling.dart # 导出文件
└── middleware.dart         # 主导出文件
```

## 分类说明

### 1. auth - 认证与授权
- **auth_middleware.dart**: 用户认证中间件，负责验证 JWT 令牌
- **permission_middleware.dart**: 权限检查中间件，负责验证用户权限

### 2. security - 安全相关
- **cors_middleware.dart**: CORS 跨域资源共享中间件
- **rate_limit_middleware.dart**: 速率限制中间件，防止 API 滥用

### 3. observability - 可观测性
- **logging_middleware.dart**: 结构化日志中间件
- **metrics_middleware.dart**: 性能指标收集中间件
- **request_id_middleware.dart**: 请求 ID 追踪中间件

### 4. error_handling - 错误处理
- **error_handler_middleware.dart**: 统一错误处理中间件
- **retry_middleware.dart**: 请求重试中间件

## 使用方式

### 方式 1: 导入整个中间件库
```dart
import 'package:ttpolyglot_server/src/middleware/middleware.dart';
```

### 方式 2: 导入特定分类
```dart
import 'package:ttpolyglot_server/src/middleware/auth/auth.dart';
import 'package:ttpolyglot_server/src/middleware/security/security.dart';
```

### 方式 3: 导入特定中间件
```dart
import 'package:ttpolyglot_server/src/middleware/auth/auth_middleware.dart';
import 'package:ttpolyglot_server/src/middleware/security/rate_limit_middleware.dart';
```

## 注意事项

1. 所有导入都使用 package 风格，不使用相对路径
2. 每个子目录都有一个默认导出文件，方便批量导入
3. 中间件的执行顺序很重要，请参考 `server.dart` 中的配置
