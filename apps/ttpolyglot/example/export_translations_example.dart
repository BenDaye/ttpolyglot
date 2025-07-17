import 'package:ttpolyglot/src/features/features.dart';

/// 翻译导出功能示例
class ExportTranslationsExample {
  /// 演示如何导出翻译文件
  static Future<void> demonstrateExport() async {
    print('=== 翻译导出功能示例 ===');

    try {
      // 1. 获取项目列表
      print('\n1. 获取项目列表...');
      await ProjectsController.loadProjects();
      final projects = ProjectsController.instance.projects;

      if (projects.isEmpty) {
        print('没有找到项目，请先创建一些项目');
        return;
      }

      // 2. 选择第一个项目进行导出
      final project = projects.first;
      print('选择项目: ${project.name}');

      // 3. 导出翻译文件
      print('\n2. 开始导出翻译文件...');
      print('注意: 这将打开文件选择器，请选择保存位置');

      await ProjectExportController.exportTranslationsShortcutJson(project.id);

      print('\n3. 导出完成！');
      print('文件已保存到用户选择的位置');
    } catch (error) {
      print('导出失败: $error');
    }
  }

  /// 演示不同格式的导出
  static Future<void> demonstrateDifferentFormats() async {
    print('\n=== 不同格式导出示例 ===');

    final project = await ProjectsController.getProject('test-project');
    if (project == null) {
      print('测试项目不存在');
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
      print('\n${format['name']} 格式导出:');
      print('- 文件扩展名: .${format['extension']}');
      print('- 默认文件名: ${project.name}_translations.${format['extension']}');

      // 这里可以调用实际的导出方法
      // await ProjectsController.exportTranslations(project.id);
    }
  }

  /// 演示错误处理
  static Future<void> demonstrateErrorHandling() async {
    print('\n=== 错误处理示例 ===');

    try {
      // 尝试导出不存在的项目
      await ProjectExportController.exportTranslationsShortcutJson('non-existent-project');
    } catch (error) {
      print('预期的错误: $error');
    }

    try {
      // 模拟文件写入失败
      print('模拟文件写入失败...');
      // 这里可以添加更多的错误处理测试
    } catch (error) {
      print('文件写入错误: $error');
    }
  }
}

/// 主函数
void main() async {
  print('TTPolyglot 翻译导出功能示例');
  print('=' * 50);

  // 运行示例
  await ExportTranslationsExample.demonstrateExport();
  await ExportTranslationsExample.demonstrateDifferentFormats();
  await ExportTranslationsExample.demonstrateErrorHandling();

  print('\n示例完成！');
}
