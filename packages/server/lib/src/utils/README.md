# Utils 工具类目录结构说明

## 目录结构

```
utils/
├── utils.dart                    # 统一导出文件
├── README.md                     # 本说明文档
│
├── security/                     # 安全相关工具
│   ├── security_utils.dart      # 安全工具导出
│   ├── crypto_utils.dart        # 加密/解密工具
│   └── jwt_utils.dart           # JWT 令牌工具
│
├── validation/                   # 验证相关工具
│   ├── validation_utils_export.dart    # 验证工具导出
│   └── validator_utils.dart           # 数据验证器
│
├── http/                         # HTTP 相关工具
│   ├── http_utils_export.dart   # HTTP 工具导出
│   ├── http_utils.dart          # HTTP 请求工具
│   └── response_utils.dart    # 响应构建器
│
├── logging/                      # 日志相关工具
│   ├── logging_utils_export.dart       # 日志工具导出
│   └── logger_utils.dart   # 结构化日志工具
│
├── data/                         # 数据处理相关工具
│   ├── data_utils.dart          # 数据工具导出
│   ├── string_utils.dart        # 字符串处理工具
│   └── date_utils.dart          # 日期处理工具
│
└── infrastructure/               # 基础设施相关工具
    ├── infrastructure_utils.dart # 基础设施工具导出
    ├── database_utils.dart      # 数据库工具
    ├── cache_utils.dart         # 缓存工具
    └── retry_utils.dart         # 重试逻辑工具
```

## 工具分类说明

### 1. Security（安全）
包含加密、解密、JWT 令牌等安全相关功能。

**文件：**
- `crypto_utils.dart` - 提供密码加密、哈希、密码强度检查等功能
- `jwt_utils.dart` - JWT 令牌的生成、验证和解析

**使用场景：**
- 用户密码加密
- API 令牌生成和验证
- 数据加密传输

### 2. Validation（验证）
提供各类数据验证功能。

**文件：**
- `validator_utils.dart` - 邮箱、电话、URL、数字等格式验证

**使用场景：**
- 用户输入验证
- API 参数验证
- 数据格式校验

### 3. HTTP（HTTP 相关）
处理 HTTP 请求和响应相关功能。

**文件：**
- `http_utils.dart` - HTTP 请求辅助工具
- `response_utils.dart` - 统一响应格式构建

**使用场景：**
- API 响应格式化
- HTTP 请求处理
- 错误响应构建

### 4. Logging（日志）
提供结构化日志记录功能。

**文件：**
- `logger_utils.dart` - 结构化日志记录器，支持不同日志级别

**使用场景：**
- 应用日志记录
- 错误追踪
- 调试信息输出

### 5. Data（数据处理）
字符串、日期等数据处理工具。

**文件：**
- `string_utils.dart` - 字符串操作（驼峰转换、随机字符串等）
- `date_utils.dart` - 日期格式化、解析等

**使用场景：**
- 数据格式转换
- 字符串处理
- 日期时间操作

### 6. Infrastructure（基础设施）
数据库、缓存、重试等基础设施相关工具。

**文件：**
- `database_utils.dart` - 数据库查询辅助工具
- `cache_utils.dart` - 缓存键生成等工具
- `retry_utils.dart` - 重试逻辑处理

**使用场景：**
- 数据库操作
- 缓存管理
- 网络请求重试

## 使用方式

### 方式一：使用统一导出（推荐）
```dart
// 导入所有工具
import 'package:ttpolyglot_server/src/utils/utils.dart';

// 直接使用
final hash = CryptoUtils().hashPassword('password');
```

### 方式二：按类别导入
```dart
// 只导入安全相关工具
import 'package:ttpolyglot_server/src/utils/security/security_utils.dart';

// 或导入单个文件
import 'package:ttpolyglot_server/src/utils/security/crypto_utils.dart';
```

### 方式三：相对路径导入
```dart
// 从项目内部文件导入
import '../../utils/security/crypto_utils.dart';
import '../../utils/validation/validator_utils.dart';
```

## 添加新工具的规范

1. **确定分类**：根据功能确定工具所属类别
2. **创建文件**：在对应目录下创建工具文件
3. **更新导出**：在该目录的导出文件中添加 export 语句
4. **编写文档**：在工具类中添加详细的注释和使用示例
5. **遵循命名**：工具类以 `Utils` 结尾，如 `CryptoUtils`

## 命名规范

- **工具类名称**：`XxxUtils` (如 `StringUtils`, `DateUtils`)
- **导出文件名称**：`xxx_utils.dart` (如 `security_utils.dart`)
- **方法命名**：小驼峰命名法 (如 `hashPassword`, `validateEmail`)

## 注意事项

1. 工具类应该是无状态的，尽量使用静态方法或单例模式
2. 工具方法应该职责单一，易于理解和测试
3. 避免工具类之间的循环依赖
4. 复杂的业务逻辑应该放在 Service 层，而不是 Utils
5. 所有工具方法都应该有完善的文档注释和使用示例

