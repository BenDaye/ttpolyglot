import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

/// 项目模型
@freezed
class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'language_count') required int languageCount,
    @JsonKey(name: 'member_count') required int memberCount,
    @JsonKey(name: 'total_entries') required int totalEntries,
    @JsonKey(name: 'completed_entries') required int completedEntries,
    @JsonKey(name: 'reviewing_entries') required int reviewingEntries,
    @JsonKey(name: 'approved_entries') required int approvedEntries,
    @JsonKey(name: 'avg_quality_score') required double avgQualityScore,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);
}
