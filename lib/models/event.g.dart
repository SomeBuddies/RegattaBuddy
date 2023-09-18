// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Event _$$_EventFromJson(Map<String, dynamic> json) => _$_Event(
      hostId: json['hostId'] as String,
      route: (json['route'] as List<dynamic>)
          .map((e) =>
              const LatLngConverter().fromJson(e as Map<String, dynamic>))
          .toList(),
      location: const LatLngConverter()
          .fromJson(json['location'] as Map<String, dynamic>),
      date: DateTime.parse(json['date'] as String),
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$_EventToJson(_$_Event instance) => <String, dynamic>{
      'hostId': instance.hostId,
      'route': instance.route.map(const LatLngConverter().toJson).toList(),
      'location': const LatLngConverter().toJson(instance.location),
      'date': instance.date.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
    };
