# 控制器目录结构

本目录包含所有的 HTTP 控制器，按功能模块进行分类组织。

## 目录结构

```
controllers/
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

## 注意事项

1. 所有导入都使用 package 风格，不使用相对路径
2. 每个子目录都有一个默认导出文件，方便批量导入
3. 控制器应该保持轻量，复杂的业务逻辑应放在 Service 层
4. 使用 `ResponseUtils` 构建统一格式的响应
5. 使用 `ValidatorUtils` 进行参数验证
6. 控制器方法应该是 async，返回 `Future<Response>`

## 相关文档

- [路由配置](../routes/README.md)
- [服务层](../services/README.md)
- [中间件](../middleware/README.md)
- [工具类](../utils/README.md)
