enum ApiResponseTipsType {
  showDialog('showDialog'),
  showToast('showToast'),
  showSnackBar('showSnackBar');

  final String value;

  const ApiResponseTipsType(this.value);

  /// 根据值获取对应的枚举
  static ApiResponseTipsType fromValue(String value) {
    return ApiResponseTipsType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ApiResponseTipsType.showToast,
    );
  }
}

/// 将 string 转换为 ApiResponseTipsType
ApiResponseTipsType apiResponseTipsTypeFromJson(String value) => ApiResponseTipsType.fromValue(value);

/// 将 ApiResponseTipsType 转换为 string
String apiResponseTipsTypeToJson(ApiResponseTipsType type) => type.value;
