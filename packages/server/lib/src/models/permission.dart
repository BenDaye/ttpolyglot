/// 权限模型
class Permission {
  final String id;
  final String name;
  final String displayName;
  final String? description;
  final String resource;
  final String action;
  final String scope;
  final bool isActive;
  final DateTime createdAt;

  const Permission({
    required this.id,
    required this.name,
    required this.displayName,
    this.description,
    required this.resource,
    required this.action,
    this.scope = 'project',
    this.isActive = true,
    required this.createdAt,
  });

  /// 从数据库行创建权限对象
  factory Permission.fromMap(Map<String, dynamic> map) {
    return Permission(
      id: map['id'] as String,
      name: map['name'] as String,
      displayName: map['display_name'] as String,
      description: map['description'] as String?,
      resource: map['resource'] as String,
      action: map['action'] as String,
      scope: map['scope'] as String? ?? 'project',
      isActive: map['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// 转换为Map用于API响应
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'description': description,
      'resource': resource,
      'action': action,
      'scope': scope,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// 创建权限副本
  Permission copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    String? resource,
    String? action,
    String? scope,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Permission(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      resource: resource ?? this.resource,
      action: action ?? this.action,
      scope: scope ?? this.scope,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 检查权限是否匹配
  bool matches({
    String? resource,
    String? action,
    String? scope,
  }) {
    if (resource != null && this.resource != resource) return false;
    if (action != null && this.action != action) return false;
    if (scope != null && this.scope != scope) return false;
    return true;
  }

  @override
  String toString() {
    return 'Permission(name: $name, resource: $resource, action: $action, scope: $scope)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Permission && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 权限作用域枚举
enum PermissionScope {
  global('global'),
  project('project'),
  resource('resource');

  const PermissionScope(this.value);
  final String value;

  static PermissionScope fromString(String value) {
    return PermissionScope.values.firstWhere(
      (scope) => scope.value == value,
      orElse: () => PermissionScope.project,
    );
  }
}

/// 权限资源枚举
enum PermissionResource {
  project('project'),
  translation('translation'),
  user('user'),
  system('system'),
  config('config'),
  provider('provider');

  const PermissionResource(this.value);
  final String value;

  static PermissionResource fromString(String value) {
    return PermissionResource.values.firstWhere(
      (resource) => resource.value == value,
      orElse: () => PermissionResource.project,
    );
  }
}

/// 权限操作枚举
enum PermissionAction {
  create('create'),
  read('read'),
  update('update'),
  delete('delete'),
  manage('manage'),
  approve('approve'),
  review('review');

  const PermissionAction(this.value);
  final String value;

  static PermissionAction fromString(String value) {
    return PermissionAction.values.firstWhere(
      (action) => action.value == value,
      orElse: () => PermissionAction.read,
    );
  }
}
