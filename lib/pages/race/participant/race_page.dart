import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/actions_dialog.dart' as actions_dialog;
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';
import 'package:regatta_buddy/pages/race/participant/race_statistics.dart';
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
  Locator? locator;
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

    locator = Locator((error) => setState(() {
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
    super.didChangeDependencies();
  }

  void onPosition(Position position) {
    DatabaseReference teamReference =
        databaseReference.child('traces').child(eventId).child(teamId);

    teamReference.update({
      'lastUpdate': position.timestamp.toString(),
      'lastPosition':
          '${position.latitude.toString()}, ${position.longitude.toString()}'
    });
    teamReference.child('positions').child('rounds').child('0').update({
      position.timestamp!.millisecondsSinceEpoch.toString():
          '${position.latitude.toString()}, ${position.longitude.toString()}',
    });
  }

  void onMessage(Message message) {
    if (message.receiverType == MessageReceiverType.all ||
        (message.receiverType == MessageReceiverType.team &&
            message.teamId == teamId)) {
      if (message.type == MessageType.startEvent) {
        setState(() {
          eventStarted = true;
        });
      }
    }
  }

  @override
  void dispose() {
    if (locator != null) locator!.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (eventStarted && !locator!.isOn) locator!.start(onPosition);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () => actions_dialog.showActionsDialog(context, raceActions),
        // onPressed: () => onMessage(Message(
        //     type: MessageType.startEvent,
        //     receiverType: MessageReceiverType.all)),
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
