import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_buddy/enums/event_status.dart';
import 'package:regatta_buddy/enums/round_status.dart';
import 'package:regatta_buddy/extensions/string_extension.dart';
import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/actions_dialog.dart' as actions_dialog;
import 'package:regatta_buddy/modals/actions_dialog.dart';
import 'package:regatta_buddy/models/message.dart';
import 'package:regatta_buddy/pages/race/moderator/event_statistics.dart';
import 'package:regatta_buddy/pages/race/moderator/race_map.dart';
import 'package:regatta_buddy/providers/event_details/team_position_notifier.dart';
import 'package:regatta_buddy/providers/race_events.dart';
import 'package:regatta_buddy/services/event_message_handler.dart';
import 'package:regatta_buddy/services/event_message_sender.dart';
import 'package:regatta_buddy/utils/data_processing_helper.dart' as data_helper;
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/utils/timer.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/rb_notification.dart';
import 'package:uuid/uuid.dart';

import '../../../models/event.dart';
import '../../../services/event_message_handler.dart';

class RaceModeratorPage extends ConsumerStatefulWidget {
  final logger = getLogger('RaceModeratorPage');

  static const String route = '/raceModerator';

  RaceModeratorPage({super.key});

  @override
  ConsumerState<RaceModeratorPage> createState() => _RaceModeratorPageState();
}

class _RaceModeratorPageState extends ConsumerState<RaceModeratorPage> {
  final int _notificationTimeInSeconds = 10;
  late Event event;
  final MapController mapController = MapController();
  late final Timer timer;

  final int NOTIFICATIONS_LIMIT = 3;
  final int _notificationTimeInSeconds = 10;
  List<RBNotification> activeNotifications = [];

  List<Message> messages = [];
  EventMessageHandler? messageHandler;
  Set<String> trackedTeams = {};

  bool eventStarted = false;
  EventMessageHandler? messageHandler;
  Map<String, int> processedScores = {};
  List<ActionButton> raceActions = [];
  EventStatus eventStatus = EventStatus.notStarted;
  RoundStatus roundStatus = RoundStatus.started;
  int round = 0;

  @override
  void didChangeDependencies() {
    event = ModalRoute.of(context)?.settings.arguments as Event;
    messageHandler = EventMessageHandler(
        eventId: event.id,
        teamId: null,
        onStartEventMessage: (_) => setState(() {
              eventStarted = true;
            }))
      ..start();

    messageHandler = EventMessageHandler(
      eventId: eventId,
      onEachNewMessage: onEachNewMessage,
      onStartEventMessage: onStartEventMessage,
      onStartEventMessage: (_) => setState(() {
          eventStarted = true;
        }),
      onRoundFinishedMessage: onRoundFinishedMessage,
      onRoundStartedMessage: onRoundStartedMessage,
    )..start();
    super.didChangeDependencies();
  }

  addPointsHandler(List<String> teams) async {
    await showSelectWithInputDialog(context, teams, event.id, round);
  }

  @override
  void initState() {
    timer = Timer();
    super.initState();
  }

