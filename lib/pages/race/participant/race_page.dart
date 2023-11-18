import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/actions_dialog.dart' as actions_dialog;
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/models/message.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/pages/race/messages_list.dart';
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';
import 'package:regatta_buddy/pages/race/participant/race_statistics.dart';
import 'package:regatta_buddy/pages/regatta_details.dart';
import 'package:regatta_buddy/services/event_message_handler.dart';
import 'package:regatta_buddy/services/locator.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/custom_error.dart';
import 'package:regatta_buddy/widgets/rb_notification.dart';

class RacePage extends ConsumerStatefulWidget {
  final logger = getLogger('RacePage');

  RacePage({super.key});

  static const String route = '/race';

  @override
  ConsumerState<RacePage> createState() => _RacePageState();
}

class _RacePageState extends ConsumerState<RacePage> {
  LocationSender? locator;
  EventMessageHandler? messageHandler;
  late final Event event;
  late final Team team;
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
    team = args.team;

    messageHandler = EventMessageHandler(
        eventId: event.id,
        teamId: team.id,
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
    if (eventStarted) locator?.start(event.id, team.id);

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
                MessagesList(messages: messages),
              ],
            )
          : CustomErrorWidget(errorMessage),
    );
  }
}
