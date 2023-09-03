import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regatta_buddy/models/registration_data.dart';
import 'package:regatta_buddy/models/user_data.dart';
import 'package:regatta_buddy/services/authentication_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockedFirebaseFirestore extends FakeFirebaseFirestore {
  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    throw Exception('Firestore exception');
  }
}

void main() {
  group('AuthenticationService Tests', () {
    late AuthenticationService authService;
    late MockFirebaseAuth mockFirebaseAuth;
    late FakeFirebaseFirestore fakeFirebaseFirestore;
    late MockUser mockUser;

    const email = 'test@somebuddies.com';
    const password = 'password';
    const userUid = 'user-id';

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      fakeFirebaseFirestore = FakeFirebaseFirestore();
      authService = AuthenticationService.custom(
        firebaseAuth: mockFirebaseAuth,
        firestore: fakeFirebaseFirestore,
      );
      mockUser = MockUser();
    });

    test('Successful login', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(userUid);

      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) => Future.value(MockUserCredential()));

      final result = await authService.login(email, password);

      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).called(1);

      expect(result, userUid);
    });

    test('Failed login', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(userUid);
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      final result = await authService.login(email, password);

      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).called(1);
      expect(result, isNull);
    });

    test('Successful fetch current user data', () async {
      const firebaseUserData = {
        'email': email,
        'firstName': 'Krysiu',
        'lastName': 'Testowy',
      };
      final expectedUserData = UserData(
        uid: userUid,
        email: email,
        firstName: 'Krysiu',
        lastName: 'Testowy',
      );

      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(userUid);
      await fakeFirebaseFirestore
          .collection('users')
          .doc(userUid)
          .set(firebaseUserData);

      final result = await authService.fetchCurrentUserData();

      verify(() => mockFirebaseAuth.currentUser).called(1);
      expect(result?.firstName, expectedUserData.firstName);
      expect(result?.lastName, expectedUserData.lastName);
      expect(result?.email, expectedUserData.email);
    });

    test('Failed fetch current user data', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = await authService.fetchCurrentUserData();

      verify(() => mockFirebaseAuth.currentUser).called(1);
      expect(result, isNull);
    });

    test('Successful fetch user data', () async {
      const firebaseUserData = {
        'email': email,
        'firstName': 'Bortek',
        'lastName': 'Tester',
      };
      final expectedUserData = UserData(
        uid: userUid,
        email: email,
        firstName: 'Bortek',
        lastName: 'Tester',
      );

      await fakeFirebaseFirestore
          .collection('users')
          .doc(userUid)
          .set(firebaseUserData);

      final result = await authService.fetchUserData(userUid);

      expect(result?.firstName, expectedUserData.firstName);
      expect(result?.lastName, expectedUserData.lastName);
      expect(result?.email, expectedUserData.email);
    });

    test('Successful signup', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(userUid);

      RegistrationData registrationData = RegistrationData(
        email: email,
        password: password,
        firstName: 'Krysiu',
        lastName: 'Testowy',
      );

      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) => Future.value(MockUserCredential()));

      final result = await authService.signUp(registrationData);

      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).called(1);

      var newUserData =
          await fakeFirebaseFirestore.collection('users').doc(userUid).get();
      const expectedFirestoreUserData = {
        'email': email,
        'firstName': 'Krysiu',
        'lastName': 'Testowy',
      };

      expect(result, userUid);
      expect(newUserData.data(), expectedFirestoreUserData);
    });

    test('Failed signup - createUserWithEmailAndPassword throws exception',
        () async {
      RegistrationData registrationData = RegistrationData(
        email: email,
        password: password,
        firstName: 'Krysiu',
        lastName: 'Testowy',
      );

      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      final result = await authService.signUp(registrationData);

      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).called(1);

      var newUserData =
          await fakeFirebaseFirestore.collection('users').doc(userUid).get();

      expect(result, isNull);
      expect(newUserData.data(), isNull);
    });

    test('Failed signup - saving user data to firestore throws exception',
        () async {
      authService = AuthenticationService.custom(
        firebaseAuth: mockFirebaseAuth,
        firestore: MockedFirebaseFirestore(),
      );

      RegistrationData registrationData = RegistrationData(
        email: email,
        password: password,
        firstName: 'Krysiu',
        lastName: 'Testowy',
      );

      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) => Future.value(MockUserCredential()));

      final result = await authService.signUp(registrationData);

      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).called(1);

      expect(result, isNull);
    });
  });
}
