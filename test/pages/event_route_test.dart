import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regatta_buddy/pages/event_creation/event_route.dart';
import 'package:regatta_buddy/models/complex_marker.dart';

class MockFunction extends Mock {
  void call(ComplexMarker marker);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(mockComplexMarker(1, 10));
  });

  testWidgets("Has no list tiles nor markers when rendered without markers",
      (tester) async {
    // given
    List<ComplexMarker> markers = [];

    // when
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: EventRouteSubPage(markers, (marker) {}, (marker) {}))));

    // then
    expect(find.byType(ListTile), findsNothing);
    expect(
        find.byType(MarkerLayer).evaluate().first.widget,
        isA<MarkerLayer>()
            .having((t) => t.markers.length, 'number of markers', 0));
  });

  testWidgets(
      "Has exactly 3 list tiles and markers when rendered with 3 markers",
      (tester) async {
    // given
    List<ComplexMarker> markers = [
      mockComplexMarker(1, 2),
      mockComplexMarker(4, 8),
      mockComplexMarker(16, 32),
    ];

    // when
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: EventRouteSubPage(markers, (marker) {}, (marker) {}))));

    // then
    expect(find.byType(ListTile), findsNWidgets(3));
    expect(
        find.byType(MarkerLayer).evaluate().first.widget,
        isA<MarkerLayer>()
            .having((t) => t.markers.length, 'number of markers', 3));
  });

  testWidgets("Calls addMarker function when longPress on map", (tester) async {
    // given
    List<ComplexMarker> markers = [];
    final void Function(ComplexMarker) addMarker = MockFunction().call;

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: EventRouteSubPage(markers, addMarker, (marker) {}))));

    // when
    await tester.longPressAt(tester.getCenter(find.byType(FlutterMap)));

    verify(() => addMarker(any())).called(1);
  });

  testWidgets("Calls removeMarker function when longPress on map",
      (tester) async {
    // given
    List<ComplexMarker> markers = [mockComplexMarker(43, 12)];
    final void Function(ComplexMarker) removeMarker = MockFunction().call;

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: EventRouteSubPage(markers, (marker) {}, removeMarker))));

    // when
    await tester.tap(find.byType(IconButton));

    verify(() => removeMarker(any())).called(1);
  });
}

ComplexMarker mockComplexMarker(double lat, double lon) {
  Color color = Colors.red;
  return ComplexMarker(
      Marker(
          key: UniqueKey(),
          point: LatLng(lat, lon),
          builder: (context) => Icon(
                Icons.circle,
                color: color,
              )),
      color);
}
