import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:theme_custom/main.dart';


void main() {
  testWidgets('Theme Store loads with title', (WidgetTester tester) async {
    // Wrap MyApp with Provider
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    // Verify that the app title is present
    expect(find.text('Theme Store'), findsOneWidget);
  });

  testWidgets('Can switch to dark theme', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    // Tap the theme toggle button
    await tester.tap(find.byIcon(Icons.brightness_6));
    await tester.pumpAndSettle();

    // Verify UI changed after toggle (example: dark mode text)
    expect(find.text('Dark Mode'), findsOneWidget);
  });
}
