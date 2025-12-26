// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_member_invite_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectMemberInviteLogModel _$ProjectMemberInviteLogModelFromJson(
    Map<String, dynamic> json) {
  return _ProjectMemberInviteLogModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectMemberInviteLogModel {
  /// 日志ID
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id => throw _privateConstructorUsedError;

  /// 成员ID（邀请链接ID）
  @JsonKey(name: 'member_id')
  @FlexibleIntConverter()
  int get memberId => throw _privateConstructorUsedError;

  /// 用户ID（使用邀请的用户ID）
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// 是否接受邀请
  @JsonKey(name: 'accepted')
  bool get accepted => throw _privateConstructorUsedError;

  /// 接受时间
  @JsonKey(name: 'accepted_at')
  @NullableTimesConverter()
  DateTime? get acceptedAt => throw _privateConstructorUsedError;

  /// IP地址
  @JsonKey(name: 'ip_address')
  String? get ipAddress => throw _privateConstructorUsedError;

  /// 用户代理
  @JsonKey(name: 'user_agent')
  String? get userAgent => throw _privateConstructorUsedError;

  /// 创建时间
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ProjectMemberInviteLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectMemberInviteLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectMemberInviteLogModelCopyWith<ProjectMemberInviteLogModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectMemberInviteLogModelCopyWith<$Res> {
  factory $ProjectMemberInviteLogModelCopyWith(
          ProjectMemberInviteLogModel value,
          $Res Function(ProjectMemberInviteLogModel) then) =
      _$ProjectMemberInviteLogModelCopyWithImpl<$Res,
          ProjectMemberInviteLogModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'member_id') @FlexibleIntConverter() int memberId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'accepted') bool accepted,
      @JsonKey(name: 'accepted_at')
      @NullableTimesConverter()
      DateTime? acceptedAt,
      @JsonKey(name: 'ip_address') String? ipAddress,
      @JsonKey(name: 'user_agent') String? userAgent,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt});
}

/// @nodoc
class _$ProjectMemberInviteLogModelCopyWithImpl<$Res,
        $Val extends ProjectMemberInviteLogModel>
    implements $ProjectMemberInviteLogModelCopyWith<$Res> {
  _$ProjectMemberInviteLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectMemberInviteLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? userId = null,
    Object? accepted = null,
    Object? acceptedAt = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      accepted: null == accepted
          ? _value.accepted
          : accepted // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectMemberInviteLogModelImplCopyWith<$Res>
    implements $ProjectMemberInviteLogModelCopyWith<$Res> {
  factory _$$ProjectMemberInviteLogModelImplCopyWith(
          _$ProjectMemberInviteLogModelImpl value,
          $Res Function(_$ProjectMemberInviteLogModelImpl) then) =
      __$$ProjectMemberInviteLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'member_id') @FlexibleIntConverter() int memberId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'accepted') bool accepted,
      @JsonKey(name: 'accepted_at')
      @NullableTimesConverter()
      DateTime? acceptedAt,
      @JsonKey(name: 'ip_address') String? ipAddress,
      @JsonKey(name: 'user_agent') String? userAgent,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt});
}

