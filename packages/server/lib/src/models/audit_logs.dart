/// 审计日志模型
class AuditLog {
  final String id;
  final String tableName;
  final String operation; // 'INSERT', 'UPDATE', 'DELETE'
  final String recordId;
  final Map<String, dynamic>? oldValues;
  final Map<String, dynamic>? newValues;
  final String? userId;
  final String? ipAddress;
  final String? userAgent;
  final DateTime createdAt;

  AuditLog({
    required this.id,
    required this.tableName,
    required this.operation,
    required this.recordId,
    this.oldValues,
    this.newValues,
    this.userId,
    this.ipAddress,
    this.userAgent,
    required this.createdAt,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: json['id'] as String,
      tableName: json['table_name'] as String,
      operation: json['operation'] as String,
      recordId: json['record_id'] as String,
      oldValues: json['old_values'] as Map<String, dynamic>?,
      newValues: json['new_values'] as Map<String, dynamic>?,
      userId: json['user_id'] as String?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_name': tableName,
      'operation': operation,
      'record_id': recordId,
      'old_values': oldValues,
      'new_values': newValues,
      'user_id': userId,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AuditLog.fromMap(Map<String, dynamic> map) {
    return AuditLog(
      id: map['id'] as String,
      tableName: map['table_name'] as String,
      operation: map['operation'] as String,
      recordId: map['record_id'] as String,
      oldValues: map['old_values'] as Map<String, dynamic>?,
      newValues: map['new_values'] as Map<String, dynamic>?,
      userId: map['user_id'] as String?,
      ipAddress: map['ip_address'] as String?,
      userAgent: map['user_agent'] as String?,
      createdAt: map['created_at'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'table_name': tableName,
      'operation': operation,
      'record_id': recordId,
      'old_values': oldValues,
      'new_values': newValues,
      'user_id': userId,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'created_at': createdAt,
    };
  }
}
