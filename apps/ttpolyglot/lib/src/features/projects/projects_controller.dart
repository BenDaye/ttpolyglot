import 'package:get/get.dart';

/// 项目信息模型
class ProjectModel {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int translationCount;
  final List<String> languages;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.translationCount,
    required this.languages,
  });
}

/// 项目管理控制器
class ProjectsController extends GetxController {
  // 响应式项目列表
  final _projects = <ProjectModel>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedProjectId = ''.obs;

  // Getters
  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  String get selectedProjectId => _selectedProjectId.value;

  // 过滤后的项目列表
  List<ProjectModel> get filteredProjects {
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
    loadProjects();
  }

  /// 加载项目列表
  Future<void> loadProjects() async {
    _isLoading.value = true;

    try {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));

      // 模拟数据
      _projects.assignAll([
        ProjectModel(
          id: '1',
          name: 'Flutter App',
          description: '一个跨平台的移动应用项目',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
          translationCount: 156,
          languages: ['zh_CN', 'en_US', 'ja_JP'],
        ),
        ProjectModel(
          id: '2',
          name: 'Web Dashboard',
          description: '管理后台系统',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          translationCount: 89,
          languages: ['zh_CN', 'en_US'],
        ),
        ProjectModel(
          id: '3',
          name: 'API Documentation',
          description: 'REST API 文档项目',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          updatedAt: DateTime.now(),
          translationCount: 234,
          languages: ['zh_CN', 'en_US', 'fr_FR', 'de_DE'],
        ),
      ]);
    } catch (e) {
      Get.snackbar('错误', '加载项目失败: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// 搜索项目
  void searchProjects(String query) {
    _searchQuery.value = query;
  }

  /// 创建新项目
  Future<void> createProject(String name, String description) async {
    _isLoading.value = true;

    try {
      // 模拟网络请求
      await Future.delayed(const Duration(milliseconds: 500));

      final newProject = ProjectModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        translationCount: 0,
        languages: ['zh_CN'],
      );

      _projects.add(newProject);
      Get.snackbar('成功', '项目创建成功');
    } catch (e) {
      Get.snackbar('错误', '创建项目失败: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// 删除项目
  Future<void> deleteProject(String id) async {
    try {
      // 模拟网络请求
      await Future.delayed(const Duration(milliseconds: 300));

      _projects.removeWhere((project) => project.id == id);
      Get.snackbar('成功', '项目删除成功');
    } catch (e) {
      Get.snackbar('错误', '删除项目失败: $e');
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
    }
  }
}
