import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:regatta_buddy/firebase_options.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:provider/provider.dart';
import 'package:regatta_buddy/pages/event_creation/event_creation.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/pages/login_page.dart';
import 'package:regatta_buddy/pages/profile_page.dart';
import 'package:regatta_buddy/pages/race/race_page.dart';
import 'package:regatta_buddy/pages/regatta_details.dart';
import 'package:regatta_buddy/pages/search.dart';
import 'package:regatta_buddy/pages/user_regattas.dart';
import 'package:regatta_buddy/providers/user_provider.dart';
import 'package:regatta_buddy/services/authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put<AuthenticationService>(AuthenticationService(), permanent: true);
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const RegattaBuddy(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RegattaBuddy extends StatelessWidget {
  const RegattaBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
        LoginPage.route: (context) => const LoginPage(),
        ProfilePage.route: (context) => const ProfilePage(),
      },
    );
  }
}
