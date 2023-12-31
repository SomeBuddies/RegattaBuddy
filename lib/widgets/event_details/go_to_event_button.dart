import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/pages/race/moderator/race_moderator_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_to_event_button.g.dart';

@riverpod
FutureOr<Team?> getUserTeamController(
  GetUserTeamControllerRef ref, {
  required String? userId,
  required String eventId,
}) async {
  if (userId == null) return null;

  final teamId = await ref
      .watch(userRepositoryProvider)
      .getUserTeamId(userId: userId, eventId: eventId);

  if (teamId == null) return null;

  return await ref.watch(teamRepositoryProvider(eventId)).getTeam(teamId);
}

class GoToEventButton extends HookConsumerWidget {
  final Event event;

  const GoToEventButton(this.event, {super.key});

  bool isEventActive() {
    DateTime now = DateTime.now();
    return now.isAfter(
          event.date.subtract(const Duration(hours: 1)),
        ) &&
        now.isBefore(
          event.date.add(const Duration(days: 1)),
        ) &&
        event.status != EventStatus.finished;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    final asyncTeam = ref.watch(getUserTeamControllerProvider(
      userId: userId,
      eventId: event.id,
    ));

    return switch (asyncTeam) {
      AsyncData(value: final team)
          when (userId == event.hostId || team != null) && isEventActive() =>
        ElevatedButton(
          onPressed: () async {
            if (team == null) {
              ref.watch(teamRepositoryProvider(event.id)).initRealtime();

              Navigator.of(context).pushNamedAndRemoveUntil(
                RaceModeratorPage.route,
                ModalRoute.withName(HomePage.route),
                arguments: event,
              );
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                RacePage.route,
                ModalRoute.withName(HomePage.route),
                arguments: RacePageArguments(event, team),
              );
            }
          },
          child: const SizedBox(
            width: double.infinity,
            child: Center(child: Text("Uruchom wydarzenie")),
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
