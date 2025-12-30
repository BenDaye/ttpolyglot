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
  /// UUID（用于分布式场景）
  @JsonKey(name: 'uuid')
  String get uuid => throw _privateConstructorUsedError;

  /// 项目ID
  @JsonKey(name: 'project_id')
  String get projectId => throw _privateConstructorUsedError;

  /// 条目键（优化字段）
  @JsonKey(name: 'entry_key')
  String get entryKey => throw _privateConstructorUsedError;

  /// 源语言ID
  @JsonKey(name: 'source_language')
  @LanguageEnumConverter()
  LanguageEnum get sourceLanguage => throw _privateConstructorUsedError;

  /// 目标语言ID
  @JsonKey(name: 'target_language')
  @LanguageEnumConverter()
  LanguageEnum get targetLanguage => throw _privateConstructorUsedError;

  /// 源文本
  @JsonKey(name: 'source_text')
  String get sourceText => throw _privateConstructorUsedError;

  /// 目标文本
  @JsonKey(name: 'target_text')
  String get targetText => throw _privateConstructorUsedError;

  /// 状态 (pending, completed, reviewing, approved)
  @JsonKey(name: 'status')
  @TranslationStatusEnumConverter()
  TranslationStatusEnum get status => throw _privateConstructorUsedError;

  /// 翻译者ID
  @JsonKey(name: 'translated_by')
  String? get translatedBy => throw _privateConstructorUsedError;

  /// 翻译者用户名（关联查询字段）
  @JsonKey(name: 'translator_username')
  String? get translatorUsername => throw _privateConstructorUsedError;

  /// 审核者ID
  @JsonKey(name: 'reviewed_by')
  String? get reviewedBy => throw _privateConstructorUsedError;

  /// 审核者用户名（关联查询字段）
  @JsonKey(name: 'reviewer_username')
  String? get reviewerUsername => throw _privateConstructorUsedError;

  /// 上下文信息
  @JsonKey(name: 'context')
  String get context => throw _privateConstructorUsedError;

  /// 备注
  @JsonKey(name: 'comment')
  String get comment => throw _privateConstructorUsedError;

  /// 最大长度限制
  @JsonKey(name: 'max_length')
  int? get maxLength => throw _privateConstructorUsedError;

  /// 是否为复数形式
  @JsonKey(name: 'is_plural')
  bool get isPlural => throw _privateConstructorUsedError;

  /// 复数形式（JSON字符串）
  @JsonKey(name: 'plural_forms')
  String? get pluralForms => throw _privateConstructorUsedError;

  /// 排序索引
  @JsonKey(name: 'sort_index')
  int get sortIndex => throw _privateConstructorUsedError;

  /// 目标语言ID（用于兼容旧代码）
  @JsonKey(name: 'target_language_id')
  int? get targetLanguageId => throw _privateConstructorUsedError;

  /// 删除时间
  @JsonKey(name: 'deleted_at')
  @NullableTimesConverter()
  DateTime? get deletedAt => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'uuid') String uuid,
      @JsonKey(name: 'project_id') String projectId,
      @JsonKey(name: 'entry_key') String entryKey,
      @JsonKey(name: 'source_language')
      @LanguageEnumConverter()
      LanguageEnum sourceLanguage,
      @JsonKey(name: 'target_language')
      @LanguageEnumConverter()
      LanguageEnum targetLanguage,
      @JsonKey(name: 'source_text') String sourceText,
      @JsonKey(name: 'target_text') String targetText,
      @JsonKey(name: 'status')
      @TranslationStatusEnumConverter()
      TranslationStatusEnum status,
      @JsonKey(name: 'translated_by') String? translatedBy,
      @JsonKey(name: 'translator_username') String? translatorUsername,
      @JsonKey(name: 'reviewed_by') String? reviewedBy,
      @JsonKey(name: 'reviewer_username') String? reviewerUsername,
      @JsonKey(name: 'context') String context,
      @JsonKey(name: 'comment') String comment,
      @JsonKey(name: 'max_length') int? maxLength,
      @JsonKey(name: 'is_plural') bool isPlural,
      @JsonKey(name: 'plural_forms') String? pluralForms,
      @JsonKey(name: 'sort_index') int sortIndex,
      @JsonKey(name: 'target_language_id') int? targetLanguageId,
      @JsonKey(name: 'deleted_at')
      @NullableTimesConverter()
      DateTime? deletedAt,
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
    Object? uuid = null,
    Object? projectId = null,
    Object? entryKey = null,
    Object? sourceLanguage = null,
    Object? targetLanguage = null,
    Object? sourceText = null,
    Object? targetText = null,
    Object? status = null,
    Object? translatedBy = freezed,
    Object? translatorUsername = freezed,
    Object? reviewedBy = freezed,
    Object? reviewerUsername = freezed,
    Object? context = null,
    Object? comment = null,
    Object? maxLength = freezed,
    Object? isPlural = null,
    Object? pluralForms = freezed,
    Object? sortIndex = null,
    Object? targetLanguageId = freezed,
    Object? deletedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      entryKey: null == entryKey
          ? _value.entryKey
          : entryKey // ignore: cast_nullable_to_non_nullable
              as String,
      sourceLanguage: null == sourceLanguage
          ? _value.sourceLanguage
          : sourceLanguage // ignore: cast_nullable_to_non_nullable
              as LanguageEnum,
      targetLanguage: null == targetLanguage
          ? _value.targetLanguage
          : targetLanguage // ignore: cast_nullable_to_non_nullable
              as LanguageEnum,
      sourceText: null == sourceText
          ? _value.sourceText
          : sourceText // ignore: cast_nullable_to_non_nullable
              as String,
      targetText: null == targetText
          ? _value.targetText
          : targetText // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TranslationStatusEnum,
      translatedBy: freezed == translatedBy
          ? _value.translatedBy
          : translatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      translatorUsername: freezed == translatorUsername
          ? _value.translatorUsername
          : translatorUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerUsername: freezed == reviewerUsername
          ? _value.reviewerUsername
          : reviewerUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      maxLength: freezed == maxLength
          ? _value.maxLength
          : maxLength // ignore: cast_nullable_to_non_nullable
              as int?,
      isPlural: null == isPlural
          ? _value.isPlural
          : isPlural // ignore: cast_nullable_to_non_nullable
              as bool,
      pluralForms: freezed == pluralForms
          ? _value.pluralForms
          : pluralForms // ignore: cast_nullable_to_non_nullable
              as String?,
      sortIndex: null == sortIndex
          ? _value.sortIndex
          : sortIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetLanguageId: freezed == targetLanguageId
          ? _value.targetLanguageId
          : targetLanguageId // ignore: cast_nullable_to_non_nullable
              as int?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
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
      {@JsonKey(name: 'uuid') String uuid,
      @JsonKey(name: 'project_id') String projectId,
      @JsonKey(name: 'entry_key') String entryKey,
      @JsonKey(name: 'source_language')
      @LanguageEnumConverter()
      LanguageEnum sourceLanguage,
      @JsonKey(name: 'target_language')
      @LanguageEnumConverter()
      LanguageEnum targetLanguage,
      @JsonKey(name: 'source_text') String sourceText,
      @JsonKey(name: 'target_text') String targetText,
      @JsonKey(name: 'status')
      @TranslationStatusEnumConverter()
      TranslationStatusEnum status,
      @JsonKey(name: 'translated_by') String? translatedBy,
      @JsonKey(name: 'translator_username') String? translatorUsername,
      @JsonKey(name: 'reviewed_by') String? reviewedBy,
      @JsonKey(name: 'reviewer_username') String? reviewerUsername,
      @JsonKey(name: 'context') String context,
      @JsonKey(name: 'comment') String comment,
      @JsonKey(name: 'max_length') int? maxLength,
      @JsonKey(name: 'is_plural') bool isPlural,
      @JsonKey(name: 'plural_forms') String? pluralForms,
      @JsonKey(name: 'sort_index') int sortIndex,
      @JsonKey(name: 'target_language_id') int? targetLanguageId,
      @JsonKey(name: 'deleted_at')
      @NullableTimesConverter()
      DateTime? deletedAt,
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
    Object? uuid = null,
    Object? projectId = null,
    Object? entryKey = null,
    Object? sourceLanguage = null,
    Object? targetLanguage = null,
    Object? sourceText = null,
    Object? targetText = null,
    Object? status = null,
    Object? translatedBy = freezed,
    Object? translatorUsername = freezed,
    Object? reviewedBy = freezed,
    Object? reviewerUsername = freezed,
    Object? context = null,
    Object? comment = null,
    Object? maxLength = freezed,
    Object? isPlural = null,
    Object? pluralForms = freezed,
    Object? sortIndex = null,
    Object? targetLanguageId = freezed,
    Object? deletedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TranslationEntryModelImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      entryKey: null == entryKey
          ? _value.entryKey
          : entryKey // ignore: cast_nullable_to_non_nullable
              as String,
      sourceLanguage: null == sourceLanguage
          ? _value.sourceLanguage
          : sourceLanguage // ignore: cast_nullable_to_non_nullable
              as LanguageEnum,
      targetLanguage: null == targetLanguage
          ? _value.targetLanguage
          : targetLanguage // ignore: cast_nullable_to_non_nullable
              as LanguageEnum,
      sourceText: null == sourceText
          ? _value.sourceText
          : sourceText // ignore: cast_nullable_to_non_nullable
              as String,
      targetText: null == targetText
          ? _value.targetText
          : targetText // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TranslationStatusEnum,
      translatedBy: freezed == translatedBy
          ? _value.translatedBy
          : translatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      translatorUsername: freezed == translatorUsername
          ? _value.translatorUsername
          : translatorUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerUsername: freezed == reviewerUsername
          ? _value.reviewerUsername
          : reviewerUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      maxLength: freezed == maxLength
          ? _value.maxLength
          : maxLength // ignore: cast_nullable_to_non_nullable
              as int?,
      isPlural: null == isPlural
          ? _value.isPlural
          : isPlural // ignore: cast_nullable_to_non_nullable
              as bool,
      pluralForms: freezed == pluralForms
          ? _value.pluralForms
          : pluralForms // ignore: cast_nullable_to_non_nullable
              as String?,
      sortIndex: null == sortIndex
          ? _value.sortIndex
          : sortIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetLanguageId: freezed == targetLanguageId
          ? _value.targetLanguageId
          : targetLanguageId // ignore: cast_nullable_to_non_nullable
              as int?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
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
      {@JsonKey(name: 'uuid') required this.uuid,
      @JsonKey(name: 'project_id') required this.projectId,
      @JsonKey(name: 'entry_key') required this.entryKey,
      @JsonKey(name: 'source_language')
      @LanguageEnumConverter()
      this.sourceLanguage = LanguageEnum.enUS,
      @JsonKey(name: 'target_language')
      @LanguageEnumConverter()
      required this.targetLanguage,
      @JsonKey(name: 'source_text') required this.sourceText,
      @JsonKey(name: 'target_text') required this.targetText,
      @JsonKey(name: 'status')
      @TranslationStatusEnumConverter()
      required this.status,
      @JsonKey(name: 'translated_by') this.translatedBy,
      @JsonKey(name: 'translator_username') this.translatorUsername,
      @JsonKey(name: 'reviewed_by') this.reviewedBy,
      @JsonKey(name: 'reviewer_username') this.reviewerUsername,
      @JsonKey(name: 'context') this.context = '',
      @JsonKey(name: 'comment') this.comment = '',
      @JsonKey(name: 'max_length') this.maxLength,
      @JsonKey(name: 'is_plural') this.isPlural = false,
      @JsonKey(name: 'plural_forms') this.pluralForms,
      @JsonKey(name: 'sort_index') this.sortIndex = 0.0,
      @JsonKey(name: 'target_language_id') this.targetLanguageId,
      @JsonKey(name: 'deleted_at') @NullableTimesConverter() this.deletedAt,
      @JsonKey(name: 'created_at') @NullableTimesConverter() this.createdAt,
      @JsonKey(name: 'updated_at') @NullableTimesConverter() this.updatedAt})
      : super._();

  factory _$TranslationEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslationEntryModelImplFromJson(json);

  /// UUID（用于分布式场景）
  @override
  @JsonKey(name: 'uuid')
  final String uuid;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  final String projectId;

  /// 条目键（优化字段）
  @override
  @JsonKey(name: 'entry_key')
  final String entryKey;

  /// 源语言ID
  @override
  @JsonKey(name: 'source_language')
  @LanguageEnumConverter()
  final LanguageEnum sourceLanguage;

  /// 目标语言ID
  @override
  @JsonKey(name: 'target_language')
  @LanguageEnumConverter()
  final LanguageEnum targetLanguage;

  /// 源文本
  @override
  @JsonKey(name: 'source_text')
  final String sourceText;

  /// 目标文本
  @override
  @JsonKey(name: 'target_text')
  final String targetText;

  /// 状态 (pending, completed, reviewing, approved)
  @override
  @JsonKey(name: 'status')
  @TranslationStatusEnumConverter()
  final TranslationStatusEnum status;

  /// 翻译者ID
  @override
  @JsonKey(name: 'translated_by')
  final String? translatedBy;

  /// 翻译者用户名（关联查询字段）
  @override
  @JsonKey(name: 'translator_username')
  final String? translatorUsername;

  /// 审核者ID
  @override
  @JsonKey(name: 'reviewed_by')
  final String? reviewedBy;

  /// 审核者用户名（关联查询字段）
  @override
  @JsonKey(name: 'reviewer_username')
  final String? reviewerUsername;

  /// 上下文信息
  @override
  @JsonKey(name: 'context')
  final String context;

  /// 备注
  @override
  @JsonKey(name: 'comment')
  final String comment;

  /// 最大长度限制
  @override
  @JsonKey(name: 'max_length')
  final int? maxLength;

  /// 是否为复数形式
  @override
  @JsonKey(name: 'is_plural')
  final bool isPlural;

  /// 复数形式（JSON字符串）
  @override
  @JsonKey(name: 'plural_forms')
  final String? pluralForms;

  /// 排序索引
  @override
  @JsonKey(name: 'sort_index')
  final int sortIndex;

  /// 目标语言ID（用于兼容旧代码）
  @override
  @JsonKey(name: 'target_language_id')
  final int? targetLanguageId;

  /// 删除时间
  @override
  @JsonKey(name: 'deleted_at')
  @NullableTimesConverter()
  final DateTime? deletedAt;

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
    return 'TranslationEntryModel(uuid: $uuid, projectId: $projectId, entryKey: $entryKey, sourceLanguage: $sourceLanguage, targetLanguage: $targetLanguage, sourceText: $sourceText, targetText: $targetText, status: $status, translatedBy: $translatedBy, translatorUsername: $translatorUsername, reviewedBy: $reviewedBy, reviewerUsername: $reviewerUsername, context: $context, comment: $comment, maxLength: $maxLength, isPlural: $isPlural, pluralForms: $pluralForms, sortIndex: $sortIndex, targetLanguageId: $targetLanguageId, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationEntryModelImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.entryKey, entryKey) ||
                other.entryKey == entryKey) &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage) &&
            (identical(other.sourceText, sourceText) ||
                other.sourceText == sourceText) &&
            (identical(other.targetText, targetText) ||
                other.targetText == targetText) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.translatedBy, translatedBy) ||
                other.translatedBy == translatedBy) &&
            (identical(other.translatorUsername, translatorUsername) ||
                other.translatorUsername == translatorUsername) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.reviewerUsername, reviewerUsername) ||
                other.reviewerUsername == reviewerUsername) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.maxLength, maxLength) ||
                other.maxLength == maxLength) &&
            (identical(other.isPlural, isPlural) ||
                other.isPlural == isPlural) &&
            (identical(other.pluralForms, pluralForms) ||
                other.pluralForms == pluralForms) &&
            (identical(other.sortIndex, sortIndex) ||
                other.sortIndex == sortIndex) &&
            (identical(other.targetLanguageId, targetLanguageId) ||
                other.targetLanguageId == targetLanguageId) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        uuid,
        projectId,
        entryKey,
        sourceLanguage,
        targetLanguage,
        sourceText,
        targetText,
        status,
        translatedBy,
        translatorUsername,
        reviewedBy,
        reviewerUsername,
        context,
        comment,
        maxLength,
        isPlural,
        pluralForms,
        sortIndex,
        targetLanguageId,
        deletedAt,
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
      {@JsonKey(name: 'uuid') required final String uuid,
      @JsonKey(name: 'project_id') required final String projectId,
      @JsonKey(name: 'entry_key') required final String entryKey,
      @JsonKey(name: 'source_language')
      @LanguageEnumConverter()
      final LanguageEnum sourceLanguage,
      @JsonKey(name: 'target_language')
      @LanguageEnumConverter()
      required final LanguageEnum targetLanguage,
      @JsonKey(name: 'source_text') required final String sourceText,
      @JsonKey(name: 'target_text') required final String targetText,
      @JsonKey(name: 'status')
      @TranslationStatusEnumConverter()
      required final TranslationStatusEnum status,
      @JsonKey(name: 'translated_by') final String? translatedBy,
      @JsonKey(name: 'translator_username') final String? translatorUsername,
      @JsonKey(name: 'reviewed_by') final String? reviewedBy,
      @JsonKey(name: 'reviewer_username') final String? reviewerUsername,
      @JsonKey(name: 'context') final String context,
      @JsonKey(name: 'comment') final String comment,
      @JsonKey(name: 'max_length') final int? maxLength,
      @JsonKey(name: 'is_plural') final bool isPlural,
      @JsonKey(name: 'plural_forms') final String? pluralForms,
      @JsonKey(name: 'sort_index') final int sortIndex,
      @JsonKey(name: 'target_language_id') final int? targetLanguageId,
      @JsonKey(name: 'deleted_at')
      @NullableTimesConverter()
      final DateTime? deletedAt,
      @JsonKey(name: 'created_at')
      @NullableTimesConverter()
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      @NullableTimesConverter()
      final DateTime? updatedAt}) = _$TranslationEntryModelImpl;
  const _TranslationEntryModel._() : super._();

  factory _TranslationEntryModel.fromJson(Map<String, dynamic> json) =
      _$TranslationEntryModelImpl.fromJson;

  /// UUID（用于分布式场景）
  @override
  @JsonKey(name: 'uuid')
  String get uuid;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  String get projectId;

  /// 条目键（优化字段）
  @override
  @JsonKey(name: 'entry_key')
  String get entryKey;

  /// 源语言ID
  @override
  @JsonKey(name: 'source_language')
  @LanguageEnumConverter()
  LanguageEnum get sourceLanguage;

  /// 目标语言ID
  @override
  @JsonKey(name: 'target_language')
  @LanguageEnumConverter()
  LanguageEnum get targetLanguage;

  /// 源文本
  @override
  @JsonKey(name: 'source_text')
  String get sourceText;

  /// 目标文本
  @override
  @JsonKey(name: 'target_text')
  String get targetText;

  /// 状态 (pending, completed, reviewing, approved)
  @override
  @JsonKey(name: 'status')
  @TranslationStatusEnumConverter()
  TranslationStatusEnum get status;

  /// 翻译者ID
  @override
  @JsonKey(name: 'translated_by')
  String? get translatedBy;

  /// 翻译者用户名（关联查询字段）
  @override
  @JsonKey(name: 'translator_username')
  String? get translatorUsername;

  /// 审核者ID
  @override
  @JsonKey(name: 'reviewed_by')
  String? get reviewedBy;

  /// 审核者用户名（关联查询字段）
  @override
  @JsonKey(name: 'reviewer_username')
  String? get reviewerUsername;

  /// 上下文信息
  @override
  @JsonKey(name: 'context')
  String get context;

  /// 备注
  @override
  @JsonKey(name: 'comment')
  String get comment;

  /// 最大长度限制
  @override
  @JsonKey(name: 'max_length')
  int? get maxLength;

  /// 是否为复数形式
  @override
  @JsonKey(name: 'is_plural')
  bool get isPlural;

  /// 复数形式（JSON字符串）
  @override
  @JsonKey(name: 'plural_forms')
  String? get pluralForms;

  /// 排序索引
  @override
  @JsonKey(name: 'sort_index')
  int get sortIndex;

  /// 目标语言ID（用于兼容旧代码）
  @override
  @JsonKey(name: 'target_language_id')
  int? get targetLanguageId;

  /// 删除时间
  @override
  @JsonKey(name: 'deleted_at')
  @NullableTimesConverter()
  DateTime? get deletedAt;

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
