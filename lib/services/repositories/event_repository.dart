import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/extensions/transaction_extension.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';

class EventRepository {
  final Ref _ref;

  EventRepository(this._ref);

  FirebaseFirestore get _firestore => _ref.read(firebaseFirestoreProvider);
  CollectionReference<Map<String, dynamic>> get colRef =>
      _firestore.collection('events');

  Future<String> addEvent(Event event, {Transaction? transaction}) async {
    final docRef = await transaction.maybeAdd(colRef, event.toJson());
    return docRef.id;
  }

  void updateEvent(String eventId, Event event, {Transaction? transaction}) {
    final docRef = colRef.doc(eventId);

    transaction.maybeUpdate(docRef, event.toJson());
  }

  Future<Event> getEvent(String id) async {
    final doc = await colRef.doc(id).get();
    return Event.fromDocument(doc);
  }

  Future<List<Event>> getEvents() async {
    final query = await colRef.get();
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

    return await getEvents().then((events) => events
        .filter(
            (event) => event.hostId == userId || eventIds.contains(event.id))
        .toList());
  }

  Future<List<Event>> getFutureEvents() async {
    final query = await colRef
        .where(
          "date",
          isGreaterThan: DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
        )
        .get();

    return query.docs.map((e) => Event.fromDocument(e)).toList();
  }

  Future<List<Event>> getFutureUserEvents(String userId) async {
    final List<String> eventIds = await _getUserEventsIds(userId);
    return await getFutureEvents().then((events) => events
        .filter(
            (event) => event.hostId == userId || eventIds.contains(event.id))
        .toList());
  }
}
