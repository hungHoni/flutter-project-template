import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_skill_radar/app/app.dart';
import 'package:ai_skill_radar/features/radar/providers/radar_providers.dart';

/// Override that prevents auto-triggering Claude API in tests.
class _NoOpRadarRefreshNotifier extends RadarRefreshNotifier {
  @override
  Future<void> refresh() async {}
}

void main() {
  testWidgets('App launches and shows onboarding on first run',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const ProviderScope(child: App()),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Your AI'), findsOneWidget);
  });

  testWidgets('App shows radar after onboarding complete',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          radarRefreshProvider.overrideWith(() => _NoOpRadarRefreshNotifier()),
        ],
        child: const App(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.textContaining('Your Radar'), findsOneWidget);
  });
}
