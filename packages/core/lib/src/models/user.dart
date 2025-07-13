import 'package:equatable/equatable.dart';

import '../enums/user_role.dart';

/// 用户模型
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.avatar,
    this.isActive = true,
    this.lastLoginAt,
    this.preferredLanguages = const [],
  });

  /// 用户唯一标识
  final String id;

  /// 邮箱地址
  final String email;

  /// 用户名
  final String name;

  /// 用户角色
  final UserRole role;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  /// 头像URL
  final String? avatar;

  /// 是否激活
  final bool isActive;

  /// 最后登录时间
  final DateTime? lastLoginAt;

  /// 偏好语言列表
  final List<String> preferredLanguages;

  /// 复制并更新用户信息
  User copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? avatar,
    bool? isActive,
    DateTime? lastLoginAt,
    List<String>? preferredLanguages,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      avatar: avatar ?? this.avatar,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferredLanguages: preferredLanguages ?? this.preferredLanguages,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'avatar': avatar,
      'isActive': isActive,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'preferredLanguages': preferredLanguages,
    };
  }

  /// 从 JSON 创建
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.values.byName(json['role'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      avatar: json['avatar'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt'] as String) : null,
      preferredLanguages: (json['preferredLanguages'] as List<dynamic>?)?.map((lang) => lang as String).toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        role,
        createdAt,
        updatedAt,
        avatar,
        isActive,
        lastLoginAt,
        preferredLanguages,
      ];

  @override
  String toString() => 'User(id: $id, name: $name, role: $role)';
}
