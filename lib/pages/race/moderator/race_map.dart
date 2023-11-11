import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_buddy/extensions/string_extension.dart';
import 'package:regatta_buddy/providers/auth/team_traces_notifier.dart';
import 'package:regatta_buddy/providers/race_events.dart';

import 'package:regatta_buddy/utils/constants.dart' as constants;
import 'package:regatta_buddy/utils/external_api_constants.dart'
    as api_constants;
import 'package:regatta_buddy/utils/logging/logger_helper.dart';

class RaceMap extends ConsumerWidget {
  final MapController mapController;
  final String eventId;

  const RaceMap(
      {super.key, required this.mapController, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackedTeams = ref.watch(currentlyTrackedTeamsProvider);
    final currentRound = ref.watch(currentRoundProvider(eventId));
    final teamTraces = ref.watch(teamTracesNotifierProvider(eventId));

    return FlutterMap(
      mapController: mapController,
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
        PolylineLayer(
          polylines: [
            for (final teamId in trackedTeams)
              Polyline(
                points: getTrackedTeamTrace(teamId, teamTraces, currentRound),
                strokeWidth: 4.0,
                color: teamId.toSeededColor(),
              ),
          ],
        ),
        CurrentLocationLayer(),
        RaceMarkerLayer(eventId: eventId)
      ],
    );
  }

  List<LatLng> getTrackedTeamTrace(String trackedTeam, Map<String, Map<int, List<LatLng>>> teamTraces, int currentRound) => [if (pointsAreAvailable(trackedTeam, teamTraces, currentRound)) ...teamTraces[trackedTeam]![currentRound]!];

  bool pointsAreAvailable(String trackedTeam, Map<String, Map<int, List<LatLng>>> teamTraces, int currentRound) => trackedTeam != "" && teamTraces[trackedTeam] != null && teamTraces[trackedTeam]![currentRound] != null;
}

class RaceMarkerLayer extends ConsumerWidget {
  const RaceMarkerLayer({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, LatLng> teamPositions =
        ref.watch(teamPositionProvider(eventId));
    var logger = getLogger("RaceMarkerLayer");
    logger.i("building a RaceMarkerLayer widget");

    return MarkerLayer(
      markers: [
        for (final team in teamPositions.keys)
          Marker(
            width: 40.0,
            height: 40.0,
            point: teamPositions[team] == null
                ? constants.startingPosition
                : teamPositions[team]!,
            builder: (ctx) => IconButton(
              icon: const Icon(
                Icons.sailing,
                shadows: [
                  Shadow(
                    blurRadius: 15.0,
                    color: Colors.black,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
              color: team.toSeededColor(),
              iconSize: 40.0,
              onPressed: () {
                logger.i("pressed on $team");
              },
            ),
          ),
      ],
    );
  }
}
