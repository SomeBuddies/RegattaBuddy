import 'package:regatta_buddy/models/auth_state.dart';
import 'package:regatta_buddy/models/registration_data.dart';
import 'package:regatta_buddy/providers/auth/auth_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthStateNotifer extends _$AuthStateNotifer {
  @override
  AuthState build() {
    return const AuthState.initial();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();
    final response = await ref.watch(authServiceProvider).login(email: email, password: password);

    state = response.fold(
      (error) => AuthState.unauthenticated(message: error),
      (user) => AuthState.authenticated(user: user),
    );
  }

  Future<void> signup(RegistrationData registrationData) async {
    state = const AuthState.loading();
    final response = await ref.watch(authServiceProvider).signup(registrationData);
    state = response.fold(
      (error) => AuthState.unauthenticated(message: error),
      (user) => AuthState.authenticated(user: user),
    );
  }

  void checkIfLoggedIn() {
    final response = ref.watch(authServiceProvider).checkIfLoggedIn();
    state = response.fold(
      () => const AuthState.unauthenticated(message: "User not logged in"),
      (user) => AuthState.authenticated(user: user),
    );
  }

  Future<void> signout() async {
    await ref.watch(authServiceProvider).signout();

    //unironically I didn't want to deal with UserData changing to null while
    //leaving the profile page so I just added a delay.
    Future.delayed(const Duration(milliseconds: 500), () {
      ref.invalidateSelf();
    });
  }
}
