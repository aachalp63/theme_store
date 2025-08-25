import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:theme_custom/main.dart';

void main() {
  testWidgets('Theme Store loads with title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Theme Store'), findsOneWidget);
  });

  testWidgets('Can switch to dark theme', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Ensure we start with light theme
    expect(Theme.of(tester.element(find.text('Theme Store'))).brightness,
        Brightness.light);

    // Tap the switch button (update selector to your actual button/icon)
    await tester.tap(find.byIcon(Icons.brightness_6));
    await tester.pumpAndSettle(); // wait for rebuild

    // Now we expect dark theme
    expect(Theme.of(tester.element(find.text('Theme Store'))).brightness,
        Brightness.dark);
  });
}
