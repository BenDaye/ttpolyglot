import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'file_model.freezed.dart';
part 'file_model.g.dart';

/// 请求额外配置类
@freezed
class FileModel with _$FileModel {
  const factory FileModel({
    /// 文件ID
    @JsonKey(name: 'id') required String id,

    /// 文件名称
    @JsonKey(name: 'name') required String name,

    /// 文件路径
    @JsonKey(name: 'path') required String path,

    /// 文件大小
    @JsonKey(name: 'size') required int size,

    /// 文件类型
    @JsonKey(name: 'type') required String type,

    /// 创建时间
    @JsonKey(name: 'created_at') @NullableTimesConverter() DateTime? createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @NullableTimesConverter() DateTime? updatedAt,
  }) = _FileModel;

  factory FileModel.fromJson(Map<String, dynamic> json) => _$FileModelFromJson(json);
}
