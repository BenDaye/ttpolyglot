# API 路由模块化架构

## 概述

本目录包含了 TTPolyglot 服务器的所有 API 路由定义。路由采用模块化设计，每个功能模块都有独立的路由文件，便于维护和扩展。

## 目录结构

```
routes/
├── api_routes.dart          # 主路由配置文件，负责组装所有模块路由
├── modules/                 # 各功能模块的路由定义
│   ├── auth_routes.dart         # 认证路由模块
│   ├── user_routes.dart         # 用户管理路由模块
│   ├── project_routes.dart      # 项目管理路由模块
│   ├── translation_routes.dart  # 翻译管理路由模块
│   ├── language_routes.dart     # 语言管理路由模块
│   ├── role_permission_routes.dart  # 角色权限管理路由模块
│   ├── config_routes.dart       # 系统配置路由模块
│   ├── file_routes.dart         # 文件管理路由模块
│   ├── notification_routes.dart # 通知管理路由模块
│   └── modules.dart            # 模块导出文件
└── README.md               # 本文档
```

## 架构设计

### 1. 主路由文件 (api_routes.dart)

主路由文件负责：
- 初始化认证中间件
- 组装所有功能模块路由
- 提供系统级别的路由（如 `/version`, `/status`）
- 统一的路由入口

### 2. 功能模块路由

每个功能模块路由类都遵循相同的设计模式：

```dart
class XxxRoutes {
  // 依赖注入所需的服务
  final ServiceA serviceA;
  final ServiceB serviceB;
  final Handler Function(Handler) withAuth;

  XxxRoutes({
    required this.serviceA,
    required this.serviceB,
    required this.withAuth,
  });

  /// 配置该模块的路由
  Router configure() {
    final router = Router();
    final controller = XxxController(...);
    
    // 定义路由
    router.get('/path', controller.method);
    router.post('/path', controller.method);
    
    return router;
  }
}
```

## 路由模块说明

### 认证路由 (auth_routes.dart)

处理用户认证相关的路由：
- 登录/注册
- 密码重置
- 邮箱验证
- 刷新令牌
- 登出

**特点**：部分路由公开（如登录、注册），部分需要认证（如登出）

### 用户路由 (user_routes.dart)

处理用户管理相关的路由：
- 用户 CRUD 操作
- 个人资料管理 (`/users/me`)
- 头像上传
- 会话管理
- 密码修改

**特点**：所有路由需要认证，内部处理认证逻辑

### 项目路由 (project_routes.dart)

处理项目管理相关的路由：
- 项目 CRUD 操作
- 项目归档/恢复
- 项目成员管理
- 项目语言管理
- 项目统计和活动

**特点**：整体应用认证中间件

### 翻译路由 (translation_routes.dart)

处理翻译管理相关的路由：
- 翻译条目 CRUD 操作
- 批量操作
- 翻译历史和版本
- 翻译状态管理（分配、提交、审核、批准、拒绝）
- 翻译搜索和过滤

**特点**：整体应用认证中间件

### 语言路由 (language_routes.dart)

处理语言管理相关的路由：
- 语言 CRUD 操作

**特点**：整体应用认证中间件

### 角色权限路由 (role_permission_routes.dart)

处理角色权限管理相关的路由：
- 角色管理
- 权限管理
- 角色权限关联
- 用户角色管理

**特点**：整体应用认证中间件

### 系统配置路由 (config_routes.dart)

处理系统配置相关的路由：
- 配置 CRUD 操作
- 公开配置查询
- 批量更新配置
- 重置配置

**特点**：部分路由公开（如 `/configs/public`），其他需要认证

### 文件路由 (file_routes.dart)

处理文件管理相关的路由：
- 文件上传/下载/删除
- 项目文件导入导出
- 导出任务状态查询

**特点**：整体应用认证中间件

### 通知路由 (notification_routes.dart)

处理通知管理相关的路由：
- 通知查询
- 标记已读
- 删除通知

**特点**：整体应用认证中间件

## 认证策略

路由的认证方式有三种：

1. **模块内部处理认证** - 适用于部分路由需要认证，部分路由公开的情况
   - 示例：认证路由、用户路由、配置路由
   - 在模块内部使用 `withAuth()` 包装需要认证的路由

2. **整体应用认证** - 适用于所有路由都需要认证的情况
   - 示例：项目路由、翻译路由、语言路由等
   - 在主路由文件中挂载时应用 `_withAuth()`

3. **公开路由** - 不需要认证的路由
   - 示例：登录、注册、密码重置等

## 添加新路由模块

1. 在 `modules/` 目录下创建新的路由文件，例如 `new_feature_routes.dart`

2. 定义路由类：
```dart
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../controllers/controllers.dart';
import '../../services/services.dart';

class NewFeatureRoutes {
  final RequiredService service;
  final Handler Function(Handler) withAuth;

  NewFeatureRoutes({
    required this.service,
    required this.withAuth,
  });

  Router configure() {
    final router = Router();
    final controller = NewFeatureController(service: service);
    
    router.get('/new-feature', controller.getItems);
    router.post('/new-feature', controller.createItem);
    
    return router;
  }
}
```

3. 在 `modules/modules.dart` 中导出新模块：
```dart
export 'new_feature_routes.dart';
```

4. 在 `api_routes.dart` 的 `_mountModuleRoutes()` 方法中注册新模块：
```dart
final newFeatureRoutes = NewFeatureRoutes(
  service: requiredService,
  withAuth: _withAuth,
);
_router.mount('/', _withAuth(newFeatureRoutes.configure().call));
```

## 优势

1. **模块化** - 每个功能模块独立，职责清晰
2. **易维护** - 修改某个功能的路由不影响其他模块
3. **可扩展** - 添加新功能只需创建新的路由模块
4. **可测试** - 每个路由模块可以独立测试
5. **代码复用** - 认证逻辑统一处理
6. **清晰的依赖关系** - 通过构造函数明确依赖

## 最佳实践

1. **保持单一职责** - 每个路由模块只处理一个功能领域
2. **统一的命名规范** - 所有路由模块类以 `Routes` 结尾
3. **依赖注入** - 通过构造函数注入所需的服务
4. **认证策略明确** - 在注释中说明该模块的认证策略
5. **路由组织** - 相关路由分组，添加清晰的注释
6. **版本控制** - 如需支持多版本 API，可在模块内部处理版本路由

