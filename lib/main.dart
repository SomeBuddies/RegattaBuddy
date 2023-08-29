import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:regatta_buddy/firebase_options.dart';
import 'package:regatta_buddy/pages/event_creation/event_creation.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/pages/race/race_page.dart';
import 'package:regatta_buddy/pages/regatta_details.dart';
import 'package:regatta_buddy/pages/search.dart';
import 'package:regatta_buddy/pages/user_regattas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RegattaBuddy());
}

class RegattaBuddy extends StatelessWidget {
  const RegattaBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RegattaBuddy',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        RegattaDetailsPage.route: (context) => const RegattaDetailsPage(),
        UserRegattasPage.route: (context) => const UserRegattasPage(),
        SearchPage.route: (context) => const SearchPage(),
        EventCreationPage.route: (context) => const EventCreationPage(),
        RacePage.route: (context) => const RacePage(),
      },
    );
  }
}
