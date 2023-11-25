import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/pages/regatta_details.dart';
import 'package:regatta_buddy/widgets/core/icon_with_text.dart';
import 'package:regatta_buddy/widgets/core/route_preview_map.dart';

class SearchItem extends StatelessWidget {
  final Event event;

  const SearchItem(
    this.event, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              event.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FutureBuilder(
                              future: placemarkFromCoordinates(
                                event.location.latitude,
                                event.location.longitude,
                              ),
                              builder: (context, snapshot) => (snapshot
                                          .connectionState ==
                                      ConnectionState.waiting)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : IconWithText(
                                      icon: const Icon(Icons.pin_drop),
                                      label: snapshot.data?.first.locality ??
                                          event.location.toString(),
                                    ),
                            )
                          ],
                        ),
                        Text(event.description),
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
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconWithText(
                              icon: const Icon(Icons.access_time),
                              label: DateFormat("HH:mm").format(event.date),
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