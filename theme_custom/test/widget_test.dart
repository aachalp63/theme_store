import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:theme_custom/main.dart';

void main() {
  testWidgets('Theme Store loads with title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Theme Store'), findsOneWidget);
  });

  testWidgets('Can switch to dark theme', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    // Tap on theme toggle button
    final toggleButton = find.byIcon(Icons.brightness_6); // adjust if you use different icon
    expect(toggleButton, findsOneWidget);

    await tester.tap(toggleButton);
    await tester.pumpAndSettle();

    // Check if theme switched (by checking a dark background or icon change)
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    final bgColor = scaffold.backgroundColor ?? Theme.of(tester.element(find.byType(Scaffold))).scaffoldBackgroundColor;

    expect(bgColor, equals(Colors.black));
  });
}
