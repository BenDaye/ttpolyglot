# 翻译键创建功能

本文档详细介绍了 TTPolyglot Core 包中新增的翻译键创建和管理功能。

## 功能概述

我们在 Core 包中新增了以下功能：

1. **批量创建翻译条目**：支持一次性为多个语言创建翻译条目
2. **翻译键管理**：提供完整的翻译键创建、验证和管理功能
3. **自动语言版本生成**：根据项目配置自动为所有目标语言生成翻译条目
4. **高级功能支持**：包括复数形式、占位符、长度限制等

## 核心组件

### 1. CreateTranslationKeyRequest

用于创建翻译键的请求模型，包含以下属性：

- `projectId`: 项目 ID
- `key`: 翻译键名
- `sourceLanguage`: 源语言
- `sourceText`: 源文本
- `targetLanguages`: 目标语言列表
- `context`: 上下文信息（可选）
- `comment`: 备注（可选）
- `maxLength`: 最大长度限制（可选）
- `isPlural`: 是否为复数形式（默认 false）
- `pluralForms`: 复数形式的翻译（可选）
- `initialStatus`: 初始状态（默认 pending）
- `generateForDefaultLanguage`: 是否为默认语言也生成条目（默认 true）

### 2. TranslationService 扩展

在 `TranslationService` 接口中新增了以下方法：

- `batchCreateTranslationEntries`: 批量创建翻译条目
- `createTranslationKey`: 为指定的 key 创建多个语言版本的翻译条目

### 3. TranslationUtils 扩展

在 `TranslationUtils` 工具类中新增了以下方法：

- `generateTranslationEntries`: 根据请求生成翻译条目列表
- `isValidTranslationKey`: 验证翻译键格式
- `batchValidateTranslationEntries`: 批量验证翻译条目
- `createTranslationKeyRequestFromProject`: 从项目信息创建翻译键请求

## 使用示例

### 基本使用

```dart
import 'package:ttpolyglot_core/core.dart';

void main() async {
  // 1. 创建翻译键请求
  final request = CreateTranslationKeyRequest(
    projectId: 'project-1',
    key: 'common.greeting',
    sourceLanguage: Language.getLanguageByCode('en-US')!,
    sourceText: 'Hello, welcome to our application!',
    targetLanguages: [
      Language.getLanguageByCode('zh-CN')!,
      Language.getLanguageByCode('ja-JP')!,
    ],
    context: '应用程序的欢迎消息',
    generateForDefaultLanguage: true,
  );

  // 2. 验证请求
  if (request.isValid) {
    // 3. 生成翻译条目
    final entries = TranslationUtils.generateTranslationEntries(request);

    // 4. 使用服务创建翻译条目
    final translationService = MyTranslationService();
    await translationService.createTranslationKey(request);

    print('成功创建了 ${entries.length} 个翻译条目');
  } else {
    print('请求验证失败: ${request.validate()}');
  }
}
```

### 高级功能

#### 复数形式的翻译

```dart
final pluralRequest = CreateTranslationKeyRequest(
  projectId: 'project-1',
  key: 'item.count',
  sourceLanguage: english,
  sourceText: '{count} items',
  targetLanguages: [chinese, japanese],
  isPlural: true,
  pluralForms: {
    'one': '{count} item',
    'other': '{count} items',
  },
);
```

#### 带占位符的翻译

```dart
final placeholderRequest = CreateTranslationKeyRequest(
  projectId: 'project-1',
  key: 'user.welcome',
  sourceLanguage: english,
  sourceText: 'Welcome back, {username}!',
  targetLanguages: [chinese, japanese],
  context: '用户登录后的欢迎消息',
);

// 提取占位符
final placeholders = TranslationUtils.extractPlaceholders(
  placeholderRequest.sourceText
);
print('占位符: ${placeholders.join(', ')}'); // 输出: {username}
```

#### 长度限制

```dart
final limitedRequest = CreateTranslationKeyRequest(
  projectId: 'project-1',
  key: 'button.submit',
  sourceLanguage: english,
  sourceText: 'Submit',
  targetLanguages: [chinese, japanese],
  maxLength: 10,
  context: '提交按钮文本',
);
```

### 批量验证

```dart
// 批量验证翻译条目
final validationResults = TranslationUtils.batchValidateTranslationEntries(entries);

if (validationResults.isNotEmpty) {
  print('发现验证错误:');
  for (final entryId in validationResults.keys) {
    final errors = validationResults[entryId]!;
    print('条目 $entryId: ${errors.join(', ')}');
  }
}
```

### 从项目信息创建请求

```dart
// 从项目信息快速创建翻译键请求
final request = TranslationUtils.createTranslationKeyRequestFromProject(
  projectId: project.id,
  key: 'error.network',
  defaultLanguage: project.defaultLanguage,
  targetLanguages: project.targetLanguages,
  sourceText: 'Network connection failed. Please try again.',
  context: '网络连接失败时显示的错误消息',
  maxLength: 80,
);
```

## 验证机制

### 翻译键格式验证

翻译键必须符合以下规则：

- 以字母开头
- 只能包含字母、数字、点号、下划线和连字符
- 不能为空

```dart
// 有效的翻译键
TranslationUtils.isValidTranslationKey('common.greeting'); // true
TranslationUtils.isValidTranslationKey('user.profile.name'); // true
TranslationUtils.isValidTranslationKey('button_submit'); // true
TranslationUtils.isValidTranslationKey('error-message'); // true

// 无效的翻译键
TranslationUtils.isValidTranslationKey('123invalid'); // false
TranslationUtils.isValidTranslationKey('special@key'); // false
TranslationUtils.isValidTranslationKey(''); // false
```

