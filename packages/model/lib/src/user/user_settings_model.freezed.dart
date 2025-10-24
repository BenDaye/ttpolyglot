// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSettingsModel _$UserSettingsModelFromJson(Map<String, dynamic> json) {
  return _UserSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$UserSettingsModel {
  /// 语言设置
  @JsonKey(name: 'language_settings')
  LanguageSettingsModel get languageSettings =>
      throw _privateConstructorUsedError;

  /// 通用设置
  @JsonKey(name: 'general_settings')
  GeneralSettingsModel get generalSettings =>
      throw _privateConstructorUsedError;

  /// 翻译设置
  @JsonKey(name: 'translation_settings')
  TranslationSettingsModel get translationSettings =>
      throw _privateConstructorUsedError;

  /// 创建时间
  @JsonKey(name: 'created_at')
  @NullableTimesConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  @JsonKey(name: 'updated_at')
  @NullableTimesConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSettingsModelCopyWith<UserSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsModelCopyWith<$Res> {
  factory $UserSettingsModelCopyWith(
          UserSettingsModel value, $Res Function(UserSettingsModel) then) =
      _$UserSettingsModelCopyWithImpl<$Res, UserSettingsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'language_settings')
      LanguageSettingsModel languageSettings,
      @JsonKey(name: 'general_settings') GeneralSettingsModel generalSettings,
      @JsonKey(name: 'translation_settings')
      TranslationSettingsModel translationSettings,
      @JsonKey(name: 'created_at')
      @NullableTimesConverter()
      DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      @NullableTimesConverter()
      DateTime? updatedAt});

  $LanguageSettingsModelCopyWith<$Res> get languageSettings;
  $GeneralSettingsModelCopyWith<$Res> get generalSettings;
  $TranslationSettingsModelCopyWith<$Res> get translationSettings;
}

