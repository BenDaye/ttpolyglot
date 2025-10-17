// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_response_pager_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiResponsePagerModel<T> _$ApiResponsePagerModelFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _ApiResponsePagerModel<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$ApiResponsePagerModel<T> {
  @JsonKey(name: 'page')
  int get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'page_size')
  int get pageSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_size')
  int get totalSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_page')
  int get totalPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'items')
  List<T>? get items => throw _privateConstructorUsedError;

  /// Serializes this ApiResponsePagerModel to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of ApiResponsePagerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiResponsePagerModelCopyWith<T, ApiResponsePagerModel<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponsePagerModelCopyWith<T, $Res> {
  factory $ApiResponsePagerModelCopyWith(ApiResponsePagerModel<T> value,
          $Res Function(ApiResponsePagerModel<T>) then) =
      _$ApiResponsePagerModelCopyWithImpl<T, $Res, ApiResponsePagerModel<T>>;
  @useResult
  $Res call(
      {@JsonKey(name: 'page') int page,
      @JsonKey(name: 'page_size') int pageSize,
      @JsonKey(name: 'total_size') int totalSize,
      @JsonKey(name: 'total_page') int totalPage,
      @JsonKey(name: 'items') List<T>? items});
}

/// @nodoc
class _$ApiResponsePagerModelCopyWithImpl<T, $Res,
        $Val extends ApiResponsePagerModel<T>>
    implements $ApiResponsePagerModelCopyWith<T, $Res> {
  _$ApiResponsePagerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiResponsePagerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? pageSize = null,
    Object? totalSize = null,
    Object? totalPage = null,
    Object? items = freezed,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalSize: null == totalSize
          ? _value.totalSize
          : totalSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalPage: null == totalPage
          ? _value.totalPage
          : totalPage // ignore: cast_nullable_to_non_nullable
              as int,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiResponsePagerModelImplCopyWith<T, $Res>
    implements $ApiResponsePagerModelCopyWith<T, $Res> {
  factory _$$ApiResponsePagerModelImplCopyWith(
          _$ApiResponsePagerModelImpl<T> value,
          $Res Function(_$ApiResponsePagerModelImpl<T>) then) =
      __$$ApiResponsePagerModelImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'page') int page,
      @JsonKey(name: 'page_size') int pageSize,
      @JsonKey(name: 'total_size') int totalSize,
      @JsonKey(name: 'total_page') int totalPage,
      @JsonKey(name: 'items') List<T>? items});
}

/// @nodoc
class __$$ApiResponsePagerModelImplCopyWithImpl<T, $Res>
    extends _$ApiResponsePagerModelCopyWithImpl<T, $Res,
        _$ApiResponsePagerModelImpl<T>>
    implements _$$ApiResponsePagerModelImplCopyWith<T, $Res> {
  __$$ApiResponsePagerModelImplCopyWithImpl(
      _$ApiResponsePagerModelImpl<T> _value,
      $Res Function(_$ApiResponsePagerModelImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ApiResponsePagerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? pageSize = null,
    Object? totalSize = null,
    Object? totalPage = null,
    Object? items = freezed,
  }) {
    return _then(_$ApiResponsePagerModelImpl<T>(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalSize: null == totalSize
          ? _value.totalSize
          : totalSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalPage: null == totalPage
          ? _value.totalPage
          : totalPage // ignore: cast_nullable_to_non_nullable
              as int,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>?,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$ApiResponsePagerModelImpl<T> implements _ApiResponsePagerModel<T> {
  const _$ApiResponsePagerModelImpl(
      {@JsonKey(name: 'page') required this.page,
      @JsonKey(name: 'page_size') required this.pageSize,
      @JsonKey(name: 'total_size') required this.totalSize,
      @JsonKey(name: 'total_page') required this.totalPage,
      @JsonKey(name: 'items') final List<T>? items})
      : _items = items;

  factory _$ApiResponsePagerModelImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$ApiResponsePagerModelImplFromJson(json, fromJsonT);

  @override
  @JsonKey(name: 'page')
  final int page;
  @override
  @JsonKey(name: 'page_size')
  final int pageSize;
  @override
  @JsonKey(name: 'total_size')
  final int totalSize;
  @override
  @JsonKey(name: 'total_page')
  final int totalPage;
  final List<T>? _items;
  @override
  @JsonKey(name: 'items')
  List<T>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ApiResponsePagerModel<$T>(page: $page, pageSize: $pageSize, totalSize: $totalSize, totalPage: $totalPage, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponsePagerModelImpl<T> &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalSize, totalSize) ||
                other.totalSize == totalSize) &&
            (identical(other.totalPage, totalPage) ||
                other.totalPage == totalPage) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, page, pageSize, totalSize,
      totalPage, const DeepCollectionEquality().hash(_items));

  /// Create a copy of ApiResponsePagerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponsePagerModelImplCopyWith<T, _$ApiResponsePagerModelImpl<T>>
      get copyWith => __$$ApiResponsePagerModelImplCopyWithImpl<T,
          _$ApiResponsePagerModelImpl<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$ApiResponsePagerModelImplToJson<T>(this, toJsonT);
  }
}

abstract class _ApiResponsePagerModel<T> implements ApiResponsePagerModel<T> {
  const factory _ApiResponsePagerModel(
          {@JsonKey(name: 'page') required final int page,
          @JsonKey(name: 'page_size') required final int pageSize,
          @JsonKey(name: 'total_size') required final int totalSize,
          @JsonKey(name: 'total_page') required final int totalPage,
          @JsonKey(name: 'items') final List<T>? items}) =
      _$ApiResponsePagerModelImpl<T>;

  factory _ApiResponsePagerModel.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$ApiResponsePagerModelImpl<T>.fromJson;

  @override
  @JsonKey(name: 'page')
  int get page;
  @override
  @JsonKey(name: 'page_size')
  int get pageSize;
  @override
  @JsonKey(name: 'total_size')
  int get totalSize;
  @override
  @JsonKey(name: 'total_page')
  int get totalPage;
  @override
  @JsonKey(name: 'items')
  List<T>? get items;

  /// Create a copy of ApiResponsePagerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiResponsePagerModelImplCopyWith<T, _$ApiResponsePagerModelImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
