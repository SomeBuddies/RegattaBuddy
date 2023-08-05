import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regatta_buddy/pages/route_creator.dart';

void main() {
  testWidgets("Has no list tiles after render", (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(home: RouteCreatorPage()));

    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets("Has one list tile when long press on map", (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(home: RouteCreatorPage()));

    await widgetTester.longPress(find.byType(FlutterMap));

    expect(find.byType(ListTile), findsOneWidget);
  });
}
