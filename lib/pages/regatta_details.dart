import 'package:flutter/material.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/event_details_item.dart';

class RegattaDetailsPage extends StatefulWidget {
  const RegattaDetailsPage({super.key});
  static const String route = '/regattaDetails';

  @override
  State<RegattaDetailsPage> createState() => _RegattaDetailsPageState();
}

class _RegattaDetailsPageState extends State<RegattaDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Event;

    return Scaffold(
      appBar: const AppHeader(),
      body: Column(
        children: [
          EventDetailsItem(args),
        ],
      ),
    );
  }
}

class RegattaDetailsArguments {
  final Event event;

  RegattaDetailsArguments(this.event);
}
