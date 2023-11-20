import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/enums/round_status.dart';
import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/actions_dialog.dart';
import 'package:regatta_buddy/modals/actions_dialog.dart' as actions_dialog;
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/models/message.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/pages/race/messages_list.dart';
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';
import 'package:regatta_buddy/pages/race/participant/race_statistics.dart';
import 'package:regatta_buddy/pages/regatta_details.dart';
import 'package:regatta_buddy/providers/race_events.dart';
import 'package:regatta_buddy/services/event_message_handler.dart';
import 'package:regatta_buddy/services/event_message_sender.dart';
import 'package:regatta_buddy/services/locator.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/utils/timer.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/custom_error.dart';
import 'package:regatta_buddy/widgets/rb_notification.dart';

import '../../home.dart';

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
  bool isError = false;
  String errorMessage = "";
  List<RBNotification> activeNotifications = [];
  List<Message> messages = [];
  late final Timer timer;
  int round = 0;

  final databaseReference = FirebaseDatabase.instance.ref();
  bool eventStarted = false;

  @override
  void initState() {
    super.initState();
    timer = Timer();
    messages = [];

    locator = LocationSender((error) => setState(() {
          errorMessage = error;
          isError = true;
        }));
  }

  @override
  void didChangeDependencies() {
    final args =
        ModalRoute.of(context)!.settings.arguments as RacePageArguments;
    event = args.event;
    team = args.team;
    widget.logger.d("Current team: ${team.name} in event: ${event.name}");

    messageHandler = EventMessageHandler(
      eventId: event.id,
      teamId: team.id,
      onStartEventMessage: onStartEventMessage,
      onRoundStartedMessage: onRoundStartedMessage,
      onRoundFinishedMessage: onRoundFinishedMessage,
      onDirectedTextMessage: onDirectedTextMessage,
      onPointsAssignedMessage: onPointsAssignedMessage,
      onEndEventMessage: onEndEventMessage,
      onReportedProblemMessage: saveMessage,
      onProtestMessage: saveMessage,
      onRequestedHelpMessage: saveMessage,
    )..start();
    super.didChangeDependencies();
  }

  void onStartEventMessage(Message message) {
    saveMessageInMemory(message);
    setState(() {
      eventStarted = true;
    });
  }

  void onRoundFinishedMessage(Message message) {
    locator?.stop();
    ref.read(currentRoundStatusProvider.notifier).set(RoundStatus.finished);
    saveMessageInMemory(message);
    showDialogIfNewMessage(message);
    timer.stop();
  }

  void saveMessage(Message message) {
    message = populateMessageWithTeamName(message);
    saveMessageInMemory(message);
  }

  void onRoundStartedMessage(Message message) {
    widget.logger.i("Round started: $round in event: ${event.name}");
    setState(() {
      round = int.parse(message.value!);
    });
    locator?.round = round;
    locator?.start(event.id, team.id);
    ref.read(currentRoundProvider(event.id).notifier).set(round);
    ref.read(currentRoundStatusProvider.notifier).set(RoundStatus.started);
    timer.startFrom(message.convertedTimestamp);
    saveMessageInMemory(message);
    showDialogIfNewMessage(message);
  }

  void onEndEventMessage(Message message) {
    saveMessageInMemory(message);

    Future.delayed(
        const Duration(seconds: 5),
            () => Navigator.of(context).pushNamedAndRemoveUntil(
              RegattaDetailsPage.route,
              ModalRoute.withName(HomePage.route),
              arguments: event,
            ));
  }

  void onDirectedTextMessage(Message message) {
    saveMessageInMemory(message);
    widget.logger.d("Direct message received: ${message.value}");
  }

  void onPointsAssignedMessage(Message message) {
    widget.logger.d("Points assigned message received: ${message.value}");
    message = populateMessageWithTeamName(message);
    setState(() {
      if (!messages.contains(message)) {
        messages.add(message);
      }
    });

    if (happenedMomentAgo(message.convertedTimestamp)) {
      showDisappearingMessageDialog(
        context,
        message,
        customTitle: "Points assigned to your team",
      );
    }
  }

  Message populateMessageWithTeamName(Message message) {
    if (message.teamId == team.id) message.teamName = team.name;
    return message;
  }

  @override
  void dispose() {
    locator?.stop();
    messageHandler?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () => showActionsDialog(context),
        child: const Icon(Icons.warning_amber_rounded, size: 35),
      ),
      appBar: const AppHeader.hideAllButtons(),
      body: !isError
          ? Column(
              children: [
                RaceStatistics(eventId: event.id, timer: timer),
                MessagesList(messages: messages),
              ],
            )
          : CustomErrorWidget(errorMessage),
    );
  }

  Future<void> showActionsDialog(BuildContext context) {
    List<ActionButton> raceActions = [
      ActionButton(
        iconData: Icons.help_outline,
        title: "Needs help",
        onTap: () => {EventMessageSender.requestHelp(event.id, team.id)},
      ),
      ActionButton(
        iconData: Icons.sports_kabaddi,
        title: "Protest",
        onTap: () => showProtestDialog(context, event.id, team.id)
      ),
      ActionButton(
          iconData: Icons.medical_services_outlined,
          title: "Problem",
          onTap: () => showReportProblemDialog(context, event.id, team.id)),
      ActionButton(
        iconData: Icons.close_outlined,
        title: "Cancel",
        onTap: () => {},
      ),
    ];

    return actions_dialog.showActionsDialog(context, raceActions);
  }

  void showDialogIfNewMessage(Message message) {
    if (happenedMomentAgo(message.convertedTimestamp)) {
      showDisappearingMessageDialog(
        context,
        message,
      );
    }
  }

  void saveMessageInMemory(Message message) {
    setState(() {
      if (!messages.contains(message)) messages.add(message);
    });
  }

  bool happenedMomentAgo(DateTime dateTime) {
    return dateTime.difference(DateTime.now()).inSeconds.abs() < 10;
  }
}
