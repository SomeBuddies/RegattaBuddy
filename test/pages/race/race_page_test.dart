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
}
