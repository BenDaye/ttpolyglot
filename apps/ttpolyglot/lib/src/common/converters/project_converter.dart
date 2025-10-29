import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 项目模型转换器
/// 负责在 API 模型（ProjectModel）和 Core 模型（Project）之间进行转换
class ProjectConverter {
  ProjectConverter._();

  /// 将 ProjectModel (API) 转换为 Project (Core)
  static Project toProject(ProjectModel model, {List<LanguageModel>? languages}) {
    try {
      // 构建主语言 - 通过 ID 查找语言信息
      final languageModel = _getLanguageById(model.primaryLanguageId);
      final primaryLanguage = Language(
        id: model.primaryLanguageId,
        code: languageModel?.code.code ?? LanguageEnum.enUS.code,
        name: languageModel?.name ?? LanguageEnum.enUS.name,
        nativeName: languageModel?.nativeName ?? LanguageEnum.enUS.nativeName,
        isRtl: languageModel?.isRtl ?? false,
        sortIndex: languageModel?.sortOrder ?? 0,
      );

      // 构建项目所有者
      final owner = User(
        id: model.ownerId,
        email: model.ownerEmail ?? '',
        name: model.ownerDisplayName ?? model.ownerUsername ?? '',
        role: UserRole.admin,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      );

      // 构建目标语言列表（排除主语言）
      final targetLanguages = <Language>[];
      if (languages != null) {
        for (final langModel in languages) {
          // 排除主语言，只添加目标语言
          if (langModel.id != model.primaryLanguageId) {
            targetLanguages.add(Language(
              id: langModel.id,
              code: langModel.code.code,
              name: langModel.name,
              nativeName: langModel.nativeName ?? langModel.name,
              isRtl: langModel.isRtl,
              sortIndex: langModel.sortOrder,
            ));
          }
        }
      }

      return Project(
        id: model.id.toString(), // API 使用 int，Core 使用 String
        name: model.name,
        description: model.description ?? '',
        primaryLanguage: primaryLanguage,
        targetLanguages: targetLanguages,
        owner: owner,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        isActive: model.isActive,
        lastAccessedAt: model.lastActivityAt,
      );
    } catch (error, stackTrace) {
      ServerLogger.error('[toProject]', error: error, stackTrace: stackTrace, name: 'ProjectConverter');
      rethrow;
    }
  }

  /// 将 ProjectDetailModel 转换为 Project (Core)，包含完整的语言列表
  static Project toProjectFromDetail(ProjectDetailModel detailModel) {
    try {
      return toProject(
        detailModel.project,
        languages: detailModel.languages,
      );
    } catch (error, stackTrace) {
      ServerLogger.error('[toProjectFromDetail]', error: error, stackTrace: stackTrace, name: 'ProjectConverter');
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
        primaryLanguageId: project.primaryLanguage.id,
        createdAt: project.createdAt,
        updatedAt: project.updatedAt,
        isActive: project.isActive,
        lastActivityAt: project.lastAccessedAt,
        ownerUsername: project.owner.email.split('@').first,
        ownerEmail: project.owner.email,
        ownerDisplayName: project.owner.name,
      );
    } catch (error, stackTrace) {
      ServerLogger.error('[toProjectModel]', error: error, stackTrace: stackTrace, name: 'ProjectConverter');
      rethrow;
    }
  }

  /// 根据语言 ID 获取语言模型
  static LanguageModel? _getLanguageById(int? languageId) {
    if (languageId == null) return null;

    try {
      final presetLanguages = LanguageEnum.toArray();
      return presetLanguages.firstWhere(
        (lang) => lang.id == languageId,
        orElse: () => presetLanguages.first,
      );
    } catch (_) {
      return null;
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
      id: presetLanguage?.id ?? 0,
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
    final presetLanguages = LanguageEnum.toArray();
    try {
      final model = presetLanguages.firstWhere((lang) => lang.code.code == code);
      return Language(
        id: model.id,
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
