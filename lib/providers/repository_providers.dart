import 'package:regatta_buddy/services/event_message_sender.dart';
import 'package:regatta_buddy/services/repositories/event_repository.dart';
import 'package:regatta_buddy/services/repositories/score_repository.dart';
import 'package:regatta_buddy/services/repositories/team_repository.dart';
import 'package:regatta_buddy/services/repositories/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@riverpod
EventRepository eventRepository(EventRepositoryRef ref) {
  return EventRepository(ref);
}

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository(ref);
}

@Riverpod(keepAlive: true)
TeamRepository teamRepository(TeamRepositoryRef ref, String eventId) {
  return TeamRepository(
    ref,
    eventId: eventId,
  );
}

@Riverpod(keepAlive: true)
ScoreRepository scoreRepository(ScoreRepositoryRef ref) {
  return ScoreRepository(ref);
}

@Riverpod(keepAlive: true)
EventMessageSender eventMessageSender(EventMessageSenderRef ref) {
  return EventMessageSender(ref);
}
