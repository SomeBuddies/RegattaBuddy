import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:regatta_buddy/models/registration_data.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  final Logger logger = getLogger((AuthService).toString());

  AuthService(this._firebaseAuth, this._firestore) {
    logger.i("Auth Service Initialized");
  }

  /// Tries to sign up user with provided [registrationData].
  ///
  /// Returns either the [User] object or a [String] with the error message.
  Future<Either<String, User>> signup(RegistrationData registrationData) async {
    logger.d(
      'Signing up user with email: ${registrationData.email}',
    );
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: registrationData.email,
        password: registrationData.password,
      );
    } on FirebaseAuthException catch (e) {
      final msg = e.message ?? 'Unknown Error when creating user';
      logger.e(msg);
      return left(msg);
    }

    logger.d(
      'Successfully created user with email: ${registrationData.email}. Now storing user info...',
    );
    try {
      await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).set(
        {
          'firstName': registrationData.firstName,
          'lastName': registrationData.lastName,
          'email': registrationData.email,
        },
      );
    } on FirebaseException catch (e) {
      final msg = e.message ?? 'Unknown Error when storing user info';
      logger.e(msg);
      return left(msg);
    }

    logger.i('Successfully sign up for email: ${registrationData.email}');
    return right(_firebaseAuth.currentUser!);
  }

  /// Tries to login with the provided [email] and [password].
  ///
  /// Returns either the [User] object or a [String] with the error message.
  Future<Either<String, User>> login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = 'No user found for email: $email';
        case 'wrong-password':
          msg = 'Wrong password provided for email: $email';
        default:
          msg = 'Unhandled FirebaseAuthException: ${e.message}';
      }
      logger.i(msg);
      return left(msg);
    } on Exception catch (e) {
      final msg = 'Error when logging in: $e';
      logger.e(msg);
      return left(msg);
    }

    logger.i('Successfully logged in with email: $email');
    return right(_firebaseAuth.currentUser!);
  }

  /// Checks if user was already logged in.
  ///
  /// Returns the [User] object or [None] if not logged in.
  Future<Option<User>> checkIfLoggedIn() async {
    // There is absolutely no reason for this to use Option instead of User?
    // This is just because the other methods user Either and I wanted it to be similar.
    final user = optionOf(_firebaseAuth.currentUser);

    if (user.isNone()) logger.i("User is not logged in.");
    return user;
  }

  /// Signs out the user.
  Future<void> signout() async {
    _firebaseAuth.signOut();
  }
}
