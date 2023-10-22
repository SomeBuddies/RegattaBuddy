import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/actions_dialog.dart' as actions_dialog;
import 'package:regatta_buddy/modals/actions_dialog.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/pages/race/moderator/event_statistics.dart';
import 'package:regatta_buddy/pages/race/moderator/race_map.dart';
import 'package:regatta_buddy/providers/race_events.dart';
import 'package:regatta_buddy/utils/data_processing_helper.dart' as data_helper;
import 'package:regatta_buddy/utils/drawing_utils.dart' as drawing_utils;
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/rb_notification.dart';
import 'package:uuid/uuid.dart';

class RaceModeratorPage extends ConsumerStatefulWidget {
  final logger = getLogger('RaceModeratorPage');

  static const String route = '/raceModerator';

  RaceModeratorPage({super.key});

  @override
  ConsumerState<RaceModeratorPage> createState() => _RaceModeratorPageState();
}

class _RaceModeratorPageState extends ConsumerState<RaceModeratorPage> {
  final int _notificationTimeInSeconds = 10;
  late final Event event;
  List<RBNotification> activeNotifications = [];
  List<ActionButton> raceActions = [];
  int round = 1;
  Map<String, int> processedScores = {};
  final MapController mapController = MapController();

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
    // Event event = ModalRoute.of(context)?.settings.arguments as Event;
    // widget.logger.i('initializing RaceModeratorPage with eventId: ${event.id}');

    // todo: remove this mock after implementing participant position tracking
    widget.logger.w('TEMPORARILY HARDCODED EVENT WITH ID: uniqueEventID');
    Event mockedEvent = Event(
        id: 'uniqueEventID',
        hostId: 'hostId',
        route: [],
        location: const LatLng(0, 0),
        date: DateTime.now(),
        name: 'name',
        description: 'desc');

    setState(() {
      event = mockedEvent;
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    raceActions = [
      ActionButton(iconData: Icons.control_point, title: "Add points", onTap: addPointsHandler),
      ActionButton(
        iconData: Icons.question_answer,
        title: "Send message",
        onTap: () => addNotification("NOT IMPLEMENTED"),
      ),
      ActionButton(
        iconData: Icons.format_list_bulleted_outlined,
        title: "Show events",
        onTap: () => {
          ref.read(currentRoundProvider.notifier).increment(),
        },
      ),
      ActionButton(
        iconData: Icons.close_outlined,
        title: "Cancel",
        onTap: () => {},
      ),
    ];
  }

  addPointsHandler(List<String> teams) async {
    await showSelectWithInputDialog(context, teams, event.id, round);
  }

  @override
  Widget build(BuildContext context) {
    final teamScores = ref.watch(teamScoresProvider(event.id));
    // ignore: unused_local_variable
    final currentRound = ref.watch(currentRoundProvider);
    Map<String, LatLng> teamPositions = ref.watch(teamPositionProvider);

    return Scaffold(
      appBar: const AppHeader(),
      body: Column(
        children: [
          Flexible(
            child: Stack(children: [
              Column(
                children: [
                  EventStatistics(),
                  SizedBox(
                    height: 300,
                    child: RaceMap(mapController: mapController),
                  ),
                  Expanded(
                    // height: 200,
                    child: teamScores.when(
                      data: (data) {
                        processedScores = data_helper.processScoresData(data);
                        if (processedScores.isNotEmpty) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              final teamId = processedScores.keys.elementAt(index);
                              return ListTile(
                                dense: true,
                                leading: IconButton(
                                  icon: const Icon(Icons.sailing, shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                    ),
                                  ]),
                                  color: drawing_utils.getColorForString(teamId),
                                  iconSize: 40.0,
                                  onPressed: () {},
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.my_location),
                                  onPressed: () {
                                    if (teamPositions[teamId] != null) {
                                      mapController.move(
                                          teamPositions[teamId]!, mapController.zoom);
                                    } else {
                                      widget.logger.w(
                                          'Team $teamId has no position data | PROBABLY IT IS MOCKED');
                                    }
                                  },
                                ),
                                title: Text("Team ${index + 1} : $teamId"),
                                subtitle: Text('Points: ${processedScores[teamId]}'),
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
