import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_buddy/extensions/string_extension.dart';

import 'package:regatta_buddy/utils/constants.dart' as constants;
import 'package:regatta_buddy/utils/external_api_constants.dart'
    as ext_constants;
import 'package:regatta_buddy/models/complex_marker.dart';

class EventRouteSubPage extends StatefulWidget {
  final List<ComplexMarker> markers;
  final void Function(ComplexMarker) addMarker;
  final void Function(ComplexMarker) removeMarker;

  const EventRouteSubPage(
    this.markers,
    this.addMarker,
    this.removeMarker, {
    super.key,
  });

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Utwórz trasę przytrzymując palcem punkty na mapie"),
        Flexible(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              maxZoom: 18.0,
              onLongPress: (tapPosition, point) {
                UniqueKey uniqueKey = UniqueKey();
                Color randomColor = uniqueKey.toString().toSeededColor();
                Marker markerWithRandomColor = Marker(
                  key: uniqueKey,
                  point: point,
                  builder: (context) => Icon(
                    Icons.circle,
                    color: randomColor,
                    size: 12,
                  ),
                );
                widget.addMarker(
                  ComplexMarker(markerWithRandomColor, randomColor),
                );
              },
              center: const LatLng(54.372158, 18.638306),
              zoom: 12,
            ),
            nonRotatedChildren: const [
              SimpleAttributionWidget(
                source: Text(constants.attributionText),
              ),
            ],
            children: [
              TileLayer(
                urlTemplate: ext_constants.tileLayerUrl,
                userAgentPackageName: ext_constants.tileLayerUserAgent,
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: widget.markers
                        .map((complexMarker) => complexMarker.marker.point)
                        .toList(),
                    isDotted: true,
                    color: Colors.red,
                    strokeWidth: 3,
                  )
                ],
              ),
              MarkerLayer(
                markers:
                    widget.markers.map((complex) => complex.marker).toList(),
              ),
            ],
          ),
        ),
        Flexible(
          child: ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            children: widget.markers
                .map(
                  (complexMarker) => ListTile(
                    key: complexMarker.marker.key,
                    title: Text(
                      complexMarker.marker.point.toSexagesimal(),
                      style: TextStyle(fontSize: 13),
                    ),
                    tileColor: complexMarker.color,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => widget.removeMarker(complexMarker),
                    ),
                  ),
                )
                .toList(),
            onReorder: (oldIndex, newIndex) => setState(
              () {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final ComplexMarker item = widget.markers.removeAt(oldIndex);
                widget.markers.insert(newIndex, item);
              },
            ),
          ),
        )
      ],
    );
  }
}
