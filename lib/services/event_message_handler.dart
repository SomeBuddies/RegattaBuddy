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

  bool _isReferee() {
    return teamId == null;
  }

  void start() {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference messRef =
        databaseReference.child('messages').child(eventId);

    messageStream = messRef.onChildAdded.listen((event) {
      final messageData = Map<String, String>.from(
          event.snapshot.value as Map<Object?, Object?>);
      final message = Message.fromJson(messageData);
      print(message);

      if (message.receiverType == MessageReceiverType.all ||
          (message.receiverType == MessageReceiverType.team &&
              message.teamId == teamId)) {
        if (message.type == MessageType.startEvent) {
          onStartEventMessage?.call(message);
        }
      }
    });
  }

  void stop() {
    messageStream?.cancel();
  }
}
