import 'package:flutter/material.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/event_details_display.dart';
import 'package:regatta_buddy/widgets/event_teams_display.dart';

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
            EventDetailsDisplay(event),
            EventTeamsDisplay(event),
          ],
        ),
      ),
    );
  }
}
