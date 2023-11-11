import 'logging/logger_helper.dart';

// processes event scores data and returns sorted total score for each team in map. Key is teamId, value is total score
Map<String, int> processScoresData(Map<String, List<int>> scores) {
  final logger = getLogger("DataProcessingHelper");
  final Map<String, int> teamScores = {};
  try {
    scores.forEach((key, value) {
      final teamId = key;
      final scores = value;
      final totalScore = scores.reduce((value, element) => value + element);
      teamScores[teamId] = totalScore;
    });
  } catch (e) {
    logger.e("Error when processing scores: $e");
  }

  final sortedScores = Map.fromEntries(
      teamScores.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));

  return sortedScores;
}
