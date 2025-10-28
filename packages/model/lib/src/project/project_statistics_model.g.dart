// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectStatisticsModelImpl _$$ProjectStatisticsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectStatisticsModelImpl(
      languageCount: json['language_count'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['language_count']),
      memberCount: json['member_count'] == null
          ? 1
          : const FlexibleIntConverter().fromJson(json['member_count']),
      totalEntries: json['total_entries'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['total_entries']),
      translatedEntries: json['translated_entries'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['translated_entries']),
      reviewingEntries: json['reviewing_entries'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['reviewing_entries']),
      approvedEntries: json['approved_entries'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['approved_entries']),
      avgQualityScore: json['avg_quality_score'] == null
          ? 0.0
          : const FlexibleDoubleConverter().fromJson(json['avg_quality_score']),
    );

Map<String, dynamic> _$$ProjectStatisticsModelImplToJson(
        _$ProjectStatisticsModelImpl instance) =>
    <String, dynamic>{
      'language_count':
          const FlexibleIntConverter().toJson(instance.languageCount),
      'member_count': const FlexibleIntConverter().toJson(instance.memberCount),
      'total_entries':
          const FlexibleIntConverter().toJson(instance.totalEntries),
      'translated_entries':
          const FlexibleIntConverter().toJson(instance.translatedEntries),
      'reviewing_entries':
          const FlexibleIntConverter().toJson(instance.reviewingEntries),
      'approved_entries':
          const FlexibleIntConverter().toJson(instance.approvedEntries),
      'avg_quality_score':
          const FlexibleDoubleConverter().toJson(instance.avgQualityScore),
    };
