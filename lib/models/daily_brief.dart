import 'package:freezed_annotation/freezed_annotation.dart';

import 'timestamp_converter.dart';

part 'daily_brief.freezed.dart';
part 'daily_brief.g.dart';

/// Firestore document: `users/{uid}/briefs/{date}` where date = "2026-03-21".
@freezed
class DailyBrief with _$DailyBrief {
  const factory DailyBrief({
    required String summary,
    required int gapCount,
    @Default([]) List<SkillGap> gaps,
  }) = _DailyBrief;

  factory DailyBrief.fromJson(Map<String, dynamic> json) =>
      _$DailyBriefFromJson(json);
}

/// A single detected skill gap entry, embedded in [DailyBrief.gaps]
/// and [WeeklySkillGaps.gaps].
@freezed
class SkillGap with _$SkillGap {
  const factory SkillGap({
    required String name,
    String? trend,
    required int mentionCount,
    required String suggestedAction,
    @TimestampConverter() required DateTime detectedAt,
    String? weekId,
  }) = _SkillGap;

  factory SkillGap.fromJson(Map<String, dynamic> json) =>
      _$SkillGapFromJson(json);
}
