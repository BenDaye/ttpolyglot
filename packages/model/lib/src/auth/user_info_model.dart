import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_model.freezed.dart';
part 'user_info_model.g.dart';

/// 用户信息模型
@freezed
class UserInfoModel with _$UserInfoModel {
  const factory UserInfoModel({
    String? id, // ID 为可选，后端不返回真实ID
    required String username,
    required String email,
    @JsonKey(name: 'email_encrypted') String? emailEncrypted,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'timezone') String? timezone,
    @JsonKey(name: 'locale') String? locale,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'is_email_verified') bool? isEmailVerified,
    @JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
    @JsonKey(name: 'last_login_ip') String? lastLoginIp,
    @JsonKey(name: 'login_attempts') int? loginAttempts,
    @JsonKey(name: 'locked_until') DateTime? lockedUntil,
    @JsonKey(name: 'password_changed_at') DateTime? passwordChangedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserInfoModel;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
}
