import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'user_session_model.freezed.dart';
part 'user_session_model.g.dart';

/// 用户会话模型
@freezed
class UserSessionModel with _$UserSessionModel {
  const factory UserSessionModel({
    /// 会话ID
    @JsonKey(name: 'id') @FlexibleIntConverter() required int id,

    /// 用户ID
    @JsonKey(name: 'user_id') required String userId,

    /// 访问令牌哈希值
    @JsonKey(name: 'token_hash') required String tokenHash,

    /// 刷新令牌哈希值
    @JsonKey(name: 'refresh_token_hash') String? refreshTokenHash,

    /// 设备ID
    @JsonKey(name: 'device_id') String? deviceId,

    /// 设备名称
    @JsonKey(name: 'device_name') String? deviceName,

    /// 设备类型
    @JsonKey(name: 'device_type') String? deviceType,

    /// IP地址
    @JsonKey(name: 'ip_address') String? ipAddress,

    /// 用户代理
    @JsonKey(name: 'user_agent') String? userAgent,

    /// 位置信息（JSONB格式）
    @JsonKey(name: 'location_info') Map<String, dynamic>? locationInfo,

    /// 最后活动时间
    @JsonKey(name: 'last_activity_at') @TimesConverter() required DateTime lastActivityAt,

    /// 过期时间
    @JsonKey(name: 'expires_at') @TimesConverter() required DateTime expiresAt,

    /// 是否激活
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    /// 创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @TimesConverter() required DateTime updatedAt,
  }) = _UserSessionModel;

  const UserSessionModel._();

  factory UserSessionModel.fromJson(Map<String, dynamic> json) => _$UserSessionModelFromJson(json);

  /// 是否已过期
  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAt);

  /// 是否有效（激活且未过期）
  bool get isValid => isActive && !isExpired;
}
