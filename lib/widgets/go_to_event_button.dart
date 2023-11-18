import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/pages/race/moderator/race_moderator_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_to_event_button.g.dart';

@riverpod
FutureOr<Team?> getUserTeamController(
    GetUserTeamControllerRef ref, Event event) async {
  final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;

  if (userId == null) return null;

  final teamId = await ref
      .watch(userRepositoryProvider)
      .getUserTeamId(userId: userId, eventId: event.id);

  if (teamId == null) return null;

  return await ref.watch(teamRepositoryProvider(event)).getTeam(teamId);
}

class GoToEventButton extends HookConsumerWidget {
  final Event event;

  const GoToEventButton(this.event, {super.key});

  bool isEventActive() {
    DateTime now = DateTime.now();
    return now.isAfter(event.date.subtract(const Duration(hours: 1))) &&
        now.isBefore(event.date.add(const Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    final asyncTeam = ref.watch(getUserTeamControllerProvider(event));

    return switch (asyncTeam) {
      AsyncData(value: final team)
          when (userId == event.hostId || team != null) && isEventActive() =>
        ElevatedButton(
          onPressed: () async {
            if (team == null) {
              ref.watch(teamRepositoryProvider(event)).initRealtime();

              Navigator.pushNamed(
                context,
                RaceModeratorPage.route,
                arguments: event,
              );
            } else {
              Navigator.pushNamed(
                context,
                RacePage.route,
                arguments: RacePageArguments(event, team),
              );
            }
          },
          child: const Text("Enter event"),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
