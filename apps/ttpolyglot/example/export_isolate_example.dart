import 'package:ttpolyglot/src/core/services/export_service_impl.dart';
import 'package:ttpolyglot/src/core/services/export_service_impl_desktop.dart';
import 'package:ttpolyglot_core/core.dart';

/// Isolate 导出功能使用示例
class ExportIsolateExample {
  static Future<void> runExample() async {
    Logger.info('开始 Isolate 导出示例');

    try {
      // 创建示例项目
      final project = Project(
        id: 'example-project',
        name: '示例项目',
        description: '这是一个示例项目',
        primaryLanguage: Language.enUS,
        targetLanguages: [
          Language.zhCN,
          Language.jaJP,
        ],
        owner: User(
          id: 'user-1',
          email: 'admin@example.com',
          name: '管理员',
          role: UserRole.admin,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 创建示例翻译条目
      final entries = [
        TranslationEntry(
          id: '1',
          key: 'hello',
          projectId: 'example-project',
          sourceLanguage: Language.enUS,
          targetLanguage: Language.zhCN,
          sourceText: 'Hello',
          targetText: '你好',
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        TranslationEntry(
          id: '2',
          key: 'world',
          projectId: 'example-project',
          sourceLanguage: Language.enUS,
          targetLanguage: Language.zhCN,
          sourceText: 'World',
          targetText: '世界',
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        TranslationEntry(
          id: '3',
          key: 'hello',
          projectId: 'example-project',
          sourceLanguage: Language.enUS,
          targetLanguage: Language.jaJP,
          sourceText: 'Hello',
          targetText: 'こんにちは',
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        TranslationEntry(
          id: '4',
          key: 'world',
          projectId: 'example-project',
          sourceLanguage: Language.enUS,
          targetLanguage: Language.jaJP,
          sourceText: 'World',
          targetText: '世界',
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      // 创建导出服务
      final exportService = await ExportServiceImpl.create();

      // 使用 isolate 导出（包含文件选择）
      Logger.info('开始导出翻译文件...');

      final success = await exportService.exportTranslationsJson(
        project: project,
        entries: entries,
      );

      if (success) {
        Logger.info('导出成功！');
      } else {
        Logger.info('导出失败');
      }
    } catch (error, stackTrace) {
      Logger.error('导出示例执行失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 演示 isolate 导出功能
  static Future<void> runIsolateExample() async {
    Logger.info('开始 Isolate 导出示例');

    try {
      // 创建示例项目
      final project = Project(
        id: 'example-project',
        name: '示例项目',
        description: '这是一个示例项目',
        primaryLanguage: Language.enUS,
        targetLanguages: [
          Language.zhCN,
        ],
        owner: User(
          id: 'user-1',
          email: 'admin@example.com',
          name: '管理员',
          role: UserRole.admin,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 创建示例翻译条目
      final entries = [
        TranslationEntry(
          id: '1',
          key: 'welcome',
          projectId: 'example-project',
          sourceLanguage: Language.enUS,
          targetLanguage: Language.zhCN,
          sourceText: 'Welcome to TTPolyglot',
          targetText: '欢迎使用 TTPolyglot',
          status: TranslationStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      // 使用 isolate 导出方法
      final success = await ExportServiceImplDesktop.exportTranslationsShortcutJson(
        project: project,
        entries: entries,
      );

      if (success != null) {
        Logger.info('Isolate 导出成功！');
      } else {
        Logger.info('Isolate 导出失败');
      }
    } catch (error, stackTrace) {
      Logger.error('Isolate 导出示例执行失败', error: error, stackTrace: stackTrace);
    }
  }
}

/// 在 main 函数中调用示例
void main() async {
  // 运行完整导出示例
  await ExportIsolateExample.runExample();

  // 运行 isolate 导出示例
  await ExportIsolateExample.runIsolateExample();
}
