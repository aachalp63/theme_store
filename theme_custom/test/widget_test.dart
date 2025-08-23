import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_custom/main.dart';

void main() {
  testWidgets('Theme Store loads with title', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MyApp());

    // Check if the app bar or main title contains "Theme Store"
    expect(find.text('Theme Store'), findsOneWidget);

    // Example: Check if at least one theme card is rendered
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('Can switch to dark theme', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Initially app is in light mode (background should be white)
    final Scaffold scaffold = tester.widget(find.byType(Scaffold));
    expect(scaffold.backgroundColor, equals(Colors.white));

    // Tap the toggle theme button
    await tester.tap(find.byIcon(Icons.brightness_6));
    await tester.pumpAndSettle();

    // Now scaffold background should be dark
    final Scaffold scaffoldAfter = tester.widget(find.byType(Scaffold));
    expect(scaffoldAfter.backgroundColor, equals(Colors.black));
  });
}
