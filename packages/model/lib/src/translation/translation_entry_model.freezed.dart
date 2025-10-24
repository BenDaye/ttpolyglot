// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TranslationEntryModel _$TranslationEntryModelFromJson(
    Map<String, dynamic> json) {
  return _TranslationEntryModel.fromJson(json);
}

/// @nodoc
mixin _$TranslationEntryModel {
  /// 条目ID
  String? get id => throw _privateConstructorUsedError;

  /// 项目ID
  @JsonKey(name: 'project_id')
  String get projectId => throw _privateConstructorUsedError;

  /// 条目键
  @JsonKey(name: 'entry_key')
  String get entryKey => throw _privateConstructorUsedError;

  /// 语言代码
  @JsonKey(name: 'language_code')
  @LanguageEnumConverter()
  LanguageEnum get languageCode => throw _privateConstructorUsedError;

  /// 源文本
  @JsonKey(name: 'source_text')
  String? get sourceText => throw _privateConstructorUsedError;

  /// 目标文本
  @JsonKey(name: 'target_text')
  String? get targetText => throw _privateConstructorUsedError;

  /// 翻译者ID
  @JsonKey(name: 'translator_id')
  String? get translatorId => throw _privateConstructorUsedError;

  /// 翻译者用户名
  @JsonKey(name: 'translator_username')
  String? get translatorUsername => throw _privateConstructorUsedError;

  /// 审核者ID
  @JsonKey(name: 'reviewer_id')
  String? get reviewerId => throw _privateConstructorUsedError;

  /// 审核者用户名
  @JsonKey(name: 'reviewer_username')
  String? get reviewerUsername => throw _privateConstructorUsedError;

  /// 上下文信息
  @JsonKey(name: 'context_info')
  String? get contextInfo => throw _privateConstructorUsedError;

  /// 状态 (pending, completed, reviewing, approved)
  String get status => throw _privateConstructorUsedError;

  /// 版本号
  int get version => throw _privateConstructorUsedError;

  /// 质量评分
  @JsonKey(name: 'quality_score')
  double? get qualityScore => throw _privateConstructorUsedError;

  /// 问题列表
  String? get issues => throw _privateConstructorUsedError;

  /// 是否有问题
  @JsonKey(name: 'has_issues')
  bool get hasIssues => throw _privateConstructorUsedError;

  /// 字符数
  @JsonKey(name: 'character_count')
  int? get characterCount => throw _privateConstructorUsedError;

  /// 单词数
  @JsonKey(name: 'word_count')
  int? get wordCount => throw _privateConstructorUsedError;

  /// 分配时间
  @JsonKey(name: 'assigned_at')
  @NullableTimesConverter()
  DateTime? get assignedAt => throw _privateConstructorUsedError;

  /// 翻译完成时间
  @JsonKey(name: 'translated_at')
  @NullableTimesConverter()
  DateTime? get translatedAt => throw _privateConstructorUsedError;

  /// 审核时间
  @JsonKey(name: 'reviewed_at')
  @NullableTimesConverter()
  DateTime? get reviewedAt => throw _privateConstructorUsedError;

  /// 批准时间
  @JsonKey(name: 'approved_at')
  @NullableTimesConverter()
  DateTime? get approvedAt => throw _privateConstructorUsedError;

  /// 创建时间
  @JsonKey(name: 'created_at')
  @NullableTimesConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  @JsonKey(name: 'updated_at')
  @NullableTimesConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TranslationEntryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranslationEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranslationEntryModelCopyWith<TranslationEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslationEntryModelCopyWith<$Res> {
  factory $TranslationEntryModelCopyWith(TranslationEntryModel value,
          $Res Function(TranslationEntryModel) then) =
      _$TranslationEntryModelCopyWithImpl<$Res, TranslationEntryModel>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'project_id') String projectId,
      @JsonKey(name: 'entry_key') String entryKey,
      @JsonKey(name: 'language_code')
      @LanguageEnumConverter()
      LanguageEnum languageCode,
      @JsonKey(name: 'source_text') String? sourceText,
      @JsonKey(name: 'target_text') String? targetText,
      @JsonKey(name: 'translator_id') String? translatorId,
      @JsonKey(name: 'translator_username') String? translatorUsername,
      @JsonKey(name: 'reviewer_id') String? reviewerId,
      @JsonKey(name: 'reviewer_username') String? reviewerUsername,
      @JsonKey(name: 'context_info') String? contextInfo,
      String status,
      int version,
      @JsonKey(name: 'quality_score') double? qualityScore,
      String? issues,
      @JsonKey(name: 'has_issues') bool hasIssues,
      @JsonKey(name: 'character_count') int? characterCount,
      @JsonKey(name: 'word_count') int? wordCount,
      @JsonKey(name: 'assigned_at')
      @NullableTimesConverter()
      DateTime? assignedAt,
      @JsonKey(name: 'translated_at')
      @NullableTimesConverter()
      DateTime? translatedAt,
      @JsonKey(name: 'reviewed_at')
      @NullableTimesConverter()
      DateTime? reviewedAt,
      @JsonKey(name: 'approved_at')
      @NullableTimesConverter()
      DateTime? approvedAt,
      @JsonKey(name: 'created_at')
      @NullableTimesConverter()
      DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      @NullableTimesConverter()
      DateTime? updatedAt});
}

