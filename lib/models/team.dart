import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'team.freezed.dart';
part 'team.g.dart';

@freezed
class Team with _$Team {
  const Team._();

  @JsonSerializable(explicitToJson: true)
  const factory Team({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required String name,
    required String captainId,
    @Default([]) List<TeamMember> members,
  }) = _Team;

  factory Team.fromJson(Map<String, Object?> json) => _$TeamFromJson(json);

  factory Team.fromDocument(DocumentSnapshot doc) {
    if (doc.data() == null) throw Exception("Document data was null");

    return Team.fromJson(doc.data() as Map<String, Object?>)
        .copyWith(id: doc.id);
  }
}

@freezed
class TeamMember with _$TeamMember {
  const TeamMember._();

  const factory TeamMember({
    required String id,
    required String name,
  }) = _TeamMember;

  factory TeamMember.fromJson(Map<String, Object?> json) =>
      _$TeamMemberFromJson(json);
}
