# 控制器目录结构

本目录包含所有的 HTTP 控制器，按功能模块进行分类组织。

## 目录结构

```
controllers/
├── base_controller.dart        # 控制器基类
├── auth/                        # 认证与授权
│   ├── auth_controller.dart
│   ├── user_controller.dart
│   ├── role_controller.dart
│   ├── permission_controller.dart
│   └── auth.dart               # 导出文件
├── project/                    # 项目与翻译
│   ├── project_controller.dart
│   ├── translation_controller.dart
│   ├── language_controller.dart
│   ├── file_controller.dart
│   └── project.dart            # 导出文件
├── system/                     # 系统功能
│   ├── config_controller.dart
│   ├── notification_controller.dart
│   └── system.dart             # 导出文件
└── controllers.dart            # 主导出文件
```

## 分类说明

### 1. auth - 认证与授权
负责用户身份验证、权限管理和访问控制相关的功能。

- **auth_controller.dart**: 用户认证控制器
  - 用户登录、注册
  - 令牌刷新、撤销
  - 密码重置、修改
  
- **user_controller.dart**: 用户管理控制器
  - 用户信息的增删改查
  - 用户头像上传
  - 用户档案管理
  
- **role_controller.dart**: 角色管理控制器
  - 角色的创建、更新、删除
  - 角色权限的分配和撤销
  - 用户角色的管理
  
- **permission_controller.dart**: 权限管理控制器
  - 权限列表查询
  - 权限详情获取

### 2. project - 项目与翻译
负责翻译项目管理、翻译内容处理和文件操作相关的功能。

- **project_controller.dart**: 项目管理控制器
  - 项目的增删改查
  - 项目成员管理
  - 项目统计信息
  
- **translation_controller.dart**: 翻译控制器
  - 翻译内容的增删改查
  - 批量翻译操作
  - 翻译审核和批准
  - 翻译历史和版本管理
  
- **language_controller.dart**: 语言管理控制器
  - 支持语言的管理
  - 语言配置
  
- **file_controller.dart**: 文件管理控制器
  - 文件上传、下载、删除
  - 翻译文件的导入导出
  - 导出状态查询

### 3. system - 系统功能
负责系统级配置和通知相关的功能。

- **config_controller.dart**: 配置管理控制器
  - 系统配置的增删改查
  - 配置分类管理
  - 批量配置更新
  - 配置重置
  
- **notification_controller.dart**: 通知管理控制器
  - 通知列表查询
  - 通知已读标记
  - 通知删除

## 使用方式

### 方式 1: 导入整个控制器库
```dart
import 'package:ttpolyglot_server/src/controllers/controllers.dart';
```

### 方式 2: 导入特定分类
```dart
import 'package:ttpolyglot_server/src/controllers/auth/auth.dart';
import 'package:ttpolyglot_server/src/controllers/project/project.dart';
```

### 方式 3: 导入特定控制器
```dart
import 'package:ttpolyglot_server/src/controllers/auth/auth_controller.dart';
import 'package:ttpolyglot_server/src/controllers/project/project_controller.dart';
```

## 控制器职责

每个控制器负责：

1. **请求处理**: 接收和解析 HTTP 请求
2. **参数验证**: 验证请求参数的合法性
3. **业务调用**: 调用相应的 Service 层处理业务逻辑
4. **响应构建**: 使用 `ResponseUtils` 构建标准化的响应
5. **异常处理**: 捕获并转换异常为合适的 HTTP 响应

## BaseController 基类

所有控制器都继承自 `BaseController`，提供以下统一功能：

### 1. 请求信息获取
```dart
// 获取当前用户ID
final userId = getCurrentUserId(request);

// 获取认证令牌
final token = getAuthToken(request);

// 获取客户端IP
final ip = getClientIp(request);
```

### 2. 统一错误处理
```dart
return execute(
  () async {
    // 业务逻辑
    return ResponseUtils.success(data: result);
  },
  operationName: '操作名称',
  context: {'key': 'value'},
);
```

`execute` 方法会自动处理以下异常：
- `ValidationException` -> 验证错误响应
- `NotFoundException` -> 资源不存在响应
- `BusinessException` -> 业务错误响应
- `UnauthorizedException` -> 未授权响应
- `ForbiddenException` -> 禁止访问响应
- 其他异常 -> 内部服务器错误响应

### 3. 统一日志记录
```dart
logInfo('操作描述', context: {'key': 'value'});
logWarn('警告信息', context: {'key': 'value'});
logError('错误信息', error: error, stackTrace: stackTrace);
logDebug('调试信息', context: {'key': 'value'});
```

## 注意事项

1. **所有控制器必须继承 `BaseController`**，并在构造函数中调用 `super(controllerName)`
2. 所有导入都使用 package 风格，不使用相对路径
3. 每个子目录都有一个默认导出文件，方便批量导入
4. 控制器应该保持轻量，复杂的业务逻辑应放在 Service 层
5. 使用 `ResponseUtils` 构建统一格式的响应
6. 使用 `ValidatorUtils` 进行参数验证
7. 控制器方法应该是 async，返回 `Future<Response>`
8. 优先使用 `execute` 方法包装业务逻辑，自动处理错误和日志

## 相关文档

- [路由配置](../routes/README.md)
- [服务层](../services/README.md)
- [中间件](../middleware/README.md)
- [工具类](../utils/README.md)
