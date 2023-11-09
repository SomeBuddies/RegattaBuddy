import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/actions_dialog.dart' as actions_dialog;
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';
import 'package:regatta_buddy/pages/race/participant/race_statistics.dart';
import 'package:regatta_buddy/services/event_message_handler.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/custom_error.dart';
import 'package:regatta_buddy/widgets/rb_notification.dart';
import 'package:uuid/uuid.dart';

import '../../../models/message.dart';
import '../../../services/locator.dart';

class RacePage extends StatefulWidget {
  const RacePage({super.key});

  static const String route = '/race';

  @override
  State<RacePage> createState() => _RacePageState();
}

class _RacePageState extends State<RacePage> {
  LocationSender? locator;
  EventMessageHandler? messageHandler;
  late final String eventId;
  late final String teamId;
  late StreamSubscription<Position> subscription;
  final int _notificationTimeInSeconds = 10;
  bool isError = false;
  String errorMessage = "";
  List<RBNotification> activeNotifications = [];
  List<ActionButton> raceActions = [];
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
    eventId = args.eventId;
    teamId = args.teamId;
    messageHandler = EventMessageHandler(
        eventId: eventId,
        teamId: teamId,
        onStartEventMessage: onStartEventMessage)
      ..start();
    super.didChangeDependencies();
  }

  void onStartEventMessage(Message message) {
    setState(() {
      eventStarted = true;
    });
  }

  @override
  void dispose() {
    locator?.stop();
    messageHandler?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (eventStarted && !locator!.isOn) locator?.start(eventId, teamId);

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
                Flexible(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 85,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: activeNotifications,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : CustomErrorWidget(errorMessage),
    );
  }
}
