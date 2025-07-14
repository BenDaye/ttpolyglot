import 'dart:convert';
import 'dart:developer';

import 'package:ttpolyglot_core/core.dart';

import '../../../core/storage/storage_provider.dart';

/// 项目服务实现
class ProjectServiceImpl implements ProjectService {
  final StorageService _storageService;

  ProjectServiceImpl(this._storageService);

  /// 从存储提供者创建项目服务
  static Future<ProjectServiceImpl> create() async {
    try {
      final storageProvider = StorageProvider();
      await storageProvider.initialize();
      return ProjectServiceImpl(storageProvider.storageService);
    } catch (error, stackTrace) {
      log('创建项目服务失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<Project> createProject(CreateProjectRequest request) async {
    final project = Project(
      id: 'project-${DateTime.now().millisecondsSinceEpoch}',
      name: request.name,
      description: request.description,
      defaultLanguage: request.defaultLanguage,
      targetLanguages: request.targetLanguages,
      owner: await _getCurrentUser(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: request.isActive,
    );

    await _saveProject(project);
    await _updateProjectList(project.id, add: true);

    return project;
  }

  @override
  Future<Project?> getProject(String projectId) async {
    try {
      final projectJson = await _storageService.read(StorageKeys.projectConfig(projectId));
      if (projectJson == null) return null;

      final projectData = jsonDecode(projectJson) as Map<String, dynamic>;
      return Project.fromJson(projectData);
    } catch (error, stackTrace) {
      log('获取项目失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<List<Project>> getUserProjects(String userId) async {
    try {
      final projectListJson = await _storageService.read(StorageKeys.projectList);
      if (projectListJson == null) return [];

      final projectIds = projectListJson.split(',').where((id) => id.isNotEmpty).toList();
      final projects = <Project>[];

      for (final projectId in projectIds) {
        final project = await getProject(projectId);
        if (project != null && project.owner.id == userId) {
          projects.add(project);
        }
      }

      return projects;
    } catch (error, stackTrace) {
      log('获取用户项目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<Project>> getAllProjects({
    int? limit,
    int? offset,
    String? search,
    bool? isActive,
  }) async {
    try {
      final projectListJson = await _storageService.read(StorageKeys.projectList);
      if (projectListJson == null) return [];

      final projectIds = projectListJson.split(',').where((id) => id.isNotEmpty).toList();
      final projects = <Project>[];

      for (final projectId in projectIds) {
        final project = await getProject(projectId);
        if (project != null) {
          // 过滤条件
          if (isActive != null && project.isActive != isActive) continue;
          if (search != null && search.isNotEmpty) {
            final searchLower = search.toLowerCase();
            if (!project.name.toLowerCase().contains(searchLower) &&
                !project.description.toLowerCase().contains(searchLower)) {
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
      log('获取所有项目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<Project> updateProject(String projectId, UpdateProjectRequest request) async {
    final existingProject = await getProject(projectId);
    if (existingProject == null) {
      throw Exception('项目不存在: $projectId');
    }

    final updatedProject = existingProject.copyWith(
      name: request.name,
      description: request.description,
      defaultLanguage: request.defaultLanguage,
      targetLanguages: request.targetLanguages,
      isActive: request.isActive,
      updatedAt: DateTime.now(),
    );

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
  Future<Project> toggleProjectStatus(String projectId, bool isActive) async {
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
      final statsJson = await _storageService.read(StorageKeys.projectCache(projectId));
      if (statsJson != null) {
        final statsData = jsonDecode(statsJson) as Map<String, dynamic>;
        return ProjectStats.fromJson(statsData);
      }
    } catch (error, stackTrace) {
      log('获取项目统计失败', error: error, stackTrace: stackTrace);
    }

    // 返回默认统计
    return ProjectStats(
      totalEntries: 0,
      completedEntries: 0,
      pendingEntries: 0,
      reviewingEntries: 0,
      completionRate: 0.0,
      languageCount: 0,
      memberCount: 1,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<List<Project>> searchProjects(
    String query, {
    String? userId,
    int? limit,
    int? offset,
  }) async {
    return await getAllProjects(
      search: query,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<Project>> getRecentProjects(String userId, {int limit = 10}) async {
    final projects = await getUserProjects(userId);

    // 按最后访问时间排序
    projects.sort((a, b) {
      final aTime = a.lastAccessedAt ?? a.updatedAt;
      final bTime = b.lastAccessedAt ?? b.updatedAt;
      return bTime.compareTo(aTime);
    });

    return projects.take(limit).toList();
  }

  @override
  Future<void> updateProjectLastAccessed(String projectId, String userId) async {
    final project = await getProject(projectId);
    if (project == null) return;

    final updatedProject = project.copyWith(
      lastAccessedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _saveProject(updatedProject);
  }

  /// 保存项目到存储
  Future<void> _saveProject(Project project) async {
    final projectJson = jsonEncode(project.toJson());
    await _storageService.write(StorageKeys.projectConfig(project.id), projectJson);
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
      log('更新项目列表失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 获取当前用户（简化实现）
  Future<User> _getCurrentUser() async {
    // 这里应该从认证服务获取当前用户
    // 暂时返回默认用户
    return User(
      id: 'default-user',
      email: 'user@example.com',
      name: '默认用户',
      role: UserRole.admin,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
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
  Future<Project> duplicateProject(String sourceProjectId, String newName) async {
    throw UnimplementedError('duplicateProject not implemented');
  }

  @override
  Future<Map<String, dynamic>> exportProjectConfig(String projectId) async {
    throw UnimplementedError('exportProjectConfig not implemented');
  }

  @override
  Future<Project> importProjectConfig(Map<String, dynamic> config) async {
    throw UnimplementedError('importProjectConfig not implemented');
  }

  @override
  Future<List<Language>> getSupportedLanguages() async {
    try {
      return Language.supportedLanguages;
    } catch (error, stackTrace) {
      log('获取支持的语言列表失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<Language>> searchSupportedLanguages(String query) async {
    try {
      return Language.searchSupportedLanguages(query);
    } catch (error, stackTrace) {
      log('搜索支持的语言失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<Map<String, List<Language>>> getSupportedLanguagesByGroup() async {
    try {
      return Language.supportedLanguagesByGroup;
    } catch (error, stackTrace) {
      log('获取分组语言列表失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  @override
  Future<bool> validateLanguageSupport(String languageCode) async {
    try {
      return Language.isLanguageSupported(languageCode);
    } catch (error, stackTrace) {
      log('验证语言支持失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  @override
  Future<Map<String, bool>> validateMultipleLanguagesSupport(List<String> languageCodes) async {
    try {
      final Map<String, bool> results = {};
      for (final code in languageCodes) {
        results[code] = Language.isLanguageSupported(code);
      }
      return results;
    } catch (error, stackTrace) {
      log('验证多个语言支持失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }
}
