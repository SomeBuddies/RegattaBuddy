import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regatta_buddy/firebase_options.dart';
import 'package:regatta_buddy/pages/event_creation/event_creation.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/pages/login_page.dart';
import 'package:regatta_buddy/pages/profile_page.dart';
import 'package:regatta_buddy/pages/race/race_page.dart';
import 'package:regatta_buddy/pages/regatta_details.dart';
import 'package:regatta_buddy/pages/register_page.dart';
import 'package:regatta_buddy/pages/search.dart';
import 'package:regatta_buddy/pages/user_regattas.dart';
import 'package:regatta_buddy/providers/user_provider.dart';
import 'package:regatta_buddy/services/authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AuthenticationService authenticationService = AuthenticationService();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => authenticationService),
        ChangeNotifierProvider(create: (context) => UserProvider(authenticationService)),
      ],
      child: const RegattaBuddy(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RegattaBuddy extends StatelessWidget {
  const RegattaBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RegattaBuddy',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        RegattaDetailsPage.route: (context) => const RegattaDetailsPage(),
        UserRegattasPage.route: (context) => const UserRegattasPage(),
        SearchPage.route: (context) => const SearchPage(),
        EventCreationPage.route: (context) => const EventCreationPage(),
        RacePage.route: (context) => const RacePage(),
        LoginPage.route: (context) => LoginPage(),
        RegisterPage.route: (context) => const RegisterPage(),
        ProfilePage.route: (context) => const ProfilePage(),
      },
    );
  }
}
