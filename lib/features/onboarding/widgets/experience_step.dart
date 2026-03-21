import 'package:flutter/material.dart';

import '../../../shared/widgets/step_header.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

class ExperienceStep extends StatelessWidget {
  const ExperienceStep({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  final String? selectedLevel;
  final ValueChanged<String> onLevelSelected;

  static const _levels = [
    _Level('beginner', 'Beginner', 'Just getting started with AI'),
    _Level('intermediate', 'Intermediate', 'Building projects and experimenting'),
    _Level('advanced', 'Advanced', 'Production experience with AI systems'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            stepLabel: 'STEP 4 OF 5',
            title: 'How deep\nare you?',
            subtitle: 'This calibrates the complexity of recommendations.',
          ),
          Expanded(
            child: Column(
              children: _levels.map((level) {
                final isSelected = selectedLevel == level.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () => onLevelSelected(level.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 72),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryLight
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            level.title,
                            style: AppTypography.title.copyWith(
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            level.subtitle,
                            style: AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Level {
  const _Level(this.id, this.title, this.subtitle);
  final String id;
  final String title;
  final String subtitle;
}
