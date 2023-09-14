import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:regatta_buddy/models/event.dart';

import 'package:regatta_buddy/pages/event_creation/event_form.dart';
import 'package:regatta_buddy/pages/event_creation/event_route.dart';
import 'package:regatta_buddy/pages/event_creation/event_social.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/models/complex_marker.dart';

class EventCreationPage extends StatefulWidget {
  static const String route = '/eventCreation';

  const EventCreationPage({super.key});

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<ComplexMarker> markers = [];

  String? eventName;
  String? eventDescription;
  DateTime? eventDate;

  int step = 0;
  late final List pages;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pages = [
      () => EventFormSubPage(_formKey, changeName, changeDescription, changeDate),
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

  void finishEventCreation() {
    Event event = Event(
      hostId: "TEMP VALUE CHANGE LATER",
      route: markers.map((e) => e.marker.point).toList(),
      location: markers[0].marker.point,
      date: eventDate!,
      name: eventName!,
      description: eventDescription!,
    );

    firestore.collection('events').add(event.toJson());

    Navigator.pushReplacementNamed(context, HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text('Event creation'),
            Flexible(
              child: pages[step](),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, HomePage.route),
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
    );
  }
}
