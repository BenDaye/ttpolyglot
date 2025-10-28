import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'project_statistics_model.freezed.dart';
part 'project_statistics_model.g.dart';

/// 项目模型
@freezed
class ProjectStatisticsModel with _$ProjectStatisticsModel {
  const factory ProjectStatisticsModel({
    /// 项目语言数
    @JsonKey(name: 'language_count') @FlexibleIntConverter() @Default(0) int languageCount,

    /// 项目成员数
    @JsonKey(name: 'member_count') @FlexibleIntConverter() @Default(1) int memberCount,

    /// 项目总键数
    @JsonKey(name: 'total_entries') @FlexibleIntConverter() @Default(0) int totalEntries,

    /// 项目已翻译键数
    @JsonKey(name: 'translated_entries') @FlexibleIntConverter() @Default(0) int translatedEntries,

    /// 项目审核中键数
    @JsonKey(name: 'reviewing_entries') @FlexibleIntConverter() @Default(0) int reviewingEntries,

    /// 项目批准键数
    @JsonKey(name: 'approved_entries') @FlexibleIntConverter() @Default(0) int approvedEntries,

    /// 项目平均质量分数
    @JsonKey(name: 'avg_quality_score') @FlexibleDoubleConverter() @Default(0.0) double avgQualityScore,
  }) = _ProjectStatisticsModel;

  factory ProjectStatisticsModel.fromJson(Map<String, dynamic> json) => _$ProjectStatisticsModelFromJson(json);
}
