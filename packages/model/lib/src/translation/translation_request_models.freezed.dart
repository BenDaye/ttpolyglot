// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_request_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateTranslationKeyRequest _$CreateTranslationKeyRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateTranslationKeyRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateTranslationKeyRequest {
  /// 项目ID
  @JsonKey(name: 'project_id')
  String get projectId => throw _privateConstructorUsedError;

  /// 条目键
  @JsonKey(name: 'entry_key')
  String get entryKey => throw _privateConstructorUsedError;

  /// 源语言
  @JsonKey(name: 'source_language')
  @LanguageEnumConverter()
  LanguageEnum get sourceLanguage => throw _privateConstructorUsedError;

  /// 目标语言列表
  @JsonKey(name: 'target_languages')
  List<LanguageEnum> get targetLanguages => throw _privateConstructorUsedError;

  /// 源文本
  @JsonKey(name: 'source_text')
  String get sourceText => throw _privateConstructorUsedError;

  /// 上下文信息
  @JsonKey(name: 'context')
  String? get context => throw _privateConstructorUsedError;

  /// 最大长度限制
  @JsonKey(name: 'max_length')
  int? get maxLength => throw _privateConstructorUsedError;

  /// 是否为复数形式
  @JsonKey(name: 'is_plural')
  bool get isPlural => throw _privateConstructorUsedError;

  /// 复数形式
  @JsonKey(name: 'plural_forms')
  String? get pluralForms => throw _privateConstructorUsedError;

  /// Serializes this CreateTranslationKeyRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateTranslationKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateTranslationKeyRequestCopyWith<CreateTranslationKeyRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTranslationKeyRequestCopyWith<$Res> {
  factory $CreateTranslationKeyRequestCopyWith(
          CreateTranslationKeyRequest value,
          $Res Function(CreateTranslationKeyRequest) then) =
      _$CreateTranslationKeyRequestCopyWithImpl<$Res,
          CreateTranslationKeyRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'project_id') String projectId,
      @JsonKey(name: 'entry_key') String entryKey,
      @JsonKey(name: 'source_language')
      @LanguageEnumConverter()
      LanguageEnum sourceLanguage,
      @JsonKey(name: 'target_languages') List<LanguageEnum> targetLanguages,
      @JsonKey(name: 'source_text') String sourceText,
      @JsonKey(name: 'context') String? context,
      @JsonKey(name: 'max_length') int? maxLength,
      @JsonKey(name: 'is_plural') bool isPlural,
      @JsonKey(name: 'plural_forms') String? pluralForms});
}

/// @nodoc
class _$CreateTranslationKeyRequestCopyWithImpl<$Res,
        $Val extends CreateTranslationKeyRequest>
    implements $CreateTranslationKeyRequestCopyWith<$Res> {
  _$CreateTranslationKeyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateTranslationKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? entryKey = null,
    Object? sourceLanguage = null,
    Object? targetLanguages = null,
    Object? sourceText = null,
    Object? context = freezed,
    Object? maxLength = freezed,
    Object? isPlural = null,
    Object? pluralForms = freezed,
  }) {
    return _then(_value.copyWith(
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
      targetLanguages: null == targetLanguages
          ? _value.targetLanguages
          : targetLanguages // ignore: cast_nullable_to_non_nullable
              as List<LanguageEnum>,
      sourceText: null == sourceText
          ? _value.sourceText
          : sourceText // ignore: cast_nullable_to_non_nullable
              as String,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateTranslationKeyRequestImplCopyWith<$Res>
    implements $CreateTranslationKeyRequestCopyWith<$Res> {
  factory _$$CreateTranslationKeyRequestImplCopyWith(
          _$CreateTranslationKeyRequestImpl value,
          $Res Function(_$CreateTranslationKeyRequestImpl) then) =
      __$$CreateTranslationKeyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'project_id') String projectId,
      @JsonKey(name: 'entry_key') String entryKey,
      @JsonKey(name: 'source_language')
      @LanguageEnumConverter()
      LanguageEnum sourceLanguage,
      @JsonKey(name: 'target_languages') List<LanguageEnum> targetLanguages,
      @JsonKey(name: 'source_text') String sourceText,
      @JsonKey(name: 'context') String? context,
      @JsonKey(name: 'max_length') int? maxLength,
      @JsonKey(name: 'is_plural') bool isPlural,
      @JsonKey(name: 'plural_forms') String? pluralForms});
}

