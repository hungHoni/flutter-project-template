import 'package:flutter/material.dart';

import '../../../shared/widgets/step_header.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../models/onboarding_state.dart';

class SourcesStep extends StatelessWidget {
  const SourcesStep({
    super.key,
    required this.selectedSources,
    required this.onSourceToggled,
  });

  final List<String> selectedSources;
  final ValueChanged<String> onSourceToggled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            stepLabel: 'STEP 5 OF 5',
            title: 'Where should\nwe look?',
            subtitle: 'Toggle the sources you want in your feed.',
          ),
          Expanded(
            child: ListView.separated(
              itemCount: availableSources.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: AppColors.border,
              ),
              itemBuilder: (context, index) {
                final source = availableSources[index];
                final isEnabled = selectedSources.contains(source.name);
                return SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              source.name,
                              style: AppTypography.title,
                            ),
                            Text(
                              source.category,
                              style: AppTypography.meta,
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: isEnabled,
                        onChanged: (_) => onSourceToggled(source.name),
                        activeTrackColor: AppColors.primary,
                        activeThumbColor: Colors.white,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
