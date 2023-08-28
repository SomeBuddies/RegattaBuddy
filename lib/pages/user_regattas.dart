import 'package:flutter/material.dart';
import 'package:regatta_buddy/pages/race/race_page.dart';
import 'package:regatta_buddy/widgets/app_header.dart';

class UserRegattasPage extends StatefulWidget {
  const UserRegattasPage({super.key});
  static const String route = '/userRegattas';

  @override
  State<UserRegattasPage> createState() => _UserRegattasPageState();
}

class _UserRegattasPageState extends State<UserRegattasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, RacePage.route),
          child: const Text('Page with regattas that user is participating in'),
        ),
      ),
    );
  }
}
