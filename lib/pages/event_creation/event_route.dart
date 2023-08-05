import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_buddy/widgets/complex_marker.dart';

class EventRouteSubPage extends StatefulWidget {
  final List<ComplexMarker> markers;
  final void Function(ComplexMarker) addMarker;
  final void Function(ComplexMarker) removeMarker;

  const EventRouteSubPage(this.markers, this.addMarker, this.removeMarker,
      {super.key});

  @override
  State<EventRouteSubPage> createState() => _EventRouteSubPageState();
}

class _EventRouteSubPageState extends State<EventRouteSubPage> {
  late final MapController _mapController;

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

  @override
  Widget build(BuildContext context) {
    return Column(
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
                widget.addMarker(
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
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.regattaBuddy.app',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                      points: widget.markers
                          .map((complexMarker) => complexMarker.marker.point)
                          .toList(),
                      isDotted: true,
                      color: Colors.red,
                      strokeWidth: 3)
                ],
              ),
              MarkerLayer(
                  markers:
                      widget.markers.map((complex) => complex.marker).toList()),
            ],
          ),
        ),
        Flexible(
          child: ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              children: widget.markers
                  .map((complexMarker) => ListTile(
                        key: complexMarker.marker.key,
                        title: Text(complexMarker.marker.point.toString()),
                        tileColor: complexMarker.color,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => widget.removeMarker(complexMarker),
                        ),
                      ))
                  .toList(),
              onReorder: (oldIndex, newIndex) => setState(
                    () {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final ComplexMarker item =
                          widget.markers.removeAt(oldIndex);
                      widget.markers.insert(newIndex, item);
                    },
                  )),
        )
      ],
    );
  }
}
