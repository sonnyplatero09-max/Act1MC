import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:activity1mc/main.dart';
import 'package:activity1mc/providers/app_state_provider.dart';

void main() {
  testWidgets('Dashboard renders student portfolio and activity cards',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppStateProvider(),
        child: const MobileComputingPortfolioApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Dashboard Title and Student Profile info
    expect(find.text('Mobile Computing Portfolio'), findsOneWidget);
    expect(find.text('Alex Rivera & Sam Cruz'), findsOneWidget);
    expect(find.text('Laboratory Activities'), findsOneWidget);

    // Verify Activity Cards exist
    expect(find.text('Activity 1: Interactive Counter Studio'), findsOneWidget);
    expect(find.text('Activity 2: Tip & Bill Splitter'), findsOneWidget);
    expect(find.text('Activity 3: Lab Checklist & Milestones'), findsOneWidget);
  });

  testWidgets('Navigating to Activity 1 and interacting with stateful counter',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppStateProvider(),
        child: const MobileComputingPortfolioApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap the first Launch button to navigate to Activity 1
    final launchButtons = find.widgetWithText(FilledButton, 'Launch');
    expect(launchButtons, findsWidgets);
    await tester.tap(launchButtons.first);
    await tester.pumpAndSettle();

    // Verify we are on Activity 1 screen
    expect(find.text('Activity 1: Interactive Counter'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    // Increment counter
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Positive (+1)'), findsOneWidget);
  });

  testWidgets('Navigating to Settings screen and verifying state persistence',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppStateProvider(),
        child: const MobileComputingPortfolioApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap the Settings icon in AppBar
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // Verify Settings screen elements
    expect(find.text('App Settings'), findsOneWidget);
    expect(find.text('APPEARANCE & THEME'), findsOneWidget);
    expect(find.text('STUDENT / PAIR PROFILE'), findsOneWidget);

    // Tap Dark mode button segment
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    // Go back to Home Dashboard
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Verify the Active Theme Metric Card now shows Dark Mode!
    expect(find.text('Dark Mode'), findsOneWidget);
  });
}
