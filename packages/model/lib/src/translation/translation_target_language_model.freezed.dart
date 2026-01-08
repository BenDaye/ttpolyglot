// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_target_language_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TranslationTargetLanguageModel _$TranslationTargetLanguageModelFromJson(
    Map<String, dynamic> json) {
  return _TranslationTargetLanguageModel.fromJson(json);
}

/// @nodoc
mixin _$TranslationTargetLanguageModel {
  /// 语言
  @JsonKey(name: 'language')
  @LanguageEnumConverter()
  LanguageEnum get language => throw _privateConstructorUsedError;

  /// 翻译文本
  @JsonKey(name: 'text')
  String get text => throw _privateConstructorUsedError;

  /// Serializes this TranslationTargetLanguageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranslationTargetLanguageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranslationTargetLanguageModelCopyWith<TranslationTargetLanguageModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslationTargetLanguageModelCopyWith<$Res> {
  factory $TranslationTargetLanguageModelCopyWith(
          TranslationTargetLanguageModel value,
          $Res Function(TranslationTargetLanguageModel) then) =
      _$TranslationTargetLanguageModelCopyWithImpl<$Res,
          TranslationTargetLanguageModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'language')
      @LanguageEnumConverter()
      LanguageEnum language,
      @JsonKey(name: 'text') String text});
}

/// @nodoc
class _$TranslationTargetLanguageModelCopyWithImpl<$Res,
        $Val extends TranslationTargetLanguageModel>
    implements $TranslationTargetLanguageModelCopyWith<$Res> {
  _$TranslationTargetLanguageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranslationTargetLanguageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as LanguageEnum,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranslationTargetLanguageModelImplCopyWith<$Res>
    implements $TranslationTargetLanguageModelCopyWith<$Res> {
  factory _$$TranslationTargetLanguageModelImplCopyWith(
          _$TranslationTargetLanguageModelImpl value,
          $Res Function(_$TranslationTargetLanguageModelImpl) then) =
      __$$TranslationTargetLanguageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'language')
      @LanguageEnumConverter()
      LanguageEnum language,
      @JsonKey(name: 'text') String text});
}

/// @nodoc
class __$$TranslationTargetLanguageModelImplCopyWithImpl<$Res>
    extends _$TranslationTargetLanguageModelCopyWithImpl<$Res,
        _$TranslationTargetLanguageModelImpl>
    implements _$$TranslationTargetLanguageModelImplCopyWith<$Res> {
  __$$TranslationTargetLanguageModelImplCopyWithImpl(
      _$TranslationTargetLanguageModelImpl _value,
      $Res Function(_$TranslationTargetLanguageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranslationTargetLanguageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? language = null,
    Object? text = null,
  }) {
    return _then(_$TranslationTargetLanguageModelImpl(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as LanguageEnum,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslationTargetLanguageModelImpl
    extends _TranslationTargetLanguageModel {
  const _$TranslationTargetLanguageModelImpl(
      {@JsonKey(name: 'language')
      @LanguageEnumConverter()
      required this.language,
      @JsonKey(name: 'text') required this.text})
      : super._();

  factory _$TranslationTargetLanguageModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TranslationTargetLanguageModelImplFromJson(json);

  /// 语言
  @override
  @JsonKey(name: 'language')
  @LanguageEnumConverter()
  final LanguageEnum language;

  /// 翻译文本
  @override
  @JsonKey(name: 'text')
  final String text;

  @override
  String toString() {
    return 'TranslationTargetLanguageModel(language: $language, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationTargetLanguageModelImpl &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, language, text);

  /// Create a copy of TranslationTargetLanguageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslationTargetLanguageModelImplCopyWith<
          _$TranslationTargetLanguageModelImpl>
      get copyWith => __$$TranslationTargetLanguageModelImplCopyWithImpl<
          _$TranslationTargetLanguageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslationTargetLanguageModelImplToJson(
      this,
    );
  }
}

abstract class _TranslationTargetLanguageModel
    extends TranslationTargetLanguageModel {
  const factory _TranslationTargetLanguageModel(
          {@JsonKey(name: 'language')
          @LanguageEnumConverter()
          required final LanguageEnum language,
          @JsonKey(name: 'text') required final String text}) =
      _$TranslationTargetLanguageModelImpl;
  const _TranslationTargetLanguageModel._() : super._();

  factory _TranslationTargetLanguageModel.fromJson(Map<String, dynamic> json) =
      _$TranslationTargetLanguageModelImpl.fromJson;

  /// 语言
  @override
  @JsonKey(name: 'language')
  @LanguageEnumConverter()
  LanguageEnum get language;

  /// 翻译文本
  @override
  @JsonKey(name: 'text')
  String get text;

  /// Create a copy of TranslationTargetLanguageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranslationTargetLanguageModelImplCopyWith<
          _$TranslationTargetLanguageModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
