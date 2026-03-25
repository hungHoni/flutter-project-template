import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/firestore_provider.dart';
import '../../../models/article.dart';

/// Generates a stable document ID from an article URL.
String articleIdFromUrl(String url) {
  return sha256.convert(utf8.encode(url)).toString().substring(0, 20);
}

/// Firestore CRUD layer for the `articles/{id}` collection.
class ArticleRepository {
  ArticleRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('articles');

  /// Watches articles ordered by fetchedAt descending.
  /// Optionally filters by [source] ('reddit', 'hn', 'blog').
  Stream<List<Article>> watchArticles({String? source, int limit = 20}) {
    Query<Map<String, dynamic>> query =
        _collection.orderBy('fetchedAt', descending: true).limit(limit);

    if (source != null) {
      query = query.where('source', isEqualTo: source);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Article.fromJson(doc.data())).toList();
    });
  }

  /// Fetches the next page of articles after [lastFetchedAt].
  Future<List<Article>> fetchArticlesPage({
    String? source,
    required DateTime lastFetchedAt,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> query = _collection
        .orderBy('fetchedAt', descending: true)
        .startAfter([Timestamp.fromDate(lastFetchedAt)])
        .limit(limit);

    if (source != null) {
      query = query.where('source', isEqualTo: source);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => Article.fromJson(doc.data())).toList();
  }

  /// Writes an article to Firestore. Overwrites if ID already exists.
  Future<void> upsertArticle(String id, Article article) {
    return _collection.doc(id).set(article.toJson());
  }

  /// Checks whether an article with the given ID already exists.
  Future<bool> articleExists(String id) async {
    final doc = await _collection.doc(id).get();
    return doc.exists;
  }

  /// Batch-updates `isSkillGap: true` on the given article IDs.
  Future<void> tagArticlesAsSkillGap(List<String> articleIds) async {
    final batch = _firestore.batch();
    for (final id in articleIds) {
      batch.update(_collection.doc(id), {'isSkillGap': true});
    }
    await batch.commit();
  }
}

/// Provides the ArticleRepository.
final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  return ArticleRepository(ref.watch(firestoreProvider));
});
