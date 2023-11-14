import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/providers/user_provider.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/event_details_display.dart';
import 'package:regatta_buddy/widgets/event_teams_display.dart';

import '../models/team.dart';
import '../providers/event_details/teams_provider.dart';

class RegattaDetailsPage extends StatelessWidget {
  const RegattaDetailsPage({super.key});

  static const String route = '/regattaDetails';

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as Event;

    return Scaffold(
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GoToEventButton(event),
            EventDetailsDisplay(event),
            EventTeamsDisplay(event),
          ],
        ),
      ),
    );
  }
}

class GoToEventButton extends ConsumerStatefulWidget {
  const GoToEventButton(this.event, {Key? key}) : super(key: key);
  final Event event;

  @override
  ConsumerState<GoToEventButton> createState() => _GoToEventButtonState();
}

class _GoToEventButtonState extends ConsumerState<GoToEventButton> {
  bool showButton = false;

  Future<void> loadNeededData(Event event) async {
    if (isEventActive(event) && isEventConnectedToUser(event)) {
      setState(() {
        showButton = true;
      });
    }
  }

  bool isEventActive(Event event) {
    DateTime now = DateTime.now();
    return now.isAfter(event.date.subtract(const Duration(hours: 1))) &&
        now.isBefore(event.date.add(const Duration(days: 1)));
  }

  bool isEventConnectedToUser(Event event) {
    final userId = ref
        .read(currentUserDataProvider)
        .whenOrNull(data: (userData) => userData.uid);

    if (event.hostId == userId) return true;

    final List<Team>? teams =
        ref.watch(teamsProvider(event)).whenOrNull(data: (teams) => teams);
    return teams
            ?.filter((team) => team.members
                .map((teamMember) => teamMember.id)
                .contains(userId))
            .isEmpty ??
        false;
  }

  @override
  void initState() {
    loadNeededData(widget.event);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return showButton
        ? ElevatedButton(
            onPressed: () {},
            child: const Text("Enter event"),
          )
        : const SizedBox.shrink();
  }
}
