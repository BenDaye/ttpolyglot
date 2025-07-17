# 导出功能 Isolate 优化

## 概述

我们使用 Dart 的 `compute` 函数将导出功能移到后台 isolate 中执行，避免阻塞 UI 线程。

## 优化前的问题

原来的导出流程：

1. 在主线程中选择保存位置（`FilePicker.platform.saveFile`）
2. 在主线程中处理所有语言的翻译数据
3. 在主线程中生成 JSON 内容
4. 在主线程中创建 ZIP 压缩包
5. 在主线程中写入文件

当翻译数据量大时，步骤 2-4 会阻塞 UI，导致界面卡顿。

## 优化后的方案

### 分离式导出（推荐方案）

文件选择在主线程，导出处理在 isolate：

```dart
// 在主线程中选择保存位置
final savePath = await FilePicker.platform.saveFile(...);

// 在 isolate 中执行导出任务
final result = await compute(_executeExportTask, taskParams);

// 在主线程中写入文件
await zipFile.writeAsBytes(result.archiveData!);
```

**优点：**

- 文件选择对话框正常显示
- 导出处理不阻塞 UI
- 用户体验更好
- 避免了 FilePicker 在 isolate 中的兼容性问题

**为什么不在 isolate 中使用 FilePicker？**

- `FilePicker` 依赖于 Flutter 的平台通道
- isolate 中无法访问平台特定的功能
- 会导致 `LateInitializationError` 错误

## 实现细节

### 1. 导出任务参数

```dart
class ExportTaskParams {
  const ExportTaskParams({
    required this.project,
    required this.entries,
  });

  final Project project;
  final List<TranslationEntry> entries;
}
```

### 2. 导出任务结果

```dart
class ExportTaskResult {
  const ExportTaskResult({
    required this.success,
    this.archiveData,
    this.error,
  });

  final bool success;
  final List<int>? archiveData;
  final String? error;
}
```

### 3. Isolate 执行函数

```dart
static Future<ExportTaskResult> _executeExportTask(ExportTaskParams params) async {
  try {
    final allLanguages = [params.project.defaultLanguage, ...params.project.targetLanguages];
    final Archive archive = Archive();

    // 处理每个语言的翻译
    for (final language in allLanguages) {
      // 过滤、排序、生成 JSON
      final jsonString = await jsonParser.writeString(...);

      // 添加到压缩包
      archive.addFile(file);
    }

    // 编码为 ZIP 数据
    final zipData = ZipEncoder().encode(archive);

    return ExportTaskResult(success: true, archiveData: zipData);
  } catch (error, stackTrace) {
    return ExportTaskResult(success: false, error: error.toString());
  }
}
```

## 使用方法

### 基本使用

```dart
final success = await exportService.exportTranslationsShortcutJson(
  project: project,
  entries: entries,
);
```

## 性能提升

- **UI 响应性**：导出过程中 UI 完全不受影响
- **多核利用**：导出任务在独立的 isolate 中运行，可以利用多核 CPU
- **内存隔离**：导出过程中的大量数据处理不会影响主线程内存

## 注意事项

1. **错误处理**：isolate 中的错误会通过 `ExportTaskResult` 返回
2. **日志记录**：使用 `log` 函数记录导出进度和错误信息
3. **内存管理**：大量数据在 isolate 中处理，避免主线程内存压力
4. **平台兼容性**：文件选择必须在主线程中进行，确保平台通道正常工作

## 测试

运行示例代码测试 isolate 导出功能：

```bash
dart run apps/ttpolyglot/example/export_isolate_example.dart
```

## 未来优化

1. **进度回调**：如果需要实时进度更新，可以使用 `Isolate.spawn` + port 通信
2. **取消支持**：添加取消导出操作的功能
3. **批量处理**：对于超大数据集，可以考虑分批处理
4. **内存优化**：对于超大文件，可以考虑流式处理