  @override
  void dispose() {
    messageHandler?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamScores = ref.watch(teamScoresProvider(event.id));
    Map<String, LatLng> teamPositions =
        ref.watch(teamPositionNotifierProvider(event.id));

    return Scaffold(
      appBar: const AppHeader(),
      body: Column(
        children: [
          Flexible(
            child: Stack(children: [
              Column(
                children: [
                  EventStatistics(eventId: event.id, timer: timer),
                  SizedBox(
                    height: 300,
                    child: RaceMap(
                      mapController: mapController,
                      eventId: event.id,
                    ),
                  ),
                  Expanded(
                    child: teamScores.when(
                      data: (data) {
                        processedScores = data_helper.processScoresData(data);
                        if (processedScores.isNotEmpty) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 100),
                            itemBuilder: (context, index) {
                              final teamId =
                                  processedScores.keys.elementAt(index);
                              return getTeamStatsTile(
                                  teamId, teamPositions, index);
                            },
                            itemCount: processedScores.keys.length,
                          );
                        } else {
                          return const Center(
                            child: Text("No team scores yet"),
                          );
                        }
                      },
                      error: (error, stackTrace) => Center(
                        child: Text(error.toString()),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: activeNotifications,
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () => {
          showActionsDialog(context),
        },
        child: const Icon(Icons.add, size: 35),
      ),
    );
  }

  Future<void> showActionsDialog(BuildContext context) {

    List<ActionButton> raceActions = [];

    if (eventStatus == EventStatus.notStarted) {
      raceActions.add(ActionButton(
        iconData: Icons.start,
        title: "Start event",
        onTap: () {
          EventMessageSender.startEvent(eventId);
        },
      ));
    } else if (eventStatus == EventStatus.inProgress && roundStatus == RoundStatus.finished) {
      raceActions.add(ActionButton(
        iconData: Icons.sports,
        title: "Start round ${round + 1}",
        onTap: () {
          EventMessageSender.startRound(eventId, round + 1);
        },
      ));
    } else if (eventStatus == EventStatus.inProgress && roundStatus == RoundStatus.started) {
      raceActions.add(ActionButton(
        iconData: Icons.timer_sharp,
        title: "Finish round $round",
        onTap: () {
          EventMessageSender.finishRound(eventId, round);
        },
      ));
    }

    raceActions.addAll([
        ActionButton(
            iconData: Icons.control_point,
            title: "Add points",
            onTap: () => addPointsHandler(processedScores.keys.toList())),
        ActionButton(
          iconData: Icons.question_answer,
          title: "Send message",
          onTap: () => {
            EventMessageSender.sendDirectedTextMessage(eventId, 'teamX', "this is just a test message | :)"),
            addNotification("Message was sent")
          },
        ),
        ActionButton(
          iconData: Icons.format_list_bulleted_outlined,
          title: "Show events",
          onTap: () => {
            addNotification("Judge was notified"),
            setState(() {
              eventStatus = EventStatus.inProgress;
            })
          },
        ),
        ActionButton(
          iconData: Icons.close_outlined,
          title: "Cancel",
          onTap: () => {},
        ),
      ]);
    return actions_dialog.showActionsDialog(context, raceActions);
  }

  ActionButton? getRoundActionButton(EventStatus eventStatus, int round) {
    if (eventStatus == EventStatus.notStarted) {
      return ActionButton(
        iconData: Icons.start,
        title: "Start event",
        onTap: () {
          EventMessageSender.startEvent(eventId);
        },
      );
    }
    return null;
  }

  ListTile getTeamStatsTile(
      String teamId, Map<String, LatLng> teamPositions, int index) {
    return ListTile(
      dense: true,
      leading: Wrap(
          spacing: 0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(100, 0, 0, 0),
                  width: 1.0,
                ),
                color: (index == 0)
                    ? const Color.fromARGB(255, 255, 215, 0)
                    : (index == 1)
                        ? const Color.fromARGB(192, 192, 192, 192)
                        : (index == 2)
                            ? const Color.fromARGB(205, 127, 50, 50)
                            : null,
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.sailing, shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
                ),
              ]),
              color: teamId.toSeededColor(),
              iconSize: 40.0,
              onPressed: () {},
            ),
          ]),
      trailing: Wrap(
        spacing: 12,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (teamPositions[teamId] != null) {
                mapController.move(teamPositions[teamId]!, mapController.zoom);
              } else {
                widget.logger.w(
                    'Team $teamId has no position data | PROBABLY IT IS MOCKED');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.timeline),
            color: (trackedTeams.contains(teamId)) ? Colors.blue : Colors.grey,
            onPressed: () {
              setState(() {
                trackedTeams.contains(teamId)
                    ? trackedTeams.remove(teamId)
                    : trackedTeams.add(teamId);
                ref.read(currentlyTrackedTeamsProvider.notifier).set(trackedTeams);
              });
            },
          ),
        ],
      ),
      title: Text(teamId),
      subtitle: Text('Points: ${processedScores[teamId]}'),
    );
  }

  // Future<void> loadAllAvailableMessages() async {
  //   var allMessages = await EventMessageHandler.getAllMessages(eventId);
  //   setState(() {
  //     for (var message in allMessages) {
  //       if (!messages.contains(message)) messages.add(message);
  //     }
  //   });
  //
  //   setCurrentEventStateByMessages();
  // }

  void setCurrentEventStateByMessages() {
    for(var message in messages) {
      switch (message.type) {
        case MessageType.startEvent:
          if (eventStatus != EventStatus.finished) {
            setState(() {
              eventStatus = EventStatus.inProgress;
            });
          }
          break;
        case MessageType.eventFinished:
          setState(() {
            eventStatus = EventStatus.finished;
          });
          break;
        case MessageType.roundStarted:
          int roundNumber = int.parse(message.value!);
          if (roundNumber > round) {
            setState(() {
              round = roundNumber;
              roundStatus = RoundStatus.started;
            });
          }
          break;
        case MessageType.roundFinished:
          int roundNumber = int.parse(message.value!);
          if (roundNumber >= round) {
            setState(() {
              round = roundNumber;
              roundStatus = RoundStatus.finished;
            });
          }
          break;
        default:
          break;
      }

    }
    widget.logger.i('Current event status: $eventStatus');
    widget.logger.i('Current round status: $roundStatus');
    widget.logger.i('Current round: $round');

  }

  void onEachNewMessage(Message message) {
    setState(() {
      if (!messages.contains(message)) messages.add(message);
    });
  }

  void onStartEventMessage(Message message) {
    setState(() {
      eventStatus = EventStatus.inProgress;
      round = 0;
      ref.read(currentRoundProvider(eventId).notifier).set(round);
    });
  }

  void onFinishEventMessage(Message message) {
    setState(() {
      eventStatus = EventStatus.finished;
    });
  }

  void onRoundFinishedMessage(Message message) {
    setState(() {
      roundStatus = RoundStatus.finished;
    });
    addNotification("Round $round finished");
    timer.stop();
  }

  void onRoundStartedMessage(Message message) {
    setState(() {
      round = int.parse(message.value!);
      ref.read(currentRoundProvider(eventId).notifier).set(round);
      roundStatus = RoundStatus.started;
    });

    addNotification("Round $round started");
    timer.startFrom(message.convertedTimestamp);
  }

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
    if (activeNotifications.length > NOTIFICATIONS_LIMIT) {
      removeNotification(activeNotifications.first.uuid);
    }
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
}
