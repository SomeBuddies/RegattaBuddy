import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:regatta_buddy/extensions/transaction_extension.dart';
import 'package:regatta_buddy/models/auth_state.dart';
import 'package:regatta_buddy/providers/auth/auth_state_notifier.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/models/user_data.dart';

class UserRepository {
  final Ref _ref;
  final Logger _logger = getLogger((UserRepository).toString());

  UserRepository(this._ref);

  FirebaseFirestore get _firestore => _ref.read(firebaseFirestoreProvider);

  Future<Either<String, UserData>> getUserData(String userId) async {
    try {
      _logger.i('Fetching user data from Firestore for uid: $userId');
      final userData = await _firestore.collection('users').doc(userId).get();

      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;
        _logger.i('User data found for uid: $userId | $data');
        return right(
          UserData(
            uid: userId,
            email: data['email'],
            firstName: data['firstName'],
            lastName: data['lastName'],
          ),
        );
      } else {
        _logger.w('User data not found for uid: $userId');
        return left('User data not found for uid: $userId');
      }
    } on Exception catch (e) {
      _logger.e('Error fetching user data: $e');
      return left('Error fetching user data: $e');
    }
  }

  Future<Either<String, UserData>> getCurrentUserData() async {
    final AuthState authState = _ref.watch(authStateNotiferProvider);

    return authState.maybeWhen(
      orElse: () => throw Exception("User not logged in"),
      authenticated: (user) => getUserData(user.uid),
    );
  }

  /// Checks if user is already participating in the event.
  Future<bool> isUserInEvent({
    required String userId,
    required String eventId,
    Transaction? transaction,
  }) async {
    final docRef =
        _firestore.collection('users/$userId/joinedEvents').doc(eventId);

    if (transaction == null) {
      final doc = await docRef.get();
      return doc.exists;
    } else {
      final doc = await transaction.get(docRef);
      return doc.exists;
    }
  }

  /// Adds an event to the list of joined events along with information,
  /// which team the user is on.
  void addToJoinedEvents({
    required String userId,
    required String eventId,
    required String teamId,
    Transaction? transaction,
  }) {
    final docRef =
        _firestore.collection('users/$userId/joinedEvents').doc(eventId);

    transaction.maybeSet(docRef, {'teamId': teamId});
  }

  /// Removes an event from the list of joined events
  void removeFromJoinedEvents({
    required String userId,
    required String eventId,
    Transaction? transaction,
  }) {
    final docRef =
        _firestore.collection('users/$userId/joinedEvents').doc(eventId);

    transaction.maybeDelete(docRef);
  }
}
