import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_buddy/extensions/string_extension.dart';
import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/actions_dialog.dart' as actions_dialog;
import 'package:regatta_buddy/modals/actions_dialog.dart';
import 'package:regatta_buddy/pages/race/moderator/event_statistics.dart';
import 'package:regatta_buddy/pages/race/moderator/race_map.dart';
import 'package:regatta_buddy/providers/race_events.dart';
import 'package:regatta_buddy/utils/data_processing_helper.dart' as data_helper;
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/rb_notification.dart';
import 'package:uuid/uuid.dart';

import '../../../services/event_message_sender.dart';

class RaceModeratorPage extends ConsumerStatefulWidget {
  final logger = getLogger('RaceModeratorPage');

  static const String route = '/raceModerator';

  RaceModeratorPage({super.key});

  @override
  ConsumerState<RaceModeratorPage> createState() => _RaceModeratorPageState();
}

class _RaceModeratorPageState extends ConsumerState<RaceModeratorPage> {
  final int _notificationTimeInSeconds = 10;
  late final String eventId;
  List<RBNotification> activeNotifications = [];
  List<ActionButton> raceActions = [];
  int round = 1;
  Map<String, int> processedScores = {};
  final MapController mapController = MapController();
  Set<String> trackedTeams = {};

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
  void didChangeDependencies() {
    eventId = ModalRoute.of(context)?.settings.arguments as String;
    super.didChangeDependencies();
  }

  addPointsHandler(List<String> teams) async {
    await showSelectWithInputDialog(context, teams, eventId, round);
  }

  @override
  Widget build(BuildContext context) {
    final teamScores = ref.watch(teamScoresProvider(eventId));
    // todo do something with below
    // ignore: unused_local_variable
    Map<String, LatLng> teamPositions = ref.watch(teamPositionProvider(eventId));
    final currentRound = ref.watch(currentRoundProvider(event.id));

    return Scaffold(
      appBar: const AppHeader(),
      body: Column(
        children: [
          Flexible(
            child: Stack(children: [
              Column(
                children: [
                  EventStatistics(eventId: event.id,),
                  SizedBox(
                    height: 300,
                    child: RaceMap(
                      mapController: mapController,
                      eventId: eventId,
                    ),
                  ),
                  Expanded(
                    child: teamScores.when(
                      data: (data) {
                        processedScores = data_helper.processScoresData(data);
                        if (processedScores.isNotEmpty) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              final teamId =
                                  processedScores.keys.elementAt(index);
                              return ListTile(
                                dense: true,
                                leading: IconButton(
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
                                trailing: Wrap(
                                  spacing: 12,
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(Icons.my_location),
                                      onPressed: () {
                                        if (teamPositions[teamId] != null) {
                                          mapController.move(teamPositions[teamId]!,
                                              mapController.zoom);
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
                                          trackedTeams.contains(teamId) ? trackedTeams.remove(teamId) : trackedTeams.add(teamId);
                                          ref.read(currentlyTrackedTeamsProvider.notifier).set(trackedTeams);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                title: Text("Team ${index + 1} : $teamId"),
                                subtitle:
                                    Text('Points: ${processedScores[teamId]}'),
                              );
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
        onPressed: () => actions_dialog.showActionsDialog(context, [
          ActionButton(
            iconData: Icons.start,
            title: "Start event",
            onTap: () {
              EventMessageSender.startEvent(eventId);
            },
          ),
          ActionButton(
              iconData: Icons.control_point,
              title: "Add points",
              onTap: () => addPointsHandler(processedScores.keys.toList())),
          ActionButton(
            iconData: Icons.question_answer,
            title: "Send message",
            onTap: () => addNotification("Protest started"),
          ),
          ActionButton(
            iconData: Icons.format_list_bulleted_outlined,
            title: "Show events",
            onTap: () => addNotification("Judge was notified"),
          ),
          ActionButton(
            iconData: Icons.close_outlined,
            title: "Cancel",
            onTap: () => {},
          ),
        ]),
        child: const Icon(Icons.add, size: 35),
      ),
    );
  }
}
