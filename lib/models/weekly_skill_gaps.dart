import 'package:freezed_annotation/freezed_annotation.dart';

import 'daily_brief.dart';

part 'weekly_skill_gaps.freezed.dart';
part 'weekly_skill_gaps.g.dart';

/// Firestore document: `users/{uid}/skillGaps/{weekId}` where weekId = "2026-W12".
@freezed
class WeeklySkillGaps with _$WeeklySkillGaps {
  const factory WeeklySkillGaps({
    @Default([]) List<SkillGap> gaps,
  }) = _WeeklySkillGaps;

  factory WeeklySkillGaps.fromJson(Map<String, dynamic> json) =>
      _$WeeklySkillGapsFromJson(json);
}
