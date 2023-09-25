import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/services/event_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@riverpod
EventRepository eventRepository(EventRepositoryRef ref) {
  return EventRepository(ref.watch(firebaseFirestoreProvider));
}
