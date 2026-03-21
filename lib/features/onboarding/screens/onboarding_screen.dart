import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../models/onboarding_state.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/experience_step.dart';
import '../widgets/role_step.dart';
import '../widgets/skills_step.dart';
import '../widgets/sources_step.dart';
import '../widgets/welcome_step.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    final state = ref.read(onboardingProvider);
    ref.read(onboardingProvider.notifier).nextStep();
    _goToStep(state.currentStep + 1);
  }

  void _back() {
    final state = ref.read(onboardingProvider);
    ref.read(onboardingProvider.notifier).previousStep();
    _goToStep(state.currentStep - 1);
  }

  Future<void> _complete() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/radar');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Step indicator (hidden on welcome)
            if (state.currentStep > 0)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: List.generate(
                    OnboardingState.totalSteps,
                    (index) => Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: index <= state.currentStep
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  WelcomeStep(onGetStarted: _next),
                  RoleStep(
                    selectedRole: state.role,
                    onRoleSelected:
                        ref.read(onboardingProvider.notifier).setRole,
                  ),
                  SkillsStep(
                    selectedSkills: state.skills,
                    onSkillToggled:
                        ref.read(onboardingProvider.notifier).toggleSkill,
                  ),
                  ExperienceStep(
                    selectedLevel: state.experienceLevel,
                    onLevelSelected: ref
                        .read(onboardingProvider.notifier)
                        .setExperienceLevel,
                  ),
                  SourcesStep(
                    selectedSources: state.feedSources,
                    onSourceToggled:
                        ref.read(onboardingProvider.notifier).toggleSource,
                  ),
                ],
              ),
            ),

            // Bottom action bar (hidden on welcome)
            if (state.currentStep > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.border),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: _back,
                        child: Text(
                          'Back',
                          style: AppTypography.button.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (state.currentStep < OnboardingState.totalSteps - 1)
                        ElevatedButton(
                          onPressed: state.canProceed ? _next : null,
                          child: Text(
                            'Continue',
                            style:
                                AppTypography.button.copyWith(color: Colors.white),
                          ),
                        )
                      else
                        ElevatedButton(
                          onPressed: state.canProceed ? _complete : null,
                          child: Text(
                            'Complete Setup',
                            style:
                                AppTypography.button.copyWith(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
