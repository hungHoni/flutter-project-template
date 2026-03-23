import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

/// Mock data — will be replaced by Firestore providers.
const _mockBrief =
    'Claude 4.6 dropped with native tool use — relevant to your backend work. '
    'Structured outputs are now the default pattern for API integrations. '
    'Meanwhile, Cursor adopted agentic workflows that mirror what you\'re building.';

const _mockGaps = [
  _GapItem('Structured Outputs', 'hot', 12, 'Try the Anthropic cookbook tutorial'),
  _GapItem('Agentic Tool Use', 'rising', 28, 'Build a simple agent with Claude SDK'),
  _GapItem('MCP Servers', 'new', 9, 'Set up your first MCP integration'),
  _GapItem('Multimodal RAG', 'rising', 7, 'Explore LlamaIndex multimodal docs'),
  _GapItem('Voice Agents', 'new', 5, 'Try OpenAI Realtime API playground'),
];

class _GapItem {
  const _GapItem(this.name, this.trend, this.mentionCount, this.action);
  final String name;
  final String trend;
  final int mentionCount;
  final String action;
}

class RadarScreen extends StatelessWidget {
  const RadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = '${_monthName(now.month)} ${now.day}, ${now.year}';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
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

            // ── Brief card ──
            const _BriefCard(brief: _mockBrief),
            const SizedBox(height: AppSpacing.xl),

            // ── Gap section header ──
            Text(
              '${_mockGaps.length} NEW GAPS THIS WEEK',
              style: AppTypography.label.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Gap list ──
            ..._mockGaps.map((gap) => _GapCard(gap: gap)),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
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
  final _GapItem gap;

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
              _TrendBadge(trend: gap.trend),
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
                  gap.action,
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