/// @nodoc
class __$$ProjectMemberInviteLogModelImplCopyWithImpl<$Res>
    extends _$ProjectMemberInviteLogModelCopyWithImpl<$Res,
        _$ProjectMemberInviteLogModelImpl>
    implements _$$ProjectMemberInviteLogModelImplCopyWith<$Res> {
  __$$ProjectMemberInviteLogModelImplCopyWithImpl(
      _$ProjectMemberInviteLogModelImpl _value,
      $Res Function(_$ProjectMemberInviteLogModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectMemberInviteLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? userId = null,
    Object? accepted = null,
    Object? acceptedAt = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ProjectMemberInviteLogModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      accepted: null == accepted
          ? _value.accepted
          : accepted // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectMemberInviteLogModelImpl
    implements _ProjectMemberInviteLogModel {
  const _$ProjectMemberInviteLogModelImpl(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required this.id,
      @JsonKey(name: 'member_id')
      @FlexibleIntConverter()
      required this.memberId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'accepted') this.accepted = false,
      @JsonKey(name: 'accepted_at') @NullableTimesConverter() this.acceptedAt,
      @JsonKey(name: 'ip_address') this.ipAddress,
      @JsonKey(name: 'user_agent') this.userAgent,
      @JsonKey(name: 'created_at') @TimesConverter() required this.createdAt});

  factory _$ProjectMemberInviteLogModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ProjectMemberInviteLogModelImplFromJson(json);

  /// 日志ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  final int id;

  /// 成员ID（邀请链接ID）
  @override
  @JsonKey(name: 'member_id')
  @FlexibleIntConverter()
  final int memberId;

  /// 用户ID（使用邀请的用户ID）
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  /// 是否接受邀请
  @override
  @JsonKey(name: 'accepted')
  final bool accepted;

  /// 接受时间
  @override
  @JsonKey(name: 'accepted_at')
  @NullableTimesConverter()
  final DateTime? acceptedAt;

  /// IP地址
  @override
  @JsonKey(name: 'ip_address')
  final String? ipAddress;

  /// 用户代理
  @override
  @JsonKey(name: 'user_agent')
  final String? userAgent;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'ProjectMemberInviteLogModel(id: $id, memberId: $memberId, userId: $userId, accepted: $accepted, acceptedAt: $acceptedAt, ipAddress: $ipAddress, userAgent: $userAgent, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectMemberInviteLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.accepted, accepted) ||
                other.accepted == accepted) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, memberId, userId, accepted,
      acceptedAt, ipAddress, userAgent, createdAt);

  /// Create a copy of ProjectMemberInviteLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectMemberInviteLogModelImplCopyWith<_$ProjectMemberInviteLogModelImpl>
      get copyWith => __$$ProjectMemberInviteLogModelImplCopyWithImpl<
          _$ProjectMemberInviteLogModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectMemberInviteLogModelImplToJson(
      this,
    );
  }
}

abstract class _ProjectMemberInviteLogModel
    implements ProjectMemberInviteLogModel {
  const factory _ProjectMemberInviteLogModel(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required final int id,
      @JsonKey(name: 'member_id')
      @FlexibleIntConverter()
      required final int memberId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'accepted') final bool accepted,
      @JsonKey(name: 'accepted_at')
      @NullableTimesConverter()
      final DateTime? acceptedAt,
      @JsonKey(name: 'ip_address') final String? ipAddress,
      @JsonKey(name: 'user_agent') final String? userAgent,
      @JsonKey(name: 'created_at')
      @TimesConverter()
      required final DateTime createdAt}) = _$ProjectMemberInviteLogModelImpl;

  factory _ProjectMemberInviteLogModel.fromJson(Map<String, dynamic> json) =
      _$ProjectMemberInviteLogModelImpl.fromJson;

  /// 日志ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id;

  /// 成员ID（邀请链接ID）
  @override
  @JsonKey(name: 'member_id')
  @FlexibleIntConverter()
  int get memberId;

  /// 用户ID（使用邀请的用户ID）
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// 是否接受邀请
  @override
  @JsonKey(name: 'accepted')
  bool get accepted;

  /// 接受时间
  @override
  @JsonKey(name: 'accepted_at')
  @NullableTimesConverter()
  DateTime? get acceptedAt;

  /// IP地址
  @override
  @JsonKey(name: 'ip_address')
  String? get ipAddress;

  /// 用户代理
  @override
  @JsonKey(name: 'user_agent')
  String? get userAgent;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt;

  /// Create a copy of ProjectMemberInviteLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectMemberInviteLogModelImplCopyWith<_$ProjectMemberInviteLogModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
