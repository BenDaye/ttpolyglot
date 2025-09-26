/// 角色模型
class Role {
  final String id;
  final String name;
  final String displayName;
  final String? description;
  final bool isSystem;
  final bool isActive;
  final int priority;
  final List<String>? permissionsCache;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Role({
    required this.id,
    required this.name,
    required this.displayName,
    this.description,
    this.isSystem = false,
    this.isActive = true,
    this.priority = 0,
    this.permissionsCache,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从数据库行创建角色对象
  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map['id'] as String,
      name: map['name'] as String,
      displayName: map['display_name'] as String,
      description: map['description'] as String?,
      isSystem: map['is_system'] as bool? ?? false,
      isActive: map['is_active'] as bool? ?? true,
      priority: map['priority'] as int? ?? 0,
      permissionsCache: (map['permissions_cache'] as String?)?.split(','),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// 转换为Map用于API响应
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'description': description,
      'is_system': isSystem,
      'is_active': isActive,
      'priority': priority,
      'permissions_cache': permissionsCache,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 创建角色副本
  Role copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    bool? isSystem,
    bool? isActive,
    int? priority,
    List<String>? permissionsCache,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      isSystem: isSystem ?? this.isSystem,
      isActive: isActive ?? this.isActive,
      priority: priority ?? this.priority,
      permissionsCache: permissionsCache ?? this.permissionsCache,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 检查角色是否有特定权限
  bool hasPermission(String permissionName) {
    if (permissionsCache == null) return false;
    return permissionsCache!.contains(permissionName);
  }

  @override
  String toString() {
    return 'Role(name: $name, displayName: $displayName, isSystem: $isSystem, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Role && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 系统预定义角色
class SystemRoles {
  static const String superAdmin = 'super_admin';
  static const String projectOwner = 'project_owner';
  static const String projectManager = 'project_manager';
  static const String translator = 'translator';
  static const String reviewer = 'reviewer';
  static const String viewer = 'viewer';

  static const Map<String, String> displayNames = {
    superAdmin: '超级管理员',
    projectOwner: '项目所有者',
    projectManager: '项目管理员',
    translator: '翻译员',
    reviewer: '审核员',
    viewer: '查看者',
  };

  static const Map<String, String> descriptions = {
    superAdmin: '拥有系统所有权限',
    projectOwner: '拥有其创建或被授予的项目所有权限',
    projectManager: '管理项目成员、翻译流程等',
    translator: '负责翻译条目',
    reviewer: '负责审核翻译条目',
    viewer: '只能查看项目和翻译内容',
  };

  static const Map<String, int> priorities = {
    superAdmin: 100,
    projectOwner: 90,
    projectManager: 80,
    reviewer: 60,
    translator: 50,
    viewer: 10,
  };
}
