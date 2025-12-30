import 'dart:convert';

import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/common/constants/storage_keys.dart';
import 'package:ttpolyglot/src/core/services/project_service.dart';
import 'package:ttpolyglot/src/core/storage/storage_provider.dart';
import 'package:ttpolyglot/src/core/storage/storage_service.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 项目服务实现
class ProjectServiceImpl extends GetxService implements ProjectService {
  final StorageService _storageService;

  ProjectServiceImpl(this._storageService);

  /// 从存储提供者创建项目服务
  static Future<ProjectServiceImpl> create() async {
    try {
      final storageProvider = StorageProvider();
      await storageProvider.initialize();
      return ProjectServiceImpl(storageProvider.storageService);
    } catch (error, stackTrace) {
      LoggerUtils.error('创建项目服务失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<ProjectModel> createProject(CreateProjectRequest request) async {
    // 调用 API 创建项目
    final projectApi = Get.find<ProjectApi>();
    final project = await projectApi.createProject(
      name: request.name,
      description: request.description,
      primaryLanguageId: request.primaryLanguageId!,
      slug: request.slug,
      visibility: request.visibility,
    );

    if (project == null) {
      throw Exception('创建项目失败');
    }

    // 本地存储项目信息（如果需要）
    await _saveProject(project);
    await _updateProjectList(project.id.toString(), add: true);

    return project;
  }

  @override
  Future<ProjectModel?> getProject(String projectId) async {
    try {
      LoggerUtils.info('从存储读取项目: $projectId');
      final projectJson = await _storageService.read(StorageKeys.projectConfig(projectId));
      if (projectJson == null) {
        LoggerUtils.info('项目数据不存在: $projectId');
        return null;
      }

      final projectData = jsonDecode(projectJson) as Map<String, dynamic>;
      final project = ProjectModel.fromJson(projectData);
      LoggerUtils.info('项目读取成功: ID=${project.id}, 名称="${project.name}"');
      return project;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<List<ProjectModel>> getUserProjects(String userId) async {
    try {
      final projectListJson = await _storageService.read(StorageKeys.projectList);
      if (projectListJson == null) return [];

      final projectIds = projectListJson.split(',').where((id) => id.isNotEmpty).toList();
      final projects = <ProjectModel>[];

      for (final projectId in projectIds) {
        final project = await getProject(projectId);
        if (project != null && project.owner.id == userId) {
          projects.add(project);
        }
      }

      return projects;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取用户项目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<ProjectModel>> getAllProjects({
    int? limit,
    int? offset,
    String? search,
    bool? isActive,
  }) async {
    try {
      final projectListJson = await _storageService.read(StorageKeys.projectList);
      if (projectListJson == null) return [];

      final projectIds = projectListJson.split(',').where((id) => id.isNotEmpty).toList();
      final projects = <ProjectModel>[];

      for (final projectId in projectIds) {
        final project = await getProject(projectId);
        if (project != null) {
          // 过滤条件
          if (isActive != null && project.isActive != isActive) continue;
          if (search != null && search.isNotEmpty) {
            final searchLower = search.toLowerCase();
            if (!project.name.toLowerCase().contains(searchLower) &&
                !(project.description?.toLowerCase().contains(searchLower) ?? false)) {
              continue;
            }
          }
          projects.add(project);
        }
      }

      // 排序（最新的在前面）
      projects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      // 分页
      if (offset != null && offset > 0) {
        if (offset >= projects.length) return [];
        final end = limit != null ? (offset + limit).clamp(0, projects.length) : projects.length;
        return projects.sublist(offset, end);
      }

      if (limit != null && limit > 0) {
        return projects.take(limit).toList();
      }

      return projects;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取所有项目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<ProjectModel> updateProject(String projectId, UpdateProjectRequest request) async {
    final existingProject = await getProject(projectId);
    if (existingProject == null) {
      throw Exception('项目不存在: $projectId');
    }

    // 调用 API 更新项目
    final projectApi = Get.find<ProjectApi>();
    final updatedProject = await projectApi.updateProject(
      projectId: int.parse(projectId),
      name: request.name,
      description: request.description,
      status: request.status,
      visibility: request.visibility,
    );

    if (updatedProject == null) {
      throw Exception('更新项目失败');
    }

    // 本地存储更新后的项目信息
    await _saveProject(updatedProject);

    return updatedProject;
  }

  @override
  Future<void> deleteProject(String projectId) async {
    // 删除项目配置
    await _storageService.delete(StorageKeys.projectConfig(projectId));

    // 删除项目相关数据
    await _storageService.delete(StorageKeys.projectDatabase(projectId));
    await _storageService.delete(StorageKeys.projectCache(projectId));
    await _storageService.delete(StorageKeys.projectSettings(projectId));

    // 从项目列表中移除
    await _updateProjectList(projectId, add: false);
  }

  @override
  Future<ProjectModel> toggleProjectStatus(String projectId, {required bool isActive}) async {
    final project = await getProject(projectId);
    if (project == null) {
      throw Exception('项目不存在: $projectId');
    }

    final updatedProject = project.copyWith(
      isActive: isActive,
      updatedAt: DateTime.now(),
    );

    await _saveProject(updatedProject);
    return updatedProject;
  }

  @override
  Future<bool> projectExists(String projectId) async {
    return await _storageService.exists(StorageKeys.projectConfig(projectId));
  }

  @override
  Future<bool> isProjectNameAvailable(String name, {String? excludeProjectId}) async {
    final projects = await getAllProjects();
    return !projects
        .any((project) => project.name.toLowerCase() == name.toLowerCase() && project.id != excludeProjectId);
  }

  @override
  Future<ProjectStats> getProjectStats(String projectId) async {
    try {
      final statsJson = await _storageService.read('${StorageKeys.projectCache}.$projectId.stats');
      if (statsJson != null) {
        final statsData = jsonDecode(statsJson) as Map<String, dynamic>;
        return ProjectStats.fromJson(statsData);
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目统计失败', error: error, stackTrace: stackTrace);
    }

    // 返回默认统计
    return ProjectStats(
      languageCount: 0,
      memberCount: 1,
      totalEntries: 0,
      translatedEntries: 0,
      reviewingEntries: 0,
      approvedEntries: 0,
      avgQualityScore: 0.0,
    );
  }

  @override
  Future<List<ProjectModel>> searchProjects(
    String query, {
    String? userId,
    bool? isActive,
  }) async {
    return await getAllProjects(
      search: query,
      isActive: isActive,
    );
  }

  @override
  Future<List<ProjectModel>> getRecentProjects(String userId, {int limit = 10}) async {
    final projects = await getUserProjects(userId);

    // 按最后活动时间排序
    projects.sort((a, b) {
      final aTime = a.lastActivityAt ?? a.updatedAt;
      final bTime = b.lastActivityAt ?? b.updatedAt;
      return bTime.compareTo(aTime);
    });

    return projects.take(limit).toList();
  }

  @override
  Future<void> updateProjectLastAccessed(String projectId, String userId) async {
    final project = await getProject(projectId);
    if (project == null) return;

    // 更新最后活动时间
    final updatedProject = project.copyWith(
      lastActivityAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _saveProject(updatedProject);
  }

  /// 保存项目到存储
  Future<void> _saveProject(ProjectModel project) async {
    LoggerUtils.info('保存项目到存储: ID=${project.id}, 名称="${project.name}"');
    final projectJson = jsonEncode(project.toJson());
    await _storageService.write(StorageKeys.projectConfig(project.id.toString()), projectJson);
    LoggerUtils.info('项目保存完成: ${project.id}');
  }

  /// 更新项目列表索引
  Future<void> _updateProjectList(String projectId, {required bool add}) async {
    try {
      final projectListJson = await _storageService.read(StorageKeys.projectList);
      final projectIds = projectListJson?.split(',').where((id) => id.isNotEmpty).toSet() ?? <String>{};

      if (add) {
        projectIds.add(projectId);
      } else {
        projectIds.remove(projectId);
      }

      await _storageService.write(StorageKeys.projectList, projectIds.join(','));
    } catch (error, stackTrace) {
      LoggerUtils.error('更新项目列表失败', error: error, stackTrace: stackTrace);
    }
  }

  // 以下方法暂时不实现，返回默认值或抛出异常
  @override
  Future<ProjectPermission> getUserProjectPermission(String userId, String projectId) async {
    throw UnimplementedError('getUserProjectPermission not implemented');
  }

  @override
  Future<void> addProjectMember(String projectId, String userId, ProjectRole role) async {
    throw UnimplementedError('addProjectMember not implemented');
  }

  @override
  Future<void> removeProjectMember(String projectId, String userId) async {
    throw UnimplementedError('removeProjectMember not implemented');
  }

  @override
  Future<void> updateProjectMemberRole(String projectId, String userId, ProjectRole role) async {
    throw UnimplementedError('updateProjectMemberRole not implemented');
  }

  @override
  Future<List<ProjectMember>> getProjectMembers(String projectId) async {
    throw UnimplementedError('getProjectMembers not implemented');
  }

  @override
  Future<ProjectModel> duplicateProject(String sourceProjectId, String newName) async {
    throw UnimplementedError('duplicateProject not implemented');
  }

  @override
  Future<Map<String, dynamic>> exportProjectConfig(String projectId) async {
    throw UnimplementedError('exportProjectConfig not implemented');
  }

  @override
  Future<ProjectModel> importProjectConfig(Map<String, dynamic> config) async {
    throw UnimplementedError('importProjectConfig not implemented');
  }

  @override
  Future<List<LanguageEnum>> getSupportedLanguages() async {
    try {
      return LanguageEnum.values;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取支持的语言列表失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<LanguageEnum>> searchSupportedLanguages(String query) async {
    try {
      final lowerQuery = query.toLowerCase();
      return LanguageEnum.values.where((lang) {
        return lang.name.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (error, stackTrace) {
      LoggerUtils.error('搜索支持的语言失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<Map<String, List<LanguageEnum>>> getSupportedLanguagesByGroup() async {
    try {
      // 简单分组：将所有语言按首字母分组
      final Map<String, List<LanguageEnum>> grouped = {};
      for (final lang in LanguageEnum.values) {
        final firstChar = lang.name[0].toUpperCase();
        grouped.putIfAbsent(firstChar, () => []).add(lang);
      }
      return grouped;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取分组语言列表失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  @override
  Future<bool> validateLanguageSupport(String languageCode) async {
    try {
      return LanguageEnum.values.any((lang) => lang.name == languageCode);
    } catch (error, stackTrace) {
      LoggerUtils.error('验证语言支持失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  @override
  Future<Map<String, bool>> validateMultipleLanguagesSupport(List<String> languageCodes) async {
    try {
      final Map<String, bool> results = {};
      for (final code in languageCodes) {
        results[code] = LanguageEnum.values.any((lang) => lang.name == code);
      }
      return results;
    } catch (error, stackTrace) {
      LoggerUtils.error('验证多个语言支持失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }
}
