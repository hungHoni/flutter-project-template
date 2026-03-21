import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_skill_radar/app/app.dart';

void main() {
  testWidgets('App launches and shows Radar screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: App()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Radar'), findsWidgets);
  });
}
