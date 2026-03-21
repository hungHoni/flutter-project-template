import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_skill_radar/app/app.dart';

void main() {
  testWidgets('App launches and shows onboarding on first run',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const ProviderScope(child: App()),
    );
    await tester.pumpAndSettle();

    // First launch should show onboarding welcome
    expect(find.textContaining('Your AI'), findsOneWidget);
  });

  testWidgets('App shows radar after onboarding complete',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});

    await tester.pumpWidget(
      const ProviderScope(child: App()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Radar'), findsWidgets);
  });
}
