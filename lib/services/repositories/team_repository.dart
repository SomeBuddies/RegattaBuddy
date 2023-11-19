import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as realtime_db;
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/extensions/transaction_extension.dart';

import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/providers/event_details/teams_provider.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';
import 'package:regatta_buddy/services/repositories/user_repository.dart';

class TeamRepository {
  final Ref _ref;
  final Event event;
  //final Logger _logger = getLogger((TeamRepository).toString());

  TeamRepository(this._ref, {required this.event});

  FirebaseFirestore get _firestore => _ref.read(firebaseFirestoreProvider);
  realtime_db.DatabaseReference get _realtime =>
      _ref.read(firebaseRealtimeProvider);
  UserRepository get _userRepo => _ref.read(userRepositoryProvider);

  CollectionReference<Map<String, dynamic>> get colRef =>
      _firestore.collection('events/${event.id}/teams');

  Future<String> addTeam(Team team, {Transaction? transaction}) async {
    final docRef = await transaction.maybeAdd(colRef, team.toJson());
    return docRef.id;
  }

  void updateTeam(String teamId, Team team, {Transaction? transaction}) {
    final docRef = colRef.doc(teamId);

    transaction.maybeUpdate(docRef, team.toJson());
  }

  void deleteTeam(String teamId, {Transaction? transaction}) {
    final docRef = colRef.doc(teamId);

    transaction.maybeDelete(docRef);
  }

  Future<Team> getTeam(String id, {Transaction? transaction}) async {
    final docRef = colRef.doc(id);

    final doc = await transaction.maybeGet(docRef);
    return Team.fromDocument(doc);
  }

  Future<List<Team>> getTeams() async {
    final query = await colRef.get();
    return query.docs.map((e) => Team.fromDocument(e)).toList();
  }

  /// Creates a team with a set name with creating user as team captain.
  /// Function fails is user is already in a team or is the event host.
  /// Note that we do not sanitise the team name in any way.
  Future<Either<String, Unit>> createTeamFromName(String name) async {
    final user = await _userRepo.getCurrentUserData();

    return user.fold(
      (error) => left(error),
      (user) async {
        if (event.hostId == user.uid) {
          return left("Cannot participate as event host.");
        }

        return await _firestore.runTransaction((transaction) async {
          if (await _userRepo.isUserInEvent(
            userId: user.uid,
            eventId: event.id,
            transaction: transaction,
          )) {
            return left("User is already in a team.");
          }

          final teamId = await addTeam(
            Team(
              name: name,
              captainId: user.uid,
              members: [TeamMember(id: user.uid, name: user.firstName)],
            ),
            transaction: transaction,
          );

          _userRepo.addToJoinedEvents(
            userId: user.uid,
            eventId: event.id,
            teamId: teamId,
            transaction: transaction,
          );

          Future.delayed(
            const Duration(milliseconds: 100),
            () => _ref.invalidate(teamsProvider(event)),
          );
          return right(unit);
        });
      },
    );
  }

  /// Adds a user to a team as a team member.
  /// Function fails is user is already in a team or is the event host.
  Future<Either<String, Unit>> joinTeam(String teamId) async {
    final user = await _userRepo.getCurrentUserData();

    return user.fold(
      (error) => left(error),
      (user) async {
        if (event.hostId == user.uid) {
          return left("Cannot participate as event host.");
        }

        return await _firestore.runTransaction((transaction) async {
          if (await _userRepo.isUserInEvent(
            userId: user.uid,
            eventId: event.id,
            transaction: transaction,
          )) {
            return left("User is already in a team.");
          }

          // update the team

          // This step is a bit tricky because it implies any user has security access to the team.
          // Not really sure how to avoid it locally BUT we could use cloud function to update the team
          // on the backend maybe? (also we get to write about cloud functions as inżynierka padding)
          final team = await getTeam(teamId, transaction: transaction);
          updateTeam(
            teamId,
            team.copyWith(members: [
              ...team.members,
              TeamMember(id: user.uid, name: user.firstName),
            ]),
            transaction: transaction,
          );

          // update the user joined events list
          _userRepo.addToJoinedEvents(
            userId: user.uid,
            eventId: event.id,
            teamId: teamId,
            transaction: transaction,
          );

          Future.delayed(
            const Duration(milliseconds: 100),
            () => _ref.invalidate(teamsProvider(event)),
          );
          return right(unit);
        });
      },
    );
  }

  /// Removes a user from a team.
  /// Note it's not possible to leave a team as Team Captain.
  Future<Either<String, Unit>> leaveTeam(String teamId) async {
    final uid = _ref.read(firebaseAuthProvider).currentUser?.uid;

    if (uid == null) return left("User is not logged in.");

    return _firestore.runTransaction((transaction) async {
      final team = await getTeam(teamId, transaction: transaction);
      if (!team.members.map((e) => e.id).contains(uid)) {
        return left("User was not in the team.");
      }
      if (team.captainId == uid) {
        return left("Team captain can't leave their own team.");
      }

      updateTeam(
        teamId,
        team.copyWith(
            members: [...team.members]
              ..removeWhere((element) => element.id == uid)),
        transaction: transaction,
      );
      _userRepo.removeFromJoinedEvents(
        userId: uid,
        eventId: event.id,
        transaction: transaction,
      );

      Future.delayed(
        const Duration(milliseconds: 100),
        () => _ref.invalidate(teamsProvider(event)),
      );
      return right(unit);
    });
  }

  Future<Either<String, Unit>> disbandTeam(String teamId) async {
    final uid = _ref.read(firebaseAuthProvider).currentUser?.uid;

    if (uid == null) return left("User is not logged in.");

    return _firestore.runTransaction((transaction) async {
      final team = await getTeam(teamId);
      if (team.captainId != uid) return left("User is not team captain.");

      deleteTeam(teamId, transaction: transaction);

      // todo: use a cloud function here maybe?
      // maybe you can make a security rule that lets team captain change which
      // event user can participate in but that sounds difficult
      // would be easier to just handle this in the backend
      for (TeamMember member in team.members) {
        _userRepo.removeFromJoinedEvents(
          userId: member.id,
          eventId: event.id,
          transaction: transaction,
        );
      }

      Future.delayed(
        const Duration(milliseconds: 100),
        () => _ref.invalidate(teamsProvider(event)),
      );
      return right(unit);
    });
  }

  // todo: move out of this repo
  Future<void> initRealtime() async {
    final teams = await getTeams();

    for (Team team in teams) {
      await _realtime
          .child("scores/${event.id}/${team.id}/0")
          .set({"score": 0});
    }
  }
}
