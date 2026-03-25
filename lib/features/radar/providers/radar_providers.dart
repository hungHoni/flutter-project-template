import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/auth_provider.dart';
import '../../../models/daily_brief.dart';
import '../../../shared/utils/date_utils.dart';
import '../../feed/repositories/article_repository.dart';
import '../../profile/providers/user_profile_provider.dart';
import '../repositories/brief_repository.dart';
import '../repositories/skill_gap_repository.dart';
import '../services/claude_service.dart';
import '../services/trend_service.dart';

/// Streams today's brief from Firestore.
final todaysBriefProvider = StreamProvider<DailyBrief?>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value(null);

  final repo = ref.watch(briefRepositoryProvider);
  return repo.watchTodaysBrief(user.uid);
});

/// Orchestrates Claude API analysis: fetch profile + articles → call Claude
/// → save brief + gaps → tag articles.
class RadarRefreshNotifier extends AutoDisposeAsyncNotifier<void> {
  bool _isRunning = false;

  @override
  Future<void> build() async {}

  Future<void> refresh() async {
    if (_isRunning) return; // Prevent concurrent calls.
    _isRunning = true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _runAnalysis());
    _isRunning = false;
  }

  Future<void> _runAnalysis() async {
    debugPrint('[Radar] Starting analysis...');
    // Await auth future — no polling needed.
    final user = await ref.read(authStateProvider.future);
    if (user == null) throw Exception('Not authenticated');
    debugPrint('[Radar] Auth OK: ${user.uid}');

    // Await profile future.
    final profile = await ref.read(userProfileProvider.future);
    if (profile == null) {
      throw Exception('Profile not loaded. Complete onboarding first.');
    }

    // Read recent articles from Firestore (all sources, last 50).
    final articleRepo = ref.read(articleRepositoryProvider);
    final articles = await articleRepo.watchArticles(limit: 50).first;

    debugPrint('[Radar] Found ${articles.length} articles');
    if (articles.isEmpty) {
      throw Exception('No articles available. Fetch feeds first.');
    }

    // Build article ID map for Claude to reference.
    final articleIdMap = <String, String>{};
    for (final article in articles) {
      articleIdMap[article.url] =
          sha256.convert(utf8.encode(article.url)).toString().substring(0, 20);
    }

    // Call Claude API.
    final claudeService = ref.read(claudeServiceProvider);
    final result = await claudeService.generateBrief(
      profile: profile,
      articles: articles,
      articleIdMap: articleIdMap,
    );

    // Compute trends from historical data.
    final skillGapRepo = ref.read(skillGapRepositoryProvider);
    final previousWeeks = await skillGapRepo.getPreviousWeeks(user.uid, 4);
    final trendService = TrendService();

    final now = DateTime.now();
    final weekId = isoWeekId();

    // Convert Claude gaps to SkillGap models.
    final rawGaps = result.gaps.map((g) {
      return SkillGap(
        name: g.skill,
        mentionCount: g.mentions,
        suggestedAction: g.action,
        detectedAt: now,
        weekId: weekId,
      );
    }).toList();

    // Assign trends.
    final gapsWithTrends = trendService.assignTrends(
      currentGaps: rawGaps,
      previousWeeks: previousWeeks,
    );

    // Save brief to Firestore.
    final briefRepo = ref.read(briefRepositoryProvider);
    final today = todayId();
    final brief = DailyBrief(
      summary: result.brief,
      gapCount: gapsWithTrends.length,
      gaps: gapsWithTrends,
    );
    debugPrint('[Radar] Saving brief for $today with ${gapsWithTrends.length} gaps');
    await briefRepo.saveBrief(user.uid, today, brief);
    debugPrint('[Radar] Brief saved!');

    // Save weekly skill gaps.
    await skillGapRepo.saveWeeklyGaps(user.uid, weekId, gapsWithTrends);

    // Tag relevant articles in Firestore.
    if (result.taggedArticleIds.isNotEmpty) {
      await articleRepo.tagArticlesAsSkillGap(result.taggedArticleIds);
    }

    debugPrint('[Radar] All saved. Invalidating brief provider.');
    // Invalidate brief provider so UI picks up the new data.
    ref.invalidate(todaysBriefProvider);
    debugPrint('[Radar] Done!');
  }
}

final radarRefreshProvider =
    AutoDisposeAsyncNotifierProvider<RadarRefreshNotifier, void>(
  RadarRefreshNotifier.new,
);
