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

import '../../../utils/constants.dart';

class RacePage extends StatefulWidget {
  const RacePage({super.key});

  static const String route = '/race';

  @override
  State<RacePage> createState() => _RacePageState();
}

class _RacePageState extends State<RacePage> {
  late final String eventId;
  late final String teamId;
  late StreamSubscription<Position> subscription;
  final int _notificationTimeInSeconds = 10;
  bool isError = false;
  String errorMessage = "";
  List<RBNotification> activeNotifications = [];
  List<ActionButton> raceActions = [];
  final databaseReference = FirebaseDatabase.instance.ref();

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

  void onError(String errorMessage) => setState(() {
        isError = true;
        this.errorMessage = errorMessage;
      });

  @override
  void initState() {
    super.initState();

    ensureLocatorPermissions().then((_) {
      runGeolocator();
    }).catchError(
      (err) {
        onError(err);
      },
    );
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

  Future<String> ensureLocatorPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
          'Location services are disabled. Please enable them.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions. You can change that in your phone settings');
    }

    return Future.value("Required permissions are allowed");
  }

  void runGeolocator() {
    subscription =
        Geolocator.getPositionStream(locationSettings: kLocationSettings)
            .listen((Position? position) {
      if (position != null) {
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
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
