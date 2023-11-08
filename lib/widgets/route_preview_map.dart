import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_buddy/extensions/latlng_bounds_extension.dart';

import 'package:regatta_buddy/utils/external_api_constants.dart'
    as ext_constants;
import 'package:regatta_buddy/utils/constants.dart' as constants;

class RoutePreviewMap extends StatelessWidget {
  final List<LatLng> route;
  final bool smallMode;

  const RoutePreviewMap(this.route, {this.smallMode = false, super.key});

  Marker _iconMarker({
    required LatLng point,
    required Icon icon,
    Color? backgroundColor,
  }) {
    return Marker(
      point: point,
      width: smallMode ? 15 : 25,
      height: smallMode ? 15 : 25,
      builder: (context) => Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
          child: icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: FlutterMap(
        options: MapOptions(
          bounds: LatLngBounds.fromPoints(route)..expandBounds(1.3),
          interactiveFlags: InteractiveFlag.none,
        ),
        nonRotatedChildren: [
          if (!smallMode)
            const SimpleAttributionWidget(
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
                points: route,
                isDotted: true,
                color: Colors.red,
                strokeWidth: 3,
              )
            ],
          ),
          MarkerLayer(
            markers: [
              _iconMarker(
                point: route.first,
                icon: Icon(
                  Icons.tour,
                  size: smallMode ? 12 : 20,
                ),
                backgroundColor: Colors.red.shade300,
              ),
              _iconMarker(
                point: route.last,
                icon: Icon(
                  Icons.sports_score_outlined,
                  size: smallMode ? 12 : 20,
                ),
                backgroundColor: Colors.red.shade300,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
