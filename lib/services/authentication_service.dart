import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:regatta_buddy/models/registration_data.dart';
import 'package:regatta_buddy/models/user_data.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';

class AuthenticationService {
  final Logger logger = getLogger('AuthenticationService');
  late final FirebaseAuth firebaseAuth;
  late final FirebaseFirestore firestore;

  AuthenticationService() {
    firebaseAuth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    logger.i('AuthenticationService initialized');
  }

  AuthenticationService.custom({
    required this.firebaseAuth,
    required this.firestore,
  }) {
    logger.i('AuthenticationService initialized with custom dependencies');
  }

  /// Tries to login with the provided [email] and [password].
  ///
  /// Returns user uid if successful, otherwise returns null.
  Future<String?> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.i('No user found for email: $email');
      } else if (e.code == 'wrong-password') {
        logger.i('Wrong password provided for email: $email');
      }
      return null;
    } on Exception catch (e) {
      logger.e('Error when logging in: $e');
      return null;
    }
    logger.i('Successfully logged in with email: $email');
    return firebaseAuth.currentUser!.uid;
  }

  /// Tries to sign up user with provided [registrationData].
  ///
  /// Returns user uid if successful, otherwise returns null.
  Future<String?> signUp(RegistrationData registrationData) async {
    logger.d('Signing up user with email: ${registrationData.email}');
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: registrationData.email,
        password: registrationData.password,
      );
    } catch (e) {
      logger.e('Error when creating user: $e');
      return null;
    }
    logger.d(
        'Successfully created user with email: ${registrationData.email}. Now storing user info...');
    try {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set({
        'firstName': registrationData.firstName,
        'lastName': registrationData.lastName,
        'email': registrationData.email,
      });
    } catch (e) {
      logger.e('Error when storing user info: $e');
      return null;
    }
    logger.i('Successfully sign up for email: ${registrationData.email}');
    return firebaseAuth.currentUser!.uid;
  }

  /// Tries to fetch current user data from Firestore.
  ///
  /// Returns [UserData] if successful, otherwise returns null.
  Future<UserData?> fetchCurrentUserData() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        logger.e('No user found');
        return null;
      }
      return await fetchUserData(user.uid);
    } catch (e) {
      logger.e('Error fetching current user data: $e');
      return null;
    }
  }

  /// Tries to fetch user data from Firestore for provided [uid].
  ///
  /// Returns [UserData] if successful, otherwise returns null.
  Future<UserData?> fetchUserData(String uid) async {
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
        return null;
      }
    } catch (e) {
      logger.e('Error fetching user data: $e');
      return null;
    }
  }
}