/// @nodoc
class _$TranslationEntryModelCopyWithImpl<$Res,
        $Val extends TranslationEntryModel>
    implements $TranslationEntryModelCopyWith<$Res> {
  _$TranslationEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranslationEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? projectId = null,
    Object? entryKey = null,
    Object? languageCode = null,
    Object? sourceText = freezed,
    Object? targetText = freezed,
    Object? translatorId = freezed,
    Object? translatorUsername = freezed,
    Object? reviewerId = freezed,
    Object? reviewerUsername = freezed,
    Object? contextInfo = freezed,
    Object? status = null,
    Object? version = null,
    Object? qualityScore = freezed,
    Object? issues = freezed,
    Object? hasIssues = null,
    Object? characterCount = freezed,
    Object? wordCount = freezed,
    Object? assignedAt = freezed,
    Object? translatedAt = freezed,
    Object? reviewedAt = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      entryKey: null == entryKey
          ? _value.entryKey
          : entryKey // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as LanguageEnum,
      sourceText: freezed == sourceText
          ? _value.sourceText
          : sourceText // ignore: cast_nullable_to_non_nullable
              as String?,
      targetText: freezed == targetText
          ? _value.targetText
          : targetText // ignore: cast_nullable_to_non_nullable
              as String?,
      translatorId: freezed == translatorId
          ? _value.translatorId
          : translatorId // ignore: cast_nullable_to_non_nullable
              as String?,
      translatorUsername: freezed == translatorUsername
          ? _value.translatorUsername
          : translatorUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerId: freezed == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerUsername: freezed == reviewerUsername
          ? _value.reviewerUsername
          : reviewerUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      contextInfo: freezed == contextInfo
          ? _value.contextInfo
          : contextInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      qualityScore: freezed == qualityScore
          ? _value.qualityScore
          : qualityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      issues: freezed == issues
          ? _value.issues
          : issues // ignore: cast_nullable_to_non_nullable
              as String?,
      hasIssues: null == hasIssues
          ? _value.hasIssues
          : hasIssues // ignore: cast_nullable_to_non_nullable
              as bool,
      characterCount: freezed == characterCount
          ? _value.characterCount
          : characterCount // ignore: cast_nullable_to_non_nullable
              as int?,
      wordCount: freezed == wordCount
          ? _value.wordCount
          : wordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedAt: freezed == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      translatedAt: freezed == translatedAt
          ? _value.translatedAt
          : translatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranslationEntryModelImplCopyWith<$Res>
    implements $TranslationEntryModelCopyWith<$Res> {
  factory _$$TranslationEntryModelImplCopyWith(
          _$TranslationEntryModelImpl value,
          $Res Function(_$TranslationEntryModelImpl) then) =
      __$$TranslationEntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'project_id') String projectId,
      @JsonKey(name: 'entry_key') String entryKey,
      @JsonKey(name: 'language_code')
      @LanguageEnumConverter()
      LanguageEnum languageCode,
      @JsonKey(name: 'source_text') String? sourceText,
      @JsonKey(name: 'target_text') String? targetText,
      @JsonKey(name: 'translator_id') String? translatorId,
      @JsonKey(name: 'translator_username') String? translatorUsername,
      @JsonKey(name: 'reviewer_id') String? reviewerId,
      @JsonKey(name: 'reviewer_username') String? reviewerUsername,
      @JsonKey(name: 'context_info') String? contextInfo,
      String status,
      int version,
      @JsonKey(name: 'quality_score') double? qualityScore,
      String? issues,
      @JsonKey(name: 'has_issues') bool hasIssues,
      @JsonKey(name: 'character_count') int? characterCount,
      @JsonKey(name: 'word_count') int? wordCount,
      @JsonKey(name: 'assigned_at')
      @NullableTimesConverter()
      DateTime? assignedAt,
      @JsonKey(name: 'translated_at')
      @NullableTimesConverter()
      DateTime? translatedAt,
      @JsonKey(name: 'reviewed_at')
      @NullableTimesConverter()
      DateTime? reviewedAt,
      @JsonKey(name: 'approved_at')
      @NullableTimesConverter()
      DateTime? approvedAt,
      @JsonKey(name: 'created_at')
      @NullableTimesConverter()
      DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      @NullableTimesConverter()
      DateTime? updatedAt});
}

