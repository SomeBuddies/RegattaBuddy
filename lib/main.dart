import 'package:flutter/material.dart';
import 'package:regatta_buddy/pages/main_page.dart';

void main() => runApp(const RegattaBuddy());

class RegattaBuddy extends StatelessWidget {
  const RegattaBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RegattaBuddy',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MainPage(),
      },
    );
  }
}
