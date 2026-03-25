import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/article.dart';
import '../../../models/user_profile.dart';

/// Result from Claude API analysis.
class ClaudeAnalysisResult {
  const ClaudeAnalysisResult({
    required this.brief,
    required this.gaps,
    required this.taggedArticleIds,
  });

  final String brief;
  final List<ClaudeGap> gaps;
  final List<String> taggedArticleIds;
}

/// A skill gap as returned by Claude (no trend — computed client-side).
class ClaudeGap {
  const ClaudeGap({
    required this.skill,
    required this.mentions,
    required this.action,
  });

  final String skill;
  final int mentions;
  final String action;
}

const _systemPrompt = '''
You are an AI skill analyst. Given a user's role, current skills,
and a batch of recent AI/tech articles, produce a JSON response with:
1. A 3-sentence personalized brief of what's most relevant today
2. A ranked list of skill gaps (skills trending in articles that the
   user doesn't have)
3. For each gap: a one-line actionable learning suggestion

Respond ONLY with valid JSON in this exact format:
{
  "brief": "Three sentences about what matters today...",
  "gaps": [
    {
      "skill": "Structured Outputs",
      "mentions": 12,
      "action": "Try the Anthropic cookbook tutorial"
    }
  ],
  "tagged_articles": ["article_id_1", "article_id_2"]
}

Rules:
- "gaps" should contain 3-7 skill gaps, ranked by relevance to the user
- "tagged_articles" should list IDs of articles that relate to detected gaps
- Keep the brief conversational and personalized to the user's role
- Focus on skills the user does NOT already have
''';

/// Calls Claude API via dio to analyze articles and generate a personalized brief.
class ClaudeService {
  ClaudeService(this._apiKey);
  final String _apiKey;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.anthropic.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
  ));

  /// Whether the API key is configured.
  bool get hasApiKey => _apiKey.isNotEmpty;

  /// Analyzes recent articles against the user's profile.
  Future<ClaudeAnalysisResult> generateBrief({
    required UserProfile profile,
    required List<Article> articles,
    required Map<String, String> articleIdMap,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('ANTHROPIC_API_KEY not configured.');
    }

    if (articles.isEmpty) {
      return const ClaudeAnalysisResult(
        brief:
            'No articles to analyze yet. Pull down on the Feed tab to fetch the latest.',
        gaps: [],
        taggedArticleIds: [],
      );
    }

    final articlesText = articles.map((a) {
      final id = articleIdMap[a.url] ?? 'unknown';
      return '$id: ${a.title} — ${a.excerpt}';
    }).join('\n');

    final userPrompt = '''
User profile:
- Role: ${profile.role}
- Current skills: ${profile.skills.join(', ')}
- Experience: ${profile.level}

Recent articles (last 24h):
$articlesText
''';

    debugPrint('[ClaudeService] Sending request to Claude API...');

    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/messages',
      options: Options(
        headers: {
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
      ),
      data: {
        'model': 'claude-haiku-4-5-20251001',
        'max_tokens': 1024,
        'system': _systemPrompt,
        'messages': [
          {'role': 'user', 'content': userPrompt},
        ],
      },
    );

    final body = response.data!;
    final content = body['content'] as List<dynamic>;
    final text = (content.first as Map<String, dynamic>)['text'] as String;

    debugPrint('[ClaudeService] Got response: ${text.substring(0, text.length.clamp(0, 100))}...');

    return _parseResponse(text);
  }

  static final _fencePattern = RegExp(r'^```\w*\n([\s\S]*?)```$');

  ClaudeAnalysisResult _parseResponse(String text) {
    // Strip markdown code fences if present.
    var cleaned = text.trim();
    final fenceMatch = _fencePattern.firstMatch(cleaned);
    if (fenceMatch != null) {
      cleaned = fenceMatch.group(1)!;
    }

    final json = jsonDecode(cleaned.trim()) as Map<String, dynamic>;

    final brief = json['brief'] as String? ?? '';
    final gapsJson = json['gaps'] as List<dynamic>? ?? [];
    final taggedJson = json['tagged_articles'] as List<dynamic>? ?? [];

    final gaps = gapsJson.map((g) {
      final m = g as Map<String, dynamic>;
      return ClaudeGap(
        skill: m['skill'] as String? ?? '',
        mentions: (m['mentions'] as num?)?.toInt() ?? 0,
        action: m['action'] as String? ?? '',
      );
    }).toList();

    final taggedIds = taggedJson.map((id) => id.toString()).toList();

    return ClaudeAnalysisResult(
      brief: brief,
      gaps: gaps,
      taggedArticleIds: taggedIds,
    );
  }

  void dispose() {
    _dio.close();
  }
}

/// API key injected at build time via `--dart-define=ANTHROPIC_API_KEY=xxx`.
const _anthropicApiKey = String.fromEnvironment('ANTHROPIC_API_KEY');

/// Provides the ClaudeService.
final claudeServiceProvider = Provider<ClaudeService>((ref) {
  final service = ClaudeService(_anthropicApiKey);
  ref.onDispose(() => service.dispose());
  return service;
});
