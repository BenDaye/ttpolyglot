import 'dart:developer';

import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 项目模型转换器
/// 负责在 API 模型（ProjectModel）和 Core 模型（Project）之间进行转换
class ProjectConverter {
  ProjectConverter._();

  /// 将 ProjectModel (API) 转换为 Project (Core)
  static Project toProject(ProjectModel model) {
    try {
      // 构建主语言
      final primaryLanguage = Language(
        code: model.primaryLanguageCode ?? 'en-US',
        name: model.primaryLanguageName ?? 'English',
        nativeName: model.primaryLanguageNativeName ?? 'English',
      );

      // 构建项目所有者
      final owner = User(
        id: model.ownerId,
        email: '${model.ownerUsername ?? 'user'}@example.com',
        name: model.ownerDisplayName ?? model.ownerUsername ?? 'User',
        role: UserRole.admin,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      );

      return Project(
        id: model.id.toString(), // API 使用 int，Core 使用 String
        name: model.name,
        description: model.description ?? '',
        primaryLanguage: primaryLanguage,
        targetLanguages: [], // 目标语言需要单独查询或从详情接口获取
        owner: owner,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        isActive: model.isActive,
        lastAccessedAt: model.lastActivityAt,
      );
    } catch (error, stackTrace) {
      log('[toProject]', error: error, stackTrace: stackTrace, name: 'ProjectConverter');
      rethrow;
    }
  }

  /// 将 Project (Core) 转换为 ProjectModel (API)
  static ProjectModel toProjectModel(Project project) {
    try {
      return ProjectModel(
        id: int.parse(project.id), // Core 使用 String，API 使用 int
        name: project.name,
        slug: _generateSlug(project.name),
        description: project.description,
        ownerId: project.owner.id,
        status: project.isActive ? 'active' : 'inactive',
        visibility: 'private',
        primaryLanguageCode: project.primaryLanguage.code,
        createdAt: project.createdAt,
        updatedAt: project.updatedAt,
        isActive: project.isActive,
        lastActivityAt: project.lastAccessedAt,
        ownerUsername: project.owner.email.split('@').first,
        ownerDisplayName: project.owner.name,
        primaryLanguageName: project.primaryLanguage.name,
        primaryLanguageNativeName: project.primaryLanguage.nativeName,
      );
    } catch (error, stackTrace) {
      log('[toProjectModel]', error: error, stackTrace: stackTrace, name: 'ProjectConverter');
      rethrow;
    }
  }

  /// 将多个 ProjectModel 转换为 Project 列表
  static List<Project> toProjectList(List<ProjectModel> models) {
    return models.map((model) => toProject(model)).toList();
  }

  /// 将 Language (Core) 转换为语言代码（API 使用）
  static String toLanguageCode(Language language) {
    return language.code;
  }

  /// 将语言代码列表转换为语言代码字符串列表
  static List<String> toLanguageCodes(List<Language> languages) {
    return languages.map((lang) => lang.code).toList();
  }

  /// 根据语言代码构建 Language 对象
  static Language fromLanguageCode(
    String code, {
    String? name,
    String? nativeName,
  }) {
    // 如果没有提供名称，使用预设语言列表查找
    final presetLanguage = _getPresetLanguageByCode(code);

    return Language(
      code: code,
      name: name ?? presetLanguage?.name ?? code,
      nativeName: nativeName ?? presetLanguage?.nativeName ?? code,
    );
  }

  /// 生成项目 slug（用于 URL）
  static String _generateSlug(String name) {
    return name.toLowerCase().replaceAll(RegExp(r'[\s\W]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
  }

  /// 获取预设语言（根据代码）
  static Language? _getPresetLanguageByCode(String code) {
    final presetLanguages = _getPresetLanguages();
    try {
      return presetLanguages.firstWhere((lang) => lang.code == code);
    } catch (_) {
      return null;
    }
  }

  /// 获取预设语言列表
  static List<Language> _getPresetLanguages() {
    return [
      const Language(
        code: 'zh-CN',
        name: '中文（简体）',
        nativeName: '中文（简体）',
        sortIndex: 0,
      ),
      const Language(
        code: 'zh-TW',
        name: '中文（繁體）',
        nativeName: '中文（繁體）',
        sortIndex: 1,
      ),
      const Language(
        code: 'en-US',
        name: 'English (United States)',
        nativeName: 'English (United States)',
        sortIndex: 2,
      ),
      const Language(
        code: 'ja-JP',
        name: '日本語',
        nativeName: '日本語',
        sortIndex: 3,
      ),
      const Language(
        code: 'ko-KR',
        name: '한국어',
        nativeName: '한국어',
        sortIndex: 4,
      ),
      const Language(
        code: 'fr-FR',
        name: 'Français',
        nativeName: 'Français',
        sortIndex: 5,
      ),
      const Language(
        code: 'de-DE',
        name: 'Deutsch',
        nativeName: 'Deutsch',
        sortIndex: 6,
      ),
      const Language(
        code: 'es-ES',
        name: 'Español',
        nativeName: 'Español',
        sortIndex: 7,
      ),
      const Language(
        code: 'pt-BR',
        name: 'Português (Brasil)',
        nativeName: 'Português (Brasil)',
        sortIndex: 8,
      ),
      const Language(
        code: 'ru-RU',
        name: 'Русский',
        nativeName: 'Русский',
        sortIndex: 9,
      ),
      const Language(
        code: 'it-IT',
        name: 'Italiano',
        nativeName: 'Italiano',
        sortIndex: 10,
      ),
      const Language(
        code: 'ar-SA',
        name: 'العربية',
        nativeName: 'العربية',
        sortIndex: 11,
      ),
      const Language(
        code: 'th-TH',
        name: 'ไทย',
        nativeName: 'ไทย',
        sortIndex: 12,
      ),
      const Language(
        code: 'vi-VN',
        name: 'Tiếng Việt',
        nativeName: 'Tiếng Việt',
        sortIndex: 13,
      ),
      const Language(
        code: 'id-ID',
        name: 'Bahasa Indonesia',
        nativeName: 'Bahasa Indonesia',
        sortIndex: 14,
      ),
      const Language(
        code: 'ms-MY',
        name: 'Bahasa Melayu',
        nativeName: 'Bahasa Melayu',
        sortIndex: 15,
      ),
      const Language(
        code: 'hi-IN',
        name: 'हिन्दी',
        nativeName: 'हिन्दी',
        sortIndex: 16,
      ),
      const Language(
        code: 'tr-TR',
        name: 'Türkçe',
        nativeName: 'Türkçe',
        sortIndex: 17,
      ),
      const Language(
        code: 'pl-PL',
        name: 'Polski',
        nativeName: 'Polski',
        sortIndex: 18,
      ),
      const Language(
        code: 'nl-NL',
        name: 'Nederlands',
        nativeName: 'Nederlands',
        sortIndex: 19,
      ),
      const Language(
        code: 'sv-SE',
        name: 'Svenska',
        nativeName: 'Svenska',
        sortIndex: 20,
      ),
    ];
  }
}
