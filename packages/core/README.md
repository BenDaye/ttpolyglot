# TTPolyglot Core

TTPolyglot 核心包，提供翻译管理平台的核心数据模型、业务逻辑和接口定义。

## 功能特性

### 数据模型
- **Language**: 语言模型，支持多种语言格式
- **Project**: 翻译项目模型
- **TranslationEntry**: 翻译条目模型
- **User**: 用户模型
- **WorkspaceConfig**: 工作空间配置模型

### 业务逻辑
- **项目管理**: 创建、更新、删除翻译项目
- **翻译管理**: 管理翻译条目和状态
- **用户管理**: 用户角色和权限控制
- **工作空间管理**: 工作空间配置和偏好设置

### 语言支持

#### 支持的语言列表
Core 包内置了 47 种语言的支持，包括：

- **英语变体**: en-US, en-GB, en-AU, en-CA
- **中文变体**: zh-CN, zh-TW, zh-HK
- **日语**: ja-JP
- **韩语**: ko-KR
- **法语变体**: fr-FR, fr-CA
- **德语变体**: de-DE, de-AT, de-CH
- **西班牙语变体**: es-ES, es-MX, es-AR
- **阿拉伯语变体**: ar-SA, ar-EG (支持 RTL)
- **希伯来语**: he-IL (支持 RTL)
- 以及更多其他语言...

#### 语言代码格式要求
- **必须使用 `language_code-country_code` 格式**（如：`en-US`、`zh-CN`）
- **不允许使用纯语言代码**（如：`en`、`zh`）
- 语言代码必须是小写，国家代码必须是大写

#### 语言功能 API

```dart
// 获取所有支持的语言
List<Language> supportedLanguages = Language.supportedLanguages;

// 验证语言代码格式
bool isValid = Language.isValidLanguageCode('en-US'); // true
bool isInvalid = Language.isValidLanguageCode('en'); // false

// 根据代码获取语言
Language? english = Language.getLanguageByCode('en-US');

// 检查语言是否支持
bool isSupported = Language.isLanguageSupported('zh-CN'); // true

// 搜索语言
List<Language> chineseLanguages = Language.searchSupportedLanguages('Chinese');

// 按语言分组
Map<String, List<Language>> grouped = Language.supportedLanguagesByGroup;
```

### 项目创建验证

创建项目时会自动验证语言支持：

```dart
// 创建项目请求
final request = CreateProjectRequest(
  name: '多语言项目',
  description: '支持多种语言的翻译项目',
  defaultLanguage: Language.getLanguageByCode('en-US')!,
  targetLanguages: [
    Language.getLanguageByCode('zh-CN')!,
    Language.getLanguageByCode('ja-JP')!,
  ],
  ownerId: 'user-123',
);

// 验证请求
if (request.isValid) {
  // 创建项目
} else {
  // 处理验证错误
  List<String> errors = request.validate();
}
```

#### 验证规则
- 项目名称和描述不能为空
- 默认语言必须是支持的语言格式
- 目标语言列表不能为空
- 目标语言必须是支持的语言格式
- 默认语言不能同时作为目标语言
- 目标语言不能重复
- 项目所有者ID不能为空

### 服务接口

- **ProjectService**: 项目管理服务接口
- **TranslationService**: 翻译服务接口
- **StorageService**: 存储服务接口
- **WorkspaceService**: 工作空间服务接口
- **SyncService**: 同步服务接口

### 工具类

- **TranslationUtils**: 翻译工具类，提供键值解析、完成度计算等功能

## 使用示例

### 基本使用

```dart
import 'package:ttpolyglot_core/core.dart';

void main() {
  // 创建语言实例
  final english = Language.getLanguageByCode('en-US')!;
  final chinese = Language.getLanguageByCode('zh-CN')!;

  // 创建用户
  final user = User(
    id: 'user-1',
    email: 'user@example.com',
    name: 'Test User',
    role: UserRole.admin,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  // 创建项目
  final project = Project(
    id: 'project-1',
    name: 'My Project',
    description: 'A multilingual project',
    defaultLanguage: english,
    targetLanguages: [chinese],
    owner: user,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  // 创建翻译条目
  final entry = TranslationEntry(
    id: 'entry-1',
    key: 'hello.world',
    projectId: project.id,
    sourceLanguage: english,
    targetLanguage: chinese,
    sourceText: 'Hello, World!',
    targetText: '你好，世界！',
    status: TranslationStatus.completed,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
```

### 项目创建示例

```dart
import 'package:ttpolyglot_core/core.dart';

void main() {
  // 查看支持的语言
  print('支持的语言数量: ${Language.supportedLanguages.length}');
  
  // 搜索中文语言
  final chineseLanguages = Language.searchSupportedLanguages('Chinese');
  for (final lang in chineseLanguages) {
    print('${lang.code}: ${lang.name}');
  }
  
  // 创建项目请求
  final request = CreateProjectRequest(
    name: '多语言应用',
    description: '支持英语和中文的应用',
    defaultLanguage: Language.getLanguageByCode('en-US')!,
    targetLanguages: [Language.getLanguageByCode('zh-CN')!],
    ownerId: 'user-123',
  );
  
  // 验证请求
  if (request.isValid) {
    print('项目请求有效，可以创建项目');
  } else {
    print('项目请求无效:');
    for (final error in request.validate()) {
      print('- $error');
    }
  }
}
```

## 运行示例

```bash
# 运行基本示例
dart run example/core_example.dart

# 运行项目创建示例
dart run example/project_creation_example.dart
```

## 运行测试

```bash
dart test
```

## 依赖项

- `equatable`: 用于数据模型的相等性比较
- `json_annotation`: 用于 JSON 序列化
- `path`: 用于路径处理
- `uuid`: 用于 UUID 生成
- `intl`: 用于国际化支持

## 开发依赖

- `test`: 单元测试框架
- `lints`: 代码质量检查
- `build_runner`: 代码生成工具
- `json_serializable`: JSON 序列化代码生成
