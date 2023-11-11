import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:regatta_buddy/models/event.dart';

class EventRepository {
  final FirebaseFirestore _firestore;
  final CollectionReference _events_collection;

  EventRepository(this._firestore)
      : _events_collection = _firestore.collection('events');

  void addEvent(Event event) {
    _events_collection.add(event.toJson());
  }

  Future<Event> getEvent(String id) async {
    final doc = await _events_collection.doc(id).get();
    return Event.fromDocument(doc);
  }

  Future<List<Event>> getEvents() async {
    final query = await _events_collection.get();
    return query.docs.map((e) => Event.fromDocument(e)).toList();
  }

  Future<List<String>> _getUserEventsIds(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('joinedEvents')
        .get();
    return snapshot.docs.map((e) => e.id).toList();
  }

  Future<List<Event>> getUserEvents(String userId) async {
    final List<String> eventIds = await _getUserEventsIds(userId);

    return await getEvents().then((events) =>
        events.filter((event) => eventIds.contains(event.id)).toList());
  }

  Future<List<Event>> getFutureEvents() async {
    final query = await _events_collection
        .where(
          "date",
          isGreaterThan: DateTime.timestamp().toIso8601String(),
        )
        .get();

    return query.docs.map((e) => Event.fromDocument(e)).toList();
  }

  Future<List<Event>> getFutureUserEvents(String userId) async {
    final List<String> eventIds = await _getUserEventsIds(userId);
    return await getFutureEvents().then((events) =>
        events.filter((event) => eventIds.contains(event.id)).toList());
  }
}
