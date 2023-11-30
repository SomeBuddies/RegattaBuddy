import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:regatta_buddy/extensions/string_extension.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/pages/regatta_details.dart';
import 'package:regatta_buddy/providers/event_details/placemark_provider.dart';
import 'package:regatta_buddy/widgets/core/icon_with_text.dart';
import 'package:regatta_buddy/widgets/core/route_preview_map.dart';

class SearchItem extends ConsumerWidget {
  final Event event;

  const SearchItem(
    this.event, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placemark = ref.watch(placemarkProvider(event.location));

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        RegattaDetailsPage.route,
        arguments: event.id,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: RoutePreviewMap(
                      event.route,
                      smallMode: true,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  flex: 3,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  event.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              switch (placemark) {
                                AsyncData(:final value) => IconWithText(
                                    icon: const Icon(Icons.pin_drop),
                                    label: value.first.locality ??
                                        event.location.toSexagesimal(),
                                  ),
                                AsyncLoading() => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                _ => const SizedBox.shrink(),
                              },
                            ],
                          ),
                        ),
                        Text(event.description.toShortened()),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconWithText(
                              icon: const Icon(Icons.calendar_month),
                              label:
                                  DateFormat("dd.MM.yyyy").format(event.date),
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            IconWithText(
                              icon: const Icon(Icons.access_time),
                              label: DateFormat("HH:mm").format(event.date),
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            if (event.status != EventStatus.notStarted)
                              IconWithText(
                                icon: const Icon(Icons.emoji_flags),
                                label: event.status.displayName,
                                style: const TextStyle(fontSize: 13),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
