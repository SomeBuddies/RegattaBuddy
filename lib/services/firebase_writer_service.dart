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
}
