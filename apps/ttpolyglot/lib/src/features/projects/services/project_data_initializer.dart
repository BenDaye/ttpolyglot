import 'dart:developer';

import 'package:ttpolyglot_core/core.dart';

import 'project_service_impl.dart';

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

      // 创建示例语言
      final zhCN = Language(code: 'zh-CN', name: '中文', nativeName: '中文');
      final enUS = Language(code: 'en-US', name: 'English', nativeName: 'English');
      final jaJP = Language(code: 'ja-JP', name: 'Japanese', nativeName: '日本語');
      final frFR = Language(code: 'fr-FR', name: 'French', nativeName: 'Français');
      final deDE = Language(code: 'de-DE', name: 'German', nativeName: 'Deutsch');

      // 创建示例项目
      final sampleProjects = [
        CreateProjectRequest(
          name: 'Flutter App',
          description: '一个跨平台的移动应用项目，支持 iOS 和 Android 平台',
          defaultLanguage: zhCN,
          targetLanguages: [enUS, jaJP],
          ownerId: 'default-user',
        ),
        CreateProjectRequest(
          name: 'Web Dashboard',
          description: '管理后台系统，提供数据分析和用户管理功能',
          defaultLanguage: zhCN,
          targetLanguages: [enUS],
          ownerId: 'default-user',
        ),
        CreateProjectRequest(
          name: 'API Documentation',
          description: 'REST API 文档项目，支持多语言文档生成',
          defaultLanguage: zhCN,
          targetLanguages: [enUS, frFR, deDE],
          ownerId: 'default-user',
        ),
        CreateProjectRequest(
          name: 'E-commerce Platform',
          description: '电商平台项目，包含商品管理、订单处理等功能',
          defaultLanguage: zhCN,
          targetLanguages: [enUS, jaJP, frFR],
          ownerId: 'default-user',
        ),
        CreateProjectRequest(
          name: 'Marketing Website',
          description: '营销网站项目，用于产品宣传和用户获取',
          defaultLanguage: zhCN,
          targetLanguages: [enUS, deDE],
          ownerId: 'default-user',
        ),
      ];

      // 创建示例项目
      for (final request in sampleProjects) {
        await _projectService.createProject(request);
        // 添加小延迟以确保项目创建时间不同
        await Future.delayed(const Duration(milliseconds: 100));
      }

      log('示例项目初始化完成');
    } catch (error, stackTrace) {
      log('初始化示例项目失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 创建预设的语言列表
  static List<Language> getPresetLanguages() {
    return [
      Language(code: 'zh-CN', name: '中文（简体）', nativeName: '简体中文'),
      Language(code: 'zh-TW', name: '中文（繁体）', nativeName: '繁体中文'),
      Language(code: 'en-US', name: 'English (US)', nativeName: 'English'),
      Language(code: 'en-GB', name: 'English (UK)', nativeName: 'English'),
      Language(code: 'ja-JP', name: 'Japanese', nativeName: '日本語'),
      Language(code: 'ko-KR', name: 'Korean', nativeName: '한국어'),
      Language(code: 'fr-FR', name: 'French', nativeName: 'Français'),
      Language(code: 'de-DE', name: 'German', nativeName: 'Deutsch'),
      Language(code: 'es-ES', name: 'Spanish', nativeName: 'Español'),
      Language(code: 'it-IT', name: 'Italian', nativeName: 'Italiano'),
      Language(code: 'pt-BR', name: 'Portuguese (Brazil)', nativeName: 'Português'),
      Language(code: 'ru-RU', name: 'Russian', nativeName: 'Русский'),
      Language(code: 'ar-SA', name: 'Arabic', nativeName: 'العربية'),
      Language(code: 'hi-IN', name: 'Hindi', nativeName: 'हिन्दी'),
      Language(code: 'th-TH', name: 'Thai', nativeName: 'ไทย'),
      Language(code: 'vi-VN', name: 'Vietnamese', nativeName: 'Tiếng Việt'),
      Language(code: 'tr-TR', name: 'Turkish', nativeName: 'Türkçe'),
      Language(code: 'pl-PL', name: 'Polish', nativeName: 'Polski'),
      Language(code: 'nl-NL', name: 'Dutch', nativeName: 'Nederlands'),
      Language(code: 'sv-SE', name: 'Swedish', nativeName: 'Svenska'),
    ];
  }

  /// 根据语言代码获取语言对象
  static Language? getLanguageByCode(String code) {
    try {
      return getPresetLanguages().firstWhere((lang) => lang.code == code);
    } catch (e) {
      return null;
    }
  }

  /// 获取常用语言（用于快速选择）
  static List<Language> getCommonLanguages() {
    return [
      Language(code: 'zh-CN', name: '中文（简体）', nativeName: '简体中文'),
      Language(code: 'en-US', name: 'English', nativeName: 'English'),
      Language(code: 'ja-JP', name: 'Japanese', nativeName: '日本語'),
      Language(code: 'ko-KR', name: 'Korean', nativeName: '한국어'),
      Language(code: 'fr-FR', name: 'French', nativeName: 'Français'),
      Language(code: 'de-DE', name: 'German', nativeName: 'Deutsch'),
      Language(code: 'es-ES', name: 'Spanish', nativeName: 'Español'),
      Language(code: 'ru-RU', name: 'Russian', nativeName: 'Русский'),
    ];
  }
}
