import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// Triggers an initial feed sync when first read.
final feedSyncProvider = FutureProvider<FeedSyncResult>((ref) async {
  final service = ref.watch(feedSyncServiceProvider);
  // Default sources — later will read from user profile.
  const defaultSources = [
    'r/MachineLearning',
    'r/LocalLLaMA',
    'Hacker News',
    'AI Blogs',
  ];
  return service.syncFeeds(defaultSources);
});

/// Notifier for manual refresh (pull-to-refresh).
class FeedSyncNotifier extends AutoDisposeAsyncNotifier<FeedSyncResult?> {
  @override
  Future<FeedSyncResult?> build() async => null;

  Future<void> refresh(List<String> sources) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(feedSyncServiceProvider);
      return service.syncFeeds(sources);
    });
  }
}

final feedSyncNotifierProvider =
    AutoDisposeAsyncNotifierProvider<FeedSyncNotifier, FeedSyncResult?>(
  FeedSyncNotifier.new,
);
