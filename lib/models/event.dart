// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  const Event._();

  const factory Event({
    @JsonKey(includeFromJson: false, includeToJson: false) @Default('') String id,
    required String hostId,
    @LatLngConverter() required List<LatLng> route,
    @LatLngConverter() required LatLng location,
    required DateTime date,
    required String name,
    required String description,
  }) = _Event;

  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);

  factory Event.fromDocument(DocumentSnapshot doc) {
    if (doc.data() == null) throw Exception("Document data was null");

    return Event.fromJson(doc.data() as Map<String, Object?>).copyWith(id: doc.id);
  }
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
