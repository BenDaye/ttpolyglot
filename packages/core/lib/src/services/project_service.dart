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
  Future<Project> toggleProjectStatus(String projectId, bool isActive);

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
    required this.userId,
    required this.projectId,
    required this.role,
    required this.canRead,
    required this.canWrite,
    required this.canDelete,
    required this.canManageMembers,
  });

  final String userId;
  final String projectId;
  final ProjectRole role;
  final bool canRead;
  final bool canWrite;
  final bool canDelete;
  final bool canManageMembers;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'projectId': projectId,
      'role': role.name,
      'canRead': canRead,
      'canWrite': canWrite,
      'canDelete': canDelete,
      'canManageMembers': canManageMembers,
    };
  }

  factory ProjectPermission.fromJson(Map<String, dynamic> json) {
    return ProjectPermission(
      userId: json['userId'] as String,
      projectId: json['projectId'] as String,
      role: ProjectRole.values.byName(json['role'] as String),
      canRead: json['canRead'] as bool,
      canWrite: json['canWrite'] as bool,
      canDelete: json['canDelete'] as bool,
      canManageMembers: json['canManageMembers'] as bool,
    );
  }
}

/// 项目成员
class ProjectMember {
  const ProjectMember({
    required this.user,
    required this.role,
    required this.joinedAt,
    this.lastActiveAt,
  });

  final User user;
  final ProjectRole role;
  final DateTime joinedAt;
  final DateTime? lastActiveAt;

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'role': role.name,
      'joinedAt': joinedAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

  factory ProjectMember.fromJson(Map<String, dynamic> json) {
    return ProjectMember(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      role: ProjectRole.values.byName(json['role'] as String),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      lastActiveAt: json['lastActiveAt'] != null ? DateTime.parse(json['lastActiveAt'] as String) : null,
    );
  }
}

/// 项目角色枚举
enum ProjectRole {
  /// 项目所有者
  owner,

  /// 项目管理员
  admin,

  /// 翻译员
  translator,

  /// 审核员
  reviewer,

  /// 只读成员
  viewer,
}

/// 项目角色扩展
extension ProjectRoleExtension on ProjectRole {
  /// 获取角色的中文显示名称
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
        return '只读成员';
    }
  }

  /// 获取角色权限级别
  int get level {
    switch (this) {
      case ProjectRole.owner:
        return 100;
      case ProjectRole.admin:
        return 80;
      case ProjectRole.translator:
        return 60;
      case ProjectRole.reviewer:
        return 40;
      case ProjectRole.viewer:
        return 20;
    }
  }

  /// 是否可以读取
  bool get canRead => true;

  /// 是否可以写入
  bool get canWrite => level >= ProjectRole.translator.level;

  /// 是否可以删除
  bool get canDelete => level >= ProjectRole.admin.level;

  /// 是否可以管理成员
  bool get canManageMembers => level >= ProjectRole.admin.level;

  /// 是否可以管理项目设置
  bool get canManageProject => level >= ProjectRole.admin.level;

  /// 是否可以删除项目
  bool get canDeleteProject => this == ProjectRole.owner;
}
