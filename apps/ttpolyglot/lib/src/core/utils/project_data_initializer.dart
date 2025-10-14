import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:ttpolyglot_core/core.dart';

/// 项目数据初始化器
class ProjectDataInitializer {
  final ProjectServiceImpl _projectService;

  ProjectDataInitializer(this._projectService);

  /// 初始化示例项目数据
  Future<void> initializeSampleProjects() async {
    try {
      // 检查是否已有项目
      final existingProjects = await _projectService.getAllProjects();
      if (existingProjects.isNotEmpty) {
        return; // 已有项目，无需初始化
      }

      // 创建示例项目
      final sampleProjects = [
        CreateProjectRequest(
          name: 'Flutter App',
          description: '一个跨平台的移动应用项目，支持 iOS 和 Android 平台',
          primaryLanguage: Language.zhCN,
          targetLanguages: [Language.enUS, Language.jaJP],
          ownerId: 'default-user',
        ),
        CreateProjectRequest(
          name: 'Web Dashboard',
          description: '管理后台系统，提供数据分析和用户管理功能',
          primaryLanguage: Language.zhCN,
          targetLanguages: [Language.enUS],
          ownerId: 'default-user',
        ),
        CreateProjectRequest(
          name: 'API Documentation',
          description: 'REST API 文档项目，支持多语言文档生成',
          primaryLanguage: Language.zhCN,
          targetLanguages: [Language.enUS, Language.frFR, Language.deDE],
          ownerId: 'default-user',
        ),
        CreateProjectRequest(
          name: 'E-commerce Platform',
          description: '电商平台项目，包含商品管理、订单处理等功能',
          primaryLanguage: Language.zhCN,
          targetLanguages: [Language.enUS, Language.jaJP, Language.frFR],
          ownerId: 'default-user',
        ),
        CreateProjectRequest(
          name: 'Marketing Website',
          description: '营销网站项目，用于产品宣传和用户获取',
          primaryLanguage: Language.zhCN,
          targetLanguages: [Language.enUS, Language.deDE],
          ownerId: 'default-user',
        ),
      ];

      // 创建示例项目
      for (final request in sampleProjects) {
        await _projectService.createProject(request);
        // 添加小延迟以确保项目创建时间不同
        await Future.delayed(const Duration(milliseconds: 100));
      }

      Logger.info('示例项目初始化完成');
    } catch (error, stackTrace) {
      Logger.error('初始化示例项目失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 创建预设的语言列表
  static List<Language> getPresetLanguages() {
    return Language.supportedLanguages;
  }

  /// 根据语言代码获取语言对象
  static Language? getLanguageByCode(String code) {
    try {
      return getPresetLanguages().firstWhere((lang) => lang.code == code);
    } catch (error, stackTrace) {
      Logger.error('getLanguageByCode', error: error, stackTrace: stackTrace);
      return null;
    }
  }
}
