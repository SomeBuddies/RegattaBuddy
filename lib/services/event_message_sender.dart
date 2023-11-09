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
}
