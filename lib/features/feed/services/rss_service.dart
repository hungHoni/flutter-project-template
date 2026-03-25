import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

import '../../../models/article.dart';

/// Client-side RSS/Atom feed fetcher.
///
/// Temporary replacement for Cloud Functions — will be removed
/// once Firebase Blaze plan enables server-side scheduled functions.
class RssService {
  RssService(this._dio);
  final Dio _dio;

  /// Per-source rate limit tracking (subreddit → last fetch time).
  /// Loaded from SharedPreferences on first access.
  Map<String, DateTime>? _lastFetch;

  Future<Map<String, DateTime>> _getLastFetch() async {
    if (_lastFetch != null) return _lastFetch!;
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('rss_last_fetch') ?? [];
    _lastFetch = {};
    for (final entry in stored) {
      final parts = entry.split('=');
      if (parts.length == 2) {
        final dt = DateTime.tryParse(parts[1]);
        if (dt != null) _lastFetch![parts[0]] = dt;
      }
    }
    return _lastFetch!;
  }

  Future<void> _persistLastFetch() async {
    if (_lastFetch == null) return;
    final prefs = await SharedPreferences.getInstance();
    final entries = _lastFetch!.entries
        .map((e) => '${e.key}=${e.value.toIso8601String()}')
        .toList();
    await prefs.setStringList('rss_last_fetch', entries);
  }

  /// Fetches articles from all enabled sources, skipping failures.
  Future<List<Article>> fetchAllSources(List<String> enabledSources) async {
    final articles = <Article>[];

    for (final source in enabledSources) {
      try {
        final fetched = await _fetchSource(source);
        articles.addAll(fetched);
      } catch (e) {
        debugPrint('[RssService] Failed to fetch $source: $e');
      }
    }

    return articles;
  }

  Future<List<Article>> _fetchSource(String sourceName) {
    // Map source names to fetch methods.
    if (sourceName.startsWith('r/')) {
      return _fetchReddit(sourceName.substring(2));
    }
    if (sourceName == 'Hacker News') {
      return _fetchHackerNews();
    }
    if (sourceName == 'AI Blogs') {
      return _fetchBlogs();
    }
    return Future.value([]);
  }

  // ── Reddit (.rss Atom feed) ──

  Future<List<Article>> _fetchReddit(String subreddit) async {
    // Rate limit: max once per 60 minutes per subreddit.
    final key = 'reddit_$subreddit';
    final rateLimits = await _getLastFetch();
    final last = rateLimits[key];
    if (last != null && DateTime.now().difference(last).inMinutes < 60) {
      return [];
    }

    final response = await _dio.get<String>(
      'https://www.reddit.com/r/$subreddit/hot.rss',
      options: Options(
        headers: {
          // User-Agent cannot be set in browser XHR requests; only set on native.
          if (!kIsWeb)
            'User-Agent': 'AISkillRadar/1.0 (Flutter; personal use)',
        },
        responseType: ResponseType.plain,
      ),
    );

    rateLimits[key] = DateTime.now();
    _persistLastFetch();
    final doc = XmlDocument.parse(response.data!);
    final entries = doc.findAllElements('entry');
    final now = DateTime.now();

    return entries.take(15).map((entry) {
      final title = entry.getElement('title')?.innerText ?? '';
      final link = entry.getElement('link')?.getAttribute('href') ?? '';
      final updated = entry.getElement('updated')?.innerText;
      final content = entry.getElement('content')?.innerText ?? '';

      return Article(
        source: 'reddit',
        sourceName: 'r/$subreddit',
        title: title,
        excerpt: _stripHtml(content),
        url: link,
        publishedAt: _parseDate(updated) ?? now,
        fetchedAt: now,
      );
    }).toList();
  }

  // ── Hacker News (JSON API) ──

