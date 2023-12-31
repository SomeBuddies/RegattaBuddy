import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regatta_buddy/main.dart';

import 'firebase_mock.dart';

void main() {
  setupFirebaseMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('App header visibility test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RegattaBuddy()));

    expect(find.byIcon(Icons.sailing), findsOneWidget);
  });
}
