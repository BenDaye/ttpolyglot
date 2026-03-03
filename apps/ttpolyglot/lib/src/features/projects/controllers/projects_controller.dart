import 'package:get/get.dart';
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

  // 响应式项目列表
  final _projects = <ProjectModel>[].obs;
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _searchQuery = ''.obs;
  final _selectedProjectId = Rxn<int>();

  // 分页相关状态
  final _currentPage = 1.obs;
  final _totalPage = 1.obs;
  final _pageSize = 50.obs;
  final _totalSize = 0.obs;

  // 防止重复初始化的标志
  bool _isInitialized = false;

  // Getters
  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  String get searchQuery => _searchQuery.value;
  int? get selectedProjectId => _selectedProjectId.value;

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
    // 防止重复初始化
    if (!_isInitialized) {
      _isInitialized = true;
      loadProjects();
    }
  }

  /// 加载项目列表
  static Future<void> loadProjects({bool refresh = false}) async {
    final controller = instance;

    // 如果正在加载且不是刷新操作，直接返回，防止重复请求
    if (controller._isLoading.value && !refresh) {
      return;
    }

    try {
      controller._isLoading.value = true;

      // 如果是刷新，重置页码
      if (refresh) {
        controller._currentPage.value = 1;
      }

      // 从 API 获取数据
      final apiProjects = await controller._projectApi.getProjects(
        page: controller._currentPage.value,
        limit: controller._pageSize.value,
        search: controller._searchQuery.value.isNotEmpty ? controller._searchQuery.value : null,
      );

      if (apiProjects != null) {
        LoggerUtils.info('从 API 获取 ${apiProjects.items?.length} 个项目');

        // 更新分页信息
        controller._currentPage.value = apiProjects.page;
        controller._totalPage.value = apiProjects.totalPage;
        controller._totalSize.value = apiProjects.totalSize;

        // apiProjects.items 已经是 List<ProjectModel>，直接使用
        controller._projects.assignAll(apiProjects.items ?? []);

        LoggerUtils.info('项目列表已更新，当前页: ${apiProjects.page}/${apiProjects.totalPage}');
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
    loadProjects(refresh: true);
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
  static Future<void> deleteProject(int projectId) async {
    final controller = instance;

    try {
      // 调用 API 删除项目
      final success = await controller._projectApi.deleteProject(projectId);
      if (success != true) {
        Get.snackbar('错误', '删除项目失败');
        return;
      }

      // 从本地列表中删除
      controller._projects.removeWhere((project) => project.id == projectId);

      // 如果删除的是当前选中项目，清除选中状态
      if (controller._selectedProjectId.value == projectId) {
        controller._selectedProjectId.value = null;
      }

      LoggerUtils.info('项目删除成功: $projectId');
      Get.snackbar('成功', '项目删除成功');
    } catch (error, stackTrace) {
      Get.snackbar('错误', '删除项目失败: $error');
      LoggerUtils.error('deleteProject', error: error, stackTrace: stackTrace);
    }
  }

  /// 切换项目状态
  static Future<void> toggleProjectStatus(int projectId, {required bool isActive}) async {
    final controller = instance;

    try {
      await controller._projectService.updateProjectStatus(projectId, isActive: isActive);
    } catch (error, stackTrace) {
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
    required int projectId,
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
      if (Get.isRegistered<TranslationController>(tag: projectId.toString())) {
        final translationController = Get.find<TranslationController>(tag: projectId.toString());
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
        search: controller._searchQuery.value.isNotEmpty ? controller._searchQuery.value : null,
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
    final controller = instance;
    // 刷新时，如果正在加载，等待加载完成后再执行刷新
    if (controller._isLoading.value) {
      // 等待当前加载完成
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 50));
        return controller._isLoading.value;
      });
    }
    await loadProjects(refresh: true);
  }

  /// 设置选中的项目ID
  static void setSelectedProjectId(int? id) {
    if (id == null) {
      instance._selectedProjectId.value = null;
      return;
    }

    final project = instance._projects.firstWhereOrNull((project) => project.id == id);
    if (project != null) {
      instance._selectedProjectId.value = id;
    }
  }

  /// 获取选中的项目
  ProjectModel? getSelectedProject() {
    if (_selectedProjectId.value == null) return null;
    return _projects.firstWhereOrNull((project) => project.id == _selectedProjectId.value);
  }

  /// 获取项目统计信息
  static Future<ProjectStatisticsModel?> getProjectStats(int projectId) async {
    try {
      return await instance._projectService.getProjectStats(projectId);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目统计失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 获取项目详情
  static Future<ProjectModel?> getProject(int projectId) async {
    try {
      final cachedProject = instance._projects.firstWhereOrNull((project) => project.id == projectId);
      if (cachedProject != null) {
        return cachedProject;
      }

      final apiProject = await instance._projectApi.getProject(projectId);
      if (apiProject != null) {
        return apiProject;
      }

      return null;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目详情失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 检查项目是否存在
  static Future<bool> projectExists(int projectId) async {
    try {
      return await instance._projectApi.getProject(projectId) != null;
    } catch (error, stackTrace) {
      LoggerUtils.error('检查项目存在性失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }
}
