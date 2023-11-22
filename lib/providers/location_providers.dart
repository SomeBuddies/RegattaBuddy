import 'package:regatta_buddy/services/location_sender.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_providers.g.dart';

@riverpod
LocationSender locationSender(
  LocationSenderRef ref,
  void Function(String) setErrorMessage,
) {
  return LocationSender(ref, setErrorMessage: setErrorMessage);
}

@riverpod
class LocationSpeed extends _$LocationSpeed {
  @override
  double build() {
    return 0.0;
  }

  set speed(double value) {
    state = value;
  }
}
