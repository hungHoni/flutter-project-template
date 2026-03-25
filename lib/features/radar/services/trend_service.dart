import '../../../models/daily_brief.dart';
import '../../../models/weekly_skill_gaps.dart';

/// Computes trend labels for skill gaps based on historical data.
///
/// - **Hot** = 10+ mentions in current batch
/// - **Rising** = mentions increased 2x+ vs. last week
/// - **New** = skill not present in any prior week
class TrendService {
  /// Assigns trend labels to current gaps using previous weeks' data.
  List<SkillGap> assignTrends({
    required List<SkillGap> currentGaps,
    required List<WeeklySkillGaps> previousWeeks,
  }) {
    // Collect all skill names from previous weeks.
    final previousSkills = <String, int>{};
    for (final week in previousWeeks) {
      for (final gap in week.gaps) {
        final existing = previousSkills[gap.name] ?? 0;
        if (gap.mentionCount > existing) {
          previousSkills[gap.name] = gap.mentionCount;
        }
      }
    }

    return currentGaps.map((gap) {
      final trend = _computeTrend(
        gap.name,
        gap.mentionCount,
        previousSkills,
      );
      return gap.copyWith(trend: trend);
    }).toList();
  }

  String _computeTrend(
    String skillName,
    int currentMentions,
    Map<String, int> previousSkills,
  ) {
    // Hot: 10+ mentions in current batch.
    if (currentMentions >= 10) return 'hot';

    final previousMentions = previousSkills[skillName];

    // New: not present in any prior week.
    if (previousMentions == null) return 'new';

    // Rising: mentions increased 2x+ vs. last week.
    if (previousMentions > 0 && currentMentions >= previousMentions * 2) {
      return 'rising';
    }

    return 'new';
  }
}