/// @nodoc
class __$$CreateTranslationKeyRequestImplCopyWithImpl<$Res>
    extends _$CreateTranslationKeyRequestCopyWithImpl<$Res,
        _$CreateTranslationKeyRequestImpl>
    implements _$$CreateTranslationKeyRequestImplCopyWith<$Res> {
  __$$CreateTranslationKeyRequestImplCopyWithImpl(
      _$CreateTranslationKeyRequestImpl _value,
      $Res Function(_$CreateTranslationKeyRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateTranslationKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? entryKey = null,
    Object? sourceLanguage = null,
    Object? targetLanguages = null,
    Object? sourceText = null,
    Object? context = freezed,
    Object? maxLength = freezed,
    Object? isPlural = null,
    Object? pluralForms = freezed,
  }) {
    return _then(_$CreateTranslationKeyRequestImpl(
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
      targetLanguages: null == targetLanguages
          ? _value._targetLanguages
          : targetLanguages // ignore: cast_nullable_to_non_nullable
              as List<LanguageEnum>,
      sourceText: null == sourceText
          ? _value.sourceText
          : sourceText // ignore: cast_nullable_to_non_nullable
              as String,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateTranslationKeyRequestImpl
    implements _CreateTranslationKeyRequest {
  const _$CreateTranslationKeyRequestImpl(
      {@JsonKey(name: 'project_id') required this.projectId,
      @JsonKey(name: 'entry_key') required this.entryKey,
      @JsonKey(name: 'source_language')
      @LanguageEnumConverter()
      required this.sourceLanguage,
      @JsonKey(name: 'target_languages')
      final List<LanguageEnum> targetLanguages = const [],
      @JsonKey(name: 'source_text') required this.sourceText,
      @JsonKey(name: 'context') this.context,
      @JsonKey(name: 'max_length') this.maxLength,
      @JsonKey(name: 'is_plural') this.isPlural = false,
      @JsonKey(name: 'plural_forms') this.pluralForms})
      : _targetLanguages = targetLanguages;

  factory _$CreateTranslationKeyRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateTranslationKeyRequestImplFromJson(json);

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  final String projectId;

  /// 条目键
  @override
  @JsonKey(name: 'entry_key')
  final String entryKey;

  /// 源语言
  @override
  @JsonKey(name: 'source_language')
  @LanguageEnumConverter()
  final LanguageEnum sourceLanguage;

  /// 目标语言列表
  final List<LanguageEnum> _targetLanguages;

  /// 目标语言列表
  @override
  @JsonKey(name: 'target_languages')
  List<LanguageEnum> get targetLanguages {
    if (_targetLanguages is EqualUnmodifiableListView) return _targetLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetLanguages);
  }

  /// 源文本
  @override
  @JsonKey(name: 'source_text')
  final String sourceText;

  /// 上下文信息
  @override
  @JsonKey(name: 'context')
  final String? context;

  /// 最大长度限制
  @override
  @JsonKey(name: 'max_length')
  final int? maxLength;

  /// 是否为复数形式
  @override
  @JsonKey(name: 'is_plural')
  final bool isPlural;

  /// 复数形式
  @override
  @JsonKey(name: 'plural_forms')
  final String? pluralForms;

  @override
  String toString() {
    return 'CreateTranslationKeyRequest(projectId: $projectId, entryKey: $entryKey, sourceLanguage: $sourceLanguage, targetLanguages: $targetLanguages, sourceText: $sourceText, context: $context, maxLength: $maxLength, isPlural: $isPlural, pluralForms: $pluralForms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTranslationKeyRequestImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.entryKey, entryKey) ||
                other.entryKey == entryKey) &&
            (identical(other.sourceLanguage, sourceLanguage) ||
                other.sourceLanguage == sourceLanguage) &&
            const DeepCollectionEquality()
                .equals(other._targetLanguages, _targetLanguages) &&
            (identical(other.sourceText, sourceText) ||
                other.sourceText == sourceText) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.maxLength, maxLength) ||
                other.maxLength == maxLength) &&
            (identical(other.isPlural, isPlural) ||
                other.isPlural == isPlural) &&
            (identical(other.pluralForms, pluralForms) ||
                other.pluralForms == pluralForms));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      projectId,
      entryKey,
      sourceLanguage,
      const DeepCollectionEquality().hash(_targetLanguages),
      sourceText,
      context,
      maxLength,
      isPlural,
      pluralForms);

  /// Create a copy of CreateTranslationKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTranslationKeyRequestImplCopyWith<_$CreateTranslationKeyRequestImpl>
      get copyWith => __$$CreateTranslationKeyRequestImplCopyWithImpl<
          _$CreateTranslationKeyRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateTranslationKeyRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateTranslationKeyRequest
    implements CreateTranslationKeyRequest {
  const factory _CreateTranslationKeyRequest(
          {@JsonKey(name: 'project_id') required final String projectId,
          @JsonKey(name: 'entry_key') required final String entryKey,
          @JsonKey(name: 'source_language')
          @LanguageEnumConverter()
          required final LanguageEnum sourceLanguage,
          @JsonKey(name: 'target_languages')
          final List<LanguageEnum> targetLanguages,
          @JsonKey(name: 'source_text') required final String sourceText,
          @JsonKey(name: 'context') final String? context,
          @JsonKey(name: 'max_length') final int? maxLength,
          @JsonKey(name: 'is_plural') final bool isPlural,
          @JsonKey(name: 'plural_forms') final String? pluralForms}) =
      _$CreateTranslationKeyRequestImpl;

  factory _CreateTranslationKeyRequest.fromJson(Map<String, dynamic> json) =
      _$CreateTranslationKeyRequestImpl.fromJson;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  String get projectId;

  /// 条目键
  @override
  @JsonKey(name: 'entry_key')
  String get entryKey;

  /// 源语言
  @override
  @JsonKey(name: 'source_language')
  @LanguageEnumConverter()
  LanguageEnum get sourceLanguage;

  /// 目标语言列表
  @override
  @JsonKey(name: 'target_languages')
  List<LanguageEnum> get targetLanguages;

  /// 源文本
  @override
  @JsonKey(name: 'source_text')
  String get sourceText;

  /// 上下文信息
  @override
  @JsonKey(name: 'context')
  String? get context;

  /// 最大长度限制
  @override
  @JsonKey(name: 'max_length')
  int? get maxLength;

  /// 是否为复数形式
  @override
  @JsonKey(name: 'is_plural')
  bool get isPlural;

  /// 复数形式
  @override
  @JsonKey(name: 'plural_forms')
  String? get pluralForms;

  /// Create a copy of CreateTranslationKeyRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateTranslationKeyRequestImplCopyWith<_$CreateTranslationKeyRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateTranslationRequest _$UpdateTranslationRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateTranslationRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateTranslationRequest {
  /// 目标文本
  @JsonKey(name: 'target_text')
  String? get targetText => throw _privateConstructorUsedError;

  /// 状态
  @JsonKey(name: 'status')
  @TranslationStatusEnumConverter()
  TranslationStatusEnum? get status => throw _privateConstructorUsedError;

  /// 上下文信息
  @JsonKey(name: 'context')
  String? get context => throw _privateConstructorUsedError;

  /// 备注
  @JsonKey(name: 'comment')
  String? get comment => throw _privateConstructorUsedError;

  /// Serializes this UpdateTranslationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateTranslationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateTranslationRequestCopyWith<UpdateTranslationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateTranslationRequestCopyWith<$Res> {
  factory $UpdateTranslationRequestCopyWith(UpdateTranslationRequest value,
          $Res Function(UpdateTranslationRequest) then) =
      _$UpdateTranslationRequestCopyWithImpl<$Res, UpdateTranslationRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'target_text') String? targetText,
      @JsonKey(name: 'status')
      @TranslationStatusEnumConverter()
      TranslationStatusEnum? status,
      @JsonKey(name: 'context') String? context,
      @JsonKey(name: 'comment') String? comment});
}

