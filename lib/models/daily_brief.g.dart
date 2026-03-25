// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_brief.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyBriefImpl _$$DailyBriefImplFromJson(Map<String, dynamic> json) =>
    _$DailyBriefImpl(
      summary: json['summary'] as String,
      gapCount: (json['gapCount'] as num).toInt(),
      gaps:
          (json['gaps'] as List<dynamic>?)
              ?.map((e) => SkillGap.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DailyBriefImplToJson(_$DailyBriefImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'gapCount': instance.gapCount,
      'gaps': instance.gaps.map((e) => e.toJson()).toList(),
    };

_$SkillGapImpl _$$SkillGapImplFromJson(Map<String, dynamic> json) =>
    _$SkillGapImpl(
      name: json['name'] as String,
      trend: json['trend'] as String?,
      mentionCount: (json['mentionCount'] as num).toInt(),
      suggestedAction: json['suggestedAction'] as String,
      detectedAt: const TimestampConverter().fromJson(json['detectedAt']),
      weekId: json['weekId'] as String?,
    );

Map<String, dynamic> _$$SkillGapImplToJson(_$SkillGapImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'trend': instance.trend,
      'mentionCount': instance.mentionCount,
      'suggestedAction': instance.suggestedAction,
      'detectedAt': const TimestampConverter().toJson(instance.detectedAt),
      'weekId': instance.weekId,
    };
