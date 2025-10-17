import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_config_model.freezed.dart';
part 'system_config_model.g.dart';

/// 系统配置模型
@freezed
class SystemConfig with _$SystemConfig {
  const factory SystemConfig({
    /// 配置ID
    String? id,

    /// 配置键
    @JsonKey(name: 'config_key') required String configKey,

    /// 配置值
    @JsonKey(name: 'config_value') required String configValue,

    /// 值类型 (bool, int, double, string)
    @JsonKey(name: 'value_type') String? valueType,

    /// 默认值
    @JsonKey(name: 'default_value') String? defaultValue,

    /// 分类
    String? category,

    /// 显示名称
    @JsonKey(name: 'display_name') String? displayName,

    /// 描述
    String? description,

    /// 排序顺序
    @JsonKey(name: 'sort_order') int? sortOrder,

    /// 是否可编辑
    @JsonKey(name: 'is_editable') @Default(true) bool isEditable,

    /// 是否公开
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,

    /// 是否激活
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    /// 更新人
    @JsonKey(name: 'updated_by') String? updatedBy,

    /// 变更原因
    @JsonKey(name: 'change_reason') String? changeReason,

    /// 创建时间
    @JsonKey(name: 'created_at') DateTime? createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _SystemConfig;

  const SystemConfig._();

  factory SystemConfig.fromJson(Map<String, dynamic> json) => _$SystemConfigFromJson(json);

  /// 获取解析后的值
  dynamic getParsedValue() {
    final value = configValue;
    final type = valueType;

    switch (type) {
      case 'bool':
        return value.toLowerCase() == 'true';
      case 'int':
        return int.tryParse(value);
      case 'double':
        return double.tryParse(value);
      default:
        return value;
    }
  }

  /// 验证值
  bool validateValue(String value) {
    if (value.isEmpty) return false;

    switch (valueType) {
      case 'bool':
        return value.toLowerCase() == 'true' || value.toLowerCase() == 'false';
      case 'int':
        return int.tryParse(value) != null;
      case 'double':
        return double.tryParse(value) != null;
      default:
        return true;
    }
  }
}