/// @nodoc
class __$$TranslationEntryModelImplCopyWithImpl<$Res>
    extends _$TranslationEntryModelCopyWithImpl<$Res,
        _$TranslationEntryModelImpl>
    implements _$$TranslationEntryModelImplCopyWith<$Res> {
  __$$TranslationEntryModelImplCopyWithImpl(_$TranslationEntryModelImpl _value,
      $Res Function(_$TranslationEntryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranslationEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? projectId = null,
    Object? entryKey = null,
    Object? languageCode = null,
    Object? sourceText = freezed,
    Object? targetText = freezed,
    Object? translatorId = freezed,
    Object? translatorUsername = freezed,
    Object? reviewerId = freezed,
    Object? reviewerUsername = freezed,
    Object? contextInfo = freezed,
    Object? status = null,
    Object? version = null,
    Object? qualityScore = freezed,
    Object? issues = freezed,
    Object? hasIssues = null,
    Object? characterCount = freezed,
    Object? wordCount = freezed,
    Object? assignedAt = freezed,
    Object? translatedAt = freezed,
    Object? reviewedAt = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TranslationEntryModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      entryKey: null == entryKey
          ? _value.entryKey
          : entryKey // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as LanguageEnum,
      sourceText: freezed == sourceText
          ? _value.sourceText
          : sourceText // ignore: cast_nullable_to_non_nullable
              as String?,
      targetText: freezed == targetText
          ? _value.targetText
          : targetText // ignore: cast_nullable_to_non_nullable
              as String?,
      translatorId: freezed == translatorId
          ? _value.translatorId
          : translatorId // ignore: cast_nullable_to_non_nullable
              as String?,
      translatorUsername: freezed == translatorUsername
          ? _value.translatorUsername
          : translatorUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerId: freezed == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerUsername: freezed == reviewerUsername
          ? _value.reviewerUsername
          : reviewerUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      contextInfo: freezed == contextInfo
          ? _value.contextInfo
          : contextInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      qualityScore: freezed == qualityScore
          ? _value.qualityScore
          : qualityScore // ignore: cast_nullable_to_non_nullable
              as double?,
      issues: freezed == issues
          ? _value.issues
          : issues // ignore: cast_nullable_to_non_nullable
              as String?,
      hasIssues: null == hasIssues
          ? _value.hasIssues
          : hasIssues // ignore: cast_nullable_to_non_nullable
              as bool,
      characterCount: freezed == characterCount
          ? _value.characterCount
          : characterCount // ignore: cast_nullable_to_non_nullable
              as int?,
      wordCount: freezed == wordCount
          ? _value.wordCount
          : wordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedAt: freezed == assignedAt
          ? _value.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      translatedAt: freezed == translatedAt
          ? _value.translatedAt
          : translatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslationEntryModelImpl extends _TranslationEntryModel {
  const _$TranslationEntryModelImpl(
      {this.id,
      @JsonKey(name: 'project_id') required this.projectId,
      @JsonKey(name: 'entry_key') required this.entryKey,
      @JsonKey(name: 'language_code')
      @LanguageEnumConverter()
      required this.languageCode,
      @JsonKey(name: 'source_text') this.sourceText,
      @JsonKey(name: 'target_text') this.targetText,
      @JsonKey(name: 'translator_id') this.translatorId,
      @JsonKey(name: 'translator_username') this.translatorUsername,
      @JsonKey(name: 'reviewer_id') this.reviewerId,
      @JsonKey(name: 'reviewer_username') this.reviewerUsername,
      @JsonKey(name: 'context_info') this.contextInfo,
      this.status = 'pending',
      this.version = 1,
      @JsonKey(name: 'quality_score') this.qualityScore,
      this.issues,
      @JsonKey(name: 'has_issues') this.hasIssues = false,
      @JsonKey(name: 'character_count') this.characterCount,
      @JsonKey(name: 'word_count') this.wordCount,
      @JsonKey(name: 'assigned_at') @NullableTimesConverter() this.assignedAt,
      @JsonKey(name: 'translated_at')
      @NullableTimesConverter()
      this.translatedAt,
      @JsonKey(name: 'reviewed_at') @NullableTimesConverter() this.reviewedAt,
      @JsonKey(name: 'approved_at') @NullableTimesConverter() this.approvedAt,
      @JsonKey(name: 'created_at') @NullableTimesConverter() this.createdAt,
      @JsonKey(name: 'updated_at') @NullableTimesConverter() this.updatedAt})
      : super._();

  factory _$TranslationEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslationEntryModelImplFromJson(json);

  /// 条目ID
  @override
  final String? id;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  final String projectId;

  /// 条目键
  @override
  @JsonKey(name: 'entry_key')
  final String entryKey;

  /// 语言代码
  @override
  @JsonKey(name: 'language_code')
  @LanguageEnumConverter()
  final LanguageEnum languageCode;

  /// 源文本
  @override
  @JsonKey(name: 'source_text')
  final String? sourceText;

  /// 目标文本
  @override
  @JsonKey(name: 'target_text')
  final String? targetText;

  /// 翻译者ID
  @override
  @JsonKey(name: 'translator_id')
  final String? translatorId;

  /// 翻译者用户名
  @override
  @JsonKey(name: 'translator_username')
  final String? translatorUsername;

  /// 审核者ID
  @override
  @JsonKey(name: 'reviewer_id')
  final String? reviewerId;

  /// 审核者用户名
  @override
  @JsonKey(name: 'reviewer_username')
  final String? reviewerUsername;

  /// 上下文信息
  @override
  @JsonKey(name: 'context_info')
  final String? contextInfo;

  /// 状态 (pending, completed, reviewing, approved)
  @override
  @JsonKey()
  final String status;

  /// 版本号
  @override
  @JsonKey()
  final int version;

  /// 质量评分
  @override
  @JsonKey(name: 'quality_score')
  final double? qualityScore;

  /// 问题列表
  @override
  final String? issues;

  /// 是否有问题
  @override
  @JsonKey(name: 'has_issues')
  final bool hasIssues;

  /// 字符数
  @override
  @JsonKey(name: 'character_count')
  final int? characterCount;

  /// 单词数
  @override
  @JsonKey(name: 'word_count')
  final int? wordCount;

  /// 分配时间
  @override
  @JsonKey(name: 'assigned_at')
  @NullableTimesConverter()
  final DateTime? assignedAt;

  /// 翻译完成时间
  @override
  @JsonKey(name: 'translated_at')
  @NullableTimesConverter()
  final DateTime? translatedAt;

  /// 审核时间
  @override
  @JsonKey(name: 'reviewed_at')
  @NullableTimesConverter()
  final DateTime? reviewedAt;

  /// 批准时间
  @override
  @JsonKey(name: 'approved_at')
  @NullableTimesConverter()
  final DateTime? approvedAt;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @NullableTimesConverter()
  final DateTime? createdAt;

  /// 更新时间
  @override
  @JsonKey(name: 'updated_at')
  @NullableTimesConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TranslationEntryModel(id: $id, projectId: $projectId, entryKey: $entryKey, languageCode: $languageCode, sourceText: $sourceText, targetText: $targetText, translatorId: $translatorId, translatorUsername: $translatorUsername, reviewerId: $reviewerId, reviewerUsername: $reviewerUsername, contextInfo: $contextInfo, status: $status, version: $version, qualityScore: $qualityScore, issues: $issues, hasIssues: $hasIssues, characterCount: $characterCount, wordCount: $wordCount, assignedAt: $assignedAt, translatedAt: $translatedAt, reviewedAt: $reviewedAt, approvedAt: $approvedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationEntryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.entryKey, entryKey) ||
                other.entryKey == entryKey) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.sourceText, sourceText) ||
                other.sourceText == sourceText) &&
            (identical(other.targetText, targetText) ||
                other.targetText == targetText) &&
            (identical(other.translatorId, translatorId) ||
                other.translatorId == translatorId) &&
            (identical(other.translatorUsername, translatorUsername) ||
                other.translatorUsername == translatorUsername) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.reviewerUsername, reviewerUsername) ||
                other.reviewerUsername == reviewerUsername) &&
            (identical(other.contextInfo, contextInfo) ||
                other.contextInfo == contextInfo) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.qualityScore, qualityScore) ||
                other.qualityScore == qualityScore) &&
            (identical(other.issues, issues) || other.issues == issues) &&
            (identical(other.hasIssues, hasIssues) ||
                other.hasIssues == hasIssues) &&
            (identical(other.characterCount, characterCount) ||
                other.characterCount == characterCount) &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.translatedAt, translatedAt) ||
                other.translatedAt == translatedAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        projectId,
        entryKey,
        languageCode,
        sourceText,
        targetText,
        translatorId,
        translatorUsername,
        reviewerId,
        reviewerUsername,
        contextInfo,
        status,
        version,
        qualityScore,
        issues,
        hasIssues,
        characterCount,
        wordCount,
        assignedAt,
        translatedAt,
        reviewedAt,
        approvedAt,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of TranslationEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslationEntryModelImplCopyWith<_$TranslationEntryModelImpl>
      get copyWith => __$$TranslationEntryModelImplCopyWithImpl<
          _$TranslationEntryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslationEntryModelImplToJson(
      this,
    );
  }
}

