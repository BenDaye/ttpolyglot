import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/src/auth/location_model.dart';
import 'package:ttpolyglot_model/src/auth/role_model.dart';
import 'package:ttpolyglot_model/src/converter/converters.dart';

part 'user_info_model.freezed.dart';
part 'user_info_model.g.dart';

/// 用户信息模型
@freezed
class UserInfoModel with _$UserInfoModel {
  const factory UserInfoModel({
    /// 用户名
    @JsonKey(name: 'username') required String username,

    /// 邮箱
    @JsonKey(name: 'email') required String email,

    /// 加密邮箱
    @JsonKey(name: 'email_encrypted') String? emailEncrypted,

    /// 显示名称
    @JsonKey(name: 'display_name') String? displayName,

    /// 头像URL
    @JsonKey(name: 'avatar_url') String? avatarUrl,

    /// 手机号
    @JsonKey(name: 'phone') String? phone,

    /// 时区
    @JsonKey(name: 'timezone') String? timezone,

    /// 是否为活跃用户
    @JsonKey(name: 'is_active') bool? isActive,

    /// 是否为邮箱已验证
    @JsonKey(name: 'is_email_verified') bool? isEmailVerified,

    /// 邮箱验证时间
    @JsonKey(name: 'email_verified_at') @NullableTimesConverter() DateTime? emailVerifiedAt,

    /// 最后登录时间
    @JsonKey(name: 'last_login_at') @NullableTimesConverter() DateTime? lastLoginAt,

    /// 最后登录IP
    @JsonKey(name: 'last_login_ip') String? lastLoginIp,

    /// 最后登录位置
    @JsonKey(name: 'last_login_location') LocationModel? lastLoginLocation,

    /// 登录尝试次数
    @JsonKey(name: 'login_attempts') int? loginAttempts,

    /// 锁定时间
    @JsonKey(name: 'locked_until') @NullableTimesConverter() DateTime? lockedUntil,

    /// 密码修改时间
    @JsonKey(name: 'password_changed_at') @NullableTimesConverter() DateTime? passwordChangedAt,

    /// 创建时间
    @JsonKey(name: 'created_at') @NullableTimesConverter() DateTime? createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @NullableTimesConverter() DateTime? updatedAt,

    /// 角色
    @JsonKey(name: 'roles') required List<RoleModel> roles,
  }) = _UserInfoModel;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
}
