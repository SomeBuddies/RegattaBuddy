import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

extension LatLngBoundsExtension on LatLngBounds {
  ///Expands the bounds outward so that the original bounds are in the center
  ///For example calling expandBounds(2) will transform the object so that
  ///it's sides are twice as big
  void expandBounds(double ratio) {
    assert(ratio > 1);

    const Distance distance = Distance();
    final diagonal = distance.as(LengthUnit.Meter, southWest, northEast);
    final extension_dist = diagonal * (ratio - 1) / 2;

    final sw2 = distance.offset(
        southWest, extension_dist, distance.bearing(northEast, southWest));
    final ne2 = distance.offset(
        northEast, extension_dist, distance.bearing(southWest, northEast));

    extendBounds(LatLngBounds(sw2, ne2));
  }
}