abstract class _TranslationEntryModel extends TranslationEntryModel {
  const factory _TranslationEntryModel(
      {final String? id,
      @JsonKey(name: 'project_id') required final String projectId,
      @JsonKey(name: 'entry_key') required final String entryKey,
      @JsonKey(name: 'language_code')
      @LanguageEnumConverter()
      required final LanguageEnum languageCode,
      @JsonKey(name: 'source_text') final String? sourceText,
      @JsonKey(name: 'target_text') final String? targetText,
      @JsonKey(name: 'translator_id') final String? translatorId,
      @JsonKey(name: 'translator_username') final String? translatorUsername,
      @JsonKey(name: 'reviewer_id') final String? reviewerId,
      @JsonKey(name: 'reviewer_username') final String? reviewerUsername,
      @JsonKey(name: 'context_info') final String? contextInfo,
      final String status,
      final int version,
      @JsonKey(name: 'quality_score') final double? qualityScore,
      final String? issues,
      @JsonKey(name: 'has_issues') final bool hasIssues,
      @JsonKey(name: 'character_count') final int? characterCount,
      @JsonKey(name: 'word_count') final int? wordCount,
      @JsonKey(name: 'assigned_at')
      @NullableTimesConverter()
      final DateTime? assignedAt,
      @JsonKey(name: 'translated_at')
      @NullableTimesConverter()
      final DateTime? translatedAt,
      @JsonKey(name: 'reviewed_at')
      @NullableTimesConverter()
      final DateTime? reviewedAt,
      @JsonKey(name: 'approved_at')
      @NullableTimesConverter()
      final DateTime? approvedAt,
      @JsonKey(name: 'created_at')
      @NullableTimesConverter()
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      @NullableTimesConverter()
      final DateTime? updatedAt}) = _$TranslationEntryModelImpl;
  const _TranslationEntryModel._() : super._();

