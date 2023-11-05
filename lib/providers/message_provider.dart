import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:regatta_buddy/models/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:regatta_buddy/providers/firebase_providers.dart';

part 'message_provider.g.dart';

@riverpod
Stream<Message> messages(MessagesRef ref, String eventId) {
  final dbRef = ref.watch(firebaseDbProvider).child('messages').child(eventId);

  final controller = StreamController<Message>();

  final subscription = dbRef.onValue.listen((DatabaseEvent event) {
    final data = event.snapshot.value as Map<String, String>;
    Message message = Message.fromJson(data);

    controller.add(message);
  });

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });
  return controller.stream;
}
