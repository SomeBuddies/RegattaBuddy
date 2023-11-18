import 'package:firebase_database/firebase_database.dart';
import 'package:regatta_buddy/models/message.dart';

class EventMessageSender {
  static void startEvent(String eventId) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.startEvent, receiverType: MessageReceiverType.all);

    newMessage.set(message.toJson());
  }

  static void endEvent(String eventId) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference newMessage =
        databaseReference.child('messages').child(eventId).child(timestamp);

    Message message = Message(
        type: MessageType.endEvent, receiverType: MessageReceiverType.all);

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
        value: roundPoints);

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
        value: text
    );

    newMessage.set(message.toJson());
  }
}
