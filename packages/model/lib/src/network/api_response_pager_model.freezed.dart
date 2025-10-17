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

ApiResponsePager<T> _$ApiResponsePagerFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _ApiResponsePager<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$ApiResponsePager<T> {
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

  /// Serializes this ApiResponsePager to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of ApiResponsePager
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiResponsePagerCopyWith<T, ApiResponsePager<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponsePagerCopyWith<T, $Res> {
  factory $ApiResponsePagerCopyWith(
          ApiResponsePager<T> value, $Res Function(ApiResponsePager<T>) then) =
      _$ApiResponsePagerCopyWithImpl<T, $Res, ApiResponsePager<T>>;
  @useResult
  $Res call(
      {@JsonKey(name: 'page') int page,
      @JsonKey(name: 'page_size') int pageSize,
      @JsonKey(name: 'total_size') int totalSize,
      @JsonKey(name: 'total_page') int totalPage,
      @JsonKey(name: 'items') List<T>? items});
}

/// @nodoc
class _$ApiResponsePagerCopyWithImpl<T, $Res, $Val extends ApiResponsePager<T>>
    implements $ApiResponsePagerCopyWith<T, $Res> {
  _$ApiResponsePagerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiResponsePager
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
abstract class _$$ApiResponsePagerImplCopyWith<T, $Res>
    implements $ApiResponsePagerCopyWith<T, $Res> {
  factory _$$ApiResponsePagerImplCopyWith(_$ApiResponsePagerImpl<T> value,
          $Res Function(_$ApiResponsePagerImpl<T>) then) =
      __$$ApiResponsePagerImplCopyWithImpl<T, $Res>;
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
class __$$ApiResponsePagerImplCopyWithImpl<T, $Res>
    extends _$ApiResponsePagerCopyWithImpl<T, $Res, _$ApiResponsePagerImpl<T>>
    implements _$$ApiResponsePagerImplCopyWith<T, $Res> {
  __$$ApiResponsePagerImplCopyWithImpl(_$ApiResponsePagerImpl<T> _value,
      $Res Function(_$ApiResponsePagerImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ApiResponsePager
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
    return _then(_$ApiResponsePagerImpl<T>(
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
class _$ApiResponsePagerImpl<T> implements _ApiResponsePager<T> {
  const _$ApiResponsePagerImpl(
      {@JsonKey(name: 'page') required this.page,
      @JsonKey(name: 'page_size') required this.pageSize,
      @JsonKey(name: 'total_size') required this.totalSize,
      @JsonKey(name: 'total_page') required this.totalPage,
      @JsonKey(name: 'items') final List<T>? items})
      : _items = items;

  factory _$ApiResponsePagerImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$ApiResponsePagerImplFromJson(json, fromJsonT);

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
    return 'ApiResponsePager<$T>(page: $page, pageSize: $pageSize, totalSize: $totalSize, totalPage: $totalPage, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponsePagerImpl<T> &&
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

  /// Create a copy of ApiResponsePager
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponsePagerImplCopyWith<T, _$ApiResponsePagerImpl<T>> get copyWith =>
      __$$ApiResponsePagerImplCopyWithImpl<T, _$ApiResponsePagerImpl<T>>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$ApiResponsePagerImplToJson<T>(this, toJsonT);
  }
}

abstract class _ApiResponsePager<T> implements ApiResponsePager<T> {
  const factory _ApiResponsePager(
          {@JsonKey(name: 'page') required final int page,
          @JsonKey(name: 'page_size') required final int pageSize,
          @JsonKey(name: 'total_size') required final int totalSize,
          @JsonKey(name: 'total_page') required final int totalPage,
          @JsonKey(name: 'items') final List<T>? items}) =
      _$ApiResponsePagerImpl<T>;

  factory _ApiResponsePager.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$ApiResponsePagerImpl<T>.fromJson;

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

  /// Create a copy of ApiResponsePager
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiResponsePagerImplCopyWith<T, _$ApiResponsePagerImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
