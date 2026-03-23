// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      role: json['role'] as String,
      skills: (json['skills'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      level: json['level'] as String,
      feedSources: (json['feedSources'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      fcmToken: json['fcmToken'] as String?,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'role': instance.role,
      'skills': instance.skills,
      'level': instance.level,
      'feedSources': instance.feedSources,
      'fcmToken': instance.fcmToken,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
