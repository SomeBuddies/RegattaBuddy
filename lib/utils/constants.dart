import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

const LatLng startingPosition = LatLng(54.372158, 18.638306);
const double startingZoom = 12;

const String attributionText = "OpenStreetMap contributors";

const double elementsBorderRadius = 20;
const LocationSettings kLocationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 5,
);
