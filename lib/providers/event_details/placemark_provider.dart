import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'placemark_provider.g.dart';

@riverpod
FutureOr<List<Placemark>> placemark(PlacemarkRef ref, LatLng location) {
  return placemarkFromCoordinates(
    location.latitude,
    location.longitude,
  );
}
