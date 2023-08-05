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

  final List<ComplexMarker> markers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  Color generateBrightColor() {
    int r = 0, g = 0, b = 0, a = 255;
    while (r + g + b < 255) {
      r = Random().nextInt(0xffffffff);
      g = Random().nextInt(255);
      b = Random().nextInt(255);
    }
    return Color.fromARGB(a, r, g, b);
  }

  void addMarker(ComplexMarker marker) {
    markers.add(marker);
    setState(() {});
  }

  void deleteMarker(ComplexMarker marker) {
    markers.remove(marker);
    setState(() {});
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
                    Color randomColor = generateBrightColor();
                    Marker markerWithRandomColor = Marker(
                        key: UniqueKey(),
                        point: point,
                        builder: (context) => Icon(
                              Icons.circle,
                              color: randomColor,
                              size: 12,
                            ));
                    addMarker(
                        ComplexMarker(markerWithRandomColor, randomColor));
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
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteMarker(complexMarker),
                            ),
                          ))
                      .toList(),
                  onReorder: (oldIndex, newIndex) => setState(
                        () {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final ComplexMarker item = markers.removeAt(oldIndex);
                          markers.insert(newIndex, item);
                        },
                      )),
            )
          ],
        ),
      ),
    );
  }
}
