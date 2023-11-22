import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/providers/event_details/placemark_provider.dart';
import 'package:regatta_buddy/widgets/core/basic_card.dart';
import 'package:regatta_buddy/widgets/core/icon_with_text.dart';
import 'package:regatta_buddy/widgets/core/route_preview_map.dart';

class EventDetailsDisplay extends ConsumerWidget {
  final Event event;

  const EventDetailsDisplay(
    this.event, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placemark = ref.watch(placemarkProvider(event.location));

    return BasicCard(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: RoutePreviewMap(event.route),
          ),
          const SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                event.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                event.description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconWithText(
                icon: const Icon(Icons.calendar_month),
                label: DateFormat("dd.MM.yyyy").format(event.date),
              ),
              IconWithText(
                icon: const Icon(Icons.access_time),
                label: DateFormat("HH:mm").format(event.date),
              ),
              placemark.when(
                data: (data) => IconWithText(
                  icon: const Icon(Icons.pin_drop),
                  label: data.first.locality ?? event.location.toString(),
                ),
                error: (error, stackTrace) => Text(event.location.toString()),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
