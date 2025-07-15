import 'dart:developer';

import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/projects/services/project_data_initializer.dart';
import 'package:ttpolyglot/src/features/projects/services/project_service_impl.dart';
import 'package:ttpolyglot_core/core.dart';

/// 项目管理控制器
class ProjectsController extends GetxController {
  // 项目服务
  late final ProjectServiceImpl _projectService;

  // 响应式项目列表
  final _projects = <Project>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedProjectId = ''.obs;
  final _error = ''.obs;

  // Getters
  List<Project> get projects => _projects;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  String get selectedProjectId => _selectedProjectId.value;
  String get error => _error.value;

  // 过滤后的项目列表
  List<Project> get filteredProjects {
    if (_searchQuery.value.isEmpty) {
      return _projects;
    }
    return _projects.where((project) {
      return project.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
          project.description.toLowerCase().contains(_searchQuery.value.toLowerCase());
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  /// 初始化项目服务
  Future<void> _initializeService() async {
    try {
      _projectService = await ProjectServiceImpl.create();

      // 初始化示例数据
      final initializer = ProjectDataInitializer(_projectService);
      await initializer.initializeSampleProjects();

      await loadProjects();
    } catch (e, stackTrace) {
      _error.value = '初始化项目服务失败: $e';
      Get.snackbar('错误', _error.value);
      log('初始化项目服务失败', error: e, stackTrace: stackTrace);
    }
  }

  /// 加载项目列表
  Future<void> loadProjects() async {
    _isLoading.value = true;
    _error.value = '';

    try {
      final projects = await _projectService.getAllProjects();
      _projects.assignAll(projects);
    } catch (error, stackTrace) {
      _error.value = '加载项目失败: $error';
      Get.snackbar('错误', _error.value);
      log('loadProjects', error: error, stackTrace: stackTrace);
    } finally {
      _isLoading.value = false;
    }
  }

  /// 搜索项目
  void searchProjects(String query) {
    _searchQuery.value = query;
  }

  /// 创建新项目
  Future<void> createProject({
    required String name,
    required String description,
    required Language defaultLanguage,
    required List<Language> targetLanguages,
  }) async {
    _isLoading.value = true;
    _error.value = '';

    try {
      // 检查项目名称是否可用
      final isNameAvailable = await _projectService.isProjectNameAvailable(name);
      if (!isNameAvailable) {
        _error.value = '项目名称已存在';
        Get.snackbar('错误', _error.value);
        return;
      }

      final request = CreateProjectRequest(
        name: name,
        description: description,
        defaultLanguage: defaultLanguage,
        targetLanguages: targetLanguages,
        ownerId: 'default-user',
      );

      final newProject = await _projectService.createProject(request);
      _projects.add(newProject);

      Get.snackbar('成功', '项目创建成功');
    } catch (error, stackTrace) {
      _error.value = '创建项目失败: $error';
      Get.snackbar('错误', _error.value);
      log('createProject', error: error, stackTrace: stackTrace);
    } finally {
      _isLoading.value = false;
    }
  }

  /// 更新项目
  Future<void> updateProject(
    Project project, {
    String? name,
    String? description,
    Language? defaultLanguage,
    List<Language>? targetLanguages,
    bool? isActive,
  }) async {
    try {
      final request = UpdateProjectRequest(
        name: name,
        description: description,
        defaultLanguage: defaultLanguage,
        targetLanguages: targetLanguages,
        isActive: isActive,
      );

      final updatedProject = await _projectService.updateProject(project.id, request);

      // 更新本地列表
      final index = _projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        _projects[index] = updatedProject;
      }

      Get.snackbar('成功', '项目更新成功');
    } catch (error, stackTrace) {
      _error.value = '更新项目失败: $error';
      Get.snackbar('错误', _error.value);
      log('updateProject', error: error, stackTrace: stackTrace);
    }
  }

  /// 删除项目
  Future<void> deleteProject(String id) async {
    try {
      await _projectService.deleteProject(id);
      _projects.removeWhere((project) => project.id == id);

      // 如果删除的是当前选中项目，清除选中状态
      if (_selectedProjectId.value == id) {
        _selectedProjectId.value = '';
      }

      Get.snackbar('成功', '项目删除成功');
    } catch (error, stackTrace) {
      _error.value = '删除项目失败: $error';
      Get.snackbar('错误', _error.value);
      log('deleteProject', error: error, stackTrace: stackTrace);
    }
  }

  /// 切换项目状态
  Future<void> toggleProjectStatus(String id, bool isActive) async {
    try {
      final updatedProject = await _projectService.toggleProjectStatus(id, isActive);

      // 更新本地列表
      final index = _projects.indexWhere((p) => p.id == id);
      if (index != -1) {
        _projects[index] = updatedProject;
      }

      final status = isActive ? '激活' : '停用';
      Get.snackbar('成功', '项目$status成功');
    } catch (error, stackTrace) {
      _error.value = '切换项目状态失败: $error';
      Get.snackbar('错误', _error.value);
      log('toggleProjectStatus', error: error, stackTrace: stackTrace);
    }
  }

  /// 刷新项目列表
  Future<void> refreshProjects() async {
    await loadProjects();
  }

  /// 设置选中的项目ID
  void setSelectedProjectId(String id) {
    final project = _projects.firstWhereOrNull((project) => project.id == id);
    if (project != null) {
      _selectedProjectId.value = id;
      // 更新项目最后访问时间
      _updateProjectLastAccessed(id);
    }
  }

  /// 获取选中的项目
  Project? getSelectedProject() {
    if (_selectedProjectId.value.isEmpty) return null;
    return _projects.firstWhereOrNull((project) => project.id == _selectedProjectId.value);
  }

  /// 获取项目统计信息
  Future<ProjectStats> getProjectStats(String projectId) async {
    try {
      return await _projectService.getProjectStats(projectId);
    } catch (error, stackTrace) {
      log('获取项目统计失败', error: error, stackTrace: stackTrace);
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
  }

  /// 搜索项目（使用服务）
  Future<void> searchProjectsWithService(String query) async {
    if (query.isEmpty) {
      await loadProjects();
      return;
    }

    _isLoading.value = true;
    try {
      final projects = await _projectService.searchProjects(query);
      _projects.assignAll(projects);
    } catch (error, stackTrace) {
      _error.value = '搜索项目失败: $error';
      Get.snackbar('错误', _error.value);
      log('搜索项目失败', error: error, stackTrace: stackTrace);
    } finally {
      _isLoading.value = false;
    }
  }

  /// 获取最近访问的项目
  Future<List<Project>> getRecentProjects({int limit = 10}) async {
    try {
      return await _projectService.getRecentProjects('default-user', limit: limit);
    } catch (error, stackTrace) {
      log('获取最近项目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  /// 检查项目名称是否可用
  Future<bool> isProjectNameAvailable(String name, {String? excludeProjectId}) async {
    try {
      return await _projectService.isProjectNameAvailable(name, excludeProjectId: excludeProjectId);
    } catch (error, stackTrace) {
      log('检查项目名称失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 更新项目最后访问时间
  Future<void> _updateProjectLastAccessed(String projectId) async {
    try {
      await _projectService.updateProjectLastAccessed(projectId, 'default-user');

      // 更新本地列表中的项目
      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index != -1) {
        final project = _projects[index];
        _projects[index] = project.copyWith(
          lastAccessedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (error, stackTrace) {
      log('更新项目访问时间失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 获取项目详情
  Future<Project?> getProject(String projectId) async {
    try {
      return await _projectService.getProject(projectId);
    } catch (error, stackTrace) {
      log('获取项目详情失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 检查项目是否存在
  Future<bool> projectExists(String projectId) async {
    try {
      return await _projectService.projectExists(projectId);
    } catch (error, stackTrace) {
      log('检查项目存在性失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 获取预设语言列表
  List<Language> getPresetLanguages() {
    return ProjectDataInitializer.getPresetLanguages();
  }

  /// 获取常用语言列表
  List<Language> getCommonLanguages() {
    return ProjectDataInitializer.getCommonLanguages();
  }

  /// 根据语言代码获取语言对象
  Language? getLanguageByCode(String code) {
    return ProjectDataInitializer.getLanguageByCode(code);
  }
}
