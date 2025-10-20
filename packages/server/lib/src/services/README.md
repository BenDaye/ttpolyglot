# Services 目录结构说明

## 目录结构

```
services/
├── base_service.dart                # 基础服务类（所有业务服务都应继承）
├── services.dart                    # 统一导出文件
│
├── infrastructure/                  # 基础设施服务
│   ├── database_service.dart       # 数据库服务
│   ├── database_connection_pool.dart # 数据库连接池
│   ├── redis_service.dart          # Redis缓存服务
│   ├── multi_level_cache_service.dart # 多级缓存服务
│   └── infrastructure_services.dart # 基础设施服务导出
│
├── business/                        # 业务服务（继承 BaseService）
│   ├── auth_service.dart           # 认证服务
│   ├── user_service.dart           # 用户服务
│   ├── project_service.dart        # 项目服务
│   ├── translation_service.dart    # 翻译条目服务
│   ├── translation_provider_service.dart # 翻译接口配置服务
│   ├── config_service.dart         # 系统配置服务
│   ├── permission_service.dart     # 权限服务
│   └── business_services.dart      # 业务服务导出
│
└── feature/                         # 功能服务（继承 BaseService）
    ├── email_service.dart          # 邮件服务
    ├── file_upload_service.dart    # 文件上传服务
    ├── metrics_service.dart        # 监控指标服务
    └── feature_services.dart       # 功能服务导出
```

## 服务分类原则

### 1. Infrastructure（基础设施服务）
- **特点**: 不继承 BaseService，提供底层技术能力
- **包含**: 数据库、缓存、连接池等
- **使用**: 被其他服务依赖注入使用

### 2. Business（业务服务）
- **特点**: 继承 BaseService，处理核心业务逻辑
- **包含**: 认证、用户、项目、翻译等业务功能
- **使用**: 使用 BaseService 提供的日志、异常处理等能力

### 3. Feature（功能服务）
- **特点**: 继承 BaseService，提供通用功能
- **包含**: 邮件、文件上传、监控等
- **使用**: 可被业务服务调用

## BaseService 功能

所有业务服务和功能服务都继承 `BaseService`，获得以下能力：

### 1. 统一日志
```dart
logInfo('操作描述', context: {'key': 'value'});
logWarn('警告信息', context: {'key': 'value'});
logError('错误信息', error: error, stackTrace: stackTrace);
logDebug('调试信息', context: {'key': 'value'});
```

### 2. 统一异常处理
```dart
throwNotFound('资源不存在');
throwBusiness('业务错误');
throwValidation('验证错误');
throwConflict('资源冲突');
throwUnauthorized('未授权');
throwForbidden('禁止访问');
```

### 3. 执行包装
```dart
return execute<T>(
  () async {
    // 业务逻辑
    return result;
  },
  operationName: '操作名称',
);
```

## 导入路径规则

### Infrastructure 目录
```dart
import '../../config/server_config.dart';  // 向上两级
import '../../utils/xxx.dart';
```

### Business/Feature 目录
```dart
import '../base_service.dart';  // 向上一级到 services 根目录
import '../infrastructure/database_service.dart';  // 其他子目录
import '../feature/email_service.dart';
import '../../config/server_config.dart';  // 向上两级到 src
import '../../utils/xxx.dart';
```

## 已完成的工作

✅ 1. 创建三级目录结构（infrastructure/business/feature）
✅ 2. 移动所有服务文件到对应目录
✅ 3. 创建各目录的导出文件
✅ 4. 更新主 services.dart 统一导出
✅ 5. 所有业务服务和功能服务继承 BaseService
✅ 6. 修复基础导入路径

## 需要进一步清理的工作

⚠️ 以下工作需要在各服务文件中逐步完成：

### 1. 日志调用替换
将所有 `_logger.info/warn/error/debug` 替换为 BaseService 的方法：
```dart
// 旧代码
_logger.info('用户登录: $username');
_logger.error('操作失败', error: error, stackTrace: stackTrace);

// 新代码
logInfo('用户登录', context: {'username': username});
logError('操作失败', error: error, stackTrace: stackTrace);
```

### 2. 移除 Logger 实例
删除所有 `LoggerFactory.getLogger()` 的使用：
```dart
// 删除这行
static final _logger = LoggerFactory.getLogger('ServiceName');
```

### 3. 异常处理替换
使用 BaseService 提供的异常方法：
```dart
// 旧代码
throw const BusinessException(message: '错误');
throw const NotFoundException(message: '未找到');

// 新代码  
throwBusiness('错误');
throwNotFound('未找到');
```

### 4. 使用 execute 包装
对于主要的业务方法，使用 execute 包装以获得统一的错误处理：
```dart
Future<Result> someMethod() async {
  return execute<Result>(
    () async {
      // 业务逻辑
      return result;
    },
    operationName: 'someMethod',
  );
}
```

## 使用示例

```dart
// 导入服务
import 'package:ttpolyglot_server/src/services/services.dart';

// 创建服务实例
final dbService = DatabaseService();
final redisService = RedisService();
final userService = UserService(
  databaseService: dbService,
  redisService: redisService,
);
final authService = AuthService(
  databaseService: dbService,
  redisService: redisService,
  emailService: emailService,
  userService: userService,
);

// 使用服务
final result = await authService.login(
  username: 'user',
  password: 'pass',
);
```

