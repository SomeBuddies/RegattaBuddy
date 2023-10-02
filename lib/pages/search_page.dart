import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regatta_buddy/enums/sort_enums.dart';
import 'package:regatta_buddy/extensions/string_extension.dart';
import 'package:regatta_buddy/providers/search_providers.dart';
import 'package:regatta_buddy/widgets/app_header.dart';
import 'package:regatta_buddy/widgets/search_item.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});
  static const String route = '/search';

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String searchQuery = '';

  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventListProvider(query: searchQuery));

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
                  value: ref.watch(showPastEventsProvider),
                  onChanged: (value) => ref.read(showPastEventsProvider.notifier).set(value),
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
                  onSelected: (value) => ref.read(currentSortTypeProvider.notifier).set(value!),
                  initialSelection: ref.watch(currentSortTypeProvider),
                  label: const Text("Sort by"),
                ),
                DropdownMenu(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: null,
                    isDense: true,
                  ),
                  dropdownMenuEntries: SortOrder.values
                      .map((e) => DropdownMenuEntry(value: e, label: e.name.toCapitalized()))
                      .toList(),
                  onSelected: (value) => ref.read(currentSortOrderProvider.notifier).set(value!),
                  initialSelection: ref.watch(currentSortOrderProvider),
                  label: const Text("Order by"),
                ),
              ],
            ),
            Expanded(
              child: eventsAsync.when(
                data: (data) => ListView.builder(
                  itemBuilder: (context, index) => SearchItem(data[index]),
                  itemCount: data.length,
                ),
                error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}