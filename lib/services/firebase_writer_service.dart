import 'package:dartz/dartz.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';

class FirebaseWriterService {
  final DatabaseReference _firebaseDatabase;

  final Logger logger = getLogger((FirebaseWriterService).toString());

  FirebaseWriterService(this._firebaseDatabase) {
    logger.i("Firebase Db Service Initialized");
  }

  Future<Either<String, String>> setPointsToTeam(
      String eventId, String teamId, int round, int points) async {
    logger.i('setting score to team: $teamId, round: $round, points: $points');
    try {
      await _firebaseDatabase
          .child('scores')
          .child(eventId)
          .child(teamId)
          .child(round.toString())
          .set(
        {
          'score': points,
        },
      );
      return right("Success");
    } on FirebaseException catch (e) {
      final msg = e.message ?? 'Unknown Error when storing score';
      logger.e(msg);
      return left("Error");
    }
  }

  Future<Either<String, int>> getTeamScore(
      String eventId, String teamId, int round) async {
    logger.i('getting score of $teamId team in $round round');
    try {
      final event = await _firebaseDatabase
          .child('scores')
          .child(eventId)
          .child(teamId)
          .child(round.toString())
          .once();

      if (event.snapshot.value != null) {
        var data = event.snapshot.value as Map;
        return right(data['score']);
      } else {
        return left('No score found');
      }
    } on FirebaseException catch (e) {
      final msg = e.message ?? 'Unknown Error when getting score';
      logger.e(msg);
      return left(msg);
    }
  }

  Future<bool> initializeScoreForTeam(String eventId, String teamId) async {
    logger.i('initializing score for team: $teamId');
    try {
      await _firebaseDatabase
          .child('scores')
          .child(eventId)
          .child(teamId)
          .child('0')
          .set(
        {
          'score': 0,
        },
      );
      return true;
    } on FirebaseException catch (e) {
      final msg = e.message ?? 'Unknown Error when initializing score';
      logger.e(msg);
      return false;
    }
  }
}
