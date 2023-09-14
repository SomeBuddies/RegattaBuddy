// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String hostId,
    @LatLngConverter() required List<LatLng> route,
    @LatLngConverter() required LatLng location,
    required DateTime date,
    required String name,
    required String description,
  }) = _Event;

  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);
}

// Because LatLng is a custom class it needs to have its own JsonConverter
// (even though it does have it's own converter and I'm just redirecting the call,
// the code generator doesn't know it's there)
class LatLngConverter implements JsonConverter<LatLng, Map<String, dynamic>> {
  const LatLngConverter();

  @override
  LatLng fromJson(Map<String, dynamic> json) {
    return LatLng.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(LatLng latlng) => latlng.toJson();
}

// class Event {
//   final String hostId;
//   final List<LatLng> route;
//   final LatLng location;
//   final DateTime date;
//   final String name;
//   final String description;

//   Event({
//     required this.hostId,
//     required this.route,
//     required this.location,
//     required this.date,
//     required this.name,
//     required this.description,
//   });

//   Event copyWith({
//     String? hostId,
//     List<LatLng>? route,
//     LatLng? location,
//     DateTime? date,
//     String? name,
//     String? description,
//   }) {
//     return Event(
//       hostId: hostId ?? this.hostId,
//       route: route ?? this.route,
//       location: location ?? this.location,
//       date: date ?? this.date,
//       name: name ?? this.name,
//       description: description ?? this.description,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'hostId': hostId,
//       'route': route.map((x) => x.toJson()).toList(),
//       'location': location.toJson(),
//       'date': date.millisecondsSinceEpoch,
//       'name': name,
//       'description': description,
//     };
//   }

//   factory Event.fromMap(Map<String, dynamic> map) {
//     // LatLng.fromJson zwraca Map<String, dynamic> a nie json encoded String
//     return Event(
//       hostId: map['hostId'] as String,
//       route: List<LatLng>.from(
//         (map['route'] as List<dynamic>).map<LatLng>(
//           (x) => LatLng.fromJson(x),
//         ),
//       ),
//       location: LatLng.fromJson(map['location']),
//       date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
//       name: map['name'] as String,
//       description: map['description'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Event.fromJson(String source) =>
//       Event.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'Event(hostId: $hostId, route: $route, location: $location, date: $date, name: $name, description: $description)';
//   }

//   @override
//   bool operator ==(covariant Event other) {
//     if (identical(this, other)) return true;

//     return other.hostId == hostId &&
//         listEquals(other.route, route) &&
//         other.location == location &&
//         other.date == date &&
//         other.name == name &&
//         other.description == description;
//   }

//   @override
//   int get hashCode {
//     return hostId.hashCode ^
//         route.hashCode ^
//         location.hashCode ^
//         date.hashCode ^
//         name.hashCode ^
//         description.hashCode;
//   }
// }
