import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/article_repository.dart';
import 'rss_service.dart';

/// Result of a feed sync operation.
class FeedSyncResult {
  const FeedSyncResult({this.added = 0, this.skipped = 0, this.errors = const []});
  final int added;
  final int skipped;
  final List<String> errors;
}

/// Orchestrates RSS fetch → dedup → Firestore write.
class FeedSyncService {
  FeedSyncService(this._rss, this._repo);
  final RssService _rss;
  final ArticleRepository _repo;

  /// Fetches articles from enabled sources, deduplicates, and writes to Firestore.
  Future<FeedSyncResult> syncFeeds(List<String> enabledSources) async {
    final articles = await _rss.fetchAllSources(enabledSources);
    var added = 0;
    var skipped = 0;

    for (final article in articles) {
      final id = articleIdFromUrl(article.url);
      final exists = await _repo.articleExists(id);
      if (exists) {
        skipped++;
        continue;
      }
      await _repo.upsertArticle(id, article);
      added++;
    }

    return FeedSyncResult(added: added, skipped: skipped);
  }
}

/// Provides the FeedSyncService.
final feedSyncServiceProvider = Provider<FeedSyncService>((ref) {
  return FeedSyncService(
    ref.watch(rssServiceProvider),
    ref.watch(articleRepositoryProvider),
  );
});
