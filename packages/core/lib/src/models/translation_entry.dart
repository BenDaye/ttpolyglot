import 'package:equatable/equatable.dart';

import '../enums/translation_status.dart';
import 'language.dart';
import 'user.dart';

/// 翻译条目模型
class TranslationEntry extends Equatable {
  const TranslationEntry({
    required this.id,
    required this.key,
    required this.projectId,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.sourceText,
    required this.targetText,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.translator,
    this.reviewer,
    this.comment,
    this.context,
    this.maxLength,
    this.isPlural = false,
    this.pluralForms,
  });

  /// 翻译条目唯一标识
  final String id;

  /// 翻译键名
  final String key;

  /// 所属项目ID
  final String projectId;

  /// 源语言
  final Language sourceLanguage;

  /// 目标语言
  final Language targetLanguage;

  /// 源文本
  final String sourceText;

  /// 目标文本
  final String targetText;

  /// 翻译状态
  final TranslationStatus status;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  /// 翻译者
  final User? translator;

  /// 审核者
  final User? reviewer;

  /// 备注
  final String? comment;

  /// 上下文信息
  final String? context;

  /// 最大长度限制
  final int? maxLength;

  /// 是否为复数形式
  final bool isPlural;

  /// 复数形式的翻译
  final Map<String, String>? pluralForms;

  /// 复制并更新翻译条目
  TranslationEntry copyWith({
    String? id,
    String? key,
    String? projectId,
    Language? sourceLanguage,
    Language? targetLanguage,
    String? sourceText,
    String? targetText,
    TranslationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? translator,
    User? reviewer,
    String? comment,
    String? context,
    int? maxLength,
    bool? isPlural,
    Map<String, String>? pluralForms,
  }) {
    return TranslationEntry(
      id: id ?? this.id,
      key: key ?? this.key,
      projectId: projectId ?? this.projectId,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      sourceText: sourceText ?? this.sourceText,
      targetText: targetText ?? this.targetText,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      translator: translator ?? this.translator,
      reviewer: reviewer ?? this.reviewer,
      comment: comment ?? this.comment,
      context: context ?? this.context,
      maxLength: maxLength ?? this.maxLength,
      isPlural: isPlural ?? this.isPlural,
      pluralForms: pluralForms ?? this.pluralForms,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'projectId': projectId,
      'sourceLanguage': sourceLanguage.toJson(),
      'targetLanguage': targetLanguage.toJson(),
      'sourceText': sourceText,
      'targetText': targetText,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'translator': translator?.toJson(),
      'reviewer': reviewer?.toJson(),
      'comment': comment,
      'context': context,
      'maxLength': maxLength,
      'isPlural': isPlural,
      'pluralForms': pluralForms,
    };
  }

  /// 从 JSON 创建
  factory TranslationEntry.fromJson(Map<String, dynamic> json) {
    return TranslationEntry(
      id: json['id'] as String,
      key: json['key'] as String,
      projectId: json['projectId'] as String,
      sourceLanguage: Language.fromJson(json['sourceLanguage'] as Map<String, dynamic>),
      targetLanguage: Language.fromJson(json['targetLanguage'] as Map<String, dynamic>),
      sourceText: json['sourceText'] as String,
      targetText: json['targetText'] as String,
      status: TranslationStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      translator: json['translator'] != null ? User.fromJson(json['translator'] as Map<String, dynamic>) : null,
      reviewer: json['reviewer'] != null ? User.fromJson(json['reviewer'] as Map<String, dynamic>) : null,
      comment: json['comment'] as String?,
      context: json['context'] as String?,
      maxLength: json['maxLength'] as int?,
      isPlural: json['isPlural'] as bool? ?? false,
      pluralForms: json['pluralForms'] != null ? Map<String, String>.from(json['pluralForms'] as Map) : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        key,
        projectId,
        sourceLanguage,
        targetLanguage,
        sourceText,
        targetText,
        status,
        createdAt,
        updatedAt,
        translator,
        reviewer,
        comment,
        context,
        maxLength,
        isPlural,
        pluralForms,
      ];

  @override
  String toString() {
    return 'TranslationEntry(id: $id, key: $key, status: $status)';
  }
}
