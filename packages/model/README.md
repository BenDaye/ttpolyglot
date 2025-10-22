# TTPolyglot Model

TTPolyglot 共享数据模型包，为 TTPolyglot 生态系统提供统一的数据结构定义和类型安全保障。

## 📦 功能特性

### 核心数据模型

- **用户相关模型**
  - `User`: 用户基础模型
  - `UserRole`: 用户角色枚举（管理员、翻译员、审核员等）
  - `UserProfile`: 用户详细资料
  - `UserPermission`: 用户权限模型

- **项目相关模型**
  - `Project`: 翻译项目模型
  - `ProjectSettings`: 项目设置
  - `ProjectMember`: 项目成员模型
  - `ProjectStatistics`: 项目统计信息

- **翻译相关模型**
  - `Translation`: 翻译条目
  - `TranslationKey`: 翻译键
  - `TranslationStatus`: 翻译状态枚举
  - `TranslationHistory`: 翻译历史记录
  - `TranslationComment`: 翻译评论

- **语言相关模型**
  - `Language`: 语言模型
  - `LanguageVariant`: 语言变体
  - `LocaleInfo`: 本地化信息

- **文件相关模型**
  - `TranslationFile`: 翻译文件元数据
  - `FileFormat`: 文件格式枚举
  - `ImportResult`: 导入结果
  - `ExportOptions`: 导出配置

- **通用模型**
  - `ApiResponse`: API 响应封装
  - `PaginatedResult`: 分页结果
  - `ValidationError`: 验证错误
  - `AuditLog`: 审计日志

### 设计特点

- ✅ **类型安全**: 使用 Dart 强类型系统，编译时类型检查
- ✅ **不可变性**: 使用 `@freezed` 注解生成不可变数据类
- ✅ **JSON 序列化**: 自动生成 JSON 序列化/反序列化代码
- ✅ **相等性比较**: 自动实现 `==` 和 `hashCode`
- ✅ **复制修改**: 提供 `copyWith` 方法便于更新
- ✅ **模式匹配**: 支持 Dart 的模式匹配特性
- ✅ **文档完善**: 所有模型都有详细的文档注释

## 📥 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  ttpolyglot_model:
    path: ../model  # 如果是 monorepo
  # 或者
  ttpolyglot_model: ^1.0.0  # 如果发布到 pub.dev
```

## 🚀 使用示例

### 基本使用

```dart
import 'package:ttpolyglot_model/model.dart';

