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

    // Verify app title
    expect(find.text('Theme Store'), findsOneWidget);
  });

  testWidgets('Can switch to dark theme', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Initially should be light theme
    BuildContext context = tester.element(find.byType(MaterialApp));
    ThemeData theme = Theme.of(context);
    expect(theme.brightness, equals(Brightness.light));

    // Tap on "Theme 2" (index = 1, dark theme)
    await tester.tap(find.text('Theme 2'));
    await tester.pumpAndSettle();

    // Now it should be dark theme
    context = tester.element(find.byType(MaterialApp));
    theme = Theme.of(context);
    expect(theme.brightness, equals(Brightness.dark));
  });
}
