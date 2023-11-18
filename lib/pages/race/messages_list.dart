
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:regatta_buddy/models/assigned_points_in_round.dart';
import 'package:regatta_buddy/models/message.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({
    super.key,
    required this.messages,
  });

  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return MessageListTile(message: messages[index]);
        },
      ),
    );
  }
}


class MessageListTile extends StatelessWidget {
  final Message message;

  const MessageListTile({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = "";

    final date =
    DateTime.fromMillisecondsSinceEpoch(int.parse(message.timestamp));
    formattedDate = DateFormat('HH:mm').format(date);

    switch (message.type) {
      case MessageType.startEvent:
        return ListTile(
          leading: const Icon(Icons.play_arrow),
          title: const Text('Event started'),
          subtitle: Text(
            'Moderator at $formattedDate',
          ),
        );
      case MessageType.directedTextMessage:
        return ListTile(
          leading: const Icon(Icons.message),
          title: Text(message.value!),
          subtitle: Text(
            '$formattedDate : ${message.value}',
          ),
        );
      case MessageType.pointsAssignment:
        AssignedPointsInRound assignment =
        AssignedPointsInRound.fromString(message.value!);

        return ListTile(
          leading: const Icon(Icons.score),
          title: Text(
              '${assignment.points} points assigned in ${assignment.round} round to ${message.teamId}'),
          subtitle: Text(
            'Moderator at $formattedDate',
          ),
        );
      case MessageType.endEvent:
        return ListTile(
          leading: const Icon(Icons.cancel_outlined),
          title: const Text('Event ended'),
          subtitle: Text(
            'Moderator at $formattedDate',
          ),
        );
      default:
        return ListTile(
          leading: const Icon(Icons.error),
          title: const Text('Unknown message type'),
          subtitle: Text(formattedDate),
        );
    }
  }
}