// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_skill_gaps.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklySkillGapsImpl _$$WeeklySkillGapsImplFromJson(
  Map<String, dynamic> json,
) => _$WeeklySkillGapsImpl(
  gaps:
      (json['gaps'] as List<dynamic>?)
          ?.map((e) => SkillGap.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$WeeklySkillGapsImplToJson(
  _$WeeklySkillGapsImpl instance,
) => <String, dynamic>{'gaps': instance.gaps};
