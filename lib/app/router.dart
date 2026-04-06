import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/feed/screens/feed_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/radar/screens/radar_screen.dart';
import '../shared/widgets/app_bottom_nav.dart';
import '../shared/widgets/offline_banner.dart';

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
            name: 'radar',
            pageBuilder: (context, state) => _fadePage(
              key: state.pageKey,
              child: const RadarScreen(),
            ),
          ),
          GoRoute(
            path: '/feed',
            name: 'feed',
            pageBuilder: (context, state) => _fadePage(
              key: state.pageKey,
              child: const FeedScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => _fadePage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}

CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

class _ScaffoldWithNav extends StatelessWidget {
  const _ScaffoldWithNav({required this.child});

  final Widget child;

  static const _tabRoutes = ['radar', 'feed', 'profile'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/feed')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex(context),
        onTap: (index) => context.goNamed(_tabRoutes[index]),
      ),
    );
  }
}
