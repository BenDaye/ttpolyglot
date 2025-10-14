import 'package:ttpolyglot/src/features/features.dart';
import 'package:ttpolyglot_core/core.dart';

/// 翻译导出功能示例
class ExportTranslationsExample {
  /// 演示如何导出翻译文件
  static Future<void> demonstrateExport() async {
    Logger.info('=== 翻译导出功能示例 ===');

    try {
      // 1. 获取项目列表
      Logger.info('\n1. 获取项目列表...');
      await ProjectsController.loadProjects();
      final projects = ProjectsController.instance.projects;

      if (projects.isEmpty) {
        Logger.warning('没有找到项目，请先创建一些项目');
        return;
      }

      // 2. 选择第一个项目进行导出
      final project = projects.first;
      Logger.info('选择项目: ${project.name}');

      // 3. 导出翻译文件
      Logger.info('\n2. 开始导出翻译文件...');
      Logger.info('注意: 这将打开文件选择器，请选择保存位置');

      await ProjectExportController.exportTranslationsShortcutJson(project.id);

      Logger.info('\n3. 导出完成！');
      Logger.info('文件已保存到用户选择的位置');
    } catch (error, stackTrace) {
      Logger.error('导出失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 演示不同格式的导出
  static Future<void> demonstrateDifferentFormats() async {
    Logger.info('\n=== 不同格式导出示例 ===');

    final project = await ProjectsController.getProject('test-project');
    if (project == null) {
      Logger.warning('测试项目不存在');
      return;
    }

    // 模拟不同格式的导出
    final formats = [
      {'name': 'JSON', 'extension': 'json'},
      {'name': 'YAML', 'extension': 'yaml'},
      {'name': 'CSV', 'extension': 'csv'},
      {'name': 'ARB', 'extension': 'arb'},
      {'name': 'Properties', 'extension': 'properties'},
      {'name': 'PO', 'extension': 'po'},
    ];

    for (final format in formats) {
      Logger.info('\n${format['name']} 格式导出:');
      Logger.info('- 文件扩展名: .${format['extension']}');
      Logger.info('- 默认文件名: ${project.name}_translations.${format['extension']}');

      // 这里可以调用实际的导出方法
      // await ProjectsController.exportTranslations(project.id);
    }
  }

  /// 演示错误处理
  static Future<void> demonstrateErrorHandling() async {
    Logger.info('\n=== 错误处理示例 ===');

    try {
      // 尝试导出不存在的项目
      await ProjectExportController.exportTranslationsShortcutJson('non-existent-project');
    } catch (error, stackTrace) {
      Logger.error('预期的错误', error: error, stackTrace: stackTrace);
    }

    try {
      // 模拟文件写入失败
      Logger.info('模拟文件写入失败...');
      // 这里可以添加更多的错误处理测试
    } catch (error, stackTrace) {
      Logger.error('文件写入错误', error: error, stackTrace: stackTrace);
    }
  }
}

/// 主函数
void main() async {
  Logger.info('TTPolyglot 翻译导出功能示例');
  Logger.info('=' * 50);

  // 运行示例
  await ExportTranslationsExample.demonstrateExport();
  await ExportTranslationsExample.demonstrateDifferentFormats();
  await ExportTranslationsExample.demonstrateErrorHandling();

  Logger.info('\n示例完成！');
}
