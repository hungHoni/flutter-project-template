import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../models/daily_brief.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../providers/radar_providers.dart';

class RadarScreen extends ConsumerStatefulWidget {
  const RadarScreen({super.key});

  @override
  ConsumerState<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends ConsumerState<RadarScreen> {
  bool _hasTriggeredRefresh = false;

  @override
  void initState() {
    super.initState();
    // Trigger initial analysis on first load.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeRefresh();
    });
  }

  void _maybeRefresh() {
    if (_hasTriggeredRefresh) return;
    final brief = ref.read(todaysBriefProvider).valueOrNull;
    if (brief == null) {
      _hasTriggeredRefresh = true;
      ref.read(radarRefreshProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final briefAsync = ref.watch(todaysBriefProvider);
    final refreshState = ref.watch(radarRefreshProvider);
    final now = DateTime.now();
    final dateStr = '${_monthName(now.month)} ${now.day}, ${now.year}';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.read(radarRefreshProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            children: [
              const SizedBox(height: AppSpacing.md),
              Text('Your Radar', style: AppTypography.display),
              const SizedBox(height: AppSpacing.xs),
              Text(dateStr.toUpperCase(), style: AppTypography.meta),
              const SizedBox(height: AppSpacing.xl),

              // Determine if we have a real brief (not just null from stream).
              ..._buildContent(briefAsync, refreshState, ref),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(
    AsyncValue<DailyBrief?> briefAsync,
    AsyncValue<void> refreshState,
    WidgetRef ref,
  ) {
    final brief = briefAsync.valueOrNull;
    final hasBrief = brief != null;

    // Loading — no brief yet.
    if (refreshState.isLoading && !hasBrief) {
      return [const _LoadingState()];
    }

    // Error — no brief to fall back on. Show actual error.
    if (refreshState.hasError && !hasBrief) {
      return [
        _ErrorState(
          message: _errorMessage(refreshState.error),
          onRetry: () => ref.read(radarRefreshProvider.notifier).refresh(),
        ),
      ];
    }

    // Brief stream still loading (first open).
    if (briefAsync.isLoading && !hasBrief) {
      return [const _LoadingState()];
    }

    // Brief stream errored.
    if (briefAsync.hasError && !hasBrief) {
      return [
        _ErrorState(
          message: 'Could not load your radar.',
          onRetry: () => ref.read(radarRefreshProvider.notifier).refresh(),
        ),
      ];
    }

    // No brief exists yet — show empty state.
    if (!hasBrief) {
      if (refreshState.isLoading) {
        return [const _LoadingState()];
      }
      return [
        _EmptyState(
          onGenerate: () => ref.read(radarRefreshProvider.notifier).refresh(),
        ),
      ];
    }

    // We have a brief — show it.
    return [
      _BriefContent(brief: brief),
      // Show spinner if refreshing with existing data.
      if (refreshState.isLoading) ...[
        const SizedBox(height: AppSpacing.md),
        const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ],
      // Show error banner if refresh failed but we have cached data.
      if (refreshState.hasError) ...[
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Couldn\'t refresh: ${_errorMessage(refreshState.error)}',
            style: AppTypography.caption.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ];
  }

  String _errorMessage(Object? error) {
    final msg = error?.toString() ?? 'Unknown error';
    if (msg.contains('ANTHROPIC_API_KEY')) {
      return 'API key not configured.\nRun with:\nflutter run --dart-define=ANTHROPIC_API_KEY=sk-ant-...';
    }
    if (msg.contains('No articles')) {
      return 'No articles yet. Go to the Feed tab and pull down to fetch.';
    }
    if (msg.contains('Profile not loaded')) {
      return 'Profile not ready yet. Please wait a moment and retry.';
    }
    if (msg.contains('Not authenticated')) {
      return 'Not signed in yet. Please wait a moment and retry.';
    }
    // Show actual error for debugging.
    return 'Error: ${msg.length > 200 ? msg.substring(0, 200) : msg}';
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }
}

/// Shows the full brief + gaps content.
class _BriefContent extends StatelessWidget {
  const _BriefContent({required this.brief});
  final DailyBrief brief;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BriefCard(brief: brief.summary),
        const SizedBox(height: AppSpacing.xl),
        if (brief.gaps.isNotEmpty) ...[
          Text(
            '${brief.gaps.length} NEW GAPS THIS WEEK',
            style: AppTypography.label.copyWith(
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...brief.gaps.map((gap) => _GapCard(gap: gap)),
        ] else
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'No new gaps this week. You\'re up to date!',
              style: AppTypography.body.copyWith(color: AppColors.textMeta),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

class _BriefCard extends StatelessWidget {
  const _BriefCard({required this.brief});
  final String brief;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY\'S BRIEF',
            style: AppTypography.meta.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(brief, style: AppTypography.body),
        ],
      ),
    );
  }
}

class _GapCard extends StatelessWidget {
  const _GapCard({required this.gap});
  final SkillGap gap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
              _TrendBadge(trend: gap.trend ?? 'new'),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(gap.name, style: AppTypography.title),
              ),
              Text(
                '${gap.mentionCount} MENTIONS',
                style: AppTypography.meta,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              PhosphorIcon(
                AppIcons.arrowRight,
                size: AppIcons.sm,
                color: AppColors.primaryDark,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  gap.suggestedAction,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.trend});
  final String trend;

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch (trend) {
      'hot' => (AppIcons.trendHot, 'HOT', AppColors.trending),
      'rising' => (AppIcons.trendUp, 'RISING', AppColors.trending),
      'new' => (AppIcons.trendNew, 'NEW', AppColors.primary),
      _ => (AppIcons.trendNew, 'NEW', AppColors.primary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.meta.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Scanning the AI landscape for you...',
                style: AppTypography.body.copyWith(color: AppColors.textMeta),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onGenerate});
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Your first radar is brewing...',
            style: AppTypography.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Make sure you have articles in the Feed tab, then tap below.',
            style: AppTypography.body.copyWith(color: AppColors.textMeta),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: onGenerate,
            child: Text(
              'Generate Radar',
              style: AppTypography.button.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            message,
            style: AppTypography.body.copyWith(color: AppColors.textMeta),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: AppTypography.button.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
