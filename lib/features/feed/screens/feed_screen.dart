import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/article.dart';
import '../../../shared/utils/time_ago.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../providers/article_providers.dart';

/// Source filter per tab: null = All, then reddit, hn, blog.
const _tabFilters = <String?>[null, 'reddit', 'hn', 'blog'];
const _tabLabels = ['All', 'Reddit', 'HN', 'Blogs'];

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger initial feed sync (fire-and-forget).
    ref.watch(feedSyncProvider);

    return DefaultTabController(
      length: _tabLabels.length,
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
                tabs: _tabLabels
                    .map((t) => Tab(text: t.toUpperCase()))
                    .toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: _tabFilters
                      .map((filter) => _ArticleStreamList(sourceFilter: filter))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleStreamList extends ConsumerWidget {
  const _ArticleStreamList({required this.sourceFilter});
  final String? sourceFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(articlesStreamProvider(sourceFilter));

    return articlesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            'Could not load articles.\nPull down to retry.',
            style: AppTypography.body.copyWith(color: AppColors.textMeta),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      data: (articles) {
        if (articles.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                'No articles yet.\nPull down to sync feeds.',
                style:
                    AppTypography.body.copyWith(color: AppColors.textMeta),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            final notifier = ref.read(feedSyncNotifierProvider.notifier);
            await notifier.refresh(const [
              'r/MachineLearning',
              'r/LocalLLaMA',
              'Hacker News',
              'AI Blogs',
            ]);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: articles.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) =>
                _ArticleCard(article: articles[index]),
          ),
        );
      },
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final Article article;

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
                Text(timeAgo(article.publishedAt), style: AppTypography.meta),
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
