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
  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: FlutterMap(
        options: MapOptions(
          onMapReady: () {
            mapController.mapEventStream.listen((event) {});
          },
          center: const LatLng(54.372158, 18.638306),
          zoom: 9.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.regattaBuddy.app',
          ),
        ],
      ),
    );
  }
}
