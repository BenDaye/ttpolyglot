import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/notification_channel_enum.dart';
import '../enums/notification_type_enum.dart';

part 'notification_settings_model.freezed.dart';
part 'notification_settings_model.g.dart';

/// 通知设置模型
@freezed
class NotificationSettingsModel with _$NotificationSettingsModel {
  const factory NotificationSettingsModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'project_id') int? projectId,
    @JsonKey(name: 'notification_type') @NotificationTypeEnumConverter() required NotificationTypeEnum notificationType,
    @JsonKey(name: 'channel') @NotificationChannelEnumConverter() required NotificationChannelEnum channel,
    @JsonKey(name: 'is_enabled') @Default(true) bool isEnabled,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _NotificationSettingsModel;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) => _$NotificationSettingsModelFromJson(json);
}

/// 更新通知设置请求模型
@freezed
class UpdateNotificationSettingsRequest with _$UpdateNotificationSettingsRequest {
  const factory UpdateNotificationSettingsRequest({
    required String userId,
    int? projectId,
    @JsonKey(name: 'notification_type') @NotificationTypeEnumConverter() required NotificationTypeEnum notificationType,
    @JsonKey(name: 'channel') @NotificationChannelEnumConverter() required NotificationChannelEnum channel,
    required bool isEnabled,
  }) = _UpdateNotificationSettingsRequest;

  factory UpdateNotificationSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNotificationSettingsRequestFromJson(json);
}

/// 批量更新通知设置请求模型
@freezed
class BatchUpdateNotificationSettingsRequest with _$BatchUpdateNotificationSettingsRequest {
  const factory BatchUpdateNotificationSettingsRequest({
    required String userId,
    int? projectId,
    required List<NotificationSettingUpdate> updates,
  }) = _BatchUpdateNotificationSettingsRequest;

  factory BatchUpdateNotificationSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$BatchUpdateNotificationSettingsRequestFromJson(json);
}

/// 通知设置更新项
@freezed
class NotificationSettingUpdate with _$NotificationSettingUpdate {
  const factory NotificationSettingUpdate({
    @JsonKey(name: 'notification_type') @NotificationTypeEnumConverter() required NotificationTypeEnum notificationType,
    @JsonKey(name: 'channel') @NotificationChannelEnumConverter() required NotificationChannelEnum channel,
    required bool isEnabled,
  }) = _NotificationSettingUpdate;

  factory NotificationSettingUpdate.fromJson(Map<String, dynamic> json) => _$NotificationSettingUpdateFromJson(json);
}
