import 'dart:developer';

import 'package:ttpolyglot/src/common/api/language_api.dart';
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
      final languageEnum = model.primaryLanguageCode ?? LanguageEnum.enUS;
      final primaryLanguage = Language(
        code: languageEnum.code,
        name: languageEnum.name,
        nativeName: languageEnum.nativeName,
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
        primaryLanguageCode: LanguageEnum.fromValue(project.primaryLanguage.code),
        createdAt: project.createdAt,
        updatedAt: project.updatedAt,
        isActive: project.isActive,
        lastActivityAt: project.lastAccessedAt,
        ownerUsername: project.owner.email.split('@').first,
        ownerDisplayName: project.owner.name,
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
    // 使用 LanguageApi 的默认语言列表
    final presetLanguages = LanguageApi.getDefaultLanguages();
    try {
      final model = presetLanguages.firstWhere((lang) => lang.code.code == code);
      return Language(
        code: code,
        name: model.name,
        nativeName: model.nativeName ?? '',
        isRtl: model.isRtl,
        sortIndex: model.sortOrder,
      );
    } catch (_) {
      return null;
    }
  }
}