  factory _TranslationEntryModel.fromJson(Map<String, dynamic> json) =
      _$TranslationEntryModelImpl.fromJson;

  /// 条目ID
  @override
  String? get id;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  String get projectId;

  /// 条目键
  @override
  @JsonKey(name: 'entry_key')
  String get entryKey;

  /// 语言代码
  @override
  @JsonKey(name: 'language_code')
  @LanguageEnumConverter()
  LanguageEnum get languageCode;

  /// 源文本
  @override
  @JsonKey(name: 'source_text')
  String? get sourceText;

  /// 目标文本
  @override
  @JsonKey(name: 'target_text')
  String? get targetText;

  /// 翻译者ID
  @override
  @JsonKey(name: 'translator_id')
  String? get translatorId;

  /// 翻译者用户名
  @override
  @JsonKey(name: 'translator_username')
  String? get translatorUsername;

  /// 审核者ID
  @override
  @JsonKey(name: 'reviewer_id')
  String? get reviewerId;

  /// 审核者用户名
  @override
  @JsonKey(name: 'reviewer_username')
  String? get reviewerUsername;

  /// 上下文信息
  @override
  @JsonKey(name: 'context_info')
  String? get contextInfo;

  /// 状态 (pending, completed, reviewing, approved)
  @override
  String get status;

