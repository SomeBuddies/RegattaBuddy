import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/providers/event_details/teams_provider.dart';
import 'package:regatta_buddy/providers/firebase_providers.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';
import 'package:regatta_buddy/providers/user_provider.dart';

// Local version so we don't call the database unless needed
bool isUserInEvent(String userId, List<Team> teams) {
  return teams.map((team) => team.members.contains(userId)).contains(true);
}

class EventTeamsDisplay extends ConsumerWidget {
  final Event event;

  const EventTeamsDisplay(this.event, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(teamsProvider(event));
    final userId = ref.read(firebaseAuthProvider).currentUser?.uid ?? "";

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(15.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: teams.when(
          data: (data) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.builder(
                  itemBuilder: (context, index) => TeamCard(
                    data[index],
                    event,
                    data,
                    context,
                    key: Key(data[index].id),
                  ),
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
              if (!isUserInEvent(userId, data)) CreateTeamButton(event),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text(error.toString()),
        ),
      ),
    );
  }
}

class CreateTeamButton extends HookConsumerWidget {
  final Event event;

  const CreateTeamButton(this.event, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final teamRepository = ref.read(teamRepositoryProvider(event));

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ScaffoldMessenger(
            child: Builder(builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: AlertDialog(
                  content: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: controller,
                      decoration:
                          const InputDecoration(hintText: "Enter a team name"),
                      validator: (value) {
                        if (value == null || value.characters.length < 3) {
                          return "Team name needs to be at least 3 characters";
                        }
                        return null;
                      },
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        final response = await teamRepository
                            .createTeamFromName(controller.text);
                        response.fold(
                          (error) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          ),
                          (success) => Navigator.of(context).pop(),
                        );
                      },
                      child: const Text("Submit"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel"),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
        ),
        child: const Text("Create a new team"),
      ),
    );
  }
}

class TeamCard extends ConsumerWidget {
  final Team team;
  final Event event;
  final List<Team> teams;
  final BuildContext parentContext;

  const TeamCard(this.team, this.event, this.teams, this.parentContext,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamRepository = ref.read(teamRepositoryProvider(event));
    final userId = ref.read(firebaseAuthProvider).currentUser?.uid ?? "";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  team.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (!isUserInEvent(userId, teams))
                  ElevatedButton(
                    onPressed: () async {
                      final response = await teamRepository.joinTeam(team.id);
                      response.fold(
                        (error) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error)),
                        ),
                        (success) => null,
                      );
                    },
                    child: const Text("Join Team"),
                  ),
              ],
            ),
            ListView.builder(
              itemBuilder: (context, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // todo: Add team member usernames to Team data class
                  // this is costing us a lot of reads just to check usernames
                  ref.watch(userDataProvider(team.members[index])).when(
                        data: (data) => Text(data.firstName),
                        error: (error, stackTrace) =>
                            const Text("Unknown User"),
                        loading: () => const CircularProgressIndicator(),
                      ),
                  if (userId == team.members[index] && userId != team.captainId)
                    ElevatedButton(
                      onPressed: () async {
                        final response =
                            await teamRepository.leaveTeam(team.id);
                        response.fold(
                          (error) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          ),
                          (success) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Left the team ${team.name}!")),
                          ),
                        );
                      },
                      child: const Text("Leave Team"),
                    ),
                  if (userId == team.members[index] && userId == team.captainId)
                    ElevatedButton(
                      onPressed: () async {
                        final response =
                            await teamRepository.disbandTeam(team.id);
                        response.fold(
                          (error) =>
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                            SnackBar(content: Text(error)),
                          ),
                          (success) =>
                              ScaffoldMessenger.of(parentContext).showSnackBar(
                            SnackBar(
                                content:
                                    Text("Deleted the team ${team.name}!")),
                          ),
                        );
                      },
                      child: const Text("Delete Team"),
                    ),
                ],
              ),
              itemCount: team.members.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }
}
