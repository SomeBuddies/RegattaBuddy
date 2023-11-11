import 'package:firebase_database/firebase_database.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:latlong2/latlong.dart';

part 'team_traces_notifier.g.dart';

@Riverpod(keepAlive: true)
class TeamTracesNotifier extends _$TeamTracesNotifier {

  @override
  Map<String, Map<int, List<LatLng>>> build(String eventId) {
    final firebaseDb = ref.watch(firebaseDbProvider);
    final logger = getLogger("TeamTracesNotifier");
    logger.i("initializing a TeamTracesNotifier provider");

    final dbScoresRef = firebaseDb.child('scores').child(eventId);

    dbScoresRef.onValue.listen((event) {
      final teamsAndScores = event.snapshot.value as Map<dynamic, dynamic>;

      for (final round in List.generate(10, (index) => index)) {
        for (final team in teamsAndScores.keys.toList()) {
          final dbRef = firebaseDb
              .child('traces')
              .child(eventId)
              .child(team)
              .child('positions')
              .child('rounds')
              .child(round.toString());

          dbRef.onChildAdded.listen((DatabaseEvent event) {
            logger.i("child added to traces | round: $round | team: $team");
            final data = event.snapshot.value as String?;
            if (data == null) return;
            final latlong = data.split(', ');
            var latitude = double.parse(latlong[0]);
            var longitude = double.parse(latlong[1]);
            var newMap = Map.of(state);
            var teamMap = newMap[team] ?? {};
            teamMap[round] = [...teamMap[round] ?? [], LatLng(latitude, longitude)];
            newMap[team] = teamMap;
            state = newMap;
          });
        }
      }
    });
    return Map.unmodifiable({});
  }

}
