import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regatta_buddy/main.dart';

void main() {
  testWidgets('App header visibility test', (WidgetTester tester) async {
    await tester.pumpWidget(const RegattaBuddy());

    expect(find.byIcon(Icons.sailing), findsOneWidget);
  });
}
