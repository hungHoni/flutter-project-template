import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

/// Mock articles — will be replaced by Firestore providers.
const _mockArticles = [
  _ArticleItem(
    source: 'reddit',
    sourceName: 'r/MachineLearning',
    title: 'Claude 4.6 Opus: First impressions and benchmarks',
    excerpt:
        'Tested Claude 4.6 on our internal eval suite. Tool use is significantly improved, '
        'especially for structured outputs. Latency is down 40% compared to 4.5.',
    url: 'https://reddit.com',
    tags: ['structured-outputs', 'benchmarks'],
    isSkillGap: true,
    timeAgo: '2h ago',
  ),
  _ArticleItem(
    source: 'hn',
    sourceName: 'Hacker News',
    title: 'Building production agents with MCP and Claude',
    excerpt:
        'A practical guide to building reliable AI agents using the Model Context Protocol. '
        'Covers tool registration, error handling, and deployment patterns.',
    url: 'https://news.ycombinator.com',
    tags: ['mcp', 'agents', 'production'],
    isSkillGap: true,
    timeAgo: '4h ago',
  ),
  _ArticleItem(
    source: 'reddit',
    sourceName: 'r/LocalLLaMA',
    title: 'Llama 4 Scout vs Maverick: comprehensive comparison',
    excerpt:
        'Ran both models through our standard benchmark suite. Scout is better for '
        'code generation while Maverick excels at reasoning tasks.',
    url: 'https://reddit.com',
    tags: ['llama', 'benchmarks'],
    isSkillGap: false,
    timeAgo: '5h ago',
  ),
  _ArticleItem(
    source: 'blog',
    sourceName: 'AI Blogs',
    title: 'The state of multimodal RAG in 2026',
    excerpt:
        'Multimodal RAG has evolved beyond simple image-text retrieval. This post covers '
        'the latest architectures combining vision, audio, and text embeddings.',
    url: 'https://example.com',
    tags: ['rag', 'multimodal'],
    isSkillGap: true,
    timeAgo: '8h ago',
  ),
  _ArticleItem(
    source: 'hn',
    sourceName: 'Hacker News',
    title: 'Why we moved from LangChain to vanilla SDK calls',
    excerpt:
        'After 6 months with LangChain, we stripped it out. The abstraction wasn\'t worth '
        'the debugging cost. Here\'s our simpler architecture.',
    url: 'https://news.ycombinator.com',
    tags: ['langchain', 'architecture'],
    isSkillGap: false,
    timeAgo: '12h ago',
  ),
];

class _ArticleItem {
  const _ArticleItem({
    required this.source,
    required this.sourceName,
    required this.title,
    required this.excerpt,
    required this.url,
    required this.tags,
    required this.isSkillGap,
    required this.timeAgo,
  });
  final String source;
  final String sourceName;
  final String title;
  final String excerpt;
  final String url;
  final List<String> tags;
  final bool isSkillGap;
  final String timeAgo;
}

const _tabs = ['All', 'Reddit', 'HN', 'Blogs'];

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
                ),
                child: Text('Feed', style: AppTypography.display),
              ),
              const SizedBox(height: AppSpacing.md),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelStyle: AppTypography.label.copyWith(
                  color: AppColors.primaryDark,
                ),
                unselectedLabelStyle: AppTypography.label,
                labelColor: AppColors.primaryDark,
                unselectedLabelColor: AppColors.textMeta,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.label,
                dividerHeight: 1,
                dividerColor: AppColors.border,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                tabs: _tabs.map((t) => Tab(text: t.toUpperCase())).toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    const _ArticleList(articles: _mockArticles),
                    _ArticleList(
                      articles: _mockArticles
                          .where((a) => a.source == 'reddit')
                          .toList(),
                    ),
                    _ArticleList(
                      articles: _mockArticles
                          .where((a) => a.source == 'hn')
                          .toList(),
                    ),
                    _ArticleList(
                      articles: _mockArticles
                          .where((a) => a.source == 'blog')
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleList extends StatelessWidget {
  const _ArticleList({required this.articles});
  final List<_ArticleItem> articles;

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            'No articles yet.\nCheck back in a few hours.',
            style: AppTypography.body.copyWith(color: AppColors.textMeta),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) => _ArticleCard(article: articles[index]),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final _ArticleItem article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(article.url)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  article.sourceName.toUpperCase(),
                  style: AppTypography.meta.copyWith(
                    color: AppColors.trending,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(article.timeAgo, style: AppTypography.meta),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(article.title, style: AppTypography.headline),
            const SizedBox(height: AppSpacing.sm),
            Text(
              article.excerpt,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                if (article.isSkillGap)
                  const _Tag(label: 'SKILL GAP', isGap: true),
                ...article.tags.map((t) => _Tag(label: t)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, this.isGap = false});
  final String label;
  final bool isGap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isGap ? AppColors.primaryLight : AppColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isGap ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.meta.copyWith(
          color: isGap ? AppColors.primaryDark : AppColors.textMeta,
          fontWeight: isGap ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
