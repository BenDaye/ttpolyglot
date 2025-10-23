import 'package:freezed_annotation/freezed_annotation.dart';

/// 通知渠道枚举
enum NotificationChannelEnum {
  email('email', '邮件'),
  inApp('in_app', '应用内');

  const NotificationChannelEnum(this.value, this.displayName);

  final String value;
  final String displayName;

  /// 根据值获取对应的枚举
  static NotificationChannelEnum fromValue(String value) {
    return NotificationChannelEnum.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationChannelEnum.email,
    );
  }
}

/// NotificationChannelEnum 的 JSON 转换器
class NotificationChannelEnumConverter implements JsonConverter<NotificationChannelEnum, String> {
  const NotificationChannelEnumConverter();

  @override
  NotificationChannelEnum fromJson(String json) {
    return NotificationChannelEnum.fromValue(json);
  }

  @override
  String toJson(NotificationChannelEnum object) => object.value;
}