/// @nodoc
class _$UpdateTranslationRequestCopyWithImpl<$Res,
        $Val extends UpdateTranslationRequest>
    implements $UpdateTranslationRequestCopyWith<$Res> {
  _$UpdateTranslationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateTranslationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetText = freezed,
    Object? status = freezed,
    Object? context = freezed,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      targetText: freezed == targetText
          ? _value.targetText
          : targetText // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TranslationStatusEnum?,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateTranslationRequestImplCopyWith<$Res>
    implements $UpdateTranslationRequestCopyWith<$Res> {
  factory _$$UpdateTranslationRequestImplCopyWith(
          _$UpdateTranslationRequestImpl value,
          $Res Function(_$UpdateTranslationRequestImpl) then) =
      __$$UpdateTranslationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'target_text') String? targetText,
      @JsonKey(name: 'status')
      @TranslationStatusEnumConverter()
      TranslationStatusEnum? status,
      @JsonKey(name: 'context') String? context,
      @JsonKey(name: 'comment') String? comment});
}

/// @nodoc
class __$$UpdateTranslationRequestImplCopyWithImpl<$Res>
    extends _$UpdateTranslationRequestCopyWithImpl<$Res,
        _$UpdateTranslationRequestImpl>
    implements _$$UpdateTranslationRequestImplCopyWith<$Res> {
  __$$UpdateTranslationRequestImplCopyWithImpl(
      _$UpdateTranslationRequestImpl _value,
      $Res Function(_$UpdateTranslationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateTranslationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetText = freezed,
    Object? status = freezed,
    Object? context = freezed,
    Object? comment = freezed,
  }) {
    return _then(_$UpdateTranslationRequestImpl(
      targetText: freezed == targetText
          ? _value.targetText
          : targetText // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TranslationStatusEnum?,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateTranslationRequestImpl implements _UpdateTranslationRequest {
  const _$UpdateTranslationRequestImpl(
      {@JsonKey(name: 'target_text') this.targetText,
      @JsonKey(name: 'status') @TranslationStatusEnumConverter() this.status,
      @JsonKey(name: 'context') this.context,
      @JsonKey(name: 'comment') this.comment});

  factory _$UpdateTranslationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateTranslationRequestImplFromJson(json);

  /// 目标文本
  @override
  @JsonKey(name: 'target_text')
  final String? targetText;

  /// 状态
  @override
  @JsonKey(name: 'status')
  @TranslationStatusEnumConverter()
  final TranslationStatusEnum? status;

  /// 上下文信息
  @override
  @JsonKey(name: 'context')
  final String? context;

  /// 备注
  @override
  @JsonKey(name: 'comment')
  final String? comment;

  @override
  String toString() {
    return 'UpdateTranslationRequest(targetText: $targetText, status: $status, context: $context, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateTranslationRequestImpl &&
            (identical(other.targetText, targetText) ||
                other.targetText == targetText) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetText, status, context, comment);

  /// Create a copy of UpdateTranslationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateTranslationRequestImplCopyWith<_$UpdateTranslationRequestImpl>
      get copyWith => __$$UpdateTranslationRequestImplCopyWithImpl<
          _$UpdateTranslationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateTranslationRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateTranslationRequest implements UpdateTranslationRequest {
  const factory _UpdateTranslationRequest(
          {@JsonKey(name: 'target_text') final String? targetText,
          @JsonKey(name: 'status')
          @TranslationStatusEnumConverter()
          final TranslationStatusEnum? status,
          @JsonKey(name: 'context') final String? context,
          @JsonKey(name: 'comment') final String? comment}) =
      _$UpdateTranslationRequestImpl;

  factory _UpdateTranslationRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateTranslationRequestImpl.fromJson;

  /// 目标文本
  @override
  @JsonKey(name: 'target_text')
  String? get targetText;

  /// 状态
  @override
  @JsonKey(name: 'status')
  @TranslationStatusEnumConverter()
  TranslationStatusEnum? get status;

  /// 上下文信息
  @override
  @JsonKey(name: 'context')
  String? get context;

  /// 备注
  @override
  @JsonKey(name: 'comment')
  String? get comment;

  /// Create a copy of UpdateTranslationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateTranslationRequestImplCopyWith<_$UpdateTranslationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BatchTranslationRequest _$BatchTranslationRequestFromJson(
    Map<String, dynamic> json) {
  return _BatchTranslationRequest.fromJson(json);
}

/// @nodoc
mixin _$BatchTranslationRequest {
  /// 翻译条目ID列表
  @JsonKey(name: 'entry_ids')
  List<String> get entryIds => throw _privateConstructorUsedError;

  /// 目标语言
  @JsonKey(name: 'target_language')
  @LanguageEnumConverter()
  LanguageEnum? get targetLanguage => throw _privateConstructorUsedError;

  /// 翻译提供商
  @JsonKey(name: 'provider')
  @TranslationProviderEnumConverter()
  TranslationProviderEnum? get provider => throw _privateConstructorUsedError;

  /// Serializes this BatchTranslationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BatchTranslationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchTranslationRequestCopyWith<BatchTranslationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchTranslationRequestCopyWith<$Res> {
  factory $BatchTranslationRequestCopyWith(BatchTranslationRequest value,
          $Res Function(BatchTranslationRequest) then) =
      _$BatchTranslationRequestCopyWithImpl<$Res, BatchTranslationRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'entry_ids') List<String> entryIds,
      @JsonKey(name: 'target_language')
      @LanguageEnumConverter()
      LanguageEnum? targetLanguage,
      @JsonKey(name: 'provider')
      @TranslationProviderEnumConverter()
      TranslationProviderEnum? provider});
}

/// @nodoc
class _$BatchTranslationRequestCopyWithImpl<$Res,
        $Val extends BatchTranslationRequest>
    implements $BatchTranslationRequestCopyWith<$Res> {
  _$BatchTranslationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchTranslationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryIds = null,
    Object? targetLanguage = freezed,
    Object? provider = freezed,
  }) {
    return _then(_value.copyWith(
      entryIds: null == entryIds
          ? _value.entryIds
          : entryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      targetLanguage: freezed == targetLanguage
          ? _value.targetLanguage
          : targetLanguage // ignore: cast_nullable_to_non_nullable
              as LanguageEnum?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as TranslationProviderEnum?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchTranslationRequestImplCopyWith<$Res>
    implements $BatchTranslationRequestCopyWith<$Res> {
  factory _$$BatchTranslationRequestImplCopyWith(
          _$BatchTranslationRequestImpl value,
          $Res Function(_$BatchTranslationRequestImpl) then) =
      __$$BatchTranslationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'entry_ids') List<String> entryIds,
      @JsonKey(name: 'target_language')
      @LanguageEnumConverter()
      LanguageEnum? targetLanguage,
      @JsonKey(name: 'provider')
      @TranslationProviderEnumConverter()
      TranslationProviderEnum? provider});
}

