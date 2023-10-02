
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regatta_buddy/pages/race/participant/race_page.dart';

import '../../firebase_mock.dart';

void main() {

  setupFirebaseMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Statistics are visible', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RacePage()));

    expect(find.text('Distance'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('Avg. Speed'), findsOneWidget);
  });

  testWidgets('Can open actions modal', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RacePage()));

    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.warning_amber_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Needs help'), findsOneWidget);
    expect(find.text('Protest'), findsOneWidget);
    expect(find.text('Problem'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('Clicking action triggers notification which disappears after some time', (tester) async {
    const int notificationVisibilityDuration = 10;
    await tester.pumpWidget(const MaterialApp(home: RacePage()));

    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.warning_amber_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Needs help'));
    await tester.pumpAndSettle();

    expect(find.text('Help requested'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: notificationVisibilityDuration + 1));

    expect(find.text('Help requested'), findsNothing);
  });
}
