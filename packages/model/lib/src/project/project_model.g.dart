// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectModelImpl _$$ProjectModelImplFromJson(Map<String, dynamic> json) =>
    _$ProjectModelImpl(
      id: json['id'] as String,
      languageCount: (json['language_count'] as num).toInt(),
      memberCount: (json['member_count'] as num).toInt(),
      totalEntries: (json['total_entries'] as num).toInt(),
      completedEntries: (json['completed_entries'] as num).toInt(),
      reviewingEntries: (json['reviewing_entries'] as num).toInt(),
      approvedEntries: (json['approved_entries'] as num).toInt(),
      avgQualityScore: (json['avg_quality_score'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ProjectModelImplToJson(_$ProjectModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'language_count': instance.languageCount,
      'member_count': instance.memberCount,
      'total_entries': instance.totalEntries,
      'completed_entries': instance.completedEntries,
      'reviewing_entries': instance.reviewingEntries,
      'approved_entries': instance.approvedEntries,
      'avg_quality_score': instance.avgQualityScore,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
