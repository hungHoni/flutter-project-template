import 'package:flutter/material.dart';

import '../../../shared/widgets/selectable_chip.dart';
import '../../../shared/widgets/step_header.dart';
import '../../../theme/app_spacing.dart';
import '../models/onboarding_state.dart';

class RoleStep extends StatelessWidget {
  const RoleStep({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  final String? selectedRole;
  final ValueChanged<String> onRoleSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
            stepLabel: 'STEP 2 OF 5',
            title: 'What\'s your\ncurrent role?',
            subtitle: 'This helps us find what\'s relevant to you.',
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: availableRoles.map((role) {
                  return SelectableChip(
                    label: role,
                    isSelected: selectedRole == role,
                    onTap: () => onRoleSelected(role),
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
