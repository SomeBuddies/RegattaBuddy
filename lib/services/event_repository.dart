import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regatta_buddy/models/event.dart';

class EventRepository {
  final FirebaseFirestore _firestore;

  EventRepository(this._firestore);

  void addEvent(Event event) {
    _firestore.collection('events').add(event.toJson());
  }

  Future<Event> getEvent(String id) async {
    // * This could be rewritten using AsyncValue if we want

    final doc = await _firestore.collection('events').doc(id).get();
    return Event.fromDocument(doc);
  }

  Future<List<Event>> getEvents() async {
    final query = await _firestore.collection('events').get();
    return query.docs.map((e) => Event.fromDocument(e)).toList();
  }

  Future<List<Event>> getFutureEvents() async {
    final query = await _firestore
        .collection('events')
        .where(
          "date",
          isGreaterThan: DateTime.timestamp().toIso8601String(),
        )
        .get();

    return query.docs.map((e) => Event.fromDocument(e)).toList();
  }
}
