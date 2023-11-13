import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/firebase_options.dart';
import 'package:regatta_buddy/pages/race/moderator/race_moderator_page.dart';
import 'package:regatta_buddy/pages/event_creation/event_creation.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/pages/login_page.dart';
import 'package:regatta_buddy/pages/profile_page.dart';
import 'package:regatta_buddy/pages/race/participant/race_page.dart';
import 'package:regatta_buddy/pages/regatta_details.dart';
import 'package:regatta_buddy/pages/register_page.dart';
import 'package:regatta_buddy/pages/search_page.dart';
import 'package:regatta_buddy/pages/user_regattas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  runApp(
    const ProviderScope(
      child: RegattaBuddy(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RegattaBuddy extends ConsumerWidget {
  const RegattaBuddy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'RegattaBuddy',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        RegattaDetailsPage.route: (context) => const RegattaDetailsPage(),
        UserRegattasPage.route: (context) => const UserRegattasPage(),
        SearchPage.route: (context) => const SearchPage(),
        EventCreationPage.route: (context) => EventCreationPage(),
        RacePage.route: (context) => RacePage(),
        LoginPage.route: (context) => LoginPage(),
        RegisterPage.route: (context) => const RegisterPage(),
        ProfilePage.route: (context) => const ProfilePage(),
        RaceModeratorPage.route: (context) => RaceModeratorPage()
      },
    );
  }
}
