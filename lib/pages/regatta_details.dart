import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/event_details_display.dart';
import 'package:regatta_buddy/widgets/event_score_display.dart';
import 'package:regatta_buddy/widgets/event_teams_display.dart';

import 'package:regatta_buddy/widgets/go_to_event_button.dart';

class RegattaDetailsPage extends ConsumerWidget {
  const RegattaDetailsPage({super.key});

  static const String route = '/regattaDetails';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ModalRoute.of(context)!.settings.arguments as Event;

    return Scaffold(
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GoToEventButton(event),
            EventDetailsDisplay(event),
            switch (event.status) {
              EventStatus.finished => EventScoreDisplay(event),
              _ => EventTeamsDisplay(event),
            }
          ],
        ),
      ),
    );
  }
}