  Future<List<Article>> _fetchHackerNews() async {
    const key = 'hn';
    final rateLimits = await _getLastFetch();
    final last = rateLimits[key];
    if (last != null && DateTime.now().difference(last).inMinutes < 60) {
      return [];
    }

    final idsResponse = await _dio.get<List<dynamic>>(
      'https://hacker-news.firebaseio.com/v0/topstories.json',
    );

    rateLimits[key] = DateTime.now();
    _persistLastFetch();
    final ids = (idsResponse.data ?? []).take(20);
    final articles = <Article>[];
    final now = DateTime.now();

    for (final id in ids) {
      try {
        final itemResponse = await _dio.get<Map<String, dynamic>>(
          'https://hacker-news.firebaseio.com/v0/item/$id.json',
        );
        final item = itemResponse.data;
        if (item == null) continue;
        if (item['type'] != 'story' || item['url'] == null) continue;

        final hnTitle = item['title'] as String? ?? '';
        final hnScore = item['score'] as int? ?? 0;
        final hnDescendants = item['descendants'] as int? ?? 0;
        articles.add(Article(
          source: 'hn',
          sourceName: 'Hacker News',
          title: hnTitle,
          excerpt: '$hnScore points · $hnDescendants comments',
          url: item['url'] as String,
          publishedAt: DateTime.fromMillisecondsSinceEpoch(
            ((item['time'] as int?) ?? 0) * 1000,
          ),
          fetchedAt: now,
        ));
      } catch (e) {
        debugPrint('[RssService] Failed to fetch HN item $id: $e');
      }
    }

    return articles;
  }

  // ── AI Blogs (RSS 2.0) ──

  static const _blogFeeds = [
    'https://blog.google/technology/ai/rss/',
    'https://openai.com/blog/rss.xml',
  ];

  Future<List<Article>> _fetchBlogs() async {
    const key = 'blogs';
    final rateLimits = await _getLastFetch();
    final last = rateLimits[key];
    if (last != null && DateTime.now().difference(last).inMinutes < 60) {
      return [];
    }

    final articles = <Article>[];
    final now = DateTime.now();

    for (final feedUrl in _blogFeeds) {
      try {
        final response = await _dio.get<String>(
          feedUrl,
          options: Options(responseType: ResponseType.plain),
        );
        final doc = XmlDocument.parse(response.data!);
        final items = doc.findAllElements('item');

        for (final item in items.take(10)) {
          final title = item.getElement('title')?.innerText ?? '';
          final link = item.getElement('link')?.innerText ?? '';
          final description = item.getElement('description')?.innerText ?? '';
          final pubDate = item.getElement('pubDate')?.innerText;

          articles.add(Article(
            source: 'blog',
            sourceName: 'AI Blogs',
            title: title,
            excerpt: _stripHtml(description),
            url: link,
            publishedAt: _parseDate(pubDate) ?? now,
            fetchedAt: now,
          ));
        }
      } catch (e) {
        debugPrint('[RssService] Failed to fetch blog $feedUrl: $e');
      }
    }

    rateLimits[key] = DateTime.now();
    _persistLastFetch();
    return articles;
  }

  // ── Helpers ──

  /// Strips HTML tags, decodes entities, removes URLs, and truncates.
  String _stripHtml(String html) {
    // Remove HTML tags.
    var text = html.replaceAll(RegExp(r'<[^>]*>'), '');
    // Decode common HTML entities.
    text = text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'")
        .replaceAllMapped(RegExp(r'&#(\d+);'), (m) {
          final code = int.tryParse(m.group(1)!);
          return code != null ? String.fromCharCode(code) : m.group(0)!;
        });
    // Remove raw URLs that leak from Reddit content.
    text = text.replaceAll(RegExp(r'https?://\S+'), '').trim();
    // Collapse multiple whitespace.
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.length <= 200) return text;
    return '${text.substring(0, 197)}...';
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }
}

/// Provides the RssService with a configured Dio instance.
final rssServiceProvider = Provider<RssService>((ref) {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));
  return RssService(dio);
});
