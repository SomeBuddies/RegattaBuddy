import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/models/message.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';

class EventMessageSender {
  final Ref _ref;

  EventMessageSender(this._ref);

  void startEvent(Event event) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(event.id).child(timestamp);

    Message message = Message(
        type: MessageType.startEvent,
        receiverType: MessageReceiverType.all,
        timestamp: timestamp);

    newMessage.set(message.toJson());

    _ref.read(eventRepositoryProvider).updateEvent(
          event.id,
          event.copyWith(status: EventStatus.inProgress),
        );
  }

  void endEvent(Event event) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(event.id).child(timestamp);

    Message message = Message(
        type: MessageType.endEvent,
        receiverType: MessageReceiverType.all,
        timestamp: timestamp);

    newMessage.set(message.toJson());

    _ref.read(eventRepositoryProvider).updateEvent(
          event.id,
          event.copyWith(status: EventStatus.finished),
        );
  }

  void assignPoints(Event event, Team team, String roundPoints) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(event.id).child(timestamp);

    Message message = Message(
        type: MessageType.pointsAssignment,
        receiverType: MessageReceiverType.team,
        teamId: team.id,
        value: roundPoints,
        timestamp: timestamp);

    newMessage.set(message.toJson());
  }

  void sendDirectedTextMessage(String eventId, String teamId, String text) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.directedTextMessage,
        receiverType: MessageReceiverType.team,
        teamId: teamId,
        value: text,
        timestamp: timestamp);

    newMessage.set(message.toJson());
  }

  void startRound(String eventId, int round) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.roundStarted,
        receiverType: MessageReceiverType.all,
        value: round.toString(),
        timestamp: timestamp);

    newMessage.set(message.toJson());
  }

  void finishRound(String eventId, int round) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.roundFinished,
        receiverType: MessageReceiverType.all,
        value: round.toString(),
        timestamp: timestamp);

    newMessage.set(message.toJson());
  }

  static void requestHelp(String eventId, String teamId) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.requestHelp,
        receiverType: MessageReceiverType.referee,
        teamId: teamId,
        timestamp: timestamp);

    newMessage.set(message.toJson());
  }

  static void protest(
      String eventId, String teamId, String otherTeamId, String description) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.protest,
        receiverType: MessageReceiverType.referee,
        teamId: teamId,
        value: otherTeamId,
        timestamp: timestamp);

    newMessage.set(message.toJson());
  }

  static void reportProblem(
      String eventId, String teamId, String problemDescription) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.reportProblem,
        receiverType: MessageReceiverType.referee,
        teamId: teamId,
        value: problemDescription,
        timestamp: timestamp);

    newMessage.set(message.toJson());
  }
}