/// @nodoc
class _$UserSettingsModelCopyWithImpl<$Res, $Val extends UserSettingsModel>
    implements $UserSettingsModelCopyWith<$Res> {
  _$UserSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageSettings = null,
    Object? generalSettings = null,
    Object? translationSettings = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      languageSettings: null == languageSettings
          ? _value.languageSettings
          : languageSettings // ignore: cast_nullable_to_non_nullable
              as LanguageSettingsModel,
      generalSettings: null == generalSettings
          ? _value.generalSettings
          : generalSettings // ignore: cast_nullable_to_non_nullable
              as GeneralSettingsModel,
      translationSettings: null == translationSettings
          ? _value.translationSettings
          : translationSettings // ignore: cast_nullable_to_non_nullable
              as TranslationSettingsModel,
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

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LanguageSettingsModelCopyWith<$Res> get languageSettings {
    return $LanguageSettingsModelCopyWith<$Res>(_value.languageSettings,
        (value) {
      return _then(_value.copyWith(languageSettings: value) as $Val);
    });
  }

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeneralSettingsModelCopyWith<$Res> get generalSettings {
    return $GeneralSettingsModelCopyWith<$Res>(_value.generalSettings, (value) {
      return _then(_value.copyWith(generalSettings: value) as $Val);
    });
  }

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TranslationSettingsModelCopyWith<$Res> get translationSettings {
    return $TranslationSettingsModelCopyWith<$Res>(_value.translationSettings,
        (value) {
      return _then(_value.copyWith(translationSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserSettingsModelImplCopyWith<$Res>
    implements $UserSettingsModelCopyWith<$Res> {
  factory _$$UserSettingsModelImplCopyWith(_$UserSettingsModelImpl value,
          $Res Function(_$UserSettingsModelImpl) then) =
      __$$UserSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'language_settings')
      LanguageSettingsModel languageSettings,
      @JsonKey(name: 'general_settings') GeneralSettingsModel generalSettings,
      @JsonKey(name: 'translation_settings')
      TranslationSettingsModel translationSettings,
      @JsonKey(name: 'created_at')
      @NullableTimesConverter()
      DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      @NullableTimesConverter()
      DateTime? updatedAt});

  @override
  $LanguageSettingsModelCopyWith<$Res> get languageSettings;
  @override
  $GeneralSettingsModelCopyWith<$Res> get generalSettings;
  @override
  $TranslationSettingsModelCopyWith<$Res> get translationSettings;
}

/// @nodoc
class __$$UserSettingsModelImplCopyWithImpl<$Res>
    extends _$UserSettingsModelCopyWithImpl<$Res, _$UserSettingsModelImpl>
    implements _$$UserSettingsModelImplCopyWith<$Res> {
  __$$UserSettingsModelImplCopyWithImpl(_$UserSettingsModelImpl _value,
      $Res Function(_$UserSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageSettings = null,
    Object? generalSettings = null,
    Object? translationSettings = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserSettingsModelImpl(
      languageSettings: null == languageSettings
          ? _value.languageSettings
          : languageSettings // ignore: cast_nullable_to_non_nullable
              as LanguageSettingsModel,
      generalSettings: null == generalSettings
          ? _value.generalSettings
          : generalSettings // ignore: cast_nullable_to_non_nullable
              as GeneralSettingsModel,
      translationSettings: null == translationSettings
          ? _value.translationSettings
          : translationSettings // ignore: cast_nullable_to_non_nullable
              as TranslationSettingsModel,
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
class _$UserSettingsModelImpl implements _UserSettingsModel {
  const _$UserSettingsModelImpl(
      {@JsonKey(name: 'language_settings') required this.languageSettings,
      @JsonKey(name: 'general_settings') required this.generalSettings,
      @JsonKey(name: 'translation_settings') required this.translationSettings,
      @JsonKey(name: 'created_at') @NullableTimesConverter() this.createdAt,
      @JsonKey(name: 'updated_at') @NullableTimesConverter() this.updatedAt});

  factory _$UserSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsModelImplFromJson(json);

  /// 语言设置
  @override
  @JsonKey(name: 'language_settings')
  final LanguageSettingsModel languageSettings;

  /// 通用设置
  @override
  @JsonKey(name: 'general_settings')
  final GeneralSettingsModel generalSettings;

  /// 翻译设置
  @override
  @JsonKey(name: 'translation_settings')
  final TranslationSettingsModel translationSettings;

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
    return 'UserSettingsModel(languageSettings: $languageSettings, generalSettings: $generalSettings, translationSettings: $translationSettings, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsModelImpl &&
            (identical(other.languageSettings, languageSettings) ||
                other.languageSettings == languageSettings) &&
            (identical(other.generalSettings, generalSettings) ||
                other.generalSettings == generalSettings) &&
            (identical(other.translationSettings, translationSettings) ||
                other.translationSettings == translationSettings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, languageSettings,
      generalSettings, translationSettings, createdAt, updatedAt);

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsModelImplCopyWith<_$UserSettingsModelImpl> get copyWith =>
      __$$UserSettingsModelImplCopyWithImpl<_$UserSettingsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _UserSettingsModel implements UserSettingsModel {
  const factory _UserSettingsModel(
      {@JsonKey(name: 'language_settings')
      required final LanguageSettingsModel languageSettings,
      @JsonKey(name: 'general_settings')
      required final GeneralSettingsModel generalSettings,
      @JsonKey(name: 'translation_settings')
      required final TranslationSettingsModel translationSettings,
      @JsonKey(name: 'created_at')
      @NullableTimesConverter()
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      @NullableTimesConverter()
      final DateTime? updatedAt}) = _$UserSettingsModelImpl;

  factory _UserSettingsModel.fromJson(Map<String, dynamic> json) =
      _$UserSettingsModelImpl.fromJson;

  /// 语言设置
  @override
  @JsonKey(name: 'language_settings')
  LanguageSettingsModel get languageSettings;

  /// 通用设置
  @override
  @JsonKey(name: 'general_settings')
  GeneralSettingsModel get generalSettings;

  /// 翻译设置
  @override
  @JsonKey(name: 'translation_settings')
  TranslationSettingsModel get translationSettings;

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

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSettingsModelImplCopyWith<_$UserSettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LanguageSettingsModel _$LanguageSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _LanguageSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$LanguageSettingsModel {
  /// 应用语言代码
  @JsonKey(name: 'language_code')
  @LanguageEnumConverter()
  LanguageEnum? get languageCode => throw _privateConstructorUsedError;

  /// Serializes this LanguageSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LanguageSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanguageSettingsModelCopyWith<LanguageSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguageSettingsModelCopyWith<$Res> {
  factory $LanguageSettingsModelCopyWith(LanguageSettingsModel value,
          $Res Function(LanguageSettingsModel) then) =
      _$LanguageSettingsModelCopyWithImpl<$Res, LanguageSettingsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'language_code')
      @LanguageEnumConverter()
      LanguageEnum? languageCode});
}

/// @nodoc
class _$LanguageSettingsModelCopyWithImpl<$Res,
        $Val extends LanguageSettingsModel>
    implements $LanguageSettingsModelCopyWith<$Res> {
  _$LanguageSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LanguageSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = freezed,
  }) {
    return _then(_value.copyWith(
      languageCode: freezed == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as LanguageEnum?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LanguageSettingsModelImplCopyWith<$Res>
    implements $LanguageSettingsModelCopyWith<$Res> {
  factory _$$LanguageSettingsModelImplCopyWith(
          _$LanguageSettingsModelImpl value,
          $Res Function(_$LanguageSettingsModelImpl) then) =
      __$$LanguageSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'language_code')
      @LanguageEnumConverter()
      LanguageEnum? languageCode});
}

/// @nodoc
class __$$LanguageSettingsModelImplCopyWithImpl<$Res>
    extends _$LanguageSettingsModelCopyWithImpl<$Res,
        _$LanguageSettingsModelImpl>
    implements _$$LanguageSettingsModelImplCopyWith<$Res> {
  __$$LanguageSettingsModelImplCopyWithImpl(_$LanguageSettingsModelImpl _value,
      $Res Function(_$LanguageSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LanguageSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = freezed,
  }) {
    return _then(_$LanguageSettingsModelImpl(
      languageCode: freezed == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as LanguageEnum?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LanguageSettingsModelImpl implements _LanguageSettingsModel {
  const _$LanguageSettingsModelImpl(
      {@JsonKey(name: 'language_code')
      @LanguageEnumConverter()
      this.languageCode});

  factory _$LanguageSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanguageSettingsModelImplFromJson(json);

  /// 应用语言代码
  @override
  @JsonKey(name: 'language_code')
  @LanguageEnumConverter()
  final LanguageEnum? languageCode;

  @override
  String toString() {
    return 'LanguageSettingsModel(languageCode: $languageCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageSettingsModelImpl &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, languageCode);

  /// Create a copy of LanguageSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageSettingsModelImplCopyWith<_$LanguageSettingsModelImpl>
      get copyWith => __$$LanguageSettingsModelImplCopyWithImpl<
          _$LanguageSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguageSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _LanguageSettingsModel implements LanguageSettingsModel {
  const factory _LanguageSettingsModel(
      {@JsonKey(name: 'language_code')
      @LanguageEnumConverter()
      final LanguageEnum? languageCode}) = _$LanguageSettingsModelImpl;

  factory _LanguageSettingsModel.fromJson(Map<String, dynamic> json) =
      _$LanguageSettingsModelImpl.fromJson;

  /// 应用语言代码
  @override
  @JsonKey(name: 'language_code')
  @LanguageEnumConverter()
  LanguageEnum? get languageCode;

  /// Create a copy of LanguageSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanguageSettingsModelImplCopyWith<_$LanguageSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

GeneralSettingsModel _$GeneralSettingsModelFromJson(Map<String, dynamic> json) {
  return _GeneralSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$GeneralSettingsModel {
  /// 自动保存
  @JsonKey(name: 'auto_save')
  bool get autoSave => throw _privateConstructorUsedError;

  /// 通知
  bool get notifications => throw _privateConstructorUsedError;

  /// Serializes this GeneralSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeneralSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeneralSettingsModelCopyWith<GeneralSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneralSettingsModelCopyWith<$Res> {
  factory $GeneralSettingsModelCopyWith(GeneralSettingsModel value,
          $Res Function(GeneralSettingsModel) then) =
      _$GeneralSettingsModelCopyWithImpl<$Res, GeneralSettingsModel>;
  @useResult
  $Res call({@JsonKey(name: 'auto_save') bool autoSave, bool notifications});
}

/// @nodoc
class _$GeneralSettingsModelCopyWithImpl<$Res,
        $Val extends GeneralSettingsModel>
    implements $GeneralSettingsModelCopyWith<$Res> {
  _$GeneralSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeneralSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoSave = null,
    Object? notifications = null,
  }) {
    return _then(_value.copyWith(
      autoSave: null == autoSave
          ? _value.autoSave
          : autoSave // ignore: cast_nullable_to_non_nullable
              as bool,
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeneralSettingsModelImplCopyWith<$Res>
    implements $GeneralSettingsModelCopyWith<$Res> {
  factory _$$GeneralSettingsModelImplCopyWith(_$GeneralSettingsModelImpl value,
          $Res Function(_$GeneralSettingsModelImpl) then) =
      __$$GeneralSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'auto_save') bool autoSave, bool notifications});
}

/// @nodoc
class __$$GeneralSettingsModelImplCopyWithImpl<$Res>
    extends _$GeneralSettingsModelCopyWithImpl<$Res, _$GeneralSettingsModelImpl>
    implements _$$GeneralSettingsModelImplCopyWith<$Res> {
  __$$GeneralSettingsModelImplCopyWithImpl(_$GeneralSettingsModelImpl _value,
      $Res Function(_$GeneralSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeneralSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoSave = null,
    Object? notifications = null,
  }) {
    return _then(_$GeneralSettingsModelImpl(
      autoSave: null == autoSave
          ? _value.autoSave
          : autoSave // ignore: cast_nullable_to_non_nullable
              as bool,
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeneralSettingsModelImpl implements _GeneralSettingsModel {
  const _$GeneralSettingsModelImpl(
      {@JsonKey(name: 'auto_save') this.autoSave = true,
      this.notifications = true});

  factory _$GeneralSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeneralSettingsModelImplFromJson(json);

  /// 自动保存
  @override
  @JsonKey(name: 'auto_save')
  final bool autoSave;

  /// 通知
  @override
  @JsonKey()
  final bool notifications;

  @override
  String toString() {
    return 'GeneralSettingsModel(autoSave: $autoSave, notifications: $notifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneralSettingsModelImpl &&
            (identical(other.autoSave, autoSave) ||
                other.autoSave == autoSave) &&
            (identical(other.notifications, notifications) ||
                other.notifications == notifications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, autoSave, notifications);

  /// Create a copy of GeneralSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneralSettingsModelImplCopyWith<_$GeneralSettingsModelImpl>
      get copyWith =>
          __$$GeneralSettingsModelImplCopyWithImpl<_$GeneralSettingsModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeneralSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _GeneralSettingsModel implements GeneralSettingsModel {
  const factory _GeneralSettingsModel(
      {@JsonKey(name: 'auto_save') final bool autoSave,
      final bool notifications}) = _$GeneralSettingsModelImpl;

  factory _GeneralSettingsModel.fromJson(Map<String, dynamic> json) =
      _$GeneralSettingsModelImpl.fromJson;

  /// 自动保存
  @override
  @JsonKey(name: 'auto_save')
  bool get autoSave;

  /// 通知
  @override
  bool get notifications;

  /// Create a copy of GeneralSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeneralSettingsModelImplCopyWith<_$GeneralSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TranslationSettingsModel _$TranslationSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _TranslationSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$TranslationSettingsModel {
  /// 翻译接口列表
  List<TranslationProviderConfigModel> get providers =>
      throw _privateConstructorUsedError;

  /// 最大重试次数
  @JsonKey(name: 'max_retries')
  int get maxRetries => throw _privateConstructorUsedError;

  /// 超时时间（秒）
  @JsonKey(name: 'timeout_seconds')
  int get timeoutSeconds => throw _privateConstructorUsedError;

  /// Serializes this TranslationSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranslationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranslationSettingsModelCopyWith<TranslationSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslationSettingsModelCopyWith<$Res> {
  factory $TranslationSettingsModelCopyWith(TranslationSettingsModel value,
          $Res Function(TranslationSettingsModel) then) =
      _$TranslationSettingsModelCopyWithImpl<$Res, TranslationSettingsModel>;
  @useResult
  $Res call(
      {List<TranslationProviderConfigModel> providers,
      @JsonKey(name: 'max_retries') int maxRetries,
      @JsonKey(name: 'timeout_seconds') int timeoutSeconds});
}

/// @nodoc
class _$TranslationSettingsModelCopyWithImpl<$Res,
        $Val extends TranslationSettingsModel>
    implements $TranslationSettingsModelCopyWith<$Res> {
  _$TranslationSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranslationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? providers = null,
    Object? maxRetries = null,
    Object? timeoutSeconds = null,
  }) {
    return _then(_value.copyWith(
      providers: null == providers
          ? _value.providers
          : providers // ignore: cast_nullable_to_non_nullable
              as List<TranslationProviderConfigModel>,
      maxRetries: null == maxRetries
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      timeoutSeconds: null == timeoutSeconds
          ? _value.timeoutSeconds
          : timeoutSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranslationSettingsModelImplCopyWith<$Res>
    implements $TranslationSettingsModelCopyWith<$Res> {
  factory _$$TranslationSettingsModelImplCopyWith(
          _$TranslationSettingsModelImpl value,
          $Res Function(_$TranslationSettingsModelImpl) then) =
      __$$TranslationSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TranslationProviderConfigModel> providers,
      @JsonKey(name: 'max_retries') int maxRetries,
      @JsonKey(name: 'timeout_seconds') int timeoutSeconds});
}

/// @nodoc
class __$$TranslationSettingsModelImplCopyWithImpl<$Res>
    extends _$TranslationSettingsModelCopyWithImpl<$Res,
        _$TranslationSettingsModelImpl>
    implements _$$TranslationSettingsModelImplCopyWith<$Res> {
  __$$TranslationSettingsModelImplCopyWithImpl(
      _$TranslationSettingsModelImpl _value,
      $Res Function(_$TranslationSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranslationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? providers = null,
    Object? maxRetries = null,
    Object? timeoutSeconds = null,
  }) {
    return _then(_$TranslationSettingsModelImpl(
      providers: null == providers
          ? _value._providers
          : providers // ignore: cast_nullable_to_non_nullable
              as List<TranslationProviderConfigModel>,
      maxRetries: null == maxRetries
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      timeoutSeconds: null == timeoutSeconds
          ? _value.timeoutSeconds
          : timeoutSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslationSettingsModelImpl implements _TranslationSettingsModel {
  const _$TranslationSettingsModelImpl(
      {final List<TranslationProviderConfigModel> providers = const [],
      @JsonKey(name: 'max_retries') this.maxRetries = 3,
      @JsonKey(name: 'timeout_seconds') this.timeoutSeconds = 30})
      : _providers = providers;

  factory _$TranslationSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslationSettingsModelImplFromJson(json);

  /// 翻译接口列表
  final List<TranslationProviderConfigModel> _providers;

  /// 翻译接口列表
  @override
  @JsonKey()
  List<TranslationProviderConfigModel> get providers {
    if (_providers is EqualUnmodifiableListView) return _providers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_providers);
  }

  /// 最大重试次数
  @override
  @JsonKey(name: 'max_retries')
  final int maxRetries;

  /// 超时时间（秒）
  @override
  @JsonKey(name: 'timeout_seconds')
  final int timeoutSeconds;

  @override
  String toString() {
    return 'TranslationSettingsModel(providers: $providers, maxRetries: $maxRetries, timeoutSeconds: $timeoutSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationSettingsModelImpl &&
            const DeepCollectionEquality()
                .equals(other._providers, _providers) &&
            (identical(other.maxRetries, maxRetries) ||
                other.maxRetries == maxRetries) &&
            (identical(other.timeoutSeconds, timeoutSeconds) ||
                other.timeoutSeconds == timeoutSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_providers),
      maxRetries,
      timeoutSeconds);

  /// Create a copy of TranslationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslationSettingsModelImplCopyWith<_$TranslationSettingsModelImpl>
      get copyWith => __$$TranslationSettingsModelImplCopyWithImpl<
          _$TranslationSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslationSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _TranslationSettingsModel implements TranslationSettingsModel {
  const factory _TranslationSettingsModel(
          {final List<TranslationProviderConfigModel> providers,
          @JsonKey(name: 'max_retries') final int maxRetries,
          @JsonKey(name: 'timeout_seconds') final int timeoutSeconds}) =
      _$TranslationSettingsModelImpl;

  factory _TranslationSettingsModel.fromJson(Map<String, dynamic> json) =
      _$TranslationSettingsModelImpl.fromJson;

  /// 翻译接口列表
  @override
  List<TranslationProviderConfigModel> get providers;

  /// 最大重试次数
  @override
  @JsonKey(name: 'max_retries')
  int get maxRetries;

  /// 超时时间（秒）
  @override
  @JsonKey(name: 'timeout_seconds')
  int get timeoutSeconds;

  /// Create a copy of TranslationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranslationSettingsModelImplCopyWith<_$TranslationSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TranslationProviderConfigModel _$TranslationProviderConfigModelFromJson(
    Map<String, dynamic> json) {
  return _TranslationProviderConfigModel.fromJson(json);
}

/// @nodoc
mixin _$TranslationProviderConfigModel {
  /// 唯一ID
  String get id => throw _privateConstructorUsedError;

  /// 翻译提供商代码 (google/baidu/youdao/custom)
  String get provider => throw _privateConstructorUsedError;

  /// 自定义名称
  String? get name => throw _privateConstructorUsedError;

  /// App ID
  @JsonKey(name: 'app_id')
  String get appId => throw _privateConstructorUsedError;

  /// App Key
  @JsonKey(name: 'app_key')
  String get appKey => throw _privateConstructorUsedError;

  /// API地址（自定义翻译用）
  @JsonKey(name: 'api_url')
  String? get apiUrl => throw _privateConstructorUsedError;

  /// 是否为默认接口
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this TranslationProviderConfigModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranslationProviderConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranslationProviderConfigModelCopyWith<TranslationProviderConfigModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslationProviderConfigModelCopyWith<$Res> {
  factory $TranslationProviderConfigModelCopyWith(
          TranslationProviderConfigModel value,
          $Res Function(TranslationProviderConfigModel) then) =
      _$TranslationProviderConfigModelCopyWithImpl<$Res,
          TranslationProviderConfigModel>;
  @useResult
  $Res call(
      {String id,
      String provider,
      String? name,
      @JsonKey(name: 'app_id') String appId,
      @JsonKey(name: 'app_key') String appKey,
      @JsonKey(name: 'api_url') String? apiUrl,
      @JsonKey(name: 'is_default') bool isDefault});
}

/// @nodoc
class _$TranslationProviderConfigModelCopyWithImpl<$Res,
        $Val extends TranslationProviderConfigModel>
    implements $TranslationProviderConfigModelCopyWith<$Res> {
  _$TranslationProviderConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranslationProviderConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? provider = null,
    Object? name = freezed,
    Object? appId = null,
    Object? appKey = null,
    Object? apiUrl = freezed,
    Object? isDefault = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      appKey: null == appKey
          ? _value.appKey
          : appKey // ignore: cast_nullable_to_non_nullable
              as String,
      apiUrl: freezed == apiUrl
          ? _value.apiUrl
          : apiUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranslationProviderConfigModelImplCopyWith<$Res>
    implements $TranslationProviderConfigModelCopyWith<$Res> {
  factory _$$TranslationProviderConfigModelImplCopyWith(
          _$TranslationProviderConfigModelImpl value,
          $Res Function(_$TranslationProviderConfigModelImpl) then) =
      __$$TranslationProviderConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String provider,
      String? name,
      @JsonKey(name: 'app_id') String appId,
      @JsonKey(name: 'app_key') String appKey,
      @JsonKey(name: 'api_url') String? apiUrl,
      @JsonKey(name: 'is_default') bool isDefault});
}

/// @nodoc
class __$$TranslationProviderConfigModelImplCopyWithImpl<$Res>
    extends _$TranslationProviderConfigModelCopyWithImpl<$Res,
        _$TranslationProviderConfigModelImpl>
    implements _$$TranslationProviderConfigModelImplCopyWith<$Res> {
  __$$TranslationProviderConfigModelImplCopyWithImpl(
      _$TranslationProviderConfigModelImpl _value,
      $Res Function(_$TranslationProviderConfigModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranslationProviderConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? provider = null,
    Object? name = freezed,
    Object? appId = null,
    Object? appKey = null,
    Object? apiUrl = freezed,
    Object? isDefault = null,
  }) {
    return _then(_$TranslationProviderConfigModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      appId: null == appId
          ? _value.appId
          : appId // ignore: cast_nullable_to_non_nullable
              as String,
      appKey: null == appKey
          ? _value.appKey
          : appKey // ignore: cast_nullable_to_non_nullable
              as String,
      apiUrl: freezed == apiUrl
          ? _value.apiUrl
          : apiUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslationProviderConfigModelImpl
    implements _TranslationProviderConfigModel {
  const _$TranslationProviderConfigModelImpl(
      {required this.id,
      required this.provider,
      this.name,
      @JsonKey(name: 'app_id') this.appId = '',
      @JsonKey(name: 'app_key') this.appKey = '',
      @JsonKey(name: 'api_url') this.apiUrl,
      @JsonKey(name: 'is_default') this.isDefault = false});

  factory _$TranslationProviderConfigModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TranslationProviderConfigModelImplFromJson(json);

  /// 唯一ID
  @override
  final String id;

  /// 翻译提供商代码 (google/baidu/youdao/custom)
  @override
  final String provider;

  /// 自定义名称
  @override
  final String? name;

  /// App ID
  @override
  @JsonKey(name: 'app_id')
  final String appId;

  /// App Key
  @override
  @JsonKey(name: 'app_key')
  final String appKey;

  /// API地址（自定义翻译用）
  @override
  @JsonKey(name: 'api_url')
  final String? apiUrl;

  /// 是否为默认接口
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;

  @override
  String toString() {
    return 'TranslationProviderConfigModel(id: $id, provider: $provider, name: $name, appId: $appId, appKey: $appKey, apiUrl: $apiUrl, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationProviderConfigModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.appKey, appKey) || other.appKey == appKey) &&
            (identical(other.apiUrl, apiUrl) || other.apiUrl == apiUrl) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, provider, name, appId, appKey, apiUrl, isDefault);

  /// Create a copy of TranslationProviderConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslationProviderConfigModelImplCopyWith<
          _$TranslationProviderConfigModelImpl>
      get copyWith => __$$TranslationProviderConfigModelImplCopyWithImpl<
          _$TranslationProviderConfigModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslationProviderConfigModelImplToJson(
      this,
    );
  }
}

abstract class _TranslationProviderConfigModel
    implements TranslationProviderConfigModel {
  const factory _TranslationProviderConfigModel(
          {required final String id,
          required final String provider,
          final String? name,
          @JsonKey(name: 'app_id') final String appId,
          @JsonKey(name: 'app_key') final String appKey,
          @JsonKey(name: 'api_url') final String? apiUrl,
          @JsonKey(name: 'is_default') final bool isDefault}) =
      _$TranslationProviderConfigModelImpl;

  factory _TranslationProviderConfigModel.fromJson(Map<String, dynamic> json) =
      _$TranslationProviderConfigModelImpl.fromJson;

  /// 唯一ID
  @override
  String get id;

  /// 翻译提供商代码 (google/baidu/youdao/custom)
  @override
  String get provider;

  /// 自定义名称
  @override
  String? get name;

  /// App ID
  @override
  @JsonKey(name: 'app_id')
  String get appId;

  /// App Key
  @override
  @JsonKey(name: 'app_key')
  String get appKey;

  /// API地址（自定义翻译用）
  @override
  @JsonKey(name: 'api_url')
  String? get apiUrl;

  /// 是否为默认接口
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;

  /// Create a copy of TranslationProviderConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranslationProviderConfigModelImplCopyWith<
          _$TranslationProviderConfigModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
