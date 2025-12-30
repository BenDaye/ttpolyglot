import 'package:freezed_annotation/freezed_annotation.dart';

enum TranslationStatusEnum {
  pending('pending', '待翻译'),
  translating('translating', '翻译中'),
  completed('completed', '已完成'),
  reviewing('reviewing', '审核中'),
  approved('approved', '已批准');

  final String value;
  final String displayName;

  const TranslationStatusEnum(
    this.value,
    this.displayName,
  );
}

class TranslationStatusEnumConverter implements JsonConverter<TranslationStatusEnum, String> {
  const TranslationStatusEnumConverter();

  @override
  TranslationStatusEnum fromJson(String json) {
    return TranslationStatusEnum.values.firstWhere(
      (e) => e.value == json,
      orElse: () => TranslationStatusEnum.pending,
    );
  }

  @override
  String toJson(TranslationStatusEnum object) => object.value;
}
