// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Team _$$_TeamFromJson(Map<String, dynamic> json) => _$_Team(
      name: json['name'] as String,
      captainId: json['captainId'] as String,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_TeamToJson(_$_Team instance) => <String, dynamic>{
      'name': instance.name,
      'captainId': instance.captainId,
      'members': instance.members.map((e) => e.toJson()).toList(),
    };

_$_TeamMember _$$_TeamMemberFromJson(Map<String, dynamic> json) =>
    _$_TeamMember(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$_TeamMemberToJson(_$_TeamMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
