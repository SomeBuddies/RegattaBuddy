import 'package:logger/logger.dart';
import 'package:regatta_buddy/models/auth_state.dart';
import 'package:regatta_buddy/models/user_data.dart';
import 'package:regatta_buddy/providers/auth/auth_state_notifier.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<UserData> userData(UserDataRef ref, String uid) async {
  final Logger logger = getLogger('UserProvider');
  final firestore = ref.watch(firebaseFirestoreProvider);

  try {
    logger.i('Fetching user data from Firestore for uid: $uid');
    final userData = await firestore.collection('users').doc(uid).get();

    if (userData.exists) {
      final data = userData.data() as Map<String, dynamic>;
      logger.i('User data found for uid: $uid | $data');
      return UserData(
        uid: uid,
        email: data['email'],
        firstName: data['firstName'],
        lastName: data['lastName'],
      );
    } else {
      logger.w('User data not found for uid: $uid');
      throw Exception('User data not found for uid: $uid');
    }
  } on Exception catch (e) {
    logger.e('Error fetching user data: $e');
    rethrow;
  }
}

@Riverpod(keepAlive: true)
FutureOr<UserData> CurrentUserData(CurrentUserDataRef ref) {
  //final Logger logger = getLogger('CurrentUserDataProvider');
  final AuthState authState = ref.watch(authStateNotiferProvider);

  return authState.maybeWhen(
    orElse: () => throw Exception("User not logged in"),
    authenticated: (user) => ref.watch(userDataProvider(user.uid).future),
  );
}
