import 'dart:convert';

/// 系统配置模型
class SystemConfig {
  final String id;
  final String configKey;
  final String? configValue;
  final String valueType;
  final String category;
  final String displayName;
  final String? description;
  final bool isPublic;
  final bool isEditable;
  final bool isEncrypted;
  final String? defaultValue;
  final Map<String, dynamic>? validationRule;
  final int sortOrder;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? lastChangedAt;
  final String? changeReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SystemConfig({
    required this.id,
    required this.configKey,
    this.configValue,
    this.valueType = 'string',
    required this.category,
    required this.displayName,
    this.description,
    this.isPublic = false,
    this.isEditable = true,
    this.isEncrypted = false,
    this.defaultValue,
    this.validationRule,
    this.sortOrder = 0,
    this.createdBy,
    this.updatedBy,
    this.lastChangedAt,
    this.changeReason,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从数据库行创建配置对象
  factory SystemConfig.fromMap(Map<String, dynamic> map) {
    return SystemConfig(
      id: map['id'] as String,
      configKey: map['config_key'] as String,
      configValue: map['config_value'] as String?,
      valueType: map['value_type'] as String? ?? 'string',
      category: map['category'] as String,
      displayName: map['display_name'] as String,
      description: map['description'] as String?,
      isPublic: map['is_public'] as bool? ?? false,
      isEditable: map['is_editable'] as bool? ?? true,
      isEncrypted: map['is_encrypted'] as bool? ?? false,
      defaultValue: map['default_value'] as String?,
      validationRule: map['validation_rule'] as Map<String, dynamic>?,
      sortOrder: map['sort_order'] as int? ?? 0,
      createdBy: map['created_by'] as String?,
      updatedBy: map['updated_by'] as String?,
      lastChangedAt: map['last_changed_at'] != null ? DateTime.parse(map['last_changed_at'] as String) : null,
      changeReason: map['change_reason'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// 转换为Map用于API响应
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'config_key': configKey,
      'config_value': configValue,
      'value_type': valueType,
      'category': category,
      'display_name': displayName,
      'description': description,
      'is_public': isPublic,
      'is_editable': isEditable,
      'is_encrypted': isEncrypted,
      'default_value': defaultValue,
      'validation_rule': validationRule,
      'sort_order': sortOrder,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'last_changed_at': lastChangedAt?.toIso8601String(),
      'change_reason': changeReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// 创建配置副本
  SystemConfig copyWith({
    String? id,
    String? configKey,
    String? configValue,
    String? valueType,
    String? category,
    String? displayName,
    String? description,
    bool? isPublic,
    bool? isEditable,
    bool? isEncrypted,
    String? defaultValue,
    Map<String, dynamic>? validationRule,
    int? sortOrder,
    String? createdBy,
    String? updatedBy,
    DateTime? lastChangedAt,
    String? changeReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SystemConfig(
      id: id ?? this.id,
      configKey: configKey ?? this.configKey,
      configValue: configValue ?? this.configValue,
      valueType: valueType ?? this.valueType,
      category: category ?? this.category,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      isEditable: isEditable ?? this.isEditable,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      defaultValue: defaultValue ?? this.defaultValue,
      validationRule: validationRule ?? this.validationRule,
      sortOrder: sortOrder ?? this.sortOrder,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      lastChangedAt: lastChangedAt ?? this.lastChangedAt,
      changeReason: changeReason ?? this.changeReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 获取解析后的值
  dynamic getParsedValue() {
    if (configValue == null) return null;

    switch (valueType) {
      case 'boolean':
        return configValue!.toLowerCase() == 'true';
      case 'number':
        return num.tryParse(configValue!);
      case 'json':
      case 'array':
        try {
          return jsonDecode(configValue!);
        } catch (e) {
          return configValue;
        }
      case 'string':
      default:
        return configValue;
    }
  }

  /// 验证配置值
  bool validateValue(dynamic value) {
    if (validationRule == null) return true;

    // 这里可以根据validationRule实现复杂的验证逻辑
    // 例如：最小值、最大值、正则表达式等
    return true;
  }

  @override
  String toString() {
    return 'SystemConfig(key: $configKey, category: $category, valueType: $valueType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SystemConfig && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 配置类别枚举
enum ConfigCategory {
  system('system'),
  security('security'),
  translation('translation'),
  notification('notification'),
  ui('ui'),
  api('api');

  const ConfigCategory(this.value);
  final String value;

  static ConfigCategory fromString(String value) {
    return ConfigCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => ConfigCategory.system,
    );
  }
}

/// 配置值类型枚举
enum ConfigValueType {
  string('string'),
  number('number'),
  boolean('boolean'),
  json('json'),
  array('array');

  const ConfigValueType(this.value);
  final String value;

  static ConfigValueType fromString(String value) {
    return ConfigValueType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ConfigValueType.string,
    );
  }
}
