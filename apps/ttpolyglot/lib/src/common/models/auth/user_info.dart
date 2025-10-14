import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

/// 用户信息模型
@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    required String id,
    required String username,
    required String email,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? timezone,
    String? locale,
    @JsonKey(name: 'is_email_verified') bool? isEmailVerified,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
}
