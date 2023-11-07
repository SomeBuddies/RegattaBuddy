import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../utils/constants.dart';

class Locator {
  void Function(String) setErrorMessage;
  StreamSubscription<Position>? positionStream;
  bool isOn = false;

  Locator(this.setErrorMessage);

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

  void start(void Function(Position) onLocation) async {
    await _ensurePermissions().catchError((error) {
      setErrorMessage(error);
      return false;
    });
    isOn = true;
    positionStream =
        Geolocator.getPositionStream(locationSettings: kLocationSettings)
            .listen((Position? position) {
      if (position != null) {
        onLocation(position);
      }
    });
  }

  void stop() {
    if (positionStream != null) positionStream!.cancel();
    isOn = false;
  }
}
