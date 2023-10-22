import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:regatta_buddy/extensions/string_extension.dart';
import 'package:regatta_buddy/models/registration_data.dart';
import 'package:regatta_buddy/models/user_data.dart';
import 'package:regatta_buddy/providers/auth/auth_state_notifier.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/providers/user_provider.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockedFirebaseFirestore extends FakeFirebaseFirestore {
  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    throw FirebaseException(
      plugin: "firestore",
      message: "Firestore Exception",
    );
  }
}

void main() {
  group('AuthenticationService Tests', () {
    late ProviderContainer container;
    //late AuthService authService;
    late MockFirebaseAuth mockFirebaseAuth;
    late FakeFirebaseFirestore mockFirebaseFirestore;
    late MockUser mockUser;

    const email = 'test@somebuddies.com';
    const password = 'password';
    const userUid = 'user-id';

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseFirestore = FakeFirebaseFirestore();
      mockUser = MockUser();
      container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          firebaseFirestoreProvider.overrideWithValue(mockFirebaseFirestore),
        ],
      );
      //authService = container.read(authServiceProvider);
    });

    test('Successful login', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(userUid);

      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) => Future.value(MockUserCredential()));

      await container
          .read(authStateNotiferProvider.notifier)
          .login(email: email, password: password);

      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);

      container.read(authStateNotiferProvider).maybeWhen(
            orElse: () => fail('Unknown error'),
            unauthenticated: (message) => fail(message),
            authenticated: (user) => expect(user.uid, userUid),
          );
    });

    test('Failed login', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(userUid);
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      await container
          .read(authStateNotiferProvider.notifier)
          .login(email: email, password: password);

      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);

      container.read(authStateNotiferProvider).maybeWhen(
            orElse: () => fail('Unknown error'),
            unauthenticated: (message) => expect(message, "No user found for email: $email"),
            authenticated: (user) => fail("method shouldn't return user object"),
          );
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
      await mockFirebaseFirestore.collection('users').doc(userUid).set(firebaseUserData);
      container.read(authStateNotiferProvider.notifier).checkIfLoggedIn();

      final result = container.read(currentUserDataProvider);

      result.whenOrNull(
        data: (value) {
          verify(() => mockFirebaseAuth.currentUser).called(1);
          expect(value.firstName, expectedUserData.firstName);
          expect(value.lastName, expectedUserData.lastName);
          expect(value.email, expectedUserData.email);
        },
        error: (error, stackTrace) => fail(error.toString()),
      );
    });

    test('Failed fetch current user data', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      final result = container.read(currentUserDataProvider);

      result.whenOrNull(
        data: (data) => fail('Should not return a User'),
        error: (error, stackTrace) {
          expect(error.toString(), "Exception: User not logged in");
        },
      );
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

      await mockFirebaseFirestore.collection('users').doc(userUid).set(firebaseUserData);

      final result = container.read(userDataProvider(userUid));

      result.whenOrNull(
        data: (data) {
          expect(data.firstName, expectedUserData.firstName);
          expect(data.lastName, expectedUserData.lastName);
          expect(data.email, expectedUserData.email.toTitleCase());
        },
        error: (error, stackTrace) => fail(error.toString()),
      );
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

      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) => Future.value(MockUserCredential()));

      await container.read(authStateNotiferProvider.notifier).signup(registrationData);

      verify(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);

      var newUserData = await mockFirebaseFirestore.collection('users').doc(userUid).get();
      const expectedFirestoreUserData = {
        'email': email,
        'firstName': 'Krysiu',
        'lastName': 'Testowy',
      };

      container.read(authStateNotiferProvider).maybeWhen(
            orElse: () => fail('Unknown error'),
            unauthenticated: (message) => fail(message),
            authenticated: (user) => expect(user.uid, userUid),
          );

      expect(newUserData.data(), expectedFirestoreUserData);
    });

    test('Failed signup - createUserWithEmailAndPassword throws exception', () async {
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

      await container.read(authStateNotiferProvider.notifier).signup(registrationData);

      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).called(1);

      var newUserData = await mockFirebaseFirestore.collection('users').doc(userUid).get();

      container.read(authStateNotiferProvider).maybeWhen(
            orElse: () => fail('Unknown error'),
            unauthenticated: (message) => expect(message, "Unknown Error when creating user"),
            authenticated: (user) => fail("method shouldn't return user object"),
          );

      expect(newUserData.data(), isNull);
    });

    test('Failed signup - saving user data to firestore throws exception', () async {
      container.updateOverrides([
        firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
        firebaseFirestoreProvider.overrideWithValue(MockedFirebaseFirestore()),
      ]);

      RegistrationData registrationData = RegistrationData(
        email: email,
        password: password,
        firstName: 'Krysiu',
        lastName: 'Testowy',
      );

      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) => Future.value(MockUserCredential()));

      await container.read(authStateNotiferProvider.notifier).signup(registrationData);

      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).called(1);

      container.read(authStateNotiferProvider).maybeWhen(
            orElse: () => fail('Unknown error'),
            unauthenticated: (message) => expect(message, "Firestore Exception"),
            authenticated: (user) => fail("method shouldn't return user object"),
          );
    });
  });
}
