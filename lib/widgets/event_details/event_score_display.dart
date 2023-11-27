// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/extensions/string_extension.dart';

import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/providers/event_details/teams_provider.dart';
import 'package:regatta_buddy/providers/race_events.dart';
import 'package:regatta_buddy/utils/data_processing_helper.dart';
import 'package:regatta_buddy/widgets/core/basic_card.dart';

class EventScoreDisplay extends HookConsumerWidget {
  final Event event;
  const EventScoreDisplay(
    this.event, {
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamScores = ref.watch(teamScoresProvider(event));
    final eventTeams = ref.watch(teamsProvider(event));

    return BasicCard(
      child: switch ((eventTeams, teamScores)) {
        (AsyncData(value: final teams), AsyncData(value: final scores)) =>
          _EventScoreDisplay(teams: teams, scores: scores),
        (AsyncLoading(), _) || (_, AsyncLoading()) => const Center(
            child: CircularProgressIndicator(),
          ),
        (_, _) => const Center(
            child: Text(
                "Podczas ładowania wyników wystąpił nieoczekiwany problem"),
          ),
      },
    );
  }
}

class _EventScoreDisplay extends StatelessWidget {
  final List<Team> teams;
  final Map<String, List<int>> scores;

  const _EventScoreDisplay({
    required this.scores,
    required this.teams,
  });

  @override
  Widget build(BuildContext context) {
    final processedScores = processScoresData(scores, teams);

    if (processedScores.isNotEmpty) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final team = teams.firstWhere(
            (element) => element.id == processedScores.keys.elementAt(index),
          );
          final score = processedScores.values.elementAt(index);

          return TeamScoreTile(
            index: index,
            team: team,
            score: score,
          );
        },
        itemCount: processedScores.keys.length,
      );
    } else {
      return const Center(
        child: Text("Brak wyników drużyn"),
      );
    }
  }
}

class TeamScoreTile extends StatelessWidget {
  final int index;
  final int score;
  final Team team;

  const TeamScoreTile({
    required this.index,
    required this.score,
    required this.team,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Wrap(
          spacing: 0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(100, 0, 0, 0),
                  width: 1.0,
                ),
                color: (index == 0)
                    ? const Color.fromARGB(255, 255, 215, 0)
                    : (index == 1)
                        ? const Color.fromARGB(192, 192, 192, 192)
                        : (index == 2)
                            ? const Color.fromARGB(205, 127, 50, 50)
                            : null,
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${index + 1}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.sailing,
              size: 40.0,
              color: team.id.toSeededColor(),
              shadows: const [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
                ),
              ],
            ),
          ]),
      title: Text(team.name),
      subtitle: Text('Punkty: $score'),
    );
  }
}
