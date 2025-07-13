import '../models/project.dart';
import '../models/user.dart';
import '../models/workspace_config.dart';
import 'storage_service.dart';

/// 工作空间管理服务接口
abstract class WorkspaceService {
  /// 初始化工作空间
  Future<WorkspaceConfig> initializeWorkspace(InitializeWorkspaceRequest request);

  /// 获取工作空间配置
  Future<WorkspaceConfig?> getWorkspaceConfig();

  /// 更新工作空间配置
  Future<WorkspaceConfig> updateWorkspaceConfig(WorkspaceConfig config);

  /// 设置当前项目
  Future<void> setCurrentProject(String projectId);

  /// 获取当前项目
  Future<Project?> getCurrentProject();

  /// 添加项目引用
  Future<void> addProjectReference(ProjectReference reference);

  /// 移除项目引用
  Future<void> removeProjectReference(String projectId);

  /// 获取所有项目引用
  Future<List<ProjectReference>> getProjectReferences();

  /// 获取最近访问的项目引用
  Future<List<ProjectReference>> getRecentProjectReferences({int limit = 10});

  /// 更新项目最后访问时间
  Future<void> updateProjectLastAccessed(String projectId);

  /// 检查工作空间是否已初始化
  Future<bool> isWorkspaceInitialized();

  /// 获取工作空间根目录
  Future<String> getWorkspaceRoot();

  /// 获取项目配置目录
  Future<String> getProjectConfigDirectory(String projectId);

  /// 清理工作空间
  Future<void> cleanupWorkspace();

  /// 备份工作空间配置
  Future<void> backupWorkspaceConfig();

  /// 恢复工作空间配置
  Future<void> restoreWorkspaceConfig(String backupPath);

  /// 迁移工作空间配置
  Future<void> migrateWorkspaceConfig(String fromVersion, String toVersion);

  /// 设置存储服务
  void setStorageService(StorageService storageService);

  /// 获取存储服务
  StorageService getStorageService();

  /// 获取存储类型
  StorageType getStorageType();

  /// 切换存储类型
  Future<void> switchStorageType(StorageType newType);
}

/// 初始化工作空间请求
class InitializeWorkspaceRequest {
  const InitializeWorkspaceRequest({
    required this.user,
    this.workspaceRoot,
    this.preferences = const WorkspacePreferences(),
  });

  /// 用户信息
  final User user;

  /// 工作空间根目录
  final String? workspaceRoot;

  /// 用户偏好设置
  final WorkspacePreferences preferences;
}

/// 工作空间状态
class WorkspaceStatus {
  const WorkspaceStatus({
    required this.isInitialized,
    required this.version,
    required this.projectCount,
    required this.currentProject,
    required this.lastAccessed,
  });

  /// 是否已初始化
  final bool isInitialized;

  /// 配置版本
  final String version;

  /// 项目数量
  final int projectCount;

  /// 当前项目
  final Project? currentProject;

  /// 最后访问时间
  final DateTime lastAccessed;

  Map<String, dynamic> toJson() {
    return {
      'isInitialized': isInitialized,
      'version': version,
      'projectCount': projectCount,
      'currentProject': currentProject?.toJson(),
      'lastAccessed': lastAccessed.toIso8601String(),
    };
  }

  factory WorkspaceStatus.fromJson(Map<String, dynamic> json) {
    return WorkspaceStatus(
      isInitialized: json['isInitialized'] as bool,
      version: json['version'] as String,
      projectCount: json['projectCount'] as int,
      currentProject:
          json['currentProject'] != null ? Project.fromJson(json['currentProject'] as Map<String, dynamic>) : null,
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
    );
  }
}
