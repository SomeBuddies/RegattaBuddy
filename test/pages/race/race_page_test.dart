import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/pages/race/participant/race_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';

import '../../firebase_mock.dart';

class MockEvent extends Mock implements Event {}

class MockTeam extends Mock implements Team {}

void main() {
  setupFirebaseMocks();
  final event = MockEvent();
  final team = MockTeam();

  setUpAll(() async {
    when(() => event.id).thenReturn("UniqueId");
    when(() => team.id).thenReturn("UniqueTeamId");

    await Firebase.initializeApp();
  });

  testWidgets('Statistics are visible', (tester) async {
    await tester.pumpWidget(MaterialApp(
      onGenerateRoute: (settings) => MaterialPageRoute(
          settings: RouteSettings(arguments: RacePageArguments(event, team)),
          builder: (context) => RacePage()),
    ));

    expect(find.text('Distance'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('Avg. Speed'), findsOneWidget);
  });

  testWidgets('Can open actions modal', (tester) async {
    await tester.pumpWidget(MaterialApp(
      onGenerateRoute: (settings) => MaterialPageRoute(
          settings: RouteSettings(arguments: RacePageArguments(event, team)),
          builder: (context) => RacePage()),
    ));

    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.warning_amber_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Needs help'), findsOneWidget);
    expect(find.text('Protest'), findsOneWidget);
    expect(find.text('Problem'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('Statistics are visible', (tester) async {
    await tester.pumpWidget(MaterialApp(
      onGenerateRoute: (settings) => MaterialPageRoute(
          settings: RouteSettings(arguments: RacePageArguments(event, team)),
          builder: (context) => RacePage()),
    ));

    expect(find.text('Distance'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('Avg. Speed'), findsOneWidget);
  });
}
