// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) {
  return _LocationModel.fromJson(json);
}

/// @nodoc
mixin _$LocationModel {
  /// 国家名称
  @JsonKey(name: 'country')
  String get country => throw _privateConstructorUsedError;

  /// 城市
  @JsonKey(name: 'city')
  String get city => throw _privateConstructorUsedError;

  /// 省份/地区
  @JsonKey(name: 'region')
  String get region => throw _privateConstructorUsedError;

  /// 国家代码
  @JsonKey(name: 'country_code')
  String get countryCode => throw _privateConstructorUsedError;

  /// 时区
  @JsonKey(name: 'timezone')
  String get timezone => throw _privateConstructorUsedError;

  /// ISP运营商
  @JsonKey(name: 'isp')
  String get isp => throw _privateConstructorUsedError;

  /// Serializes this LocationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationModelCopyWith<LocationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationModelCopyWith<$Res> {
  factory $LocationModelCopyWith(
          LocationModel value, $Res Function(LocationModel) then) =
      _$LocationModelCopyWithImpl<$Res, LocationModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'country') String country,
      @JsonKey(name: 'city') String city,
      @JsonKey(name: 'region') String region,
      @JsonKey(name: 'country_code') String countryCode,
      @JsonKey(name: 'timezone') String timezone,
      @JsonKey(name: 'isp') String isp});
}

/// @nodoc
class _$LocationModelCopyWithImpl<$Res, $Val extends LocationModel>
    implements $LocationModelCopyWith<$Res> {
  _$LocationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? country = null,
    Object? city = null,
    Object? region = null,
    Object? countryCode = null,
    Object? timezone = null,
    Object? isp = null,
  }) {
    return _then(_value.copyWith(
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      isp: null == isp
          ? _value.isp
          : isp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationModelImplCopyWith<$Res>
    implements $LocationModelCopyWith<$Res> {
  factory _$$LocationModelImplCopyWith(
          _$LocationModelImpl value, $Res Function(_$LocationModelImpl) then) =
      __$$LocationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'country') String country,
      @JsonKey(name: 'city') String city,
      @JsonKey(name: 'region') String region,
      @JsonKey(name: 'country_code') String countryCode,
      @JsonKey(name: 'timezone') String timezone,
      @JsonKey(name: 'isp') String isp});
}

/// @nodoc
class __$$LocationModelImplCopyWithImpl<$Res>
    extends _$LocationModelCopyWithImpl<$Res, _$LocationModelImpl>
    implements _$$LocationModelImplCopyWith<$Res> {
  __$$LocationModelImplCopyWithImpl(
      _$LocationModelImpl _value, $Res Function(_$LocationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? country = null,
    Object? city = null,
    Object? region = null,
    Object? countryCode = null,
    Object? timezone = null,
    Object? isp = null,
  }) {
    return _then(_$LocationModelImpl(
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      isp: null == isp
          ? _value.isp
          : isp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationModelImpl implements _LocationModel {
  const _$LocationModelImpl(
      {@JsonKey(name: 'country') this.country = '',
      @JsonKey(name: 'city') this.city = '',
      @JsonKey(name: 'region') this.region = '',
      @JsonKey(name: 'country_code') this.countryCode = '',
      @JsonKey(name: 'timezone') this.timezone = '',
      @JsonKey(name: 'isp') this.isp = ''});

  factory _$LocationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationModelImplFromJson(json);

  /// 国家名称
  @override
  @JsonKey(name: 'country')
  final String country;

  /// 城市
  @override
  @JsonKey(name: 'city')
  final String city;

  /// 省份/地区
  @override
  @JsonKey(name: 'region')
  final String region;

  /// 国家代码
  @override
  @JsonKey(name: 'country_code')
  final String countryCode;

  /// 时区
  @override
  @JsonKey(name: 'timezone')
  final String timezone;

  /// ISP运营商
  @override
  @JsonKey(name: 'isp')
  final String isp;

  @override
  String toString() {
    return 'LocationModel(country: $country, city: $city, region: $region, countryCode: $countryCode, timezone: $timezone, isp: $isp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationModelImpl &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.isp, isp) || other.isp == isp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, country, city, region, countryCode, timezone, isp);

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationModelImplCopyWith<_$LocationModelImpl> get copyWith =>
      __$$LocationModelImplCopyWithImpl<_$LocationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationModelImplToJson(
      this,
    );
  }
}

abstract class _LocationModel implements LocationModel {
  const factory _LocationModel(
      {@JsonKey(name: 'country') final String country,
      @JsonKey(name: 'city') final String city,
      @JsonKey(name: 'region') final String region,
      @JsonKey(name: 'country_code') final String countryCode,
      @JsonKey(name: 'timezone') final String timezone,
      @JsonKey(name: 'isp') final String isp}) = _$LocationModelImpl;

  factory _LocationModel.fromJson(Map<String, dynamic> json) =
      _$LocationModelImpl.fromJson;

  /// 国家名称
  @override
  @JsonKey(name: 'country')
  String get country;

  /// 城市
  @override
  @JsonKey(name: 'city')
  String get city;

  /// 省份/地区
  @override
  @JsonKey(name: 'region')
  String get region;

  /// 国家代码
  @override
  @JsonKey(name: 'country_code')
  String get countryCode;

  /// 时区
  @override
  @JsonKey(name: 'timezone')
  String get timezone;

  /// ISP运营商
  @override
  @JsonKey(name: 'isp')
  String get isp;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationModelImplCopyWith<_$LocationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
