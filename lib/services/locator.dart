import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/constants.dart';

class LocationSender {
  void Function(String) setErrorMessage;
  StreamSubscription<Position>? positionStream;
  bool _isOn = false;

  int round = 0;

  LocationSender(this.setErrorMessage);

  Future<bool> _ensurePermissions() async {
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

    return Future.value(true);
  }

  void start(String eventId, String teamId) async {
    if (!_isOn) {
      await _ensurePermissions().catchError((error) {
        setErrorMessage(error);
        return false;
      });
      _isOn = true;
      positionStream =
          Geolocator.getPositionStream(locationSettings: kLocationSettings)
              .listen((Position? position) {
        if (position != null) {
          DatabaseReference teamReference = FirebaseDatabase.instance
              .ref()
              .child('traces')
              .child(eventId)
              .child(teamId);

          teamReference.update({
            'lastUpdate': position.timestamp.toString(),
            'lastPosition':
                '${position.latitude.toString()}, ${position.longitude.toString()}'
          });
          teamReference
              .child('positions')
              .child('rounds')
              .child(round.toString())
              .update({
            position.timestamp!.millisecondsSinceEpoch.toString():
                '${position.latitude.toString()}, ${position.longitude.toString()}',
          });
        }
      });
    }
  }

  void stop() {
    if (positionStream != null) positionStream!.cancel();
    _isOn = false;
  }
}
