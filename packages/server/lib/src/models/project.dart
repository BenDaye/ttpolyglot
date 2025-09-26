/// 项目模型
class Project {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String ownerId;
  final String primaryLanguageCode;
  final Map<String, dynamic>? settings;
  final String status;
  final String visibility;
  final int totalKeys;
  final int translatedKeys;
  final int languagesCount;
  final int membersCount;
  final DateTime? lastActivityAt;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Project({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.ownerId,
    required this.primaryLanguageCode,
    this.settings,
    this.status = 'active',
    this.visibility = 'private',
    this.totalKeys = 0,
    this.translatedKeys = 0,
    this.languagesCount = 0,
    this.membersCount = 1,
    this.lastActivityAt,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从数据库行创建项目对象
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String,
      name: map['name'] as String,
      slug: map['slug'] as String,
      description: map['description'] as String?,
      ownerId: map['owner_id'] as String,
      primaryLanguageCode: map['primary_language_code'] as String,
      settings: map['settings'] as Map<String, dynamic>?,
      status: map['status'] as String? ?? 'active',
      visibility: map['visibility'] as String? ?? 'private',
      totalKeys: map['total_keys'] as int? ?? 0,
      translatedKeys: map['translated_keys'] as int? ?? 0,
      languagesCount: map['languages_count'] as int? ?? 0,
      membersCount: map['members_count'] as int? ?? 1,
      lastActivityAt: map['last_activity_at'] != null ? DateTime.parse(map['last_activity_at'] as String) : null,
      archivedAt: map['archived_at'] != null ? DateTime.parse(map['archived_at'] as String) : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// 转换为Map用于API响应
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'owner_id': ownerId,
      'primary_language_code': primaryLanguageCode,
      'settings': settings,
      'status': status,
      'visibility': visibility,
      'total_keys': totalKeys,
      'translated_keys': translatedKeys,
      'languages_count': languagesCount,
      'members_count': membersCount,
      'completion_percentage': totalKeys > 0 ? (translatedKeys / totalKeys * 100).round() : 0,
      'last_activity_at': lastActivityAt?.toIso8601String(),
      'archived_at': archivedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 创建项目副本
  Project copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? ownerId,
    String? primaryLanguageCode,
    Map<String, dynamic>? settings,
    String? status,
    String? visibility,
    int? totalKeys,
    int? translatedKeys,
    int? languagesCount,
    int? membersCount,
    DateTime? lastActivityAt,
    DateTime? archivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      primaryLanguageCode: primaryLanguageCode ?? this.primaryLanguageCode,
      settings: settings ?? this.settings,
      status: status ?? this.status,
      visibility: visibility ?? this.visibility,
      totalKeys: totalKeys ?? this.totalKeys,
      translatedKeys: translatedKeys ?? this.translatedKeys,
      languagesCount: languagesCount ?? this.languagesCount,
      membersCount: membersCount ?? this.membersCount,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 检查项目是否活跃
  bool get isActive => status == 'active';

  /// 检查项目是否已归档
  bool get isArchived => status == 'archived';

  /// 检查项目是否公开
  bool get isPublic => visibility == 'public';

  /// 检查项目是否私有
  bool get isPrivate => visibility == 'private';

  /// 获取翻译完成百分比
  double get completionPercentage {
    if (totalKeys == 0) return 0.0;
    return translatedKeys / totalKeys * 100;
  }

  @override
  String toString() {
    return 'Project(id: $id, name: $name, slug: $slug, status: $status, visibility: $visibility)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Project && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 项目状态枚举
enum ProjectStatus {
  active('active'),
  archived('archived'),
  suspended('suspended');

  const ProjectStatus(this.value);
  final String value;

  static ProjectStatus fromString(String value) {
    return ProjectStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ProjectStatus.active,
    );
  }
}

/// 项目可见性枚举
enum ProjectVisibility {
  public('public'),
  private('private'),
  internal('internal');

  const ProjectVisibility(this.value);
  final String value;

  static ProjectVisibility fromString(String value) {
    return ProjectVisibility.values.firstWhere(
      (visibility) => visibility.value == value,
      orElse: () => ProjectVisibility.private,
    );
  }
}
