import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/actions_dialog.dart' as actions_dialog;
import 'package:regatta_buddy/models/assigned_points_in_round.dart';
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';
import 'package:regatta_buddy/pages/race/participant/race_statistics.dart';
import 'package:regatta_buddy/services/event_message_handler.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/custom_error.dart';
import 'package:regatta_buddy/widgets/rb_notification.dart';
import 'package:uuid/uuid.dart';

import '../../../models/event.dart';
import '../../../models/message.dart';
import '../../../services/locator.dart';
import '../../regatta_details.dart';

class RacePage extends StatefulWidget {
  final logger = getLogger('RacePage');

  RacePage({super.key});

  static const String route = '/race';

  @override
  State<RacePage> createState() => _RacePageState();
}

class _RacePageState extends State<RacePage> {
  LocationSender? locator;
  EventMessageHandler? messageHandler;
  late Event event;
  late String teamId;
  late StreamSubscription<Position> subscription;
  final int _notificationTimeInSeconds = 10;
  bool isError = false;
  String errorMessage = "";
  List<RBNotification> activeNotifications = [];
  List<ActionButton> raceActions = [];
  List<Message> messages = [];

  final databaseReference = FirebaseDatabase.instance.ref();
  bool eventStarted = false;

  // todo check if it is possible to move notifications to separate file
  void addNotification(String title) {
    String uuid = const Uuid().v4();
    setState(() {
      activeNotifications.add(
        RBNotification(
          uuid: uuid,
          title: title,
          onClose: () => removeNotification(uuid),
        ),
      );
    });
    Future.delayed(
      Duration(seconds: _notificationTimeInSeconds),
      () => {removeNotification(uuid), setState(() {})},
    );
  }

  void removeNotification(String uuid) {
    setState(() {
      activeNotifications.removeWhere((element) => element.uuid == uuid);
    });
  }

  @override
  void initState() {
    super.initState();
    messages = [];

    locator = LocationSender((error) => setState(() {
          errorMessage = error;
          isError = true;
        }));
    raceActions = [
      ActionButton(
        iconData: Icons.help_outline,
        title: "Needs help",
        onTap: () => addNotification("Help requested"),
      ),
      ActionButton(
        iconData: Icons.sports_kabaddi,
        title: "Protest",
        onTap: () => addNotification("Protest started"),
      ),
      ActionButton(
        iconData: Icons.question_answer,
        title: "Problem",
        onTap: () => addNotification("Judge was notified"),
      ),
      ActionButton(
        iconData: Icons.close_outlined,
        title: "Cancel",
        onTap: () => {},
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    final args =
        ModalRoute.of(context)!.settings.arguments as RacePageArguments;
    event = args.event;
    teamId = args.teamId;

    messageHandler = EventMessageHandler(
        eventId: event.id,
        teamId: teamId,
        onEachNewMessage: onEachNewMessage,
        onStartEventMessage: onStartEventMessage,
        onDirectedTextMessage: onDirectedTextMessage,
        onPointsAssignedMessage: onPointsAssignedMessage,
        onEndEventMessage: onEndEventMessage)
      ..start();
    super.didChangeDependencies();
  }

  void onEachNewMessage(Message message) {
    setState(() {
      if (!messages.contains(message)) messages.add(message);
    });
  }

  void onStartEventMessage(Message message) {
    setState(() {
      if (!messages.contains(message)) messages.add(message);
      eventStarted = true;
    });
  }

  void onEndEventMessage(Message message) {
    setState(() {
      if (!messages.contains(message)) messages.add(message);
    });

    Future.delayed(
        const Duration(seconds: 5),
        () => Navigator.of(context).pushNamed(
              RegattaDetailsPage.route,
              arguments: event,
            ));
  }

  void onDirectedTextMessage(Message message) {
    setState(() {
      if (!messages.contains(message)) messages.add(message);
    });
    widget.logger.i("Direct message received: ${message.value}");
  }

  void onPointsAssignedMessage(Message message) {
    setState(() {
      if (!messages.contains(message)) messages.add(message);
    });
    widget.logger.i("Points assigned message received: ${message.value}");
  }

  @override
  void dispose() {
    locator?.stop();
    messageHandler?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (eventStarted) locator?.start(event.id, teamId);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () => actions_dialog.showActionsDialog(context, raceActions),
        child: const Icon(Icons.warning_amber_rounded, size: 35),
      ),
      appBar: const AppHeader(),
      body: !isError
          ? Column(
              children: [
                const RaceStatistics(),
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MessageListTile(message: messages[index]);
                    },
                  ),
                ),
              ],
            )
          : CustomErrorWidget(errorMessage),
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
