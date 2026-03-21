import 'package:flutter/material.dart';

import '../../../shared/widgets/selectable_chip.dart';
import '../../../shared/widgets/step_header.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../models/onboarding_state.dart';

class SkillsStep extends StatelessWidget {
  const SkillsStep({
    super.key,
    required this.selectedSkills,
    required this.onSkillToggled,
  });

  final List<String> selectedSkills;
  final ValueChanged<String> onSkillToggled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            stepLabel: 'STEP 3 OF 5',
            title: 'What do you\nalready know?',
            subtitle: 'Select your current AI skills. Skip if you\'re just starting.',
          ),
          if (selectedSkills.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                '${selectedSkills.length} selected',
                style: AppTypography.meta.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: availableSkills.map((skill) {
                  return SelectableChip(
                    label: skill,
                    isSelected: selectedSkills.contains(skill),
                    onTap: () => onSkillToggled(skill),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
