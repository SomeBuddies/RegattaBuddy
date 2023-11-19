import 'package:regatta_buddy/models/user_data.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<UserData> userData(UserDataRef ref, String uid) async {
  final data = await ref.watch(userRepositoryProvider).getUserData(uid);
  return data.fold(
    (l) => throw Exception(l),
    (r) => r,
  );
}

@riverpod
FutureOr<UserData> CurrentUserData(CurrentUserDataRef ref) async {
  final data = await ref.watch(userRepositoryProvider).getCurrentUserData();
  return data.fold(
    (l) => throw Exception(l),
    (r) => r,
  );
}
