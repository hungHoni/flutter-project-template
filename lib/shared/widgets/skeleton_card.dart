import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Shimmer loading placeholder matching real card shapes.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard._({required this.lines, required this.showBadge});

  /// Matches article card shape: title + 2 body lines + meta row.
  factory SkeletonCard.article() =>
      const SkeletonCard._(lines: 4, showBadge: false);

  /// Matches gap card shape: badge + title + action line.
  factory SkeletonCard.gap() =>
      const SkeletonCard._(lines: 2, showBadge: true);

  /// Matches brief card shape: label + 3 body lines.
  factory SkeletonCard.brief() =>
      const SkeletonCard._(lines: 3, showBadge: false);

  final int lines;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surface,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showBadge) ...[
              Row(
                children: [
                  _bar(48, 20),
                  const SizedBox(width: AppSpacing.sm),
                  _bar(120, 16),
                  const Spacer(),
                  _bar(60, 12),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            _bar(double.infinity, 14),
            for (var i = 1; i < lines; i++) ...[
              const SizedBox(height: AppSpacing.sm),
              _bar(i == lines - 1 ? 160 : double.infinity, 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _bar(double width, double height) {
    return Container(
      width: width == double.infinity ? null : width,
      constraints: width == double.infinity
          ? const BoxConstraints(minWidth: double.infinity)
          : null,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
