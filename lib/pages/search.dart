import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:regatta_buddy/extensions/string_extension.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/search_item.dart';

enum SortType {
  name,
  date,
  //location,
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static const String route = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  SortType sortType = SortType.name;
  bool sortAscending = true;
  bool showPastEvents = false;

  late Future<QuerySnapshot<Map<String, dynamic>>> firestoreQuery;
  late TextEditingController controller;

  Future<QuerySnapshot<Map<String, dynamic>>> getFirestoreCollection() {
    return FirebaseFirestore.instance
        .collection('events')
        .where(
          "date",
          isGreaterThan: showPastEvents ? null : DateTime.timestamp().millisecondsSinceEpoch,
        )
        .get();
  }

  List<Event> filterResults(List<Event> events) {
    return events
        .where(
          (element) =>
              element.name.toLowerCase().contains(searchQuery) ||
              element.description.toLowerCase().contains(searchQuery),
        )
        .toList()
      ..sort((a, b) {
        int result = 0;
        switch (sortType) {
          case SortType.name:
            result = a.name.compareTo(b.name);
            break;
          case SortType.date:
            result = a.date.compareTo(b.date);
            break;
          // case SortType.location:
          //   result = 0; //dodam kiedyś
        }
        return sortAscending ? result : -result;
      });
  }

  @override
  void initState() {
    controller = TextEditingController();
    firestoreQuery = getFirestoreCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: "Search"),
                    autocorrect: false,
                    onSubmitted: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                Switch(
                  value: showPastEvents,
                  onChanged: (value) {
                    setState(() {
                      showPastEvents = value;
                      firestoreQuery = getFirestoreCollection();
                    });
                  },
                ),
                const Text("Past Events"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownMenu(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: null,
                    isDense: true,
                  ),
                  dropdownMenuEntries: SortType.values
                      .map((e) => DropdownMenuEntry(value: e, label: e.name.toCapitalized()))
                      .toList(),
                  onSelected: (value) {
                    setState(() {
                      sortType = value ?? sortType;
                    });
                  },
                  initialSelection: sortType,
                  label: const Text("Sort by"),
                ),
                DropdownMenu(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: null,
                    isDense: true,
                  ),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: true, label: "Ascending"),
                    DropdownMenuEntry(value: false, label: "Descending"),
                  ],
                  onSelected: (value) {
                    setState(() {
                      sortAscending = value ?? sortAscending;
                    });
                  },
                  initialSelection: sortAscending,
                  label: const Text("Order by"),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: firestoreQuery,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<Event> events = filterResults(
                      snapshot.data!.docs.map((doc) => Event.fromMap(doc.data())).toList(),
                    );
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return SearchItem(events[index]);
                      },
                      itemCount: events.length,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
