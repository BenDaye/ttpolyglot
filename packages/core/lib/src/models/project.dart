import 'package:equatable/equatable.dart';

import 'language.dart';
import 'user.dart';

/// 项目设置
class ProjectSettings extends Equatable {
  const ProjectSettings({
    this.autoSync = false,
    this.allowEmptyTranslations = false,
    this.requireReview = false,
    this.maxKeyLength = 100,
    this.keyPattern = r'^[a-zA-Z][a-zA-Z0-9._-]*$',
    this.customFields = const {},
  });

  /// 是否自动同步
  final bool autoSync;

  /// 是否允许空翻译
  final bool allowEmptyTranslations;

  /// 是否需要审核
  final bool requireReview;

  /// 键名最大长度
  final int maxKeyLength;

  /// 键名格式规则
  final String keyPattern;

  /// 自定义字段
  final Map<String, dynamic> customFields;

  /// 复制并更新设置
  ProjectSettings copyWith({
    bool? autoSync,
    bool? allowEmptyTranslations,
    bool? requireReview,
    int? maxKeyLength,
    String? keyPattern,
    Map<String, dynamic>? customFields,
  }) {
    return ProjectSettings(
      autoSync: autoSync ?? this.autoSync,
      allowEmptyTranslations: allowEmptyTranslations ?? this.allowEmptyTranslations,
      requireReview: requireReview ?? this.requireReview,
      maxKeyLength: maxKeyLength ?? this.maxKeyLength,
      keyPattern: keyPattern ?? this.keyPattern,
      customFields: customFields ?? this.customFields,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'autoSync': autoSync,
      'allowEmptyTranslations': allowEmptyTranslations,
      'requireReview': requireReview,
      'maxKeyLength': maxKeyLength,
      'keyPattern': keyPattern,
      'customFields': customFields,
    };
  }

  /// 从 JSON 创建
  factory ProjectSettings.fromJson(Map<String, dynamic> json) {
    return ProjectSettings(
      autoSync: json['autoSync'] as bool? ?? false,
      allowEmptyTranslations: json['allowEmptyTranslations'] as bool? ?? false,
      requireReview: json['requireReview'] as bool? ?? false,
      maxKeyLength: json['maxKeyLength'] as int? ?? 100,
      keyPattern: json['keyPattern'] as String? ?? r'^[a-zA-Z][a-zA-Z0-9._-]*$',
      customFields: json['customFields'] as Map<String, dynamic>? ?? const {},
    );
  }

  @override
  List<Object?> get props => [
        autoSync,
        allowEmptyTranslations,
        requireReview,
        maxKeyLength,
        keyPattern,
        customFields,
      ];
}

/// 翻译项目模型
class Project extends Equatable {
  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.defaultLanguage,
    required this.targetLanguages,
    required this.owner,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.lastAccessedAt,
    this.settings,
  });

  /// 项目唯一标识
  final String id;

  /// 项目名称
  final String name;

  /// 项目描述
  final String description;

  /// 默认语言（源语言）
  final Language defaultLanguage;

  /// 目标语言列表
  final List<Language> targetLanguages;

  /// 项目所有者
  final User owner;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  /// 是否激活
  final bool isActive;

  /// 最后访问时间
  final DateTime? lastAccessedAt;

  /// 项目设置
  final ProjectSettings? settings;

  /// 获取所有语言（包括默认语言和目标语言）
  List<Language> get allLanguages => [defaultLanguage, ...targetLanguages];

  /// 复制并更新项目信息
  Project copyWith({
    String? id,
    String? name,
    String? description,
    Language? defaultLanguage,
    List<Language>? targetLanguages,
    User? owner,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    DateTime? lastAccessedAt,
    ProjectSettings? settings,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      targetLanguages: targetLanguages ?? this.targetLanguages,
      owner: owner ?? this.owner,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      settings: settings ?? this.settings,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'defaultLanguage': defaultLanguage.toJson(),
      'targetLanguages': targetLanguages.map((lang) => lang.toJson()).toList(),
      'owner': owner.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
      'settings': settings?.toJson(),
    };
  }

  /// 从 JSON 创建
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      defaultLanguage: Language.fromJson(json['defaultLanguage'] as Map<String, dynamic>),
      targetLanguages: (json['targetLanguages'] as List<dynamic>)
          .map((lang) => Language.fromJson(lang as Map<String, dynamic>))
          .toList(),
      owner: User.fromJson(json['owner'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      lastAccessedAt: json['lastAccessedAt'] != null 
          ? DateTime.parse(json['lastAccessedAt'] as String) 
          : null,
      settings: json['settings'] != null 
          ? ProjectSettings.fromJson(json['settings'] as Map<String, dynamic>) 
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        defaultLanguage,
        targetLanguages,
        owner,
        createdAt,
        updatedAt,
        isActive,
        lastAccessedAt,
        settings,
      ];

  @override
  String toString() {
    return 'Project(id: $id, name: $name, defaultLanguage: ${defaultLanguage.code})';
  }
}