  /// 版本号
  @override
  int get version;

  /// 质量评分
  @override
  @JsonKey(name: 'quality_score')
  double? get qualityScore;

  /// 问题列表
  @override
  String? get issues;

  /// 是否有问题
  @override
  @JsonKey(name: 'has_issues')
  bool get hasIssues;

  /// 字符数
  @override
  @JsonKey(name: 'character_count')
  int? get characterCount;

  /// 单词数
  @override
  @JsonKey(name: 'word_count')
  int? get wordCount;

  /// 分配时间
  @override
  @JsonKey(name: 'assigned_at')
  @NullableTimesConverter()
  DateTime? get assignedAt;

  /// 翻译完成时间
  @override
  @JsonKey(name: 'translated_at')
  @NullableTimesConverter()
  DateTime? get translatedAt;

  /// 审核时间
  @override
  @JsonKey(name: 'reviewed_at')
  @NullableTimesConverter()
  DateTime? get reviewedAt;

  /// 批准时间
  @override
  @JsonKey(name: 'approved_at')
  @NullableTimesConverter()
  DateTime? get approvedAt;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @NullableTimesConverter()
  DateTime? get createdAt;

  /// 更新时间
  @override
  @JsonKey(name: 'updated_at')
  @NullableTimesConverter()
  DateTime? get updatedAt;

  /// Create a copy of TranslationEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranslationEntryModelImplCopyWith<_$TranslationEntryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
