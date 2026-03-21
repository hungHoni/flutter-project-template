import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/feed/screens/feed_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/radar/screens/radar_screen.dart';
import '../shared/widgets/app_bottom_nav.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Creates the app router. If [onboardingCompleted] is false,
/// redirects all tab routes to /onboarding.
GoRouter createRouter(bool onboardingCompleted) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: onboardingCompleted ? '/radar' : '/onboarding',
    redirect: (context, state) {
      final isOnboarding = state.uri.path == '/onboarding';

      if (!onboardingCompleted && !isOnboarding) return '/onboarding';
      if (onboardingCompleted && isOnboarding) return '/radar';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _ScaffoldWithNav(child: child);
        },
        routes: [
          GoRoute(
            path: '/radar',
            builder: (context, state) => const RadarScreen(),
          ),
          GoRoute(
            path: '/feed',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}

class _ScaffoldWithNav extends StatelessWidget {
  const _ScaffoldWithNav({required this.child});

  final Widget child;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/feed')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/radar');
            case 1:
              context.go('/feed');
            case 2:
              context.go('/profile');
          }
        },
      ),
    );
  }
}
