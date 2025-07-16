# 翻译导出功能使用指南

## 概述

TTPolyglot 现在支持将翻译数据导出为多种格式的文件。用户可以选择保存位置，系统会根据文件扩展名自动选择合适的格式。

## 功能特性

- ✅ 支持多种文件格式：JSON、YAML、CSV、ARB、Properties、PO
- ✅ 用户友好的文件选择器
- ✅ 根据文件扩展名自动确定格式
- ✅ 智能的默认文件名生成
- ✅ 完整的错误处理
- ✅ 使用 `dart:developer` 进行日志记录

## 支持的格式

| 格式       | 扩展名          | 键样式 | 说明                   |
| ---------- | --------------- | ------ | ---------------------- |
| JSON       | `.json`         | 嵌套   | 结构化数据，支持嵌套键 |
| YAML       | `.yaml`, `.yml` | 嵌套   | 人类可读的格式         |
| CSV        | `.csv`          | 平铺   | 表格格式，适合电子表格 |
| ARB        | `.arb`          | 平铺   | Flutter 应用资源包格式 |
| Properties | `.properties`   | 平铺   | Java 属性文件格式      |
| PO         | `.po`           | 平铺   | GNU gettext 格式       |

## 使用方法

### 1. 基本导出

```dart
import 'package:ttpolyglot/src/features/projects/controllers/projects_controller.dart';

// 导出项目翻译
await ProjectsController.exportTranslations('project-id');
```

### 2. 在 UI 中调用

```dart
// 在按钮点击事件中
ElevatedButton(
  onPressed: () async {
    await ProjectsController.exportTranslations(projectId);
  },
  child: Text('导出翻译'),
)
```

### 3. 错误处理

```dart
try {
  await ProjectsController.exportTranslations(projectId);
} catch (error) {
  // 处理错误
  print('导出失败: $error');
}
```

## 工作流程

1. **用户触发导出**：调用 `ProjectsController.exportTranslations(projectId)`
2. **获取项目信息**：系统获取项目详情和默认语言
3. **生成默认文件名**：基于项目名称生成默认文件名
4. **打开文件选择器**：用户选择保存位置和文件名
5. **确定文件格式**：根据文件扩展名自动确定格式
6. **导出翻译内容**：调用翻译服务导出数据
7. **写入文件**：使用 `FileUtils.writeFile` 保存文件
8. **完成反馈**：显示成功或错误消息

## 文件格式选择

系统会根据用户选择的文件扩展名自动确定格式：

```dart
// 根据文件扩展名确定格式
final fileExtension = savePath.split('.').last.toLowerCase();
String format;
TranslationKeyStyle keyStyle;

switch (fileExtension) {
  case 'json':
    format = FileFormats.json;
    keyStyle = TranslationKeyStyle.nested;
    break;
  case 'yaml':
  case 'yml':
    format = FileFormats.yaml;
    keyStyle = TranslationKeyStyle.nested;
    break;
  case 'csv':
    format = FileFormats.csv;
    keyStyle = TranslationKeyStyle.flat;
    break;
  // ... 其他格式
  default:
    format = FileFormats.json;
    keyStyle = TranslationKeyStyle.nested;
}
```

## 默认文件名

系统会根据项目名称自动生成默认文件名：

```dart
final defaultFileName = '${project.name}_translations.json';
// 例如：'我的项目_translations.json'
```

## 错误处理

功能包含完整的错误处理：

- **项目不存在**：显示错误消息
- **用户取消**：静默处理，记录日志
- **文件写入失败**：显示错误消息并记录详细日志
- **格式不支持**：默认使用 JSON 格式

## 日志记录

使用 `dart:developer` 进行详细的日志记录：

```dart
log('翻译文件已保存到: $savePath', name: 'exportTranslations');
log('exportTranslations', error: error, stackTrace: stackTrace);
```

## 测试

运行测试来验证功能：

```bash
cd apps/ttpolyglot
flutter test test/export_translations_test.dart
```

## 示例

查看 `example/export_translations_example.dart` 了解完整的使用示例。

## 注意事项

### 1. 平台特定权限

#### macOS 权限配置

对于 macOS 应用，特别是启用了应用沙盒的应用，需要在 `entitlements` 文件中声明文件访问权限：

**DebugProfile.entitlements 和 Release.entitlements 需要包含：**

```xml
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
<key>com.apple.security.files.downloads.read-write</key>
<true/>
<key>com.apple.security.files.documents.read-write</key>
<true/>
```

这些权限允许应用：

- 访问用户选择的文件和目录
- 写入下载文件夹
- 写入文档文件夹

#### 其他平台

- **Windows**：通常不需要特殊权限配置
- **Linux**：可能需要确保应用有写入权限
- **Web**：使用浏览器的文件下载 API

### 2. 通用注意事项

1. **文件权限**：确保应用有写入文件的权限
2. **平台支持**：功能主要在桌面端使用，移动端和 Web 端可能需要特殊处理
3. **文件大小**：大项目可能生成较大的文件，注意性能
4. **编码格式**：所有文件都使用 UTF-8 编码
5. **沙盒限制**：在 macOS 上，应用沙盒可能会限制文件访问，确保正确配置权限

## 扩展性

要添加新的文件格式支持：

1. 在 `packages/parsers/lib/src/constants/file_formats.dart` 中添加新格式
2. 在 `exportTranslations` 方法的 switch 语句中添加对应的 case
3. 确保相应的解析器已实现

## 相关文件

- `apps/ttpolyglot/lib/src/features/projects/controllers/projects_controller.dart` - 主要实现
- `packages/parsers/lib/src/utils/file_utils.dart` - 文件工具类
- `packages/parsers/lib/src/constants/file_formats.dart` - 文件格式常量
- `test/export_translations_test.dart` - 测试文件
- `example/export_translations_example.dart` - 使用示例
- `macos/Runner/DebugProfile.entitlements` - macOS 调试权限配置
- `macos/Runner/Release.entitlements` - macOS 发布权限配置
