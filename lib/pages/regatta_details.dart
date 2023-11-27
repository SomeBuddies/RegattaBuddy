import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/providers/event_details/event_provider.dart';
import 'package:regatta_buddy/providers/event_details/teams_provider.dart';
import 'package:regatta_buddy/widgets/core/app_header.dart';
import 'package:regatta_buddy/widgets/event_details/event_details_display.dart';
import 'package:regatta_buddy/widgets/event_details/event_score_display.dart';
import 'package:regatta_buddy/widgets/event_details/event_teams_display.dart';
import 'package:regatta_buddy/widgets/event_details/go_to_event_button.dart';

class RegattaDetailsPage extends ConsumerWidget {
  static const String route = '/regattaDetails';

  const RegattaDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventId = ModalRoute.of(context)!.settings.arguments as String;
    final asyncEvent = ref.watch(eventProvider(eventId));

    return Scaffold(
      appBar: const AppHeader(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(eventProvider(eventId));
          final event = await ref.read(eventProvider(eventId).future);
          ref.invalidate(teamsProvider(event));
        },
        child: switch (asyncEvent) {
          AsyncData(value: final event) => _RegataDetailsPage(event: event),
          AsyncLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          _ => const Center(
              child: Text(
                  "Podczas ładowania wydarzenia wystąpił nieoczekiwany problem"),
            ),
        },
      ),
    );
  }
}

class _RegataDetailsPage extends StatelessWidget {
  final Event event;

  const _RegataDetailsPage({
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          EventDetailsDisplay(event),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GoToEventButton(event),
          ),
          switch (event.status) {
            EventStatus.finished => EventScoreDisplay(event),
            _ => EventTeamsDisplay(event),
          }
        ],
      ),
    );
  }
}
