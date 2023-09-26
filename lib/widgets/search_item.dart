import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/pages/admin/race_moderator_page.dart';
import 'package:regatta_buddy/widgets/icon_with_text.dart';

class SearchItem extends StatelessWidget {
  final Event event;

  const SearchItem(
    this.event, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: Colors.lightBlue,
                  child: const Center(
                    child: Text("Nw może tu dać podgląd trasy?"),
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
                            builder: (context, snapshot) =>
                                (snapshot.connectionState == ConnectionState.waiting)
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : IconWithText(
                                        icon: const Icon(Icons.pin_drop),
                                        label: snapshot.data!.first.locality ??
                                            event.location.toString(),
                                      ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(event.description),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconWithText(
                            icon: const Icon(Icons.calendar_month),
                            label: DateFormat("dd.MM.yyyy").format(event.date),
                          ),
                          IconWithText(
                            icon: const Icon(Icons.access_time),
                            label: DateFormat("HH:mm").format(event.date),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("Join"),
                          )
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
    );
  }
}
