import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/pages/race/moderator/race_moderator_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_to_event_button.g.dart';

@riverpod
FutureOr<String?> getUserTeamIdController(
    GetUserTeamIdControllerRef ref, Event event) async {
  final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;

  if (userId == null) return null;

  return await ref
      .watch(userRepositoryProvider)
      .getUserTeamId(userId: userId, eventId: event.id);
}

class GoToEventButton extends HookConsumerWidget {
  final Event event;

  const GoToEventButton(this.event, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
    final asyncTeamId = ref.watch(getUserTeamIdControllerProvider(event));

    return switch (asyncTeamId) {
      AsyncData(value: final teamId)
          when userId == event.hostId || teamId != null =>
        ElevatedButton(
          onPressed: () {
            if (teamId == null) {
              Navigator.pushNamed(context, RaceModeratorPage.route,
                  arguments: event);
            } else {
              Navigator.pushNamed(context, RacePage.route,
                  arguments: RacePageArguments(event, teamId));
            }
          },
          child: const Text("Enter event"),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
