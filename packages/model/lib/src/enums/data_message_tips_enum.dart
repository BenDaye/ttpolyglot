import 'package:freezed_annotation/freezed_annotation.dart';

enum DataMessageTipsEnum {
  showDialog('showDialog'),
  showToast('showToast'),
  showSnackBar('showSnackBar');

  final String value;

  const DataMessageTipsEnum(this.value);

  /// 根据值获取对应的枚举
  static DataMessageTipsEnum fromValue(String value) {
    return DataMessageTipsEnum.values.firstWhere(
      (type) => type.value == value,
      orElse: () => DataMessageTipsEnum.showToast,
    );
  }
}

/// DataMessageTipsEnum 的 JSON 转换器
class DataMessageTipsEnumConverter implements JsonConverter<DataMessageTipsEnum, String> {
  const DataMessageTipsEnumConverter();

  @override
  DataMessageTipsEnum fromJson(String json) {
    return DataMessageTipsEnum.fromValue(json);
  }

  @override
  String toJson(DataMessageTipsEnum object) => object.value;
}
