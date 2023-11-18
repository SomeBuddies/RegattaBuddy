import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/event.dart';
import '../models/team.dart';
import '../pages/race/moderator/race_moderator_page.dart';
import '../pages/race/participant/race_page.dart';
import '../pages/race/participant/race_page_arguments.dart';
import '../providers/event_details/teams_provider.dart';
import '../providers/user_provider.dart';

class GoToEventButton extends ConsumerStatefulWidget {
  const GoToEventButton(this.event, {Key? key}) : super(key: key);
  final Event event;

  @override
  ConsumerState<GoToEventButton> createState() => _GoToEventButtonState();
}

class _GoToEventButtonState extends ConsumerState<GoToEventButton> {
  String? teamId;
  late final Event event;
  String? userId;
  List<Team>? teams;

  void onPressed() {
    teamId == null
        ? Navigator.pushNamed(context, RaceModeratorPage.route,
            arguments: event)
        : Navigator.pushNamed(context, RacePage.route,
            arguments: RacePageArguments(event, teamId!));
  }

  bool shouldShowButton() {
    return isEventActive() && isEventConnectedToUser();
  }

  bool isEventActive() {
    DateTime now = DateTime.now();
    return now.isAfter(event.date.subtract(const Duration(hours: 1))) &&
        now.isBefore(event.date.add(const Duration(days: 1)));
  }

  bool isEventConnectedToUser() {
    if (userId == null) return false;
    if (event.hostId == userId) return true;

    if (teams == null) return false;
    var teamsWithUser = teams!.where((team) =>
        team.members.map((teamMember) => teamMember.id).contains(userId));

    if (teamsWithUser.isNotEmpty) {
      setState(() {
        teamId = teamsWithUser.first.id;
      });
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    userId = ref
        .watch(currentUserDataProvider)
        .whenOrNull(data: (userData) => userData.uid);
    teams = ref.watch(teamsProvider(event)).whenOrNull(data: (teams) => teams);
    return shouldShowButton()
        ? ElevatedButton(
            onPressed: onPressed,
            child: const Text("Enter event"),
          )
        : const SizedBox.shrink();
  }
}
