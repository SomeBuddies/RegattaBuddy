import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:regatta_buddy/models/message.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';

class EventMessageHandler {
  final logger = getLogger('EventMessageHandler');
  final String eventId;
  final String? teamId;
  void Function(Message)? onEachNewMessage;
  void Function(Message)? onStartEventMessage;
  void Function(Message)? onDirectedTextMessage;
  void Function(Message)? onPointsAssignedMessage;
  void Function(Message)? onRoundStartedMessage;
  void Function(Message)? onRoundFinishedMessage;
  void Function(Message)? onEndEventMessage;
  void Function(Message)? onReportedProblemMessage;
  void Function(Message)? onRequestedHelpMessage;
  void Function(Message)? onProtestMessage;

  StreamSubscription<DatabaseEvent>? messageStream;

  EventMessageHandler({
    required this.eventId,
    this.teamId,
    this.onEachNewMessage,
    this.onStartEventMessage,
    this.onDirectedTextMessage,
    this.onPointsAssignedMessage,
    this.onRoundStartedMessage,
    this.onRoundFinishedMessage,
    this.onEndEventMessage,
    this.onReportedProblemMessage,
    this.onRequestedHelpMessage,
    this.onProtestMessage,
  });

  void start() {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference messRef =
        databaseReference.child('messages').child(eventId);

    messageStream = messRef.onChildAdded.listen((event) {
      final messageData = Map<String, String>.from(
        event.snapshot.value as Map<Object?, Object?>,
      );
      final message = Message.fromJson(messageData);

      onEachNewMessage?.call(message);
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
          case MessageType.roundStarted:
            onRoundStartedMessage?.call(message);
          case MessageType.roundFinished:
            onRoundFinishedMessage?.call(message);
          default:
        }
      }
      if (message.isForReferee(teamId) || isSendByThisInstance(message)) {
        switch (message.type) {
          case MessageType.reportProblem:
            onReportedProblemMessage?.call(message);
          case MessageType.protest:
            onProtestMessage?.call(message);
          case MessageType.requestHelp:
            onRequestedHelpMessage?.call(message);
          default:
        }
      }
    });
  }

  bool isSendByThisInstance(Message message) => message.teamId == teamId;

  void stop() {
    messageStream?.cancel();
  }
}
