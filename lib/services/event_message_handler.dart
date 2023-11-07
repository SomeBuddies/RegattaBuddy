import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:regatta_buddy/models/message.dart';

class EventMessageHandler {
  final String eventId;
  final String? teamId;
  void Function(Message)? onStartEventMessage;
  StreamSubscription<DatabaseEvent>? messageStream;

  EventMessageHandler(
      {required this.eventId, this.teamId, this.onStartEventMessage});

  void start() {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference messRef =
        databaseReference.child('messages').child(eventId);

    messageStream = messRef.onChildAdded.listen((event) {
      final messageData = Map<String, String>.from(
          event.snapshot.value as Map<Object?, Object?>);
      final message = Message.fromJson(messageData);

      if (message.isForAll() || message.isForTeam(teamId)) {
        switch (message.type) {
          case MessageType.startEvent:
            onStartEventMessage?.call(message);
        }
      }
    });
  }

  void stop() {
    messageStream?.cancel();
  }
}
