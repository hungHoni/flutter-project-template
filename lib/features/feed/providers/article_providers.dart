import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/auth_provider.dart';
import '../../../features/onboarding/models/onboarding_state.dart';
import '../../../features/profile/providers/user_profile_provider.dart';
import '../../../models/article.dart';
import '../repositories/article_repository.dart';
import '../services/feed_sync_service.dart';

/// Streams articles from Firestore, optionally filtered by source.
/// Pass `null` for all, `'reddit'` / `'hn'` / `'blog'` for filtered.
final articlesStreamProvider =
    StreamProvider.family<List<Article>, String?>((ref, source) {
  final repo = ref.watch(articleRepositoryProvider);
  return repo.watchArticles(source: source);
});

/// Default feed sources when profile is unavailable.
List<String> _defaultSources() =>
    availableSources.where((s) => s.defaultEnabled).map((s) => s.name).toList();

/// Resolves the current user's feed sources from their profile,
/// falling back to defaults if profile is not loaded.
List<String> _userFeedSources(Ref ref) {
  final profile = ref.watch(userProfileProvider).valueOrNull;
  if (profile != null && profile.feedSources.isNotEmpty) {
    return profile.feedSources;
  }
  return _defaultSources();
}

/// Triggers an initial feed sync when first read.
final feedSyncProvider = FutureProvider<FeedSyncResult>((ref) async {
  // Wait for auth before syncing.
  ref.watch(authStateProvider);
  final service = ref.watch(feedSyncServiceProvider);
  final sources = _userFeedSources(ref);
  return service.syncFeeds(sources);
});

/// Notifier for manual refresh (pull-to-refresh).
class FeedSyncNotifier extends AutoDisposeAsyncNotifier<FeedSyncResult?> {
  @override
  Future<FeedSyncResult?> build() async => null;

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(feedSyncServiceProvider);
      final sources = _userFeedSources(ref);
      return service.syncFeeds(sources);
    });
  }
}

final feedSyncNotifierProvider =
    AutoDisposeAsyncNotifierProvider<FeedSyncNotifier, FeedSyncResult?>(
  FeedSyncNotifier.new,
);
