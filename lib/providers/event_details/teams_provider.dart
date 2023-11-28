import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'teams_provider.g.dart';

@riverpod
FutureOr<List<Team>> teams(TeamsRef ref, String eventId) {
  return ref.watch(teamRepositoryProvider(eventId)).getTeams();
}
