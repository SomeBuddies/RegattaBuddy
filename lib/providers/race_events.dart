import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_buddy/enums/round_status.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'race_events.g.dart';

@riverpod
Stream<Map<String, List<int>>> teamScores(TeamScoresRef ref, String eventId) {
  final logger = getLogger("TeamScoresProvider");
  final dbRef = ref.watch(firebaseDbProvider).child('scores').child(eventId);

  final controller = StreamController<Map<String, List<int>>>();

  final subscription = dbRef.onValue.listen((DatabaseEvent event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>;
    logger.i("getting new data from firebase: ${data.toString()}");

    final scores = data.map((key, value) {
      final teamId = key as String;
      final rounds = value as List<dynamic>;

      final scores = rounds.map((round) {
        return round['score'] as int;
      }).toList();

      return MapEntry(teamId, scores);
    });

    controller.add(scores);
  });

  ref.onDispose(() {
    logger.i("disposing a teamScore provider");
    subscription.cancel();
    controller.close();
  });
  return controller.stream;
}

// TODO change to immutable map
class TeamPositionNotifier extends StateNotifier<Map<String, LatLng>> {
  final DatabaseReference firebaseDb;

  TeamPositionNotifier(this.firebaseDb, String eventId) : super(<String, LatLng>{}) {
    final logger = getLogger("TeamPositionNotifier");
    logger.i("initializing a TeamPositionNotifier provider");

    final dbScoresRef = firebaseDb.child('scores').child(eventId);

    // TODO get the teams from teams document instead of scores document
    dbScoresRef.onValue.listen((event) {
      final teamsAndScores = event.snapshot.value as Map<dynamic, dynamic>;

      logger.i("getting new scores data from firebase: ${teamsAndScores.toString()}");

      for (final team in teamsAndScores.keys.toList()) {
        final dbRef = firebaseDb.child('traces').child(eventId).child(team).child('lastPosition');
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
  }
}

final teamPositionProvider =
    StateNotifierProvider<TeamPositionNotifier, Map<String, LatLng>>((ref) {
  const eventId = "uniqueEventID";

  final db = ref.read(firebaseDbProvider);

  return TeamPositionNotifier(db, eventId);
});

@riverpod
class CurrentRound extends _$CurrentRound {
  @override
  int build() {
    // TODO should be synced with db
    return 0;
  }

  void set(int type) {
    state = type;
  }

  void increment() {
    state = state + 1;
  }
}

@riverpod
class CurrentRoundStatus extends _$CurrentRoundStatus {
  @override
  RoundStatus build() {
    return RoundStatus.pending;
  }

  void set(RoundStatus status) {
    state = status;
  }

  void start() {
    state = RoundStatus.started;
  }

  void finish() {
    state = RoundStatus.finished;
  }
}
