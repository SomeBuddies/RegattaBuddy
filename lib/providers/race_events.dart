import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
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
