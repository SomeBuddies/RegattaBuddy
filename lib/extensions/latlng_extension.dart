import 'package:latlong2/latlong.dart';

extension LatLngExtension on LatLng {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
