/// 翻译条目模型
class TranslationEntry {
  final String id;
  final String projectId;
  final String entryKey;
  final String languageCode;
  final String? sourceText;
  final String? targetText;
  final String status;
  final String? translationProvider;
  final String? providerConfigId;
  final bool isAiTranslated;
  final double? confidenceScore;
  final String? translatorId;
  final String? reviewerId;
  final DateTime? assignedAt;
  final int version;
  final String? parentVersionId;
  final int characterCount;
  final int wordCount;
  final bool isPlural;
  final String? contextInfo;
  final double? qualityScore;
  final bool hasIssues;
  final Map<String, dynamic>? issues;
  final DateTime? translatedAt;
  final DateTime? reviewedAt;
  final DateTime? approvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TranslationEntry({
    required this.id,
    required this.projectId,
    required this.entryKey,
    required this.languageCode,
    this.sourceText,
    this.targetText,
    this.status = 'pending',
    this.translationProvider,
    this.providerConfigId,
    this.isAiTranslated = false,
    this.confidenceScore,
    this.translatorId,
    this.reviewerId,
    this.assignedAt,
    this.version = 1,
    this.parentVersionId,
    this.characterCount = 0,
    this.wordCount = 0,
    this.isPlural = false,
    this.contextInfo,
    this.qualityScore,
    this.hasIssues = false,
    this.issues,
    this.translatedAt,
    this.reviewedAt,
    this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从数据库行创建翻译条目对象
  factory TranslationEntry.fromMap(Map<String, dynamic> map) {
    return TranslationEntry(
      id: map['id'] as String,
      projectId: map['project_id'] as String,
      entryKey: map['entry_key'] as String,
      languageCode: map['language_code'] as String,
      sourceText: map['source_text'] as String?,
      targetText: map['target_text'] as String?,
      status: map['status'] as String? ?? 'pending',
      translationProvider: map['translation_provider'] as String?,
      providerConfigId: map['provider_config_id'] as String?,
      isAiTranslated: map['is_ai_translated'] as bool? ?? false,
      confidenceScore: map['confidence_score'] as double?,
      translatorId: map['translator_id'] as String?,
      reviewerId: map['reviewer_id'] as String?,
      assignedAt: map['assigned_at'] != null ? DateTime.parse(map['assigned_at'] as String) : null,
      version: map['version'] as int? ?? 1,
      parentVersionId: map['parent_version_id'] as String?,
      characterCount: map['character_count'] as int? ?? 0,
      wordCount: map['word_count'] as int? ?? 0,
      isPlural: map['is_plural'] as bool? ?? false,
      contextInfo: map['context_info'] as String?,
      qualityScore: map['quality_score'] as double?,
      hasIssues: map['has_issues'] as bool? ?? false,
      issues: map['issues'] as Map<String, dynamic>?,
      translatedAt: map['translated_at'] != null ? DateTime.parse(map['translated_at'] as String) : null,
      reviewedAt: map['reviewed_at'] != null ? DateTime.parse(map['reviewed_at'] as String) : null,
      approvedAt: map['approved_at'] != null ? DateTime.parse(map['approved_at'] as String) : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// 转换为Map用于API响应
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'entry_key': entryKey,
      'language_code': languageCode,
      'source_text': sourceText,
      'target_text': targetText,
      'status': status,
      'translation_provider': translationProvider,
      'provider_config_id': providerConfigId,
      'is_ai_translated': isAiTranslated,
      'confidence_score': confidenceScore,
      'translator_id': translatorId,
      'reviewer_id': reviewerId,
      'assigned_at': assignedAt?.toIso8601String(),
      'version': version,
      'parent_version_id': parentVersionId,
      'character_count': characterCount,
      'word_count': wordCount,
      'is_plural': isPlural,
      'context_info': contextInfo,
      'quality_score': qualityScore,
      'has_issues': hasIssues,
      'issues': issues,
      'translated_at': translatedAt?.toIso8601String(),
      'reviewed_at': reviewedAt?.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 创建翻译条目副本
  TranslationEntry copyWith({
    String? id,
    String? projectId,
    String? entryKey,
    String? languageCode,
    String? sourceText,
    String? targetText,
    String? status,
    String? translationProvider,
    String? providerConfigId,
    bool? isAiTranslated,
    double? confidenceScore,
    String? translatorId,
    String? reviewerId,
    DateTime? assignedAt,
    int? version,
    String? parentVersionId,
    int? characterCount,
    int? wordCount,
    bool? isPlural,
    String? contextInfo,
    double? qualityScore,
    bool? hasIssues,
    Map<String, dynamic>? issues,
    DateTime? translatedAt,
    DateTime? reviewedAt,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TranslationEntry(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      entryKey: entryKey ?? this.entryKey,
      languageCode: languageCode ?? this.languageCode,
      sourceText: sourceText ?? this.sourceText,
      targetText: targetText ?? this.targetText,
      status: status ?? this.status,
      translationProvider: translationProvider ?? this.translationProvider,
      providerConfigId: providerConfigId ?? this.providerConfigId,
      isAiTranslated: isAiTranslated ?? this.isAiTranslated,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      translatorId: translatorId ?? this.translatorId,
      reviewerId: reviewerId ?? this.reviewerId,
      assignedAt: assignedAt ?? this.assignedAt,
      version: version ?? this.version,
      parentVersionId: parentVersionId ?? this.parentVersionId,
      characterCount: characterCount ?? this.characterCount,
      wordCount: wordCount ?? this.wordCount,
      isPlural: isPlural ?? this.isPlural,
      contextInfo: contextInfo ?? this.contextInfo,
      qualityScore: qualityScore ?? this.qualityScore,
      hasIssues: hasIssues ?? this.hasIssues,
      issues: issues ?? this.issues,
      translatedAt: translatedAt ?? this.translatedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 检查翻译条目是否已完成
  bool get isCompleted => status == 'completed';

  /// 检查翻译条目是否待审核
  bool get isReviewing => status == 'reviewing';

  /// 检查翻译条目是否已批准
  bool get isApproved => status == 'approved';

  /// 检查翻译条目是否待翻译
  bool get isPending => status == 'pending';

  /// 检查翻译条目是否正在翻译中
  bool get isTranslating => status == 'translating';

  /// 检查翻译条目是否有问题
  bool get hasQualityIssues => hasIssues || (issues != null && issues!.isNotEmpty);

  @override
  String toString() {
    return 'TranslationEntry(id: $id, key: $entryKey, status: $status, language: $languageCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TranslationEntry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 翻译条目状态枚举
enum TranslationStatus {
  pending('pending'),
  translating('translating'),
  completed('completed'),
  reviewing('reviewing'),
  approved('approved'),
  rejected('rejected');

  const TranslationStatus(this.value);
  final String value;

  static TranslationStatus fromString(String value) {
    return TranslationStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TranslationStatus.pending,
    );
  }
}
