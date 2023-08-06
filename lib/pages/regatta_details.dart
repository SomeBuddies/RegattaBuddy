import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regatta_buddy/widgets/app_header.dart';

class RegattaDetailsPage extends StatefulWidget {
  const RegattaDetailsPage({super.key});
  static const String route = '/regattaDetails';

  @override
  State<RegattaDetailsPage> createState() => _RegattaDetailsPageState();
}

class _RegattaDetailsPageState extends State<RegattaDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppHeader(),
      body: Text('Regatta Details Page'),
    );
  }
}