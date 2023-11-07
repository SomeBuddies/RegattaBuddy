import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/pages/race/moderator/race_moderator_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';
import 'package:regatta_buddy/providers/firebase_writer_service_provider.dart';
import 'package:regatta_buddy/utils/form_utils.dart';
import 'package:regatta_buddy/widgets/app_header.dart';

class UserRegattasPage extends HookConsumerWidget {
  const UserRegattasPage({super.key});

  static const String route = '/userRegattas';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventIdController = useTextEditingController(text: "uniqueEventID");
    final teamController = useTextEditingController(text: "teamX");

    final dbRef = ref.watch(firebaseWriterServiceProvider);

    return Scaffold(
      appBar: const AppHeader(),
      body: Center(
          child: Column(
        children: [
          RBInputFormField(
            label: "eventId",
            controller: eventIdController,
          ),
          RBInputFormField(
            label: "teamId",
            controller: teamController,
          ),
          ElevatedButton(
            onPressed: () async {
              // TODO move team score initialization to team creation flow
              dbRef.initializeScoreForTeam(
                  eventIdController.text, teamController.text);

                Navigator.pushNamed(context, RacePage.route,
                    arguments: RacePageArguments(eventIdController.text, teamController.text));
            },
            child: const Text('Race participant page'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, RaceModeratorPage.route,
                  arguments: eventIdController.text);
            },
            child: const Text('Race moderator page'),
          ),
        ],
      )),
    );
  }
}
