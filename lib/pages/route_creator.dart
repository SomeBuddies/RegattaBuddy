import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/app_header.dart';
import '../widgets/complex_marker.dart';

class RouteCreatorPage extends StatefulWidget {
  static const String route = '/route_creator';

  const RouteCreatorPage({super.key});

  @override
  State<RouteCreatorPage> createState() => _RouteCreatorPageState();
}

class _RouteCreatorPageState extends State<RouteCreatorPage> {
  late final MapController _mapController;

  // List<Marker> markers = [];
  // List<Color> colors = [];
  List<ComplexMarker> markers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  onLongPress: (tapPosition, point) {
                    Color randomColor =
                        Color(Random().nextInt(0x55555555) + 0xaaaaaaaa)
                            .withAlpha(0xff);
                    Marker markerWithRandomColor = Marker(
                        key: UniqueKey(),
                        point: point,
                        builder: (context) => Icon(
                              Icons.circle,
                              color: randomColor,
                              size: 12,
                            ));
                    markers
                        .add(ComplexMarker(markerWithRandomColor, randomColor));
                    setState(() {});
                  },
                  center: const LatLng(54.372158, 18.638306),
                  zoom: 12,
                ),
                nonRotatedChildren: const [
                  SimpleAttributionWidget(
                    source: Text('OpenStreetMap contributors'),
                  ),
                ],
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.regattaBuddy.app',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                          points: markers
                              .map(
                                  (complexMarker) => complexMarker.marker.point)
                              .toList(),
                          isDotted: true,
                          color: Colors.red,
                          strokeWidth: 3)
                    ],
                  ),
                  MarkerLayer(
                      markers:
                          markers.map((complex) => complex.marker).toList()),
                ],
              ),
            ),
            Flexible(
              child: ReorderableListView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  children: markers
                      .map((complexMarker) => ListTile(
                            key: complexMarker.marker.key,
                            title: Text(complexMarker.marker.point.toString()),
                            tileColor: complexMarker.color,
                          ))
                      .toList(),
                  onReorder: (oldIndex, newIndex) => setState(() {
                    if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final ComplexMarker item = markers.removeAt(oldIndex);
                        markers.insert(newIndex, item);
                      })),
            )
          ],
        ),
      ),
    );
  }
}
