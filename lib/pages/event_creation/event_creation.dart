import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/extensions/datetime_extension.dart';
import 'package:regatta_buddy/models/event.dart';

import 'package:regatta_buddy/pages/event_creation/event_form.dart';
import 'package:regatta_buddy/pages/event_creation/event_route.dart';
import 'package:regatta_buddy/pages/event_creation/event_social.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';
import 'package:regatta_buddy/providers/user_provider.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/models/complex_marker.dart';

class EventCreationPage extends ConsumerStatefulWidget {
  final logger = getLogger('EventCreationPage');

  static const String route = '/eventCreation';

  EventCreationPage({super.key});

  @override
  ConsumerState<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends ConsumerState<EventCreationPage> {
  final List<ComplexMarker> markers = [];

  String? eventName;
  String? eventDescription;
  DateTime? eventDate;
  TimeOfDay? eventTime;

  int step = 0;
  late final List pages;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pages = [
      () => EventFormSubPage(
          _formKey, changeName, changeDescription, changeDate, changeTime),
      () => EventRouteSubPage(markers, addMarker, deleteMarker),
      () => const EventSocialSubPage(),
    ];
  }

  void changeName(String newName) {
    setState(() {
      eventName = newName;
    });
  }

  void changeDescription(String newDescription) {
    setState(() {
      eventDescription = newDescription;
    });
  }

  void changeDate(DateTime newDate) {
    setState(() {
      eventDate = newDate;
    });
  }

  void changeTime(TimeOfDay newTime) {
    setState(() {
      eventTime = newTime;
    });
  }

  void addMarker(ComplexMarker marker) {
    markers.add(marker);
    setState(() {});
  }

  void deleteMarker(ComplexMarker marker) {
    markers.remove(marker);
    setState(() {});
  }

  void nextStep() {
    if (step == 0 && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    if (step < pages.length - 1) {
      step += 1;
      setState(() {});
    }
  }

  void previousStep() {
    if (step > 0) {
      step -= 1;
      setState(() {});
    }
  }

  void finishEventCreation() async {
    ref.read(currentUserDataProvider).whenOrNull(
          data: (data) {
            Event event = Event(
              hostId: data.uid,
              route: markers.map((e) => e.marker.point).toList(),
              location: markers[0].marker.point,
              date: eventDate!.withTimeOfDay(eventTime!).toUtc(),
              name: eventName!,
              description: eventDescription!,
            );
            widget.logger.i(
              "Event creation finished, saving following event to firebase: ${event.toJson()}",
            );

            ref.read(eventRepositoryProvider).addEvent(event);

            Navigator.pushReplacementNamed(context, HomePage.route);
          },
          error: (error, stackTrace) => throw error as Exception,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const AppHeader(),
      //==Remove this part to return to how it was before==
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Builder(
          //This bit is weird because you can't call Scaffold.of() inside the scaffold
          //so you need a builder to do it in a callback.
          builder: (context) => ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  Scaffold.of(context).appBarMaxHeight!.toInt(),
            ),
            // =============================================
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Event creation'),
                  Expanded(
                    child: pages[step](),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context)
                            .popUntil(ModalRoute.withName(HomePage.route)),
                        child: const Text("Cancel"),
                      ),
                      Row(
                        children: [
                          if (step > 0)
                            TextButton(
                              onPressed: previousStep,
                              child: const Text("Previous"),
                            ),
                          if (step < pages.length - 1)
                            TextButton(
                              onPressed: nextStep,
                              child: const Text("Next"),
                            )
                          else
                            TextButton(
                              onPressed: finishEventCreation,
                              child: const Text("Finish"),
                            ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
