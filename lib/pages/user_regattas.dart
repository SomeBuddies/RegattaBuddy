import 'package:flutter/material.dart';
import 'package:regatta_buddy/pages/race/moderator/race_moderator_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page_arguments.dart';
import 'package:regatta_buddy/utils/form_utils.dart';
import 'package:regatta_buddy/widgets/app_header.dart';

class UserRegattasPage extends StatefulWidget {
  const UserRegattasPage({super.key});

  static const String route = '/userRegattas';

  @override
  State<UserRegattasPage> createState() => _UserRegattasPageState();
}

class _UserRegattasPageState extends State<UserRegattasPage> {
  final eventIdController = TextEditingController(text: "uniqueEventID");
  final teamController = TextEditingController(text: "teamX");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    eventIdController.dispose();
    teamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => Navigator.pushNamed(
              context,
              RacePage.route,
              arguments: RacePageArguments(
                  eventIdController.text, teamController.text),
            ),
            child: const Text('Race participant page'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, RaceModeratorPage.route),
            child: const Text('Race moderator page'),
          ),
        ],
      )),
    );
  }
}
