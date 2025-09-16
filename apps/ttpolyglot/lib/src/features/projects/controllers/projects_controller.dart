import 'dart:developer';

import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:ttpolyglot/src/features/features.dart';
import 'package:ttpolyglot_core/core.dart';

/// 项目管理控制器
class ProjectsController extends GetxController {
  static ProjectsController get instance {
    return Get.isRegistered<ProjectsController>() ? Get.find<ProjectsController>() : Get.put(ProjectsController());
  }

  final ProjectServiceImpl _projectService = Get.find<ProjectServiceImpl>();
  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();

  // 响应式项目列表
  final _projects = <Project>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedProjectId = ''.obs;

  // Getters
  List<Project> get projects => _projects;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  String get selectedProjectId => _selectedProjectId.value;

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
      // 初始化示例数据
      final initializer = ProjectDataInitializer(_projectService);
      await initializer.initializeSampleProjects();

      await loadProjects();
    } catch (error, stackTrace) {
      Get.snackbar('错误', '初始化项目服务失败: $error');
      log('初始化项目服务失败', error: error, stackTrace: stackTrace, name: 'ProjectsController');
    }
  }

  /// 加载项目列表
  static Future<void> loadProjects() async {
    final controller = instance;

    try {
      controller._isLoading.value = true;
      final projects = await controller._projectService.getAllProjects();
      controller._projects.assignAll(projects);
    } catch (error, stackTrace) {
      Get.snackbar('错误', '加载项目失败: $error');
      log('loadProjects', error: error, stackTrace: stackTrace, name: 'ProjectsController');
    } finally {
      controller._isLoading.value = false;
    }
  }

  /// 搜索项目
  void searchProjects(String query) {
    _searchQuery.value = query;
  }

  /// 创建新项目
  static Future<void> createProject({
    required String name,
    required String description,
    required Language primaryLanguage,
    required List<Language> targetLanguages,
  }) async {
    final controller = instance;
    try {
      controller._isLoading.value = true;
      // 检查项目名称是否可用
      final isNameAvailable = await controller._projectService.isProjectNameAvailable(name);
      if (!isNameAvailable) {
        Get.snackbar('错误', '项目名称已存在');
        return;
      }

      final request = CreateProjectRequest(
        name: name,
        description: description,
        primaryLanguage: primaryLanguage,
        targetLanguages: targetLanguages,
        ownerId: 'default-user',
      );

      final newProject = await controller._projectService.createProject(request);

      /// 更新本地列表
      controller._projects.add(newProject);

      Get.snackbar('成功', '项目创建成功');
    } catch (error, stackTrace) {
      Get.snackbar('错误', '创建项目失败: $error');
      log('createProject', error: error, stackTrace: stackTrace, name: 'ProjectsController');
    } finally {
      controller._isLoading.value = false;
    }
  }

  /// 更新项目
  static Future<void> updateProject(
    String projectId, {
    String? name,
    String? description,
    Language? defaultLanguage,
    List<Language>? targetLanguages,
    bool? isActive,
  }) async {
    try {
      final controller = instance;

      final project = await controller._projectService.getProject(projectId);
      if (project == null) {
        throw Exception('项目不存在');
      }

      final hasLanguageChange = hasLanguageConfigChanged(
        project,
        defaultLanguage,
        targetLanguages,
      );

      final request = UpdateProjectRequest(
        name: name,
        description: description,
        targetLanguages: targetLanguages,
        isActive: isActive,
      );

      final updatedProject = await controller._projectService.updateProject(project.id, request);

      // 检查语言配置是否发生变化

      // 如果语言配置发生变化，同步翻译条目
      if (hasLanguageChange) {
        await syncTranslationLanguages(
          sourceLanguage: updatedProject.primaryLanguage,
          targetLanguages: updatedProject.targetLanguages,
          projectId: project.id,
        );
      }

      // 更新本地列表
      final index = controller._projects.indexWhere((p) => p.id == project.id);
      if (index != -1) {
        controller._projects[index] = updatedProject;
      }

      Get.snackbar('成功', '项目更新成功');
    } catch (error, stackTrace) {
      Get.snackbar('错误', '更新项目失败: $error');
      log('updateProject', error: error, stackTrace: stackTrace, name: 'ProjectsController');
    }
  }

  /// 删除项目
  static Future<void> deleteProject(String projectId) async {
    final controller = instance;

    try {
      await controller._projectService.deleteProject(projectId);
      controller._projects.removeWhere((project) => project.id == projectId);

      // 如果删除的是当前选中项目，清除选中状态
      if (controller._selectedProjectId.value == projectId) {
        controller._selectedProjectId.value = '';
      }

      Get.snackbar('成功', '项目删除成功');
    } catch (error, stackTrace) {
      Get.snackbar('错误', '删除项目失败: $error');
      log('deleteProject', error: error, stackTrace: stackTrace, name: 'ProjectsController');
    }
  }

  /// 切换项目状态
  static Future<void> toggleProjectStatus(String projectId, {required bool isActive}) async {
    final controller = instance;

    try {
      final updatedProject = await controller._projectService.toggleProjectStatus(projectId, isActive: isActive);

      // 更新本地列表
      final index = controller._projects.indexWhere((p) => p.id == projectId);
      if (index != -1) {
        controller._projects[index] = updatedProject;
      }

      final status = isActive ? '激活' : '停用';
      Get.snackbar('成功', '项目$status成功');
    } catch (error, stackTrace) {
      Get.snackbar('错误', '切换项目状态失败: $error');
      log('toggleProjectStatus', error: error, stackTrace: stackTrace, name: 'ProjectsController');
    }
  }

  /// 检查语言配置是否发生变化
  static bool hasLanguageConfigChanged(
    Project currentProject,
    Language? newPrimaryLanguage,
    List<Language>? newTargetLanguages,
  ) {
    // 检查默认语言是否变化
    if (newPrimaryLanguage != null && currentProject.primaryLanguage.code != newPrimaryLanguage.code) {
      return true;
    }

    // 检查目标语言是否变化
    if (newTargetLanguages != null) {
      final currentCodes = currentProject.targetLanguages.map((lang) => lang.code).toSet();
      final newCodes = newTargetLanguages.map((lang) => lang.code).toSet();

      if (currentCodes.length != newCodes.length ||
          !currentCodes.containsAll(newCodes) ||
          !newCodes.containsAll(currentCodes)) {
        return true;
      }
    }

    return false;
  }

  /// 同步翻译条目的语言配置
  static Future<void> syncTranslationLanguages({
    required Language sourceLanguage,
    required List<Language> targetLanguages,
    required String projectId,
  }) async {
    try {
      log('开始同步项目语言配置到翻译条目');

      final controller = instance;
      final translationService = controller._translationService;

      await translationService.syncProjectLanguages(
        projectId,
        sourceLanguage,
        targetLanguages,
      );

      log('项目语言配置同步完成');

      // 通知翻译控制器刷新数据
      if (Get.isRegistered<TranslationController>(tag: projectId)) {
        final translationController = Get.find<TranslationController>(tag: projectId);
        await translationController.onProjectLanguageChanged();
      }
    } catch (error, stackTrace) {
      log('同步翻译条目语言配置失败', error: error, stackTrace: stackTrace, name: 'ProjectsController');
      // 不抛出异常，避免影响项目更新
    }
  }

  /// 刷新项目列表
  static Future<void> refreshProjects() async {
    await loadProjects();
  }

  /// 设置选中的项目ID
  static void setSelectedProjectId(String? id) {
    final controller = instance;

    if (id == null || id.isEmpty) {
      controller._selectedProjectId.value = '';
      return;
    }

    final project = controller._projects.firstWhereOrNull((project) => project.id == id);
    if (project != null) {
      controller._selectedProjectId.value = id;
    }
  }

  /// 获取选中的项目
  Project? getSelectedProject() {
    if (_selectedProjectId.value.isEmpty) return null;
    return _projects.firstWhereOrNull((project) => project.id == _selectedProjectId.value);
  }

  /// 获取项目统计信息
  static Future<ProjectStats> getProjectStats(String projectId) async {
    final controller = instance;

    try {
      return await controller._projectService.getProjectStats(projectId);
    } catch (error, stackTrace) {
      log('获取项目统计失败', error: error, stackTrace: stackTrace, name: 'ProjectsController');
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
  static Future<void> searchProjectsWithService(String query) async {
    final controller = instance;

    if (query.isEmpty) {
      await loadProjects();
      return;
    }

    try {
      controller._isLoading.value = true;
      final projects = await controller._projectService.searchProjects(query);
      controller._projects.assignAll(projects);
    } catch (error, stackTrace) {
      Get.snackbar('错误', '搜索项目失败: $error');
      log('搜索项目失败', error: error, stackTrace: stackTrace, name: 'ProjectsController');
    } finally {
      controller._isLoading.value = false;
    }
  }

  /// 获取最近访问的项目
  static Future<List<Project>> getRecentProjects({int limit = 10}) async {
    final controller = instance;

    try {
      return await controller._projectService.getRecentProjects('default-user', limit: limit);
    } catch (error, stackTrace) {
      log('获取最近项目失败', error: error, stackTrace: stackTrace, name: 'ProjectsController');
      return [];
    }
  }

  /// 检查项目名称是否可用
  static Future<bool> isProjectNameAvailable(String name, {String? excludeProjectId}) async {
    final controller = instance;

    try {
      return await controller._projectService.isProjectNameAvailable(name, excludeProjectId: excludeProjectId);
    } catch (error, stackTrace) {
      log('检查项目名称失败', error: error, stackTrace: stackTrace, name: 'ProjectsController');
      return false;
    }
  }

  /// 更新项目最后访问时间
  static Future<void> updateProjectLastAccessed(String projectId) async {
    final controller = instance;

    try {
      await controller._projectService.updateProjectLastAccessed(projectId, 'default-user');

      // 更新本地列表中的项目
      final index = controller._projects.indexWhere((p) => p.id == projectId);
      if (index != -1) {
        final project = controller._projects[index];
        controller._projects[index] = project.copyWith(
          lastAccessedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (error, stackTrace) {
      log('更新项目访问时间失败', error: error, stackTrace: stackTrace, name: 'ProjectsController');
    }
  }

  /// 获取项目详情
  static Future<Project?> getProject(String projectId) async {
    final controller = instance;

    try {
      return await controller._projectService.getProject(projectId);
    } catch (error, stackTrace) {
      log('获取项目详情失败', error: error, stackTrace: stackTrace, name: 'ProjectsController');
      return null;
    }
  }

  /// 检查项目是否存在
  static Future<bool> projectExists(String projectId) async {
    final controller = instance;

    try {
      return await controller._projectService.projectExists(projectId);
    } catch (error, stackTrace) {
      log('检查项目存在性失败', error: error, stackTrace: stackTrace, name: 'ProjectsController');
      return false;
    }
  }

  /// 获取预设语言列表
  static List<Language> getPresetLanguages() {
    return ProjectDataInitializer.getPresetLanguages();
  }

  /// 根据语言代码获取语言对象
  static Language? getLanguageByCode(String code) {
    return ProjectDataInitializer.getLanguageByCode(code);
  }
}
