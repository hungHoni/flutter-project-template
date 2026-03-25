import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.stepLabel,
  });

  final String title;
  final String? subtitle;
  final String? stepLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stepLabel != null) ...[
            Text(
              stepLabel!,
              style: AppTypography.meta,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(
            title,
            style: AppTypography.display,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
