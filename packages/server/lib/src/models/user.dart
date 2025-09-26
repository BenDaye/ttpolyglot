/// 用户模型
class User {
  final String id;
  final String username;
  final String email;
  final String passwordHash;
  final String? displayName;
  final String? avatarUrl;
  final String? phone;
  final String timezone;
  final String locale;
  final bool twoFactorEnabled;
  final String? twoFactorSecret;
  final bool isActive;
  final bool isEmailVerified;
  final DateTime? emailVerifiedAt;
  final DateTime? lastLoginAt;
  final String? lastLoginIp;
  final int loginAttempts;
  final DateTime? lockedUntil;
  final DateTime? passwordChangedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    this.displayName,
    this.avatarUrl,
    this.phone,
    this.timezone = 'UTC',
    this.locale = 'en-US',
    this.twoFactorEnabled = false,
    this.twoFactorSecret,
    this.isActive = true,
    this.isEmailVerified = false,
    this.emailVerifiedAt,
    this.lastLoginAt,
    this.lastLoginIp,
    this.loginAttempts = 0,
    this.lockedUntil,
    this.passwordChangedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从数据库行创建用户对象
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      passwordHash: map['password_hash'] as String,
      displayName: map['display_name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      phone: map['phone'] as String?,
      timezone: map['timezone'] as String? ?? 'UTC',
      locale: map['locale'] as String? ?? 'en-US',
      twoFactorEnabled: map['two_factor_enabled'] as bool? ?? false,
      twoFactorSecret: map['two_factor_secret'] as String?,
      isActive: map['is_active'] as bool? ?? true,
      isEmailVerified: map['is_email_verified'] as bool? ?? false,
      emailVerifiedAt: map['email_verified_at'] != null ? DateTime.parse(map['email_verified_at'] as String) : null,
      lastLoginAt: map['last_login_at'] != null ? DateTime.parse(map['last_login_at'] as String) : null,
      lastLoginIp: map['last_login_ip'] as String?,
      loginAttempts: map['login_attempts'] as int? ?? 0,
      lockedUntil: map['locked_until'] != null ? DateTime.parse(map['locked_until'] as String) : null,
      passwordChangedAt:
          map['password_changed_at'] != null ? DateTime.parse(map['password_changed_at'] as String) : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// 转换为Map用于API响应
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'phone': phone,
      'timezone': timezone,
      'locale': locale,
      'two_factor_enabled': twoFactorEnabled,
      'is_active': isActive,
      'is_email_verified': isEmailVerified,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'last_login_ip': lastLoginIp,
      'login_attempts': loginAttempts,
      'locked_until': lockedUntil?.toIso8601String(),
      'password_changed_at': passwordChangedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 创建用户副本
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? passwordHash,
    String? displayName,
    String? avatarUrl,
    String? phone,
    String? timezone,
    String? locale,
    bool? twoFactorEnabled,
    String? twoFactorSecret,
    bool? isActive,
    bool? isEmailVerified,
    DateTime? emailVerifiedAt,
    DateTime? lastLoginAt,
    String? lastLoginIp,
    int? loginAttempts,
    DateTime? lockedUntil,
    DateTime? passwordChangedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      timezone: timezone ?? this.timezone,
      locale: locale ?? this.locale,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      twoFactorSecret: twoFactorSecret ?? this.twoFactorSecret,
      isActive: isActive ?? this.isActive,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastLoginIp: lastLoginIp ?? this.lastLoginIp,
      loginAttempts: loginAttempts ?? this.loginAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      passwordChangedAt: passwordChangedAt ?? this.passwordChangedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
