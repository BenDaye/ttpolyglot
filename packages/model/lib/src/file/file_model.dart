import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'file_model.freezed.dart';
part 'file_model.g.dart';

/// 请求额外配置类
@freezed
class FileModel with _$FileModel {
  const factory FileModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'path') required String path,
    @JsonKey(name: 'size') required int size,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'created_at') @NullableTimesConverter() DateTime? createdAt,
    @JsonKey(name: 'updated_at') @NullableTimesConverter() DateTime? updatedAt,
  }) = _FileModel;

  factory FileModel.fromJson(Map<String, dynamic> json) => _$FileModelFromJson(json);
}
