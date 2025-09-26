/// 用户会话模型
class UserSession {
  final String id;
  final String userId;
  final String tokenHash;
  final String? refreshTokenHash;
  final String? deviceId;
  final String? deviceName;
  final String? deviceType;
  final String? ipAddress;
  final String? userAgent;
  final Map<String, dynamic>? locationInfo;
  final bool isActive;
  final DateTime lastActivityAt;
  final DateTime expiresAt;
  final DateTime createdAt;

  const UserSession({
    required this.id,
    required this.userId,
    required this.tokenHash,
    this.refreshTokenHash,
    this.deviceId,
    this.deviceName,
    this.deviceType,
    this.ipAddress,
    this.userAgent,
    this.locationInfo,
    this.isActive = true,
    required this.lastActivityAt,
    required this.expiresAt,
    required this.createdAt,
  });

  /// 从数据库行创建会话对象
  factory UserSession.fromMap(Map<String, dynamic> map) {
    return UserSession(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      tokenHash: map['token_hash'] as String,
      refreshTokenHash: map['refresh_token_hash'] as String?,
      deviceId: map['device_id'] as String?,
      deviceName: map['device_name'] as String?,
      deviceType: map['device_type'] as String?,
      ipAddress: map['ip_address'] as String?,
      userAgent: map['user_agent'] as String?,
      locationInfo: map['location_info'] as Map<String, dynamic>?,
      isActive: map['is_active'] as bool? ?? true,
      lastActivityAt: DateTime.parse(map['last_activity_at'] as String),
      expiresAt: DateTime.parse(map['expires_at'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// 转换为Map用于数据库存储
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'token_hash': tokenHash,
      'refresh_token_hash': refreshTokenHash,
      'device_id': deviceId,
      'device_name': deviceName,
      'device_type': deviceType,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'location_info': locationInfo,
      'is_active': isActive,
      'last_activity_at': lastActivityAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// 创建会话副本
  UserSession copyWith({
    String? id,
    String? userId,
    String? tokenHash,
    String? refreshTokenHash,
    String? deviceId,
    String? deviceName,
    String? deviceType,
    String? ipAddress,
    String? userAgent,
    Map<String, dynamic>? locationInfo,
    bool? isActive,
    DateTime? lastActivityAt,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return UserSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tokenHash: tokenHash ?? this.tokenHash,
      refreshTokenHash: refreshTokenHash ?? this.refreshTokenHash,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      locationInfo: locationInfo ?? this.locationInfo,
      isActive: isActive ?? this.isActive,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserSession(id: $id, userId: $userId, deviceType: $deviceType, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserSession && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
