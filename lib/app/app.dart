import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/onboarding/providers/onboarding_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingCompleted = ref.watch(onboardingCompletedProvider);

    return onboardingCompleted.when(
      data: (completed) {
        final routerConfig = createRouter(completed);
        return MaterialApp.router(
          title: 'AI Skill Radar',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: routerConfig,
        );
      },
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const Scaffold(
          backgroundColor: AppColors.surface,
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) {
        final routerConfig = createRouter(false);
        return MaterialApp.router(
          title: 'AI Skill Radar',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: routerConfig,
        );
      },
    );
  }
}
