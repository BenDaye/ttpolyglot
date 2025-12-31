import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:ttpolyglot/src/features/features.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 项目管理控制器
class ProjectsController extends GetxController {
  static ProjectsController get instance {
    return Get.isRegistered<ProjectsController>() ? Get.find<ProjectsController>() : Get.put(ProjectsController());
  }

  final ProjectServiceImpl _projectService = Get.find<ProjectServiceImpl>();
  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();
  final ProjectApi _projectApi = Get.find<ProjectApi>();
  late final ProjectCacheService _cacheService;

  // 响应式项目列表
  final _projects = <ProjectModel>[].obs;
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _searchQuery = ''.obs;
  final _selectedProjectId = ''.obs;

  // 分页相关状态
  final _currentPage = 1.obs;
  final _totalPage = 1.obs;
  final _pageSize = 50.obs;
  final _totalSize = 0.obs;

  // Getters
  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  String get searchQuery => _searchQuery.value;
  String get selectedProjectId => _selectedProjectId.value;

  // 分页信息 Getters
  int get currentPage => _currentPage.value;
  int get totalPage => _totalPage.value;
  int get totalSize => _totalSize.value;
  bool get hasNextPage => _currentPage.value < _totalPage.value;

  // 过滤后的项目列表
  List<ProjectModel> get filteredProjects {
    if (_searchQuery.value.isEmpty) {
      return _projects;
    }
    return _projects.where((project) {
      return project.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
          (project.description?.toLowerCase().contains(_searchQuery.value.toLowerCase()) ?? false);
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
      // 初始化缓存服务
      final prefs = await SharedPreferences.getInstance();
      _cacheService = ProjectCacheService(prefs);

      await loadProjects();
    } catch (error, stackTrace) {
      Get.snackbar('错误', '初始化项目服务失败: $error');
      LoggerUtils.error('初始化项目服务失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 加载项目列表（缓存优先策略）
  static Future<void> loadProjects({bool refresh = false}) async {
    final controller = instance;

    try {
      controller._isLoading.value = true;

      // 如果是刷新，重置页码
      if (refresh) {
        controller._currentPage.value = 1;
      }

      // 第一步：先尝试从缓存加载（仅第一页时）
      if (controller._currentPage.value == 1) {
        final cachedProjects = await controller._cacheService.getCachedProjects();
        if (cachedProjects != null && cachedProjects.isNotEmpty) {
          LoggerUtils.info('从缓存加载 ${cachedProjects.length} 个项目');
          // cachedProjects 已经是 List<ProjectModel>，直接使用
          controller._projects.assignAll(cachedProjects);
          controller._isLoading.value = false;
        }
      }

      // 第二步：从 API 获取第一页数据
      try {
        final apiProjects = await controller._projectApi.getProjects(
          page: 1,
          limit: controller._pageSize.value,
        );

        if (apiProjects != null) {
          LoggerUtils.info('从 API 获取 ${apiProjects.items?.length} 个项目');

          // 更新分页信息
          controller._currentPage.value = apiProjects.page;
          controller._totalPage.value = apiProjects.totalPage;
          controller._totalSize.value = apiProjects.totalSize;

          // 更新缓存
          await controller._cacheService.cacheProjects(apiProjects.items ?? []);

          // apiProjects.items 已经是 List<ProjectModel>，直接使用
          controller._projects.assignAll(apiProjects.items ?? []);

          LoggerUtils.info('项目列表已更新并缓存，当前页: ${apiProjects.page}/${apiProjects.totalPage}');
        }
      } catch (apiError, apiStackTrace) {
        LoggerUtils.error('从 API 加载项目失败', error: apiError, stackTrace: apiStackTrace);
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('[loadProjects]', error: error, stackTrace: stackTrace, name: 'ProjectsController');
    } finally {
      controller._isLoading.value = false;
    }
  }

  /// 搜索项目
  void searchProjects(String query) {
    _searchQuery.value = query;
  }

  /// 项目创建现在通过 API 完成，在 ProjectDialogController 中处理
  @Deprecated('Use ProjectDialogController.showCreateDialog() instead')
  static Future<void> createProject({
    required String name,
    required String description,
    required LanguageEnum primaryLanguage,
    required List<LanguageEnum> targetLanguages,
  }) async {
    // 刷新项目列表以获取最新数据
    await loadProjects();
  }

  /// 项目更新现在通过 API 完成，在 ProjectDialogController 中处理
  @Deprecated('Use ProjectDialogController.showEditDialog() instead')
  static Future<void> updateProject(
    String projectId, {
    String? name,
    String? description,
    LanguageEnum? defaultLanguage,
    List<LanguageEnum>? targetLanguages,
    bool? isActive,
  }) async {
    // 刷新项目列表以获取最新数据
    await loadProjects();
  }

  /// 删除项目
  static Future<void> deleteProject(String projectId) async {
    final controller = instance;

    try {
      // 转换项目 ID 为 int
      final projectIdInt = int.parse(projectId);

      // 调用 API 删除项目
      await controller._projectApi.deleteProject(projectIdInt);

      // 从缓存中删除
      await controller._cacheService.removeCachedProject(projectIdInt);

      // 从本地列表中删除
      controller._projects.removeWhere((project) => project.id.toString() == projectId);

      // 如果删除的是当前选中项目，清除选中状态
      if (controller._selectedProjectId.value == projectId) {
        controller._selectedProjectId.value = '';
      }

      LoggerUtils.info('项目删除成功: $projectId');
      Get.snackbar('成功', '项目删除成功');
    } catch (error, stackTrace) {
      Get.snackbar('错误', '删除项目失败: $error');
      LoggerUtils.error('deleteProject', error: error, stackTrace: stackTrace);
    }
  }

  /// 切换项目状态
  static Future<void> toggleProjectStatus(String projectId, {required bool isActive}) async {
    final controller = instance;

    try {
      final updatedProject = await controller._projectService.toggleProjectStatus(projectId, isActive: isActive);

      // 更新本地列表
      final index = controller._projects.indexWhere((p) => p.id.toString() == projectId);
      if (index != -1) {
        controller._projects[index] = updatedProject;
      }

      final status = isActive ? '激活' : '停用';
      Get.snackbar('成功', '项目$status成功');
    } catch (error, stackTrace) {
      Get.snackbar('错误', '切换项目状态失败: $error');
      LoggerUtils.error('toggleProjectStatus', error: error, stackTrace: stackTrace);
    }
  }

  /// 检查语言配置是否发生变化
  static bool hasLanguageConfigChanged(
    ProjectModel currentProject,
    LanguageEnum? newPrimaryLanguage,
    List<LanguageEnum>? newTargetLanguages,
  ) {
    // 检查默认语言是否变化
    if (newPrimaryLanguage != null && currentProject.primaryLanguage.code != newPrimaryLanguage) {
      return true;
    }

    // 检查目标语言是否变化
    if (newTargetLanguages != null) {
      // 获取当前项目的目标语言（除主语言外的所有语言）
      final currentTargetLanguages =
          currentProject.languages.where((lang) => lang.id != currentProject.primaryLanguageId).toList();
      final currentCodes = currentTargetLanguages.map((lang) => lang.code).toSet();
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
    required LanguageEnum sourceLanguage,
    required List<LanguageEnum> targetLanguages,
    required String projectId,
  }) async {
    try {
      LoggerUtils.info('开始同步项目语言配置到翻译条目');

      final controller = instance;
      final translationService = controller._translationService;

      await translationService.syncProjectLanguages(
        projectId,
        sourceLanguage,
        targetLanguages,
      );

      LoggerUtils.info('项目语言配置同步完成');

      // 通知翻译控制器刷新数据
      if (Get.isRegistered<TranslationController>(tag: projectId)) {
        final translationController = Get.find<TranslationController>(tag: projectId);
        await translationController.onProjectLanguageChanged();
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('同步翻译条目语言配置失败', error: error, stackTrace: stackTrace);
      // 不抛出异常，避免影响项目更新
    }
  }

  /// 加载更多项目
  static Future<void> loadMoreProjects() async {
    final controller = instance;

    // 如果已在加载或没有下一页，直接返回
    if (controller._isLoadingMore.value || !controller.hasNextPage) {
      return;
    }

    try {
      controller._isLoadingMore.value = true;

      final nextPage = controller._currentPage.value + 1;
      LoggerUtils.info('加载更多项目，页码: $nextPage');

      final apiProjects = await controller._projectApi.getProjects(
        page: nextPage,
        limit: controller._pageSize.value,
      );

      if (apiProjects != null && apiProjects.items != null) {
        // 更新分页信息
        controller._currentPage.value = apiProjects.page;
        controller._totalPage.value = apiProjects.totalPage;
        controller._totalSize.value = apiProjects.totalSize;

        // 将新数据追加到现有列表（apiProjects.items 已经是 List<ProjectModel>）
        controller._projects.addAll(apiProjects.items!);

        LoggerUtils.info('加载了 ${apiProjects.items!.length} 个项目，当前页: ${apiProjects.page}/${apiProjects.totalPage}');
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('[loadMoreProjects]', error: error, stackTrace: stackTrace, name: 'ProjectsController');
    } finally {
      controller._isLoadingMore.value = false;
    }
  }

  /// 刷新项目列表
  static Future<void> refreshProjects() async {
    await loadProjects(refresh: true);
  }

  /// 设置选中的项目ID
  static void setSelectedProjectId(String? id) {
    final controller = instance;

    if (id == null || id.isEmpty) {
      controller._selectedProjectId.value = '';
      return;
    }

    final project = controller._projects.firstWhereOrNull((project) => project.id.toString() == id);
    if (project != null) {
      controller._selectedProjectId.value = id;
    }
  }

  /// 获取选中的项目
  ProjectModel? getSelectedProject() {
    if (_selectedProjectId.value.isEmpty) return null;
    return _projects.firstWhereOrNull((project) => project.id.toString() == _selectedProjectId.value);
  }

  /// 获取项目统计信息
  static Future<ProjectStatisticsModel?> getProjectStats(String projectId) async {
    final controller = instance;

    try {
      return await controller._projectService.getProjectStats(projectId);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目统计失败', error: error, stackTrace: stackTrace);
      return null;
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

      // 重置分页状态，因为搜索结果不支持分页
      controller._currentPage.value = 1;
      controller._totalPage.value = 1;
      controller._totalSize.value = projects.length;
    } catch (error, stackTrace) {
      Get.snackbar('错误', '搜索项目失败: $error');
      LoggerUtils.error('搜索项目失败', error: error, stackTrace: stackTrace);
    } finally {
      controller._isLoading.value = false;
    }
  }

  /// 获取最近访问的项目
  static Future<List<ProjectModel>> getRecentProjects({int limit = 10}) async {
    final controller = instance;

    try {
      return await controller._projectService.getRecentProjects('default-user', limit: limit);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取最近项目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  /// 检查项目名称是否可用
  static Future<bool> isProjectNameAvailable(String name, {String? excludeProjectId}) async {
    final controller = instance;

    try {
      return await controller._projectService.isProjectNameAvailable(name, excludeProjectId: excludeProjectId);
    } catch (error, stackTrace) {
      LoggerUtils.error('检查项目名称失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 更新项目最后访问时间
  static Future<void> updateProjectLastAccessed(String projectId) async {
    final controller = instance;

    try {
      await controller._projectService.updateProjectLastAccessed(projectId, 'default-user');

      // 更新本地列表中的项目
      final index = controller._projects.indexWhere((p) => p.id.toString() == projectId);
      if (index != -1) {
        final project = controller._projects[index];
        controller._projects[index] = project.copyWith(
          lastActivityAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('更新项目访问时间失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 获取项目详情
  static Future<ProjectModel?> getProject(String projectId) async {
    final controller = instance;

    try {
      final cachedProject = controller._projects.firstWhereOrNull((project) => project.id.toString() == projectId);
      if (cachedProject != null) {
        return cachedProject;
      }

      final storageProject = await controller._projectService.getProject(projectId);
      if (storageProject != null) {
        _cacheProjectLocally(controller, storageProject);
        return storageProject;
      }

      final projectIdInt = int.tryParse(projectId);
      if (projectIdInt != null) {
        final apiProject = await controller._projectApi.getProject(projectIdInt);
        if (apiProject != null) {
          // apiProject 已经是 ProjectModel，直接使用
          _cacheProjectLocally(controller, apiProject);
          return apiProject;
        }
      }

      return null;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目详情失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  static void _cacheProjectLocally(ProjectsController controller, ProjectModel project) {
    final index = controller._projects.indexWhere((item) => item.id == project.id);
    if (index != -1) {
      controller._projects[index] = project;
    } else {
      controller._projects.add(project);
    }
  }

  /// 检查项目是否存在
  static Future<bool> projectExists(String projectId) async {
    final controller = instance;

    try {
      return await controller._projectService.projectExists(projectId);
    } catch (error, stackTrace) {
      LoggerUtils.error('检查项目存在性失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 获取预设语言列表
  static List<LanguageEnum> getPresetLanguages() {
    return ProjectDataInitializer.getPresetLanguages();
  }

  /// 根据语言代码获取语言对象
  static LanguageEnum? getLanguageByCode(String code) {
    return ProjectDataInitializer.getLanguageByCode(code);
  }
}
