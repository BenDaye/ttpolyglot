/// 通知模型
class Notification {
  final String id;
  final String userId;
  final String type; // 'system', 'project', 'translation', 'security', etc.
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? readAt;
  final String? readBy;
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final String? actionUrl;
  final String? actionText;
  final DateTime createdAt;
  final DateTime? expiresAt;

  Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.isRead = false,
    this.readAt,
    this.readBy,
    this.priority = 'medium',
    this.actionUrl,
    this.actionText,
    required this.createdAt,
    this.expiresAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      readBy: json['read_by'] as String?,
      priority: json['priority'] as String? ?? 'medium',
      actionUrl: json['action_url'] as String?,
      actionText: json['action_text'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'message': message,
      'data': data,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'read_by': readBy,
      'priority': priority,
      'action_url': actionUrl,
      'action_text': actionText,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: map['type'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      data: map['data'] as Map<String, dynamic>?,
      isRead: map['is_read'] as bool,
      readAt: map['read_at'] as DateTime?,
      readBy: map['read_by'] as String?,
      priority: map['priority'] as String,
      actionUrl: map['action_url'] as String?,
      actionText: map['action_text'] as String?,
      createdAt: map['created_at'] as DateTime,
      expiresAt: map['expires_at'] as DateTime?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'message': message,
      'data': data,
      'is_read': isRead,
      'read_at': readAt,
      'read_by': readBy,
      'priority': priority,
      'action_url': actionUrl,
      'action_text': actionText,
      'created_at': createdAt,
      'expires_at': expiresAt,
    };
  }

  /// 标记为已读
  Notification markAsRead({String? readBy}) {
    return Notification(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      data: data,
      isRead: true,
      readAt: DateTime.now(),
      readBy: readBy ?? this.readBy,
      priority: priority,
      actionUrl: actionUrl,
      actionText: actionText,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }

  /// 检查是否过期
  bool get isExpired {
    return expiresAt != null && DateTime.now().isAfter(expiresAt!);
  }

  /// 获取优先级数值（用于排序）
  int get priorityValue {
    switch (priority.toLowerCase()) {
      case 'low':
        return 1;
      case 'medium':
        return 2;
      case 'high':
        return 3;
      case 'urgent':
        return 4;
      default:
        return 2;
    }
  }
}

/// 通知类型枚举
enum NotificationType {
  system,
  project,
  translation,
  security,
  user,
  marketing,
}

/// 通知优先级枚举
enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}
