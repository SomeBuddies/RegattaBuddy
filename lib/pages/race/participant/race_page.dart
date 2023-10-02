import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/actions_dialog.dart' as actions_dialog;
import 'package:regatta_buddy/pages/race/participant/race_statistics.dart';
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

  @override
  void initState() {
    super.initState();
    runGeolocator();
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

  void runGeolocator() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
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
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      if (position != null) {
        DatabaseReference teamReference = databaseReference
            .child('traces')
            .child('uniqueEventID')
            .child('teamX');

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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () => actions_dialog.showActionsDialog(context, raceActions),
        child: const Icon(Icons.warning_amber_rounded, size: 35),
      ),
      appBar: const AppHeader(),
      body: Column(
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
      ),
    );
  }
}
