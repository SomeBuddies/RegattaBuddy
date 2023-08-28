import 'package:flutter/material.dart';
import 'package:regatta_buddy/widgets/app_header.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static const String route = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppHeader(),
      body: Text('Search Page'),
    );
  }
}
