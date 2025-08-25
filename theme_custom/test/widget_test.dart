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

  await tester.pumpAndSettle();

  // Initially light background
  BuildContext context = tester.element(find.byType(MaterialApp));
  ThemeData theme = Theme.of(context);
  expect(theme.scaffoldBackgroundColor, equals(Colors.white));

  // Tap on "Theme 2" (index 1 = dark theme)
  await tester.tap(find.text('Theme 2'));
  await tester.pumpAndSettle();

  // Now it should be dark
  context = tester.element(find.byType(MaterialApp));
  theme = Theme.of(context);
  expect(theme.scaffoldBackgroundColor, equals(Colors.black));
});
}
