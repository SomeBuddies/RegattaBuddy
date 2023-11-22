// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      route: (json['route'] as List<dynamic>)
          .map((e) =>
              const LatLngConverter().fromJson(e as Map<String, dynamic>))
          .toList(),
      location: const LatLngConverter()
          .fromJson(json['location'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$EventStatusEnumMap, json['status']) ??
          EventStatus.notStarted,
      hostId: json['hostId'] as String,
      date: DateTime.parse(json['date'] as String),
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'route': instance.route.map(const LatLngConverter().toJson).toList(),
      'location': const LatLngConverter().toJson(instance.location),
      'status': _$EventStatusEnumMap[instance.status]!,
      'hostId': instance.hostId,
      'date': instance.date.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
    };

const _$EventStatusEnumMap = {
  EventStatus.notStarted: 'notStarted',
  EventStatus.inProgress: 'inProgress',
  EventStatus.finished: 'finished',
};
