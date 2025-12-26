// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_member_invite_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectMemberInviteLogModelImpl _$$ProjectMemberInviteLogModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectMemberInviteLogModelImpl(
      id: const FlexibleIntConverter().fromJson(json['id']),
      memberId: const FlexibleIntConverter().fromJson(json['member_id']),
      userId: json['user_id'] as String,
      accepted: json['accepted'] as bool? ?? false,
      acceptedAt: const NullableTimesConverter().fromJson(json['accepted_at']),
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
    );

Map<String, dynamic> _$$ProjectMemberInviteLogModelImplToJson(
        _$ProjectMemberInviteLogModelImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIntConverter().toJson(instance.id),
      'member_id': const FlexibleIntConverter().toJson(instance.memberId),
      'user_id': instance.userId,
      'accepted': instance.accepted,
      'accepted_at': const NullableTimesConverter().toJson(instance.acceptedAt),
      'ip_address': instance.ipAddress,
      'user_agent': instance.userAgent,
      'created_at': const TimesConverter().toJson(instance.createdAt),
    };
