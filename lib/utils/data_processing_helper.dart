import 'package:regatta_buddy/models/team.dart';

import 'logging/logger_helper.dart';

// processes event scores data and returns sorted total score for each team in map. Key is teamId, value is total score
Map<String, int> processScoresData(Map<String, List<int>> scores, List<Team> teams) {
  final logger = getLogger("DataProcessingHelper");
  final Map<String, int> teamScores = {};
  try {

    var teamsIds = teams.map((team) => team.id).toList();

    scores.keys.where((teamId) => teamsIds.contains(teamId)).forEach((teamId) {
      final score = scores[teamId] as List<int>;
      final totalScore = score.reduce((value, element) => value + element);
      teamScores[teamId] = totalScore;
    });
  } catch (e) {
    logger.e("Error when processing scores: $e");
  }

  final sortedScores = Map.fromEntries(
      teamScores.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));

  return sortedScores;
}
