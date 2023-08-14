import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/actions_dialog.dart' as actions_dialog;
import 'package:regatta_buddy/pages/race/race_statistics.dart';
import 'package:regatta_buddy/utils/constants.dart' as constants;
import 'package:regatta_buddy/utils/externalAPIConstants.dart' as api_constants;
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/rb_notification.dart';
import 'package:uuid/uuid.dart';

class RacePage extends StatefulWidget {
  const RacePage({super.key});

  static const String route = '/race';

  @override
  State<RacePage> createState() => _RacePageState();
}

class _RacePageState extends State<RacePage> {
  final int _notificationTimeInSeconds = 10;
  List<RBNotification> activeNotifications = [];
  List<ActionButton> raceActions = [];

  void addNotification(String title) {
    String uuid = const Uuid().v4();
    activeNotifications.add(RBNotification(
        uuid: uuid, title: title, onClose: () => removeNotification(uuid)));
    Future.delayed(Duration(seconds: _notificationTimeInSeconds),
        () => {removeNotification(uuid), setState(() {})});
    setState(() {});
  }

  void removeNotification(String uuid) {
    activeNotifications.removeWhere((element) => element.uuid == uuid);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    raceActions = [
      ActionButton(
          iconData: Icons.help_outline,
          title: "Needs help",
          onTap: () => addNotification("Help requested")),
      ActionButton(
          iconData: Icons.sports_kabaddi,
          title: "Protest",
          onTap: () => addNotification("Protest started")),
      ActionButton(
          iconData: Icons.question_answer,
          title: "Problem",
          onTap: () => addNotification("Judge was notified")),
      ActionButton(
          iconData: Icons.close_outlined, title: "Cancel", onTap: () => {})
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: Column(
        children: [
          Flexible(
            child: Stack(children: [
              FlutterMap(
                mapController: MapController(),
                options: MapOptions(
                  center: constants.startingPosition,
                  zoom: constants.startingZoom,
                ),
                nonRotatedChildren: const [
                  SimpleAttributionWidget(
                    source: Text(constants.attributionText),
                  ),
                ],
                children: [
                  TileLayer(
                    urlTemplate: api_constants.tileLayerUrl,
                    userAgentPackageName: api_constants.tileLayerUserAgent,
                  ),
                  CurrentLocationLayer(),
                ],
              ),
              Positioned(
                bottom: 32,
                right: 32,
                child: SizedBox(
                    height: 60,
                    width: 60,
                    child: FloatingActionButton(
                      elevation: 10,
                      onPressed: () => actions_dialog.showActionsDialog(
                          context, raceActions),
                      child: const Icon(Icons.warning_amber_rounded, size: 35),
                    )),
              ),
              const Positioned(
                top: 0,
                child: RaceStatistics(),
              ),
              Positioned(
                  top: 85,
                  child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: activeNotifications,
                      )
                  )
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
