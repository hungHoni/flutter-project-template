import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/auth_provider.dart';
import '../../../models/daily_brief.dart';
import '../../../models/user_profile.dart';
import '../../feed/repositories/article_repository.dart';
import '../../profile/providers/user_profile_provider.dart';
import '../repositories/brief_repository.dart';
import '../repositories/skill_gap_repository.dart';
import '../services/claude_service.dart';
import '../services/trend_service.dart';

/// Today's date formatted as yyyy-MM-dd for Firestore doc ID.
String _todayId() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

/// Current ISO week ID (e.g. "2026-W12").
String _currentWeekId() {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
  final weekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();
  return '${now.year}-W${weekNumber.toString().padLeft(2, '0')}';
}

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
    // Wait for auth to resolve (may still be loading on app start).
    var user = ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      // Wait up to 10 seconds for auth.
      for (var i = 0; i < 20 && user == null; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        user = ref.read(authStateProvider).valueOrNull;
      }
      if (user == null) throw Exception('Not authenticated');
    }
    debugPrint('[Radar] Auth OK: ${user.uid}');

    // Wait for profile to resolve (may still be loading on app start).
    var profile = ref.read(userProfileProvider).valueOrNull;
    if (profile == null) {
      // Wait up to 5 seconds for profile.
      for (var i = 0; i < 10 && profile == null; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        profile = ref.read(userProfileProvider).valueOrNull;
      }
    }
    // Use default profile if none exists (e.g. fresh install, no onboarding yet).
    profile ??= UserProfile(
      role: 'Software Engineer',
      skills: const [],
      level: 'Intermediate',
      feedSources: const ['r/MachineLearning', 'Hacker News', 'AI Blogs'],
      createdAt: DateTime.now(),
    );

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
    final weekId = _currentWeekId();

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
    final brief = DailyBrief(
      summary: result.brief,
      gapCount: gapsWithTrends.length,
      gaps: gapsWithTrends,
    );
    debugPrint('[Radar] Saving brief for ${_todayId()} with ${gapsWithTrends.length} gaps');
    await briefRepo.saveBrief(user.uid, _todayId(), brief);
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
