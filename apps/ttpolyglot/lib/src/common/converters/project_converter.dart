import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 项目模型转换器
/// 负责在 API 模型（ProjectModel）和 Core 模型（Project）之间进行转换
class ProjectConverter {
  ProjectConverter._();

  /// 将 ProjectModel (API) 转换为 Project (Core)
  static Project toProject(ProjectModel model) {
    try {
      final primaryLanguage = Language(
        id: model.primaryLanguageId,
        code: model.primaryLanguage.code.code,
        name: model.primaryLanguage.name,
        nativeName: model.primaryLanguage.nativeName ?? model.primaryLanguage.name,
        isRtl: model.primaryLanguage.isRtl,
        sortIndex: model.primaryLanguage.sortOrder,
      );

      final owner = User(
        id: model.ownerId,
        email: model.owner.email ?? '',
        name: model.owner.displayName ?? model.owner.username ?? '',
        role: UserRole.admin,
        createdAt: model.owner.createdAt,
        updatedAt: model.owner.updatedAt,
      );

      // 构建目标语言列表（排除主语言）
      final targetLanguages = <Language>[];
      for (final langModel in model.languages) {
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

  /// 将 Project (Core) 转换为 ProjectModel (API)
  /// 注意：这个方法不会填充完整的 languages 和 members 列表，
  /// 需要从 API 返回时才能获取完整数据
  static ProjectModel toProjectModel(
    Project project, {
    List<LanguageModel>? languages,
    List<ProjectMemberModel>? members,
  }) {
    try {
      // 构建语言列表（如果没有提供，则使用默认空列表）
      final projectLanguages = languages ??
          [
            // 至少包含主语言
            LanguageModel(
              id: project.primaryLanguage.id,
              code: LanguageEnum.fromValue(project.primaryLanguage.code),
              name: project.primaryLanguage.name,
              nativeName: project.primaryLanguage.nativeName,
              isRtl: project.primaryLanguage.isRtl,
              sortOrder: project.primaryLanguage.sortIndex,
              isActive: true,
              createdAt: project.createdAt,
              updatedAt: project.updatedAt,
            ),
          ];

      // 构建成员列表（如果没有提供，则使用默认空列表）
      final projectMembers = members ??
          [
            // 至少包含所有者
            ProjectMemberModel(
              id: 0,
              projectId: int.parse(project.id),
              userId: project.owner.id,
              role: ProjectRoleEnum.owner,
              username: project.owner.email.split('@').first,
              displayName: project.owner.name,
              email: project.owner.email,
              status: MemberStatusEnum.active,
              isActive: true,
              invitedAt: project.createdAt,
              joinedAt: project.createdAt,
              createdAt: project.createdAt,
              updatedAt: project.updatedAt,
            ),
          ];

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
        languages: projectLanguages,
        members: projectMembers,
      );
    } catch (error, stackTrace) {
      ServerLogger.error('[toProjectModel]', error: error, stackTrace: stackTrace, name: 'ProjectConverter');
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
