import 'package:ttpolyglot_model/model.dart';

/// 项目服务抽象接口
abstract class ProjectService {
  /// 创建项目
  Future<ProjectModel> createProject(CreateProjectRequest request);

  /// 获取项目
  Future<ProjectModel?> getProject(String projectId);

  /// 获取用户的所有项目
  Future<List<ProjectModel>> getUserProjects(String userId);

  /// 获取所有项目（支持分页、搜索、过滤）
  Future<List<ProjectModel>> getAllProjects({
    int? limit,
    int? offset,
    String? search,
    bool? isActive,
  });

  /// 更新项目
  Future<ProjectModel> updateProject(String projectId, UpdateProjectRequest request);

  /// 删除项目
  Future<void> deleteProject(String projectId);

  /// 切换项目状态（激活/停用）
  Future<ProjectModel> toggleProjectStatus(String projectId, {required bool isActive});

  /// 检查项目是否存在
  Future<bool> projectExists(String projectId);

  /// 检查项目名称是否可用
  Future<bool> isProjectNameAvailable(String name, {String? excludeProjectId});

  /// 获取项目统计信息
  Future<ProjectStats> getProjectStats(String projectId);

  /// 搜索项目
  Future<List<ProjectModel>> searchProjects(
    String query, {
    String? userId,
    bool? isActive,
  });

  /// 获取最近访问的项目
  Future<List<ProjectModel>> getRecentProjects(String userId, {int limit = 10});

  /// 更新项目最后访问时间
  Future<void> updateProjectLastAccessed(String projectId, String userId);

  /// 获取用户对项目的权限
  Future<ProjectPermission> getUserProjectPermission(String userId, String projectId);

  /// 添加项目成员
  Future<void> addProjectMember(String projectId, String userId, ProjectRole role);

  /// 移除项目成员
  Future<void> removeProjectMember(String projectId, String userId);

  /// 更新项目成员角色
  Future<void> updateProjectMemberRole(String projectId, String userId, ProjectRole role);

  /// 获取项目成员列表
  Future<List<ProjectMember>> getProjectMembers(String projectId);

  /// 复制项目
  Future<ProjectModel> duplicateProject(String sourceProjectId, String newName);

  /// 导出项目配置
  Future<Map<String, dynamic>> exportProjectConfig(String projectId);

  /// 导入项目配置
  Future<ProjectModel> importProjectConfig(Map<String, dynamic> config);

  /// 获取支持的语言列表
  Future<List<LanguageEnum>> getSupportedLanguages();

  /// 搜索支持的语言
  Future<List<LanguageEnum>> searchSupportedLanguages(String query);

  /// 按组获取支持的语言
  Future<Map<String, List<LanguageEnum>>> getSupportedLanguagesByGroup();

  /// 验证语言是否支持
  Future<bool> validateLanguageSupport(String languageCode);

  /// 批量验证语言是否支持
  Future<Map<String, bool>> validateMultipleLanguagesSupport(List<String> languageCodes);
}
