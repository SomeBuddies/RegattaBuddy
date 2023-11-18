import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/pages/race/participant/race_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';

import '../../firebase_mock.dart';

void main() {
  setupFirebaseMocks();

  final Event mockedEvent = Event(
      id: "uniqueId",
      date: DateTime.utc(2013),
      description: "sdfa",
      hostId: "dfsa",
      location: const LatLng(12, 12),
      name: "nasdf",
      route: []);

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Can open actions modal', (tester) async {
    await tester.pumpWidget(MaterialApp(
      onGenerateRoute: (settings) => MaterialPageRoute(
          settings:
              RouteSettings(arguments: RacePageArguments(mockedEvent, "teamX")),
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
          settings:
              RouteSettings(arguments: RacePageArguments(mockedEvent, "teamX")),
          builder: (context) => RacePage()),
    ));

    expect(find.text('Distance'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('Avg. Speed'), findsOneWidget);
  });
}
