import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/providers/event_details/teams_provider.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'team_position_notifier.g.dart';

@Riverpod(keepAlive: true)
class TeamPositionNotifier extends _$TeamPositionNotifier {
  @override
  Map<String, LatLng> build(Event event) {
    final teams = ref.watch(teamsProvider(event));
    final firebaseDb = ref.watch(firebaseDbProvider);
    final logger = getLogger("TeamPositionNotifier");
    logger.i("initializing a TeamPositionNotifier provider");
    teams.when(
        data: (data) {
          for (final team in data) {
            final dbRef = firebaseDb
                .child('traces')
                .child(event.id)
                .child(team.id)
                .child('lastPosition');

            dbRef.onValue.listen((DatabaseEvent event) {
              if (event.snapshot.value == null) {
                return;
              }
              final data = event.snapshot.value as String;
              logger.i("updating $team position: ${data.toString()}");
              final latlon = data.split(', ');
              var latitude = double.parse(latlon[0]);
              var longitude = double.parse(latlon[1]);
              var newMap = Map.of(state);
              newMap[team.id] = LatLng(latitude, longitude);
              state = newMap;
            });
          }
        },
        error: (error, stackTrace) =>
            logger.e("Error: $error", error, stackTrace),
        loading: () {});

    return Map.unmodifiable({});
  }
}
