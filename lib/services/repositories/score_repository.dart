import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:regatta_buddy/extensions/exception_extension.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';

class ScoreRepository {
  final Logger logger = getLogger((ScoreRepository).toString());

  final Ref _ref;

  DatabaseReference get _realtime => _ref.read(firebaseRealtimeProvider);

  ScoreRepository(this._ref) {
    logger.i("Score Repository Initialized");
  }

  Future<void> setPointsToTeam(
    String eventId,
    String teamId,
    int round,
    int points,
  ) async {
    logger.i('setting score to team: $teamId, round: $round, points: $points');

    try {
      await _realtime
          .child('scores')
          .child(eventId)
          .child(teamId)
          .child(round.toString())
          .set(
        {
          'score': points,
        },
      );
    } on Exception catch (e) {
      e.log(logger);
      rethrow;
    }
  }

  Future<int> getTeamScore(
    String eventId,
    String teamId,
    int round,
  ) async {
    logger.i('getting score of $teamId team in $round round');

    try {
      final event = await _realtime
          .child('scores')
          .child(eventId)
          .child(teamId)
          .child(round.toString())
          .once();

      if (event.snapshot.value != null) {
        var data = event.snapshot.value as Map;
        return data['score'];
      } else {
        logger.i("No score found, defaulting to 0");
        return 0;
      }
    } on Exception catch (error) {
      error.log(logger);
      rethrow;
    }
  }
}