void main() {
  // 创建用户模型
  final user = User(
    id: 'user-123',
    email: 'user@example.com',
    username: 'john_doe',
    displayName: 'John Doe',
    role: UserRole.translator,
    createdAt: DateTime.now(),
  );

  // 创建项目模型
  final project = Project(
    id: 'project-1',
    name: 'My Translation Project',
    description: 'A multilingual application',
    defaultLanguage: 'en-US',
    targetLanguages: ['zh-CN', 'ja-JP', 'ko-KR'],
    ownerId: user.id,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  // 创建翻译条目
  final translation = Translation(
    id: 'trans-1',
    projectId: project.id,
    key: 'common.greeting',
    sourceLanguage: 'en-US',
    targetLanguage: 'zh-CN',
    sourceText: 'Hello, World!',
    translatedText: '你好，世界！',
    status: TranslationStatus.approved,
    createdBy: user.id,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  print('User: ${user.displayName}');
  print('Project: ${project.name}');
  print('Translation: ${translation.sourceText} -> ${translation.translatedText}');
}
```

### JSON 序列化

```dart
import 'package:ttpolyglot_model/model.dart';
import 'dart:convert';

void main() {
  // 创建模型实例
  final user = User(
    id: 'user-123',
    email: 'user@example.com',
    username: 'john_doe',
    displayName: 'John Doe',
    role: UserRole.translator,
    createdAt: DateTime.now(),
  );

  // 序列化为 JSON
  final jsonString = jsonEncode(user.toJson());
  print('JSON: $jsonString');

  // 从 JSON 反序列化
  final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
  final userFromJson = User.fromJson(jsonMap);
  print('Deserialized user: ${userFromJson.displayName}');
}
```

### 使用 copyWith 更新模型

```dart
import 'package:ttpolyglot_model/model.dart';

void main() {
  final project = Project(
    id: 'project-1',
    name: 'Original Name',
    description: 'Original description',
    defaultLanguage: 'en-US',
    targetLanguages: ['zh-CN'],
    ownerId: 'user-1',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  // 使用 copyWith 创建更新后的副本
  final updatedProject = project.copyWith(
    name: 'Updated Name',
    description: 'Updated description',
    targetLanguages: ['zh-CN', 'ja-JP', 'ko-KR'],
    updatedAt: DateTime.now(),
  );

  print('Original: ${project.name}');
  print('Updated: ${updatedProject.name}');
  print('Target languages: ${updatedProject.targetLanguages}');
}
```

### API 响应封装

```dart
import 'package:ttpolyglot_model/model.dart';

void main() {
  // 成功响应
  final successResponse = ApiResponse<User>.success(
    data: User(
      id: 'user-1',
      email: 'user@example.com',
      username: 'john',
      displayName: 'John Doe',
      role: UserRole.admin,
      createdAt: DateTime.now(),
    ),
    message: 'User retrieved successfully',
  );

  if (successResponse.isSuccess) {
    print('User: ${successResponse.data?.displayName}');
  }

  // 错误响应
  final errorResponse = ApiResponse<User>.error(
    code: 'USER_NOT_FOUND',
    message: 'User not found',
    details: {'userId': 'user-999'},
  );

  if (errorResponse.isError) {
    print('Error: ${errorResponse.message}');
    print('Error code: ${errorResponse.errorCode}');
  }
}
```

### 分页结果

```dart
import 'package:ttpolyglot_model/model.dart';

void main() {
  final projects = [
    Project(...),
    Project(...),
    Project(...),
  ];

  final paginatedResult = PaginatedResult<Project>(
    items: projects,
    total: 100,
    page: 1,
    pageSize: 10,
    hasNext: true,
    hasPrevious: false,
  );

  print('Current page: ${paginatedResult.page}/${paginatedResult.totalPages}');
  print('Items: ${paginatedResult.items.length}/${paginatedResult.total}');
  print('Has next page: ${paginatedResult.hasNext}');
}
```

### 翻译状态流转

```dart
import 'package:ttpolyglot_model/model.dart';

void main() {
  var translation = Translation(
    id: 'trans-1',
    projectId: 'project-1',
    key: 'common.title',
    sourceLanguage: 'en-US',
    targetLanguage: 'zh-CN',
    sourceText: 'Welcome',
    status: TranslationStatus.pending,
    createdBy: 'user-1',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  // 翻译完成
  translation = translation.copyWith(
    translatedText: '欢迎',
    status: TranslationStatus.translated,
    updatedAt: DateTime.now(),
  );

  // 审核通过
  translation = translation.copyWith(
    status: TranslationStatus.approved,
    reviewedBy: 'reviewer-1',
    reviewedAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  print('Translation status: ${translation.status}');
  print('Reviewed by: ${translation.reviewedBy}');
}
```

## 📊 数据模型架构

### 模型层次结构

```
Model Package
├── User Models
│   ├── User (用户基础信息)
│   ├── UserProfile (用户详细资料)
│   ├── UserRole (角色枚举)
│   └── UserPermission (权限)
├── Project Models
│   ├── Project (项目)
│   ├── ProjectSettings (项目设置)
│   ├── ProjectMember (项目成员)
│   └── ProjectStatistics (项目统计)
├── Translation Models
│   ├── Translation (翻译条目)
│   ├── TranslationKey (翻译键)
│   ├── TranslationStatus (翻译状态)
│   ├── TranslationHistory (翻译历史)
│   └── TranslationComment (翻译评论)
├── Language Models
│   ├── Language (语言)
│   └── LocaleInfo (本地化信息)
├── File Models
│   ├── TranslationFile (翻译文件)
│   ├── FileFormat (文件格式)
│   ├── ImportResult (导入结果)
│   └── ExportOptions (导出选项)
└── Common Models
    ├── ApiResponse (API 响应)
    ├── PaginatedResult (分页结果)
    ├── ValidationError (验证错误)
    └── AuditLog (审计日志)
```

## 🔧 开发指南

### 添加新模型

1. 在 `lib/src/` 目录下创建模型文件：

```dart
// lib/src/my_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
    String? description,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

2. 在 `lib/model.dart` 中导出：

```dart
export 'src/my_model.dart';
```

3. 运行代码生成：

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 运行代码生成

```bash
# 一次性生成
dart run build_runner build

# 监听模式（开发时推荐）
dart run build_runner watch

# 删除冲突并重新生成
dart run build_runner build --delete-conflicting-outputs
```

### 测试

```bash
# 运行所有测试
dart test

# 运行特定测试
dart test test/models/user_test.dart
```

## 🏗️ 技术栈

- **Dart**: 编程语言
- **Freezed**: 不可变数据类生成
- **json_serializable**: JSON 序列化代码生成
- **build_runner**: 代码生成工具

## 📦 依赖

```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.6
  freezed: ^2.4.5
  json_serializable: ^6.7.1
```

## 🔗 相关链接

- [项目主文档](../../README.md)
- [Freezed 文档](https://pub.dev/packages/freezed)
- [json_serializable 文档](https://pub.dev/packages/json_serializable)

## 📄 许可证

Apache License 2.0 - 详见 [LICENSE](../../LICENSE)

## 🤝 贡献

欢迎贡献！请查看主项目的 [贡献指南](../../README.md#-贡献指南)。
