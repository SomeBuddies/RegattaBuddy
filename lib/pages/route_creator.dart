import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:regatta_buddy/components/app_header.dart';
import 'package:latlong2/latlong.dart';

class RouteCreatorPage extends StatefulWidget {
  static const String route = '/route_creator';

  const RouteCreatorPage({super.key});

  @override
  State<RouteCreatorPage> createState() => _RouteCreatorPageState();
}

class _RouteCreatorPageState extends State<RouteCreatorPage> {
  late final MapController _mapController;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          onLongPress: (tapPosition, coordinates) {
            markers.add(Marker(
                point: coordinates,
                builder: (context) => const Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 12,
                    )));
            setState(() {});
          },
          center: const LatLng(54.372158, 18.638306),
          zoom: 12,
        ),
        nonRotatedChildren: const [
          RichAttributionWidget(
            popupInitialDisplayDuration: Duration(seconds: 5),
            animationConfig: ScaleRAWA(),
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
              ),
              TextSourceAttribution(
                'This attribution is the same throughout this app, except where otherwise specified',
                prependCopyright: false,
              ),
            ],
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.regattaBuddy.app',
          ),
          MarkerLayer(markers: markers)
        ],
      ),
    );
  }
}
