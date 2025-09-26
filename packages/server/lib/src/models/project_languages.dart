/// 项目语言配置模型
class ProjectLanguage {
  final String id;
  final String projectId;
  final String languageCode;
  final bool isEnabled;
  final Map<String, dynamic>? settings;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectLanguage({
    required this.id,
    required this.projectId,
    required this.languageCode,
    this.isEnabled = true,
    this.settings,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectLanguage.fromJson(Map<String, dynamic> json) {
    return ProjectLanguage(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      languageCode: json['language_code'] as String,
      isEnabled: json['is_enabled'] as bool? ?? true,
      settings: json['settings'] as Map<String, dynamic>?,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'language_code': languageCode,
      'is_enabled': isEnabled,
      'settings': settings,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ProjectLanguage.fromMap(Map<String, dynamic> map) {
    return ProjectLanguage(
      id: map['id'] as String,
      projectId: map['project_id'] as String,
      languageCode: map['language_code'] as String,
      isEnabled: map['is_enabled'] as bool,
      settings: map['settings'] as Map<String, dynamic>?,
      sortOrder: map['sort_order'] as int,
      createdAt: map['created_at'] as DateTime,
      updatedAt: map['updated_at'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'language_code': languageCode,
      'is_enabled': isEnabled,
      'settings': settings,
      'sort_order': sortOrder,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// 获取翻译进度设置
  double get translationProgressThreshold {
    return settings?['translation_progress_threshold'] as double? ?? 0.8;
  }

  /// 获取质量检查设置
  bool get qualityCheckEnabled {
    return settings?['quality_check_enabled'] as bool? ?? true;
  }

  /// 获取自动翻译设置
  bool get autoTranslationEnabled {
    return settings?['auto_translation_enabled'] as bool? ?? false;
  }

  /// 获取默认翻译提供商
  String? get defaultTranslationProvider {
    return settings?['default_translation_provider'] as String?;
  }

  /// 获取翻译记忆库设置
  bool get translationMemoryEnabled {
    return settings?['translation_memory_enabled'] as bool? ?? true;
  }

  /// 获取术语库设置
  bool get terminologyEnabled {
    return settings?['terminology_enabled'] as bool? ?? true;
  }

  /// 创建带有语言信息的完整映射
  Map<String, dynamic> toMapWithLanguage(Map<String, dynamic> languageInfo) {
    return {
      ...toMap(),
      'language': languageInfo,
    };
  }
}
