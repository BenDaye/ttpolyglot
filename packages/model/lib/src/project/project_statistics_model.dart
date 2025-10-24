import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_statistics_model.freezed.dart';
part 'project_statistics_model.g.dart';

/// 项目模型
@freezed
class ProjectStatisticsModel with _$ProjectStatisticsModel {
  const factory ProjectStatisticsModel({
    @JsonKey(name: 'language_count') @Default(0) int languageCount,
    @JsonKey(name: 'member_count') @Default(1) int memberCount,
    @JsonKey(name: 'total_entries') @Default(0) int totalEntries,
    @JsonKey(name: 'completed_entries') @Default(0) int completedEntries,
    @JsonKey(name: 'reviewing_entries') @Default(0) int reviewingEntries,
    @JsonKey(name: 'approved_entries') @Default(0) int approvedEntries,
    @JsonKey(name: 'avg_quality_score') @Default(0.0) double avgQualityScore,
  }) = _ProjectStatisticsModel;

  factory ProjectStatisticsModel.fromJson(Map<String, dynamic> json) => _$ProjectStatisticsModelFromJson(json);
}
