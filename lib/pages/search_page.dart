import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/enums/sort_enums.dart';
import 'package:regatta_buddy/providers/search/search_providers.dart';
import 'package:regatta_buddy/widgets/core/app_header.dart';
import 'package:regatta_buddy/widgets/search/search_item.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});
  static const String route = '/search';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUserView = (ModalRoute.of(context)!.settings.arguments
        as Map<String, bool>)['isUserView'];
    final searchQuery = useState('');
    final controller = useTextEditingController();

    final eventsAsync = ref.watch(
      eventListProvider(query: searchQuery.value, isUserView: isUserView),
    );

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
                    decoration: const InputDecoration(hintText: "Szukaj"),
                    autocorrect: false,
                    onSubmitted: (value) =>
                        searchQuery.value = value.toLowerCase(),
                  ),
                ),
                Switch(
                  value: ref.watch(showPastEventsProvider),
                  onChanged: (value) async {
                    ref.read(showPastEventsProvider.notifier).set(value);
                    await Future.delayed(const Duration(milliseconds: 50));
                    if (ref.read(currentSortTypeProvider) == SortType.date) {
                      ref.read(currentSortOrderProvider.notifier).set(
                          value ? SortOrder.descending : SortOrder.ascending);
                    }
                  },
                ),
                const Text("Pokaż zakończone"),
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
                      .map((e) => DropdownMenuEntry(
                            value: e,
                            label: e.displayName,
                          ))
                      .toList(),
                  onSelected: (value) =>
                      ref.read(currentSortTypeProvider.notifier).set(value!),
                  initialSelection: ref.watch(currentSortTypeProvider),
                  label: const Text("Sortuj według"),
                ),
                DropdownMenu(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: null,
                    isDense: true,
                  ),
                  dropdownMenuEntries: SortOrder.values
                      .map((e) => DropdownMenuEntry(
                            value: e,
                            label: e.displayName,
                          ))
                      .toList(),
                  onSelected: (value) =>
                      ref.read(currentSortOrderProvider.notifier).set(value!),
                  initialSelection: ref.watch(currentSortOrderProvider),
                  label: const Text("Kolejność"),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
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
            ),
          ],
        ),
      ),
    );
  }
}