/// @nodoc
class __$$BatchTranslationRequestImplCopyWithImpl<$Res>
    extends _$BatchTranslationRequestCopyWithImpl<$Res,
        _$BatchTranslationRequestImpl>
    implements _$$BatchTranslationRequestImplCopyWith<$Res> {
  __$$BatchTranslationRequestImplCopyWithImpl(
      _$BatchTranslationRequestImpl _value,
      $Res Function(_$BatchTranslationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of BatchTranslationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entryIds = null,
    Object? targetLanguage = freezed,
    Object? provider = freezed,
  }) {
    return _then(_$BatchTranslationRequestImpl(
      entryIds: null == entryIds
          ? _value._entryIds
          : entryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      targetLanguage: freezed == targetLanguage
          ? _value.targetLanguage
          : targetLanguage // ignore: cast_nullable_to_non_nullable
              as LanguageEnum?,
      provider: freezed == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as TranslationProviderEnum?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchTranslationRequestImpl implements _BatchTranslationRequest {
  const _$BatchTranslationRequestImpl(
      {@JsonKey(name: 'entry_ids') required final List<String> entryIds,
      @JsonKey(name: 'target_language')
      @LanguageEnumConverter()
      this.targetLanguage,
      @JsonKey(name: 'provider')
      @TranslationProviderEnumConverter()
      this.provider})
      : _entryIds = entryIds;

  factory _$BatchTranslationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatchTranslationRequestImplFromJson(json);

  /// 翻译条目ID列表
  final List<String> _entryIds;

  /// 翻译条目ID列表
  @override
  @JsonKey(name: 'entry_ids')
  List<String> get entryIds {
    if (_entryIds is EqualUnmodifiableListView) return _entryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entryIds);
  }

  /// 目标语言
  @override
  @JsonKey(name: 'target_language')
  @LanguageEnumConverter()
  final LanguageEnum? targetLanguage;

  /// 翻译提供商
  @override
  @JsonKey(name: 'provider')
  @TranslationProviderEnumConverter()
  final TranslationProviderEnum? provider;

  @override
  String toString() {
    return 'BatchTranslationRequest(entryIds: $entryIds, targetLanguage: $targetLanguage, provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchTranslationRequestImpl &&
            const DeepCollectionEquality().equals(other._entryIds, _entryIds) &&
            (identical(other.targetLanguage, targetLanguage) ||
                other.targetLanguage == targetLanguage) &&
            (identical(other.provider, provider) ||
                other.provider == provider));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_entryIds), targetLanguage, provider);

  /// Create a copy of BatchTranslationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchTranslationRequestImplCopyWith<_$BatchTranslationRequestImpl>
      get copyWith => __$$BatchTranslationRequestImplCopyWithImpl<
          _$BatchTranslationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchTranslationRequestImplToJson(
      this,
    );
  }
}

abstract class _BatchTranslationRequest implements BatchTranslationRequest {
  const factory _BatchTranslationRequest(
      {@JsonKey(name: 'entry_ids') required final List<String> entryIds,
      @JsonKey(name: 'target_language')
      @LanguageEnumConverter()
      final LanguageEnum? targetLanguage,
      @JsonKey(name: 'provider')
      @TranslationProviderEnumConverter()
      final TranslationProviderEnum? provider}) = _$BatchTranslationRequestImpl;

  factory _BatchTranslationRequest.fromJson(Map<String, dynamic> json) =
      _$BatchTranslationRequestImpl.fromJson;

  /// 翻译条目ID列表
  @override
  @JsonKey(name: 'entry_ids')
  List<String> get entryIds;

  /// 目标语言
  @override
  @JsonKey(name: 'target_language')
  @LanguageEnumConverter()
  LanguageEnum? get targetLanguage;

  /// 翻译提供商
  @override
  @JsonKey(name: 'provider')
  @TranslationProviderEnumConverter()
  TranslationProviderEnum? get provider;

  /// Create a copy of BatchTranslationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchTranslationRequestImplCopyWith<_$BatchTranslationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
