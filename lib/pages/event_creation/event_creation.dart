import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:regatta_buddy/pages/event_creation/event_form.dart';
import 'package:regatta_buddy/pages/event_creation/event_route.dart';
import 'package:regatta_buddy/pages/event_creation/event_social.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/complex_marker.dart';
import 'package:uuid/uuid.dart';

class EventCreationPage extends StatefulWidget {
  static const String route = '/event_creation';

  const EventCreationPage({super.key});

  @override
  State<EventCreationPage> createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  DatabaseReference databaseReference = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              " https://regattabuddy-default-rtdb.europe-west1.firebasedatabase.app")
      .ref('/events');
  final List<ComplexMarker> markers = [];
  final String eventId = const Uuid().v4();
  String eventName = '';
  String eventDescription = '';

  int step = 0;
  late final List pages;

  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pages = [
      () => EventFormSubPage(
          _formKey, eventName, eventDescription, changeName, changeDescription),
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

  void addMarker(ComplexMarker marker) {
    markers.add(marker);
    setState(() {});
  }

  void deleteMarker(ComplexMarker marker) {
    markers.remove(marker);
    setState(() {});
  }

  void nextStep() {
    if (step == 0 && !_formKey.currentState!.validate()) return;
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
    databaseReference.update(toJson());
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
                  TextButton(onPressed: () {}, child: const Text("Cancel")),
                  Row(
                    children: [
                      if (step > 0)
                        TextButton(
                            onPressed: previousStep,
                            child: const Text("Previous")),
                      if (step < pages.length - 1)
                        TextButton(
                            onPressed: nextStep, child: const Text("Next"))
                      else
                        TextButton(
                            onPressed: finishEventCreation,
                            child: const Text("Finish")),
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }

  Map<String, dynamic> toJson() => {
        eventId: {
          'name': eventName,
          'description': eventDescription,
          'route': markers.map((e) => e.marker.point.toJson()).toList()
        }
      };
}
