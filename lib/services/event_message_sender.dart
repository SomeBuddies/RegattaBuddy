import 'package:firebase_database/firebase_database.dart';
import 'package:regatta_buddy/models/message.dart';

class EventMessageSender {
  static void startEvent(String eventId) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.startEvent,
        receiverType: MessageReceiverType.all,
        timestamp: timestamp);

    newMessage.set(message.toJson());
  }

  static void endEvent(String eventId) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.endEvent,
        receiverType: MessageReceiverType.all,
        timestamp: timestamp);

    newMessage.set(message.toJson());
  }

  static void assignPoints(String eventId, String teamId, String roundPoints) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.pointsAssignment,
        receiverType: MessageReceiverType.team,
        teamId: teamId,
        value: roundPoints,
        timestamp: timestamp);

    newMessage.set(message.toJson());
  }

  static void sendDirectedTextMessage(String eventId, String teamId, String text) {
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

  static void startRound(String eventId, int round) {
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

  static void finishRound(String eventId, int round) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage = databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.roundFinished,
        receiverType: MessageReceiverType.all,
        value: round.toString(),
        timestamp: timestamp
    );

    newMessage.set(message.toJson());
  }

  static void requestHelp(String eventId, String teamId) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage = databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.requestHelp,
        receiverType: MessageReceiverType.referee,
        teamId: teamId,
        timestamp: timestamp
    );

    newMessage.set(message.toJson());
  }

  static void protest(String eventId, String teamId, String otherTeamId, String description ) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage = databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.protest,
        receiverType: MessageReceiverType.referee,
        teamId: teamId,
        value: otherTeamId,
        timestamp: timestamp
    );

    newMessage.set(message.toJson());
  }

  static void reportProblem(String eventId, String teamId, String problemDescription) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage = databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.reportProblem,
        receiverType: MessageReceiverType.referee,
        teamId: teamId,
        value: problemDescription,
        timestamp: timestamp
    );

    newMessage.set(message.toJson());
  }
}
