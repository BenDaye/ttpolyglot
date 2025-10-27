// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extra_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExtraModel _$ExtraModelFromJson(Map<String, dynamic> json) {
  return _ExtraModel.fromJson(json);
}

/// @nodoc
mixin _$ExtraModel {
  @JsonKey(name: 'show_loading')
  bool get showLoading => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_lazy_loading')
  bool get showLazyLoading => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_success_toast')
  bool get showSuccessToast => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_error_toast')
  bool get showErrorToast => throw _privateConstructorUsedError;

  /// Serializes this ExtraModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExtraModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExtraModelCopyWith<ExtraModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtraModelCopyWith<$Res> {
  factory $ExtraModelCopyWith(
          ExtraModel value, $Res Function(ExtraModel) then) =
      _$ExtraModelCopyWithImpl<$Res, ExtraModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'show_loading') bool showLoading,
      @JsonKey(name: 'show_lazy_loading') bool showLazyLoading,
      @JsonKey(name: 'show_success_toast') bool showSuccessToast,
      @JsonKey(name: 'show_error_toast') bool showErrorToast});
}

/// @nodoc
class _$ExtraModelCopyWithImpl<$Res, $Val extends ExtraModel>
    implements $ExtraModelCopyWith<$Res> {
  _$ExtraModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExtraModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showLoading = null,
    Object? showLazyLoading = null,
    Object? showSuccessToast = null,
    Object? showErrorToast = null,
  }) {
    return _then(_value.copyWith(
      showLoading: null == showLoading
          ? _value.showLoading
          : showLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      showLazyLoading: null == showLazyLoading
          ? _value.showLazyLoading
          : showLazyLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      showSuccessToast: null == showSuccessToast
          ? _value.showSuccessToast
          : showSuccessToast // ignore: cast_nullable_to_non_nullable
              as bool,
      showErrorToast: null == showErrorToast
          ? _value.showErrorToast
          : showErrorToast // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExtraModelImplCopyWith<$Res>
    implements $ExtraModelCopyWith<$Res> {
  factory _$$ExtraModelImplCopyWith(
          _$ExtraModelImpl value, $Res Function(_$ExtraModelImpl) then) =
      __$$ExtraModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'show_loading') bool showLoading,
      @JsonKey(name: 'show_lazy_loading') bool showLazyLoading,
      @JsonKey(name: 'show_success_toast') bool showSuccessToast,
      @JsonKey(name: 'show_error_toast') bool showErrorToast});
}

/// @nodoc
class __$$ExtraModelImplCopyWithImpl<$Res>
    extends _$ExtraModelCopyWithImpl<$Res, _$ExtraModelImpl>
    implements _$$ExtraModelImplCopyWith<$Res> {
  __$$ExtraModelImplCopyWithImpl(
      _$ExtraModelImpl _value, $Res Function(_$ExtraModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExtraModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showLoading = null,
    Object? showLazyLoading = null,
    Object? showSuccessToast = null,
    Object? showErrorToast = null,
  }) {
    return _then(_$ExtraModelImpl(
      showLoading: null == showLoading
          ? _value.showLoading
          : showLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      showLazyLoading: null == showLazyLoading
          ? _value.showLazyLoading
          : showLazyLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      showSuccessToast: null == showSuccessToast
          ? _value.showSuccessToast
          : showSuccessToast // ignore: cast_nullable_to_non_nullable
              as bool,
      showErrorToast: null == showErrorToast
          ? _value.showErrorToast
          : showErrorToast // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExtraModelImpl implements _ExtraModel {
  const _$ExtraModelImpl(
      {@JsonKey(name: 'show_loading') this.showLoading = false,
      @JsonKey(name: 'show_lazy_loading') this.showLazyLoading = true,
      @JsonKey(name: 'show_success_toast') this.showSuccessToast = false,
      @JsonKey(name: 'show_error_toast') this.showErrorToast = true});

  factory _$ExtraModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtraModelImplFromJson(json);

  @override
  @JsonKey(name: 'show_loading')
  final bool showLoading;
  @override
  @JsonKey(name: 'show_lazy_loading')
  final bool showLazyLoading;
  @override
  @JsonKey(name: 'show_success_toast')
  final bool showSuccessToast;
  @override
  @JsonKey(name: 'show_error_toast')
  final bool showErrorToast;

  @override
  String toString() {
    return 'ExtraModel(showLoading: $showLoading, showLazyLoading: $showLazyLoading, showSuccessToast: $showSuccessToast, showErrorToast: $showErrorToast)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtraModelImpl &&
            (identical(other.showLoading, showLoading) ||
                other.showLoading == showLoading) &&
            (identical(other.showLazyLoading, showLazyLoading) ||
                other.showLazyLoading == showLazyLoading) &&
            (identical(other.showSuccessToast, showSuccessToast) ||
                other.showSuccessToast == showSuccessToast) &&
            (identical(other.showErrorToast, showErrorToast) ||
                other.showErrorToast == showErrorToast));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, showLoading, showLazyLoading,
      showSuccessToast, showErrorToast);

  /// Create a copy of ExtraModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtraModelImplCopyWith<_$ExtraModelImpl> get copyWith =>
      __$$ExtraModelImplCopyWithImpl<_$ExtraModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtraModelImplToJson(
      this,
    );
  }
}

abstract class _ExtraModel implements ExtraModel {
  const factory _ExtraModel(
          {@JsonKey(name: 'show_loading') final bool showLoading,
          @JsonKey(name: 'show_lazy_loading') final bool showLazyLoading,
          @JsonKey(name: 'show_success_toast') final bool showSuccessToast,
          @JsonKey(name: 'show_error_toast') final bool showErrorToast}) =
      _$ExtraModelImpl;

  factory _ExtraModel.fromJson(Map<String, dynamic> json) =
      _$ExtraModelImpl.fromJson;

  @override
  @JsonKey(name: 'show_loading')
  bool get showLoading;
  @override
  @JsonKey(name: 'show_lazy_loading')
  bool get showLazyLoading;
  @override
  @JsonKey(name: 'show_success_toast')
  bool get showSuccessToast;
  @override
  @JsonKey(name: 'show_error_toast')
  bool get showErrorToast;

  /// Create a copy of ExtraModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExtraModelImplCopyWith<_$ExtraModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
