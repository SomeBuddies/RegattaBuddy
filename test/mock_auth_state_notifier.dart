import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:regatta_buddy/models/auth_state.dart';
import 'package:regatta_buddy/providers/auth/auth_state_notifier.dart';

part 'mock_auth_state_notifier.g.dart';

class MockUser extends Mock implements User {}

@Riverpod(keepAlive: true)
class MockAuthStateNotifier extends _$MockAuthStateNotifier implements AuthStateNotifer {
  @override
  AuthState build() {
    return AuthState.authenticated(user: MockUser());
  }

  @override
  void checkIfLoggedIn() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
