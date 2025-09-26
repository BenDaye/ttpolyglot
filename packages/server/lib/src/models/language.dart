/// 语言模型
class Language {
  final String code;
  final String name;
  final String nativeName;
  final String direction;
  final bool isActive;
  final bool isRtl;
  final String? pluralizationRule;
  final int sortIndex;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    this.direction = 'ltr',
    this.isActive = true,
    this.isRtl = false,
    this.pluralizationRule,
    this.sortIndex = 0,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从数据库行创建语言对象
  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      code: map['code'] as String,
      name: map['name'] as String,
      nativeName: map['native_name'] as String,
      direction: map['direction'] as String? ?? 'ltr',
      isActive: map['is_active'] as bool? ?? true,
      isRtl: map['is_rtl'] as bool? ?? false,
      pluralizationRule: map['pluralization_rule'] as String?,
      sortIndex: map['sort_index'] as int? ?? 0,
      metadata: map['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// 转换为Map用于API响应
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'native_name': nativeName,
      'direction': direction,
      'is_active': isActive,
      'is_rtl': isRtl,
      'pluralization_rule': pluralizationRule,
      'sort_index': sortIndex,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 创建语言副本
  Language copyWith({
    String? code,
    String? name,
    String? nativeName,
    String? direction,
    bool? isActive,
    bool? isRtl,
    String? pluralizationRule,
    int? sortIndex,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Language(
      code: code ?? this.code,
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      direction: direction ?? this.direction,
      isActive: isActive ?? this.isActive,
      isRtl: isRtl ?? this.isRtl,
      pluralizationRule: pluralizationRule ?? this.pluralizationRule,
      sortIndex: sortIndex ?? this.sortIndex,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Language(code: $code, name: $name, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Language && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}
