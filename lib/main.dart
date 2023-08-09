import 'package:flutter/material.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/pages/race/race_page.dart';
import 'package:regatta_buddy/pages/regatta_details.dart';
import 'package:regatta_buddy/pages/route_creator.dart';
import 'package:regatta_buddy/pages/search.dart';
import 'package:regatta_buddy/pages/user_regattas.dart';

void main() => runApp(const RegattaBuddy());

class RegattaBuddy extends StatelessWidget {
  const RegattaBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RegattaBuddy',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        RouteCreatorPage.route: (context) => const RouteCreatorPage(),
        RegattaDetailsPage.route: (context) => const RegattaDetailsPage(),
        UserRegattasPage.route: (context) => const UserRegattasPage(),
        SearchPage.route: (context) => const SearchPage(),
        RacePage.route: (context) => const RacePage(),
      },
    );
  }
}
