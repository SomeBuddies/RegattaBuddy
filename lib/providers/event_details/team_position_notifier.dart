import 'package:firebase_database/firebase_database.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:latlong2/latlong.dart';

part 'team_position_notifier.g.dart';

@Riverpod(keepAlive: true)
class TeamPositionNotifier extends _$TeamPositionNotifier {

  @override
  Map<String, LatLng> build(String eventId) {
    final firebaseDb = ref.watch(firebaseDbProvider);
    final logger = getLogger("TeamPositionNotifier");
    logger.i("initializing a TeamPositionNotifier provider");

    final dbScoresRef = firebaseDb.child('scores').child(eventId);

    // TODO get the teams from teams document instead of scores document
    dbScoresRef.onValue.listen((event) {
      final teamsAndScores = event.snapshot.value as Map<dynamic, dynamic>;

      logger.i(
          "getting new scores data from firebase: ${teamsAndScores.toString()}");

      for (final team in teamsAndScores.keys.toList()) {
        final dbRef = firebaseDb
            .child('traces')
            .child(eventId)
            .child(team)
            .child('lastPosition');
        dbRef.onValue.listen((DatabaseEvent event) {
          if (event.snapshot.value == null) {
            return;
          }
          final data = event.snapshot.value as String;
          logger.i("updating $team position: ${data.toString()}");
          final latlong = data.split(', ');
          var latitude = double.parse(latlong[0]);
          var longitude = double.parse(latlong[1]);
          var newMap = Map.of(state);
          newMap[team] = LatLng(latitude, longitude);
          state = newMap;
        });
      }
    });
    return Map.unmodifiable({});
  }

}
