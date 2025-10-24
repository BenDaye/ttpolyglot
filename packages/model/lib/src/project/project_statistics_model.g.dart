// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectStatisticsModelImpl _$$ProjectStatisticsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectStatisticsModelImpl(
      languageCount: (json['language_count'] as num?)?.toInt() ?? 0,
      memberCount: (json['member_count'] as num?)?.toInt() ?? 1,
      totalEntries: (json['total_entries'] as num?)?.toInt() ?? 0,
      completedEntries: (json['completed_entries'] as num?)?.toInt() ?? 0,
      reviewingEntries: (json['reviewing_entries'] as num?)?.toInt() ?? 0,
      approvedEntries: (json['approved_entries'] as num?)?.toInt() ?? 0,
      avgQualityScore: (json['avg_quality_score'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$ProjectStatisticsModelImplToJson(
        _$ProjectStatisticsModelImpl instance) =>
    <String, dynamic>{
      'language_count': instance.languageCount,
      'member_count': instance.memberCount,
      'total_entries': instance.totalEntries,
      'completed_entries': instance.completedEntries,
      'reviewing_entries': instance.reviewingEntries,
      'approved_entries': instance.approvedEntries,
      'avg_quality_score': instance.avgQualityScore,
    };
