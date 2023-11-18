import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/models/team.dart';

class RacePageArguments {
  final Event event;
  final Team team;

  const RacePageArguments(this.event, this.team);
}
