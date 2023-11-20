import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_provider.g.dart';

@riverpod
FutureOr<Event> event(EventRef ref, String id) {
  return ref.watch(eventRepositoryProvider).getEvent(id);
}
