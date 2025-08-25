import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:theme_custom/main.dart';

void main() {
  testWidgets('Theme Store loads with title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: ThemeStoreScreen(),
        ),
      ),
    );

    expect(find.text('Theme Store'), findsOneWidget);
  });

  testWidgets('Can switch to dark theme', (WidgetTester tester) async {
    final themeProvider = ThemeProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: themeProvider,
        child: const MaterialApp(
          home: ThemeStoreScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Initially should be light theme
    expect(themeProvider.getSelectedThemeIndex(), 0);

    // Tap on "Theme 2" (index 1 = dark theme)
    await tester.tap(find.text('Theme 2'));
    await tester.pumpAndSettle();

    // Verify it switched to dark theme
    expect(themeProvider.getSelectedThemeIndex(), 1);
  });
}
