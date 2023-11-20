import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:regatta_buddy/enums/round_status.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'race_events.g.dart';

@riverpod
Stream<Map<String, List<int>>> teamScores(TeamScoresRef ref, Event event) {
  final logger = getLogger("TeamScoresProvider");
  logger.i("initializing a teamScore provider for ${event.id}");
  final dbRef =
      ref.watch(firebaseRealtimeProvider).child('scores').child(event.id);

  final controller = StreamController<Map<String, List<int>>>();

  final subscription = dbRef.onValue.listen((DatabaseEvent dbEvent) {
    if (dbEvent.snapshot.value == null) return;
    if (dbEvent.snapshot.value is! Map) return;
    final data = dbEvent.snapshot.value as Map<dynamic, dynamic>;
    logger.i("getting new data from firebase: ${data.toString()}");

    final scores = data.map((key, value) {
      final teamId = key as String;
      List<dynamic> rounds = [];

      // normalize the data to be a map
      if (value is List) value = value.asMap();

      int maxRound = 0;
      for (var key in value.keys) {
        if (key is int && key > maxRound) maxRound = key;
        if (key is String && int.parse(key) > maxRound) {
          maxRound = int.parse(key);
        }
      }
      rounds = List<dynamic>.filled(maxRound + 1, Map.of({'score': 0}));
      for (var key in value.keys) {
        if (key is String && value[key] != null) rounds[int.parse(key)] = value[key];
        if (key is int && value[key] != null) rounds[key] = value[key];
      }

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

@riverpod
class CurrentRound extends _$CurrentRound {
  @override
  int build(String eventId) {
    // TODO should get the current round from firebase
    return 0;
  }

  void set(int round) {
    state = round;
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

@riverpod
class CurrentlyTrackedTeams extends _$CurrentlyTrackedTeams {
  @override
  Set<String> build() {
    return {};
  }

  void set(Set<String> teams) {
    state = teams;
  }

  void clear() {
    state = {};
  }
}
