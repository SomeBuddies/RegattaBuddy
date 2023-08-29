import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import 'package:regatta_buddy/utils/constants.dart' as constants;
import 'package:regatta_buddy/utils/external_api_constants.dart' as api_constants;

class RaceMap extends StatelessWidget {
  const RaceMap({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        center: constants.startingPosition,
        zoom: constants.startingZoom,
      ),
      nonRotatedChildren: const [
        SimpleAttributionWidget(
          source: Text(constants.attributionText),
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: api_constants.tileLayerUrl,
          userAgentPackageName: api_constants.tileLayerUserAgent,
        ),
        CurrentLocationLayer(),
      ],
    );
  }
}
