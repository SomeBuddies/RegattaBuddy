import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:regatta_buddy/models/message.dart';

class EventMessageHandler {
  final String eventId;
  final String? teamId;
  void Function(Message)? onStartEventMessage;
  void Function(Message)? onDirectedTextMessage;
  void Function(Message)? onPointsAssignedMessage;
  void Function(Message)? onEndEventMessage;

  StreamSubscription<DatabaseEvent>? messageStream;

  EventMessageHandler(
      {required this.eventId,
      this.teamId,
      this.onStartEventMessage,
      this.onDirectedTextMessage,
      this.onPointsAssignedMessage,
      this.onEndEventMessage});

  void start() {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference messRef =
        databaseReference.child('messages').child(eventId);

    messageStream = messRef.onChildAdded.listen((event) {
      final messageData = Map<String, String>.from(
          event.snapshot.value as Map<Object?, Object?>);
      final message = Message.fromJson(messageData);

      if (message.isForAll() ||
          message.isForTeam(teamId) ||
          message.isForReferee(teamId)) {
        switch (message.type) {
          case MessageType.startEvent:
            onStartEventMessage?.call(message);
          case MessageType.directedTextMessage:
            if (message.isForTeam(teamId)) {
              onDirectedTextMessage?.call(message);
            }
          case MessageType.pointsAssignment:
            onPointsAssignedMessage?.call(message);
          case MessageType.endEvent:
            onEndEventMessage?.call(message);
        }
      }
    });
  }

  void stop() {
    messageStream?.cancel();
  }
}
