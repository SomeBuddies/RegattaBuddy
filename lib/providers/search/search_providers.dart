import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';
import 'package:regatta_buddy/services/repositories/event_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:regatta_buddy/enums/sort_enums.dart';

part 'search_providers.g.dart';

@riverpod
class CurrentSortType extends _$CurrentSortType {
  @override
  SortType build() {
    return SortType.date;
  }

  void set(SortType type) {
    state = type;
  }
}

@riverpod
class CurrentSortOrder extends _$CurrentSortOrder {
  @override
  SortOrder build() {
    return SortOrder.ascending;
  }

  void set(SortOrder value) {
    state = value;
  }
}

@riverpod
class ShowPastEvents extends _$ShowPastEvents {
  @override
  bool build() {
    return false;
  }

  void set(bool value) {
    state = value;
  }
}

@riverpod
Future<List<Event>> firestoreEvents(FirestoreEventsRef ref,
    {String? userId}) async {
  final bool showPastEvents = ref.watch(showPastEventsProvider);
  final EventRepository repo = ref.watch(eventRepositoryProvider);

  final Future<List<Event>> Function() getEvents = userId != null
      ? () async => showPastEvents
          ? await repo.getUserEvents(userId)
          : await repo.getFutureUserEvents(userId)
      : () async => showPastEvents
          ? await repo.getEvents()
          : await repo.getFutureEvents();

  return getEvents();
}

@riverpod
Future<List<Event>> eventList(
  EventListRef ref, {
  String? query,
  bool? isUserView,
}) async {
  final String? userId = isUserView == true
      ? ref.watch(firebaseAuthProvider).currentUser?.uid
      : null;
  final events =
      await ref.watch(firestoreEventsProvider(userId: userId).future);
  final sortType = ref.watch(currentSortTypeProvider);
  final sortOrder = ref.watch(currentSortOrderProvider);

  final filteredEvents = events
      .where(
        (event) =>
            query == null ||
            event.name.toLowerCase().contains(query) ||
            event.description.toLowerCase().contains(query),
      )
      .toList();

  return filteredEvents
    ..sort(
      (a, b) {
        int result = 0;
        switch (sortType) {
          case SortType.name:
            result = a.name.compareTo(b.name);
          case SortType.date:
            result = a.date.compareTo(b.date);
        }
        return sortOrder == SortOrder.ascending ? result : -result;
      },
    );
}
