import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/src/auth/location_model.dart';
import 'package:ttpolyglot_model/src/auth/role_model.dart';
import 'package:ttpolyglot_model/src/converter/converters.dart';

part 'user_info_model.freezed.dart';
part 'user_info_model.g.dart';

/// 用户信息模型
@freezed
@JsonSerializable(explicitToJson: true)
class UserInfoModel with _$UserInfoModel {
  const factory UserInfoModel({
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'email_encrypted') String? emailEncrypted,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'timezone') String? timezone,
    @JsonKey(name: 'locale') String? locale,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'is_email_verified') bool? isEmailVerified,
    @JsonKey(name: 'email_verified_at') @NullableTimesConverter() DateTime? emailVerifiedAt,
    @JsonKey(name: 'last_login_at') @NullableTimesConverter() DateTime? lastLoginAt,
    @JsonKey(name: 'last_login_ip') String? lastLoginIp,
    @JsonKey(name: 'last_login_location') LocationModel? lastLoginLocation,
    @JsonKey(name: 'login_attempts') int? loginAttempts,
    @JsonKey(name: 'locked_until') @NullableTimesConverter() DateTime? lockedUntil,
    @JsonKey(name: 'password_changed_at') @NullableTimesConverter() DateTime? passwordChangedAt,
    @JsonKey(name: 'created_at') @NullableTimesConverter() DateTime? createdAt,
    @JsonKey(name: 'updated_at') @NullableTimesConverter() DateTime? updatedAt,
    @JsonKey(name: 'roles') List<RoleModel>? roles,
  }) = _UserInfoModel;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
}
