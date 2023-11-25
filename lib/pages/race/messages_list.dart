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
        reverse: true,
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

    final date = DateTime.fromMillisecondsSinceEpoch(
      int.parse(message.timestamp),
    );
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
            '${assignment.points} points assigned in round ${assignment.round} to ${message.teamName ?? message.teamId}',
          ),
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
      case MessageType.roundStarted:
        var titleText = "Round nr ${message.value!} started";
        if (message.value! == "0") {
          titleText = "Warmup started";
        }

        return ListTile(
          leading: const Icon(Icons.sports),
          title: Text(titleText),
          subtitle: Text(
            'Moderator at $formattedDate',
          ),
        );
      case MessageType.roundFinished:
        var titleText = "Round nr ${message.value!} finished";
        if (message.value! == "0") {
          titleText = "Warmup finished";
        }
        return ListTile(
          leading: const Icon(Icons.timer_sharp),
          title: Text(titleText),
          subtitle: Text(
            'Moderator at $formattedDate',
          ),
        );

      case MessageType.reportProblem:
        var titleText = "Problem reported";
        return ListTile(
          leading:
              const Icon(Icons.medical_services_outlined, color: Colors.red),
          title: Text(titleText),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(message.value!),
              const SizedBox(height: 5),
              Text(
                '${message.teamName ?? message.teamId} at $formattedDate',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );

      case MessageType.requestHelp:
        var titleText = "Help requested";
        return ListTile(
          leading: const Icon(Icons.help_outline, color: Colors.red),
          title: Text(titleText),
          subtitle: Text(
            '${message.teamName ?? message.teamId} at $formattedDate',
          ),
        );

      case MessageType.protest:
        var value = message.getTeamNameAndProtestDesc();
        var titleText = "Protest by ${message.teamName ?? message.teamId}";
        return ListTile(
          leading: const Icon(Icons.sports_kabaddi, color: Colors.red),
          title: Text(titleText),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text("other team: ${value.$1}"),
              const SizedBox(height: 5),
              Text(
                value.$2,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${message.teamName ?? message.teamId} at $formattedDate',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
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
