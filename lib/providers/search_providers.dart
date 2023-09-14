import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:regatta_buddy/enums/sort_enums.dart';

part 'search_providers.g.dart';

@riverpod
class CurrentSortType extends _$CurrentSortType {
  @override
  SortType build() {
    return SortType.name;
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
Future<List<Event>> firestoreEvents(FirestoreEventsRef ref) async {
  final bool showPastEvents = ref.watch(showPastEventsProvider);

  final query = await FirebaseFirestore.instance
      .collection('events')
      .where(
        "date",
        isGreaterThan: showPastEvents ? null : DateTime.timestamp().toIso8601String(),
      )
      .get();

  return query.docs.map((doc) => Event.fromJson(doc.data())).toList();
}

@riverpod
Future<List<Event>> eventList(EventListRef ref, {String? query}) async {
  final events = await ref.watch(firestoreEventsProvider.future);
  final sortType = ref.watch(currentSortTypeProvider);
  final sortOrder = ref.watch(currentSortOrderProvider);

  final filteredEvents = events
      .where(
        (element) =>
            query == null ||
            element.name.toLowerCase().contains(query) ||
            element.description.toLowerCase().contains(query),
      )
      .toList();

  return filteredEvents
    ..sort(
      (a, b) {
        int result = 0;
        switch (sortType) {
          case SortType.name:
            result = a.name.compareTo(b.name);
            break;
          case SortType.date:
            result = a.date.compareTo(b.date);
            break;
          // case SortType.location:
          //   result = 0; //dodam kiedyś
        }
        return sortOrder == SortOrder.ascending ? result : -result;
      },
    );
}