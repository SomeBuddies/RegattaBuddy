import 'package:flutter/material.dart';
import 'package:regatta_buddy/pages/home.dart';
import 'package:regatta_buddy/pages/route_creator.dart';

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
      },
    );
  }
}
