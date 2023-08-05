import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regatta_buddy/pages/route_creator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Has no list tiles after render", (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(home: RouteCreatorPage()));

    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets("Adds list tile when tap on map", (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(home: RouteCreatorPage()));

    await widgetTester.ensureVisible(find.byType(FlutterMap));
    await widgetTester
        .longPressAt(widgetTester.getCenter(find.byType(FlutterMap)));
    await widgetTester.pump();

    await widgetTester.ensureVisible(find.byType(ListTile));
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets("Removes list tile when icon on list tile is clicked",
      (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(home: RouteCreatorPage()));

    await widgetTester.longPress(find.byType(FlutterMap));
    expect(find.byType(ListTile), findsOneWidget);

    await widgetTester.tap(find.byType(IconButton));
    await widgetTester.pump();

    expect(find.byType(ListTile), findsNothing);
  });
}
