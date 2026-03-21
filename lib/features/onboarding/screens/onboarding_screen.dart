import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _stepTitles = [
    'Welcome',
    'Your Role',
    'Your Skills',
    'Experience Level',
    'Feed Sources',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Step indicator
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: List.generate(
                  5,
                  (index) => Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? AppColors.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _StepPlaceholder(
                    title: _stepTitles[index],
                    step: index + 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepPlaceholder extends StatelessWidget {
  const _StepPlaceholder({
    required this.title,
    required this.step,
  });

  final String title;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTypography.display,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'STEP $step OF 5',
            style: AppTypography.meta,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'COMING SOON',
            style: AppTypography.meta.copyWith(
              color: AppColors.textMeta,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
