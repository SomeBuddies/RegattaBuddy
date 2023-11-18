import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/services/event_repository.dart';
import 'package:regatta_buddy/services/team_repository.dart';
import 'package:regatta_buddy/services/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@riverpod
EventRepository eventRepository(EventRepositoryRef ref) {
  return EventRepository(ref.watch(firebaseFirestoreProvider));
}

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository(ref);
}

@Riverpod(keepAlive: true)
TeamRepository teamRepository(TeamRepositoryRef ref, Event event) {
  return TeamRepository(
    ref,
    event: event,
  );
}