### 请求验证

`CreateTranslationKeyRequest` 提供了完整的验证机制：

```dart
final request = CreateTranslationKeyRequest(
  projectId: 'project-1',
  key: 'common.greeting',
  sourceLanguage: english,
  sourceText: 'Hello, World!',
  targetLanguages: [chinese, japanese],
);

// 验证请求
if (request.isValid) {
  // 请求有效
} else {
  // 获取验证错误
  final errors = request.validate();
  for (final error in errors) {
    print('错误: $error');
  }
}
```

验证规则包括：

- 项目 ID 不能为空
- 翻译键名不能为空
- 源文本不能为空
- 源语言必须是有效的语言代码
- 目标语言列表不能为空
- 目标语言不能重复
- 源语言不能同时作为目标语言（除非 `generateForDefaultLanguage` 为 true）

## 自动生成功能

### 为所有目标语言生成翻译条目

当创建翻译键时，系统会自动为所有指定的目标语言生成翻译条目：

```dart
final request = CreateTranslationKeyRequest(
  projectId: 'project-1',
  key: 'common.greeting',
  sourceLanguage: english,
  sourceText: 'Hello, World!',
  targetLanguages: [chinese, japanese, korean], // 3 个目标语言
  generateForDefaultLanguage: true,
);

final entries = TranslationUtils.generateTranslationEntries(request);
// 生成 4 个翻译条目：3 个目标语言 + 1 个默认语言
```

### 默认语言条目

如果 `generateForDefaultLanguage` 为 true，系统会为默认语言生成一个已完成状态的翻译条目：

```dart
// 默认语言条目
TranslationEntry(
  id: 'project-1_common.greeting_en-US',
  key: 'common.greeting',
  sourceLanguage: english,
  targetLanguage: english,
  sourceText: 'Hello, World!',
  targetText: 'Hello, World!', // 目标文本等于源文本
  status: TranslationStatus.completed, // 状态为已完成
  // ...
)
```

## 统计和分析

`TranslationUtils` 提供了强大的统计功能：

```dart
final entries = TranslationUtils.generateTranslationEntries(request);
final stats = TranslationUtils.generateStatistics(entries);

print('总条目数: ${stats['total']}');
print('已完成: ${stats['completed']}');
print('待翻译: ${stats['pending']}');
print('完成率: ${(stats['completionRate'] * 100).toStringAsFixed(1)}%');
print('涉及语言数: ${stats['languageCount']}');

// 状态分布
final statusBreakdown = stats['statusBreakdown'] as Map<String, int>;
for (final status in statusBreakdown.keys) {
  print('$status: ${statusBreakdown[status]}');
}

// 语言分布
final languageBreakdown = stats['languageBreakdown'] as Map<String, int>;
for (final language in languageBreakdown.keys) {
  print('$language: ${languageBreakdown[language]}');
}
```

## 最佳实践

### 1. 使用有意义的键名

```dart
// 好的键名
'common.greeting'
'user.profile.name'
'error.network.connection'
'button.submit.form'

// 避免的键名
'text1'
'message'
'btn'
```

### 2. 提供上下文信息

```dart
final request = CreateTranslationKeyRequest(
  key: 'button.submit',
  sourceText: 'Submit',
  context: '表单提交按钮，用于保存用户输入的数据',
  comment: '这个按钮在用户填写完表单后点击',
  // ...
);
```

### 3. 设置合理的长度限制

```dart
final request = CreateTranslationKeyRequest(
  key: 'button.text',
  sourceText: 'Click here',
  maxLength: 20, // 按钮文本通常需要限制长度
  // ...
);
```

### 4. 批量验证

```dart
// 在创建翻译条目之前进行批量验证
final entries = TranslationUtils.generateTranslationEntries(request);
final validationResults = TranslationUtils.batchValidateTranslationEntries(entries);

if (validationResults.isEmpty) {
  // 所有条目都有效，可以创建
  await translationService.batchCreateTranslationEntries(entries);
} else {
  // 处理验证错误
  handleValidationErrors(validationResults);
}
```

## 错误处理

### 常见错误及解决方案

1. **翻译键格式错误**

   ```
   错误: 翻译键名格式不正确: 123invalid
   解决: 翻译键必须以字母开头
   ```

2. **源文本为空**

   ```
   错误: 源文本不能为空
   解决: 提供有效的源文本
   ```

3. **目标语言重复**

   ```
   错误: 目标语言不能重复
   解决: 检查目标语言列表，移除重复项
   ```

4. **不支持的语言代码**
   ```
   错误: 不支持的目标语言: xx-XX
   解决: 使用 Language.isLanguageSupported() 检查语言是否支持
   ```

## 性能考虑

1. **批量操作**：使用 `batchCreateTranslationEntries` 而不是多次调用 `createTranslationEntry`
2. **验证优化**：在生成大量翻译条目前先验证请求
3. **内存管理**：对于大型项目，考虑分批处理翻译条目

## 扩展性

这个设计支持未来的扩展：

1. **自定义验证规则**：可以扩展验证机制
2. **更多翻译状态**：可以添加新的翻译状态
3. **高级功能**：可以添加更多高级功能，如翻译记忆、术语管理等
4. **插件系统**：可以通过插件扩展功能

## 测试

我们提供了全面的测试覆盖：

```bash
# 运行所有测试
dart test

# 运行示例
dart run example/translation_key_example.dart
```

测试包括：

- 翻译键请求验证
- 翻译条目生成
- 批量验证
- 错误处理
- 边界情况

这些功能大大简化了翻译键的创建和管理流程，提高了开发效率，并确保了翻译数据的质量和一致性。
