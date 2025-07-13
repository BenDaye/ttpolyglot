import 'package:equatable/equatable.dart';

import 'user.dart';

/// 工作空间配置
class WorkspaceConfig extends Equatable {
  const WorkspaceConfig({
    required this.version,
    required this.user,
    this.currentProjectId,
    this.preferences = const WorkspacePreferences(),
    this.recentProjects = const [],
    this.createdAt,
    this.updatedAt,
  });

  /// 配置版本
  final String version;

  /// 当前用户
  final User user;

  /// 当前选中的项目ID
  final String? currentProjectId;

  /// 用户偏好设置
  final WorkspacePreferences preferences;

  /// 最近访问的项目ID列表
  final List<String> recentProjects;

  /// 创建时间
  final DateTime? createdAt;

  /// 更新时间
  final DateTime? updatedAt;

  /// 复制并更新配置
  WorkspaceConfig copyWith({
    String? version,
    User? user,
    String? currentProjectId,
    WorkspacePreferences? preferences,
    List<String>? recentProjects,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkspaceConfig(
      version: version ?? this.version,
      user: user ?? this.user,
      currentProjectId: currentProjectId ?? this.currentProjectId,
      preferences: preferences ?? this.preferences,
      recentProjects: recentProjects ?? this.recentProjects,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'user': user.toJson(),
      'currentProjectId': currentProjectId,
      'preferences': preferences.toJson(),
      'recentProjects': recentProjects,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// 从 JSON 创建
  factory WorkspaceConfig.fromJson(Map<String, dynamic> json) {
    return WorkspaceConfig(
      version: json['version'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      currentProjectId: json['currentProjectId'] as String?,
      preferences: json['preferences'] != null
          ? WorkspacePreferences.fromJson(json['preferences'] as Map<String, dynamic>)
          : const WorkspacePreferences(),
      recentProjects: (json['recentProjects'] as List<dynamic>?)?.map((id) => id as String).toList() ?? const [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  @override
  List<Object?> get props => [
        version,
        user,
        currentProjectId,
        preferences,
        recentProjects,
        createdAt,
        updatedAt,
      ];
}

/// 工作空间用户偏好设置
class WorkspacePreferences extends Equatable {
  const WorkspacePreferences({
    this.defaultLanguage = 'en',
    this.theme = 'auto',
    this.autoSync = true,
    this.showCompletionRate = true,
    this.maxRecentProjects = 10,
    this.customSettings = const {},
  });

  /// 默认语言
  final String defaultLanguage;

  /// 主题设置
  final String theme;

  /// 是否自动同步
  final bool autoSync;

  /// 是否显示完成率
  final bool showCompletionRate;

  /// 最大最近项目数量
  final int maxRecentProjects;

  /// 自定义设置
  final Map<String, dynamic> customSettings;

  /// 复制并更新偏好设置
  WorkspacePreferences copyWith({
    String? defaultLanguage,
    String? theme,
    bool? autoSync,
    bool? showCompletionRate,
    int? maxRecentProjects,
    Map<String, dynamic>? customSettings,
  }) {
    return WorkspacePreferences(
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      theme: theme ?? this.theme,
      autoSync: autoSync ?? this.autoSync,
      showCompletionRate: showCompletionRate ?? this.showCompletionRate,
      maxRecentProjects: maxRecentProjects ?? this.maxRecentProjects,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'defaultLanguage': defaultLanguage,
      'theme': theme,
      'autoSync': autoSync,
      'showCompletionRate': showCompletionRate,
      'maxRecentProjects': maxRecentProjects,
      'customSettings': customSettings,
    };
  }

  /// 从 JSON 创建
  factory WorkspacePreferences.fromJson(Map<String, dynamic> json) {
    return WorkspacePreferences(
      defaultLanguage: json['defaultLanguage'] as String? ?? 'en',
      theme: json['theme'] as String? ?? 'auto',
      autoSync: json['autoSync'] as bool? ?? true,
      showCompletionRate: json['showCompletionRate'] as bool? ?? true,
      maxRecentProjects: json['maxRecentProjects'] as int? ?? 10,
      customSettings: json['customSettings'] as Map<String, dynamic>? ?? const {},
    );
  }

  @override
  List<Object?> get props => [
        defaultLanguage,
        theme,
        autoSync,
        showCompletionRate,
        maxRecentProjects,
        customSettings,
      ];
}

/// 项目引用信息
class ProjectReference extends Equatable {
  const ProjectReference({
    required this.id,
    required this.name,
    required this.path,
    required this.lastAccessed,
    this.isActive = true,
  });

  /// 项目ID
  final String id;

  /// 项目名称
  final String name;

  /// 项目路径
  final String path;

  /// 最后访问时间
  final DateTime lastAccessed;

  /// 是否激活
  final bool isActive;

  /// 复制并更新项目引用
  ProjectReference copyWith({
    String? id,
    String? name,
    String? path,
    DateTime? lastAccessed,
    bool? isActive,
  }) {
    return ProjectReference(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      isActive: isActive ?? this.isActive,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
      'lastAccessed': lastAccessed.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// 从 JSON 创建
  factory ProjectReference.fromJson(Map<String, dynamic> json) {
    return ProjectReference(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [id, name, path, lastAccessed, isActive];
}
