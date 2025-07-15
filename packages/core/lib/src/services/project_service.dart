import 'dart:developer' as developer;

import '../models/language.dart';
import '../models/project.dart';
import '../models/user.dart';

/// 项目管理服务接口
abstract class ProjectService {
  /// 创建新项目
  Future<Project> createProject(CreateProjectRequest request);

  /// 获取项目详情
  Future<Project?> getProject(String projectId);

  /// 获取用户的所有项目
  Future<List<Project>> getUserProjects(String userId);

  /// 获取所有项目（管理员功能）
  Future<List<Project>> getAllProjects({
    int? limit,
    int? offset,
    String? search,
    bool? isActive,
  });

  /// 更新项目信息
  Future<Project> updateProject(String projectId, UpdateProjectRequest request);

  /// 删除项目
  Future<void> deleteProject(String projectId);

  /// 激活/停用项目
  Future<Project> toggleProjectStatus(String projectId, {required bool isActive});

  /// 检查项目是否存在
  Future<bool> projectExists(String projectId);

  /// 检查项目名称是否可用
  Future<bool> isProjectNameAvailable(String name, {String? excludeProjectId});

  /// 获取项目统计信息
  Future<ProjectStats> getProjectStats(String projectId);

  /// 获取用户在项目中的权限
  Future<ProjectPermission> getUserProjectPermission(String userId, String projectId);

  /// 添加项目成员
  Future<void> addProjectMember(String projectId, String userId, ProjectRole role);

  /// 移除项目成员
  Future<void> removeProjectMember(String projectId, String userId);

  /// 更新项目成员角色
  Future<void> updateProjectMemberRole(String projectId, String userId, ProjectRole role);

  /// 获取项目成员列表
  Future<List<ProjectMember>> getProjectMembers(String projectId);

  /// 搜索项目
  Future<List<Project>> searchProjects(
    String query, {
    String? userId,
    int? limit,
    int? offset,
  });

  /// 获取最近访问的项目
  Future<List<Project>> getRecentProjects(String userId, {int limit = 10});

  /// 更新项目最后访问时间
  Future<void> updateProjectLastAccessed(String projectId, String userId);

  /// 复制项目
  Future<Project> duplicateProject(String sourceProjectId, String newName);

  /// 导出项目配置
  Future<Map<String, dynamic>> exportProjectConfig(String projectId);

  /// 导入项目配置
  Future<Project> importProjectConfig(Map<String, dynamic> config);

  /// 获取支持的语言列表
  Future<List<Language>> getSupportedLanguages();

  /// 搜索支持的语言
  Future<List<Language>> searchSupportedLanguages(String query);

  /// 获取按语言分组的支持语言列表
  Future<Map<String, List<Language>>> getSupportedLanguagesByGroup();

  /// 验证语言是否支持
  Future<bool> validateLanguageSupport(String languageCode);

  /// 验证多个语言是否都支持
  Future<Map<String, bool>> validateMultipleLanguagesSupport(List<String> languageCodes);
}

/// 创建项目请求
class CreateProjectRequest {
  const CreateProjectRequest({
    required this.name,
    required this.description,
    required this.defaultLanguage,
    required this.targetLanguages,
    required this.ownerId,
    this.isActive = true,
  });

  final String name;
  final String description;
  final Language defaultLanguage;
  final List<Language> targetLanguages;
  final String ownerId;
  final bool isActive;

  /// 验证请求数据
  List<String> validate() {
    try {
      final errors = <String>[];

      // 验证项目名称
      if (name.trim().isEmpty) {
        errors.add('项目名称不能为空');
      }

      // 验证项目描述
      if (description.trim().isEmpty) {
        errors.add('项目描述不能为空');
      }

      // 验证默认语言
      if (!Language.isValidLanguageCode(defaultLanguage.code)) {
        errors.add('默认语言代码格式错误: ${defaultLanguage.code}');
      }

      if (!Language.isLanguageSupported(defaultLanguage.code)) {
        errors.add('不支持的默认语言: ${defaultLanguage.code}');
      }

      // 验证目标语言
      if (targetLanguages.isEmpty) {
        errors.add('至少需要选择一个目标语言');
      }

      for (final language in targetLanguages) {
        if (!Language.isValidLanguageCode(language.code)) {
          errors.add('目标语言代码格式错误: ${language.code}');
        }

        if (!Language.isLanguageSupported(language.code)) {
          errors.add('不支持的目标语言: ${language.code}');
        }
      }

      // 验证默认语言不能在目标语言中
      if (targetLanguages.any((lang) => lang.code == defaultLanguage.code)) {
        errors.add('默认语言不能同时作为目标语言');
      }

      // 验证目标语言不能重复
      final targetLanguageCodes = targetLanguages.map((lang) => lang.code).toList();
      final uniqueCodes = targetLanguageCodes.toSet();
      if (targetLanguageCodes.length != uniqueCodes.length) {
        errors.add('目标语言不能重复');
      }

      // 验证所有者ID
      if (ownerId.trim().isEmpty) {
        errors.add('项目所有者ID不能为空');
      }

      return errors;
    } catch (error, stackTrace) {
      developer.log('CreateProjectRequest.validate', error: error, stackTrace: stackTrace);
      return ['验证项目请求时发生错误'];
    }
  }

