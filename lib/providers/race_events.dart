import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
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