  /// 检查请求是否有效
  bool get isValid => validate().isEmpty;
}

/// 更新项目请求
class UpdateProjectRequest {
  const UpdateProjectRequest({
    this.name,
    this.description,
    this.defaultLanguage,
    this.targetLanguages,
    this.isActive,
  });

  final String? name;
  final String? description;
  final Language? defaultLanguage;
  final List<Language>? targetLanguages;
  final bool? isActive;

  /// 验证请求数据
  List<String> validate() {
    try {
      final errors = <String>[];

      // 验证项目名称
      if (name != null && name!.trim().isEmpty) {
        errors.add('项目名称不能为空');
      }

      // 验证项目描述
      if (description != null && description!.trim().isEmpty) {
        errors.add('项目描述不能为空');
      }

      // 验证默认语言
      if (defaultLanguage != null) {
        if (!Language.isValidLanguageCode(defaultLanguage!.code)) {
          errors.add('默认语言代码格式错误: ${defaultLanguage!.code}');
        }

        if (!Language.isLanguageSupported(defaultLanguage!.code)) {
          errors.add('不支持的默认语言: ${defaultLanguage!.code}');
        }
      }

      // 验证目标语言
      if (targetLanguages != null) {
        if (targetLanguages!.isEmpty) {
          errors.add('至少需要选择一个目标语言');
        }

        for (final language in targetLanguages!) {
          if (!Language.isValidLanguageCode(language.code)) {
            errors.add('目标语言代码格式错误: ${language.code}');
          }

          if (!Language.isLanguageSupported(language.code)) {
            errors.add('不支持的目标语言: ${language.code}');
          }
        }

        // 验证默认语言不能在目标语言中（如果同时提供了默认语言）
        if (defaultLanguage != null && targetLanguages!.any((lang) => lang.code == defaultLanguage!.code)) {
          errors.add('默认语言不能同时作为目标语言');
        }

        // 验证目标语言不能重复
        final targetLanguageCodes = targetLanguages!.map((lang) => lang.code).toList();
        final uniqueCodes = targetLanguageCodes.toSet();
        if (targetLanguageCodes.length != uniqueCodes.length) {
          errors.add('目标语言不能重复');
        }
      }

      return errors;
    } catch (error, stackTrace) {
      developer.log('UpdateProjectRequest.validate', error: error, stackTrace: stackTrace);
      return ['验证项目更新请求时发生错误'];
    }
  }

  /// 检查请求是否有效
  bool get isValid => validate().isEmpty;
}

/// 项目统计信息
class ProjectStats {
  const ProjectStats({
    required this.totalEntries,
    required this.completedEntries,
    required this.pendingEntries,
    required this.reviewingEntries,
    required this.completionRate,
    required this.languageCount,
    required this.memberCount,
    required this.lastUpdated,
  });

  final int totalEntries;
  final int completedEntries;
  final int pendingEntries;
  final int reviewingEntries;
  final double completionRate;
  final int languageCount;
  final int memberCount;
  final DateTime lastUpdated;

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'totalEntries': totalEntries,
      'completedEntries': completedEntries,
      'pendingEntries': pendingEntries,
      'reviewingEntries': reviewingEntries,
      'completionRate': completionRate,
      'languageCount': languageCount,
      'memberCount': memberCount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// 从 JSON 创建
  factory ProjectStats.fromJson(Map<String, dynamic> json) {
    return ProjectStats(
      totalEntries: json['totalEntries'] as int,
      completedEntries: json['completedEntries'] as int,
      pendingEntries: json['pendingEntries'] as int,
      reviewingEntries: json['reviewingEntries'] as int,
      completionRate: (json['completionRate'] as num).toDouble(),
      languageCount: json['languageCount'] as int,
      memberCount: json['memberCount'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}

/// 项目权限
class ProjectPermission {
  const ProjectPermission({
    required this.canRead,
    required this.canWrite,
    required this.canManage,
    required this.canDelete,
  });

  final bool canRead;
  final bool canWrite;
  final bool canManage;
  final bool canDelete;
}

/// 项目角色
enum ProjectRole {
  owner,
  admin,
  translator,
  reviewer,
  viewer,
}

/// 项目角色扩展
extension ProjectRoleExtension on ProjectRole {
  String get displayName {
    switch (this) {
      case ProjectRole.owner:
        return '项目所有者';
      case ProjectRole.admin:
        return '项目管理员';
      case ProjectRole.translator:
        return '翻译员';
      case ProjectRole.reviewer:
        return '审核员';
      case ProjectRole.viewer:
        return '查看者';
    }
  }

  bool get canRead => true;

  bool get canWrite {
    return this == ProjectRole.owner ||
        this == ProjectRole.admin ||
        this == ProjectRole.translator ||
        this == ProjectRole.reviewer;
  }

  bool get canManage {
    return this == ProjectRole.owner || this == ProjectRole.admin;
  }

  bool get canDelete {
    return this == ProjectRole.owner;
  }
}

/// 项目成员
class ProjectMember {
  const ProjectMember({
    required this.user,
    required this.role,
    required this.joinedAt,
  });

  final User user;
  final ProjectRole role;
  final DateTime joinedAt;
}
